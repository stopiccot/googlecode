unit SokobanLevel;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface
uses
  Windows, SysUtils, FileUtil, GameMain,
  RenderTextures, Render2D;

  procedure Initialize;
  procedure FindAvalibleLevels;
  procedure LoadLevel(n: integer);
  procedure RenderLevel(Alpha: Single);
  procedure Timer;
  procedure KeyDown(Key: Longint);
  procedure Undo;

type
  TLevel = record
    Name: String;
    FileName: String;
    Glow: Single;
    Completed: Boolean;
  end;

var
  nLevels: Integer = 0;
  Levels : array of TLevel;
  C      : Single = 0;
implementation
uses GuiMain;
type
  TBox = record
    Pos  : TPoint;
    Dest : TPoint;
    gPos : TPoint;
  end;

  TMove = record
    Move    : Byte;
    nBox    : Integer;
  end;

var
  nBoxes     : Integer = 0;
  Boxes      : array of TBox;
  nMoves     : Integer = 0;
  Moves      : array of TMove;
  _Width     : Integer;
  _Height    : Integer;
  Ground     : array[0..31,0..27]of Integer;
  GroundBox  : array[0..31,0..27]of Integer;

  GreenColor : DWORD;
  LevelFile  : Text;
  LevelFileName: String;
  LevelWidth : Byte;
  LevelHeight: Byte;

  procedure Initialize;
  begin
       SetLength(Boxes,1);
  end;
  
