unit gl_max;

interface

uses
  Windows, Messages, Classes, Graphics, Forms, ExtCtrls, Menus,
  Controls, Dialogs, SysUtils, OpenGL;


type

  gl_color=array[1..3]of glfloat;

  gl_Rotate=array[1..3]of glfloat;

  text_cor=record
    x,y:glfloat;               //нормаль (вектор)
  end;

  normal=record
    x,y,z:glfloat;               //нормаль (вектор)
    znak:boolean;                //знак нормали
  end;

  sl_point=^tpoint;
  tpoint=record
    x,y,z:integer;
    texture:text_cor;
    smooh_nrml:normal;
    n:integer;             //координаты и номер
    select:boolean;              //выделение точки
    color:gl_color;              //цвет вершины
    next:sl_point;               //сл. точка в списке
  end;

  tpoint_fl=record
    x,y,z:glfloat;
  end;

  sl_poly=^tpoly;
  tpoly=record
    vr:array[1..3]of sl_point;   //Ссылки на точки в списке
    nrml:normal;                 //каждый полигон имеет свою нормаль
    gl_p_color:boolean;          //цвет полигона или по верширнам
    color:gl_color;              //цвет полигона
    next:sl_poly;                //ссылка на сл. полигон
  end;

  sl_obj=^tGL_object3D;

  tGL_object3D = class

       obj_set:record
          texture,smooth,
          color_m,light:boolean;
          draw_mode:glenum;
       end;

       angcn,angfr:array[1..3]of glfloat;
       next:sl_obj;
       x,y,z:integer;
       select:boolean;
       smooth:boolean;
      private
       fall_points:sl_point;             //Список точек
       next_p,new_p:sl_point;            //Список точек
       fall_polys,next_poly:sl_poly;     //список полигонов
       sh_points:boolean;
       sh_frame:boolean;


      public
       function put_point(x,y,z:integer):sl_point;
       function put_polygon:sl_poly;
       function get_selested:integer;
       function get_point(x,y,z:integer):sl_point;
       function get_sel_poly:sl_poly;

       procedure set_text_cor(x,y:glfloat);

       function get_col_points:integer;
       function get_col_polys:integer;

       procedure ved_diap(x,y,z,rad:glfloat);
       procedure ved_poly_by_point;

       function line_per(x1,y1,z1,x2,y2,z2:glfloat;var nrm:normal):tpoint_fl;

       procedure reset_ss_normals;
       procedure reset_sm_nrml_sel;

       procedure reset_sm_nrml;

       procedure filter_obj(x,y,z,rad:glfloat);
       procedure sin_obj(kof:glfloat);


       procedure set_s_color(r,g,b:glfloat);

       procedure de_sel;
       procedure invert_obj(x,y,z:boolean);
       procedure clear_obj;
       procedure select_all;
       procedure invert_select;
       procedure show_points(mode:boolean);
       procedure show_frame(mode:boolean);
       procedure invert_nrm;
       procedure del_polygons;
       procedure del_points;
       procedure reset_normals;      //производит расщет всех нормалей
       procedure invert_normals;     //инвертирует все нормали
       procedure LoadFromFile(const FileName : String);
       procedure Save_to_File(const FileName : String);
       procedure Draw;
  end;

  tList_objects3D = class
      private
       fall_obj,new_obj,next_obj:sl_obj;
      public
       function put_obj(x,y,z:integer;filename:string):sl_obj;
       function GET_obj_XY(x,y:integer):sl_obj;
       function GET_obj_Xz(x,z:integer):sl_obj;

       function get_col_s:integer;
       function get_col:integer;

       procedure sel_point_xz(x,z:integer);

       procedure set_color(r,g,b:glfloat);

       procedure SET_TEXT_CORD(x,y:glfloat);

       procedure filter_list(x,y,z,rad:glfloat);

       procedure reset_nrm_s;
       procedure del_poly_obj;
       procedure sdv_object(x,y,z:integer);
       procedure del_s_points;
       procedure sel_point_xy(x,y:integer);
       procedure put_poly_obj;
       procedure save_to_file_s(filename:string);
       procedure sel_all_points;
       procedure select_all;
       procedure inv_select;

       procedure inv_smooth;
       procedure set_draw_mode(mode:glenum);

       procedure show_points(b:boolean);

       procedure save_to_list_file(filename:string);
       procedure load_from_list_file(filename:string);
       procedure put_point_In_s(x,y,z:integer);
       procedure sdv_points_obj(xh,yh,zh:integer);
       procedure invert_objects(x,y,z:boolean);
       procedure Inv_sel_points;
       procedure obr_nrm_sel;
       procedure draw_list;
       procedure draw_list_xy(pw,ph,xsm,ysm,st:integer);
       procedure draw_list_xz(pw,ph,xsm,ysm,st:integer);
       procedure calk_sm_nrml;
       procedure del_obj;
       procedure clear;
  end;

 procedure butbar3d(x1,y1,z1,x2,y2,z2:real;dr_type:glenum);
 function get_Normal(p1,p2,p3:tpoint;zn:boolean):normal;
 function get_Normal_fl(p1,p2,p3:tpoint_fl):normal;
 function get_dl_line(x1,y1,z1,x2,y2,z2:glfloat):glfloat;
 function get_S_abc(x1,y1,z1,x2,y2,z2,x3,y3,z3:integer):glfloat;

 function getpoint(p1,p2,pt1,pt2,pt3:tpoint_fl;nrm:normal):tpoint_fl;

 function get_angle(x,y:glfloat):glfloat;
 function point_in_triangle(x1,y1,x2,y2,x3,y3,x,y:glfloat):boolean;
 Function PixelInOtr(x1,y1,x2,y2,x,y:glfloat):boolean;
 procedure rotate_point(angle:glfloat;var x,y:glfloat);

 procedure butbar3d_in(x1,y1,z1,x2,y2,z2:real;dr_type:glenum);


const
  select_color:gl_color=(1.0,0.0,0.0);
  not_select_c:gl_color=(0.9,0.8,0.0);
  not_select_cp:gl_color=(0.5,0.7,0.9);
  normal_color:gl_color=(0.0,0.5,0.2);
  const loop=10;


var MyMesh : tList_objects3D;


implementation


///////////////////
////конструктор////
///////////////////
{constructor tGL_object3D.create;
begin
  fall_points:=nil;
  fall_polys:=nil;
  next_p:=nil;
  new_p:=nil;
  next_poly:=nil;
  sh_points:=false;
  sh_frame:=false;

  draw_mode:=gl_line_loop;

end;        }

///////////////////////
////очистка объекта////
///////////////////////
procedure tGL_object3D.clear_obj;
begin
  select_all;
  del_points;
end;


procedure tGL_object3D.set_text_cor(x,y:glfloat);
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   if (next_p^.select) then
   begin
     next_p^.texture.x:=x;
     next_p^.texture.y:=y;
   end;
   next_p:=next_p^.next;
  end;
end;


procedure tGL_object3D.sin_obj(kof:glfloat);
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.y:=trunc( ((cos(((next_p^.z+kof))))*(cos(((next_p^.x+kof))))  )*loop);
   next_p:=next_p^.next;
  end;
  select_all;
  reset_ss_normals;
  reset_sm_nrml_sel;
end;


function tGL_object3D.line_per(x1,y1,z1,x2,y2,z2:glfloat;var nrm:normal):tpoint_fl;
var pv1,pv2,pt1,pt2,pt3,pnt:tpoint_fl;
begin
   line_per.y:=0;
   next_poly:=fall_polys;
   while next_poly<>nil do
   begin
     if (next_poly^.vr[1]^.select)and
        (next_poly^.vr[2]^.select)and
        (next_poly^.vr[3]^.select) then
     begin
      pv1.x:=x1;  pv1.y:=y1;  pv1.z:=z1;
      pv2.x:=x2;  pv2.y:=y2;  pv2.z:=z2;

      pt1.x:=next_poly^.vr[1]^.x/loop;
      pt1.y:=next_poly^.vr[1]^.y/loop;
      pt1.z:=next_poly^.vr[1]^.z/loop;

      pt2.x:=next_poly^.vr[2]^.x/loop;
      pt2.y:=next_poly^.vr[2]^.y/loop;
      pt2.z:=next_poly^.vr[2]^.z/loop;

      pt3.x:=next_poly^.vr[3]^.x/loop;
      pt3.y:=next_poly^.vr[3]^.y/loop;
      pt3.z:=next_poly^.vr[3]^.z/loop;

      pnt:=getpoint(pv1,pv2,pt1,pt2,pt3,next_poly^.nrml);

      if point_in_triangle(pt1.x,pt1.z,pt2.x,pt2.z,
      pt3.x,pt3.z,pnt.x,pnt.z) then
      begin
        line_per.x:=pnt.x;
        line_per.y:=pnt.y;
        line_per.z:=pnt.z;
        nrm:=next_poly^.nrml;
        break;
      end;
     end;
     next_poly:=next_poly^.next;
   end;
