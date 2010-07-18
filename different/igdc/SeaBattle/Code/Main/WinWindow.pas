unit WinWindow;
interface
uses
  Windows, Messages, Game;//, log;

const
  ApplicationName  = '.SeaBattle';
  WindowName       = '.SeaBattle';

var
  MainWindow       : HWND;
  Handle           : HWND;

  function CreateWindow(): HRESULT;

implementation
uses
  RenderMain, RenderSettings, GuiMain, SeaBattleMain;

  function WindowProc(Window: HWND; Message: LongWord; wParam: LongInt; lParam: LongInt): LongInt; stdcall;
  begin
       case Message of
         WM_TIMER:
         begin
              GuiMain.WMTimer;
         end;
         WM_LBUTTONDBLCLK:
         begin
         end;
         WM_LBUTTONDOWN:
         begin
              GuiMain.WMMouseDown();
         end;
         WM_LBUTTONUP:
         begin
              GuiMain.WMClick();
         end;
         WM_MOUSEMOVE:
         begin
         end;
         WM_QUIT:
         begin
              Game.ShutDown := True;
         end;
         WM_CLOSE:
         begin
              Game.ShutDown := True;
              UnregisterClass(WindowName, hInstance);
         end;
         WM_CHAR:
         begin
             GuiMain.WMChar(wParam);
         end;
         WM_KEYDOWN:
         begin
              GuiMain.WMKeyDown(wParam);
         end;
       else Result := DefWindowProc( Window, Message, wParam, lParam );
     end;
  end;
  
  function CreateWindow(): HRESULT;
  var
    WC: TWndClass;
  begin
       // Check if application is already running
       if (FindWindow(nil,WindowName)<>0)then
       begin
            Result := E_FAIL;
            Exit;
       end;
       // SetUp WindowClass
       WC.hInstance     := hInstance;
       WC.lpszClassName := WindowName;
       WC.lpfnWndProc   := @WindowProc;
       WC.style         := CS_DBLCLKS;
       WC.hIcon         := LoadIcon(0, IDC_ICON);
       WC.hCursor       := LoadCursor(0, IDC_ARROW);
       WC.lpszMenuName  := nil;
       WC.cbClsExtra    := 0;
       WC.cbWndExtra    := 0;
       WC.hbrBackground := COLOR_BACKGROUND;
       // RegisterClass
       if (RegisterClass(WC)=0)then
       begin
            Result := E_FAIL;
            Exit;
       end;
       // CreateWindow
       MainWindow := CreateWindowEx(WS_EX_APPWINDOW,
                                    WindowName,
                                    ApplicationName,
                                    WS_POPUP,
                                    0, 0, 1024, 768,
                                    0, 0, hInstance, nil);
       if MainWindow=0 then
       begin
            UnregisterClass(WindowName, hInstance);
            Result := E_FAIL;
            Exit;
       end;
       ShowWindow(MainWindow, SW_SHOW);
       SetForegroundWindow(MainWindow);
       //SetFocus(MainWindow);
       SetTimer(MainWindow, 0, Round(25), nil);
       Result := S_OK;
  end;

end.
