unit WinMain;
interface
uses
  Windows, SysUtils, WinWindow, Game,
  SeaBattleMain, SeaBattleHighscores, GuiMain,
  RenderMain;

  procedure Main;

var
  MainWindow : HWND;

implementation

  procedure Main;
  var
    Msg: TMsg;
  begin
       // Initialize game
       Game.Initialize();

       // Create window
       if FAILED(WinWindow.CreateWindow())then
       begin
            Exit;
       end;

       // Initialize render
       if FAILED(RenderMain.Initialize())then
       begin
            RenderMain.ShutDown();
            Exit;
       end;

       if FAILED(SeaBattleMain.Initialize()) then
       begin
            RenderMain.ShutDown();
            Exit;
       end;

       if FAILED(GuiMain.Initialize()) then
       begin
            RenderMain.ShutDown();
            Exit;
       end;
       
       while not Game.ShutDown do
       begin
            if PeekMessage(Msg, WinWindow.Handle, 0, 0, PM_REMOVE) then
            begin
                 TranslateMessage(Msg);
                 DispatchMessage(Msg);
            end else
            begin
                 if not FAILED(RenderMain.Render()) then
                 begin
                      GuiMain.OnRender;
                 end;
            end;
       end;
       RenderMain.ShutDown();
       SeaBattleHighscores.SaveHighScores;
  end;

end.
