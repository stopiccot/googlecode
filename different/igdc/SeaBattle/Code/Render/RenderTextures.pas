unit RenderTextures;
interface
uses
  Windows, Classes, SysUtils, Game,
  d3d9, d3d9x;

type
  TTexture = class
    Name        : string;
    D3DTexture  : IDirect3DTexture9;
    constructor Create;
  end;

  function LoadTextureFromMem(Name: string; Source: Pointer; Size: int64; TranspColor: DWORD): HRESULT;
  function LoadTextureFromFile(Name: string; FileName: string; TranspColor: DWORD): HRESULT;
  function FindTexture(Name: string): IDirect3DTexture9;
  procedure ShutDown();

var
  Textures   : TList;
  hr : HRESULT;

implementation
uses
  RenderMain;

  function LoadTextureFromMem(Name: string; Source: Pointer; Size: int64; TranspColor: DWORD): HRESULT;
  var AddingTexture : TTexture;
  begin
       if Textures=nil then Textures := TList.Create;
       Name := ExtractFileName(Name);
       AddingTexture := TTexture.Create;
       AddingTexture.Name := Name;
       hr := D3DXCreateTextureFromFileInMemoryEx(Device,
                                                 Source, Size,
                                                 0, 0, 3, 0,
                                                 D3DFMT_UNKNOWN,
                                                 D3DPOOL_MANAGED,
                                                 D3DX_DEFAULT,
                                                 D3DX_DEFAULT,
                                                 TranspColor,
                                                 nil, nil,
                                                 AddingTexture.D3DTexture );
       Textures.Add(AddingTexture);
       Result := D3D_OK;
  end;

  function LoadTextureFromFile(Name: string; FileName: string; TranspColor: DWORD): HRESULT;
  var AddingTexture : TTexture;
  begin
       if Textures=nil then Textures := TList.Create;
       ChDir(Game.WorkDir+'Data\');
       Name := ExtractFileName(Name);
       AddingTexture := TTexture.Create;
       AddingTexture.Name := Name;
       hr := D3DXCreateTextureFromFileEx(Device, PChar(FileName),
                                         0, 0, 3, 0,
                                         D3DFMT_UNKNOWN, D3DPOOL_MANAGED,
                                         D3DX_DEFAULT, D3DX_DEFAULT,
                                         TranspColor, nil, nil,
                                         AddingTexture.D3DTexture );
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       Textures.Add(AddingTexture);
       Result := D3D_OK;
  end;

  function FindTexture(Name: string): IDirect3DTexture9;
  var i: word;
  begin
       //Name := NBL(Name);
       Result := nil;
       for i := 0 to (Textures.Count-1) do
       if TTexture(Textures.Items[i]).Name = Name then
       begin
            Result := TTexture(Textures.Items[i]).D3DTexture;
            Exit;
       end;
  end;

  procedure ShutDown;
  var i: word;
  begin
       // Release all IDirect3DTexture9 interfaces
       for i := 0 to (Textures.Count-1) do
            TTexture(Textures.Items[i]).D3DTexture := nil;

       Textures.Free;
  end;

  constructor TTexture.Create;begin end;

end.
