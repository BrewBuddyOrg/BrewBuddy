unit FrFermentables3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ComCtrls, StdCtrls, Spin, Buttons, Data, Containers;

type

  { TFrmFermentables3 }

  TFrmFermentables3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbOnlyInStock: TCheckBox;
    fseAmount: TFloatSpinEdit;
    fsePerc: TFloatSpinEdit;
    hcIngredients: THeaderControl;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lAmount: TLabel;
    sgIngredients: TStringGrid;
    Label4: TLabel;
    eSearch: TEdit;
    SpeedButton1: TSpeedButton;
    cbFlexible: TCheckBox;
    Label5: TLabel;
    cbAdded: TComboBox;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure fseAmountChange(Sender: TObject);
    procedure fsePercChange(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
    procedure eSearchChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure cbFlexibleChange(Sender: TObject);
    Procedure BitBtn1Click(Sender : TObject);
  private
    Ftot : double;
    FFerm : TFermentable;
    FSort : integer;
    FSortDec, FPerc, FUserClicked : boolean;
    FRecipe : TRecipe;
    FFermList : array of TFermentable;
    Procedure SortGrid(Nr1, Nr2 : integer);
    Function InRecipe(F : TFermentable) : boolean;
  public
    Function Execute(const F : TFermentable; prc : boolean) : boolean;
  end; 

var
  FrmFermentables3: TFrmFermentables3;

implementation

{$R *.lfm}

uses Hulpfuncties, strutils;

procedure TFrmFermentables3.FormCreate(Sender: TObject);
var i : integer;
    at : TAddedType;
begin
  {$ifdef Windows}
  hcIngredients.Font.Height:= 0;
  sgIngredients.Font.Height:= 0;
  {$endif}

  FFerm:= NIL;
  FRecipe:= NIL;
  for at:= Low(AddedTypeDisplayNames) to High(AddedTypeDisplayNames) do
    cbAdded.Items.Add(AddedTypeDisplayNames[at]);
  with sgIngredients do
  begin
    ColCount:= 4;
    RowCount:= Fermentables.NumItems;
    for i:= 0 to ColCount - 1 do
      ColWidths[i]:= hcIngredients.Sections[i].Width;
  end;
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;
  FSort := -1;
  FSortDec := false;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FUserClicked:= TRUE;
end;

procedure TFrmFermentables3.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
end;

Function TFrmFermentables3.InRecipe(F : TFermentable) : boolean;
var i : integer;
    Fr : TFermentable;
begin
  Result:= false;
  for i:= 0 to FRecipe.NumFermentables - 1 do
  begin
    Fr:= FRecipe.Fermentable[i];
    if (Fr.Name.Value = F.Name.Value) and (Fr.Supplier.Value = F.Supplier.Value) and
       (Fr.Color.Value = F.Color.Value) and (Fr.AddedType = F.AddedType) then Result:= TRUE;
  end;
end;

procedure TFrmFermentables3.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FSort := -1;
    FSortDec := false;
    SortGrid(17, 0);
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

Procedure TFrmFermentables3.SortGrid(Nr1, Nr2 : integer);
var i, j : integer;
    Fr : TFermentable;
begin
  if FSort = Nr1 then FSortDec:= not FSortDec
  else FSortDec:= false;
  FSort:= Nr1;
  Fermentables.SortByIndex2(Nr1, Nr2, FSortDec);

  j:= 0;
  SetLength(FFermList, 0);
  sgIngredients.RowCount:= 0;

  for i:= 0 to Fermentables.NumItems - 1 do
  begin
    Fr:= TFermentable(Fermentables.Item[i]);
    if (Fr <> NIL) and ((not cbOnlyInStock.Checked) or
        ((cbOnlyInStock.Checked) and (Fr.Inventory.Value > 0)))
        and (not InRecipe(Fr)) then
    begin
      Inc(j);
      SetLength(FFermList, j);
      FFermList[j-1]:= Fr;
      sgIngredients.RowCount:= j;
      sgIngredients.Cells[0, j-1]:= Fr.Supplier.Value;
      sgIngredients.Cells[1, j-1]:= Fr.Name.Value;
      sgIngredients.Cells[2, j-1]:= Fr.Color.DisplayString;
      sgIngredients.Cells[3, j-1]:= Fr.Inventory.DisplayString;
    end;
  end;
  if High(FFermList) < 0 then
  begin
    Settings.ShowOnlyInStock.Value:= false;
    Settings.Save;
    cbOnlyInStock.Checked:= false;
    for i:= 0 to Fermentables.NumItems - 1 do
    begin
      Fr:= TFermentable(Fermentables.Item[i]);
      if (Fr <> NIL) and ((not cbOnlyInStock.Checked) or
          ((cbOnlyInStock.Checked) and (Fr.Inventory.Value > 0))) then
      begin
        Inc(j);
        SetLength(FFermList, j);
        FFermList[j-1]:= Fr;
        sgIngredients.RowCount:= j;
        sgIngredients.Cells[0, j-1]:= Fr.Supplier.Value;
        sgIngredients.Cells[1, j-1]:= Fr.Name.Value;
        sgIngredients.Cells[2, j-1]:= Fr.Color.DisplayString;
        sgIngredients.Cells[3, j-1]:= Fr.Inventory.DisplayString;
      end;
    end;
  end;
  for i:= 0 to sgIngredients.ColCount - 1 do
    sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
end;

procedure TFrmFermentables3.fseAmountChange(Sender: TObject);
begin
  if fseAmount.Enabled and FUserClicked then
  begin
    FUserClicked:= false;
    FFerm.Amount.DisplayValue:= fseAmount.Value;
    if (FTot + FFerm.Amount.Value > 0) then
      fsePerc.Value:= 100 * FFerm.Amount.Value / (FTot + FFerm.Amount.Value);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmFermentables3.fsePercChange(Sender: TObject);
var d, x, x1, x2 : double;
begin
{  if (fsePerc.Enabled) and (Ftot + fseAmount.Value > 0) then
    fseAmount.Value:= Convert(kilogram, FFerm.Amount.DisplayUnit,
                              fsePerc.Value / 100 * (FTot + Convert(FFerm.Amount.DisplayUnit, kilogram, fseAmount.Value))); }
  if FUserClicked then
  begin
    FUserClicked:= false;
    FFerm.Percentage.Value:= fsePerc.Value;
    if fsePerc.Value < 100 then
      FFerm.Amount.Value:= fsePerc.Value * FTot / (100 - fsePerc.Value)
    else
    begin
      d:= SGtoPlato(FRecipe.EstOG.Value) * (FRecipe.BatchSize.Value * 10) / 1000;
      if (FFerm.AddedType = atMash) then
        d:= d / (FRecipe.Efficiency / 100);
      x1:= FFerm.Yield.Value;
      x2:= FFerm.Moisture.Value;
      x:= (x1 / 100) * (1 - x2 / 100);
      if x > 0 then
        FFerm.Amount.Value:= d / x;
    end;
    fseAmount.Value:= FFerm.Amount.DisplayValue;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmFermentables3.cbFlexibleChange(Sender: TObject);
begin
  FUserClicked:= false;
  fsePerc.Enabled:= not cbFlexible.Checked;
  FFerm.AdjustToTotal100.Value:= cbFlexible.Checked;
  FUserClicked:= TRUE;
end;

procedure TFrmFermentables3.hcIngredientsSectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.Index of
  0: SortGrid(17, 0);
  1: SortGrid(0, 2);
  2: SortGrid(7, 0);
  3: SortGrid(3, 0);
  end;
  eSearchChange(self);
end;

procedure TFrmFermentables3.sgIngredientsSelection(Sender: TObject; aCol,
  aRow: Integer);
begin
  if (sgIngredients.Row >= 0) and (sgIngredients.Row <= High(FFermList))
      and (FFermList[sgIngredients.Row] <> NIL) then
  begin
    FFerm.Assign(FFermList[sgIngredients.Row]);
    if FPerc then fsePercChange(self)
    else fseAmountChange(self);
    cbAdded.ItemIndex:= cbAdded.Items.IndexOf(AddedTypeDisplayNames[FFerm.AddedType]);
  end;
end;

procedure TFrmFermentables3.eSearchChange(Sender: TObject);
var i, n : integer;
    s, sn, sl : string;
begin
  n:= -1;
  s:= Lowercase(eSearch.Text);
  for i:= 0 to sgIngredients.RowCount - 1 do
  begin
    sn:= LowerCase(FFermList[i].Name.Value);
    sl:= LowerCase(FFermList[i].Supplier.Value);
    if s = '' then
    begin
      sgIngredients.RowHeights[i]:= 23;
      n:= 0;
    end
    else
      if (NPos(s, sn, 1) = 0) and (NPos(s, sl, 1) = 0) then
        sgIngredients.RowHeights[i]:= 0
      else
      begin
        sgIngredients.RowHeights[i]:= 23;
        if n = -1 then n:= i;
      end;
  end;
//  if f > -1 then f:= 0;
  if n > -1 then
  begin
    sgIngredients.Row:= n;
    sgIngredientsSelection(Self, 0, n);
  end;
  fseAmount.Enabled:= (n > -1) and (not FPerc);
  fsePerc.Enabled:= (n > -1) and (FPerc);
end;

procedure TFrmFermentables3.SpeedButton1Click(Sender: TObject);
begin
  eSearch.Text:= '';
end;

Procedure TFrmFermentables3.BitBtn1Click(Sender : TObject);
begin
  if FFerm.Amount.Value = 0 then
    fseAmount.Value:= 1;
end;

Function TFrmFermentables3.Execute(const F : TFermentable; prc : boolean) :  boolean;
var n : longint;
    perc : double;
begin
//  FFerm:= F;
  FFerm:= TFermentable.Create(F.Recipe);
  FFerm.Assign(F);
  FRecipe:= FFerm.Recipe;
  Result:= false;
  SortGrid(17, 0);
  FPerc:= prc;
  fseAmount.Value:= 0;
  lAmount.Caption:= UnitNames[FFerm.Amount.DisplayUnit];
  fsePerc.Value:= 0;
  cbAdded.ItemIndex:= cbAdded.Items.IndexOf(AddedTypeDisplayNames[FFerm.AddedType]);
  FTot:= FRecipe.TotalFermentableMass;
  if (FTot = 0) and prc then
  begin
    fsePerc.Value:= 100;
    fsePerc.Enabled:= false;
    cbFlexible.Enabled:= TRUE;
    cbFlexible.Checked:= TRUE;
  end
  else
  begin
    fsePerc.Enabled:= FPerc;
    cbFlexible.Enabled:= FPerc;
    cbFlexible.Checked:= false;
  end;
  fseAmount.Enabled:= (not FPerc);// or (FTot = 0);
  Result:= (ShowModal = mrOK);
  if Result then
  begin
    n:= sgIngredients.Row;
    if (n >= 0) and (n <= High(FFermList)) and (FFermList[n] <> NIL) then
    begin
      FFerm.Assign(FFermList[n]);
      FFerm.AddedTypeDisplayName:= cbAdded.Items[cbAdded.ItemIndex];
      if FPerc then
      begin
        perc:= fsePerc.Value;
        FFerm.Percentage.Value:= perc;
        FFerm.AdjustToTotal100.Value:= cbFlexible.Checked;
      end
      else
        FFerm.Amount.DisplayValue:= fseAmount.Value;
      F.Assign(FFerm);
    end;
    FFerm.Free;
    FFerm:= NIL;
  end;
  SetLength(FFermList, 0);
end;

end.

