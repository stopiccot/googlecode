unit GuiMain;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

//==============================================================================
// Unit: GuiMain.pas
// Desc: Главный GUI(Graphical User Interface) модуль.
//       Как мне показалось код в итоге получился некрасивым. Извиняйте... просто
//       времени было маловато. Хоть как есть. :)
//==============================================================================
interface
uses
  Windows, SysUtils, WinWindow, GameMain,
  GuiSplash, GuiComments, GuiCursor,
  RenderMain, RenderTextures, RenderPostProcess, RenderEffects, RenderFont, Render2D,
  SokobanLevel;

  function DrawWindow(X,Y,Width,Heigth: Integer; Color: DWORD = $301e1f19): HRESULT;
  procedure Initialize;
  procedure Render;
  procedure Timer;
  procedure WMMouseDown;
  procedure ScrollUp;
  procedure ScrollDown;
  
const
  mpSplash      = 0;
  mpMainMenu    = 1;
  mpSelectLevel = 2;
  mpAbout       = 3;
  mpGame        = 4;
  mpComplete    = 5;

var
  MenuPos  : Byte = mpSplash;

  maBack        : Single = 0;
  maUndo        : Single = 0;
  maSelectLevel : Single = 0;
  maAbout       : Single = 0;
  maGame        : Single = 0;
  maComplete    : Single = 0;
  GameStarted   : Boolean = False;

  Alpha    : Single = 0;
  A        : Single = 0;
  m,n,j,_j: integer;
implementation
//==============================================================================
// Name: ShellExecute & Hyperlink
// Desc: Фунция необхлдтмая для того, чтобы работала гиперссылка в About окне.
//       Чтоб не юзать целый модуль ShellAPI, объявил её здесь. А Hyperlink
//       просто вспомогательная функция для удобства.
//==============================================================================
  function ShellExecute(hWnd: HWND; Operation, FileName, Parameters,
       Directory: PChar; ShowCmd: Integer): HINST; stdcall; external 'shell32.dll' name 'ShellExecuteA';

  procedure Hyperlink(Link: PChar); inline;
  begin
       Windows.ShowWindow(WinWindow.Handle, SW_HIDE);
       ShellExecute(HWND(nil), 'open', Link, nil, nil, SW_SHOW);
  end;
//==============================================================================
// Name: _Inc & _Dec
// Desc: "Улучшенные" варианты процедур Inc и Dec."Улучшение" довольно простое:)
//==============================================================================
  {$REGION ' ... '}
  procedure _Inc(var S: Single; Step, Max: Single); overload;
  begin
       S := S + Step;
       if S > Max then S := Max;
  end;

  procedure _Inc(var I: Integer; Step, Max: Integer); overload;
  begin
       I := I + Step;
       if I > Max then I := Max;
  end;

  procedure _Dec(var S: Single; Step, Min: Single); overload;
  begin
       S := S - Step;
       if S < Min then S := Min
  end;

  procedure _Dec(var I: Integer; Step, Min: Integer); overload;
  begin
       I := I - Step;
       if I < Min then I := Min
  end;
  {$ENDREGION}

//==============================================================================
// Name: DrawWindow
// Desc: Рисует серый полупрозрачный прямоугольник с закруглёнными краями 
//==============================================================================
  function DrawWindow(X,Y,Width,Heigth: Integer; Color: DWORD = $301e1f19): HRESULT;
  const N = 'Shadow';
  begin
       DrawSpriteEx(N, X,         Y,     7,        7,     0,    0,   8/32,  8/32, Color);
       DrawSpriteEx(N, X+7,       Y,     Width-14, 7,  8/32,    0,  24/32,  8/32, Color);
       DrawSpriteEx(N, X+Width-7,    Y,     7,     7, 24/32,    0,  33/32,  8/32, Color);
       DrawSpriteEx(N, X,     Y+7,     7,  Heigth-14,     0,  8/32,  8/32, 24/32, Color);
       DrawSpriteEx(N, X+7, Y+7, Width-14, Heigth-14,  8/32,  8/32, 24/32, 24/32, Color);
       DrawSpriteEx(N, X+Width-7, Y+7, 7,  Heigth-14, 24/32,  8/32, 33/32, 24/32, Color);
       DrawSpriteEx(N, X, Y+Heigth-7, 7,           7,     0, 24/32,  8/32, 33/32, Color);
       DrawSpriteEx(N, X+7, Y+Heigth-7, Width-14,  7,  8/32, 24/32, 24/32, 33/32, Color);
       DrawSpriteEx(N, X+Width-7, Y+Heigth-7,   7, 7, 24/32, 24/32, 33/32, 33/32, Color);
       Result := S_OK;
  end;

