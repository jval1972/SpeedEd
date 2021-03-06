//------------------------------------------------------------------------------
//
//  SpeedEd: GLSpeed map Editor utilities
//  Copyright (C) 2021-2022 by Jim Valavanis
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
//  Main Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed-game/
//------------------------------------------------------------------------------

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Buttons, Clipbrd, ExtDlgs, pngimage, xTGA, zBitmap,
  Menus, ImgList, jpeg, StdCtrls, se_undo, se_filemenuhistory, se_maptexture;

const
  MINZOOM = 1;
  MAXZOOM = 16;

const
  MOUSEWHEELTIMEOUT = 100; // Msecs until next mouse wheel even to be proccessed

const
  COLORPICKTILESIZE = 32;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    StatusBar1: TStatusBar;
    LeftPanel: TPanel;
    OpenSpeedButton1: TSpeedButton;
    SaveSpeedButton1: TSpeedButton;
    CopySpeedButton1: TSpeedButton;
    GridButton1: TSpeedButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    SaveAs1: TMenuItem;
    N1: TMenuItem;
    Exit1: TMenuItem;
    Edit1: TMenuItem;
    Copy1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Timer1: TTimer;
    Panel4: TPanel;
    ScrollBox1: TScrollBox;
    PaintBox1: TPaintBox;
    New1: TMenuItem;
    N3: TMenuItem;
    Save2: TMenuItem;
    Cut1: TMenuItem;
    HistoryItem0: TMenuItem;
    HistoryItem1: TMenuItem;
    HistoryItem2: TMenuItem;
    HistoryItem3: TMenuItem;
    HistoryItem4: TMenuItem;
    HistoryItem5: TMenuItem;
    HistoryItem6: TMenuItem;
    HistoryItem7: TMenuItem;
    HistoryItem8: TMenuItem;
    HistoryItem9: TMenuItem;
    N14: TMenuItem;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    N4: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    NewSpeedButton1: TSpeedButton;
    UndoSpeedButton1: TSpeedButton;
    RedoSpeedButton1: TSpeedButton;
    ZoomOutSpeedButton1: TSpeedButton;
    ZoomInSpeedButton1: TSpeedButton;
    ToolPanel: TPanel;
    BackgroundPalettePanel1: TPanel;
    BackgroundPalette1: TImage;
    Panel5: TPanel;
    FreeDrawSpeedButton: TSpeedButton;
    FloodFillSpeedButton: TSpeedButton;
    RectSpeedButton: TSpeedButton;
    FillRectSpeedButton: TSpeedButton;
    LineSpeedButton: TSpeedButton;
    EraseSpeedButton: TSpeedButton;
    EclipseSpeedButton: TSpeedButton;
    FilledEclipseSpeedButton: TSpeedButton;
    PaintBoxPopupMenu1: TPopupMenu;
    Undo2: TMenuItem;
    Redo2: TMenuItem;
    N5: TMenuItem;
    Cut2: TMenuItem;
    Copy2: TMenuItem;
    Export1: TMenuItem;
    N6: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    RotateRightSpeedButton: TSpeedButton;
    RotateLeftSpeedButton: TSpeedButton;
    PasteSpeedButton1: TSpeedButton;
    Paste1: TMenuItem;
    N2: TMenuItem;
    CopyAsImage1: TMenuItem;
    Paste2: TMenuItem;
    RotateSpeedButton0: TSpeedButton;
    RotateSpeedButton90: TSpeedButton;
    RotateSpeedButton180: TSpeedButton;
    RotateSpeedButton270: TSpeedButton;
    SelectSpeedButton: TSpeedButton;
    PasteIntoSelection1: TMenuItem;
    PasteIntoSelection2: TMenuItem;
    PasteHere1: TMenuItem;
    ExportWAD1: TMenuItem;
    SaveWADDialog: TSaveDialog;
    ExportWAD40961: TMenuItem;
    Trans0SpeedButton: TSpeedButton;
    Trans1SpeedButton: TSpeedButton;
    Trans2SpeedButton: TSpeedButton;
    Trans3SpeedButton: TSpeedButton;
    Trans4SpeedButton: TSpeedButton;
    Trans5SpeedButton: TSpeedButton;
    Trans6SpeedButton: TSpeedButton;
    Trans7SpeedButton: TSpeedButton;
    Trans8SpeedButton: TSpeedButton;
    Trans9SpeedButton: TSpeedButton;
    Trans10SpeedButton: TSpeedButton;
    N7: TMenuItem;
    Applytranslation1: TMenuItem;
    Applyrotation1: TMenuItem;
    Trans11SpeedButton: TSpeedButton;
    Trans12SpeedButton: TSpeedButton;
    Trans13SpeedButton: TSpeedButton;
    Trans14SpeedButton: TSpeedButton;
    Trans15SpeedButton: TSpeedButton;
    Trans16SpeedButton: TSpeedButton;
    Trans17SpeedButton: TSpeedButton;
    Trans18SpeedButton: TSpeedButton;
    Trans19SpeedButton: TSpeedButton;
    Trans20SpeedButton: TSpeedButton;
    Trans21SpeedButton: TSpeedButton;
    Trans22SpeedButton: TSpeedButton;
    Trans23SpeedButton: TSpeedButton;
    Trans24SpeedButton: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Copy1Click(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1Click(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure New1Click(Sender: TObject);
    procedure Save1Click(Sender: TObject);
    procedure SaveAs1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure ZoomIn1Click(Sender: TObject);
    procedure ZoomOut1Click(Sender: TObject);
    procedure GridButton1Click(Sender: TObject);
    procedure BackgroundPalette1MouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FreeDrawSpeedButtonClick(Sender: TObject);
    procedure EraseSpeedButtonClick(Sender: TObject);
    procedure FloodFillSpeedButtonClick(Sender: TObject);
    procedure RectSpeedButtonClick(Sender: TObject);
    procedure FillRectSpeedButtonClick(Sender: TObject);
    procedure LineSpeedButtonClick(Sender: TObject);
    procedure TextSpeedButtonClick(Sender: TObject);
    procedure TextColorChangeSpeedButtonClick(Sender: TObject);
    procedure SpecialCharSpeedButton1Click(Sender: TObject);
    procedure SpecialCharSpeedButton2Click(Sender: TObject);
    procedure CharRectSpeedButtonClick(Sender: TObject);
    procedure BlinkOnSpeedButtonClick(Sender: TObject);
    procedure BlinkOffSpeedButtonClick(Sender: TObject);
    procedure EclipseSpeedButtonClick(Sender: TObject);
    procedure FilledEclipseSpeedButtonClick(Sender: TObject);
    procedure Cut1Click(Sender: TObject);
    procedure PaintBoxPopupMenu1Popup(Sender: TObject);
    procedure Export1Click(Sender: TObject);
    procedure RotateRightSpeedButtonClick(Sender: TObject);
    procedure RotateLeftSpeedButtonClick(Sender: TObject);
    procedure CopyAsImage1Click(Sender: TObject);
    procedure Paste1Click(Sender: TObject);
    procedure Cut2Click(Sender: TObject);
    procedure RotateSpeedButton0Click(Sender: TObject);
    procedure RotateSpeedButton90Click(Sender: TObject);
    procedure RotateSpeedButton180Click(Sender: TObject);
    procedure RotateSpeedButton270Click(Sender: TObject);
    procedure SelectSpeedButtonClick(Sender: TObject);
    procedure PasteIntoSelection1Click(Sender: TObject);
    procedure PasteHere1Click(Sender: TObject);
    procedure ExportWAD1Click(Sender: TObject);
    procedure ExportWAD40961Click(Sender: TObject);
    procedure Trans0SpeedButtonClick(Sender: TObject);
    procedure Trans1SpeedButtonClick(Sender: TObject);
    procedure Trans2SpeedButtonClick(Sender: TObject);
    procedure Trans3SpeedButtonClick(Sender: TObject);
    procedure Trans4SpeedButtonClick(Sender: TObject);
    procedure Trans5SpeedButtonClick(Sender: TObject);
    procedure Trans6SpeedButtonClick(Sender: TObject);
    procedure Trans7SpeedButtonClick(Sender: TObject);
    procedure Trans8SpeedButtonClick(Sender: TObject);
    procedure Trans9SpeedButtonClick(Sender: TObject);
    procedure Trans10SpeedButtonClick(Sender: TObject);
    procedure Applyrotation1Click(Sender: TObject);
    procedure Applytranslation1Click(Sender: TObject);
    procedure Trans11SpeedButtonClick(Sender: TObject);
    procedure Trans12SpeedButtonClick(Sender: TObject);
    procedure Trans13SpeedButtonClick(Sender: TObject);
    procedure Trans14SpeedButtonClick(Sender: TObject);
    procedure Trans15SpeedButtonClick(Sender: TObject);
    procedure Trans16SpeedButtonClick(Sender: TObject);
    procedure Trans17SpeedButtonClick(Sender: TObject);
    procedure Trans18SpeedButtonClick(Sender: TObject);
    procedure Trans19SpeedButtonClick(Sender: TObject);
    procedure Trans20SpeedButtonClick(Sender: TObject);
    procedure Trans21SpeedButtonClick(Sender: TObject);
    procedure Trans22SpeedButtonClick(Sender: TObject);
    procedure Trans23SpeedButtonClick(Sender: TObject);
    procedure Trans24SpeedButtonClick(Sender: TObject);
  private
    { Private declarations }
    buffer, exportbuffer: TBitmap;
    drawbuffer: TBitmap;
    changed: boolean;
    needsupdate: boolean;
    needbuffersupdate: boolean;
    undoManager: TUndoRedoManager;
    filemenuhistory: TFileMenuHistory;
    ffilename: string;
    maptexture, backscreen: TMapTexture;
    zoom: integer;
    flastzoomwheel: int64;
    lmousedown: boolean;
    lmouserecalcdown: boolean;
    lmousetraceposition: boolean;
    lmouseclearonmove: boolean;
    lmousedownx, lmousedowny: integer;
    lmousemovex, lmousemovey: integer;
    rmousedown: boolean;
    rmousedownx, rmousedowny: integer;
    bktile: integer;
    bkpalbitmap0: array[0..NUMTRANSLATIONS - 1] of TBitmap;
    bkpalbitmap1: array[0..NUMTRANSLATIONS - 1] of TBitmap;
    bkpalbitmap2: array[0..NUMTRANSLATIONS - 1] of TBitmap;
    bkpalbitmap3: array[0..NUMTRANSLATIONS - 1] of TBitmap;
    closing: boolean;
    anglerotated: array[0..SCREENSIZEX - 1, 0..SCREENSIZEY - 1] of boolean;
    curangle: integer;
    curtrans: integer;
    bkpalx, bkpaly: integer;
    selRect: TRect;
    recalcscrollbox: boolean;
    recalcscrollboxx, recalcscrollboxy: integer;
    recalcscrollboxrx, recalcscrollboxry: integer;
    procedure Idle(Sender: TObject; var Done: Boolean);
    procedure Hint(Sender: TObject);
    procedure UpdateEnable;
    procedure InvalidatePaintBox;
    procedure DrawGrid;
    procedure DrawSelection;
    procedure NormalizeSelectionRect;
    function ZoomValueX(const X: Integer): Integer;
    function ZoomValueY(const Y: Integer): Integer;
    procedure LLeftMousePaintAt(const X, Y: integer);
    procedure LLeftMousePaintTo(const X, Y: integer);
    procedure CreateDrawBuffer;
    procedure CreateExportBuffer;
    procedure DoPrepareEditor;
    procedure DoCreateNew;
    procedure DoLoadFromStream(const s: TStream);
    procedure DoSaveToStream(const s: TStream);
    procedure DoLoadUndo(const s: TStream);
    procedure DoSaveUndo(const s: TStream);
    function DoLoadFromFile(const aname: string): boolean;
    procedure FileNotFoundMsg(const aname: string);
    procedure DoSaveToFile(const aname: string);
    procedure OnLoadFileMenuHistory(Sender: TObject; const aname: string);
    function CheckCanClose: boolean;
    procedure SetFileName(const fname: string);
    procedure HandlePaletteImage(const X, Y: integer; const Palette1: TImage;
      const palbitmap: TBitmap; const tx: string; var cc: integer);
    procedure EditActionFreeDraw(const X, Y: integer);
    procedure EditActionErase(const X, Y: integer);
    procedure EditActionFloodFill(const X, Y: integer);
    procedure EditActionRect(const X, Y: integer);
    procedure EditActionFillRect(const X, Y: integer);
    procedure EditActionLine(const X, Y: integer);
    procedure midpointellipse(const X, Y: integer; const filled: boolean);
    procedure EditActionEclipse(const X, Y: integer);
    procedure EditActionFillEclipse(const X, Y: integer);
    procedure EditActionRotateRight(const X, Y: integer);
    procedure EditActionRotateLeft(const X, Y: integer);
    procedure EditActionSelectionAt(const X, Y: integer);
    procedure DoExportImage(const imgfname: string);
    procedure ClearSelection;
    function HasSelection: boolean;
    procedure CopyToClipboardAsText;
    procedure DoExportWAD4096(const fn: string; const lname: string);
    procedure DoExportWAD8192(const fn: string; const lname: string);
    procedure ChangeEditorTranslation(const trn: integer);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  se_utils, se_defs, se_doommap, se_wadreader, se_wadwriter, se_wad, se_doomdefs;

procedure TForm1.FormCreate(Sender: TObject);
var
  i, j, t: integer;
  doCreate: boolean;
  tmpmap: TMapTexture;
  tile: integer;
begin
  DoubleBuffered := True;
  for i := 0 to ComponentCount - 1 do
    if Components[i].InheritsFrom(TWinControl) then
      if not (Components[i] is TListBox) then
        (Components[i] as TWinControl).DoubleBuffered := True;

  closing := False;

  lmousedown := False;
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
  lmousedownx := 0;
  lmousedowny := 0;
  lmousemovex := 0;
  lmousemovey := 0;

  rmousedown := False;
  rmousedownx := 0;
  rmousedowny := 0;

  curangle := 0;
  curtrans := 0;

  recalcscrollbox := False;
  recalcscrollboxx := 0;
  recalcscrollboxy := 0;
  recalcscrollboxrx := 0;
  recalcscrollboxry := 0;

  ClearSelection;

  buffer := TBitmap.Create;
  buffer.Width := SCREENSIZEX * TILESIZE;
  buffer.Height := SCREENSIZEY * TILESIZE;
  buffer.PixelFormat := pf32bit;

  exportbuffer := TBitmap.Create;
  exportbuffer.Width := SCREENSIZEX * TILESIZE;
  exportbuffer.Height := SCREENSIZEY * TILESIZE;
  exportbuffer.PixelFormat := pf32bit;

  drawbuffer := TBitmap.Create;
  drawbuffer.Width := SCREENSIZEX * TILESIZE;
  drawbuffer.Height := SCREENSIZEY * TILESIZE;
  drawbuffer.PixelFormat := pf32bit;

  flastzoomwheel := GetTickCount;

  maptexture := TMapTexture.Create;
  backscreen := TMapTexture.Create;

  undoManager := TUndoRedoManager.Create;
  undoManager.OnLoadFromStream := DoLoadUndo;
  undoManager.OnSaveToStream := DoSaveUndo;

  se_LoadSettingFromFile(ChangeFileExt(ParamStr(0), '.ini'));

  filemenuhistory := TFileMenuHistory.Create(self);
  filemenuhistory.MenuItem0 := HistoryItem0;
  filemenuhistory.MenuItem1 := HistoryItem1;
  filemenuhistory.MenuItem2 := HistoryItem2;
  filemenuhistory.MenuItem3 := HistoryItem3;
  filemenuhistory.MenuItem4 := HistoryItem4;
  filemenuhistory.MenuItem5 := HistoryItem5;
  filemenuhistory.MenuItem6 := HistoryItem6;
  filemenuhistory.MenuItem7 := HistoryItem7;
  filemenuhistory.MenuItem8 := HistoryItem8;
  filemenuhistory.MenuItem9 := HistoryItem9;
  filemenuhistory.OnOpen := OnLoadFileMenuHistory;

  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory9));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory8));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory7));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory6));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory5));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory4));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory3));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory2));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory1));
  filemenuhistory.AddPath(bigstringtostring(@opt_filemenuhistory0));

  ffilename := '';

  GridButton1.Down := opt_showgrid;
  zoom := GetIntInRange(opt_zoom, MINZOOM, MAXZOOM);

  for t := 0 to NUMTRANSLATIONS - 1 do
  begin
    bkpalbitmap0[t] := TBitmap.Create;
    bkpalbitmap1[t] := TBitmap.Create;
    bkpalbitmap2[t] := TBitmap.Create;
    bkpalbitmap3[t] := TBitmap.Create;
  end;

  tmpmap := TMapTexture.Create;

  for j := 0 to 63 do
    for i := 0 to 63 do
      tmpmap.MapTiles[i, j] := -1;

  tile := 0;
  for j := 0 to 15 do
    for i := 0 to 15 do
    begin
      tmpmap.MapTiles[i, j] := tile;
      inc(tile);
    end;

  for t := 0 to NUMTRANSLATIONS - 1 do
  begin
    for j := 0 to 15 do
      for i := 0 to 15 do
      begin
        tmpmap.Angles[i, j] := 0;
        tmpmap.Translation[i, j] := t;
      end;

    bkpalbitmap0[t].Width := 2048;
    bkpalbitmap0[t].Height := 2048;

    tmpmap.GetBitmap(buffer, False, 1024, 1024);
    bkpalbitmap0[t].Canvas.StretchDraw(Rect(0, 0, bkpalbitmap0[t].Width - 1, bkpalbitmap0[t].Height - 1), buffer);
    bkpalbitmap0[t].Width := 512;
    bkpalbitmap0[t].Height := 512;

    // 90 degress
    for j := 0 to 15 do
      for i := 0 to 15 do
      begin
        tmpmap.Angles[i, j] := 1;
        tmpmap.Translation[i, j] := t;
      end;

    bkpalbitmap1[t].Width := 2048;
    bkpalbitmap1[t].Height := 2048;

    tmpmap.GetBitmap(buffer, False, 1024, 1024);
    bkpalbitmap1[t].Canvas.StretchDraw(Rect(0, 0, bkpalbitmap1[t].Width - 1, bkpalbitmap1[t].Height - 1), buffer);
    bkpalbitmap1[t].Width := 512;
    bkpalbitmap1[t].Height := 512;

    // 180 degress
    for j := 0 to 15 do
      for i := 0 to 15 do
      begin
        tmpmap.Angles[i, j] := 2;
        tmpmap.Translation[i, j] := t;
      end;

    bkpalbitmap2[t].Width := 2048;
    bkpalbitmap2[t].Height := 2048;

    tmpmap.GetBitmap(buffer, False, 1024, 1024);
    bkpalbitmap2[t].Canvas.StretchDraw(Rect(0, 0, bkpalbitmap2[t].Width - 1, bkpalbitmap2[t].Height - 1), buffer);
    bkpalbitmap2[t].Width := 512;
    bkpalbitmap2[t].Height := 512;

    // 270 degress
    for j := 0 to 15 do
      for i := 0 to 15 do
      begin
        tmpmap.Angles[i, j] := 3;
        tmpmap.Translation[i, j] := t;
      end;

    bkpalbitmap3[t].Width := 2048;
    bkpalbitmap3[t].Height := 2048;

    tmpmap.GetBitmap(buffer, False, 1024, 1024);
    bkpalbitmap3[t].Canvas.StretchDraw(Rect(0, 0, bkpalbitmap3[t].Width - 1, bkpalbitmap3[t].Height - 1), buffer);
    bkpalbitmap3[t].Width := 512;
    bkpalbitmap3[t].Height := 512;
  end;

  tmpmap.Free;

  bkpalx := 1;
  bkpaly := 1;
  HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap0[curtrans], '0', bktile);

  doCreate := True;
  if ParamCount > 0 then
    if DoLoadFromFile(ParamStr(1)) then
      doCreate := False;

  if docreate then
  begin
    needsupdate := True;
    needbuffersupdate := True;
    DoCreateNew;
  end;

  Application.OnIdle := Idle;
  Application.OnHint := Hint;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  PaintBox1.Canvas.Draw(0, 0, drawbuffer);
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  t: integer;
begin
  closing := True;

  undoManager.Free;

  stringtobigstring(filemenuhistory.PathStringIdx(0), @opt_filemenuhistory0);
  stringtobigstring(filemenuhistory.PathStringIdx(1), @opt_filemenuhistory1);
  stringtobigstring(filemenuhistory.PathStringIdx(2), @opt_filemenuhistory2);
  stringtobigstring(filemenuhistory.PathStringIdx(3), @opt_filemenuhistory3);
  stringtobigstring(filemenuhistory.PathStringIdx(4), @opt_filemenuhistory4);
  stringtobigstring(filemenuhistory.PathStringIdx(5), @opt_filemenuhistory5);
  stringtobigstring(filemenuhistory.PathStringIdx(6), @opt_filemenuhistory6);
  stringtobigstring(filemenuhistory.PathStringIdx(7), @opt_filemenuhistory7);
  stringtobigstring(filemenuhistory.PathStringIdx(8), @opt_filemenuhistory8);
  stringtobigstring(filemenuhistory.PathStringIdx(9), @opt_filemenuhistory9);
  opt_showgrid := GridButton1.Down;
  opt_zoom := zoom;

  se_SaveSettingsToFile(ChangeFileExt(ParamStr(0), '.ini'));

  filemenuhistory.Free;

  buffer.Free;
  exportbuffer.Free;
  drawbuffer.Free;

  for t := 0 to NUMTRANSLATIONS - 1 do
  begin
    bkpalbitmap0[t].Free;
    bkpalbitmap1[t].Free;
    bkpalbitmap2[t].Free;
    bkpalbitmap3[t].Free;
  end;

  maptexture.Free;
  backscreen.Free;
