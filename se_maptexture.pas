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
//  GLSpeed Map Texture
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

unit se_maptexture;

interface

uses
  Windows, SysUtils, Classes, Graphics, se_utils;

const
  SCREENSIZEX = 64;
  SCREENSIZEY = 64;
  SCREENSIZE = SCREENSIZEX * SCREENSIZEY;
  TILESIZE = 64;

type
  maptexture_t = packed record
    filler: LongWord;
    maptiles: packed array[0..SCREENSIZE - 1] of smallint;
    angles: packed array[0..SCREENSIZE - 1] of byte;
  end;
  Pmaptexture_t = ^maptexture_t;


type
  buffer_t = packed array[0..4095] of byte;
  bmbuffer4096_t = packed array[0..4095] of buffer_t;
  bmbuffer4096_p = ^bmbuffer4096_t;
  bmbuffer8192_t = packed array[0..8191] of packed array[0..8191] of byte;
  bmbuffer8192_p = ^bmbuffer8192_t;

type
  TMapTexture = class(TObject)
  private
    data: Pmaptexture_t;
    function getidx(const x, y: integer): integer;
  protected
    procedure SetMapTile(x, y: integer; const tile: integer); virtual;
    function GetMapTile(x, y: integer): integer; virtual;
    procedure SetAngle(x, y: integer; const ang: integer); virtual;
    function GetAngle(x, y: integer): integer; virtual;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear;
    procedure SaveToStream(const strm: TStream);
    procedure LoadFromStream(const strm: TStream);
    function GetExportText(const aX1: integer = -1; const aX2: integer = -1;
      const aY1: integer = -1; const aY2: integer = -1): string;
    procedure ApplyImportText(const tx: string; const aX1: integer = -1; const aX2: integer = -1;
      const aY1: integer = -1; const aY2: integer = -1);
    procedure GetBitmap(const b: TBitmap; const doublesize: boolean);
    procedure GetBuffer4096(const buf4096: bmbuffer4096_p);
    procedure GetBuffer8192(const buf8192: bmbuffer8192_p);
    procedure AssignTo(const amaptexture: TMapTexture);
    property MapTiles[x, y: integer]: integer read GetMapTile write SetMapTile;
    property Angles[x, y: integer]: integer read GetAngle write SetAngle;
  end;

implementation

uses
  se_grafs, se_scriptengine;

constructor TMapTexture.Create;
begin
  Inherited;
  GetMem(data, SizeOf(maptexture_t));
  Clear;
end;

destructor TMapTexture.Destroy;
begin
  FreeMem(data, SizeOf(maptexture_t));
  Inherited;
end;

procedure TMapTexture.Clear;
begin
  ZeroMemory(data, SizeOf(maptexture_t));
end;

function TMapTexture.getidx(const x, y: integer): integer;
begin
  Result := y * SCREENSIZEX + (SCREENSIZEX - x - 1);
end;

procedure TMapTexture.SetMapTile(x, y: integer; const tile: integer);
var
  idx: integer;
begin
  idx := getidx(x, y);
  data.maptiles[idx] := tile;
end;

function TMapTexture.GetMapTile(x, y: integer): integer;
var
  idx: integer;
begin
  idx := getidx(x, y);
  Result := data.maptiles[idx];
end;

procedure TMapTexture.SetAngle(x, y: integer; const ang: integer);
var
  idx: integer;
begin
  idx := getidx(x, y);
  data.angles[idx] := ang;
end;

function TMapTexture.GetAngle(x, y: integer): integer;
var
  idx: integer;
begin
  idx := getidx(x, y);
  Result := data.angles[idx];
end;

procedure TMapTexture.SaveToStream(const strm: TStream);
begin
  strm.Write(data^, SizeOf(maptexture_t));
end;

procedure TMapTexture.LoadFromStream(const strm: TStream);
begin
  strm.Read(data^, SizeOf(maptexture_t));
end;

function TMapTexture.GetExportText(const aX1: integer = -1; const aX2: integer = -1;
  const aY1: integer = -1; const aY2: integer = -1): string;
var
  x, y, x2, y2: integer;
  iX, iY: integer;

  function _elem_str(const xx, yy: integer): string;
  begin
    Result := IntToStr(xx) + ' ' + IntToStr(yy) + ' ' + IntToStr(GetMapTile(xx, yy)) + ' ' + IntToStr(GetAngle(xx, yy)) + #13#10;
  end;

