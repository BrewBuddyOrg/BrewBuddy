unit frgristwizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, ComCtrls, Grids, Data, positieinterval;

type

  { TFrmGristWizard }

  TScrollRec = record
    SB : TScrollBar;
    cb : TCheckBox;
    row, colsb, colcb : integer;
    grid : TStringGrid;
    Ferm : TFermentable;
  end;

  TFrmGristWizard = class(TForm)
    bbAddFermentable: TBitBtn;
    bbRemoveBaseMalt: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    cbLockSpecialty: TCheckBox;
    cbLockSugar: TCheckBox;
    eColor: TEdit;
    fseGrid: TFloatSpinEdit;
    fsePercSpec: TFloatSpinEdit;
    fsePercSug: TFloatSpinEdit;
    fseSG: TFloatSpinEdit;
    gbBasemalt: TGroupBox;
    gbSpecialty: TGroupBox;
    gbSugars: TGroupBox;
    gbProperties: TGroupBox;
    GroupBox2: TGroupBox;
    hcBaseMalt: THeaderControl;
    hcSpecialtyMalt: THeaderControl;
    hcSugar: THeaderControl;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lSVG: TLabel;
    lAlcohol: TLabel;
    lFG: TLabel;
    lSGMin: TLabel;
    lSGmax: TLabel;
    Label3: TLabel;
    lblSGunit: TLabel;
    sbSG: TScrollBar;
    sbSpecialty: TScrollBar;
    sbSugars: TScrollBar;
    sgBaseMalt: TStringGrid;
    sgSpecialty: TStringGrid;
    sgSugar: TStringGrid;
    procedure bbAddFermentableClick(Sender: TObject);
    procedure bbRemoveBaseMaltClick(Sender: TObject);
    procedure cbLockSpecialtyChange(Sender: TObject);
    procedure cbLockSugarChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseGridChange(Sender: TObject);
    procedure fsePercSpecChange(Sender: TObject);
    procedure fsePercSugChange(Sender: TObject);
    procedure fseSGChange(Sender: TObject);
    procedure sbSGChange(Sender: TObject);
    procedure sbSpecialtyChange(Sender: TObject);
    procedure sbSugarsChange(Sender: TObject);
    procedure sgBaseMaltDblClick(Sender: TObject);
    procedure sgBaseMaltDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgBaseMaltExit(Sender: TObject);
    procedure sgBaseMaltSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgBaseMaltSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure sgSpecialtyDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgSpecialtyExit(Sender: TObject);
    procedure sgSpecialtySelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgSpecialtySelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure sgSugarDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgSugarExit(Sender: TObject);
    procedure sgSugarSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgSugarSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
  private
    { private declarations }
    FRec : TRecipe;
    FUserClicked, FSortGrid : boolean;
    FSelFerm : TFermentable;
    FSelGrid : integer;
    FIGSCYBase, FIGSCYSpecialty, FIGSCYSugar : integer;
    FBaseGridColors, FSpecialtyGridColors, FSugarGridColors : array of TColor;
    FBaseInventoryColors, FSpecialtyInventoryColors, FSugarInventoryColors : array of TColor;
    FScrollBars : array of TScrollRec;
    piSG, piColor, piAlcohol : TPosInterval;
    Procedure FillGrids;
    Procedure Update;
    Procedure ChangeOG;
    Function FindMaltScrollBar : TScrollBar;
    Function FindScrollBar(sg : TStringGrid; aCol, aRow : integer) : TScrollBar;
    Function FindCheckBox(sg : TStringGrid; aCol, aRow : integer) : TCheckBox;
    Function FindFermentable(sb : TScrollBar) : TFermentable;
    Function FindFermentable2(cb : TCheckBox) : TFermentable;
    Function FindNum(F : TFermentable) : integer;
    Function IsBaseMalt(F : TFermentable) : boolean;
    Function IsSpecialtyMalt(F : TFermentable) : boolean;
    Function IsSugar(F : TFermentable) : boolean;
    procedure sbScrollbarsChange(Sender: TObject);
    procedure cbScrollbarsChange(Sender: TObject);
  public
    { public declarations }
    Function Execute(R : TRecipe) : boolean;
  end;

var
  FrmGristWizard: TFrmGristWizard;

implementation

{$R *.lfm}

uses Hulpfuncties, frfermentables2, frfermentables3, Containers, fradjustto100;

procedure TFrmGristWizard.FormCreate(Sender: TObject);
begin
  FUserClicked:= TRUE;
  FSelFerm:= NIL;
  FSelGrid:= -1;
  FIGSCYBase:= 0; FIGSCYSpecialty:= 0; FIGSCYSugar:= 0;

  piSG:= TPosInterval.Create(gbProperties);
  piSG.Parent:= gbProperties;
  piSG.Left:= 3;
  piSG.Top:= 180;
  piSG.Width:= 170;
  piSG.Height:= 40;
  piSG.Font.Height:= Font.Height;
  piSG.Caption:= 'SG: ';
  piSG.ShowValues:= false;
  piSG.Effect:= ePlain;
  piSG.Decimals:= 0;
  piSG.Min:= 0;
  piSG.Max:= 100;
  piSG.Value:= 50;
  piSG.Color:= gbProperties.Color;

  piColor:= TPosInterval.Create(gbProperties);
  piColor.Parent:= gbProperties;
  piColor.Left:= 3;
  piColor.Top:= 225;
  piColor.Width:= 170;
  piColor.Height:= 40;
  piColor.Font.Height:= Font.Height;
  piColor.Caption:= 'Kleur: ';
  piColor.ShowValues:= false;
  piColor.Effect:= ePlain;
  piColor.Decimals:= 0;
  piColor.Min:= 0;
  piColor.Max:= 100;
  piColor.Value:= 50;
  piColor.Color:= gbProperties.Color;

  piAlcohol:= TPosInterval.Create(gbProperties);
  piAlcohol.Parent:= gbProperties;
  piAlcohol.Left:= 3;
  piAlcohol.Top:= 270;
  piAlcohol.Width:= 170;
  piAlcohol.Height:= 40;
  piAlcohol.Font.Height:= Font.Height;
  piAlcohol.Caption:= 'Alc.%: ';
  piAlcohol.ShowValues:= false;
  piAlcohol.Effect:= ePlain;
  piAlcohol.Decimals:= 0;
  piAlcohol.Min:= 0;
  piAlcohol.Max:= 10;
  piAlcohol.Value:= 5;
  piAlcohol.Color:= gbProperties.Color;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmGristWizard.FormDestroy(Sender: TObject);