end;

procedure TForm1.Idle(Sender: TObject; var Done: Boolean);
begin
  UpdateEnable;
end;

procedure TForm1.UpdateEnable;
begin
  Undo1.Enabled := undoManager.CanUndo;
  Redo1.Enabled := undoManager.CanRedo;
  Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
  UndoSpeedButton1.Enabled := undoManager.CanUndo;
  RedoSpeedButton1.Enabled := undoManager.CanRedo;
  PasteSpeedButton1.Enabled := Clipboard.HasFormat(CF_TEXT);
  ZoomInSpeedButton1.Enabled := zoom < MAXZOOM;
  ZoomOutSpeedButton1.Enabled := zoom > MINZOOM;

  PasteIntoSelection1.Enabled := HasSelection;
  PasteIntoSelection2.Enabled := HasSelection;

  if needsupdate then
  begin
    InvalidatePaintBox;
    needsupdate := False;
  end;
end;

procedure TForm1.Hint(Sender: TObject);
begin
  StatusBar1.SimpleText := Application.Hint;
end;

resourcestring
  rsTitle = 'GLSpeed Tile Editor';

procedure TForm1.About1Click(Sender: TObject);
begin
  MessageBox(
    Handle,
    PChar(Format('%s'#13#10'Version %s'#13#10#13#10'Helper tool for creating levels for GLSpeed.'#13#10'? 2021, jvalavanis@gmail.com', [rsTitle, I_VersionBuilt])),
    PChar(rsTitle),
    MB_OK or MB_ICONINFORMATION or MB_APPLMODAL);
end;

procedure TForm1.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.Copy1Click(Sender: TObject);
begin
  CopyToClipboardAsText;
end;

procedure TForm1.Open1Click(Sender: TObject);
begin
  if not CheckCanClose then
    Exit;

  if OpenDialog1.Execute then
    if not DoLoadFromFile(OpenDialog1.FileName) then
      FileNotFoundMsg(OpenDialog1.FileName);
end;

procedure TForm1.InvalidatePaintBox;
begin
  CreateDrawBuffer;

  if recalcscrollbox then
  begin
    SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 0, 0);
    try
      PaintBox1.Width := drawbuffer.Width;
      PaintBox1.Height := drawbuffer.Height;
      ScrollBox1.HorzScrollBar.Position := recalcscrollboxx;
      ScrollBox1.VertScrollBar.Position := recalcscrollboxy;
    finally
      SendMessage(ScrollBox1.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(ScrollBox1.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or RDW_FRAME or RDW_ALLCHILDREN);
    end;
    recalcscrollbox := False;
  end
  else
  begin
    PaintBox1.Width := drawbuffer.Width;
    PaintBox1.Height := drawbuffer.Height;
  end;

  PaintBox1.Invalidate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  UpdateEnable;
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Undo1.Enabled := undoManager.CanUndo;
  Redo1.Enabled := undoManager.CanRedo;
  Paste1.Enabled := Clipboard.HasFormat(CF_TEXT);
  PasteIntoSelection1.Enabled := HasSelection;
end;

procedure TForm1.EditActionFreeDraw(const X, Y: integer);
begin
  maptexture.MapTiles[X, Y] := bktile;
  maptexture.Angles[X, Y] := curangle;
  maptexture.Translation[X, Y] := curtrans;
end;

procedure TForm1.EditActionErase(const X, Y: integer);
begin
  maptexture.MapTiles[X, Y] := 0;
  maptexture.Angles[X, Y] := 0;
  maptexture.Translation[X, Y] := 0;
end;

procedure TForm1.EditActionFloodFill(const X, Y: integer);
var
  rover: integer;
begin
  rover := maptexture.MapTiles[X, Y];
  if rover <> bktile then
  begin
    maptexture.MapTiles[X, Y] := bktile;
    maptexture.Angles[X, Y] := curangle;
    maptexture.Translation[X, Y] := curtrans;
    if X > 0 then
      if maptexture.MapTiles[X - 1, Y] = rover then
        EditActionFloodFill(X - 1, Y);
    if X < SCREENSIZEX - 1 then
      if maptexture.MapTiles[X + 1, Y] = rover then
        EditActionFloodFill(X + 1, Y);
    if Y > 0 then
      if maptexture.MapTiles[X, Y - 1] = rover then
        EditActionFloodFill(X, Y - 1);
    if Y < SCREENSIZEY - 1 then
      if maptexture.MapTiles[X, Y + 1] = rover then
        EditActionFloodFill(X, Y + 1);
  end;
end;

procedure TForm1.EditActionRect(const X, Y: integer);
var
  atop, abottom, aleft, aright: integer;
  i: integer;
begin
  aleft := MinI(lmousedownx, X);
  aright := MaxI(lmousedownx, X);
  atop := MinI(lmousedowny, Y);
  abottom := MaxI(lmousedowny, Y);
  for i := aleft to aright do
  begin
    maptexture.MapTiles[i, atop] := bktile;
    maptexture.Angles[i, atop] := curangle;
    maptexture.Translation[i, atop] := curtrans;
    maptexture.MapTiles[i, abottom] := bktile;
    maptexture.Angles[i, abottom] := curangle;
    maptexture.Translation[i, abottom] := curtrans;
  end;
  for i := atop + 1 to abottom - 1 do
  begin
    maptexture.MapTiles[aleft, i] := bktile;
    maptexture.Angles[aleft, i] := curangle;
    maptexture.Translation[aleft, i] := curtrans;
    maptexture.MapTiles[aright, i] := bktile;
    maptexture.Angles[aright, i] := curangle;
    maptexture.Translation[aright, i] := curtrans;
  end;
end;

procedure TForm1.EditActionFillRect(const X, Y: integer);
var
  atop, abottom, aleft, aright: integer;
  i, j: integer;
begin
  aleft := MinI(lmousedownx, X);
  aright := MaxI(lmousedownx, X);
  atop := MinI(lmousedowny, Y);
  abottom := MaxI(lmousedowny, Y);
  for i := aleft to aright do
    for j := atop to abottom do
    begin
      maptexture.MapTiles[i, j] := bktile;
      maptexture.Angles[i, j] := curangle;
      maptexture.Translation[i, j] := curtrans;
    end;
end;

procedure TForm1.EditActionLine(const X, Y: integer);
begin
  maptexture.MapTiles[X, Y] := bktile;
  maptexture.Angles[X, Y] := curangle;
  maptexture.Translation[X, Y] := curtrans;
end;

procedure TForm1.midpointellipse(const X, Y: integer; const filled: boolean);
// midpoint ellipse algorithm
var
  rx, ry, xc, yc: integer;
  dx, dy, d1, d2: single;
  xx, yy: integer;
  i: integer;

  procedure _draw_point(const ax, ay: integer);
  begin
    if IsIntInRange(ax, 0, SCREENSIZEX - 1) then
      if IsIntInRange(ay, 0, SCREENSIZEY - 1) then
      begin
        maptexture.MapTiles[ax, ay] := bktile;
        maptexture.Angles[ax, ay] := curangle;
        maptexture.Translation[ax, ay] := curtrans;
      end;
  end;

begin
  rx := abs(lmousedownx - X);
  ry := abs(lmousedowny - Y);
  xc := lmousedownx;
  yc := lmousedowny;
  xx := 0;
  yy := ry;

  // Initial decision parameter of region 1
  d1 := (ry * ry) -
        (rx * rx * ry) +
        (0.25 * rx * rx);
  dx := 2 * ry * ry * xx;
  dy := 2 * rx * rx * yy;

  // For region 1
  while dx < dy do
  begin
    // Print points based on 4-way symmetry
    _draw_point(xx + xc, yy + yc);
    _draw_point(-xx + xc, yy + yc);
    _draw_point(xx + xc, -yy + yc);
    _draw_point(-xx + xc, -yy + yc);

    if filled then
      for i := -xx + xc + 1 to xx + xc - 1 do
      begin
        _draw_point(i, yy + yc);
        _draw_point(i, -yy + yc);
      end;

    // Checking and updating value of
    // decision parameter based on algorithm
    if d1 < 0 then
    begin
      inc(xx);
      dx := dx + (2 * ry * ry);
      d1 := d1 + dx + (ry * ry);
    end
    else
    begin
      inc(xx);
      dec(yy);
      dx := dx + (2 * ry * ry);
      dy := dy - (2 * rx * rx);
      d1 := d1 + dx - dy + (ry * ry);
    end;
  end;

  // Decision parameter of region 2
  d2 := ((ry * ry) * ((xx + 0.5) * (xx + 0.5))) +
        ((rx * rx) * ((yy - 1) * (yy - 1))) -
        (rx * rx * ry * ry);

  // Plotting points of region 2
  while yy >= 0 do
  begin
    // printing points based on 4-way symmetry
    _draw_point(xx + xc, yy + yc);
    _draw_point(-xx + xc, yy + yc);
    _draw_point(xx + xc, -yy + yc);
    _draw_point(-xx + xc, -yy + yc);

    if filled then
      for i := -xx + xc + 1 to xx + xc - 1 do
      begin
        _draw_point(i, yy + yc);
        _draw_point(i, -yy + yc);
      end;

    // Checking and updating parameter
    // value based on algorithm
    if d2 > 0 then
    begin
      dec(yy);
      dy := dy - (2 * rx * rx);
      d2 := d2 + (rx * rx) - dy;
    end
    else
    begin
      dec(yy);
      inc(xx);
      dx := dx + (2 * ry * ry);
      dy := dy - (2 * rx * rx);
      d2 := d2 + dx - dy + (rx * rx);
    end;
  end;
end;

procedure TForm1.EditActionEclipse(const X, Y: integer);
begin
  midpointellipse(X, Y, False);
end;

procedure TForm1.EditActionFillEclipse(const X, Y: integer);
begin
  midpointellipse(X, Y, True);
end;

procedure TForm1.EditActionRotateRight(const X, Y: integer);
var
  ang: integer;
begin
  if not IsIntInRange(X, 0, SCREENSIZEX - 1) then
    Exit;
  if not IsIntInRange(Y, 0, SCREENSIZEY - 1) then
    Exit;

  if anglerotated[X, Y] then
    Exit;

  anglerotated[X, Y] := True;

  ang := maptexture.Angles[X, Y];
  if ang = 3 then
    ang := 0
  else
    inc(ang);
  maptexture.Angles[X, Y] := ang;
end;

procedure TForm1.EditActionRotateLeft(const X, Y: integer);
var
  ang: integer;
begin
  if not IsIntInRange(X, 0, SCREENSIZEX - 1) then
    Exit;
  if not IsIntInRange(Y, 0, SCREENSIZEY - 1) then
    Exit;

  if anglerotated[X, Y] then
    Exit;

  anglerotated[X, Y] := True;

  ang := maptexture.Angles[X, Y];
  if ang = 0 then
    ang := 3
  else
    dec(ang);
  maptexture.Angles[X, Y] := ang;
end;

procedure TForm1.EditActionSelectionAt(const X, Y: integer);
begin
  if not IsIntInRange(X, 0, SCREENSIZEX - 1) then
    Exit;
  if not IsIntInRange(Y, 0, SCREENSIZEY - 1) then
    Exit;

  selRect.Right := X;
  selRect.Bottom := Y;
end;

procedure TForm1.LLeftMousePaintAt(const X, Y: integer);
begin
  if not lmousedown then
    Exit;
  if FreeDrawSpeedButton.Down then
    EditActionFreeDraw(X, Y)
  else if FloodFillSpeedButton.Down then
    EditActionFloodFill(X, Y)
  else if EraseSpeedButton.Down then
    EditActionErase(X, Y)
  else if RectSpeedButton.Down then
    EditActionRect(X, Y)
  else if FillRectSpeedButton.Down then
    EditActionFillRect(X, Y)
  else if LineSpeedButton.Down then
    EditActionLine(X, Y)
  else if EclipseSpeedButton.Down then
    EditActionEclipse(X, Y)
  else if FilledEclipseSpeedButton.Down then
    EditActionFillEclipse(X, Y)
  else if RotateRightSpeedButton.Down then
    EditActionRotateRight(X, Y)
  else if RotateLeftSpeedButton.Down then
    EditActionRotateLeft(X, Y)
  else if SelectSpeedButton.Down then
    EditActionSelectionAt(X, Y);
end;

procedure TForm1.LLeftMousePaintTo(const X, Y: integer);
var
  dx, dy: integer;
  curx, cury: integer;
  sx, sy,
  ax, ay,
  d: integer;
begin
  if not lmousedown then
    Exit;

  if lmouseclearonmove then
    maptexture.AssignTo(backscreen);

  if lmousetraceposition then
  begin
    dx := X - lmousedownx;
    ax := 2 * abs(dx);
    if dx < 0 then
      sx := -1
    else
      sx := 1;
    dy := Y - lmousedowny;
    ay := 2 * abs(dy);
    if dy < 0 then
      sy := -1
    else
      sy := 1;

    curx := lmousedownx;
    cury := lmousedowny;

    if ax > ay then
    begin
      d := ay - ax div 2;
      while True do
      begin
        LLeftMousePaintAt(curx, cury);
        if curx = X then break;
        if d >= 0 then
        begin
          cury := cury + sy;
          d := d - ax;
        end;
        curx := curx + sx;
        d := d + ay;
      end;
    end
    else
    begin
      d := ax - ay div 2;
      while True do
      begin
        LLeftMousePaintAt(curx, cury);
        if cury = Y then break;
        if d >= 0 then
        begin
          curx := curx + sx;
          d := d - ay;
        end;
        cury := cury + sy;
        d := d + ax;
      end;
    end;
  end
  else
  begin
    LLeftMousePaintAt(X, Y);
  end;

  needsupdate := True;
  if not SelectSpeedButton.Down then
  begin
    Changed := True;
    needbuffersupdate := True;
  end;
  InvalidatePaintBox;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    if not SelectSpeedButton.Down then
      undoManager.SaveUndo;

    backscreen.AssignTo(maptexture);

    lmousedown := True;
    lmousedownx := ZoomValueX(X);
    lmousedowny := ZoomValueY(Y);
    lmousemovex := ZoomValueX(X);
    lmousemovey := ZoomValueY(Y);

    if RotateRightSpeedButton.Down or RotateLeftSpeedButton.Down then
      ZeroMemory(@anglerotated, SizeOf(anglerotated));

    ClearSelection;
    if SelectSpeedButton.Down then
    begin
      selRect.Left := lmousedownx;
      selRect.Top := lmousedowny;
    end;

    LLeftMousePaintTo(lmousemovex, lmousemovey);
  end
  else if button = mbRight then
  begin
    rmousedownx := ZoomValueX(X);
    rmousedowny := ZoomValueX(Y);
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    lmousemovex := ZoomValueX(X);
    lmousemovey := ZoomValueY(Y);
    LLeftMousePaintTo(lmousemovex, lmousemovey);
    lmousedown := False;
  end
  else if button = mbRight then
    rmousedown := False;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  lmousemovex := ZoomValueX(X);
  lmousemovey := ZoomValueY(Y);
  StatusBar1.SimpleText := Format(
    'Position: (%d, %d), Tile Id: #%d, Angle: %d degress, Translation: %d',
      [lmousemovex, lmousemovey,
       maptexture.MapTiles[lmousemovex, lmousemovey],
       maptexture.Angles[lmousemovex, lmousemovey] * 90,
       maptexture.Translation[lmousemovex, lmousemovey]]
      );
  if lmousedown then
  begin
    LLeftMousePaintTo(lmousemovex, lmousemovey);
    if lmouserecalcdown then
    begin
      lmousedownx := ZoomValueX(X);
      lmousedowny := ZoomValueY(Y);
    end;
  end
end;

procedure TForm1.DrawGrid;
var
  x, y: integer;
  stepw, steph: integer;
begin
  if GridButton1.Down then
  begin
    drawbuffer.Canvas.Pen.Style := psSolid;
    drawbuffer.Canvas.Pen.Color := RGB(160, 160, 128);
    stepw := drawbuffer.Width div SCREENSIZEX;

    for x := 1 to SCREENSIZEX - 1 do
    begin
      drawbuffer.Canvas.MoveTo(x * stepw - 1, 0);
      drawbuffer.Canvas.LineTo(x * stepw - 1, drawbuffer.Height);
    end;

    steph := drawbuffer.Height div SCREENSIZEY;
    for y := 1 to SCREENSIZEY - 1 do
    begin
      drawbuffer.Canvas.MoveTo(0, y * steph - 1);
      drawbuffer.Canvas.LineTo(drawbuffer.Width, y * steph - 1);
    end;
  end;
end;

procedure TForm1.DrawSelection;
var
  sleft, stop, sright, sbottom: integer;
  stepw, steph: integer;
begin
  if not HasSelection then
    Exit;

  sleft := MinI(selRect.Left, selRect.Right);
  sright := MaxI(selRect.Left, selRect.Right);
  stop := MinI(selRect.Top, selRect.Bottom);
  sbottom := MaxI(selRect.Top, selRect.Bottom);

  stepw := drawbuffer.Width div SCREENSIZEX;
  steph := drawbuffer.Height div SCREENSIZEY;

  sleft := GetIntInRange(sleft * stepw, 0, drawbuffer.Width - 1);
  sright := GetIntInRange((sright + 1) * stepw, 0, drawbuffer.Width - 1);
  stop := GetIntInRange(stop * steph, 0, drawbuffer.Height - 1);
  sbottom := GetIntInRange((sbottom + 1) * steph, 0, drawbuffer.Height - 1);

  drawbuffer.Canvas.Pen.Style := psDash;
  drawbuffer.Canvas.Pen.Color := RGB(0, 0, 0);

  drawbuffer.Canvas.MoveTo(sleft, stop);
  drawbuffer.Canvas.LineTo(sright, stop);
  drawbuffer.Canvas.LineTo(sright, sbottom);
  drawbuffer.Canvas.LineTo(sleft, sbottom);
  drawbuffer.Canvas.LineTo(sleft, stop);
end;

procedure TForm1.NormalizeSelectionRect;
var
  sleft, stop, sright, sbottom: integer;
begin
  sleft := MinI(selRect.Left, selRect.Right);
  sright := MaxI(selRect.Left, selRect.Right);
  stop := MinI(selRect.Top, selRect.Bottom);
  sbottom := MaxI(selRect.Top, selRect.Bottom);
  selRect.Left := sleft;
  selRect.Right := sright;
  selRect.Top := stop;
  selRect.Bottom := sbottom;
end;

function TForm1.ZoomValueX(const X: Integer): Integer;
begin
  Result := GetIntInRange(X div (drawbuffer.Width div SCREENSIZEX), 0, SCREENSIZEX - 1);
end;

function TForm1.ZoomValueY(const Y: Integer): Integer;
begin
  Result := GetIntInRange(Y div (drawbuffer.Height div SCREENSIZEY), 0, SCREENSIZEY - 1);
end;

procedure TForm1.CreateDrawBuffer;
begin
  if needbuffersupdate then
  begin
    maptexture.GetBitmap(buffer, False);
    needbuffersupdate := False;
  end;

  drawbuffer.Width := SCREENSIZEX * ((TILESIZE div MAXZOOM) * zoom);
  drawbuffer.Height := SCREENSIZEY * ((TILESIZE div MAXZOOM) * zoom);

  drawbuffer.Canvas.StretchDraw(Rect(0, 0, drawbuffer.Width, drawbuffer.Height), buffer);
  DrawGrid;
  DrawSelection;
end;

procedure TForm1.CreateExportBuffer;
begin
  maptexture.GetBitmap(buffer, False);
  exportbuffer.Canvas.StretchDraw(Rect(0, 0, exportbuffer.Width, exportbuffer.Height), buffer);
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  if undoManager.CanUndo then
    undoManager.Undo;
end;

procedure TForm1.Redo1Click(Sender: TObject);
begin
  if undoManager.CanRedo then
    undoManager.Redo;
end;

procedure TForm1.File1Click(Sender: TObject);
begin
  filemenuhistory.RefreshMenuItems;
end;

procedure TForm1.DoPrepareEditor;
begin
  undoManager.Clear;
  ClearSelection;
  changed := False;
end;

procedure TForm1.DoCreateNew;
begin
  maptexture.Clear;
  DoPrepareEditor;
  needsupdate := True;
  needbuffersupdate := True;
  SetFileName('');
end;

procedure TForm1.DoLoadFromStream(const s: TStream);
begin
  needsupdate := True;
  needbuffersupdate := True;
  maptexture.LoadFromStream(s);
end;

procedure TForm1.DoSaveToStream(const s: TStream);
begin
  maptexture.SaveToStream(s);
end;

procedure TForm1.DoLoadUndo(const s: TStream);
begin
  DoLoadFromStream(s);
  changed := True;
end;

procedure TForm1.DoSaveUndo(const s: TStream);
begin
  DoSaveToStream(s);
end;

function TForm1.DoLoadFromFile(const aname: string): boolean;
var
  fs: TFileStream;
begin
  if not FileExists(aname) then
  begin
    Result := False;
    Exit;
  end;

  Result := True;
  fs := TFileStream.Create(aname, fmOpenRead);
  try
    DoLoadFromStream(fs);
    DoPrepareEditor;
    SetFileName(aname);
    filemenuhistory.AddPath(aname);
  finally
    fs.Free;
  end;
end;

procedure TForm1.FileNotFoundMsg(const aname: string);
begin
  ShowMessage(Format('Can not find file %s', [mkshortname(aname)]));
end;

procedure TForm1.DoSaveToFile(const aname: string);
var
  fs: TFileStream;
begin
  BackupFile(aname);
  fs := TFileStream.Create(aname, fmCreate);
  try
    DoSaveToStream(fs);
    SetFileName(aname);
    filemenuhistory.AddPath(aname);
    changed := False;
  finally
    fs.Free;
  end;
end;

procedure TForm1.OnLoadFileMenuHistory(Sender: TObject; const aname: string);
begin
  if CheckCanClose then
    if not DoLoadFromFile(aname) then
      FileNotFoundMsg(aname);
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := CheckCanClose;
end;

function TForm1.CheckCanClose: boolean;
var
  ret: integer;
begin
  if changed then
  begin
    ret := MessageBox(Handle, 'Do you want to save changes?', PChar(rsTitle), MB_YESNOCANCEL or MB_ICONQUESTION or MB_APPLMODAL);
    if ret = IDCANCEL	then
    begin
      Result := False;
      exit;
    end;
    if ret = IDNO	then
    begin
      Result := True;
      exit;
    end;
    if ret = IDYES then
    begin
      Save1Click(self);
      Result := not changed;
      exit;
    end;
  end;
  Result := True;
end;

procedure TForm1.New1Click(Sender: TObject);
begin
  if not CheckCanClose then
    Exit;

  DoCreateNew;
end;

procedure TForm1.SetFileName(const fname: string);
begin
  ffilename := fname;
  Caption := rsTitle;
  if ffilename <> '' then
    Caption := Caption + ' - ' + MkShortName(ffilename);
end;

procedure TForm1.Save1Click(Sender: TObject);
begin
  if ffilename = '' then
  begin
    SaveAs1Click(Sender);
    Exit;
  end;

  DoSaveToFile(ffilename);
end;

procedure TForm1.SaveAs1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
    DoSaveToFile(SaveDialog1.FileName);
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  pt: TPoint;
  r: TRect;
  tick: int64;
  fx, fy: double;
  w, h: integer;
  mx1, my1, mx2, my2: integer;
  currscrollx, currscrolly: integer;
  currscrollrx, currscrollry: integer;
begin
  tick := GetTickCount;
  if tick <= flastzoomwheel + MOUSEWHEELTIMEOUT then
    Exit;

  flastzoomwheel := tick;
  pt := PaintBox1.Parent.ScreenToClient(MousePos);
  r := PaintBox1.ClientRect;

  if PtInRect(r, pt) then
  begin
    w := SCREENSIZEX * ((TILESIZE div MAXZOOM) * zoom);
    h := SCREENSIZEY * ((TILESIZE div MAXZOOM) * zoom);

    fx := pt.X / w;
    fy := pt.Y / h;
    mx1 := pt.X;
    my1 := pt.Y;

    ZoomOut1Click(Sender);

    if zoom > MINZOOM then
    begin
      w := SCREENSIZEX * ((TILESIZE div MAXZOOM) * zoom);
      h := SCREENSIZEY * ((TILESIZE div MAXZOOM) * zoom);

      mx2 := Trunc(fx * w);
      my2 := Trunc(fy * h);

      if recalcscrollbox then
      begin
        currscrollx := recalcscrollboxx;
        currscrolly := recalcscrollboxy;
        currscrollrx := recalcscrollboxrx;
        currscrollry := recalcscrollboxry;
      end
      else
      begin
        currscrollx := ScrollBox1.HorzScrollBar.Position;
        currscrolly := ScrollBox1.VertScrollBar.Position;
        currscrollrx := ScrollBox1.HorzScrollBar.Range;
        currscrollry := ScrollBox1.VertScrollBar.Range;
      end;

      recalcscrollbox := True;
      recalcscrollboxx := GetIntInRange(currscrollx + mx2 - mx1, 0, currscrollrx - 1);
      recalcscrollboxy := GetIntInRange(currscrolly + my2 - my1, 0, currscrollry - 1);
      recalcscrollboxrx := w;
      recalcscrollboxry := h;
//      recalcscrollboxx := GetIntInRange(Trunc(currscrollx * fx) + mx2 - mx1, 0, ScrollBox1.HorzScrollBar.Range - 1);
//      recalcscrollboxy := GetIntInRange(Trunc(currscrolly * fy) + my2 - my1, 0, ScrollBox1.VertScrollBar.Range - 1);
    end;
  end;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  pt: TPoint;
  r: TRect;
  tick: int64;
  fx, fy: double;
  w, h: integer;
  mx1, my1, mx2, my2: integer;
  currscrollx, currscrolly: integer;
  currscrollrx, currscrollry: integer;
begin
  tick := GetTickCount;
  if tick <= flastzoomwheel + MOUSEWHEELTIMEOUT then
    Exit;

  flastzoomwheel := tick;
  pt := PaintBox1.Parent.ScreenToClient(MousePos);
  r := PaintBox1.ClientRect;

  if PtInRect(r, pt) then
  begin
    w := SCREENSIZEX * ((TILESIZE div MAXZOOM) * zoom);
    h := SCREENSIZEY * ((TILESIZE div MAXZOOM) * zoom);

    fx := pt.X / w;
    fy := pt.Y / h;
    mx1 := pt.X;
    my1 := pt.Y;

    ZoomIn1Click(Sender);

    if zoom < MAXZOOM then
    begin
      w := SCREENSIZEX * ((TILESIZE div MAXZOOM) * zoom);
      h := SCREENSIZEY * ((TILESIZE div MAXZOOM) * zoom);

      mx2 := Trunc(fx * w);
      my2 := Trunc(fy * h);

      if recalcscrollbox then
      begin
        currscrollx := recalcscrollboxx;
        currscrolly := recalcscrollboxy;
        currscrollrx := recalcscrollboxrx;
        currscrollry := recalcscrollboxry;
      end
      else
      begin
        currscrollx := ScrollBox1.HorzScrollBar.Position;
        currscrolly := ScrollBox1.VertScrollBar.Position;
        currscrollrx := ScrollBox1.HorzScrollBar.Range;
        currscrollry := ScrollBox1.VertScrollBar.Range;
      end;

      recalcscrollbox := True;
      recalcscrollboxx := GetIntInRange(currscrollx + mx2 - mx1, 0, currscrollrx - 1);
      recalcscrollboxy := GetIntInRange(currscrolly + my2 - my1, 0, currscrollry - 1);
      recalcscrollboxrx := w;
      recalcscrollboxry := h;
//      recalcscrollboxx := GetIntInRange(Trunc(currscrollx * fx) + mx2 - mx1, 0, ScrollBox1.HorzScrollBar.Range - 1);
//      recalcscrollboxy := GetIntInRange(Trunc(currscrolly * fy) + my2 - my1, 0, ScrollBox1.VertScrollBar.Range - 1);
    end;
  end;
end;

procedure TForm1.ZoomIn1Click(Sender: TObject);
begin
  if zoom < MAXZOOM then
  begin
    inc(zoom);
    needsupdate := True;
  end;
end;

procedure TForm1.ZoomOut1Click(Sender: TObject);
begin
  if zoom > MINZOOM then
  begin
    dec(zoom);
    needsupdate := True;
  end;
end;

procedure TForm1.GridButton1Click(Sender: TObject);
begin
  InvalidatePaintBox;
end;

procedure TForm1.HandlePaletteImage(const X, Y: integer; const Palette1: TImage;
  const palbitmap: TBitmap; const tx: string; var cc: integer);
var
  px, py: integer;
  C: TCanvas;
  txcolor: LongWord;
begin
  if closing then
    Exit;

  if not IsIntInRange(X, 0, Palette1.Width - 1) then
    Exit;

  if not IsIntInRange(Y, 0, Palette1.Height - 1) then
    Exit;

  bkpalx := X;
  bkpaly := Y;

  cc := (X div 32) + (Y div 32) * 16;

  Palette1.Picture.Bitmap.Width := 512;
  Palette1.Picture.Bitmap.Height := 512;

  C := Palette1.Picture.Bitmap.Canvas;
  C.Draw(0, 0, palbitmap);
  px := X div COLORPICKTILESIZE;
  py := Y div COLORPICKTILESIZE;
  C.Pen.Style := psSolid;
  txcolor := RGB(255, 255, 255);
  C.Pen.Color := txcolor;
  C.MoveTo(px * COLORPICKTILESIZE, py * COLORPICKTILESIZE);
  C.LineTo((1 + px) * COLORPICKTILESIZE - 1, py * COLORPICKTILESIZE);
  C.LineTo((1 + px) * COLORPICKTILESIZE - 1, (1 + py) * COLORPICKTILESIZE - 1);
  C.LineTo(px * COLORPICKTILESIZE, (1 + py) * COLORPICKTILESIZE - 1);
  C.LineTo(px * COLORPICKTILESIZE, py * COLORPICKTILESIZE);
  C.Font.Size := 10;
  C.Font.Color := txcolor;
  C.Brush.Style := bsClear;
  C.TextOut(
    px * COLORPICKTILESIZE + COLORPICKTILESIZE div 2 - C.TextWidth(tx) div 2,
    py * COLORPICKTILESIZE + COLORPICKTILESIZE div 2 - C.TextHeight(tx) div 2,
    tx
  );
  Palette1.Invalidate;
end;

procedure TForm1.BackgroundPalette1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case curangle of
    0: HandlePaletteImage(X, Y, BackgroundPalette1, bkpalbitmap0[curtrans], '0', bktile);
    1: HandlePaletteImage(X, Y, BackgroundPalette1, bkpalbitmap1[curtrans], '90', bktile);
    2: HandlePaletteImage(X, Y, BackgroundPalette1, bkpalbitmap2[curtrans], '180', bktile);
  else
    HandlePaletteImage(X, Y, BackgroundPalette1, bkpalbitmap3[curtrans], '270', bktile);
  end;
end;

procedure TForm1.FreeDrawSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.EraseSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.FloodFillSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.RectSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.FillRectSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.LineSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := True;
  lmouseclearonmove := True;
end;

procedure TForm1.EclipseSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;


procedure TForm1.FilledEclipseSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.TextSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := False;
end;

procedure TForm1.TextColorChangeSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.SpecialCharSpeedButton1Click(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.SpecialCharSpeedButton2Click(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.CharRectSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.BlinkOnSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.BlinkOffSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.Cut1Click(Sender: TObject);
var
  x, y: integer;
begin
  CopyToClipboardAsText;
  undoManager.SaveUndo;
  Changed := True;
  for x := 0 to SCREENSIZEX - 1 do
    for y := 0 to SCREENSIZEY - 1 do
    begin
      maptexture.MapTiles[x, y] := 0;
      maptexture.Angles[x, y] := 0;
    end;
  needsupdate := True;
  needbuffersupdate := True;
end;

procedure TForm1.PaintBoxPopupMenu1Popup(Sender: TObject);
begin
  Undo2.Enabled := undoManager.CanUndo;
  Redo2.Enabled := undoManager.CanRedo;
  Paste2.Enabled := Clipboard.HasFormat(CF_TEXT);
  PasteIntoSelection2.Enabled := HasSelection;
  Applyrotation1.Visible := HasSelection;
  Applytranslation1.Visible := HasSelection;
end;

procedure TForm1.Export1Click(Sender: TObject);
var
  imgfname: string;
begin
  if SavePictureDialog1.Execute then
  begin
    Screen.Cursor := crHourglass;
    try
      imgfname := SavePictureDialog1.FileName;
      BackupFile(imgfname);
      DoExportImage(imgfname);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.DoExportImage(const imgfname: string);
var
  png: TPngObject;
  jpg: TJPEGImage;
  ext: string;
begin
  CreateExportBuffer;
  ext := UpperCase(ExtractFileExt(imgfname));
  if ext = '.PNG' then
  begin
    png := TPngObject.Create;
    png.Assign(exportbuffer);
    png.SaveToFile(imgfname);
    png.Free;
  end
  else if (ext = '.JPG') or (ext = '.JPEG') then
  begin
    jpg := TJPEGImage.Create;
    jpg.Assign(exportbuffer);
    jpg.SaveToFile(imgfname);
    jpg.Free;
  end
  else
    exportbuffer.SaveToFile(imgfname);
end;

procedure TForm1.RotateRightSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.RotateLeftSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := True;
  lmousetraceposition := True;
  lmouseclearonmove := False;
end;

procedure TForm1.CopyAsImage1Click(Sender: TObject);
begin
  CreateExportBuffer;
  Clipboard.Assign(buffer);
end;

procedure TForm1.Paste1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    undoManager.SaveUndo;
    maptexture.ApplyImportText(Clipboard.AsText);
    needsupdate := True;
    needbuffersupdate := True;
    Changed := True;
  end;
end;

procedure TForm1.Cut2Click(Sender: TObject);
begin
  CopyToClipboardAsText;
  undoManager.SaveUndo;
  Changed := True;
  maptexture.MapTiles[rmousedownx, rmousedowny] := 0;
  maptexture.Angles[rmousedownx, rmousedowny] := 0;
  needsupdate := True;
  needbuffersupdate := True;
end;

procedure TForm1.RotateSpeedButton0Click(Sender: TObject);
begin
  curangle := 0;
  HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap0[curtrans], '0', bktile);
end;

procedure TForm1.RotateSpeedButton90Click(Sender: TObject);
begin
  curangle := 1;
  HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap1[curtrans], '90', bktile);
end;

procedure TForm1.RotateSpeedButton180Click(Sender: TObject);
begin
  curangle := 2;
  HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap2[curtrans], '180', bktile);
end;

procedure TForm1.RotateSpeedButton270Click(Sender: TObject);
begin
  curangle := 3;
  HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap3[curtrans], '270', bktile);
