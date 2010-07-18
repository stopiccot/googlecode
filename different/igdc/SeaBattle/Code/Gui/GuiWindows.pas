unit GuiWindows;
//==============================================================================
// Unit: GuiWindows.pas
// Desc: Реализация gui-окошек...
//==============================================================================
interface
uses Windows, Classes, GuiCursor, GuiUtils, RenderMain;

  // API Functions
  function GuiCreateWindow: THandle;
  function GuiCreateWindowEx(Title: String; X,Y,Width,Heigth: Integer;
                             RenderProc: Pointer; MouseProc : Pointer): THandle;
  function GuiShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL;
  function GuiFindWindow(hWnd: HWND): Pointer;
  function GuiMouseOverWindow: Boolean;

  function OnRender: HRESULT;
  
  function WMMouseDown: HRESULT;
  function WMMouseUp: HRESULT;
  function WMTimer: HRESULT;

const
  SW_SHOWMODAL = 11;
  
type
  POWindow = ^TOWindow;

  TProcedure = procedure(OWindow: POWindow);
  TMouseProc = procedure(OWindow: POWindow; Event: Byte);

  TOWindow = class
  private
    FTitle   : String;
    FVisible : Boolean;
    FX,FY    : Integer;
    FWidth   : Integer;
    FHeigth  : Integer;
    FDragStartPos : TPoint;
    FOldPos  : TPoint;
    FDrag    : Boolean;
    FAlpha   : Single;
    FCanClose: Boolean;
    FZ       : Integer;
    FHandle  : THandle;
  public
    Sizeable   : Boolean;
    RenderProc : TProcedure;
    MouseProc  : TMouseProc;
    constructor Create;
    constructor CreateEx(ATitle: string; AX,AY,AWidth,AHeigth: Integer);
    procedure WMMouseUp;
    function WMMouseDown: Boolean;
    procedure Draw;
    procedure Timer;
    procedure Show(nCmdShow: Integer);
    procedure BringToTop;
    property Alpha: Single read FAlpha write FAlpha;
    property Title: String read FTitle write FTitle;
    property X: Integer read FX write FX;
    property Y: Integer read FY write FY;
    property Width: Integer read FWidth write FWidth;
    property Heigth: Integer read FHeigth write FHeigth;
    property Visible: Boolean read FVisible write FVisible;
    property CanClose: Boolean read FCanClose write FCanClose;
    property Handle: THandle read FHandle;
  end;

var
  Modal    : Boolean = False;
implementation
var
  nHandle  : THandle = 100500;
  OWindows : array of TOWindow;
  nWindows : Integer = 0;

//==============================================================================
// Name: GuiCreateWindow
// Desc:
//==============================================================================
  function GuiCreateWindow: THandle;
  begin
       inc(nWindows);
       SetLength(OWindows, nWindows);
       OWindows[nWindows-1] := TOWindow.Create;
       Result := OWindows[nWindows-1].Handle;
  end;

//==============================================================================
// Name: GuiCreateWindowEx
// Desc:
//==============================================================================
  function GuiCreateWindowEx(Title: String; X,Y,Width,Heigth: Integer;
                             RenderProc: Pointer;
                             MouseProc : Pointer): THandle;
  begin
       inc(nWindows);
       SetLength(OWindows, nWindows);
       OWindows[nWindows-1] := TOWindow.CreateEx(Title,X,Y,Width,Heigth);
       OWindows[nWindows-1].RenderProc := RenderProc;
       OWindows[nWindows-1].MouseProc  := MouseProc;
       Result := OWindows[nWindows-1].Handle;
  end;

//==============================================================================
// Name: GuiShowWindow
// Desc: Аналог Windows-функции ShowWindow
//==============================================================================
  function GuiShowWindow(hWnd: HWND; nCmdShow: Integer): BOOL;
  var i: integer;
  begin
       Result := False;
       for i := 0 to nWindows-1 do
       if OWindows[i].Handle=hWnd then
       begin
            OWindows[i].Show(nCmdShow);
            Result := True;
            Exit;
       end;
  end;

