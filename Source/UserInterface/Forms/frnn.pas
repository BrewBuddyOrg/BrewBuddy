unit FrNN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TATools, PrintersDlgs, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, ComCtrls, Buttons, StdCtrls, ExtDlgs,
  Spin, Grids, neuroot, types;

type

  { TFrmNN }

  TFrmNN = class(TForm)
    bbNewNN: TBitBtn;
    bbRemoveNN: TBitBtn;
    bbTrain: TBitBtn;
    bbRebuild: TBitBtn;
    cbEquipment: TComboBox;
    cbResponse2: TComboBox;
    cbShowLabels: TCheckBox;
    ChartToolset1: TChartToolset;
    ChartToolset1DataPointCrosshairTool1: TDataPointCrosshairTool;
    chResponse: TChart;
    clsResponse: TLineSeries;
    chTrain: TChart;
    cbOutputPar: TComboBox;
    cbResponse: TComboBox;
    cbActivationFunction: TComboBox;
    eNumValid: TEdit;
    fsePrediction: TFloatSpinEdit;
    fseError: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    gbPrediction: TGroupBox;
    gbResponse: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    pParameter: TPanel;
    PrintDialog1: TPrintDialog;
    seTrainingRounds: TSpinEdit;
    spdChart: TSavePictureDialog;
    sgInput: TStringGrid;
    sgOutput: TStringGrid;
    StatusBar1: TStatusBar;
    tls1: TLineSeries;
    tlsResult: TLineSeries;
    eName: TEdit;
    eTrained: TEdit;
    gbProperties: TGroupBox;
    gbTrain: TGroupBox;
    ilMenu: TImageList;
    ilTree: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lbOutput: TListBox;
    lbParameters: TListBox;
    lbInput: TListBox;
    lError: TLabel;
    pcMain: TPageControl;
    pbTraining: TProgressBar;
    pTreeButtons: TPanel;
    pTree: TPanel;
    pMain: TPanel;
    sbInputAdd: TSpeedButton;
    sbOutputAdd: TSpeedButton;
    sbInputRemove: TSpeedButton;
    sbOutputRemove: TSpeedButton;
    Splitter1: TSplitter;
    tbSave: TToolButton;
    tbCopy: TToolButton;
    tbPrint: TToolButton;
    ToolButton1: TToolButton;
    tbClose: TToolButton;
    tsResult: TTabSheet;
    tsPredict: TTabSheet;
    tsTrain: TTabSheet;
    tbMenu: TToolBar;
    tvNN: TTreeView;
    procedure bbNewNNClick(Sender: TObject);
    procedure bbRemoveNNClick(Sender: TObject);
    procedure bbRebuildClick(Sender: TObject);
    procedure cbActivationFunctionChange(Sender: TObject);
    procedure cbEquipmentChange(Sender: TObject);
    procedure cbOutputParChange(Sender: TObject);
    procedure cbResponseChange(Sender: TObject);
    procedure cbShowLabelsChange(Sender: TObject);
    procedure ChartToolset1DataPointCrosshairTool1AfterMouseMove(
      ATool: TChartTool; APoint: TPoint);
    procedure eNameChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fsePredictionChange(Sender: TObject);
    procedure lbInputSelectionChange(Sender: TObject; User: boolean);
    procedure lbOutputSelectionChange(Sender: TObject; User: boolean);
    procedure lbParametersSelectionChange(Sender: TObject; User: boolean);
    procedure pcMainChange(Sender: TObject);
    procedure sbInputAddClick(Sender: TObject);
    procedure sbInputRemoveClick(Sender: TObject);
    procedure sbOutputAddClick(Sender: TObject);
    procedure sbOutputRemoveClick(Sender: TObject);
    procedure sgInputDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgInputEditingDone(Sender: TObject);
    procedure sgInputExit(Sender: TObject);
    procedure sgInputSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgInputSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure tbCloseClick(Sender: TObject);
    procedure tbCopyClick(Sender: TObject);
    procedure tbPrintClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure tvNNSelectionChanged(Sender: TObject);
    procedure bbTrainClick(Sender: TObject);
  private
    FSelNN : TBHNN;
    FUserClicked, FChanged, FTraining : boolean;
    FISGX, FISGY : integer;
    Procedure FillTree;
    Procedure Update; reintroduce;
    Function UpdateNetwork : boolean;
    Procedure AskToSave;
    Procedure UpdateChart;
    Procedure UpdatesgOutput;
  public
    Procedure Execute;
    procedure NNOnTrainRound(Sender : TObject; Error, Progress : single);
    procedure NNOnTrainReady(Sender : TObject; Error : single);
  end;

var
  FrmNN: TFrmNN;

implementation

uses containers, data, hulpfuncties, OSPrinters, TAPrint, Printers, tadrawutils,
     tadrawersvg, tadrawercanvas, tachartutils, math, fannnetwork;

