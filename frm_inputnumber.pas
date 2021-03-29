unit frm_inputnumber;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TInputNumberForm = class(TForm)
    Panel1: TPanel;
    OKButton: TButton;
    CancelButton: TButton;
    Panel2: TPanel;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
    minval, maxval: integer;
  end;

function GetInputNumber(const aTitle, aPrompt: string; const minvalue, maxvalue: integer;
  var value: integer): boolean;

implementation

{$R *.dfm}

uses
  se_utils;

function GetInputNumber(const aTitle, aPrompt: string; const minvalue, maxvalue: integer;
  var value: integer): boolean;
var
  f: TInputNumberForm;
begin
  Result := False;
  f := TInputNumberForm.Create(nil);
  try
    f.Caption := aTitle;
    f.Label1.Caption := aPrompt;
    f.Label2.Caption := Format('Please enter a number in range [%d, %d]', [minvalue, maxvalue]);
    f.Edit1.Text := IntToStr(value);
    f.minval := minvalue;
    f.maxval := maxvalue;
    f.ShowModal;
    if f.ModalResult = mrOK then
    begin
      Result := True;
      value := StrToIntDef(f.Edit1.Text, value);
    end;
  finally
    f.Free;
  end;
end;

procedure TInputNumberForm.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in [#8, '0'..'9']) then
  begin
    Key := #0;
    Exit;
  end;
end;

procedure TInputNumberForm.FormCreate(Sender: TObject);
begin
  minval := 0;
  maxval := MAXINT;
end;

procedure TInputNumberForm.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
var
  value: integer;
begin
  if ModalResult = mrOK then
  begin
    value := StrToInt(Edit1.Text);
    CanClose := IsIntInRange(value, minval, maxval);
    if not CanClose then
    begin
      ShowMessage(Format('Please enter a number in range [%d, %d]', [minval, maxval]));
      try Edit1.SetFocus except end;
    end;
  end;
end;

end.
