unit FrGetPasswd;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  MaskEdit, Buttons;

type

  { TfrmGetPasswd }

  TfrmGetPasswd = class(TForm)
    lPasswd: TLabel;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    mePasswd: TMaskEdit;
    procedure FormCreate(Sender: TObject);
  private

  public
    Function GetAnswer : string;
  end;

var
  frmGetPasswd: TfrmGetPasswd;

implementation
uses hulpfuncties, data;

{$R *.lfm}

procedure TfrmGetPasswd.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  mePasswd.PasswordChar:= '*';
end;

Function TfrmGetPassWd.GetAnswer : string;
begin
  Result:= '';
  If ShowModal = mrOK then
    Result:= mePasswd.Text;
end;

end.

