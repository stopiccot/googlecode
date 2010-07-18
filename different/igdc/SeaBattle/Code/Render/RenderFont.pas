unit RenderFont;
interface
uses
  Windows, Classes, SysUtils, d3d9, d3d9x;
  function OutTextEx(X,Y,W,H: Single; Text: string; FontName: string; Size: Byte; Bold: Integer; Italic: BOOL; Color: DWORD): HRESULT;
  function OutTextCaret(X,Y: Single; Text: string; CaretPos: Integer; Color: DWORD): HRESULT;
  procedure ShutDown();
  
implementation
uses
  RenderMain, RenderUtils;

type
  TFont = class
    Name    : string;
    Bold    : integer;
    Size    : byte;
    Italic  : BOOL;
    D3DFont : ID3DXFont;
    constructor Create();
  end;

var
  Fonts : TList;
  hr    : HRESULT;

  function CreateFont(Font: string; Bold: Integer; Italic: BOOL; Size: Byte): HRESULT;
  var AddingFont : TFont;
  begin
       if Fonts=nil then Fonts := TList.Create;
       AddingFont := TFont.Create;
       AddingFont.Name := Font;
       AddingFont.Bold := Bold;
       AddingFont.Italic := Italic;
       AddingFont.Size := Size;
       
       // D3DXCreateFont
       hr := D3DXCreateFont(Device, Size, 0, Bold, 1, Italic,
                            DEFAULT_CHARSET, OUT_DEVICE_PRECIS,//OUT_DEFAULT_PRECIS,
                            DEFAULT_QUALITY, DEFAULT_PITCH or FF_DONTCARE,
                            PChar(Font), AddingFont.D3DFont);
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;

       Fonts.Add(AddingFont);               
       Result := D3D_OK;
  end;

  function FindFont(Font: string; Bold: Integer; Italic: BOOL; Size: Byte): ID3DXFont;
  var i: word;
  begin
       //Name := NBL(Name);
       Result := nil;
       i := 0;
       while (i<Fonts.Count) do
       begin
            if (TFont(Fonts.Items[i]).Name = Font)and
               (TFont(Fonts.Items[i]).Bold = Bold)and
               (TFont(Fonts.Items[i]).Size = Size)and
               (TFont(Fonts.Items[i]).Italic = Italic)then
            begin
                 Result := TFont(Fonts.Items[i]).D3DFont;
                 Exit;
            end;
            inc(i);
       end;
  end;

  // OutTextCaret
  function OutTextCaret(X,Y: Single; Text: string; CaretPos: Integer; Color: DWORD): HRESULT;
  var
    Font: ID3DXFont;
    Rect: TRect;
  begin
       Result := S_OK;
       if Fonts=nil then Fonts := TList.Create;
       Font := FindFont('Tahoma', 1000, False, 13);
       if Font = nil then
       begin
            hr := CreateFont('Tahoma', 1000, False, 13);
            if FAILED(hr) then begin Result := hr; Exit; end;
            Font := TFont(Fonts.Items[Fonts.Count-1]).D3DFont;
       end;
       Rect.Left := Round(X);
       Rect.Top  := Round(Y);
       hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, 0, Color);
       if CaretPos<>0 then
            hr := Font.DrawTextA(nil, PChar(Copy(Text,1,CaretPos)), -1, @Rect, DT_CALCRECT, $00FFFFFF);
       Font := FindFont('Tahoma', 0, False, 13);
       if Font = nil then
       begin
            hr := CreateFont('Tahoma', 0, False, 13);
            if FAILED(hr) then begin Result := hr; Exit; end;
            Font := TFont(Fonts.Items[Fonts.Count-1]).D3DFont;
       end;
       Rect.Left := Rect.Right-2;
       if CaretPos=0 then
            Rect.Left := Round(X)-2;
       Rect.Top  := Round(Y)-1;
       hr := Font.DrawTextA(nil, '|', -1, @Rect, DT_NOCLIP, Color);
  end;

  function OutTextEx(X,Y,W,H: Single; Text: string; FontName: string; Size: Byte; Bold: Integer; Italic: BOOL; Color: DWORD): HRESULT;
  var
    Font: ID3DXFont;
    Rect: TRect;
  begin
       if Fonts=nil then Fonts := TList.Create;
       Font := FindFont(FontName,Bold,Italic,Size);
       if Font = nil then
       begin
            hr := CreateFont(FontName,Bold,Italic,Size);
            if FAILED(hr) then
            begin
                 Result := hr;
                 Exit;
            end;
            Font := FindFont(FontName,Bold,Italic,Size);
       end;

       Rect.Left := Round(X);
       Rect.Top  := Round(Y);
       if W>0 then
       begin
            Rect.Right  := Rect.Left+Round(W);
            Rect.Bottom := Rect.Top+Round(H);
            hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, 0, Color);
       end else
       begin
            hr := Font.DrawTextA(nil, PChar(Text), -1, @Rect, DT_NOCLIP, Color);
       end;
       if FAILED(hr) then
       begin
            Result := hr;
            Exit;
       end;
       Result := D3D_OK;
  end;

  procedure ShutDown();
  var i: word;
  begin
       if Fonts = nil then Exit;
       // Release all ID3DXFont interfaces
       for i := 0 to (Fonts.Count-1) do
            TFont(Fonts.Items[i]).D3DFont._Release();
       Fonts.Free();
       Fonts := nil;
  end;

  constructor TFont.Create(); begin end;
end.
