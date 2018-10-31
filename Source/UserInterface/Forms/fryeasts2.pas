unit FrYeasts2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, EditBtn, Data;

type

  { TFrmYeasts2 }

  TFrmYeasts2 = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbType: TComboBox;
    cbYeastForm: TComboBox;
    cbFlocculation: TComboBox;
    cbOnlyInStock: TCheckBox;
    deCultureDate: TDateEdit;
    eProductID: TEdit;
    eLaboratory: TEdit;
    fseCost: TFloatSpinEdit;
    fseAmount: TFloatSpinEdit;
    fseAttenuation: TFloatSpinEdit;
    fseMinTemperature: TFloatSpinEdit;
    fseMaxTemperature: TFloatSpinEdit;
    gbUse: TGroupBox;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    lCost2: TLabel;
    lCost: TLabel;
    lAmount: TLabel;
    Label17: TLabel;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lMintemp: TLabel;
    lMaxtemp: TLabel;
    lAttenuation: TLabel;
    mBestFor: TMemo;
    mNotes: TMemo;
    pEdit: TPanel;
    seMaxReuse: TSpinEdit;
    seReuse: TSpinEdit;
    cbName: TComboBox;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbYeastFormChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseMaxTemperatureChange(Sender: TObject);
    procedure fseMinTemperatureChange(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cbNameChange(Sender: TObject);
  private
    { private declarations }
    FYeast, FOriginal, FChosen : TYeast;
    FUserClicked : boolean;
    Procedure Store;
    Procedure SetControls;
    procedure FillcbName;
  public
    { public declarations }
    Function Execute(Y : TYeast) : boolean;
  end; 

var
  FrmYeasts2: TFrmYeasts2;

implementation

{$R *.lfm}
uses Hulpfuncties, Containers, subs;

{ TFrmYeasts2 }

procedure TFrmYeasts2.FormCreate(Sender: TObject);
var yt : TYeastType;
    yf : TYeastForm;
    fl : TFlocculation;
begin
  FUserClicked:= false;
  cbType.Items.Clear;
  for yt:= Low(YeastTypeDisplayNames) to High(YeastTypeDisplayNames) do
    cbType.Items.Add(YeastTypeDisplayNames[yt]);
  cbType.ItemIndex:= 0;
  cbYeastForm.Items.Clear;
  for yf:= Low(YeastFormDisplayNames) to High(YeastFormDisplayNames) do
    cbYeastForm.Items.Add(YeastFormDisplayNames[yf]);
  cbYeastForm.ItemIndex:= 0;
  cbFlocculation.Items.Clear;
  for fl:= Low(FlocculationDisplayNames) to High(FlocculationDisplayNames) do
    cbFlocculation.Items.Add(FlocculationDisplayNames[fl]);
  cbFlocculation.ItemIndex:= 0;
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  FOriginal:= TYeast.Create(nil);
  FChosen:= TYeast.Create(nil);

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FUserClicked:= TRUE;
end;

procedure TFrmYeasts2.FormDestroy(Sender: TObject);
begin
  FOriginal.Free;
  FChosen.Free;
end;

procedure TFrmYeasts2.cbYeastFormChange(Sender: TObject);
begin
  FChosen.FormDisplayName:= cbYeastForm.Items[cbYeastForm.ItemIndex];
  lAmount.Caption:= FChosen.AmountYeast.DisplayUnitString;
end;

procedure TFrmYeasts2.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FillcbName;
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

Procedure TFrmYeasts2.SetControls;
begin
  if FChosen <> NIL then
  begin
//    eName.Text:= FYeast.Name.Value;
    eProductID.Text:= FChosen.ProductID.Value;
    mNotes.Text:= FChosen.Notes.Value;

//    fseAmount.Value:= FYeast.Amount.DisplayValue;
    seReuse.Value:= FChosen.TimesCultured.Value;
    deCultureDate.Date:= FChosen.CultureDate.Value;

    eLaboratory.Text:= FChosen.Laboratory.Value;
    cbType.ItemIndex:= cbType.Items.IndexOf(YeastTypeDisplayNames[FChosen.YeastType]);
    cbYeastForm.ItemIndex:= cbYeastForm.Items.IndexOf(YeastFormDisplayNames[FChosen.Form]);
//    lAmount.Caption:= FChosen.Amount.DisplayUnitString;
    lAmount.Caption:= FChosen.AmountYeast.DisplayUnitString;

    cbFlocculation.ItemIndex:= cbFlocculation.Items.IndexOf(FlocculationDisplayNames[FChosen.Flocculation]);

    cbFlocculation.ItemIndex:= cbFlocculation.Items.IndexOf(FlocculationDisplayNames[FChosen.Flocculation]);
    SetControl(fseMinTemperature, lMinTemp, FChosen.MinTemperature, TRUE);
    SetControl(fseMaxTemperature, lMaxTemp, FChosen.MaxTemperature, TRUE);
    SetControl(fseAttenuation, lAttenuation, FChosen.Attenuation, TRUE);
    SetControl(fseCost, lCost, FChosen.Cost, TRUE);
    lCost2.Caption:= '/' + FChosen.AmountYeast.DisplayUnitString;
    mBestFor.Text:= FChosen.BestFor.Value;
    seMaxReuse.Value:= FChosen.MaxReuse.Value;
  end;
end;

Procedure TFrmYeasts2.FillcbName;
var i : integer;
    s : string;
    Ye : TYeast;
begin
  if FYeast <> NIL then
  begin
    cbName.Clear;
    s:= FOriginal.Laboratory.Value + ' - ' + FOriginal.ProductID.Value + ' ' + FOriginal.Name.Value;
    cbName.AddItem(s, FOriginal);
    Yeasts.SortByIndex2(5, 6, false);
    for i:= 0 to Yeasts.NumItems - 1 do
    begin
      Ye:= TYeast(Yeasts.Item[i]);
      if (not cbOnlyInStock.Checked) or ((cbOnlyInStock.Checked) and (Ye.Inventory.Value > 0)) then
      begin
        s:= Ye.Laboratory.Value + ' - ' + Ye.ProductID.Value + ' ' + Ye.Name.Value;;
        cbName.AddItem(s, Yeasts.Item[i]);
      end;
    end;
    cbName.ItemIndex:= 0;
  end;
end;

Function TFrmYeasts2.Execute(Y : TYeast) : boolean;
var i : integer;
    s : string;
    Ye : TYeast;
begin
  FYeast:= Y;
  FOriginal.Assign(Y);
  FOriginal.Recipe:= Y.Recipe;
  FChosen.Assign(Y);
  FChosen.Recipe:= Y.Recipe;
  FillcbName;
  if FYeast <> NIL then
  begin
    SetControls;
    fseAmount.Value:= FYeast.AmountYeast.DisplayValue;

    Result:= ShowModal = mrOK;

    if Result then
    begin
      Store;
      if ((FChosen.Laboratory.Value <> FOriginal.Laboratory.Value) or
         (FChosen.Name.Value <> FOriginal.Name.Value)) and
         (Yeasts.FindByNameAndLaboratory(FOriginal.Name.Value, FOriginal.Laboratory.Value) = NIL) then
        //Original fermenable is not in the database, so it is a strange, imported one
        //put the replacement and original in the substitutions database
          YeastSubs.Add(FOriginal.Name.Value, FOriginal.Laboratory.Value,
                        FChosen.Name.Value, FChosen.Laboratory.Value);
    end;
  end;
end;

Procedure TFrmYeasts2.Store;
begin
  if FYeast <> NIL then
  begin
//    FYeast.Name.Value:= eName.Text;
    FChosen.ProductID.Value:= eProductID.Text;
    FChosen.Notes.Value:= mNotes.Text;
    FChosen.FormDisplayName:= cbYeastForm.Items[cbYeastForm.ItemIndex];
//    FChosen.Amount.DisplayValue:= fseAmount.Value;
    FChosen.AmountYeast.DisplayValue:= fseAmount.Value;
    FChosen.CalcAmountYeast;
    FChosen.TimesCultured.Value:= seReuse.Value;
    FChosen.CultureDate.Value:= deCultureDate.Date;
    FChosen.TypeDisplayName:= cbType.Items[cbType.ItemIndex];

    FChosen.Laboratory.Value:= eLaboratory.Text;
    FChosen.FlocculationDisplayName:= cbFlocculation.Items[cbFlocculation.ItemIndex];
    FChosen.MinTemperature.DisplayValue:= fseMinTemperature.Value;
    FChosen.MaxTemperature.DisplayValue:= fseMaxTemperature.Value;
    FChosen.Attenuation.DisplayValue:= fseAttenuation.Value;
    FChosen.BestFor.Value:= mBestFor.Text;
    FChosen.MaxReuse.Value:= seMaxReuse.Value;
    FChosen.Cost.DisplayValue:= fseCost.Value;
    FChosen.Recipe:= FYeast.Recipe;
    FYeast.Assign(FChosen);
  end;
end;

procedure TFrmYeasts2.fseMinTemperatureChange(Sender: TObject);
begin
  if fseMinTemperature.Value > fseMaxTemperature.Value then
    fseMaxTemperature.Value:= fseMinTemperature.Value + 2;
end;

procedure TFrmYeasts2.fseMaxTemperatureChange(Sender: TObject);
begin
  if fseMaxTemperature.Value < fseMinTemperature.Value then
    fseMinTemperature.Value:= fseMaxTemperature.Value - 2;
end;

procedure TFrmYeasts2.cbNameChange(Sender: TObject);
var am : double;
begin
  am:= FChosen.Amount.Value;
  FChosen.Assign(TYeast(cbName.Items.Objects[cbName.ItemIndex]));
  FChosen.Amount.Value:= am;
  SetControls;
end;


end.