{$R *.lfm}

{ TFrmNN }

procedure TFrmNN.FormCreate(Sender: TObject);
var i : integer;
    s : string;
    af : TActivationFunction;
begin
{  BHNNs:= TBHNNs.Create;
  BHNNs.ReadXML;}
  FSelNN:= NIL;
  FUserClicked:= false;
  FChanged:= false;
  FTraining:= false;

  pcMain.ActivePage:= tsTrain;
  pcMain.Visible:= false;
  cbEquipment.Items.Add('Alle');
  for i:= 0 to Brews.NumItems - 1 do
  begin
    s:= '';
    if TRecipe(Brews.Item[i]).Equipment <> NIL then
      s:= TRecipe(Brews.Item[i]).Equipment.Name.Value;
    if s = '' then s:= 'Alle';
    if cbEquipment.Items.IndexOf(s) = -1 then cbEquipment.Items.Add(s);
  end;

  for af:= low(ActivationFunctionNames) to High(ActivationFunctionNames) do
    if (af <> afFANN_THRESHOLD) and (af <> afFANN_THRESHOLD_SYMMETRIC) then
      cbActivationFunction.Items.Add(ActivationFunctionNames[af]);

  sgInput.ColWidths[0]:= 200;
  sgInput.ColWidths[1]:= sgInput.Width - sgInput.ColWidths[0] - 21;
  sgInput.Cells[0, 0]:= 'Parameter';
  sgInput.Cells[1, 0]:= 'Waarde';
  sgOutput.ColWidths[0]:= sgInput.ColWidths[0];
  sgOutput.ColWidths[1]:= sgOutput.Width - sgOutput.ColWidths[0] - 21;
  sgOutput.Cells[0, 0]:= 'Parameter';
  sgOutput.Cells[1, 0]:= 'Waarde';
  FISGX:= -1;
  FISGY:= -1;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  FillTree;

  FUserClicked:= TRUE;
end;

procedure TFrmNN.FormDestroy(Sender: TObject);
begin
  AskToSave;
//  FreeAndNIL(BHNNs);
end;

procedure TFrmNN.lbInputSelectionChange(Sender: TObject; User: boolean);
begin
  if FUserClicked then
  begin
    sbInputRemove.Enabled:= (lbInput.ItemIndex > -1);
    sbInputAdd.Enabled:= false;
    sbOutputAdd.Enabled:= false;
  end;
end;

procedure TFrmNN.lbOutputSelectionChange(Sender: TObject; User: boolean);
begin
  if FUserClicked then
  begin
    sbOutputRemove.Enabled:= (lbOutput.ItemIndex > -1);
    sbInputAdd.Enabled:= false;
    sbOutputAdd.Enabled:= false;
  end;
end;

procedure TFrmNN.lbParametersSelectionChange(Sender: TObject; User: boolean);
begin
  if FUserClicked then
  begin
    sbInputAdd.Enabled:= (lbParameters.ItemIndex > -1);
    sbOutputAdd.Enabled:= sbInputAdd.Enabled;
    sbInputRemove.Enabled:= false;
    sbOutputRemove.Enabled:= false;
  end;
end;

procedure TFrmNN.pcMainChange(Sender: TObject);
begin
  tbCopy.Enabled:= (pcMain.ActivePage = tsResult) or (pcMain.ActivePage = tsPredict);
  tbPrint.Enabled:= tbCopy.Enabled;
end;

procedure TFrmNN.sbInputAddClick(Sender: TObject);
var s : string;
    //i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (lbParameters.ItemIndex > -1) and (R <> NIL) and (FSelNN <> NIL) then
  begin
    s:= lbParameters.Items[lbParameters.ItemIndex];
    //i:= R.GetNumberIndexByName(s);
    lbParameters.Items.Delete(lbParameters.ItemIndex);
    lbInput.Items.Add(s);
//    FSelNN.AddInputIndex(i);
    if not UpdateNetwork then
    begin
      lbInput.Items.Delete(lbInput.Items.Count-1);
      lbParameters.Items.Add(s);
      UpdateNetwork;
    end;
  end;
end;

procedure TFrmNN.sbInputRemoveClick(Sender: TObject);
var s : string;
    //i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (lbInput.ItemIndex > -1) and (R <> NIL) and (FSelNN <> NIL) then
  begin
    if lbOutput.Count > (lbInput.Count - 1) then
      ShowMessage('Aantal uitvoerparameters mag niet groter zijn dan het aantal invoerparameters')
    else
    begin
      s:= lbInput.Items[lbInput.ItemIndex];
      //i:= R.GetNumberIndexByName(s);
      lbInput.Items.Delete(lbInput.ItemIndex);
      lbParameters.Items.Add(s);
      UpdateNetwork;
    end;
  end;
end;