end;


procedure tGL_object3D.filter_obj(x,y,z,rad:glfloat);
var dl:glfloat;
    xt,yt,zt:glfloat;
begin
  de_sel;
  next_p:=fall_points;
  while next_p<>nil do
  begin
   dl:=get_dl_line(x,y,z,next_p^.x/loop,next_p^.y/loop,next_p^.z/loop);
   if dl<rad then
   begin
       next_p^.select:=true;
       dl:=rad/dl;
       xt:=(next_p^.x/loop)-x;
       yt:=(next_p^.y/loop)-y;
       zt:=(next_p^.z/loop)-z;

       //next_p^.x:=round(next_p^.x+(xt*dl));
       next_p^.y:=round(next_p^.y+(yt*dl));
       //next_p^.z:=round(next_p^.z+(zt*dl));

     {dl:=get_dl_line(x,y,z,next_p^.x/loop,next_p^.y/loop,next_p^.z/loop);
     if (rad*0.5)>dl then next_p^.select:=true;
      }
   end;
   next_p:=next_p^.next;
  end;
  ved_poly_by_point;
  reset_ss_normals;
  reset_sm_nrml_sel;

end;


procedure tGL_object3D.ved_diap(x,y,z,rad:glfloat);
var dl:glfloat;
    xt,yt,zt:glfloat;

begin

  next_p:=fall_points;
  while next_p<>nil do
  begin
   xt:=next_p^.x/loop;
   yt:=next_p^.y/loop;
   zt:=next_p^.z/loop;
   if (((xt)<(x+rad))and((xt)>(x-rad)))and
      (((yt)<(y+rad))and((yt)>(y-rad)))and
      (((zt)<(z+rad))and((zt)>(z-rad))) then
      next_p^.select:=true else next_p^.select:=false;

  // dl:=get_dl_line(x,y,z,next_p^.x/loop,next_p^.y/loop,next_p^.z/loop);
  // if dl<rad then next_p^.select:=true;
  next_p:=next_p^.next;
  end;
end;


///////////////////////
////установка цвета////
///////////////////////
procedure tGL_object3D.set_s_color(r,g,b:glfloat);
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   if (next_p^.select)and(next_p^.select)and(next_p^.select) then
   begin
     next_p^.color[1]:=r;
     next_p^.color[2]:=g;
     next_p^.color[3]:=b;
   end;
   next_p:=next_p^.next;
  end;
end;


///////////////////
////поиск точки////
///////////////////
function tGL_object3D.get_point(x,y,z:integer):sl_point;
begin
  get_point:=nil;
  next_p:=fall_points;
  while next_p<>nil do
  begin
   if (next_p^.x=x)and(next_p^.y=y)and(next_p^.z=z) then
   begin
    get_point:=next_p;
    break;
   end;
   next_p:=next_p^.next;
  end;
end;


////////////////////
////развыд точек////
////////////////////
procedure tGL_object3D.de_sel;
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.select:=false;
   next_p:=next_p^.next;
  end;
end;


///////////////////////////
////расщет сгл нормалей////
///////////////////////////
procedure tGL_object3D.reset_sm_nrml;
begin

  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.smooh_nrml.x:=0;
   next_p^.smooh_nrml.y:=0;
   next_p^.smooh_nrml.z:=0;
   next_p^.n:=0;
   next_p:=next_p^.next;
  end;

  next_p:=fall_points;
  while next_p<>nil do
  begin

    next_poly:=fall_polys;
    while next_poly<>nil do
    begin
      if (next_poly^.vr[1]<>next_p)and(next_poly^.vr[2]<>next_p)
      and(next_poly^.vr[3]<>next_p) then
      begin
      end else
      begin
        next_p^.smooh_nrml.x:=next_p^.smooh_nrml.x+next_poly^.nrml.x;
        next_p^.smooh_nrml.y:=next_p^.smooh_nrml.y+next_poly^.nrml.y;
        next_p^.smooh_nrml.z:=next_p^.smooh_nrml.z+next_poly^.nrml.z;
        next_p^.n:=next_p^.n+1;
      end;
      next_poly:=next_poly^.next;
    end;

    if next_p^.n<>0 then
    begin
      next_p^.smooh_nrml.x:=next_p^.smooh_nrml.x/next_p^.n;
      next_p^.smooh_nrml.y:=next_p^.smooh_nrml.y/next_p^.n;
      next_p^.smooh_nrml.z:=next_p^.smooh_nrml.z/next_p^.n;
    end;

    next_p:=next_p^.next;
  end;


end;


///////////////////////////////
////расщет сгл нормалей выд////
///////////////////////////////
procedure tGL_object3D.reset_sm_nrml_sel;
begin

  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.smooh_nrml.x:=0;
   next_p^.smooh_nrml.y:=0;
   next_p^.smooh_nrml.z:=0;
   next_p^.n:=0;
   next_p:=next_p^.next;
  end;

  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
     next_poly^.vr[1]^.smooh_nrml.x:=next_poly^.vr[1]^.smooh_nrml.x+next_poly^.nrml.x;
     next_poly^.vr[1]^.smooh_nrml.y:=next_poly^.vr[1]^.smooh_nrml.y+next_poly^.nrml.y;
     next_poly^.vr[1]^.smooh_nrml.z:=next_poly^.vr[1]^.smooh_nrml.z+next_poly^.nrml.z;
     next_poly^.vr[1].n:=next_poly^.vr[1].n+1;

     next_poly^.vr[2]^.smooh_nrml.x:=next_poly^.vr[2]^.smooh_nrml.x+next_poly^.nrml.x;
     next_poly^.vr[2]^.smooh_nrml.y:=next_poly^.vr[2]^.smooh_nrml.y+next_poly^.nrml.y;
     next_poly^.vr[2]^.smooh_nrml.z:=next_poly^.vr[2]^.smooh_nrml.z+next_poly^.nrml.z;
     next_poly^.vr[2].n:=next_poly^.vr[2].n+1;

     next_poly^.vr[3]^.smooh_nrml.x:=next_poly^.vr[3]^.smooh_nrml.x+next_poly^.nrml.x;
     next_poly^.vr[3]^.smooh_nrml.y:=next_poly^.vr[3]^.smooh_nrml.y+next_poly^.nrml.y;
     next_poly^.vr[3]^.smooh_nrml.z:=next_poly^.vr[3]^.smooh_nrml.z+next_poly^.nrml.z;
     next_poly^.vr[3].n:=next_poly^.vr[3].n+1;

     next_poly:=next_poly^.next;
   end;

  next_p:=fall_points;
  while next_p<>nil do
  begin
   if next_p^.n<>0 then
   begin
     next_p^.smooh_nrml.x:=next_p^.smooh_nrml.x/next_p^.n;
     next_p^.smooh_nrml.y:=next_p^.smooh_nrml.y/next_p^.n;
     next_p^.smooh_nrml.z:=next_p^.smooh_nrml.z/next_p^.n;
   end;
  next_p:=next_p^.next;
  end;


end;


//////////////////////
////поиск полигона////
//////////////////////
function tGL_object3D.get_sel_poly:sl_poly;
begin
  get_sel_poly:=nil;
  if get_selested=3 then
  begin

   next_poly:=fall_polys;
   while next_poly<>nil do
   begin
     if (next_poly^.vr[1]^.select)and(next_poly^.vr[2]^.select)
     and(next_poly^.vr[3]^.select) then
     begin
       get_sel_poly:=next_poly;
       break;
     end;
     next_poly:=next_poly^.next;
   end;

  end;
end;


////////////////////
////выд полигона////
///////?////////////
procedure tGL_object3D.ved_poly_by_point;
begin
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    if not((not next_poly^.vr[1]^.select)and(not next_poly^.vr[2]^.select)
    and(not next_poly^.vr[3]^.select)) then
    begin
      next_poly^.vr[1]^.select:=true;
      next_poly^.vr[2]^.select:=true;
      next_poly^.vr[3]^.select:=true;
    end;
    next_poly:=next_poly^.next;
  end;
end;


/////////////////////
////кол.полигонов////
/////////////////////
function tGL_object3D.get_col_polys:integer;
var i:integer;
begin
next_poly:=fall_polys;i:=0;
 while next_poly<>nil do
 begin
   i:=i+1;
   next_poly:=next_poly^.next;
 end;
 get_col_polys:=i;
end;