var i : integer;
begin
  for i:= 0 to High(FScrollBars) do
  begin
    FreeAndNIL(FScrollBars[i].SB);
    FreeAndNIL(FScrollBars[i].cb);
  end;
  SetLength(FScrollBars, 0);
  SetLength(FBaseGridColors, 0);
  SetLength(FSpecialtyGridColors, 0);
  SetLength(FSugarGridColors, 0);
  SetLength(FBaseInventoryColors, 0);
  SetLength(FSpecialtyInventoryColors, 0);
  SetLength(FSugarInventoryColors, 0);
end;

Function TFrmGristWizard.Execute(R : TRecipe) : boolean;
begin
  if R <> NIL then
  begin
    FRec:= TRecipe.Create(NIL);
    FRec.Assign(R);
    FRec.SortFermentables(20, 2, true, true);
    FUserclicked:= false;
    FSelFerm:= NIL;
    bbRemoveBaseMalt.Enabled:= false;

    lblSGUnit.Caption:= R.OG.DisplayUnitString;
    Case R.OG.DisplayUnit of
    sg:
    begin
      fseSG.MinValue:= 1.030;
      fseSG.MaxValue:= 1.100;
      fseSG.DecimalPlaces:= 3;
    end;
    plato:
    begin
      fseSG.MinValue:= 7;
      fseSG.MaxValue:= 24;
      fseSG.DecimalPlaces:= 1;
    end;
    end;
    fseSG.Value:= FRec.EstOG.DisplayValue;

    lSGMin.Caption:= RealToStrDec(fseSG.MinValue, fseSG.DecimalPlaces);
    lSGMax.Caption:= RealToStrDec(fseSG.MaxValue, fseSG.DecimalPlaces);
    sbSG.Position:= round((fseSG.Value - fseSG.MinValue) * (sbSG.Max - sbSG.Min) / (fseSG.MaxValue - fseSG.MinValue) + sbSG.Min);

    FillGrids;

    Update;

    Result:= (ShowModal = mrOK);
    if Result then
      R.Assign(FRec);

    FRec.Free;
  end;
end;

Procedure TFrmGristWizard.FillGrids;
var i : integer;
    F, Fr, ferm : TFermentable;
    s : string;
    perc, n, ni : double;
    sb : TScrollBar;
    cb : TCheckBox;
    variableset : boolean;
begin
  if FRec <> NIL then
  begin
    for i:= 0 to High(FScrollBars) do
    begin
      FreeAndNIL(FScrollBars[i].SB);
      FreeAndNIL(FScrollBars[i].cb);
    end;
    SetLength(FScrollBars, 0);
    SetLength(FBaseGridColors, 0);
    SetLength(FSpecialtyGridColors, 0);
    SetLength(FSugarGridColors, 0);
    SetLength(FBaseInventoryColors, 0);
    SetLength(FSpecialtyInventoryColors, 0);
    SetLength(FSugarInventoryColors, 0);

    SetLength(FBaseGridColors, FRec.NumBaseMalts);
    SetLength(FBaseInventoryColors, FRec.NumBaseMalts);
    SetLength(FSpecialtyGridColors, FRec.NumSpecialtyMalts);
    SetLength(FSpecialtyInventoryColors, FRec.NumSpecialtyMalts);
    SetLength(FSugarGridColors, FRec.NumSugars);
    SetLength(FSugarInventoryColors, FRec.NumSugars);

    //Check if the malts in the recipe have the appropriate graintype values if not, try to find
    //the corresponding malts in the database and set the appropriate graintype values
    for i:= 0 to FRec.NumFermentables - 1 do
    begin
      Fr:= FRec.Fermentable[i];
      if (Fr <> NIL) and (Fr.FermentableType = ftGrain) and (Fr.GrainType = gtNone) then
      begin
        F:= TFermentable(Fermentables.FindByName(Fr.Name.Value));
        if F <> NIL then Fr.GrainTypeName:= F.GrainTypeName;
      end;
    end;
    FUserClicked:= TRUE;

    sgBaseMalt.RowCount:= FRec.NumBaseMalts;
    for i:= 0 to FRec.NumBaseMalts - 1 do
    begin
      F:= FRec.BaseMalt[i];
      sgBaseMalt.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgBaseMalt.Cells[1, i]:= s;
      FBaseGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgBaseMalt.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgBaseMalt.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgBaseMalt.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FBaseInventoryColors[i]:= FBaseGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FBaseInventoryColors[i]:= clRed;

      sgBaseMalt.RowHeights[i]:= 20;

      if (not F.AdjustToTotal100.Value) then
      begin
        SetLength(FScrollBars, High(FScrollBars) + 2);
        FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgBaseMalt);
        FScrollBars[High(FScrollBars)].colsb:= 4;
        FScrollBars[High(FScrollBars)].row:= i;
        FScrollBars[High(FScrollBars)].grid:= sgBaseMalt;
        FScrollBars[High(FScrollBars)].Ferm:= F;
        sb:= FScrollBars[High(FScrollBars)].SB;
        sb.Parent:= sgBaseMalt;
        sb.Min:= 0;
        sb.SmallChange:= 1;
        sb.LargeChange:= 10;
        sb.OnChange:= @sbScrollBarsChange;
        FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgBaseMalt);
        FScrollBars[High(FScrollBars)].colcb:= 5;
        cb:= FScrollBars[High(FScrollBars)].cb;
        cb.Parent:= sgBaseMalt;
        cb.Caption:= '';
        cb.Checked:= F.LockPercentage;
        cb.Color:= FermentableColor;
        cb.OnChange:= @cbScrollBarsChange;
      end;

      if F.AdjustToTotal100.Value then variableset:= TRUE;
    end;
    if (not variableset) and (FRec.NumBaseMalts > 0) then FRec.BaseMalt[0].AdjustToTotal100.Value:= TRUE;

    sgSpecialty.RowCount:= FRec.NumSpecialtyMalts;
    for i:= 0 to FRec.NumSpecialtyMalts - 1 do
    begin
      F:= FRec.SpecialtyMalt[i];
      sgSpecialty.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgSpecialty.Cells[1, i]:= s;
      FSpecialtyGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgSpecialty.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgSpecialty.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgSpecialty.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FSpecialtyInventoryColors[i]:= FSpecialtyGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FSpecialtyInventoryColors[i]:= clRed;

      sgSpecialty.RowHeights[i]:= 20;
      if not (F.AdjustToTotal100.Value) then
      begin
        SetLength(FScrollBars, High(FScrollBars) + 2);
        FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgSpecialty);
        FScrollBars[High(FScrollBars)].colsb:= 4;
        FScrollBars[High(FScrollBars)].row:= i;
        FScrollBars[High(FScrollBars)].grid:= sgSpecialty;
        FScrollBars[High(FScrollBars)].Ferm:= F;
        sb:= FScrollBars[High(FScrollBars)].SB;
        sb.Parent:= sgSpecialty;
        sb.Min:= 0;
        sb.SmallChange:= 1;
        sb.LargeChange:= 10;
        sb.OnChange:= @sbScrollBarsChange;
        FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgSpecialty);
        FScrollBars[High(FScrollBars)].colcb:= 5;
        cb:= FScrollBars[High(FScrollBars)].cb;
        cb.Parent:= sgSpecialty;
        cb.Caption:= '';
        cb.Checked:= F.LockPercentage;
        cb.Color:= FermentableColor;
        cb.OnChange:= @cbScrollBarsChange;
      end;
    end;

    sgSugar.RowCount:= FRec.NumSugars;
    for i:= 0 to FRec.NumSugars - 1 do
    begin
      F:= FRec.Sugar[i];
      sgSugar.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgSugar.Cells[1, i]:= s;
      FSugarGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgSugar.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgSugar.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgSugar.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FSugarInventoryColors[i]:= FSugarGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FSugarInventoryColors[i]:= clRed;

      sgSugar.RowHeights[i]:= 20;
      if not (F.AdjustToTotal100.Value) then
      begin
        SetLength(FScrollBars, High(FScrollBars) + 2);
        FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgSugar);
        FScrollBars[High(FScrollBars)].colsb:= 4;
        FScrollBars[High(FScrollBars)].row:= i;
        FScrollBars[High(FScrollBars)].grid:= sgSugar;
        FScrollBars[High(FScrollBars)].Ferm:= F;
        sb:= FScrollBars[High(FScrollBars)].SB;
        sb.Parent:= sgSugar;
        sb.Min:= 0;
        sb.SmallChange:= 1;
        sb.LargeChange:= 10;
        sb.OnChange:= @sbScrollBarsChange;
        FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgSugar);
        FScrollBars[High(FScrollBars)].colcb:= 5;
        cb:= FScrollBars[High(FScrollBars)].cb;
        cb.Parent:= sgSugar;
        cb.Caption:= '';
        cb.Checked:= F.LockPercentage;
        cb.Color:= FermentableColor;
        cb.OnChange:= @cbScrollBarsChange;
      end;
    end;
  end;
