#include <windows.h>
#include <iostream>
#include <direct.h>
using namespace std;
#pragma comment (lib, "ws2_32.lib")

const int BUFFER_SIZE = 500 * 1024; // 500Kb Buffer

#define CleanBuffer() memset( Buffer, 0, BUFFER_SIZE )

#define SendError( X ) \
{ \
	sprintf_s( Buffer, BUFFER_SIZE, "%s%s%s%s%s", "<html><head><title>", X, "</title></head><body><center><b><span style=\"font-size:404px;\">", X, "</span></b></center></body></html>" ); \
	send( Socket, Buffer, (int)strlen( Buffer ), 0 );	\
	closesocket( Socket ); \
	return 0; \
}

DWORD WINAPI Request(LPVOID lpParam)
{
	SOCKET Socket = *((SOCKET*)(lpParam));
	CHAR   Buffer[ BUFFER_SIZE ];

	CleanBuffer(); 
	recv( Socket, Buffer, BUFFER_SIZE, 0 );
	cout << Buffer << "\n--------------------------------------------------------------------------------\n";

	CHAR String[ 1024 ]; memset( String, 0, 1024 );

	if ( Buffer[ 0 ] != 'G' || Buffer[ 1 ] != 'E' || Buffer[ 2 ] != 'T' ) SendError( "400" );
	
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
	if ( strstr( String, "\\" ) || String[ 0 ] == '/' ) SendError( "404" );

	CleanBuffer();
	FILE *File;

	if ( fopen_s( &File, String, "rb" ) ) SendError( "404" ) else
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

void Error( char* text )
{
	printf( "%s%s" , "Error: ", text );
	getchar();
	exit( 1 );
}

int main()
{
	_chdir( "D:\\host" );
	printf( "starting httpalivo 0.2\n--------------------------------------------------------------------------------" );

	if ( WSAStartup( MAKEWORD(2,0), &wsaData) ) 
		Error( "WSAStartup" );
	
	if ( ( listenSocket = socket(PF_INET, SOCK_STREAM, 0) ) == INVALID_SOCKET )
		Error( "Failed to create listening socket" );
	
	SOCKADDR_IN Address; memset( &Address, 0, sizeof(SOCKADDR_IN) );
	Address.sin_family      = AF_INET;
	Address.sin_port        = htons( 80 );
	Address.sin_addr.s_addr = inet_addr( "0.0.0.0" );

	if ( bind( listenSocket, (SOCKADDR*)&Address, sizeof(SOCKADDR_IN)))
		Error( "Failed to bind listening socket" );

	if( listen( listenSocket, 10 ) )
		Error( "listen() error" );
	
	SOCKADDR_IN clientAddress;
	SOCKET      clientSocket;
	INT         size = sizeof( SOCKADDR_IN );

	while ( true )
	{
		clientSocket = accept( listenSocket, (SOCKADDR*)&clientAddress, &size );

		if ( clientSocket != INVALID_SOCKET ) CreateThread( NULL, 0, Request, (void*)&clientSocket, 0, NULL );
			else printf( "Warning: accept() failed\n" );
	}

	return 0;
}