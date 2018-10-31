unit FrHop2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, EditBtn, Data, Hulpfuncties;

type

  { TFrmHop2 }

  TFrmHop2 = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbForm: TComboBox;
    cbType: TComboBox;
    cbUse: TComboBox;
    cbOnlyInStock: TCheckBox;
    deHarvestDate: TDateEdit;
    eSubstitutes: TEdit;
    eOrigin: TEdit;
    fseCost: TFloatSpinEdit;
    fseBeta: TFloatSpinEdit;
    fseAmount: TFloatSpinEdit;
    fseIBU: TFloatSpinEdit;
    fseAlfa: TFloatSpinEdit;
    fseHSI: TFloatSpinEdit;
    fseHumulene: TFloatSpinEdit;
    fseCaryophyllene: TFloatSpinEdit;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label21: TLabel;
    lblCost: TLabel;
    Label5: TLabel;
    lTime: TLabel;
    Label19: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lIBU: TLabel;
    lAmount: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lAlfa: TLabel;
    lMyrcene: TLabel;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    gbOil: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lHumulene: TLabel;
    lCaryophyllene: TLabel;
    lBeta: TLabel;
    mNotes: TMemo;
    pEdit: TPanel;
    fseMyrcene: TFloatSpinEdit;
    cbName: TComboBox;
    Label13: TLabel;
    fseCohumulone: TFloatSpinEdit;
    lCohumulone: TLabel;
    Label20: TLabel;
    fseTotalOil: TFloatSpinEdit;
    lTotalOil: TLabel;
    fseTime: TFloatSpinEdit;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbUseChange(Sender: TObject);
    procedure deHarvestDateChange(Sender: TObject);
    procedure fseAmountChange(Sender: TObject);
    procedure fseIBUChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseTimeChange(Sender: TObject);
    procedure seTimeChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbNameChange(Sender: TObject);
    procedure fseAlfaChange(Sender: TObject);
    procedure cbFormChange(Sender: TObject);
  private
    { private declarations }
    FHop, FOriginal, FChosen : THop;
    FCh, FUserClicked : boolean;
    Function GetHopUse : THopUse;
    Procedure SetControls;
    Procedure FillcbName;
  public
    { public declarations }
    Function Execute(H : THop) : boolean;
  end;

var
  FrmHop2: TFrmHop2;

implementation

{$R *.lfm}

{ TFrmHop2 }
uses Containers;

procedure TFrmHop2.FormCreate(Sender: TObject);
var hf : THopForm;
    ht : THopType;
    hu : THopUse;
begin
  FUserClicked:= false;
  cbForm.Items.Clear;
  for hf:= Low(HopFormDisplayNames) to High(HopFormDisplayNames) do
    cbForm.Items.Add(HopFormDisplayNames[hf]);
  cbForm.ItemIndex:= 0;
  cbType.Items.Clear;
  for ht:= Low(HopTypeDisplayNames) to High(HopTypeDisplaynames) do
    cbType.Items.Add(HopTypeDisplayNames[ht]);
  cbType.ItemIndex:= 0;
  cbUse.Items.Clear;
  for hu:= Low(HopUseDisplayNames) to High(HopUseDisplaynames) do
    cbUse.Items.Add(HopUseDisplayNames[hu]);
  cbUse.ItemIndex:= 0;
  FCh:= false;
  FOriginal:= THop.Create(nil);
  FChosen:= THop.Create(nil);
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FUserClicked:= TRUE;
end;

procedure TFrmHop2.fseTimeChange(Sender: TObject);
begin

end;

procedure TFrmHop2.FormDestroy(Sender: TObject);
begin
  FOriginal.Free;
  FChosen.Free;
end;

procedure TFrmHop2.cbNameChange(Sender: TObject);
var Am, bt : double;
begin
  Am:= FChosen.Amount.Value;
  bt:= FChosen.Time.Value;
  FChosen.Assign(THop(cbName.Items.Objects[cbName.ItemIndex]));
  FChosen.Amount.Value:= Am;
  FChosen.Time.Value:= bt;
  SetControls;
end;

