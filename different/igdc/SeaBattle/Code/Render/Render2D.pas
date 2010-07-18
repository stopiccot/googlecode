unit Render2D;
interface
uses Windows, d3d9;

  function DrawSprite(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single;Color: DWORD): HRESULT;

implementation
uses
  RenderMain, RenderTextures;

 const
   D3DFVF_SPRITE = (D3DFVF_XYZRHW or D3DFVF_DIFFUSE or D3DFVF_TEX1);

 type
   FLOAT = Single;
   SPRITEVERTEX=record
     x,y,z,rhw : FLOAT;
     Color     : DWORD;
     tx,ty     : FLOAT;
   end;

  function DrawSprite(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single;Color: DWORD): HRESULT;
  var Verts: array[0..3]of SPRITEVERTEX; i: byte;

    procedure AddVertex(X,Y,tx,ty: single; Color: DWORD);
    begin
         Verts[i].x := x;
         Verts[i].y := y;
         Verts[i].z := 0.0;
         Verts[i].rhw := 0.0;
         Verts[i].tx := tx;
         Verts[i].ty := ty;
         Verts[i].Color := Color; inc(i);
    end;

  begin
       i := 0;
       AddVertex( X    , Y    , txLeft , tyTop,    Color );
       AddVertex( X + W, Y    , txRight, tyTop,    Color );
       AddVertex( X    , Y + H, txLeft , tyBottom, Color );
       AddVertex( X + W, Y + H, txRight, tyBottom, Color );
       Device.SetFVF(D3DFVF_SPRITE);
       hr := Device.SetTexture(0, RenderTextures.FindTexture(Name) );
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       hr := Device.DrawPrimitiveUp(D3DPT_TRIANGLESTRIP, 2, Verts, SizeOf(SPRITEVERTEX));
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Result := D3D_OK;
  end;
  
end.
