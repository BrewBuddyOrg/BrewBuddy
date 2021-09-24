unit FrMiscs2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, Data;

type

  { TFrmMiscs2 }

  TFrmMiscs2 = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbType: TComboBox;
    cbUse: TComboBox;
    cbOnlyInStock: TCheckBox;
    fseFreeField: TFloatSpinEdit;
    fseCost: TFloatSpinEdit;
    fseAmount: TFloatSpinEdit;
    fseTime: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    lblFreeFieldUnit: TLabel;
    lblFreeField: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lCost: TLabel;
    lAmount: TLabel;
    lTime: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    mUseFor: TMemo;
    mNotes: TMemo;
    pEdit: TPanel;
    cbName: TComboBox;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbUseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbNameChange(Sender: TObject);
  private
    FMisc, FOriginal, FChosen : TMisc;
    FUserClicked : boolean;
    Procedure Store;
    Procedure SetControls;
    procedure FillcbName;
  public
    Function Execute(M : TMisc) : boolean;
  end; 

var
  FrmMiscs2: TFrmMiscs2;

implementation

{$R *.lfm}
uses Hulpfuncties, Containers;

{ TFrmMiscs2 }

procedure TFrmMiscs2.FormCreate(Sender: TObject);
var mt : TMiscType;
    mu : TMiscUse;
begin
  FUserClicked:= false;
  cbType.Items.Clear;
  for mt:= Low(MiscTypeDisplayNames) to High(MiscTypeDisplayNames) do
    cbType.Items.Add(MiscTypeDisplayNames[mt]);
  cbType.ItemIndex:= 0;
  cbUse.Items.Clear;
  for mu:= Low(MiscUseDisplayNames) to High(MiscUseDisplayNames) do
    cbUse.Items.Add(MiscUseDisplayNames[mu]);
  cbUse.ItemIndex:= 0;
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  FOriginal:= TMisc.Create(nil);
  FChosen:= TMisc.Create(nil);

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FUserClicked:= TRUE;
end;

procedure TFrmMiscs2.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FillcbName;
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

procedure TFrmMiscs2.cbUseChange(Sender: TObject);
begin
  FChosen.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
  case FChosen.Use of
    muStarter: FChosen.Time.DisplayUnit:= uur;
    muMash, muBoil: FChosen.Time.DisplayUnit:= minuut;
    muPrimary, muSecondary, muBottling: FChosen.Time.DisplayUnit:= dag;
  end;
  lTime.Caption:= FChosen.Time.DisplayUnitString;
  fseTime.Value:= FChosen.Time.DisplayValue;
end;

procedure TFrmMiscs2.FormDestroy(Sender: TObject);
begin
  FOriginal.Free;
  FChosen.Free;
end;

procedure TFrmMiscs2.cbNameChange(Sender: TObject);
var am : double;
begin
  Am:= FChosen.Amount.Value;
  FChosen.Assign(TMisc(cbName.Items.Objects[cbName.ItemIndex]));
  FChosen.Amount.Value:= Am;
  SetControls;
end;

Procedure TFrmMiscs2.Store;
begin
  if FMisc <> NIL then
  begin
//    FMisc.Name.Value:= eName.Text;
    FChosen.Notes.Value:= mNotes.Text;
    FChosen.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    FChosen.UseFor.Value:= mUseFor.Text;
    FChosen.Amount.DisplayValue:= fseAmount.Value;
    FChosen.Time.DisplayValue:= fseTime.Value;
    FChosen.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
    FChosen.Cost.DisplayValue:= fseCost.Value;
    FChosen.Recipe:= FMisc.Recipe;
    if FChosen.FreeFieldName.Value <> '' then
      FChosen.FreeField.Value:= fseFreeField.Value;
    FMisc.Assign(FChosen);
  end;
end;

procedure TFrmMiscs2.SetControls;
begin
  if FChosen <> NIL then
  begin
    lAmount.Caption:= UnitNames[FChosen.Amount.DisplayUnit];
    lTime.Caption:= UnitNames[FChosen.Time.DisplayUnit];
//    eName.Text:= FChosen.Name.Value;
    mNotes.Text:= FChosen.Notes.Value;
    mUseFor.Text:= FChosen.UseFor.Value;
    cbType.ItemIndex:= cbType.Items.IndexOf(MiscTypeDisplayNames[FChosen.MiscType]);
    SetControl(fseAmount, lAmount, FChosen.Amount, TRUE);
    SetControl(fseTime, lTime, FChosen.Time, TRUE);
    SetControl(fseCost, lCost, FChosen.Cost, TRUE);
    cbUse.ItemIndex:= cbUse.Items.IndexOf(MiscUseDisplayNames[FChosen.Use]);

    lblFreeField.Visible:= FChosen.FreeFieldName.Value <> '';
    fseFreeField.Visible:= lblFreeField.Visible;
    lblFreeFieldUnit.Visible:= lblFreeField.Visible;
    if FChosen.FreeFieldName.Value <> '' then
    begin
      SetControl(fseFreeField, lblFreeFieldUnit, FChosen.FreeField, TRUE);
      lblFreeField.Caption:= FChosen.FreeFieldName.Value + ':';
      fseFreeField.DecimalPlaces:= FChosen.FreeField.Decimals;
    end;
  end;
end;

procedure TFrmMiscs2.FillcbName;
var i : integer;
    s : string;
    Mi : TMisc;
begin
  if FMisc <> NIL then
  begin
    cbName.Clear;
    s:= MiscTypeDisplayNames[FOriginal.MiscType] + ' - ' + FOriginal.Name.Value;
    cbName.AddItem(s, FOriginal);
    Miscs.SortByIndex2(5, 0, false);
    for i:= 0 to Miscs.NumItems - 1 do
    begin
      Mi:= TMisc(Miscs.Item[i]);
      if (not cbOnlyInStock.Checked) or ((cbOnlyInStock.Checked) and (Mi.Inventory.Value > 0)) then
      begin
        s:= MiscTypeDisplayNames[Mi.MiscType] + ' - ' + Mi.Name.Value;
        cbName.AddItem(s, Miscs.Item[i]);
      end;
    end;
    cbName.ItemIndex:= 0;
  end;
end;

Function TFrmMiscs2.Execute(M : TMisc) : boolean;
begin
  Result:= false;
  FMisc:= M;
  FOriginal.Assign(M);
  FOriginal.Recipe:= M.Recipe;
  FChosen.Assign(M);
  FChosen.Recipe:= M.Recipe;
  FillcbName;
  if FMisc <> NIL then
  begin
    SetControls;
    fseAmount.Value:= FMisc.Amount.DisplayValue;
    fseTime.Value:= FMisc.Time.DisplayValue;
    if ShowModal = mrOK then
    begin
      Store;
      Result:= TRUE;
    end;
  end;
end;

end.

