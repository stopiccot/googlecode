unit SeaBattleMain;
//==============================================================================
// Unit: SeaBattleMain.pas
// Desc: отвечает за реализацию морского боя
//==============================================================================
interface
uses
  Windows, RenderMain, d3d9, SysUtils;

  procedure NewGame;
  function Initialize(): HRESULT;

  function PlayerWins: Boolean;
  function ComputerWins: Boolean;
  
const
  // Pos
  Horizontal = 0;
  Vertical   = 1;
  // Field
  Clean      = 0;
  Hit        = 1;
  Miss       = 2;


type
  TShip = record
    X,Y  : Integer;
    Pos  : Byte;
    Size : Byte;
    Life : array[1..4] of byte;
    Dead : Boolean;
  end;

  TShips = array [1..10] of TShip;

  TGameField = record
    Ships : TShips;
    Field : array[0..11,0..11] of Byte;
  end;

  function Shoot(var GameField: TGameField; X,Y: integer): integer;

var
  PlayerField    : TGameField;
  ComputerField  : TGameField;
  Turn           : Byte; // 0 - ходит игрок, 1 - ходит компьютер
  LastKilledShip : Byte; // Номер последнего убитого корабля
  GameStarted    : Boolean = False;
  GameEnded      : Boolean = False;
  EnteringName   : Boolean = False;

implementation
uses
  SeaBattleHighscores, SeaBattleAI;

  function max(a,b: integer): integer;
  begin
       if a>b then Result := a else Result := b;
  end;

  function min(a,b: integer): integer;
  begin
       if a<b then Result := a else Result := b;
  end;

//==============================================================================
// Name: PlaceShipsRandom
// Desc: Рандомное расставление кораблей на заданном игровом поле
//==============================================================================
  procedure PlaceShipsRandom(var GameField: TGameField);
  var k,i,j: integer;

    function CanPlace: boolean;
    var m,n: integer;
    begin
         Result := False;
         case GameField.Ships[k].Pos of
           Horizontal:
             for m := max(i-1,1) to min(i+1,10) do
                  for n := max(j-1,1) to min(j+GameField.Ships[k].Size,10) do
                       if GameField.Field[m,n]<>0 then Exit;
           Vertical:
             for m := max(i-1,1) to min(i+GameField.Ships[k].Size,10) do
                  for n := max(j-1,1) to min(j+1,10) do
                       if GameField.Field[m,n]<>0 then Exit;
         end;
         // Ставим
         Result := True;
         case GameField.Ships[k].Pos of
           Horizontal:
             for n := j to j+GameField.Ships[k].Size-1 do
                       GameField.Field[i,n] := 1;
           Vertical:
             for n := i to i+GameField.Ships[k].Size-1 do
                       GameField.Field[n,j] := 1;
         end;
    end;

  begin
       Randomize;
       ZeroMemory(@GameField.Field, SizeOf(GameField.Field));
       for k := 1 to 10 do
       begin
            GameField.Ships[k].Pos := Random(2);
            repeat
                 i := Random(11-GameField.Ships[k].Size)+1;
                 j := Random(11-GameField.Ships[k].Size)+1;
            until CanPlace;
            GameField.Ships[k].X := j;
            GameField.Ships[k].Y := i;
       end;
       ZeroMemory(@GameField.Field, SizeOf(GameField.Field));
  end;