procedure TFrmNN.sbOutputAddClick(Sender: TObject);
var s : string;
    //i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (lbParameters.ItemIndex > -1) and (R <> NIL) and (FSelNN <> NIL) then
  begin
    if (lbOutput.Count + 1) > lbInput.Count then
      ShowMessage('Aantal uitvoerparameters mag niet groter zijn dan het aantal invoerparameters')
    else
    begin
      s:= lbParameters.Items[lbParameters.ItemIndex];
      //i:= R.GetNumberIndexByName(s);
      lbParameters.Items.Delete(lbParameters.ItemIndex);
      lbOutput.Items.Add(s);
  //    FSelNN.AddOutputIndex(i);
      if not UpdateNetwork then
      begin
        lbOutput.Items.Delete(lbOutput.Items.Count-1);
        lbParameters.Items.Add(s);
        UpdateNetwork;
      end;
    end;
  end;
end;

procedure TFrmNN.sbOutputRemoveClick(Sender: TObject);
var s : string;
    //i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (lbOutput.ItemIndex > -1) and (R <> NIL) and (FSelNN <> NIL) then
  begin
    s:= lbOutput.Items[lbOutput.ItemIndex];
    //i:= R.GetNumberIndexByName(s);
    lbOutput.Items.Delete(lbOutput.ItemIndex);
    lbParameters.Items.Add(s);
    UpdateNetwork;
  end;
end;

procedure TFrmNN.sgInputDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
var rect : TRect;
begin
  if (sgInput.Row = aRow) and (sgInput.Col = aCol) and (sgInput.Editor = fsePrediction) then
  begin
    if (sgInput.TopRow <= aRow) and (sgInput.TopRow + round(sgInput.Height / sgInput.DefaultRowHeight) > aRow) then
    begin
      rect:= sgInput.CellRect(aCol, aRow);
      fsePrediction.BoundsRect:= rect;
      fsePrediction.Visible:= TRUE;
    end;
  end;
  if (sgInput.TopRow > FISGY) or (sgInput.TopRow + round(sgInput.Height / sgInput.DefaultRowHeight) <= FISGY) then
    fsePrediction.Visible:= false;
end;

procedure TFrmNN.sgInputEditingDone(Sender: TObject);
begin
  //
end;

procedure TFrmNN.sgInputExit(Sender: TObject);
begin
  sgInput.Editor:= NIL;
end;

procedure TFrmNN.sgInputSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  sgInput.Editor:= NIL;
end;

procedure TFrmNN.sgInputSelectEditor(Sender: TObject; aCol, aRow: Integer;
  var Editor: TWinControl);
var R : TRecipe;
    i : integer;
    d : double;
    rect : TRect;
begin
  R:= TRecipe(Brews.Item[0]);
  if (R <> NIL) and (FSelNN <> NIL) and (aCol = 1) and (aRow > 0) and FUserClicked then
  begin
    FUserClicked:= false;
    i:= aRow - 1;
    rect:= sgInput.CellRect(aCol, aRow);
    fsePrediction.BoundsRect:= rect;
    fsePrediction.MinValue:= FSelNN.InputMin[i];
    fsePrediction.MaxValue:= FSelNN.InputMax[i];
    fsePrediction.DecimalPlaces:= R.GetNumberDecimalsByName(FSelNN.InputIndex[i]);
    fsePrediction.Increment:= Power(10, -fsePrediction.DecimalPlaces);
    d:= StrToReal(sgInput.Cells[1, aRow]);
    fsePrediction.Value:= d;
    Editor:= fsePrediction;
    fsePrediction.Visible:= TRUE;
    FISGX:= aCol;
    FISGY:= aRow;
    FUserclicked:= TRUE;
  end
  else
  begin
    fsePrediction.Visible:= false;
    Editor:= NIL;
    FISGX:= -1;
    FISGY:= -1;
  end;
end;

procedure TFrmNN.fsePredictionChange(Sender: TObject);
var d : double;
    s : string;
    i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (R <> NIL) and FUserClicked then
  begin
    d:= fsePrediction.Value;
    FUserClicked:= false;

    i:= sgInput.Row - 1;
    s:= RealToStrDec(d, R.GetNumberDecimalsByName(FSelNN.InputIndex[i]));
    sgInput.Cells[1, i+1]:= s;
    UpdatesgOutput;

    cbResponseChange(self);

    FUserClicked:= TRUE;
  end;
end;

procedure TFrmNN.tbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmNN.tbCopyClick(Sender: TObject);
begin
  if pcMain.ActivePage = tsTrain then
    chTrain.CopyToClipboardBitmap
  else if pcMain.ActivePage = tsPredict then
    chResponse.CopyToClipboardBitmap;
end;

