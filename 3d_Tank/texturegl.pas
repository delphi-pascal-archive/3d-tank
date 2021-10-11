unit TextureGL;

interface

Uses
  Windows, Messages, Classes, Graphics, Forms, ExtCtrls, Menus,
  Controls, Dialogs, SysUtils, OpenGL, Math;

Type
  TTextureGL = class
    Texture_pointer : glUint;
    Width,Height : word;
    pBits : pByteArray;
    Destructor Destroy; override;
    procedure LoadFrom_bmp_File1( const AFileName : String);
    procedure LoadFrom_bmp_File2( const AFileName : String);
    procedure LoadFrom_Txr_File( const AFileName : String);
    procedure Enable;
    procedure Disable;
  end;

 procedure glGenTextures(n: GLsizei; var textures: GLuint); stdcall; external opengl32;
 procedure glBindTexture(target: GLenum; texture: GLuint); stdcall; external opengl32;

 procedure Gene_Txr_from_BMP( const bmp,txr_f : String);
 function inc_bytes(a,b:byte):word;
 procedure res_bytes(z:word;var a,b:byte);

 function gluBuild2DMipmaps(Target: GLenum; Components, Width, Height: GLint; Format,atype: GLenum; Data: Pointer): GLint; stdcall; external glu32;
 procedure glDeleteTextures(N: GLsizei; Textures: PGLuint); stdcall; external opengl32;


implementation

Destructor TTextureGL.Destroy;
begin
  if Assigned(pBits) then FreeMem(pBits);
  Inherited Destroy;
end;


function ReadBitmap(const FileName : String;
                    var sWidth, tHeight: GLsizei): pointer;
const
  szh = SizeOf(TBitmapFileHeader);
  szi = SizeOf(TBitmapInfoHeader);
type
  TRGB = record
    r, g, b : GLbyte;
  end;
  TWrap = Array [0..0] of TRGB;
var
  BmpFile : File;
  bfh : TBitmapFileHeader;
  bmi : TBitmapInfoHeader;
  x, size: GLint;
  temp: GLbyte;
begin
  AssignFile (BmpFile, FileName);
  Reset (BmpFile, 1);
  Size := FileSize (BmpFile) - szh - szi;
  Blockread(BmpFile, bfh, szh);
  BlockRead (BmpFile, bmi, szi);
  If Bfh.bfType <> $4D42 then begin
    MessageBox(0, 'Invalid Bitmap', 'Error', MB_OK);
    Result := nil;
    Exit;
  end;
  sWidth := bmi.biWidth;
  tHeight := bmi.biHeight;
  GetMem (Result, Size);
  BlockRead(BmpFile, Result^, Size);
  For x := 0 to sWidth*tHeight-1 do
    With TWrap(Result^)[x] do begin
      temp := r;
      r := b;
      b := temp;
  end;
end;

procedure TTextureGl.LoadFrom_bmp_File1( const AFileName : String);
var
  buf : Pointer;
  sWidth, tHeight : GLsizei;
begin
  buf := ReadBitmap(aFileName, sWidth, tHeight);

  glGenTextures(1, Texture_pointer);
  glBindTexture(GL_TEXTURE_2D, Texture_pointer);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);

  gluBuild2DMipmaps(GL_TEXTURE_2D, 3, sWidth, tHeight, GL_RGB, GL_UNSIGNED_BYTE, buf);
 FreeMem (buf);
end;



procedure TTextureGl.LoadFrom_bmp_File2( const AFileName : String);
var B : TBitmap;
    i,j,a : Integer;
    c:byte;
begin
  B := TBitmap.Create;
  B.LoadFromFile(AFileName);
  Width := B.Width;
  Height := B.Height;

  GetMem(pBits,Width*Height*4);

  for j := 0 to Height - 1 do begin
    for i := 0 to Width - 1 do begin
      pBits[(j*Width + i)*4] := GetRValue(B.Canvas.Pixels[i,j]);
      c:=GetRValue(B.Canvas.Pixels[i,j]);
      pBits[(j*Width + i)*4+1] := GetGValue(B.Canvas.Pixels[i,j]);
      c:=c+GetgValue(B.Canvas.Pixels[i,j]);
      pBits[(j*Width + i)*4+2] := GetBValue(B.Canvas.Pixels[i,j]);
      c:=c+GetbValue(B.Canvas.Pixels[i,j]);
      pBits[(j*Width + i)*4+3] := 255;
      if c=0 then pBits[(j*Width + i)*4+3] := 0;
    end;
  end;

  glGenTextures(1, Texture_pointer);
  glBindTexture(GL_TEXTURE_2D, Texture_pointer);


  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER,GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER,GL_LINEAR_MIPMAP_NEAREST);

  gluBuild2DMipmaps(GL_TEXTURE_2D, 4, Width, Height, GL_RGBa, GL_UNSIGNED_BYTE, pbits);

  freemem(pBits);
  B.Free;
