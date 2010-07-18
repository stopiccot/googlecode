!macro INSTALL_DATA

Section "Game"
  SectionIn RO 
  SetOutPath $INSTDIR
  File "/oname=.SeaBattle.exe" "..\SeaBattle.exe"
  File "..\.Readme.html"  

  SetOutPath $INSTDIR\Data\dll
  File "..\Data\dll\DirectX.dll"

  SetOutPath $INSTDIR\Data\textures
  File "..\Data\textures\orbital_1.jpg"
  File "..\Data\textures\orbital_2.jpg"
  File "..\Data\textures\orbital_3.jpg"
  File "..\Data\textures\OrbitalLogo.png"
  File "..\Data\textures\About.tga"
  File "..\Data\textures\Arrow.tga"
  File "..\Data\textures\Cell.tga"
  File "..\Data\textures\CellHover.tga"
  File "..\Data\textures\Cross.tga"
  File "..\Data\textures\Dot.tga"
  File "..\Data\textures\GDCLogo.tga"
  File "..\Data\textures\Hand.tga"
  File "..\Data\textures\Highscores.tga"
  File "..\Data\textures\Newgame.tga"
  File "..\Data\textures\Quit.tga"
  File "..\Data\textures\Ship.tga"
  File "..\Data\textures\ToolWindow.tga"
  
  WriteUninstaller ".Uninstall.exe"
SectionEnd

; Установка исходных кодов
SectionGroup "Source сode"

   ; Исходники самой игры
   Section "Game (BDS required for compilation)"
      SetOutPath $INSTDIR      
      File "..\SeaBattle.dpr"
      File "..\SeaBattle.cfg"
      File "..\SeaBattle.res"
      
      SetOutPath $INSTDIR\Code
      File "..\Code\Readme.txt"      
      
      SetOutPath $INSTDIR\Code\Direct3D
      File "..\Code\Direct3D\d3d9.pas"
      File "..\Code\Direct3D\d3d9x.pas"
      File "..\Code\Direct3D\d3dtypes.pas"
      
      SetOutPath $INSTDIR\Code\Game
      File "..\Code\Game\Game.pas"

      SetOutPath $INSTDIR\Code\Gui
      File "..\Code\Gui\GuiCursor.pas"
      File "..\Code\Gui\GuiMain.pas"
      File "..\Code\Gui\GuiSplash.pas"
      File "..\Code\Gui\GuiUtils.pas"
      File "..\Code\Gui\GuiWindows.pas"

      SetOutPath $INSTDIR\Code\Main
      File "..\Code\Main\WinMain.pas"
      File "..\Code\Main\WinWindow.pas"

      SetOutPath $INSTDIR\Code\Misc
      File "..\Code\Misc\IO.pas"

      SetOutPath $INSTDIR\Code\Render
      File "..\Code\Render\Render2D.pas"     
      File "..\Code\Render\RenderFont.pas"
      File "..\Code\Render\RenderMain.pas"
      File "..\Code\Render\RenderSettings.pas"
      File "..\Code\Render\RenderTextures.pas"
      File "..\Code\Render\RenderUtils.pas"
      
      SetOutPath $INSTDIR\Code\SeaBattle
      File "..\Code\SeaBattle\SeaBattleAI.pas"
      File "..\Code\SeaBattle\SeaBattleMain.pas"
      File "..\Code\SeaBattle\SeaBattleHighscores.pas"
   SectionEnd

   ; Исходники инсталлера
   Section "Installer (NSIS required for compilation)"
      SetOutPath "$INSTDIR\Installer source"
      File "SeaBattleSetup.nsi"
      File "Sections.nsh"
      File "background.bmp"
      File "checks.bmp"
      File "ui.exe"
      File "install.ico"
      File "uninstall.ico"     
      File "Readme.txt"
   SectionEnd

SectionGroupEnd

Section "Football icons (Bonus)"
   SetOutPath "$INSTDIR\Football icons"
   File "..\Football icons\GreenFace.ico"
   File "..\Football icons\BlueFace.ico"
   File "..\Football icons\OrangeFace.ico"
   File "..\Football icons\Readme.txt"
SectionEnd

Section "Uninstall"
   RMDir /r "$INSTDIR\Data"
   RMDir /r "$INSTDIR\Code"
   RMDir /r "$INSTDIR\Installer source"
   Delete $INSTDIR\.Uninstall.exe
   Delete $INSTDIR\.SeaBattle.exe
   Delete $INSTDIR\.Readme.html
   Delete $INSTDIR\SeaBattle.dpr
   Delete $INSTDIR\SeaBattle.cfg
   Delete $INSTDIR\SeaBattle.res
   Delete $INSTDIR\highscores.sbh
   
   IfFileExists "$INSTDIR\Football icons\*.*" 0 +3
   MessageBox MB_YESNO "Uninstall football icons too?" IDNO NoAbort
   RMDir /r "$INSTDIR\Football icons"
   NoAbort:
   MessageBox MB_OK "Uninstall complete."

SectionEnd

!macroend
