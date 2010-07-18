unit GuiCursor;
//==============================================================================
// Unit: GuiCursor.pas
// Desc: Полупрозрачные курсорчики
//==============================================================================
interface
uses Windows, RenderMain;

  function Initialize: HRESULT;
  function OnRender: HRESULT;

const
  crArrow = 0;
  crHand  = 1;
var
  Cursor: TPoint;             // Положение курсора
  CursorType: Byte = crArrow; // Тип курсора

implementation
//==============================================================================
// Name: Initialize
// Desc: Инициализация, загрузка текстур...
//==============================================================================
  function Initialize: HRESULT;
  begin
       // Прячем обычный курсор
       repeat until ShowCursor(False)< 0;
       LoadTextureFromFile('Arrow', 'textures\Arrow.tga', 0);
       LoadTextureFromFile('Hand',  'textures\Hand.tga', 0);
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
       crArrow: DrawSprite('Arrow', Cursor.X,   Cursor.Y, 32, 32, 0, 0, 1, 1, $FFFFFFFF);
       crHand : DrawSprite('Hand',  Cursor.X-5, Cursor.Y, 32, 32, 0, 0, 1, 1, $FFFFFFFF);
       end;
       Result := S_OK;
  end;
  
end.
