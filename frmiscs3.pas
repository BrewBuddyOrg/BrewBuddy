unit frmiscs3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ComCtrls, StdCtrls, Spin, Buttons, Data, Containers;

type

  { TFrmMiscs3 }

  TFrmMiscs3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbUse: TComboBox;
    cbOnlyInStock: TCheckBox;
    fseAmount: TFloatSpinEdit;
    hcIngredients: THeaderControl;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lTime: TLabel;
    lAmount: TLabel;
    sgIngredients: TStringGrid;
    Label2: TLabel;
    eSearch: TEdit;
    SpeedButton1: TSpeedButton;
    fseTime: TFloatSpinEdit;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbUseChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
    procedure eSearchChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    FMisc : TMisc;
    FSort : integer;
    FSortDec, FUserClicked : boolean;
    FMiscList : array of TMisc;
    Procedure SortGrid(Nr1, Nr2 : integer);
  public
    { public declarations }
    Function Execute(M : TMisc) : boolean;
  end; 

var
  FrmMiscs3: TFrmMiscs3;

implementation

{$R *.lfm}

uses Hulpfuncties, StrUtils;

procedure TFrmMiscs3.FormCreate(Sender: TObject);
var i : integer;
    mu : TMiscUse;
begin
  FUSerClicked:= false;
  {$ifdef Windows}
  hcIngredients.Font.Height:= 0;
  sgIngredients.Font.Height:= 0;
  {$endif}

  with sgIngredients do
  begin
    ColCount:= 3;
    RowCount:= Miscs.NumItems;
    for i:= 0 to ColCount - 1 do
      ColWidths[i]:= hcIngredients.Sections[i].Width;
  end;

  cbUse.Items.Clear;
  for mu:= Low(MiscUseDisplayNames) to High(MiscUseDisplayNames) do
    cbUse.Items.Add(MiscUseDisplayNames[mu]);

  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  FSortDec:= false;
  FSort:= -1;
  SortGrid(0, 8);
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FUserclicked:= TRUE;
end;

procedure TFrmMiscs3.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FSort := -1;
    FSortDec := false;
    SortGrid(0, 8);
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

procedure TFrmMiscs3.cbUseChange(Sender: TObject);
begin
  FMisc.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
  case FMisc.Use of
    muStarter: FMisc.Time.DisplayUnit:= uur;
    muMash, muBoil: FMisc.Time.DisplayUnit:= minuut;
    muPrimary, muSecondary, muBottling: FMisc.Time.DisplayUnit:= dag;
  end;
  lTime.Caption:= FMisc.Time.DisplayUnitString;
  fseTime.Value:= FMisc.Time.DisplayValue;
end;

Procedure TFrmMiscs3.SortGrid(Nr1, Nr2 : integer);
var i, j : integer;
    M : TMisc;
begin
  if FSort = Nr1 then FSortDec:= not FSortDec
  else FSortDec:= false;
  FSort:= Nr1;

  Miscs.SortByIndex2(Nr1, Nr2, FSortDec);

  j:= 0;
  SetLength(FMiscList, 0);
  sgIngredients.RowCount:= 0;

  for i:= 0 to Miscs.NumItems - 1 do
  begin
    M:= TMisc(Miscs.Item[i]);
    if (M <> NIL) and ((not cbOnlyInStock.Checked) or
        ((cbOnlyInStock.Checked) and (M.Inventory.Value > 0))) then
    begin
      Inc(j);
      SetLength(FMiscList, j);
      FMiscList[j-1]:= M;
      sgIngredients.RowCount:= j;
      sgIngredients.Cells[0, j-1]:= M.Name.Value;
      sgIngredients.Cells[1, j-1]:= MiscTypeDisplayNames[M.MiscType];
      sgIngredients.Cells[2, j-1]:= M.Inventory.DisplayString;
    end;
  end;
  If High(FMiscList) < 0 then
  begin
    Settings.ShowOnlyInStock.Value:= false;
    Settings.Save;
    cbOnlyInStock.Checked:= false;
    for i:= 0 to Miscs.NumItems - 1 do
    begin
      M:= TMisc(Miscs.Item[i]);
      if (M <> NIL) and ((not cbOnlyInStock.Checked) or
          ((cbOnlyInStock.Checked) and (M.Inventory.Value > 0))) then
      begin
        Inc(j);
        SetLength(FMiscList, j);
        FMiscList[j-1]:= M;
        sgIngredients.RowCount:= j;
        sgIngredients.Cells[0, j-1]:= M.Name.Value;
        sgIngredients.Cells[1, j-1]:= MiscTypeDisplayNames[M.MiscType];
        sgIngredients.Cells[2, j-1]:= M.Inventory.DisplayString;
      end;
    end;
  end;
  for i:= 0 to sgIngredients.ColCount - 1 do
    sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
