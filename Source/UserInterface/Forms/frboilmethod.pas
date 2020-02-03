unit FrBoilMethod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons;

type

  { TFrmBoilMethod }

  TFrmBoilMethod = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    fseSGbefore: TFloatSpinEdit;
    fseSGafter: TFloatSpinEdit;
    eAlcohol: TEdit;
    bbOK: TBitBtn;
    lSGv: TLabel;
    lSGn: TLabel;
    procedure fseSGbeforeChange(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure fseSGafterChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end; 

var
  FrmBoilMethod: TFrmBoilMethod;

implementation

{$R *.lfm}
uses Data, HulpFuncties;

{ TFrmBoilMethod }

procedure TFrmBoilMethod.fseSGbeforeChange(Sender: TObject);
var SGv, SGn, A : double;
begin
  if fseSGafter.Value < fseSGbefore.Value then
    fseSGafter.Value:= fseSGbefore.Value;
  SGv:= fseSGbefore.Value;
  SGn:= fseSGafter.Value;
  A:= 717 * (SGn - SGv);
  eAlcohol.Text:= RealToStrDec(A, 1) + ' vol.%';
end;

procedure TFrmBoilMethod.fseSGafterChange(Sender: TObject);
var SGv, SGn, A : double;
begin
  if fseSGafter.Value < fseSGbefore.Value then
    fseSGbefore.Value:= fseSGafter.Value;
  SGv:= fseSGbefore.Value;
  SGn:= fseSGafter.Value;
  A:= 717 * (SGn - SGv);
  eAlcohol.Text:= RealToStrDec(A, 1) + ' vol.%';
end;

procedure TFrmBoilMethod.FormCreate(Sender: TObject);
begin
  if Settings.SGUnit.Value = UnitNames[SG] then
  begin
    fseSGafter.MaxValue:= 1.3;
    fseSGafter.MinValue:= 1.0;
    fseSGafter.DecimalPlaces:= 3;
    fseSGafter.Increment:= 0.001;
  end
  else if Settings.SGUnit.Value = UnitNames[Plato] then
  begin
    fseSGafter.MaxValue:= 50;
    fseSGafter.MinValue:= 0;
    fseSGafter.DecimalPlaces:= 1;
    fseSGafter.Increment:= 0.5;
  end;
  lSGv.Caption:= Settings.SGUnit.Value;
  lSGn.Caption:= lSGv.Caption;
  fseSGbefore.MaxValue:= fseSGafter.MaxValue;
  fseSGbefore.MinValue:= fseSGafter.MinValue;
  fseSGbefore.DecimalPlaces:= fseSGafter.DecimalPlaces;
  fseSGbefore.Increment:= fseSGafter.Increment;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmBoilMethod.bbOKClick(Sender: TObject);
begin
end;

end.

