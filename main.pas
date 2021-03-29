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
//  Main Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, xTGA, jpeg, zBitmap, ComCtrls, ExtCtrls, Buttons, Menus, FileCtrl,
  StdCtrls, AppEvnts, ExtDlgs, clipbrd, ToolWin, se_class, se_undo,
  se_filemenuhistory, se_slider, PngImage1, se_pk3, se_colorpickerbutton,
  xTIFF, ImgList;

type
  drawlayeritem_t = packed record
    pass: byte;
    color: integer;
  end;

  drawlayer_t = packed array[0..MAXTEXTURESIZE - 1, 0..MAXTEXTURESIZE - 1] of drawlayeritem_t;
  drawlayer_p = ^drawlayer_t;

type
  colorbuffer_t = array[0..MAXTEXTURESIZE - 1, 0..MAXTEXTURESIZE - 1] of LongWord;
  colorbuffer_p = ^colorbuffer_t;

const
  MAXPENSIZE = 128;

const
  MINTEXTURESCALE = 8;
  MAXTEXTURESCALE = 400;

const
  MINZOOM = 1;
  MAXZOOM = 8;

const
  MOUSEWHEELTIMEOUT = 150; // Msecs until next mouse wheel even to be proccessed

type
  TForm1 = class(TForm)
    ColorDialog1: TColorDialog;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Open1: TMenuItem;
    Open2: TMenuItem;
    Save1: TMenuItem;
    Savesa1: TMenuItem;
    N2: TMenuItem;
    Exit1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    ApplicationEvents1: TApplicationEvents;
    OpenDialog1: TOpenDialog;
    Undo1: TMenuItem;
    Redo1: TMenuItem;
    OpenPictureDialog1: TOpenPictureDialog;
    Timer1: TTimer;
    StatusBar1: TStatusBar;
    SaveDialog1: TSaveDialog;
    N5: TMenuItem;
    N8: TMenuItem;
    CopyTexture1: TMenuItem;
    ToolBar1: TToolBar;
    PropertiesPanel: TPanel;
    Splitter1: TSplitter;
    SaveAsButton1: TSpeedButton;
    SaveButton1: TSpeedButton;
    OpenButton1: TSpeedButton;
    NewButton1: TSpeedButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    UndoButton1: TSpeedButton;
    RedoButton1: TSpeedButton;
    AboutButton1: TSpeedButton;
    N7: TMenuItem;
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
    EditPageControl: TPageControl;
    TabSheet1: TTabSheet;
    OpenWADDialog: TOpenDialog;
    Panel1: TPanel;
    Label3: TLabel;
    PenSizePaintBox: TPaintBox;
    PenSizeLabel: TLabel;
    OpacityLabel: TLabel;
    OpacityPaintBox: TPaintBox;
    Label2: TLabel;
    PenSpeedButton1: TSpeedButton;
    PenSpeedButton2: TSpeedButton;
    PenSpeedButton3: TSpeedButton;
    Bevel2: TBevel;
    PasteTexture1: TMenuItem;
    PalettePopupMenu1: TPopupMenu;
    PaletteDoom1: TMenuItem;
    PaletteHeretic1: TMenuItem;
    PaletteHexen1: TMenuItem;
    PaletteStrife1: TMenuItem;
    PaletteRadix1: TMenuItem;
    N18: TMenuItem;
    PaletteGreyScale1: TMenuItem;
    PaletteDefault1: TMenuItem;
    N6: TMenuItem;
    N9: TMenuItem;
    Panel2: TPanel;
    TexturePageControl: TPageControl;
    WADTabSheet1: TTabSheet;
    OpenWADMainPanel: TPanel;
    Panel3: TPanel;
    Pk3TabSheet: TTabSheet;
    Panel12: TPanel;
    Panel13: TPanel;
    OpenPK3Dialog: TOpenDialog;
    DirTabSheet: TTabSheet;
    Panel4: TPanel;
    Panel6: TPanel;
    MNImportTexture1: TMenuItem;
    TextureScaleResetLabel: TLabel;
    TextureScalePaintBox: TPaintBox;
    TextureScaleLabel: TLabel;
    ColorTabSheet: TTabSheet;
    SelectColorBackPanel: TPanel;
    Panel29: TPanel;
    ToolButton5: TToolButton;
    MNExpoortTexture1: TMenuItem;
    SavePictureDialog1: TSavePictureDialog;
    Panel5: TPanel;
    WADPageControl1: TPageControl;
    WADFlatsTabSheet: TTabSheet;
    Panel7: TPanel;
    WADFlatListPanel: TPanel;
    Panel28: TPanel;
    WADFlatsListBox: TListBox;
    WADPreviewFlatPanel: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    WADFlatPreviewImage: TImage;
    Panel11: TPanel;
    FlatSizeLabel: TLabel;
    WAADFlatNameLabel: TLabel;
    Panel30: TPanel;
    PaletteSpeedButton1: TSpeedButton;
    SelectWADFileButton: TSpeedButton;
    WADFileNameEdit: TEdit;
    Label23: TLabel;
    Panel31: TPanel;
    Label5: TLabel;
    PK3FileNameEdit: TEdit;
    SelectPK3FileButton: TSpeedButton;
    Panel32: TPanel;
    Label6: TLabel;
    DIRFileNameEdit: TEdit;
    SelectDIRFileButton: TSpeedButton;
    Panel33: TPanel;
    ColorPanel1: TPanel;
    PickColorRGBLabel: TLabel;
    Panel15: TPanel;
    PK3PageControl: TPageControl;
    PK3TexturesTabSheet: TTabSheet;
    Panel16: TPanel;
    PK3TextureListPanel: TPanel;
    Panel34: TPanel;
    PK3TexListBox: TListBox;
    PK3PreviewTexturePanel: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    PK3TexPreviewImage: TImage;
    Panel21: TPanel;
    PK3TexSizeLabel: TLabel;
    PK3TextureNameLabel: TLabel;
    Panel14: TPanel;
    DirPageControl: TPageControl;
    DirTexturesTabSheet: TTabSheet;
    Panel17: TPanel;
    DIRTextureListPanel: TPanel;
    Panel36: TPanel;
    DIRTexListBox: TListBox;
    DIRPreviewTexturePanel: TPanel;
    Panel22: TPanel;
    Panel23: TPanel;
    Panel24: TPanel;
    DIRTexPreviewImage: TImage;
    Panel25: TPanel;
    DIRTexSizeLabel: TLabel;
    DIRTextureNameLabel: TLabel;
    Panel26: TPanel;
    ColorPalettePageControl: TPageControl;
    ColorPaletteTabSheet: TTabSheet;
    Panel27: TPanel;
    PickColorPalettePanel: TPanel;
    ColorPaletteImage: TImage;
    WADPatchesTabSheet: TTabSheet;
    Panel35: TPanel;
    WADPatchListPanel: TPanel;
    Panel37: TPanel;
    WADPatchListBox: TListBox;
    WADPreviewPatchPanel: TPanel;
    Panel38: TPanel;
    Panel39: TPanel;
    Panel40: TPanel;
    WADPatchPreviewImage: TImage;
    Panel41: TPanel;
    WADPatchSizeLabel: TLabel;
    WADPatchNameLabel: TLabel;
    PaintScrollBox: TScrollBox;
    PaintBox1: TPaintBox;
    Colors1: TMenuItem;
    Doom1: TMenuItem;
    Heretic1: TMenuItem;
    Hexen1: TMenuItem;
    Strife1: TMenuItem;
    Radix1: TMenuItem;
    ToolButton4: TToolButton;
    ZoomInButton1: TSpeedButton;
    ZoomOutButton1: TSpeedButton;
    Filter1: TMenuItem;
    FilterLaplace1: TMenuItem;
    FilterHiPass1: TMenuItem;
    FilterFindEdges1: TMenuItem;
    FilterSharpen1: TMenuItem;
    FilterEdgeEnhance1: TMenuItem;
    FilterColorEmboss1: TMenuItem;
    FilterSoften1: TMenuItem;
    FilterSofterless1: TMenuItem;
    FilterBlur1: TMenuItem;
    FilterBlurmore1: TMenuItem;
    FilterBlurmax1: TMenuItem;
    FilterGrease1: TMenuItem;
    FilterLithograph1: TMenuItem;
    FilterPsychedelicDistillation1: TMenuItem;
    WADFlatRotateRadioGroup: TRadioGroup;
    WADPatchRotateRadioGroup: TRadioGroup;
    PK3RotateRadioGroup: TRadioGroup;
    DIRRotateRadioGroup: TRadioGroup;
    SizeSpeedButton1: TSpeedButton;
    OpacitySpeedButton1: TSpeedButton;
    ScaleSpeedButton1: TSpeedButton;
    N1: TMenuItem;
    Grayscale1: TMenuItem;
    RedScale1: TMenuItem;
    GreenScale1: TMenuItem;
    BlueScale1: TMenuItem;
    N3: TMenuItem;
    LinearScaleCheckBox1: TCheckBox;
    ColorDialog2: TColorDialog;
    ColorScale1: TMenuItem;
    N4: TMenuItem;
    NegativeImage1: TMenuItem;
    N10: TMenuItem;
    RemapColorChannels1: TMenuItem;
    GaussianBlur1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure NewButton1Click(Sender: TObject);
    procedure SaveButton1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure AboutButton1Click(Sender: TObject);
    procedure SaveAsButton1Click(Sender: TObject);
    procedure ExitButton1Click(Sender: TObject);
    procedure OpenButton1Click(Sender: TObject);
    procedure ApplicationEvents1Idle(Sender: TObject; var Done: Boolean);
    procedure Edit1Click(Sender: TObject);
    procedure Undo1Click(Sender: TObject);
    procedure Redo1Click(Sender: TObject);
    procedure File1Click(Sender: TObject);
    procedure CopyTexture1Click(Sender: TObject);
    procedure PaintBox1Paint(Sender: TObject);
    procedure SelectWADFileButtonClick(Sender: TObject);
    procedure WADFlatsListBoxClick(Sender: TObject);
    procedure PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PenSpeedButton1Click(Sender: TObject);
    procedure PenSpeedButton2Click(Sender: TObject);
    procedure PenSpeedButton3Click(Sender: TObject);
    procedure PasteTexture1Click(Sender: TObject);
    procedure PaletteSpeedButton1Click(Sender: TObject);
    procedure PaletteDefault1Click(Sender: TObject);
    procedure PaletteDoom1Click(Sender: TObject);
    procedure PaletteHeretic1Click(Sender: TObject);
    procedure PaletteHexen1Click(Sender: TObject);
    procedure PaletteStrife1Click(Sender: TObject);
    procedure PaletteRadix1Click(Sender: TObject);
    procedure PaletteGreyScale1Click(Sender: TObject);
    procedure PalettePopupMenu1Popup(Sender: TObject);
    procedure SelectPK3FileButtonClick(Sender: TObject);
    procedure PK3TexListBoxClick(Sender: TObject);
    procedure MNImportTexture1Click(Sender: TObject);
    procedure DIRTexListBoxClick(Sender: TObject);
    procedure SelectDIRFileButtonClick(Sender: TObject);
    procedure Splitter1Moved(Sender: TObject);
    procedure WADFileNameEditChange(Sender: TObject);
    procedure PK3FileNameEditChange(Sender: TObject);
    procedure DIRFileNameEditChange(Sender: TObject);
    procedure TexturePageControlChange(Sender: TObject);
    procedure PickColorPalettePanelCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure ColorPaletteImageMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ColorPaletteImageMouseMove(Sender: TObject;
      Shift: TShiftState; X, Y: Integer);
    procedure ColorPaletteImageMouseUp(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TextureScaleResetLabelDblClick(Sender: TObject);
    procedure MNExpoortTexture1Click(Sender: TObject);
    procedure WADPatchListBoxClick(Sender: TObject);
    procedure WADPageControl1Change(Sender: TObject);
    procedure Quantize1Click(Sender: TObject);
    procedure Doom1Click(Sender: TObject);
    procedure Heretic1Click(Sender: TObject);
    procedure Hexen1Click(Sender: TObject);
    procedure Strife1Click(Sender: TObject);
    procedure Radix1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ZoomInButton1Click(Sender: TObject);
    procedure ZoomOutButton1Click(Sender: TObject);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure Label2DblClick(Sender: TObject);
    procedure Label3DblClick(Sender: TObject);
    procedure FilterLaplace1Click(Sender: TObject);
    procedure FilterHiPass1Click(Sender: TObject);
    procedure FilterFindEdges1Click(Sender: TObject);
    procedure FilterSharpen1Click(Sender: TObject);
    procedure FilterEdgeEnhance1Click(Sender: TObject);
    procedure FilterColorEmboss1Click(Sender: TObject);
    procedure FilterSoften1Click(Sender: TObject);
    procedure FilterSofterless1Click(Sender: TObject);
    procedure FilterBlur1Click(Sender: TObject);
    procedure FilterGrease1Click(Sender: TObject);
    procedure FilterSimpleEmboss1Click(Sender: TObject);
    procedure FilterLithograph1Click(Sender: TObject);
    procedure FilterPsychedelicDistillation1Click(Sender: TObject);
    procedure FilterBlurmore1Click(Sender: TObject);
    procedure FilterBlurmax1Click(Sender: TObject);
    procedure WADFlatRotateRadioGroupClick(Sender: TObject);
    procedure WADPatchRotateRadioGroupClick(Sender: TObject);
    procedure PK3RotateRadioGroupClick(Sender: TObject);
    procedure DIRRotateRadioGroupClick(Sender: TObject);
    procedure SizeSpeedButton1Click(Sender: TObject);
    procedure OpacitySpeedButton1Click(Sender: TObject);
    procedure ScaleSpeedButton1Click(Sender: TObject);
    procedure Grayscale1Click(Sender: TObject);
    procedure RedScale1Click(Sender: TObject);
    procedure GreenScale1Click(Sender: TObject);
    procedure BlueScale1Click(Sender: TObject);
    procedure ColorScale1Click(Sender: TObject);
    procedure NegativeImage1Click(Sender: TObject);
    procedure RemapColorChannels1Click(Sender: TObject);
    procedure GaussianBlur1Click(Sender: TObject);
  private
    { Private declarations }
    ffilename: string;
    fwadfilename: string;
    fpalettename: string;
    fpk3filename: string;
    fpk3reader: TZipFile;
    fdirdirectory: string;
    fdirlist: TStringList;
    fdrawcolor: TColor;
    lpickcolormousedown: boolean;
    drawlayer: drawlayer_p;
    colorbuffersize: integer;
    colorbuffer: colorbuffer_p;
    colorbuffersize2: integer;
    colorbuffer2: colorbuffer_p;
    changed: Boolean;
    tex: TTexture;
    undoManager: TUndoRedoManager;
    filemenuhistory: TFileMenuHistory;
    fopacity: integer;
    fpensize: integer;
    ftexturescale: integer;
    foldopacity: integer;
    foldpensize: integer;
    OpacitySlider: TSliderHook;
    TextureScaleSlider: TSliderHook;
    PenSizeSlider: TSliderHook;
    closing: boolean;
    lmousedown: boolean;
    lmousedownx, lmousedowny: integer;
    pen2mask: array[-MAXPENSIZE div 2..MAXPENSIZE div 2, -MAXPENSIZE div 2..MAXPENSIZE div 2] of integer;
    pen3mask: array[-MAXPENSIZE div 2..MAXPENSIZE div 2, -MAXPENSIZE div 2..MAXPENSIZE div 2] of integer;
    bitmapbuffer: TBitmap;
    savebitmapundo: boolean;
    ColorPickerButton1: TColorPickerButton;
    LastiX1, LastiX2, LastiY1, LastiY2: integer;
    hasdrawPaintToolShape: boolean;
    LastShape: integer;
    fZoom: integer;
    flastzoomwheel: int64;
    procedure Idle(Sender: TObject; var Done: Boolean);
    function CheckCanClose: boolean;
    procedure DoNewTexture(const twidth, theight: integer);
    procedure DoSaveTexture(const fname: string);
    function DoLoadTexture(const fname: string): boolean;
    procedure SetFileName(const fname: string);
    procedure DoLoadTextureBinaryUndo(s: TStream);
    procedure DoSaveTextureBinaryUndo(s: TStream);
    procedure SaveUndo(const dosavebitmap: boolean);
    procedure UpdateStausbar;
    procedure UpdateEnable;
    procedure OnLoadTextureFileMenuHistory(Sender: TObject; const fname: string);
    procedure SlidersToLabels;
    procedure TextureToControls;
    procedure UpdateSliders;
    procedure UpdateFromSliders(Sender: TObject);
    procedure BitmapToColorBuffer(const abitmap: TBitmap);
    procedure ColorBufferHalftoneAdjust;
    procedure PopulateFlatsListBox(const wadname: string);
    procedure NotifyFlatsListBox;
    function GetWADFlatAsBitmap(const fwad: string; const flat: string): TBitmap;
    procedure PopulateWADPatchListBox(const wadname: string);
    procedure NotifyWADPatchListBox;
    function GetWADPatchAsBitmap(const fwad: string; const patch: string): TBitmap;
    procedure PopulatePK3ListBox(const pk3name: string);
    procedure NotifyPK3ListBox;
    function GetPK3TexAsBitmap(const tname: string): TBitmap;
    procedure PopulateDirListBox;
    procedure NotifyDIRListBox;
    function DIRTexListBoxNameSize: integer;
    procedure LLeftMousePaintAt(const X, Y: integer);
    procedure LLeftMousePaintTo(const X, Y: integer);
    procedure CalcPenMasks;
    procedure DoRefreshPaintBox(const r: TRect);
    procedure CheckPaletteName;
    procedure ChangeListHint(const lst: TListBox; const def: string);
    procedure ColorPickerButton1Click(Sender: TObject);
    procedure ColorPickerButton1Change(Sender: TObject);
    procedure NotifyColor;
    procedure RecreateColorPickPalette;
    procedure PickColorPalette(const X, Y: integer);
    procedure RotateBitmapFromRadiogroupIndex(var bm: TBitmap; const rg: TRadioGroup);
    function ZoomValue(const x: integer): integer;
    procedure ColorScaleTexture(const aR, aG, aB: byte);
    procedure DoRemapColorChannels(const aR, aG, aB: integer);
  protected
    // Made protected to avoid "Private symbol never used" warning.
    function DIRTexEditNameSize: integer;
    procedure ConvertToPalette(const pname: string);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses
  se_defs,
  se_utils,
  frm_newterrain,
  se_wadreader,
  se_palettes,
  frm_loadimagehelper,
  frm_inputnumber,
  frm_remapcolorchannels,
  se_colorpalettebmz,
  se_cursors,
  se_doomdata,
  se_doomutils,
  se_quantize,
  se_filters,
  se_wad;

{$R *.dfm}

resourcestring
  rsTitle = 'WAD Painter';

// Helper function
procedure ClearList(const lst: TStringList);
var
  i: integer;
begin
  for i := 0 to lst.Count - 1 do
    lst.Objects[i].Free;
  lst.Clear;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  doCreate: boolean;
  i: integer;
begin
  Screen.Cursor := crHourglass;

  Randomize;

  CreateCustomCursors;
  PaintBox1.Cursor := crCross; //crPaint;

  colorbuffer := nil;
  colorbuffer2 := nil;
  flastzoomwheel := GetTickCount;

  DoubleBuffered := True;
  for i := 0 to ComponentCount - 1 do
    if Components[i].InheritsFrom(TWinControl) then
      if not (Components[i] is TListBox) then
        (Components[i] as TWinControl).DoubleBuffered := True;

  bitmapbuffer := TBitmap.Create;
  bitmapbuffer.PixelFormat := pf32bit;

  ColorPickerButton1 := TColorPickerButton.Create(nil);
  ColorPickerButton1.Parent := ColorPanel1;
  ColorPickerButton1.Align := alClient;
  ColorPickerButton1.OnClick := ColorPickerButton1Click;
  ColorPickerButton1.OnChange := ColorPickerButton1Change;
  fdrawcolor := RGB(255, 255, 255);
  lpickcolormousedown := False;
  NotifyColor;
  RecreateColorPickPalette;

  ter_LoadSettingFromFile(ChangeFileExt(ParamStr(0), '.ini'));

  closing := False;

  EditPageControl.ActivePageIndex := 0;
  TexturePageControl.ActivePageIndex := 0;
  WADPageControl1.ActivePageIndex := 0;

  GetMem(drawlayer, SizeOf(drawlayer_t));
  GetMem(colorbuffer, SizeOf(colorbuffer_t));
  FillChar(colorbuffer^, SizeOf(colorbuffer_t), 255);
  colorbuffersize := 128;

  GetMem(colorbuffer2, SizeOf(colorbuffer_t));
  FillChar(colorbuffer2^, SizeOf(colorbuffer_t), 255);
  colorbuffersize2 := 128;

  // Set palette
  fpalettename := bigstringtostring(@opt_defaultpalette);
  CheckPaletteName;

  // Open WAD resource
  fwadfilename := bigstringtostring(@opt_lastwadfile);
  WADFileNameEdit.Text := ExtractFileName(fwadfilename);
  PopulateFlatsListBox(fwadfilename);
  PopulateWADPatchListBox(fwadfilename);

  // Open PK3 resource
  fpk3filename := bigstringtostring(@opt_lastpk3file);
  fpk3reader := TZipFile.Create(fpk3filename);
  PK3FileNameEdit.Text := ExtractFileName(fpk3filename);
  PopulatePK3ListBox(fpk3filename);

  // Open Directory resource
  fdirdirectory := bigstringtostring(@opt_lastdirectory);
  fdirlist := TStringList.Create;
//  DIRFileNameEdit.Text := MkShortName(fdirdirectory, DIRTexEditNameSize);
  DIRFileNameEdit.Text := fdirdirectory;
  PopulateDirListBox;

  LinearScaleCheckBox1.Checked := opt_linearscaling;

  lmousedown := False;
  lmousedownx := 0;
  lmousedowny := 0;

  fopacity := 100;
  fpensize := 64;
  ftexturescale := 100;
  foldopacity := -1;
  foldpensize := -1;
  savebitmapundo := true;

  CalcPenMasks;

  fZoom := 1;

  undoManager := TUndoRedoManager.Create;
  undoManager.UndoLimit := 100;
  undoManager.OnLoadFromStream := DoLoadTextureBinaryUndo;
  undoManager.OnSaveToStream := DoSaveTextureBinaryUndo;

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
  filemenuhistory.OnOpen := OnLoadTextureFileMenuHistory;

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

  tex := TTexture.Create;

  Scaled := False;

  TabSheet1.DoubleBuffered := True;

  OpacitySlider := TSliderHook.Create(OpacityPaintBox);
  OpacitySlider.Min := 1;
  OpacitySlider.Max := 100;

  PenSizeSlider := TSliderHook.Create(PenSizePaintBox);
  PenSizeSlider.Min := 1;
  PenSizeSlider.Max := MAXPENSIZE;

  TextureScaleSlider := TSliderHook.Create(TextureScalePaintBox);
  TextureScaleSlider.Min := MINTEXTURESCALE;
  TextureScaleSlider.Max := MAXTEXTURESCALE;

  doCreate := True;
  if ParamCount > 0 then
    if DoLoadTexture(ParamStr(1)) then
      doCreate := False;

  LastiX1 := 0;
  LastiX2 := 0;
  LastiY1 := 0;
  LastiY2 := 0;
  LastShape := 0;
  hasdrawPaintToolShape := false;

  WADFlatRotateRadioGroup.ItemIndex := 0;
  WADPatchRotateRadioGroup.ItemIndex := 0;
  PK3RotateRadioGroup.ItemIndex := 0;
  DIRRotateRadioGroup.ItemIndex := 0;

  Timer1.Enabled := True;

  if DoCreate then
  begin
    SetFileName('');
    DoNewTexture(DEF_TEXTURE_WIDTH, DEF_TEXTURE_HEIGHT);
    undoManager.Clear;
  end;

  NotifyWADPatchListBox;
  NotifyFlatsListBox; // This must be placed here to use the flats for drawing at startup.

  // when the app has spare time, render the GL scene
  Application.OnIdle := Idle;

  Screen.Cursor := crDefault;
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
    if ret = IDCANCEL then
    begin
      Result := False;
      exit;
    end;
    if ret = IDNO then
    begin
      Result := True;
      exit;
    end;
    if ret = IDYES then
    begin
      SaveButton1Click(self);
      Result := not changed;
      exit;
    end;
  end;
  Result := True;
end;

procedure TForm1.NewButton1Click(Sender: TObject);
var
  twidth, theight: integer;
begin
  if not CheckCanClose then
    Exit;

  twidth := tex.texturewidth;
  theight := tex.textureheight;
  if GetNewTextureSize(twidth, theight) then
    DoNewTexture(twidth, theight);
end;

procedure TForm1.DoNewTexture(const twidth, theight: integer);
begin
  SetFileName('');
  changed := False;
  tex.Clear(twidth, theight);
  fZoom := 1;
  PaintBox1.Width := twidth;
  PaintBox1.Height := theight;
  bitmapbuffer.Width := twidth;
  bitmapbuffer.Height := theight;
  TextureToControls;
  undoManager.Clear;
  LastiX1 := 0;
  LastiX2 := 0;
  LastiY1 := 0;
  LastiY2 := 0;
  LastShape := 0;
end;

procedure TForm1.SetFileName(const fname: string);
begin
  ffilename := fname;
  Caption := rsTitle;
  if ffilename <> '' then
    Caption := Caption + ' - ' + MkShortName(ffilename);
end;

procedure TForm1.SaveButton1Click(Sender: TObject);
begin
  if ffilename = '' then
  begin
    if SaveDialog1.Execute then
    begin
      ffilename := SaveDialog1.FileName;
      filemenuhistory.AddPath(ffilename);
    end
    else
    begin
      Beep;
      Exit;
    end;
  end;
  BackupFile(ffilename);
  DoSaveTexture(ffilename);
end;

procedure TForm1.DoSaveTexture(const fname: string);
begin
  SetFileName(fname);

  Screen.Cursor := crHourglass;
  try
    tex.SaveToFile(fname);
  finally
    Screen.Cursor := crDefault;
  end;

  changed := False;
end;

function TForm1.DoLoadTexture(const fname: string): boolean;
var
  s: string;
begin
  if not FileExists(fname) then
  begin
    s := Format('File %s does not exist!', [MkShortName(fname)]);
    MessageBox(Handle, PChar(s), PChar(rsTitle), MB_OK or MB_ICONEXCLAMATION or MB_APPLMODAL);
    Result := False;
    exit;
  end;

  undoManager.Clear;

  Screen.Cursor := crHourglass;
  try
    tex.LoadFromFile(fname);
  finally
    Screen.Cursor := crDefault;
  end;

  fZoom := 1;
  PaintBox1.Width := tex.texturewidth;
  PaintBox1.Height := tex.textureheight;
  bitmapbuffer.Width := tex.texturewidth;
  bitmapbuffer.Height := tex.textureheight;

  TextureToControls;
  filemenuhistory.AddPath(fname);
  SetFileName(fname);
  changed := False;
  Result := True;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  closing := True;
  Timer1.Enabled := False;
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
  stringtobigstring(fwadfilename, @opt_lastwadfile);
  stringtobigstring(fpalettename, @opt_defaultpalette);
  stringtobigstring(fpk3filename, @opt_lastpk3file);
  stringtobigstring(fdirdirectory, @opt_lastdirectory);
  opt_linearscaling := LinearScaleCheckBox1.Checked;

  ter_SaveSettingsToFile(ChangeFileExt(ParamStr(0), '.ini'));

  filemenuhistory.Free;

  OpacitySlider.Free;
  TextureScaleSlider.Free;
  PenSizeSlider.Free;

  tex.Free;
  Freemem(drawlayer, SizeOf(drawlayer_t));
  Freemem(colorbuffer, SizeOf(colorbuffer_t));
  Freemem(colorbuffer2, SizeOf(colorbuffer_t));

  bitmapbuffer.Free;

  fpk3reader.Free;

  ClearList(fdirlist);
  fdirlist.Free;

  ColorPickerButton1.Free;

  PaintBox1.Cursor := crDefault;

  DeleteCustomCursors;
end;

resourcestring
  copyright = 'Copyright (c) 2020-2021, Jim Valavanis';

procedure TForm1.AboutButton1Click(Sender: TObject);
begin
  MessageBox(
    Handle,
    PChar(Format('%s'#13#10 +
    'Version ' + I_VersionBuilt + #13#10 +
    'Copyright (c) 2021, jvalavanis@gmail.com'#13#10 +
    #13#10'A tool to create WAD Textures.'#13#10#13#10,
        [rsTitle])),
    PChar(rsTitle),
    MB_OK or MB_ICONINFORMATION or MB_APPLMODAL);
end;

procedure TForm1.SaveAsButton1Click(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    filemenuhistory.AddPath(SaveDialog1.FileName);
    BackupFile(SaveDialog1.FileName);
    DoSaveTexture(SaveDialog1.FileName);
  end;
end;

procedure TForm1.ExitButton1Click(Sender: TObject);
begin
  Close;
end;

procedure TForm1.OpenButton1Click(Sender: TObject);
begin
  if not CheckCanClose then
    Exit;

  if OpenDialog1.Execute then
    DoLoadTexture(OpenDialog1.FileName);
end;

procedure TForm1.Idle(Sender: TObject; var Done: Boolean);
begin
  if closing then
    Exit;
    
  UpdateEnable;

  Done := False;

  Sleep(1);
  UpdateStausbar;
end;

procedure TForm1.ApplicationEvents1Idle(Sender: TObject;
  var Done: Boolean);
begin
  Idle(Sender, Done);
end;

procedure TForm1.Edit1Click(Sender: TObject);
begin
  Undo1.Enabled := undoManager.CanUndo;
  Redo1.Enabled := undoManager.CanRedo;
  PasteTexture1.Enabled := Clipboard.HasFormat(CF_BITMAP);
end;

procedure TForm1.Undo1Click(Sender: TObject);
begin
  if undoManager.CanUndo then
  begin
    Screen.Cursor := crHourglass;
    try
      undoManager.Undo;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.Redo1Click(Sender: TObject);
begin
  if undoManager.CanRedo then
  begin
    Screen.Cursor := crHourglass;
    try
      undoManager.Redo;
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.DoSaveTextureBinaryUndo(s: TStream);
begin
  tex.SaveToStream(s, true, savebitmapundo);
end;

procedure TForm1.DoLoadTextureBinaryUndo(s: TStream);
begin
  tex.LoadFromStream(s);
  TextureToControls;
end;

procedure TForm1.SaveUndo(const dosavebitmap: boolean);
begin
  savebitmapundo := dosavebitmap;
  undoManager.SaveUndo;
  savebitmapundo := true;
end;

procedure TForm1.UpdateStausbar;
begin
  StatusBar1.Panels[1].Text := Format('Zoom = %d%s', [fZoom * 100, '%']);
end;

procedure TForm1.UpdateEnable;
begin
  Undo1.Enabled := undoManager.CanUndo;
  Redo1.Enabled := undoManager.CanRedo;
  UndoButton1.Enabled := undoManager.CanUndo;
  RedoButton1.Enabled := undoManager.CanRedo;
  ZoomInButton1.Enabled := fZoom < MAXZOOM;
  ZoomOutButton1.Enabled := fZoom > MINZOOM;
end;

procedure TForm1.OnLoadTextureFileMenuHistory(Sender: TObject; const fname: string);
begin
  if not CheckCanClose then
    Exit;

  DoLoadTexture(fname);
end;

procedure TForm1.File1Click(Sender: TObject);
begin
  filemenuhistory.RefreshMenuItems;
end;

procedure TForm1.CopyTexture1Click(Sender: TObject);
begin
  Clipboard.Assign(tex.Texture);
end;

procedure TForm1.UpdateSliders;
begin
  OpacitySlider.OnSliderHookChange := nil;
  OpacitySlider.Position := fopacity;
  OpacityPaintBox.Invalidate;
  OpacitySlider.OnSliderHookChange := UpdateFromSliders;

  PenSizeSlider.OnSliderHookChange := nil;
  PenSizeSlider.Position := fpensize;
  PenSizePaintBox.Invalidate;
  PenSizeSlider.OnSliderHookChange := UpdateFromSliders;

  TextureScaleSlider.OnSliderHookChange := nil;
  TextureScaleSlider.Position := ftexturescale;
  TextureScalePaintBox.Invalidate;
  TextureScaleSlider.OnSliderHookChange := UpdateFromSliders;
end;

procedure TForm1.SlidersToLabels;
begin
  OpacityLabel.Caption := Format('%d%s', [Round(OpacitySlider.Position), '%']);
  PenSizeLabel.Caption := Format('%d', [Round(PenSizeSlider.Position)]);
  TextureScaleLabel.Caption := Format('%d%s', [Round(TextureScaleSlider.Position) div 2 * 2, '%']);
end;

procedure TForm1.TextureToControls;
begin
  if closing then
    Exit;

  PaintBox1.Invalidate;
  StatusBar1.Panels[0].Text := Format('Texture Size: %dx%d', [tex.texturewidth, tex.textureheight]);
  UpdateSliders;
  SlidersToLabels;
end;

procedure TForm1.UpdateFromSliders(Sender: TObject);
var
  oldscale: integer;
begin
  if closing then
    Exit;

  SlidersToLabels;
  fopacity := Round(OpacitySlider.Position);
  fpensize := Round(PenSizeSlider.Position);
  oldscale := ftexturescale;
  ftexturescale := Round(TextureScaleSlider.Position) div 2 * 2;
  if oldscale <> ftexturescale then
    ColorBufferHalftoneAdjust;

  CalcPenMasks;
end;

procedure TForm1.PaintBox1Paint(Sender: TObject);
begin
  DoRefreshPaintBox(Rect(0, 0, tex.texturewidth - 1, tex.textureheight - 1));
end;

function intersectRect(const r1, r2: TRect): boolean;
begin
  Result :=  not ((r2.left > r1.right) or
                  (r2.right < r1.left) or
                  (r2.top > r1.bottom) or
                  (r2.bottom < r1.top));
end;

function intersectRange(const a1, a2, b1, b2: integer): boolean;
begin
  Result := (a1 <= b2) and (a2 >= b1);
end;

procedure TForm1.DoRefreshPaintBox(const r: TRect);
var
  C: TCanvas;
  oldc: LongWord;
begin
  if fZoom = 1 then
  begin
    C := bitmapbuffer.Canvas;
    C.CopyRect(r, tex.Texture.Canvas, r);
    PaintBox1.Canvas.CopyRect(r, C, r);
  end
  else
//    PaintBox1.Canvas.StretchDraw(Rect(0, 0, PaintBox1.Width - 1, PaintBox1.Height - 1), tex.Texture);
    PaintBox1.Canvas.StretchDraw(Rect(0, 0, PaintBox1.Width, PaintBox1.Height), tex.Texture);

  if (LastiX1 <> 0) or (LastiX2 <> 0) or (LastiY1 <> 0) or (LastiY2 <> 0) then
  begin
    PaintBox1.Canvas.Brush.Style := bsClear;
    PaintBox1.Canvas.Pen.Style := psDot;
    oldc := PaintBox1.Canvas.Pen.Color;
    PaintBox1.Canvas.Pen.Color := RGB(255, 255, 255);
    if LastShape = 1 then
      PaintBox1.Canvas.Rectangle(fZoom * LastiX1, fZoom * LastiY1, fZoom * (1 + LastiX2), fZoom * (1 + LastiY2))
    else if (LastShape = 2) or (LastShape = 3) then
      PaintBox1.Canvas.Ellipse(fZoom * LastiX1, fZoom * LastiY1, fZoom * (1 + LastiX2), fZoom * (1 + LastiY2));
    PaintBox1.Canvas.Brush.Style := bsSolid;
    PaintBox1.Canvas.Pen.Style := psSolid;
    PaintBox1.Canvas.Pen.Color := oldc;
    hasdrawPaintToolShape := True;
  end
  else
    hasdrawPaintToolShape := False;
end;

procedure TForm1.SelectWADFileButtonClick(Sender: TObject);
begin
  if OpenWADDialog.Execute then
  begin
    Screen.Cursor := crHourglass;
    try
      fwadfilename := ExpandFilename(OpenWADDialog.FileName);
      WADFileNameEdit.Text := ExtractFileName(OpenWADDialog.FileName);
      PopulateFlatsListBox(fwadfilename);
      PopulateWADPatchListBox(fwadfilename);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.BitmapToColorBuffer(const abitmap: TBitmap);
var
  i, j: integer;
  A, B: PLongWordArray;
  oldw, oldh: integer;

  function RGBSwap(buffer: LongWord): LongWord;
  var
    r, g, b: LongWord;
  begin
    Result := buffer;
    b := Result and $FF;
    Result := Result shr 8;
    g := Result and $FF;
    Result := Result shr 8;
    r := Result and $FF;
    Result := r + g shl 8 + b shl 16;
  end;

begin
  abitmap.PixelFormat := pf32bit;
  if abitmap.Width <> abitmap.Height then // Make rectangular
  begin
    if abitmap.Width > abitmap.Height then
    begin
      oldh := abitmap.Height;
      abitmap.Height := abitmap.Width;
      for j := oldh to abitmap.Height - 1 do
      begin
        A := abitmap.ScanLine[j];
        B := abitmap.ScanLine[j - oldh];
        for i := 0 to abitmap.Width - 1 do
          A[i] := B[i];
      end;
    end
    else
    begin
      oldw := abitmap.Width;
      abitmap.Width := abitmap.Height;
      for j := 0 to abitmap.Height - 1 do
      begin
        A := abitmap.ScanLine[j];
        for i := oldw to abitmap.Width - 1 do
          A[i] := A[i - oldw];
      end;
    end;
  end;

  // Copy to colorbuffer
  for j := 0 to MinI(abitmap.Height - 1, MAXTEXTURESIZE - 1) do
  begin
    A := abitmap.ScanLine[j];
    for i := 0 to MinI(abitmap.Width - 1, MAXTEXTURESIZE - 1) do
      colorbuffer[i, j] := RGBSwap(A[i]);
  end;
end;

procedure TForm1.ColorBufferHalftoneAdjust;
var
  i, j: integer;
  A: PLongWordArray;
  bm1, bm2: TBitmap;
begin
  bm1 := TBitmap.Create;
  bm1.PixelFormat := pf32bit;
  bm1.Width := colorbuffersize;
  bm1.Height := colorbuffersize;
  for j := 0 to MinI(bm1.Height - 1, MAXTEXTURESIZE - 1) do
  begin
    A := bm1.ScanLine[j];
    for i := 0 to MinI(bm1.Width - 1, MAXTEXTURESIZE - 1) do
      A[i] := RGBSwap(colorbuffer[i, j]);
  end;

  bm2 := TBitmap.Create;
  bm2.PixelFormat := pf32bit;
  bm2.Width := bm1.Width * ftexturescale div 100;
  bm2.Height := bm2.Width;
  BitmapLanczosDraw(bm1, bm2);
//  BitmapHalftoneDraw(bm1, bm2.Canvas, Rect(0, 0, bm2.Width, bm2.Height));
  bm1.Free;

  // Copy to colorbuffer2
  for j := 0 to MinI(bm2.Height - 1, MAXTEXTURESIZE - 1) do
  begin
    A := bm2.ScanLine[j];
    for i := 0 to MinI(bm2.Width - 1, MAXTEXTURESIZE - 1) do
      colorbuffer2[i, j] := RGBSwap(A[i]);
  end;
  colorbuffersize2 := bm2.Width;

  bm2.Free;
end;

procedure TForm1.PopulateFlatsListBox(const wadname: string);
var
  wad: TWADReader;
  i: integer;
  inflats: boolean;
  uEntry: string;
begin
  wad := TWADReader.Create;
  wad.OpenWadFile(wadname);
  inflats := False;
  WADFlatsListBox.Items.Clear;
  for i := 0 to wad.NumEntries - 1 do
  begin
    uEntry := UpperCase(wad.EntryName(i));
    if (uEntry = 'F_START') or (uEntry = 'FF_START') then
      inflats := True
    else if (uEntry = 'F_END') or (uEntry = 'FF_END') then
      inflats := False
    else if inflats then
      WADFlatsListBox.Items.Add(uEntry);
  end;
  wad.Free;
  if WADFlatsListBox.Count > 0 then
    WADFlatsListBox.ItemIndex := 0
  else
    WADFlatsListBox.ItemIndex := -1;
  NotifyFlatsListBox;
end;

procedure TForm1.NotifyFlatsListBox;
var
  idx: integer;
  bm: TBitmap;
begin
  ChangeListHint(WADFlatsListBox, 'WAD Flats');
  idx := WADFlatsListBox.ItemIndex;
  if (idx < 0) or (fwadfilename = '') or not FileExists(fwadfilename) then
  begin
    WADFlatPreviewImage.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    WADFlatPreviewImage.Picture.Bitmap.Canvas.Brush.Color := RGB(255, 255, 255);
    WADFlatPreviewImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, 128, 128));
    WAADFlatNameLabel.Caption := '(None)';
    FlatSizeLabel.Caption := Format('(%dx%d)', [128, 128]);
    colorbuffersize := 128;
    FillChar(colorbuffer^, SizeOf(colorbuffer_t), 255);
    ColorBufferHalftoneAdjust;
    exit;
  end;

  bm := GetWADFlatAsBitmap(fwadfilename, WADFlatsListBox.Items[idx]);

  RotateBitmapFromRadiogroupIndex(bm, WADFlatRotateRadioGroup);
  BitmapToColorBuffer(bm);

  colorbuffersize := MinI(bm.Height, MAXTEXTURESIZE);
  ColorBufferHalftoneAdjust;
  WADFlatPreviewImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, 128, 128), bm);
  WAADFlatNameLabel.Caption := WADFlatsListBox.Items[idx];
  FlatSizeLabel.Caption := Format('(%dx%d)', [bm.Width, bm.Height]);
  bm.Free;
