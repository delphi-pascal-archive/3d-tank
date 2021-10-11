/////////////////////////////////////////////////////////////
///эта  прога -  "Некое убогое (и тормозное)подобие движка///
///Автор - BoogeMan            BoogeSoft@yandex.ru        ///
/////////////////////////////////////////////////////////////

unit frmMain;
interface

uses
  Windows, Messages, Classes, Graphics, Forms, ExtCtrls, OpenGL,

  gl_max,unit_gam,texturegl;

type
  Tfrmcube = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);

  private
    DC: HDC;
    hrc: HGLRC;
    Angle: GLfloat;
    Palette: HPalette;
    uTimerId : uint;  // идентификатор таймера - необходимо запомнить

    procedure SetDCPixelFormat;
  protected
    procedure WMPaint(var Msg: TWMPaint); message WM_PAINT;
    procedure WMQueryNewPalette(var Msg: TWMQueryNewPalette); message WM_QUERYNEWPALETTE;
    procedure WMPaletteChanged(var Msg: TWMPaletteChanged); message WM_PALETTECHANGED;
  end;

type
     point=record
       x,y,z:real;
     end;

     material=record
       ambient:record
         r,g,b,a:glFloat;
       end;
       diffuse:record
         r,g,b,a:glFloat;
       end;
       specular:record
         r,g,b,a:glFloat;
       end;
       emission:record
         r,g,b,a:glFloat;
       end;
       shininess:glFloat;
     end;

type keyd=record
      key:char;
      down:boolean;
     end;


const
  col_keys=30;

var
  frmcube: Tfrmcube;

  font1,water,water1:TTextureGL;

  angx,angy,fov,rastx,rasty:glfloat;

  lfps,prm,fps,zad:real;   //Все для fps-ов
  sfps:string[100];

  xx:array[1..15] of keyd;

  mesh1:tgl_object3D;

  moused:boolean;
  msx,msy:integer;

  angx1,angy1:glfloat;
  xb1,yb1,zb1:glfloat;

  zoom:array[1..2]of sl_obj;


  nrmt:normal;

  xcam,ycam,zcam:glfloat;

  bzz,z,player_model:model_unit;
  zero:boolean;
  r:glfloat;

  boom:snarad;


implementation

uses mmSystem;

{$R *.DFM}


{=======================================================================
Обработка таймера}
procedure FNTimeCallBack(uTimerID, uMessage: UINT;dwUser, dw1, dw2: DWORD) stdcall;
begin
  // Каждый "тик" изменяется значение угла

  frmCube.Angle := frmCube.Angle + 0.00001;
  If (frmCube.Angle >= 360.0) then frmCube.Angle := 0.0;
  InvalidateRect(frmCube.Handle, nil, False); // перерисовка региона
end;

{=======================================================================
Рисование картинки}
procedure Tfrmcube.WMPaint(var Msg: TWMPaint);
const ftej=0.023;
var
  ps : TPaintStruct;
  s : string;

  i,j:integer;
  a,b,c,al,bl,cl:real;
  bz,yt,xt,zt:glfloat;//координаты текстуры
  bs:normal;

begin

 //glMatrixMode(GL_PROJECTION);
 glLoadIdentity;
 gluPerspective(fov, clientWidth / clientHeight, 1, 70.0);
 glViewport(0, 0, Width, Height);
 glMatrixMode(GL_MODELVIEW);

 prm:=gettickcount;          //Смотрю на часы
 if prm-lfps>10 then
 begin


   if xx[1].down then player_model.ang:=player_model.ang-2;
   if xx[3].down then player_model.ang:=player_model.ang+2;

   if xx[2].down then player_model.Pogonalka( 0.10);
   if xx[7].down then player_model.Pogonalka(-0.05);

   if xx[4].down then player_model.rotate_obj(1,1);
   if xx[5].down then player_model.rotate_obj(1,-1);

   if xx[6].down then angy:=angy-1;
   if xx[8].down then angy:=angy+1;


 if zoom[1]^.angcn[2]>360 then
 begin
   zoom[1]^.angcn[2]:=0;
   zoom[2]^.angcn[2]:=0;
 end;

 if zoom[1]^.angcn[2]<0 then
 begin
   zoom[1]^.angcn[2]:=360;
   zoom[2]^.angcn[2]:=360;
 end;

 if zoom[2]^.angfr[3]>35 then
    zoom[2]^.angfr[3]:=35;
 if zoom[2]^.angfr[3]<0 then
    zoom[2]^.angfr[3]:=0;


   BeginPaint(Handle, ps);


   glClear(GL_DEPTH_BUFFER_BIT or GL_COLOR_BUFFER_BIT);

   glLoadIdentity;                // трехмерность

   glPushMatrix;

