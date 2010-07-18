unit RenderMain;
interface
uses
  Windows, WinWindow, SysUtils, D3D9, D3D9X, {Errors,} Game, {log,}
  RenderSettings, {RenderPostProcess,} RenderTextures, RenderUtils,
  Render2D, RenderFont;

  function Initialize: HRESULT;
  function Render: HRESULT;
  procedure ShutDown();

  // Render2D functions
  function DrawSprite(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single;Color: DWORD): HRESULT;

  // RenderFont functions
  function OutTextEx(X,Y,W,H: Single; Text: string; Font: string; Size: Byte; Bold: Integer; Italic: BOOL; Color: DWORD): HRESULT;

  // RenderTextures functions
  function LoadTextureFromFile(Name: string; FileName: string; TranspColor: DWORD): HRESULT;

var
  D3D    : IDirect3D9 = nil;
  Device : IDirect3DDevice9 = nil;
  VB     : IDirect3DVertexBuffer9 = nil;
  IB     : IDirect3DIndexBuffer9 = nil;
  D3DDM  : TD3DDisplayMode;
  D3DPP  : TD3DPresentParameters;
  WorkDir: string;

  EnablePostProcess : BOOL = True;
  PixelShader  : DWORD;
  Debug        : BOOL = False;
implementation
var
  hr     : HRESULT;
  D3DCaps: TD3DCaps9;
  PPnotReset: BOOL = False;

  function Initialize: HRESULT;
  begin
       WorkDir := Game.WorkDir;

       // Create D3D
       D3D := Direct3DCreate9(D3D_SDK_VERSION);
       if (D3D = nil) then
       begin
            Result := E_FAIL;
            Exit;
       end;

       // Get Adapter Display Mode
       hr := D3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT,D3DDM);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       // Fill D3DPP
       ZeroMemory(@D3DPP,SizeOf(D3DPP));
       D3DPP.Windowed := not RenderSettings.Fullscreen;
       if RenderSettings.Fullscreen then
       begin
            D3DPP.BackBufferCount  := 2;
            D3DPP.FullScreen_RefreshRateInHz := D3DDM.RefreshRate;
       end;
       D3DPP.EnableAutoDepthStencil := True;
       D3DPP.AutoDepthStencilFormat := D3DFMT_D16;
       D3DPP.BackBufferWidth  := 1024;
       D3DPP.BackBufferHeight := 768;
       D3DPP.SwapEffect       := D3DSWAPEFFECT_DISCARD;
       D3DPP.BackBufferFormat := D3DDM.Format;

       // CreateDevice
       hr := D3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, WinWindow.MainWindow,
                  D3DCREATE_HARDWARE_VERTEXPROCESSING, @D3DPP, Device);
       if hr<>D3D_OK then
       begin
            Result := hr;
            Exit;
       end;

       // GetPixelShaderVersion
       Device.GetDeviceCaps(D3DCaps);
       PixelShader := D3DCaps.PixelShaderVersion;

       Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1 );
       Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1 );
       Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
       Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);

       Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);

       Device.SetSamplerState(0,D3DSAMP_MAGFILTER, D3DTEXF_NONE);
       Device.SetSamplerState(0,D3DSAMP_MINFILTER, D3DTEXF_NONE);

       Device.BeginScene;
       Result := D3D_OK;
  end;

  function Render(): HRESULT;
  begin
       // End scene
       Device.EndScene();
       // Send data to monitor
       Device.Present(nil,nil,0,nil);
       // TestCooperativeLevel
       case Device.TestCooperativeLevel() of
          D3DERR_DEVICELOST:
            begin
                 Result := E_FAIL;
                 Exit;
            end;
          D3DERR_DEVICENOTRESET:
            begin
                 // Releasing fonts
                 RenderFont.ShutDown();
                 // ResetDevice
                 Device.Reset(D3DPP);
                 Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1 );
                 Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1 );
                 Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
                 Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
                 Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
                 // EndScene
                 Device.EndScene();
                 Result := E_FAIL;
                 Exit;
            end;
       end;
       hr := Device.Clear(0, nil, D3DCLEAR_TARGET, $FFE6E7E1, 1.0, 0);
       hr := Device.BeginScene();
       Result := D3D_OK;
  end;

  function DrawSprite(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single;Color: DWORD): HRESULT;
  begin
       Result := Render2D.DrawSprite(Name,X,Y,W,H,txleft,tyTop,txRight,tyBottom,Color);
  end;

  function OutTextEx(X,Y,W,H: Single; Text: string; Font: string; Size: Byte; Bold: Integer; Italic: BOOL; Color: DWORD): HRESULT;
  begin
       Result := RenderFont.OutTextEx(X,Y,W,H,Text,Font,Size,Bold,Italic,Color);
  end;

  function LoadTextureFromFile(Name: string; FileName: string; TranspColor: DWORD): HRESULT;
  begin
       Result := RenderTextures.LoadTextureFromFile(Name, FileName, TranspColor);
  end;
  
  procedure ShutDown();
  begin
       RenderFont.ShutDown();
       RenderTextures.ShutDown();
       IB := nil;
       VB := nil;
       Device := nil;
       D3D := nil;
  end;

end.