end;

function TForm1.GetWADFlatAsBitmap(const fwad: string; const flat: string): TBitmap;
var
  wad: TWADReader;
  i, idx, palidx: integer;
  inflats: boolean;
  wpal: PByteArray;
  palsize: integer;
  lumpsize: integer;
  flatsize: integer;
  buf: PByteArray;
  x, y: integer;
  b: byte;
  uEntry: string;
  buildinrawpal: rawpalette_p;
  line: PLongWordarray;
begin
  idx := -1;
  palidx := -1;
  wad := TWADReader.Create;
  if (fwad <> '') and FileExists(fwad) then
  begin
    wad.OpenWadFile(fwad);
    inflats := False;
    for i := 0 to wad.NumEntries - 1 do
    begin
      uEntry := UpperCase(wad.EntryName(i));
      if (uEntry = 'PLAYPAL') or (uEntry = 'PALETTE') then
        palidx := i
      else if (uEntry = 'F_START') or (uEntry = 'FF_START') then
        inflats := True
      else if (uEntry = 'F_END') or (uEntry = 'FF_END') then
        inflats := False
      else if inflats then
      begin
        if UpperCase(wad.EntryName(i)) = UpperCase(flat) then
          idx := i;
      end;
    end;
  end;

  if idx >= 0 then
    lumpsize := wad.EntryInfo(idx).size
  else
    lumpsize := 0;

  if lumpsize < 32 * 32 then
  begin
    Result := TBitmap.Create;
    Result.Width := 64;
    Result.Height := 64;
    Result.Canvas.Brush.Style := bsSolid;
    Result.Canvas.Brush.Color := RGB(255, 255, 255);
    Result.Canvas.FillRect(Rect(0, 0, 64, 64));
    wad.Free;
    Exit;
  end;

  if fpalettename = spalDEFAULT then
  begin
    palsize := 0;
    if (palidx >= 0) and (wad.EntryInfo(palidx).size >= 768) then
      wad.ReadEntry(palidx, pointer(wpal), palsize);
  end
  else
  begin
    buildinrawpal := GetPaletteFromName(fpalettename);
    if buildinrawpal <> nil then
    begin
      palsize := 768;
      GetMem(wpal, palsize);
      for i := 0 to 767 do
        wpal[i] := buildinrawpal[i];
    end
    else
      palsize := 0;
  end;

  if palsize = 0 then
  begin
    palsize := 768;
    GetMem(wpal, palsize);
    for i := 0 to 255 do
    begin
      wpal[3 * i] := i;
      wpal[3 * i + 1] := i;
      wpal[3 * i + 2] := i;
    end;
  end;

  lumpsize := 0;
  wad.ReadEntry(idx, pointer(buf), lumpsize);

  if lumpsize = 0 then
  begin
    lumpsize := 32 * 32;
    GetMem(buf, lumpsize);
    FillChar(buf^, lumpsize, 255);
  end;

  if lumpsize >= 2048 * 2048 then
    flatsize := 2048
  else if lumpsize >= 1024 * 1024 then
    flatsize := 1024
  else if lumpsize >= 512 * 512 then
    flatsize := 512
  else if lumpsize >= 256 * 256 then
    flatsize := 256
  else if lumpsize >= 128 * 128 then
    flatsize := 128
  else if lumpsize >= 64 * 64 then
    flatsize := 64
  else
    flatsize := 32;

  Result := TBitmap.Create;
  Result.Width := flatsize;
  Result.Height := flatsize;
  Result.PixelFormat := pf32bit;

  for y := 0 to flatsize - 1 do
  begin
    line := Result.ScanLine[y];
    for x := 0 to flatsize - 1 do
    begin
      b := buf[(y * flatsize + x) mod lumpsize];
      line[x] := RGB(wpal[b * 3 + 2], wpal[b * 3 + 1], wpal[b * 3]);
    end;
  end;

  FreeMem(buf, flatsize * flatsize);
  FreeMem(wpal, palsize);
  wad.Free;