end;

procedure TForm1.ClearSelection;
begin
  selRect.Left := -1;
  selRect.Top := -1;
  selRect.Right := -1;
  selRect.Bottom := -1;
end;

function TForm1.HasSelection: boolean;
begin
  Result :=
    IsIntInRange(selRect.Left, 0, SCREENSIZEX - 1) and
    IsIntInRange(selRect.Right, 0, SCREENSIZEX - 1) and
    IsIntInRange(selRect.Top, 0, SCREENSIZEY - 1) and
    IsIntInRange(selRect.bottom, 0, SCREENSIZEY - 1);
end;

procedure TForm1.SelectSpeedButtonClick(Sender: TObject);
begin
  lmouserecalcdown := False;
  lmousetraceposition := False;
  lmouseclearonmove := True;
end;

procedure TForm1.CopyToClipboardAsText;
begin
  if HasSelection then
  begin
    try Clipboard.AsText := maptexture.GetExportText(selRect.Left, selRect.Right, selRect.Top, selRect.Bottom); except end;
  end
  else
  begin
    if rmousedown then
    begin
      try Clipboard.AsText := maptexture.GetExportText(rmousedownx, rmousedownx, rmousedowny, rmousedowny); except end;
    end
    else
    begin
      try Clipboard.AsText := maptexture.GetExportText; except end;
    end;
  end;
