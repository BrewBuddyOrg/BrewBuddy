unit franalysis;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, CheckLst, Spin, ComCtrls, ExtDlgs, TAGraph, TASeries, TASources,
  TAFuncSeries, TATransformations, TAFitUtils, PrintersDlgs;

type

  { TFrmAnalysis }

  TFrmAnalysis = class(TForm)
    btnSelectAll: TButton;
    cbEquipment: TComboBox;
    cbFitEquation: TComboBox;
    Chart: TChart;
    ChartAxisTransformations: TChartAxisTransformations;
    cbShowLabels: TCheckBox;
    clbBrews: TCheckListBox;
    cbX: TComboBox;
    cbY: TComboBox;
    DataSeries: TLineSeries;
    edFitOrder: TSpinEdit;
    FitSeries: TFitSeries;
    gbAxes: TGroupBox;
    gbRecipes: TGroupBox;
    gbResults: TGroupBox;
    ilAnalysis: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblFitOrder: TLabel;
    lbResults: TListBox;
    ListChartSource: TListChartSource;
    LogarithmAxisTransform: TLogarithmAxisTransform;
    pParameters: TPanel;
    PrintDialog1: TPrintDialog;
    pSettings: TPanel;
    pChart: TPanel;
    spdChart: TSavePictureDialog;
    tbAnalysis: TToolBar;
    sbSave: TToolButton;
    tbCopyToClipboard: TToolButton;
    ToolButton1: TToolButton;
    tbClose: TToolButton;
    tbPrint: TToolButton;
    procedure btnSelectAllClick(Sender: TObject);
    procedure cbEquipmentChange(Sender: TObject);
    procedure cbFitEquationSelect(Sender: TObject);
    procedure cbShowLabelsChange(Sender: TObject);
    procedure cbXChange(Sender: TObject);
    procedure cbYChange(Sender: TObject);
    procedure ChartMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure clbBrewsClickCheck(Sender: TObject);
    procedure edFitOrderChange(Sender: TObject);
    procedure FitSeriesFitComplete(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure tbCloseClick(Sender: TObject);
    procedure tbCopyToClipboardClick(Sender: TObject);
    procedure tbPrintClick(Sender: TObject);
  private
    { private declarations }
    FX, FY : longint;
    Procedure FillChart;
    Function CalcRSquare : double;
  public
    { public declarations }
    Function Execute : boolean;
  end;

var
  FrmAnalysis: TFrmAnalysis;

implementation

{$R *.lfm}
uses Data, Containers, LCLType, Math, TAChartAxis, TAChartUtils, TACustomSource,
     TADrawerSVG, TADrawUtils, TADrawerCanvas, OSPrinters, {TAPrint, }Printers,
     hulpfuncties;

{ TFrmAnalysis }

procedure TFrmAnalysis.FormCreate(Sender: TObject);
var i, j : LongInt;
    R : TRecipe;
    E : TEquipment;
    s : string;
    found : boolean;
begin
  R:= TRecipe(Brews.Item[0]);
  if R <> NIL then
    for i:= 1 to R.NumNumbers do
    begin
      cbX.Items.Add(R.GetNumberNameByIndex(i));
      cbY.Items.Add(R.GetNumberNameByIndex(i));
    end;
  cbX.ItemIndex:= -1;
  cbY.ItemIndex:= -1;

  s:= 'Alle';
  cbEquipment.Items.Add(s);

  {for i:= 0 to Equipments.NumItems - 1 do
  begin
    E:= TEquipment(Equipments.Item[i]);
    s:= E.Name.Value;
    cbEquipment.Items.Add(s);
  end;}

  for i:= 0 to Brews.NumItems - 1 do
  begin
    R:= TRecipe(Brews.Item[i]);
    if R <> NIL then
    begin
      s:= R.NrRecipe.Value + ' ' + R.Name.Value;
      clbBrews.Items.AddObject(s, R);
      clbBrews.Checked[i]:= TRUE;
      if R.Equipment = NIL then s:= ''
      else s:= R.Equipment.Name.Value;
      found:= false;
      for j:= 0 to cbEquipment.Items.Count - 1 do
        if trim(Lowercase(s)) = trim(LowerCase(cbEquipment.Items[j])) then
          found:= TRUE;
      if not found then cbEquipment.Items.Add(s);
    end;
  end;

  cbEquipment.ItemIndex:= 0;
  FX:= -1; FY:= -1;
  cbFitEquation.ItemIndex:= 1;
  cbFitEquationSelect(Self);
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

Function TFrmAnalysis.Execute : boolean;
begin
  ShowModal;
  Result:= TRUE;
end;

procedure TFrmAnalysis.btnSelectAllClick(Sender: TObject);
var i : longint;
begin
  for i:= 0 to clbBrews.Items.Count - 1 do
    if btnSelectAll.Caption = 'Selecteer alles' then
      clbBrews.Checked[i]:= TRUE
    else
      clbBrews.Checked[i]:= false;

  if btnSelectAll.Caption = 'Selecteer alles' then
    btnSelectAll.Caption:= 'Deselecteer alles'
  else btnSelectAll.Caption:= 'Selecteer alles';
  FillChart;
end;

procedure TFrmAnalysis.cbEquipmentChange(Sender: TObject);
var i, n : longint;
    ne, s : string;
    R : TRecipe;
begin
  ne:= cbEquipment.Items[cbEquipment.ItemIndex];
  n:= -1;
  clbBrews.Items.Clear;
  for i:= 0 to Brews.NumItems - 1 do
  begin
    R:= TRecipe(Brews.Item[i]);
    if (cbEquipment.ItemIndex = 0) or ((R.Equipment <> NIL) and (R.Equipment.Name.Value = ne))
       or ((R.Equipment = NIL) and (trim(cbEquipment.Items[cbEquipment.ItemIndex]) = '')) then
    begin
      s:= R.NrRecipe.Value + ' ' + R.Name.Value;
      clbBrews.Items.AddObject(s, R);
      inc(n);
      clbBrews.Checked[n]:= TRUE;
    end;
  end;
  FillChart;
end;

procedure TFrmAnalysis.cbFitEquationSelect(Sender: TObject);
var
  eq: TFitEquation;
begin
  eq := TFitEquation(cbFitEquation.ItemIndex);
  FitSeries.FitEquation := eq;
  edFitOrder.Enabled := (eq = fePolynomial);
  lblFitOrder.Enabled := edFitOrder.Enabled;
end;

procedure TFrmAnalysis.cbShowLabelsChange(Sender: TObject);
begin
  if cbShowLabels.Checked then DataSeries.Marks.Style:= smsLabel
  else DataSeries.Marks.Style:= smsNone;
end;

procedure TFrmAnalysis.ChartMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
//
end;

procedure TFrmAnalysis.sbSaveClick(Sender: TObject);
var ext : string;
    fs: TFileStream;
    id: IChartDrawer;
begin
  if spdChart.Execute then
  begin
    ext:= Lowercase(ExtractFileExt(spdChart.FileName));
    if ext = '.bmp' then Chart.SaveToBitmapFile(spdChart.FileName)
    else if ext = '.jpg' then Chart.SaveToFile(TJPEGImage, spdChart.FileName)
    else if ext = '.png' then Chart.SaveToFile(TPortableNetworkGraphic, spdChart.FileName)
    else if ext = '.svg' then
    begin
      fs := TFileStream.Create(spdChart.FileName, fmCreate);
      try
        id := TSVGDrawer.Create(fs, true);
        id.DoChartColorToFPColor := @ChartColorSysToFPColor;
        with Chart do
          Draw(id, Rect(0, 0, Width, Height));
      finally
        fs.Free;
      end;
    end;
  end;
end;

procedure TFrmAnalysis.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmAnalysis.tbCopyToClipboardClick(Sender: TObject);
begin
  Chart.CopyToClipboardBitmap;
end;

procedure TFrmAnalysis.tbPrintClick(Sender: TObject);
const
  MARGIN = 10;
var
  r: TRect;
  d: Integer;
begin
  if not PrintDialog1.Execute then exit;
  Printer.BeginDoc;
  try
    r := Rect(0, 0, Printer.PageWidth, Printer.PageHeight div 2);
    d := r.Right - r.Left;
    r.Left += d div MARGIN;
    r.Right -= d div MARGIN;
    d := r.Bottom - r.Top;
    r.Top += d div MARGIN;
    r.Bottom -= d div MARGIN;
    Chart.Draw(TPrinterDrawer.Create(Printer), r);
  finally
    Printer.EndDoc;
  end;
end;

procedure TFrmAnalysis.clbBrewsClickCheck(Sender: TObject);
begin
  FillChart;
end;

procedure TFrmAnalysis.cbXChange(Sender: TObject);
begin
  FX:= cbX.ItemIndex;
  FillChart;
end;

procedure TFrmAnalysis.cbYChange(Sender: TObject);
begin
  FY:= cbY.ItemIndex;
  FillChart;
end;

procedure TFrmAnalysis.edFitOrderChange(Sender: TObject);
begin
  FitSeries.ParamCount := edFitOrder.Value + 1;
end;

Function GetOrdinals( S : Extended) : LongInt;
var AbsS : Extended;
begin
  AbsS:= Abs(S);
  if AbsS < 1 then result:= 1  {0,..}
  else Result:= Trunc(Log10(AbsS)) + 1;
  if S < 0 then Inc(Result); {Minus-sign}
end;

Function RealToStrDEC( S : Double;  D : SmallInt) : string;
var StrF : string;
    Total : LongInt;
begin
  Total:= GetOrdinals(S);
  if D > 0 then Total:= Total + 1 + D;
  StrF:= '%' + IntToStr(Total) + '.' + IntToStr(D) + 'f';

  FmtStr(Result, StrF, [S]);
end;



procedure TFrmAnalysis.FitSeriesFitComplete(Sender: TObject);
var r2 : double;
    i: Integer;
begin
  with lbResults.Items do
  begin
    BeginUpdate;
    Clear;
    case TFitEquation(cbFitEquation.ItemIndex) of
    fePolynomial:
      for i := 0 to FitSeries.ParamCount - 1 do
        Add(sysutils.Format('b[%d] = %g', [i, FitSeries.Param[i]]));
    else
      Add(sysutils.Format('a = %g', [FitSeries.Param[0]]));
      Add(sysutils.Format('b = %g', [FitSeries.Param[1]]));
    end;
    r2:= CalcRSquare;
    Add('r² = ' + RealToStrDec(r2, 2));
    EndUpdate;
  end;
end;

Procedure TFrmAnalysis.FillChart;
var i, XC, YC : longint;
    x, y : double;
    R : TRecipe;
    s : string;
begin
  lbResults.Items.Clear;
  DataSeries.BeginUpdate;
  try
    DataSeries.Clear;
    DataSeries.Title:= 'Meetwaarden';
    if (FX > -1) and (FY > -1) then
    begin
      R:= TRecipe(clbBrews.Items.Objects[0]);
      s:= cbX.Items[FX];
      if R <> NIL then s:= s + ' (' + R.GetNumberDisplayUnitByIndex(FX+1) + ')';
      Chart.BottomAxis.Title.Caption:= s;
      s:= cbY.Items[FY];
      if R <> NIL then s:= s + ' (' + R.GetNumberDisplayUnitByIndex(FY+1) + ')';
      Chart.LeftAxis.Title.Caption:= s;
      for i := 0 to clbBrews.Items.Count - 1 do
      begin
        if clbBrews.Checked[i] then
        begin
          R:= TRecipe(clbBrews.Items.Objects[i]);
          if R <> NIL then
          begin
            x := R.GetNumberByIndex(FX+1);
            y := R.GetNumberByIndex(FY+1);
            if ((x > -99) and (y > -99)) then
            begin
              DataSeries.AddXY(x, y, R.NrRecipe.Value);
            end;
          end;
        end;
      end;
    end
    else
    begin
      Chart.BottomAxis.Title.Caption:= 'X';
      Chart.LeftAxis.Title.Caption:= 'Y';
    end;
  finally
    DataSeries.EndUpdate;
  end;
 // FitSeries.FitRange.Min := edFitRangeMin.Value;
 // FitSeries.FitRange.Max := edFitRangeMax.Value;
end;

Function TFrmAnalysis.CalcRSquare : double;
var x, y, yr, ymean, SStot, SSr : double;
    i, n : longint;
    R : TRecipe;
begin
  Result:= 0;
  SStot:= 0;
  SSr:= 0;
  n:= 0;
  ymean:= 0;
  for i := 0 to clbBrews.Items.Count - 1 do
  begin
    if clbBrews.Checked[i] then
    begin
      R:= TRecipe(clbBrews.Items.Objects[i]);
      if R <> NIL then
      begin
        x := R.GetNumberByIndex(FX+1);
        y := R.GetNumberByIndex(FY+1);
        if (x > -99) and (y > -99) then
        begin
          Inc(n);
          ymean:= ymean + y;
        end;
      end;
    end;
  end;
  if n > 0 then ymean:= ymean / n;
  for i := 0 to clbBrews.Items.Count - 1 do
  begin
    if clbBrews.Checked[i] then
    begin
      R:= TRecipe(clbBrews.Items.Objects[i]);
      if R <> NIL then
      begin
        x := R.GetNumberByIndex(FX+1);
        y := R.GetNumberByIndex(FY+1);
        if (x > -99) and (y > -99) then
        begin
          yr:= FitSeries.Calculate(x);
          SStot:= SStot + SQR(y-ymean);
          SSr:= SSr + SQR(y-yr);
        end;
      end;
    end;
  end;
  if SStot > 0 then
    Result:= 1 - SSr / SStot;
end;

end.