end;

procedure TForm1.WADFlatsListBoxClick(Sender: TObject);
begin
  NotifyFlatsListBox;
end;

procedure TForm1.PopulateWADPatchListBox(const wadname: string);
var
  wad: TWADReader;
  i: integer;
  inpatch: boolean;
  uEntry: string;
  pnames: Ppnames_t;
  pnameslump: integer;
  pnameslumpsize: integer;
  lump: integer;
begin
  wad := TWADReader.Create;
  wad.OpenWadFile(wadname);
  inpatch := False;
  WADPatchListBox.Items.Clear;
  pnameslump := -1;
  for i := 0 to wad.NumEntries - 1 do
  begin
    uEntry := UpperCase(wad.EntryName(i));
    if uEntry = 'PNAMES' then
      pnameslump := i
    else if (uEntry = 'P_START') or (uEntry = 'PP_START') or (uEntry= 'TX_START') or (uEntry = 'HI_START') then
      inpatch := True
    else if (uEntry = 'P_END') or (uEntry = 'PP_END') or (uEntry= 'TX_END') or (uEntry = 'HI_END') then
      inpatch := False
    else if inpatch then
      WADPatchListBox.Items.Add(uEntry);
  end;
  if pnameslump >= 0 then // get patches from PNAMES
  begin
    wad.ReadEntry(pnameslump, pointer(pnames), pnameslumpsize);
    for i := 0 to pnames.numentries - 1 do
    begin
      uEntry := UpperCase(char8tostring(pnames.names[i]));
      if WADPatchListBox.Items.IndexOf(uEntry) < 0 then
      begin
        lump := wad.EntryId(uEntry);
        if lump >= 0 then
          WADPatchListBox.Items.Add(uEntry);
      end;
    end;
    FreeMem(pnames, pnameslumpsize);
  end;
  wad.Free;
  if WADPatchListBox.Count > 0 then
    WADPatchListBox.ItemIndex := 0
  else
    WADPatchListBox.ItemIndex := -1;
  NotifyWADPatchListBox;
