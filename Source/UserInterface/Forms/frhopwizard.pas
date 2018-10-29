unit frhopwizard;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, ComCtrls, Grids, Buttons, Data, positieinterval;

type

  { TFrmHopWizard }

  TScrollRec = record
    SB : TScrollBar;
    cb : TCheckBox;
    row, colsb, colcb : integer;
    grid : TStringGrid;
    Hop : THop;
  end;

  TFrmHopWizard = class(TForm)
    bbAddHop: TBitBtn;
    bbRemoveHop: TBitBtn;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbLockIBU: TCheckBox;
    cbLockFlavour: TCheckBox;
    cbLockAroma: TCheckBox;
    fseGrid: TFloatSpinEdit;
    fseIBU: TFloatSpinEdit;
    fseFlavour: TFloatSpinEdit;
    fseAroma: TFloatSpinEdit;
    gbBitter: TGroupBox;
    gbFlavour: TGroupBox;
    gbAroma: TGroupBox;
    gbProperties: TGroupBox;
    GroupBox2: TGroupBox;
    hcBitter: THeaderControl;
    hcAroma: THeaderControl;
    hcFlavour: THeaderControl;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lBUGU: TLabel;
    lIBUmax: TLabel;
    lIBUMin: TLabel;
    pbFlavour: TProgressBar;
    pbAroma: TProgressBar;
    sbIBU: TScrollBar;
    sbFlavour: TScrollBar;
    sbAroma: TScrollBar;
    sgBitter: TStringGrid;
    sgFlavour: TStringGrid;
    sgAroma: TStringGrid;
    procedure bbAddHopClick(Sender: TObject);
    procedure bbRemoveHopClick(Sender: TObject);
    procedure cbLockAromaChange(Sender: TObject);
    procedure cbLockFlavourChange(Sender: TObject);
    procedure cbLockIBUChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseAromaChange(Sender: TObject);
    procedure fseFlavourChange(Sender: TObject);
    procedure fseGridChange(Sender: TObject);
    procedure fseIBUChange(Sender: TObject);
    procedure sbAromaChange(Sender: TObject);
    procedure sbFlavourChange(Sender: TObject);
    procedure sbIBUChange(Sender: TObject);
    procedure sgAromaDblClick(Sender: TObject);
    procedure sgAromaDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgAromaExit(Sender: TObject);
    procedure sgAromaSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgAromaSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure sgBitterDblClick(Sender: TObject);
    procedure sgBitterDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgBitterExit(Sender: TObject);
    procedure sgBitterSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgBitterSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure sgFlavourDblClick(Sender: TObject);
    procedure sgFlavourDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgFlavourExit(Sender: TObject);
    procedure sgFlavourSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgFlavourSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
  private
    { private declarations }
    FRec : TRecipe;
    FUserClicked : boolean;
    FSelHop : THop;
    FSelGrid : integer;
    FIGSCYBitter, FIGSCYFlavour, FIGSCYAroma : integer;
    FBitterGridColors, FFlavourGridColors, FAromaGridColors : array of TColor;
    FBitterInventoryColors, FFlavourInventoryColors, FAromaInventoryColors : array of TColor;
    FScrollBars : array of TScrollRec;
    piIBU, piBUGU : TPosInterval;
    Function NumBitter : integer;
    Function NumFlavour : integer;
    Function NumAroma : integer;
    Function BitterHop(i : integer) : THop;
    Function FlavourHop(i : integer) : THop;
    Function AromaHop(i : integer) : THop;
    Function IsBitterHop(H : THop) : boolean;
    Function IsFlavourHop(H : THop) : boolean;
    Function IsAromaHop(H : THop) : boolean;
    Procedure FillGrids;
    Procedure Update;
    Procedure ChangeIBU;
    Function FindHopScrollBar : TScrollBar;
    Function FindScrollBar(sg : TStringGrid; aCol, aRow : integer) : TScrollBar;
    Function FindCheckBox(sg : TStringGrid; aCol, aRow : integer) : TCheckBox;
    Function FindHop(sb : TScrollBar) : THop;
    Function FindHop2(cb : TCheckBox) : THop;
    Function FindNum(H : THop) : integer;
    procedure sbScrollbarsChange(Sender: TObject);
    procedure cbScrollbarsChange(Sender: TObject);
  public
    { public declarations }
    Function Execute(R : TRecipe) : boolean;
  end;

var
  FrmHopWizard: TFrmHopWizard;

implementation

{$R *.lfm}
uses hulpfuncties, Containers, frhop2, frhop3;

{ TFrmHopWizard }
const
  TasteBound = 30;
  AromaBound = 10;
  TasteVeryHigh = 5;
  AromaVeryHigh = 6;

procedure TFrmHopWizard.FormCreate(Sender: TObject);
begin
  FUserClicked:= TRUE;
  FSelHop:= NIL;
  FSelGrid:= -1;

  gbFlavour.Caption:= gbFlavour.Caption + ' (' + IntToStr(AromaBound) + ' tot ' +
                      IntToStr(TasteBound) + ' min. meekoken)';
  gbAroma.Caption:= gbAroma.Caption + ' ( korter dan ' + IntToStr(AromaBound) + ' min. meekoken)';

  FIGSCYBitter:= 0; FIGSCYFlavour:= 0; FIGSCYAroma:= 0;

  piBUGU:= TPosInterval.Create(gbProperties);
  piBUGU.Parent:= gbProperties;
  piBUGU.Left:= 3;
  piBUGU.Top:= 25;
  piBUGU.Width:= 170;
  piBUGU.Height:= 40;
  piBUGU.Font.Height:= Font.Height;
  piBUGU.Caption:= 'BU/GU: ';
  piBUGU.ShowValues:= false;
  piBUGU.Effect:= ePlain;
  piBUGU.Decimals:= 0;
  piBUGU.Min:= 0;
  piBUGU.Max:= 1.5;
  piBUGU.Value:= 0.75;
  piBUGU.Color:= gbProperties.Color;

  piIBU:= TPosInterval.Create(gbProperties);
  piIBU.Parent:= gbProperties;
  piIBU.Left:= 3;
  piIBU.Top:= 70;
  piIBU.Width:= 170;
  piIBU.Height:= 40;
  piIBU.Font.Height:= Font.Height;
  piIBU.Caption:= 'IBU: ';
  piIBU.ShowValues:= false;
  piIBU.Effect:= ePlain;
  piIBU.Decimals:= 0;
  piIBU.Min:= 0;
  piIBU.Max:= 100;
  piIBU.Value:= 50;
  piIBU.Color:= gbProperties.Color;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmHopWizard.FormDestroy(Sender: TObject);