//==============================================================================
// Name: Initialize
// Desc: Не поверите! Инициализация :)
//==============================================================================
  procedure Initialize;
  begin
       if PS14Avalible then Alpha := 40;

       if PS20Avalible then CreateRenderTargetTexture('AboutRT', 512, 512);
       if FAILED(LoadEffectFromFile('2d','effects\2d.fx'))then
       begin
            GameShutDown := True;
       end;

       GuiSplash.Initialize;
       GuiComments.Initialize;
       GuiCursor.Initialize;
       SokobanLevel.Initialize;
  end;

//==============================================================================
// Name: RenderMainMenuButtons
// Desc: Рисует кнопки главного меню
//==============================================================================
  procedure RenderMainMenuButtons;
  var Color,y: DWORD; i: Integer;
  begin
       Color := (Round(maBack*255) shl 24) or $FFFFFF;
       DrawSprite('Back', 728, 523, 64, 32, Color);

       i := Round(maUndo*255-C*170); if i<0 then i := 0;
       Color := (i shl 24) or $FFFFFF;
       DrawSprite('Undo', 728, 523, 64, 32, Color);

       if PS14Avalible then
            Color := (Round((Alpha-40)/60*255) shl 24) or $00FFFFFF
       else
            Color := (Round(Alpha*255/100) shl 24) or $00FFFFFF;
       DrawSprite('NewGame',      728, 555, 128, 32, Color);
       DrawSprite('About',        728, 577, 128, 32, Color);
       DrawSprite('Quit',         728, 603,  64, 32, Color);

       // Точка при наведении на кнопку
       y := 0;
       if (Cursor.X>=730)and(Cursor.X<=791)and(Cursor.Y>=525)and(Cursor.Y<=541)
       and((MenuPos=mpAbout)or(MenuPos=mpSelectLevel))then y := 537;
       if (Cursor.X>=730)and(Cursor.X<=791)and(Cursor.Y>=525)and(Cursor.Y<=541)
       and(MenuPos=mpGame)and(C<0.3)then y := 537;
       if (Cursor.X>=729)and(Cursor.X<=852)and(Cursor.Y>=556)and(Cursor.Y<=575)then y := 564;
       if (Cursor.X>=729)and(Cursor.X<=798)and(Cursor.Y>=578)and(Cursor.Y<=599)then y := 591;
       if (Cursor.X>=729)and(Cursor.X<=772)and(Cursor.Y>=604)and(Cursor.Y<=630)then y := 617;
       if y<>0 then DrawSprite('Dot', 719, y,  16, 16, Color);
  end;