end;

procedure TForm1.PasteIntoSelection1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) and HasSelection then
  begin
    undoManager.SaveUndo;
    maptexture.ApplyImportText(Clipboard.AsText, selRect.Left, selRect.Right, selRect.Top, selRect.Bottom);
    needsupdate := True;
    needbuffersupdate := True;
    Changed := True;
  end;
end;

procedure TForm1.PasteHere1Click(Sender: TObject);
begin
  if Clipboard.HasFormat(CF_TEXT) then
  begin
    undoManager.SaveUndo;
    maptexture.ApplyImportText(Clipboard.AsText, rmousedownx, SCREENSIZEX - 1, rmousedowny, SCREENSIZEY - 1);
    needsupdate := True;
    needbuffersupdate := True;
    Changed := True;
  end;
end;

procedure TForm1.DoExportWAD4096(const fn: string; const lname: string);
var
  ms: TMemoryStream;
  wadr: TWadReader;
  wadw: TWadWriter;
  i: integer;
  buf4096: bmbuffer4096_p;
  ename: string;
  ebuffer: pointer;
  esize: integer;
  mname: string;
  msec: Pmapsector_t;
  flatname: string;
begin
  ms := TMemoryStream.Create;
  ms.Write(DOOMMAP, SizeOf(DOOMMAP));
  ms.Position := 0;

  wadr := TWadReader.Create;
  wadr.LoadFromStream(ms);

  wadw := TWadWriter.Create;

  mname := lname;
  if Length(mname) <> 4 then
    mname := 'E2M1';

  flatname := mname + 'FLAT';

  for i := 0 to wadr.NumEntries - 1 do
  begin
    ename := wadr.EntryName(i);
    wadr.ReadEntry(i, ebuffer, esize);
    if ename = 'E1M1' then
      ename := mname;
    if ename = 'SECTORS' then
    begin
      msec := ebuffer;
      msec.floorpic := stringtochar8(flatname);
    end;
    wadw.AddData(ename, ebuffer, esize);
    FreeMem(ebuffer, esize);
  end;