var i : integer;
begin
  for i:= 0 to High(FScrollBars) do
  begin
    FreeAndNIL(FScrollBars[i].SB);
    FreeAndNIL(FScrollBars[i].cb);
  end;
  SetLength(FScrollBars, 0);
  SetLength(FBitterGridColors, 0);
  SetLength(FFlavourGridColors, 0);
  SetLength(FAromaGridColors, 0);
  SetLength(FBitterInventoryColors, 0);
  SetLength(FFlavourInventoryColors, 0);
  SetLength(FAromaInventoryColors, 0);
  FreeAndNIL(piIBU);
  FreeAndNIL(piBUGU);
end;

Function TFrmHopWizard.NumBitter : integer;
var i : integer;
    H : THop;
    bt : double;
begin
  Result:= 0;
  if FRec <> NIL then
  begin
    for i:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[i];
      bt:= H.Time.Value;
      if bt > TasteBound then Inc(Result);
    end;
  end;
end;

Function TFrmHopWizard.NumFlavour : integer;
var i : integer;
    H : THop;
    bt : double;
begin
  Result:= 0;
  if FRec <> NIL then
  begin
    for i:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[i];
      bt:= H.Time.Value;
      if (bt <= TasteBound) and (bt > AromaBound) then Inc(Result);
    end;
  end;
end;

Function TFrmHopWizard.NumAroma : integer;
var i : integer;
    H : THop;
    bt : double;
begin
  Result:= 0;
  if FRec <> NIL then
  begin
    for i:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[i];
      bt:= H.Time.Value;
      if bt <= AromaBound then Inc(Result);
    end;
  end;
end;

Function TFrmHopWizard.BitterHop(i : integer) : THop;
var j, n : integer;
    H : THop;
begin
  Result:= NIL;
  if FRec <> NIL then
  begin
    n:= -1;
    for j:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[j];
      if IsBitterHop(H) then
      begin
        Inc(n);
        if n = i then
        begin
          Result:= H;
          Exit;
        end;
      end;
    end;
  end;
end;

Function TFrmHopWizard.FlavourHop(i : integer) : THop;
var j, n : integer;
    H : THop;
begin
  Result:= NIL;
  if FRec <> NIL then
  begin
    n:= -1;
    for j:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[j];
      if IsFlavourHop(H) then
      begin
        Inc(n);
        if n = i then
        begin
          Result:= H;
          Exit;
        end;
      end;
    end;
  end;
end;

Function TFrmHopWizard.AromaHop(i : integer) : THop;
var j, n : integer;
    H : THop;
begin
  Result:= NIL;
  if FRec <> NIL then
  begin
    n:= -1;
    for j:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[j];
      if IsAromaHop(H) then
      begin
        Inc(n);
        if n = i then
        begin
          Result:= H;
          Exit;
        end;
      end;
    end;
  end;
end;

Function TFrmHopWizard.IsBitterHop(H : THop) : boolean;
var bt : double;
begin
  Result:= false;
  if H <> NIL then
  begin
    bt:= H.Time.Value;
    Result:= (bt > TasteBound);
  end;
end;

Function TFrmHopWizard.IsFlavourHop(H : THop) : boolean;
var bt : double;
begin
  Result:= false;
  if H <> NIL then
  begin
    bt:= H.Time.Value;
    Result:= (bt <= TasteBound) and (bt > AromaBound);
  end;
end;

Function TFrmHopWizard.IsAromaHop(H : THop) : boolean;
var bt : double;
begin
  Result:= false;
  if H <> NIL then
  begin
    bt:= H.Time.Value;
    Result:= (bt <= AromaBound);
  end;
end;

Function TFrmHopWizard.Execute(R : TRecipe) : boolean;
var s : string;
    H : THop;
begin
  if R <> NIL then
  begin
    FRec:= TRecipe.Create(NIL);
    FRec.Assign(R);
    FRec.SortHops(9, 2, true, true);
    FUserclicked:= false;
    FSelHop:= NIL;
    bbRemoveHop.Enabled:= false;

    fseIBU.MinValue:= 0;
    fseIBU.MaxValue:= MaxD(100, 1.2 * FRec.IBUcalc.DisplayValue);
    fseIBU.DecimalPlaces:= 0;
    fseIBU.Value:= FRec.IBUcalc.DisplayValue;

    lIBUMin.Caption:= RealToStrDec(fseIBU.MinValue, fseIBU.DecimalPlaces);
    lIBUMax.Caption:= RealToStrDec(fseIBU.MaxValue, fseIBU.DecimalPlaces);
    sbIBU.Position:= round((fseIBU.Value - fseIBU.MinValue)
                           * (sbIBU.Max - sbIBU.Min) / (fseIBU.MaxValue - fseIBU.MinValue)
                           + sbIBU.Min);

    H:= FRec.Hop[0];
    if H <> NIL then s:= H.Amount.DisplayUnitString + '/' + FRec.BatchSize.DisplayUnitString
    else s:= 'g/l';
    hcBitter.Sections[3].Text:= s;
    hcFlavour.Sections[3].Text:= s;
    hcAroma.Sections[3].Text:= s;
    Label4.Caption:= s;
    Label5.Caption:= s;

    FillGrids;

    Update;

    Result:= (ShowModal = mrOK);
    if Result then
      R.Assign(FRec);

    FRec.Free;
  end;
end;

