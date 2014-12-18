unit RenderSettings;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

var
  Resolution : Integer = 1; // Не менять!
  // 0 - 800x600
  // 1 - 1024x768
  VSync      : Boolean = False;
  Fullscreen : Boolean = not True;
  
implementation
end.