procedure TFrmNN.tbPrintClick(Sender: TObject);
const MARGIN = 10;
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
    if pcMain.ActivePage = tsTrain then
      chTrain.Draw(TPrinterDrawer.Create(Printer), r)
    else if pcMain.ActivePage = tsPredict then
      chResponse.Draw(TPrinterDrawer.Create(Printer), r)
  finally
    Printer.EndDoc;
  end;
end;

procedure TFrmNN.tbSaveClick(Sender: TObject);
var ext : string;
    fs: TFileStream;
    id: IChartDrawer;
begin
  if (pcMain.ActivePage = tsResult) or (pcMain.ActivePage = tsPredict) then
  begin
    if spdChart.Execute then
    begin
      ext:= Lowercase(ExtractFileExt(spdChart.FileName));
      if ext = '.bmp' then ChTrain.SaveToBitmapFile(spdChart.FileName)
      else if ext = '.jpg' then ChTrain.SaveToFile(TJPEGImage, spdChart.FileName)
      else if ext = '.png' then ChTrain.SaveToFile(TPortableNetworkGraphic, spdChart.FileName)
      else if ext = '.svg' then
      begin
        fs := TFileStream.Create(spdChart.FileName, fmCreate);
        try
          id := TSVGDrawer.Create(fs, true);
          id.DoChartColorToFPColor := @ChartColorSysToFPColor;

          if pcMain.ActivePage = tsResult then
            ChTrain.Draw(id, Rect(0, 0, Width, Height))
          else if pcMain.ActivePage = tsPredict then
            ChResponse.Draw(id, Rect(0, 0, Width, Height));
        finally
          fs.Free;
        end;
      end;
    end;
  end;
  BHNNs.SaveXML;
  FChanged:= false;
end;

Procedure TFrmNN.AskToSave;
begin
  if FChanged and Question(self, 'Wil je wijzigingen bewaren?') then
    BHNNs.SaveXML;
  FChanged:= false;
end;

procedure TFrmNN.tvNNSelectionChanged(Sender: TObject);
begin
  FUserClicked:= false;
  AskToSave;
  FSelNN:= NIL;
  if (tvNN.Selected <> NIL) and (tvNN.Selected.Data <> NIL) then
    FSelNN:= TBHNN(tvNN.Selected.Data);
  bbRemoveNN.Enabled:= ((tvNN.Selected <> NIL) and (tvNN.Selected.Level = 2));
  pcMain.Visible:= bbRemoveNN.Enabled;

  Update;
  UpdateChart;
  FUserClicked:= TRUE;
end;

Procedure TFrmNN.Execute;
begin
  ShowModal;
end;

Function TFrmNN.UpdateNetwork : boolean;
var s : string;
    i : integer;
    numvalid : longint;
    R : TRecipe;
begin
  Result:= false;
  FUserClicked:= false;
  numvalid:= -1;
  R:= TRecipe(Brews.Item[0]);
  if (FSelNN <> NIL) and (R <> NIL) then
  begin
    FChanged:= TRUE;
    if FSelNN.IsBuilt then FSelNN.UnBuild;
    FSelNN.IsTrained:= false;
    eTrained.Text:= 'Netwerk is niet getraind';
    eTrained.Color:= clRed;
    eTrained.Font.Color:= clWhite;
    eTrained.Font.Style:= [];
    s:= cbEquipment.Items[cbEquipment.ItemIndex];
    if s = 'Alle' then s:= '';
    FSelNN.Equipment:= s;
    FSelNN.ClearInputIndexs;
    for i:= 0 to lbInput.Count - 1 do
    begin
      s:= lbInput.Items[i];
      FSelNN.AddInputIndex(s);
    end;
    FSelNN.ClearOutputIndexs;
    cbOutputPar.Clear;
    for i:= 0 to lbOutput.Count - 1 do
    begin
      s:= lbOutput.Items[i];
      cbOutputPar.Items.Add(s);
      FSelNN.AddOutputIndex(s);
    end;
    gbTrain.Enabled:= (lbInput.Count > 0) and (lbOutput.Count > 0);

    Result:= TRUE;
    if gbTrain.Enabled then
      if not FSelNN.CheckNumValidData(numvalid) then
      begin
        PlayWarning;
        ShowNotification(self, 'Te weinig data voor aantal in- en uitvoerparameters.');
        ShowNotification(self, 'Laatste parameter wordt verwijderd.');
//        gbTrain.Enabled:= false;
        Result:= false;
      end
      else
      begin
        FSelNN.Build;
        Result:= TRUE;
      end;

    if numvalid >= 0 then eNumValid.Text:= IntToStr(numvalid)
    else eNumValid.Text:= '';
    tsResult.TabVisible:= FSelNN.IsTrained;
    if FSelNN.IsTrained then UpdateChart;
  end;
  FUserClicked:= TRUE;
end;

Procedure TFrmNN.Update;
var i, j : integer;
    d : double;
    s : string;
    R : TRecipe;
    numvalid : longint;