//    wadw.AddString(wadr.EntryName(i), wadr.EntryAsString(i));

  GetMem(buf4096, SizeOf(bmbuffer4096_t));

  maptexture.GetBuffer4096(buf4096);
  wadw.AddString('FLATSIZE', flatname + '=8192');
  wadw.AddSeparator('F_START');
  wadw.AddData(flatname, buf4096, SizeOf(bmbuffer4096_t));
  wadw.AddSeparator('F_END');

  ms.Free;

  ms := TMemoryStream.Create;
  maptexture.SaveToStream(ms);

  wadw.AddData(mname + '_DAT', ms.Memory, ms.Size);
  ms.Free;

  wadw.SaveToFile(fn);


  wadw.Free;
  wadr.Free;

  FreeMem(buf4096);
end;

procedure TForm1.DoExportWAD8192(const fn: string; const lname: string);
var
  ms: TMemoryStream;
  wadr: TWadReader;
  wadw: TWadWriter;
  i: integer;
  buf8192: bmbuffer8192_p;
  ename: string;
  ebuffer: pointer;
  esize: integer;
  mname: string;
  msec: Pmapsector_t;
  flatname: string;
begin
  ms := TMemoryStream.Create;
  ms.Write(DOOMMAP, SizeOf(DOOMMAP));
  ms.Position := 0;

  wadr := TWadReader.Create;
  wadr.LoadFromStream(ms);

  wadw := TWadWriter.Create;

  mname := lname;
  if Length(mname) <> 4 then
    mname := 'E2M1';

  flatname := mname + 'FLAT';

  for i := 0 to wadr.NumEntries - 1 do
  begin
    ename := wadr.EntryName(i);
    wadr.ReadEntry(i, ebuffer, esize);
    if ename = 'E1M1' then
      ename := mname;
    if ename = 'SECTORS' then
    begin
      msec := ebuffer;
      msec.floorpic := stringtochar8(flatname);
    end;
    wadw.AddData(ename, ebuffer, esize);
    FreeMem(ebuffer, esize);
  end;