/////////////////////////////////////

  { if xx[7].down then
   begin
      angy:=angy+1;
    {  boom.Nvect[1]:=vectx;
      boom.Nvect[2]:=vecty;
      boom.Nvect[3]:=vectz;

      boom.Ncord[1]:=xb;
      boom.Ncord[2]:=p.y+0.03;
      boom.Ncord[3]:=yb;

      boom.Lcord[1]:=xb;
      boom.Lcord[2]:=p.y+0.03;
      boom.Lcord[3]:=yb; }
 //  end;

   // mesh1.de_sel;
  {

   boom.Lcord[1]:=boom.Ncord[1];
   boom.Lcord[2]:=boom.Ncord[1];
   boom.Lcord[3]:=boom.Ncord[1];

   boom.Ncord[1]:=boom.Ncord[1]+boom.Nvect[1];
   boom.Ncord[2]:=boom.Ncord[2]+boom.Nvect[2];
   boom.Ncord[3]:=boom.Ncord[3]+boom.Nvect[3];

   boom.Nvect[2]:=boom.Nvect[2]-ftej;

    mesh1.ved_diap(boom.Ncord[1],boom.Ncord[2],boom.Ncord[3],4);
    mesh1.ved_poly_by_point;

    p2:=mesh1.line_per(boom.Ncord[1],-2,boom.Ncord[3]
                   ,boom.ncord[1],2,boom.ncord[3],bs);
{    if (p2.y>boom.Ncord[2]) then
      begin
      mesh1.filter_obj(p2.x+bs.x,p2.y+bs.y,p2.z+bs.z,6);

      boom.Nvect[1]:=0;
      boom.Nvect[2]:=0;
      boom.Nvect[3]:=0;

      boom.Ncord[1]:=0;
      boom.Ncord[2]:=100;
      boom.Ncord[3]:=0;

      boom.Lcord[1]:=0;
      boom.Lcord[2]:=100;
      boom.Lcord[3]:=0;
     end;     }

   xt:=0; yt:=rastx;



   angx1:=(angx1+angx)/1.3;
   angy1:=(angy1+angy)/1.3;



   rotate_point(angy1,xt,yt);
   //rotate_point(angx1,zt,xt);

   mesh1.select_all;
   zt:=mesh1.line_per(player_model.xb+yt,10,player_model.yb+xt,
        player_model.xb+yt,-10,player_model.yb+xt,bs).y+rasty;


   if zero then
   begin
     xcam:=(player_model.xb+xcam)/2;
     ycam:=(player_model.yb+ycam)/2;
     zcam:=(player_model.zb+zcam)/2;
   end;

   gluLookAt (xcam+yt,zcam+zt,ycam+xt,
   xcam,zcam,ycam, -yt,zcam,-xt);

   //player_model.Go_to(z.xb,z.yb);
   player_model.reset_obj(mesh1);
   player_model.draw;

   z.Go_to(player_model.xb,player_model.yb);
   z.reset_obj(mesh1);
   z.reset_obj(mesh1);
   z.reset_obj(mesh1);
   z.reset_obj(mesh1);

   z.draw;

   water.Enable;
   glColor3f(1.0, 1.0, 1.0);
   mesh1.Draw;

   glBlendFunc(GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA);
   glEnable(GL_BLEND);

   glnormal3f(0,1,0);
   gldisable(GL_LIGHTING);

   {glEnable(GL_TEXTURE_GEN_S);     // Enable spherical
   glEnable(GL_TEXTURE_GEN_T);     // Environment Mapping
    }

   water1.Enable;
   glColor4f(0.8, 0.8, 1.2, 0.5);
   xt:=5*cos(angle*50*pi/180);
   yt:=5*sin(angle*50*pi/180);
   glBegin(gl_polygon);
     glTexCoord2f(0.5+xt,0.5+yt);
     glVertex3f( 45,-1.3, 45);
     glTexCoord2f(0+xt,0.5+yt);
     glVertex3f(-45,-1.3, 45);
     glTexCoord2f(0+xt,0+yt);
     glVertex3f(-45,-1.3,-45);
     glTexCoord2f(0.5+xt,0+yt);
     glVertex3f( 45,-1.3,-45);
   glEnd;

   glEnable(GL_LIGHTING);
   glPopMatrix;


  // gldisable(GL_BLEND);
   glMatrixMode(GL_projection);
   glLoadIdentity;
   glortho(0,frmcube.ClientWidth,0,frmcube.Clientheight,-800,800);
   font1.Enable;
   glNormal3f( 0, 0,  1);
   //gldisable(GL_DEPTH_TEST);// разрешаем тест глубины
   glColor4f(0.8, 0.8, 1.2, 1);

   {определение и вывод fps-ов}
    if prm-zad>100 then
    begin
      fps:=1000/(prm-lfps);
      str(fps:7:4,s);
      sfps:=' Fps: '+s;
      zad:=prm;
    end;
    lfps:=prm;

   glTranslatef(0,height-75,0);
   str(player_model.xb:8:4,s);
   draw_str('   X: '+s);

   glTranslatef(0,-15,0);
   str(player_model.yb:8:4,s);
   draw_str('   Y: '+s);

   glTranslatef(0,-15,0);
   str(player_model.Zb:8:4,s);
   draw_str('   Z: '+s);



   glTranslatef(150,30,0);
   draw_str('Mode: '+glGetString(GL_RENDERER));

   glTranslatef(0,-15,0);
   str(fov:7:4,s);
   draw_str(' Fov: '+s);

   glTranslatef(0,-15,0);
   draw_str(sfps);



   font1.Disable;

   glenable(GL_DEPTH_TEST);// разрешаем тест глубины   }



   SwapBuffers(DC);               // конец работы
   EndPaint(Handle, ps);

 end;
   {-------------------------}
end;



{=======================================================================
Создание окна}
procedure Tfrmcube.FormCreate(Sender: TObject);
 function SetFullscreenMode(ModeIndex: Integer) : Boolean;
 var DeviceMode : TDevMode;
 begin
  with DeviceMode do
  begin
   dmSize:=SizeOf(DeviceMode);
   dmBitsPerPel:=256;
   dmPelsWidth:=640;
   dmPelsHeight:=480;
   dmFields:=DM_PELSWIDTH or DM_PELSHEIGHT;
   // при неудачной смене режима переходим в режим текущего разрешения
   Result:=ChangeDisplaySettings(DeviceMode,CDS_FULLSCREEN) = DISP_CHANGE_SUCCESSFUL;
   if Result then SetFullscreenMode:=True else SetFullscreenMode:=false;
  end;
 end;


begin

  frmcube.ClientHeight:=480;
  frmcube.clientWidth:=640;


  DC := GetDC(Handle);
  SetDCPixelFormat;
  hrc := wglCreateContext(DC);
  wglMakeCurrent(DC, hrc);

  glEnable(GL_DEPTH_TEST);// разрешаем тест глубины
  glEnable(GL_LIGHTING);  // разрешаем работу с освещенностью


  xx[1].key:='A';xx[1].down:=false;
  xx[2].key:='W';xx[2].down:=false;
  xx[3].key:='D';xx[3].down:=false;
  xx[4].key:='P';xx[2].down:=false;
  xx[5].key:='O';xx[3].down:=false;
  xx[6].key:='Y';xx[2].down:=false;
  xx[7].key:='S';xx[3].down:=false;
  xx[8].key:='U';xx[3].down:=false;


  glClearColor (0, 0, 0, 1);

  angx:=0;

  nrmt.x:=0;
  nrmt.y:=-10;
  nrmt.z:=0;

  fov:=45;
  rastx:=10;
  rasty:=10;

  mesh1:=tgl_object3D.create;
  mesh1.LoadFromFile('obj\plosk.lst');


  mesh1.obj_set.draw_mode:=gl_polygon;
  mesh1.obj_set.texture:=true;
  mesh1.obj_set.smooth:=true;
  mesh1.obj_set.color_m:=true;
  mesh1.obj_set.light:=true;

  mesh1.show_points(false);
  //mesh1.select_all;


  player_model:=model_unit.Create;
  player_model.loadfromfile('models\model_tank.txt');

  z:=model_unit.Create;
  z.loadfromfile('models\model_tank.txt');
  z.xb:=9;
  z.yb:=9;

  water:=ttexturegl.Create;
  water.LoadFrom_bmp_File1('textures\stone.bmp');

  water1:=ttexturegl.Create;
  water1.LoadFrom_bmp_File1('textures\water1.bmp');

  font1:=ttexturegl.Create;
  font1.LoadFrom_bmp_File2('font.bmp');

  zoom[1]:=player_model.model.GET_obj_Xz(-1,0);
  zoom[2]:=player_model.model.GET_obj_XY(2,7);

    //туман
    glFogi(GL_FOG_MODE, GL_exp2);
    glFogfv(GL_FOG_COLOR, @color);
    //glFogf(GL_FOG_START,25);
    //glFogf(GL_FOG_END ,55);
    glFogf(GL_FOG_DENSITY, 0.035);
    glEnable (GL_FOG);
   //Включен1
    glenable(GL_COLOR_MATERIAL);
    glEnable(GL_LIGHT0);

//    glEnable(GL_CULL_FACE);

  uTimerID := timeSetEvent (2, 0, @FNTimeCallBack, 0, TIME_PERIODIC);

end;


{=======================================================================
Конец работы программы}
procedure Tfrmcube.FormDestroy(Sender: TObject);
begin
  player_model.model.clear;
  player_model.model.Destroy;
  player_model.Destroy;
  mesh1.clear_obj;
  mesh1.Destroy;

  timeKillEvent(uTimerID);
  wglMakeCurrent(0, 0);
  wglDeleteContext(hrc);
  ReleaseDC(Handle, DC);
end;

{=======================================================================
Обработка нажатия клавиши}
procedure Tfrmcube.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const r=0.1;
var c:char;

begin
  c:=chr(key);
  if xx[1].key=c then xx[1].down:=true;
  if xx[2].key=c then xx[2].down:=true;
  if xx[3].key=c then xx[3].down:=true;
  if xx[4].key=c then xx[4].down:=true;
  if xx[5].key=c then xx[5].down:=true;
  if xx[6].key=c then xx[6].down:=true;
  if xx[7].key=c then xx[7].down:=true;
  if xx[8].key=c then xx[8].down:=true;

  if c='F' then
  begin

    mesh1.filter_obj(player_model.xb,6,player_model.yb,10);
  end;
  if c='G' then
  begin
    mesh1.filter_obj(player_model.xb,-6,player_model.yb,10);
  end;
end;



{=======================================================================
Устанавливаем формат пикселей}
procedure Tfrmcube.SetDCPixelFormat;
var
 hHeap: THandle;
 nColors, i: Integer;
 lpPalette: PLogPalette;
 byRedMask, byGreenMask, byBlueMask: Byte;
 nPixelFormat: Integer;
 pfd: TPixelFormatDescriptor;
begin
 FillChar(pfd, SizeOf(pfd), 0);

 with pfd do begin
   nSize     := sizeof(pfd);
   nVersion  := 1;
   dwFlags   := PFD_DRAW_TO_WINDOW or
                PFD_SUPPORT_OPENGL or
                PFD_DOUBLEBUFFER;
   iPixelType:= PFD_TYPE_RGBA;
   cColorBits:= 24;
   cDepthBits:= 32;
   iLayerType:= PFD_MAIN_PLANE;
 end;

 nPixelFormat := ChoosePixelFormat(DC, @pfd);
 SetPixelFormat(DC, nPixelFormat, @pfd);

 DescribePixelFormat(DC, nPixelFormat, sizeof(TPixelFormatDescriptor), pfd);

 if ((pfd.dwFlags and PFD_NEED_PALETTE) <> 0) then begin
   nColors   := 1 shl pfd.cColorBits;
   hHeap     := GetProcessHeap;
   lpPalette := HeapAlloc(hHeap, 0, sizeof(TLogPalette) + (nColors * sizeof(TPaletteEntry)));

   lpPalette^.palVersion := $300;
   lpPalette^.palNumEntries := nColors;

   byRedMask   := (1 shl pfd.cRedBits) - 1;
   byGreenMask := (1 shl pfd.cGreenBits) - 1;
   byBlueMask  := (1 shl pfd.cBlueBits) - 1;

   for i := 0 to nColors - 1 do begin
     lpPalette^.palPalEntry[i].peRed   := (((i shr pfd.cRedShift)   and byRedMask)   * 255) DIV byRedMask;
     lpPalette^.palPalEntry[i].peGreen := (((i shr pfd.cGreenShift) and byGreenMask) * 255) DIV byGreenMask;
     lpPalette^.palPalEntry[i].peBlue  := (((i shr pfd.cBlueShift)  and byBlueMask)  * 255) DIV byBlueMask;
     lpPalette^.palPalEntry[i].peFlags := 0;
   end;

   Palette := CreatePalette(lpPalette^);
   HeapFree(hHeap, 0, lpPalette);

   if (Palette <> 0) then begin
     SelectPalette(DC, Palette, False);
     RealizePalette(DC);
   end;
 end;
end;

{=======================================================================
Сообщение WM_QUERYNEWPALETTE}
procedure Tfrmcube.WMQueryNewPalette(var Msg : TWMQueryNewPalette);
begin
 if (Palette <> 0) then begin
   Msg.Result := RealizePalette(DC);

 if (Msg.Result <> GDI_ERROR) then
   InvalidateRect(Handle, nil, False);
 end;
end;

{=======================================================================
Сообщение WM_PALETTECHANGED}
procedure Tfrmcube.WMPaletteChanged(var Msg : TWMPaletteChanged);
begin
 if ((Palette <> 0) and (THandle(TMessage(Msg).wParam) <> Handle))
 then begin
   if (RealizePalette(DC) <> GDI_ERROR) then
     UpdateColors(DC);

   Msg.Result := 0;
 end;
end;

procedure Tfrmcube.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var c:char;
begin

  c:=chr(key);
  if xx[1].key=c then xx[1].down:=false;
  if xx[2].key=c then xx[2].down:=false;
  if xx[3].key=c then xx[3].down:=false;
  if xx[4].key=c then xx[4].down:=false;
  if xx[5].key=c then xx[5].down:=false;
  if xx[6].key=c then xx[6].down:=false;
  if xx[7].key=c then xx[7].down:=false;
  if xx[8].key=c then xx[8].down:=false;
end;



procedure Tfrmcube.FormKeyPress(Sender: TObject; var Key: Char);
begin
 case key of
   'q':angx:=angx+1;
   'e':angx:=angx-1;
   '1':zoom[2]^.angfr[3]:=zoom[2]^.angfr[3]+1;
   '3':zoom[2]^.angfr[3]:=zoom[2]^.angfr[3]-1;
   '-':fov:=fov+1;
   '+':fov:=fov-1;

   '7':rastx:=rastx+0.2;
   '9':begin
         rastx:=rastx-0.2;
         if rastx<0.2 then rastx:=0.2;
       end;

   'k':rasty:=rasty+0.2;
   'l':begin
         rasty:=rasty-0.2;
         if rasty<2 then rasty:=2;
       end;

   '0':zero:=not zero;
   #27:close;
 end;
end;


{procedure Tfrmcube.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  moused:=true;
end;

procedure Tfrmcube.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  moused:=false;
end;

procedure Tfrmcube.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if moused then
  begin
    angy:=angy-((x-msx)/3);
    angx:=angx+((y-msy)/3);
  end;
  msx:=x;msy:=y;
end;    }



end.

