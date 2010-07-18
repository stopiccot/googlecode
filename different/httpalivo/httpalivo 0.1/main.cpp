#include <windows.h>
#include <iostream>
using namespace std;
#pragma comment (lib, "ws2_32.lib")

const int BUFFER_SIZE = 500 * 1024; // 500Kb Buffer

#define CleanBuffer() memset( Buffer, 0, BUFFER_SIZE )

DWORD WINAPI Request(LPVOID lpParam)
{
	SOCKET Socket = *((SOCKET*)(lpParam));
	CHAR   Buffer[ BUFFER_SIZE ];

	// Print request
	CleanBuffer();
	recv( Socket, Buffer, BUFFER_SIZE, 0 );
	cout << Buffer << "\n--------------------------------------------------------------------------------\n";

	// Get requested filename
	CHAR String[ 1024 ]; memset( String, 0, 1024 );

	if ( Buffer[ 0 ] != 'G' || Buffer[ 1 ] != 'E' || Buffer[ 2 ] != 'T' ) closesocket( Socket );
	
	for ( int i = 5, j = 0; Buffer[ i ] != ' '; j++ )
	{
		if ( Buffer[ i ] == '%' )
		{
			for ( int k = 1; k < 3 ; k++ )
			{
				String[ j ] *= 16;

				if ( Buffer[ i + k ] >= '0' && Buffer[ i + k ] <= '9' )
					String[ j ] += Buffer[ i + k ] - '0';	
				
				else if ( Buffer[ i + k ] >= 'a' && Buffer[ i + k ] <= 'f' )
					String[ j ] += Buffer[ i + k ] - 'a' + 10;
					
				else if ( Buffer[ i + k ] >= 'A' && Buffer[ i + k ] <= 'F' )
					String[ j ] += Buffer[ i + k ] - 'A' + 10;
						
				else
				{
					String[ j ] = '%'; i -= 2;
					break;
				}
			}
			i += 3;
		}
		else String[ j ] = Buffer[ i++ ];
	}
	
	if ( !String[ 0 ] ) sprintf_s( String, 1024, "%s", "index.html" );

	CleanBuffer();
	FILE *File;

	if ( fopen_s( &File, String, "rb" ) )
	{
		sprintf_s( Buffer, BUFFER_SIZE, "%s", "<html><head><title>404</title></head><body><center><b><span style=\"font-size:404px;\">404</span></b></center></body></html>" );
		send( Socket, Buffer, (int)strlen( Buffer ), 0 );
	}
	else
	{
		while ( !feof( File ) )
		{
			CleanBuffer();
			int Readed = (int)fread( Buffer, 1, BUFFER_SIZE, File );

			for ( int Sended = 0; Sended < Readed; )
				Sended += send( Socket, &Buffer[ Sended ], Readed - Sended, 0 );
		}
		fclose( File );
	}

	closesocket( Socket );

	return 0;
}


WSADATA wsaData;
SOCKET  listenSocket;

DWORD WINAPI ListenFunction(LPVOID lpParam)
{
	if( listen( listenSocket, 10 ) )
	{
		cout << "Network error: listen error" << endl;
		return 0;
	}

	SOCKADDR_IN clientAddress;
	SOCKET      clientSocket;
	INT         size = sizeof( SOCKADDR_IN );

	while ( true )
	{
		clientSocket = accept( listenSocket, (SOCKADDR*)&clientAddress, &size );

		if ( clientSocket != INVALID_SOCKET ) CreateThread( NULL, 0, Request, (void*)&clientSocket, 0, NULL );
		else cout << "Warning: accept() failed\n";

	}
	return 0;
}

int main()
{
	cout << "starting httpalivo 0.1\n--------------------------------------------------------------------------------\n";

	if ( WSAStartup( MAKEWORD(2,0), &wsaData) ) 
	{
		cout << "Error: WSAStartup\n" << endl;
		return 0;
	}

	if ( ( listenSocket = socket(PF_INET, SOCK_STREAM, 0) ) == INVALID_SOCKET )
	{
		cout << "Error: Failed to create listening socket" << endl;
		return 0;
	}

	SOCKADDR_IN Address; memset( &Address, 0, sizeof(SOCKADDR_IN) );
	Address.sin_family      = AF_INET;
	Address.sin_port        = htons( 80 );
	Address.sin_addr.s_addr = inet_addr( "10.162.8.181" );


	if ( bind( listenSocket, (SOCKADDR*)&Address, sizeof(SOCKADDR_IN)))
	{
		cout << "Error: Failed to bind listening socket" << endl;
		return 0;
	}

	HANDLE hThread = CreateThread( NULL, 0, ListenFunction, NULL, 0, NULL );
	SetThreadPriority( hThread, -15 );
	WaitForSingleObject( hThread, INFINITE );

	return 0;
}