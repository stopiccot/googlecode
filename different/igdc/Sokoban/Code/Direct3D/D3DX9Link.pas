unit D3DX9Link;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
  Windows, D3D9, D3DX9Def;

  function DynamicallyLinkD3DX9: Boolean;
type
  TD3DXCreateTextureFromFile =
     function(pDevice: IDirect3DDevice9;
              pSrcFile: PChar;
              out ppTexture: IDirect3DTexture9): HRESULT; stdcall;

  TD3DXCreateTextureFromFileInMemory =
     function(pDevice: IDirect3DDevice9;
              const pSrcData: Pointer;
              SrcDataSize: LongWord;
              out ppTexture: IDirect3DTexture9): HRESULT; stdcall;

  TD3DXCreateFont =
     function (pDevice: IDirect3DDevice9;
               Height: Integer;
               Width: Longint;
               Weight: Longword;
               MipLevels: Longword;
               Italic: BOOL;
               CharSet: DWORD;
               OutputPrecision: DWORD;
               Quality: DWORD;
               PitchAndFamily: DWORD;
               pFaceName: PChar;
               out ppFont: ID3DXFont): HRESULT; stdcall;

  TD3DXCreateEffectFromFile =
     function (pDevice: IDirect3DDevice9;
               pSrcFile: PChar;
               pDefines: PD3DXMacro;
               pInclude: ID3DXInclude;
               Flags: DWORD;
               pPool: ID3DXEffectPool;
               out ppEffect: ID3DXEffect;
               ppCompilationErrors: PID3DXBuffer): HRESULT; stdcall;
var
  D3DXCreateTextureFromFile         : TD3DXCreateTextureFromFile = nil;
  D3DXCreateTextureFromFileInMemory : TD3DXCreateTextureFromFileInMemory = nil;
  D3DXCreateFont                    : TD3DXCreateFont = nil;
  D3DXCreateEffectFromFile          : TD3DXCreateEffectFromFile = nil;
implementation
var
  D3DX9Library : HMODULE;
  System32Dir  : String;

//==============================================================================
// Name: DynamicallyLinkD3DX9
// Desc: Так как dll-ка Direct 3D eXtension Library, в каждом updat'е DirectX
//       меняет название, а "таскать" с собой лишних 2 Mb ой как не хочеться, то
//       динамически устанавливаем связь с той версией dll-ки, которую найдём :)
//==============================================================================
  function DynamicallyLinkD3DX9: Boolean;
  var WinDir: array[0..MAX_PATH]of Char;
  begin
       Result := False;
       
       if (GetWindowsDirectory(WinDir, SizeOf(WinDir))=0) then Exit;
       System32Dir := WinDir+'\system32\';

       D3DX9Library := LoadLibrary(PChar(System32Dir+'d3dx9_30.dll'));
       if D3DX9Library = 0 then
       begin
            D3DX9Library := LoadLibrary(PChar(System32Dir+'d3dx9_29.dll'));
            if D3DX9Library = 0 then
            begin
                 D3DX9Library := LoadLibrary(PChar(System32Dir+'d3dx9_28.dll'));
                 if D3DX9Library = 0 then
                 begin
                      D3DX9Library := LoadLibrary(PChar(System32Dir+'d3dx9_27.dll'));
                      if D3DX9Library = 0 then
                      begin
                           D3DX9Library := LoadLibrary(PChar(System32Dir+'d3dx9_26.dll'));
                           if D3DX9Library = 0 then
                           begin
                                D3DX9Library := LoadLibrary(PChar(System32Dir+'DirectX.dll'));
                                if D3DX9Library = 0 then Exit;
                           end;
                      end;
                 end;
            end;
       end;

       D3DXCreateTextureFromFile := GetProcAddress(D3DX9Library, 'D3DXCreateTextureFromFileA');
       if Addr(D3DXCreateTextureFromFile) = nil then Exit;

       D3DXCreateTextureFromFileInMemory := GetProcAddress(D3DX9Library, 'D3DXCreateTextureFromFileInMemory');
       if Addr(D3DXCreateTextureFromFileInMemory) = nil then Exit;

       D3DXCreateFont := GetProcAddress(D3DX9Library, 'D3DXCreateFontA');
       if Addr(D3DXCreateFont) = nil then Exit;

       D3DXCreateEffectFromFile := GetProcAddress(D3DX9Library, 'D3DXCreateEffectFromFileA');
       if Addr(D3DXCreateEffectFromFile) = nil then Exit;

       Result := True;
  end;

end.