end;

procedure TForm1.NotifyWADPatchListBox;
var
  idx: integer;
  bm: TBitmap;
begin
  ChangeListHint(WADPatchListBox, 'WAD Patches');
  idx := WADPatchListBox.ItemIndex;
  if (idx < 0) or (fwadfilename = '') or not FileExists(fwadfilename) then
  begin
    WADPatchPreviewImage.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    WADPatchPreviewImage.Picture.Bitmap.Canvas.Brush.Color := RGB(255, 255, 255);
    WADPatchPreviewImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, 128, 128));
    WADPatchNameLabel.Caption := '(None)';
    WADPatchSizeLabel.Caption := Format('(%dx%d)', [128, 128]);
    colorbuffersize := 128;
    FillChar(colorbuffer^, SizeOf(colorbuffer_t), 255);
    ColorBufferHalftoneAdjust;
    Exit;
  end;

  bm := GetWADPatchAsBitmap(fwadfilename, WADPatchListBox.Items[idx]);

  RotateBitmapFromRadiogroupIndex(bm, WADPatchRotateRadioGroup);
  BitmapToColorBuffer(bm);

  colorbuffersize := MinI(bm.Height, MAXTEXTURESIZE);
  ColorBufferHalftoneAdjust;
  WADPatchPreviewImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, 128, 128), bm);
  WADPatchNameLabel.Caption := WADPatchListBox.Items[idx];
  WADPatchSizeLabel.Caption := Format('(%dx%d)', [bm.Width, bm.Height]);
  bm.Free;
end;

function TForm1.GetWADPatchAsBitmap(const fwad: string; const patch: string): TBitmap;
var
  wad: TWADReader;
  i, idx, palidx: integer;
  inpatch: boolean;
  wpal: PByteArray;
  lpal: PLongWordArray;
  palsize: integer;
  lumpsize: integer;
  flatsize: integer;
  buf: PByteArray;
  x, y: integer;
  b: byte;
  uEntry: string;
  buildinrawpal: rawpalette_p;
  jpg: TJpegImage;
  png: TPNGObject;
  m: TMemoryStream;
  line: PLongWordArray;
