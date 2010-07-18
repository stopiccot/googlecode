unit Calculations;

interface

procedure CreateDefaultConfig;

function GetAngle(X1,Y1,X2,Y2: double): extended;
function GetImage(angle: extended): string;


procedure inc(var i: integer;a: integer); overload
procedure inc(var i: integer); overload;

procedure dec(var i: integer;a: integer); overload
procedure dec(var i: integer); overload;

implementation

uses Classes, Math, Constants;
{-------------------------------------------------------------------------------
         Dec & inc block
-------------------------------------------------------------------------------}

procedure inc(var i: integer;a: integer); overload;
begin i:=i+a;end;

procedure inc(var i: integer); overload;
begin i:=i+1;end;

procedure dec(var i: integer;a: integer); overload;
begin i:=i-a;end;

procedure dec(var i: integer); overload;
begin i:=i-1;end;

{-------------------------------------------------------------------------------
         Name: GetAngle
         Desc: Returns angle between two points.
--------------------------------------------------------------------------------}

function GetAngle(X1,Y1,X2,Y2: double): extended;
var X,Y: double;
    gyp: extended;
begin
     Result := 0;
     X := X2-X1;
     Y := Y2-Y1;
     gyp := sqrt(sqr(X)+sqr(Y));
     if gyp=0 then gyp := 0.000001;
     if (X>0) and (Y<0) then
     begin
          Result := ArcCos(X/gyp);
     end;
     if (X<=0) and (Y<=0) then
     begin
          Result := Pi-ArcCos(-X/gyp);
     end;
     if (X<0) and (Y>0) then
     begin
          Result := Pi+ArcCos(-X/gyp);
     end;
     if (X>=0) and (Y>=0) then
     begin
          Result := 2*Pi-ArcCos(X/gyp);
     end;
     Result := result/Pi*180;
end;

{-------------------------------------------------------------------------------
         Name: GetImage
         Desc: Returns needed image for this angle
-------------------------------------------------------------------------------}
function GetImage(angle: extended): string;
var s: string;
begin
     if (angle>354.375)or(angle<=5.625)then s := '09';
     if (angle>5.625)and(angle<=16.875)then s := '08';
     if (angle>16.875)and(angle<=28.125)then s := '07';
     if (angle>28.125)and(angle<=39.275)then s := '06';
     if (angle>39.275)and(angle<=50.625)then s := '05';
     if (angle>50.625)and(angle<=61.875)then s := '04';
     if (angle>61.875)and(angle<=73.125)then s := '03';
     if (angle>73.125)and(angle<=84.375)then s := '02';
     if (angle>84.375)and(angle<=95.625)then s := '01';
     if (angle>95.625)and(angle<=106.875)then s := '32';
     if (angle>106.875)and(angle<=118.125)then s := '31';
     if (angle>118.125)and(angle<=129.375)then s := '30';
     if (angle>129.375)and(angle<=140.625)then s := '29';
     if (angle>140.625)and(angle<=151.875)then s := '28';
     if (angle>151.875)and(angle<=163.125)then s := '27';
     if (angle>163.125)and(angle<=174.375)then s := '26';
     if (angle>174.375)and(angle<=185.625)then s := '25';
     if (angle>185.375)and(angle<=196.875)then s := '24';
     if (angle>196.875)and(angle<=208.125)then s := '23';
     if (angle>208.125)and(angle<=219.375)then s := '22';
     if (angle>219.375)and(angle<=230.625)then s := '21';
     if (angle>230.625)and(angle<=241.875)then s := '20';
     if (angle>241.875)and(angle<=253.125)then s := '19';
     if (angle>253.125)and(angle<=264.375)then s := '18';
     if (angle>264.375)and(angle<=275.625)then s := '17';
     if (angle>275.625)and(angle<=286.875)then s := '16';
     if (angle>286.875)and(angle<=298.125)then s := '15';
     if (angle>298.125)and(angle<=309.375)then s := '14';
     if (angle>309.375)and(angle<=320.625)then s := '13';
     if (angle>320.625)and(angle<=331.875)then s := '12';
     if (angle>331.875)and(angle<=343.125)then s := '11';
     if (angle>343.125)and(angle<=354.375)then s := '10';
     Result:=s;
end;

{-------------------------------------------------------------------------------
         Name: CreateDefault config
         Desc: Creates default config
-------------------------------------------------------------------------------}
procedure CreateDefaultConfig;
begin
     AssignFile(output,'autoexec.cfg');
     Rewrite(output);
          Writeln('SCREEN_WIDTH=1024');
          Writeln('SCREEN_HEIGHT=768');
          Writeln('SCREEN_BIT_COUNT=32');
     CloseFile(output);
end;

end.
 