begin
  R:= TRecipe(Brews.Item[0]);
  if (FSelNN <> NIL) and (R <> NIL) then
  begin
    FUserClicked:= false;
    if FSelNN.IsTrained then
    begin
      eTrained.Text:= 'Netwerk is getraind';
      eTrained.Color:= clDefault;
      eTrained.Font.Color:= clDefault;
      eTrained.Font.Style:= [fsBold];
    end
    else
    begin
      eTrained.Text:= 'Netwerk is niet getraind';
      eTrained.Color:= clRed;
      eTrained.Font.Color:= clWhite;
      eTrained.Font.Style:= [];
    end;

    s:= FSelNN.Equipment;
    if s = '' then s:= 'Alle';
    cbEquipment.ItemIndex:= cbEquipment.Items.IndexOf(s);

    eName.Text:= FSelNN.Name;

    lbInput.Clear;
    for i:= 0 to FSelNN.InputCount - 1 do
      lbInput.Items.Add(FSelNN.InputIndex[i]);
    lbOutput.Clear;
    cbOutputPar.Clear;
    for i:= 0 to FSelNN.OutputCount - 1 do
    begin
      lbOutput.Items.Add(FSelNN.OutputIndex[i]);
      cbOutputPar.Items.Add(FSelNN.OutputIndex[i]);
    end;
    if FSelNN.OutputCount > 0 then cbOutputPar.ItemIndex:= 0;
    lbParameters.Clear;
    for i:= 0 to R.NumNumbers - 1 do
    begin
      s:= R.GetNumberNameByIndex(i+1);
      if (lbInput.Items.IndexOf(s) = -1) and (lbOutput.Items.IndexOf(s) = -1) then
        lbParameters.Items.Add(s);
    end;
    gbTrain.Enabled:= (lbInput.Count > 0) and (lbOutput.Count > 0);

    s:= ActivationFunctionNames[FSelNN.ActivationFunction];
    i:= cbActivationFunction.Items.IndexOf(s);
    cbActivationFunction.ItemIndex:= i;

    FSelNN.CheckNumValidData(numvalid);
    eNumValid.Text:= IntToStr(numvalid);
    if FSelNN.IsTrained then lError.Caption:= SysUtils.Format('%.6f',[FSelNN.MSE])
    else lError.Caption:= '';

    tsResult.TabVisible:= FSelNN.IsTrained;
    tsPredict.TabVisible:= FSelNN.IsTrained;
    if tsPredict.TabVisible then
    begin
      j:= FSelNN.InputCount + 1;
      sgInput.RowCount:= j;
      cbResponse.Clear;
      for i:= 0 to FSelNN.InputCount - 1 do
      begin
        s:= FSelNN.InputIndex[i];
        sgInput.Cells[0, i+1]:= s;
        cbResponse.Items.Add(s);
        d:= (FSelNN.InputMin[i] + FSelNN.InputMax[i]) / 2;
        s:= RealToStrDec(d, R.GetNumberDecimalsByName(FSelNN.InputIndex[i]));
        sgInput.Cells[1, i+1]:= s;
      end;
      cbResponse.ItemIndex:= 0;
      sgOutput.RowCount:= FSelNN.OutputCount + 1;
      cbResponse2.Clear;
      for i:= 0 to FSelNN.OutputCount - 1 do
      begin
        s:= FSelNN.OutputIndex[i];
        sgOutput.Cells[0, i+1]:= s;
//        sgOutput.Cells[1, i+1]:= RealToStrDec(FSelNN.OutputMin[i], R.GetNumberDecimalsByIndex(FSelNN.OutputIndex[i]));
        cbResponse2.Items.Add(s);
      end;
      cbResponse2.ItemIndex:= 0;
      FUserClicked:= TRUE;
      UpdatesgOutput;

      cbResponseChange(Self);
    end;
    FUserClicked:= TRUE;
  end;
end;

Procedure TFrmNN.UpdatesgOutput;
var Inp, Outp : array of double;
    i : integer;
    R : TRecipe;
begin
  R:= TRecipe(Brews.Item[0]);
  if (FSelNN <> NIL) and (R <> NIL) and (FSelNN.IsTrained) then
  begin
    try
      SetLength(Inp, FSelNN.InputCount);
      SetLength(Outp, FSelNN.OutputCount);
      for i:= 0 to FSelNN.InputCount - 1 do
        Inp[i]:= StrToFloat(sgInput.Cells[1, i+1]);
      FSelNN.Run(Inp, Outp);
      for i:= 0 to FSelNN.OutputCount - 1 do
        sgOutput.Cells[1, i+1]:= RealToStrDec(Outp[i], R.GetNumberDecimalsByName(FSelNN.OutputIndex[i]));
    finally
      SetLength(Inp, 0);
      SetLength(Outp, 0);
    end;
  end;
end;