/////////////////
////кол.точек////
/////////////////
function tGL_object3D.get_col_points:integer;
var i:integer;
begin
next_p:=fall_points;i:=0;
 while next_p<>nil do
 begin
   i:=i+1;
   next_p:=next_p^.next;
 end;
 get_col_points:=i;
end;


/////////////////////////
////отображение точек////
/////////////////////////
procedure tGL_object3D.show_points(mode:boolean);
begin
  sh_points:=mode;
end;

/////////////////////////
////отображение frame////
/////////////////////////
procedure tGL_object3D.show_frame(mode:boolean);
begin
  sh_frame:=mode;
end;


//////////////////////////////////////
////инверт. нормалей у выделенного////
//////////////////////////////////////
procedure tGL_object3D.invert_nrm;
begin
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    if (next_poly^.vr[1]^.select)and(next_poly^.vr[2]^.select)
    and(next_poly^.vr[3]^.select)  then
    begin
      next_poly^.nrml.znak:=not next_poly^.nrml.znak;
      next_poly^.nrml:=get_normal(next_poly^.vr[1]^,next_poly^.vr[2]^,
                             next_poly^.vr[3]^,next_poly^.nrml.znak);
    end;
    next_poly:=next_poly^.next;
  end;
end;

///////////////////////////
////инвертирование выд.////
///////////////////////////
procedure tGL_object3D.invert_select;
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.select:=not next_p^.select;
   next_p:=next_p^.next;
  end;
end;



///////////////////////
////выделение всего////
///////////////////////
procedure tGL_object3D.select_all;
begin
  next_p:=fall_points;
  while next_p<>nil do
  begin
   next_p^.select:=true;
   next_p:=next_p^.next;
  end;
end;
///////////////////////////////////////////////
////возвращает колличество выделенных точек////
///////////////////////////////////////////////
function tGL_object3D.get_selested:integer;
var i:integer;
begin
  next_p:=fall_points;i:=0;
  while next_p<>nil do
  begin
   if next_p^.select then i:=i+1;
   next_p:=next_p^.next;
  end;
  get_selested:=i;
end;

////////////////////////////////
////удаляет выделенные точки////
////////////////////////////////
procedure tGL_object3D.del_points;
var
    pred_poly:sl_poly;
    pred_p:sl_point;
begin
  pred_poly:=nil;
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    if (not next_poly^.vr[1]^.select)and(not next_poly^.vr[2]^.select)
    and(not next_poly^.vr[3]^.select)  then
    begin
      pred_poly:=next_poly;
      next_poly:=pred_poly^.next;
    end
    else
    begin
      if pred_poly=nil then
      begin
        fall_polys:=fall_polys^.next;
        dispose(next_poly);
        next_poly:=fall_polys;
      end
      else begin
        pred_poly^.next:=next_poly^.next;
        dispose(next_poly);
        next_poly:=pred_poly^.next;
      end;
    end;
  end;

  pred_p:=nil;
  next_p:=fall_points;
  while next_p<>nil do
  begin
    if next_p^.select then
    begin
      if pred_p=nil then
      begin
        fall_points:=fall_points^.next;
        dispose(next_p);
        next_p:=fall_points;
      end
      else begin
        pred_p^.next:=next_p^.next;
        dispose(next_p);
        next_p:=pred_p^.next;
      end;
    end
    else
    begin
      pred_p:=next_p;
      next_p:=pred_p^.next;
    end;
  end;
end;

///////////////////////////////////
////удаляет выделенные полигоны////
///////////////////////////////////
procedure tGL_object3D.del_polygons;
var
  pred_poly:sl_poly;
begin
  pred_poly:=nil;
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    if (next_poly^.vr[1]^.select)and(next_poly^.vr[2]^.select)
    and(next_poly^.vr[3]^.select)  then
    begin
      if pred_poly=nil then
      begin
        fall_polys:=fall_polys^.next;
        dispose(next_poly);
        next_poly:=fall_polys;
      end
      else begin
        pred_poly^.next:=next_poly^.next;
        dispose(next_poly);
        next_poly:=pred_poly^.next;
      end;
    end
    else
    begin
      pred_poly:=next_poly;
      next_poly:=pred_poly^.next;
    end;
  end;
end;

/////////////////////////////////
////добовляет к объекту точку////
/////////////////////////////////
function tGL_object3D.put_point(x,y,z:integer):sl_point;
begin
  new(new_p);
  new_p^.x:=x;
  new_p^.y:=y;
  new_p^.z:=z;

  new_p^.select:=false;

  new_p^.color[1]:=random(100)/100;
  new_p^.color[2]:=random(100)/100;
  new_p^.color[3]:=random(100)/100;

  new_p^.next:=fall_points;
  fall_points:=new_p;
  put_point:=new_p;

end;

///////////////////////////////////
////добовляет к объекту полигон////
///////////////////////////////////
function tGL_object3D.put_polygon:sl_poly;
var i:integer;
begin
  put_polygon:=nil;
  if get_selested=3 then
  begin
    if get_sel_poly=nil then
    begin
      new(next_poly);
      next_p:=fall_points;i:=0;
      while next_p<>nil do
      begin
        if next_p^.select then
        begin
            i:=i+1;
            next_poly.vr[i]:=next_p;
        end;
       next_p:=next_p^.next;
      end;
      next_poly.nrml.znak:=false;
      next_poly.nrml:=get_normal(next_poly.vr[1]^,next_poly.vr[2]^,
                               next_poly.vr[3]^,next_poly.nrml.znak);
      next_poly.next:=fall_polys;
      fall_polys:=next_poly;
      put_polygon:=next_poly;
    end;
  end;
end;


///////////////////////////////////////
////инвертирование оббекта по оси X////
///////////////////////////////////////
procedure tGL_object3D.invert_obj(x,y,z:boolean);
begin

  if x then
  begin
    next_p:=fall_points;
    while next_p<>nil do
    begin
     next_p^.x:=-next_p^.x;
     next_p:=next_p^.next;
    end;
    invert_normals;
  end;
  if y then
  begin
    next_p:=fall_points;
    while next_p<>nil do
    begin
     next_p^.y:=-next_p^.y;
     next_p:=next_p^.next;
    end;
    invert_normals;
  end;
  if z then
  begin
    next_p:=fall_points;
    while next_p<>nil do
    begin
     next_p^.z:=-next_p^.z;
     next_p:=next_p^.next;
    end;
    invert_normals;
  end;
end;


/////////////////////////
////пересщет нормалей////
/////////////////////////
procedure tGL_object3D.reset_normals;
begin
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    next_poly^.nrml:=get_normal(next_poly^.vr[1]^,next_poly^.vr[2]^,
                     next_poly^.vr[3]^,next_poly^.nrml.znak);
    next_poly:=next_poly^.next;
  end;
end;

/////////////////////////////
////пересщет нормалей выд////
/////////////////////////////
procedure tGL_object3D.reset_ss_normals;
begin
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    if (next_poly^.vr[1].select)and(next_poly^.vr[2].select)and
    (next_poly^.vr[3].select)  then begin
           next_poly^.nrml:=get_normal(next_poly^.vr[1]^,next_poly^.vr[2]^,
                     next_poly^.vr[3]^,next_poly^.nrml.znak);
    end;
    next_poly:=next_poly^.next;
  end;
end;



///////////////////////////////
////инвертирование нормалей////
///////////////////////////////
procedure tGL_object3D.invert_normals;
begin
  next_poly:=fall_polys;
  while next_poly<>nil do
  begin
    next_poly^.nrml.znak:=not next_poly^.nrml.znak;
    next_poly:=next_poly^.next;
  end;
  reset_normals;
end;


///////////////////////////////////////
////Метод сохранения объекта в файл////
///////////////////////////////////////
procedure tGL_object3D.Save_to_File(const FileName : String);
var nomer,a,b:integer;
    f:textfile;
begin
   assignfile(f,FileName);
   rewrite(f);

   next_p:=fall_points;nomer:=0;
   while next_p<>nil do
   begin
     nomer:=nomer+1;
     next_p^.n:=nomer;
     next_p:=next_p^.next;
   end;

   writeln(f,nomer:6);
   next_p:=fall_points;
   for a:=1 to nomer do
   begin
     write(f,next_p^.x:10);
     write(f,next_p^.y:10);
     write(f,next_p^.z:10);

     write(f,next_p^.texture.x:15:6);
     writeln(f,next_p^.texture.y:15:6);

     write(f,next_p^.color[1]:6:3);
     write(f,next_p^.color[2]:6:3);
     writeln(f,next_p^.color[3]:6:3);

     next_p:=next_p^.next;
   end;

   next_poly:=fall_polys;nomer:=0;
   while next_poly<>nil do
   begin
     nomer:=nomer+1;
     next_poly:=next_poly^.next;
   end;

   writeln(f,nomer:6);next_poly:=fall_polys;
   for a:=1 to nomer do
   begin
     write(f,next_poly^.vr[1]^.n:6);
     write(f,next_poly^.vr[2]^.n:6);
     write(f,next_poly^.vr[3]^.n:6);
     b:=0;if next_poly^.nrml.znak then b:=1;
     writeln(f,b:2);
     next_poly:=next_poly^.next;
   end;


   closefile(f);