//==============================================================================
// Name: Shoot
// Desc: Обработка "выстрела"
// Return: 0 - мимо, 1 - ранил, 2 - убил
//==============================================================================
  function Shoot(var GameField: TGameField; X,Y: integer): integer;
  var i, _Result: Integer;

    function CheckDead(n: integer): Boolean;
    var i: integer;
    begin
         Result := True;
         for i := 1 to GameField.Ships[n].Size do
         if GameField.Ships[n].Life[i]=0 then
         begin
              Result := False;
              Exit;
         end;
    end;

    function HitShip(n: integer): Boolean;
    var j: integer;
    begin
         Result := False;
         // Стрельба по убитым кораблям не обрабатывается
         if GameField.Ships[n].Dead then Exit;
         case GameField.Ships[n].Pos of
           Horizontal:
             begin
                  // Корабль расположен горизонтально
                  if GameField.Ships[n].Y<>Y then Exit;
                  for j := 0 to GameField.Ships[n].Size - 1 do
                  if (GameField.Ships[n].X+j)=X then
                  begin
                       GameField.Ships[n].Life[j+1] := 1;
                       GameField.Ships[n].Dead := CheckDead(n);
                       if GameField.Ships[n].Dead then _Result := 2 else _Result := 1;
                       Result := True;
                       Exit;
                  end;
             end;
           Vertical:
             begin
                  // Корабль расположен вертикально
                  if GameField.Ships[n].X<>X then Exit;
                  for j := 0 to GameField.Ships[n].Size - 1 do
                  if (GameField.Ships[n].Y+j)=Y then
                  begin
                       GameField.Ships[n].Life[j+1] := 1;
                       GameField.Ships[n].Dead := CheckDead(n);
                       if GameField.Ships[n].Dead then _Result := 2 else _Result := 1;
                       Result := True;
                       Exit;
                  end;
             end;
         end;
    end;

  begin
       Result := 0;
       for i := 1 to 10 do
       begin
            if HitShip(i) then
            begin
                 GameField.Field[Y,X] := Hit;
                 Result := _Result;
                 if _Result=2 then
                      LastKilledShip := i;
                 Exit;
            end;
       end;
       GameField.Field[Y,X] := Miss;
  end;
  
//==============================================================================
// Name: NewGame
// Desc: Вызывается в начале каждой новой игры
//==============================================================================
  procedure NewGame;
  var i: integer;
  begin
       PlaceShipsRandom(PlayerField);
       PlaceShipsRandom(ComputerField);
       ZeroMemory(@PlayerField.Field, SizeOf(PlayerField.Field));
       ZeroMemory(@ComputerField.Field, SizeOf(ComputerField.Field));
       ZeroMemory(@AIField, SizeOf(AIField));
       for i := 1 to 10 do
       begin
            PlayerField.Ships[i].Dead := False;
            ZeroMemory(@PlayerField.Ships[i].Life, PlayerField.Ships[i].Size);
            ComputerField.Ships[i].Dead := False;
            ZeroMemory(@ComputerField.Ships[i].Life, ComputerField.Ships[i].Size);
       end;
       Turn := 0;
       Score := 0;
       SeaBattleAI.NewGame;
       GameStarted := True;
       GameEnded := False;
  end;

//==============================================================================
// Name: Initialize
// Desc: Инициализация. Вызывается одие раз в самом начале
//==============================================================================
  function Initialize(): HRESULT;

    procedure SetShipSizes(var GameField: TGameField);
    begin
         GameField.Ships[1].Size := 4;
         GameField.Ships[2].Size := 3;
         GameField.Ships[3].Size := 3;
         GameField.Ships[4].Size := 2;
         GameField.Ships[5].Size := 2;
         GameField.Ships[6].Size := 2;
         GameField.Ships[7].Size := 1;
         GameField.Ships[8].Size := 1;
         GameField.Ships[9].Size := 1;
         GameField.Ships[10].Size := 1;
    end;

  begin
       SetShipSizes(PlayerField);
       SetShipSizes(ComputerField);
       SeaBattleHighscores.LoadHighScores;
       SeaBattleAI.Initialize;
       Result := S_OK;
  end;

  function PlayerWins: Boolean;
  var i: integer;
  begin
       Result := False;
       for i := 1 to 10 do
       if ComputerField.Ships[i].Dead=False then Exit;
       Result := True;
       GameEnded := True;       
  end;

  function ComputerWins: Boolean;
  var i: integer;
  begin
       Result := False;
       for i := 1 to 10 do
       if PlayerField.Ships[i].Dead=False then Exit;
       Result := True;
       GameEnded := True;
  end;

end.