Procedure TFrmHopWizard.FillGrids;
var i, numbit, numflav, numaro : integer;
    H, Ho : THop;
    s : string;
    ibu, gpl, n, ni : double;
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
    SetLength(FBitterGridColors, 0);
    SetLength(FFlavourGridColors, 0);
    SetLength(FAromaGridColors, 0);
    SetLength(FBitterInventoryColors, 0);
    SetLength(FFlavourInventoryColors, 0);
    SetLength(FAromaInventoryColors, 0);

    numbit:= NumBitter;
    numflav:= NumFlavour;
    numaro:= NumAroma;
    SetLength(FBitterGridColors, numbit);
    SetLength(FBitterInventoryColors, numbit);
    SetLength(FFlavourGridColors, numflav);
    SetLength(FFlavourInventoryColors, numflav);
    SetLength(FAromaGridColors, numaro);
    SetLength(FAromaInventoryColors, numaro);

    FUserClicked:= TRUE;

    sgBitter.RowCount:= numbit;
    for i:= 0 to numbit - 1 do
    begin
      H:= BitterHop(i);
      sgBitter.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgBitter.Cells[1, i]:= s;
      FBitterGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      sgBitter.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgBitter.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgBitter.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgBitter.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FBitterInventoryColors[i]:= FBitterGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.Value;
      if Ho <> NIL then ni:= Ho.Inventory.Value
      else ni:= 0;
      if n > ni then FBitterInventoryColors[i]:= clRed;

      sgBitter.RowHeights[i]:= 20;

      SetLength(FScrollBars, High(FScrollBars) + 2);
      FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgBitter);
      FScrollBars[High(FScrollBars)].colsb:= 5;
      FScrollBars[High(FScrollBars)].row:= i;
      FScrollBars[High(FScrollBars)].grid:= sgBitter;
      FScrollBars[High(FScrollBars)].Hop:= H;
      sb:= FScrollBars[High(FScrollBars)].SB;
      sb.Parent:= sgBitter;
      sb.Min:= 0;
      sb.OnChange:= @sbScrollBarsChange;
      sb.SmallChange:= 1;
      sb.LargeChange:= 10;
      FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgBitter);
      FScrollBars[High(FScrollBars)].colcb:= 6;
      cb:= FScrollBars[High(FScrollBars)].cb;
      cb.Parent:= sgBitter;
      cb.Caption:= '';
      cb.Checked:= H.Lock;
      cb.Color:= HopColor;
      cb.OnChange:= @cbScrollBarsChange;
    end;

    sgFlavour.RowCount:= numflav;
    for i:= 0 to numflav - 1 do
    begin
      H:= FlavourHop(i);
      sgFlavour.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgFlavour.Cells[1, i]:= s;
      FFlavourGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      sgFlavour.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgFlavour.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgFlavour.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgFlavour.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FFlavourInventoryColors[i]:= FFlavourGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.Value;
      if Ho <> NIL then ni:= Ho.Inventory.Value
      else ni:= 0;
      if n > ni then FFlavourInventoryColors[i]:= clRed;

      sgFlavour.RowHeights[i]:= 20;

      SetLength(FScrollBars, High(FScrollBars) + 2);
      FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgFlavour);
      FScrollBars[High(FScrollBars)].colsb:= 5;
      FScrollBars[High(FScrollBars)].row:= i;
      FScrollBars[High(FScrollBars)].grid:= sgFlavour;
      FScrollBars[High(FScrollBars)].Hop:= H;
      sb:= FScrollBars[High(FScrollBars)].SB;
      sb.Parent:= sgFlavour;
      sb.SmallChange:= 1;
      sb.LargeChange:= 10;
      sb.Min:= 0;
      sb.Max:= round(1.5 * 10 * TasteVeryHigh);
      sb.OnChange:= @sbScrollBarsChange;
      FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgFlavour);
      FScrollBars[High(FScrollBars)].colcb:= 6;
      cb:= FScrollBars[High(FScrollBars)].cb;
      cb.Parent:= sgFlavour;
      cb.Caption:= '';
      cb.Checked:= H.Lock;
      cb.Color:= HopColor;
      cb.OnChange:= @cbScrollBarsChange;
    end;

    sgAroma.RowCount:= numaro;
    for i:= 0 to numaro - 1 do
    begin
      H:= AromaHop(i);
      sgAroma.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgAroma.Cells[1, i]:= s;
      FAromaGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      sgAroma.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgAroma.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgAroma.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgAroma.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FAromaInventoryColors[i]:= FAromaGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.Value;
      if Ho <> NIL then ni:= Ho.Inventory.Value
      else ni:= 0;
      if n > ni then FAromaInventoryColors[i]:= clRed;

      sgAroma.RowHeights[i]:= 20;

      SetLength(FScrollBars, High(FScrollBars) + 2);
      FScrollBars[High(FScrollBars)].SB:= TScrollBar.Create(sgAroma);
      FScrollBars[High(FScrollBars)].colsb:= 5;
      FScrollBars[High(FScrollBars)].row:= i;
      FScrollBars[High(FScrollBars)].grid:= sgAroma;
      FScrollBars[High(FScrollBars)].Hop:= H;
      sb:= FScrollBars[High(FScrollBars)].SB;
      sb.Parent:= sgAroma;
      sb.Min:= 0;
      sb.Max:= round(1.5 * 10 * AromaVeryHigh);
      sb.OnChange:= @sbScrollBarsChange;
      sb.SmallChange:= 1;
      sb.LargeChange:= 10;
      FScrollBars[High(FScrollBars)].cb:= TCheckBox.Create(sgAroma);
      FScrollBars[High(FScrollBars)].colcb:= 6;
      cb:= FScrollBars[High(FScrollBars)].cb;
      cb.Parent:= sgAroma;
      cb.Caption:= '';
      cb.Checked:= H.Lock;
      cb.Color:= HopColor;
      cb.OnChange:= @cbScrollBarsChange;
    end;
  end;
end;

Procedure TFrmHopWizard.Update;
var i, j, nbit, nflav, naro : integer;
    H, Ho : THop;
    s : string;
    conc, n, ni, ibu, gpl, totbitter, totflavour, totaroma, vol  : double;
    ibubitter, ibuflavour, ibuaroma : double;
    allflavourlocked, allaromalocked : boolean;
    sb : TScrollBar;
    cb : TCheckBox;
    Rect : TRect;
    St : TBeerStyle;
