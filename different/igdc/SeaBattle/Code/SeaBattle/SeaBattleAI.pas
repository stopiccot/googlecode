unit SeaBattleAI;
//==============================================================================
// Unit: SeaBattleAI.pas
// Desc: Искуственный интеллект оппонента
//==============================================================================
interface
{.$DEFINE DEBUG}

  procedure Initialize;
  procedure NewGame;
  function ComputerTurn: Boolean;

var
  Difficulty: Byte;
  AIField: array[0..11,0..11]of Byte;
  {$IFDEF DEBUG}
  AILog: array[0..49]of string;
  {$ENDIF}

implementation
uses Windows, SeaBattleMain, SysUtils;
var
  X,Y         : integer;
  LastHit     : TPoint;
  ShootResult : Byte;

  {$IFDEF DEBUG}
  procedure DebugLogAI(S: String);
  var i: integer;
  begin
       for i := 49 downto 1 do AILog[i] := AILog[i-1];
       AILog[i] := S;
  end;
  {$ENDIF}

  function max(a,b: integer): integer;
  begin
       if a>b then Result := a else Result := b;
  end;

  function min(a,b: integer): integer;
  begin
       if a<b then Result := a else Result := b;
  end;

  procedure Initialize;
  var i: integer;
  begin
       for i := 0 to 11 do
       begin
            AIField[0,i] := 2;
            AIField[11,i] := 2;
            AIField[i,0] := 2;
            AIField[i,11] := 2;
       end;
  end;

  procedure NewGame;
  begin
       ShootResult := 0;
       LastHit.X := 0;
       {$IFDEF DEBUG}
       DebugLogAI('Game ended.');
       DebugLogAI('');
       DebugLogAI('');
       DebugLogAI('');
       {$ENDIF}
  end;
  
  function ComputerTurn: Boolean;
  var
    i,R : integer;
    Ship: TShip;
    
    function FindHurtedShip: Boolean;
    var i,j: integer;
    begin
         Result := True;
         for i := 1 to 10 do
         begin
              for j := 1 to 10 do
              begin
                   if AIField[i,j]<>0 then Continue;
                   
                   if (i>1)and((AIField[i-2,j]=1)and(AIField[i-1,j]=1))then
                   begin
                        X := j; Y := i; Exit;
                   end;
                   if(i<10)and((AIField[i+2,j]=1)and(AIField[i+1,j]=1))then
                   begin
                        X := j; Y := i; Exit;
                   end;
                   if (j>1)and((AIField[i,j-2]=1)and(AIField[i,j-1]=1))then
                   begin
                        X := j; Y := i; Exit;
                   end;
                   if(j<10)and((AIField[i,j+2]=1)and(AIField[i,j+1]=1))then
                   begin
                        X := j; Y := i; Exit;
                   end;
              end;
         end;
         Result := False; 
    end;
    
  {$IFDEF DEBUG}
  var C: Integer;
  {$ENDIF}
  begin
       Result := False;
       // 1.Выбираем координаты для выстрела
       // 1.1.Сначала ищем недобитые корабли
       if not FindHurtedShip then
       begin
            // 1.2 Потом пытаемся выстрелить в районе последнего удачного выстрела
            if(ShootResult<>2)and(LastHit.X<>0)and
             ((AIField[LastHit.Y-1,LastHit.X]=Clean)or
              (AIField[LastHit.Y,LastHit.X-1]=Clean)or
              (AIField[LastHit.Y+1,LastHit.X]=Clean)or
              (AIField[LastHit.Y,LastHit.X+1]=Clean))then
            begin
                 X := LastHit.X;
                 Y := LastHit.Y;
                 repeat
                      R := Random(4);
                      case R of
                      0: if (AIField[Y-1,X]=Clean)and(Y>1) then begin Y := Y-1; Break; end;
                      1: if (AIField[Y,X+1]=Clean)and(X<10)then begin X := X+1; Break; end;
                      2: if (AIField[Y+1,X]=Clean)and(Y<10)then begin Y := Y+1; Break; end;
                      3: if (AIField[Y,X-1]=Clean)and(X>1) then begin X := X-1; Break; end;
                 end;
                 until False;
                 {$IFDEF DEBUG}
                 DebugLogAI('Shoot('+IntToStr(X)+','+IntToStr(Y)+') - NearLastHit');
                 {$ENDIF}
            end else
            begin
                 // 1.3 Последнее, что остаётся это стрелять рандомом
                 {$IFDEF DEBUG}
                 C := 0;
                 {$ENDIF}
                 repeat
                      X := Random(10)+1;
                      Y := Random(10)+1;
                 {$IFDEF DEBUG}
                      Inc(C);
                 until (C>200)or(AIField[Y,X]=Clean);
                 if C>200
                 then DebugLogAI('Random failed...')
                 else DebugLogAI('Shoot('+IntToStr(X)+','+IntToStr(Y)+') - Random('+IntToStr(C)+')');
                 {$ELSE}
                 until AIField[Y,X]=Clean;
                 {$ENDIF}
            end;
       end else
       begin
            {$IFDEF DEBUG}
            DebugLogAI('Shoot('+IntToStr(X)+','+IntToStr(Y)+') - FindHurtedShip');
            {$ENDIF}
       end;
                
       // Точка для выстрела выбрана!
       AIField[Y,X] := Miss;
       // 2.Выстрел...
       ShootResult := Shoot(PlayerField, X, Y);
       // ...попали...
       if ShootResult<>0 then
       begin
            AIField[Y,X] := Hit;
            LastHit.X := X; LastHit.Y := Y;
            {$IFDEF DEBUG}
            DebugLogAI('New LastHit('+IntToStr(X)+','+IntToStr(Y)+');');
            {$ENDIF}
            Result := True;
       end;
       // ...и даже убили!
       if (ShootResult=2) then
       begin
            Result := True;
            LastHit.X := 0;
            if (LastKilledShip<1)or(LastKilledShip>10)then Exit;
            Ship := PlayerField.Ships[LastKilledShip];
            // Помечаем смежные с кораблём точки, чтоб AI в них не стрелял
            {$REGION ' ... '}
            {$IFDEF DEBUG}
            DebugLogAI('Mark cells...');
            {$ENDIF}
            case Ship.Pos of
            Vertical:
              begin
                   for i := (Ship.Y-1)to(Ship.Y+Ship.Size)do
                   begin
                        AIField[i,Ship.X-1] := 2;
                        AIField[i,Ship.X+1] := 2;
                   end;
                   for i := (Ship.X-1) to (Ship.X+1) do
                   begin
                        AIField[Ship.Y-1,i] := 2;
                        AIField[Ship.Y+Ship.Size,i] := 2;
                   end;
              end;
            Horizontal:
              begin
                   for i := (Ship.X-1)to(Ship.X+Ship.Size)do
                   begin
                        AIField[Ship.Y-1,i] := 2;
                        AIField[Ship.Y+1,i] := 2;
                   end;
                   for i := (Ship.Y-1) to (Ship.Y+1) do
                   begin
                        AIField[i,Ship.X-1] := 2;
                        AIField[i,Ship.X+Ship.Size] := 2;
                   end;
              end;
            end;
            {$ENDREGION}
            {$IFDEF DEBUG}
            AILog[0] := AILog[0]+' ok';
            {$ENDIF}
       end;    
  end;

end.
