unit GuiSplash;
//==============================================================================
// Unit: GuiSplash.pas
// Desc: Отвечает за Game Developers Contest-заставку в начале игры
//==============================================================================
interface
uses Windows, Game, RenderMain;

  function Initialize: HRESULT;
  function OnRender: HRESULT;

  function WMKeyDown(Key: Word): HRESULT;
  function WMTimer: HRESULT;
  function WMClick: HRESULT;
  
implementation
const
  Appearance    = 0; // Появление
  Disappearance = 1; // Исчезание
  Wait          = 1; // Время заставки в секундах
var
  State : Byte = Appearance;
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
       LoadTextureFromFile('GDCLogo', 'textures\GDCLogo.tga', 0);
       Result := S_OK;
  end;

//==============================================================================
// Name: OnRender
// Desc: Непосредственно рендер
//==============================================================================
  function OnRender: HRESULT;
  begin
       DrawSprite('GDCLogo', 256, 128, 512, 512, 0, 0, 1, 1, (Round(Alpha*2.55) shl 24) or $00FFFFFF);
       Result := S_OK;
  end;

//==============================================================================
// Name: WMTimer
// Desc: Вызывается 40 раз в секунду
//==============================================================================
  function WMTimer: HRESULT;
  begin
       case State of
         Appearance:
         begin
              if Alpha = 100 then
              begin
                   if Time>=Wait then State := Disappearance else Time := Time + 0.025;
              end else
                   Alpha := Min(Alpha + 5, 100);
         end;
         Disappearance:
         begin
              Alpha := Max(0, Alpha - 5);
              if Alpha <= 50 then Game.GamePos := gpMainMenu;
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
