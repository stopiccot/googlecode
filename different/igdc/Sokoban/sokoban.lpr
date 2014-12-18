program sokoban;

{$MODE Delphi}

uses
  LCLIntf, LCLType, LMessages,
  SysUtils,
  DXTypes in 'Code\Direct3D\DXTypes.pas',
  RenderMain in 'Code\Render\RenderMain.pas',
  WinMain in 'Code\Win\WinMain.pas',
  WinWindow in 'Code\Win\WinWindow.pas',
  RenderSettings in 'Code\Render\RenderSettings.pas',
  GameMain in 'Code\Game\GameMain.pas',
  RenderTextures in 'Code\Render\RenderTextures.pas',
  RenderEffects in 'Code\Render\RenderEffects.pas',
  Render2D in 'Code\Render\Render2D.pas',
  GuiMain in 'Code\Gui\GuiMain.pas',
  RenderFont in 'Code\Render\RenderFont.pas',
  D3DX9Def in 'Code\Direct3D\D3DX9Def.pas',
  D3DX9Link in 'Code\Direct3D\D3DX9Link.pas',
  RenderPostProcess in 'Code\Render\RenderPostProcess.pas',
  GuiCursor in 'Code\Gui\GuiCursor.pas',
  RenderDeclarations in 'Code\Render\RenderDeclarations.pas',
  GuiSplash in 'Code\Gui\GuiSplash.pas',
  DevelopingDiary in 'Code\DevelopingDiary.pas',
  GuiComments in 'Code\Gui\GuiComments.pas',
  SokobanLevel in 'Code\Sokoban\SokobanLevel.pas',
  Lzma in 'Code\Lzma.pas',
  D3D9 in 'Code\Direct3D\D3D9.pas';

{$R *.res}
// height
begin
     // Если динамическая загрузка d3dx9.dll прошла успешно, запускаем игру.
     // В противном же случае выводим MessageBox, что так и так скачайте dll.
     // Жалко в MessageBox нельзя делать гиперссылки, но от VCL я отказался
     // принципиально - сильно exe'шник "раздувает".
     if D3DX9Link.DynamicallyLinkD3DX9 then
     begin
          ExitCode := WinMain.Main();
     end else
     begin
          MessageBox(HWND(nil),
             'No one version of d3dx9.dll not found.'+#10+
             'Please install the lastest DirectX 9.0 update or'+#10+
             'download this dll from:'+#10+
             'http://gear.velloo.net/d3dx9install.exe',
             '.sokoban',MB_OK);
     end;
end.