begin
  idx := -1;
  palidx := -1;
  wad := TWADReader.Create;
  if (fwad <> '') and FileExists(fwad) then
  begin
    wad.OpenWadFile(fwad);
    inpatch := False;
    for i := 0 to wad.NumEntries - 1 do
    begin
      uEntry := UpperCase(wad.EntryName(i));
      if (uEntry = 'PLAYPAL') or (uEntry = 'PALETTE') then
        palidx := i
      else if (uEntry = 'P_START') or (uEntry = 'PP_START') or (uEntry= 'TX_START') or (uEntry = 'HI_START') then
        inpatch := True
      else if (uEntry = 'P_END') or (uEntry = 'PP_END') or (uEntry= 'TX_END') or (uEntry = 'HI_END') then
        inpatch := False
      else if inpatch then
      begin
        if UpperCase(wad.EntryName(i)) = UpperCase(patch) then
          idx := i;
      end;
    end;
  end;

  if idx < 0 then
    idx := wad.EntryId(UpperCase(patch)); // Patch outsize namespace ??

  if idx >= 0 then
    lumpsize := wad.EntryInfo(idx).size
  else
    lumpsize := 0;

  if lumpsize < 10 then
  begin
    Result := TBitmap.Create;
    Result.Width := 64;
    Result.Height := 64;
    Result.Canvas.Brush.Style := bsSolid;
    Result.Canvas.Brush.Color := RGB(255, 255, 255);
    Result.Canvas.FillRect(Rect(0, 0, 64, 64));
    wad.Free;
    Exit;
  end;

  if fpalettename = spalDEFAULT then
  begin
    palsize := 0;
    if (palidx >= 0) and (wad.EntryInfo(palidx).size >= 768) then
      wad.ReadEntry(palidx, pointer(wpal), palsize);
  end
  else
  begin
    buildinrawpal := GetPaletteFromName(fpalettename);
    if buildinrawpal <> nil then
    begin
      palsize := 768;
      GetMem(wpal, palsize);
      for i := 0 to 767 do
        wpal[i] := buildinrawpal[i];
    end
    else
      palsize := 0;
  end;

  if palsize = 0 then
  begin
    palsize := 768;
    GetMem(wpal, palsize);
    for i := 0 to 255 do
    begin
      wpal[3 * i] := i;
      wpal[3 * i + 1] := i;
      wpal[3 * i + 2] := i;
    end;
  end;

  lumpsize := 0;
  buf := nil;
  wad.ReadEntry(idx, pointer(buf), lumpsize);

  if lumpsize < 10 then
  begin
    lumpsize := 32 * 32;
    ReallocMem(buf, lumpsize);
    FillChar(buf^, lumpsize, 255);
  end;

  if (buf[1] = $50) and (buf[2] = $4E) and (buf[3] = $47) then // PNG
  begin
    m := TMemoryStream.Create;
    try
      m.Write(buf^, lumpsize);
      m.Position := 0;
      png := TPNGObject.Create;
      png.LoadFromStream(m);
      Result := TBitmap.Create;
      Result.Assign(png);
      png.Free;
    finally
      m.Free;
    end;
  end
  else if (buf[6] = $4A) and (buf[7] = $46) and (buf[8] = $49) and (buf[9] = $46) then // JPEG
  begin
    m := TMemoryStream.Create;
    try
      m.Write(buf^, lumpsize);
      m.Position := 0;
      jpg := TJpegImage.Create;
      jpg.LoadFromStream(m);
      Result := TBitmap.Create;
      Result.Assign(jpg);
      jpg.Free;
    finally
      m.Free;
    end;
  end
  else if IsValidWADPatchImage(buf, lumpsize) then // PATCH
  begin
    GetMem(lpal, 256 * SizeOf(LongWord));
    for b := 0 to 255 do
      lpal[b] := RGB(wpal[b * 3 + 2], wpal[b * 3 + 1], wpal[b * 3]);
    Ppatch_t(buf).leftoffset := 0;  // Clear left offset
    Ppatch_t(buf).topoffset := 0;   // Clear top offset
    Result := DoomPatchToBitmap(buf, lumpsize, lpal);
    FreeMem(lpal, 256 * SizeOf(LongWord));
  end
  else // Flat ?
  begin
    flatsize := 0;
    if lumpsize = 2048 * 2048 then
      flatsize := 2048
    else if lumpsize = 1024 * 1024 then
      flatsize := 1024
    else if lumpsize = 512 * 512 then
      flatsize := 512
    else if lumpsize = 256 * 256 then
      flatsize := 256
    else if lumpsize = 128 * 128 then
      flatsize := 128
    else if lumpsize = 64 * 64 then
      flatsize := 64;
    if flatsize > 0 then
    begin
      Result := TBitmap.Create;
      Result.Width := flatsize;
      Result.Height := flatsize;
      Result.PixelFormat := pf32bit;

      for y := 0 to flatsize - 1 do
      begin
        line := Result.ScanLine[y];
        for x := 0 to flatsize - 1 do
        begin
          b := buf[(y * flatsize + x) mod lumpsize];
          line[x] := RGB(wpal[b * 3 + 2], wpal[b * 3 + 1], wpal[b * 3]);
        end;
      end;

    end
    else
    begin
      Result := TBitmap.Create;
      Result.Width := 64;
      Result.Height := 64;
      Result.Canvas.Brush.Style := bsSolid;
      Result.Canvas.Brush.Color := RGB(255, 255, 255);
      Result.Canvas.FillRect(Rect(0, 0, 64, 64));
    end;
  end;

  FreeMem(buf, lumpsize);
  FreeMem(wpal, palsize);
  wad.Free;
end;

procedure TForm1.PaintBox1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    CalcPenMasks;
    SaveUndo(PenSpeedButton1.Down or PenSpeedButton2.Down or PenSpeedButton3.Down);
    lmousedown := True;
    lmousedownx := ZoomValue(X);
    lmousedowny := ZoomValue(Y);

    ZeroMemory(drawlayer, SizeOf(drawlayer_t));

    LLeftMousePaintTo(ZoomValue(X), ZoomValue(Y));
  end;
end;

procedure TForm1.PaintBox1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    LLeftMousePaintTo(ZoomValue(X), ZoomValue(Y));
    lmousedownx := ZoomValue(X);
    lmousedowny := ZoomValue(Y);
    lmousedown := False;
  end;
end;

procedure TForm1.PaintBox1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if lmousedown then
  begin
    LastiX1 := 0;
    LastiX2 := 0;
    LastiY1 := 0;
    LastiY2 := 0;
    LLeftMousePaintTo(ZoomValue(X), ZoomValue(Y));
    lmousedownx := ZoomValue(X);
    lmousedowny := ZoomValue(Y);
  end
  else
  begin
    LastiX1 := ZoomValue(X) - fpensize div 2;
    LastiX2 := ZoomValue(X) + fpensize div 2;
    LastiY1 := ZoomValue(Y) - fpensize div 2;
    LastiY2 := ZoomValue(Y) + fpensize div 2;
    if PenSpeedButton1.Down then
      LastShape := 1
    else if PenSpeedButton2.Down then
      LastShape := 2
    else if PenSpeedButton3.Down then
      LastShape := 3;
    PaintBox1.Invalidate;
  end;
end;

function coloraverage(const c1, c2: LongWord; const opact: integer): LongWord;
var
  r1, g1, b1: byte;
  r2, g2, b2: byte;
  opact2: integer;
begin
  if (c1 = c2) or (opact >= 100) then
  begin
    Result := c2;
    Exit;
  end;
  if opact <= 0 then
  begin
    Result := c1;
    Exit;
  end;
  r1 := c1;
  g1 := c1 shr 8;
  b1 := c1 shr 16;
  r2 := c2;
  g2 := c2 shr 8;
  b2 := c2 shr 16;
  opact2 := 100 - opact;
  r1 := (r1 * opact2 + r2 * opact) div 100;
  g1 := (g1 * opact2 + g2 * opact) div 100;
  b1 := (b1 * opact2 + b2 * opact) div 100;
  Result := r1 or (g1 shl 8) or (b1 shl 16);
end;

procedure TForm1.LLeftMousePaintAt(const X, Y: integer);
var
  iX, iY: integer;
  iX1, iX2, iY1, iY2: integer;
  c, c1, c2: LongWord;
  twidth, theight: integer;
  tline: PLongWordarray;
  newopacity: integer;
  hchanged: boolean;
  ypos: integer;
begin
  twidth := tex.texturewidth;
  iX1 := GetIntInRange(X - fpensize div 2, 0, twidth - 1);
  iX2 := GetIntInRange(X + fpensize div 2, 0, twidth - 1);
  theight := tex.textureheight;
  iY1 := GetIntInRange(Y - fpensize div 2, 0, theight - 1);
  iY2 := GetIntInRange(Y + fpensize div 2, 0, theight - 1);

  ftexturescale := GetIntInRange(ftexturescale, MINTEXTURESCALE, MAXTEXTURESCALE);

  if LinearScaleCheckBox1.Checked then
  begin
    if PenSpeedButton1.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := iY mod colorbuffersize2;
        for iX := iX1 to iX2 do
          if drawlayer[iX, iY].pass < fopacity then
          begin
            drawlayer[iX, iY].pass := fopacity;
            c1 := colorbuffer2[iX mod colorbuffersize2, ypos];
            c2 := RGBSwap(tline[iX]);
            c := coloraverage(c2, c1, fopacity);
            tline[iX] := RGBSwap(c);
          end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end
    else if PenSpeedButton2.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := iY mod colorbuffersize2;
        for iX := iX1 to iX2 do
        begin
          newopacity := pen2mask[iX - X, iY - Y];
          if drawlayer[iX, iY].pass < newopacity then
          begin
            if drawlayer[iX, iY].pass = 0 then
              c2 := RGBSwap(tline[iX])
            else
              c2 := drawlayer[iX, iY].color;
            drawlayer[iX, iY].color := c2;
            drawlayer[iX, iY].pass := newopacity;
            c1 := colorbuffer2[iX mod colorbuffersize2, ypos];
            c := coloraverage(c2, c1, fopacity);
            tline[iX] := RGBSwap(c);
          end;
        end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end
    else if PenSpeedButton3.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := iY mod colorbuffersize2;
        for iX := iX1 to iX2 do
        begin
          newopacity := pen3mask[iX - X, iY - Y];
          if drawlayer[iX, iY].pass < newopacity then
          begin
            if drawlayer[iX, iY].pass = 0 then
              c2 := RGBSwap(tline[iX])
            else
              c2 := drawlayer[iX, iY].color;
            drawlayer[iX, iY].color := c2;
            drawlayer[iX, iY].pass := newopacity;
            c1 := colorbuffer2[iX mod colorbuffersize2, ypos];
            c := coloraverage(c2, c1, newopacity);
            tline[iX] := RGBSwap(c);
          end;
        end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end;
  end

  else
  begin
    if PenSpeedButton1.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := (iY * 100 div ftexturescale) mod colorbuffersize;
        for iX := iX1 to iX2 do
          if drawlayer[iX, iY].pass < fopacity then
          begin
            drawlayer[iX, iY].pass := fopacity;
            c1 := colorbuffer[(iX * 100 div ftexturescale) mod colorbuffersize, ypos];
            c2 := RGBSwap(tline[iX]);
            c := coloraverage(c2, c1, fopacity);
            tline[iX] := RGBSwap(c);
          end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end
    else if PenSpeedButton2.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := (iY * 100 div ftexturescale) mod colorbuffersize;
        for iX := iX1 to iX2 do
        begin
          newopacity := pen2mask[iX - X, iY - Y];
          if drawlayer[iX, iY].pass < newopacity then
          begin
            if drawlayer[iX, iY].pass = 0 then
              c2 := RGBSwap(tline[iX])
            else
              c2 := drawlayer[iX, iY].color;
            drawlayer[iX, iY].color := c2;
            drawlayer[iX, iY].pass := newopacity;
            c1 := colorbuffer[(iX * 100 div ftexturescale) mod colorbuffersize, ypos];
            c := coloraverage(c2, c1, fopacity);
            tline[iX] := RGBSwap(c);
          end;
        end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end
    else if PenSpeedButton3.Down then
    begin
      for iY := iY1 to iY2 do
      begin
        tline := tex.Texture.ScanLine[iY];
        ypos := (iY * 100 div ftexturescale) mod colorbuffersize;
        for iX := iX1 to iX2 do
        begin
          newopacity := pen3mask[iX - X, iY - Y];
          if drawlayer[iX, iY].pass < newopacity then
          begin
            if drawlayer[iX, iY].pass = 0 then
              c2 := RGBSwap(tline[iX])
            else
              c2 := drawlayer[iX, iY].color;
            drawlayer[iX, iY].color := c2;
            drawlayer[iX, iY].pass := newopacity;
            c1 := colorbuffer[(iX * 100 div ftexturescale) mod colorbuffersize, ypos];
            c := coloraverage(c2, c1, newopacity);
            tline[iX] := RGBSwap(c);
          end;
        end;
      end;
      DoRefreshPaintBox(Rect(iX1 - 1, iY1 - 1, iX2 + 1, iY2 + 1));
      changed := True;
    end;
  end;
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
end;

procedure TForm1.CalcPenMasks;
var
  iX, iY: integer;
  sqmaxdist: integer;
  sqdist: integer;
  sqry: integer;
  frac: single;
