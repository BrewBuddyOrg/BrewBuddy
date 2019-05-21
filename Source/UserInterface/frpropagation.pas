unit frpropagation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Grids, Buttons, Data;

type

  { TFrmPropagation }

  TFrmPropagation = class(TForm)
    eAmountCells: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    cbSource: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    lVitality: TLabel;
    fseVitality: TFloatSpinEdit;
    lVitalityu: TLabel;
    lVolume: TLabel;
    fseVolume: TFloatSpinEdit;
    lVolumeu: TLabel;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    cbStarterType: TComboBox;
    sgSteps: TStringGrid;
    Label5: TLabel;
    fseMaxVolume: TFloatSpinEdit;
    lMaxVolume: TLabel;
    GroupBox3: TGroupBox;
    Label7: TLabel;
    Label8: TLabel;
    fseVolumeWort: TFloatSpinEdit;
    lVolumeWort: TLabel;
    fseSG: TFloatSpinEdit;
    Label10: TLabel;
    cbYeastType: TComboBox;
    bbOK: TBitBtn;
    Label11: TLabel;
    eCellsNeeded: TEdit;
    Label12: TLabel;
    lSG: TLabel;
    procedure cbSourceChange(Sender: TObject);
    procedure fseVolumeWortChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbStarterTypeChange(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
  private
    { private declarations }
    FCellsNeeded : double;
    FAuto : boolean;
    Function CalcStart : double;
    Procedure CalcNeeded;
    Procedure CalcSteps;
  public
    { public declarations }
    Function Execute(Rec : TRecipe) : boolean;
  end; 

var
  FrmPropagation: TFrmPropagation;

implementation

{$R *.lfm}
uses Hulpfuncties, Math;

{ TFrmPropagation }

procedure TFrmPropagation.FormCreate(Sender: TObject);
begin
  FAuto:= TRUE;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

Function TFrmPropagation.Execute(Rec : TRecipe) : boolean;
var vol : TBFloat;
    v : double;
begin
  Result:= false;
  if Rec <> NIL then
  begin
    Vol:= TBFloat.Create(nil);
    Vol.Assign(Rec.VolumeFermenter);
    vol.Value:= Rec.BatchSize.Value - Rec.Equipment.TrubChillerLoss.Value + Rec.Equipment.TopUpWater.Value;
    if Rec.VolumeFermenter.Value > 0 then
      Vol.Value:= Rec.VolumeFermenter.Value + Rec.Equipment.TopUpWater.Value;
    v:= vol.DisplayValue;
    SetControl(fseVolumeWort, lVolumeWort, Vol, false);
    fseVolumeWort.Value:= v;
    Vol.Free;
    if Rec.OGFermenter.Value > 1.000 then SetControl(fseSG, lSG, Rec.OGFermenter, TRUE)
    else SetControl(fseSG, lSG, Rec.EstOG, TRUE);
    lMaxVolume.Caption:= Rec.BatchSize.DisplayUnitString;

    cbStarterType.ItemIndex:= 0;
    if Rec.Yeast[0] <> NIL then
    begin
      case Rec.Yeast[0].YeastType of
      ytLager: cbYeastType.ItemIndex:= 0;
      ytAle, ytWheat, ytWine, ytChampagne: cbYeastType.ItemIndex:= 1;
      end;
      cbStartertype.ItemIndex:= cbStarterType.Items.IndexOf(Rec.Yeast[0].StarterTypeDisplayName);
    end;
    CalcStart;
    CalcNeeded;
    CalcSteps;
    ShowModal;
    if (Rec.Yeast[0] <> NIL) and (cbStarterType.ItemIndex > -1) then
      rec.Yeast[0].StarterTypeDisplayName:= cbStarterType.Items[cbStartertype.ItemIndex];
  end;
end;

procedure TFrmPropagation.cbStarterTypeChange(Sender: TObject);
begin
  CalcSteps;
end;

procedure TFrmPropagation.bbOKClick(Sender: TObject);
begin

end;

Function TFrmPropagation.CalcStart : double;
begin
  case cbSource.ItemIndex of
  0: //activator pak
  begin
    lVolume.Caption:= 'Aantal pakken:';
    lVolume.visible:= false;
    fseVolume.Visible:= false;
    lVolumeu.Visible:= false;
    Result:= AmCellspPack / 1E9 * fseVitality.Value / 100;
  end;
  1, 2: //slurry of depot uit fles
  begin
    lVolume.Caption:= 'Volume:';
    lVolume.visible:= TRUE;
    fseVolume.Visible:= TRUE;
    lVolumeu.Visible:= TRUE;
    Result:= fseVitality.Value / 100 * fseVolume.Value * AmCellspMlSlurry / 1E9;
  end;
  end;
  eAmountCells.Text:= RealToStrDec(Result, 0);
end;

Procedure TFrmPropagation.CalcNeeded;
var fact, P, v : double;
begin
  case cbYeastType.Itemindex of
  0: fact:= 1.5;
  1: fact:= 0.75;
  2: fact:= 1.0;
  end;
  P:= SGtoPlato(fseSG.Value);
  v:= fseVolumeWort.Value;
  FCellsNeeded:= fact * P * v; //miljard cellen
  if FCellsNeeded < 100 then
    eCellsNeeded.Text:= RealToStrDec(FCellsNeeded, 1)
  else
    eCellsNeeded.Text:= RealToStrDec(FCellsNeeded, 0);
end;

Procedure TFrmPropagation.CalcSteps;
type
  TStep = record
    Volume : double;
    Cells : double;
  end;
  TStepArray = array of TSTep;
  PStepArray = ^TStepArray;

const numtrials = 12;
var i, n, n2 : integer;
    SA1 : array[0..numtrials-1] of TStepArray;
    StepVol, TotVol, AmCells : double;
    numsteps : array[0..numtrials-1] of integer;

  function TrySteps(StartVol, stepsize : double; SA : PStepArray) : integer;
  var vol : double;
      j : integer;
  begin
    j:= 0;
    Result:= 0;
    AmCells:= CalcStart;
    vol:= startvol;
    if vol > fseMaxVolume.Value then vol:= fseMaxVolume.Value;
    while (AmCells < 0.9 * FCellsNeeded) do
    begin
      SetLength(SA^, j+1);
      SA^[j].Volume:= vol;
      SA^[j].Cells:= AmountCells(cbStarterType.ItemIndex, SA^[j].Volume, AmCells);
      Result:= Result + 1;
      AmCells:= SA^[j].Cells;
      Vol:= stepsize * vol;
      if Vol > fseMaxVolume.Value then Vol:= fseMaxVolume.Value;
      inc(j);
    end;
//    AmCells:= CalcStart;
  end;

begin
  sgSteps.RowCount:= 1;

//ideally, start with 100-200 billion cells/l in the starter
//then scale by a factor of 5 to 10
  i:= 0;
  TotVol:= 0;
  AmCells:= CalcStart;
//first, check if the needed amount of cells can be grown in one step
  TotVol:= StarterSize2(cbStarterType.ItemIndex, FCellsNeeded, AmCells);
  sgSteps.RowCount:= 2;
  if TotVol <= fseMaxVolume.Value then
  begin
    SetLength(SA1[0], 1);
    SA1[0, 0].Volume:= TotVol;
    SA1[0, 0].Cells:= FCellsNeeded;
    n:= 0;
  end
  else
  begin
    TotVol:= 0;
    numsteps[0]:= TrySteps(AmCells / 100, 5, @SA1[0]);
    numsteps[1]:= TrySteps(AmCells / 100, 10, @SA1[1]);
    numsteps[2]:= TrySteps(AmCells / 100, 20, @SA1[2]);
    numsteps[3]:= TrySteps(AmCells / 150, 5, @SA1[3]);
    numsteps[4]:= TrySteps(AmCells / 150, 10, @SA1[4]);
    numsteps[5]:= TrySteps(AmCells / 150, 20, @SA1[5]);
    numsteps[6]:= TrySteps(AmCells / 200, 5, @SA1[6]);
    numsteps[7]:= TrySteps(AmCells / 200, 10, @SA1[7]);
    numsteps[8]:= TrySteps(AmCells / 200, 20, @SA1[8]);
    numsteps[9]:= TrySteps(AmCells / 10, 5, @SA1[9]);
    numsteps[10]:= TrySteps(AmCells / 10, 10, @SA1[10]);
    numsteps[11]:= TrySteps(AmCells / 10, 20, @SA1[11]);

    if (SA1[1, High(SA1[1])].Cells < SA1[0, High(SA1[0])].Cells) then
     n:= 1
    else n:= 0;
    for i:= 2 to numtrials-1 do
      if (SA1[i, High(SA1[i])].Cells < SA1[n, High(SA1[n])].Cells) then
        n:= i;
    n2:= 0;
    for i:= 1 to numtrials-1 do
      if numsteps[i] < numsteps[n2] then
        n2:= i;
//    n:= n2;
  end;

  sgSteps.RowCount:= High(SA1[n]) + 2;
  for i:= Low(SA1[n]) to High(SA1[n]) do
  begin
    sgSteps.Cells[0, i+1]:= 'Stap ' + IntToStr(i+1);
    sgSteps.Cells[1, i+1]:= RealToStrDec(SA1[n, i].Volume, 1);
    sgSteps.Cells[2, i+1]:= RealToStrDec(SA1[n, i].Cells, 0);
  end;

  n2:= 0;
  for i:= Low(SA1[n]) to High(SA1[n]) do
  begin
    if SA1[n, i].Volume = fseMaxVolume.Value then
      Inc(n2);
  end;
  if n2 > 2 then
  begin
    ShowNotification(self, 'Volume kweekvat is te klein. ');
    ShowNotification(self, 'Brouw eerst een kleine batch en gebruik');
    ShowNotification(self, 'de slurry van dat bier voor de grote batch.');
  end;

  for i:= 0 to NumTrials-1 do
    SetLength(SA1[i], 0);
end;

procedure TFrmPropagation.cbSourceChange(Sender: TObject);
begin
  CalcStart;
  CalcSteps;
end;

procedure TFrmPropagation.fseVolumeWortChange(Sender: TObject);
begin
  CalcNeeded;
  CalcSteps;
end;

end.

