unit fradjustto100;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, CheckLst,
  StdCtrls, Buttons, Data;

type

  { TfrmAdjustTotalTo100 }

  TfrmAdjustTotalTo100 = class(TForm)
    bbOK: TBitBtn;
    cbBasemalts: TCheckListBox;
    Label1: TLabel;
    procedure cbBasemaltsClickCheck(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Function Execute(Rec : TRecipe) : boolean;
  end;

var
  frmAdjustTotalTo100: TfrmAdjustTotalTo100;

implementation
uses hulpfuncties;

{$R *.lfm}

procedure TfrmAdjustTotalTo100.cbBasemaltsClickCheck(Sender: TObject);
var i, n : integer;
begin
  n:= 0;
  for i:= 0 to cbBaseMalts.Count - 1 do
    if cbBaseMalts.Checked[i] then Inc(n);

  bbOK.Enabled:= (n > 0);
end;

Function TfrmAdjustTotalTo100.Execute(Rec : TRecipe) : boolean;
var i : integer;
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  if Rec <> NIL then
  begin
    for i:= 0 to Rec.NumFermentables - 1 do
    begin
      cbBaseMalts.Items.Add(Rec.Fermentable[i].Name.Value);
      cbBaseMalts.Checked[i]:= Rec.Fermentable[i].AdjustToTotal100.Value;
    end;
    cbBaseMalts.Checked[0]:= TRUE;

    Result:= (ShowModal = mrOK);
    if Result then
    begin
      for i:= 0 to Rec.NumFermentables - 1 do
        Rec.Fermentable[i].AdjustToTotal100.Value:= cbBaseMalts.Checked[i];
    end;
  end;
end;

end.

