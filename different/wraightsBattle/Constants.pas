unit Constants;

interface

{-------------------------------------------------------------------------------

              In tihs unit are kept all  constants and types
              used in MyStarCraft.exe

-------------------------------------------------------------------------------}

type
{-------------------------------------------------------------------------------
              Records and own types
-------------------------------------------------------------------------------}
  TWeapon = (Roket,SMARTRoket);

  TMyColor =(Default,Green);

  TControl = (Mouse,Keyboard,AI);

  TVector = packed record
       X,Y: double;
  end;

  ///PPoint = ^TPoint;
  TPoint = packed record
       X,Y: double;
  end;

const
{-------------------------------------------------------------------------------
  Numeric constants
-------------------------------------------------------------------------------}
  {$REGION 'Moving constants'}
  MOVING_IN                       = 0;
  MOVING_OUT                      = 1;
  {$ENDREGION}

  {$REGION 'Orientatin constants'}
  _LEFT                            = 0;
  _DOWN                            = 1;
  _RIGHT                           = 2;
  _UP                              = 3;
  {$ENDREGION}

  {$REGION 'Game position constants'}
  //Game position constants
  MAIN_MENU                       = 0;
  GAME                            = 1;
  OPTIONS                         = 2;
  ABOUT                           = 3;
  {$ENDREGION}

  {$REGION 'Game type constants'}
  DEATHMATCH                      = 0;
  COOPERATIVE                     = 1;
  SINGLE                          = 2;
  {$ENDREGION}

  {$REGION 'Misc constants'}
  //Misc
  crSCCursor                      = 1;
  NO_BACKGROUND                   = False;
  {$ENDREGION}

  {$REGION 'Wraight constants'}
  WRAIGHT_RELOAD_TIME             = 20;
  WRAIGHT_KEYBOARD_SENSIVITY      = 7;
  WRAIGHT_START_LIFE              = 1;
  WRAIGHT_START_WAEPON            = Roket;
  WRAIGHT_MAGNIT                  = -40;
  WRAIGHT_SPEED                   = 0.25;
  WRAIGHT_MAX_SPEED               = 6;
  {$ENDREGION}

  {$REGION 'Roket constants'}
  ROKET_SPEED                     = 9.0;//7.7;
  ROKET_BILLIARD_MODE             = False;
  ROKET_TIMER                     = 7;
  ROKET_LIFE_TIME                 = 2000;
  {$ENDREGION}

  {$REGION 'Mutalisk constants'}
  MUTALISK_START_LIFE             = 1;
  MUTALISK_ANIMATION_SPEED        = 5;
  MUTALISK_SENSIVITY              = 5;
  MUTALISK_SPEED                  = 3;
  MUTALISK_MAGNIT                 = 3;
  {$ENDREGION}

  {$REGION 'Panel constants'}
  PANEL_ENTER_SPEED               = 5;
  {$ENDREGION}

  {$REGION 'Button constants'}
  BUTTON_GLOW_TIME                = 5;
  BUTTON_ALPHA                    = 130;
  {$ENDREGION}

implementation

end.
