unit RenderUtils;
interface

  procedure Release(var i); inline;

implementation

  procedure Release(var i); inline;
  begin
       if IUnknown(i)<>nil then
       begin
            IUnknown(i)._Release;
            IUnknown(i) := nil;
       end;
  end;
  
end.
