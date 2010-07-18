unit RenderSettings;
interface
uses
  Windows;
  
var
  ZBuffer    : BOOL = not True;
  Fullscreen : BOOL = True;
  HLSL       : BOOL = True;
  Resolution : BYTE = 2; // Static
  { 0 - 640x480
    1 - 800x600
    2 - 1024x768
    3 - 1152x864              
    4 - 1280x960
    5 - 1600x1200 }
  AntiAlias  : BYTE = 0; //по-идее чем больше тем лучше :)

  //if g_vsync = 0 then D3DPP.PresentationInterval := D3DPRESENT_INTERVAL_IMMEDIATE else D3DPP.PresentationInterval := (1 shl g_vsync) div 2;
implementation

end.
