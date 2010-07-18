unit Game;
interface
uses
  Windows, SysUtils, RenderSettings;

  procedure Initialize;

const
  // Game positions
  gpSplash     = 0;
  gpMainMenu   = 1;
  gpGame       = 2;
  gpAbout      = 3;
  gpHighscores = 4;
  
var
  Build     : string;
  WorkDir   : string;
  GamePos   : Byte = gpSplash;
  ShutDown  : Bool = False;

implementation

  // Get build
  procedure GetBuild;
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
       Build := IntToStr(VerValue^.dwFileVersionLS and $FFFF);
       FreeMem(VerInfo, VerInfoSize);
  end;

  procedure Initialize;
  begin
       GetBuild;
       WorkDir := GetCurrentDir+'\';
  end;

end.