begin
  x := MinI(aX1, aX2);
  x2 := MaxI(aX1, aX2);
  y := MinI(aY1, aY2);
  y2 := MaxI(aY1, aY2);

  if x = -1 then
    x := 0;
  if x2 = -1 then
    x2 := SCREENSIZEX - 1;
  if y = -1 then
    y := 0;
  if y2 = -1 then
    y2 := SCREENSIZEY - 1;

  x := GetIntInRange(x, 0, SCREENSIZEX - 1);
  x2 := GetIntInRange(x2, 0, SCREENSIZEX - 1);
  y := GetIntInRange(y, 0, SCREENSIZEY - 1);
  y2 := GetIntInRange(y2, 0, SCREENSIZEY - 1);

  Result := '';

  for iX := x to x2 do
    for iY := y to y2 do
      Result := Result + _elem_str(iX, iY);
end;

procedure TMapTexture.ApplyImportText(const tx: string; const aX1: integer = -1; const aX2: integer = -1;
  const aY1: integer = -1; const aY2: integer = -1);
var
  sc: TScriptEngine;
  x, y, x2, y2: integer;
  xx, yy, tile, ang: integer;
  rx, ry: integer;
  cnt: integer;
begin
  x := MinI(aX1, aX2);
  x2 := MaxI(aX1, aX2);
  y := MinI(aY1, aY2);
  y2 := MaxI(aY1, aY2);

  if x = -1 then
    x := 0;
  if x2 = -1 then
    x2 := SCREENSIZEX - 1;
  if y = -1 then
    y := 0;
  if y2 = -1 then
    y2 := SCREENSIZEY - 1;

  x := GetIntInRange(x, 0, SCREENSIZEX - 1);
  x2 := GetIntInRange(x2, 0, SCREENSIZEX - 1);
  y := GetIntInRange(y, 0, SCREENSIZEY - 1);
  y2 := GetIntInRange(y2, 0, SCREENSIZEY - 1);

  cnt := 0;
  rX := 0;
  rY := 0;
  sc := TScriptEngine.Create(tx);
  while sc.GetInteger do
  begin
    xx := sc._Integer;
    sc.MustGetInteger;
    yy := sc._Integer;
    sc.MustGetInteger;
    if cnt = 0 then
    begin
      rX := xx;
      rY := yy;
      cnt := 1;
    end;
    tile := sc._Integer;
    sc.MustGetInteger;
    ang := sc._Integer;

    if aX1 >= 0 then
      xx := xx - rX + aX1;
    if aY1 >= 0 then
      yy := yy - rY + aY1;
    if IsIntInRange(xx, x, x2) then
      if IsIntInRange(yy, y, y2) then
      begin
        SetMapTile(xx, yy, tile);
        SetAngle(xx, yy, ang);
      end;
  end;
  sc.Free;
end;

