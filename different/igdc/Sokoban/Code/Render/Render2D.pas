// PART OF ORBITAL ENGINE 2.0 SOURCE CODE
unit Render2D;
//==============================================================================
// Unit: Render2D.pas
// Desc: Отрисовка 2D-графики
//       ©2006 .gear
//==============================================================================
interface
uses Windows, D3D9, D3DX9Def;

  function DrawSprite(Name: string;X,Y,W,H: Single; Color: DWORD): HRESULT;
  function DrawSpriteEx(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single; Color: DWORD; Technique: string = 'Normal'): HRESULT; overload;
  function DrawSpriteEx(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single; Color1,Color2,Color3,Color4: DWORD; Technique: string = 'Normal'): HRESULT; overload;
  function DrawSpriteAngle(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom,Angle: Single; Color: DWORD; Technique: string = 'Angle'): HRESULT;
  
implementation
uses
  RenderMain, RenderTextures, RenderEffects, RenderDeclarations, RenderSettings,
  RenderPostProcess;

var
  Effect            : ID3DXEffect = nil;
  A: Single = 0;
  B: Single = 0;

type
  SPRITEVERTEX=record
    x,y   : Single;
    Color : DWORD;
    tx,ty : Single;
  end;

//==============================================================================
// Name: ArcCos
// Desc: Фунция вычисления угла по его косинусу. Выдрана из модуля Math
//==============================================================================
  function ArcCos(const X : Double) : Double;
  asm
     FLD   X
     FLD1
     FADD  ST(0), ST(1)
     FLD1
     FSUB  ST(0), ST(2)
     FMULP ST(1), ST(0)
     FSQRT
     FXCH
     FPATAN
  end;

//==============================================================================
// Name: DrawSprite
// Desc: Процедура вывода спрайта
//==============================================================================
  function DrawSprite(Name: string;X,Y,W,H: Single; Color: DWORD): HRESULT;
  var NumPasses,i: Longword; Verts: array[0..3]of SPRITEVERTEX;

    procedure AddVertex(X,Y,tx,ty: single; Color: DWORD);
    begin
         Verts[i].x := (x-512)/512;
         Verts[i].y := -(y-384)/384;
         Verts[i].tx := tx;
         Verts[i].ty := ty;
         Verts[i].Color := Color; inc(i);
    end;

  begin
       i := 0;
       AddVertex(X+W, Y+H, 1, 1, Color);
       AddVertex(X,   Y+H, 0, 1, Color);
       AddVertex(X+W, Y,   1, 0, Color);
       AddVertex(X,   Y,   0, 0, Color);

       Device.SetVertexDeclaration(SpriteDeclaration);

       Effect := FindTechnique('Normal');
       if Effect = nil then
       begin
            Result := E_FAIL;
            Exit;
       end;
       hr := Effect.SetTechnique(Effect.GetTechniqueByName('Normal'));
       if FAILED(hr)then
       begin
            Result := hr;
            Exit;
       end;
       Device.BeginScene;
       // Рендер
       Effect._Begin(@NumPasses, 0);
       Effect.SetTexture('t0', FindTexture(Name));
       for i := 0 to NumPasses-1 do
       begin
            Effect.BeginPass(i);
            Device.DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, Verts, SizeOf(SPRITEVERTEX));
            Effect.EndPass;
       end;
       Effect._End;
       Device.EndScene;
       // CleanUp
       Device.SetVertexDeclaration(nil);
      
       Result := D3D_OK;
  end;

