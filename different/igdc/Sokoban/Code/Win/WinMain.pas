unit WinMain;
//==============================================================================
// Unit: WinMain.pas
// Desc: Главный юнит, сообственно сама программа
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, SysUtils, WinWindow,
  GuiMain,
  GameMain,
  RenderMain, Render2D, RenderTextures, RenderEffects, RenderDeclarations,
  RenderPostProcess,
  Lzma;


  function Main: integer;
  
implementation

  procedure UnPackTextures;
  var P: PByte; Size: DWORD; Name: String;
  begin
       ChDir(GameWorkDir+'Data\');
       Lzma.AssignArchive('textures.lzma');
       repeat
            P := Lzma.ExtractToMemory(Size,Name);
            if P = nil then Break;
            if FAILED(RenderTextures.LoadTextureFromMem(Name,Pointer(P),Size)) then Halt;
       until False;
       Lzma.CloseArchive;
  end;

  function Main: integer;
  var Msg: TMsg;
  begin
       Result := 1;

       GameMain.Initialize;
       
       // Создаём окно
       if FAILED(WinWindow.CreateWindow) then Exit;

       // Инициализируем рендер
       if FAILED(RenderMain.Initialize) then Exit;
       if FAILED(RenderDeclarations.Initialize) then Exit;
       if FAILED(RenderPostProcess.Initialize) then Exit;

       UnPackTextures;
       
       GuiMain.Initialize;

       WinWindow.ShowWindow;
       
       while not GameShutDown do
       begin
            if PeekMessage(Msg, WinWindow.Handle, 0, 0, PM_REMOVE) then
            begin
                 TranslateMessage(Msg);
                 DispatchMessage(Msg);
            end else
            begin
                 if SUCCEEDED(RenderMain.Render) then
                 begin
                      GuiMain.Render;
                 end;
            end;
       end;

       RenderMain.Release;
       RenderTextures.Release;

       Result := 0;
  end;
  
end.
