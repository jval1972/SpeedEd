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
//  New Texture Form
//
//------------------------------------------------------------------------------
//  E-Mail: jimmyvalavanis@yahoo.gr
//  Site  : https://sourceforge.net/projects/speed/
//------------------------------------------------------------------------------

unit frm_newterrain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TNewForm = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label2: TLabel;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    function texWidth: integer;
    procedure SetWidthSize(const twidth: integer);
    function texHeight: integer;
    procedure SetHeighSize(const theight: integer);
  end;

function GetNewTextureSize(var twidth, theight: integer): boolean;

implementation

{$R *.dfm}

uses
  se_class;

function GetNewTextureSize(var twidth, theight: integer): boolean;
var
  f: TNewForm;
begin
  Result := False;
  f := TNewForm.Create(nil);
  try
    f.SetWidthSize(twidth);
    f.SetHeighSize(theight);
    f.ShowModal;
    if f.ModalResult = mrOK then
    begin
      twidth := wp_validatetexturesize(f.texWidth);
      theight := wp_validatetexturesize(f.texHeight);
      Result := True;
    end;
  finally
    f.Free;
  end;
end;

function TNewForm.texWidth: integer;
begin
  Result := StrToIntDef(Edit1.Text, 64);
end;

procedure TNewForm.SetWidthSize(const twidth: integer);
begin
  Edit1.Text := IntToStr(twidth);
end;

function TNewForm.texHeight: integer;
begin
  Result := StrToIntDef(Edit2.Text, 64);
end;

procedure TNewForm.SetHeighSize(const theight: integer);
begin
  Edit2.Text := IntToStr(theight);
end;

procedure TNewForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
  begin
    Key := #0;
    Exit;
  end;
end;

procedure TNewForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
  begin
    Key := #0;
    Exit;
  end;
end;

end.