end;


///////////////////////////////////////
////Метод загрузки объекта из файла////
///////////////////////////////////////
procedure tGL_object3D.LoadFromFile(const FileName : String);
var
    nomer,a,b:integer;
    f:textfile;

begin
   clear_obj;
   fall_points:=nil;
   fall_polys:=nil;

   assignfile(f,FileName);
   reset(f);

   readln(f,nomer);
   for a:=1 to nomer do
   begin
     new(new_p);

     read(f,new_p^.x);
     read(f,new_p^.y);
     read(f,new_p^.z);

     read(f,new_p^.texture.x);
     readln(f,new_p^.texture.y);

     read(f,new_p^.color[1]);
     read(f,new_p^.color[2]);
     readln(f,new_p^.color[3]);

     new_p^.select:=false;

     new_p^.n:=a;
     new_p^.next:=fall_points;
     fall_points:=new_p;
   end;

   read(f,nomer);
   for a:=1 to nomer do
    begin
       new(next_poly);
       read(f,nomer);next_p:=fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[1]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       read(f,nomer);next_p:=fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[2]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       read(f,nomer);next_p:=fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[3]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       readln(f,b);
       next_poly^.nrml.znak:=false;
       if b=1 then next_poly^.nrml.znak:=true;


      next_poly^.next:=fall_polys;
      fall_polys:=next_poly;
   end;
   closefile(f);

   reset_normals;
   reset_sm_nrml;


end;


/////////////////////////////////
////процедура вывода на экран////
/////////////////////////////////
procedure tGL_object3D.Draw;
var q, qDisk : GLUquadricObj;

const fdl=10;
      green1 : Array [0..3] of GLfloat = (0.5, 0.5, 0.8, 0.6);

begin

  glRotatef(Angcn[1], 1.0, 0.0, 0.0);
  glRotatef(Angcn[2], 0.0, 1.0, 0.0);
  glRotatef(Angcn[3], 0.0, 0.0, 1.0);

  glTranslatef(x/loop,y/loop,z/loop);

  glRotatef(Angfr[1], 1.0, 0.0, 0.0);
  glRotatef(Angfr[2], 0.0, 1.0, 0.0);
  glRotatef(Angfr[3], 0.0, 0.0, 1.0);

  {if sh_frame then
  begin
    glColor3f (not_select_c[1],not_select_c[2],not_select_c[3]);
    if  select then glColor3f (select_color[1],select_color[2],select_color[3]);
    butbar3d(-0.05,0.05,-0.05,0.05,-0.05,0.05,GL_POLYGON);
    gldisable(GL_LIGHTING);    //отключаю работу со светом
    glBegin(gl_lines);
       glVertex3f(-fdl/loop,0,0);
       glVertex3f(fdl/loop,0,0);
       glVertex3f(0,fdl/loop,0);
       glVertex3f(0,-fdl/loop,0);
       glVertex3f(0,0,-fdl/loop);
       glVertex3f(0,0,fdl/loop);
    glEnd;
    glenable(GL_LIGHTING);
  end;   }

  if sh_points then
  begin
    next_p:=fall_points;
    while next_p<>nil do
    begin
      glPushMatrix;
      glTranslatef(next_p^.x/loop,next_p^.y/loop,next_p^.z/loop);

      glColor3f (not_select_cp[1],not_select_cp[2],not_select_cp[3]);
      if next_p^.select then glColor3f (select_color[1],select_color[2],select_color[3]);

      butbar3d(-0.05,0.05,-0.05,0.05,-0.05,0.05,GL_POLYGON);
      glPopMatrix;
      next_p:=next_p^.next;
    end;
  end;

  next_poly:=fall_polys;
  while next_poly<>nil do
  begin

     glBegin(obj_set.draw_mode);
       if (not obj_set.smooth)and(obj_set.light) then
       glnormal3f(next_poly^.nrml.x,next_poly^.nrml.y,next_poly^.nrml.z);

       if obj_set.texture then
       glTexCoord2f(next_poly^.vr[1]^.texture.x,next_poly^.vr[1]^.texture.y);
       if (obj_set.smooth)and(obj_set.light) then
       glnormal3f(next_poly^.vr[1]^.smooh_nrml.x,   next_poly^.vr[1]^.smooh_nrml.y,next_poly^.vr[1]^.smooh_nrml.z);
       if obj_set.color_m then
       glColor4f (next_poly.vr[1]^.color[1],next_poly.vr[1]^.color[2],next_poly.vr[1]^.color[3],1);
       glVertex3f(next_poly.vr[1]^.x/loop,next_poly.vr[1]^.y/loop,next_poly.vr[1]^.z/loop);

       if obj_set.texture then
       glTexCoord2f(next_poly^.vr[2]^.texture.x,next_poly^.vr[2]^.texture.y);
       if (obj_set.smooth)and(obj_set.light) then
       glnormal3f(next_poly^.vr[2]^.smooh_nrml.x,   next_poly^.vr[2]^.smooh_nrml.y,next_poly^.vr[2]^.smooh_nrml.z);;
       if obj_set.color_m then
       glColor4f (next_poly.vr[2]^.color[1],next_poly.vr[2]^.color[2],next_poly.vr[2]^.color[3],1);
       glVertex3f(next_poly.vr[2]^.x/loop,next_poly.vr[2]^.y/loop,next_poly.vr[2]^.z/loop);

       if obj_set.texture then
       glTexCoord2f(next_poly^.vr[3]^.texture.x,next_poly^.vr[3]^.texture.y);
       if (obj_set.smooth)and(obj_set.light) then
       glnormal3f(next_poly^.vr[3]^.smooh_nrml.x,   next_poly^.vr[3]^.smooh_nrml.y,next_poly^.vr[3]^.smooh_nrml.z);
       if obj_set.color_m then
       glColor4f (next_poly.vr[3]^.color[1],next_poly.vr[3]^.color[2],next_poly.vr[3]^.color[3],1);
       glVertex3f(next_poly.vr[3]^.x/loop,next_poly.vr[3]^.y/loop,next_poly.vr[3]^.z/loop);
     glEnd;

   next_poly:=next_poly^.next;
  end;
end;





/////////////////////////////////////////////////////
/////////////////////////////////////////////////////
/////////описание класса - группа объектов///////////
/////////////////////////////////////////////////////
/////////////////////////////////////////////////////



///////////////////////
////добавить объект////
///////////////////////
function tList_objects3D.put_obj(x,y,z:integer;filename:string):sl_obj;
begin
  new(new_obj);

  new_obj^:=tGL_object3D.Create;
  new_obj^.LoadFromFile(filename);

  new_obj^.x:=x;
  new_obj^.y:=y;
  new_obj^.z:=z;

  new_obj^.sh_frame:=true;
  new_obj^.sh_points:=true;

  new_obj^.obj_set.draw_mode:=gl_polygon;

  new_obj^.next:=fall_obj;
  fall_obj:=new_obj;
  put_obj:=new_obj;
end;

//////////////////////
////вывод на экран////
//////////////////////
procedure tList_objects3D.draw_list;
begin


  new_obj:=fall_obj;
  while new_obj<>nil do
  begin
   glPushMatrix;

   new_obj^.Draw;

   new_obj:=new_obj^.next;
   glPopMatrix;
  end;

end;

/////////////////////////
////вывод на экран xy////
/////////////////////////
procedure tList_objects3D.draw_list_xy(pw,ph,xsm,ysm,st:integer);
const
    df=5;
var
   i,j:integer;
   next_poly:sl_poly;
   next_p:sl_point;

   x_frame,y_frame:integer;

