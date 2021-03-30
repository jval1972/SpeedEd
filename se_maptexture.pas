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
    function GetExportText(const x: integer = -1; const y: integer = -1): string;
    procedure ApplyImportText(const tx: string);
    procedure GetBitmap(const b: TBitmap; const doublesize: boolean);
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

function TMapTexture.GetExportText(const x: integer = -1; const y: integer = -1): string;
var
  iX, iY: integer;

  function _elem_str(const xx, yy: integer): string;
  begin
    Result := IntToStr(xx) + ' ' + IntToStr(yy) + ' ' + IntToStr(GetMapTile(xx, yy)) + ' ' + IntToStr(GetAngle(xx, yy)) + #13#10;
  end;

begin
  Result := '';

  if (x = -1) and (y = -1) then
  begin
    for iX := 0 to SCREENSIZEX - 1 do
      for iY := 0 to SCREENSIZEY - 1 do
        Result := Result + _elem_str(iX, iY);
    Exit;
  end;

  if x = -1 then
  begin
    for iX := 0 to SCREENSIZEX - 1 do
      Result := Result + _elem_str(iX, y);
    Exit;
  end;

  if y = -1 then
  begin
    for iY := 0 to SCREENSIZEY - 1 do
      Result := Result + _elem_str(x, iY);
    Exit;
  end;

  Result := _elem_str(x, y);
end;

procedure TMapTexture.ApplyImportText(const tx: string);
var
  sc: TScriptEngine;
  x, y, tile, ang: integer;
begin
  sc := TScriptEngine.Create(tx);
  while sc.GetInteger do
  begin
    x := sc._Integer;
    sc.MustGetInteger;
    y := sc._Integer;
    sc.MustGetInteger;
    tile := sc._Integer;
    sc.MustGetInteger;
    ang := sc._Integer;
    SetMapTile(x, y, tile);
    SetAngle(x, y, ang);
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
  type
    buffer_t = packed array[0..4095] of byte;
    bmbuffer4096_t = packed array[0..4095] of buffer_t;
    bmbuffer4096_p = ^bmbuffer4096_t;
    bmbuffer8192_t = packed array[0..8191] of packed array[0..8191] of byte;
    bmbuffer8192_p = ^bmbuffer8192_t;
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
//          bmbuffer4096[ix, iy] := tile[it];
          bmbuffer4096[iy, ix] := tile[it];
          inc(it);
        end;
    end;

{    for iy := 0 to 2047 do
      for ix := 0 to 4095 do
      begin
        bb := bmbuffer4096[ix, iy];
        bmbuffer4096[ix, iy] := bmbuffer4096[ix, 4095 - iy];
        bmbuffer4096[ix, 4095 - iy] := bb;
      end;}
    for iy := 0 to 2047 do
//      for ix := 0 to 4095 do
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
          bb := bmbuffer8192[iy, ix];
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

procedure TMapTexture.AssignTo(const amaptexture: TMapTexture);
begin
  Move(amaptexture.data^, data^, SizeOf(maptexture_t));
end;

end.