end;

Procedure TFrmGristWizard.Update;
var i, j : integer;
    F, ferm : TFermentable;
    s : string;
    perc, n, ni, totbase, totspec, totsug, percvar, maxperc : double;
    variableset, allsugarslocked, allspecialtylocked : boolean;
    sb : TScrollBar;
    cb : TCheckBox;
    Rect : TRect;
    St : TBeerStyle;
begin
  FUserClicked:= false;

  totbase:= 0;
  totspec:= 0;
  totsug:= 0;

  if FRec <> NIL then
  begin
    //check if at least 1 (base) malt has AdjustToTotal100 on TRUE
    variableset:= false;
    percvar:= 0;
    for i:= 0 to FRec.NumFermentables - 1 do
    begin
      if FRec.Fermentable[i].AdjustToTotal100.Value then
      begin
        variableset:= TRUE;
        percvar:= percvar + FRec.Fermentable[i].Percentage.Value;
      end;
    end;
    if (not variableset) and (FRec.NumFermentables > 0) then
    begin
      frmAdjustTotalTo100:= TfrmAdjustTotalTo100.Create(self);
      FrmAdjustTotalTo100.Execute(FRec);
      FreeAndNIL(FrmAdjustTotalTo100);
      for i:= 0 to FRec.NumFermentables - 1 do
        if FRec.Fermentable[i].AdjustToTotal100.Value then
          percvar:= percvar + FRec.Fermentable[i].Percentage.Value;
      FillGrids;
    end;

    {FSortGrid:= (sgBaseMalt.Editor = NIL) and (sgSpecialty.Editor = NIL)
                and (sgSugar.Editor = NIL);
    if FSortGrid then FRec.SortFermentables(20, 2, true, true);
//      FRec.SortFermentables(2, -1, true, true);}

    for i:= 0 to sgBaseMalt.RowCount - 1 do
      for j:= 0 to 3 do
        sgBaseMalt.Cells[j, i]:= '';
    for i:= 0 to sgSpecialty.RowCount - 1 do
      for j:= 0 to 3 do
        sgSpecialty.Cells[j, i]:= '';
    for i:= 0 to sgSugar.RowCount - 1 do
      for j:= 0 to 3 do
        sgSugar.Cells[j, i]:= '';

    sgBaseMalt.RowCount:= FRec.NumBaseMalts;
    sgSpecialty.RowCount:= FRec.NumSpecialtyMalts;
    sgSugar.RowCount:= FRec.NumSugars;

    variableset:= false;
    for i:= 0 to FRec.NumBaseMalts - 1 do
    begin
      F:= FRec.BaseMalt[i];
      sgBaseMalt.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgBaseMalt.Cells[1, i]:= s;
      FBaseGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgBaseMalt.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgBaseMalt.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgBaseMalt.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FBaseInventoryColors[i]:= FBaseGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FBaseInventoryColors[i]:= clRed;

      sgBaseMalt.RowHeights[i]:= 20;
      totbase:= totbase + n;

      if F.AdjustToTotal100.Value then variableset:= TRUE;
    end;
    if (not variableset) and (FRec.NumBaseMalts > 0) then FRec.BaseMalt[0].AdjustToTotal100.Value:= TRUE;

    for i:= 0 to FRec.NumSpecialtyMalts - 1 do
    begin
      F:= FRec.SpecialtyMalt[i];
      sgSpecialty.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgSpecialty.Cells[1, i]:= s;
      FSpecialtyGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgSpecialty.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgSpecialty.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgSpecialty.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FSpecialtyInventoryColors[i]:= FSpecialtyGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FSpecialtyInventoryColors[i]:= clRed;

      sgSpecialty.RowHeights[i]:= 20;
      totspec:= totspec + n;
    end;

    for i:= 0 to FRec.NumSugars - 1 do
    begin
      F:= FRec.Sugar[i];
      sgSugar.Cells[0, i]:= F.Amount.DisplayString;
      s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
      sgSugar.Cells[1, i]:= s;
      FSugarGridColors[i]:= FermentableColor;

      perc:= F.Percentage.Value;
      sgSugar.Cells[2, i]:= RealToStrDec(Perc, 1) + '%';
      ferm:= Fermentables.FindByNameAndSupplier(F.Name.Value, F.Supplier.Value);
      if ferm <> NIL then sgSugar.Cells[3, i]:= ferm.Inventory.DisplayString
      else sgSugar.Cells[3, i]:= RealToStrDec(0, F.Amount.Decimals) + ' ' + F.Amount.DisplayUnitString;

      FSugarInventoryColors[i]:= FSugarGridColors[i];
      s:= F.Name.Value;
      n:= F.Amount.Value;
      if ferm <> NIL then ni:= ferm.Inventory.Value
      else ni:= 0;
      if n > ni then FSugarInventoryColors[i]:= clRed;

      sgSugar.RowHeights[i]:= 20;
      totsug:= totsug + n;
    end;

    if (totbase + totspec + totsug) > 0 then
    begin
      sbSpecialty.Position:= round(1000 * totspec / (totbase + totspec + totsug));
      sbSpecialty.Max:= round(1000 * totspec / (totbase + totspec + totsug) + 10 * percvar);
      fsePercSpec.Value:= sbSpecialty.Position/10;
      sbSugars.Position:= round(1000 * totsug / (totbase + totspec + totsug));
      sbSugars.Max:= round(1000 * totsug / (totbase + totspec + totsug) + 10 * percvar);
      fsePercSug.Value:= sbSugars.Position/10;
    end
    else
    begin
      sbSpecialty.Position:= 0;
      sbSpecialty.Max:= 1000;
      fsePercSpec.Value:= 0;
      sbSugars.Position:= 0;
      sbSugars.Max:= 100;
      fsePercSug.Value:= 0;
    end;

    FRec.CalcColor;
    eColor.Text:= FRec.EstColor.DisplayString;
    eColor.Color:= SRMtoColor(FRec.EstColor.Value);
    if FRec.EstColor.Value < 15 then eColor.Font.Color:= clBlack
    else eColor.Font.Color:= clWhite;
    eColor.Invalidate;

    FRec.EstimateFG;
    n:= FRec.EstFG.DisplayValue;
    lFG.Caption:= 'Eind SG: ' + RealToStrDec(n, 3) + ' ' + FRec.EstOG.DisplayUnitString;
    ni:= ABVol(FRec.EstOG.Value, FRec.EstFG.Value);
    lAlcohol.Caption:= 'Alcohol: ' + RealToStrDec(ni, 1) + ' vol.%';
    n:= 100 * (FRec.EstOG.Value - FRec.EstFG.Value) / (FRec.EstOG.Value - 1);
    lSVG.Caption:= 'Verg. graad: ' + RealToStrDec(n, 1) + '%';

    if sgBaseMalt.RowCount > 0 then
      for i:= 0 to 4 do
        sgBaseMalt.ColWidths[i]:= hcBaseMalt.Sections[i].Width;
    if sgSpecialty.RowCount > 0 then
      for i:= 0 to 4 do
        sgSpecialty.ColWidths[i]:= hcSpecialtyMalt.Sections[i].Width;
    if sgSugar.RowCount > 0 then
      for i:= 0 to 4 do
        sgSugar.ColWidths[i]:= hcSugar.Sections[i].Width;

    allsugarslocked:= TRUE; allspecialtylocked:= TRUE;
    for i:= 0 to High(FScrollBars) do
    begin
      sb:= FScrollBars[i].SB;
     { rect:= FScrollBars[i].grid.CellRect(FScrollBars[i].colsb, FScrollBars[i].Row);
      sb.BoundsRect:= rect;
      sb.Visible:= TRUE;}
      FScrollBars[i].cb.Checked:= FScrollBars[i].Ferm.LockPercentage;
      sb.Enabled:= not FScrollBars[i].cb.Checked;
      if (not FScrollBars[i].cb.Checked) then
        if FScrollBars[i].grid = sgSpecialty then allspecialtylocked:= false
        else if FScrollBars[i].grid = sgSugar then allsugarslocked:= false;
      maxperc:= FScrollBars[i].Ferm.Percentage.Value + percvar;
      if maxperc > 100 then maxperc:= 100;
      if maxperc < 0 then
        maxperc:= 0;
      sb.Max:= round(10 * maxperc);
      if FScrollBars[i].grid = sgSpecialty then
        if cbLockSpecialty.Checked then //total percentage of specialty malts must stay the same
          sb.Max:= sbSpecialty.Position
        else
          sb.Max:= round(10 * maxperc);
      if FScrollBars[i].grid = sgSugar then
        if cbLockSugar.Checked then //total percentage of sugars must stay the same
          sb.Max:= sbSugars.Position
        else
          sb.Max:= round(10 * maxperc);
      perc:= FScrollBars[i].Ferm.Percentage.Value;
      sb.Position:= round(10 * perc);
    end;

    if allspecialtylocked and (FRec.NumSpecialtyMalts > 0) then
    begin
      cbLockSpecialty.Checked:= TRUE;
      sbSpecialty.Enabled:= false;
      fsePercSpec.Enabled:= false;
    end
    {else
    begin
      cbLockSpecialty.Checked:= false;
      sbSpecialty.Enabled:= (FRec.NumSpecialtyMalts > 0) and (not cbLockSpecialty.Checked);
    end};
    if allsugarslocked and (FRec.NumSugars > 0) then
    begin
      cbLockSugar.Checked:= TRUE;
      sbSugars.Enabled:= false;
      fsePercSug.Enabled:= false;
    end
    {else
    begin
      cbLockSugar.Checked:= false;
      sbSugars.Enabled:= (FRec.NumSugars > 0) and (not cbLockSugar.Checked);
    end};

    St:= FRec.Style;
    if St <> NIL then
    begin
      n:= 1000 * (St.OGMin.Value - 1);
      piSG.Low:= n;
      n:= 1000 * (St.OGMax.Value - 1);
      piSG.High:= n;

      n:= St.ColorMin.Value;
      piColor.Low:= n;
      n:= St.ColorMax.Value;
      piColor.High:= n;

      n:= St.ABVMin.Value;
      piAlcohol.Low:= n;
      n:= St.ABVMax.Value;
      piAlcohol.High:= n;
    end;
    n:= 1000 * (FRec.EstOG.Value - 1);
    piSG.Min:= MaxA([0, MinD(800 * (n - 1), 800 * (St.OGMin.Value - 1))]);
    n:= 1000 * (FRec.EstOG.Value - 1);
    piSG.Value:= n;
    piSG.Max:= MaxD(1.25 * piSG.High, 1.1 * piSG.Value);

    n:= FRec.EstColor.Value;
    piColor.Min:= MaxA([0, MinD(n - 10, piColor.Low - 10)]);
    n:= FRec.EstColor.Value;
    piColor.Max:= MaxD(1.1 * piColor.High, 1.1 * n);
    piColor.Value:= n;

    n:= ABVol(FRec.EstOG.Value, FRec.EstFG.Value);
    piAlcohol.Max:= MaxD(1.25 * piAlcohol.High, 1.1 * n);
    piAlcohol.Min:= MaxA([0, MinD(0.8 * St.ABVMin.Value, 0.8 * n)]);
    piAlcohol.Value:= n;

    FUserClicked:= TRUE;
  end;
end;

Function TFrmGristWizard.IsBaseMalt(F : TFermentable) : boolean;
begin
  Result:= (F.GrainType = gtBase) or (F.FermentableType = ftExtract)
            or (F.FermentableType = ftDryExtract);
end;

Function TFrmGristWizard.IsSpecialtyMalt(F : TFermentable) : boolean;
begin
  Result:= (F.GrainType = gtRoast) or (F.GrainType = gtCrystal)
           or (F.GrainType = gtKilned) or (F.GrainType = gtSour)
           or (F.GrainType = gtSpecial) or (F.FermentableType = ftAdjunct);
end;

Function TFrmGristWizard.IsSugar(F : TFermentable) : boolean;
begin
  Result:= (F.FermentableType = ftSugar);
end;

Function TFrmGristWizard.FindMaltScrollBar : TScrollBar;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if FScrollBars[i].Ferm = FSelFerm then
    begin
      Result:= FScrollBars[i].SB;
      Exit;
    end;
end;

Function TFrmGristWizard.FindScrollBar(sg : TStringGrid; aCol, aRow : integer) : TScrollBar;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].grid = sg) and (FScrollBars[i].colsb = aCol) and (FScrollBars[i].row = aRow) then
    begin
      Result:= FScrollBars[i].SB;
      Exit;
    end;
