unit RenderTextures;
//==============================================================================
// Unit: RenderTextures.pas
// Desc: Хранение текстур
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, SysUtils, GameMain, D3D9, D3DX9Def, D3DX9Link;

type
  TTexture = record
    Name         : String;
    W,H          : Integer;
    RenderTarget : Boolean;
    D3DTexture   : IDirect3DTexture9;
  end;

  function CreateRenderTargetTexture(Name: string; Width, Height: Integer): HRESULT;
  function LoadTextureFromFile(Name: string; FileName: string): HRESULT;
  function LoadTextureFromMem(Name: string; Data: Pointer; Size: DWORD): HRESULT;
  function FindTexture(Name: string): IDirect3DTexture9;
  function RecreateRenderTargetTextures: HRESULT;
  procedure ReleaseRenderTargetTextures;
  procedure Release;

var
  Textures  : array of TTexture;
  nTextures : integer = 0;
  hr : HRESULT;

implementation
uses
  RenderMain, RenderPostProcess;
//==============================================================================
// Name: NameAlreadyUsed
// Desc: Проверяет, не используется ли уже какой либо текстурой, заданное имя.
//==============================================================================
  function NameAlreadyUsed(Name: String): Boolean;
  var i: Integer;
  begin
       Result := True;
       for i := 0 to nTextures-1 do
            if Textures[i].Name = Name then
                 Exit;
       Result := False;
  end;

//==============================================================================
// Name: CreateRenderTargetTexture
// Desc: Создаёт текстуру в уоторую можно производить рендер (Render Traget)
//==============================================================================
  function CreateRenderTargetTexture(Name: string; Width, Height: Integer): HRESULT;
  begin
       if NameAlreadyUsed(Name) then begin Result := E_FAIL; Exit; end;
       
       inc(nTextures);
       SetLength(Textures, nTextures);
       Textures[nTextures-1].Name := Name;
       Textures[nTextures-1].RenderTarget := True;
       Textures[nTextures-1].W := Width;
       Textures[nTextures-1].H := Height;
       hr := Device.CreateTexture(Width, Height, 1, D3DUSAGE_RENDERTARGET,
                    D3DDM.Format, D3DPOOL_DEFAULT, Textures[nTextures-1].D3DTexture, nil);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Result := D3D_OK;
  end;

//==============================================================================
// Name: LoadTextureFromFile
// Desc: Загружает текстуру из файла
//==============================================================================
  function LoadTextureFromMem(Name: string; Data: Pointer; Size: DWORD): HRESULT;
  begin
       if NameAlreadyUsed(Name) then begin Result := E_FAIL; Exit; end;

       inc(nTextures);
       SetLength(Textures, nTextures);
       Delete(Name,Length(Name)-3,4);
       Textures[nTextures-1].Name := Name;
       Textures[nTextures-1].RenderTarget := False;

       hr := D3DXCreateTextureFromFileInMemory(Device,
                  Data, Size, Textures[nTextures-1].D3DTexture);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Result := D3D_OK;
  end;

//==============================================================================
// Name: LoadTextureFromFile
// Desc: Загружает текстуру из файла
//==============================================================================
  function LoadTextureFromFile(Name: string; FileName: string): HRESULT;
  begin
       if NameAlreadyUsed(Name) then begin Result := E_FAIL; Exit; end;
            
       inc(nTextures);
       SetLength(Textures, nTextures);
       Textures[nTextures-1].Name := Name;
       Textures[nTextures-1].RenderTarget := False;
       hr := D3DXCreateTextureFromFile(Device,
                  PChar(GameWorkDir+'Data\'+FileName),
                  Textures[nTextures-1].D3DTexture);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Result := D3D_OK;
  end;

//==============================================================================
// Name: FindTexture
// Desc: Находит текстуру по имени
//==============================================================================
  function FindTexture(Name: string): IDirect3DTexture9;
  var i: Integer;
  begin
       Result := nil;
       for i := 0 to nTextures-1 do
       if Textures[i].Name = Name then
       begin
            Result := Textures[i].D3DTexture;
            Exit;
       end;
  end;

//==============================================================================
// Name: RecreateRenderTargetTextures
// Desc: Пересоздаёт Render Target текстуры
//==============================================================================
  function RecreateRenderTargetTextures: HRESULT;
  var i: Integer;
  begin
       for i := 0 to nTextures-1 do
       if Textures[i].RenderTarget then
       begin
            hr := Device.CreateTexture(Textures[i].W, Textures[i].H, 1,
                       D3DUSAGE_RENDERTARGET, D3DDM.Format, D3DPOOL_DEFAULT, Textures[i].D3DTexture, nil);
            if FAILED(hr) then
            begin
                 Result := hr;
                 Exit;
            end;
       end;
       Result := D3D_OK;
  end;

//==============================================================================
// Name: ReleaseRenderTargetTextures
// Desc: Удаляет RenderTarget текстуры
//==============================================================================
  procedure ReleaseRenderTargetTextures;
  var i: Integer;
  begin
       for i := 0 to nTextures-1 do
       if Textures[i].RenderTarget then
       if Textures[i].D3DTexture <> nil then
       begin
            Textures[i].D3DTexture := nil;
       end;
  end;

//==============================================================================
// Name: Release
// Desc: Высвобождает память, занятую текстурами
//==============================================================================
  procedure Release;
  var i: Integer;
  begin
       for i := 0 to nTextures-1 do
            Textures[i].D3DTexture := nil;
       SetLength(Textures, 0);
       nTextures := 0;
  end;

end.