begin

  gldisable(GL_LIGHTING);

  glpointsize(st-2);
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    x_frame:=next_obj^.x*st;
    y_frame:=next_obj^.y*st;
    next_p:=next_obj^.fall_points;
    while next_p<>nil do
    begin
      glColor3f (not_select_cp[1],not_select_cp[2],not_select_cp[3]);
      if  next_p^.select then glColor3f (select_color[1],select_color[2],select_color[3]);
      glBegin(gl_points);
        glVertex3f((xsm*st)+x_frame+(next_p^.x*st),(ysm*st)+y_frame+(next_p^.y*st),next_obj^.z+next_p^.z);
      glEnd;
      next_p:=next_p^.next;
    end;
    next_obj:=next_obj^.next;
  end;

  glenable(GL_LIGHTING);

  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    x_frame:=next_obj^.x*st;
    y_frame:=next_obj^.y*st;

    //glColor3f (1.5,1.5,1.5);
    next_poly:=next_obj^.fall_polys;
    while next_poly<>nil do
    begin
      glBegin(next_obj^.obj_set.draw_mode);

        glnormal3f(next_poly^.nrml.x,next_poly^.nrml.y,next_poly^.nrml.z);

        glColor3f (next_poly^.vr[1]^.color[1],next_poly^.vr[1]^.color[2],next_poly^.vr[1]^.color[3]);
        glVertex3f((xsm*st)+x_frame+(next_poly.vr[1]^.x*st),(ysm*st)+y_frame+(next_poly.vr[1]^.y*st),next_obj^.z+next_poly.vr[1]^.z);

        glColor3f (next_poly^.vr[2]^.color[1],next_poly^.vr[2]^.color[2],next_poly^.vr[2]^.color[3]);
        glVertex3f((xsm*st)+x_frame+(next_poly.vr[2]^.x*st),(ysm*st)+y_frame+(next_poly.vr[2]^.y*st),next_obj^.z+next_poly.vr[2]^.z);

        glColor3f (next_poly^.vr[3]^.color[1],next_poly^.vr[3]^.color[2],next_poly^.vr[3]^.color[3]);
        glVertex3f((xsm*st)+x_frame+(next_poly.vr[3]^.x*st),(ysm*st)+y_frame+(next_poly.vr[3]^.y*st),next_obj^.z+next_poly.vr[3]^.z);

      glEnd;
      next_poly:=next_poly^.next;
    end;
    next_obj:=next_obj^.next;
  end;

  gldisable(GL_LIGHTING);

  glpointsize(st);
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    glColor3f (not_select_c[1],not_select_c[2],not_select_c[3]);
    if  next_obj^.select then glColor3f (select_color[1],select_color[2],select_color[3]);

    x_frame:=next_obj^.x*st;
    y_frame:=next_obj^.y*st;
    glBegin(gl_points);
      glVertex3f((xsm*st)+x_frame,(ysm*st)+y_frame,next_obj^.z);
    glEnd;
    glBegin(gl_lines);
      glVertex3f((xsm*st)+x_frame+(df*st),(ysm*st)+y_frame,next_obj^.z);
      glVertex3f((xsm*st)+x_frame-(df*st),(ysm*st)+y_frame,next_obj^.z);
    glEnd;
    glBegin(gl_lines);
      glVertex3f((xsm*st)+x_frame,(ysm*st)+y_frame+(df*st),next_obj^.z);
      glVertex3f((xsm*st)+x_frame,(ysm*st)+y_frame-(df*st),next_obj^.z);
    glEnd;
    next_obj:=next_obj^.next;
  end;



  glColor3f (0.4,0.7,0.4);   // рисую оси
  glBegin(gl_lines);
     glVertex2f(0,ysm*st);
     glVertex2f(pw,ysm*st);
  glEnd;
  glBegin(gl_lines);
     glVertex2f(xsm*st,0);
     glVertex2f(xsm*st,ph);
  glEnd;

  {glColor3f (0.5,0.5,0.5);
  for i:=1 to pw div st do
  begin
   glBegin(gl_lines);
     glVertex2f(i*st,0);
     glVertex2f(i*st,ph);
   glEnd;
  end;

  for i:=1 to ph div st do
  begin
    glBegin(gl_lines);
      glVertex2f(0,i*st);
      glVertex2f(pw,i*st);
    glEnd;
  end;  }
end;

/////////////////////////
////вывод на экран xz////
/////////////////////////
procedure tList_objects3D.draw_list_xz(pw,ph,xsm,ysm,st:integer);
const
    df=5;
var
   i,j:integer;
   next_poly:sl_poly;
   next_p:sl_point;

   x_frame,z_frame:integer;

begin

  //gllinewidth(5);




  glpointsize(st-2);
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    x_frame:=next_obj^.x*st;
    z_frame:=-next_obj^.z*st;
    next_p:=next_obj^.fall_points;
    while next_p<>nil do
    begin
      glColor3f (not_select_cp[1],not_select_cp[2],not_select_cp[3]);
      if  next_p^.select then glColor3f (select_color[1],select_color[2],select_color[3]);
      glBegin(gl_points);
        glVertex2f((xsm*st)+x_frame+(next_p^.x*st),(ysm*st)+z_frame-(next_p^.z*st));
      glEnd;
      next_p:=next_p^.next;
    end;
    next_obj:=next_obj^.next;
  end;

  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    x_frame:=next_obj^.x*st;
    z_frame:=-next_obj^.z*st;

    glColor3f (1.5,1.5,1.5);
    next_poly:=next_obj^.fall_polys;
    while next_poly<>nil do
    begin
      glBegin(gl_line_loop);
        glVertex2f((xsm*st)+x_frame+(next_poly.vr[1]^.x*st),(ysm*st)+z_frame-(next_poly.vr[1]^.z*st));
        glVertex2f((xsm*st)+x_frame+(next_poly.vr[2]^.x*st),(ysm*st)+z_frame-(next_poly.vr[2]^.z*st));
        glVertex2f((xsm*st)+x_frame+(next_poly.vr[3]^.x*st),(ysm*st)+z_frame-(next_poly.vr[3]^.z*st));
      glEnd;
      next_poly:=next_poly^.next;
    end;
    next_obj:=next_obj^.next;
  end;


  glpointsize(st);
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    glColor3f (not_select_c[1],not_select_c[2],not_select_c[3]);
    if  next_obj^.select then glColor3f (select_color[1],select_color[2],select_color[3]);

    x_frame:=next_obj^.x*st;
    z_frame:=-next_obj^.z*st;
    glBegin(gl_points);
      glVertex2f((xsm*st)+x_frame,(ysm*st)+z_frame);
    glEnd;
    glBegin(gl_lines);
      glVertex2f((xsm*st)+x_frame+(df*st),(ysm*st)+z_frame);
      glVertex2f((xsm*st)+x_frame-(df*st),(ysm*st)+z_frame);
    glEnd;
    glBegin(gl_lines);
      glVertex2f((xsm*st)+x_frame,(ysm*st)+z_frame+(df*st));
      glVertex2f((xsm*st)+x_frame,(ysm*st)+z_frame-(df*st));
    glEnd;
    next_obj:=next_obj^.next;
  end;



  glColor3f (0.4,0.7,0.4);   // рисую оси
  glBegin(gl_lines);
     glVertex2f(0,ysm*st);
     glVertex2f(pw,ysm*st);
  glEnd;
  glBegin(gl_lines);
     glVertex2f(xsm*st,0);
     glVertex2f(xsm*st,ph);
  glEnd;

  glColor3f (0.5,0.5,0.5);
  for i:=1 to pw div st do
  begin
   glBegin(gl_lines);
     glVertex2f(i*st,0);
     glVertex2f(i*st,ph);
   glEnd;
  end;

  for i:=1 to ph div st do
  begin
    glBegin(gl_lines);
      glVertex2f(0,i*st);
      glVertex2f(pw,i*st);
    glEnd;
  end;
end;

//////////////////////////
////Удаление из памяти////
//////////////////////////
procedure tList_objects3D.clear;
begin
  select_all;
  del_obj;
end;


//////////////////////////////////
////удаляет выделенные объекты////
//////////////////////////////////
procedure tList_objects3D.del_obj;
var
  pred_obj:sl_obj;
begin
  pred_obj:=nil;
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if next_obj^.select then
    begin
      if pred_obj=nil then
      begin
         fall_obj:=next_obj^.next;
         next_obj^.clear_obj;
         next_obj^.Destroy;
         dispose(next_obj);
         next_obj:=fall_obj;
      end
      else begin
         pred_obj^.next:=next_obj^.next;
         next_obj^.clear_obj;
         next_obj^.Destroy;
         dispose(next_obj);
         next_obj:=pred_obj^.next;
      end;;
    end
    else begin
      pred_obj:=next_obj;
      next_obj:=next_obj^.next;
    end;
  end;
end;

/////////////////////////////////
////сдвиг выделенных объектов////
/////////////////////////////////
procedure tList_objects3D.sdv_object(x,y,z:integer);
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if next_obj^.select then
    begin
       next_obj^.x:=next_obj^.x+x;
       next_obj^.y:=next_obj^.y+y;
       next_obj^.z:=next_obj^.z+z;
    end;
    next_obj:=next_obj^.next;
  end;