//    wadw.AddString(wadr.EntryName(i), wadr.EntryAsString(i));

  GetMem(buf8192, SizeOf(bmbuffer8192_t));

  maptexture.GetBuffer8192(buf8192);
  wadw.AddString('FLATSIZE', flatname + '=8192');
  wadw.AddSeparator('F_START');
  wadw.AddData(flatname, buf8192, SizeOf(bmbuffer8192_t));
  wadw.AddSeparator('F_END');

  ms.Free;

  ms := TMemoryStream.Create;
  maptexture.SaveToStream(ms);

  wadw.AddData(mname + '_DAT', ms.Memory, ms.Size);
  ms.Free;

  wadw.SaveToFile(fn);


  wadw.Free;
  wadr.Free;

  FreeMem(buf8192);
end;

var
  lname: string = 'E2M1';

procedure TForm1.ExportWAD1Click(Sender: TObject);
begin
  if SaveWADDialog.Execute then
  begin
    lname := InputBox(rsTitle, 'Map name', lname);
    BackupFile(SaveWADDialog.FileName);
    DoExportWAD8192(SaveWADDialog.FileName, lname);
  end;
end;

procedure TForm1.ExportWAD40961Click(Sender: TObject);
begin
  if SaveWADDialog.Execute then
  begin
    lname := InputBox(rsTitle, 'Map name', lname);
    BackupFile(SaveWADDialog.FileName);
    DoExportWAD4096(SaveWADDialog.FileName, lname);
  end;
