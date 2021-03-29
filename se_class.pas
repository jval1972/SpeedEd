//------------------------------------------------------------------------------
//
//  SpeedEd: GLSpeed map Editor utilities
//  Copyright (C) 2021 by Jim Valavanis
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, inc., 59 Temple Place - Suite 330, Boston, MA
//  02111-1307, USA.
//
// DESCRIPTION:
//  Texture class
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

unit se_class;

interface

uses
  Windows, SysUtils, Classes, Graphics;

const
  MINTEXTURESIZE = 32;
  MAXTEXTURESIZE = 2048;

type
  point2d_t = record
    X, Y: integer;
  end;
  point2d_p = ^point2d_t;

  point3d_t = record
    X, Y, Z: integer;
  end;
  point3d_p = ^point3d_t;

type
  TTexture = class(TObject)
  private
    ftexture: TBitmap;
  protected
    procedure ClearTexture;
    procedure SetTextureSize(const wval, hval: integer);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear(const newt, newh: integer);
    procedure SaveToStream(const strm: TStream; const compressed: boolean = true; const savebitmap: boolean = true);
    function LoadFromStream(const strm: TStream): boolean;
    procedure SaveToFile(const fname: string; const compressed: boolean = true);
    function LoadFromFile(const fname: string): boolean;
    property Texture: TBitmap read ftexture;
    function texturewidth: integer;
    function textureheight: integer;
  end;

function wp_validatetexturesize(const t: integer): integer;

const
  TEXTURE_MAGIC: integer = $50444157; // WADP

const
  DEF_TEXTURE_WIDTH = 4096;
  DEF_TEXTURE_HEIGHT = 4096;

implementation

uses
  Math, se_utils, zBitmap;

constructor TTexture.Create;
begin
  ftexture := TBitmap.Create;
  ftexture.Width := DEF_TEXTURE_WIDTH;
  ftexture.Height := DEF_TEXTURE_HEIGHT;
  ftexture.PixelFormat := pf32bit;

  ClearTexture;
  Inherited;
end;

destructor TTexture.Destroy;
begin
  ftexture.Free;
  Inherited
end;

procedure TTexture.ClearTexture;
var
  i: integer;
  A: PLongWordArray;
begin
  for i := 0 to ftexture.Height - 1 do
  begin
    A := PLongWordArray(ftexture.ScanLine[i]);
    ZeroMemory(A, ftexture.Width * SizeOf(LongWord));
  end;
end;

procedure TTexture.SetTextureSize(const wval, hval: integer);
var
  nw, nh: integer;
begin
  nw := wp_validatetexturesize(wval);
  nh := wp_validatetexturesize(hval);
  if (nw <> ftexture.Width) or (nh <> ftexture.Height) then
  begin
    ftexture.Width := nw;
    ftexture.Height := nh;
  end;
end;

procedure TTexture.Clear(const newt, newh: integer);
begin
  SetTextureSize(newt, newh);
  ClearTexture;
end;

procedure TTexture.SaveToStream(const strm: TStream; const compressed: boolean = true; const savebitmap: boolean = true);
var
  magic: integer;
  foo: integer;
  sz: integer;
  m: TMemoryStream;
  z: TZBitmap;
begin
  magic := TEXTURE_MAGIC;
  strm.Write(magic, SizeOf(Integer));
  foo := 0; // Reserved for future use
  strm.Write(foo, SizeOf(Integer));
  sz := ftexture.Width;
  strm.Write(sz, SizeOf(Integer));
  sz := ftexture.Height;
  strm.Write(sz, SizeOf(Integer));

  strm.Write(compressed, SizeOf(Boolean));

  m := TMemoryStream.Create;
  if savebitmap then
  begin
    if compressed then
    begin
      z := TZBitmap.Create;
      z.Assign(ftexture);
      z.PixelFormat := pf24bit;
      z.SaveToStream(m);
      z.Free;
    end
    else
      ftexture.SaveToStream(m);
    sz := m.Size;
  end
  else
    sz := 0;
  m.Position := 0;
  strm.Write(sz, SizeOf(Integer));
  if sz > 0 then
    strm.CopyFrom(m, sz);
  m.Free;
end;

function TTexture.LoadFromStream(const strm: TStream): boolean;
var
  magic: integer;
  foo: integer;
  sw, sh, sz: integer;
  m: TMemoryStream;
  z: TZBitmap;
  compressed: boolean;
begin
  strm.Read(magic, SizeOf(Integer));
  if magic <> TEXTURE_MAGIC then
  begin
    Result := False;
    Exit;
  end;

  strm.Read(foo, SizeOf(Integer));
  if foo <> 0 then
  begin
    Result := False;
    Exit;
  end;

  strm.Read(sw, SizeOf(Integer));
  strm.Read(sh, SizeOf(Integer));
  SetTextureSize(sw, sh);

  strm.Read(compressed, SizeOf(Boolean));
  strm.Read(sz, SizeOf(Integer));
  if sz > 0 then
  begin
    m := TMemoryStream.Create;
    m.CopyFrom(strm, sz);
    m.Position := 0;
    if compressed then
    begin
      z := TZBitmap.Create;
      z.LoadFromStream(m);
      z.PixelFormat := pf32bit;
      ftexture.Assign(z);
      z.Free;
    end
    else
      ftexture.LoadFromStream(m);
    m.free;
  end;

  Result := True;
end;

procedure TTexture.SaveToFile(const fname: string; const compressed: boolean = true);
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(fname, fmCreate);
  try
    SaveToStream(fs, compressed);
  finally
    fs.Free;
  end;
end;

function TTexture.LoadFromFile(const fname: string): boolean;
var
  fs: TFileStream;
begin
  fs := TFileStream.Create(fname, fmOpenRead or fmShareDenyWrite);
  try
    Result := LoadFromStream(fs);
  finally
    fs.Free;
  end;
end;

function TTexture.texturewidth: integer;
begin
  Result := ftexture.Width;
end;

function TTexture.textureheight: integer;
begin
  Result := ftexture.Height;
end;

////////////////////////////////////////////////////////////////////////////////
function wp_validatetexturesize(const t: integer): integer;
begin
  if t < MINTEXTURESIZE then
    Result := MINTEXTURESIZE
  else if t > MAXTEXTURESIZE then
    Result := MAXTEXTURESIZE
  else
    Result := t;
end;

end.
