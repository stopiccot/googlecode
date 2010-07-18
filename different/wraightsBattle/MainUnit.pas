unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, DXSounds, DXInput, DXSprite, DXDraws, DXClass,
  Constants, DIB,Calculations;

type
{-------------------------------------------------------------------------------
          TStarPanel
-------------------------------------------------------------------------------}
  TStarPanel = class(TImageSprite)
  private
    Orientation    : byte;
    Moving         : byte;
    DEST_X,DEST_Y  : double;
  protected
    procedure MoveIn;
    procedure MoveOut;
    procedure DoMove(MoveCount: integer); override;
  public
    constructor Create(AParent: TSprite); overload;
    constructor Create(AParent: TSprite; FX,FY: double;FImage: string; FOrientation: byte); overload;
  end;
{-------------------------------------------------------------------------------
          TStarRadioButton
-------------------------------------------------------------------------------}
  TStarRadioButton = class(TImageSprite)
  private
    Left,Top   : double;
    Checked    : boolean;
    Name       : string;
    OwnerPanel : TStarPanel;
    TextLayer  : TImageSprite;
  protected
    function MouseOver(mX,mY: double): boolean;
    procedure DoMove(MoveCount: integer); override;
    procedure DoClick; override;
    procedure Check;
    procedure UnCheck;
  public
    constructor Create(AParent: TSprite;FLeft,FTop: double; FOwnerPanel: TStarPanel; FImage: string);
  end;
{-------------------------------------------------------------------------------
          TOptinsPanel
-------------------------------------------------------------------------------}
  TOptionsPanel = class(TStarPanel)
  private
    SingleButton      : TStarRadioButton;
    CooperativeButton : TStarRadioButton;
    DeathMatchButton  : TStarRadioButton;
  protected
  public
  end;
{-------------------------------------------------------------------------------
          TStarButton
-------------------------------------------------------------------------------}
  TStarButton = class(TStarPanel)
  private
    Click                : integer;
    TextLayer,AlphaLayer : TImageSprite;
    TdX,TdY,AdX,AdY      : double;
    beep                 : boolean;
  protected
    function MouseOver(X,Y: double): boolean;
    procedure DoMove(MoveCount: integer); override;
    procedure DoClick; override;
  public
    constructor Create(AParent: TSprite; FX,FY,FTdX,FTdY,FAdX,FAdY: double;FImage: string; FOrientation: byte);
  end;
{-------------------------------------------------------------------------------
          TCustomExplosion;
-------------------------------------------------------------------------------}
  TCustomExplosion = class(TImageSprite)
  private
    FFrameCounter   : integer;
    FFrames         : integer;
    FSpeed          : integer;
    FName           : string;
  protected
    procedure DoMove(MoveCount: integer); override;
  public
    constructor Create(AParent: TSprite;_X,_Y: double;Name: string;Speed,Frames: integer);
  end;
{-------------------------------------------------------------------------------
          TWraight
-------------------------------------------------------------------------------}
  TWraight = class(TImageSprite)
  private
    NewAngle        : extended;
    OldAngle        : extended;
    Angle           : extended;
    animation       : integer;
    Control         : TControl;
    Color           : TColor;
    Life            : integer;
    New             : integer;
    Reload          : integer;
    move_x          : extended;
    move_y          : extended;
    Weapon          : TWeapon;
    a,b             : extended;
  protected
    procedure DoMove(MoveCount: integer); override;
    procedure DoClick; override;
    procedure Fire;
    procedure ReSpawn;
    procedure Kill;
  public
    constructor Create(AParent: TSprite;fID: byte;fControl: TControl;fColor: TColor;fWeapon: TWeapon);
  end;
{-------------------------------------------------------------------------------
          TMutalisk
-------------------------------------------------------------------------------}
  PPoint = ^TPoint;
  TMutalisk = class(TImageSprite)
  private
    Need_Angle          : extended;
    Angle              : extended;
    Speed_modificator  : extended;
    animation          : integer;
    Life               : integer;
    move_x             : extended;
    move_y             : extended;
  protected
    procedure FindAngle(MutaList: TList);
    function FindTarget: PPoint;
    procedure DoMove(MoveCount: integer); override;
  public
    constructor Create(AParent: TSprite);
  end;
{-------------------------------------------------------------------------------
          TRoket
-------------------------------------------------------------------------------}
  TRoket = class(TImageSprite)
  private
    Angle          : extended;
    timer          : integer;
    life_timer     : integer;
  protected
    procedure DoMove(MoveCount: integer); override;
    procedure DoCollision(Sprite: TSprite; var Done: Boolean); override;
  public
  end;
{-------------------------------------------------------------------------------
          TMainForm
-------------------------------------------------------------------------------}
  TMainForm = class(TDXForm)
    DXDraw         : TDXDraw;
    DXTimer        : TDXTimer;
    DXWaveList     : TDXWaveList;
    DXImageList    : TDXImageList;
    DXSpriteEngine : TDXSpriteEngine;
    DXInput        : TDXInput;
    DXSound        : TDXSound;
    procedure DXTimerTimer(Sender: TObject; LagCount: Integer);
    procedure FormCreate(Sender: TObject);
    procedure DXDrawClick(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DXDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DXDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    KeyPressed     : boolean;
    procedure Up;
    procedure Down;
    procedure A;
    procedure C;
    procedure D;
    procedure I;
    procedure O;
    procedure S;
    procedure X;
  public
    { Public declarations }
  end;

var
  //Form
  MainForm                                                    : TMainForm;

  //Wraights
  WraightOne,WraightTwo                                       : TWraight;


  MUTALISK_CREATE_TIME_COUNTER : integer;
   MUTALISK_CREATE_TIME   : integer;//         = 1000;
  //Lists
  MutaList                                                    : TList;
  RoketList                                                   : TList;

  {$REGION 'Mouse'}
  MOUSE_X                                                     : integer;
  MOUSE_Y                                                     : integer;
  PRESSED                                                     : boolean;
  {$ENDREGION}

  {$REGION 'Screen variables'}
  SCREEN_WIDTH{Ширина}                                        : integer;
  SCREEN_HEIGHT{Высота}                                       : integer;
  SCREEN_BIT_COUNT                                            : byte;
  SCREEN_WINDOWED                                             : boolean;
  {$ENDREGION}

  {$REGION 'Game variables'}
  GAME_PATH                                                   : string;
  GAME_POSITION                                               : byte;
  GAME_TYPE                                                   : byte;
  GAME_SPEED                                                  : double;
  DELTA_TICK_COUNT                                            : integer;
  NEW_TICK                                                    : integer;
  OLD_TICK                                                    : integer;
  {$ENDREGION}

  {$REGION 'Panels and buttons'}
  ExitButton                                                  : TStarButton;
  StartButton                                                 : TStarButton;
  AboutButton                                                 : TStarButton;
  OptionsButton                                               : TStarButton;
  AboutPanel                                                  : TStarPanel;
  OptionsPanel                                                : TOptionsPanel;
  {$ENDREGION}
implementation

{$R *.dfm}


{$REGION '          TStarPanel block                                                      '}

constructor TStarPanel.Create(AParent: TSprite);
begin
     inherited Create(AParent);
end;

constructor TStarPanel.Create(AParent: TSprite; FX,FY: double; FImage: string; FOrientation: byte);
begin
     inherited Create(AParent);
     DEST_X := FX;
     DEST_Y := FY;
     X := FX;
     Y := FY;
     //Load image
     Image := MainForm.DXImageList.Items.Find(FImage);
     Width := Image.Width;
     Height := Image.Height;

     //Orientation and other
     Orientation := FOrientation;
     if Orientation = _LEFT  then X := 0-Width;
     if Orientation = _RIGHT then X := SCREEN_WIDTH;
     if Orientation = _UP    then Y := 0-Height;
     if Orientation = _DOWN  then Y := SCREEN_HEIGHT;
     Moving := MOVING_OUT;
end;

procedure TStarPanel.DoMove(MoveCount: integer);
begin
     case Moving of

       MOVING_IN:
       begin
            case Orientation of
            _RIGHT: X := X+(DEST_X+1-X)/PANEL_ENTER_SPEED;
            _LEFT : X := X+(DEST_X-1-X)/PANEL_ENTER_SPEED;
            _DOWN : Y := Y+(DEST_Y+1-Y)/(PANEL_ENTER_SPEED);
            end;
       end;

       MOVING_OUT:
       begin
            case Orientation of
            _RIGHT: if (X<SCREEN_WIDTH) then X:=(PANEL_ENTER_SPEED*X-DEST_X)/(PANEL_ENTER_SPEED-1)+5;
            _LEFT : if (X+Width>0)then X:=X+(2*DEST_X-X)-5-(PANEL_ENTER_SPEED*(2*DEST_X-X) - DEST_X)/(PANEL_ENTER_SPEED-1);
            _DOWN : if (Y<SCREEN_HEIGHT) then Y:=(PANEL_ENTER_SPEED*Y-DEST_Y)/(PANEL_ENTER_SPEED-1)+5;
            end;
        end;

     end;
end;

procedure TStarPanel.MoveIn;
begin
     Moving := MOVING_IN;

end;

procedure TStarPanel.MoveOut;
begin
     Moving := MOVING_OUT;
end;

{$ENDREGION}

{$REGION '          TStarButton block                                                     '}

constructor TStarButton.Create(AParent: TSprite; FX,FY,FTdX,FTdY,FAdX,FAdY: double;FImage: string; FOrientation: byte);
begin
     inherited Create(AParent);
     Click := 0;
     beep := False;
     DEST_X := FX;
     DEST_Y := FY;
     X := FX;
     Y := FY;
     //Load image
     Image := MainForm.DXImageList.Items.Find(FImage);
     Width := Image.Width;
     Height := Image.Height;

     //Orientation and other
     Orientation := FOrientation;
     if Orientation = _LEFT  then X := 0-Width;
     if Orientation = _RIGHT then X := SCREEN_WIDTH;
     if Orientation = _UP    then Y := 0-Height;
     if Orientation = _DOWN  then Y := SCREEN_HEIGHT;
     Moving := MOVING_OUT;

     TdX := FTdX;
     TdY := FTdY;
     AdX := FAdX;
     AdY := FAdY;

     //TextLayer create
     TextLayer := TImageSprite.Create(Engine);
     TextLayer.X := X+TdX;
     TextLayer.Y := Y+TdY;
     TextLayer.Image := MainForm.DXImageList.Items.Find(FImage+'TU');
     TextLayer.Height := TextLayer.Image.Height;
     TextLayer.Width := TextLayer.Image.Width;

     //AlphaLayer create
     AlphaLayer := TImageSprite.Create(Engine);
     AlphaLayer.X := X+Adx;
     AlphaLayer.Y := Y+AdY;
     AlphaLayer.Image := MainForm.DXImageList.Items.Find(FImage+'BL');
     AlphaLayer.Height := AlphaLayer.Image.Height;
     AlphaLayer.Width := AlphaLayer.Image.Width;
     AlphaLayer.Alpha := BUTTON_ALPHA;
end;

function TStarButton.MouseOver(X,Y: double): boolean;
begin
     if (X>AlphaLayer.X)and(X<AlphaLayer.X+AlphaLayer.Width)
     and(Y>AlphaLayer.Y)and(Y<AlphaLayer.Y+AlphaLayer.Height)
     then Result := True else Result := False;
end;

procedure TStarButton.DoMove(MoveCount: integer);
begin
     inherited DoMove(MoveCount);
     //Move Alpha and TextLayer
     TextLayer.X := Trunc(X) + TdX;
     TextLayer.Y := Trunc(Y) + TdY;
     AlphaLayer.X := Trunc(X) + AdX;
     AlphaLayer.Y := Trunc(Y) + AdY;
     //Beep
     if MouseOver(mouse_X,mouse_Y) then
     begin
          TextLayer.Image := MainForm.DXImageList.Items.Find(Image.Name+'TS');
          if not beep then MainForm.DXWaveList.Items.Find('beep').Play(False);
          beep := True;
     end else
     begin
          TextLayer.Image := MainForm.DXImageList.Items.Find(Image.Name+'TU');
          beep := False;
     end;
     //Click
     if Click <> 0 then
     begin
          TextLayer.Image := MainForm.DXImageList.Items.Find(Image.Name+'TS');
          dec(Click);
     end;
end;

procedure TStarButton.DoClick;
begin
     if not MouseOver(MOUSE_X,MOUSE_Y) then exit;
     MainForm.DXWaveList.Items.Find('Click').Play(False);
     if Image.Name='Start' then MainForm.S;
     if Image.Name='Exit' then MainForm.X;
     if Image.Name='Options' then MainForm.O;
     if Image.Name='About' then MainForm.A;
end;
{$ENDREGION}

{$REGION '          TStarRadioButton                                                      '}


constructor TStarRadioButton.Create(AParent: TSprite;FLeft,FTop: double; FOwnerPanel: TStarPanel; FImage: string);
begin
     inherited Create(AParent);
     Checked := False;
     Left := FLeft;
     Top := FTop;
     Name := FImage;
     OwnerPanel := FOwnerPanel;
     Image := MainForm.DXImageList.Items.Find('RBU');
     Height := Image.Height;
     Width := Image.Width;
     X := OwnerPanel.X+Left;
     Y := OwnerPanel.Y+Top;
     Z := OwnerPanel.Z+1;
        TextLayer := TImageSprite.Create(Engine);
        TextLayer.X := X+15;
        TextLayer.Y := Y-1;
        TextLayer.Z := Z;
        TextLayer.Image := MainForm.DXImageList.Items.Find(Name+'TU');
        TextLayer.Height := TextLayer.Image.Height;
        TextLayer.Width := TextLayer.Image.Width;
end;

function TStarRadioButton.MouseOver(mX,mY: double): boolean;
begin
     if (mX>X)and(mx<X+15+TextLayer.Width)
     and(my>Y)and(my<Y+Height) then
     Result := True else Result := False;
end;

procedure TStarRadioButton.DoMove(MoveCount: integer);
begin
     X := Trunc(OwnerPanel.X)+Left;
     Y := Trunc(OwnerPanel.Y)+Top;
     TextLayer.X := X+15;
     TextLayer.Y := Y-1;
     if MouseOver(MOUSE_X,MOUSE_Y) then TextLayer.Image := Mainform.DXImageList.Items.Find(Name+'TS')
                                   else TextLayer.Image := Mainform.DXImageList.Items.Find(Name+'TU');
end;

procedure TStarRadioButton.DoClick;
begin
     if not MouseOver(MOUSE_X,MOUSE_Y) then exit;
     Check;
     if Name='Deathmatch' then
     begin
          OptionsPanel.CooperativeButton.UnCheck;
          OptionsPanel.SingleButton.UnCheck;
          GAME_TYPE := DEATHMATCH;
     end;
     if Name='Cooperative' then
     begin
          OptionsPanel.DeathmatchButton.UnCheck;
          OptionsPanel.SingleButton.UnCheck;
          GAME_TYPE := COOPERATIVE;
     end;
     if Name='Single' then
     begin
          OptionsPanel.CooperativeButton.UnCheck;
          OptionsPanel.DeathmatchButton.UnCheck;
          GAME_TYPE := SINGLE;
     end;
end;

procedure TStarRadioButton.Check;
begin
     Checked := True;
     Image := MainForm.DXImageList.Items.Find('RBS');
end;

procedure TStarRadioButton.UnCheck;
begin
     Checked := False;
     Image := MainForm.DXImageList.Items.Find('RBU');
end;
{$ENDREGION}

{$REGION '          TCustomExplosion  block                                               '}


constructor TCustomExplosion.Create(AParent: TSprite;_X,_Y: double;Name: string;Speed,Frames: integer);
begin
     inherited Create(AParent);
     FFrameCounter := 0;
     FSpeed := Speed;
     FName := Name;
     FFrames := Frames;
     Image := MainForm.DXImageList.Items.Find(FName+'0');
     Width := Image.Width;
     Height := Image.Height;
     X := _X-Width/2;
     Y := _Y-Height/2;
end;

procedure TCustomExplosion.DoMove(MoveCount: Integer);
begin
     //Проверка позиции игры
     if GAME_POSITION<>GAME then exit;
     inc(FFrameCounter);
     if (FFrameCounter mod FSpeed)=0 then Image := MainForm.DXImageList.Items.Find(FName+IntToStr(FFrameCounter div FSpeed));
     if FFrameCounter=FSpeed*FFrames then Dead;
end;
{$ENDREGION}

{$REGION '          TMutalisk block                                                       '}

constructor TMutalisk.Create(AParent: TSprite);
var i: byte;
    P: PPoint;
begin
     inherited Create(AParent);

     {$REGION 'Random creation out of screen bounds'}
     randomize;
     Speed_modificator := random(10)-5;
     Speed_modificator := Speed_modificator/10;
     i := random(20);
     if i>10 then
     begin
          randomize;
          i := random(20);
          X := random(1400)-150;
          if i>10 then y := -128 else y := SCREEN_HEIGHT+128;
     end else
     begin
          randomize;
          i := random(20);
          Y := random(900)-150;
          if i>10 then x := -128 else X := SCREEN_WIDTH+128;
     end;
     {$ENDREGION}
     //Reseting all other constants
     ID := MutaList.Count;
     Visible := True;
     Angle := 0;
     Life := MUTALISK_START_LIFE;
     PixelCheck := True;
     animation := 0;
     Image := MainForm.DXImageList.Items.Find('mut001');
     Width := 128;
     Height:= 128;

     //Adding to MutaList
     New(P);
    // P := @Self;
     P^.X := X;
     P^.Y := Y;
     MutaList.Add(P);

end;


function TMutalisk.FindTarget: PPoint;
var DISTANCE_ONE,DISTANCE_TWO: extended;
begin
     if WraightOne.Visible then
          DISTANCE_ONE := sqrt(sqr(Self.X-WraightOne.X)+sqr(Self.Y-WraightOne.Y))
     else DISTANCE_ONE := maxlongint;
     if WraightTwo.Visible then
          DISTANCE_TWO := sqrt(sqr(Self.X-WraightTwo.X)+sqr(Self.Y-WraightTwo.Y))
     else DISTANCE_TWO := maxlongint;
     New(Result);
     if DISTANCE_TWO<DISTANCE_ONE then
     begin
          Result^.X := WraightTwo.X;
          Result^.Y := WraightTwo.Y;
     end else
     begin
          if DISTANCE_ONE<>maxlongint then
          begin
               Result^.X := WraightOne.X;
               Result^.Y := WraightOne.Y;
          end else
          begin
               Result^.X := SCREEN_WIDTH/2;
               Result^.Y := SCREEN_HEIGHT/2;
          end;
     end;
end;

procedure TMutalisk.FindAngle(MutaList: TList);
var vector_x , vector_y   : extended;
    distance              : extended;
    dx  ,  dy             : extended;
    P                     : PPoint;
    i                     : integer;
begin
     P := FindTarget;
     vector_x := 0;
     vector_y := 0;
     if P<>nil then
     begin
          dx := P^.X - Self.X;
          dY := P^.Y - Self.Y;
          distance := sqrt( sqr(dX) + sqr(dY) );
          vector_x := vector_x - dx*100*WRAIGHT_MAGNIT/distance;
          vector_y := vector_y - dy*100*WRAIGHT_MAGNIT/distance;
     end;
     for i := 0 to (MutaList.Count-1) do
     begin
          if (i<>ID)and(MutaList.Items[i]<>nil) then
          begin
               P := Mutalist.Items[i];
               dx := P^.X - Self.X;
               dY := P^.Y - Self.Y;
               distance := sqrt( sqr(dX) + sqr(dY) );
               vector_x := vector_x - dx*100*MUTALISK_MAGNIT/distance;
               vector_y := vector_y - dx*100*MUTALISK_MAGNIT/distance;
          end;
     end;
     Need_Angle := GetAngle(0,0,vector_x,vector_y);
end;

procedure TMutalisk.DoMove(MoveCount : integer);
var P: PPoint;
begin
     if (GAME_POSITION<>Game) then exit;
     inherited DoMove(MoveCount);
     //Оптимизация угла
     while Angle<0 do Angle := Angle + 360;
     while Angle>360 do Angle := Angle - 360;
     if (Life<=0)and Visible then
     begin
          Visible:=False;
          TCustomExplosion.Create(Engine,X+Width/2,Y+Height/2,'BL',5,8);
          MainForm.DXWaveList.Items.Find('MutaliskDeath').Play(False);
          MutaList.Items[ID] := nil;
          Dead;
          exit;
     end;

     //Moving
     FindAngle(MutaList);
     if abs(Angle-need_angle)>4 then
        if Angle>need_angle then
               begin
                    if (Angle-need_angle)<(360+need_angle-Angle)then Angle := Angle-MUTALISK_SENSIVITY else Angle := Angle+MUTALISK_SENSIVITY;
               end else
               begin
                    if (need_angle-Angle)<(360+Angle-need_angle)then Angle := Angle+MUTALISK_SENSIVITY else Angle := Angle-MUTALISK_SENSIVITY;
               end;

     X := X + (MUTALISK_SPEED+Speed_modificator)*cos(Angle*Pi/180);
     Y := Y - (MUTALISK_SPEED+Speed_modificator)*sin(Angle*Pi/180);

     inc(animation);  if (animation=4*MUTALISK_ANIMATION_SPEED) then animation := 0;
     Image := MainForm.DXImageList.Items.Find('mut'+IntToStr(animation div MUTALISK_ANIMATION_SPEED)+GetImage(Angle));

     P := MutaList.Items[ID];
     P^.X := X;
     P^.Y := Y;
     MutaList.Items[ID] := P;
end;
{$ENDREGION}

{$REGION '          TRoket  block                                                         '}


procedure TRoket.DoMove(MoveCount: Integer);
begin
     inherited DoMove(MoveCount);
     //Проверка позиции игры
     if GAME_POSITION<>GAME then exit;

     if timer<>0 then dec(timer);
     if life_timer<>0 then dec(life_timer);
     if (life_timer=0) then Dead;

     //Движение
     X := X + ROKET_SPEED*cos(Angle*Pi/180);
     Y := Y - ROKET_SPEED*sin(Angle*Pi/180);

     if timer=0 then Collision;

     //BILLIARD MODE
     if (ROKET_BILLIARD_MODE) and (X<0) then Angle := 180-Angle;
     if (ROKET_BILLIARD_MODE) and (Y<0) then Angle := 360-Angle;
     if (ROKET_BILLIARD_MODE) and (Y>768-Image.Height) then Angle := 360-Angle;
     if (ROKET_BILLIARD_MODE) and (X>1024-Image.Width)then Angle := 180-Angle;
     while Angle<0 do Angle := Angle + 360;
     while Angle>360 do Angle := Angle - 360;
     if  ROKET_BILLIARD_MODE then Image := MainForm.DXImageList.Items.Find('Roket'+GetImage(Angle));

     //Kill roket if it is out of screen
     if (X<-10)or(X>1100)or(Y<-10)or(Y>800)then Dead;

end;

procedure TRoket.DoCollision(Sprite: TSprite; var Done: Boolean);
begin
     if (Sprite is TWraight)and(Sprite as TWraight).Visible then
     begin
          (Sprite as TWraight).Life := (Sprite as TWraight).Life-1;
          Dead;
     end;
     if (Sprite is TMutalisk)and(Sprite as TMutalisk).Visible then
     begin
          (Sprite as TMutalisk).Life := (Sprite as TMutalisk).Life-1;
          Dead;
     end;
end;

{$ENDREGION}

{$REGION '          TWraight block                                                        '}

constructor TWraight.Create(AParent: TSprite;fID: byte;fControl: TControl;fColor: TColor;fWeapon: TWeapon);
begin

     inherited Create(AParent);
     Visible := False;
     Angle := 0;

     animation := 0;

     ID := fID;
     Control := fControl;
     Color := fColor;
     Weapon := fWeapon;
     Life := WRAIGHT_START_LIFE;
     PixelCheck := True;

     case Color of
       clPurple: Image := MainForm.DXImageList.Items.Find('wd0'+GetImage(Angle));
       clGreen : Image := MainForm.DXImageList.Items.Find('wg0'+GetImage(Angle));
     end;
     Width := 64;
     Height:= 64;
     Randomize;
     X := Random(950);
     Y := Random(700);
end;

procedure TWraight.DoClick;
begin
     if GAME_POSITION=GAME then
     begin
          if (Control=Mouse)and Visible and(Reload=0)and(New=0) then
          begin
               MainForm.DXWaveList.Items.Find('WraightFire').Play(False);
               Fire;
          end;
          if (Control=Mouse) and not Visible then ReSpawn;
     end;
end;

procedure TWraight.DoMove(MoveCount: Integer);

procedure Borders;
begin
     if Y<10 then
     begin
          Y := 10;                   move_y := -move_y;
          MainForm.DXWaveList.Items.Find('beep').Play(False);
     end;
     if Y>781-Image.Height then
     begin
          Y := 781-Image.Height;     move_y := -move_y;
          MainForm.DXWaveList.Items.Find('beep').Play(False);
     end;
     if X<10 then
     begin
          X := 10;                   move_x := -move_x;
          MainForm.DXWaveList.Items.Find('beep').Play(False);
     end;
     if X>1021-Image.Width then
     begin
          X := 1021-Image.Width;     move_x := -move_x;
          MainForm.DXWaveList.Items.Find('beep').Play(False);
     end;
end;

procedure LimitSpeed(var move_x,move_y: extended);
var cf,speed: extended;
begin
     speed := sqrt(sqr(move_x)+sqr(move_y));
     cf := speed/WRAIGHT_MAX_SPEED;
     if cf>1 then
     begin
          move_x := move_x/cf;
          move_y := move_y/cf;
     end;
     move_x := move_x*0.99;
     move_y := move_y*0.99;
end;

var center_X,center_Y: integer;
begin
     //Проверка позиции игры
     if (GAME_POSITION<>Game)then exit;

     //inherited
     inherited DoMove(MoveCount);

     //Respawn for keyboard
     if (Control=Keyboard)and(GAME_TYPE<>Single)and
     (isDown in MainForm.DXInput.States)and not Visible then Respawn;

     //Проверка живой ли Wraight
     if not Visible then exit;

     //Проверка жизней
     if (Life<=0)and Visible then
     begin
          TCustomExplosion.Create(Engine,X+Height/2,Y+Height/2,'EX',7,10);
          MainForm.DXWaveList.Items.Find('WraightDeath').Play(False);
          Kill;
          exit;
     end;


     {$REGION 'Оcновной case'}
     case Control of

       Mouse:
       begin
            //Собственное движение
            center_X := Round(X+Width/2);
            center_Y := Round(Y+Height/2);
            NewAngle := GetAngle(center_X,center_Y,mouse_X,mouse_Y);
            Angle := Angle+NewAngle-OldAngle;
            if pressed then
            begin
                 move_x := move_x+WRAIGHT_SPEED*cos(Angle*Pi/180);
		             move_y := move_y-WRAIGHT_SPEED*sin(Angle*Pi/180);
            end;
            OldAngle := NewAngle;
       end;

       Keyboard:
       begin
            if isLeft in MainForm.DXInput.States then Angle := Angle+WRAIGHT_KEYBOARD_SENSIVITY;
            if isRight in MainForm.DXInput.States then Angle := Angle-WRAIGHT_KEYBOARD_SENSIVITY;
            if (isDown in MainForm.DXInput.States)and(Reload=0)and(New=0)then
            begin
                 MainForm.DXWaveList.Items.Find('WraightFire').Play(False);
                 Fire;
            end;
            if isUp in MainForm.DXInput.States then
            begin
                 move_x := move_x+WRAIGHT_SPEED*cos(Angle*Pi/180);
		             move_y := move_y-WRAIGHT_SPEED*sin(Angle*Pi/180);
            end;
            while Angle>360 do Angle := Angle-360;
            while Angle<0 do Angle := Angle+360;
       end;

     end;
     {$ENDREGION}

     {$REGION 'Общее для всех видов управления'}
     LimitSpeed(move_x,move_y);
     a := a + b;
     if a>0.1 then b := -0.005;
     if a<-0.1 then b := 0.005;
     X := X + move_x;
     Y := Y + move_y+a;
     if Color = clPurple then Image := MainForm.DXImageList.Items.Find('wd0'+GetImage(Angle));
     if Color = clGreen then Image := MainForm.DXImageList.Items.Find('wg0'+GetImage(Angle));
     //Ограничение экрана
     Borders;
     //Перезарядка
     if Reload>0 then dec(Reload);
     if New>0 then dec(New);
     {$ENDREGION}
end;


procedure TWraight.ReSpawn;
begin
     a := 0;
     b := 0.01;
     Visible := True;
     Life := WRAIGHT_START_LIFE;
     if Control=Mouse then New := 1 else New := 25;
     move_x := 0;
     move_y := 0;
     X := random(950);
     Y := random(700);
end;

procedure TWraight.Kill;
begin
     Visible := False;
end;

procedure TWraight.Fire;
begin
     Reload := WRAIGHT_RELOAD_TIME;
     case Weapon of
          Roket:
          with TRoket.Create(Engine) do
          begin
               timer := Roket_timer;
               X := Self.X+15;
               Y := Self.Y+15;
               life_timer := ROKET_LIFE_TIME;
               Angle := Self.Angle;
               Image := MainForm.DXImageList.Items.Find('R0'+GetImage(Angle));
               Width := Image.Width;
               Height := Image.Height;
           end;
     end;
end;
{$ENDREGION}

{$REGION '          TMainForm block                                                       '}

procedure TMainForm.DXTimerTimer(Sender: TObject; LagCount: Integer);
begin
     //Exit if not enought time passed
     NEW_TICK := GetTickCount;
     if ( ( NEW_TICK - OLD_TICK ) < DELTA_TICK_COUNT ) and ( GAME_POSITION = GAME ) then exit;
     OLD_TICK := NEW_TICK;


          //Stop DXTimer until work will end
          DXTimer.Enabled := False;
          DXInput.Update;                //Find pressed keys
          DXSpriteEngine.Move(LagCount); //Move all sprites
          DXSpriteEngine.Dead;           //Kill all sprites
          DXDraw.Surface.Fill(6000);     //Clean DXDraw with color 6000(nearly blue)
          DXSpriteEngine.Draw;           //Draw all sprites
          DXDraw.Flip;                   //Move BackBuffer image to FrontBuffer

          //Mutalisk block
          if (GAME_TYPE=DEATHMATCH)or(GAME_POSITION<>GAME) then
          begin
               DXTimer.Enabled := True;
               exit;
          end;
          inc(MUTALISK_CREATE_TIME_COUNTER);
          if MUTALISK_CREATE_TIME_COUNTER=MUTALISK_CREATE_TIME then
          begin
               //if MUTALISK_CREATE_TIME>100 then dec(MUTALISK_CREATE_TIME,100);
               MUTALISK_CREATE_TIME_COUNTER := 0;
               TMutalisk.Create(DXSpriteEngine.Engine);
          end;

          //Go next
          DXTimer.Enabled := True;
end;

procedure TMainForm.FormCreate(Sender: TObject);

{Load parametrs}
procedure LoadParametrs;

     function OptimizeS(s: string): string;
     begin
          while copy(s,1,1)=' ' do delete(s,1,1);
          Result := s;
     end;

     {$REGION 'Screen procedures'}
     procedure SetScreenWidth(s: string);
     begin      delete(s,1,13);      SCREEN_WIDTH := StrToInt(s);           end;

     procedure SetScreenHeight(s: string);
     begin      delete(s,1,14);      SCREEN_HEIGHT := StrToInt(s);          end;

     procedure SetScreenBitCount(s: string);
     begin      delete(s,1,17);      SCREEN_BIT_COUNT := StrToInt(s);       end;

     procedure SetScreenWindowed(s: string);
     begin      delete(s,1,16);      if s='True' then SCREEN_WINDOWED := True
     else SCREEN_WINDOWED := False;end;

     procedure SetTickCount(s: string);
     begin      delete(s,1,17);      DELTA_TICK_COUNT := StrToInt(s);       end;
     {$ENDREGION}

var  s: string;
begin
     AssignFile(input,'autoexec.cfg');
     Reset(input);
     while not eof do
     begin
          Readln(s);
          OptimizeS(s);
          if copy(s,1,13)='SCREEN_WIDTH=' then SetScreenWidth(s);
          if copy(s,1,14)='SCREEN_HEIGHT=' then SetScreenHeight(s);
          if copy(s,1,17)='SCREEN_BIT_COUNT=' then SetScreenBitCount(s);
          if copy(s,1,16)='SCREEN_WINDOWED=' then SetScreenWindowed(s);
          if copy(s,1,17)='DELTA_TICK_COUNT=' then SetTickCount(s);
     end;
     CloseFile(input);
end;

procedure InitDXDraw;
begin
     Screen.Cursors[crSCCursor] := LoadCursorFromFile('Pictures/Enviroment/arrow.ani');
     DXDraw.Cursor := crSCCursor;
     DXDraw.Display.Width := SCREEN_WIDTH;
     DXDraw.Display.Height := SCREEN_HEIGHT;
     DXDraw.Display.BitCount := SCREEN_BIT_COUNT;
     if not SCREEN_WINDOWED then
     begin
          DXDraw.Options := DXDraw.Options + [doFullScreen];
          DXDraw.Options := DXDraw.Options + [doFlip];
     end;
end;

procedure InitGameParametrs;
begin
     GAME_PATH := GetCurrentDir;
     GAME_PATH := IncludeTrailingBackslash(GAME_PATH);
     GAME_POSITION := MAIN_MENU;
     GAME_TYPE := DEATHMATCH;
     GAME_SPEED := 1;

     OLD_TICK := GetTickCount;

     KeyPressed := False;

     MutaList := TList.Create;
     MUTALISK_CREATE_TIME := 50;
     MUTALISK_CREATE_TIME_COUNTER := 49;
end;

procedure LoadImage(Way,ItemName: string;_Transparent: boolean;_TransparentColor: TColor;_Mirror: boolean);
var  number: byte;
        DIB: TDIB;

function DelBMPExtension(s: string): string;
var i: byte;
begin
     Result := '';
     for i := 1 to Length(s)-4 do
     Result := Result + s[i];
end;

function GetNumber(s: string): byte;
begin
     Result := StrToInt(s[ length(s)-1 ] + s[ length(s) ] );
end;

function GetMirroredName(s: string): string;
var i: byte;
    number: string;
begin
     for i := 1 to length(s)-2 do
          Result := Result + s[i];
     Number := IntToStr( 34 - GetNumber(s));
     if length(Number) = 1 then Number := '0' + Number;
     Result := Result + Number;
end;

begin
     ItemName := DelBMPExtension(ItemName);
     DXImageList.Items.Add;
     with DXImageList.Items[DXImageList.Items.Count-1] do
     begin
          //Load picture
          Picture.LoadFromFile(Way);
          Name := ItemName;
          Restore;
          Transparent := _Transparent;
          TransparentColor := _TransparentColor;
          //Mirroring
          if _Mirror then
          begin
               number := GetNumber(ItemName);
               if (number=1) or (number=17)then exit;
               DIB := TDIB.Create;
               DIB.Assign(Picture);
               DIB.Mirror(True,False);
               DXImageList.Items.Add;
               with DXImageList.Items[DXImageList.Items.Count-1] do
               begin
                    Picture.Graphic := DIB;
                    Name := GetMirroredName(ItemName);
                    Restore;
                    Transparent := _Transparent;
                    TransparentColor := _TransparentColor;
               end;
               DIB.Free;
          end;
     end;
end;

procedure LoadAllInFolder(s: string; Transparent: boolean; Color:TColor; Mirror: boolean);
var sr: TSearchRec;
begin
     ChDir(s);
     if FindFirst('*.bmp', faAnyFile, sr) = 0 then
     begin
          LoadImage(sr.name, sr.name,Transparent,Color,Mirror);
          while FindNext(sr)=0 do
               LoadImage(sr.name, sr.name,Transparent,Color,Mirror);
     end;
end;

procedure LoadAllGraphics;
begin
     //LOAD BACKGROUND
     LoadImage('Pictures/Enviroment/borders.bmp','border.bmp',False,clBlack,False);
     //LOAD BUTTONS
     LoadAllInFolder(GAME_PATH+'Pictures/Enviroment/Buttons',True,clWhite,False);
     //LOAD PANELS
     LoadAllInFolder(GAME_PATH+'Pictures/Enviroment/Panels',True,clWhite,False);
     //LOAD WRAIGHTS
     LoadAllInFolder(GAME_PATH+'Pictures/Wraights/WraightDefault',True,clBlack,True);
     LoadAllInFolder(GAME_PATH+'Pictures/Wraights/WraightGreen',True,clBlack,True);
     //LOAD MUTALISK
     LoadAllInFolder(GAME_PATH+'Pictures/Mutalisk',True,clBlack,True);
     //LOAD ROKETS
     LoadAllInFolder(GAME_PATH+'Pictures/Bullets/Roket',True,clBlack,True);
     //LOAD EXPLOSIONS
     LoadAllInFolder(GAME_PATH+'Pictures/Explosion/Wraight',True,clBlack,False);
     LoadAllInFolder(GAME_PATH+'Pictures/Explosion/Blood',True,clBlack,False);
end;

procedure LoadSound(Way,ItemName: string);

function DelWAVExtension(s: string): string;
var i: byte;
begin
     Result := '';
     for i := 1 to Length(s)-4 do
     Result := Result + s[i];
end;

begin
     ItemName := DelWAVExtension(ItemName);
     DXWaveList.Items.Add;
     with DXWaveList.Items[DXWaveList.Items.Count-1] do
     begin
          Wave.LoadFromFile(Way);
          Name := ItemName;
          Restore;
     end;
end;

procedure LoadAllSound;
var sr: TSearchRec;
begin
     ChDir(GAME_PATH+'Sound');
     if FindFirst('*.wav', faAnyFile, sr) = 0 then
     begin
          LoadSound(sr.name, sr.name);
          while FindNext(sr)=0 do
               LoadSound(sr.name, sr.name);
     end;
end;

procedure CreateMenu;
begin
      //BACKGROUND
     if not NO_BACKGROUND then
     with TBackGroundSprite.Create(DXSpriteEngine.Engine) do
     begin
          SetMapSize(1,1);
          Image := DXImageList.Items.Find('border');
          Z:= -5;
          Tile := True;
     end;
     //CREATE BUTTONS
     ExitButton    := TStarButton.Create(DXSpriteEngine.Engine,
                                         790*SCREEN_WIDTH/1024,
                                         690*SCREEN_HEIGHT/768,70,17,4,12,'Exit',_RIGHT);
     StartButton   := TStarButton.Create(DXSpriteEngine.Engine,
                                         0,640*SCREEN_HEIGHT/768,
                                         106,20,35,15,'Start',_LEFT);
     AboutButton   := TStarButton.Create(DXSpriteEngine.Engine,
                                         0,671*SCREEN_HEIGHT/768,75,37,11,28 ,'About',_DOWN);
     OptionsButton := TStarButton.Create(DXSpriteEngine.Engine,
                                         180,671*SCREEN_HEIGHT/768,100,37,24,28 ,'Options',_DOWN);
     ExitButton.MoveIn;
     StartButton.MoveIn;
     AboutButton.MoveIn;
     OptionsButton.MoveIn;
     //CREATE PANELS
     AboutPanel   :=    TStarPanel.Create(DXSpriteEngine.Engine,
                                          748*SCREEN_WIDTH/1024,
                                          300*SCREEN_HEIGHT/768,'pAbout',_RIGHT);
     OptionsPanel := TOptionsPanel.Create(DXSpriteEngine.Engine,0,
                                          300*SCREEN_HEIGHT/768,'pOptions',_LEFT);
     OptionsPanel.DeathmatchButton := TstarRadioButton.Create(DXSpriteEngine.Engine,60,90,OptionsPAnel,'Deathmatch');
     OptionsPanel.CooperativeButton := TstarRadioButton.Create(DXSpriteEngine.Engine,60,106,OptionsPAnel,'Cooperative');
     OptionsPanel.SingleButton := TstarRadioButton.Create(DXSpriteEngine.Engine,60,122,OptionsPAnel,'Single');
     OptionsPanel.DeathmatchButton.Check;
end;

procedure CreateWraights;
begin
     WraightOne := TWraight.Create(DXSpriteEngine.Engine,1,Mouse,clPurple,Roket);
     WraightTwo := TWraight.Create(DXSpriteEngine.Engine,2,Keyboard,clGreen,Roket);
end;


begin
     LoadParametrs;     //Load parametrs

     InitGameParametrs; //Initializate Game parametrs

     InitDXDraw;        //Initializate DXDraw

     LoadAllGraphics;   //Load all graphic(*.BMP) files in folder Pictures

     LoadAllSound;      //Load all sound files in folder Sound

     CreateMenu;        //Creates all menu items;

     CreateWraights;    //Creates wraigts
end;

{-------------------------------------------------------------------------------
     TMainForm key press block
-------------------------------------------------------------------------------}
procedure TMainForm.Up;
begin
     if GAME_POSITION<>OPTIONS then exit;
     case GAME_TYPE of
       DEATHMATCH:
       begin
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.CooperativeButton.UnCheck;
            OptionsPanel.SingleButton.Check;
            GAME_TYPE := SINGLE;
       end;
       COOPERATIVE:
       begin
            OptionsPanel.DeathmatchButton.Check;
            OptionsPanel.CooperativeButton.UnCheck;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := DEATHMATCH;
       end;
       SINGLE:
       begin
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.CooperativeButton.Check;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := COOPERATIVE;
       end;
     end;
end;

procedure TMainForm.Down;
begin
     if GAME_POSITION<>OPTIONS then exit;
     case GAME_TYPE of
       DEATHMATCH:
       begin
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.CooperativeButton.Check;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := COOPERATIVE;
       end;
       COOPERATIVE:
       begin
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.CooperativeButton.UnCheck;
            OptionsPanel.SingleButton.Check;
            GAME_TYPE := SINGLE;
       end;
       SINGLE:
       begin
            OptionsPanel.DeathmatchButton.Check;
            OptionsPanel.CooperativeButton.UnCheck;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := DEATHMATCH;
       end;
     end;
end;

procedure TMainForm.A;
begin
     case GAME_POSITION of

       MAIN_MENU:
       begin
            GAME_POSITION := ABOUT;
            AboutPanel.MoveIn;
            MainForm.DXWaveList.Items.Find('hoo_in').Play(False);
       end;

       OPTIONS:
       if AboutPanel.X>=SCREEN_WIDTH then
       begin
            GAME_POSITION := ABOUT;
            AboutPanel.MoveIn;
            MainForm.DXWaveList.Items.Find('hoo_in').Play(False);
       end else
       begin
            AboutPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;


       ABOUT:
       begin
            if OptionsPanel.Moving=MOVING_IN then GAME_POSITION := OPTIONS else GAME_POSITION := MAIN_MENU;
            AboutPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;

     end;
     AboutButton.Click := BUTTON_GLOW_TIME;
end;

procedure TMainForm.C;
begin
     case GAME_POSITION of
       OPTIONS:
       begin
            OptionsPanel.CooperativeButton.Check;
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := COOPERATIVE;
       end;
     end;
end;

procedure TMainForm.D;
begin
     case GAME_POSITION of
       OPTIONS:
       begin
            OptionsPanel.DeathmatchButton.Check;
            OptionsPanel.CooperativeButton.UnCheck;
            OptionsPanel.SingleButton.UnCheck;
            GAME_TYPE := DEATHMATCH;
       end;
     end;
end;

procedure TMainForm.I;
begin
     case GAME_POSITION of
       OPTIONS:
       begin
            OptionsPanel.SingleButton.Check;
            OptionsPanel.DeathmatchButton.UnCheck;
            OptionsPanel.CooperativeButton.UnCheck;
            GAME_TYPE := SINGLE;
       end;
     end;
end;

procedure TMainForm.O;
begin
     case GAME_POSITION of

       MAIN_MENU:
       begin
            GAME_POSITION := OPTIONS;
            OptionsPanel.MoveIn;
            MainForm.DXWaveList.Items.Find('hoo_in').Play(False);
       end;

       ABOUT:
       if OptionsPanel.Moving=MOVING_OUT then
       begin
            GAME_POSITION := OPTIONS;
            OptionsPanel.MoveIn;
            MainForm.DXWaveList.Items.Find('hoo_in').Play(False);
       end else
       begin
            OptionsPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;

       OPTIONS:
       begin
            if AboutPanel.X<SCREEN_WIDTH then GAME_POSITION := ABOUT else GAME_POSITION := MAIN_MENU;
            OptionsPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;

     end;
     OptionsButton.Click := BUTTON_GLOW_TIME;
end;

procedure TMainForm.S;

procedure MoveOutAll;
begin
     AboutPanel.MoveOut;
     OptionsPanel.MoveOut;
     AboutButton.MoveOut;
     OptionsButton.MoveOut;
     ExitButton.MoveOut;
     StartButton.MoveOut;
end;
var i: integer;
    P: PPoint;
begin
     case GAME_POSITION of

       MAIN_MENU,OPTIONS,ABOUT:
       begin
            GAME_POSITION := GAME;
            Screen.Cursor := crNone;
            MoveOutAll;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
            case GAME_TYPE of

              COOPERATIVE:
              begin
                   WraightOne.ReSpawn;
                   WraightTwo.ReSpawn;
              end;

              DEATHMATCH:
              begin
                   WraightOne.ReSpawn;
                   WraightTwo.ReSpawn;
                   for i := 0 to MutaList.Count-1 do
                   begin
                        P := MutaList[i];
                       // P^.Life := 0;
                   end;
              end;

              SINGLE:
              begin
                   WraightOne.ReSpawn;
                   WraightTwo.Visible := False;
              end;

            end;

       end;

     end;
     StartButton.Click := BUTTON_GLOW_TIME;
end;

procedure TMainForm.X;
begin
     case GAME_POSITION of

       MAIN_MENU:
       begin
            MainForm.DXWaveList.Items.Find('click').Play(True);
            Application.Terminate;
       end;

       ABOUT:
       begin
            if OptionsPanel.Moving=MOVING_IN then GAME_POSITION := OPTIONS else GAME_POSITION := MAIN_MENU;
            AboutPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;

       OPTIONS:
       begin
            if AboutPanel.Moving=MOVING_IN then GAME_POSITION := ABOUT else GAME_POSITION := MAIN_MENU;
            OptionsPanel.MoveOut;
            MainForm.DXWaveList.Items.Find('hoo_out').Play(False);
       end;

       GAME:
       begin
            GAME_POSITION := MAIN_MENU;
            Screen.Cursor := crSCCursor;
            StartButton.MoveIn;
            ExitButton.MoveIn;
            AboutButton.MoveIn;
            OptionsButton.MoveIn;
            MainForm.DXWaveList.Items.Find('hoo_in').Play(False);
       end;

     end;
     ExitButton.Click := BUTTON_GLOW_TIME;
end;

procedure TMainForm.FormKeyUp(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
     KeyPressed := False;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;  Shift: TShiftState);
begin
     if KeyPressed then exit;
     KeyPressed := True;
     if (Key=38) then Up;
     if (Key=40) then Down;
     if (Key=65) then A;
     if (Key=67) then C;
     if (Key=68) then D;
     if (Key=73) then I;
     if (Key=79) then O;
     if (Key=83) then S;
     if (Key=88)or(Key=27) then X;
end;
{$ENDREGION}

{$REGION'          TDXDraw block                                                         '}


procedure TMainForm.DXDrawClick(Sender: TObject);
begin
     DXSpriteEngine.Click;
end;

procedure TMainForm.DXDrawMouseMove(Sender: TObject; Shift: TShiftState; X,Y: Integer);
begin
     MOUSE_X := X+10;
     MOUSE_Y := Y+8;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     Mutalist.Free;  
end;

procedure TMainForm.DXDrawMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     if Button = mbRight then pressed := True;
end;

procedure TMainForm.DXDrawMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     if Button = mbRight then pressed := False;
end;
{$ENDREGION}
end.