begin
  if (foldopacity = fopacity) and (foldpensize = fpensize) then
    Exit;
  foldopacity := fopacity;
  foldpensize := fpensize;

  ZeroMemory(@pen2mask, SizeOf(pen2mask));
  ZeroMemory(@pen3mask, SizeOf(pen3mask));
  sqmaxdist := sqr(fpensize div 2);
  if sqmaxdist <= 0 then
    sqmaxdist := 1;
  for iY := -fpensize div 2 to fpensize div 2 do
  begin
    sqry := iY * iY;
    for iX := -fpensize div 2 to fpensize div 2 do
    begin
      sqdist := iX * iX + sqry;
      if sqdist <= sqmaxdist then
      begin
        pen2mask[iX, iY] := fopacity;
        frac := (1 - sqdist / sqmaxdist) * fopacity;
        pen3mask[iX, iY] := GetIntInRange(round(frac), 0, 100);
      end;
    end;
  end;
end;

procedure TForm1.PenSpeedButton1Click(Sender: TObject);
begin
  PaintBox1.Cursor := crCross; //crPaint;
  PaintBox1.Invalidate;
end;

procedure TForm1.PenSpeedButton2Click(Sender: TObject);
begin
  PaintBox1.Cursor := crCross; //crPaint;
  PaintBox1.Invalidate;
end;

procedure TForm1.PenSpeedButton3Click(Sender: TObject);
begin
  PaintBox1.Cursor := crCross; //crPaint;
  PaintBox1.Invalidate;
end;

procedure TForm1.PasteTexture1Click(Sender: TObject);
var
  tempBitmap: TBitmap;
begin
  // if there is an image on clipboard
  if Clipboard.HasFormat(CF_BITMAP) then
  begin
    SaveUndo(true);

    tempBitmap := TBitmap.Create;
    tempBitmap.LoadFromClipboardFormat(CF_BITMAP, ClipBoard.GetAsHandle(cf_Bitmap), 0);

    tempBitmap.PixelFormat := pf32bit;

    tex.Texture.Canvas.StretchDraw(Rect(0, 0, tex.texturewidth, tex.textureheight), tempBitmap);

    tempBitmap.Free;

    changed := True;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.PaletteSpeedButton1Click(Sender: TObject);
var
  p: TPoint;
begin
  p := PaletteSpeedButton1.ClientToScreen(Point(0, PaletteSpeedButton1.Height));
  PalettePopupMenu1.Popup(p.X, p.Y);
  PaletteSpeedButton1.Down := False;
end;

procedure TForm1.PaletteDefault1Click(Sender: TObject);
begin
  fpalettename := spalDEFAULT;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteDoom1Click(Sender: TObject);
begin
  fpalettename := spalDOOM;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteHeretic1Click(Sender: TObject);
begin
  fpalettename := spalHERETIC;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteHexen1Click(Sender: TObject);
begin
  fpalettename := spalHEXEN;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteStrife1Click(Sender: TObject);
begin
  fpalettename := spalSTRIFE;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteRadix1Click(Sender: TObject);
begin
  fpalettename := spalRADIX;
  NotifyFlatsListBox;
end;

procedure TForm1.PaletteGreyScale1Click(Sender: TObject);
begin
  fpalettename := spalGRAYSCALE;
  NotifyFlatsListBox;
end;

procedure TForm1.CheckPaletteName;
begin
  if fpalettename <> spalDEFAULT then
    if fpalettename <> spalDOOM then
      if fpalettename <> spalHERETIC then
        if fpalettename <> spalHEXEN then
          if fpalettename <> spalSTRIFE then
            if fpalettename <> spalRADIX then
              if fpalettename <> spalGRAYSCALE then
                fpalettename := spalDEFAULT;
end;

procedure TForm1.PalettePopupMenu1Popup(Sender: TObject);
begin
  PaletteDoom1.Checked := fpalettename = spalDOOM;
  PaletteHeretic1.Checked := fpalettename = spalHERETIC;
  PaletteHexen1.Checked := fpalettename = spalHEXEN;
  PaletteStrife1.Checked := fpalettename = spalSTRIFE;
  PaletteRadix1.Checked := fpalettename = spalRADIX;
  PaletteGreyScale1.Checked := fpalettename = spalGRAYSCALE;
  PaletteDefault1.Checked := fpalettename = spalDEFAULT;
end;

procedure TForm1.SelectPK3FileButtonClick(Sender: TObject);
begin
  if OpenPK3Dialog.Execute then
  begin
    Screen.Cursor := crHourglass;
    try
      fpk3filename := ExpandFilename(OpenPK3Dialog.FileName);
      PK3FileNameEdit.Text := ExtractFileName(OpenPK3Dialog.FileName);
      PopulatePK3ListBox(fpk3filename);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.PopulatePK3ListBox(const pk3name: string);
var
  i: integer;
  uEntry: string;
  uExt: string;
begin
  fpk3reader.FileName := fpk3filename;
  PK3TexListBox.Items.Clear;
  for i := 0 to fpk3reader.FileCount - 1 do
  begin
    uEntry := UpperCase(fpk3reader.Files[i]);
    uExt := ExtractFileExt(uEntry);
    if (uExt = '.PNG') or (uExt = '.JPG') then
      PK3TexListBox.Items.Add(uEntry);
  end;
  if PK3TexListBox.Count > 0 then
    PK3TexListBox.ItemIndex := 0
  else
    PK3TexListBox.ItemIndex := -1;
  NotifyPK3ListBox;
end;

procedure TForm1.NotifyPK3ListBox;
var
  idx: integer;
  bm: TBitmap;
begin
  ChangeListHint(PK3TexListBox, 'PK3 Textures');
  idx := PK3TexListBox.ItemIndex;
  if (idx < 0) or (fpk3filename = '') or not FileExists(fpk3filename) then
  begin
    PK3TexPreviewImage.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    PK3TexPreviewImage.Picture.Bitmap.Canvas.Brush.Color := RGB(255, 255, 255);
    PK3TexPreviewImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, 128, 128));
    PK3TextureNameLabel.Caption := '(none)';
    PK3TexSizeLabel.Caption := Format('(%dx%d)', [128, 128]);
    colorbuffersize := 128;
    FillChar(colorbuffer^, SizeOf(colorbuffer_t), 255);
    ColorBufferHalftoneAdjust;
    exit;
  end;

  Screen.Cursor := crHourglass;
  try
    bm := GetPK3TexAsBitmap(PK3TexListBox.Items[idx]);
  finally
    Screen.Cursor := crDefault;
  end;

  RotateBitmapFromRadiogroupIndex(bm, PK3RotateRadioGroup);
  BitmapToColorBuffer(bm);

  colorbuffersize := MinI(bm.Height, MAXTEXTURESIZE);
  ColorBufferHalftoneAdjust;
  PK3TexPreviewImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, 128, 128), bm);
  PK3TextureNameLabel.Caption := ExtractFileName(PK3TexListBox.Items[idx]);
  PK3TexSizeLabel.Caption := Format('(%dx%d)', [bm.Width, bm.Height]);
  bm.Free;
end;

function TForm1.GetPK3TexAsBitmap(const tname: string): TBitmap;
var
  p: pointer;
  psize: integer;
  jpg: TJpegImage;
  png: TPNGObject;
  uExt: string;
  m: TMemoryStream;
begin
  if fpk3reader.GetZipFileData(tname, p, psize) then
  begin
    m := TMemoryStream.Create;
    m.Write(p^, psize);
    FreeMem(p, psize);

    m.Position := 0;

    uExt := UpperCase(ExtractFileExt(tname));

    if uExt = '.JPG' then
    begin
      jpg := TJpegImage.Create;
      jpg.LoadFromStream(m);
      Result := TBitmap.Create;
      Result.Assign(jpg);
      jpg.Free;
      m.Free;
      Exit;
    end;

    if uExt = '.PNG' then
    begin
      png := TPNGObject.Create;
      png.LoadFromStream(m);
      Result := TBitmap.Create;
      Result.Assign(png);
      png.Free;
      m.Free;
      Exit;
    end;
    m.Free;
  end;

  // Not supported extension ???
  Result := TBitmap.Create;
  Result.Width := 64;
  Result.Height := 64;
  Result.Canvas.Brush.Style := bsSolid;
  Result.Canvas.Brush.Color := RGB(255, 255, 255);
  Result.Canvas.FillRect(Rect(0, 0, 64, 64));
  Exit;
end;

procedure TForm1.PK3TexListBoxClick(Sender: TObject);
begin
  NotifyPK3ListBox;
end;

procedure TForm1.MNImportTexture1Click(Sender: TObject);
var
  f: TLoadImageHelperForm;
begin
  if OpenPictureDialog1.Execute then
  begin
    Screen.Cursor := crHourglass;
    f := TLoadImageHelperForm.Create(nil);
    try
      f.Image1.Picture.LoadFromFile(OpenPictureDialog1.FileName);
      SaveUndo(True);
      tex.Texture.Canvas.StretchDraw(Rect(0, 0, tex.texturewidth, tex.textureheight), f.Image1.Picture.Graphic);
      changed := True;
      PaintBox1.Invalidate;
    finally
      f.Free;
    end;
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.PopulateDirListBox;
var
  Rec: TSearchRec;
  uName, uExt: string;
  i: integer;
begin
  if (fdirdirectory = '') or not DirectoryExists(fdirdirectory) then
    fdirdirectory := ExtractFileDir(ParamStr(0));
  if fdirdirectory[Length(fdirdirectory)] <> '\' then
    fdirdirectory := fdirdirectory + '\';
  ClearList(fdirlist);
  if FindFirst(fdirdirectory + '*.*', faAnyFile - faDirectory, Rec) = 0 then
  try
    repeat
      uName := UpperCase(fdirdirectory + Rec.Name);
      uExt := ExtractFileExt(uName);
      if (uExt = '.JPG') or (uExt = '.JPEG') or (uExt = '.BMP') or (uExt = '.TGA') or (uExt = '.PNG') then
        fdirlist.AddObject(MkShortName(fdirdirectory + Rec.Name, DIRTexListBoxNameSize), TString.Create(fdirdirectory + Rec.Name));
    until FindNext(Rec) <> 0;
  finally
    FindClose(Rec);
  end;
  DIRTexListBox.Items.Clear;
  for i := 0 to fdirlist.Count - 1 do
    DIRTexListBox.Items.AddObject(fdirlist.Strings[i], fdirlist.Objects[i]);
  if DIRTexListBox.Items.Count > 0 then
    DIRTexListBox.ItemIndex := 0;
  NotifyDIRListBox;
end;

procedure TForm1.NotifyDIRListBox;
var
  idx: integer;
  bm: TBitmap;
  f: TLoadImageHelperForm;
begin
  ChangeListHint(DIRTexListBox, 'Disk Textures');
  idx := DIRTexListBox.ItemIndex;
  if (idx < 0) or (idx >= fdirlist.Count) or not FileExists((fdirlist.Objects[idx] as TString).str) then
  begin
    DIRTexPreviewImage.Picture.Bitmap.Canvas.Brush.Style := bsSolid;
    DIRTexPreviewImage.Picture.Bitmap.Canvas.Brush.Color := RGB(255, 255, 255);
    DIRTexPreviewImage.Picture.Bitmap.Canvas.FillRect(Rect(0, 0, 128, 128));
    DIRTextureNameLabel.Caption := '(none)';
    DIRTexSizeLabel.Caption := Format('(%dx%d)', [128, 128]);
    colorbuffersize := 128;
    FillChar(colorbuffer^, SizeOf(colorbuffer_t), 255);
    ColorBufferHalftoneAdjust;
    exit;
  end;

  f := TLoadImageHelperForm.Create(nil);
  bm := TBitmap.Create;
  bm.PixelFormat := pf32bit;
  bm.Width := 128;
  bm.Height := 128;
  try
    f.Image1.Picture.LoadFromFile((fdirlist.Objects[idx] as TString).str);
    bm.Assign(f.Image1.Picture.Graphic);
  finally
    f.Free;
  end;

  RotateBitmapFromRadiogroupIndex(bm, DIRRotateRadioGroup);
  BitmapToColorBuffer(bm);

  colorbuffersize := MinI(bm.Height, MAXTEXTURESIZE);
  ColorBufferHalftoneAdjust;
  DIRTexPreviewImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, 128, 128), bm);
  DIRTextureNameLabel.Caption := ExtractFileName((fdirlist.Objects[idx] as TString).str);
  DIRTexSizeLabel.Caption := Format('(%dx%d)', [bm.Width, bm.Height]);
  bm.Free;
end;

function TForm1.DIRTexListBoxNameSize: integer;
begin
  Result := 32 + (DIRTexListBox.Width - 236) div 7;
end;

function TForm1.DIRTexEditNameSize: integer;
begin
  Result := DIRFileNameEdit.Width div 7;
end;

procedure TForm1.DIRTexListBoxClick(Sender: TObject);
begin
  NotifyDIRListBox;
end;

procedure TForm1.SelectDIRFileButtonClick(Sender: TObject);
var
  newdir: string;
