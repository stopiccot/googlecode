unit GuiUtils;
//==============================================================================
// Unit: GuiUtils.pas
// Desc: Чтоб тупо не дублировать min и max функции в нескольких юнитах.
//       Math тоже не хочеться использовать только из-за этих двух функций.
//==============================================================================
interface

  function Max(a,b: Single): Single;
  function Min(a,b: Single): Single;

implementation

  function Max(a,b: Single): Single;
  begin
       if a>b then Result := a else Result := b;
  end;

  function Min(a,b: Single): Single;
  begin
       if a<b then Result := a else Result := b;
  end;

end.
