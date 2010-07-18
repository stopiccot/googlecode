unit GuiMain;
//==============================================================================
// Unit: GuiMain.pas
// Desc: Главный Graphic User Interface (GUI) модуль
//==============================================================================
interface
{.$DEFINE DEBUGAI} //Отладака AI. Не забываем включить DEBUG в SeaBattleAI.pas :)
uses
  Windows, RenderMain, RenderFont, Game, SysUtils,
  GuiCursor, GuiSplash, GuiWindows, GuiUtils,
  SeaBattleMain, SeaBattleHighscores, SeaBattleAI; 

  function Initialize: HRESULT;
  function OnRender: HRESULT;

  function WMKeyDown(Key: Word): HRESULT;
  function WMChar(C: LongWord): HRESULT;
  function WMTimer: HRESULT;
  function WMClick: HRESULT;
  function WMMouseDown: HRESULT;

implementation
const
  WebSite = 'www.thisgamehomepage.com';
var
  Alpha           : Single = 0;
  Buttons         : array[0..3]of Single;
  // Хэндлы на окна
  AboutWindow     : THandle;
  HighWindow      : THandle;
  PlayerWindow    : THandle;
  ComputerWindow  : THandle;
  MessageBox      : THandle;
  TempWindow      : POWindow;
  // Всевозможные переменные
  MessageBoxState : Byte;
  TimeForAITurn   : Byte = 0;
  iHigh {©Apple:)}: Integer;
  HighscoreName   : String;
  CaretPos        : Byte;

//==============================================================================
// Name: ShellExecute
// Desc: Фунция необхлдтмая для того, чтобы работала гиперссылка в About окне.
//       Чтоб не юзать целый модуль ShellAPI, объявил её здесь
//==============================================================================
  function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
       Directory: PChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';