begin
  newdir := fdirdirectory;
  if SelectDirectory('Select textures folder', '', newdir) then
  begin
    if newdir <> '' then
      if newdir[Length(newdir)] <> '\' then
        newdir := newdir + '\';
    if newdir <> fdirdirectory then
    begin
      Screen.Cursor := crHourglass;
      try
        fdirdirectory := newdir;
        DIRFileNameEdit.Text := fdirdirectory;
        PopulateDirListBox;
      finally
        Screen.Cursor := crDefault;
      end;
    end;
  end;
end;

procedure TForm1.Splitter1Moved(Sender: TObject);
var
  i, idx: integer;
begin
  idx := DIRTexListBox.ItemIndex;
  DIRTexListBox.Items.Clear;
  for i := 0 to fdirlist.Count - 1 do
    DIRTexListBox.Items.AddObject(mkshortname((fdirlist.Objects[i] as TString).str, DIRTexListBoxNameSize), fdirlist.Objects[i]);
  DIRTexListBox.ItemIndex := idx;
  RecreateColorPickPalette;
end;

procedure TForm1.WADFileNameEditChange(Sender: TObject);
begin
  WADFileNameEdit.Hint := WADFileNameEdit.Text;
end;

procedure TForm1.PK3FileNameEditChange(Sender: TObject);
begin
  PK3FileNameEdit.Hint := PK3FileNameEdit.Text;
end;

procedure TForm1.DIRFileNameEditChange(Sender: TObject);
begin
  DIRFileNameEdit.Hint := DIRFileNameEdit.Text;
end;

procedure TForm1.ChangeListHint(const lst: TListBox; const def: string);
var
  idx: integer;
begin
  idx := lst.ItemIndex;
  if idx >= 0 then
  begin
    if lst.Items.Objects[idx] <> nil then
      lst.Hint := (lst.Items.Objects[idx] as TString).str
    else
      lst.Hint := lst.Items.strings[idx];
  end
  else
    lst.Hint := def;
end;

procedure TForm1.TexturePageControlChange(Sender: TObject);
begin
  case TexturePageControl.ActivePageIndex of
  0:
    begin
      case WADPageControl1.ActivePageIndex of
      0: NotifyFlatsListBox;
      1: NotifyWADPatchListBox;
      end;
    end;
  1: NotifyPK3ListBox;
  2: NotifyDIRListBox;
  3:
    begin
      RecreateColorPickPalette;
      NotifyColor;
    end;
  end;
end;

procedure TForm1.ColorPickerButton1Click(Sender: TObject);
begin
  ColorDialog1.Color := ColorPickerButton1.Color;
  if ColorDialog1.Execute then
  begin
    fdrawcolor := ColorDialog1.Color;
    NotifyColor;
  end;
end;

procedure TForm1.ColorPickerButton1Change(Sender: TObject);
begin
  fdrawcolor := ColorPickerButton1.Color;
  NotifyColor;
end;

procedure TForm1.NotifyColor;
var
  x, y: integer;
begin
  ColorPickerButton1.Color := fdrawcolor;
  PickColorRGBLabel.Caption := Format('RGB(%d, %d, %d)', [GetRValue(fdrawcolor), GetGValue(fdrawcolor), GetBValue(fdrawcolor)]);
  if colorbuffer = nil then
    Exit;
  colorbuffersize := 64;
  for x := 0 to 63 do
    for y := 0 to 63 do
      colorbuffer[x, y] := fdrawcolor;
  ColorBufferHalftoneAdjust;
end;

procedure TForm1.RecreateColorPickPalette;
var
  m: TMemoryStream;
  bmz: TZBitmap;
  w, h: integer;
begin
  m := TMemoryStream.Create;
  m.Write(ColorPaletteBMZ, SizeOf(ColorPaletteBMZ));
  m.Position := 0;
  bmz := TZBitmap.Create;
  bmz.LoadFromStream(m);
  m.Free;
  w := ColorPaletteImage.Width;
  h := ColorPaletteImage.Height;
  ColorPaletteImage.Picture.Bitmap.Width := w;
  ColorPaletteImage.Picture.Bitmap.Height := h;
  ColorPaletteImage.Picture.Bitmap.Canvas.StretchDraw(Rect(0, 0, w, h), bmz);
  bmz.Free;
end;

procedure TForm1.PickColorPalettePanelCanResize(Sender: TObject;
  var NewWidth, NewHeight: Integer; var Resize: Boolean);
begin
  RecreateColorPickPalette;
end;

procedure TForm1.PickColorPalette(const X, Y: integer);
var
  x2, y2: integer;
begin
  x2 := GetIntInRange(X, 0, ColorPaletteImage.Picture.Bitmap.Width - 1);
  y2 := GetIntInRange(Y, 0, ColorPaletteImage.Picture.Bitmap.Height - 1);
  fdrawcolor := ColorPaletteImage.Picture.Bitmap.Canvas.Pixels[x2, y2];
  NotifyColor;
end;

procedure TForm1.ColorPaletteImageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    lpickcolormousedown := True;
    PickColorPalette(X, Y);
  end;
end;


procedure TForm1.ColorPaletteImageMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
  if lpickcolormousedown then
    PickColorPalette(X, Y);
end;

procedure TForm1.ColorPaletteImageMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if button = mbLeft then
  begin
    lpickcolormousedown := False;
    PickColorPalette(X, Y);
  end;
end;

procedure TForm1.TextureScaleResetLabelDblClick(Sender: TObject);
begin
  ftexturescale := 100;
  UpdateSliders;
  SlidersToLabels;
end;

procedure TForm1.MNExpoortTexture1Click(Sender: TObject);
var
  imgfname: string;
begin
  if SavePictureDialog1.Execute then
  begin
    Screen.Cursor := crHourglass;
    try
      imgfname := SavePictureDialog1.FileName;
      BackupFile(imgfname);
      SaveImageToDisk(tex.Texture, imgfname);
    finally
      Screen.Cursor := crDefault;
    end;
  end;
end;

procedure TForm1.WADPatchListBoxClick(Sender: TObject);
begin
  NotifyWADPatchListBox;
end;

procedure TForm1.WADPageControl1Change(Sender: TObject);
begin
  case WADPageControl1.ActivePageIndex of
  0: NotifyFlatsListBox;
  1: NotifyWADPatchListBox;
  end;
end;

procedure TForm1.Quantize1Click(Sender: TObject);
begin
  changed := True;
  SaveUndo(true);
  wp_quantizebitmap(tex.Texture, 255);
  PaintBox1.Invalidate;
end;

procedure TForm1.ConvertToPalette(const pname: string);
var
  rp: rawpalette_p;
  palette: array[0..255] of LongWord;
  line: PLongWordArray;
  x, y: integer;
  cchanged: boolean;
  c, cn: LongWord;
begin
  rp := GetPaletteFromName(pname);
  if rp = nil then
    Exit;

  WP_RawPalette2PaletteArray(rp, @palette);

  tex.Texture.PixelFormat := pf32bit;

  cchanged := False;
  for y := 0 to tex.textureheight - 1 do
  begin
    line := tex.Texture.ScanLine[y];
    for x := 0 to tex.texturewidth - 1 do
    begin
      c := line[x];
      cn := palette[V_FindAproxColorIndex(@palette, c, 0, 255)];
      if cn <> c then
      begin
        if not cchanged then
        begin
          cchanged := True;
          SaveUndo(True);
        end;
        line[x] := cn;
      end;
    end;
  end;

  if cchanged then
  begin
    changed := True;
    PaintBox1.Invalidate;
  end;
end;

procedure TForm1.Doom1Click(Sender: TObject);
begin
  ConvertToPalette(spalDOOM);
end;

procedure TForm1.Heretic1Click(Sender: TObject);
begin
  ConvertToPalette(spalHERETIC);
end;

procedure TForm1.Hexen1Click(Sender: TObject);
begin
  ConvertToPalette(spalHEXEN);
end;

procedure TForm1.Strife1Click(Sender: TObject);
begin
  ConvertToPalette(spalSTRIFE);
end;

procedure TForm1.Radix1Click(Sender: TObject);
begin
  ConvertToPalette(spalRADIX);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  pt: TPoint;
  r: TRect;
begin
  ZoomInButton1.Enabled := fZoom < MAXZOOM;
  ZoomOutButton1.Enabled := fZoom > MINZOOM;
  
  if hasdrawPaintToolShape then
  begin
    GetCursorPos(pt);
    pt := PaintBox1.Parent.ScreenToClient(pt);
    r := PaintBox1.ClientRect;
    if r.Right > PaintScrollBox.Width then
      r.Right := PaintScrollBox.Width;
    if r.Bottom > PaintScrollBox.Height then
      r.Bottom := PaintScrollBox.Height;
    if not PtInRect(r, pt) then
    begin
      LastiX1 := 0;
      LastiX2 := 0;
      LastiY1 := 0;
      LastiY2 := 0;
      LastShape := 0;
      PaintBox1.Invalidate;
    end;
  end;
end;

procedure TForm1.ZoomInButton1Click(Sender: TObject);
var
  z: integer;
begin
  if not lmousedown then
  begin
    z := GetIntInRange(fZoom + 1, MINZOOM, MAXZOOM);
    if z <> fZoom then
    begin
      fZoom := z;
      PaintBox1.Width := tex.texturewidth * fZoom;
      PaintBox1.Height := tex.textureheight * fZoom;
      PaintBox1.Invalidate;
    end;
  end;
end;

procedure TForm1.ZoomOutButton1Click(Sender: TObject);
var
  z: integer;
begin
  if not lmousedown then
  begin
    z := GetIntInRange(fZoom - 1, MINZOOM, MAXZOOM);
    if z <> fZoom then
    begin
      fZoom := z;
      PaintBox1.Width := tex.texturewidth * fZoom;
      PaintBox1.Height := tex.textureheight * fZoom;
      PaintBox1.Invalidate;
    end;
  end;
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  pt: TPoint;
  r: TRect;
  tick: int64;
begin
  tick := GetTickCount;
  if tick <= flastzoomwheel + MOUSEWHEELTIMEOUT then
    Exit;
  flastzoomwheel := tick;
  pt := PaintBox1.Parent.ScreenToClient(MousePos);
  r := PaintBox1.ClientRect;
  if r.Right > PaintScrollBox.Width then
    r.Right := PaintScrollBox.Width;
  if r.Bottom > PaintScrollBox.Height then
    r.Bottom := PaintScrollBox.Height;
  if PtInRect(r, pt) then
    ZoomOutButton1Click(Sender);
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
var
  pt: TPoint;
  r: TRect;
  tick: int64;
begin
  tick := GetTickCount;
  if tick <= flastzoomwheel + MOUSEWHEELTIMEOUT then
    Exit;
  flastzoomwheel := tick;
  pt := PaintBox1.Parent.ScreenToClient(MousePos);
  r := PaintBox1.ClientRect;
  if r.Right > PaintScrollBox.Width then
    r.Right := PaintScrollBox.Width;
  if r.Bottom > PaintScrollBox.Height then
    r.Bottom := PaintScrollBox.Height;
  if PtInRect(r, pt) then
    ZoomInButton1Click(Sender);
end;

procedure TForm1.Label2DblClick(Sender: TObject);
begin
  fopacity := 100;
  UpdateSliders;
  SlidersToLabels;
end;

procedure TForm1.Label3DblClick(Sender: TObject);
begin
  fpensize := 64;
  UpdateSliders;
  SlidersToLabels;
end;