Procedure TFrmNN.FillTree;
var i : longint;
    s : string;
    BHNN : TBHNN;
    RootNode, EqNode, NNNode : TTreeNode;
    R : TRecipe;
    SL : TStringList;
begin
  Screen.Cursor:= crHourglass;
  Cursor:= crHourglass;
  Application.ProcessMessages;
  try
    SL:= TStringList.Create;
    tvNN.Visible:= false;
    tvNN.Items.Clear;
    tvNN.SortType:= stNone;
    RootNode:= tvNN.Items.Add (nil,'Netwerken');
    RootNode.StateIndex:= 0;

    for i:= 0 to Brews.NumItems - 1 do
    begin
      s:= '';
      R:= TRecipe(Brews.Item[i]);
      if R.Equipment <> NIL then
        s:= R.Equipment.Name.Value;
      if (SL.IndexOf(s) = -1) and (s <> '') then
        SL.Add(s);
    end;
    SL.Sort;
    s:= 'Alle';
    SL.Insert(0, s);

    for i:= 0 to SL.Count - 1 do
    begin
      s:= SL.Strings[i];
      EqNode:= tvNN.Items.AddChild(RootNode, s);
      EqNode.StateIndex:= 1;
    end;

    for i:= 0 to BHNNs.Count - 1 do
    begin
      BHNN:= BHNNs.BHNN[i];
      if BHNN <> NIL then
      begin
        s:= BHNN.Equipment;
        if s = '' then s:= 'Alle';
        EqNode:= tvNN.Items.FindNodeWithText(s);
        if EqNode = NIL then //equipment has not been found
        begin
          EqNode:= tvNN.Items.AddChild(RootNode, s);
          EqNode.StateIndex:= 1;
        end;
        s:= BHNN.Name;
        NNNode:= tvNN.Items.AddChildObject(EqNode, s, BHNN);
        NNNode.StateIndex:= 2;
      end;
    end;
  finally
    tvNN.SortType:= stNone;
//    tvNN.SortType:= stText;
    tvNN.Visible:= TRUE;
    FreeAndNIL(SL);
    Screen.Cursor:= crDefault;
    Cursor:= crDefault;
  end;
end;

procedure TFrmNN.bbNewNNClick(Sender: TObject);
var BHNN : TBHNN;
    Node, NNNode : TTreeNode;
    i : integer;
    s : string;
begin
  FUserClicked:= false;
  tsResult.TabVisible:= false;
  tlsResult.Clear;
  tls1.Clear;
  BHNN:= BHNNs.AddBHNN;
  Node:= tvNN.Selected;
  if Node <> NIL then
  begin
    if Node.Level = 2 then
      Node:= Node.Parent;
    if Node.Level = 1 then
    begin
      s:= Node.Text;
      if s = 'Alle' then s:= '';
      BHNN.Equipment:= s;
    end
    else if Node.Level = 0 then
    begin
      BHNN.Equipment:= '';
      Node:= tvNN.Items.FindNodeWithText('Alle');
    end;
  end
  else
  begin
    BHNN.Equipment:= '';
    Node:= tvNN.Items.FindNodeWithText('Alle');
  end;

  BHNN.Name:= 'Nieuw netwerk';
  FSelNN:= BHNN;

  s:= ActivationFunctionNames[FSelNN.ActivationFunction];
  i:= cbActivationFunction.Items.IndexOf(s);
  cbActivationFunction.ItemIndex:= i;

  s:= BHNN.Name;
  NNNode:= tvNN.Items.AddChildObject(Node, s, BHNN);
  NNNode.StateIndex:= 2;
  NNNode.Selected:= TRUE;
  tvNNSelectionChanged(Self);
//  Update;
  eNumValid.Text:= '';
  lError.Caption:= '';
  FChanged:= TRUE;
  FUserClicked:= TRUE;
end;

procedure TFrmNN.bbRemoveNNClick(Sender: TObject);
var pn, tn, ns : TTreeNode;
    FS : TBHNN;
begin
  if FSelNN <> NIL then
    if Question(self, 'Weet je heel zeker dat je ' + FSelNN.Name + ' wilt verwijderen?') then
    begin
      FUserClicked:= false;
      tn:= tvNN.Selected.GetNextSibling;
      if tn = NIL then tn:= tvNN.Selected.GetPrevSibling;
      if tn = NIL then
      begin
        pn:= tvNN.Selected.Parent;
        if pn <> NIL then
          ns:= pn.GetNextSibling;
          if ns <> NIL then
            tn:= ns.GetFirstChild;
      end;
      ns:= NIL;
      if (tn = NIL) and (pn <> NIL) then
        ns:= pn.GetPrevSibling;
      if ns <> NIL then
        tn:= ns.GetFirstChild;

      ns:= tvNN.Selected;
      ns.Data:= NIL;
      FS:= FSelNN;
      if ns <> NIL then
        tvNN.Selected.Delete;
      FSelNN:= FS;
      BHNNs.RemoveByReference(FSelNN);
      FSelNN:= NIL;
      if tn <> nil then tn.Selected:= TRUE;
      tvNNSelectionChanged(Self);
    //  Update;
      FChanged:= TRUE;
      FUserClicked:= TRUE;
    end;
