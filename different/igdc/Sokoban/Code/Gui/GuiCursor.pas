unit GuiCursor;
//==============================================================================
// Unit: GuiCursor.pas
// Desc: Полупрозрачные курсорчики
//==============================================================================
interface
uses
  Windows, D3D9, D3DX9Def,
  RenderMain, RenderTextures, Render2D;

  function Initialize: HRESULT;
  function OnRender: HRESULT;

const
  crArrow   = 0;
  crHand    = 1;

var
  Cursor: TPoint;               // Положение курсора
  CursorType: Byte = crArrow;   // Тип курсора

implementation
//==============================================================================
// Name: Initialize
// Desc: Инициализация, загрузка текстур и эффектов
//==============================================================================
  function Initialize: HRESULT;
  begin
       // Прячем обычный курсор
       repeat until ShowCursor(False)< 0;
       LoadTextureFromFile('Arrow',    'textures\Arrow.tga');
       LoadTextureFromFile('Hand',     'textures\Hand.tga');
       Result := S_OK;
  end;
  
//==============================================================================
// Name: OnRender
// Desc: Рендер курсора
//==============================================================================
  function OnRender: HRESULT;
  begin
       GetCursorPos(Cursor);
       case CursorType of
       crArrow: DrawSprite('Arrow', Cursor.X,   Cursor.Y, 32, 32, $FFFFFFFF);
       crHand : DrawSprite('Hand',  Cursor.X-5, Cursor.Y, 32, 32, $FFFFFFFF);
       end;
       Result := S_OK;
  end;
  
end.
