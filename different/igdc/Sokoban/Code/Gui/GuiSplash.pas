unit GuiSplash;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

//==============================================================================
// Unit: GuiSplash.pas
// Desc: Отвечает за Game Developers Contest-заставку в начале игры
//==============================================================================
interface
uses Windows, Render2D, RenderTextures;

  function Initialize: HRESULT;
  function OnRender: HRESULT;

  function WMKeyDown(Key: Word): HRESULT;
  function WMTimer: HRESULT;
  function WMClick: HRESULT;
  
implementation
uses
  GuiMain;
const
  TimeOut       = 0;    // Задержка перед появлением
  Appearance    = 1;    // Появление
  Disappearance = 2;    // Исчезание
  TimeOutWait   = 100;  // Время задержки перед появлением в миллисекундах
  Wait          = 1000; // Время заставки в миллисекундах
var
  State : Byte = TimeOut;
  Alpha : Single = 0;
  Time  : Single = 0;

  function Max(a,b: Single): Single;
  begin
       if a>b then Result := a else Result := b;
  end;

  function Min(a,b: Single): Single;
  begin
       if a<b then Result := a else Result := b;
  end;

//==============================================================================
// Name: Initialize
//==============================================================================
  function Initialize: HRESULT;
  begin
       Result := LoadTextureFromFile('Splash', 'textures\Splash.tga');
  end;

//==============================================================================
// Name: OnRender
// Desc: Непосредственно рендер
//==============================================================================
  function OnRender: HRESULT;
  begin
       Result := DrawSprite('Splash', 256, 128, 512, 512, (Round(Alpha*2.55) shl 24) or $00FFFFFF);
  end;

//==============================================================================
// Name: WMTimer
// Desc: Вызывается 40 раз в секунду
//==============================================================================
  function WMTimer: HRESULT;
  begin
       case State of
         TimeOut:
         begin
              Time := Time + 25;
              if Time>=TimeOutWait then
              begin
                   State := Appearance;
                   Time := 0;
              end;
         end;
         Appearance:
         begin
              if Alpha = 100 then
              begin
                   if Time>=Wait then State := Disappearance else Time := Time + 25;
              end else
                   Alpha := Min(Alpha + 5, 100);
         end;
         Disappearance:
         begin
              Alpha := Max(0, Alpha - 5);
              if (Alpha <= 50)and(GuiMain.MenuPos = mpSplash) then GuiMain.MenuPos := mpMainMenu;
         end;
       end;
       Result := S_OK;
  end;

//==============================================================================
// Name: WMKeyDown & WMClick
// Desc: Клик мышки или нажатие клавиши вырубает заставку
//==============================================================================
  function WMKeyDown(Key: Word): HRESULT;
  begin
       State := Disappearance;
       Result := S_OK;
  end;

  function WMClick: HRESULT;
  begin
       State := Disappearance;
       Result := S_OK;
  end;
  
end.