//==============================================================================
// Name: DrawSpriteEx
// Desc: Расширенная процедура вывода спрайта
//==============================================================================
  function DrawSpriteEx(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single; Color: DWORD; Technique: string = 'Normal'): HRESULT;
  begin
       Result := DrawSpriteEx(Name,X,Y,W,H,txLeft,tyTop,txRight,tyBottom,Color,Color,Color,Color,Technique);
  end;

  function DrawSpriteEx(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom: Single; Color1,Color2,Color3,Color4: DWORD; Technique: string = 'Normal'): HRESULT;
  var NumPasses,i: Longword; Verts: array[0..3]of SPRITEVERTEX;

    procedure AddVertex(X,Y,tx,ty: single; Color: DWORD);
    begin
         Verts[i].x := (x-512)/512;
         Verts[i].y := -(y-384)/384;
         Verts[i].tx := tx;
         Verts[i].ty := ty;
         Verts[i].Color := Color; inc(i);
    end;

  begin
       i := 0;
       AddVertex(X+W, Y+H, txRight, tyBottom, Color4);
       AddVertex(X,   Y+H, txLeft,  tyBottom, Color3);
       AddVertex(X+W, Y,   txRight, tyTop,    Color2);
       AddVertex(X,   Y,   txLeft,  tyTop,    Color1);

       Device.SetVertexDeclaration(SpriteDeclaration);

       Effect := FindTechnique(Technique);
       if Effect = nil then
       begin
            Result := E_FAIL;
            Exit;
       end;
       hr := Effect.SetTechnique(Effect.GetTechniqueByName(PChar(Technique)));
       if FAILED(hr)then
       begin
            hr := Effect.SetTechnique(Effect.GetTechniqueByName('Normal'));
            if FAILED(hr)then
            begin
                 Result := hr;
                 Exit;
            end;
       end;

       Device.BeginScene;
       
       // Render
       Effect._Begin(@NumPasses, 0);
       Effect.SetTexture('t0', FindTexture(Name));
       if Technique='Blur' then
       begin
            A := A + 0.002;//0125;
            B := B + 0.003;//0125;
            if A>1 then A := 0;
            if B>1 then B := 0;
            Effect.SetFloat('a',2*Pi*A);
            Effect.SetFloat('b',2*Pi*B);
       end;
       for i := 0 to NumPasses-1 do
       begin
            Effect.BeginPass(i);
            Device.DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, Verts, SizeOf(SPRITEVERTEX));
            Effect.EndPass;
       end;
       Effect._End;

       Device.EndScene;
       // CleanUp
       Device.SetVertexDeclaration(nil);
      
       Result := D3D_OK;
  end;     

  function DrawSpriteAngle(Name: string;X,Y,W,H,txLeft,tyTop,txRight,tyBottom,Angle: Single; Color: DWORD; Technique: string = 'Angle'): HRESULT;
  var
    AC, Alpha, L: Double;
    NumPasses,i: Longword;
    Verts: array[0..3]of SPRITEVERTEX;

    procedure AddVertex(X,Y,tx,ty: single; Color: DWORD);
    begin
         Verts[i].x := (x-512)/512;
         Verts[i].y := -(y-384)/384;
         Verts[i].tx := tx;
         Verts[i].ty := ty;
         Verts[i].Color := Color; inc(i);
    end;

  begin
       L := Sqrt(W*W+H*H);
       AC := ArcCos(W/L);
       L := L/2;
       i := 0;
       Alpha := AC + Angle;
       AddVertex(X+L*Cos(Alpha), Y+L*Sin(Alpha), txRight, tyBottom,    Color);

       Alpha := Pi - AC + Angle;
       AddVertex(X+L*Cos(Alpha), Y+L*Sin(Alpha), txLeft,  tyBottom,    Color);

       Alpha := 2*Pi - AC + Angle;
       AddVertex(X+L*Cos(Alpha), Y+L*Sin(Alpha), txRight, tyTop, Color);

       Alpha := Pi + AC + Angle;
       AddVertex(X+L*Cos(Alpha), Y+L*Sin(Alpha), txLeft,  tyTop, Color);

       Device.SetVertexDeclaration(SpriteDeclaration);

       hr := Effect.SetTechnique(Effect.GetTechniqueByName(PChar(Technique)));
       if FAILED(hr)then
       begin
            hr := Effect.SetTechnique(Effect.GetTechniqueByName('Angle'));
            if FAILED(hr)then
            begin
                 Result := hr;
                 Exit;
            end;
       end;

       Device.BeginScene;
       
       // Render
       Effect._Begin(@NumPasses, 0);
       Effect.SetTexture('t0', FindTexture(Name));
       for i := 0 to NumPasses-1 do
       begin
            Effect.BeginPass(i);
            Device.DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, Verts, SizeOf(SPRITEVERTEX));
            Effect.EndPass;
       end;
       Effect._End;

       Device.EndScene;
       // CleanUp
       Device.SetVertexDeclaration(nil);
      
       Result := D3D_OK;
  end;

end.
