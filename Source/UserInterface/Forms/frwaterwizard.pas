unit FrWaterWizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, Data, Hulpfuncties;

type

  { TFrmWaterWizard }

  TFrmWaterWizard = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    fseSpargeMash: TFloatSpinEdit;
    fseExtra: TFloatSpinEdit;
    fseFermenter: TFloatSpinEdit;
    fseKettleLoss: TFloatSpinEdit;
    fseMashThickness: TFloatSpinEdit;
    fseMashWater: TFloatSpinEdit;
    fseSparge: TFloatSpinEdit;
    fseLauterLoss: TFloatSpinEdit;
    fseEvap: TFloatSpinEdit;
    gbMash: TGroupBox;
    gbSparge: TGroupBox;
    gbBoil: TGroupBox;
    gbFermentation: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lFerm: TLabel;
    lKettleLoss: TLabel;
    lPreBoilVolume: TLabel;
    Label6: TLabel;
    lMashWater: TLabel;
    lMashThickness: TLabel;
    Label5: TLabel;
    lPostBoilVolume: TLabel;
    lPreFerm: TLabel;
    lSparge: TLabel;
    lLauterLoss: TLabel;
    lEvap: TLabel;
    sbExtra: TScrollBar;
    sbFermenter: TScrollBar;
    sbKettleLoss: TScrollBar;
    sbMashWater: TScrollBar;
    sbMashThickness: TScrollBar;
    sbSparge: TScrollBar;
    sbLauterLoss: TScrollBar;
    sbEvap: TScrollBar;
    sbSpargeMash: TScrollBar;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseEvapChange(Sender: TObject);
    procedure fseExtraChange(Sender: TObject);
    procedure fseFermenterChange(Sender: TObject);
    procedure fseKettleLossChange(Sender: TObject);
    procedure fseLauterLossChange(Sender: TObject);
    procedure fseMashThicknessChange(Sender: TObject);
    procedure fseMashWaterChange(Sender: TObject);
    procedure fseSpargeChange(Sender: TObject);
    procedure fseSpargeMashChange(Sender: TObject);
    procedure sbEvapChange(Sender: TObject);
    procedure sbExtraChange(Sender: TObject);
    procedure sbFermenterChange(Sender: TObject);
    procedure sbKettleLossChange(Sender: TObject);
    procedure sbLauterLossChange(Sender: TObject);
    procedure sbMashThicknessChange(Sender: TObject);
    procedure sbMashWaterChange(Sender: TObject);
    procedure sbMashWaterEnter(Sender: TObject);
    procedure sbMashWaterExit(Sender: TObject);
    procedure sbSpargeChange(Sender: TObject);
    procedure sbSpargeMashChange(Sender: TObject);
  private
    FRec : TRecipe;
    un, dun : TUnit;
    Mash : TMash;
    Eq : TEquipment;
    FUserClicked : boolean;
    FMaxFerm : double;
    Procedure Update; reintroduce;
  public
    Function Execute(R : TRecipe) : boolean;
  end;

var
  FrmWaterWizard: TFrmWaterWizard;

implementation

{$R *.lfm}

{ TFrmWaterWizard }

procedure TFrmWaterWizard.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FUserClicked:= TRUE;
end;

procedure TFrmWaterWizard.FormDestroy(Sender: TObject);
begin

end;

function TFrmWaterWizard.Execute(R: TRecipe): boolean;
var s : string;
begin
  if R <> NIL then
  begin
    FRec:= TRecipe.Create(NIL);
    FRec.Assign(R);
    lMashWater.Caption:= FRec.BatchSize.DisplayUnitString;
    if FRec.Fermentable[0] <> NIL then s:= FRec.Fermentable[0].Amount.DisplayUnitString
    else s:= 'kg';
    lMashThickness.Caption:= FRec.BatchSize.DisplayUnitString +  '/' + s;
    lSparge.Caption:= lMashWater.Caption;
