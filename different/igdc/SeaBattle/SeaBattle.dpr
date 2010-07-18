program SeaBattle;
uses
  Windows,
  SysUtils,
  WinMain in 'Code\Main\WinMain.pas',
  WinWindow in 'Code\Main\WinWindow.pas',
  Game in 'Code\Game\Game.pas',
  RenderMain in 'Code\Render\RenderMain.pas',
  RenderSettings in 'Code\Render\RenderSettings.pas',
  d3d9 in 'Code\Direct3D\d3d9.pas',
  d3d9x in 'Code\Direct3D\d3d9x.pas',
  d3dtypes in 'Code\Direct3D\d3dtypes.pas',
  RenderTextures in 'Code\Render\RenderTextures.pas',
  Render2D in 'Code\Render\Render2D.pas',
  RenderFont in 'Code\Render\RenderFont.pas',
  RenderUtils in 'Code\Render\RenderUtils.pas',
  SeaBattleMain in 'Code\SeaBattle\SeaBattleMain.pas',
  GuiMain in 'Code\Gui\GuiMain.pas',
  GuiCursor in 'Code\Gui\GuiCursor.pas',
  GuiSplash in 'Code\Gui\GuiSplash.pas',
  GuiWindows in 'Code\Gui\GuiWindows.pas',
  GuiUtils in 'Code\Gui\GuiUtils.pas',
  SeaBattleHighscores in 'Code\SeaBattle\SeaBattleHighscores.pas',
  IO in 'Code\Misc\IO.pas',
  SeaBattleAI in 'Code\SeaBattle\SeaBattleAI.pas';

{$R *.res}
begin
     WinMain.Main();
end.