//==============================================================================
// Name: GuiFindWindow
// Desc: Возвращает поинтер на класс окна по его хэндлу
//==============================================================================
  function GuiFindWindow(hWnd: HWND): Pointer;
  var i: integer;
  begin
       for i := 0 to nWindows - 1 do
       if OWindows[i].Handle=hWnd then
       begin
            Result := @OWindows[i];
            Exit;
       end;
       Result := nil;
  end;

//==============================================================================
// Name: GuiMouseOverWindow
// Desc: Возвращает True если мышь находится над каким-нибудь окном
//==============================================================================
  function GuiMouseOverWindow: Boolean;
  var i: integer;
  begin
       Result := False;
       for i := 0 to nWindows - 1 do
       begin
            if (Cursor.X>=OWindows[i].X)and(Cursor.X<=OWindows[i].X+OWindows[i].Width)
            and(Cursor.Y>=OWindows[i].Y)and(Cursor.Y<=OWindows[i].Y+OWindows[i].Heigth)
            and(OWindows[i].Alpha<>0)then
            begin
                 Result := True;
                 Exit;
            end;
       end;
  end;

  function DrawWindow(Title: string; X,Y,Width,Heigth: integer; Alpha: Byte): HRESULT;
  var Color: DWORD;
  begin
       Color := (Alpha shl 24) or $00FFFFFF;

       DrawSprite('ToolWindow', X,         Y, 4,       17, 0,     0, 4/64,  18/64, Color);
       DrawSprite('ToolWindow', X+4,       Y, Width-8, 17, 4/64,  0, 60/64, 18/64, Color);
       DrawSprite('ToolWindow', X+Width-4, Y, 4,       17, 60/64, 0, 1,     18/64, Color);

       DrawSprite('ToolWindow', X,         Y+17, 4, Heigth-21, 0,     17/64, 4/64, 47/64, Color);
       DrawSprite('ToolWindow', X+Width-4, Y+17, 4, Heigth-21, 60/64, 17/64, 1,    47/64, Color);

       DrawSprite('ToolWindow', X,         Y+Heigth-4, 4,       4, 0,     47/64, 4/64,  52/64, Color);
       DrawSprite('ToolWindow', X+4,       Y+Heigth-4, Width-8, 4, 4/64,  47/64, 60/64, 52/64, Color);
       DrawSprite('ToolWindow', X+Width-4, Y+Heigth-4, 4,       4, 60/64, 47/64, 1,     52/64, Color);

       OutTextEx(X+3, Y+1, -1, -1, Title, 'Tahoma', 13, 1000, False, (Alpha shl 24) or $00B39188);

       Result := S_OK;
  end;

  function OnRender: HRESULT;
  var i: Integer;
  begin
       for i := nWindows - 1 downto 0 do
       begin
            OWindows[i].Draw;
       end;
       Result := S_OK; 
  end;
  
  function WMMouseDown: HRESULT;
  var i: Integer;
  begin
       if Modal then OWindows[0].WMMouseDown else
       for i := 0 to nWindows - 1 do
       begin
            if OWindows[i].WMMouseDown then Break;
       end;
       Result := S_OK;
  end;

  function WMMouseUp: HRESULT;
  var i: integer;
  begin
       if Modal then OWindows[0].WMMouseUp else
       for i := 0 to nWindows - 1 do
       begin
            OWindows[i].WMMouseUp;
       end;
       Result := S_OK;
  end;

  function WMTimer: HRESULT;
  var i: integer;
  begin
       for i := 0 to nWindows - 1 do
       begin
            OWindows[i].Timer;
       end;
       Result := S_OK;
  end;
  
  constructor TOWindow.Create;
  begin
       FAlpha := 0;
       FVisible := False;
       FWidth := 100;
       FHeigth := 100;
       OWindows[nWindows-1].FZ := nWindows-1;
       FHandle := nHandle;
       inc(nHandle);
  end;

  constructor TOWindow.CreateEx(ATitle: string; AX,AY,AWidth,AHeigth: Integer);
  begin
       FAlpha := 0;
       FVisible := False;
       FTitle := ATitle;
       FWidth := AWidth;
       FHeigth := AHeigth;
       FX := AX;
       FY := AY;
       FZ := nWindows-1;
       FHandle := nHandle;
       inc(nHandle);
  end;

  function TOWindow.WMMouseDown: Boolean;
  begin
       Result := False;
       if (Cursor.X>=FX)and(Cursor.Y>=FY)and(Cursor.X<=FX+FWidth)and(Cursor.Y<=FY+FHeigth)then
       begin
            Result := True;
            BringToTop;
       end;
       if (Cursor.X>=X)and(Cursor.Y>=Y)and(Cursor.Y<=Y+17)then
       begin
            if ((not CanClose)and(Cursor.X<=X+Width))or
                ((CanClose)and(Cursor.X<=X+Width-17)) then
            begin
                 FDrag := True;
                 FDragStartPos := Cursor;
                 FOldPos.X := FX;
                 FOldPos.Y := FY;
            end;
       end;
  end;
  
  procedure TOWindow.WMMouseUp;
  var i: Integer; Temp: TOWindow;
  begin
       FDrag := False;
       if FCanClose then
       begin
            if (Cursor.X>=FX+FWidth-16)and(Cursor.X<=FX+FWidth-3)and(Cursor.Y>=FY+3)and(Cursor.Y<=FY+19)and(FZ=0)then
            begin
                 GuiShowWindow(FHandle, SW_HIDE);
                 if (FZ=0) then Modal := False;
                 Temp := Self;
                 for i := 0 to nWindows-2 do
                 begin
                      OWindows[i] := OWindows[i+1];
                      OWindows[i].FZ := i;
                 end;
                 OWindows[nWindows-1] := Temp;
                 OWindows[nWindows-1].FZ := nWindows-1;
            end;
       end;
       if (FZ=0)and(FVisible)and Assigned(MouseProc) then MouseProc(@Self, 0);
  end;

  procedure TOWindow.Draw;
  begin
       if FDrag then       
       begin
            FX := FOldPos.X + Cursor.X - FDragStartPos.X;
            FY := FOldPos.Y + Cursor.Y - FDragStartPos.Y;
            if FX<0 then FX := 0;
            if FY<0 then FY := 0;
            if FX+FWidth>1024 then FX := 1024 - FWidth;
            if FY+FHeigth>768 then FY := 768 - FHeigth;
       end;
       DrawWindow(FTitle,FX,FY,FWidth,FHeigth,Round(FAlpha*255));
       // Кнопка закрытия окна
       if FCanClose then
       begin
            if (Cursor.X>=FX+FWidth-16)and(Cursor.X<=FX+FWidth-3)and(Cursor.Y>=FY+3)and(Cursor.Y<=FY+19)and(FZ=0)then
                 DrawSprite('ToolWindow', FX+FWidth-16, FY+2, 13, 13, 13/64, 51/64, 27/64, 65/64, (Round(FAlpha*255) shl 24) or $00FFFFFF)
            else
                 DrawSprite('ToolWindow', FX+FWidth-16, FY+2, 13, 13, 0, 51/64, 14/64, 65/64, (Round(FAlpha*255) shl 24) or $00FFFFFF);
       end;
       // RenderProc
       if Assigned(RenderProc) then RenderProc(@Self);
  end;

  procedure TOWindow.Show(nCmdShow: Integer);
  begin
       case nCmdShow of
       SW_SHOW:
         begin
              FVisible := True;
              BringToTop;
         end;
       SW_SHOWMODAL:
         begin
              FVisible := True;
              BringToTop;
              Modal := True;
         end;
       SW_HIDE:
         begin
              FVisible := False;
              Modal := False;
         end;
       end;
  end;

  procedure TOWindow.Timer;
  begin
       if (FVisible)and(FAlpha<1) then FAlpha := Min(FAlpha + 1/7,1);
       if (not FVisible)and(FAlpha>0) then FAlpha := Max(FAlpha - 1/7,0);
       if (FZ=0)and(FVisible)and Assigned(MouseProc) then MouseProc(@Self, 1);
  end;

  procedure TOWindow.BringToTop;
  var i: Integer; Temp: TOWindow;
  begin
       Temp := Self;
       for i := FZ downto 1 do
       begin
            OWindows[i] := OWindows[i-1];
            OWindows[i].FZ := i;
       end;
       OWindows[0] := Temp;
       OWindows[0].FZ := 0;
  end;

end.
