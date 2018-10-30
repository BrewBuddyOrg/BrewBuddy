unit FrFermentables2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, Data;

type

  { TFrmFermentables2 }

  TFrmFermentables2 = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbType: TComboBox;
    cbGrainType: TComboBox;
    cbRecommendMash: TCheckBox;
    cbAddAfterBoil: TCheckBox;
    cbAdded: TComboBox;
    cbOnlyInStock: TCheckBox;
    eSupplier: TEdit;
    eOrigin: TEdit;
    fseBaseTo57: TFloatSpinEdit;
    fseCost: TFloatSpinEdit;
    fseDIpH: TFloatSpinEdit;
    fsePercentage: TFloatSpinEdit;
    fseAmount: TFloatSpinEdit;
    fseProtein: TFloatSpinEdit;
    fseMoisture: TFloatSpinEdit;
    fseCoarseFineDiff: TFloatSpinEdit;
    fseDiastaticPower: TFloatSpinEdit;
    fseYield: TFloatSpinEdit;
    fseMaxInBatch: TFloatSpinEdit;
    fseColor: TFloatSpinEdit;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblBaseTo57: TLabel;
    lblCost: TLabel;
    lblDIpH: TLabel;
    lMaxInBatch: TLabel;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lAmount: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblYield: TLabel;
    lblColor: TLabel;
    lblMoisture: TLabel;
    lblCoarseFineDiff: TLabel;
    lblProtein: TLabel;
    lblDiastaticPower: TLabel;
    mNotes: TMemo;
    pEdit: TPanel;
    cbName: TComboBox;
    cbFlexible: TCheckBox;
    procedure bbAddClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseAmountChange(Sender: TObject);
    procedure fseColorChange(Sender: TObject);
    procedure fsePercentageChange(Sender: TObject);
    procedure cbNameChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbFlexibleChange(Sender: TObject);
  private
    { private declarations }
    FFermentable, FOriginal, FChosen : TFermentable;
    FTotal : double;
    FRec : TRecipe;
    FOldAmount : double;
    FUserClicked : boolean;
    Procedure Store;
    Procedure SetControls;
    procedure FillcbName;
    Function InRecipe(F : TFermentable) : boolean;
  public
    { public declarations }
    Function Execute(F : TFermentable; perc : boolean; tot : double) : boolean;
  end; 

var
  FrmFermentables2: TFrmFermentables2;

implementation

{$R *.lfm}
uses Hulpfuncties, Containers, subs;

{ TFrmFermentables2 }

procedure TFrmFermentables2.FormCreate(Sender: TObject);
var ft : TFermentableType;
    gt : TGrainType;
    at : TAddedType;
begin
  FUserClicked:= false;
  FFermentable:= NIL;
  cbType.Items.Clear;
  for ft:= Low(FermentableTypeDisplayNames) to High(FermentableTypeDisplayNames) do
    cbType.Items.Add(FermentableTypeDisplayNames[ft]);
  cbType.ItemIndex:= 0;
  cbGrainType.Items.Clear;
  for gt:= Low(GrainTypeDisplayNames) to High(GrainTypeDisplayNames) do
    cbGrainType.Items.Add(GrainTypeDisplayNames[gt]);
  cbGrainType.ItemIndex:= 0;
  cbAdded.Items.Clear;
  for at:= Low(AddedTypeDisplayNames) to High(AddedTypeDisplayNames) do
    cbAdded.Items.Add(AddedTypeDisplayNames[at]);
  cbAdded.ItemIndex:= 0;
  FOriginal:= TFermentable.Create(nil);
  FChosen:= TFermentable.Create(nil);
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FUserClicked:= TRUE;
end;

procedure TFrmFermentables2.FormDestroy(Sender: TObject);
begin
  FOriginal.Free;
  FChosen.Free;
end;

Procedure TFrmFermentables2.SetControls;
begin
  if (FChosen <> NIL) then
  begin
    FUserClicked:= false;
//    eName.Text:= FChosen.Name.Value;
    mNotes.Text:= FChosen.Notes.Value;
//    fseAmount.Value:= FChosen.Amount.DisplayValue;
//    fsePercentage.Value:= FChosen.Percentage.Value;
    cbFlexible.Checked:= FChosen.AdjustToTotal100.Value;

    eOrigin.Text:= FChosen.Origin.Value;
    eSupplier.Text:= FChosen.Supplier.Value;
    cbType.ItemIndex:= cbType.Items.IndexOf(FermentableTypeDisplayNames[FChosen.FermentableType]);
    cbGrainType.ItemIndex:= cbGrainType.Items.IndexOf(GrainTypeDisplayNames[FChosen.GrainType]);
    cbAdded.ItemIndex:= cbAdded.Items.IndexOf(AddedTypeDisplayNames[FChosen.AddedType]);
    cbAddAfterBoil.Checked:= FChosen.AddAfterBoil.Value;
    cbRecommendMash.Checked:= FChosen.RecommendMash.Value;

    SetControl(fseAmount, lAmount, FChosen.Amount, TRUE);