//    lSpargeMash.Caption:= lMashWater.Caption;
    lLauterLoss.Caption:= lMashWater.Caption;
    lEvap.Caption:= lMashWater.Caption;
    lPostBoilVolume.Caption:= lMashWater.Caption;
    lKettleLoss.Caption:= lMashWater.Caption;
    lFerm.Caption:= lMashWater.Caption;
    lPreFerm.Caption:= lMashWater.Caption;
    un:= FRec.BatchSize.vUnit;
    dun:= FRec.BatchSize.DisplayUnit;
    Mash:= FRec.Mash;
    Eq:= FRec.Equipment;

    FMaxFerm:= 2.5 * FRec.BatchSize.DisplayValue;

    Update;
    FUserClicked:= False;
    Result:= (ShowModal = mrOK);
    if Result then R.Assign(FRec);
    FreeAndNIL(FRec);
  end;
end;

Procedure TFrmWaterWizard.Update;
var x, y, GrM, volMalt, evap, spdspc, mi, ma : double;
begin
  if (FUserClicked) and (FRec <> NIL) and (FRec.Mash <> NIL) and (FRec.Equipment <> NIL) then
  begin
    FUserClicked:= false;
    FRec.CalcWaterBalance;
    Mash.CalcMash;

    GrM:= FRec.GrainMassMash;
    volMalt:= GrM * MaltVolume;
    volMalt:= Convert(un, dun, volMalt);
    evap:= FRec.BoilSize.DisplayValue - FRec.BatchSize.DisplayValue;

    volMalt:= convert(un, dun, GrM * Settings.GrainAbsorption.Value);
    x:= FRec.BoilSize.DisplayValue + VolMalt + Eq.LauterDeadSpace.DisplayValue;
    y:= Convert(un, dun, 6 * GrM);

    ma:= MinD(x, y);
    FUserClicked:= false;
    sbMashWater.Position:= 0;
    fseMashWater.MaxValue:= ma;
    FUserClicked:= false;
    FUserClicked:= false;
    mi:= Convert(un, dun, 2 * GrM);
    fseMashWater.MinValue:= mi;
    FUserClicked:= false;
    x:= Convert(un, dun, Mash.MashWaterVolume);
    fseMashWater.Value:= x;
    FUserClicked:= false;
    sbMashWater.Position:= round(10 * ma);
    FUserClicked:= false;
    sbMashWater.SetParams(round(10 * x), round(10 * mi), round(10 * ma));
    FUserClicked:= false;
    x:= Eq.VolumeInTun(0.01);
    y:= Mash.MashWaterVolume + GrM * MaltVolume;
    if y > x then fseMashWater.Color:= clRed
    else fseMashWater.Color:= clDefault;

    fseMashThickness.MaxValue:= 6;
    FUserClicked:= false;
    x:= FRec.MashThickness;
    fseMashThickness.Value:= x;
    FUserClicked:= false;
    fseMashThickness.MinValue:= 2;
    FUserClicked:= false;
    sbMashThickNess.Position:= 0;
    sbMashThickness.SetParams(round(10 * x), round(10 * fseMashThickness.MinValue), round(10 * fseMashThickness.MaxValue));
    FUserClicked:= false;

    spdspc := FRec.Equipment.LauterDeadSpace.DisplayValue;
    volMalt:= convert(un, dun, GrM * Settings.GrainAbsorption.Value);
    ma:= FRec.BoilSize.DisplayValue + VolMalt + spdspc - Convert(un, dun, 2 * GrM);
    fseSparge.MaxValue:= ma;
    FUserClicked:= false;
    mi:= MaxD(0, FRec.BoilSize.DisplayValue + VolMalt + spdspc - Convert(un, dun, 6 * GrM));
    fseSparge.MinValue:= mi;
    FUserClicked:= false;
    x:= Mash.SpargeVolume;
    fseSparge.Value:= Convert(un, dun, x);
    FUserClicked:= false;
    sbSparge.Position:= 0;
    sbSparge.SetParams(round(10 * x), round(10 * mi), round(10 * ma));
    FUserClicked:= false;

    sbSpargeMash.Position:= 0;
    fseSpargeMash.MaxValue:= 1.5;
    FUserClicked:= false;
    sbSpargeMash.Max:= round(1000 * fseSpargeMash.MaxValue);
    FUserClicked:= false;
    if fseMashWater.Value > 0 then
      x:= fseSparge.Value / fseMashWater.Value
    else x:= 1;
    fseSpargeMash.Value:= x;
    FUserClicked:= false;
    sbSpargeMash.Position:= round(1000 * x);
    FUserClicked:= false;
    fseSpargeMash.MinValue:= 0.2;
    FUserClicked:= false;
    sbSpargeMash.Min:= round(1000 * fseSpargeMash.MinValue);
    FUserClicked:= false;

    fseLauterLoss.MaxValue:= 0.1 * Eq.LauterVolume.DisplayValue;
    sbLauterLoss.Max:= round(10 * fseLauterLoss.MaxValue);
    fseLauterLoss.Value:= Eq.LauterDeadSpace.DisplayValue;
    sbLauterLoss.Position:= round(10 * fseLauterLoss.Value);

    x:= ExpansionFactor * FRec.BoilSize.DisplayValue;
    lPreBoilVolume.Caption:= RealToStrDec(x, 1) + ' ' + FRec.BoilSize.DisplayUnitString
                             + ' (@ 100' + UnitNames[celcius] + ')';
    y:= Eq.VolumeInKettle(0.02);
    if x >= y then
    begin
      lPreBoilVolume.Color:= clRed;
      lPreBoilVolume.Font.Color:= clWhite;
    end
    else
    begin
      lPreboilVolume.ParentColor:= TRUE;
      lPreBoilVolume.Font.Color:= clDefault;
    end;
    x:= ExpansionFactor * evap;
    fseEvap.MaxValue:= 0.2 * Eq.KettleVolume.DisplayValue;
    sbEvap.Max:= round(10 * fseEvap.MaxValue);
    fseEvap.Value:= x;
    sbEvap.Position:= round(10 * x);

    y:= FRec.BatchSize.DisplayValue;
    x:= ExpansionFactor * y;
    lPostBoilVolume.Caption:= RealToStrDec(x, FRec.BatchSize.Decimals) + ' '
                              + FRec.BatchSize.DisplayUnitString + ' (@ 100' + UnitNames[celcius]
                              + '; ' + FRec.BatchSize.DisplayString + ' @ 20'
                              + UnitNames[celcius] + ')';

    x:= Eq.TrubChillerLoss.DisplayValue;
    fseKettleLoss.MaxValue:= 0.2 * Eq.KettleVolume.DisplayValue;
    sbKettleLoss.Max:= round(10 * fseKettleLoss.MaxValue);
    fseKettleLoss.Value:= x;
    sbKettleLoss.Position:= round(10 * x);

    x:= Eq.TopUpWater.DisplayValue;
    fseExtra.MaxValue:= 2 * FRec.BatchSize.DisplayValue;
    sbExtra.Max:= round(10 * fseExtra.MaxValue);
    fseExtra.Value:= x;
    sbExtra.Position:= round(10 * x);

    x:= y - Eq.TrubChillerLoss.DisplayValue + x;
    fseFermenter.MaxValue:= FMaxFerm;
    sbFermenter.Max:= round(10 * fseFermenter.MaxValue);
    fseFermenter.Value:= x;
    sbFermenter.Position:= round(10 * x);

    FUserClicked:= TRUE;
  end;