//==============================================================================
// Name: AboutWindowRenderProc & AboutWindowMouseProc
// Desc: Процедуры, отвечающие за рендер и обработку мыши About окна
//==============================================================================
  procedure AboutWindowRenderProc(OWindow: POWindow);
  begin
       // Полупрозрачный фон
       DrawSprite('ToolWindow', OWindow.X+4, OWindow.Y+17, OWindow.Width-8, OWindow.Heigth-21, 5/64, 19/64, 47/64,47/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
       // Иконка Orbital
       DrawSprite('OrbitalLogo', OWindow.X+5, OWindow.Y+18, 32, 32, 0, 0, 1, 1, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
       // Гиперссылка
       OutTextEx(OWindow.X+40, OWindow.Y+OWindow.Heigth-21, -1, -1, WebSite , 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $004651B0);
       // Текст
       OutTextEx(OWindow.X+40, OWindow.Y+20, -1, -1, '.SeaBattle v.1.0'+#10+'Orbital Technology Powered'+#10+#10+'Code        : .gear'+#10+'Graphics : .gear&Other sources', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $00909090);
  end;

  procedure AboutWindowMouseProc(OWindow: POWindow; MouseEvent: Byte);
  begin
       case MouseEvent of
       0: begin
               // Клик по гипрессылке
               if (Cursor.X>=OWindow.X+40)and(Cursor.Y>=OWindow.Y+OWindow.Heigth-21)and(Cursor.X<=OWindow.X+210)and(Cursor.Y<=OWindow.Y+OWindow.Heigth-8)
               then ShellExecute(HWND(nil), 'open', 'http://'+WebSite, nil, nil, SW_SHOW);
          end;
       1: begin
               // Меняем курсор при наводе на гиперссылку
               if (Cursor.X>=OWindow.X+40)and(Cursor.Y>=OWindow.Y+OWindow.Heigth-21)and(Cursor.X<=OWindow.X+210)and(Cursor.Y<=OWindow.Y+OWindow.Heigth-8)
               then GuiCursor.CursorType := crHand
               else GuiCursor.CursorType := crArrow;
          end;
       end;
  end;

//==============================================================================
// Name: HighWindowRenderProc
// Desc: Процедура, отвечающпя за рендер Highscores окна
//==============================================================================
  procedure HighWindowRenderProc(OWindow: POWindow);
  const c = 'ToolWindow';
  var i: integer;
  begin
       DrawSprite('ToolWindow', OWindow.X+4, OWindow.Y+17, OWindow.Width-8, OWindow.Heigth-21, 5/64, 19/64, 47/64,47/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
       for i := 0 to 14 do
       begin
            OutTextEx(OWindow.X+8, OWindow.Y+19+i*14, -1, -1, Highscores[i].Name,
                      'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*255) shl 24) or $0073726d);
            OutTextEx(OWindow.X+210, OWindow.Y+19+i*14, -1, -1, IntToStr(Highscores[i].Score),
                      'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*255) shl 24) or $0073726d);
       end;
       if GameStarted then
       begin
            DrawSprite('ToolWindow', OWindow.X+3, OWindow.Y+OWindow.Heigth-19, OWindow.Width-6, 1, 0, 0, 1,1, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
            OutTextEx(OWindow.X+6, OWindow.Y+OWindow.Heigth-18, -1, -1, 'Current game score: '+IntToStr(Score),
                      'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*255) shl 24) or $0073726d)
       end;
       if EnteringName then
       begin
            DrawSprite(c, OWindow.X+5,   OWindow.Y+18+iHigh*14,     140, 1, 0, 0, 1/64, 1/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
            DrawSprite(c, OWindow.X+5,   OWindow.Y+18+(iHigh+1)*14, 140, 1, 0, 0, 1/64, 1/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
            DrawSprite(c, OWindow.X+5,   OWindow.Y+18+iHigh*14,     1,  15, 0, 0, 1/64, 1/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
            DrawSprite(c, OWindow.X+145, OWindow.Y+18+iHigh*14,     1,  15, 0, 0, 1/64, 1/64, (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
            OutTextCaret(Owindow.X+8, OWindow.Y+19+iHigh*14, HighscoreName,
                         CaretPos, (Round(OWindow.Alpha*255) shl 24) or $0073726d);
       end;
  end;

//==============================================================================
// Name: MessageBoxRenderProc & MessageBoxMouseProc
// Desc: Процедуры, отвечающие за рендер и обработку мыши Message окна
//==============================================================================
  procedure MessageBoxRenderProc(OWindow: POWindow);
  const c = 'ToolWindow';
  var Color: DWORD;

    // Процедуры отрисовки кнопок Yes, No и OK
    procedure DrawYesButton;
    begin
         DrawSprite(c, OWindow.X+25,  OWindow.Y+50, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+25,  OWindow.Y+70, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+25,  OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+100, OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         if (Cursor.X>=OWindow.X+25)and(Cursor.X<=OWindow.X+100)and(Cursor.Y>=OWindow.Y+50)and(Cursor.Y<=OWindow.Y+70)then
         begin
              DrawSprite(c, OWindow.X+26, OWindow.Y+51, 75, 19, 5/64, 19/64, 47/64,47/64, (Round(OWindow.Alpha*125) shl 24) or $00EFEFEF);
              OutTextEx(OWindow.X+50, OWindow.Y+54, -1, -1, 'Yes','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $00B19087)
         end
         else OutTextEx(OWindow.X+50, OWindow.Y+54, -1, -1, 'Yes','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
    end;

    procedure DrawNoButton;
    begin
         DrawSprite(c, OWindow.X+110, OWindow.Y+50, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+110, OWindow.Y+70, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+110, OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+185, OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         if (Cursor.X>=OWindow.X+110)and(Cursor.X<=OWindow.X+185)and(Cursor.Y>=OWindow.Y+50)and(Cursor.Y<=OWindow.Y+70)then
         begin
              DrawSprite(c, OWindow.X+111, OWindow.Y+51, 75, 19, 5/64, 19/64, 47/64,47/64, (Round(OWindow.Alpha*125) shl 24) or $00EFEFEF);
              OutTextEx(OWindow.X+140, OWindow.Y+54, -1, -1, 'No','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $00B19087)
         end
         else OutTextEx(OWindow.X+140, OWindow.Y+54, -1, -1, 'No','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
    end;

    procedure DrawOKButton;
    begin
         DrawSprite(c, OWindow.X+67,  OWindow.Y+50, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+67,  OWindow.Y+70, 75, 1, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+67,  OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         DrawSprite(c, OWindow.X+142, OWindow.Y+50, 1, 21, 0, 0, 1/64, 1/64, Color);
         if (Cursor.X>=OWindow.X+67)and(Cursor.X<=OWindow.X+142)and(Cursor.Y>=OWindow.Y+50)and(Cursor.Y<=OWindow.Y+70)then
         begin
              DrawSprite(c, OWindow.X+68, OWindow.Y+51, 75, 19, 5/64, 19/64, 47/64,47/64, (Round(OWindow.Alpha*125) shl 24) or $00EFEFEF);
              OutTextEx(OWindow.X+100, OWindow.Y+54, -1, -1, 'OK','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $00B19087)
         end
         else OutTextEx(OWindow.X+100, OWindow.Y+54, -1, -1, 'OK','Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
    end;

  begin
       Color := (Round(OWindow.Alpha*255) shl 24) or $00FFFFFF;
       // Полупрозрачный фон
       DrawSprite(c, OWindow.X+4, OWindow.Y+17, OWindow.Width-8, OWindow.Heigth-21, 5/64, 19/64, 47/64,47/64, Color);
       // Текст
       case MessageBoxState of
       0: OutTextEx(OWindow.X+40, OWindow.Y+20, -1, -1, 'You win! One more game?', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
       1: OutTextEx(OWindow.X+10, OWindow.Y+20, -1, -1, 'Computer wins. One more game?', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
       2: OutTextEx(OWindow.X+8,  OWindow.Y+20, -1, -1, 'Sure? Current game would be lost.', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
       3: OutTextEx(OWindow.X+60, OWindow.Y+20, -1, -1, 'One more game?', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
       4: OutTextEx(OWindow.X+15,  OWindow.Y+20, -1, -1, 'Well done you made a highscore!', 'Tahoma', 13, 1000, False, (Round(OWindow.Alpha*216) shl 24) or $0082817C);
       end;
       // Кнопки
       if MessageBoxState<>4 then
       begin
            DrawYesButton;
            DrawNoButton;
       end else DrawOKButton;
  end;

  procedure MessageBoxMouseProc(OWindow: POWindow; MouseEvent: Byte);
  var Temp: POWindow;
  begin
       case MouseEvent of
       0: begin // Клик
               if not((Cursor.Y>=OWindow.Y+50)and(Cursor.Y<=OWindow.Y+70)) then Exit;
               // Yes
               if (Cursor.X>=OWindow.X+25)and(Cursor.X<=OWindow.X+100)
               and(MessageBoxState<>4)then
               begin
                    SeaBattleMain.NewGame;
                    GuiShowWindow(MessageBox, SW_HIDE);
               end;
               // No
               if (Cursor.X>=OWindow.X+110)and(Cursor.X<=OWindow.X+185)
               and(MessageBoxState<>4)then
               begin
                    case MessageBoxState of
                    0,1,3: begin
                                GuiShowWindow(PlayerWindow, SW_HIDE);
                                GuiShowWindow(ComputerWindow, SW_HIDE);
                                GameStarted := False;
                           end;
                    end;
                    GuiShowWindow(MessageBox, SW_HIDE);
               end;
               // OK
               if(Cursor.X>=OWindow.X+67)and(Cursor.X<=OWindow.X+142)
               and(MessageBoxState=4)then
               begin
                    GuiShowWindow(MessageBox, SW_HIDE);
                    GuiShowWindow(HighWindow, SW_SHOWMODAL);
                    GameStarted := False;
                    GameEnded := False;
                    EnteringName := True;
                    Temp := GuiFindWindow(HighWindow);
                    Temp.CanClose := False;
                    CaretPos := 7;
               end;
          end;
       end;
  end;

//==============================================================================
// Name: GameWindowRenderProc
// Desc: Прцедура рендера игровых полей
//==============================================================================
  procedure GameWindowRenderProc(OWindow: POWindow);
  var
    i,j,m,n,X,Y: integer;
    GameField : TGameField;
    Color     : DWORD;
    ShipColor : DWORD;
  begin
       m := -25; n := -25;
       X := OWindow.X;
       Y := OWindow.Y;
       if OWindow.Handle=PlayerWindow then GameField := SeaBattleMain.PlayerField else
                                           GameField := SeaBattleMain.ComputerField;
       // Colors
       Color := ((Round(OWindow.Alpha*255) shl 24) or $00FFFFFF);
       ShipColor := ((Round(OWindow.Alpha*255) shl 24) or $00555454);
       // Рисуем клеточки
       for i := 1 to 10 do
       begin
            for j := 1 to 10 do
            begin
                 if (Cursor.X >= X+3+(j-1)*23) and(Cursor.X < X+3+j*23)
                 and(Cursor.Y >= Y+16+(i-1)*23)and(Cursor.Y < Y+16+i*23)
                 and(OWindow.Handle = ComputerWindow)then
                 begin
                      m := X+3+(j-1)*23;
                      n := Y+16+(i-1)*23;
                 end else
                 begin
                      DrawSprite('Cell', X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 1/24, 1/24, 1, 1, Color);
                 end;
            end;
       end;
       if OWindow.Handle = ComputerWindow then
            DrawSprite('CellHover', m, n, 24, 24, 1/24, 1/24, 1, 1, Color);
       for i := 1 to 10 do
       begin
            for j := 1 to 10 do
            begin
                 {$IFDEF DEBUGAI}
                 if OWindow.Handle=PlayerWindow then
                 case AIField[i,j] of
                   Hit  : DrawSprite('Cross', X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                   Miss : DrawSprite('Dot',   X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                 end else
                 case GameField.Field[i,j] of
                   Hit  : DrawSprite('Cross', X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                   Miss : DrawSprite('Dot',   X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                 end
                 {$ELSE}
                 case GameField.Field[i,j] of
                   Hit  : DrawSprite('Cross', X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                   Miss : DrawSprite('Dot',   X+3+(j-1)*23, Y+16+(i-1)*23, 24, 24, 0, 0, 25/32, 25/32, Color);
                 end;
                 {$ENDIF}
            end;
       end;
       {$REGION ' Рисуем корабли '}
       for i := 1 to 10 do
       begin
            if (OWindow.Handle<>PlayerWindow)and(not GameField.Ships[i].Dead) then Continue;
            case GameField.Ships[i].Size of
            4: begin
                    case GameField.Ships[i].Pos of
                      Horizontal:
                        begin

                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 72/256, 0/256,  96/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X)*23,   Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 96/256, 0/256, 120/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X+1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 96/256, 0/256, 120/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X+2)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 24/256, 0/256,  48/256, 25/256, ShipColor);
                        end;
                      Vertical:
                        begin
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24,   0/256, 0/256,  24/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y)*23,   24, 24, 120/256, 0/256, 144/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y+1)*23, 24, 24, 120/256, 0/256, 144/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y+2)*23, 24, 24,  48/256, 0/256,  72/256, 25/256, ShipColor);
                        end;
                    end;
               end;
            3: begin
                    case GameField.Ships[i].Pos of
                      Horizontal:
                        begin
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 72/256, 0/256,  96/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X)*23,   Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 96/256, 0/256, 120/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X+1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 24/256, 0/256,  48/256, 25/256, ShipColor);
                        end;
                      Vertical:
                        begin
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24,   0/256, 0/256,  24/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y)*23,   24, 24, 120/256, 0/256, 144/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y+1)*23, 24, 24,  48/256, 0/256,  72/256, 25/256, ShipColor);
                        end;
                    end;
               end;
            2: begin
                    case GameField.Ships[i].Pos of
                      Horizontal:
                        begin
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 72/256, 0/256, 96/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X)*23,   Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 24/256, 0/256, 48/256, 25/256, ShipColor);
                        end;
                      Vertical:
                        begin
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24,  0/256, 0/256, 24/256, 25/256, ShipColor);
                             DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y)*23,   24, 24, 48/256, 0/256, 72/256, 25/256, ShipColor);
                        end;
                    end;
               end;
            1: begin
                    DrawSprite('Ship', X+3+(GameField.Ships[i].X-1)*23, Y+16+(GameField.Ships[i].Y-1)*23, 24, 24, 144/256, 0/256, 169/256, 25/256, ShipColor);
               end;
            end;
       end;
       {$ENDREGION}
  end;

//==============================================================================
// Name: ComputerWindowMouseProc
// Desc: Обработка кликов мышки по игровому полю компьютера
//==============================================================================
  procedure ComputerWindowMouseProc(OWindow: POWindow; MouseEvent: Byte);
  var
    X,Y: integer;
  begin
       if ComputerWins then Exit;
       case MouseEvent of
       0: begin
               X := Cursor.X-OWindow.X-3; if X>=0 then X := (X div 23) + 1;
               Y := Cursor.Y-OWindow.Y-16;if Y>=0 then Y := (Y div 23) + 1;
               if (X>0)and(X<11)and(Y>0)and(Y<11)and(Turn=0)and(not GameEnded)
               and(ComputerField.Field[Y,X]=Clean)then
               begin
                    // Стреляем
                    if (Shoot(ComputerField, X, Y)=0)then
                    begin
                         // Промах
                         Turn := 1;
                         TimeForAITurn := 0;
                         ScoreDec;
                    end else
                    begin
                         if PlayerWins then
                         begin
                              iHigh := NewHighscore;
                              if iHigh<>-1 then
                              begin
                                   HighscoreName := '.Player';
                                   MessageBoxState := 4;
                              end else MessageBoxState := 0;
                              GuiShowWindow(MessageBox, SW_SHOWMODAL);
                         end else ScoreAdd;
                    end;
               end;
          end;
       1: begin
               // Просто движение мышки не обрабатывается
          end;
       end;
  end;

//==============================================================================
// Name: ComputerWindowMouseProc
// Desc: Обработка кликов мышки по игровому полю компьютера
//==============================================================================
  function Initialize: HRESULT;
  begin
       {$REGION ' Загружаем текстуры '}
       LoadTextureFromFile('orbital_1',   'textures\orbital_1.jpg', 0);
       LoadTextureFromFile('orbital_2',   'textures\orbital_2.jpg', 0);
       LoadTextureFromFile('orbital_3',   'textures\orbital_3.jpg', 0);
       LoadTextureFromFile('ToolWindow',  'textures\ToolWindow.tga', 0);
       LoadTextureFromFile('Cell',        'textures\Cell.tga', 0);
       LoadTextureFromFile('CellHover',   'textures\CellHover.tga', 0);
       LoadTextureFromFile('Cross',       'textures\Cross.tga', 0);
       LoadTextureFromFile('Dot',         'textures\Dot.tga', 0);
       LoadTextureFromFile('Ship',        'textures\Ship.tga', 0);
       LoadTextureFromFile('Warning',     'textures\Warning.png', 0);
       LoadTextureFromFile('Info',        'textures\Info.png', 0);
       LoadTextureFromFile('Success',     'textures\Success.png', 0);
       LoadTextureFromFile('NewGame',     'textures\NewGame.tga', 0);
       LoadTextureFromFile('Highscores',  'textures\Highscores.tga', 0);
       LoadTextureFromFile('About',       'textures\About.tga', 0);
       LoadTextureFromFile('OrbitalLogo', 'textures\OrbitalLogo.png', 0);
       LoadTextureFromFile('Quit',        'textures\Quit.tga', 0);
       {$ENDREGION}

       // Логотип Game Developer Contest
       if FAILED(GuiSplash.Initialize) then begin Result := E_FAIL; Exit; end;

       // Инициализируем курсор
       if FAILED(GuiCursor.Initialize) then begin Result := E_FAIL; Exit; end;

       // Создаем окошки
       AboutWindow := GuiCreateWindowEx('About', 100, 170, 237, 125,
            @AboutWindowRenderProc, @AboutWindowMouseProc);
       TempWindow := GuiFindWindow(AboutWindow);
       TempWindow.CanClose := True;

       HighWindow := GuiCreateWindowEx('Highscores', 590, 300, 237, 250,@HighWindowRenderProc, nil);
       TempWindow := GuiFindWindow(HighWindow);
       TempWindow.CanClose := True;

       PlayerWindow := GuiCreateWindowEx('Player ships', 100, 300, 237, 250, @GameWindowRenderProc, nil);
       ComputerWindow := GuiCreateWindowEx('Enemy ships', 345, 300, 237, 250,
            @GameWindowRenderProc, @ComputerWindowMouseProc);

       MessageBox := GuiCreateWindowEx('', 407, 339, 210, 90, @MessageBoxRenderProc, @MessageBoxMouseProc);

       LoadTextureFromFile('Test2', 'textures\Test2.tga', 0);
       Result := S_OK;
  end;

//==============================================================================
// Name: OnRender
// Desc: Рендер
//==============================================================================
  function OnRender: HRESULT;
  var Color: DWORD;{$IFDEF DEBUGAI}i: integer;{$ENDIF}
  begin
       Color := (Round(Alpha*2.55) shl 24) or $00FFFFFF;
       // Рисем фоновый рисунок
       DrawSprite('orbital_1', 768, 0,   256, 256, 4e-3, 0,    1, 1, Color);
       DrawSprite('orbital_2', 0,   0,   256, 128, 0,    0,    1, 1, Color);
       DrawSprite('orbital_3', 0,   128, 512, 512, 0,    2e-3, 1, 1, Color);

       {$IFDEF DEBUGAI}
       for i := 0 to 49 do
          OutTextEx(800, 200+11*i, -1, -1,AILog[i],'Tahoma', 13, 1000, False, $FF000000);
       {$ENDIF}

       {$REGION ' Кнопки меню '}
       Color := (Round(Alpha*2.55*(1-Buttons[0])) shl 24) or $0082817C;
       DrawSprite('NewGame',    300, 555, 128,  32, 0,    0,    1, 1, Color);
       Color := (Round(Alpha*2.55*(Buttons[0])) shl 24)   or $00B19087;
       DrawSprite('NewGame',    300, 555, 128,  32, 0,    0,    1, 1, Color);

       Color := (Round(Alpha*2.55*(1-Buttons[1])) shl 24) or $0082817C;
       DrawSprite('Highscores', 425, 555, 128,  32, 0,    0,    1, 1, Color);
       Color := (Round(Alpha*2.55*(Buttons[1])) shl 24)   or $00B19087;
       DrawSprite('Highscores', 425, 555, 128,  32, 0,    0,    1, 1, Color);

       Color := (Round(Alpha*2.55*(1-Buttons[2])) shl 24) or $0082817C;
       DrawSprite('About',      555, 555, 128,  32, 0,    0,    1, 1, Color);
       Color := (Round(Alpha*2.55*(Buttons[2])) shl 24)   or $00B19087;
       DrawSprite('About',      555, 555, 128,  32, 0,    0,    1, 1, Color);

       Color := (Round(Alpha*2.55*(1-Buttons[3])) shl 24) or $0082817C;
       DrawSprite('Quit',       640, 555,  64,  32, 0,    0,    1, 1, Color);
       Color := (Round(Alpha*2.55*(Buttons[3])) shl 24)   or $00B19087;
       DrawSprite('Quit',       640, 555,  64,  32, 0,    0,    1, 1, Color);
       {$ENDREGION}

       GuiSplash.OnRender;
       GuiWindows.OnRender;

       // Рисуем курсор
       if FAILED(GuiCursor.OnRender) then
       begin
            Result := E_FAIL;
            Exit;
       end;
       Result := S_OK;
  end;

//==============================================================================
// Name: WMKeyDown & WMChar
// Desc: Обработка нажатий клавиш
//==============================================================================
  function WMKeyDown(Key: Word): HRESULT;
  var Temp: POWindow;
  begin
       GuiSplash.WMKeyDown(Key);
       case Key of
        8: begin // Backspace
                Delete(HighscoreName, CaretPos, 1);
                if CaretPos>0 then Dec(CaretPos);
           end;
       13: begin // Enter
                if EnteringName then
                begin
                     GuiShowWindow(HighWindow, SW_HIDE);
                     GuiShowWindow(HighWindow, SW_SHOW);
                     Temp := GuiFindWindow(HighWindow);
                     Temp.CanClose := True;
                     EnteringName := False;
                     MessageBoxState := 3;
                     GuiShowWindow(MessageBox, SW_SHOWMODAL);
                     Highscores[iHigh].Name := HighscoreName;
                     SeaBattleHighscores.SaveHighscores;
                end;
           end;
       35: begin // End
                CaretPos := Length(HighscoreName);
           end;
       36: begin // Home
                CaretPos := 0;
           end;
       37: begin // <-
                if CaretPos>0 then Dec(CaretPos);
           end;
       39: begin // ->
                if CaretPos<Length(HighscoreName) then Inc(CaretPos);
           end;
       46: begin // Delete
                Delete(HighscoreName, CaretPos+1, 1);
           end;
       end;
       Result := S_OK;
  end;

  function WMChar(C: LongWord): HRESULT;
  begin
       if (EnteringName)and(C<>8)and(Length(HighscoreName)<12) then
       begin
            Insert(Chr(C), HighscoreName, CaretPos+1);
            Inc(CaretPos);
       end;
       Result := S_OK;
  end;
//==============================================================================
// Name: WMTimer
// Desc: Вызывается 40 раз в секунду
//==============================================================================
  function WMTimer: HRESULT;
  var i: integer;
  begin
       Result := S_OK;
       GuiSplash.WMTimer;
       if Game.GamePos = gpSplash then Exit;
       
       GuiWindows.WMTimer;

       // "Потухание" кнопок
       for i := 0 to 3 do Buttons[i] := Max(Buttons[i]-0.1,0);
       // Появление меню
       if Alpha<100 then Alpha := Alpha + 10;
       // "Зажигание" кнопок при наводе на них мышкой
       if (not GuiMouseOverWindow)and(not GuiWindows.Modal) then
       begin
            if (Cursor.Y>=554)and(Cursor.Y<=580)and(not GuiMouseOverWindow) then
            begin
                      if (Cursor.X>=300)and(Cursor.X<=418) then Buttons[0] := Min(Buttons[0]+0.15,1)
                 else if (Cursor.X>=425)and(Cursor.X<=545) then Buttons[1] := Min(Buttons[1]+0.15,1)
                 else if (Cursor.X>=555)and(Cursor.X<=625) then Buttons[2] := Min(Buttons[2]+0.15,1)
                 else if (Cursor.X>=640)and(Cursor.X<=690) then Buttons[3] := Min(Buttons[3]+0.15,1);
            end;
       end;

       // Ход компьютера
       if(Turn=1)and(not GameEnded)then
       begin
            if (TimeForAITurn=0)then
            begin
                 if not SeaBattleAI.ComputerTurn then Turn := 0 else
                 begin
                      if ComputerWins then
                      begin
                           MessageBoxState := 1;
                           GuiShowWindow(MessageBox, SW_SHOWMODAL);
                           GameEnded := True;
                      end else TimeForAITurn := 20;
                 end;
            end else Dec(TimeForAITurn);
       end;
  end;

//==============================================================================
// Name: WMClick
// Desc: Обработка отпускания кнопки мыши
//==============================================================================
  function WMClick: HRESULT;
  begin
       GuiSplash.WMClick;
       GuiWindows.WMMouseUp;
       if Game.GamePos <> gpSplash then
       begin
            if (Cursor.Y>=554)and(Cursor.Y<=580)and(not GuiMouseOverWindow)
            and(not GuiWindows.Modal) then
            begin
                 if (Cursor.X>=300)and(Cursor.X<=418) then
                 begin
                      if GameStarted then
                      begin
                           MessageBoxState := 2;
                           GuiShowWindow(MessageBox, SW_SHOWMODAL);
                      end else
                      begin
                           GuiShowWindow(PlayerWindow, SW_SHOW);
                           GuiShowWindow(ComputerWindow, SW_SHOW);
                           SeaBattleMain.NewGame;
                      end;
                 end;
                 if (Cursor.X>=425)and(Cursor.X<=545) then
                 begin
                      GuiShowWindow(HighWindow, SW_SHOW);
                 end;
                 if (Cursor.X>=555)and(Cursor.X<=625) then
                 begin
                      GuiShowWindow(AboutWindow, SW_SHOW);
                 end;
                 if (Cursor.X>=640)and(Cursor.X<=690) then Game.ShutDown := True;
            end;
       end;
       Result := S_OK;
  end;

//==============================================================================
// Name: WMMouseDown
// Desc: Обработка нажатия кнопки мыши
//==============================================================================
  function WMMouseDown: HRESULT;
  begin
       GuiWindows.WMMouseDown;
       Result := S_OK;
  end;

end.