end;


///////////////////////////////
////выделение всех объектов////
///////////////////////////////
procedure tList_objects3D.select_all;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    next_obj^.select:=true;
    next_obj:=next_obj^.next;
  end;
end;

///////////////////////////////////////
////инверт. выделения всех объектов////
///////////////////////////////////////
procedure tList_objects3D.inv_select;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    next_obj^.select:=not next_obj^.select;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////////////
////выдает объект по 2-м координатам////
////////////////////////////////////////
function tList_objects3D.GET_obj_XY(x,y:integer):sl_obj;
begin
  GET_obj_XY:=nil;
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.x=x)and(y=next_obj^.y) then
    begin
      GET_obj_XY:=next_obj;
      break;
    end;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////////////
////выдает объект по 2-м координатам////
////////////////////////////////////////
function tList_objects3D.GET_obj_Xz(x,z:integer):sl_obj;
begin
  GET_obj_Xz:=nil;
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.x=x)and(-z=next_obj^.z) then
    begin
      GET_obj_Xz:=next_obj;
      break;
    end;
    next_obj:=next_obj^.next;
  end;
end;



///////////////////////////////////
////инверт. выделенных объектов////
///////////////////////////////////
procedure tList_objects3D.invert_objects(x,y,z:boolean);
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
      next_obj^.invert_obj(x,y,z);
    end;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////
////Кол. выделенных объектов////
////////////////////////////////
function tList_objects3D.get_col_s:integer;
var i:integer;
begin
  next_obj:=fall_obj;i:=0;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then i:=i+1;
    next_obj:=next_obj^.next;
  end;
  get_col_s:=i;
end;

///////////////////////////////////////////////
////сохраняет в файл один выделенный объект////
///////////////////////////////////////////////
procedure tList_objects3D.save_to_file_s(filename:string);
begin
  if get_col_s=1 then
  begin
    next_obj:=fall_obj;
    while next_obj<>nil do
    begin
      if (next_obj^.select) then
      begin
        next_obj^.Save_to_File(filename);
        break;
      end;
      next_obj:=next_obj^.next;
    end;
  end;
end;

///////////////////////////////////////////////
////выделяет точку в выделенных объектах xy////
///////////////////////////////////////////////
procedure tList_objects3D.sel_point_xy(x,y:integer);
var next_p:sl_point;
begin

  next_obj:=fall_obj;
  while next_obj<>nil do
  begin

    if next_obj^.select then
    begin

      next_p:=next_obj^.fall_points;
      while next_p<>nil do
      begin
        if (next_p^.x+next_obj^.x=x)and(next_p^.y+next_obj^.y=y) then
        begin
         if next_p^.select then next_p^.select:=false
         else begin
           next_p^.select:=true;
           break;
         end
        end;
        next_p:=next_p^.next;
      end;

    end;

    next_obj:=next_obj^.next;
  end;

end;

///////////////////////////////////////////////
////выделяет точку в выделенных объектах xy////
///////////////////////////////////////////////
procedure tList_objects3D.sel_point_xz(x,z:integer);
var next_p:sl_point;
begin

  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if next_obj^.select then
    begin
      next_p:=next_obj^.fall_points;
      while next_p<>nil do
      begin
        if (next_p^.x+next_obj^.x=x)and(-(next_p^.z+next_obj^.z)=z) then
        begin
         if next_p^.select then next_p^.select:=false
         else begin
           next_p^.select:=true;
           break;
         end
        end;
        next_p:=next_p^.next;
      end;
    end;
    next_obj:=next_obj^.next;
  end;
end;



/////////////////////////////////////////////
////инвертирование сглаживания в объектах////
/////////////////////////////////////////////
procedure tList_objects3D.inv_smooth;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    next_obj^.smooth:=not next_obj^.smooth;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////////////////
////удаление точек в выделенных объектах////
////////////////////////////////////////////
procedure tList_objects3D.del_s_points;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.del_points;
    end;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////
////выделение всех точек////
////////////////////////////
procedure tList_objects3D.sel_all_points;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.select_all;
    end;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////////
////инверт. выделения всех точек////
////////////////////////////////////
procedure tList_objects3D.Inv_sel_points;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.invert_select;
    end;
    next_obj:=next_obj^.next;
  end;
end;

///////////////////////////////
////Инвертирование нормалей////
///////////////////////////////
procedure tList_objects3D.obr_nrm_sel;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.invert_nrm;
    end;
    next_obj:=next_obj^.next;
  end;
end;


///////////////////////////////////////
////образование в обектах полигонов////
///////////////////////////////////////
procedure tList_objects3D.put_poly_obj;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.put_polygon;
    end;
    next_obj:=next_obj^.next;
  end;
end;

////////////////////////////////////
////удаление в обектах полигонов////
////////////////////////////////////
procedure tList_objects3D.del_poly_obj;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_obj^.del_polygons;
    end;
    next_obj:=next_obj^.next;
  end;
end;


////////////////////////
////добавление точки////
////////////////////////
procedure tList_objects3D.put_point_In_s(x,y,z:integer);
begin
 if get_col_s=1 then
 begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
      next_obj^.put_point(x-next_obj^.x,y-next_obj^.y,-(z+next_obj^.z)).select:=true;
      break;
    end;
    next_obj:=next_obj^.next;
  end;
 end;
end;


///////////////////////
////установка цвета////
///////////////////////
procedure tList_objects3D.set_color(r,g,b:glfloat);
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   if (next_obj^.select) then
   begin
     next_obj^.set_s_color(r,g,b);
   end;
   next_obj:=next_obj^.next;
 end;
end;

//////////////////////////////////////////////////
////перерасщет  нормалей у выделенных объектов////
//////////////////////////////////////////////////
procedure tList_objects3D.reset_nrm_s;
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   if (next_obj^.select) then
   begin
     next_obj^.reset_normals;
   end;
   next_obj:=next_obj^.next;
 end;
end;


///////////////////////////////
////сдвиг выд. точек на шаг////
///////////////////////////////
procedure tList_objects3D.sdv_points_obj(xh,yh,zh:integer);
var next_p:sl_point;
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    if (next_obj^.select) then
    begin
       next_p:=next_obj^.fall_points;
       while next_p<>nil do
       begin
         if next_p^.select then
         begin
          next_p^.x:=next_p^.x+xh;
          next_p^.y:=next_p^.y+yh;
          next_p^.z:=next_p^.z+zh;
         end;
         next_p:=next_p^.next;
       end;
    end;
    next_obj:=next_obj^.next;
  end;
end;




///////////////////////////////
////сдвиг выд. точек на шаг////
///////////////////////////////
procedure tList_objects3D.show_points(b:boolean);
begin
  next_obj:=fall_obj;
  while next_obj<>nil do
  begin
    next_obj^.sh_points:=b;
    next_obj:=next_obj^.next;
  end;
end;



///////////////////////////////
////число объектов в списке////
///////////////////////////////
function tList_objects3D.get_col:integer;
var i:integer;
begin
 next_obj:=fall_obj;i:=0;
 while next_obj<>nil do
 begin
   i:=i+1;
   next_obj:=next_obj^.next;
 end;
 get_col:=i;
end;


/////////////////////////////////////////
////сохранение группы объектов в файл////
/////////////////////////////////////////
procedure tList_objects3D.save_to_list_file(filename:string);
var a,b,nomer:integer;
    f:textfile;
    next_p:sl_point;
    next_poly:sl_poly;

begin

 assignfile(f,filename);
 rewrite(f);

 writeln(f,get_col:8);

 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   write(f,next_obj^.x:8);
   write(f,next_obj^.y:8);
   writeln(f,next_obj^.z:8);

   next_p:=next_obj^.fall_points;nomer:=0;
   while next_p<>nil do
   begin
     nomer:=nomer+1;
     next_p^.n:=nomer;
     next_p:=next_p^.next;
   end;

   writeln(f,nomer:6);
   next_p:=next_obj^.fall_points;
   for a:=1 to nomer do
   begin
     write(f,next_p^.x:10);
     write(f,next_p^.y:10);
     write(f,next_p^.z:10);

     write(f,next_p^.texture.x:15:6);
     writeln(f,next_p^.texture.y:15:6);

     write(f,next_p^.color[1]:6:3);
     write(f,next_p^.color[2]:6:3);
     writeln(f,next_p^.color[3]:6:3);

     next_p:=next_p^.next;
   end;

   next_poly:=next_obj^.fall_polys;nomer:=0;
   while next_poly<>nil do
   begin
     nomer:=nomer+1;
     next_poly:=next_poly^.next;
   end;

   writeln(f,nomer:6);next_poly:=next_obj^.fall_polys;
   for a:=1 to nomer do
   begin
     write(f,next_poly^.vr[1]^.n:6);
     write(f,next_poly^.vr[2]^.n:6);
     write(f,next_poly^.vr[3]^.n:6);
     b:=0;if next_poly^.nrml.znak then b:=1;
     writeln(f,b:2);
     next_poly:=next_poly^.next;
   end;

   next_obj:=next_obj^.next;
 end;

 closefile(f);

