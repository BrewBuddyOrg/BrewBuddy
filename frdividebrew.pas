unit frdividebrew;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Spin;

type

  { TFrmDivideBrew }

  TFrmDivideBrew = class(TForm)
    RadioGroup1: TRadioGroup;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    Label1: TLabel;
    seNumBatches: TSpinEdit;
  private
    { private declarations }
    Function GetNumBatches : word;
  public
    { public declarations }
    Function Execute : integer;
  published
    property NumBatches : word read GetNumBatches;
  end; 

var
  FrmDivideBrew: TFrmDivideBrew;

implementation
uses hulpfuncties, data;

{$R *.lfm}

Function TFrmDivideBrew.Execute : integer;
begin
  Result:= -1;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  if (ShowModal = mrOK) then
  begin
    Result:= RadioGroup1.ItemIndex;
  end;
end;

Function TFrmDivideBrew.GetNumBatches : word;
begin
  Result:= seNumBatches.Value;
end;

end.