end;

procedure TFrmWaterWizard.fseMashWaterChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    Mash.MashWaterVolume:= Convert(dun, un, fseMashWater.Value);
    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbMashWaterChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseMashWater.Value:= sbMashWater.Position / 10;
    FUserClicked:= TRUE;
    fseMashWaterChange(fseMashWater);
  end;
end;

procedure TFrmWaterWizard.sbMashWaterEnter(Sender: TObject);
begin
  FUserClicked:= TRUE;
end;

procedure TFrmWaterWizard.sbMashWaterExit(Sender: TObject);
begin
  FUserClicked:= false;
end;

procedure TFrmWaterWizard.fseMashThicknessChange(Sender: TObject);
var gm : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    gm:= FRec.GrainMassMash;
    Mash.MashWaterVolume:= Convert(dun, un, fseMashThickness.Value * gm);
    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbMashThicknessChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseMashThickness.Value:= sbMashThickness.Position / 10;
    FUserClicked:= TRUE;
    fseMashThicknessChange(fseMashThickness);
  end;
end;

procedure TFrmWaterWizard.fseSpargeChange(Sender: TObject);
var MashVol, SpargeVol : double;
    volmalt, spdspc: double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    SpargeVol:= fseSparge.Value;
    volMalt := Convert(un, dun, FRec.GrainMassMash * Settings.GrainAbsorption.Value);
    spdspc := FRec.Equipment.LauterDeadSpace.DisplayValue;
    MashVol:= FRec.BoilSize.DisplayValue - SpargeVol + volmalt + spdspc;

    Mash.MashWaterVolume:= convert(dun, un, MashVol);

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbSpargeChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseSparge.Value:= sbSparge.Position / 10;
    FUserClicked:= TRUE;
    fseSpargeChange(fseSparge);
  end;
