// PART OF ORBITAL ENGINE 2.0 SOURCE CODE
unit RenderMain;
//==============================================================================
// Unit: RenderMain.pas
// Desc: Главный модуль рендера, самые фундаментальные функции
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, D3D9, D3DX9Def, WinWindow,
  RenderPostProcess, RenderSettings, RenderFont, RenderTextures, RenderEffects;

  function Initialize: HRESULT;
  function CreateDevice: HRESULT;
  function Render: HRESULT;
  procedure Release;

type
  THRESULTFunction = function: HRESULT;
var
  D3D    : IDirect3D9 = nil;
  Device : IDirect3DDevice9 = nil;
  D3DPP  : TD3DPresentParameters;
  D3DDM  : TD3DDisplayMode;
  
  Present: THRESULTFunction;
  
  FPS    : Integer;
  FrameTime: int64 = 0;

  PS20Avalible : Boolean = False;
  PS14Avalible : Boolean = False;
implementation
var
  hr     : HRESULT;
  NewTick: int64;
  OldTick: int64;
  Caps   : TD3DCaps9;

//==============================================================================
// Name: _Present
// Desc: "Нормальный" вариант функции Present
//==============================================================================
  function _Present: HRESULT;
  begin
       hr := Device.Present(nil, nil, 0, nil);
       if FAILED(hr) then begin Result := hr; Exit; end;

       hr := Device.Clear(0, nil, D3DCLEAR_TARGET, $FF0000FF, 1, 0);
       if FAILED(hr) then begin Result := hr; Exit; end;
       
       Result := D3D_OK;
  end;
//==============================================================================
// Name: Initialize
// Desc: Инициализация
//==============================================================================
  function Initialize: HRESULT;
  begin
       // Создаём интерфейс IDirect3D9
       D3D := Direct3DCreate9(D3D_SDK_VERSION);
       if (D3D = nil) then
       begin
            MessageBox(HWND(nil), 'Failed to create D3D interface.', ApplicationName + ' - Critical Error', MB_OK);
            Result := E_FAIL;
            Exit;
       end;

       // GetAdapterDisplayMode
       hr := D3D.GetAdapterDisplayMode(D3DADAPTER_DEFAULT,D3DDM);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       // Создаём интерфейс видеокарты
       hr := CreateDevice;
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Present := _Present;
       
       Result := D3D_OK;
  end;

//==============================================================================
// Name: CreateDevice
// Desc: Создаёт интерфейс видеокарты
//==============================================================================
  function CreateDevice: HRESULT;
  begin
       // Удаляем старый интерфейс
       Device := nil;
       
       // Задаём параметры создания интерфейса видеокарты
       ZeroMemory(@D3DPP,SizeOf(D3DPP));
       D3DPP.Windowed := not RenderSettings.Fullscreen;
       if RenderSettings.Fullscreen then
       begin
            // Полноэкранный режим
            D3DPP.BackBufferCount  := 1;
            D3DPP.FullScreen_RefreshRateInHz := D3DDM.RefreshRate;
       end;
       D3DPP.EnableAutoDepthStencil := True;
       D3DPP.AutoDepthStencilFormat := D3DFMT_D16;
       // Разрешение
       case RenderSettings.Resolution of
       0: begin
               D3DPP.BackBufferWidth := 800;
               D3DPP.BackBufferHeight := 600;
          end;
       1: begin
               D3DPP.BackBufferWidth := 1024;
               D3DPP.BackBufferHeight := 768;
          end;
       2: begin
               D3DPP.BackBufferWidth := 1600;
               D3DPP.BackBufferHeight := 1200;
          end;
       end;

       D3DPP.SwapEffect := D3DSWAPEFFECT_DISCARD; //D3DSWAPEFFECT_COPY
       D3DPP.BackBufferFormat := D3DDM.Format;
       // D3DPRESENT_INTERVAL_ONE даёт vsync лучшего качества.
       D3DPP.PresentationInterval := D3DPRESENT_INTERVAL_ONE;
                                    //D3DPRESENT_INTERVAL_DEFAULT;
                                   
       // Создаём интерфейс
       hr := D3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, WinWindow.MainWindow,
                  D3DCREATE_HARDWARE_VERTEXPROCESSING, @D3DPP, Device);
       if hr<>D3D_OK then
       begin
            Result := hr;
            Exit;
       end;
       // Включаем Alpha-канал
       Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1 );
       Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1 );
       Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
       Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
       Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);

       // Детектируем версию пиксельных шейдеров

       Device.GetDeviceCaps(Caps);
       PS14Avalible := (((Caps.PixelShaderVersion shl 16) shr 24) = 1) and
                       (((Caps.PixelShaderVersion shl 32) shr 32) = 4);
       PS20Avalible := ((Caps.PixelShaderVersion shl 16) shr 24) > 1;
       if PS20Avalible then PS14Avalible := True;

       // Очищаем экран
       Device.Clear(0, nil, D3DCLEAR_TARGET, $FFE6E7E1, 1, 0);
       Device.Present(nil, nil, 0, nil);
       
       Result := D3D_OK;
  end;

//==============================================================================
// Name: Render
// Desc: Начало отрисовки нового кадра
//==============================================================================
  function Render: HRESULT;
  begin
       // Считаем FPS(Frames Per Second)
       NewTick := GetTickCount;
       FrameTime := NewTick - OldTick;
       FPS := Trunc(1000/FrameTime+0.5);
       OldTick := NewTick;
       // Состояние приложения
       case Device.TestCooperativeLevel of
         D3DERR_DEVICELOST:
         begin
              // Приложение "свёрнуто" и проводить рендер не имеет смысла
              Result := E_FAIL;
              Exit;
         end;
         D3DERR_DEVICENOTRESET:
         begin
              // Приложение "развернули" и надо восстановить ресурсы и
              // некоторые настройки
              // Восстанавливаем шрифты и эффекты
              RenderFont.OnResetDevice;
              RenderEffects.OnResetDevice;
              RenderPostProcess.Release;
              RenderTextures.ReleaseRenderTargetTextures;
              // Восстанавливаем видеокарту
              hr := Device.Reset(D3DPP);
              RenderPostProcess.Reset;
              RenderTextures.RecreateRenderTargetTextures;
              // Заново включаем Alpha-канал
              Device.SetRenderState(D3DRS_ALPHABLENDENABLE, 1 );
              Device.SetRenderState(D3DRS_SEPARATEALPHABLENDENABLE, 1 );
              Device.SetRenderState(D3DRS_SRCBLEND, D3DBLEND_SRCALPHA );
              Device.SetRenderState(D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA);
              Device.SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_MODULATE);
              Result := E_FAIL;
              Exit;
         end;
       end;
       hr := Present;
       Result := D3D_OK;
  end;

//==============================================================================
// Name: Release
// Desc: Освобождение памяти
//==============================================================================
  procedure Release;
  begin
       // Освобождаем память, занятую шрифтами
       RenderFont.Release;
       Device := nil;
       D3D := nil;
  end;

end.
