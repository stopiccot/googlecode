unit IO;
interface
uses Windows;

function ReadBoolean(var B: Boolean): HRESULT;
function ReadByte(var b: byte): HRESULT;
function ReadInt(var i: integer): HRESULT;
function ReadWord(var w: word): HRESULT;
function ReadInt64(var i64: int64): HRESULT;
procedure WriteBoolean(B: Boolean);
procedure WriteByte(b: byte);
procedure WriteInt(i: integer);
procedure WriteWord(w: word);
procedure WriteInt64(i64: int64);
procedure ShutDown();

var
  BytesReaded : word = 0;
  BytesWrited : word = 0;

implementation
const
  NotInitialized = 0;
  InputInitialize = 1;
  InputInitialized = 1;
  OutputInitialize = 2;
  OutputInitialized = 2;
const
  BaseName = 'highscores.sbh';

var
  F        : File;
  BaseSize : integer;
  Init     : byte;

function Initialize(I: byte): HRESULT;
begin
     if Init<>NotInitialized then ShutDown();
     Assign(F, BaseName);
     case I of
       InputInitialize:
         begin
              // Инициализация для считывания
              Reset(F,1);
              BaseSize := FileSize(F); // Размер файла в байтах
              BytesReaded := 0;        // Сбрасываем счётчик
         end;
       OutputInitialize:
         begin
              Rewrite(F,1);
              BytesWrited := 0;        // Сбрасываем счётчик
         end;
     end;
     Init := I;
     Result := S_OK;
end;

procedure ShutDown();
begin
     if Init=NotInitialized then Exit;
     Close(F);
     Init := NotInitialized;
end;

function ReadBoolean(var B: Boolean): HRESULT;
begin
     // Проверяем была ли проведена инициализация для чтения
     if Init<>InputInitialized then Initialize(InputInitialize);
     // Проверка, чтоб не выйти за пределы файла
     if BytesReaded+1>BaseSize then
     begin
          // Что-то с файлом не то
          Result := E_FAIL;
          Exit;
     end;
     BlockRead(F,B,1);  // Считываем переменную
     inc(BytesReaded);  // Увеличиваем счётчик
     Result := S_OK;    // Успешный выход
end;

function ReadByte(var b: byte): HRESULT;
begin
     if Init<>InputInitialized then Initialize(InputInitialize);
     if BytesReaded+1>BaseSize then
     begin
          Result := E_FAIL;
          Exit;
     end;
     BlockRead(F,B,1);
     inc(BytesReaded);
     Result := S_OK;
end;

function ReadInt(var i: integer): HRESULT;
begin
     if Init<>InputInitialized then Initialize(InputInitialize);
     if BytesReaded+2>BaseSize then
     begin
          Result := E_FAIL;
          Exit;
     end;
     BlockRead(F,i,2);
     inc(BytesReaded,2);
     Result := S_OK;
end;

function ReadWord(var w: word): HRESULT;
begin
     if Init<>InputInitialized then Initialize(InputInitialize);
     if BytesReaded+2>BaseSize then
     begin
          Result := E_FAIL;
          Exit;
     end;
     BlockRead(F,W,2);
     inc(BytesReaded,2);
     Result := S_OK;
end;

function ReadInt64(var i64: int64): HRESULT;
begin
     if Init<>InputInitialized then Initialize(InputInitialize);
     if BytesReaded+8>BaseSize then
     begin
          Result := E_FAIL;
          Exit;
     end;
     BlockRead(F,i64,8);
     inc(BytesReaded,8);
     Result := S_OK;
end;

procedure WriteBoolean(b: Boolean);
begin
     // Проверяем была ли проведена инициализация для записи в файл
     if Init<>OutputInitialized then Initialize(OutputInitialize);
     BlockWrite(F,B,1); // Пишем в файл
     inc(BytesWrited);  // Увеличиваем счётчик
end;

procedure WriteByte(b: byte);
begin
     if Init<>OutputInitialized then Initialize(OutputInitialize);
     BlockWrite(F,B,1);
     inc(BytesWrited);  
end;

procedure WriteInt(i: integer);
begin
     if Init<>OutputInitialized then Initialize(OutputInitialize);
     BlockWrite(F,i,2);
     inc(BytesWrited,2);
end;

procedure WriteWord(w: word);
begin
     if Init<>OutputInitialized then Initialize(OutputInitialize);
     BlockWrite(F,w,2);
     inc(BytesWrited,2);
end;

procedure WriteInt64(i64: int64);
begin
     if Init<>OutputInitialized then Initialize(OutputInitialize);
     BlockWrite(F,i64,8);
     inc(BytesWrited,8);
end;

end.