end;

procedure TForm1.ChangeEditorTranslation(const trn: integer);
begin
  curtrans := trn;
  case curangle of
    0: HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap0[curtrans], '0', bktile);
    1: HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap1[curtrans], '90', bktile);
    2: HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap2[curtrans], '180', bktile);
  else
    HandlePaletteImage(bkpalx, bkpaly, BackgroundPalette1, bkpalbitmap3[curtrans], '270', bktile);
  end;
end;

procedure TForm1.Trans0SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(0);
end;

procedure TForm1.Trans1SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(1);
end;

procedure TForm1.Trans2SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(2);
end;

procedure TForm1.Trans3SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(3);
end;

procedure TForm1.Trans4SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(4);
end;

procedure TForm1.Trans5SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(5);
end;

procedure TForm1.Trans6SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(6);
end;

procedure TForm1.Trans7SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(7);
end;

procedure TForm1.Trans8SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(8);
end;

procedure TForm1.Trans9SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(9);
end;

procedure TForm1.Trans10SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(10);
end;

procedure TForm1.Applyrotation1Click(Sender: TObject);
var
  sleft, stop, sright, sbottom: integer;
  iX, iY: integer;
begin
  if not HasSelection then
    Exit;

  undoManager.SaveUndo;
  sleft := MinI(selRect.Left, selRect.Right);
  sright := MaxI(selRect.Left, selRect.Right);
  stop := MinI(selRect.Top, selRect.Bottom);
  sbottom := MaxI(selRect.Top, selRect.Bottom);

  for iX := sleft to sright do
    for iY := stop to sbottom do
      maptexture.Angles[iX, iY] := curangle;