end;

Function TFrmGristWizard.FindCheckBox(sg : TStringGrid; aCol, aRow : integer) : TCheckBox;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].grid = sg) and (FScrollBars[i].colcb = aCol) and (FScrollBars[i].row = aRow) then
    begin
      Result:= FScrollBars[i].cb;
      Exit;
    end;
end;

Function TFrmGristWizard.FindFermentable(sb : TScrollBar) : TFermentable;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].SB = sb) then
    begin
      Result:= FScrollBars[i].Ferm;
      Exit;
    end;
end;

Function TFrmGristWizard.FindFermentable2(cb : TCheckBox) : TFermentable;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].cb = cb) then
    begin
      Result:= FScrollBars[i].Ferm;
      Exit;
    end;
end;

Function TFrmGristWizard.FindNum(F : TFermentable) : integer;
var i : integer;
begin
  Result:= -1;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].Ferm = F) then
    begin
      Result:= i;
      Exit;
    end;
end;

procedure TFrmGristWizard.fseGridChange(Sender: TObject);
var v, vr : double;
    i : integer;
begin
  if (FSelFerm <> NIL) and (FUserClicked) and (fseGrid.Modified) then
  begin
    FUserClicked:= false;
   // FSortGrid:= false;
    if FSelGrid = 0 then i:= sgBaseMalt.Col
    else if FSelGrid = 1 then i:= sgSpecialty.Col
    else if FSelGrid = 2 then i:= sgSugar.Col
    else i:= -1;
    if i <> -1 then
    begin
      FSelFerm.Percentage.Value:= fseGrid.Value;
      FRec.CheckPercentage;
      v:= FSelFerm.Percentage.Value;
      vr:= FSelFerm.MaxInBatch.Value;
      if (vr > 0) and (v > vr) then
        ShowNotificationModal(self, 'Percentage ' + FSelFerm.Name.Value + ' is hoger dan het aanbevolen maximum');
      Update;
    end;

    fseGrid.Enabled:= TRUE;

    FUserClicked:= TRUE;
  //  FSortGrid:= TRUE;
  end;
