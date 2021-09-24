unit FrHistogram;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Spin, ComCtrls, ExtDlgs,
  TAChartAxisUtils, PrintersDlgs;

type

  THistRecs = record
    Number : longint;
    percentage, xmin, xmax : double;
  end;

  { TFrmHistogram }

  TFrmHistogram = class(TForm)
    cbParameter: TComboBox;
    Chart: TChart;
    cbPercentages: TCheckBox;
    cbLabels: TCheckBox;
    DataSeries: TBarSeries;
    gbParameter: TGroupBox;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    ilAnalysis: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    pChart: TPanel;
    pLeft: TPanel;
    PrintDialog1: TPrintDialog;
    pSettings: TPanel;
    sbSave: TToolButton;
    spdChart: TSavePictureDialog;
    seNumBars: TSpinEdit;
    tbAnalysis: TToolBar;
    tbClose: TToolButton;
    tbCopyToClipboard: TToolButton;
    ToolButton1: TToolButton;
    tbPrint: TToolButton;
    procedure cbLabelsChange(Sender: TObject);
    procedure cbParameterChange(Sender: TObject);
    procedure ChartAxisList1MarkToText(var AText: String; AMark: Double);
    procedure cbPercentagesChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbSaveClick(Sender: TObject);
    procedure seNumBarsChange(Sender: TObject);
    procedure tbCloseClick(Sender: TObject);
    procedure tbCopyToClipboardClick(Sender: TObject);
    procedure tbPrintClick(Sender: TObject);
  private
    FX : LongInt;
    FMarkList : TStringList;
    FHistArr : array of THistRecs;
    Procedure FillChart;
  public
    Function Execute : boolean;
  end;

var
  FrmHistogram: TFrmHistogram;

implementation

{$R *.lfm}

{ TFrmHistogram }

uses Data, Containers, LCLType, Math, TAChartAxis, TAChartUtils, TACustomSource,
     TADrawerSVG, TADrawUtils, TADrawerCanvas, Hulpfuncties, OSPrinters, TAPrint, Printers;

procedure TFrmHistogram.FormCreate(Sender: TObject);
var i : LongInt;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if R <> NIL then
    for i:= 1 to R.NumNumbers do
    begin
      cbParameter.Items.Add(R.GetNumberNameByIndex(i));
    end;
  cbParameter.ItemIndex:= -1;
  FX:= -1;
  FMarkList:= TStringList.Create;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmHistogram.FormDestroy(Sender: TObject);
begin
  FMarkList.Clear;
  FreeAndNIL(FMarkList);
end;

procedure TFrmHistogram.cbParameterChange(Sender: TObject);
begin
  FX:= cbParameter.ItemIndex;
  FillChart;
end;

procedure TFrmHistogram.cbLabelsChange(Sender: TObject);
begin
  FillChart;
end;

procedure TFrmHistogram.ChartAxisList1MarkToText(var AText: String; AMark: Double);
var i : longint;
begin
  i:= round(AMark);
  if (FX > -1) and (i >= 0) and (i < FMarkList.Count) then
    AText:= FMarkList.Strings[i];
end;

procedure TFrmHistogram.cbPercentagesChange(Sender: TObject);
begin
  FillChart;
end;

Function TFrmHistogram.Execute : boolean;
begin
  ShowModal;
  Result:= TRUE;
end;

Procedure TFrmHistogram.FillChart;
var i, j, tot : longint;
    x, {y,} xmin, xmax : double;
    R : TRecipe;
    s : string;
    nbars : integer;
begin
  try
    DataSeries.Clear;
    FMarkList.Clear;
    nbars:= seNumBars.Value;
    if (FX > -1) then
    begin
      //first get the minimum and maximum values of the chosen parameter
      xmin:= 1E25;
      xmax:= -1E25;
      for i := 0 to Brews.NumItems - 1 do
      begin
        R:= TRecipe(Brews.Item[i]);
        if R <> NIL then
        begin
          if i = 0 then DataSeries.Title:= R.GetNumberNameByIndex(FX+1);
          x := R.GetNumberByIndex(FX+1);
          if (x > -99) {and (y > -99)} then
          begin
            xmin:= MinD(x, xmin);
            xmax:= MaxD(x, xmax);
          end;
        end;
      end;

      if xmin <= xmax then
      begin
        //create histogram intervals
        if xmax = xmin then nbars:= 1;
        SetLength(FHistArr, nbars);
        for i:= Low(FHistArr) to High(FHistArr) do
        begin
          FHistArr[i].Number:= 0;
          FHistArr[i].xmin:= xmin + i * (xmax - xmin) / nbars;
          FHistArr[i].xmax:= FHistArr[i].xmin + (xmax - xmin) / nbars;
        end;

        //fill histogram intervals
        tot:= 0;
        for i := 0 to Brews.NumItems - 1 do
        begin
          R:= TRecipe(Brews.Item[i]);
          if R <> NIL then
          begin
            x := R.GetNumberByIndex(FX+1);
            j:=  Floor(nbars * (x - xmin) / (xmax - xmin));
            if nbars = 1 then j:= 0;
            if x = xmax then j:= High(FHistArr);
            if (j >= 0) and (j <= High(FHistArr)) then
            begin
              FHistArr[j].Number:= FHistArr[j].Number + 1;
              Inc(Tot);
            end;
          end;
        end;

        //calculate percentages if needed
        if cbPercentages.Checked and (tot > 0) then
        begin
          for i:= Low(FHistArr) to High(FHistArr) do
            FHistArr[i].Percentage:= 100 * FHistArr[i].Number / tot;
        end;

        //fill the chart
        R:= TRecipe(Brews.Item[0]);
        for i:= Low(FHistArr) to High(FHistArr) do
        begin
          s:= RealToStrDec(FHistArr[i].xmin, R.GetNumberDecimalsByIndex(FX+1));
          s:= s + ' - ';
          s:= s + RealToStrDec(FHistArr[i].xmax, R.GetNumberDecimalsByIndex(FX+1));
          FMarkList.Add(s);
          if cbPercentages.Checked then DataSeries.AddXY(i, RoundTo(FHistArr[i].Percentage, -1))
          else DataSeries.AddXY(i, FHistArr[i].Number);
        end;
        Chart.BottomAxis.Intervals.Count:= nbars-1;
        if (cbParameter.ItemIndex > -1) and (R <> NIL) then
          s:= cbParameter.Items[cbPArameter.ItemIndex] + ' (' + R.GetNumberDisplayUnitByIndex(FX+1) + ')'
        else s:= '';
        Chart.BottomAxis.Title.Caption:= s;
        if cbPercentages.Checked then Chart.LeftAxis.Title.Caption:= 'Percentage'
        else Chart.LeftAxis.Title.Caption:= 'Aantal';

        DataSeries.Marks.Visible:= cbLabels.Checked;
      end;
    end;
  finally
    SetLength(FHistArr, 0);
  end;
end;

procedure TFrmHistogram.sbSaveClick(Sender: TObject);
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

procedure TFrmHistogram.seNumBarsChange(Sender: TObject);
begin
  FillChart;
end;

procedure TFrmHistogram.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmHistogram.tbCopyToClipboardClick(Sender: TObject);
begin
  Chart.CopyToClipboardBitmap;
end;

procedure TFrmHistogram.tbPrintClick(Sender: TObject);
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

end.

