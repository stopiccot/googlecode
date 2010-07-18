// PART OF ORBITAL ENGINE 2.0 SOURCE CODE
unit RenderFont;
//==============================================================================
// Unit: RenderFont.pas
// Desc: Вектореые шрифты
//       ©2006 .gear
//==============================================================================
interface
uses
  Windows, D3D9, D3DX9Def, D3DX9Link;
  
  function OutTextEx(X,Y,W,H: Single; Text: String; FontName: String; Size: Byte; Bold: Boolean; Italic: Boolean; Color: DWORD; Align: Byte = 0): HRESULT;
  function OutTextJustify(X,Y,W,H: Single; Text: PChar; FontName: String; Size: Byte; Bold: Boolean; Italic: Boolean; Color: DWORD): HRESULT;
  procedure OnResetDevice;
  procedure Release;

implementation
uses
  RenderMain;

type
  TFont = record
    Name    : String;
    Bold    : Boolean;
    Italic  : Boolean;
    Size    : Byte;
    D3DFont : ID3DXFont;
  end;

var
  Fonts  : array of TFont;
  nFonts : integer = 0;
  hr     : HRESULT;

//==============================================================================
// Name: CreateFont
// Desc: Создаёт шрифт с заданными параметрами
//==============================================================================
  function CreateFont(Font: String; Bold: Boolean; Italic: Boolean; Size: Byte): HRESULT;
  var B: Integer;
  begin
       inc(nFonts);
       SetLength(Fonts, nFonts);

       Fonts[nFonts-1].Name := Font;
       Fonts[nFonts-1].Bold := Bold;
       Fonts[nFonts-1].Italic := Italic;
       Fonts[nFonts-1].Size := Size;
       if Bold then B := 1000 else B := 0;

       // Создаём шрифт
       hr := D3DXCreateFont(Device, Size, 0, B, 100, Italic,
                  DEFAULT_CHARSET, OUT_DEVICE_PRECIS,
                  DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
                  PChar(Font), Fonts[nFonts-1].D3DFont);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Result := D3D_OK;
  end;

//==============================================================================
// Name: FindFont
// Desc: Ищет шрифт среди созданных, по имени
//==============================================================================
  function FindFont(Font: String; Bold: Boolean; Italic: Boolean; Size: Byte): ID3DXFont;
  var i: integer;
  begin
       Result := nil;
       for i := 0 to nFonts-1 do
       begin
            if (Fonts[i].Name = Font)and
               (Fonts[i].Bold = Bold)and
               (Fonts[i].Size = Size)and
               (Fonts[i].Italic = Italic)then
            begin
                 Result := Fonts[i].D3DFont;
                 Exit;
            end;
       end;
  end;

//==============================================================================
// Name: OutTextEx
// Desc: Вывод текста
//==============================================================================
  function OutTextEx(X,Y,W,H: Single; Text: String; FontName: String; Size: Byte; Bold: Boolean; Italic: Boolean; Color: DWORD; Align: Byte = 0): HRESULT;
  var
    Font : ID3DXFont;
    Flags: DWORD;
    Rect : TRect;
  begin
       Font := nil;
       Font := FindFont(FontName,Bold,Italic,Size);
       if Font = nil then
       begin
            hr := CreateFont(FontName,Bold,Italic,Size);
            if FAILED(hr) then
            begin
                 Result := hr;
                 Exit;
            end;
            Font := Fonts[nFonts-1].D3DFont;
       end;

       Flags := 0;
       
       case Align of
       0: begin
               Rect.Left := Round(X);
               Rect.Top  := Round(Y);
               if W>=0 then
               begin
                    Rect.Right  := Rect.Left+Round(W);
                    if H>=0 then Rect.Bottom := Rect.Top+Round(H) else Rect.Bottom := 10000;
                    hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, Flags, Color);
               end else
               begin
                    hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, DT_NOCLIP, Color);
               end;
          end;
       1: begin
               Rect.Top   := Round(Y);
               Rect.Left  := Round(X);
               Rect.Right := Round(X+W);
               hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, DT_NOCLIP or DT_CENTER, Color);
          end;
       2: begin
               Rect.Top    := Round(Y);
               Rect.Right  := Round(X);
               hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, DT_NOCLIP or DT_RIGHT, Color);
          end;
       end;
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       Result := D3D_OK;
  end;

//==============================================================================
// Name: OutTextJustify
// Desc: Вывод текста
//==============================================================================
  function OutTextJustify(X,Y,W,H: Single; Text: PChar; FontName: String; Size: Byte; Bold: Boolean; Italic: Boolean; Color: DWORD): HRESULT;
  var
    Font: ID3DXFont;
    Rect: TRect;
  begin
       Font := nil;
       Font := FindFont(FontName,Bold,Italic,Size);
       if Font = nil then
       begin
            hr := CreateFont(FontName,Bold,Italic,Size);
            if FAILED(hr) then
            begin
                 Result := hr;
                 Exit;
            end;
            Font := Fonts[nFonts-1].D3DFont;
       end;

       Rect.Left := Round(X);
       Rect.Top  := Round(Y);
       Rect.Right  := Rect.Left+Round(W);
       Rect.Bottom := Rect.Top+Round(H);

       hr := Font.DrawTextA(nil, Text, -1, @Rect, DT_WORDBREAK, Color);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       Result := D3D_OK;
  end;
//==============================================================================
// Name: OnResetDevice
// Desc: Восстанавливает шрифты после сворачивания приложения
//==============================================================================
  procedure OnResetDevice;
  var i: integer;
  begin
       for i := 0 to nFonts-1 do
       begin
            hr := Fonts[i].D3DFont.OnLostDevice;
            hr := Fonts[i].D3DFont.OnResetDevice;
       end;
  end;

//==============================================================================
// Name: Relase
// Desc: Высвобождает память, занятую шрифтами
//==============================================================================
  procedure Release;
  var i: integer;
  begin
       for i := 0 to nFonts-1 do
            Fonts[i].D3DFont := nil;
       nFonts := 0;
       SetLength(Fonts, nFonts);
  end;

end.
