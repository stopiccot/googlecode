
#undef UNICODE
#include <windows.h>
#include "resource.h"

const char	EVE_WNDCLASS[]					= "triuiScreen";
const int	WM_TRAYICON						= WM_USER + 1;
const int	IDM_EXIT						= 1;

CHAR			*EVE_PATH;
HWND			hMainWindow, hEVEWindow;
BOOL			OnTop = false;
HICON			Icon1, Icon2;
NOTIFYICONDATA	iconData;
HMENU			hMenu;

LRESULT CALLBACK MainWindowProc( HWND hWnd, UINT uMsg, WPARAM wParam, LPARAM lParam )
{
	switch( uMsg ) 
	{
		case WM_TRAYICON:
		{
			switch ( lParam )
			{
				case WM_LBUTTONUP: 
				{
					break;
				}
				case WM_LBUTTONDBLCLK:
				{
					if ( hEVEWindow = FindWindow( EVE_WNDCLASS, NULL ) )
					{
						RECT Rect; GetWindowRect( hEVEWindow, &Rect );
						SetWindowPos( hEVEWindow, OnTop ? HWND_NOTOPMOST : HWND_TOPMOST, Rect.left, Rect.top, Rect.right - Rect.left, Rect.bottom - Rect.top, SWP_SHOWWINDOW );
						iconData.hIcon = OnTop ? Icon1 : Icon2;
						Shell_NotifyIcon( NIM_MODIFY, &iconData );
						OnTop = !OnTop;
					}
					else
						ShellExecute( NULL, "open", EVE_PATH, NULL, NULL, SW_SHOWNORMAL );
					break;
				}
				case WM_RBUTTONUP:
				{
					hMenu = CreatePopupMenu();
					AppendMenu( hMenu, MF_STRING, IDM_EXIT, TEXT("Exit") ); 
					POINT Point; GetCursorPos( &Point );
					switch( TrackPopupMenu( hMenu, TPM_LEFTALIGN | TPM_TOPALIGN | TPM_RETURNCMD, Point.x, Point.y, 0, hMainWindow, 0 ) )
					{
						case IDM_EXIT:
						{
							PostQuitMessage(0);
							break;
						}
					};
					break;
				}
			}
			break;
		}
	}
	return DefWindowProc( hWnd, uMsg, wParam, lParam );
}

int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPreviuos, LPSTR lpCmdLine, int nCmdShow)
{
	EVE_PATH = lpCmdLine;

	static WNDCLASS wnd;
	wnd.lpfnWndProc		= MainWindowProc;
	wnd.lpszClassName	= "eveontop";

	RegisterClass( &wnd );

	hMainWindow = CreateWindow( "eveontop", "eveontop", 0, 0, 0, 0, 0, 0, 0, 0, 0 );
	
	Icon1 = LoadIcon( hInstance, MAKEINTRESOURCE(IDI_ICON1));
	Icon2 = LoadIcon( hInstance, MAKEINTRESOURCE(IDI_ICON2));

	iconData.cbSize           = sizeof( NOTIFYICONDATA );
	iconData.hIcon            = Icon1;
	iconData.hWnd             = hMainWindow;
	iconData.uCallbackMessage = WM_TRAYICON;
	iconData.uFlags           = NIF_MESSAGE | NIF_ICON;
	iconData.uID              = 1;

	Shell_NotifyIcon( NIM_ADD, &iconData );

	MSG msg;
	while ( GetMessage( &msg, NULL, 0, 0 ) )
	{
		TranslateMessage( &msg ); 
		DispatchMessage( &msg );
	}
	
	Shell_NotifyIcon( NIM_DELETE, &iconData );
	return 0;
}