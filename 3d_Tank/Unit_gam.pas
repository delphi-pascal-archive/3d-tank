unit Unit_gam;

interface
uses gl_max,opengl;

type

  snarad=record
    Ncord:array [1..3] of glfloat;
    Lcord:array [1..3] of glfloat;
    Nvect:array [1..3] of glfloat;
  end;

  next_seel=^seel;
  seel=record
    seelka:sl_obj;
    indexfr:array[1..3]of byte;
    indexcn:array[1..3]of byte;
    next:next_seel;
  end;

  model_unit=class
    ang,xb,yb,zb:glfloat;
    nrmt:normal;
    rotate:next_seel;
    model:tList_objects3D;
    procedure loadfromfile(filename:string);
    procedure rotate_obj(i:integer;angle:glfloat);
    procedure reset_obj(var map:tgl_object3d);
    procedure Pogonalka(skor:glfloat);
    procedure Go_to(x,y:glfloat);
    procedure draw;

  end;

  procedure draw_str(str:string);

implementation

procedure draw_str(str:string);
var i:byte;
    ch:char;
    az,kord:glfloat;
begin
  for i:=1 to length(str) do
  begin
    ch:=str[i];
    if ch<>' ' then
    begin
    kord:=10/1024;
    az:=kord*(ord(ch)-33);
    glBegin(gl_polygon);
      glTexCoord2f(az,1);       glVertex3f((i*8),0,0);
      glTexCoord2f(az+kord,1);  glVertex3f(((i+1)*8),0, 0);
      glTexCoord2f(az+kord,0);  glVertex3f(((i+1)*8),16, 0);
      glTexCoord2f(az,0);       glVertex3f((i*8),16, 0);
    glEnd;
    end;
  end;
end;


procedure model_unit.Go_to(x,y:glfloat);
var ang1,ang2:glfloat;
    a1,a2:glfloat;
begin
  ang1:=round(get_angle(x-xb,y-yb));
  ang1:=ang1-ang;
  if ang1<0 then ang1:=360+ang1;

  if ang1>=180 then ang:=ang-1;
  if ang1<180 then ang:=ang+1;

  Pogonalka(0.05);

end;

procedure model_unit.Pogonalka(skor:glfloat);
begin
   xb:=xb+(skor*cos((ang)*pi/180));
   yb:=yb+(skor*sin((ang)*pi/180));
end;

