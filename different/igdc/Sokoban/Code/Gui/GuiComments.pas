unit GuiComments;
//==============================================================================
// Unit: GuiComments.pas
// Desc: Коментарии разработчиков
//==============================================================================
interface
uses
  Windows,
  Render2D, RenderTextures, RenderFont,
  GuiCursor;

  procedure Initialize;
  procedure Timer;
  procedure OnRender;
  procedure WMMouseDown;
  
implementation
uses GuiMain;
const
  Step = 20;
type
  TComment = class
  private
    Alpha: Single;
    Readed: Boolean;
    State: Byte;
    _Width: Integer;
    Flash: Byte;
  public
    X,Y,Width,Height: Integer;
    Text: PChar;
    Menu: Byte;
    constructor Create;
    procedure Timer;
    procedure WMMouseDown;
    procedure Render;
  end;

  LongString = array[0..1536]of Char;
var
  CommentsOn   : Boolean = not False;
  Width        : Integer = 20;
  TimeOut      : Integer;
  nComments    : Integer = 0;
  Comments     : array of TComment;
  LongComment1 : LongString;
  LongComment2 : LongString;
  LongComment3 : LongString;
  LongComment4 : LongString;
  LongComment5 : LongString;

//==============================================================================
// Name: Initialize
//==============================================================================
  procedure Initialize;
  var i: integer;

    procedure AddText(var ls: LongString; s: string; var n: integer);
    begin
         while s<>'' do
         begin
              ls[n] := s[1];
              inc(n);
              Delete(s,1,1);
         end;
         ls[n] := Chr(0);
         Dec(n);
    end;

  begin
       i := 0;
       AddText(LongComment1, '    Как и в прошлый раз основной упор я постарался сделать на графику. Хотелось всё сделать минималистичным и выдержанном в одном стиле и цветовой гамме. В итоге добавилась "сеточка". Фоновый рисунок не просто проявляется, а как бы рисуется, ', i);
       AddText(LongComment1, ' хотя скорее это просто "шейдерный выпендрёж" :) Интересно, можно ли сделать то же самое без применения шейдеров? Так же я перепробовал четыре вида оформления главнй менюшки. В итоге вы видите последний вариант - эдакие контуры слов. ', i);
       AddText(LongComment1, ' Ну и обязательную "точку-спереди" тоже не забыл :) По причине общего стиля отказался от деньрождениьевских примочек: ну куда мне тортики, бантики, свечечки и прочюю атрибутику пихать? Могу всех поздравить в здесь :) ', i);
       AddText(LongComment1, ' Поздравляю всех с юбилейным           (шестнадцатым по счёту) конкурсом программирования игр на Delphi!', i);

       i := 0;
       AddText(LongComment2, '    Делая About, я опять "отрывался", как дизайнер. Главная гордость - "синусная вода"(для счастливых обладателей видеокарт со вторыми шейдерами). самое интересное, что сначала был написан шейдер (так побаловаться :), ',i);
       AddText(longComment2, 'а потом уже я долго думал куда его "прикрутить", и чтоб был, и чтоб глаза не резал. Также долго не мог напридумать текста, чтоб забить весь about-screen. В итоге вспомнил даже Adobe :)', i);

       i := 0;
       AddText(LongComment3, '    Может кому-то будет интересна одна техническая деталь рендера. Чтоб c буфером, куда всё рендериться, можно было обращаться как текстурой весь рендер производиться не в этот буфер, а в текстуру (гениально не правда ли?). И только в',i);
       AddText(LongComment3, ' самом конце эта текстура рендериться в буфер. Зачем это надо? Ну, например, для водички. Хотя может её можно сделать и без этого - просто я не знаю :) Минусом всего этого является то, что в каждом кадре добавляется лишний рендер немаленькой', i);
       AddText(LongComment3, ' текстурки. Но самое главное, чтоб рендер был без артефактов, то, если игра работает в разрешении 1024x768, надо создавать текстуру размером 1025x769. Почему именно так? Не знаю :) Чуть-что это всё Microsoft виновата :)', i);

       i := 0;
       AddText(LongComment4, '    В любой игре должен быть сюжет. Обычно он "рассказывается" с помощью скриптовых сценок на движке игры, но по причине неполноценности и ущербности Orbital Engine 2.0™ скриптовых сценок в этой игре вы не увидите.', i);
       AddText(LongComment4, #10+'    Итак. Сразу предупреждаю, что никакого вселенского Зла, желающего уничтожить человечество, в этой игре вы не найдёте - игра сугубо мирная и обладает рейтингом E по версии ESRB. Видите это физическое тело округлой формы, ', i);
       AddText(LongComment4, 'совершающее гармонические колебания? Это...Действительно, что же это такое? Назовём это...ммм...точкой! Да, это "точка". Так вот.Большая "мама-точка" пообещала "точке"...ммм...пирожок. Вкусный такой. С яблоками. Объеденье.', i);
       AddText(LongComment4, ' Но, как известно, родители ничего просто так не делают. Выражаясь их же языком, пирожок надо "заслужить". Это значит, что "точка" должна наконец-то убраться - все ящики должны стоять на зелёных клеточках. Как Вы уже поняли, ', i);
       AddText(LongComment4, 'в очередной раз спасать мир не надо, надо всего-лишь помоч "точке". Всё бы ничего, но "точка" спортивные секции не посещала и сдвинуть сразу два ящика не может. Также по причине отсутствия всевозможных ручек на ящиках подтянуть их к', i);
       AddText(LongComment4, ' себе "точка" не может. Легче зайти сзади и толкнуть ящик вперёд :)', i);
       
       i := 0;
       AddText(LongComment5, '    В этот раз, наверное, мой дистрибутив опять будет самым большим. Я конечно пошёл на хитрость, считая, что d3dx9.dll должна быть на компьютере - её ведь может не быть, и тогда некоторым придёться скачать где-то 930 лишних килобайтов.', i);
       AddText(LongComment5, '. Также в этот раз у меня получилось многовато текстур - где-то 600Kb в распакованном виде. Пришлось всё паковать rar-ом, но это не лучший вариант. В идеале я бы текстуры упаковал в 7Z-архив(а он жмёт лучше, чем rar), и написал юнит распаковки 7', i);
       AddText(LongComment5, '7z(C-исходники я уже скачал осталось "всего-лишь" перевести их на Паскаль). Я думаю что каким бы большим этот юнит не получился, он не "раздул" бы exe''шник на 160Kb (именно столько вести unrar.dll). Но самое интересное это то, что UPX у меня ', i);
       AddText(LongComment5, 'упорно отказывается паковать exe''шники, откопилированные под Delphi 2006 (чего не скажешь про Delphi 2005). Вот. Так что не видать мне приза за самый маленький дистрибутив. Имхо, конечно :)', i);
       
       LoadTextureFromFile('Comment',  'textures\Comment.tga');
       LoadTextureFromFile('Checked',   'textures\check.tga');
       LoadTextureFromFile('UnChecked', 'textures\check_un.tga');

       nComments := 6; 
       SetLength(Comments, nComments);
       Comments[0] := TComment.Create;
       Comments[0].X := 25;
       Comments[0].Y := 590;
       Comments[0].Width := 190;
       Comments[0].Height := 150;
       Comments[0].Text := '    Как видтие к этой игре я решил добавить свои комментарии (Привет, Valve!) Большой смысловой нагрузки они не несут, for fun only. Можете почитать если интересно. Если они вам мозолят глаза, то внизу слева есть чекбокс.';
       Comments[0].Menu := mpMainMenu;

       Comments[1] := TComment.Create;
       Comments[1].X := 729;
       Comments[1].Y := 230;
       Comments[1].Width := 285;
       Comments[1].Height := 315;
       Comments[1].Text := @LongComment1[0];
       Comments[1].Menu := mpMainMenu;

       Comments[2] := TComment.Create;
       Comments[2].X := 200;
       Comments[2].Y := 590;
       Comments[2].Width := 280;
       Comments[2].Height := 170;
       Comments[2].Text := @LongComment2[0];
       Comments[2].Menu := mpAbout;

       Comments[3] := TComment.Create;
       Comments[3].X := 680;
       Comments[3].Y := 177;
       Comments[3].Width := 270;
       Comments[3].Height := 285;
       Comments[3].Text := @LongComment3[0];
       Comments[3].Menu := mpAbout;

       Comments[4] := TComment.Create;
       Comments[4].X := 729;
       Comments[4].Y := 50;
       Comments[4].Width := 285;
       Comments[4].Height := 470;
       Comments[4].Text := @LongComment4[0];
       Comments[4].Menu := mpGame;

       Comments[5] := TComment.Create;
       Comments[5].X := 729;
       Comments[5].Y := 120;
       Comments[5].Width := 250;
       Comments[5].Height := 400;
       Comments[5].Text := @LongComment5[0];
       Comments[5].Menu := mpSelectLevel;
  end;      

//==============================================================================
// Name: Timer
//==============================================================================
  procedure Timer;
  var i: Integer;
  begin
       if (Cursor.X>=3)and(Cursor.X<=3+Width)and(Cursor.Y>=746)and(Cursor.Y<=766) then
       begin
            if Width<150 then
            begin
                 Inc(Width, Step);
                 if Width>150 then
                 begin
                      Width := 150;
                      TimeOut := 15;
                 end;
            end;
       end else
       begin
            if TimeOut>0 then Dec(TimeOut) else
            if Width>20 then
            begin
                 Dec(Width, Step);
                 if Width<20 then Width := 20;
            end;
       end;
       for i := 0 to nComments-1 do
       begin
            Comments[i].Timer;
       end;
  end;

//==============================================================================
// Name: OnRender
//==============================================================================
  function Max(a,b:Integer):Integer;begin if a>b then Result:=a else Result:=b;end;
  
  procedure OnRender;
  var i: integer;
  begin
       // Флажок в левом нижнем углу экрана
       DrawWindow(3, 746, Width, 20);
       OutTextEx(23, 749, Max(0,Width-20), -1, 'Play with comments', 'Tahoma', 15, True, False, $FFEFEFEF);
       if CommentsOn then
            DrawSprite('Checked',   5, 748, 16, 16, $FFFFFFFF)
       else
            DrawSprite('UnChecked', 5, 748, 16, 16, $FFFFFFFF);
       // Сами коментарии
       for i := 0 to nComments - 1 do
       begin
            Comments[i].Render;
       end;
  end;

//==============================================================================
// Name: WMMouseDown
//==============================================================================
  procedure WMMouseDown;
  var i: Integer;
  begin
       if(Cursor.X>=3)and(Cursor.X<=3+Width)and(Cursor.Y>=746)and(Cursor.Y<=766)then
            CommentsOn := not CommentsOn;

       for i := 0 to nComments - 1 do Comments[i].WMMouseDown;
  end;

//==============================================================================
// Функции и процедуры класса TComment
//==============================================================================
  constructor TComment.Create;
  begin
       Alpha := 0;
       State := 0;
  end;
  
  procedure TComment.Timer;
  begin
       if (GuiMain.MenuPos = Menu)and(CommentsOn) then
       begin
            if Alpha<100 then Alpha := Alpha + 5;
       end else
       begin
            if Alpha>0   then Alpha := Alpha - 5;
       end;
       case State of
       1: begin
               if _Width<=Width then
               begin
                    _Width := _Width + Round(Width/10);
                    if _Width>Width then
                    begin
                         _Width := Width;
                         Flash := 100;
                         State := 2;
                    end;
               end;
          end;
       2: begin
               if Flash>0 then Dec(Flash,5);
          end;
       3: begin
               if _Width>=0 then
               begin
                    _Width := _Width - Round(Width/10);
                    if _Width<0 then
                    begin
                         _Width := 0;
                         State := 0;
                    end;
               end;
          end;
       end;
  end;

  procedure TComment.WMMouseDown;
  begin
       if(Cursor.X>=X-12)and(Cursor.X<=X+12)and(Cursor.Y>=Y-12)and(Cursor.Y<=Y+12)
       and(GuiMain.MenuPos=Menu)then
       begin
            if State = 0 then
            begin
                 State := 1;
                 _Width := 0;
            end;
            if State = 2 then
            begin
                 State := 3;
                 Readed := True;
            end;
       end;
  end;

  procedure TComment.Render;
  var Color: DWORD; F: Single;
  begin
       if Alpha <= 0 then Exit;
       // Отрисовка текста комментария
       case State of
       1: DrawWindow(X,Y,_Width,Round(_Width/Width*Height));
       2: begin
               F := sqr(Flash/100);
               Color := (Round(F*2*Alpha) shl 24) or $00EFEFEF;
               DrawWindow(X,Y,_Width,Round(_Width/Width*Height), Color);
               Color := (Round((0.48-0.48*F)*Alpha) shl 24) or $001e1f19;
               DrawWindow(X,Y,_Width,Round(_Width/Width*Height), Color);
               Color := (Round(Alpha*2.55) shl 24) or $00EFEFEF;
               OutTextJustify(X+10,Y+10,Width-10,Height-10,Text,'Tahoma',15,False,False,Color);
          end;
       3: DrawWindow(X,Y,_Width,Round(_Width/Width*Height), $301e1f19);
       end;
       
       // Отрисовка кружочка с тремя точкам
       Color := (Round(Alpha*2.55) shl 24) or $00FFFFFF;
       if(Cursor.X>=X-12)and(Cursor.X<=X+12)and(Cursor.Y>=Y-12)and(Cursor.Y<=Y+12)then
       begin
            if Readed then
                 DrawSpriteEx('Comment', X-12, Y-12, 36, 36, 0, 0, 1, 1, Color, 'BlackAndWhiteSmooth')
            else
                 DrawSpriteEx('Comment', X-12, Y-12, 36, 36, 0, 0, 1, 1, Color, 'Angle');
       end else
       begin
            if Readed then
                 DrawSpriteEx('Comment', X-10, Y-10, 32, 32, 0, 0, 1, 1, Color, 'BlackAndWhite')
            else
                 DrawSpriteEx('Comment', X-10, Y-10, 32, 32, 0, 0, 1, 1, Color, 'Normal');
       end;
  end;

end.