//==============================================================================
// Name: RenderAboutScreen
// Desc: Рендер About меню
//==============================================================================
  procedure RenderAboutScreen;
  var
    Y: DWORD;
    TextColor: DWORD;
    HyperColor: DWORD;
  begin
       // Вода
       if PS20Avalible then
       begin
            SetRenderTexture('AboutRT');
            DrawSpriteEx('RenderTexture',0,0,1000,600,177/1024,177/768,677/1024,577/768,$FFFFFFFF,'Blur');
            SetRenderTexture('RenderTexture');
            DrawSpriteEx('AboutRT',177,177,500,400,0,0,500/512,400/512,(Round(255*maAbout*maAbout*maAbout) shl 24) or $00FFFFFF,'Normal');
       end;
       // Окошко
       DrawWindow(177, 177, 500, 400, (Round(48*maAbout) shl 24) or $001e1f19);
       // Надпись sokoban
       DrawSprite('Sokoban', 309, 177, 256, 64, (Round(255*maAbout) shl 24) or $00FFFFFF);

       TextColor := (Round(255*maAbout) shl 24) or $EFEFEF;
       HyperColor := (Round(maAbout*216) shl 24) or $4651B0;
       // Версия
       OutTextEx(672, 561, -1, -1, 'build '+GameVersion, 'Tahoma', 15, True, False, TextColor, 2);
       // Текст
       OutTextEx(250, 250, -1, -1, 'Orbital Technology 2.0 Powered', 'Tahoma', 15, True, False, TextColor);
       DrawSpriteEx('Box',248,300,425,1,0,0,1/32,1/32, TextColor, $EFEFEF, TextColor, $EFEFEF);
       OutTextEx(250, 301, -1, -1, 'Game was made by gear. Because I have neither ICQ', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(250, 316, -1, -1, 'nor completely made website you still can contact', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(250, 331, -1, -1, 'me only by my e-mail - ho', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(392, 331, -1, -1, 'hoziaistvennoe@list.ru', 'Tahoma', 15, True, False, HyperColor);
       DrawSpriteEx('Box',248,388,425,1,0,0,1/32,1/32, TextColor, $EFEFEF, TextColor, $EFEFEF);
       OutTextEx(250, 390, -1, -1, 'Game was made for the game developing contest', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(250, 405, -1, -1, 'hosted by', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(316, 405, -1, -1, 'code.darthman.com', 'Tahoma', 15, True, False, HyperColor);
       DrawSpriteEx('Box',248,437,425,1,0,0,1/32,1/32, TextColor, $EFEFEF, TextColor, $EFEFEF);
       OutTextEx(250, 440, -1, -1, 'Thanks to', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(315, 440, -1, -1, 'deviantart.com', 'Tahoma', 15, True, False, HyperColor);
       OutTextEx(413, 440, -1, -1, 'for used graphics. Thanks to my', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(250, 455, -1, -1, 'only tester - g', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(330, 455, -1, -1, 'grouzd)ev', 'Tahoma', 15, True, False, HyperColor);
       OutTextEx(392, 455, -1, -1, '. Also thanks to Nullsoft, Borland and', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(494, 455, -1, -1, 'Nullsoft', 'Tahoma', 15, True, False, HyperColor);
       OutTextEx(549, 455, -1, -1, 'Borland', 'Tahoma', 15, True, False, HyperColor);
       OutTextEx(250, 470, -1, -1, 'Adobe', 'Tahoma', 15, True, False, HyperColor);
       OutTextEx(294, 470, -1, -1, 'for their programs.', 'Tahoma', 15, True, False, TextColor);
       DrawSpriteEx('Box',248,507,425,1,0,0,1/32,1/32, TextColor, $EFEFEF, TextColor, $EFEFEF);
       OutTextEx(250, 509, -1, -1, '©', 'Tahoma', 16, True, False, TextColor);
       OutTextEx(264, 510, -1, -1, '2006 Gear Games', 'Tahoma', 15, True, False, TextColor);
       OutTextEx(250, 525, -1, -1, 'All rights reserved', 'Tahoma', 15, True, False, TextColor);
       // Логотип
       if maAbout = 1 then
       begin
            DrawSprite('OrbitalLogo',168,168,64,64,$FFFFFFFF);
       end else
       begin
            if MenuPos = mpAbout then
            begin
                 Y := Round(45.2548339959*Sin(3/4*Pi*maAbout));
                 DrawSpriteEx('OrbitalLogo',200-Y,200-Y,2*Y,2*Y,0,0,1,1,$FFFFFFFF,'Angle');
            end else
                 DrawSprite('OrbitalLogo',168,168,64,64,(Round(255*maAbout) shl 24) or $00FFFFFF);
       end;
       // Курсор на гиперссылках
       CursorType := crArrow;
       if(Cursor.X>=392)and(Cursor.X<=528)and(Cursor.Y>=333)and(Cursor.Y<=343)then CursorType := crHand else
       if(Cursor.X>=316)and(Cursor.X<=437)and(Cursor.Y>=407)and(Cursor.Y<=417)then CursorType := crHand else
       if(Cursor.X>=315)and(Cursor.X<=407)and(Cursor.Y>=442)and(Cursor.Y<=452)then CursorType := crHand else
       if(Cursor.X>=330)and(Cursor.X<=391)and(Cursor.Y>=457)and(Cursor.Y<=469)then CursorType := crHand else
       if(Cursor.X>=494)and(Cursor.X<=540)and(Cursor.Y>=457)and(Cursor.Y<=467)then CursorType := crHand else
       if(Cursor.X>=549)and(Cursor.X<=595)and(Cursor.Y>=457)and(Cursor.Y<=467)then CursorType := crHand else
       if(Cursor.X>=250)and(Cursor.X<=289)and(Cursor.Y>=472)and(Cursor.Y<=482)then CursorType := crHand;
  end;

//==============================================================================
// Name: RenderSelectMenu
// Desc: Рендер Select меню
//==============================================================================
  procedure RenderSelectMenu;
  var i,x: integer; Color: DWORD;
  begin
       for i := 0 to SokobanLevel.nLevels-1 do
       begin
            x := 140+40*i-j;
            if (x<90)or(x>635) then Continue;
            if (Cursor.X>=300)and(Cursor.X<=700)and(Cursor.Y>=x)and(Cursor.Y<=x+25)then
            _Inc(Levels[i].Glow,20,100) else _Dec(Levels[i].Glow,3,0);
            // Вычисляем цвет
            Color :=  ($19 + Round(Levels[i].Glow/4));
            Color := (($1F + Round(Levels[i].Glow/4)) shl 8) or Color;
            Color := (($1E + Round(Levels[i].Glow/4)) shl 16) or Color;
            Color := ((Round(maSelectLevel*(12 + 0.3*Levels[i].Glow))) shl 24) or Color;
            // Фон
            DrawSpriteEx('MenuItem',300,x,400,35,0,0,1,1,Color,'Angle');
            // Текст
            OutTextEx(303, x+1, -1, -1, Levels[i].Name, 'Luicida Console', 23, True, False, $FFFFFFFF);
            OutTextEx(305, x+20, -1, -1, Levels[i].FileName, 'Tahoma', 13, False, False, $FF555555);
            //
            if Levels[i].Completed then
            DrawSpriteEx('Completed',671,x+5,24,24,0,0,48/64,48/64,$FFFFFFFF);
       end;
       // Fade out & fade in
       DrawSpriteEx('Grid', 295, 115, 410, 35, 0, 0, 410/8, 35/8, $FFFFFFFF, $FFFFFFFF, $00FFFFFF, $00FFFFFF, 'Grid');
       DrawSpriteEx('Grid', 297,  80, 410, 35, 0, 0, 410/8, 35/8, $FFFFFFFF, 'Grid');
       DrawSpriteEx('Grid', 295, 600, 410, 35, 0, 0, 410/8, 35/8, $00FFFFFF, $00FFFFFF, $FFFFFFFF, $FFFFFFFF, 'Grid');
       DrawSpriteEx('Grid', 293, 635, 410, 35, 0, 0, 410/8, 35/8, $FFFFFFFF, 'Grid');
  end;

//==============================================================================
// Name: RenderLevelComleteScreen
// Desc: ...
//==============================================================================
  procedure RenderLevelComleteScreen;
  var Y: DWORD;
  begin
       DrawWindow(250, 334, Round(250*maComplete), 35, (Round(48*maComplete) shl 24) or $1e1f19);
       if maComplete = 1 then
            DrawSprite('Completed', 237, 328, 64, 64, (Round(255*maComplete) shl 24) or $FFFFFF)
       else
       begin
            Y := Round(30.1698893306*Sin(3/4*Pi*maComplete));
            DrawSpriteEx('Completed', 261-Y, 352-Y, 2*Y, 2*Y, 0, 0, 48/64, 48/64, (Round(255*maComplete) shl 24) or $FFFFFF, 'Angle');
       end;
       OutTextEx(250,336,250,-1,'Congratulations!'+#10+' You''ve comleted this level.','Tahoma',16,True,False,(Round(255*maComplete) shl 24) or $EFEFEF,1);
  end;

//==============================================================================
// Name: Render
// Desc: Тоже не поверите! Рендер
//==============================================================================
  procedure Render;
  var Color: DWORD; Technique: String;
  begin
       // Рисуем сеточку
       DrawSpriteEx('Grid', 0, 0, 1024, 768, 0, 0, 1024/8, 768/8, $FFFFFFFF, 'Grid');

       // Рисуем фоновый рисунок, и если аппаратура позволяет, то рисуем с шейдерами
       if PS14Avalible then Technique := 'Test' else Technique := 'Normal';
       Color := (Round(Alpha*2.55) shl 24) or $00FFFFFF;
       DrawSpriteEx('orbital_1', 768, 0, 256, 256, 0, 0, 1, 1, Color, Technique);
       DrawSpriteEx('orbital_2', 0,   0, 256, 128, 0, 0, 1, 1, Color, Technique);
       DrawSpriteEx('orbital_3', 0, 128, 512, 512, 0, 0, 1, 1, Color, Technique);

       // Кнопки меню
       RenderMainMenuButtons;

       // Если видеокарточка старовата, то выводим предупреждения, что мол так и
       // так такие-то шейдеры не поддерживаются и некоторые графические навороты
       // отключены
       if not PS14Avalible then
       begin
            DrawSprite('Warning',754,748,32,32,$FFFFFFFF);
            OutTextEx(776,750,-1,-1,'Your videocard doesn''t support pixel shaders 1.4','Tahoma',12,True,False,$AA000000);
       end else
       if not PS20Avalible then
       begin
            DrawSprite('Warning',754,748,32,32,$FFFFFFFF);
            OutTextEx(776,750,-1,-1,'Your videocard doesn''t support pixel shaders 2.0','Tahoma',12,True,False,$AA000000);
       end;

       GuiSplash.OnRender;
       GuiComments.OnRender;

       if maGame > 0.1 then SokobanLevel.RenderLevel(maGame);
       if maAbout > 0.1 then RenderAboutScreen;
       if maSelectLevel > 0.1 then RenderSelectMenu;
       if maComplete > 0.1 then RenderLevelComleteScreen;

       GuiCursor.OnRender;
  end;

//==============================================================================
// Name: Timer
// Desc: Вызывается сколько-то там раз в секунду
//==============================================================================
  procedure Timer;     
  begin
       if MenuPos<>mpSplash then
       begin
            if Alpha<100 then
            begin
                 if PS14Avalible then _Inc(Alpha,1.25,100) else _Inc(Alpha,2.5,100);
            end;
       end;
       case MenuPos of
       mpMainMenu:
         begin
              _Dec(maBack, 0.075, 0);
              _Dec(maSelectLevel, 0.075, 0);
              _Dec(maAbout, 0.075, 0);
              _Dec(maUndo, 0.075, 0);
              _Dec(maGame, 0.075, 0);
              _Dec(maComplete, 0.075, 0);
         end;
       mpSelectLevel:
         begin
              _Inc(maBack, 0.05, 1);
              _Dec(maAbout, 0.075, 0);
              _Dec(maUndo, 0.075, 0);
              _Dec(maGame, 0.075, 0);
              if maAbout<0.1 then _Inc(maSelectLevel, 0.05, 1);
              
              // Скроллинг
              if j <> _j then
              if j < _j then Inc(j,Trunc((_j-j)/7+0.5)) else Dec(j,Trunc((j-_j)/7+0.5));
         end;
       mpAbout:
         begin
              _Inc(maBack, 0.05, 1);
              _Dec(maSelectLevel, 0.075, 0);
              _Dec(maUndo, 0.075, 0);
              if maSelectLevel<0.1 then  _Inc(maAbout, 0.05, 1);
         end;
       mpGame:
         begin
              _Inc(maGame, 0.05, 1);
              _Inc(maUndo, 0.05, 1);
              _Dec(maBack, 0.075, 0);
              _Dec(maAbout, 0.075, 0);
              _Dec(maSelectLevel, 0.075, 0);
         end;
       mpComplete:
         begin
              _Inc(maComplete, 0.05, 1);
              _Dec(maGame, 0.075, 0);
         end;
       end;
       GuiSplash.WMTimer;
       GuiComments.Timer;
       SokobanLevel.Timer;
  end;

//==============================================================================
// Name: WMMouseDown
// Desc: Клик мышки
//==============================================================================
  procedure WMMouseDown;
  var i,x: integer;
  begin
       GuiSplash.WMClick;
       GuiComments.WMMouseDown;
       // Выбираем уровень
       case MenuPos of
         mpAbout:
         begin
              if(Cursor.X>=392)and(Cursor.X<=528)and(Cursor.Y>=333)and(Cursor.Y<=343)then
                 Hyperlink('mailto:hoziaistvennoe@list.ru') else
              if(Cursor.X>=316)and(Cursor.X<=437)and(Cursor.Y>=407)and(Cursor.Y<=417)then
                 Hyperlink('http://code.darthman.com') else
              if(Cursor.X>=315)and(Cursor.X<=407)and(Cursor.Y>=442)and(Cursor.Y<=452)then
                 Hyperlink('http://www.deviantart.com') else
              if(Cursor.X>=330)and(Cursor.X<=391)and(Cursor.Y>=457)and(Cursor.Y<=469)then
                 Hyperlink('http://www.grouzdev.nm.ru') else
              if(Cursor.X>=494)and(Cursor.X<=540)and(Cursor.Y>=457)and(Cursor.Y<=467)then
                 Hyperlink('http://www.nullsoft.com') else
              if(Cursor.X>=549)and(Cursor.X<=595)and(Cursor.Y>=457)and(Cursor.Y<=467)then
                 Hyperlink('http://www.borland.com') else
              if(Cursor.X>=250)and(Cursor.X<=289)and(Cursor.Y>=472)and(Cursor.Y<=482)then
                 Hyperlink('http://www.adobe.com');
         end;
         mpSelectLevel:
         begin
              for i := 0 to nLevels - 1 do
              begin
                   x := 140+40*i-j;
                   if (x<90)or(x>635)then Continue;
                   if (Cursor.X>=300)and(Cursor.X<=700)and(Cursor.Y>=x)and(Cursor.Y<=x+25)then
                   begin
                        SokobanLevel.LoadLevel(i);
                        GameStarted := True;
                        MenuPos := mpGame;
                        Break;
                   end;
              end;
         end;
         mpComplete:
         begin
              GameStarted := False;
              MenuPos := mpMainMenu;
              Exit;
         end;
       end;
       // Back
       if (Cursor.X>=730)and(Cursor.X<=791)and(Cursor.Y>=525)and(Cursor.Y<=541)then
       begin
            if MenuPos=mpSelectLevel then MenuPos := mpMainMenu;
            if MenuPos=mpAbout then if GameStarted then MenuPos := mpGame else MenuPos := mpMainMenu;
            if MenuPos=mpGame  then SokobanLevel.Undo;
       end;
       // New Game
       if (Cursor.X>=729)and(Cursor.X<=852)and(Cursor.Y>=556)and(Cursor.Y<=575)then
       begin
            if MenuPos <> mpSelectLevel then
            begin
                 GameStarted := False;
                 SokobanLevel.FindAvalibleLevels;
                 MenuPos := mpSelectLevel;
                 maSelectLevel := 0;
            end;
       end;
       // About
       if (Cursor.X>=729)and(Cursor.X<=798)and(Cursor.Y>=578)and(Cursor.Y<=599)then
       begin
            if MenuPos <> mpAbout then
            begin
                 MenuPos := mpAbout;
                 maAbout := 0;
            end;
       end;
       // Quit
       if (Cursor.X>=729)and(Cursor.X<=772)and(Cursor.Y>=604)and(Cursor.Y<=630)then
       begin
            GameShutDown := True;
       end;
  end;

//==============================================================================
// Name: ScrollUp
// Desc: Скролл вверх
//==============================================================================
  procedure ScrollUp;
  begin
       if nLevels < 12 then _Inc(_j,40,0) else _Inc(_j,40,40*(nLevels-12));
  end;

//==============================================================================
// Name: ScrollDown
// Desc: Скролл вниз
//==============================================================================
  procedure ScrollDown;
  begin
       _Dec(_j,40,0);
  end;

end.