begin
  FUserClicked:= false;

  totbitter:= 0;
  totflavour:= 0;
  totaroma:= 0;
  ibubitter:= 0;
  ibuflavour:= 0;
  ibuaroma:= 0;

  if FRec <> NIL then
  begin
    for i:= 0 to sgBitter.RowCount - 1 do
      for j:= 0 to 4 do
        sgBitter.Cells[j, i]:= '';
    for i:= 0 to sgFlavour.RowCount - 1 do
      for j:= 0 to 4 do
        sgFlavour.Cells[j, i]:= '';
    for i:= 0 to sgAroma.RowCount - 1 do
      for j:= 0 to 4 do
        sgAroma.Cells[j, i]:= '';

    nbit:= NumBitter;
    nflav:= NumFlavour;
    naro:= NumAroma;
    sgBitter.RowCount:= nbit;
    sgFlavour.RowCount:= nflav;
    sgAroma.RowCount:= naro;

    fseIBU.Value:= FRec.IBUcalc.DisplayValue;
    sbIBU.Position:= round(fseIBU.Value * 10);

    for i:= 0 to nbit - 1 do
    begin
      H:= BitterHop(i);
      sgBitter.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgBitter.Cells[1, i]:= s;
      FBitterGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      ibubitter:= ibubitter + ibu;
      sgBitter.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgBitter.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgBitter.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgBitter.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FBitterInventoryColors[i]:= FBitterGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.DisplayValue;
      if Ho <> NIL then ni:= Ho.Inventory.DisplayValue
      else ni:= 0;
      if n > ni then FBitterInventoryColors[i]:= clRed;

      sgBitter.RowHeights[i]:= 20;
      totbitter:= totbitter + n;
    end;

    for i:= 0 to numflavour - 1 do
    begin
      H:= FlavourHop(i);
      sgFlavour.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgFlavour.Cells[1, i]:= s;
      FFlavourGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      ibuflavour:= ibuflavour + ibu;
      sgFlavour.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgFlavour.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgFlavour.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgFlavour.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FFlavourInventoryColors[i]:= FFlavourGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.DisplayValue;
      if Ho <> NIL then ni:= Ho.Inventory.DisplayValue
      else ni:= 0;
      if n > ni then FFlavourInventoryColors[i]:= clRed;

      sgFlavour.RowHeights[i]:= 20;
      totflavour:= totflavour + n;
    end;

    for i:= 0 to numaroma - 1 do
    begin
      H:= AromaHop(i);
      sgAroma.Cells[0, i]:= H.Amount.DisplayString;
      s:= H.Name.Value;
      case H.Use of
      huBoil:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
      end;
      huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
      begin
        s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
      end;
      end;
      sgAroma.Cells[1, i]:= s;
      FAromaGridColors[i]:= HopColor;

      ibu:= H.BitternessContribution;
      ibuaroma:= ibuaroma + ibu;
      sgAroma.Cells[2, i]:= RealToStrDec(ibu, 1);
      gpl:= H.Amount.DisplayValue / FRec.BatchSize.DisplayValue;
      sgAroma.Cells[3, i]:= RealToStrDec(gpl, 1);
      Ho:= Hops.FindByNameAndOriginAndAlfa(H.Name.Value, H.Origin.Value, H.Alfa.Value);
      if Ho <> NIL then sgAroma.Cells[4, i]:= Ho.Inventory.DisplayString
      else sgAroma.Cells[4, i]:= RealToStrDec(0, H.Amount.Decimals) + ' ' + H.Amount.DisplayUnitString;

      FAromaInventoryColors[i]:= FAromaGridColors[i];
      s:= H.Name.Value;
      n:= H.Amount.DisplayValue;
      if Ho <> NIL then ni:= Ho.Inventory.DisplayValue
      else ni:= 0;
      if n > ni then FAromaInventoryColors[i]:= clRed;

      sgAroma.RowHeights[i]:= 20;
      totaroma:= totaroma + n;
    end;

    vol:= FRec.BatchSize.DisplayValue;
    if vol > 0 then
    begin
//      sbFlavour.Max:= MaxI(50, round(1.5 * 10 * totflavour / vol));
      sbFlavour.Max:= round(1.5 * 10 * TasteVeryHigh);
      fseFlavour.MaxValue:= round(1.5 * TasteVeryHigh);
      sbFlavour.Position:= round(10 * totflavour / vol);
      fseFlavour.Value:= totflavour / vol;
//      sbAroma.Max:= MaxI(60, round(1.5 * 10 * totaroma / vol));
      sbAroma.Max:= round(1.5 * 10 * AromaVeryHigh);
      fseAroma.MaxValue:= round(1.5 * AromaVeryHigh);
      sbAroma.Position:= round(10 * totaroma / vol);
      fseAroma.Value:= totaroma / vol;
    end
    else
    begin
      sbFlavour.Position:= 0;
      sbFlavour.Max:= 50;
      fseFlavour.Value:= 0;
      sbAroma.Position:= 0;
      sbAroma.Max:= 60;
      fseAroma.Value:= 0;
    end;
    fseFlavour.MaxValue:= sbFlavour.Max / 10;
    fseFlavour.Value:= sbFlavour.Position/10;
    fseAroma.MaxValue:= sbAroma.Max / 10;
    fseAroma.Value:= sbAroma.Position/10;


    if sgBitter.RowCount > 0 then
      for i:= 0 to 6 do
        sgBitter.ColWidths[i]:= hcBitter.Sections[i].Width;
    if sgFlavour.RowCount > 0 then
      for i:= 0 to 6 do
        sgFlavour.ColWidths[i]:= hcFlavour.Sections[i].Width;
    if sgAroma.RowCount > 0 then
      for i:= 0 to 6 do
        sgAroma.ColWidths[i]:= hcAroma.Sections[i].Width;

    allflavourlocked:= TRUE; allaromalocked:= TRUE;
    for i:= 0 to High(FScrollBars) do
    begin
      H:= FScrollBars[i].Hop;
      sb:= FScrollBars[i].SB;
      sb.Enabled:= not FScrollBars[i].cb.Checked;
      if (not FScrollBars[i].cb.Checked) then
        if FScrollBars[i].grid = sgFlavour then allflavourlocked:= false
        else if FScrollBars[i].grid = sgAroma then allaromalocked:= false;

      if FScrollBars[i].grid = sgBitter then
      begin
        if cbLockIBU.Checked then
        begin
          n:= ibubitter;
          sb.Max:= round(10 * n);
        end
        else sb.Max:= 1000;
        n:= FScrollBars[i].Hop.BitternessContribution;
//        if n > sb.Max / 10 then sb.Max:= round(1.2 * 10 * conc);
        sb.Position:= round(10 * n);
      end;

      if FScrollBars[i].grid = sgFlavour then
      begin
        if cbLockFlavour.Checked then //total amount of flavour hops must stay the same
          sb.Max:= round(10 * totflavour / vol)
        else
          sb.Max:= 60;
        conc:= H.Amount.DisplayValue / vol;
       // if conc > sb.Max / 10 then sb.Max:= round(1.2 * 10 * conc);
        sb.Position:= round(10 * conc);
      end;

      if FScrollBars[i].grid = sgAroma then
      begin
        if cbLockAroma.Checked then //total amount of aroma hops must stay the same
          sb.Max:= round(10 * totaroma / vol)
        else
          sb.Max:= 100;
        conc:= H.Amount.DisplayValue / vol;
        //if conc > sb.Max / 10 then sb.Max:= round(1.2 * 10 * conc);
        sb.Position:= round(10 * conc);
      end;
    end;

    if allflavourlocked and (NumFlavour > 0) then
    begin
      cbLockFlavour.Checked:= TRUE;
      sbFlavour.Enabled:= false;
      fseFlavour.Enabled:= false;
    end
    {else
    begin
      cbLockSpecialty.Checked:= false;
      sbSpecialty.Enabled:= (FRec.NumSpecialtyMalts > 0) and (not cbLockSpecialty.Checked);
    end};
    if allaromalocked and (NumAroma > 0) then
    begin
      cbLockAroma.Checked:= TRUE;
      sbAroma.Enabled:= false;
      fseAroma.Enabled:= false;
    end
    {else
    begin
      cbLockSugar.Checked:= false;
      sbSugars.Enabled:= (FRec.NumSugars > 0) and (not cbLockSugar.Checked);
    end};

    ibu:= FRec.IBUcalc.Value;
    ni:= FRec.EstOG.Value;
    if ni > 1 then
      ni:= ibu / (1000 * (ni - 1));
    s:= RealToStrDec(ni, 2);
    lBUGU.Caption:= 'Bitterheidsindex: ' + s;
    St:= FRec.Style;
    n:= St.BUGUMin;
    piBUGU.Low:= n;
    n:= St.BUGUMax;
    piBUGU.High:= n;
    piBUGU.Value:= ni;
    piBUGU.Max:= MaxD(1.25 * piBUGU.High, 1.1 * ni);

    piIBU.Min:= MaxA([0, MinD(0.7 * ibu, 0.7 * St.IBUMin.Value)]);
    piIBU.Max:= MaxD(1.25 * St.IBUMax.Value, 1.1 * ibu);
    n:= St.IBUMIn.Value;
    piIBU.Low:= n;
    n:= St.IBUMax.Value;
    piIBU.High:= n;
    piIBU.Value:= ibu;

    n:= 0; ni:= 0;
    for i:= 0 to FRec.NumHops - 1 do
    begin
      H:= FRec.Hop[i];
      n:= n + H.FlavourContribution;
      ni:= ni + H.AromaContribution;
    end;

    //assume very high at HopVeryHigh g/l
    n:= 100 * n / TasteVeryHigh;
    if n > 100 then n:= 100;
    ni:= 100 * ni / AromaVeryHigh;
    if ni > 100 then ni:= 100;
    pbFlavour.Position:= round(n);
    pbAroma.Position:= round(ni);

    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.fseIBUChange(Sender: TObject);
