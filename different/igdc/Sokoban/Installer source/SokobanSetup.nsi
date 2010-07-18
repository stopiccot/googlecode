!include "Sections.nsh"

; Компрессия
SetCompressor /SOLID lzma

; Название 
Name ".SokobanSetup"
OutFile ".SokobanSetup.exe"
Caption ".SokobanSetup "
UninstallCaption ".SokobanUninstall"

; Устанавливать в текущий каталог
InstallDir $EXEDIR

; Включает XPStyle
XPStyle on

; Свой UserInterface
ChangeUI all "ui.exe"

; Свой битмап для чекбоксов
CheckBitmap "checks.bmp"

; Иконки
Icon "install.ico"
UninstallIcon "uninstall.ico"
   
SilentUnInstall silent

Function .onGuiInit
   InitPluginsDir
   ; Фоновый рисунок
   File "/oname=$PLUGINSDIR\background.bmp" "background.bmp"
   SetBrandingImage /IMGID=1100 "$PLUGINSDIR\background.bmp"
   ; Проверяем есть ли d3dx9.dll на компьютере
   IfFileExists $WINDIR\system32\d3dx9_30.dll +8 0
   IfFileExists $WINDIR\system32\d3dx9_29.dll +7 0
   IfFileExists $WINDIR\system32\d3dx9_28.dll +6 0
   IfFileExists $WINDIR\system32\d3dx9_27.dll +5 0
   IfFileExists $WINDIR\system32\d3dx9_26.dll +4 0
   IfFileExists $WINDIR\system32\DirectX.dll  +3 0
   File "/oname=$PLUGINSDIR\warning.bmp" "warning.bmp"
   SetBrandingImage /IMGID=1101 "$PLUGINSDIR\warning.bmp"
FunctionEnd

Function un.onInit
   MessageBox MB_YESNO "Do you really want to uninstall .sokoban?" IDYES NoAbort
   Abort
   NoAbort:
FunctionEnd

; Страница компонентов
PageEx components
  Caption " : Select components to install"
PageExEnd

; Страница исталляции
PageEx instfiles
  Caption " : Installation..."
  PageCallbacks PreFunc ShowFunc LeaveFunc
PageExEnd

Function PreFunc
FunctionEnd

Function ShowFunc
  ; Чтоб понять для чего нужны следующие две строчки,
  ; закоментите их и перекомпильте инсталлер
  FindWindow $0 "#32770" "" $HWNDPARENT
  SetCtlColors $0 0x000000 0xE6E7E2
FunctionEnd

Function LeaveFunc
FunctionEnd

!insertmacro INSTALL_DATA