end;

procedure TFrmNN.cbEquipmentChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    UpdateNetwork;
    FillTree;
  end;
end;

procedure TFrmNN.eNameChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FSelNN.Name:= eName.Text;
    tvNN.Selected.Text:= eName.Text;
    FChanged:= TRUE;
  end;
end;

procedure TFrmNN.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  CanClose:= not FTraining;
end;

procedure TFrmNN.bbRebuildClick(Sender: TObject);
begin
  if FSelNN <> NIL then
  begin
    FSelNN.UnBuild;
    FSelNN.Build;
    Update;
    FChanged:= TRUE;
  end;
end;

procedure TFrmNN.cbActivationFunctionChange(Sender: TObject);
begin
  if (FSelNN <> NIL) and FUserClicked then
  begin
    FSelNN.ActivationFunction:= GetActivationFunctionFromName(cbActivationFunction.Items[cbActivationFunction.ItemIndex]);
    Update;
    FChanged:= TRUE;
  end;
end;

procedure TFrmNN.bbTrainClick(Sender: TObject);
begin
  if FSelNN <> NIL then
  begin
    Screen.Cursor:= crHourglass;
    pTree.Enabled:= false;
    eTrained.Enabled:= false;
    gbProperties.Enabled:= false;
    bbTrain.Enabled:= false;
    seTrainingRounds.Enabled:= false;
    fseError.Enabled:= false;
    tsResult.Enabled:= false;
    tsPredict.Enabled:= false;
    bbRebuild.Enabled:= false;
    cbActivationFunction.Enabled:= false;
    tbMenu.Enabled:= false;
    try
      FSelNN.OnTrainRound:= @NNOnTrainRound;
      FSelNN.OnTrainReady:= @NNOnTrainReady;
      if not FSelNN.IsBuilt then FSelNN.Build;
      FTraining:= TRUE;
      FSelNN.Train(100, seTrainingRounds.Value, fseError.Value);
      FSelNN.OnTrainRound:= NIL;
      FTraining:= false;
    finally
      Screen.Cursor:= crDefault;
      pTree.Enabled:= TRUE;
      eTrained.Enabled:= TRUE;
      gbProperties.Enabled:= TRUE;
      bbTrain.Enabled:= TRUE;
      seTrainingRounds.Enabled:= TRUE;
      fseError.Enabled:= TRUE;
      tsResult.Enabled:= TRUE;
      tsPredict.Enabled:= TRUE;
      bbRebuild.Enabled:= TRUE;
      tbMenu.Enabled:= TRUE;
    end;
  end;
end;

procedure TFrmNN.NNOnTrainRound(Sender : TObject; Error, Progress : single);
begin
  lError.Caption:= SysUtils.Format('%.6f',[Error]);
  pbTraining.Position:= round(Progress);
end;

procedure TFrmNN.NNOnTrainReady(Sender : TObject; Error : single);
begin
  lError.Caption:= SysUtils.Format('%.6f',[Error]);
  eTrained.Text:= 'Netwerk is getraind';
  eTrained.Color:= clDefault;
  eTrained.Font.Color:= clDefault;
  eTrained.Font.Style:= [fsBold];
  FSelNN.IsTrained:= TRUE;
  pbTraining.Position:= 0;
  tsResult.TabVisible:= TRUE;
  tsPredict.TabVisible:= TRUE;
  cbActivationFunction.Enabled:= TRUE;
  cbOutputPar.ItemIndex:= 0;
  Application.ProcessMessages;
  cbOutputParChange(self);
  FUserClicked:= false;
  Update;
  pcMain.ActivePage:= tsResult;
  FUserClicked:= TRUE;
end;

procedure TFrmNN.cbOutputParChange(Sender: TObject);
begin
  if FUserClicked then
    UpdateChart;
end;

procedure TFrmNN.cbResponseChange(Sender: TObject);
var i : integer;
    Inp, Outp : array of double;
    dx, x, y, xmin, xmax : double;
    sx, sy : string;
    R : TRecipe;
const
    nsteps = 100;