Procedure TFrmHop2.SetControls;
var R : TRecipe;
begin
  if FChosen <> NIL then
  begin
    //  eName.Text:= FHop.Name.Value;
      mNotes.Text:= FChosen.Notes.Value;
      SetControl(fseAmount, lAmount, FChosen.Amount, TRUE);
      SetControl(fseTime, lTime, FChosen.Time, TRUE);
      SetControl(fseAlfa, lAlfa, FChosen.Alfa, TRUE);
      SetControl(fseBeta, lBeta, FChosen.Beta, TRUE);
      SetFloatSpinEdit(fseHSI, FChosen.HSI, TRUE);
      cbForm.ItemIndex:= cbForm.Items.IndexOf(HopFormDisplayNames[FChosen.Form]);
      cbType.ItemIndex:= cbType.Items.IndexOf(HopTypeDisplayNames[FChosen.HopType]);
      eOrigin.Text:= FChosen.Origin.Value;
      eSubstitutes.Text:= FChosen.Substitutes.Value;
      SetControl(fseHumulene, lHumulene, FChosen.Humulene, TRUE);
      SetControl(fseCaryophyllene, lCaryophyllene, FChosen.Caryophyllene, TRUE);
      SetControl(fseCohumulone, lCohumulone, FChosen.Cohumulone, TRUE);
      SetControl(fseMyrcene, lMyrcene, FChosen.Myrcene, TRUE);
      SetControl(fseTotalOil, lTotalOil, FChosen.TotalOil, TRUE);
      SetControl(fseCost, lblCost, FChosen.Cost, TRUE);
      fseCost.Value:= FChosen.Cost.DisplayValue / 10; //€ / 100g
      deHarvestDate.Date:= FChosen.HarvestDate.Value;

      if FHop.Recipe <> NIL then
      begin
        R:= FHop.Recipe;

        fseIBU.Value:= CalcIBU(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                           Convert(FHop.Amount.DisplayUnit, gram, fseAmount.Value),
                           R.BoilSize.Value, R.BatchSize.Value,
                           R.SGStartBoil, fseTime.Value, FChosen.Form, 0);
      end;
  end;
end;

procedure TFrmHop2.FillcbName;
var s : string;
    Ho : THop;
    i : integer;
begin
  cbName.Clear;
  s:= FOriginal.Origin.Value + ' - ' + FOriginal.Name.Value + ' (' + FOriginal.Alfa.DisplayString + ')';
  cbName.AddItem(s, FOriginal);
  Hops.SortByIndex2(12, 0, false);
  for i:= 0 to Hops.NumItems - 1 do
  begin
    Ho:= THop(Hops.Item[i]);
    if (not cbOnlyInStock.Checked) or ((cbOnlyInStock.Checked) and (Ho.Inventory.Value > 0)) then
    begin
      s:= Ho.Origin.Value + ' - ' + Ho.Name.Value + ' (' + Ho.Alfa.DisplayString + ')';
      cbName.AddItem(s, Hops.Item[i]);
    end;
  end;
  cbName.ItemIndex:= 0;
end;

Function TFrmHop2.Execute(H : THop) : boolean;
var R : TRecipe;
    s : string;
    Ho : THop;
    i : integer;
    hu : THopUse;
begin
  Result:= false;
  FHop:= H;
  R:= FHop.Recipe;
  FOriginal.Assign(H);
  FOriginal.Recipe:= H.Recipe;
  FChosen.Assign(H);
  FChosen.Recipe:= H.Recipe;
  if FOriginal <> NIL then
  begin
    FillcbName;
    SetControls;
    fseAmount.Value:= FHop.Amount.DisplayValue;
    fseTime.Value:= round(double(FHop.Time.Value));
    fseTime.MaxValue:= round(R.BoilTime.Value);
    cbUse.ItemIndex:= cbUse.Items.IndexOf(HopUseDisplaynames[FHop.Use]);
    hu:= GetHopUse;
    fseTime.Enabled:= (hu = huBoil);
    fseIBU.Value:= CalcIBU(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                           Convert(FHop.Amount.DisplayUnit, gram, fseAmount.Value),
                           R.BoilSize.Value, R.BatchSize.Value,
                           R.SGstartboil, fseTime.Value, FChosen.Form, 0);

    fseIBU.Enabled:= not ((fseIBU.Value = 0) and (fseAmount.Value > 0));

    Result:= (ShowModal = mrOK);
    if Result then
    begin
      //FHop.Name.Value:= eName.Text;
      FChosen.Notes.Value:= mNotes.Text;
      FChosen.Alfa.Value:= fseAlfa.Value;
      FChosen.Beta.Value:= fseBeta.Value;
      FChosen.HSI.Value:= fseHSI.Value;
      FChosen.FormDisplayName:= cbForm.Items[cbForm.ItemIndex];
      FChosen.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
      FChosen.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
      FChosen.Origin.Value:= eOrigin.Text;
      FChosen.Substitutes.Value:= eSubstitutes.Text;
      FChosen.Humulene.Value:= fseHumulene.Value;
      FChosen.Caryophyllene.Value:= fseCaryophyllene.Value;
      FChosen.Cohumulone.Value:= fseCohumulone.Value;
      FChosen.TotalOil.Value:= fseTotalOil.Value;
      FChosen.Myrcene.Value:= fseMyrcene.Value;
      FChosen.Amount.DisplayValue:= fseAmount.Value;
      FChosen.Time.Value:= fseTime.Value;
      FChosen.Cost.DisplayValue:= 10 * fseCost.Value;
      FChosen.HarvestDate.Value:= deHarvestDate.Date;
      FChosen.Recipe:= FHop.Recipe;
      FHop.Assign(FChosen);
      FHop.Amount.Value:= FChosen.Amount.Value;
    end;
  end;
