!macro INSTALL_DATA

Section "Game"
  SectionIn RO 
  SetOutPath $INSTDIR
  File "/oname=.sokoban.exe" "..\sokoban.exe"
  File "..\Readme.txt"

  SetOutPath $INSTDIR\Data
  File "..\Data\textures.lzma"
  
  SetOutPath $INSTDIR\Data\Effects
  File "..\Data\effects\2d.fx"
  
  SetOutPath $INSTDIR\Data\Levels
  File "..\Data\levels\Readme.txt"
  File "..\Data\levels\diff.lvl"
  File "..\Data\levels\diff2.lvl"
  File "..\Data\levels\Easy.lvl"
  File "..\Data\levels\gigant.lvl"
  File "..\Data\levels\level0.lvl"
  File "..\Data\levels\level1.lvl"
  File "..\Data\levels\level2.lvl"
  File "..\Data\levels\level3.lvl"
  File "..\Data\levels\level4.lvl"
  File "..\Data\levels\onemore.lvl"
  File "..\Data\levels\seems.lvl"
  File "..\Data\levels\simple0.lvl"
  File "..\Data\levels\simple1.lvl"
  File "..\Data\levels\simple2.lvl"
  File "..\Data\levels\small.lvl"
  File "..\Data\levels\small2.lvl"
  File "..\Data\levels\tutorial.lvl"

  WriteUninstaller ".uninstall.exe"
SectionEnd

; Установка исходных кодов
SectionGroup "Source сode"

   ; Исходники самой игры
   Section "Game (BDS required for compilation)"
      SetOutPath $INSTDIR
      File "..\sokoban.dpr"
      File "..\sokoban.cfg"
      File "..\sokoban.res"

      SetOutPath $INSTDIR\Code
      File "..\Code\Readme.txt"
      File "..\Code\DevelopingDiary.pas"
      File "..\Code\Lzma.pas"

      SetOutPath $INSTDIR\Code\Direct3D
      File "..\Code\Direct3D\D3D9.pas"
      File "..\Code\Direct3D\D3DX9Def.pas"
      File "..\Code\Direct3D\D3DX9Link.pas"
      File "..\Code\Direct3D\DXTypes.pas"

      SetOutPath $INSTDIR\Code\Game
      File "..\Code\Game\GameMain.pas"

      SetOutPath $INSTDIR\Code\Gui
      File "..\Code\Gui\GuiComments.pas"
      File "..\Code\Gui\GuiCursor.pas"
      File "..\Code\Gui\GuiMain.pas"
      File "..\Code\Gui\GuiSplash.pas"

      SetOutPath $INSTDIR\Code\Render
      File "..\Code\Render\Render2D.pas"
      File "..\Code\Render\RenderDeclarations.pas"
      File "..\Code\Render\RenderEffects.pas"
      File "..\Code\Render\RenderFont.pas"
      File "..\Code\Render\RenderMain.pas"
      File "..\Code\Render\RenderPostProcess.pas"
      File "..\Code\Render\RenderSettings.pas"
      File "..\Code\Render\RenderTextures.pas"
      
      SetOutPath $INSTDIR\Code\Sokoban
      File "..\Code\Sokoban\SokobanLevel.pas"

      SetOutPath $INSTDIR\Code\Win
      File "..\Code\Win\WinMain.pas"
      File "..\Code\Win\WinWindow.pas"
   SectionEnd

   ; Исходники инсталлера
   Section "Installer (NSIS required for compilation)"
      SetOutPath "$INSTDIR\Installer source"
      File "SokobanSetup.nsi"
      File "Sections.nsh"
      File "background.bmp"
      File "warning.bmp"
      File "checks.bmp"
      File "ui.exe"
      File "install.ico"
      File "uninstall.ico"
      File "Readme.txt"
   SectionEnd

SectionGroupEnd

Section "Uninstall"
   RMDir /r "$INSTDIR\Data"
   RMDir /r "$INSTDIR\Code"
   RMDir /r "$INSTDIR\Installer source"
   Delete $INSTDIR\.uninstall.exe
   Delete $INSTDIR\.sokoban.exe
   Delete $INSTDIR\sokoban.exe
   Delete $INSTDIR\sokoban.dpr
   Delete $INSTDIR\sokoban.cfg
   Delete $INSTDIR\sokoban.res
   Delete $INSTDIR\Readme.txt
   MessageBox MB_OK "Uninstall complete."
SectionEnd

!macroend