procedure TMapTexture.GetBitmap(const b: TBitmap; const doublesize: boolean);
var
  grafs: PByteArray;
  grafsize: integer;
  pal: PByteArray;
  i: integer;
  RGBpal: array[0..255] of LongWord;

  procedure _rotate_tile(const pt: PByteArray; const rot: integer);
  var
    buf: packed array[0..SCREENSIZE - 1] of byte;
    ii, jj: integer;
  begin
    if rot = 0 then
      exit;

    for ii := 0 to 4095 do
      buf[ii] := pt[ii];

    if rot = 1 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - jj) * 64 + ii];
    if rot = 2 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - ii) * 64 + 63 - jj];
    if rot = 3 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[jj * 64 + 63 - ii];
  end;

  procedure GenerateMapBitmap;
  var
    xb, yb: integer;
    ix, iy: integer;
    ig: integer;
    g, m: integer;
    tile: packed array[0..4095] of byte;
    tmpbuf: buffer_t;
    it: integer;
    bmbuffer4096: bmbuffer4096_p;
    bmbuffer8192: bmbuffer8192_p;
    bb: byte;
    c: LongWord;
    ln: PLongWordArray;
  begin
    GetMem(bmbuffer4096, SizeOf(bmbuffer4096_t));
    for m := 0 to 4095 do
    begin
      xb := (m div 64) * 64;
      yb := (m mod 64) * 64;
      g := data.maptiles[m];
      ig := g * 64 * 64;
      if (ig >= 0) and (ig < grafsize - 4095) then
      begin
        for ix := 0 to 4095 do
          tile[ix] := grafs[ig + ix];
      end
      else
      begin
        for ix := 0 to 4095 do
          tile[ix] := 0;
      end;

      _rotate_tile(@tile, data.angles[m]);

      it := 0;
      for iy := yb to yb + 63 do
        for ix := xb to xb + 63 do
        begin
          bmbuffer4096[iy, ix] := tile[it];
          inc(it);
        end;
    end;

    for iy := 0 to 2047 do
    begin
      tmpbuf := bmbuffer4096[iy];
      bmbuffer4096[iy] := bmbuffer4096[4095 - iy];
      bmbuffer4096[4095 - iy] := tmpbuf;
    end;

    if doublesize then
    begin
      GetMem(bmbuffer8192, SizeOf(bmbuffer8192_t));
      for iy := 0 to 4095 do
        for ix := 0 to 4095 do
        begin
          bb := bmbuffer4096[ix, iy];
          bmbuffer8192[2 * ix, 2 * iy] := bb;
          bmbuffer8192[2 * ix + 1, 2 * iy] := bb;
          bmbuffer8192[2 * ix + 1, 2 * iy + 1] := bb;
          bmbuffer8192[2 * ix, 2 * iy + 1] := bb;
        end;

      b.Width := 8192;
      b.Height := 8192;

      for iy := 0 to 8191 do
      begin
        ln := b.ScanLine[iy];
        for ix := 0 to 8191 do
        begin
          bb := bmbuffer8192[ix, iy];
          c := RGBpal[bb];
          ln[ix] := c;
        end;
      end;

      FreeMem(bmbuffer8192);
    end
    else
    begin
      b.Width := 4096;
      b.Height := 4096;

      for iy := 0 to 4095 do
      begin
        ln := b.ScanLine[iy];
        for ix := 0 to 4095 do
        begin
          bb := bmbuffer4096[ix, iy];
          c := RGBpal[bb];
          ln[ix] := c;
        end;
      end;
    end;

    FreeMem(bmbuffer4096);
  end;

begin
  grafs := @GRAFS_DAT;
  grafsize := SizeOf(GRAFS_DAT);
  pal := @GRAFS_PAL;

  for i := 0 to 255 do
    RGBpal[i] := RGB(pal[3 * i + 2] * 4, pal[3 * i + 1] * 4 + 2, pal[3 * i] * 4 + 2);

  GenerateMapBitmap;
end;

procedure TMapTexture.GetBuffer4096(const buf4096: bmbuffer4096_p);
var
  grafs: PByteArray;
  grafsize: integer;
  pal: PByteArray;
  i: integer;
  RGBpal: array[0..255] of LongWord;

  procedure _rotate_tile(const pt: PByteArray; const rot: integer);
  var
    buf: packed array[0..SCREENSIZE - 1] of byte;
    ii, jj: integer;
  begin
    if rot = 0 then
      exit;

    for ii := 0 to 4095 do
      buf[ii] := pt[ii];

    if rot = 1 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - jj) * 64 + ii];
    if rot = 2 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - ii) * 64 + 63 - jj];
    if rot = 3 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[jj * 64 + 63 - ii];
  end;

  procedure GenerateBuf4096;
  var
    xb, yb: integer;
    ix, iy: integer;
    ig: integer;
    g, m: integer;
    tile: packed array[0..4095] of byte;
    it: integer;
    bmbuffer4096: bmbuffer4096_p;
    bb: byte;
  begin
    bmbuffer4096 := buf4096;
    for m := 0 to 4095 do
    begin
      xb := (m div 64) * 64;
      yb := (m mod 64) * 64;
      g := data.maptiles[m];
      ig := g * 64 * 64;
      if (ig >= 0) and (ig < grafsize - 4095) then
      begin
        for ix := 0 to 4095 do
          tile[ix] := grafs[ig + ix];
      end
      else
      begin
        for ix := 0 to 4095 do
          tile[ix] := 0;
      end;

      _rotate_tile(@tile, data.angles[m]);

      it := 0;
      for iy := yb to yb + 63 do
        for ix := xb to xb + 63 do
        begin
          bmbuffer4096[ix, iy] := tile[it];
          inc(it);
        end;
    end;

    for iy := 0 to 2047 do
      for ix := 0 to 4095 do
      begin
        bb := bmbuffer4096[ix, iy];
        bmbuffer4096[ix, iy] := bmbuffer4096[ix, 4095 - iy];
        bmbuffer4096[ix, 4095 - iy] := bb;
      end;
  end;

