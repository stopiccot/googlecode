unit SeaBattleHighscores;
//==============================================================================
// Unit: SeaBattleHighscores.pas
// Desc: Рекорды
//==============================================================================
interface
uses IO, Game, SysUtils;

  procedure ScoreAdd;
  procedure ScoreDec;
  procedure SaveHighScores;
  procedure LoadHighScores;
  function NewHighscore: Integer;
  
const
  MaxHighscores = 15;
type
  THighscore = record
    Name       : String;
    Score      : Integer;
  end;

const
  NilHighscore : THighscore = (Name:''; Score:0;);

var
  Highscores : array[0..MaxHighscores-1]of THighscore;
  Score      : Integer = 0;
  Modifier   : Integer = 0;

implementation
uses SeaBattleMain;
type
  TByteArray = array[0..7]of Byte;

  procedure ScoreAdd;
  begin
       Score := Score+10+Modifier;
       Modifier := Modifier+2;
  end;

  procedure ScoreDec;
  begin
       Dec(Score);
       if Score<0 then Score := 0;
       
       Modifier := 0;
  end;

  function NewHighscore: Integer;
  var i,j: integer;
  begin
       for i := 0 to 14 do
       begin
            if Score>Highscores[i].Score then
            begin
                 for j := 14 downto (i+1) do Highscores[j] := Highscores[j-1];
                 Highscores[i].Score := Score;
                 Highscores[i].Name := '';
                 Result := i;
                 EnteringName := True;
                 Exit;
            end;
       end;
       Result := -1;
  end;

  procedure SaveHighscore(Highscore: THighscore);
  var i: integer;
  begin
       WriteInt64(Length(Highscore.Name));
       for i := 1 to Length(Highscore.Name) do
            WriteInt64(Ord(Highscore.Name[i]));
       WriteInt64(Highscore.Score);
  end;

  procedure SaveHighscores;
  var i: integer;
  begin
       ChDir(Game.WorkDir);
       for i := 0 to 14 do SaveHighscore(Highscores[i]);
       IO.ShutDown;
  end;

  procedure LoadHighscore(var Highscore: THighscore);
  var
    NameLength, i64: Int64;
    i: Integer;
  begin
       ReadInt64(NameLength);
       for i := 1 to NameLength do
       begin
            ReadInt64(i64);
            Highscore.Name := Highscore.Name + Chr(i64 mod 255);
       end;
       ReadInt64(i64);
       Highscore.Score := i64; 
  end;

  procedure LoadHighscores;
  var i: integer;
  begin
       ChDir(Game.WorkDir);
       if FileExists('highscores.sbh') then
       begin
            for i := 0 to 14 do LoadHighscore(Highscores[i]);
            IO.ShutDown;
       end else
       begin
            for i := 0 to (MaxHighscores-1) do
            begin
                 Highscores[i].Name := '.Player';
                 Highscores[i].Score := 60-i*4;
            end;
       end;
  end;


end.