end;

procedure TFrmMiscs3.sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if (sgIngredients.Row >= 0) and (sgIngredients.Row <= High(FMiscList))
      and (FMiscList[sgIngredients.Row] <> NIL) then
  begin
    FMisc.Assign(FMiscList[sgIngredients.Row]);
    FMisc.Amount.DisplayValue:= fseAmount.Value;
    cbUse.ItemIndex:= cbUse.Items.IndexOf(MiscUseDisplayNames[FMisc.Use]);
    FMisc.Time.DisplayValue:= fseTime.Value;
    lTime.Caption:= FMisc.Time.DisplayUnitString;
  end;
end;

procedure TFrmMiscs3.eSearchChange(Sender: TObject);
var i, n : integer;
    s, sn : string;
begin
  n:= -1;
  s:= Lowercase(eSearch.Text);
  for i:= 0 to sgIngredients.RowCount - 1 do
  begin
    sn:= LowerCase(FMiscList[i].Name.Value);
    if s = '' then
    begin
      sgIngredients.RowHeights[i]:= 23;
      n:= 0;
    end
    else
      if NPos(s, sn, 1) = 0 then
        sgIngredients.RowHeights[i]:= 0
      else
      begin
        sgIngredients.RowHeights[i]:= 23;
        if n = -1 then n:= i;
      end;
  end;
  if n > -1 then
  begin
    sgIngredients.Row:= n;
    sgIngredientsSelection(Self, 0, n);
  end;
  fseAmount.Enabled:= (n > -1);
  fseTime.Enabled:= fseAmount.Enabled;
end;

procedure TFrmMiscs3.SpeedButton1Click(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmMiscs3.hcIngredientsSectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.Index of
  0: SortGrid(0, 5);
  1: SortGrid(5, 0);
  2: SortGrid(3, 0);
  end;
  eSearchChange(self);
end;

Function TFrmMiscs3.Execute(M : TMisc) :  boolean;
var n : Longint;
begin
  FMisc:= TMisc.Create(NIL);
  FMisc.Assign(M);
  Result:= false;
  fseAmount.Value:= 0;
  lAmount.Caption:= M.Amount.DisplayUnitString;
  lTime.Caption:= M.Time.DisplayUnitString;
  cbUse.ItemIndex:= cbUse.Items.IndexOf(MiscUseDisplayNames[M.Use]);

  sgIngredients.Row:= 0;
  FMisc.Assign(TMisc(Miscs.Item[0]));
  FMisc.Amount.DisplayValue:= fseAmount.Value;
  FMisc.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
  FMisc.Time.DisplayValue:= fseTime.Value;

  Result:= (ShowModal = mrOK);

  if Result then
  begin
    n:= sgIngredients.Row;
    if (n >= 0) and (n <= High(FMiscList)) and (FMiscList[n] <> NIL) then
    begin
      M.Assign(FMiscList[sgIngredients.Row]);
      M.Amount.DisplayValue:= fseAmount.Value;
      M.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
      M.Time.DisplayValue:= fseTime.Value;
    end;
  end;
  SetLength(FMiscList, 0);
  FMisc.Free;
end;

end.