//==============================================================================
// Name: FindAvalibleLevels
// Desc: Находит все lvl-файлы в папке Data\levels\
//==============================================================================
  procedure FindAvalibleLevels;

    procedure AddLevel(FileName: String);
    var i: integer;
    begin
         Inc(nLevels);
         SetLength(Levels, nLevels);
         AssignFile(LevelFile, FileName);
         Reset(LevelFile);
         Levels[nLevels-1].FileName := FileName;
         Readln(LevelFile, Levels[nLevels-1].Name);
         Readln(LevelFile, i);
         Levels[nLevels-1].Completed := i = 1;
         CloseFile(LevelFile);
    end;

  var SearchRec: TSearchRec;
  begin
       nLevels := 0;
       SetLength(Levels, nLevels);
       ChDir(GameWorkDir+'Data\levels\');
       if FindFirstUTF8('*.lvl',0,SearchRec) { *Converted from FindFirst* }=0 then
       begin
            AddLevel(SearchRec.Name);
            while FindNextUTF8(SearchRec) { *Converted from FindNext* }=0 do AddLevel(SearchRec.Name);
       end;
       FindCloseUTF8(SearchRec); { *Converted from FindClose* }
  end;

//==============================================================================
// Name: LoadLevel
// Desc: Загружаем, выбранный игроком, уровень.
//==============================================================================
  procedure LoadLevel(n: integer);
  var s: String; i,j: Integer;
  begin
       ChDir(GameWorkDir+'Data\levels\');
       LevelFileName := Levels[n].FileName;
       AssignFile(LevelFile, LevelFileName);
       Reset(LevelFile);
       Readln(LevelFile,s);
       Readln(LevelFile,s);
       Readln(LevelFile, LevelWidth, LevelHeight);
       _Width  := Round((730-(LevelWidth*23+1))/2);
       _Height := Round((760-(LevelHeight*23+1))/2);
       C := 1;

       for i := 0 to 31 do
       begin
            for j := 0 to 27 do
            begin
                 Ground[i, j] := -1;
                 GroundBox[i, j] := -1;
            end;
       end;

       nMoves := 0;
       SetLength(Moves,0);
       nBoxes := 0;
       SetLength(Boxes,1);
       
       for i := 1 to LevelHeight do
       begin
            Readln(LevelFile,s);
            for j := 1 to LevelWidth do
            begin
                 case s[j] of
                 '0': begin // ground
                           Ground[j,i] := 0;
                      end;
                 '1': begin // storage
                           Ground[j,i] := 1;
                      end;
                 '2': begin // box
                           Ground[j,i] := 0;
                           Inc(nBoxes);
                           GroundBox[j,i] := nBoxes;
                           SetLength(Boxes, nBoxes+1);
                           Boxes[nBoxes].Pos.X := 23*j;
                           Boxes[nBoxes].Pos.Y := 23*i;
                           Boxes[nBoxes].Dest := Boxes[nBoxes].Pos;
                           Boxes[nBoxes].gPos.X := j;
                           Boxes[nBoxes].gPos.Y := i;
                      end;
                 '3': begin // box on storage
                           Ground[j,i] := 1;
                           Inc(nBoxes);
                           GroundBox[j,i] := nBoxes;
                           SetLength(Boxes, nBoxes+1);
                           Boxes[nBoxes].Pos.X := 23*j;
                           Boxes[nBoxes].Pos.Y := 23*i;
                           Boxes[nBoxes].Dest := Boxes[nBoxes].Pos;
                           Boxes[nBoxes].gPos.X := j;
                           Boxes[nBoxes].gPos.Y := i;
                      end;
                 '4': begin // player
                           Ground[j,i] := 0;
                           Boxes[0].Pos.X := 23*j;
                           Boxes[0].Pos.Y := 23*i;
                           Boxes[0].Dest := Boxes[0].Pos;
                           Boxes[0].gPos.X := j;
                           Boxes[0].gPos.Y := i;
                      end;
                 '5': begin // player on storage
                           Ground[j,i] := 1;
                           Boxes[0].Pos.X := 23*j;
                           Boxes[0].Pos.Y := 23*i;
                           Boxes[0].Dest := Boxes[0].Pos;
                           Boxes[0].gPos.X := j;
                           Boxes[0].gPos.Y := i;
                      end;
                 end;
            end;
       end;
       CloseFile(LevelFile);
  end;

//==============================================================================
// Name: RenderLevel
// Desc: Рендер...
//==============================================================================
  procedure RenderLevel(Alpha: Single);
  var i,j: integer; Color: DWORD; DarkColor: DWORD;
  begin
       Color := (Round(255*Alpha) shl 24) or $FFFFFF;
       DarkColor := (Round(255*Alpha) shl 24) or $777777;
       GreenColor := (Round(255*Alpha) shl 24) or GreenColor;
       // Рисуем землю
       for i := 1 to LevelHeight do
       begin
            for j := 1 to LevelWidth do
            begin
                 if Ground[j,i] = -1 then Continue;
                 if Ground[j,i] = 0 then
                      DrawSprite('Cell',_Width+23*j,_Height+23*i,32,32,Color) else
                      DrawSprite('Cell',_Width+23*j,_Height+23*i,32,32,GreenColor);
                 if Ground[j-1,i] = -1 then
                      DrawSpriteEx('White',_Width+23*j,_Height+23*i,1,24,0,0,1,1,DarkColor);
                 if Ground[j+1,i] = -1 then
                      DrawSpriteEx('White',_Width+23*(j+1),_Height+23*i,1,24,0,0,1,1,DarkColor);
                 if Ground[j,i-1] = -1 then
                      DrawSpriteEx('White',_Width+23*j,_Height+23*i,24,1,0,0,1,1,DarkColor);
                 if Ground[j,i+1] = -1 then
                      DrawSpriteEx('White',_Width+23*j,_Height+23*(i+1),24,1,0,0,1,1,DarkColor);
            end;
       end;
       // Рисуем ящики
       for i := 1 to nBoxes do
            DrawSprite('Box',_Width+Boxes[i].Pos.X+2,_Height+Boxes[i].Pos.Y+2,32,32,(Round(255*Alpha) shl 24) or $555454);
       DrawSprite('Hero',
          _Width+1+Boxes[0].Pos.X+Round(Cos(GetTickCount/125)),
          _Height+1+Boxes[0].Pos.Y-Round(2*Sin(GetTickCount/125)*Sin(GetTickCount/125)),32,32,Color);
  end;

//==============================================================================
// Name: Timer
// Desc: ...
//==============================================================================
  procedure Timer;
  var i,j: integer;
  begin
       for j := 1 to 3 do
       for i := 0 to nBoxes do
       begin
            if Boxes[i].Pos.X < Boxes[i].Dest.X then Inc(Boxes[i].Pos.X);
            if Boxes[i].Pos.X > Boxes[i].Dest.X then Dec(Boxes[i].Pos.X);
            if Boxes[i].Pos.Y < Boxes[i].Dest.Y then Inc(Boxes[i].Pos.Y);
            if Boxes[i].Pos.Y > Boxes[i].Dest.Y then Dec(Boxes[i].Pos.Y);
       end;
       GreenColor := 215+Round(15*Sin(GetTickCount/750));
       GreenColor := ((GreenColor shl 16) or GreenColor)or $FF00;
       if nMoves = 1 then if C>0 then
       begin
            C := C - 0.05;
            if C<0 then C:= 0;
       end;
       if nMoves = 0 then if C<1 then
       begin
            C := C + 0.05;
            if C>1 then C:= 1;
       end;
  end;

//==============================================================================
// Name: KeyDown
// Desc: Процедура обработки нажатий клавиш
//==============================================================================
  procedure KeyDown(Key: Integer);
  var Box: integer;

    function FindBox(x,y: integer): integer;
    var i: integer;
    begin
         Result := -1;
         for i := 1 to nBoxes do
         if(Boxes[i].gPos.X = X)and(Boxes[i].gPos.Y = Y)then
         begin
              Result := i;
              Exit;
         end;
    end;

    function LevelCompleted: Boolean;
    var i: integer;
    begin
         Result := False;
         for i := 1 to nBoxes do
         if Ground[Boxes[i].gPos.X,Boxes[i].gPos.Y]<>1 then Exit;
         Result := True;
    end;

    procedure MarkLevelAsCompleted;
    var
      NewLevelFile: Text;
      S: String;
    begin
         ChDir(GameWorkDir+'Data\levels\');
         AssignFile(LevelFile, LevelFileName);
         Reset(LevelFile);
         AssignFile(NewLevelFile, '~'+LevelFileName);
         Reset(LevelFile);
         Rewrite(NewLevelFile);
         Readln(LevelFile, S); Writeln(NewLevelFile, S);
         Readln(LevelFile, S); Writeln(NewLevelFile, 1);
         while not eof(LevelFile) do
         begin
              Readln(LevelFile, S);
              Writeln(NewLevelFile, S);
         end;
         CloseFile(LevelFile);
         CloseFile(NewLevelFile);
         DeleteFileUTF8(LevelFileName); { *Converted from DeleteFile* }
         AssignFile(NewLevelFile, '~'+LevelFileName);
         Rename(NewLevelFile, LevelFileName);
         FindAvalibleLevels;
    end;

  begin
       if GuiMain.MenuPos <> mpGame then Exit;
       if(Boxes[0].Pos.X <> Boxes[0].Dest.X)or
         (Boxes[0].Pos.Y <> Boxes[0].Dest.Y)then Exit;
       case Key of
       37: begin
                if Ground[Boxes[0].gPos.X-1,Boxes[0].gPos.Y] = -1 then Exit;

                Box := FindBox(Boxes[0].gPos.X-1,Boxes[0].gPos.Y);
                if Box<>-1 then
                begin
                     if (FindBox(Boxes[0].gPos.X-2,Boxes[0].gPos.Y)<>-1)or
                        (Ground[Boxes[0].gPos.X-2,Boxes[0].gPos.Y]=-1)then Exit;
                     Dec(Boxes[Box].gPos.X);
                     Dec(Boxes[Box].Dest.X,23);
                end;
                
                Dec(Boxes[0].gPos.X);
                Dec(Boxes[0].Dest.X,23);

                Inc(nMoves);
                SetLength(Moves,nMoves);
                Moves[nMoves-1].Move := 1;
                Moves[nMoves-1].nBox := Box;
           end;
       38: begin
                if Ground[Boxes[0].gPos.X,Boxes[0].gPos.Y-1] = -1 then Exit;

                Box := FindBox(Boxes[0].gPos.X,Boxes[0].gPos.Y-1);
                if Box<>-1 then
                begin
                     if (FindBox(Boxes[0].gPos.X,Boxes[0].gPos.Y-2)<>-1)or
                        (Ground[Boxes[0].gPos.X,Boxes[0].gPos.Y-2]=-1)then Exit;
                     Dec(Boxes[Box].gPos.Y);
                     Dec(Boxes[Box].Dest.Y,23);
                end;

                Dec(Boxes[0].gPos.Y);
                Dec(Boxes[0].Dest.Y,23);

                Inc(nMoves);
                SetLength(Moves,nMoves);
                Moves[nMoves-1].Move := 2;
                Moves[nMoves-1].nBox := Box;
           end;
       39: begin
                if Ground[Boxes[0].gPos.X+1,Boxes[0].gPos.Y] = -1 then Exit;

                Box := FindBox(Boxes[0].gPos.X+1,Boxes[0].gPos.Y);
                if Box<>-1 then
                begin
                     if (FindBox(Boxes[0].gPos.X+2,Boxes[0].gPos.Y)<>-1)or
                        (Ground[Boxes[0].gPos.X+2,Boxes[0].gPos.Y]=-1)then Exit;
                     Inc(Boxes[Box].gPos.X);
                     Inc(Boxes[Box].Dest.X,23);
                end;

                Inc(Boxes[0].gPos.X);
                Inc(Boxes[0].Dest.X,23);

                Inc(nMoves);
                SetLength(Moves,nMoves);
                Moves[nMoves-1].Move := 3;
                Moves[nMoves-1].nBox := Box;
           end;
       40: begin
                if Ground[Boxes[0].gPos.X,Boxes[0].gPos.Y+1] = -1 then Exit;

                Box := FindBox(Boxes[0].gPos.X,Boxes[0].gPos.Y+1);
                if Box<>-1 then
                begin
                     if (FindBox(Boxes[0].gPos.X,Boxes[0].gPos.Y+2)<>-1)or
                        (Ground[Boxes[0].gPos.X,Boxes[0].gPos.Y+2]=-1)then Exit;
                     Inc(Boxes[Box].gPos.Y);
                     Inc(Boxes[Box].Dest.Y,23);
                end;

                Inc(Boxes[0].gPos.Y);
                Inc(Boxes[0].Dest.Y,23);

                Inc(nMoves);
                SetLength(Moves,nMoves);
                Moves[nMoves-1].Move := 4;
                Moves[nMoves-1].nBox := Box;
           end;
       end;
       if LevelCompleted then
       begin
            GuiMain.MenuPos := mpComplete;
            MarkLevelAsCompleted;
       end;
  end;

//==============================================================================
// Name: Undo
// Desc: Отмена одно хода
//==============================================================================
  procedure Undo;
  begin
       if nMoves=0 then Exit;
       case Moves[nMoves-1].Move of
       1: begin
               Inc(Boxes[0].Dest.X,23);
               Inc(Boxes[0].gPos.X);
               if Moves[nMoves-1].nBox<>-1 then
               begin
                    Inc(Boxes[Moves[nMoves-1].nBox].Dest.X,23);
                    Inc(Boxes[Moves[nMoves-1].nBox].gPos.X);
               end;
          end;
       2: begin
               Inc(Boxes[0].Dest.Y,23);
               Inc(Boxes[0].gPos.Y);
               if Moves[nMoves-1].nBox<>-1 then
               begin
                    Inc(Boxes[Moves[nMoves-1].nBox].Dest.Y,23);
                    Inc(Boxes[Moves[nMoves-1].nBox].gPos.Y);
               end;
          end;
       3: begin
               Dec(Boxes[0].Dest.X,23);
               Dec(Boxes[0].gPos.X);
               if Moves[nMoves-1].nBox<>-1 then
               begin
                    Dec(Boxes[Moves[nMoves-1].nBox].Dest.X,23);
                    Dec(Boxes[Moves[nMoves-1].nBox].gPos.X);
               end;
          end;
       4: begin
               Dec(Boxes[0].Dest.Y,23);
               Dec(Boxes[0].gPos.Y);
               if Moves[nMoves-1].nBox<>-1 then
               begin
                    Dec(Boxes[Moves[nMoves-1].nBox].Dest.Y,23);
                    Dec(Boxes[Moves[nMoves-1].nBox].gPos.Y);
               end;
          end;
       end;
       Dec(nMoves);
  end;
  
end.
