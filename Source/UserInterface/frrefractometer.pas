unit frrefractometer;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons;

type

  { TFrmRefractometer }

  TFrmRefractometer = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    fseSG: TFloatSpinEdit;
    fseBrix: TFloatSpinEdit;
    eOG: TEdit;
    eABV: TEdit;
    bbOK: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure fseSGChange(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  FrmRefractometer: TFrmRefractometer;

implementation

{$R *.lfm}
uses HulpFuncties, Data;

{ TFrmRefractometer }

procedure TFrmRefractometer.fseSGChange(Sender: TObject);
var FG, Brix, OG, Alc, ABW, RI, RealExtract, StartBrix, Plato : double;
begin
  FG:= fseSG.Value;
  Brix:= fseBrix.Value;
  Plato:= Brix / Settings.BrixCorrection.Value;
  RI:= 1.33302 + 0.001427193 * Brix + 0.000005791157 * (Brix * Brix);
  Alc:= (277.8851 - 277.4 * FG + 0.9956 * Plato + 0.00523 * (Plato * Plato)
        + 0.000015 * (Plato * Plato * Plato)) * (FG / 0.79);
  ABW:= Alc * 0.794 / FG;
  RealExtract:= 129.8 * FG + 194.5935 + RI * (410.882 * RI - 790.8732);
  StartBrix:= RealExtract + (ABW * 2.0665);
  OG:= PlatoToSG(StartBrix / Settings.BrixCorrection.Value);

  eOG.Text:= RealToStrDec(OG, 3);
  eABV.Text:= RealToStrDec(Alc, 1) + ' vol.%';
end;

procedure TFrmRefractometer.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmRefractometer.bbOKClick(Sender: TObject);
begin
end;

end.

