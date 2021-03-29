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
//  Project file
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

program SpeedEd;

uses
  FastMM4 in 'FastMM4.pas',
  FastMM4Messages in 'FastMM4Messages.pas',
  Forms,
  main in 'main.pas' {Form1},
  se_undo in 'se_undo.pas',
  se_binary in 'se_binary.pas',
  se_filemenuhistory in 'se_filemenuhistory.pas',
  se_utils in 'se_utils.pas',
  pngextra in 'pngextra.pas',
  pnglang in 'pnglang.pas',
  xTGA in 'xTGA.pas',
  zBitmap in 'zBitmap.pas',
  zlibpas in 'zlibpas.pas',
  se_slider in 'se_slider.pas',
  se_class in 'se_class.pas',
  se_wadreader in 'se_wadreader.pas',
  pngimage1 in 'pngimage1.pas',
  se_defs in 'se_defs.pas',
  se_wadwriter in 'se_wadwriter.pas',
  se_wad in 'se_wad.pas',
  se_doomdata in 'se_doomdata.pas',
  se_palettes in 'se_palettes.pas',
  se_pk3 in 'se_pk3.pas',
  frm_loadimagehelper in 'frm_loadimagehelper.pas' {LoadImageHelperForm},
  se_colorpickerbutton in 'se_colorpickerbutton.pas',
  se_colorpalettebmz in 'se_colorpalettebmz.pas',
  se_cursors in 'se_cursors.pas',
  se_quantize in 'se_quantize.pas',
  xTIFF in 'xTIFF.pas',
  LibDelphi in 'LibDelphi.pas',
  LibJpegDelphi in 'LibJpegDelphi.pas',
  LibTiffDelphi in 'LibTiffDelphi.pas',
  se_tmp in 'se_tmp.pas',
  se_doomutils in 'se_doomutils.pas',
  se_filters in 'se_filters.pas',
  frm_inputnumber in 'frm_inputnumber.pas' {InputNumberForm},
  GR32 in 'Graphics32\GR32.pas',
  GR32_ArrowHeads in 'Graphics32\GR32_ArrowHeads.pas',
  GR32_Backends in 'Graphics32\GR32_Backends.pas',
  GR32_Backends_Generic in 'Graphics32\GR32_Backends_Generic.pas',
  GR32_Backends_VCL in 'Graphics32\GR32_Backends_VCL.pas',
  GR32_Bindings in 'Graphics32\GR32_Bindings.pas',
  GR32_Blend in 'Graphics32\GR32_Blend.pas',
  GR32_BlendASM in 'Graphics32\GR32_BlendASM.pas',
  GR32_BlendMMX in 'Graphics32\GR32_BlendMMX.pas',
  GR32_BlendSSE2 in 'Graphics32\GR32_BlendSSE2.pas',
  GR32_Blurs in 'Graphics32\GR32_Blurs.pas',
  GR32_Brushes in 'Graphics32\GR32_Brushes.pas',
  GR32_Clipper in 'Graphics32\GR32_Clipper.pas',
  GR32_ColorGradients in 'Graphics32\GR32_ColorGradients.pas',
  GR32_ColorPicker in 'Graphics32\GR32_ColorPicker.pas',
  GR32_ColorSwatch in 'Graphics32\GR32_ColorSwatch.pas',
  GR32_Containers in 'Graphics32\GR32_Containers.pas',
  GR32_ExtImage in 'Graphics32\GR32_ExtImage.pas',
  GR32_Filters in 'Graphics32\GR32_Filters.pas',
  GR32_Gamma in 'Graphics32\GR32_Gamma.pas',
  GR32_Geometry in 'Graphics32\GR32_Geometry.pas',
  GR32_Image in 'Graphics32\GR32_Image.pas',
  GR32_Layers in 'Graphics32\GR32_Layers.pas',
  GR32_LowLevel in 'Graphics32\GR32_LowLevel.pas',
  GR32_Math in 'Graphics32\GR32_Math.pas',
  GR32_MicroTiles in 'Graphics32\GR32_MicroTiles.pas',
  GR32_OrdinalMaps in 'Graphics32\GR32_OrdinalMaps.pas',
  GR32_Paths in 'Graphics32\GR32_Paths.pas',
  GR32_Polygons in 'Graphics32\GR32_Polygons.pas',
  GR32_PolygonsAggLite in 'Graphics32\GR32_PolygonsAggLite.pas',
  GR32_RangeBars in 'Graphics32\GR32_RangeBars.pas',
  GR32_Rasterizers in 'Graphics32\GR32_Rasterizers.pas',
  GR32_RepaintOpt in 'Graphics32\GR32_RepaintOpt.pas',
  GR32_Resamplers in 'Graphics32\GR32_Resamplers.pas',
  GR32_System in 'Graphics32\GR32_System.pas',
  GR32_Text_VCL in 'Graphics32\GR32_Text_VCL.pas',
  GR32_Transforms in 'Graphics32\GR32_Transforms.pas',
  GR32_VectorMaps in 'Graphics32\GR32_VectorMaps.pas',
  GR32_VectorUtils in 'Graphics32\GR32_VectorUtils.pas',
  GR32_VPR in 'Graphics32\GR32_VPR.pas',
  GR32_VPR2 in 'Graphics32\GR32_VPR2.pas',
  GR32_XPThemes in 'Graphics32\GR32_XPThemes.pas',
  frm_remapcolorchannels in 'frm_remapcolorchannels.pas' {RemapColorChannelsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'WAD Painter';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

