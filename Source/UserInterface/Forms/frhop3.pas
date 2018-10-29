unit frhop3;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  ComCtrls, StdCtrls, Spin, Buttons, Data, Containers;

type

  { TFrmHop3 }

  TFrmHop3 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbUse: TComboBox;
    cbOnlyInStock: TCheckBox;
    fseAmount: TFloatSpinEdit;
    fseIBU: TFloatSpinEdit;
    hcIngredients: THeaderControl;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lTime: TLabel;
    lAmount: TLabel;
    sgIngredients: TStringGrid;
    seTime: TSpinEdit;
    Label6: TLabel;
    eSearch: TEdit;
    SpeedButton1: TSpeedButton;
    procedure cbUseChange(Sender: TObject);
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseAmountChange(Sender: TObject);
    procedure fseIBUChange(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure seTimeChange(Sender: TObject);
    procedure sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
    procedure eSearchChange(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { private declarations }
    FHop : THop;
    FSort : integer;
    FSortDec : boolean;
    FUserClicked : boolean;
    FHopList : array of THop;
    Procedure SortGrid(Nr1, Nr2 : integer);
  public
    { public declarations }
    Function Execute(H : THop) : boolean;
  end; 

var
  FrmHop3: TFrmHop3;

implementation

{$R *.lfm}

uses Hulpfuncties, strutils;

procedure TFrmHop3.FormCreate(Sender: TObject);
var i : integer;
    hu : THopUse;
begin
  with sgIngredients do
  begin
    ColCount:= 4;
    RowCount:= Hops.NumItems;
    for i:= 0 to ColCount - 1 do
      ColWidths[i]:= hcIngredients.Sections[i].Width;
  end;

  cbUse.Items.Clear;
  for hu:= Low(HopUseDisplayNames) to High(HopUseDisplayNames) do
    cbUse.Items.Add(HopUseDisplayNames[hu]);
  cbUse.ItemIndex:= 2;
  cbOnlyInStock.Checked:= Settings.ShowOnlyInStock.Value;

  FSortDec:= false;
  FSort:= -1;
  SortGrid(0, 8);

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FUserClicked:= TRUE;
end;

procedure TFrmHop3.cbOnlyInStockChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FSortDec:= false;
    FSort:= -1;
    SortGrid(0, 8);
    Settings.ShowOnlyInStock.Value:= cbOnlyInStock.Checked;
    Settings.Save;
  end;
end;

procedure TFrmHop3.cbUseChange(Sender: TObject);
begin
  case cbUse.ItemIndex of
  0, 1: if FHop.Recipe <> NIL then seTime.Value:= FHop.Recipe.BoilTime.Value;
  2: ;
  3, 4, 5: seTime.Value:= 0;
  end;
  FHop.Time.DisplayValue:= seTime.Value;
  FHop.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
  fseAmountChange(sender);
end;

Procedure TFrmHop3.SortGrid(Nr1, Nr2 : integer);
var i, j : integer;
    H : THop;
begin
  if FSort = Nr1 then FSortDec:= not FSortDec
  else FSortDec:= false;
  FSort:= Nr1;

  Hops.SortByIndex2(Nr1, Nr2, FSortDec);
  SetLength(FHopList, 0);
  sgIngredients.RowCount:= 0;
  j:= 0;

  for i:= 0 to Hops.NumItems - 1 do
  begin
    H:= THop(Hops.Item[i]);
    if (H <> NIL) and ((not cbOnlyInStock.Checked) or
        ((cbOnlyInStock.Checked) and (H.Inventory.Value > 0))) then
    begin
      Inc(j);
      SetLength(FHopList, j);
      FHopList[j-1]:= H;
      sgIngredients.RowCount:= j;
      sgIngredients.Cells[0, j-1]:= H.Name.Value;
      sgIngredients.Cells[1, j-1]:= H.Alfa.DisplayString;
      sgIngredients.Cells[2, j-1]:= HopFormDisplayNames[H.Form];
      sgIngredients.Cells[3, j-1]:= H.Inventory.DisplayString;
    end;
  end;
  if High(FHopList) < 0 then
  begin
    Settings.ShowOnlyInStock.Value:= false;
    Settings.Save;
    cbOnlyInStock.Checked:= false;
    for i:= 0 to Hops.NumItems - 1 do
    begin
      H:= THop(Hops.Item[i]);
      if (H <> NIL) and ((not cbOnlyInStock.Checked) or
          ((cbOnlyInStock.Checked) and (H.Inventory.Value > 0))) then
      begin
        Inc(j);
        SetLength(FHopList, j);
        FHopList[j-1]:= H;
        sgIngredients.RowCount:= j;
        sgIngredients.Cells[0, j-1]:= H.Name.Value;
        sgIngredients.Cells[1, j-1]:= H.Alfa.DisplayString;
        sgIngredients.Cells[2, j-1]:= HopFormDisplayNames[H.Form];
        sgIngredients.Cells[3, j-1]:= H.Inventory.DisplayString;
      end;
    end;
  end;
  for i:= 0 to sgIngredients.ColCount - 1 do
    sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
end;

procedure TFrmHop3.fseAmountChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    FHop.Amount.DisplayValue:= fseAmount.Value;
    SGstartboil := R.SGstartboil;
    SGav := SGStartBoil; //(SGstartboil + R.EstOG.Value) / 2;
    fseIBU.Value:= CalcIBU(R.IBUmethod, FHop.Use, FHop.Alfa.Value, 1000 * FHop.Amount.Value,
                           R.BoilSize.Value, R.BatchSize.Value, SGav,
                           FHop.Time.Value, FHop.Form, 0);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHop3.seTimeChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    SGstartboil := R.SGstartboil;
    SGav := SGStartBoil; //(SGstartboil + R.EstOG.Value) / 2;
    FHop.Time.DisplayValue:= seTime.Value;
    fseIBU.Value:= CalcIBU(R.IBUmethod, FHop.Use, FHop.Alfa.Value, 1000 * FHop.Amount.Value,
                           R.BoilSize.Value, R.BatchSize.Value, SGav,
                           FHop.Time.Value, FHop.Form, 0);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHop3.sgIngredientsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if (sgIngredients.Row >= 0) and (sgIngredients.Row <= High(FHopList))
      and (FHopList[sgIngredients.Row] <> NIL) then
  begin
    FHop.Assign(FHopList[sgIngredients.Row]);
    FHop.Amount.DisplayValue:= fseAmount.Value;
    FHop.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
    FHop.Time.DisplayValue:= seTime.Value;
    fseAmountChange(sender);
  end;
end;

procedure TFrmHop3.eSearchChange(Sender: TObject);
var i, n : integer;
    s, sn : string;
begin
  n:= -1;
  s:= Lowercase(eSearch.Text);
  for i:= 0 to sgIngredients.RowCount - 1 do
  begin
    sn:= LowerCase(FHopList[i].Name.Value);
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
//  if f > -1 then f:= 0;
  if n > -1 then
  begin
    sgIngredients.Row:= n;
    sgIngredientsSelection(Self, 0, n);
  end;
  fseAmount.Enabled:= (n > -1);
  fseIBU.Enabled:= fseAmount.Enabled;
  seTime.Enabled:= fseAmount.Enabled;
  cbUse.Enabled:= fseAmount.Enabled;
end;

procedure TFrmHop3.SpeedButton1Click(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmHop3.fseIBUChange(Sender: TObject);
var R : TRecipe;
    SGstartboil, SGav: double;
begin
  R:= FHop.Recipe;
  if (R <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    SGstartboil := R.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + R.EstOG.Value) / 2;
    fseAmount.Value:= AmHop(R.IBUmethod, FHop.Use, FHop.Alfa.Value, fseIBU.Value,
                            R.BoilSize.Value, R.BatchSize.Value, SGav,
                            FHop.Time.Value, FHop.Form, 0);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHop3.hcIngredientsSectionClick(
  HeaderControl: TCustomHeaderControl; Section: THeaderSection);
begin
  case Section.Index of
  0: SortGrid(0, 8);
  1: SortGrid(8, 0);
  2: SortGrid(7, 0);
  3: SortGrid(3, 0);
  end;
  eSearchChange(self);
end;

Function TFrmHop3.Execute(H : THop) :  boolean;
var n : longint;
begin
  FHop:= H;
  Result:= false;
  fseAmount.Value:= 0;
  lAmount.Caption:= UnitNames[H.Amount.DisplayUnit];
  lTime.Caption:= UnitNames[H.Time.DisplayUnit];
  fseIBU.Value:= 0;
  cbUse.ItemIndex:= cbUse.Items.IndexOf(HopUseDisplayNames[H.Use]);

  sgIngredients.Row:= 0;
  FHop.Assign(THop(Hops.Item[0]));
  FHop.Amount.DisplayValue:= fseAmount.Value;
  FHop.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
  FHop.Time.DisplayValue:= seTime.Value;
  fseAmountChange(self);

  Result:= (ShowModal = mrOK);

  if Result then
  begin
    n:= sgIngredients.Row;
    if (n >= 0) and (n <= High(FHopList)) and (FHopList[n] <> NIL) then
    begin
      H.Assign(FHopList[sgIngredients.Row]);
      H.Amount.DisplayValue:= fseAmount.Value;
      H.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
      H.Time.DisplayValue:= seTime.Value;
    end;
  end;
  SetLength(FHopList, 0);
end;

end.