end;



/////////////////////////////
////режим воспроизведения////
/////////////////////////////
procedure tList_objects3D.set_draw_mode(mode:glenum);
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   next_obj^.obj_set.draw_mode:=mode;
   next_obj:=next_obj^.next;
 end;
end;

/////////////////////////////////////////
////сохранение группы объектов в файл////
/////////////////////////////////////////
procedure tList_objects3D.load_from_list_file(filename:string);
var a,b,nomer:integer;
    i:integer;
    f:textfile;
    new_p,next_p:sl_point;
    next_poly:sl_poly;

begin

 assignfile(f,filename);
 reset(f);

 readln(f,nomer);

 for i:=1 to nomer do
 begin

   new(new_obj);
   new_obj^:=tGL_object3D.Create;

   read(f,new_obj^.x);
   read(f,new_obj^.y);
   read(f,new_obj^.z);

   new_obj^.sh_frame:=true;
   new_obj^.sh_points:=true;
   new_obj^.obj_set.draw_mode:=gl_polygon;

   new_obj^.obj_set.draw_mode:=gl_polygon;
   new_obj^.obj_set.texture:=false;
   new_obj^.obj_set.light:=true;
   new_obj^.obj_set.color_m:=true;
   new_obj^.obj_set.smooth:=true;


   new_obj^.next:=fall_obj;
   fall_obj:=new_obj;


   readln(f,nomer);
   for a:=1 to nomer do
   begin
     new(new_p);
     read(f,new_p^.x);
     read(f,new_p^.y);
     read(f,new_p^.z);

     read(f,new_p^.texture.x);
     readln(f,new_p^.texture.y);

     read(f,new_p^.color[1]);
     read(f,new_p^.color[2]);
     readln(f,new_p^.color[3]);

     new_p^.select:=false;

     new_p^.n:=a;

     new_p^.next:=new_obj^.fall_points;
     new_obj^.fall_points:=new_p;
   end;

   read(f,nomer);
   for a:=1 to nomer do
    begin
       new(next_poly);
       read(f,nomer);next_p:=new_obj^.fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[1]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       read(f,nomer);next_p:=new_obj^.fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[2]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       read(f,nomer);next_p:=new_obj^.fall_points;;
       while next_p<>nil do
       begin
         if next_p^.n=nomer then
         begin
           next_poly.vr[3]:=next_p;
           break;
         end;
         next_p:=next_p^.next;
       end;

       readln(f,b);
       next_poly^.nrml.znak:=false;
       if b=1 then next_poly^.nrml.znak:=true;


       next_poly^.next:=new_obj^.fall_polys;
       new_obj^.fall_polys:=next_poly;
   end;

 end;


 closefile(f);
 select_all;
 sel_all_points;
 reset_nrm_s;
 Inv_sel_points;
 inv_select;

end;


/////////////////////////////////////
////подсчет сглаживающих нормалей////
/////////////////////////////////////
procedure tList_objects3D.calk_sm_nrml;
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   if next_obj^.select then
   begin
     next_obj.reset_sm_nrml;
   end;
   next_obj:=next_obj^.next;
 end;
end;





//////////////////
////фильтр... ////
//////////////////
procedure tList_objects3D.filter_list(x,y,z,rad:glfloat);
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   next_obj^.filter_obj(x-(next_obj^.x/loop),y-(next_obj^.y/loop),z-(next_obj^.z/loop),rad);
   next_obj:=next_obj^.next;
 end;
end;

procedure tList_objects3D.SET_TEXT_CORD(x,y:glfloat);
begin
 next_obj:=fall_obj;
 while next_obj<>nil do
 begin
   if next_obj^.select then
      next_obj^.set_text_cor(x,y);
   next_obj:=next_obj^.next;
 end;
end;

