end;

procedure TForm1.Applytranslation1Click(Sender: TObject);
var
  sleft, stop, sright, sbottom: integer;
  iX, iY: integer;
begin
  if not HasSelection then
    Exit;

  undoManager.SaveUndo;
  sleft := MinI(selRect.Left, selRect.Right);
  sright := MaxI(selRect.Left, selRect.Right);
  stop := MinI(selRect.Top, selRect.Bottom);
  sbottom := MaxI(selRect.Top, selRect.Bottom);

  for iX := sleft to sright do
    for iY := stop to sbottom do
      maptexture.Translation[iX, iY] := curtrans;

  needsupdate := True;
  needbuffersupdate := True;
end;

procedure TForm1.Trans11SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(11);
end;

procedure TForm1.Trans12SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(12);
end;

procedure TForm1.Trans13SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(13);
end;

procedure TForm1.Trans14SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(14);
end;

procedure TForm1.Trans15SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(15);
end;

procedure TForm1.Trans16SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(16);
end;

procedure TForm1.Trans17SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(17);
end;

procedure TForm1.Trans18SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(18);
end;

procedure TForm1.Trans19SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(19);
end;

procedure TForm1.Trans20SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(20);
end;

procedure TForm1.Trans21SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(21);
end;

procedure TForm1.Trans22SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(22);
end;

procedure TForm1.Trans23SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(23);
end;

procedure TForm1.Trans24SpeedButtonClick(Sender: TObject);
begin
  ChangeEditorTranslation(24);
end;

end.