procedure TForm1.FilterLaplace1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] := -1; RAY[1] := -1; RAY[2] := -1;
      RAY[3] := -1; RAY[4] :=  8; RAY[5] := -1;
      RAY[6] := -1; RAY[7] := -1; RAY[8] := -1;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterHiPass1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] := -1; RAY[1] := -1; RAY[2] := -1;
      RAY[3] := -1; RAY[4] :=  9; RAY[5] := -1;
      RAY[6] := -1; RAY[7] := -1; RAY[8] := -1;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterFindEdges1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  1; RAY[1] :=  1; RAY[2] :=  1;
      RAY[3] :=  1; RAY[4] := -2; RAY[5] :=  1;
      RAY[6] := -1; RAY[7] := -1; RAY[8] := -1;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterSharpen1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] := -1; RAY[1] := -1; RAY[2] := -1;
      RAY[3] := -1; RAY[4] := 16; RAY[5] := -1;
      RAY[6] := -1; RAY[7] := -1; RAY[8] := -1;
      DIVFACTOR := 8;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterEdgeEnhance1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  0; RAY[1] := -1; RAY[2] :=  0;
      RAY[3] := -1; RAY[4] :=  5; RAY[5] := -1;
      RAY[6] :=  0; RAY[7] := -1; RAY[8] :=  0;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterColorEmboss1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  1; RAY[1] :=  0; RAY[2] :=  1;
      RAY[3] :=  0; RAY[4] :=  0; RAY[5] :=  0;
      RAY[6] :=  1; RAY[7] :=  0; RAY[8] := -2;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterSoften1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  2; RAY[1] :=  2; RAY[2] :=  2;
      RAY[3] :=  2; RAY[4] :=  0; RAY[5] :=  2;
      RAY[6] :=  2; RAY[7] :=  2; RAY[8] :=  2;
      DIVFACTOR := 16;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterSofterless1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  0; RAY[1] :=  1; RAY[2] :=  0;
      RAY[3] :=  1; RAY[4] :=  2; RAY[5] :=  1;
      RAY[6] :=  0; RAY[7] :=  1; RAY[8] :=  0;
      DIVFACTOR := 6;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterBlur1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  3; RAY[1] :=  3; RAY[2] :=  3;
      RAY[3] :=  3; RAY[4] :=  8; RAY[5] :=  3;
      RAY[6] :=  3; RAY[7] :=  3; RAY[8] :=  3;
      DIVFACTOR := 32;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterGrease1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  1; RAY[1] :=  1; RAY[2] :=  1;
      RAY[3] :=  1; RAY[4] := -7; RAY[5] :=  1;
      RAY[6] :=  1; RAY[7] :=  1; RAY[8] :=  1;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterSimpleEmboss1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] := -1; RAY[1] :=  0; RAY[2] :=  1;
      RAY[3] := -1; RAY[4] :=  0; RAY[5] :=  1;
      RAY[6] := -1; RAY[7] :=  0; RAY[8] :=  1;
      DIVFACTOR := 1;
      BIAS := 128;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterLithograph1Click(Sender: TObject);
var 
  flt: TImageFilter5x5;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[ 0] := -1; RAY[ 1] := -1; RAY[ 2] := -1; RAY[ 3] := -1; RAY[ 4] := -1;
      RAY[ 5] := -1; RAY[ 6] :=-10; RAY[ 7] :=-10; RAY[ 8] :=-10; RAY[ 9] := -1;
      RAY[10] := -1; RAY[11] :=-10; RAY[12] := 98; RAY[13] :=-10; RAY[14] := -1;
      RAY[15] := -1; RAY[16] :=-10; RAY[17] :=-10; RAY[18] :=-10; RAY[19] := -1;
      RAY[20] := -1; RAY[21] := -1; RAY[22] := -1; RAY[23] := -1; RAY[24] := -1;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter5x5ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterPsychedelicDistillation1Click(Sender: TObject);
var 
  flt: TImageFilter5x5;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[ 0] :=  0; RAY[ 1] := -1; RAY[ 2] := -2; RAY[ 3] := -3; RAY[ 4] := -4;
      RAY[ 5] :=  0; RAY[ 6] := -1; RAY[ 7] :=  3; RAY[ 8] :=  2; RAY[ 9] :=  1;
      RAY[10] :=  0; RAY[11] := -1; RAY[12] := 10; RAY[13] :=  2; RAY[14] :=  1;
      RAY[15] :=  0; RAY[16] := -1; RAY[17] :=  3; RAY[18] :=  2; RAY[19] :=  1;
      RAY[20] :=  0; RAY[21] := -1; RAY[22] := -2; RAY[23] := -3; RAY[24] := -4;
      DIVFACTOR := 1;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter5x5ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterBlurmore1Click(Sender: TObject);
var 
  flt: TImageFilter3x3;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[0] :=  1; RAY[1] :=  1; RAY[2] :=  1;
      RAY[3] :=  1; RAY[4] :=  1; RAY[5] :=  1;
      RAY[6] :=  1; RAY[7] :=  1; RAY[8] :=  1;
      DIVFACTOR := 9;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter3x3ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.FilterBlurmax1Click(Sender: TObject);
var
  flt: TImageFilter5x5;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[ 0] :=  1; RAY[ 1] :=  1; RAY[ 2] :=  1; RAY[ 3] :=  1; RAY[ 4] :=  1;
      RAY[ 5] :=  1; RAY[ 6] :=  1; RAY[ 7] :=  1; RAY[ 8] :=  1; RAY[ 9] :=  1;
      RAY[10] :=  1; RAY[11] :=  1; RAY[12] :=  1; RAY[13] :=  1; RAY[14] :=  1;
      RAY[15] :=  1; RAY[16] :=  1; RAY[17] :=  1; RAY[18] :=  1; RAY[19] :=  1;
      RAY[20] :=  1; RAY[21] :=  1; RAY[22] :=  1; RAY[23] :=  1; RAY[24] :=  1;
      DIVFACTOR := 25;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter5x5ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TForm1.RotateBitmapFromRadiogroupIndex(var bm: TBitmap; const rg: TRadioGroup);
begin
  case rg.ItemIndex of
    1: RotateBitmap90DegreesClockwise(bm);
    2: begin RotateBitmap90DegreesClockwise(bm); RotateBitmap90DegreesClockwise(bm); end;
    3: RotateBitmap90DegreesCounterClockwise(bm);
  end;
end;

function TForm1.ZoomValue(const x: integer): integer;
begin
  Result := x div fZoom;
end;

procedure TForm1.WADFlatRotateRadioGroupClick(Sender: TObject);
begin
  NotifyFlatsListBox;
end;

procedure TForm1.WADPatchRotateRadioGroupClick(Sender: TObject);
begin
  NotifyWADPatchListBox;
end;

procedure TForm1.PK3RotateRadioGroupClick(Sender: TObject);
begin
  NotifyPK3ListBox;
end;

procedure TForm1.DIRRotateRadioGroupClick(Sender: TObject);
begin
  NotifyDIRListBox;
end;

procedure TForm1.SizeSpeedButton1Click(Sender: TObject);
begin
  if GetInputNumber('Enter value', 'Size: ', 1, MAXPENSIZE, fpensize) then
  begin
    UpdateSliders;
    SlidersToLabels;
  end;
end;

procedure TForm1.OpacitySpeedButton1Click(Sender: TObject);
begin
  if GetInputNumber('Enter value', 'Opacity: ', 1, 100, fopacity) then
  begin
    UpdateSliders;
    SlidersToLabels;
  end;
end;

procedure TForm1.ScaleSpeedButton1Click(Sender: TObject);
begin
  if GetInputNumber('Enter value', 'Scale %: ', MINTEXTURESCALE, MAXTEXTURESCALE, ftexturescale) then
  begin
    UpdateSliders;
    SlidersToLabels;
  end;
end;

procedure TForm1.Grayscale1Click(Sender: TObject);
var
  r, g, b: byte;
  line: PLongWordArray;
  x, y: integer;
  cchanged: boolean;
  c, cn: LongWord;
begin
  tex.Texture.PixelFormat := pf32bit;

  cchanged := False;
  for y := 0 to tex.textureheight - 1 do
  begin
    line := tex.Texture.ScanLine[y];
    for x := 0 to tex.texturewidth - 1 do
    begin
      c := line[x];
      r := (c shr 16) and $ff;
      g := (c shr 8) and $ff;
      b := c and $ff;

      cn := Trunc(r * 0.299 + g * 0.587 + b * 0.114); // Human perceive;
      if cn > 255 then cn := 255;
      cn := cn + cn shl 8 + cn shl 16;
      if cn <> c then
      begin
        if not cchanged then
        begin
          cchanged := True;
          SaveUndo(True);
        end;
        line[x] := cn;
      end;
    end;
  end;

  if cchanged then
  begin
    changed := True;
    PaintBox1.Invalidate;
  end;

end;

procedure TForm1.ColorScaleTexture(const aR, aG, aB: byte);
var
  r, g, b: byte;
  line: PLongWordArray;
  x, y: integer;
  cchanged: boolean;
  c, cn: LongWord;
begin
  tex.Texture.PixelFormat := pf32bit;

  cchanged := False;
  for y := 0 to tex.textureheight - 1 do
  begin
    line := tex.Texture.ScanLine[y];
    for x := 0 to tex.texturewidth - 1 do
    begin
      c := line[x];
      r := (c shr 16) and $ff;
      g := (c shr 8) and $ff;
      b := c and $ff;

      cn := Trunc(r * 0.299 + g * 0.587 + b * 0.114); // Human perceive;
      if cn > 255 then cn := 255;
      r := GetIntInRange(Round(aR / 255 * cn), 0, 255);
      g := GetIntInRange(Round(aG / 255 * cn), 0, 255);
      b := GetIntInRange(Round(aB / 255 * cn), 0, 255);
      cn := b + g shl 8 + r shl 16;
      if cn <> c then
      begin
        if not cchanged then
        begin
          cchanged := True;
          SaveUndo(True);
        end;
        line[x] := cn;
      end;
    end;
  end;

  if cchanged then
  begin
    changed := True;
    PaintBox1.Invalidate;
  end;

end;

procedure TForm1.RedScale1Click(Sender: TObject);
begin
  ColorScaleTexture(255, 0, 0);
end;

procedure TForm1.GreenScale1Click(Sender: TObject);
begin
  ColorScaleTexture(0, 255, 0);
end;

procedure TForm1.BlueScale1Click(Sender: TObject);
begin
  ColorScaleTexture(0, 0, 255);
end;

procedure TForm1.ColorScale1Click(Sender: TObject);
begin
  if ColorDialog2.Execute then
    ColorScaleTexture(GetRValue(ColorDialog2.Color), GetGValue(ColorDialog2.Color), GetBValue(ColorDialog2.Color));
end;

procedure TForm1.NegativeImage1Click(Sender: TObject);
var
  r, g, b: byte;
  line: PLongWordArray;
  x, y: integer;
  cchanged: boolean;
  c, cn: LongWord;
begin
  tex.Texture.PixelFormat := pf32bit;

  cchanged := False;
  for y := 0 to tex.textureheight - 1 do
  begin
    line := tex.Texture.ScanLine[y];
    for x := 0 to tex.texturewidth - 1 do
    begin
      c := line[x];
      r := (c shr 16) and $ff;
      g := (c shr 8) and $ff;
      b := c and $ff;

      r := 255 - r;
      g := 255 - g;
      b := 255 - b;
      cn := b + g shl 8 + r shl 16;
      if cn <> c then
      begin
        if not cchanged then
        begin
          cchanged := True;
          SaveUndo(True);
        end;
        line[x] := cn;
      end;
    end;
  end;

  if cchanged then
  begin
    changed := True;
    PaintBox1.Invalidate;
  end;

end;

procedure TForm1.DoRemapColorChannels(const aR, aG, aB: integer);
var
  r, g, b: byte;
  A: array[0..2] of byte;
  line: PLongWordArray;
  x, y: integer;
  cchanged: boolean;
  c, cn: LongWord;
begin
  tex.Texture.PixelFormat := pf32bit;

  cchanged := False;
  for y := 0 to tex.textureheight - 1 do
  begin
    line := tex.Texture.ScanLine[y];
    for x := 0 to tex.texturewidth - 1 do
    begin
      c := line[x];
      r := (c shr 16) and $ff;
      g := (c shr 8) and $ff;
      b := c and $ff;

      A[0] := r;
      A[1] := g;
      A[2] := b;
      r := A[aR];
      g := A[aG];
      b := A[aB];
      cn := b + g shl 8 + r shl 16;
      if cn <> c then
      begin
        if not cchanged then
        begin
          cchanged := True;
          SaveUndo(True);
        end;
        line[x] := cn;
      end;
    end;
  end;

  if cchanged then
  begin
    changed := True;
    PaintBox1.Invalidate;
  end;

end;

procedure TForm1.RemapColorChannels1Click(Sender: TObject);
var
  aR, aG, aB: integer;
begin
  if RemapColorChannelsQuery(aR, aG, aB) then
    DoRemapColorChannels(aR, aG, aB);
end;

procedure TForm1.GaussianBlur1Click(Sender: TObject);
var 
  flt: TImageFilter5x5;
begin
  Screen.Cursor := crHourglass;
  try
    with flt do
    begin
      RAY[ 0] :=  1; RAY[ 1] :=  4; RAY[ 2] :=  6; RAY[ 3] :=  4; RAY[ 4] :=  1;
      RAY[ 5] :=  4; RAY[ 6] := 16; RAY[ 7] := 24; RAY[ 8] := 16; RAY[ 9] :=  4;
      RAY[10] :=  6; RAY[11] := 24; RAY[12] := 36; RAY[13] := 24; RAY[14] :=  6;
      RAY[15] :=  4; RAY[16] := 16; RAY[17] := 24; RAY[18] := 16; RAY[19] :=  4;
      RAY[20] :=  1; RAY[21] :=  4; RAY[22] :=  6; RAY[23] :=  4; RAY[24] :=  1;
      DIVFACTOR := 256;
      BIAS := 0;
    end;
    SaveUndo(True);
    ApplyFilter5x5ToBitmap(flt, tex.Texture);
    changed := true;
    PaintBox1.Invalidate;
  finally
    Screen.Cursor := crDefault;
  end;
end;

end.

