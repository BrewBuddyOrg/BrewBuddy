unit frhopgraph;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TASources, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, ComCtrls, types;

type

  { TFrmHopGraph }

  TFrmHopGraph = class(TForm)
    cbOnlyInStock: TCheckBox;
    cbProperties: TComboBox;
    Chart1: TChart;
    cbsProperties: TBarSeries;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointCrosshairTool1: TDataPointCrosshairTool;
    Label1: TLabel;
    lcsData: TListChartSource;
    pTop: TPanel;
    StatusBar1: TStatusBar;
    procedure cbOnlyInStockChange(Sender: TObject);
    procedure cbPropertiesChange(Sender: TObject);
    procedure ChartToolset1DataPointCrosshairTool1AfterMouseMove(
      ATool: TChartTool; APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { private declarations }
    FGraphType : longint;
    procedure FillGraph;
  public
    { public declarations }
    Function Execute(i : longint) : boolean;
  end;

var
  FrmHopGraph: TFrmHopGraph;

implementation

{$R *.lfm}
uses Containers, Data, Hulpfuncties;

{ TFrmHopGraph }
type
  TDataRec = record
    Name : string;
    Value : double;
  end;

procedure TFrmHopGraph.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmHopGraph.FormDestroy(Sender: TObject);
begin
  cbProperties.Clear;
  lcsData.Clear;
end;

Function TFrmHopGraph.Execute(i : longint) : boolean;
begin
  FGraphType:= i;
  case FGraphType of
  0:
  begin
    cbProperties.Items.Add('Opbrengst');
    cbProperties.Items.Add('Kleur');
    cbProperties.Items.Add('Vochtgehalte');
    cbProperties.Items.Add('Enzymkracht');
    cbProperties.Items.Add('Eiwitgehalte');
    cbProperties.Items.Add('Opgelost eiwit');
    cbProperties.Items.Add('Kolbach Index');
  end;
  1:
  begin
    cbProperties.Items.Add('Alfazuur%');
    cbProperties.Items.Add('Betazuur%');
    cbProperties.Items.Add('Stabiliteits Index');
    cbProperties.Items.Add('Cohumuloon gehalte');
    cbProperties.Items.Add('Totaal olie %');
    cbProperties.Items.Add('Humuleen %');
    cbProperties.Items.Add('Caryofyleen %');
    cbProperties.Items.Add('Myrceen %');
  end;
  2:
  begin
    cbProperties.Items.Add('Min. temperatuur');
    cbProperties.Items.Add('Max. temperatuur');
    cbProperties.Items.Add('Vergistingsgraad');
  end;
  3:
  begin
    cbProperties.Items.Add('Calcium');
    cbProperties.Items.Add('Magnesium');
    cbProperties.Items.Add('Natrium');
    cbProperties.Items.Add('Chloride');
    cbProperties.Items.Add('Sulfaat');
    cbProperties.Items.Add('Bicarbonaat');
    cbProperties.Items.Add('pH');
    cbProperties.Items.Add('Restalkaliteit');
    cbOnlyInStock.Visible:= false;
  end;
  end;
  cbProperties.ItemIndex:= 0;
  FillGraph;
  Result:= false;
  ShowModal;
  Result:= TRUE;
end;

Procedure Sort(var A : Array of TDataRec);
  procedure QuickSort(var A: array of TDataRec; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      Mid : double;
      T : TDataRec;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2].Value;
    repeat
      while A[Lo].Value < Mid do Inc(Lo);
      while A[Hi].Value > Mid do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  QuickSort(A, Low(A), High(A));
end;

Procedure TFrmHopGraph.FillGraph;
var i, n : longint;
    H : THop;
    F : TFermentable;
    Y : TYeast;
    W : TWater;
    x : double;
    s : string;
    HRArr : array of TDataRec;
begin
  lcsData.Clear;
  n:= 0;

  case FGraphType of
  0:
  begin
    for i:= 0 to Fermentables.NumItems - 1 do
    begin
      F:= TFermentable(Fermentables.Item[i]);
      if F <> NIL then
      begin
        if (not cbOnlyInStock.Checked) or (cbOnlyInStock.Checked and (F.Inventory.Value > 0)) then
        begin
          case cbProperties.ItemIndex of
          0: begin
               x:= F.Yield.DisplayValue;
               s:= 'Opbrengst (' + F.Yield.DisplayUnitString + ')';
             end;
          1: begin
               x:= F.Color.DisplayValue;
               s:= 'Kleur (' + F.Color.DisplayUnitString + ')';
             end;
          2: begin
               x:= F.Moisture.DisplayValue;
               s:= 'Vochtgehalte (' + F.Moisture.DisplayUnitString + ')';
             end;
          3: begin
               x:= F.DiastaticPower.DisplayValue;
               s:= 'Enzymkracht (' + F.DiastaticPower.DisplayUnitString + ')';
             end;
          4: begin
               x:= F.Protein.DisplayValue;
               s:= 'Eiwitgehalte (' + F.Protein.DisplayUnitString + ')';
             end;
          5: begin
               x:= F.DissolvedProtein.DisplayValue;
               s:= 'Opgelost eiwit (' + F.DissolvedProtein.DisplayUnitString + ')';
             end;
          6: begin
               x:= F.KolbachIndex;
               s:= 'Kolbach Index (-)';
             end;
          end;
          SetLength(HRArr, High(HRArr) + 2);
          HRArr[n].Name:= F.Name.Value + ' (' + F.Supplier.Value + ')';
          HRArr[n].Value:= x;
          inc(n);
        end;
      end;
    end;
  end;
  1:
  begin
    for i:= 0 to Hops.NumItems - 1 do
    begin
      H:= THop(Hops.Item[i]);
      if H <> NIL then
      begin
        if (not cbOnlyInStock.Checked) or (cbOnlyInStock.Checked and (H.Inventory.Value > 0)) then
        begin
          case cbProperties.ItemIndex of
          0: begin
               x:= H.Alfa.DisplayValue;
               s:= 'Alfazuurgehalte (' + H.Alfa.DisplayUnitString + ')';
             end;
          1: begin
               x:= H.Beta.DisplayValue;
               s:= 'Betazuurgehalte (' + H.Beta.DisplayUnitString + ')';
             end;
          2: begin
               x:= H.HSI.DisplayValue;
               s:= 'Stabiliteitsindex (' + H.HSI.DisplayUnitString + ')';
             end;
          3: begin
               x:= H.Cohumulone.DisplayValue;
               s:= 'Cohumuloongehalte (' + H.Cohumulone.DisplayUnitString + ')';
             end;
          4: begin
               x:= H.TotalOil.DisplayValue;
               s:= 'Totaal oliegehalte (' + H.TotalOil.DisplayUnitString + ')';
             end;
          5: begin
               x:= H.Humulene.DisplayValue;
               s:= 'Humuleengehalte (' + H.Humulene.DisplayUnitString + ')';
             end;
          6: begin
               x:= H.Caryophyllene.DisplayValue;
               s:= 'Caryofyleengehalte (' + H.Caryophyllene.DisplayUnitString + ')';
             end;
          7: begin
               x:= H.Myrcene.DisplayValue;
               s:= 'Myrceengehalte (' + H.Myrcene.DisplayUnitString + ')';
             end;
          end;
          SetLength(HRArr, High(HRArr) + 2);
          HRArr[n].Name:= H.Name.Value + ' (' + H.Origin.Value + ')';
          HRArr[n].Value:= x;
          inc(n);
        end;
      end;
    end;
  end;
  2:
  begin
    for i:= 0 to Yeasts.NumItems - 1 do
    begin
      Y:= TYeast(Yeasts.Item[i]);
      if Y <> NIL then
      begin
        if (not cbOnlyInStock.Checked) or (cbOnlyInStock.Checked and (Y.Inventory.Value > 0)) then
        begin
          case cbProperties.ItemIndex of
          0: begin
               x:= Y.MinTemperature.DisplayValue;
               s:= 'Min. temperatuur (' + Y.MinTemperature.DisplayUnitString + ')';
             end;
          1: begin
               x:= Y.MaxTemperature.DisplayValue;
               s:= 'Max. temperatuur (' + Y.MaxTemperature.DisplayUnitString + ')';
             end;
          2: begin
               x:= Y.Attenuation.DisplayValue;
               s:= 'Vergistingsgraad (' + Y.Attenuation.DisplayUnitString + ')';
             end;
          end;
          SetLength(HRArr, High(HRArr) + 2);
          HRArr[n].Name:= Y.ProductID.Value + ' ' + Y.Name.Value + ' (' + Y.Laboratory.Value + ')';
          HRArr[n].Value:= x;
          inc(n);
        end;
      end;
    end;
  end;
  3:
  begin
    for i:= 0 to Waters.NumItems - 1 do
    begin
      W:= TWater(Waters.Item[i]);
      if W <> NIL then
      begin
        case cbProperties.ItemIndex of
        0: begin
             x:= W.Calcium.DisplayValue;
             s:= 'Calcium (' + W.Calcium.DisplayUnitString + ')';
           end;
        1: begin
             x:= W.Magnesium.DisplayValue;
             s:= 'Magnesium (' + W.Magnesium.DisplayUnitString + ')';
           end;
        2: begin
             x:= W.Sodium.DisplayValue;
             s:= 'Natrium (' + W.Sodium.DisplayUnitString + ')';
           end;
        3: begin
             x:= W.Chloride.DisplayValue;
             s:= 'Chloride (' + W.Chloride.DisplayUnitString + ')';
           end;
        4: begin
             x:= W.Sulfate.DisplayValue;
             s:= 'Sulfaat (' + W.Sulfate.DisplayUnitString + ')';
           end;
        5: begin
             x:= W.Bicarbonate.DisplayValue;
             s:= 'Bicarbonaat (' + W.Bicarbonate.DisplayUnitString + ')';
           end;
        6: begin
             x:= W.pHwater.DisplayValue;
             s:= 'pH (' + W.pHWater.DisplayUnitString + ')';
           end;
        7: begin
             x:= W.ResidualAlkalinity;
             s:= 'Restalkaliteit (°D)';
           end;
        end;
        SetLength(HRArr, High(HRArr) + 2);
        HRArr[n].Name:= W.Name.Value;
        HRArr[n].Value:= x;
        inc(n);
      end;
    end;
  end;
  end;


  if High(HRArr) > 0 then
  begin
    Sort(HRArr);
    for i:= Low(HRArr) to High(HRArr) do
    begin
      lcsData.Add(i, HRArr[i].Value, HRArr[i].Name);
    end;
    Chart1.LeftAxis.Title.Caption:= s;
  end;
end;

procedure TFrmHopGraph.cbPropertiesChange(Sender: TObject);
begin
  FillGraph;
end;

procedure TFrmHopGraph.ChartToolset1DataPointCrosshairTool1AfterMouseMove(
  ATool: TChartTool; APoint: TPoint);
var i : longint;
    Xv, Yv : double;
    t : string;
begin
  i:= TDataPointCrosshairTool(atool).PointIndex;
  if (i > -1) and (i <= cbsProperties.Source.Count - 1) then
  begin
    Xv:= cbsProperties.Source.Item[i]^.X;
    Yv:= cbsProperties.Source.Item[i]^.Y;
    t:= cbsProperties.Source.Item[i]^.Text;
    StatusBar1.Panels.Items[0].Text:= t + '; waarde: ' + RealToStrSignif(Yv, 3);
  end
  else StatusBar1.Panels.Items[0].Text:= '';
end;

procedure TFrmHopGraph.cbOnlyInStockChange(Sender: TObject);
begin
  FillGraph;
end;

end.

