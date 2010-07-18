!include "Sections.nsh"

; Компрессия
SetCompressor /SOLID lzma

; Название 
Name ".SeaBattleSetup"
OutFile ".SeaBattleSetup.exe"
Caption ".SeaBattleSetup "
UninstallCaption ".SeaBattleUninstall"

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
   File "/oname=$PLUGINSDIR\sfxlogo.bmp" "background.bmp"
   SetBrandingImage /IMGID=1100 "$PLUGINSDIR\sfxlogo.bmp"   
FunctionEnd

Function un.onInit
   MessageBox MB_YESNO "Do you really want to uninstall .SeaBattle?" IDYES NoAbort
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