//    lAmount.Caption:= UnitNames[FChosen.Amount.DisplayUnit];
    SetControl(fseMaxInBatch, lMaxInBatch, FChosen.MaxInBatch, TRUE);

    SetControl(fseYield, lblYield, FChosen.Yield, TRUE);
    SetControl(fseColor, lblColor, FChosen.Color, TRUE);
    SetControl(fseCoarseFineDiff, lblCoarseFineDiff, FChosen.CoarseFineDiff, TRUE);
    SetControl(fseMoisture, lblMoisture, FChosen.Moisture, TRUE);
    SetControl(fseDiastaticPower, lblDiastaticPower, FChosen.DiastaticPower, TRUE);
    SetControl(fseProtein, lblProtein, FChosen.Protein, TRUE);
    SetControl(fseCost, lblCost, FChosen.Cost, TRUE);
    Setcontrol(fseDIpH, lblDIpH, FChosen.DIpH, TRUE);
    SetControl(fseBaseTo57, lblBaseTo57, FChosen.AcidTo57, TRUE);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmFermentables2.FillcbName;
var i : integer;
    s : string;
    Fr : TFermentable;
begin
  if (FFermentable <> NIL) and (FOriginal <> NIL) then
  begin
    cbName.Clear;
    s:= FOriginal.Supplier.Value + ' - ' + FOriginal.Name.Value + ' (' + FOriginal.Color.DisplayString + ')';
    cbName.AddItem(s, FOriginal);
    Fermentables.SortByIndex2(17, 0, false);
    for i:= 0 to Fermentables.NumItems - 1 do
    begin
      Fr:= TFermentable(Fermentables.Item[i]);
      if (not InRecipe(Fr)) and ((not cbOnlyInStock.Checked)
          or ((cbOnlyInStock.Checked) and (Fr.Inventory.Value > 0))) then
      begin
        s:= Fr.Supplier.Value + ' - ' + Fr.Name.Value + ' (' + Fr.Color.DisplayString + ')';
        cbName.AddItem(s, Fermentables.Item[i]);
      end;
    end;
    cbName.ItemIndex:= 0;
  end;
end;

Function TFrmFermentables2.InRecipe(F : TFermentable) : boolean;
var i : integer;
    Fr : TFermentable;
begin
  Result:= false;
  for i:= 0 to FRec.NumFermentables - 1 do
  begin
    Fr:= FRec.Fermentable[i];
    if (Fr.Name.Value = F.Name.Value) and (Fr.Supplier.Value = F.Supplier.Value) and
       (Fr.Color.Value = F.Color.Value) then Result:= TRUE;
  end;
end;

Function TFrmFermentables2.Execute(F : TFermentable; perc : boolean; tot : double) : boolean;
var i : integer;
    s : string;
    Fr : TFermentable;
begin
  FRec:= F.Recipe;
  FFermentable:= F;
  FOriginal.Assign(F);
  FOriginal.Recipe:= F.Recipe;
  FChosen.Assign(F);
  FChosen.Recipe:= F.Recipe;
  FTotal:= tot;
  fseAmount.Enabled:= not perc;
  cbFlexible.Enabled:= perc;
  fsePercentage.Enabled:= perc and (not cbFlexible.Checked);
  FOldAmount:= F.Amount.Value;
  FillcbName;
  if F <> NIL then
  begin
    SetControls;
    fseAmount.Value:= FFermentable.Amount.DisplayValue;
    fsePercentage.Value:= FFermentable.Percentage.Value;
  end;
  Result:= (ShowModal = mrOK);
  if Result then
  begin
    Store;
    if ((FChosen.Supplier.Value <> FOriginal.Supplier.Value) or
       (FChosen.Name.Value <> FOriginal.Name.Value)) and
       (Fermentables.FindByNameAndSupplier(FOriginal.Name.Value, FOriginal.Supplier.Value) = NIL) then
      //Original fermenable is not in the database, so it is a strange, imported one
      //put the replacement and original in the substitutions database
        FermentableSubs.Add(FOriginal.Name.Value, FOriginal.Supplier.Value,
                            FChosen.Name.Value, FChosen.Supplier.Value);
  end;
end;