begin
  if FUserclicked then
  begin
    FUserClicked:= false;
    sbIBU.Position:= round(fseIBU.Value * 10);
    ChangeIBU;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.sbIBUChange(Sender: TObject);
begin
  if FUserclicked then
  begin
    FUserClicked:= false;
    fseIBU.Value:= sbIBU.Position / 10;
    ChangeIBU;
    FUserClicked:= TRUE;
  end;
end;

Procedure TFrmHopWizard.ChangeIBU;
begin
  FRec.AdjustBitterness(fseIBU.Value);
  Update;
end;

Function TFrmHopWizard.FindHopScrollBar : TScrollBar;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if FScrollBars[i].Hop = FSelHop then
    begin
      Result:= FScrollBars[i].SB;
      Exit;
    end;
end;

Function TFrmHopWizard.FindScrollBar(sg : TStringGrid; aCol, aRow : integer) : TScrollBar;
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

Function TFrmHopWizard.FindCheckBox(sg : TStringGrid; aCol, aRow : integer) : TCheckBox;
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

Function TFrmHopWizard.FindHop(sb : TScrollBar) : THop;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].SB = sb) then
    begin
      Result:= FScrollBars[i].Hop;
      Exit;
    end;
end;

Function TFrmHopWizard.FindHop2(cb : TCheckBox) : THop;
var i : integer;
begin
  Result:= NIL;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].cb = cb) then
    begin
      Result:= FScrollBars[i].Hop;
      Exit;
    end;
end;

Function TFrmHopWizard.FindNum(H : THop) : integer;
var i : integer;
begin
  Result:= -1;
  for i:= 0 to High(FScrollBars) do
    if (FScrollBars[i].Hop = H) then
    begin
      Result:= i;
      Exit;
    end;
end;

procedure TFrmHopWizard.fseGridChange(Sender: TObject);
var v : double;
    i : integer;
begin
  if (FSelHop <> NIL) and (FUserClicked) and (fseGrid.Modified) then
  begin
    FUserClicked:= false;
    if FSelGrid = 0 then i:= sgBitter.Col
    else if FSelGrid = 1 then i:= sgFlavour.Col
    else if FSelGrid = 2 then i:= sgAroma.Col
    else i:= -1;

    if i = 0 then
      FSelHop.Amount.DisplayValue:= fseGrid.Value
    else if i = 2 then
      FSelHop.BitternessContribution:= fseGrid.Value
    else if i = 3 then
      FSelHop.Amount.DisplayValue:= fseGrid.Value * FRec.BatchSize.DisplayValue;

    if cbLockIBU.Checked then
    begin
      v:= fseIBU.Value;
      FRec.AdjustBitterness(v);
    end;

    Update;
    fseGrid.Enabled:= TRUE;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.sbScrollbarsChange(Sender: TObject);
var sb : TScrollBar;
    i, spos, n : integer;
    vol, conc, amount, tot, delta : double;
    H : THop;
    ibuold, ibunew, ibufa, ibu : double;
