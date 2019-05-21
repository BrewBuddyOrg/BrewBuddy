unit frhopstorage;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAStyles, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Spin, Buttons;

type

  { TFrmHopStorage }

  TFrmHopStorage = class(TForm)
    BitBtn1: TBitBtn;
    cbStorageType: TComboBox;
    Chart1: TChart;
    clsMark: TLineSeries;
    clsLine: TLineSeries;
    fseHSI: TFloatSpinEdit;
    fseIBUAdj: TFloatSpinEdit;
    fseIBU: TFloatSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    seTemperature: TSpinEdit;
    seAge: TSpinEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure fseIBUChange(Sender: TObject);
  private
    { private declarations }
    Procedure CalcIBU;
    Procedure SetHSI(v : double);
    Procedure SetAlpha(v : double);
    procedure SetAge(i : longint);
  public
    { public declarations }
  published
    property HSI : double write SetHSI;
    property Alpha : double write SetAlpha;
    property Age: longint write SetAge;
  end;

var
  FrmHopStorage: TFrmHopStorage;

implementation

{$R *.lfm}
uses Hulpfuncties, Data;

{ TFrmHopStorage }

procedure TFrmHopStorage.FormCreate(Sender: TObject);
begin
  seTemperature.Value:= Settings.HopStorageTemp.Value;
  cbStorageType.ItemIndex:= Settings.HopStorageType.Value;
  seAge.Value:= 10;
  CalcIBU;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmHopStorage.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  clsLine.Clear;
  clsMark.Clear;
end;

procedure TFrmHopStorage.SetHSI(v : double);
begin
  fseHSI.Value:= v;
  CalcIBU;
end;

procedure TFrmHopStorage.SetAlpha(v : double);
begin
  fseIBU.Value:= v;
  CalcIBU;
end;

procedure TFrmHopStorage.SetAge(i : longint);
begin
  seAge.Value:= i;
  CalcIBU;
end;

procedure TFrmHopStorage.BitBtn1Click(Sender: TObject);
begin
  ModalResult:= mrOK;
end;

Procedure TFrmHopStorage.CalcIBU;
var i, n : longint;
    ibu : double;
begin
  fseIBUAdj.Value:= ActualIBU(fseIBU.Value, fseHSI.Value, seTemperature.Value, round(seAge.Value * 365/12), cbStorageType.ItemIndex);
  n:= seAge.Value;
  if n < 12 then n:= 12
  else n:= round(1.5 * n);

  clsLine.Clear;
  for i:= 0 to 10 * n do
  begin
    ibu:= ActualIBU(fseIBU.Value, fseHSI.Value, seTemperature.Value, round(i/10 * 365/12), cbStorageType.ItemIndex);
    clsLine.AddXY(i/10, ibu);
  end;
  clsMark.Clear;
  clsMark.AddXY(seAge.Value, fseIBUAdj.Value);
end;

procedure TFrmHopStorage.fseIBUChange(Sender: TObject);
begin
  CalcIBU;
end;



end.