end;

procedure TFrmGristWizard.fseSGChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    bbRemoveBaseMalt.Enabled:= false;
    FSelFerm:= NIL;
    sbSG.Position:= round((fseSG.Value - fseSG.MinValue) * (sbSG.Max - sbSG.Min) / (fseSG.MaxValue - fseSG.MinValue) + sbSG.Min);
    ChangeOG;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.sbSGChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    fseSG.Value:= (sbSG.Position - sbSG.Min) * (fseSG.MaxValue - fseSG.MinValue) / (sbSG.Max - sbSG.Min) + fseSG.MinValue;
    bbRemoveBaseMalt.Enabled:= false;
    FSelFerm:= NIL;
    ChangeOG;
    FUserClicked:= TRUE;
  end;
end;

Procedure TFrmGristWizard.ChangeOG;
var ibu, bindex : double;
begin
  if (FRec <> NIL) then
  begin
    ibu:= FRec.IBUcalc.Value;
    bindex:= -1;
    if FRec.EstOG.Value > 1 then
      bindex:= ibu / (1000 * (FRec.EstOG.Value - 1));
    FRec.EstOG.DisplayValue:= fseSG.Value;
    FRec.CalcFermentablesFromPerc(FRec.EstOG.Value);
    if ibu > 0 then
      if Settings.SGBitterness.Value = 0 then
        FRec.AdjustBitterness(ibu)
      else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
        FRec.AdjustBitterness(1000 * (FRec.EstOG.Value - 1) * bIndex);
    Update;
  end;
end;

procedure TFrmGristWizard.sbScrollbarsChange(Sender: TObject);
var sb : TScrollBar;
    i, spos, n : integer;
    totperc, delta : double;
    F : TFermentable;