procedure model_unit.draw;
begin
  glPushMatrix;
    glTranslatef(xb,zb,yb);

    {vectx:=0.06;
    vecty:=0;
    vectz:=0;
    rotate_point(zoom[2]^.angfr[3],vectx,vecty);
    rotate_point(-zoom[2]^.angcn[2],vectx,vectz);

    rotate_point(ang,vectx,vectz);
    rotate_point(get_angle(nrmt.y,nrmt.x),vecty,vectx);
    rotate_point(get_angle(nrmt.y,nrmt.z),vecty,vectz);


    a:=0;    b:=0;    c:=0;
    al:=0;   bl:=0;   cl:=0;

    glBegin(gl_lines);
      glVertex3f(vectx*25,vecty*25,vectz*25);
      glVertex3f(0,0,0);
    glEnd;

    { for i:=1 to 30 do
     begin
       glBegin(gl_lines);
         glVertex3f(a,b,c);
         glVertex3f(al,bl,cl);
       glEnd;
       al:=a;
       bl:=b;
       cl:=c;
       a:=a+vectx;
       b:=b+vecty;
       c:=c+vectz;
       vecty:= vecty-ftej;
     end; }

     glRotatef(get_angle(nrmt.y,nrmt.z), 1.0, 0.0, 0.0);
     glRotatef(get_angle(nrmt.y,-nrmt.x), 0.0, 0.0, 1.0);
     glRotatef(-Ang, 0.0, 1.0, 0.0);

     model.draw_list;



   glPopMatrix;
end;

procedure model_unit.reset_obj(var map:tgl_object3d);
var bs:normal;
    p,p2:tpoint_fl;

begin
    map.ved_diap(xb,zb,yb,3);
    map.ved_poly_by_point;

    zb:=0;

   { p:=map.line_per(xb+0.5,1,yb+0.5,xb+0.5,-1,yb+0.5,bs);
    zb:=zb+p.y;
    nrmt.x:=nrmt.x+bs.x;
    nrmt.y:=nrmt.y+bs.y;
    nrmt.z:=nrmt.z+bs.z;  }

    p:=map.line_per(xb-0.5,50,yb+0.5,xb-0.5,-50,yb+0.5,bs);
    zb:=zb+p.y;
    nrmt.x:=nrmt.x+bs.x;
    nrmt.y:=nrmt.y+bs.y;
    nrmt.z:=nrmt.z+bs.z;

    {p:=map.line_per(xb-0.5,1,yb-0.5,xb-0.5,-1,yb-0.5,bs);
    zb:=zb+p.y;
    nrmt.x:=nrmt.x+bs.x;
    nrmt.y:=nrmt.y+bs.y;
    nrmt.z:=nrmt.z+bs.z;  }

    p:=map.line_per(xb+0.5,50,yb-0.5,xb+0.5,-50,yb-0.5,bs);
    zb:=zb+p.y;
    nrmt.x:=nrmt.x+bs.x;
    nrmt.y:=nrmt.y+bs.y;
    nrmt.z:=nrmt.z+bs.z;

    p:=map.line_per(xb,50,yb,xb,-50,yb,bs);
    zb:=zb+p.y+0.3;
    nrmt.x:=nrmt.x+bs.x;
    nrmt.y:=nrmt.y+bs.y;
    nrmt.z:=nrmt.z+bs.z;

    zb:=zb/3;

    nrmt.x:=nrmt.x/1.24;
    nrmt.y:=nrmt.y/1.24;
    nrmt.z:=nrmt.z/1.24;

    if ang>360 then ang:=0;
    if ang<0 then ang:=360;



end;

procedure model_unit.loadfromfile(filename:string);
var
   f:textfile;
   s:string[60];
   nomer,i:integer;
   newp:next_seel;
   x,z:integer;
begin
  assignfile(f,filename);
  reset(f);

  readln(f,s);

  model:=tList_objects3D.Create;

  model.load_from_list_file(s);
  model.set_draw_mode(gl_polygon);
  model.show_points(false);
  model.select_all;
  model.reset_nrm_s;
  model.calk_sm_nrml;
  model.inv_smooth;

  readln(f,nomer);

  for i:=1 to nomer do
  begin

    new(newp);

    read(f,x);
    readln(f,z);

    newp.seelka:=model.GET_obj_Xz(x,z);

    read(f,newp.indexfr[1]);
    read(f,newp.indexfr[2]);
    readln(f,newp.indexfr[3]);

    read(f,newp.indexcn[1]);
    read(f,newp.indexcn[2]);
    readln(f,newp.indexcn[3]);

    newp^.next:=rotate;
    rotate:=newp;
  end;

end;


procedure model_unit.rotate_obj(i:integer;angle:glfloat);
var newp:next_seel;
begin
  newp:=rotate;
  while newp<>nil do
  begin

   if newp^.indexfr[1]=i then
     newp^.seelka^.angfr[1]:=newp^.seelka^.angfr[1]+angle;
   if newp^.indexfr[2]=i then
     newp^.seelka^.angfr[2]:=newp^.seelka^.angfr[2]+angle;
   if newp^.indexfr[3]=i then
     newp^.seelka^.angfr[3]:=newp^.seelka^.angfr[3]+angle;

   if newp^.indexcn[1]=i then
     newp^.seelka^.angcn[1]:=newp^.seelka^.angcn[1]+angle;
   if newp^.indexcn[2]=i then
     newp^.seelka^.angcn[2]:=newp^.seelka^.angcn[2]+angle;
   if newp^.indexcn[3]=i then
     newp^.seelka^.angcn[3]:=newp^.seelka^.angcn[3]+angle;

   newp:=newp^.next;
  end;
end;

end.