procedure butbar3d_in(x1,y1,z1,x2,y2,z2:real;dr_type:glenum);
begin
    glBegin(dr_type);
      glNormal3f( 0,  -1,  0);
      glVertex3f(x1, y1, z1); glVertex3f(x2, y1, z1);
      glVertex3f(x2, y1, z2); glVertex3f(x1, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, 1,  0);
      glVertex3f(x1, y2, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x1, y2, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f(1, 0,   0);
      glVertex3f(x1, y1, z1); glVertex3f(x1, y2, z1);
      glVertex3f(x1, y2, z2); glVertex3f(x1, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( -1, 0,   0);
      glVertex3f(x2, y1, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x2, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( -1, 0,   0);
      glVertex3f(x2, y1, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x2, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, 0,  1);
      glVertex3f(x1, y1, z1); glVertex3f(x2, y1, z1);
      glVertex3f(x2, y2, z1); glVertex3f(x1, y2, z1);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, 0,   -1);
      glVertex3f(x1, y1, z2); glVertex3f(x2, y1, z2);
      glVertex3f(x2, y2, z2); glVertex3f(x1, y2, z2);
    glEnd;
end;


procedure butbar3d(x1,y1,z1,x2,y2,z2:real;dr_type:glenum);
begin
    glBegin(dr_type);
      glNormal3f( 0,  1,  0);
      glVertex3f(x1, y1, z1); glVertex3f(x2, y1, z1);
      glVertex3f(x2, y1, z2); glVertex3f(x1, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, -1,  0);
      glVertex3f(x1, y2, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x1, y2, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f(-1, 0,   0);
      glVertex3f(x1, y1, z1); glVertex3f(x1, y2, z1);
      glVertex3f(x1, y2, z2); glVertex3f(x1, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 1, 0,   0);
      glVertex3f(x2, y1, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x2, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 1, 0,   0);
      glVertex3f(x2, y1, z1); glVertex3f(x2, y2, z1);
      glVertex3f(x2, y2, z2); glVertex3f(x2, y1, z2);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, 0,  -1);
      glVertex3f(x1, y1, z1); glVertex3f(x2, y1, z1);
      glVertex3f(x2, y2, z1); glVertex3f(x1, y2, z1);
    glEnd;
    glBegin(dr_type);
      glNormal3f( 0, 0,   1);
      glVertex3f(x1, y1, z2); glVertex3f(x2, y1, z2);
      glVertex3f(x2, y2, z2); glVertex3f(x1, y2, z2);
    glEnd;
end;








Procedure Swap(Var a,b:real);
Var c : real;
Begin
  a:=c; a:=b; b:=c
End;

Procedure GetCoords(x1,y1,x2,y2,x3,y3,x4,y4:real; Var
                    x,y : glfloat; code:boolean);
Var k1,k2 : extended;
    b1,b2 : extended;
   xx, yy : extended;
Begin
   If (x1-x2=0) and (x3-x4=0) Then
   Begin
      code:=false;
      Exit;
   End;
   code:=true;
   If (x1-x2=0) and (x3<>x4) Then
   Begin
      k2:=(y3-y4)/(x3-x4);
      b2:=y3-k2*x3;
      x:=x1;
      y:=k2*x+b2;
      Exit;
   End;
   If (x3-x4=0) and (x1<>x2) Then
   Begin
      k1:=(y1-y2)/(x1-x2);
      b1:=y1-k1*x1;
      x:=x3;
      y:=k1*x+b1;
      Exit;
   End;
   If (y1=y2) and ((x1=x2) or (x3=x2)) Then
   Begin
      If x1=x2 then Begin x:=x1; y:=y3 End
      Else Begin x:=x3; y:=y1 End;
      Exit;
   End;
   If (y3=y4) and ((x1=x2) or (x3=x2)) Then
   Begin
      If x3=x4 then Begin x:=x3; y:=y1 End
      Else Begin x:=x1; y:=y3 End;
      Exit;
   End;
   k1:=(y1-y2)/(x1-x2);
   k2:=(y3-y4)/(x3-x4);
   If k1=k2 Then Begin code:=False; Exit End;
   b1:=y1-k1*x1;
   b2:=y3-k2*x3;
   If k1-k2=0 then
   Begin
      code:=False;
      Exit
   End;
   x:=(b2-b1)/(k1-k2);
   y:=k1*x+b1;
   code:=True
End;

function point_in_triangle(x1,y1,x2,y2,x3,y3,x,y:glfloat):boolean;
var code:boolean;
    xt,yt:glfloat;
    napr:array[1..4]of boolean;
label m1,m2,m3;
begin
   napr[1]:=false;
   napr[2]:=false;
   napr[3]:=false;
   napr[4]:=false;

   GetCoords(x1,y1,x2,y2,x,y,x+1,y,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x1,y1,x2,y2,xt,yt) then
      begin
      if xt>=x then napr[1]:=true;
      if xt<=x then napr[3]:=true;
      end;
   end;
   GetCoords(x2,y2,x3,y3,x,y,x+1,y,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x2,y2,x3,y3,xt,yt) then
      begin
      if xt>=x then napr[1]:=true;
      if xt<=x then napr[3]:=true;
      end;
   end;
   GetCoords(x3,y3,x1,y1,x,y,x+1,y,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x3,y3,x1,y1,xt,yt) then
      begin
      if xt>=x then napr[1]:=true;
      if xt<=x then napr[3]:=true;
      end;
   end;

   GetCoords(x1,y1,x2,y2,x,y,x,y+1,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x1,y1,x2,y2,xt,yt) then
      begin
      if yt>=y then napr[2]:=true;
      if yt<=y then napr[4]:=true;
      end;
   end;
   GetCoords(x2,y2,x3,y3,x,y,x,y+1,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x2,y2,x3,y3,xt,yt) then
      begin
      if yt>=y then napr[2]:=true;
      if yt<=y then napr[4]:=true;
      end;
   end;
   GetCoords(x3,y3,x1,y1,x,y,x,y+1,xt,yt,code);
   if code then
   begin
      if PixelInOtr(x3,y3,x1,y1,xt,yt) then
      begin
      if yt>=y then napr[2]:=true;
      if yt<=y then napr[4]:=true;
      end;
   end;

   if (napr[1])and(napr[2])and(napr[3])and(napr[4]) then
   point_in_triangle:=true else point_in_triangle:=false;

end;


Function PixelInOtr(x1,y1,x2,y2,x,y:glfloat):boolean;
  Function Sign(a:glfloat):shortint;
  Begin
    If a>0 then sign:=1 Else If a<0 Then sign:=-1 Else sign:=0
  End;
Begin
     PixelInOtr:=(Sign(x-x1)=Sign(x2-x))and(Sign(y-y1)=Sign(y2-y))
End;










function get_dl_line(x1,y1,z1,x2,y2,z2:glfloat):glfloat;
var x,y,z:glfloat;
begin
  {arctan(x/y)=y}
  x:=x2-x1;y:=y2-y1;z:=z2-z1;
  //get_dl_line:=sqrt(sqr(sqrt(sqr(x)+sqr(y)))+sqr(z));
  get_dl_line:=sqrt((x*x)+(y*y)+(z*z));
end;


procedure rotate_point(angle:glfloat;var x,y:glfloat);
var a,r:real;
begin
 if x=0 then
 begin
   r:=abs(y);
   if y>=0 then a:=90;
   if y<0 then a:=270;
 end else
 begin
   r:=sqrt((x*x)+(y*y));
   a:=abs(arctan(y/x)*180/pi);
 end;

 if (x<0)and(y>0)then a:=180-a; {2-п зҐвўҐавм}
 if (x<0)and(y<0)then a:=180+a; {3-п зҐвўҐавм}
 if (x>0)and(y<0)then a:=360-a; {4-п зҐвўҐавм}

 a:=((a+angle)*pi/180);
 x:=r*cos(a);
 y:=r*sin(a);
end;



function get_angle(x,y:glfloat):glfloat;
var a:real;
begin
  if x=0 then
  begin
    if y>0 then a:=90;
    if y<0 then a:=270;
  end else
  begin
    a:=abs(arctan(y/x)*180/pi);
  end;

  if (x<0)and(y>0)then a:=180-a;
  if (x<0)and(y<0)then a:=180+a;
  if (x>0)and(y<0)then a:=360-a;

  get_angle:=a;
end;


function get_S_abc(x1,y1,z1,x2,y2,z2,x3,y3,z3:integer):glfloat;
var a,b,c,p:glfloat;
begin
  a:=get_dl_line(x1,y1,z1,x2,y2,z2);
  b:=get_dl_line(x2,y2,z2,x3,y3,z3);
  c:=get_dl_line(x3,y3,z3,x1,y1,z1);
  p:=(a+b+c)/2;
  get_S_abc:=sqrt(p*(p-a)*(p-b)*(p-c));
end;

function getpoint(p1,p2,pt1,pt2,pt3:tpoint_fl;nrm:normal):tpoint_fl;
var p,l,m,n:glfloat;
    cen:array[1..3]of glfloat;
begin
  //nrm:=get_normal_fl(pt1,pt2,pt3);

  cen[1]:=(pt1.x+pt2.x+pt3.x)/3;
  cen[2]:=(pt1.y+pt2.y+pt3.y)/3;
  cen[3]:=(pt1.z+pt2.z+pt3.z)/3;

  p1.x:=p1.x-cen[1];  p1.y:=p1.y-cen[2];  p1.z:=p1.z-cen[3];
  p2.x:=p2.x-cen[1];  p2.y:=p2.y-cen[2];  p2.z:=p2.z-cen[3];

  pt1.x:=pt1.x-cen[1];  pt1.y:=pt1.y-cen[2];  pt1.z:=pt1.z-cen[3];
  pt2.x:=pt2.x-cen[1];  pt1.y:=pt2.y-cen[2];  pt2.z:=pt2.z-cen[3];
  pt3.x:=pt3.x-cen[1];  pt3.y:=pt3.y-cen[2];  pt3.z:=pt3.z-cen[3];


  l:=p2.x-p1.x;
  m:=p2.y-p1.y;
  n:=p2.z-p1.z;

  p:=((nrm.x*p1.x)+(nrm.y*p1.y)+(nrm.z*p1.z))
  /((nrm.x*l)+(nrm.y*m)+(nrm.z*n));

  getpoint.x:=(p1.x-(l*p))+cen[1];
  getpoint.y:=(p1.y-(m*p))+cen[2];
  getpoint.z:=(p1.z-(n*p))+cen[3];

end;

function get_Normal(p1,p2,p3:tpoint;zn:boolean):normal;
var
  wrki, vx1, vy1, vz1, vx2, vy2, vz2 : GLfloat;
  nx, ny, nz : GLfloat;
  wrkVector : tpoint;
begin
     vx1 := p1.x - p2.x;
     vy1 := p1.y - p2.y;
     vz1 := p1.z - p2.z;
     vx2 := p2.x - p3.x;
     vy2 := p2.y - p3.y;
     vz2 := p2.z - p3.z;
     // вектор перпендикулярен центру треугольника
     nx := vy1 * vz2 - vz1 * vy2;
     ny := vz1 * vx2 - vx1 * vz2;
     nz := vx1 * vy2 - vy1 * vx2;
     // получаем унитарный вектор единичной длины
     wrki := sqrt (nx * nx + ny * ny + nz * nz);
     If wrki = 0 then wrki := 1; // для предотвращения деления на ноль
     get_Normal.x := nx / wrki;
     get_Normal.y := ny / wrki;
     get_Normal.z := nz / wrki;
     if zn then
     begin
        get_Normal.x := -(nx/ wrki);
        get_Normal.y := -(ny/ wrki);
        get_Normal.z := -(nz/ wrki);
     end;
     get_Normal.znak :=zn;
end;

function get_Normal_fl(p1,p2,p3:tpoint_fl):normal;
var
  wrki, vx1, vy1, vz1, vx2, vy2, vz2 : GLfloat;
  nx, ny, nz : GLfloat;
  wrkVector : tpoint;
  f:textfile;
begin
     vx1 := p1.x - p2.x;
     vy1 := p1.y - p2.y;
     vz1 := p1.z - p2.z;
     vx2 := p2.x - p3.x;
     vy2 := p2.y - p3.y;
     vz2 := p2.z - p3.z;
     // вектор перпендикулярен центру треугольника
     nx := vy1 * vz2 - vz1 * vy2;
     ny := vz1 * vx2 - vx1 * vz2;
     nz := vx1 * vy2 - vy1 * vx2;
     // получаем унитарный вектор единичной длины
     wrki := sqrt (nx * nx + ny * ny + nz * nz);
     If wrki = 0 then wrki := 1; // для предотвращения деления на ноль

     get_Normal_fl.x := nx/ wrki;
     get_Normal_fl.y := ny/ wrki;
     get_Normal_fl.z := nz/ wrki;

     {assignfile(f,'zxzxzx');
     rewrite(f);
     writeln(f,nx:5:5);
     writeln(f,ny:5:5);
     writeln(f,nz:5:5);
     closefile(f);   }

end;


end.