begin
  if (FSelFerm <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;

    sb:= TScrollBar(sender);
    spos:= sb.Position;
    FSelFerm:= FindFermentable(sb);
    if FSelFerm <> NIL then
    begin
      if (FSelFerm.GrainType = gtBase) or (FSelFerm.FermentableType = ftExtract)
      or (FSelFerm.FermentableType = ftDryExtract) then
        FSelFerm.Percentage.Value:= sb.Position / 10

      else if (FSelFerm.GrainType = gtRoast) or (FSelFerm.GrainType = gtCrystal)
      or (FSelFerm.GrainType = gtKilned) or (FSelFerm.GrainType = gtSour)
      or (FSelFerm.GrainType = gtSpecial) or (FSelFerm.FermentableType = ftAdjunct) then
      begin
        if cbLockSpecialty.Checked and (FRec.NumSpecialtyMalts > 1) then //total percentage of specialty malts must stay the same
        begin
          n:= 0;
          for i:= 0 to FRec.NumSpecialtyMalts - 1 do
          begin
            F:= FRec.SpecialtyMalt[i];
            if (not F.LockPercentage) then Inc(n);
          end;
          totperc:= sbSpecialty.Position / 10;
          delta:= FSelFerm.Percentage.Value - sb.Position / 10;
          if n > 1 then delta:= delta / (n - 1);
          for i:= 0 to FRec.NumSpecialtyMalts - 1 do
          begin
            F:= FRec.SpecialtyMalt[i];
            if F = FSelFerm then
              FSelFerm.Percentage.Value:= sb.Position / 10
            else if (not F.LockPercentage) then
              F.Percentage.Value:= F.percentage.Value + delta;
          end;
        end
        else if cbLockSpecialty.Checked and (FRec.NumSpecialtyMalts = 1) then
        begin
          //nothing changes
        end
        else
          FSelFerm.Percentage.Value:= sb.Position / 10;
      end

      else if (FSelFerm.FermentableType = ftSugar) then
      begin
        if cbLockSugar.Checked and (FRec.NumSugars > 1) then //total percentage of specialty malts must stay the same
        begin
          n:= 0;
          for i:= 0 to FRec.NumSugars - 1 do
          begin
            F:= FRec.Sugar[i];
            if (not F.LockPercentage) then Inc(n);
          end;
          totperc:= sbSugars.Position / 10;
          delta:= FSelFerm.Percentage.Value - sb.Position / 10;
          if n > 1 then delta:= delta / (n - 1);
          for i:= 0 to FRec.NumSugars - 1 do
          begin
            if FRec.Sugar[i] = FSelFerm then
              FSelFerm.Percentage.Value:= sb.Position / 10
            else if (not F.LockPercentage) then
              FRec.Sugar[i].Percentage.Value:= FRec.Sugar[i].percentage.Value + delta;
          end;
        end
        else if cbLockSugar.Checked and (FRec.NumSugars = 1) then
        begin
          //nothing changes
        end
        else
          FSelFerm.Percentage.Value:= sb.Position / 10;
      end;
      FRec.CheckPercentage;
      FRec.CalcFermentablesFromPerc(FRec.EstOG.Value);
      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.cbScrollbarsChange(Sender: TObject);
var cb : TCheckBox;
    i, n: integer;
begin
  if (FSelFerm <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;

    cb:= TCheckBox(sender);
    FSelFerm:= FindFermentable2(cb);
    if FSelFerm <> NIL then
    begin
      FSelFerm.LockPercentage:= cb.Checked;
      if IsBaseMalt(FSelFerm) then
      begin
        n:= 0;
        for i:= 0 to FRec.NumBaseMalts - 1 do
          if FRec.BaseMalt[i].LockPercentage then inc(n);
        if n = (FRec.NumBaseMalts - 1) then
          for i:= 0 to FRec.NumBaseMalts - 1 do
            FRec.BaseMalt[i].LockPercentage:= FSelFerm.LockPercentage;
      end;
      if IsSpecialtyMalt(FSelFerm) then
      begin
        n:= 0;
        for i:= 0 to FRec.NumSpecialtyMalts - 1 do
          if FRec.SpecialtyMalt[i].LockPercentage then inc(n);
        if n = (FRec.NumSpecialtyMalts - 1) then
          for i:= 0 to FRec.NumSpecialtyMalts - 1 do
            FRec.SpecialtyMalt[i].LockPercentage:= FSelFerm.LockPercentage;
      end;
      if IsSugar(FSelFerm) then
      begin
        n:= 0;
        for i:= 0 to FRec.NumSugars - 1 do
          if FRec.Sugar[i].LockPercentage then inc(n);
        if n = (FRec.NumSugars - 1) then
          for i:= 0 to FRec.NumSugars - 1 do
            FRec.Sugar[i].LockPercentage:= FSelFerm.LockPercentage;
      end;
      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.sbSpecialtyChange(Sender: TObject);
var i : integer;
    percold, percnew : double;
    F : TFermentable;
begin
  if FUserClicked and (FRec <> NIL) and (sbSpecialty.Enabled) then
  begin
    FUserClicked:= false;
    bbRemoveBaseMalt.Enabled:= false;
    FSelFerm:= NIL;
    fsePercSpec.Value:= sbSpecialty.Position/10;
    //change the percentage of specialty malts. All specialty malts will change with proportion
    //calculate the 'old' percentage of specialty  malts
    percnew:= sbSpecialty.Position / 10;
    //if percnew = 0 then percnew:= 0.1;
    percold:= 0;
    for i:= 0 to FRec.NumSpecialtyMalts - 1 do
    begin
      F:= FRec.SpecialtyMalt[i];
      if (not F.LockPercentage) then
        percold:= percold + F.Percentage.Value
      else
        percnew:= percnew - F.Percentage.Value;
    end;

    if percold <> 0 then
      for i:= 0 to FRec.NumSpecialtyMalts - 1 do
      begin
        F:= FRec.SpecialtyMalt[i];
        if (not F.LockPercentage) then
          F.Percentage.Value:= F.Percentage.Value * percnew / percold;
      end
    else
      for i:= 0 to FRec.NumSpecialtyMalts - 1 do
      begin
        F:= FRec.SpecialtyMalt[i];
        if (not F.LockPercentage) then
          F.Percentage.Value:= percnew / FRec.NumSpecialtyMalts;
      end;

    FRec.CheckPercentage;
    FRec.CalcFermentablesFromPerc(FRec.EstOG.Value);
    Update;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.fsePercSpecChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    sbSpecialty.Position:= round(fsePercSpec.Value * 10);
    sbSpecialtyChange(sbSpecialty);
  end;
end;

procedure TFrmGristWizard.sbSugarsChange(Sender: TObject);
var i : integer;
    percold, percnew : double;
    F : TFermentable;
begin
  if FUserClicked and (FRec <> NIL) and (sbSugars.Enabled) then
  begin
    FUserClicked:= false;
    bbRemoveBaseMalt.Enabled:= false;
    FSelFerm:= NIL;
    fsePercSug.Value:= sbSugars.Position/10;
    //change the percentage of sugars. All specialty malts will change with proportion
    //calculate the 'old' percentage of specialty  malts
    percnew:= sbSugars.Position / 10;
    percold:= 0;
    for i:= 0 to FRec.NumSugars - 1 do
    begin
      F:= FRec.Sugar[i];
      if (not F.LockPercentage) then
        percold:= percold + F.Percentage.Value
      else
        percnew:= percnew - F.Percentage.Value;
    end;

    if percold <> 0 then
      for i:= 0 to FRec.NumSugars - 1 do
      begin
        F:= FRec.Sugar[i];
        if (not F.LockPercentage) then
          F.Percentage.Value:= F.Percentage.Value * percnew / percold;
      end
    else
      for i:= 0 to FRec.NumSugars - 1 do
      begin
        F:= FRec.Sugar[i];
        if (not F.LockPercentage) then
          F.Percentage.Value:= percnew / FRec.NumSugars;
      end;

    FRec.CheckPercentage;
    FRec.CalcFermentablesFromPerc(FRec.EstOG.Value);
    Update;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.fsePercSugChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    sbSugars.Position:= round(fsePercSug.Value * 10);
    sbSugarsChange(sbSugars);
  end;
end;

procedure TFrmGristWizard.sgBaseMaltDblClick(Sender: TObject);
var ibu, bindex : double;
begin
  if (FRec <> NIL) and (FSelFerm <> NIL) then
  begin
    ibu:= FRec.IBUcalc.Value;
    bindex:= -1;
    if FRec.EstOG.Value > 1 then
      bindex:= ibu / (1000 * (FRec.EstOG.Value - 1));
    FrmFermentables2:= TFrmFermentables2.Create(self);
    FrmFermentables2.Execute(FSelFerm, TRUE, FRec.TotalFermentableMass);
    FrmFermentables2.Free;
    FRec.CheckPercentage;
    if ibu > 0 then
      if Settings.SGBitterness.Value = 0 then
        FRec.AdjustBitterness(ibu)
      else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
        FRec.AdjustBitterness(1000 * (FRec.EstOG.Value - 1) * bIndex);
    FillGrids;
    Update;
  end;
end;

procedure TFrmGristWizard.sgBaseMaltDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : TScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FBaseGridColors)) and (aRow <= High(FBaseGridcolors)) then
  begin
    if aCol = 3 then sgBaseMalt.Canvas.Brush.Color:= FBaseInventoryColors[aRow]
    else sgBaseMalt.Canvas.Brush.Color:= FBaseGridColors[aRow];
  end;
  sgBaseMalt.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgBaseMalt.Canvas.Font.Style:= [fsBold, fsItalic];
    sgBaseMalt.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgBaseMalt.Canvas.Font.Style:= [];
    sgBaseMalt.Canvas.Font.Color:= clBlack;
  end;

  sgBaseMalt.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                            sgBaseMalt.Cells[ACol, ARow]);

  if (sgBaseMalt.Row = aRow) and (sgBaseMalt.Col = aCol) and (sgBaseMalt.Editor = fseGrid) then
  begin
    if (sgBaseMalt.TopRow <= aRow) and (sgBaseMalt.TopRow + round(sgBaseMalt.Height / sgBaseMalt.DefaultRowHeight) > aRow) then
    begin
      rect:= sgBaseMalt.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgBaseMalt.TopRow > FIGSCYBase) or (sgBaseMalt.TopRow + round(sgBaseMalt.Height / sgBaseMalt.DefaultRowHeight) <= FIGSCYBase) then
    fseGrid.Visible:= false;

  sb:= FindScrollBar(sgBaseMalt, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgBaseMalt.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgBaseMalt, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgBaseMalt.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmGristWizard.sgBaseMaltExit(Sender: TObject);
begin
  sgBaseMalt.Editor:= NIL;
  //FSortGrid:= TRUE;
end;

procedure TFrmGristWizard.sgBaseMaltSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgBaseMalt.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelFerm:= FRec.BaseMalt[aRow];
    bbRemoveBaseMalt.Enabled:= TRUE;
    FSelGrid:= 0;
  end;
end;

procedure TFrmGristWizard.sgBaseMaltSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelFerm:= FRec.BaseMalt[sgBaseMalt.Row];
  if (FRec <> NIL) and (FSelGrid = 0) and (FSelFerm <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgBaseMalt.CellRect(aCol, aRow);
    if (Editor = NIL) and (aRow >= 0) and (aCol = 2) and (sgBaseMalt.Cells[sgBaseMalt.Col, sgBaseMalt.Row] <> '') then
    begin
      if (not FSelFerm.AdjustToTotal100.Value) and (not FSelFerm.LockPercentage) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= FSelFerm.Percentage.Decimals;
        fseGrid.MaxValue:= 100;
        fseGrid.Value:= FSelFerm.Percentage.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else
    begin
      Editor:= NIL;
      fseGrid.Visible:= false;
     // FSortGrid:= TRUE;
    end;
    FUserClicked:= TRUE;
  end
  else
    Editor:= NIL;
  if Editor <> NIL then  FIGSCYBase:= aRow
  else FIGSCYBase:= 0;
end;

procedure TFrmGristWizard.sgSpecialtyDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : tScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FSpecialtyGridColors)) and (aRow <= High(FSpecialtyGridcolors)) then
  begin
    if aCol = 3 then sgSpecialty.Canvas.Brush.Color:= FSpecialtyInventoryColors[aRow]
    else sgSpecialty.Canvas.Brush.Color:= FSpecialtyGridColors[aRow];
  end;
  sgSpecialty.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgSpecialty.Canvas.Font.Style:= [fsBold, fsItalic];
    sgSpecialty.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgSpecialty.Canvas.Font.Style:= [];
    sgSpecialty.Canvas.Font.Color:= clBlack;
  end;

  sgSpecialty.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                            sgSpecialty.Cells[ACol, ARow]);

  if (sgSpecialty.Row = aRow) and (sgSpecialty.Col = aCol) and (sgSpecialty.Editor = fseGrid) then
  begin
    if (sgSpecialty.TopRow <= aRow) and (sgSpecialty.TopRow + round(sgSpecialty.Height / sgSpecialty.DefaultRowHeight) > aRow) then
    begin
      rect:= sgSpecialty.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgSpecialty.TopRow > FIGSCYSpecialty) or (sgSpecialty.TopRow + round(sgSpecialty.Height / sgSpecialty.DefaultRowHeight) <= FIGSCYSpecialty) then
    fseGrid.Visible:= false;
  sb:= FindScrollBar(sgSpecialty, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgSpecialty.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgSpecialty, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgSpecialty.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmGristWizard.sgSpecialtyExit(Sender: TObject);
begin
  sgSpecialty.Editor:= NIL;
  //FSortGrid:= TRUE;
end;

procedure TFrmGristWizard.sgSpecialtySelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgSpecialty.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelFerm:= FRec.SpecialtyMalt[aRow];
    bbRemoveBaseMalt.Enabled:= TRUE;
    FSelGrid:= 1;
  end;
end;

procedure TFrmGristWizard.sgSpecialtySelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelFerm:= FRec.SpecialtyMalt[sgSpecialty.Row];
  if (FRec <> NIL) and (FSelGrid = 1) and (FSelFerm <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgSpecialty.CellRect(aCol, aRow);
    if (Editor = NIL) and (aRow >= 0) and (aCol = 2) and (sgSpecialty.Cells[sgSpecialty.Col, sgSpecialty.Row] <> '') then
    begin
      if (not FSelFerm.AdjustToTotal100.Value) and (not FSelFerm.LockPercentage) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= FSelFerm.Percentage.Decimals;
        fseGrid.MaxValue:= 100;
        fseGrid.Value:= FSelFerm.Percentage.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
        //FSortGrid:= TRUE;
      end;
    end
    else
    begin
      Editor:= NIL;
      fseGrid.Visible:= false;
      //FSortGrid:= TRUE;
    end;
    FUserClicked:= TRUE;
  end
  else
    Editor:= NIL;
  if Editor <> NIL then  FIGSCYSpecialty:= aRow
  else FIGSCYSpecialty:= 0;
end;

procedure TFrmGristWizard.sgSugarDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : TScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FSugarGridColors)) and (aRow <= High(FSugarGridcolors)) then
  begin
    if aCol = 3 then sgSugar.Canvas.Brush.Color:= FSugarInventoryColors[aRow]
    else sgSugar.Canvas.Brush.Color:= FSugarGridColors[aRow];
  end;
  sgSugar.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgSugar.Canvas.Font.Style:= [fsBold, fsItalic];
    sgSugar.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgSugar.Canvas.Font.Style:= [];
    sgSugar.Canvas.Font.Color:= clBlack;
  end;

  sgSugar.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                            sgSugar.Cells[ACol, ARow]);

  if (sgSugar.Row = aRow) and (sgSugar.Col = aCol) and (sgSugar.Editor = fseGrid) then
  begin
    if (sgSugar.TopRow <= aRow) and (sgSugar.TopRow + round(sgSugar.Height / sgSugar.DefaultRowHeight) > aRow) then
    begin
      rect:= sgSugar.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgSugar.TopRow > FIGSCYSugar) or (sgSugar.TopRow + round(sgSugar.Height / sgSugar.DefaultRowHeight) <= FIGSCYSugar) then
    fseGrid.Visible:= false;
  sb:= FindScrollBar(sgSugar, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgSugar.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgSugar, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgSugar.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmGristWizard.sgSugarExit(Sender: TObject);
begin
  sgSugar.Editor:= NIL;
  //FSortGrid:= TRUE;
end;

procedure TFrmGristWizard.sgSugarSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgSugar.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelFerm:= FRec.Sugar[aRow];
    FSelGrid:= 2;
    bbRemoveBaseMalt.Enabled:= TRUE;
  end;
end;

procedure TFrmGristWizard.sgSugarSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelFerm:= FRec.Sugar[sgSpecialty.Row];
  if (FRec <> NIL) and (FSelGrid = 2) and (FSelFerm <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgSugar.CellRect(aCol, aRow);
    if (Editor = NIL) and (aRow >= 0) and (aCol = 2) and (sgSugar.Cells[sgSugar.Col, sgSugar.Row] <> '') then
    begin
      if (not FSelFerm.AdjustToTotal100.Value) and (not FSelFerm.LockPercentage) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= FSelFerm.Percentage.Decimals;
        fseGrid.MaxValue:= 100;
        fseGrid.Value:= FSelFerm.Percentage.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
        //FSortGrid:= TRUE;
      end;
    end
    else
    begin
      Editor:= NIL;
      fseGrid.Visible:= false;
      //FSortGrid:= TRUE;
    end;
    FUserClicked:= TRUE;
  end
  else
    Editor:= NIL;
  if Editor <> NIL then  FIGSCYSugar:= aRow
  else FIGSCYSugar:= 0;
end;

procedure TFrmGristWizard.bbAddFermentableClick(Sender: TObject);
var F : TFermentable;
    i, j : integer;
    prca : array of double;
    v, vr : double;
    g : TStringGrid;
    sb : TScrollBar;
begin
  try
    if FRec <> NIL then
      begin
      if FRec.Efficiency <= 0 then
        FRec.Efficiency:= 75;
      sgBaseMalt.Editor:= NIL;
      sgSpecialty.Editor:= NIL;
      sgSugar.Editor:= NIL;

      Setlength(prca, FRec.NumFermentables);
      j:= High(prca);
      for i:= 0 to j do
        prca[i]:= FRec.Fermentable[i].Percentage.Value;

      FrmFermentables3:= TFrmFermentables3.Create(self);
      if FrmFermentables3.Execute(FRec.AddFermentable, TRUE) then
      begin
        F:= FRec.Fermentable[FRec.NumFermentables-1];

      if (cbLockSpecialty.Checked) and IsSpecialtyMalt(F) then
        F.Percentage.Value:= 0;

      if (cbLockSugar.Checked) and IsSugar(F) then
        F.Percentage.Value:= 0;

        v:= F.Percentage.Value;
        for i:= 0 to j do
          FRec.Fermentable[i].Percentage.Value:= prca[i];
        v:= F.Percentage.Value;
        FRec.CheckPercentage;
        v:= F.Percentage.Value;


        FillGrids;
        Update;

        v:= F.Percentage.Value;
        vr:= F.MaxInBatch.Value;
        if (vr > 0) and (v > vr) then
          ShowNotificationModal(self, 'Percentage ' + F.Name.Value + ' is hoger dan het aanbevolen maximum');
      end
      else
        FRec.RemoveFermentable(FRec.NumFermentables-1);
      SetLength(prca, 0);
    end;
  finally
    FrmFermentables3.Free;
   { if FRec.NumIngredients = 1 then
      for i:= 0 to 3 do
        sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;}
  end;
end;

procedure TFrmGristWizard.bbRemoveBaseMaltClick(Sender: TObject);
begin
  if (FRec <> NIL) and (FSelFerm <> NIL) then
  begin
    FRec.RemoveFermentableByReference(FSelFerm);

    FillGrids;

    FRec.CheckPercentage;
    sgBaseMalt.Editor:= NIL;
    sgSpecialty.Editor:= NIL;
    sgSugar.Editor:= NIL;
    FSelFerm:= NIL;
    bbRemoveBaseMalt.Enabled:= false;
    Update;
  end;
end;

procedure TFrmGristWizard.cbLockSpecialtyChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    bbRemoveBaseMalt.Enabled:= false;
    sbSpecialty.Enabled:= not cbLockSpecialty.Checked;
    fsePercSpec.Enabled:= sbSpecialty.Enabled;
    fsePercSpec.ReadOnly:= cbLockSpecialty.Checked;
    FSelFerm:= NIL;
    Update;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmGristWizard.cbLockSugarChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    bbRemoveBaseMalt.Enabled:= false;
    sbSugars.Enabled:= not cbLockSugar.Checked;
    fsePercSug.Enabled:= sbSugars.Enabled;
    fsePercSug.ReadOnly:= cbLockSugar.Checked;
    FSelFerm:= NIL;
    Update;
    FUserClicked:= TRUE;
  end;
end;

end.

