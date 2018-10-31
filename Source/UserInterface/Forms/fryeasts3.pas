unit fryeasts3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ComCtrls, StdCtrls, Spin, Buttons, Data, Containers;

type

  { TFrmYeasts3 }

  TFrmYeasts3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbSecondary: TCheckBox;
    cbOnlyInStock: TCheckBox;
    fseAmount: TFloatSpinEdit;
    hcIngredients: THeaderControl;
    Label1: TLabel;
    Label2: TLabel;
    lAmount: TLabel;
    sgIngredients: TStringGrid;
    seTimesCultured: TSpinEdit;
    Label3: TLabel;
    eSearch: TEdit;
    SpeedButton1: TSpeedButton;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
    procedure eSearchChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    FYeast : TYeast;
    FSort : integer;
    FSortDec, FUserClicked : boolean;
    FYeastList : array of TYeast;
    Procedure SortGrid(Nr1, Nr2 : integer);
  public
    { public declarations }
    Function Execute(Y : TYeast) : boolean;
  end; 

var
  FrmYeasts3: TFrmYeasts3;

implementation

{$R *.lfm}

uses Hulpfuncties, strutils;

procedure TFrmYeasts3.FormCreate(Sender: TObject);
var i : integer;
begin
  FUserClicked:= false;

  with sgIngredients do
  begin
    ColCount:= 6;
    RowCount:= Yeasts.NumItems;
    for i:= 0 to ColCount - 1 do
      ColWidths[i]:= hcIngredients.Sections[i].Width;
  end;
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  FSortDec:= false;
  FSort:= -1;
  SortGrid(5, 6);
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FUserClicked:= TRUE;
end;

procedure TFrmYeasts3.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserclicked then
  begin
    FSortDec:= false;
    FSort:= -1;
    SortGrid(5, 6);
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

Procedure TFrmYeasts3.SortGrid(Nr1, Nr2 : integer);
var i, j : integer;
    Y : TYeast;
begin
  if FSort = Nr1 then FSortDec:= not FSortDec
  else FSortDec:= false;
  FSort:= Nr1;

  Yeasts.SortByIndex2(Nr1, Nr2, FSortDec);

  j:= 0;
  SetLength(FYeastList, 0);
  sgIngredients.RowCount:= 0;

  for i:= 0 to Yeasts.NumItems - 1 do
  begin
    Y:= TYeast(Yeasts.Item[i]);
    if (Y <> NIL) and ((not cbOnlyInStock.Checked) or
        ((cbOnlyInStock.Checked) and (Y.Inventory.Value > 0))) then
    begin
      Inc(j);
      SetLength(FYeastList, j);
      FYeastList[j-1]:= Y;
      sgIngredients.RowCount:= j;
      sgIngredients.Cells[0, j-1]:= Y.Laboratory.Value;
      sgIngredients.Cells[1, j-1]:= Y.ProductID.Value;
      sgIngredients.Cells[2, j-1]:= Y.Name.Value;
      sgIngredients.Cells[3, j-1]:= YeastTypeDisplayNames[Y.YeastType];
      sgIngredients.Cells[4, j-1]:= YeastFormDisplayNames[Y.Form];
      sgIngredients.Cells[5, j-1]:= Y.Inventory.DisplayString;
    end;
  end;
  if High(FYeastList) < 0 then
  begin
    Settings.ShowOnlyInStock.Value:= false;
    Settings.Save;
    cbOnlyInStock.Checked:= false;
    for i:= 0 to Yeasts.NumItems - 1 do
    begin
      Y:= TYeast(Yeasts.Item[i]);
      if (Y <> NIL) and ((not cbOnlyInStock.Checked) or
          ((cbOnlyInStock.Checked) and (Y.Inventory.Value > 0))) then
      begin
        Inc(j);
        SetLength(FYeastList, j);
        FYeastList[j-1]:= Y;
        sgIngredients.RowCount:= j;
        sgIngredients.Cells[0, j-1]:= Y.Laboratory.Value;
        sgIngredients.Cells[1, j-1]:= Y.ProductID.Value;
        sgIngredients.Cells[2, j-1]:= Y.Name.Value;
        sgIngredients.Cells[3, j-1]:= YeastTypeDisplayNames[Y.YeastType];
        sgIngredients.Cells[4, j-1]:= YeastFormDisplayNames[Y.Form];
        sgIngredients.Cells[5, j-1]:= Y.Inventory.DisplayString;
      end;
    end;
  end;
  for i:= 0 to sgIngredients.ColCount - 1 do
    sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
end;

procedure TFrmYeasts3.sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if (sgIngredients.Row >= 0) and (sgIngredients.Row <= High(FYeastList))
      and (FYeastList[sgIngredients.Row] <> NIL) then
  begin
    FYeast.Assign(FYeastList[sgIngredients.Row]);
    FYeast.AmountYeast.DisplayValue:= fseAmount.Value;
    lAmount.Caption:= FYeast.AmountYeast.DisplayUnitString;
  end;
end;

procedure TFrmYeasts3.eSearchChange(Sender: TObject);
var i, n : integer;
    s, sn, sl, snr : string;
begin
  n:= -1;
  s:= Lowercase(eSearch.Text);
  for i:= 0 to sgIngredients.RowCount - 1 do
  begin
    sn:= LowerCase(FYeastList[i].Name.Value);
    sl:= LowerCase(FYeastList[i].Laboratory.Value);
    snr:= LowerCase(FYeastList[i].ProductID.Value);
    if s = '' then
    begin
      sgIngredients.RowHeights[i]:= 23;
      n:= 0;
    end
    else
      if (NPos(s, sn, 1) = 0) and (NPos(s, sl, 1) = 0) and (NPos(s, snr, 1) = 0) then
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
  seTimesCultured.Enabled:= fseAmount.Enabled;
  cbSecondary.Enabled:= fseAmount.Enabled;
end;

procedure TFrmYeasts3.SpeedButton1Click(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmYeasts3.hcIngredientsSectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.Index of
  0: SortGrid(5, 6);
  1: SortGrid(6, 5);
  2: SortGrid(0, 5);
  3: SortGrid(7, 1);
  4: SortGrid(8, 1);
  end;
  eSearchChange(self);
end;

Function TFrmYeasts3.Execute(Y : TYeast) :  boolean;
var n : longint;
begin
  FYeast:= Y;
  Result:= false;
  fseAmount.Value:= 0;

  FYeast.Assign(FYeastList[sgIngredients.Row]);
  FYeast.AmountYeast.DisplayValue:= fseAmount.Value;
  lAmount.Caption:= FYeast.AmountYeast.DisplayUnitString;//FYeast.AmountYeast.DisplayUnitString;
  cbSecondary.Checked:= false;
  seTimesCultured.Value:= 0;
  sgIngredients.Row:= 0;
  FYeast.Assign(TYeast(Yeasts.Item[0]));

  Result:= (ShowModal = mrOK);

  if Result then
  begin
    n:= sgIngredients.Row;
    if (n >= 0) and (n <= High(FYeastList)) and (FYeastList[n] <> NIL) then
    begin
      Y.Assign(FYeastList[sgIngredients.Row]);
      Y.Amount.DisplayValue:= fseAmount.Value;
      Y.AmountYeast.DisplayValue:= fseAmount.Value;
  //    Y.AmountYeast.DisplayValue:= fseAmount.Value;
      Y.AddToSecondary.Value:= cbSecondary.Checked;
      Y.TimesCultured.Value:= seTimesCultured.Value;
    end;
  end;
  SetLength(FYeastList, 0);
end;

end.

