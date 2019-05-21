unit frmeasurements;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Grids, EditBtn, Spin, Data;

type

  { TfrmMeasurements }

  TfrmMeasurements = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbNew: TBitBtn;
    bbTcontrol: TBitBtn;
    cbCooling: TCheckBox;
    cbHeating: TCheckBox;
    deDate: TDateEdit;
    fseTemp1: TFloatSpinEdit;
    fseTemp2: TFloatSpinEdit;
    fseInstTemp: TFloatSpinEdit;
    fseSG: TFloatSpinEdit;
    fseCO2: TFloatSpinEdit;
    fseCoolingPower: TFloatSpinEdit;
    gbMeasurements: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    lSG: TLabel;
    lCO2: TLabel;
    lCoolingpower: TLabel;
    lTemp1: TLabel;
    lTemp2: TLabel;
    lInstTemp: TLabel;
    odTControl: TOpenDialog;
    sgMeas: TStringGrid;
    rxteTime : TTimeEdit;
    bbRemoveAll: TBitBtn;
    procedure bbNewClick(Sender: TObject);
    procedure bbTcontrolClick(Sender: TObject);
    procedure cbCoolingChange(Sender: TObject);
    procedure cbHeatingChange(Sender: TObject);
    procedure deDateChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseCO2Change(Sender: TObject);
    procedure fseCoolingPowerChange(Sender: TObject);
    procedure fseInstTempChange(Sender: TObject);
    procedure fseSGChange(Sender: TObject);
    procedure fseTemp1Change(Sender: TObject);
    procedure fseTemp2Change(Sender: TObject);
    procedure sgMeasSelection(Sender: TObject; aCol, aRow: Integer);
    procedure rxteTimeChange(Sender: TObject);
    procedure bbRemoveAllClick(Sender: TObject);
  private
    { private declarations }
    FRecipe : TRecipe;
    FMeasurements : TFermMeasurements;
    FSelM : TFermMeasurement;
    FUserClicked : boolean;
    SL : TStringList;
    tab : char;
    SCS : TSysCharSet;
    Procedure FillStringgrid;
    Function ImportTControl : boolean;
    Function CountColumns : integer;
    Function FindEndHeader : integer;
  public
    { public declarations }
    Function Execute(R : TRecipe) : boolean;
  end; 

var
  frmMeasurements: TfrmMeasurements;

implementation

{$R *.lfm}
uses Hulpfuncties, StrUtils;

{ TfrmMeasurements }

procedure TfrmMeasurements.FormCreate(Sender: TObject);
begin
  {$ifdef windows}
  gbMeasurements.Font.Height:= 0;
  {$endif}

  FUserClicked:= TRUE;
  rxteTime := TTimeEdit.Create(self);
  rxteTime.Parent:= gbMeasurements;
  rxteTime.Top:= 424;
  rxteTime.Left:= 205;
  rxteTime.Width:= 80;
  rxteTime.Height:= 24;
  rxteTime.Font.Height:= 0;
  rxteTime.Time:= 0;
  rxteTime.OnChange:= @rxteTimeChange;

  with sgMeas do
  begin
    AlternateColor:= RGBtoColor(243, 251, 158);
    FixedColor:= RGBtoColor(158, 226, 251);
    SelectedColor:= RGBtoColor(15, 196, 54);
    Cells[0, 1]:= 'dd-mm-jjjj hh:mm:ss'
  end;
  FRecipe:= NIL;
  FMeasurements:= TFermMeasurements.Create(NIL);
  FSelM:= NIL;
  tab := Chr(9);
  SCS:= [tab];

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TfrmMeasurements.FormDestroy(Sender: TObject);
begin
  FMeasurements.Free;
end;

Function TfrmMeasurements.Execute(R : TRecipe) : boolean;
begin
  if R <> NIL then
  begin
    FRecipe:= R;
    lSG.Caption:= R.OG.DisplayUnitString;
    lCO2.Caption:= UnitNames[lph];
    lCoolingpower.Caption:= UnitNames[watt];
    lTemp1.Caption:= R.PrimaryTemp.DisplayUnitString;
    lTemp2.Caption:= R.PrimaryTemp.DisplayUnitString;
    lInstTemp.Caption:= R.PrimaryTemp.DisplayUnitString;
    with sgMeas do
    begin
      Cells[1, 1]:= FRecipe.PrimaryTemp.DisplayUnitString;
      Cells[2, 1]:= FRecipe.PrimaryTemp.DisplayUnitString;
      Cells[3, 1]:= FRecipe.PrimaryTemp.DisplayUnitString;
      Cells[4, 1]:= FRecipe.OG.DisplayUnitString;
      Cells[5, 1]:= UnitNames[lph];
      Cells[6, 1]:= UnitNames[watt];
      Cells[7, 1]:= 'aan/uit';
      Cells[8, 1]:= 'aan/uit';
    end;
    FMeasurements.Assign(FRecipe.FermMeasurements);

    FillStringGrid;

    Result:= (ShowModal = mrOK);

    if Result and (FMeasurements <> NIL) then
    begin
      FMeasurements.Sort;
      FRecipe.FermMeasurements.Assign(FMeasurements);
    end;
  end;
