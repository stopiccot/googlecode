// PART OF ORBITAL ENGINE 2.0 SOURCE CODE
unit RenderDeclarations;
//==============================================================================
// Unit: RenderDeclarations.pas
// Desc: Хранение форматов вершин
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, D3D9;

var
  SpriteDeclaration : IDirect3DVertexDeclaration9 = nil;
  CursorDeclaration : IDirect3DVertexDeclaration9 = nil;
  
  function Initialize: HRESULT;
  
implementation
uses
  RenderMain;
//==============================================================================
// Name: Initialize
// Desc: Инициализация
//==============================================================================
  function Initialize: HRESULT;
  var Decl: array[0..5] of TD3DVertexElement9; hr: HRESULT;
  begin
       {$REGION ' SpriteDeclaration '}
       Decl[0].Stream := 0;
       Decl[0].Offset := 0;
       Decl[0]._Type  := D3DDECLTYPE_FLOAT2;
       Decl[0].Method := D3DDECLMETHOD_DEFAULT;
       Decl[0].Usage  := D3DDECLUSAGE_POSITION;
       Decl[0].UsageIndex := 0;

       Decl[1].Stream := 0;
       Decl[1].Offset := 8;
       Decl[1]._Type  := D3DDECLTYPE_D3DCOLOR;
       Decl[1].Method := D3DDECLMETHOD_DEFAULT;
       Decl[1].Usage  := D3DDECLUSAGE_COLOR;
       Decl[1].UsageIndex := 0;

       Decl[2].Stream := 0;
       Decl[2].Offset := 12;
       Decl[2]._Type  := D3DDECLTYPE_FLOAT2;
       Decl[2].Method := D3DDECLMETHOD_DEFAULT;
       Decl[2].Usage  := D3DDECLUSAGE_TEXCOORD;
       Decl[2].UsageIndex := 0;

       Decl[3] := D3DDECL_END;

       hr := Device.CreateVertexDeclaration(@Decl, SpriteDeclaration);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       {$ENDREGION}

       {$REGION ' CursorDeclaration '}
       Decl[0].Stream := 0;
       Decl[0].Offset := 0;
       Decl[0]._Type  := D3DDECLTYPE_FLOAT2;
       Decl[0].Method := D3DDECLMETHOD_DEFAULT;
       Decl[0].Usage  := D3DDECLUSAGE_POSITION;
       Decl[0].UsageIndex := 0;

       Decl[1].Stream := 0;
       Decl[1].Offset := 8;
       Decl[1]._Type  := D3DDECLTYPE_FLOAT2;
       Decl[1].Method := D3DDECLMETHOD_DEFAULT;
       Decl[1].Usage  := D3DDECLUSAGE_TEXCOORD;
       Decl[1].UsageIndex := 0;

       Decl[2].Stream := 0;
       Decl[2].Offset := 16;
       Decl[2]._Type  := D3DDECLTYPE_FLOAT2;
       Decl[2].Method := D3DDECLMETHOD_DEFAULT;
       Decl[2].Usage  := D3DDECLUSAGE_TEXCOORD;
       Decl[2].UsageIndex := 1;

       Decl[3] := D3DDECL_END;

       hr := Device.CreateVertexDeclaration(@Decl, CursorDeclaration);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       {$ENDREGION}

       Result := D3D_OK;
  end;

end.