end;




procedure TTextureGl.LoadFrom_Txr_File( const AFileName : String);
var
    i,j,a : Integer;
    f:file of byte;
    c,b:byte;
begin
  assignfile(f,afilename);
  reset(f);

  read(f,c);  read(f,b);
  height:=inc_bytes(c,b);
  read(f,c);  read(f,b);
  width:=inc_bytes(c,b);


  GetMem(pBits,Width*Height*4);

  for j := 0 to Height - 1 do begin
    for i := 0 to Width - 1 do begin
      read(f,pBits[(j*Width + i)*4  ]);
      read(f,pBits[(j*Width + i)*4+1]);
      read(f,pBits[(j*Width + i)*4+2]);
      pBits[(j*Width + i)*4+3] := 255;
    end;
  end;

  closefile(f);

  glGenTextures(1, Texture_pointer);
  glBindTexture(GL_TEXTURE_2D, Texture_pointer);

  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexImage2D(GL_TEXTURE_2D,0,GL_RGBA,Width,Height,0,GL_RGBa,GL_UNSIGNED_BYTE,pBits);

  freemem(pBits);
end;


procedure TTextureGL.Enable;
begin
  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D, Texture_pointer);
end;

procedure TTextureGL.Disable;
begin
  glDisable(GL_TEXTURE_2D);
end;





procedure Gene_Txr_from_BMP( const bmp,txr_f : String);
var B : TBitmap;
    i,j : Integer;
    f:file of byte;
    c:byte;
    a:byte;
begin
  B := TBitmap.Create;
  B.LoadFromFile(bmp);

  assignfile(f,txr_f);
  rewrite(f);

  res_bytes(B.Height,c,a);
  write(f,c); write(f,a);
  res_bytes(B.width,c,a);
  write(f,c); write(f,a);

  for j := 0 to b.Height - 1 do begin
    for i := 0 to b.Width - 1 do begin
      c:=GetRValue(B.Canvas.Pixels[i,j]);
      write(f,c);
      c:=GetgValue(B.Canvas.Pixels[i,j]);
      write(f,c);
      c:=GetbValue(B.Canvas.Pixels[i,j]);
      write(f,c);
    end;
  end;

  closefile(f);
  B.Free;
end;



function dec_in_bin(ch,bits:word):string;
var i,j:integer;
    temp1,temp2:string;
    ost:byte;
begin
   temp2:='';
   temp1:='';
   for i:=1 to bits do
   begin
     ost:=ch mod 2;
     ch:=ch div 2;
     str(ost,temp1);
     if temp1<>'' then temp2:=temp1+temp2
     else temp2:='0'+temp2;
   end;
   dec_in_bin:=temp2;
end;

function bin_in_dec(s:string):word;
var i,j:integer;
    ch,temp:word;
    code:integer;
begin
   ch:=0;
   for i:=1 to length(s) do
   begin
     val(s[i],temp,code);
    
     ch:=(ch+temp)*2;
   end;
   bin_in_dec:=(ch div 2);
end;

function inc_bytes(a,b:byte):word;
var s1,s2,s3:string[50];
begin
  s1:=dec_in_bin(a,8);
  s2:=dec_in_bin(b,8);
  s3:=s1+s2;
  inc_bytes:=bin_in_dec(s3);
end;

procedure res_bytes(z:word;var a,b:byte);
var s1,s2,s3:string[50];
begin
  s3:=dec_in_bin(a,16);

  s1:=copy(s3,1,8);
  s2:=copy(s3,9,8);

  a:=bin_in_dec(s1);
  b:=bin_in_dec(s2);
end;


end.