begin
  if (FRec <> NIL) and (FSelHop <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;

    sb:= TScrollBar(sender);

    spos:= sb.Position;
    FSelHop:= FindHop(sb);

    vol:= FRec.BatchSize.DisplayValue;
    conc:= sb.Position / 10;
    amount:= conc * vol;

    if (FSelHop <> NIL) and (vol > 0) then
    begin
      if IsBitterHop(FSelHop) then
      begin
        ibu:= sb.Position / 10;
        if cbLockIBU.Checked then
        begin
          if NumBitter > 1 then
          begin
            ibuold:= fseIBU.Value;
            FSelHop.BitternessContribution:= ibu;
            FRec.CalcBitterness;
            ibunew:= FRec.IBUcalc.Value;
            delta:= ibuold - ibunew;
            for i:= 0 to NumBitter - 1 do
            begin
              H:= BitterHop(i);
              if H <> FSelHop then
                H.BitternessContribution:= H.BitternessContribution + delta / (NumBitter - 1);
            end;
          end;
        end
        else
          FSelHop.BitternessContribution:= ibu;
      end
      else if IsFlavourHop(FSelHop) then
      begin
        if cbLockFlavour.Checked and (NumFlavour > 1) then
        begin
          n:= 0;
          for i:= 0 to NumFlavour - 1 do
          begin
            H:= FlavourHop(i);
            if (not H.Lock) then inc(n);
          end;
          delta:= FSelHop.Amount.DisplayValue - amount;
          if n > 1 then
          begin
            for i:= 0 to NumFlavour - 1 do
            begin
              H:= FlavourHop(i);
              if H = FSelHop then FSelHop.Amount.DisplayValue:= amount
              else if (not H.Lock) then H.Amount.DisplayValue:= H.Amount.DisplayValue + delta / (n - 1);
            end;
          end;
          if cbLockIBU.Checked then
          begin
            ibu:= sb.Position / 10;
            if NumBitter > 1 then
            begin
              ibuold:= fseIBU.Value;
//              FSelHop.BitternessContribution:= ibu;
              FRec.CalcBitterness;
              ibunew:= FRec.IBUcalc.Value;
              delta:= ibuold - ibunew;
              for i:= 0 to NumBitter - 1 do
              begin
                H:= BitterHop(i);
                H.BitternessContribution:= H.BitternessContribution + delta / (NumBitter - 1);
              end;
            end;
          end;
        end
        else if cbLockFlavour.Checked and (NumFlavour = 1) then
        begin
          //nothing changes
        end
        else
        begin
          FSelHop.Amount.DisplayValue:= amount;
        end;
        if cbLockIBU.Checked then
        begin
          ibuold:= fseIBU.Value;
          FRec.AdjustBitterness(ibuold);
        end;
      end
      else if IsAromaHop(FSelHop) then
      begin
        if cbLockAroma.Checked and (NumAroma > 1) then
        begin
          n:= 0;
          for i:= 0 to NumAroma - 1 do
          begin
            H:= AromaHop(i);
            if (not H.Lock) then inc(n);
          end;
          delta:= FSelHop.Amount.DisplayValue - amount;
          if n > 1 then
          begin
            for i:= 0 to NumAroma - 1 do
            begin
              H:= AromaHop(i);
              if H = FSelHop then FSelHop.Amount.DisplayValue:= amount
              else if (not H.Lock) then H.Amount.DisplayValue:= H.Amount.DisplayValue + delta / (n - 1);
            end;
          end;
        end
        else if cbLockAroma.Checked and (NumAroma = 1) then
        begin
          //nothing changes
        end
        else
          FSelHop.Amount.DisplayValue:= amount;
        if cbLockIBU.Checked then
        begin
          ibuold:= fseIBU.Value;
          FRec.AdjustBitterness(ibuold);
        end;
      end;
      FRec.CalcBitterness;
      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.cbScrollbarsChange(Sender: TObject);
var cb : TCheckBox;
    i: integer;
    H : THop;
    alllocked : boolean;
begin
  if (FSelHop <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;

    cb:= TCheckBox(sender);
    FSelHop:= FindHop2(cb);
    if FSelHop <> NIL then
    begin
      FSelHop.Lock:= cb.Checked;
      if (cbLockIBU.Checked) and (IsBitterHop(FSelHop)) then
      begin
        alllocked:= TRUE;
        for i:= 0 to NumBitter - 1 do
        begin
          H:= BitterHop(i);
          if (H <> NIL) and (not H.Lock) then
            alllocked:= false;
        end;
        if alllocked then
        begin
          cbLockIBU.Checked:= false;
          bbRemoveHop.Enabled:= false;
          sbIBU.Enabled:= not cbLockIBU.Checked;
          fseIBU.Enabled:= sbIBU.Enabled;
          fseIBU.ReadOnly:= cbLockIBU.Checked;
        end;
      end;
      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.sbFlavourChange(Sender: TObject);
var i : integer;
    concold, concnew, vol, oldibu : double;
    H : THop;
begin
  if FUserClicked and (FRec <> NIL) then
  begin
    FUserClicked:= false;
    oldibu:= FRec.IBUcalc.Value;
    vol:= FRec.BatchSize.DisplayValue;
    if vol > 0 then
    begin
      bbRemoveHop.Enabled:= false;
      FSelHop:= NIL;
      fseFlavour.Value:= sbFlavour.Position/10;
      //change the concentrations of flavour hops. All hops will change with proportion
      //calculate the 'old' concentration of flavour hops
      concnew:= sbFlavour.Position / 10;
      concold:= 0;
      for i:= 0 to NumFlavour - 1 do
      begin
        H:= FlavourHop(i);
        if (not H.Lock) then
          concold:= concold + H.Amount.DisplayValue / vol
        else
          concnew:= concnew - H.Amount.DisplayValue / vol;
      end;

      if concold <> 0 then
        for i:= 0 to NumFlavour - 1 do
        begin
          H:= FlavourHop(i);
          if (not H.Lock) then
            H.Amount.DisplayValue:= H.Amount.DisplayValue * concnew / concold;
        end
      else
        for i:= 0 to NumFlavour - 1 do
        begin
          H:= FlavourHop(i);
          if (not H.Lock) then
            H.Amount.DisplayValue:= concnew / NumFlavour;
        end;

      FRec.CalcBitterness;
      if cbLockIBU.Checked then FRec.AdjustBitterness(oldibu);

      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.sbAromaChange(Sender: TObject);
var i : integer;
    concold, concnew, vol, oldibu : double;
    H : THop;
begin
  if FUserClicked and (FRec <> NIL) then
  begin
    FUserClicked:= false;
    oldibu:= FRec.IBUcalc.Value;
    vol:= FRec.BatchSize.DisplayValue;
    if vol > 0 then
    begin
      bbRemoveHop.Enabled:= false;
      FSelHop:= NIL;
      fseAroma.Value:= sbAroma.Position/10;
      //change the concentrations of flavour hops. All hops will change with proportion
      //calculate the 'old' concentration of flavour hops
      concnew:= sbAroma.Position / 10;
      concold:= 0;
      for i:= 0 to NumAroma - 1 do
      begin
        H:= AromaHop(i);
        if (not H.Lock) then
          concold:= concold + H.Amount.DisplayValue / vol
        else
          concnew:= concnew - H.Amount.DisplayValue / vol;
      end;

      if concold <> 0 then
        for i:= 0 to NumAroma - 1 do
        begin
          H:= AromaHop(i);
          if (not H.Lock) then
            H.Amount.DisplayValue:= H.Amount.DisplayValue * concnew / concold;
        end
      else
        for i:= 0 to NumAroma - 1 do
        begin
          H:= AromaHop(i);
          if (not H.Lock) then
            H.Amount.DisplayValue:= concnew / NumAroma;
        end;

      FRec.CalcBitterness;
      if cbLockIBU.Checked then FRec.AdjustBitterness(oldibu);
      Update;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.fseFlavourChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    sbFlavour.Position:= round(fseFlavour.Value * 10);
    sbFlavourChange(sbFlavour);
  end;
end;

procedure TFrmHopWizard.fseAromaChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    sbAroma.Position:= round(fseAroma.Value * 10);
    sbAromaChange(sbAroma);
  end;
end;

procedure TFrmHopWizard.sgBitterDblClick(Sender: TObject);
begin
  if (FRec <> NIL) and (FSelHop <> NIL) then
  begin
    sgBitter.Editor:= NIL;
    FrmHop2:= TFrmHop2.Create(self);
    FrmHop2.Execute(FSelHop);
    FrmHop2.Free;
    FRec.CalcBitterness;
    FillGrids;
    Update;
  end;
end;

procedure TFrmHopWizard.sgBitterDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : TScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FBitterGridColors)) and (aRow <= High(FBitterGridcolors)) then
  begin
    if aCol = 4 then sgBitter.Canvas.Brush.Color:= FBitterInventoryColors[aRow]
    else sgBitter.Canvas.Brush.Color:= FBitterGridColors[aRow];
  end;
  sgBitter.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgBitter.Canvas.Font.Style:= [fsBold, fsItalic];
    sgBitter.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgBitter.Canvas.Font.Style:= [];
    sgBitter.Canvas.Font.Color:= clBlack;
  end;

  sgBitter.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                          sgBitter.Cells[ACol, ARow]);

  if (sgBitter.Row = aRow) and (sgBitter.Col = aCol) and (sgBitter.Editor = fseGrid) then
  begin
    if (sgBitter.TopRow <= aRow) and (sgBitter.TopRow + round(sgBitter.Height / sgBitter.DefaultRowHeight) > aRow) then
    begin
      rect:= sgBitter.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgBitter.TopRow > FIGSCYBitter) or (sgBitter.TopRow + round(sgBitter.Height / sgBitter.DefaultRowHeight) <= FIGSCYBitter) then
    fseGrid.Visible:= false;

  sb:= FindScrollBar(sgBitter, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgBitter.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgBitter, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgBitter.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmHopWizard.sgBitterExit(Sender: TObject);
begin
  sgBitter.Editor:= NIL;
end;

procedure TFrmHopWizard.sgBitterSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgBitter.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelHop:= BitterHop(aRow);
    bbRemoveHop.Enabled:= TRUE;
    FSelGrid:= 0;
  end;
end;

procedure TFrmHopWizard.sgBitterSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelHop:= BitterHop(aRow);
  if (FRec <> NIL) and (FSelGrid = 0) and (FSelHop <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgBitter.CellRect(aCol, aRow);
    {if (Editor = NIL) and (aRow >= 0) and (aCol = 0) and (sgBitter.Cells[sgBitter.Col, sgBitter.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 10000;
        fseGrid.Value:= FSelHop.Amount.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else} if (Editor = NIL) and (aRow >= 0) and (aCol = 2) and (sgBitter.Cells[sgBitter.Col, sgBitter.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 100;
        fseGrid.Value:= FSelHop.BitternessContribution;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else if (Editor = NIL) and (aRow >= 0) and (aCol = 3) and (sgBitter.Cells[sgBitter.Col, sgBitter.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 100;
        if FRec.BatchSize.DisplayValue > 0 then
          fseGrid.Value:= FSelHop.Amount.DisplayValue / FRec.BatchSize.DisplayValue
        else fseGrid.Value:= 0;
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
  if Editor <> NIL then  FIGSCYBitter:= aRow
  else FIGSCYBitter:= 0;
end;

procedure TFrmHopWizard.sgFlavourDblClick(Sender: TObject);
begin
  sgFlavour.Editor:= NIL;
  sgBitterDblClick(sender);
end;

procedure TFrmHopWizard.sgFlavourDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : TScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FFlavourGridColors)) and (aRow <= High(FFlavourGridcolors)) then
  begin
    if aCol = 4 then sgFlavour.Canvas.Brush.Color:= FFlavourInventoryColors[aRow]
    else sgFlavour.Canvas.Brush.Color:= FFlavourGridColors[aRow];
  end;
  sgFlavour.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgFlavour.Canvas.Font.Style:= [fsBold, fsItalic];
    sgFlavour.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgFlavour.Canvas.Font.Style:= [];
    sgFlavour.Canvas.Font.Color:= clBlack;
  end;

  sgFlavour.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                          sgFlavour.Cells[ACol, ARow]);

  if (sgFlavour.Row = aRow) and (sgFlavour.Col = aCol) and (sgFlavour.Editor = fseGrid) then
  begin
    if (sgFlavour.TopRow <= aRow) and (sgFlavour.TopRow + round(sgFlavour.Height / sgFlavour.DefaultRowHeight) > aRow) then
    begin
      rect:= sgFlavour.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgFlavour.TopRow > FIGSCYFlavour) or (sgFlavour.TopRow + round(sgFlavour.Height / sgFlavour.DefaultRowHeight) <= FIGSCYFlavour) then
    fseGrid.Visible:= false;

  sb:= FindScrollBar(sgFlavour, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgFlavour.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgFlavour, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgFlavour.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmHopWizard.sgFlavourExit(Sender: TObject);
begin
  sgFlavour.Editor:= NIL;
end;

procedure TFrmHopWizard.sgFlavourSelectCell(Sender: TObject; aCol,
  aRow: Integer; var CanSelect: Boolean);
begin
  sgFlavour.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelHop:= FlavourHop(aRow);
    bbRemoveHop.Enabled:= TRUE;
    FSelGrid:= 1;
  end;
end;

procedure TFrmHopWizard.sgFlavourSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelHop:= FlavourHop(aRow);
  if (FRec <> NIL) and (FSelGrid = 1) and (FSelHop <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgFlavour.CellRect(aCol, aRow);
    {if (Editor = NIL) and (aRow >= 0) and (aCol = 0) and (sgFlavour.Cells[sgFlavour.Col, sgFlavour.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 10000;
        fseGrid.Value:= FSelHop.Amount.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else} if (Editor = NIL) and (aRow >= 0) and (aCol = 2) and (sgFlavour.Cells[sgFlavour.Col, sgFlavour.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 100;
        fseGrid.Value:= FSelHop.BitternessContribution;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else if (Editor = NIL) and (aRow >= 0) and (aCol = 3) and (sgFlavour.Cells[sgFlavour.Col, sgFlavour.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= round(1.5 * TasteVeryHigh);
        if FRec.BatchSize.DisplayValue > 0 then
          fseGrid.Value:= FSelHop.Amount.DisplayValue / FRec.BatchSize.DisplayValue
        else fseGrid.Value:= 0;
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
  if Editor <> NIL then  FIGSCYFlavour:= aRow
  else FIGSCYFlavour:= 0;
end;

procedure TFrmHopWizard.sgAromaDblClick(Sender: TObject);
begin
  sgAroma.Editor:= NIL;
  sgBitterDblClick(sender);
end;

procedure TFrmHopWizard.sgAromaDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var Rect : TRect;
    sb : TScrollBar;
    cb : TCheckBox;
begin
  if (aRow >= Low(FAromaGridColors)) and (aRow <= High(FAromaGridcolors)) then
  begin
    if aCol = 4 then sgAroma.Canvas.Brush.Color:= FAromaInventoryColors[aRow]
    else sgAroma.Canvas.Brush.Color:= FAromaGridColors[aRow];
  end;
  sgAroma.canvas.fillrect(arect);
  if (gdSelected in aState) then
  begin
    sgAroma.Canvas.Font.Style:= [fsBold, fsItalic];
    sgAroma.Canvas.Font.Color:= clBlack;
  end
  else
  begin
    sgAroma.Canvas.Font.Style:= [];
    sgAroma.Canvas.Font.Color:= clBlack;
  end;

  sgAroma.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                          sgAroma.Cells[ACol, ARow]);

  if (sgAroma.Row = aRow) and (sgAroma.Col = aCol) and (sgAroma.Editor = fseGrid) then
  begin
    if (sgAroma.TopRow <= aRow) and (sgAroma.TopRow + round(sgAroma.Height / sgAroma.DefaultRowHeight) > aRow) then
    begin
      rect:= sgAroma.CellRect(aCol, aRow);
      fseGrid.BoundsRect:= rect;
      fseGrid.Visible:= TRUE;
    end
    else
      fseGrid.Visible:= false;
  end;
  if (sgAroma.TopRow > FIGSCYAroma) or (sgAroma.TopRow + round(sgAroma.Height / sgAroma.DefaultRowHeight) <= FIGSCYAroma) then
    fseGrid.Visible:= false;

  sb:= FindScrollBar(sgAroma, aCol, aRow);
  if sb <> NIL then
  begin
    rect:= sgAroma.CellRect(aCol, aRow);
    sb.BoundsRect:= rect;
    sb.Visible:= TRUE;
  end;
  cb:= FindCheckBox(sgAroma, aCol, aRow);
  if cb <> NIL then
  begin
    rect:= sgAroma.CellRect(aCol, aRow);
    cb.BoundsRect:= rect;
    cb.Visible:= TRUE;
  end;
end;

procedure TFrmHopWizard.sgAromaExit(Sender: TObject);
begin
  sgAroma.Editor:= NIL;
end;

procedure TFrmHopWizard.sgAromaSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  sgAroma.Editor:= NIL;
  if FRec <> NIL then
  begin
    FSelHop:= AromaHop(aRow);
    bbRemoveHop.Enabled:= TRUE;
    FSelGrid:= 2;
  end;

end;

procedure TFrmHopWizard.sgAromaSelectEditor(Sender: TObject; aCol,
  aRow: Integer; var Editor: TWinControl);
var r : TRect;
begin
  Editor:= NIL;
  FSelHop:= AromaHop(aRow);
  if (FRec <> NIL) and (FSelGrid = 2) and (FSelHop <> NIL) and FUserClicked then
  begin
    FUserClicked:= false;
    r:= sgAroma.CellRect(aCol, aRow);
    {if (Editor = NIL) and (aRow >= 0) and (aCol = 0) and (sgAroma.Cells[sgAroma.Col, sgAroma.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= 10000;
        fseGrid.Value:= FSelHop.Amount.DisplayValue;
        Editor:= fseGrid;
      end
      else
      begin
        Editor:= NIL;
        fseGrid.Visible:= false;
       // FSortGrid:= TRUE;
      end;
    end
    else} if (Editor = NIL) and (aRow >= 0) and (aCol = 3) and (sgAroma.Cells[sgAroma.Col, sgAroma.Row] <> '') then
    begin
      if (not FSelHop.Lock) then
      begin
        fseGrid.BoundsRect:= r;
        fseGrid.DecimalPlaces:= 1;
        fseGrid.MaxValue:= round(1.5 * AromaVeryHigh);
        if FRec.BatchSize.DisplayValue > 0 then
          fseGrid.Value:= FSelHop.Amount.DisplayValue / FRec.BatchSize.DisplayValue
        else fseGrid.Value:= 0;
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
  if Editor <> NIL then  FIGSCYAroma:= aRow
  else FIGSCYAroma:= 0;
end;

procedure TFrmHopWizard.bbAddHopClick(Sender: TObject);
var H : THop;
    g : TStringGrid;
    sb : TScrollBar;
    i, n : integer;
    IBUold : double;
begin
  try
    if FRec <> NIL then
    begin
      sgBitter.Editor:= NIL;
      sgFlavour.Editor:= NIL;
      sgAroma.Editor:= NIL;

      FrmHop3:= TFrmHop3.Create(self);
      if FrmHop3.Execute(FRec.AddHop) then
      begin
        H:= FRec.Hop[FRec.NumHops-1];

        if IsFlavourHop(H) and (cbLockFlavour.Checked) then
          H.Amount.Value:= 0;

        if IsAromaHop(H) and (cbLockAroma.Checked) then
          H.Amount.Value:= 0;

        IBUold:= FRec.IBUcalc.Value;
        FRec.CalcBitterness;
        if cbLockIBU.Checked then
          FRec.AdjustBitterness(IBUold);

        FillGrids;
        Update;
      end
      else
        FRec.RemoveHop(FRec.NumHops-1);
    end;
  finally
    FrmHop3.Free;
  end;
end;

procedure TFrmHopWizard.bbRemoveHopClick(Sender: TObject);
begin
  if (FRec <> NIL) and (FSelHop <> NIL) then
  begin
    FRec.RemoveHopByReference(FSelHop);

    FillGrids;

    FRec.CalcBitterness;
    sgBitter.Editor:= NIL;
    sgFlavour.Editor:= NIL;
    sgAroma.Editor:= NIL;
    FSelHop:= NIL;
    bbRemoveHop.Enabled:= false;
    Update;
  end;
end;

procedure TFrmHopWizard.cbLockFlavourChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    bbRemoveHop.Enabled:= false;
    sbFlavour.Enabled:= not cbLockFlavour.Checked;
    fseFlavour.Enabled:= sbFlavour.Enabled;
    fseFlavour.ReadOnly:= cbLockFlavour.Checked;
    FSelHop:= NIL;
    Update;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.cbLockIBUChange(Sender: TObject);
var i : integer;
    alllocked : boolean;
    H : THop;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    if cbLockIBU.Checked then
    begin
      alllocked:= TRUE;
      for i:= 0 to NumBitter - 1 do
      begin
        H:= BitterHop(i);
        if (H <> NIL) and (not H.Lock) then
          alllocked:= false;
      end;
      if alllocked then
        cbLockIBU.Checked:= false;
    end;

    bbRemoveHop.Enabled:= false;
    sbIBU.Enabled:= not cbLockIBU.Checked;
    fseIBU.Enabled:= sbIBU.Enabled;
    fseIBU.ReadOnly:= cbLockIBU.Checked;
    FSelHop:= NIL;

    Update;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmHopWizard.cbLockAromaChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    bbRemoveHop.Enabled:= false;
    sbAroma.Enabled:= not cbLockAroma.Checked;
    fseAroma.Enabled:= sbAroma.Enabled;
    fseAroma.ReadOnly:= cbLockAroma.Checked;
    FSelHop:= NIL;
    Update;
    FUserClicked:= TRUE;
  end;
end;

end.