procedure TFrmFermentables2.fseColorChange(Sender: TObject);
begin
{  if lblColor.Caption = 'EBC' then shColor.Brush.Color:= EBCtoColor(fseColor.Value)
  else shColor.Brush.Color:= SRMtoColor(fseColor.Value);}
end;

Procedure TFrmFermentables2.Store;
begin
  if FFermentable <> NIL then
  begin
    FChosen.Notes.Value:= mNotes.Text;
    FChosen.Amount.DisplayValue:= fseAmount.Value;
    FChosen.Percentage.Value:= fsePercentage.Value;
    FChosen.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    FChosen.GrainTypeDisplayName:= cbGrainType.Items[cbGrainType.ItemIndex];
    FChosen.AddedTypeDisplayName:= cbAdded.Items[cbAdded.ItemIndex];
    FChosen.Origin.Value:= eOrigin.Text;
    FChosen.Supplier.Value:= eSupplier.Text;
    FChosen.MaxInBatch.Value:= fseMaxInBatch.Value;
    FChosen.AddAfterBoil.Value:= cbAddAfterBoil.Checked;
    FChosen.RecommendMash.Value:= cbRecommendMash.Checked;
    FChosen.Yield.Value:= fseYield.Value;
    FChosen.Color.DisplayValue:= fseColor.Value;
    FChosen.CoarseFineDiff.Value:= fseCoarseFineDiff.Value;
    FChosen.Moisture.Value:= fseMoisture.Value;
    FChosen.DiastaticPower.DisplayValue:= fseDiastaticPower.Value;
    FChosen.Protein.Value:= fseProtein.Value;
    FChosen.Recipe:= FFermentable.Recipe;
    FChosen.AdjustToTotal100.Value:= cbFlexible.Checked;
    FChosen.Cost.DisplayValue:= fseCost.Value;
    FChosen.DIpH.Value:= fseDIpH.Value;
    FChosen.AcidTo57.Value:= fseBaseTo57.Value;
    FFermentable.Assign(FChosen);
  end;
end;

procedure TFrmFermentables2.bbAddClick(Sender: TObject);
begin

end;

procedure TFrmFermentables2.bbDeleteClick(Sender: TObject);
begin

end;

procedure TFrmFermentables2.bbOKClick(Sender: TObject);
begin
  Store;
end;

procedure TFrmFermentables2.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmFermentables2.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FillcbName;
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

procedure TFrmFermentables2.cbTypeChange(Sender: TObject);
begin
  cbGrainType.Enabled:= (cbType.ItemIndex = 0);
  if not cbGrainType.Enabled then cbGrainType.ItemIndex:= 6;
end;

procedure TFrmFermentables2.fseAmountChange(Sender: TObject);
begin
  if (FTotal > 0) and (fseAmount.Enabled) and FUserclicked then
  begin
    FUserclicked:= false;
    fsePercentage.Value:= 100 * fseAmount.Value / (FTotal + (fseAmount.Value - FOldAmount));
    FUserclicked:= TRUE;
  end;
end;

procedure TFrmFermentables2.fsePercentageChange(Sender: TObject);
begin
  if fsePercentage.Enabled and FUserclicked then
  begin
    FUserclicked:= false;
    fseAmount.Value:= fsePercentage.Value / 100 * FTotal;
    FUserclicked:= TRUE;
  end;
end;

procedure TFrmFermentables2.cbFlexibleChange(Sender: TObject);
var i : integer;
    tot : double;
    Fr : TFermentable;
begin
  if FUserclicked and cbFlexible.Enabled then
  begin
    if cbFlexible.Checked then
    begin
      FUserclicked:= false;
      FChosen.AdjustToTotal100.Value:= cbFlexible.Checked;
      tot:= 0;
      for i:= 0 to FRec.NumFermentables - 1 do
      begin
        Fr:= TFermentable(FRec.Fermentable[i]);
        if (Fr.Name.Value <> FOriginal.Name.Value) and
           (Fr.Supplier.Value <> FOriginal.Supplier.Value) then
          tot:= tot + Fr.Percentage.Value;
      end;
      FUserclicked:= TRUE;
      fsePercentage.Value:= 100 - tot;
    end;
    fsePercentage.Enabled:= not cbFlexible.Checked;
  end;
end;

procedure TFrmFermentables2.cbNameChange(Sender: TObject);
var b : boolean;
    am, perc : double;
begin
  b:= cbFlexible.Checked;
  am:= FChosen.Amount.Value;
  perc:= FChosen.Percentage.Value;
  FChosen.Assign(TFermentable(cbName.Items.Objects[cbName.ItemIndex]));
  FChosen.Amount.Value:= am;
  FChosen.Percentage.Value:= perc;
  FChosen.AdjustToTotal100.Value:= b;
  SetControls;
end;

end.