end;

Function TFrmHop2.GetHopUse : THopUse;
var hu : THopUse;
begin
  for hu:= Low(HopUseDisplayNames) to High(HopUseDisplayNames) do
    if LowerCase(HopUseDisplayNames[hu]) = LowerCase(cbUse.Items[cbUse.ItemIndex]) then
      Result:= hu;
end;

procedure TFrmHop2.cbUseChange(Sender: TObject);
var hu : THopUse;
    R : TRecipe;
begin
  hu:= GetHopUse;
  R:= FHop.Recipe;
  case hu of
  huDryhop: fseTime.Value:= 0;
  huWhirlpool: fseTime.Value:= 0;
  huMash, huFirstWort: fseTime.Value:= R.BoilTime.Value;
  huAroma: fseTime.Value:= 0; //vlamuit
  end;
  fseTime.Enabled:= (hu = huBoil);
  fseAmountChange(sender);
end;

procedure TFrmHop2.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FillcbName;
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

procedure TFrmHop2.seTimeChange(Sender: TObject);
begin
  FChosen.Time.Value:= fseTime.Value;
  fseAmountChange(sender);
end;

procedure TFrmHop2.fseAmountChange(Sender: TObject);
var R : TRecipe;
    d : double;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and (not FCh) then
  begin
    FCh:= TRUE;
    d:= fseAmount.Value;
    SGstartboil := R.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + R.EstOG.Value) / 2;
    FChosen.Amount.DisplayValue:= d;
    fseIBU.Value:= CalcIBU(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                           Convert(FHop.Amount.DisplayUnit, gram, fseAmount.Value),
                           R.BoilSize.Value, R.BatchSize.Value,
                           SGav, fseTime.Value, FChosen.Form, 0);
    fseIBU.Enabled:= not ((fseIBU.Value = 0) and (fseAmount.Value > 0));

    FCh:= false;
  end;
end;

procedure TFrmHop2.fseAlfaChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and (not FCh) then
  begin
    FCh:= TRUE;
    FChosen.Alfa.DisplayValue:= fseAlfa.Value;
    SGstartboil := R.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + R.EstOG.Value) / 2;
    fseIBU.Value:= CalcIBU(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                           Convert(FHop.Amount.DisplayUnit, gram, fseAmount.Value),
                           R.BoilSize.Value, R.BatchSize.Value,
                           SGav, fseTime.Value, FChosen.Form, 0);
    FCh:= false;
  end;
end;

procedure TFrmHop2.cbFormChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and (not FCh) then
  begin
    FCh:= TRUE;
    SGstartboil := R.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + R.EstOG.Value) / 2;
    FChosen.FormDisplayName:= cbForm.Items[cbForm.ItemIndex];
    fseIBU.Value:= CalcIBU(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                           Convert(FHop.Amount.DisplayUnit, gram, fseAmount.Value),
                           R.BoilSize.Value, R.BatchSize.Value,
                           SGav, fseTime.Value, FChosen.Form, 0);
    FCh:= false;
  end;
end;

procedure TFrmHop2.fseIBUChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and (not FCh) then
  begin
    FCh:= TRUE;
    SGstartboil := R.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + R.EstOG.Value) / 2;
    fseAmount.Value:= Convert(gram, FHop.Amount.DisplayUnit,
                              AmHop(R.IBUmethod, GetHopUse, FChosen.AlfaAdjusted,
                                    fseIBU.Value,
                                    R.BoilSize.Value, R.BatchSize.Value,
                                    SGav, fseTime.Value, FChosen.Form, 0));
    FChosen.Amount.DisplayValue:= fseAmount.Value;
    FCh:= false;
  end;
end;

procedure TFrmHop2.deHarvestDateChange(Sender: TObject);
begin
  FChosen.HarvestDate.Value:= deHarvestDate.Date;
  fseAmountChange(self);
end;

end.

