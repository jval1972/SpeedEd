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
  pngextra in 'pngextra.pas',
  pngimage in 'pngimage.pas',
  pnglang in 'pnglang.pas',
  xTGA in 'xTGA.pas',
  zBitmap in 'zBitmap.pas',
  zlibpas in 'zlibpas.pas',
  se_utils in 'se_utils.pas',
  se_binary in 'se_binary.pas',
  se_filemenuhistory in 'se_filemenuhistory.pas',
  se_undo in 'se_undo.pas',
  se_defs in 'se_defs.pas',
  se_maptexture in 'se_maptexture.pas',
  se_grafs in 'se_grafs.pas',
  se_scriptengine in 'se_scriptengine.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'GLSpeed map Editor utilities';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
