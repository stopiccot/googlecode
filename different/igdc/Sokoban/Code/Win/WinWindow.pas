// PART OF ORBITAL ENGINE 2.0 SOURCE CODE
unit WinWindow;
//==============================================================================
// Unit: WinWindow.pas
// Desc: Окно на WinAPI
//       ©2006 .gear 
//==============================================================================
interface
uses
  Windows, Messages;

  {$DEFINE ONE_COPY_ONLY} // Запрещает запускать более одной копии программы

const
  ApplicationName    = '.sokoban';
  WindowName         = '.sokoban';
  {$IFDEF ONE_COPY_ONLY}
  AlreadyRunningText = '.sokoban is already running';
  {$ENDIF}

var
  MainWindow       : HWND;
  Handle           : HWND;

  function CreateWindow(): HRESULT;
  procedure ShowWindow();
  
implementation
uses
  SokobanLevel,
  GameMain, GuiMain,
  RenderMain, RenderSettings;
  
var
  Ctrl: Boolean;
//==============================================================================
// Name: WindowProc
// Desc: Процедура обработки сообщений, посланных окну
//==============================================================================
  function WindowProc(Window: HWND; Message: LongWord; wParam: LongInt; lParam: LongInt): LongInt; stdcall;
  begin
       case Message of
         WM_TIMER:
         begin
              GuiMain.Timer;
         end;
         WM_LBUTTONDOWN:
         begin
              GuiMain.WMMouseDown;
         end;
         WM_MOUSEWHEEL:
         begin
              if wParam/Abs(wParam) > 0 then GuiMain.ScrollUp else GuiMain.ScrollDown;
         end;
         WM_CLOSE:
         begin
              GameShutDown := True;
              UnregisterClass(WindowName, hInstance);
         end;
         WM_CHAR:
         begin
         end;
         WM_KEYDOWN:
         begin
              if wParam=17 then Ctrl := True;
              if(Ctrl)and(wParam=90)and(GuiMain.MenuPos=mpGame)then SokobanLevel.Undo;
              SokobanLevel.KeyDown(wParam);
         end;
         WM_KEYUP:
         begin
              if wParam=17 then Ctrl := False;
         end;
       else
       begin
            Result := DefWindowProc(Window, Message, wParam, lParam);
       end;
     end;
  end;

//==============================================================================
// Name: ShowWindow
// Desc: Делает окно видимым
//==============================================================================
  procedure ShowWindow();
  begin
       Windows.ShowWindow(MainWindow, SW_SHOW);
       SetForegroundWindow(MainWindow);
  end;

//==============================================================================
// Name: CreateWindow
// Desc: Создаёт окно
//==============================================================================
  function CreateWindow(): HRESULT;
  var WC: TWndClass;
  begin
       {$IFDEF ONE_COPY_ONLY}
       // Может игра уже запущена?
       if (FindWindow(nil, WindowName)<>0)then
       begin
            // Если уже запущена, то выводим MessageBox
            MessageBox(HWND(nil), AlreadyRunningText, ApplicationName, MB_OK);
            Result := E_FAIL;
            Exit;
       end;
       {$ENDIF}
       // Регистрируем класс
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
       if (RegisterClass(WC)=0)then
       begin
            Result := E_FAIL;
            Exit;
       end;
       // Создаём окно
       MainWindow := CreateWindowEx(WS_EX_APPWINDOW,
                          WindowName,
                          ApplicationName,
                          WS_POPUP,
                          0, 0, 1024, 768,
                          0, 0, hInstance, nil);
       if MainWindow=0 then
       begin
            // Не удалось создать окно
            UnregisterClass(WindowName, hInstance);
            Result := E_FAIL;
            Exit;
       end;
       // Устанавливаем таймер
       SetTimer(MainWindow, 0, Round(13), nil);

       Result := S_OK;
  end;

end.