begin
  R:= TRecipe(Brews.Item[0]);
  if (FSelNN <> NIL) and (R <> NIL) and (cbResponse.ItemIndex > -1) and (cbResponse2.ItemIndex > -1) then
  begin
    try
      SetLength(Inp, FSelNN.InputCount);
      SetLength(Outp, FSelNN.OutputCount);
      for i:= 0 to FSelNN.InputCount - 1 do
      begin
        Inp[i]:= StrToReal(sgInput.Cells[1, i+1]);
      end;

      sx:= cbResponse.Items[cbResponse.ItemIndex] + ' (' +
           R.GetNumberDisplayUnitByIndex(R.GetNumberIndexByName(cbResponse.Items[cbResponse.ItemIndex])) + ')';
      xmin:= FSelNN.InputMin[cbResponse.ItemIndex];
      xmax:= FSelNN.InputMax[cbResponse.ItemIndex];

      sy:= cbResponse2.Items[cbResponse2.ItemIndex] + ' (' +
           R.GetNumberDisplayUnitByIndex(R.GetNumberIndexByName(cbResponse2.Items[cbResponse2.ItemIndex])) + ')';

      dx:= (xmax - xmin) / nsteps;

      chResponse.BottomAxis.Title.Caption:= sx;
      chResponse.LeftAxis.Title.Caption:= sy;
      clsResponse.BeginUpdate;
      clsResponse.Clear;
      for i:= 0 to nsteps do
      begin
        inp[cbResponse.ItemIndex]:= xmin + i * dx;
        FSelNN.Run(Inp, Outp);
        x:= inp[cbResponse.ItemIndex];
        y:= Outp[cbResponse2.ItemIndex];
        clsResponse.AddXY(x, y);
      end;
      clsResponse.EndUpdate;
    finally
      SetLength(Inp, 0);
      SetLength(Outp, 0);
    end;
  end;
end;

procedure TFrmNN.cbShowLabelsChange(Sender: TObject);
begin
  tlsResult.Marks.Visible:= cbShowLabels.Checked;
  if cbShowLabels.Checked then tlsResult.Marks.Style:= smsLabel
  else tlsResult.Marks.Style:= smsNone;
end;

procedure TFrmNN.ChartToolset1DataPointCrosshairTool1AfterMouseMove(
  ATool: TChartTool; APoint: TPoint);
var i : longint;
    Xv, Yv : double;
    t : string;
begin
  i:= TDataPointCrosshairTool(atool).PointIndex;
  if i > -1 then
  begin
    Xv:= tlsResult.Source.Item[i]^.X;
    Yv:= tlsResult.Source.Item[i]^.Y;
    t:= tlsResult.Source.Item[i]^.Text + ': meetwaarde ' + RealToStrSignif(Xv, 3)
        + ', voorspelling ' + RealToStrSignif(Yv, 3);
    StatusBar1.Panels.Items[0].Text:= t;
  end
  else StatusBar1.Panels.Items[0].Text:= '';
end;

Procedure TFrmNN.UpdateChart;
var i, j : integer;
    x, y, min, max : double;
    R : TRecipe;
    Inp, Outp, Meas : array of double;
    valid : boolean;
begin
  if (FSelNN <> NIL) and (FSelNN.IsTrained) then
  begin
    min:= 1E10; max:= -1E10;
    SetLength(Inp, FSelNN.InputCount);
    SetLength(Outp, FSelNN.OutputCount);
    SetLength(Meas, FSelNN.OutputCount);
    tlsResult.BeginUpdate;
    try
      tlsResult.Clear;

      for i:= 0 to Brews.NumItems - 1 do
      begin
        R:= TRecipe(Brews.Item[i]);
        if (R <> NIL) and (((R.Equipment <> NIL) and (TLC(R.Equipment.Name.Value) = TLC(FSelNN.Equipment)))
           or (FSelNN.Equipment = '')) then
        begin
          valid:= true;
          for j:= 0 to FSelNN.InputCount - 1 do
          begin
            x:= R.GetNumberByName(FSelNN.InputIndex[j]);
            inp[j]:= x;
            if x < -99 then valid:= false;
          end;
          for j:= 0 to FSelNN.OutputCount - 1 do
          begin
            y:= R.GetNumberByName(FSelNN.OutputIndex[j]);
            meas[j]:= y;
            if y < -99 then valid:= false;
          end;
          if valid then
          begin
            valid:= FSelNN.Run(inp, outp);
            if valid then
            begin
              x:= meas[cbOutputPar.ItemIndex];
              y:= outp[cbOutputPar.ItemIndex];
              if x < min then min:= x;
              if x > max then max:= x;
              if y < min then min:= y;
              if y > max then max:= y;
              tlsResult.AddXY(x, y, R.NrRecipe.Value);
            end;
          end;
        end;
      end;
      tls1.BeginUpdate;
      tls1.Clear;
      tls1.AddXY(min, min);
      tls1.AddXY(max, max);
      tls1.EndUpdate;

      SetLength(Inp, 0);
      SetLength(Outp, 0);
      SetLength(Meas, 0);
    finally
      tlsResult.EndUpdate;
      tlsResult.Marks.Visible:= cbShowLabels.Checked;
    end;
  end;
end;

end.