begin
  grafs := @GRAFS_DAT;
  grafsize := SizeOf(GRAFS_DAT);
  pal := @GRAFS_PAL;

  for i := 0 to 255 do
    RGBpal[i] := RGB(pal[3 * i + 2] * 4, pal[3 * i + 1] * 4 + 2, pal[3 * i] * 4 + 2);

  GenerateBuf4096;
end;

procedure TMapTexture.GetBuffer8192(const buf8192: bmbuffer8192_p);
var
  grafs: PByteArray;
  grafsize: integer;
  pal: PByteArray;
  i: integer;
  RGBpal: array[0..255] of LongWord;

  procedure _rotate_tile(const pt: PByteArray; const rot: integer);
  var
    buf: packed array[0..SCREENSIZE - 1] of byte;
    ii, jj: integer;
  begin
    if rot = 0 then
      exit;

    for ii := 0 to 4095 do
      buf[ii] := pt[ii];

    if rot = 1 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - jj) * 64 + ii];
    if rot = 2 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[(63 - ii) * 64 + 63 - jj];
    if rot = 3 then
      for ii := 0 to 63 do
        for jj :=  0 to 63 do
          pt[ii * 64 + jj] := buf[jj * 64 + 63 - ii];
  end;

  procedure GenerateBuf8192;
  var
    xb, yb: integer;
    ix, iy: integer;
    ig: integer;
    g, m: integer;
    tile: packed array[0..4095] of byte;
    it: integer;
    bmbuffer4096: bmbuffer4096_p;
    bmbuffer8192: bmbuffer8192_p;
    bb: byte;
  begin
    GetMem(bmbuffer4096, SizeOf(bmbuffer4096_t));
    for m := 0 to 4095 do
    begin
      xb := (m div 64) * 64;
      yb := (m mod 64) * 64;
      g := data.maptiles[m];
      ig := g * 64 * 64;
      if (ig >= 0) and (ig < grafsize - 4095) then
      begin
        for ix := 0 to 4095 do
          tile[ix] := grafs[ig + ix];
      end
      else
      begin
        for ix := 0 to 4095 do
          tile[ix] := 0;
      end;

      _rotate_tile(@tile, data.angles[m]);

      it := 0;
      for iy := yb to yb + 63 do
        for ix := xb to xb + 63 do
        begin
          bmbuffer4096[ix, iy] := tile[it];
          inc(it);
        end;
    end;

    for iy := 0 to 2047 do
      for ix := 0 to 4095 do
      begin
        bb := bmbuffer4096[ix, iy];
        bmbuffer4096[ix, iy] := bmbuffer4096[ix, 4095 - iy];
        bmbuffer4096[ix, 4095 - iy] := bb;
      end;

    bmbuffer8192 := buf8192;
    for iy := 0 to 4095 do
      for ix := 0 to 4095 do
      begin
        bb := bmbuffer4096[ix, iy];
        bmbuffer8192[2 * ix, 2 * iy] := bb;
        bmbuffer8192[2 * ix + 1, 2 * iy] := bb;
        bmbuffer8192[2 * ix + 1, 2 * iy + 1] := bb;
        bmbuffer8192[2 * ix, 2 * iy + 1] := bb;
      end;


    FreeMem(bmbuffer4096);
  end;

begin
  grafs := @GRAFS_DAT;
  grafsize := SizeOf(GRAFS_DAT);
  pal := @GRAFS_PAL;

  for i := 0 to 255 do
    RGBpal[i] := RGB(pal[3 * i + 2] * 4, pal[3 * i + 1] * 4 + 2, pal[3 * i] * 4 + 2);

  GenerateBuf8192;
end;

procedure TMapTexture.AssignTo(const amaptexture: TMapTexture);
begin
  Move(amaptexture.data^, data^, SizeOf(maptexture_t));
end;

end.