end;

procedure TFrmWaterWizard.fseSpargeMashChange(Sender: TObject);
var MashVol, Tot : double;
    x, volmalt, spdspc: double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    volMalt := Convert(un, dun, FRec.GrainMassMash * Settings.GrainAbsorption.Value);
    spdspc := FRec.Equipment.LauterDeadSpace.DisplayValue;
    Tot:= FRec.BoilSize.Value + volmalt + spdspc;

    x:= fseSpargeMash.Value;
    sbSpargeMash.Position:= round(1000 * fseSpargeMash.Value);
    MashVol:= Tot / (1 + x);

    Mash.MashWaterVolume:= convert(dun, un, MashVol);

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbSpargeMashChange(Sender: TObject);
var x : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    x:= sbSpargeMash.Position;
    fseSpargeMash.Value:= x / 1000;
    FUserClicked:= TRUE;
    fseSpargeMashChange(fseSpargeMash);
  end;
end;

procedure TFrmWaterWizard.fseLauterLossChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    Eq.LauterDeadSpace.DisplayValue:= fseLauterLoss.Value;

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbLauterLossChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseLauterLoss.Value:= sbLauterLoss.Position / 10;
    FUserClicked:= TRUE;
    fseLauterLossChange(fseLauterLoss);
  end;
end;

procedure TFrmWaterWizard.fseEvapChange(Sender: TObject);
var boilsz, batchsz, evap : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    batchsz:= FRec.BatchSize.DisplayValue;
    evap:= fseEvap.Value;
    Boilsz:= FRec.BatchSize.DisplayValue + evap;

    evap:= 60 * 100 * (BoilSz - BatchSz) / (BoilSz * FRec.BoilTime.Value);
    Eq.EvapRate.Value:= evap;
    FRec.BoilSize.DisplayValue:= BoilSz;

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbEvapChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseEvap.Value:= sbEvap.Position / 10;
    FUserClicked:= TRUE;
    fseEvapChange(fseEvap);
  end;
end;

procedure TFrmWaterWizard.fseKettleLossChange(Sender: TObject);
var kl : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    kl:= fseKettleLoss.Value;
    Eq.TrubChillerLoss.DisplayValue:= kl;

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbKettleLossChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseKettleLoss.Value:= sbKettleLoss.Position / 10;
    FUserClicked:= TRUE;
    fseKettleLossChange(fseKettleLoss);
  end;
end;

procedure TFrmWaterWizard.fseExtraChange(Sender: TObject);
var ex : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    ex:= fseExtra.Value;
    Eq.TopUpWater.DisplayValue:= ex;

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbExtraChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseExtra.Value:= sbExtra.Position / 10;
    FUserClicked:= TRUE;
    fseExtraChange(fseExtra);
  end;
end;

procedure TFrmWaterWizard.fseFermenterChange(Sender: TObject);
var kl, ex, ferm, bs : double;
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;

    ferm:= fseFermenter.Value;
    kl:= Eq.TrubChillerLoss.DisplayValue;
    ex:= Eq.TopUpWater.DisplayValue;
    bs:= ferm - ex + kl;
    FRec.Scale(Convert(dun, un, bs));

    FRec.BatchSize.DisplayValue:= bs;
    FRec.CalcWaterBalance;

    FUserClicked:= TRUE;
    Update;
  end;
end;

procedure TFrmWaterWizard.sbFermenterChange(Sender: TObject);
begin
  if FUserClicked and (Mash <> NIL) and (Eq <> NIL) then
  begin
    FUserClicked:= false;
    fseFermenter.Value:= sbFermenter.Position / 10;
    FUserClicked:= TRUE;
    fseFermenterChange(fseFermenter);
  end;
end;

end.