end;

Procedure TfrmMeasurements.FillStringgrid;
var i : integer;
begin
  with sgMeas do
  begin
    sgMeas.RowCount:= sgMeas.FixedRows;

    if FMeasurements <> NIL then
    begin
      RowCount:= FMeasurements.NumMeasurements + 2;
      for i:= 0 to FMeasurements.NumMeasurements - 1 do
      begin
        FSelM:= FMeasurements.Measurement[i];
        if (FSelM <> NIL) and (FSelM.DateTime.Value > 0) then
        begin
          Cells[0, i+sgMeas.FixedRows]:= FSelM.DateTime.DisplayString;
          Cells[1, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[3];
          Cells[2, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[7];
          Cells[3, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[4];
          Cells[4, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[9];
          Cells[5, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[8];
          Cells[6, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[5];
          Cells[7, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[6];
          Cells[8, i+sgMeas.FixedRows]:= FSelM.DisplayStringByIndex[10];
        end;
      end;
      if FMeasurements.NumMeasurements > 0 then
        sgMeas.Row:= sgMeas.FixedRows;
    end;
  end;
end;

procedure TfrmMeasurements.sgMeasSelection(Sender: TObject; aCol, aRow: Integer);
var sg : double;
    b : boolean;
begin //a row is selected. Put values of that row in the edit controls
  FUserClicked:= false;
  if (FMeasurements <> NIL) and (aRow > sgMeas.FixedRows) then
  begin
    FSelM:= FMeasurements.Measurement[aRow-sgMeas.FixedRows];
    if FSelM <> NIL then
    begin
      deDate.Date:= Int(FSelM.DateTime.Value);
      rxteTime.Time:= Frac(FSelM.DateTime.Value);
      if FSelM.Cooling.Value = 0 then b:= false else b:= true;
      cbCooling.Checked:= b;
      if FSelM.Heating.Value = 0 then b:= false else b:= true;
      cbHeating.Checked:= b;
      SetControl(fseTemp1, lTemp1, FSelM.TempS1, TRUE);
      SetControl(fseTemp2, lTemp2, FSelM.TempS2, TRUE);
      SetControl(fseInstTemp, lInstTemp, FSelM.SetPoint, TRUE);
      SetControl(fseSG, lSG, FSelM.SGmeas, TRUE);
      SetControl(fseCO2, lCO2, FSelM.CO2, TRUE);
      SetControl(fseCoolingPower, lCoolingPower, FSelM.CoolPower, TRUE);
    end
    else
    begin
      deDate.Date:= 0;
      rxteTime.Time:= 0;
      cbCooling.Checked:= false;
      cbHeating.Checked:= false;
      fseTemp1.Value:= 0;
      fseTemp2.Value:= 0;
      fseInstTemp.Value:= 0;
      fseSG.Value:= 1.0;
      fseCO2.Value:= 0;
      fseCoolingPower.Value:= 0;
    end;
  end;
  FUserClicked:= TRUE;
end;

procedure TfrmMeasurements.deDateChange(Sender: TObject);
var i : integer;
    M : TFermMeasurement;
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.DateTime.Value:= deDate.Date + rxteTime.Time;
    FMeasurements.Sort;
    for i:= 0 to FMeasurements.NumMeasurements - 1 do
    begin
      M:= FMeasurements.Measurement[i];
      if (M <> NIL) and (M.DateTime.Value > 0) then
      begin
        sgMeas.Cells[0, i+sgMeas.FixedRows]:= M.DateTime.DisplayString;
        sgMeas.Cells[1, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[3];
        sgMeas.Cells[2, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[7];
        sgMeas.Cells[3, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[4];
        sgMeas.Cells[4, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[9];
        sgMeas.Cells[5, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[8];
        sgMeas.Cells[6, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[5];
        sgMeas.Cells[7, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[6];
        sgMeas.Cells[8, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[10];
      end;
    end;
    for i:= 0 to FMeasurements.NumMeasurements - 1 do
    begin
      if FSelM = FMeasurements.Measurement[i] then
        sgMeas.Row:= i + sgMeas.FixedRows;
    end;
  end;
end;

procedure TfrmMeasurements.rxteTimeChange(Sender: TObject);
var i : integer;
    M : TFermMeasurement;
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.DateTime.Value:= deDate.Date + rxteTime.Time;
    FMeasurements.Sort;
    for i:= 0 to FMeasurements.NumMeasurements - 1 do
    begin
      M:= FMeasurements.Measurement[i];
      if (M <> NIL) and (M.DateTime.Value > 0) then
      begin
        sgMeas.Cells[0, i+sgMeas.FixedRows]:= M.DateTime.DisplayString;
        sgMeas.Cells[1, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[3];
        sgMeas.Cells[2, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[7];
        sgMeas.Cells[3, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[4];
        sgMeas.Cells[4, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[9];
        sgMeas.Cells[5, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[8];
        sgMeas.Cells[6, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[5];
        sgMeas.Cells[7, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[6];
        sgMeas.Cells[8, i+sgMeas.FixedRows]:= M.DisplayStringByIndex[10];
      end;
    end;
    for i:= 0 to FMeasurements.NumMeasurements - 1 do
    begin
      if FSelM = FMeasurements.Measurement[i] then
        sgMeas.Row:= i + sgMeas.FixedRows;
    end;
  end;
end;

procedure TfrmMeasurements.fseTemp1Change(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.TempS1.DisplayValue:= fseTemp1.Value;
    sgMeas.Cells[1, sgMeas.Row]:= FSelM.TempS1.DisplayString;
  end;
end;

procedure TfrmMeasurements.fseTemp2Change(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.TempS2.DisplayValue:= fseTemp2.Value;
    sgMeas.Cells[2, sgMeas.Row]:= FSelM.TempS2.DisplayString;
  end;
end;

procedure TfrmMeasurements.fseInstTempChange(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.Setpoint.DisplayValue:= fseInstTemp.Value;
    sgMeas.Cells[3, sgMeas.Row]:= FSelM.Setpoint.DisplayString;
  end;
end;

procedure TfrmMeasurements.fseSGChange(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.SGmeas.DisplayValue:= fseSG.Value;
    sgMeas.Cells[4, sgMeas.Row]:= FSelM.SGmeas.DisplayString;
  end;
end;

procedure TfrmMeasurements.fseCO2Change(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.CO2.DisplayValue:= fseCO2.Value;
    sgMeas.Cells[5, sgMeas.Row]:= FSelM.CO2.DisplayString;
  end;
end;

procedure TfrmMeasurements.fseCoolingPowerChange(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    FSelM.Coolpower.DisplayValue:= fseCoolingpower.Value;
    sgMeas.Cells[6, sgMeas.Row]:= FSelM.Coolpower.DisplayString;
  end;
end;

procedure TfrmMeasurements.cbCoolingChange(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    if cbCooling.Checked then FSelM.Cooling.Value:= 1
    else FSelM.Cooling.Value:= 0;
    if cbCooling.Checked then sgMeas.Cells[7, sgMeas.Row]:= 'aan'
    else sgMeas.Cells[7, sgMeas.Row]:= 'uit';
  end;
end;

procedure TfrmMeasurements.cbHeatingChange(Sender: TObject);
begin
  if (FSelM <> NIL) and FUserClicked then
  begin
    if cbHeating.Checked then FSelM.Heating.Value:= 1
    else FSelM.Heating.Value:= 0;
    if cbHeating.Checked then sgMeas.Cells[8, sgMeas.Row]:= 'aan'
    else sgMeas.Cells[8, sgMeas.Row]:= 'uit';
  end;
end;

procedure TfrmMeasurements.bbNewClick(Sender: TObject);
begin
  sgMeas.RowCount:= sgMeas.RowCount + 1;
  sgMeas.Row:= sgMeas.RowCount - 1;
  FSelM:= FMeasurements.AddMeasurement;
end;

procedure TfrmMeasurements.bbRemoveAllClick(Sender: TObject);
begin
  if Question(self, 'Wil je echt alle metingen verwijderen?') then
  begin
    FMeasurements.Clear;
    FillStringGrid;
  end;
end;

Function TfrmMeasurements.ImportTControl : boolean;
var s, w : string;
    i, y, m, d, h, mi, sec : word;
    StartDate, Date : TDateTime;
    v, hr, sg : double;
    Meas : TFermMeasurement;
    ColCount, DataStart, iDate : integer;
begin
  Result:= false;
  try
    //get the start date and time
    DataStart:= FindEndHeader;
    ColCount:= CountColumns;
    for i:= 0 to DataStart - 3 do
    begin
      s:= SL.Strings[i];
      w:= Trim(ExtractWord(1, s, SCS));
      if w = 'Date' then
      begin
        s:= SL.Strings[i];
        s:= Trim(ExtractWord(2, s, SCS));
        y:= StrToInt(LeftStr(s, 4));
        m:= StrToInt(MidStr(s, 6, 2));
        d:= StrToInt(RightStr(s, 2));
      end
      else if w = 'Time' then
      begin
        s:= SL.Strings[i];
        s:= Trim(ExtractWord(2, s, SCS));
        h:= StrToInt(LeftStr(s, 2));
        mi:= StrToInt(MidStr(s, 4, 2));
        w:= RightStr(s, 9);
        sec:= round(StrToReal(w));
        StartDate:= EncodeDate(y, m, d) + EncodeTime(h, mi, sec, 0);
      end;
    end;
    hr:= 0;
    for i:= DataStart to SL.Count - 1 do
    begin
      s:= SL.Strings[i];
      if trim(s) <> '' then
      begin
        w:= Trim(ExtractWord(1, s, SCS));
        v:= StrToReal(w); //time in seconds
        v:= v / 3600; //time in hours
        if v >= hr then //only import values once every two hours to prevent too much entries
        begin
          hr:= hr + 2;
          v:= v / 24; //time in days
          Date:= StartDate + v;
          Meas:= FMeasurements.AddMeasurement;
          Meas.DateTime.Value:= Date;

          w:= Trim(ExtractWord(2, s, SCS));
          v:= StrToReal(w); //Temp. sensor 1
          Meas.TempS1.Value:= v;
          w:= Trim(ExtractWord(3, s, SCS));
          v:= StrToReal(w); //Setpoint
          Meas.Setpoint.Value:= v;
          w:= Trim(ExtractWord(4, s, SCS));
          v:= StrToReal(w); //Coolpower
          Meas.Coolpower.Value:= v;
          w:= Trim(ExtractWord(5, s, SCS));
          v:= StrToReal(w); //Cooling
          if v < 0 then
            v:= 10;
          Meas.Cooling.Value:= 10 * round(v);
          if ColCount >= 6 then
          begin
            w:= Trim(ExtractWord(6, s, SCS));
            v:= StrToReal(w); //Temp. sensor 2
            Meas.TempS2.Value:= v;
          end;
          if ColCount >= 7 then
          begin
            w:= Trim(ExtractWord(7, s, SCS));
            v:= StrToReal(w); //CO2
            Meas.CO2.Value:= v;
          end;
          if ColCount >= 8 then
          begin
            w:= Trim(ExtractWord(8, s, SCS));
            v:= StrToReal(w); //SVG
            sg:= FRecipe.OG.Value;
            if sg > 1 then v:= sg - (v/100 * (sg - 1))
            else v:= 0;
            Meas.SGmeas.Value:= v;
          end;
          if ColCount >= 9 then
          begin
            w:= Trim(ExtractWord(9, s, SCS));
            v:= StrToReal(w); //Heating
            if v < 0 then v:= 10;
            Meas.Heating.Value:= 10 * round(v);
          end;
          if ColCount >= 10 then
          begin
            w:= Trim(ExtractWord(10, s, SCS));
            v:= StrToReal(w); //CO22
            Meas.CO22.Value:= v;
          end;
        end;
      end;
    end;
    Result:= TRUE;
  except
    Result:= false;
  end;
end;

Function TfrmMeasurements.CountColumns : integer;
var s, w : string;
begin
  Result:= 1;
  s:= SL.Strings[SL.Count - 2];
  repeat
    w:= Trim(ExtractWord(Result, s, SCS));
    if w <> '' then Inc(Result);
  until w = '';
  Result:= Result - 1;
end;

Function TfrmMeasurements.FindEndHeader : integer;
var s, w : string;
begin
  Result:= 0;
  repeat
    Inc(Result);
    s:= Trim(SL.Strings[Result]);
  until (s = '***End_of_Header***');
  Result:= Result + 2;
end;

procedure TfrmMeasurements.bbTcontrolClick(Sender: TObject);
var OK : boolean;
begin
  if (odTControl.Execute) and (FileExists(odTcontrol.FileName)) then
  begin
    try
      OK:= TRUE;
      //empty measurements
      FMeasurements.Clear;
      //import the values into measurements
      SL:= TStringList.Create;
      SL.Sorted:= false;
      SL.LoadFromFile(odTControl.FileName);
      OK:= ImportTControl;
      SL.Free;

      //display measurements in the stringgrid
      if OK then FillStringgrid
      else ShowNotification(self, 'Fout bij importeren TControl log bestand');
      //select the last entry
      sgMeas.Row:= sgMeas.RowCount - 1;
    except
      ShowNotification(self, 'Fout bij importeren TControl log bestand');
    end;
  end;
end;

end.

