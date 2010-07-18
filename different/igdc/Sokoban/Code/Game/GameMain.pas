unit GameMain;
//==============================================================================
// Unit: GameMain.pas
// Desc: 
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, SysUtils;

  procedure Initialize;
  
var
  GameVersion  : String;
  GameWorkDir  : String;
  GameShutDown : Boolean = False;

implementation

//==============================================================================
// Name: GetVersion
// Desc: Позволяет узнать версию самого себя(exe файла) "на лету". Больше не
//       надо "зашивать" версию в виде константы в коде. Тем более константу
//       можно забыть "обновить" и будет не соответствие. Полезная процедурка.
//==============================================================================
  procedure GetVersion;
  var
    VerInfoSize  : DWORD;
    Reserved     : DWORD;
    VerValueSize : DWORD;
    VerInfo      : Pointer;
    VerValue     : PVSFixedFileInfo;
  begin
       VerinfoSize := GetFileVersionInfoSize(PChar(ParamStr(0)),Reserved);
       GetMem(VerInfo,VerInfoSize);
       GetFileVersionInfo(PChar(ParamStr(0)), 0, VerInfoSize, VerInfo);
       VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
       with VerValue^ do
       begin
            //GameVersion := IntToStr(dwFileVersionMS shr 16);
            //GameVersion := GameVersion + '.' + IntToStr(dwFileVersionMS and $FFFF);
            //GameVersion := GameVersion + '.' + IntToStr(dwFileVersionLS shr 16);
            //GameVersion := GameVersion + '.' + IntToStr(dwFileVersionLS and $FFFF);
            GameVersion := IntToStr(dwFileVersionLS and $FFFF);
       end;
       FreeMem(VerInfo, VerInfoSize);
  end;

//==============================================================================
// Name: Initialize
//==============================================================================
  procedure Initialize;
  begin
       GameWorkDir := GetCurrentDir+'\';
       GetVersion;
  end;

end.
