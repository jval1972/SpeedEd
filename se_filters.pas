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
//  Image Filters
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

unit se_filters;

interface

uses
  Windows, Classes, Graphics;

type
  TImageFilter3x3 = record
    RAY: array[0..8] of integer;
    DIVFACTOR: word;
    BIAS: byte;
  end;

  TImageFilter5x5 = record
    RAY: array[0..24] of integer;
    DIVFACTOR: word;
    BIAS: byte;
  end;

procedure ApplyFilter3x3ToBitmap(const flt: TImageFilter3x3; bmp: TBitmap);

procedure ApplyFilter5x5ToBitmap(const flt: TImageFilter5x5; bmp: TBitmap);

implementation

// Image proccessing specific routines
type    // For scanline simplification
  TRGBArray = packed array[0..32767] OF TRGBTriple;
  PRGBArray = ^TRGBArray;

{This just forces a value to be 0 - 255 for rgb purposes.  I used asm in an
 attempt at speed, but I don't think it helps much.}
function Set255(Clr : integer): integer;
asm
  MOV  EAX,Clr  // store value in EAX register (32-bit register)
  CMP  EAX,254  // compare it to 254
  JG   @SETHI   // if greater than 254 then go set to 255 (max value)
  CMP  EAX,1    // if less than 255, compare to 1
  JL   @SETLO   // if less than 1 go set to 0 (min value)
  RET           // otherwise it doesn't change, just exit
@SETHI:         // Set value to 255
  MOV  EAX,255  // Move 255 into the EAX register
  RET           // Exit (result value is the EAX register value)
@SETLO:         // Set value to 0
  MOV  EAX,0    // Move 0 into EAX register
end;            // Result is in EAX

procedure ApplyFilter3x3ToBitmap(const flt: TImageFilter3x3; bmp: TBitmap);
var
  O, T, C, B: PRGBArray;  // Scanlines
  x, y: integer;
  tBufr: TBitmap; // temp bitmap for 'enlarged' image
  oldf: TPixelFormat;
begin
  tBufr := TBitmap.Create;
  try
    tBufr.Width := bmp.Width + 2;  // Add a box around the outside...
    tBufr.Height := bmp.Height + 2;
    tBufr.PixelFormat := pf24bit;
    oldf := bmp.PixelFormat;
    bmp.PixelFormat := pf24bit;
    O := tBufr.ScanLine[0];   // Copy top corner pixels
    T := bmp.ScanLine[0];
    O[0] := T[0];  // Left
    O[tBufr.Width - 1] := T[bmp.Width - 1];  // Right
    // Copy bottom line to our top - trying to remain seamless...
    tBufr.Canvas.CopyRect(Rect(1, 0, tBufr.Width - 1, 1), bmp.Canvas,
                          Rect(0, bmp.Height - 1, bmp.Width, bmp.Height - 2));

    O := tBufr.ScanLine[tBufr.Height - 1]; // Copy bottom corner pixels
    T := bmp.ScanLine[bmp.Height - 1];
    O[0] := T[0];
    O[tBufr.Width - 1] := T[bmp.Width - 1];
    // Copy top line to our bottom
    tBufr.Canvas.CopyRect(Rect(1, tBufr.Height - 1, tBufr.Width - 1, tBufr.Height), bmp.Canvas,
                          Rect(0, 0, bmp.Width, 1));
    // Copy left to our right
    tBufr.Canvas.CopyRect(Rect(tBufr.Width - 1, 1, tBufr.Width, tBufr.Height - 1), bmp.Canvas,
                          Rect(0, 0, 1, bmp.Height));
    // Copy right to our left
    tBufr.Canvas.CopyRect(Rect(0, 1, 1, tBufr.Height - 1), bmp.Canvas,
                          Rect(bmp.Width - 1, 0, bmp.Width, bmp.Height));
    // Now copy main rectangle
    tBufr.Canvas.CopyRect(Rect(1, 1, tBufr.Width - 1, tBufr.Height - 1), bmp.Canvas,
                          Rect(0, 0, bmp.Width, bmp.Height));
    // bmp now enlarged and copied, apply convolve
    for x := 0 to bmp.Height - 1 do
    begin  // Walk scanlines
      O := bmp.ScanLine[x];       // New Target (Original)
      T := tBufr.ScanLine[x];     //old x-1  (Top)
      C := tBufr.ScanLine[x + 1]; //old x    (Center)
      B := tBufr.ScanLine[x + 2]; //old x+1  (Bottom)
    // Now do the main piece
      for y := 1 to (tBufr.Width - 2) do
      begin  // Walk pixels
        O[y - 1].rgbtRed := Set255(
            ((T[y - 1].rgbtRed * flt.RAY[0]) +
            (T[y].rgbtRed * flt.RAY[1]) + (T[y + 1].rgbtRed * flt.RAY[2]) +
            (C[y - 1].rgbtRed * flt.RAY[3]) +
            (C[y].rgbtRed * flt.RAY[4]) + (C[y + 1].rgbtRed * flt.RAY[5])+
            (B[y - 1].rgbtRed * flt.RAY[6]) +
            (B[y].rgbtRed * flt.RAY[7]) + (B[y + 1].rgbtRed * flt.RAY[8])) div flt.DIVFACTOR + flt.BIAS
            );
        O[y - 1].rgbtBlue := Set255(
            ((T[y - 1].rgbtBlue * flt.RAY[0]) +
            (T[y].rgbtBlue * flt.RAY[1]) + (T[y + 1].rgbtBlue * flt.RAY[2]) +
            (C[y - 1].rgbtBlue * flt.RAY[3]) +
            (C[y].rgbtBlue * flt.RAY[4]) + (C[y + 1].rgbtBlue * flt.RAY[5])+
            (B[y - 1].rgbtBlue * flt.RAY[6]) +
            (B[y].rgbtBlue * flt.RAY[7]) + (B[y + 1].rgbtBlue * flt.RAY[8])) div flt.DIVFACTOR + flt.BIAS
            );
        O[y - 1].rgbtGreen := Set255(
            ((T[y - 1].rgbtGreen * flt.RAY[0]) +
            (T[y].rgbtGreen * flt.RAY[1]) + (T[y + 1].rgbtGreen * flt.RAY[2]) +
            (C[y - 1].rgbtGreen * flt.RAY[3]) +
            (C[y].rgbtGreen * flt.RAY[4]) + (C[y + 1].rgbtGreen * flt.RAY[5])+
            (B[y - 1].rgbtGreen * flt.RAY[6]) +
            (B[y].rgbtGreen * flt.RAY[7]) + (B[y + 1].rgbtGreen * flt.RAY[8])) div flt.DIVFACTOR + flt.BIAS
            );
      end;
    end;
    bmp.PixelFormat := oldf;
  finally
    tBufr.Free;
  end;
end;

procedure ApplyFilter5x5ToBitmap(const flt: TImageFilter5x5; bmp: TBitmap);
var
  O, T, TT, C, B, BB: PRGBArray;  // Scanlines
  x, y: integer;
  tBufr: TBitmap; // temp bitmap for 'enlarged' image
  oldf: TPixelFormat;
begin
  tBufr := TBitmap.Create;
  try
    tBufr.Width := bmp.Width + 4;  // Add a box around the outside...
    tBufr.Height := bmp.Height + 4;
    tBufr.PixelFormat := pf24bit;
    oldf := bmp.PixelFormat;
    bmp.PixelFormat := pf24bit;
    O := tBufr.ScanLine[0];   // Copy top corner pixels
    T := bmp.ScanLine[0];
    O[0] := T[0];  // Left
    O[1] := T[1];
    O[tBufr.Width - 2] := T[bmp.Width - 2];  // Right
    O[tBufr.Width - 1] := T[bmp.Width - 1];  // Right
    O := tBufr.ScanLine[1];   // Copy top corner pixels
    T := bmp.ScanLine[1];
    O[0] := T[0];  // Left
    O[1] := T[1];
    O[tBufr.Width - 2] := T[bmp.Width - 2];  // Right
    O[tBufr.Width - 1] := T[bmp.Width - 1];  // Right
    // Copy bottom line to our top - trying to remain seamless...
    tBufr.Canvas.CopyRect(Rect(2, 0, tBufr.Width - 2, 2), bmp.Canvas,
                          Rect(0, bmp.Height - 2, bmp.Width, bmp.Height - 4));

    O := tBufr.ScanLine[tBufr.Height - 2]; // Copy bottom corner pixels
    T := bmp.ScanLine[bmp.Height - 2];
    O[0] := T[0];
    O[1] := T[1];
    O[tBufr.Width - 2] := T[bmp.Width - 2];
    O[tBufr.Width - 1] := T[bmp.Width - 1];
    O := tBufr.ScanLine[tBufr.Height - 1]; // Copy bottom corner pixels
    T := bmp.ScanLine[bmp.Height - 1];
    O[0] := T[0];
    O[1] := T[1];
    O[tBufr.Width - 2] := T[bmp.Width - 2];
    O[tBufr.Width - 1] := T[bmp.Width - 1];
    // Copy top line to our bottom
    tBufr.Canvas.CopyRect(Rect(2, tBufr.Height - 2, tBufr.Width - 2, tBufr.Height), bmp.Canvas,
                          Rect(0, 0, bmp.Width, 2));
    // Copy left to our right
    tBufr.Canvas.CopyRect(Rect(tBufr.Width - 2, 2, tBufr.Width, tBufr.Height - 2), bmp.Canvas,
                          Rect(0, 0, 2, bmp.Height));
    // Copy right to our left
    tBufr.Canvas.CopyRect(Rect(0, 2, 2, tBufr.Height - 2), bmp.Canvas,
                          Rect(bmp.Width - 2, 0, bmp.Width, bmp.Height));
    // Now copy main rectangle
    tBufr.Canvas.CopyRect(Rect(2, 2, tBufr.Width - 2, tBufr.Height - 2), bmp.Canvas,
                          Rect(0, 0, bmp.Width, bmp.Height));
    // bmp now enlarged and copied, apply convolve
    for x := 0 to bmp.Height - 1 do
    begin  // Walk scanlines
      O := bmp.ScanLine[x];       // New Target (Original)
      TT := tBufr.ScanLine[x];     //old x-2  (TopTop)
      T  := tBufr.ScanLine[x + 1]; //old x-1  (Top)
      C  := tBufr.ScanLine[x + 2]; //old x    (Center)
      B  := tBufr.ScanLine[x + 3]; //old x+1  (Bottom)
      BB := tBufr.ScanLine[x + 4]; //old x+2  (BottomBottom)
    // Now do the main piece
      for y := 2 to (tBufr.Width - 3) do
      begin  // Walk pixels
        O[y - 2].rgbtRed := Set255(
            ((TT[y - 2].rgbtRed * flt.RAY[0]) + (TT[y - 1].rgbtRed * flt.RAY[1]) +
             (TT[y    ].rgbtRed * flt.RAY[2]) + (TT[y + 1].rgbtRed * flt.RAY[3]) +
             (TT[y + 2].rgbtRed * flt.RAY[4]) +

             (T[y - 2].rgbtRed * flt.RAY[5]) + (T[y - 1].rgbtRed * flt.RAY[6]) +
             (T[y    ].rgbtRed * flt.RAY[7]) + (T[y + 1].rgbtRed * flt.RAY[8]) +
             (T[y + 2].rgbtRed * flt.RAY[9]) +

             (C[y - 2].rgbtRed * flt.RAY[10]) + (C[y - 1].rgbtRed * flt.RAY[11]) +
             (C[y    ].rgbtRed * flt.RAY[12]) + (C[y + 1].rgbtRed * flt.RAY[13]) +
             (C[y + 2].rgbtRed * flt.RAY[14]) +

             (B[y - 2].rgbtRed * flt.RAY[15]) + (B[y - 1].rgbtRed * flt.RAY[16]) +
             (B[y    ].rgbtRed * flt.RAY[17]) + (B[y + 1].rgbtRed * flt.RAY[18]) +
             (B[y + 2].rgbtRed * flt.RAY[19]) +

             (BB[y - 2].rgbtRed * flt.RAY[20]) + (BB[y - 1].rgbtRed * flt.RAY[21]) +
             (BB[y    ].rgbtRed * flt.RAY[22]) + (BB[y + 1].rgbtRed * flt.RAY[23]) +
             (BB[y + 2].rgbtRed * flt.RAY[24])) div flt.DIVFACTOR + flt.BIAS
            );


        O[y - 2].rgbtBlue := Set255(
            ((TT[y - 2].rgbtBlue * flt.RAY[0]) + (TT[y - 1].rgbtBlue * flt.RAY[1]) +
             (TT[y    ].rgbtBlue * flt.RAY[2]) + (TT[y + 1].rgbtBlue * flt.RAY[3]) +
             (TT[y + 2].rgbtBlue * flt.RAY[4]) +

             (T[y - 2].rgbtBlue * flt.RAY[5]) + (T[y - 1].rgbtBlue * flt.RAY[6]) +
             (T[y    ].rgbtBlue * flt.RAY[7]) + (T[y + 1].rgbtBlue * flt.RAY[8]) +
             (T[y + 2].rgbtBlue * flt.RAY[9]) +

             (C[y - 2].rgbtBlue * flt.RAY[10]) + (C[y - 1].rgbtBlue * flt.RAY[11]) +
             (C[y    ].rgbtBlue * flt.RAY[12]) + (C[y + 1].rgbtBlue * flt.RAY[13]) +
             (C[y + 2].rgbtBlue * flt.RAY[14]) +

             (B[y - 2].rgbtBlue * flt.RAY[15]) + (B[y - 1].rgbtBlue * flt.RAY[16]) +
             (B[y    ].rgbtBlue * flt.RAY[17]) + (B[y + 1].rgbtBlue * flt.RAY[18]) +
             (B[y + 2].rgbtBlue * flt.RAY[19]) +

             (BB[y - 2].rgbtBlue * flt.RAY[20]) + (BB[y - 1].rgbtBlue * flt.RAY[21]) +
             (BB[y    ].rgbtBlue * flt.RAY[22]) + (BB[y + 1].rgbtBlue * flt.RAY[23]) +
             (BB[y + 2].rgbtBlue * flt.RAY[24])) div flt.DIVFACTOR + flt.BIAS
            );

        O[y - 2].rgbtGreen := Set255(
            ((TT[y - 2].rgbtGreen * flt.RAY[0]) + (TT[y - 1].rgbtGreen * flt.RAY[1]) +
             (TT[y    ].rgbtGreen * flt.RAY[2]) + (TT[y + 1].rgbtGreen * flt.RAY[3]) +
             (TT[y + 2].rgbtGreen * flt.RAY[4]) +

             (T[y - 2].rgbtGreen * flt.RAY[5]) + (T[y - 1].rgbtGreen * flt.RAY[6]) +
             (T[y    ].rgbtGreen * flt.RAY[7]) + (T[y + 1].rgbtGreen * flt.RAY[8]) +
             (T[y + 2].rgbtGreen * flt.RAY[9]) +

             (C[y - 2].rgbtGreen * flt.RAY[10]) + (C[y - 1].rgbtGreen * flt.RAY[11]) +
             (C[y    ].rgbtGreen * flt.RAY[12]) + (C[y + 1].rgbtGreen * flt.RAY[13]) +
             (C[y + 2].rgbtGreen * flt.RAY[14]) +

             (B[y - 2].rgbtGreen * flt.RAY[15]) + (B[y - 1].rgbtGreen * flt.RAY[16]) +
             (B[y    ].rgbtGreen * flt.RAY[17]) + (B[y + 1].rgbtGreen * flt.RAY[18]) +
             (B[y + 2].rgbtGreen * flt.RAY[19]) +

             (BB[y - 2].rgbtGreen * flt.RAY[20]) + (BB[y - 1].rgbtGreen * flt.RAY[21]) +
             (BB[y    ].rgbtGreen * flt.RAY[22]) + (BB[y + 1].rgbtGreen * flt.RAY[23]) +
             (BB[y + 2].rgbtGreen * flt.RAY[24])) div flt.DIVFACTOR + flt.BIAS
            );

      end;
    end;
    bmp.PixelFormat := oldf;
  finally
    tBufr.Free;
  end;
end;

end.
