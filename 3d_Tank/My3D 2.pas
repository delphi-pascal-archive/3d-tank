Uses Graph, CRT;


function get_x(x1,z1:integer):integer;
begin
  get_x:=round((((getmaxx/2)/(z1+(getmaxx / 2)))*x1)+(getmaxx / 2));
end;
{------------------}
function get_y(y1,z1:integer):integer;
begin
  get_y:=round((((getmaxy/2)/(z1+(getmaxy / 2)))*y1)+(getmaxy / 2));
end;

var

  g : boolean;
  S : STRING;
  gm,gd,i : integer;

  x:array[1..8]of longint;
  y:array[1..8]of longint;
  z:array[1..8]of longint;

  key:char;

Begin
  gd:=vga;
  gm:=vgamed;
  InitGraph(gd,gm,'C:\BP\BGI');

  {------------}
  x[1]:=-20; x[2]:=20;  x[3]:=20;  x[4]:=-20;
  y[1]:=50;  y[2]:=50;  y[3]:=50;  y[4]:=50;
  z[1]:=250; z[2]:=250; z[3]:=50;  z[4]:=50;

  x[5]:=-20; x[6]:=20;  x[7]:=20;  x[8]:=-20;
  y[5]:=-50; y[6]:=-50; y[7]:=-50; y[8]:=-50;
  z[5]:=250; z[6]:=250; z[7]:=50;  z[8]:=50;
  {------------}

  repeat
   if g then
     begin setvisualpage(1);setactivepage(0); end
     else begin setvisualpage(0);setactivepage(1); end;
     g:=not g;


   key:=' ';
   if keypressed then key:=readkey;

   case key of
     {-------------------}
     '4': for i:=1 to 8 do
          begin
            x[i]:=x[i]+5;
          end;
     '6': for i:=1 to 8 do
          begin
            x[i]:=x[i]-5;
          end;
     {-------------------}
     '8': for i:=1 to 8 do
          begin
            y[i]:=y[i]+5;
          end;
     '2': for i:=1 to 8 do
          begin
            y[i]:=y[i]-5;
          end;
     {-------------------}
     '1': for i:=1 to 8 do
          begin
            z[i]:=z[i]+5;
          end;
     '7': for i:=1 to 8 do
          begin
            z[i]:=z[i]-5;
          end;
     {-------------------}

   end;

   delay(350);
   cleardevice;

   outtextxy(0,00,'[8,2] - ZDVIG PO OSE "Y";');
   outtextxy(0,10,'[4,6] - ZDVIG PO OSE "X";       PROG "BAR ABSOLUTE 3D" BY ENIGMA :)');
   outtextxy(0,20,'[1,7] - ZDVIG PO OSE "Z";');

   {--------}
   str(x[1],s);
   outtextxy(0,40,'X: '+s);
   str(y[1],s);
   outtextxy(0,50,'Y: '+s);
   str(z[1],s);
   outtextxy(0,60,'Z: '+s);
   {--------}


   line(get_x(x[1],z[1]),get_y(y[1],z[1]),get_x(x[2],z[2]),get_y(y[2],z[2]));
   line(get_x(x[2],z[2]),get_y(y[2],z[2]),get_x(x[3],z[3]),get_y(y[3],z[3]));
   line(get_x(x[3],z[3]),get_y(y[3],z[3]),get_x(x[4],z[4]),get_y(y[4],z[4]));
   line(get_x(x[4],z[4]),get_y(y[4],z[4]),get_x(x[1],z[1]),get_y(y[1],z[1]));

   line(get_x(x[5],z[5]),get_y(y[5],z[5]),get_x(x[6],z[6]),get_y(y[6],z[6]));
   line(get_x(x[6],z[6]),get_y(y[6],z[6]),get_x(x[7],z[7]),get_y(y[7],z[7]));
   line(get_x(x[7],z[7]),get_y(y[7],z[7]),get_x(x[8],z[8]),get_y(y[8],z[8]));
   line(get_x(x[8],z[8]),get_y(y[8],z[8]),get_x(x[5],z[5]),get_y(y[5],z[5]));

   line(get_x(x[1],z[1]),get_y(y[1],z[1]),get_x(x[5],z[5]),get_y(y[5],z[5]));
   line(get_x(x[2],z[2]),get_y(y[2],z[2]),get_x(x[6],z[6]),get_y(y[6],z[6]));
   line(get_x(x[3],z[3]),get_y(y[3],z[3]),get_x(x[7],z[7]),get_y(y[7],z[7]));
   line(get_x(x[4],z[4]),get_y(y[4],z[4]),get_x(x[8],z[8]),get_y(y[8],z[8]));

  until key=#27;
  {------------}
  CloseGraph;
End.