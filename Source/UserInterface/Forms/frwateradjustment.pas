unit FrWaterAdjustment;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Grids, Spin, ExtCtrls, Math, Data, Hulpfuncties, PositieInterval;

type

  { TFrmWaterAdjustment }

  TFrmWaterAdjustment = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbTargetWater: TBitBtn;
    bbpHClSO4: TBitBtn;
    bbReset: TBitBtn;
    cbAcidMash: TComboBox;
    cbBaseMash: TComboBox;
    cbSource1: TComboBox;
    cbSource2: TComboBox;
    cbTarget: TComboBox;
    cbAcid: TComboBox;
    cbAutoAcid: TCheckBox;
    eBUGU: TEdit;
    eOptClSO4: TEdit;
    eSpargeLacticAcid: TEdit;
    fseAcidPerc: TFloatSpinEdit;
    fseSpargepH: TFloatSpinEdit;
    fseSpargeVolume: TFloatSpinEdit;
    fseMashAcidPerc: TFloatSpinEdit;
    fseAcid: TFloatSpinEdit;
    fseCaCl2: TFloatSpinEdit;
    fseCaSO4: TFloatSpinEdit;
    fseMgSO4: TFloatSpinEdit;
    fseBase: TFloatSpinEdit;
    fseNaCl: TFloatSpinEdit;
    fseVolume1: TFloatSpinEdit;
    fseVolume2: TFloatSpinEdit;
    fseTargetpH: TFloatSpinEdit;
    gbMash: TGroupBox;
    sgSource : TStringGrid;
    bgBrewingSalts: TGroupBox;
    gbSpargeWater: TGroupBox;
    gbVisual: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    lSpargeLacticAcid: TLabel;
    lSpargeVolume: TLabel;
    lLacticAcid: TLabel;
    lCaCl2: TLabel;
    Label2: TLabel;
    lCaSO4: TLabel;
    lMgSO4: TLabel;
    lNaHCO3: TLabel;
    lNaCl: TLabel;
    lVolume: TLabel;
    rgSource: TRadioGroup;
    piClSO4 : TPosInterval;
    pipH : TPosInterval;
    lVolume1: TLabel;
    lVolume2: TLabel;
    procedure bbpHClSO4Click(Sender: TObject);
    procedure bbResetClick(Sender: TObject);
    procedure bbTargetWaterClick(Sender: TObject);
    procedure cbAcidMashChange(Sender: TObject);
    procedure cbBaseMashChange(Sender: TObject);
    procedure cbSource1Change(Sender: TObject);
    procedure cbSource2Change(Sender: TObject);
    procedure cbTargetChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseAcidPercChange(Sender: TObject);
    procedure fseCaCl2Change(Sender: TObject);
    procedure fseSpargepHChange(Sender: TObject);
    procedure fseSpargeVolumeChange(Sender: TObject);
    procedure fseTargetpHChange(Sender: TObject);
    procedure fseVolume2Change(Sender: TObject);
    procedure rgSourceClick(Sender: TObject);
    procedure sgSourceDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
  private
    FRecipe : TRecipe;
    FSource1, FSource2, FMashWater, FAdjustedWater, FTargetWater : TWater;
    FColorCells : array of TCellCoord;
    FWarningColor : TColor;
    FUserClicked : boolean;
    Procedure ColorCell(Col, Row : integer);
    Procedure DeColorCell(Col, Row : integer);
    Procedure MixWater(W1, W2, Wr : TWater);
    Procedure CalcWater;
    Procedure CalcWater2;
    Procedure CalcSparge;
    Procedure SetTable(Row : integer; W : TWater);
    Procedure GetAcidSpecs(AT : TAcidType; var pK1, pK2, pK3, MolWt, AcidSG, AcidPrc : double);
    Function GetFrac(pH, pK1, pK2, pK3 : double) : double;
    Function PartCO3(pH : double) : double;
    Function PartHCO3(pH : double) : double;
    Function PartH2CO3(pH : double) : double;
    Function Charge(pH : double) : double;
    Function GetDefaultPerc(at : TAcidType) : double;
    Procedure Dilute(perc : double);
  public
    Function Execute(R : TRecipe) : boolean;
  end; 

var
  FrmWaterAdjustment: TFrmWaterAdjustment;

implementation

{$R *.lfm}
uses Containers, FrMain;

const
  Ka1 = 0.0000004445;
  Ka2 = 0.0000000000468;

procedure TFrmWaterAdjustment.FormCreate(Sender: TObject);
var at : TAcidType;
    bt : TBaseType;
begin
  {$ifdef Linux}
  Font.Height:= 12;
  {$endif}
  {$ifdef Windows}
  Font.Height:= 0;
  {$endif}

  FWarningColor:= clRed;

  piClSO4:= TPosInterval.Create(gbVisual);
  piClSO4.Parent:= gbVisual;
  piClSO4.Left:= 231;
  piClSO4.Top:= 1;
  piClSO4.Width:= 261;
  piClSO4.Height:= 40;
//  piClSO4.Font.Height:= 12;
  piClSO4.Caption:= 'Cl/SO4 ratio: ';
  piClSO4.ShowValues:= false;
  piClSO4.Effect:= ePlain;
  piClSO4.Decimals:= 0;
  piClSO4.Min:= 0;
  piClSO4.Max:= 3;
  piClSO4.Value:= 0.8;

  pipH:= TPosInterval.Create(gbVisual);
  pipH.Parent:= gbVisual;
  pipH.Left:= 231;
  pipH.Top:= 41;
  pipH.Width:= 261;
  pipH.Height:= 40;
//  pipH.Font.Height:= 12;
  pipH.Caption:= 'Geschatte pH: ';
  pipH.ShowValues:= false;
  pipH.Effect:= ePlain;
  pipH.Decimals:= 0;
  pipH.Min:= 4.0;
  pipH.Max:= 7.0;
  pipH.Value:= 5.4;
  pipH.Low:= 5.2;
  pipH.High:= 5.6;

  for at:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
  begin
    cbAcidMash.Items.Add(AcidTypeDisplayNames[at]);
    cbAcid.Items.Add(AcidTypeDisplayNames[at]);
  end;

  for bt:= Low(BaseTypeDisplayNames) to High(BaseTypeDisplayNames) do
    cbBaseMash.Items.Add(BaseTypeDisplayNames[bt]);

  FUserClicked:= TRUE;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmWaterAdjustment.FormDestroy(Sender: TObject);
begin
  FSource1.Free;
  FSource2.Free;
  FMashWater.Free;
  FAdjustedWater.Free;
  FTargetWater.Free;
  piClSO4.Free;
end;

Function TFrmWaterAdjustment.Execute(R : TRecipe) : boolean;
var i, n : integer;
    wc, prc : double;
    s : string;
    M : TMisc;
    W, W2 : TWater;
    at, atc : TAcidType;
    bt, btc : TBaseType;
begin
  FUserClicked:= false;
  Result:= false;
  FRecipe:= R;
  FSource1:= TWater.Create(FRecipe);
  FSource1.Name.Value:= 'Bron 1';
  FSource1.Amount.Value:= 0;
  FSource2:= TWater.Create(FRecipe);
  FSource2.Name.Value:= 'Bron 2';
  FSource2.Amount.Value:= 0;
  FMashWater:= TWater.Create(FRecipe);
  FMashWater.Name.Value:= 'Na mengen';
  FAdjustedWater:= TWater.Create(FRecipe);
  FAdjustedWater.Name.Value:= 'Aangepast';
  FAdjustedWater.Amount.Value:= 0;
  FTargetWater:= TWater.Create(FRecipe);
  FTargetWater.Name.Value:= 'Doelwater';
  FTargetWater.Amount.Value:= 0;

  if FRecipe <> NIL then
  begin
    fseVolume2.Enabled:= not FRecipe.Locked.Value;
    cbSource1.Enabled:= not FRecipe.Locked.Value;
    cbSource2.Enabled:= not FRecipe.Locked.Value;
    cbTarget.Enabled:= not FRecipe.Locked.Value;
    fseCaCl2.Enabled:= not FRecipe.Locked.Value;
    fseCaSO4.Enabled:= not FRecipe.Locked.Value;
    cbAcidMash.Enabled:= not FRecipe.Locked.Value;
    cbBaseMash.Enabled:= not FRecipe.Locked.Value;
    fseMgSO4.Enabled:= not FRecipe.Locked.Value;
    fseBase.Enabled:= not FRecipe.Locked.Value;
    fseNaCl.Enabled:= not FRecipe.Locked.Value;
    fseAcid.Enabled:= not FRecipe.Locked.Value;
    fseMashAcidPerc.Enabled:= not FRecipe.Locked.Value;
    fseSpargeVolume.Enabled:= not FRecipe.Locked.Value;

    cbAutoAcid.Checked:= FRecipe.CalcAcid.Value;
    fseBase.ReadOnly:= cbAutoAcid.Checked;
    fseAcid.ReadOnly:= cbAutoAcid.Checked;

    M:= TMisc(Miscs.FindByName(AcidTypeDisplayNames[atLactic]));
    if M <> NIL then s:= M.Amount.DisplayUnitString
    else s:= 'ml';
    lLacticAcid.Caption:= s;
    //lSpargeLacticAcid.Caption:= s + ' melkzuur';
    lSpargeVolume.Caption:= FRecipe.Equipment.BatchSize.DisplayUnitString;
    if FRecipe.VolumeHLT.Value > 0 then
      fseSpargeVolume.Value:= FRecipe.VolumeHLT.DisplayValue
    else
      fseSpargeVolume.Value:= StrToFloat(FrmMain.eSpargeWater.Caption);

    eBUGU.Text:= RealToStrDec(FRecipe.BUGU, 2);
    eOptClSO4.Text:= RealToStrDec(FRecipe.OptClSO4ratio, 1);

    if (FRecipe.Mash <> NIL) and (FRecipe.Mash.MashStep[0] <> NIL) then
      lVolume.Caption:= 'Volume (' + FRecipe.Mash.MashStep[0].InfuseAmount.DisplayUnitString + ')'
    else
      lVolume.Caption:= 'Volume';

    if FRecipe.Mash <> NIL then
    begin
      fseVolume1.MaxValue:= Convert(liter, FRecipe.BatchSize.DisplayUnit, FRecipe.Mash.MashWaterVolume);
      fseVolume2.MaxValue:= Convert(liter, FRecipe.BatchSize.DisplayUnit, FRecipe.Mash.MashWaterVolume);
    end;

    Waters.SortByIndex(0, false, 1, Waters.NumItems-1);
    if Waters.Item[0].Name.Value <> 'Gedemineraliseerd water' then
    begin
      Waters.InsertItem(0);
      TWater(Waters.Item[0]).pHwater.Value:= 7;
      TWater(Waters.Item[0]).Name.Value:= 'Gedemineraliseerd water';
    end;
    for i:= 0 to Waters.NumItems - 1 do
      cbSource1.Items.Add(Waters.Item[i].Name.Value);

    if FRecipe.Water[0] <> NIL then
    begin
      FSource1.Assign(FRecipe.Water[0]);
      i:= cbSource1.Items.IndexOf(FRecipe.Water[0].Name.Value);
      if i < 0 then
      begin
        cbSource1.Items.Add(FRecipe.Water[0].Name.Value);
        cbSource1.ItemIndex:= cbSource1.Items.Count - 1;
      end
      else
        cbSource1.ItemIndex:= i;
      rgSource.Items[0]:= 'Alleen ' + cbSource1.Items[cbSource1.ItemIndex];
    end
    else
    begin
      cbSource1.ItemIndex:= -1;
      rgSource.Items[0]:= 'Alleen bron 1';
    end;

    for i:= 0 to Waters.NumItems - 1 do
      cbSource2.Items.Add(Waters.Item[i].Name.Value);

    if FRecipe.Water[1] <> NIL then
    begin
      FSource2.Assign(FRecipe.Water[1]);
      s:= FRecipe.Water[1].Name.Value;
      i:= cbSource2.Items.IndexOf(s);
      if i < 0 then
      begin
        cbSource2.Items.Add(FRecipe.Water[1].Name.Value);
        cbSource2.ItemIndex:= cbSource2.Items.Count - 1;
      end
      else cbSource2.ItemIndex:= i;
      rgSource.Items[1]:= 'Alleen ' + cbSource2.Items[cbSource2.ItemIndex];
    end
    else
      rgSource.Items[1]:= 'Alleen bron 2';

    rgSource.ItemIndex:= FRecipe.SpargeWaterComposition;

    cbTarget.Items.Add('');
    for i:= 0 to Waters.NumItems - 1 do
      cbTarget.Items.Add(Waters.Item[i].Name.Value);
    cbTarget.ItemIndex:= 0;

    bbTargetWater.Enabled:= (cbTarget.ItemIndex > 0);

    if FRecipe.Mash <> NIL then
      FSource1.Amount.Value:= FRecipe.Mash.MashWaterVolume
    else
      FSource1.Amount.Value:= FRecipe.BatchSize.DisplayValue;
    fseVolume1.Value:= FSource1.Amount.DisplayValue;

    fseVolume2.Value:= 0;
    if (FRecipe.Mash <> NIL) and (FRecipe.Water[1] <> NIL) then
    begin
      FSource2.Amount.Value:= FRecipe.Water[1].Amount.Value;
      FSource1.Amount.Value:= FRecipe.Mash.MashWaterVolume - FSource2.Amount.Value;
      fseVolume2.Value:= FSource2.Amount.DisplayValue;
      fseVolume1.Value:= FSource1.Amount.DisplayValue;
    end;

    if cbSource1.ItemIndex = -1 then cbSource2.ItemIndex:= -1;
    cbSource2.Enabled:= (not FRecipe.Locked.Value) and (cbSource1.ItemIndex > -1);

    fseVolume2.Enabled:= (FRecipe.Water[1] <> NIL);

    M:= FRecipe.FindMisc('CaCl2');
    if M <> NIL then fseCaCl2.Value:= M.Amount.DisplayValue;
    M:= FRecipe.FindMisc('CaSO4');
    if M <> NIL then fseCaSO4.Value:= M.Amount.DisplayValue;
    M:= FRecipe.FindMisc('MgSO4');
    if M <> NIL then fseMgSO4.Value:= M.Amount.DisplayValue;
    M:= FRecipe.FindMisc('NaCl');
    if M <> NIL then fseNaCl.Value:= M.Amount.DisplayValue;

    i:= 0; n:= -1;
    for at:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
    begin
      inc(n);
      M:= FRecipe.FindMisc(AcidTypeDisplayNames[at]);
      if M <> NIL then
      begin
        i:= n;
        fseAcid.Value:= M.Amount.DisplayValue;
        prc:= M.FreeField.Value;
        if prc < 1 then prc:= GetDefaultPerc(at);
      end;
      if at = FRecipe.AcidSpargeType then i:= n;

      M:= TMisc(Miscs.FindByName(AcidTypeDisplayNames[at]));
      if M = NIL then
      begin
        M:= Miscs.AddItem;
        M.Name.Value:= AcidTypeDisplayNames[at];
        M.AmountIsWeight.Value:= false;
        M.Amount.vUnit:= liter;
        M.Amount.DisplayUnit:= milliliter;
        //M.Amount.Value:= 0;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= AcidTypeDisplayNames[at] + ' wordt gebruikt voor het verlagen van de pH tijdens het maischen en het verlagen van de pH van het spoelwater.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        //M.Amount.DisplayValue:= fseAcid.Value;
        M.FreeField.Decimals:= 0;
        M.FreeField.MinValue:= 0;
        M.FreeField.MaxValue:= 100;
        M.FreeField.Value:= prc;
        M.FreeField.vUnit:= perc;
        M.FreeField.DisplayUnit:= perc;
        M.FreeField.Decimals:= 0;
        M.FreeFieldName.Value:= 'Concentratie';
        Miscs.SaveXML;
      end
      else if M.FreeField.Value <= 0.1 then
      begin
        prc:= GetDefaultPerc(at);
        M.FreeField.Value:= prc;
        M.FreeField.Decimals:= 0;
        M.FreeField.MinValue:= 0;
        M.FreeField.MaxValue:= 100;
        M.FreeField.vUnit:= perc;
        M.FreeField.DisplayUnit:= perc;
        M.FreeField.Decimals:= 0;
        M.FreeFieldName.Value:= 'Concentratie';
        Miscs.SaveXML;
      end;
    end;
    cbAcidMash.ItemIndex:= i;
    at:= FRecipe.AcidSpargeType;
    prc:= GetDefaultPerc(at);
    fseAcidPerc.Value:= prc;


    i:= 0; n:= -1;
    for bt:= Low(BaseTypeDisplayNames) to High(BaseTypeDisplayNames) do
    begin
      inc(n);
      M:= FRecipe.FindMisc(BaseTypeDisplayNames[bt]);
      if M <> NIL then
      begin
        i:= n;
        fseBase.Value:= M.Amount.DisplayValue;
      end;
      M:= TMisc(Miscs.FindByName(BaseTypeDisplayNames[bt]));
      if M = NIL then
      begin
        M:= Miscs.AddItem;
        M.Name.Value:= BaseTypeDisplayNames[bt];
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Voor het ontzuren van het beslag. Voegt calcium en (bi)carbonaat toe. Voor het verhogen van de pH tijdens het maischen.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
      end;
    end;
    cbBaseMash.ItemIndex:= i;


    i:= 0; n:= -1;
    for at:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
    begin
      inc(n);
      if at = FRecipe.AcidSpargeType then i:= n;
    end;

    cbAcid.ItemIndex:= i;
    wc:= FRecipe.AcidSpargePerc.Value;
    fseAcidPerc.Value:= wc;

//    cbSource1Change(self);
//    cbSource2Change(self);
//    cbTargetChange(self);
    fseTargetpH.Value:= FRecipe.TargetpH.Value;

    FUserClicked:= TRUE;
    CalcWater2;
    CalcSparge;

    Result:= (ShowModal = mrOK);
    if Result then
    begin
      //create the right waters (source, distilled etc) in FRecipe and add the right amount of salts and acids
      n:= -1;
      FRecipe.RemoveWaters;
      if (cbSource1.ItemIndex > -1) and (FSource1.Amount.Value > 0) then
      begin
        inc(n);
        W:= FRecipe.AddWater;
        W.Assign(FSource1);
      end;
      if (cbSource2.ItemIndex > -1) and (FSource2.Amount.Value > 0) then
      begin
        inc(n);
        W:= FRecipe.AddWater;
        W.Assign(FSource2);
      end;
      if n = -1 then
      begin
        W2:= Waters.GetDefaultWater;
        if W2 <> NIL then
        begin
          W:= FRecipe.AddWater;
          W.Assign(W2);
          W.Amount.Value:= FRecipe.Mash.MashWaterVolume;
        end;
      end;

      M:= FRecipe.FindMisc('CaCl2');
      if (fseCaCl2.Value = 0) and (M <> NIL) then FRecipe.RemoveMiscByReference(M)
      else if (fseCaCl2.Value > 0) and (M = NIL) then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= 'CaCl2';
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Voor het maken van een ander waterprofiel. Voegt calcium en chloride toe. Voor het verbeteren van zoetere bieren.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseCaCl2.Value;
      end
      else if (fseCaCl2.Value > 0) and (M <> NIL) then
      begin
        M.Amount.DisplayValue:= fseCaCl2.Value;
      end;

      M:= FRecipe.FindMisc('CaSO4');
      if (fseCaSO4.Value = 0) and (M <> NIL) then FRecipe.RemoveMiscByReference(M)
      else if (fseCaSO4.Value > 0) and (M = NIL) then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= 'CaSO4';
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Gips. Voor het maken van een ander waterprofiel. Voegt calcium en sulfaat toe. Voor het verbeteren van bittere bieren.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseCaSO4.Value;
      end
      else if (fseCaSO4.Value > 0) and (M <> NIL) then
      begin
        M.Amount.DisplayValue:= fseCaSO4.Value;
      end;

      M:= FRecipe.FindMisc('MgSO4');
      if (fseMgSO4.Value = 0) and (M <> NIL) then FRecipe.RemoveMiscByReference(M)
      else if (fseMgSO4.Value > 0) and (M = NIL) then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= 'MgSO4';
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Epsom zout. Voor het maken van een ander waterprofiel. Voegt magnesium en sulfaat toe. Gebruik spaarzaam!';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseMgSO4.Value;
      end
      else if (fseMgSO4.Value > 0) and (M <> NIL) then
      begin
        M.Amount.DisplayValue:= fseMgSO4.Value;
      end;

      M:= FRecipe.FindMisc('NaCl');
      if (fseNaCl.Value = 0) and (M <> NIL) then FRecipe.RemoveMiscByReference(M)
      else if (fseNaCl.Value > 0) and (M = NIL) then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= 'NaCl';
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Keukenzout. Voor het maken van een ander waterprofiel. Voegt natrium en chloride toe. Voor het accentueren van zoetheid. Bij hoge dosering wordt het bier ziltig.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseNaCl.Value;
      end
      else if (fseNaCl.Value > 0) and (M <> NIL) then
      begin
        M.Amount.DisplayValue:= fseNaCl.Value;
      end;

      at:= atLactic;
      for atc:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
      begin
        M:= FRecipe.FindMisc(AcidTypeDisplayNames[atc]);
        if M <> NIL then FRecipe.RemoveMiscByReference(M);
        if cbAcidMash.Items[cbAcidMash.ItemIndex] = AcidTypeDisplayNames[atc] then
          at:= atc;
      end;
      if fseAcid.Value > 0 then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= AcidTypeDisplayNames[at];
        M.AmountIsWeight.Value:= false;
        M.Amount.vUnit:= liter;
        M.Amount.DisplayUnit:= milliliter;
        M.Amount.Value:= 0;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= AcidTypeDisplayNames[at] + ' wordt gebruikt voor het verlagen van de pH tijdens het maischen en het verlagen van de pH van het spoelwater.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseAcid.Value;
        M.FreeField.Decimals:= 0;
        M.FreeField.MinValue:= 0;
        M.FreeField.MaxValue:= 100;
        M.FreeField.vUnit:= perc;
        M.FreeField.DisplayUnit:= perc;
        M.FreeField.Decimals:= 0;
        M.FreeField.Value:= fseMashAcidPerc.Value;
        M.FreeFieldName.Value:= 'Concentratie';
      end;

      M:= TMisc(Miscs.FindByName(AcidTypeDisplayNames[at]));
      if M = NIL then
      begin
        M:= Miscs.AddItem;
        M.Name.Value:= AcidTypeDisplayNames[at];
        M.AmountIsWeight.Value:= false;
        M.Amount.vUnit:= liter;
        M.Amount.DisplayUnit:= milliliter;
        //M.Amount.Value:= 0;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= AcidTypeDisplayNames[at] + ' wordt gebruikt voor het verlagen van de pH tijdens het maischen en het verlagen van de pH van het spoelwater.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        //M.Amount.DisplayValue:= fseAcid.Value;
        Miscs.SaveXML;
      end;
      M.FreeField.Decimals:= 0;
      M.FreeField.MinValue:= 0;
      M.FreeField.MaxValue:= 100;
      M.FreeField.Value:= fseMashAcidPerc.Value;
      M.FreeField.vUnit:= perc;
      M.FreeField.DisplayUnit:= perc;
      M.FreeField.Decimals:= 0;
      M.FreeFieldName.Value:= 'Concentratie';

      bt:= btNaHCO3;
      for btc:= Low(BaseTypeDisplayNames) to High(BaseTypeDisplayNames) do
      begin
        M:= FRecipe.FindMisc(BaseTypeDisplayNames[btc]);
        if M <> NIL then FRecipe.RemoveMiscByReference(M);
        if cbBaseMash.Items[cbBaseMash.ItemIndex] = BaseTypeDisplayNames[btc] then
          bt:= btc;
      end;
      M:= FRecipe.FindMisc(BaseTypeDisplayNames[bt]);
      if (fseBase.Value = 0) and (M <> NIL) then FRecipe.RemoveMiscByReference(M)
      else if (fseBase.Value > 0) and (M = NIL) then
      begin
        M:= FRecipe.AddMisc;
        M.Name.Value:= BaseTypeDisplayNames[bt];
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Voor het ontzuren van het beslag. Voegt calcium en (bi)carbonaat toe. Voor het verhogen van de pH tijdens het maischen.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
        M.Amount.DisplayValue:= fseBase.Value;
      end
      else if (fseBase.Value > 0) and (M <> NIL) then
      begin
        M.Amount.DisplayValue:= fseBase.Value;
      end;

      M:= TMisc(Miscs.FindByName(BaseTypeDisplayNames[bt]));
      if M = NIL then
      begin
        M:= Miscs.AddItem;
        M.Name.Value:= BaseTypeDisplayNames[bt];
        M.AmountIsWeight.Value:= TRUE;
        M.Amount.vUnit:= kilogram;
        M.Amount.DisplayUnit:= gram;
        M.Amount.MinValue:= 0;
        M.Amount.MaxValue:= 10000;
        M.Amount.Decimals:= 2;
        M.MiscType:= mtWaterAgent;
        M.Use:= muMash;
        M.UseFor.Value:= 'Voor het ontzuren van het beslag. Voegt calcium en (bi)carbonaat toe. Voor het verhogen van de pH tijdens het maischen.';
        M.Inventory.vUnit:= M.Amount.vUnit;
        M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
        M.Inventory.Value:= 0;
      end;

      FRecipe.VolumeHLT.DisplayValue:= fseSpargeVolume.Value;
      FRecipe.SpargeWaterComposition:= rgSource.ItemIndex;
      FRecipe.TargetpH.Value:= fseTargetpH.Value;
      FRecipe.CalcAcid.Value:= cbAutoAcid.Checked;
    end;
  end;
end;

Procedure TFrmWaterAdjustment.Dilute(perc : double);
var Wdemi : TWater;
    vol : double;
begin
  Wdemi:= Waters.GetDemiWater;
  if (Wdemi <> NIL) and (perc >= 0) and (perc <= 100) then
  begin
    FUserClicked:= false;
    FSource2.Assign(WDemi);
    vol:= FMashWater.Amount.Value;
    FSource1.Amount.Value:= (100 - perc) /  100 * vol;
    cbSource2.ItemIndex:= cbSource2.Items.IndexOf(FSource2.Name.Value);
    FSource2.Amount.Value:= perc / 100 * vol;
    fseVolume2.Value:= FSource2.Amount.Value;
    fseVolume1.Value:= fseVolume1.MaxValue - fseVolume2.Value;
    fseVolume2.Enabled:= (cbSource2.ItemIndex > -1);
    rgSource.Enabled:= fseVolume2.Enabled;
    if not rgSource.Enabled then rgSource.ItemIndex:= 0;
    FUserClicked:= TRUE;
    CalcWater2;
  end;
end;

Function TFrmWaterAdjustment.GetDefaultPerc(at : TAcidType) : double;
begin
  Result:= 80;
  case at of
  atLactic: Result:= 80;
  atHydrochloric: Result:= 23;
  atPhosphoric: Result:= 25;
  atSulfuric: Result:= 93;
  end;
end;

Procedure TFrmWaterAdjustment.ColorCell(Col, Row : integer);
begin
  SetLength(FColorCells, High(FColorCells) + 2);
  FColorCells[High(FColorCells)].Col:= Col;
  FColorCells[High(FColorCells)].Row:= Row;
end;

Procedure TFrmWaterAdjustment.DeColorCell(Col, Row : integer);
var i, j : integer;
begin
  for i:= Low(FColorCells) to High(FColorCells) do
  begin
    if (FColorCells[i].Col = Col) and (FColorCells[i].Row = Row) then
    begin
      for j:= i+1 to High(FColorCells) do
        FColorCells[j-1]:= FColorCells[j];
      SetLength(FColorCells, High(FColorCells));
    end;
  end;
end;

Procedure TFrmWaterAdjustment.SetTable(Row : integer; W : TWater);
var RA : double;
    i : integer;
begin
  if (Row >= 1) and (Row <= 4) then
  begin
    if W <> NIL then
    begin
      sgSource.Cells[0, Row]:= W.Name.Value;
      sgSource.Cells[1, Row]:= W.Calcium.DisplayString;
      sgSource.Cells[2, Row]:= W.Magnesium.DisplayString;
      sgSource.Cells[3, Row]:= W.Sodium.DisplayString;
      sgSource.Cells[4, Row]:= W.TotalAlkalinity.DisplayString;
      sgSource.Cells[5, Row]:= W.Sulfate.DisplayString;
      sgSource.Cells[6, Row]:= W.Chloride.DisplayString;
      if W.Sulfate.Value <> 0 then
        RA:= W.Chloride.Value / W.Sulfate.Value
      else RA:= 10;
      sgSource.Cells[8, Row]:= RealToStrDec(RA, 1);

      if (W.Calcium.Value < 40) or (W.Calcium.Value > 200) then ColorCell(1, Row)
      else DeColorCell(1, Row);
      if (W.Magnesium.Value > 40) then ColorCell(2, Row)
      else DeColorCell(2, Row);
      if (W.Sodium.Value > 100) then ColorCell(3, Row)
      else DeColorCell(3, Row);
      if (W.Sulfate.Value > 600) then ColorCell(5, Row)
      else DeColorCell(5, Row);
      if (W.Chloride.Value > 200) then ColorCell(6, Row)
      else DeColorCell(6, Row);
      if (RA < piClSO4.Low) or (RA > piClSO4.High) then ColorCell(8, Row);
    end
    else
      for i:= 0 to 8 do
      begin
        sgSource.Cells[i, row]:= '';
        DeColorCell(i, row);
      end;
  end;
end;

Procedure TFrmWaterAdjustment.MixWater(W1, W2, Wr : TWater);
  Function Mix(V1, V2, C1, C2 : double) : double;
  begin
    if (V1 + V2) > 0 then
      Result:= (V1 * C1 + V2 * C2) / (V1 + V2)
    else
      Result:= 0;
  end;

var vol1, vol2 : double;
    phnew : double;
begin
  vol1:= W1.Amount.Value;
  vol2:= W2.Amount.Value;
  if (vol1 + vol2) > 0 then
  begin
    Wr.Amount.Value:= vol1 + vol2;
    Wr.Calcium.Value:= Mix(vol1, vol2, W1.Calcium.Value, W2.Calcium.Value);
    Wr.Magnesium.Value:= Mix(vol1, vol2, W1.Magnesium.Value, W2.Magnesium.Value);
    Wr.Sodium.Value:= Mix(vol1, vol2, W1.Sodium.Value, W2.Sodium.Value);
    Wr.Bicarbonate.Value:= Mix(vol1, vol2, W1.Bicarbonate.Value, W2.Bicarbonate.Value);
    Wr.TotalAlkalinity.Value:= Mix(vol1, vol2, W1.TotalAlkalinity.Value, W2.TotalAlkalinity.Value);
    Wr.Sulfate.Value:= Mix(vol1, vol2, W1.Sulfate.Value, W2.Sulfate.Value);
    Wr.Chloride.Value:= Mix(vol1, vol2, W1.Chloride.Value, W2.Chloride.Value);
    pHnew:=  -log10((power(10, -W1.pHWater.Value) * vol1 + power(10, -W2.pHWater.Value) * vol2) / (vol1 + vol2));
    Wr.pHwater.Value:= pHnew;
  end;
end;

Procedure TFrmWaterAdjustment.CalcWater;
var x, RA, pHa : double;
    i : integer;
begin
  if (FSource1 <> NIL) and (FRecipe <> NIL) then
  begin
    FSource1.Amount.Value:= Convert(liter, FRecipe.Equipment.TunVolume.DisplayUnit,
                                    FRecipe.Mash.MashWaterVolume) - FSource2.Amount.Value;
    if cbSource2.ItemIndex > -1 then
      MixWater(FSource1, FSource2, FMashWater)
    else
    begin
      FSource2.Amount.Value:= 0;
      fSource1.Amount.Value:= Convert(liter, FRecipe.Equipment.TunVolume.DisplayUnit,
                                    FRecipe.Mash.MashWaterVolume);
      FMashWater.Assign(FSource1);
      FMashWater.Name.Value:= 'Na mengen';
      fseVolume2.Value:= 0;
      fseVolume1.Value:= fSource1.Amount.DisplayValue;
    end;
    SetLength(FColorCells, 0);
    SetTable(1, FSource1);
    RA:= FSource1.ResidualAlkalinity;
//    pHa:= FRecipe.pHdemi + RA * (0.013 * FRecipe.MashThickness + 0.013) / 2.81;
    pHa:= FRecipe.pHdemi + RA * (0.013 * FRecipe.MashThickness + 0.013) / 50;
    sgSource.Cells[7, 1]:= RealToStrDec(pHa, 1);
    if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 1);
    sgSource.Cells[8, 1]:= RealToStrDec(RA, 0) + ' mg/l';
    if (RA < FRecipe.RAmin) or (RA > FRecipe.RAmax) then ColorCell(8, 1);
    if FSource1.Sulfate.Value > 0 then RA:= FSource1.Chloride.Value / FSource1.Sulfate.Value
    else RA:= 10;
    if (RA < 0.8 * FRecipe.BUGU) or (RA > 1.2 * FRecipe.BUGU) then ColorCell(9, 1);
    sgSource.Cells[9, 1]:= RealToStrDec(RA, 1);

    if cbSource2.ItemIndex > -1 then
    begin
      SetTable(2, FMashWater);
      RA:= FMashWater.ResidualAlkalinity;
      pHa:= FRecipe.pHdemi + RA * (0.013 * FRecipe.MashThickness + 0.013) / 50;
      sgSource.Cells[7, 2]:= RealToStrDec(pHa, 1);
      if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 2);
      sgSource.Cells[8, 2]:= RealToStrDec(RA, 0) + ' mg/l';
      if (RA < FRecipe.RAmin) or (RA > FRecipe.RAmax) then ColorCell(8, 2);
      if FMashWater.Sulfate.Value > 0 then RA:= FMashWater.Chloride.Value / FMashWater.Sulfate.Value
      else RA:= 10;
      if (RA < 0.8 * FRecipe.BUGU) or (RA > 1.2 * FRecipe.BUGU) then ColorCell(9, 2);
      sgSource.Cells[8, 2]:= RealToStrDec(RA, 1);
    end
    else
    begin
      for i:= 0 to 9 do sgSource.Cells[i, 2]:= '';
    end;
//    FAdjustedWater
    FAdjustedWater.Assign(FMashWater);
    FAdjustedWater.Name.Value:= 'Aangepast';
    if FAdjustedWater.Amount.Value > 0 then
    begin
      //Ca
      RA:= fseCaCl2.Value * MMCa / MMCaCl2 + fseCaSO4.Value * MMCa / MMCaSO4;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Calcium.Value:= FMashWater.Calcium.Value + RA;
      if (FAdjustedWater.Calcium.Value < 40) or (FAdjustedWater.Calcium.Value > 200) then ColorCell(1, 3);
      //Mg
      RA:= fseMgSO4.Value * MMMg / MMMgSO4;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Magnesium.Value:= FMashWater.Magnesium.Value + RA;
      if (FAdjustedWater.Magnesium.Value > 40) then ColorCell(2, 3);
      //Na
      RA:= fseNaCl.Value * MMNa / MMNaCl + fseBase.Value * MMNa / MMNaHCO3;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
      if (FAdjustedWater.Sodium.Value > 100) then ColorCell(3, 3);
{      //HCO3
      RA:= fseCaCO3.Value * MMHCO3 / MMCaCO3 + fseBase.Value * MMHCO3 / MMNaHCO3;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;}
      //SO4
      RA:= fseCaSO4.Value * MMSO4 / MMCaSO4 + fseMgSO4.Value * MMSO4 / MMMgSO4;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      x:= FMashWater.Sulfate.Value;
      FAdjustedWater.Sulfate.Value:= x + RA;
      if (FAdjustedWater.Sulfate.Value > 600) then ColorCell(5, 3);
      //Cl
      RA:= 2 * fseCaCl2.Value * MMCl / MMCaCl2 + fseNaCl.Value * MMCl / MMNaCl;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Chloride.Value:= FMashWater.Chloride.Value + RA;
      if (FAdjustedWater.Chloride.Value > 200) then ColorCell(6, 3);

      sgSource.Cells[0, 3]:= FAdjustedWater.Name.Value;
      sgSource.Cells[1, 3]:= FAdjustedWater.Calcium.DisplayString;
      sgSource.Cells[2, 3]:= FAdjustedWater.Magnesium.DisplayString;
      sgSource.Cells[3, 3]:= FAdjustedWater.Sodium.DisplayString;
      sgSource.Cells[4, 3]:= FAdjustedWater.TotalAlkalinity.DisplayString;
      sgSource.Cells[5, 3]:= FAdjustedWater.Sulfate.DisplayString;
      sgSource.Cells[6, 3]:= FAdjustedWater.Chloride.DisplayString;

      RA:= 2/3 * 50 / FAdjustedWater.Amount.Value * fseAcid.Value * 11.8 * fseMashAcidPerc.Value / 88;
      RA:= FAdjustedWater.ResidualAlkalinity - RA;
      pHa:= FRecipe.pHdemi + RA * (0.013 * FRecipe.MashThickness + 0.013) / 50;
      sgSource.Cells[7, 3]:= RealToStrDec(pHa, 1);
      if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 3);

      if FAdjustedWater.Sulfate.Value > 0 then RA:= FAdjustedWater.Chloride.Value / FAdjustedWater.Sulfate.Value
      else RA:= 10;

      piClSO4.Low:= 0.8 * FRecipe.OptClSO4ratio;
      piClSO4.High:= 1.2 * FRecipe.OptClSO4ratio;
      if (RA < piClSO4.Low) or (RA > piClSO4.High) then ColorCell(9, 3);
      sgSource.Cells[9, 3]:= RealToStrDec(RA, 1);
      piClSO4.Value:= RA;

      CalcSparge;
    end;
  end;
end;

Procedure TFrmWaterAdjustment.GetAcidSpecs(AT : TAcidType;
                           var pK1, pK2, pK3, MolWt, AcidSG, AcidPrc : double);
begin
  Case AT of
  atLactic:
    begin
      pK1:= 3.08;
      pK2:= 20;
      pK3:= 20;
      MolWt:= 90.08;
      AcidSG:= 1214; //@88%
      AcidPrc:= 0.88;
    end;
  atHydrochloric:
    begin
      pK1:= -10;
      pK2:=  20;
      pK3:=  20;
      MolWt:= 36.46;
      AcidSG:= 1142; //@28%
      AcidPrc:= 0.28;
    end;
  atPhosphoric:
    begin
      pK1:= 2.12;
      pK2:= 7.20;
      pK3:=  12.44;
      MolWt:= 98.00;
      AcidSG:= 1170; //@25%
      AcidPrc:= 0.25;
    end;
  atSulfuric:
    begin
      pK1:= -10;
      pK2:= 1.92;
      pK3:= 20;
      MolWt:= 98.07;
      AcidSG:= 1700; //@93%
      AcidPrc:= 0.93;
    end;
  end;
end;

Function TFrmWaterAdjustment.GetFrac(pH, pK1, pK2, pK3 : double) : double;
var r1d, r2d, r3d, dd, {f1d,} f2d, f3d, f4d : double;
begin
  r1d:= Power(10, fseTargetpH.Value - pK1);
  r2d:= Power(10, fseTargetpH.Value - pK2);
  r3d:= Power(10, fseTargetpH.Value - pK3);
  dd:= 1/(1 + r1d + r1d*r2d + r1d*r2d*r3d);
  //f1d:= dd;
  f2d:= r1d*dd;
  f3d:= r1d*r2d*dd;
  f4d:= r1d*r2d*r3d*dd;
  Result:= f2d + 2*f3d + 3*f4d;
end;

Procedure TFrmWaterAdjustment.CalcWater2;
var x, RA, pHa, ProtonDeficit : double;
    acid, acidmg, base : double;
    r1d, r2d, f1d, f2d, f3d, frac, pK1, pK2, pK3, MolWt, AcidSG, AcidPrc : double;
    AT, ATc : TAcidType;
    bt, btc : TBaseType;
    n : integer;
    pd : double;
    deltapH, deltapd : double;
begin
  if (FSource1 <> NIL) and (FRecipe <> NIL) then
  begin
{    fseAcid.Value:= 0;
    fseBase.Value:= 0;}

    FSource1.Amount.Value:= Convert(liter, FRecipe.Equipment.TunVolume.DisplayUnit,
                                    FRecipe.Mash.MashWaterVolume) - FSource2.Amount.Value;

    if cbSource2.ItemIndex > -1 then
      MixWater(FSource1, FSource2, FMashWater)
    else
    begin
      FSource2.Amount.Value:= 0;
      fSource1.Amount.Value:= Convert(liter, FRecipe.Equipment.TunVolume.DisplayUnit,
                                    FRecipe.Mash.MashWaterVolume);
      FMashWater.Assign(FSource1);
      FMashWater.Name.Value:= 'Na mengen';
      fseVolume2.Value:= 0;
      fseVolume1.Value:= fSource1.Amount.DisplayValue;
    end;

    SetLength(FColorCells, 0);
    SetTable(1, FSource1);
    pHa:= FSource1.MashpH;
    sgSource.Cells[7, 1]:= RealToStrDec(pHa, 1);
    if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 1);

    if cbSource2.ItemIndex > -1 then
    begin
      SetTable(2, FMashWater);
      pHa:= FMashWater.MashpH;
      sgSource.Cells[7, 2]:= RealToStrDec(pHa, 1);
      if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 2);
    end
    else SetTable(2, NIL);

    //    FAdjustedWater
    FAdjustedWater.Assign(FMashWater);
    FAdjustedWater.Name.Value:= 'Aangepast';
    if FAdjustedWater.Amount.Value > 0 then
    begin
      //Ca
      RA:= fseCaCl2.Value * MMCa / MMCaCl2 + fseCaSO4.Value * MMCa / MMCaSO4;
      x:= FAdjustedWater.Amount.Value;
      RA:= 1000 * RA / x;
      FAdjustedWater.Calcium.Value:= FMashWater.Calcium.Value + RA;
      //Mg
      RA:= fseMgSO4.Value * MMMg / MMMgSO4;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Magnesium.Value:= FMashWater.Magnesium.Value + RA;
      //Na
      RA:= fseNaCl.Value * MMNa / MMNaCl;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
      //SO4
      RA:= fseCaSO4.Value * MMSO4 / MMCaSO4 + fseMgSO4.Value * MMSO4 / MMMgSO4;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      x:= FMashWater.Sulfate.Value;
      FAdjustedWater.Sulfate.Value:= x + RA;
      //Cl
      RA:= 2 * fseCaCl2.Value * MMCl / MMCaCl2 + fseNaCl.Value * MMCl / MMNaCl;
      RA:= 1000 * RA / FAdjustedWater.Amount.Value;
      FAdjustedWater.Chloride.Value:= FMashWater.Chloride.Value + RA;

      if cbAcid.ItemIndex < 0 then cbAcid.ItemIndex:= 0;
      for ATc:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
        if cbAcidMash.Items[cbAcidMash.ItemIndex] = AcidTypeDisplayNames[ATc] then
          AT:= ATc;

      for BTc:= Low(BaseTypeDisplayNames) to High(BaseTypeDisplayNames) do
        if cbBaseMash.Items[cbBaseMash.ItemIndex] = BaseTypeDisplayNames[BTc] then
          BT:= BTc;

      GetAcidSpecs(AT, pK1, pK2, pK3, MolWt, AcidSG, AcidPrc);

      if cbAutoAcid.Checked then
      begin
        FRecipe.TargetpH.Value:= fseTargetpH.Value;
        //Proton dificit of the mixed water with added salts
        //proton deficit of the water
        ProtonDeficit:= FAdjustedWater.ProtonDeficit(fseTargetpH.Value); //is already * volume
        if ProtonDeficit > 0 then //add acid
        begin
          fseBase.Value:= 0;
          frac:= GetFrac(fseTargetpH.Value, pK1, pK2, pK3);

        { Step 9. Now divide the mEq required by the "fraction". This is the required
          number of moles of acid.}
          Acid:= ProtonDeficit / frac;

          //Step 10. Multiply by molecular weight of the acid
          Acid:= Acid * MolWt; //mg
          Acidmg:= acid;

          {Step 10. Liquids are usually labeled according to the percentage of their weight
           which is the acid, for example, 88% lactic acid, 25% phosphoric acid and 28% hydrochloric
           acid are typical labelings. In order to calculate the volume of liquid which contains
           a given weight it is necessary to know the specific gravity of the liquid.
           In some cases this is specified on the label (for example 28% HCl is labeled
           18 Baume which converts to about 1.142 specific gravity or 1142 mg/mL).
           In other cases you will have to determine the specific gravity by the use of
           tables in the CRC handbook (sulfuric) or weigh a small known quantity of the
           acid. 88% lactic acid, for example, weighs about 1214 mg/mL (and thus has a
           density of about 1.214 mg/mL). 25% phosphoric acid weighs about 1170 mg/L
           (specific gravity 1.170). If unable to obtain a specific gravity value you
           can use 1000 mg/L. The three examples just given indicate that you would
           incur errors of 14 - 21% by doing that. This may seem like a lot of error but
           it really isn't especially if you are going to add measured acid gradually until
           the target pH is reached.}

          acid:= acid / AcidSG; //ml ;
          if fseMashAcidPerc.Value = 0 then fseMashAcidPerc.Value:= AcidPrc;
          acid:= acid * AcidPrc / (fseMashAcidPerc.Value / 100); //ml
          fseAcid.Value:= acid;

          RA:= FAdjustedWater.Bicarbonate.Value - ProtonDeficit * frac / FAdjustedWater.Amount.Value;
          FAdjustedWater.Bicarbonate.Value:= RA;
          FAdjustedWater.TotalAlkalinity.Value:= RA * 50 / 61;
        end
        else if ProtonDeficit < 0 then //add base
        begin
          fseAcid.Value:= 0;
          r1d:= Power(10, (fseTargetpH.Value - 6.38));
          r2d:= Power(10, (fseTargetpH.Value - 10.38));
          f1d:= 1 / (1 + r1d + r1d * r2d);
          f2d:= f1d * r1d;
          f3d:= f2d * r2d;
          case bt of
          btNaHCO3:
          begin
            base:= -ProtonDeficit / (f1d - f3d); //mmol totaal
            base:= base * MMNaHCO3/1000; //gram
            fseBase.Value:= base;
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Na
              RA:= fseNaCl.Value * MMNa / MMNaCl + fseBase.Value * MMNa / MMNaHCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
              //HCO3
              RA:= fseBase.Value * MMHCO3 / MMNaHCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          btNa2CO3:
          begin
            base:= -ProtonDeficit / (2 * f1d + f2d); //mmol totaal
            base:= base * MMNa2CO3/1000; //gram
            fseBase.Value:= base;
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Na
              RA:= fseNaCl.Value * MMNa / MMNaCl + fseBase.Value * 2 * MMNa / MMNa2CO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
              //HCO3
              RA:= fseBase.Value * MMHCO3 / MMNa2CO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          btCaCO3:
          begin
            base:= -ProtonDeficit * (f1d - f3d); //mmol totaal
            base:= base * MMCaCO3/1000; //gram
            //but only 1/3 is effective, so add 3 times as much
            base:= 3 * base;
            fseBase.Value:= base;
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Bicarbonate
              RA:= fseBase.Value / 3 * MMHCO3 / MMCaCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              //Ca precipitates out as Ca10(PO4)6(OH)2
              RA:= fseCaCl2.Value * MMCa / MMCaCl2 + fseCaSO4.Value * MMCa / MMCaSO4
                   + fseBase.Value * MMCa / MMCaCO3;
              x:= FAdjustedWater.Amount.Value;
              RA:= 1000 * RA / x;
              FAdjustedWater.Calcium.Value:= FMashWater.Calcium.Value + RA;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          btCaOH2:
          begin
            base:= -ProtonDeficit / 19.3; //g, see p. 133 of Water
            fseBase.Value:= base;
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Bicarbonate
              RA:= -ProtonDeficit / FAdjustedWater.Amount.Value;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.TotalAlkalinity.Value
                                  + RA;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA * 61 / 50;
              //Calcium
              RA:= fseCaCl2.Value * MMCa / MMCaCl2 + fseCaSO4.Value * MMCa / MMCaSO4
                   + fseBase.Value * MMCa / MMCaOH2;
              x:= FAdjustedWater.Amount.Value;
              RA:= 1000 * RA / x;
              FAdjustedWater.Calcium.Value:= FMashWater.Calcium.Value + RA;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          end;
        end;
        pHa:= fseTargetpH.Value;
        FAdjustedWater.pHwater.Value:= pHa;
      end
      else if FAdjustedWater.Amount.Value > 0 then //AutoAcid not checked
      begin
        frac:= 0;
        //first add the base salts
        if fseBase.Value > 0 then
        begin
          case bt of
          btNaHCO3:
          begin
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Na
              RA:= fseNaCl.Value * MMNa / MMNaCl + fseBase.Value * MMNa / MMNaHCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
              if (FAdjustedWater.Sodium.Value > 100) then ColorCell(3, 3);
              //HCO3
              RA:= fseBase.Value * MMHCO3 / MMNaHCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          btNa2CO3:
          begin
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Na
              RA:= fseNaCl.Value * MMNa / MMNaCl + fseBase.Value * 2 * MMNa / MMNa2CO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Sodium.Value:= FMashWater.Sodium.Value + RA;
              //HCO3
              RA:= fseBase.Value * MMHCO3 / MMNa2CO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              RA:= FAdjustedWater.ResidualAlkalinity;
            end;
          end;
          btCaCO3:
          begin
            if FAdjustedWater.Amount.Value > 0 then
            begin
              //Bicarbonate
              RA:= fseBase.Value / 3 * MMHCO3 / MMCaCO3;
              RA:= 1000 * RA / FAdjustedWater.Amount.Value;
              FAdjustedWater.Bicarbonate.Value:= FMashWater.Bicarbonate.Value + RA;
              FAdjustedWater.TotalAlkalinity.Value:= FAdjustedWater.Bicarbonate.Value * 50 / 61;
              RA:= FAdjustedWater.ResidualAlkalinity;
              //Ca precipitates out as Ca10(PO4)6(OH)2
              RA:= fseCaCl2.Value * MMCa / MMCaCl2 + fseCaSO4.Value * MMCa / MMCaSO4
                   + fseBase.Value * MMCa / MMCaCO3;
              x:= FAdjustedWater.Amount.Value;
              RA:= 1000 * RA / x;
              FAdjustedWater.Calcium.Value:= FMashWater.Calcium.Value + RA;
              if (FAdjustedWater.Calcium.Value < 40) or (FAdjustedWater.Calcium.Value > 200) then ColorCell(1, 3);
            end;
          end;
          end;
        end;

        pHa:= FAdjustedWater.MashpH;
        //then calculate the new pH with added acids
        if fseAcid.Value > 0 then
        begin
          acid:= fseAcid.Value;
          if fseMashAcidPerc.Value = 0 then fseMashAcidPerc.Value:= AcidPrc;
          acid:= acid / AcidPrc * (fseMashAcidPerc.Value / 100); //ml
          acid:= acid * AcidSG; //ml ;
          Acid:= Acid / MolWt; //mg
          Acidmg:= acid;

          //find the pH where the protondeficit = protondeficit by the acid
          frac:= GetFrac(pHa, pK1, pK2, pK3);
          ProtonDeficit:= Acid * frac;

          deltapH:= 0.001;
          deltapd:= 0.1;
          pd:= FAdjustedWater.ProtonDeficit(pHa);
          n:= 0;
          while ((pd < ProtonDeficit-deltapd) or (pd > ProtonDeficit + deltapd)) and (n < 1000) do
          begin
            inc(n);
            if pd < ProtonDeficit-deltapd then pHa:= pHa - deltapH
            else if pd > ProtonDeficit+deltapd then pHa:= pHa + deltapH;
            frac:= GetFrac(pHa, pK1, pK2, pK3);
            ProtonDeficit:= Acid * frac;
            pd:= FAdjustedWater.ProtonDeficit(pHa);
          end;
        end;
        RA:= FAdjustedWater.Bicarbonate.Value - ProtonDeficit * frac / FAdjustedWater.Amount.Value;
        FAdjustedWater.Bicarbonate.Value:= RA;
        FAdjustedWater.TotalAlkalinity.Value:= RA * 50 / 61;
        FRecipe.TargetpH.Value:= pHa;
        FAdjustedWater.pHwater.Value:= pHa;
      end;

      if at = atSulfuric then //add sulfate ions to AdjustedWater
      begin
        RA:= fseCaSO4.Value * MMSO4 / MMCaSO4 + fseMgSO4.Value * MMSO4 / MMMgSO4
             + Acidmg / 1000 * MMSO4 / (MMSO4 + 2);
        RA:= 1000 * RA / FAdjustedWater.Amount.Value;
        x:= FMashWater.Sulfate.Value;
        FAdjustedWater.Sulfate.Value:= x + RA;
      end
      else if at = atHydroChloric then //add chloride ions to AdjustedWater
      begin
        RA:= 2 * fseCaCl2.Value * MMCl / MMCaCl2 + fseNaCl.Value * MMCl / MMNaCl
             + Acidmg / 1000 * MMCl / (MMCL + 1);
        RA:= 1000 * RA / FAdjustedWater.Amount.Value;
        FAdjustedWater.Chloride.Value:= FMashWater.Chloride.Value + RA;
      end;

      pHa:= FAdjustedWater.pHWater.Value;
      sgSource.Cells[7, 3]:= RealToStrDec(pHa, 1);
      if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 3);
      pipH.Value:= pHa;

      SetTable(3, FAdjustedWater);

      if FAdjustedWater.Sulfate.Value > 0 then
        RA:= FAdjustedWater.Chloride.Value / FAdjustedWater.Sulfate.Value
      else RA:= 10;
      piClSO4.Low:= 0.8 * FRecipe.OptClSO4ratio;
      piClSO4.High:= 1.2 * FRecipe.OptClSO4ratio;
      if (RA < piClSO4.Low) or (RA > piClSO4.High) then ColorCell(8, 3);
      piClSO4.Value:= RA;

      FRecipe.MashWater.Assign(FAdjustedWater);
      CalcSparge;
    end;
  end;
end;

procedure TFrmWaterAdjustment.cbSource1Change(Sender: TObject);
var W : TWater;
begin
  W:= TWater(Waters.Item[cbSource1.ItemIndex]);
  if W <> NIL then
  begin
    FSource1.Assign(W);
    FSource1.Name.Value:= W.Name.Value;
    rgSource.Items[0]:= 'Alleen ' + W.Name.Value;
  end;
  CalcWater2;
  if cbSource1.ItemIndex = -1 then
    cbSource2.ItemIndex:= -1;
  cbSource2.Enabled:= (not FRecipe.Locked.Value) and (cbSource1.ItemIndex > -1);
end;

procedure TFrmWaterAdjustment.cbSource2Change(Sender: TObject);
var W : TWater;
begin
  if FUserClicked then
  begin
    W:= TWater(Waters.Item[cbSource2.ItemIndex]);
    if W <> NIL then
    begin
      FSource2.Assign(W);
      FSource2.Name.Value:= W.Name.Value;
     { FSource2.Amount.Value:= 0;
      fseVolume2.Value:= 0;
      rgSource.Items[1]:= 'Alleen ' + W.Name.Value;}
    end;
    fseVolume2.Enabled:= (cbSource2.ItemIndex > -1);
    rgSource.Enabled:= fseVolume2.Enabled;
    if not rgSource.Enabled then rgSource.ItemIndex:= 0;
    CalcWater2;
  end;
end;

procedure TFrmWaterAdjustment.fseVolume2Change(Sender: TObject);
begin
  if (FRecipe <> NIL) and FUserClicked then
  begin
    fseVolume1.Value:= fseVolume1.MaxValue - fseVolume2.Value;
    FSource1.Amount.DisplayValue:= fseVolume1.Value;
    FSource2.Amount.DisplayValue:= fseVolume2.Value;
    CalcWater2;
  end;
end;

procedure TFrmWaterAdjustment.cbTargetChange(Sender: TObject);
var W : TWater;
    pHa : double;
begin
  if cbTarget.ItemIndex < 1 then W:= NIL
  else W:= TWater(Waters.Item[cbTarget.ItemIndex-1]);
  if W <> NIL then
  begin
     FTargetWater.Assign(W);
     FTargetWater.Name.Value:= W.Name.Value; //'Doelwater';
     SetTable(4, FTargetWater);
     pHa:= FTargetWater.MashpH;
     sgSource.Cells[7, 4]:= RealToStrDec(pHa, 1);
     if (pHa > 5.6) or (pHa < 5.2) then ColorCell(7, 2)
     else DeColorCell(7, 2);
  end
  else SetTable(4, NIL);
  bbTargetWater.Enabled:= (W <> NIL);
end;

procedure TFrmWaterAdjustment.sgSourceDrawCell(Sender: TObject; aCol,
  aRow: Integer; aRect: TRect; aState: TGridDrawState);
var S: string;
    i : integer;
begin
  for i:= Low(FColorCells) to High(FColorCells) do
    if (ACol = FColorCells[i].Col) and (ARow = FColorCells[i].Row) then
    begin
      sgSource.Canvas.Brush.Color := FWarningColor;
      sgSource.Canvas.FillRect(aRect);
      S := sgSource.Cells[ACol, ARow];
      sgSource.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, S);
    end;
end;

procedure TFrmWaterAdjustment.fseCaCl2Change(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    fseBase.ReadOnly:= cbAutoAcid.Checked;
    fseAcid.ReadOnly:= cbAutoAcid.Checked;

    CalcWater2;
    FUserclicked:= TRUE;
  end;
end;

Procedure TFrmWaterAdjustment.CalcSparge;
var alkalinity, acid, TargetpH : double;
    r1, r2, d, f1, {f2,} f3 : double;
    r1g, r2g, dg, f1g, {f2g,} f3g : double;
    r143, r243, d43, f143, {f243,} f343 : double;
    fract, pK1, pK2, pK3, MolWt, AcidSG, AcidPrc : double;
    W : TWater;
    AT : TAcidType;
begin
  if FUserClicked then
  begin
    //Calculations from http://www.brewery.org/brewery/library/Acidi0,00fWaterAJD0497.html

    if rgSource.ItemIndex = 0 then W:= FSource1
    else if rgSource.ItemIndex = 1 then W:= FSource2
    else W:= FMashwater;
    TargetpH:= fseSpargepH.Value;

    //Step 1: Compute the mole fractions of carbonic (f1o), bicarbonate (f2o) and carbonate(f3o) at the water sample's pH
    acid:= W.pHWater.Value;
    r1:= power(10, acid - 6.38);
    r2:= power(10, acid - 10.33);
    d:= 1 + r1 + r1*r2;
    f1:= 1/d;
    //f2:= r1/d;
    f3:= r1 * r2 / d;

    //Step 2. Compute the mole fractions at pHb = 4.3 (the pH which defines alkalinity)
    r143:= power(10, 4.3 - 6.38);
    r243:= power(10, 4.3 - 10.33);
    d43:= 1 + r143 + r143*r243;
    f143:= 1/d43;
    //f243:= r143 / d43;
    f343:= r143 * r243 / d43;

    //Step 3. Convert the sample alkalinity to milliequivalents/L
    alkalinity:= W.TotalAlkalinity.Value / 50;

    //Step 4. Solve
    alkalinity:= alkalinity / ((f143-f1)+(f3-f343));

    //Step 5. Compute mole fractions at desired pH
    r1g:= power(10, TargetpH - 6.38);
    r2g:= power(10, TargetpH - 10.33);
    dg:= 1 + r1g + r1g*r2g;
    f1g:= 1/dg;
    //f2g:= r1g / dg;
    f3g:= r1g * r2g / dg;

    //Step 6. Use these to compute the milliequivalents acid required per liter (mEq/L)
    acid:= alkalinity * ((f1g-f1)+(f3-f3g)) + power(10, -TargetpH)
           - power(10, -W.pHwater.Value);  //mEq/l

    {Step 7. If the acid is labeled in terms of its normality (i.e. 1 N, 0.1N) recognize that
     a milliter contains the same number of mEq as the normality of the acid e.g. 1 N acid
     contains 1 mEq/mL, 0.1N contains 0.1 mEq/L. Of the acids typically used only hydrochloric
     and sulfuric are likely to be labeled in this way. Divide 'E' by the number of mEq/mL
     to get the number of mL of acid to add to each liter of the water. Thus if 8.75 N acid
     (approximate strength of hardware store hydrochloric acid) were being used with the
     example water 1.94/8.75 = 0.216 mL would be required for each liter being acidified.

    Step 8. If the acid is not labeled by its normality then you must compute the number
    of millimoles (mM) required to give the needed number of mEq and then convert that
    to a weight or volume. This is not necessary if the acid is labeled in terms of its
    molarity (e.g. 2 M, 0.1M) in which case each milliliter contains the same number
    of mM as the strength. One mL of 1M acid contains 1 mM. Start by computing the number
    of mEq of H+ obtained from 1 mM of the acid at the target pH. To do this you will
    need all the pK's of the acid being used. The following table gives values you can
    plug into the formulas which follow (you will neFRecipe.AcidSpargePerc.Value:= fseAcidPerc.Value;ed the molecular weights later):

    Code            Acid            pK1     pK2     pK3     Mol. Wt

                    Acetic          4.75    20     20        60.05
                    Citric          3.14    4.77    6.39    192.13
    taHydrochloric  Hydrochloric  -10.     20      20        36.46
    taLactic        Lactic          3.08   20      20        90.08
    taPhosphoric    Phosphoric      2.12    7.20   12.44     98.00
    taSulfuric      Sulfuric      -10.      1.92   20        98.07
                    Tartaric        2.98    4.34   20       150.09

    I hope the chemists will appreciate that I know that hydrochloric acid, for example,
    only has one hydogen ion to give and that the pK for this ion probably isn't -10.
    By using -10 for the pK I insure that the math will calculate 1 millimole of H+
    from each millimole of HCl whatever the (reasonable) target pH. Similarly the
    use of +20 for the second and third pKs will result in calculation of insignificant
    additional amounts of hydrogen ions from the second and third nonexistant dissociations.
    This artifice allows the same formulas to be used for any of the acids we are
    likely to encounter.
    The "fraction" (in quotes because it may be a number biggert than one) of moles
    of acid which release a hydrogen ion are found from the following formulas.}

    if cbAcid.ItemIndex < 0 then cbAcid.ItemIndex:= 0;
    FRecipe.AcidSpargeTypeDisplayName:= cbAcid.Items[cbAcid.ItemIndex];
    AT:= FRecipe.AcidSpargeType;
    GetAcidSpecs(AT, pK1, pK2, pK3, MolWt, AcidSG, AcidPrc);
    fract:= GetFrac(TargetpH, pK1, pK2, pK3);

  { Step 9. Now divide the mEq required by the "fraction". This is the required
    number of moles of acid.}
    Acid:= Acid / fract;

    //Step 10. Multiply by molecular weight of the acid
    Acid:= Acid * MolWt; //mg

    {Step 10. Liquids are usually labeled according to the percentage of their weight
     which is the acid, for example, 88% lactic acid, 25% phosphoric acid and 28% hydrochloric
     acid are typical labelings. In order to calculate the volume of liquid which contains
     a given weight it is necessary to know the specific gravity of the liquid.
     In some cases this is specified on the label (for example 28% HCl is labeled
     18 Baume which converts to about 1.142 specific gravity or 1142 mg/mL).
     In other cases you will have to determine the specific gravity by the use of
     tables in the CRC handbook (sulfuric) or weigh a small known quantity of the
     acid. 88% lactic acid, for example, weighs about 1214 mg/mL (and thus has a
     density of about 1.214 mg/mL). 25% phosphoric acid weighs about 1170 mg/L
     (specific gravity 1.170). If unable to obtain a specific gravity value you
     can use 1000 mg/L. The three examples just given indicate that you would
     incur errors of 14 - 21% by doing that. This may seem like a lot of error but
     it really isn't especially if you are going to add measured acid gradually until
     the target pH is reached.}

    acid:= acid / AcidSG; //ml ; 88% lactid solution
    f1:= fseAcidPerc.Value;
    if f1 <= 0.1 then f1:= AcidPrc;
    acid:= acid * AcidPrc / (f1 / 100);

    acid:= acid * fseSpargeVolume.Value; //ml lactic acid total
    eSpargeLacticAcid.Text:= RealToStrDec(acid, 1);
    FRecipe.AcidSparge.Value:= Convert(milliliter, FRecipe.AcidSparge.vUnit, acid);
    FRecipe.AcidSpargePerc.Value:= f1;
    FRecipe.AcidSpargeType:= AT;

  {  acid:= acid * 1.00 * 36.46; //mg acid/l water
    acid:= acid / (1140 * fseMashAcidPerc.Value / 100); //ml lactic acid / l water
    acid:= acid * fseSpargeVolume.Value; //ml lactic acid total
    eSpargeLacticAcid.Text:= RealToStrDec(acid, 1);
    FRecipe.LacticSparge.Value:= Convert(milliliter, FRecipe.LacticSparge.vUnit, acid);}
  end;
end;

procedure TFrmWaterAdjustment.fseAcidPercChange(Sender: TObject);
var M : TMisc;
    AT, ATc : TAcidType;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    {$warning This code makes no sense. AT gets a value but it is not used. }
    for ATc:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
      if cbAcid.Items[cbAcid.ItemIndex] = AcidTypeDisplayNames[ATc] then
        AT:= ATc;
    M:= TMisc(Miscs.FindByName(cbAcid.Items[cbAcid.ItemIndex]));
    if M <> NIL then
    begin
      M.FreeField.Value:= fseAcidPerc.Value;
      if M.FreeFieldName.Value = '' then M.FreeFieldName.Value:= 'Concentratie';
    end;

    FUserClicked:= TRUE;
    CalcSparge;
  end;
end;

procedure TFrmWaterAdjustment.fseSpargepHChange(Sender: TObject);
var M : TMisc;
    AT, ATc : TAcidType;
    prc : double;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    for ATc:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
      if cbAcid.Items[cbAcid.ItemIndex] = AcidTypeDisplayNames[ATc] then
        AT:= ATc;

    M:= TMisc(Miscs.FindByName(cbAcid.Items[cbAcid.ItemIndex]));
    if M <> NIL then
      prc:= M.FreeField.Value;
    if (M = NIL) or (fseMashAcidPerc.Value <= 1) then
    begin
      prc:= GetDefaultPerc(at);
      if M <> NIL then
      begin
        M.FreeField.Decimals:= 0;
        M.FreeField.MinValue:= 0;
        M.FreeField.MaxValue:= 100;
        M.FreeField.Value:= prc;
        M.FreeField.vUnit:= perc;
        M.FreeField.DisplayUnit:= perc;
        M.FreeField.Decimals:= 0;
        M.FreeFieldName.Value:= 'Concentratie';
      end;
    end;
    fseAcidPerc.Value:= prc;
    FUserClicked:= TRUE;
    CalcSparge;
  end;
end;

procedure TFrmWaterAdjustment.fseSpargeVolumeChange(Sender: TObject);
begin
  CalcSparge;
end;

procedure TFrmWaterAdjustment.fseTargetpHChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    CalcWater2;
    FRecipe.TargetpH.Value:= fseTargetpH.Value;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmWaterAdjustment.rgSourceClick(Sender: TObject);
begin
  if (not fseVolume2.Enabled) and (rgSource.ItemIndex > 0) then
    rgSource.ItemIndex:= 0;
  CalcSparge;
end;

Function CalcDilution(A1, A2, Ad, Vtarget : double) : double;
var x, V1, Vd : double; //= Vd / V1
begin
  if A1 < A2 then Result:= 0 //A1: conc ion source 1; A2: conc ion target, Ad: conc ion demiwater
  else if Ad < A2 then
  begin
    x:= (A1 / A2 - 1) / (1 - Ad / A2);
    V1:= Vtarget / (1 + x); //Volume source 1
    Vd:= Vtarget - V1;      //Volume demiwater
    Result:= 100 * Vd / (Vd + V1);
  end
  else
    Result:= 100;
end;

procedure TFrmWaterAdjustment.bbTargetWaterClick(Sender: TObject);
var Na1, Na2, Nad, Ca1, Ca2, Cad, Mg1, Mg2, Mgd : Double;
    Cl1, Cl2, Cld, SO41, SO42, SO4d, CO31, CO32, CO3d : Double;
    dNa, dCa, dMg, dCl, dSO4, dCO3, dmax : Double;
    NaCl, CaCl2 : Double;
    MgSO4, CaSO4 : Double;
    Vol : Double;
    Wdest : TWater;
begin
  Na1:= 0; Na2:= 0; Nad:= 0; Ca1:= 0; Ca2:= 0; Cad:= 0; Mg1:= 0; Mg2:= 0; Mgd:= 0;
  Cl1:= 0; Cl2:= 0; Cld:= 0; SO41:= 0; SO42:= 0; SO4d:= 0; CO31:= 0; CO32:= 0; CO3d:= 0;
  dNa:= 0; dCa:= 0; dMg:= 0; dCl:= 0; dSO4:= 0; dCO3:= 0;
  NaCl:= 0; CaCl2:= 0;
  MgSO4:= 0; CaSO4:= 0;
  Vol:= 0;
  Vol:= FMashWater.Amount.Value;
  //remove dilution water if present and set all additions to 0
  bbResetClick(sender);

  //First, find out if the source 1 water should be diluted with demiwater
  Wdest:= Waters.GetDemiWater;
  if Wdest <> NIL then
  begin
    Ca1:= FSource1.Calcium.Value;
    Ca2:= FTargetWater.Calcium.Value;
    Cad:= Wdest.Calcium.Value;
    Mg1:= FSource1.Magnesium.Value;
    Mg2:= FTargetWater.Magnesium.Value;
    Mgd:= Wdest.Magnesium.Value;
    Na1:= FSource1.Sodium.Value;
    Na2:= FTargetWater.Sodium.Value;
    Nad:= Wdest.Sodium.Value;

    CO31:= FSource1.Bicarbonate.Value;
    CO32:= FTargetWater.Bicarbonate.Value;
    CO3d:= Wdest.Bicarbonate.Value;
    SO41:= FSource1.Sulfate.Value;
    SO42:= FTargetWater.Sulfate.Value;
    SO4d:= Wdest.Sulfate.Value;
    Cl1:= FSource1.Chloride.Value;
    Cl2:= FTargetWater.Chloride.Value;
    Cld:= Wdest.Chloride.Value;

    dNa:= Na2 - Na1;
    dCa:= Ca2 - Ca1;
    dMg:= Mg2 - Mg1;
    dCl:= Cl2 - Cl1;
    dSO4:= SO42 - SO41;
    dCO3:= CO32 - CO31;

    dNa:= CalcDilution(Na1, Na2, Nad, Vol);
    dCa:= CalcDilution(Ca1, Ca2, Cad, Vol);
    dMg:= CalcDilution(Mg1, Mg2, Mgd, Vol);
    dCl:= CalcDilution(Cl1, Cl2, Cld, Vol);
    dSO4:= CalcDilution(SO41, SO42, SO4d, Vol);
    dCO3:= CalcDilution(CO31, CO32, CO3d, Vol);

    dmax:= MaxA([dNa, dCa, dMg, dCl, dSO4, dCO3]);
    Dilute(dmax);
  end;

  // Get concentration of ions in diluted brewwater (1) and target water (2) in mmol/l
  Ca1:= FMashWater.Calcium.Value / MMCa;
  Ca2:= FTargetWater.Calcium.Value / MMCa;
  Mg1:= FMashWater.Magnesium.Value / MMMg;
  Mg2:= FTargetWater.Magnesium.Value / MMMg;
  Na1:= FMashWater.Sodium.Value / MMNa;
  Na2:= FTargetWater.Sodium.Value / MMNa;

  CO31:= FMashWater.Bicarbonate.Value / MMHCO3;
  CO32:= FTargetWater.Bicarbonate.Value / MMHCO3;
  SO41:= FMashWater.Sulfate.Value / MMSO4;
  SO42:= FTargetWater.Sulfate.Value / MMSO4;
  Cl1:= FMashWater.Chloride.Value / MMCl;
  Cl2:= FTargetWater.Chloride.Value / MMCl;

  dNa:= MaxD(Na2 - Na1, 0);
  dCa:= MaxD(Ca2 - Ca1, 0);
  dMg:= MaxD(Mg2 - Mg1, 0);
  dCl:= MaxD(Cl2 - Cl1, 0);
  dSO4:= MaxD(SO42 - SO41, 0);
  dCO3:= MaxD(CO32 - CO31, 0);

  //ignore Mg, Na and HCO3 because they are non-essential for now
  //first add CaSO4 to get the SO4 level right.
  CaSO4:= dSO4;
  dCa:= dCa - CaSO4;
  dSO4:= 0;
  //if too much calcium is added, then add part of the SO4 as MgSO4
  if dCa < 0 then
  begin
    dCa:= dCa + CaSO4;
    CaSO4:= dCa;
    MgSO4:= dSO4 - dCa;
    dCa:= 0;
    dSO4:= 0;
  end;

  //Add Chloride. Add as CaCl2. If too much calcium is added, then add as NaCl
  CaCl2:= dCl / 2;
  dCa:= dCa - CaCl2;
  if dCa < 0 then
  begin
    dCa:= dCa + CaCl2;
    CaCl2:= dCa;
    NaCl:= dCl - 2 * dCa;
    dCa:= 0;
    dCl:= 0;
  end;

  //Ca, Cl and SO4 are now on the right level.

  //calculate addition in grams per salt
  NaCl:= NaCl * MMNaCl * Vol / 1000;
  CaCl2:= CaCl2 * MMCaCl2 * Vol / 1000;
  MgSO4:= MgSO4 * MMMgSO4 * Vol / 1000;
  CaSO4:= CaSO4 * MMCaSO4 * Vol / 1000;

  fseNaCl.Value:= NaCl;
  fseCaCl2.Value:= CaCl2;
  fseMgSO4.Value:= MgSO4;
  fseCaSO4.Value:= CaSO4;
  fseBase.Value:= 0;
  fseAcid.Value:= 0;

  //Set autocalulate acid or base addition to true and calculate
  cbAutoAcid.Checked:= TRUE;
end;

procedure TFrmWaterAdjustment.cbAcidMashChange(Sender: TObject);
var M : TMisc;
    AT, ATc : TAcidType;
    prc : double;
begin
  FUserClicked:= false;
  for ATc:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
    if cbAcidMash.Items[cbAcidMash.ItemIndex] = AcidTypeDisplayNames[ATc] then
      AT:= ATc;

  M:= TMisc(Miscs.FindByName(cbAcidMash.Items[cbAcidMash.ItemIndex]));
  if M <> NIL then
    prc:= M.FreeField.Value;
  if (M = NIL) or (prc <= 1) then
  begin
    prc:= GetDefaultPerc(at);
    if M <> NIL then
    begin
      M.FreeField.Decimals:= 0;
      M.FreeField.MinValue:= 0;
      M.FreeField.MaxValue:= 100;
      M.FreeField.Value:= prc;
      M.FreeField.vUnit:= perc;
      M.FreeField.DisplayUnit:= perc;
      M.FreeField.Decimals:= 0;
      M.FreeFieldName.Value:= 'Concentratie';
    end;
  end;
  fseMashAcidPerc.Value:= prc;
  FUserClicked:= TRUE;
  fseCaCl2Change(sender);
end;

procedure TFrmWaterAdjustment.cbBaseMashChange(Sender: TObject);
begin
  fseCaCl2Change(sender);
end;

procedure TFrmWaterAdjustment.bbpHClSO4Click(Sender: TObject);
var Cl1, Cl2, Cld, SO41, SO42, SO4d : Double;
    dCl, dSO4, dmax : Double;
    CaCl2, CaSO4 : Double;
    ClSO4opt : double;
    Vol : Double;
    Wdest : TWater;
begin
  Cl1:= 0; Cl2:= 0; Cld:= 0; SO41:= 0; SO42:= 0; SO4d:= 0;
  dCl:= 0; dSO4:= 0;
  CaCl2:= 0;
  CaSO4:= 0;
  Vol:= 0;
  Vol:= FMashWater.Amount.Value;
  //remove dilution water if present and set all additions to 0
  bbResetClick(sender);

  ClSO4opt:= FRecipe.OptClSO4ratio;
  SO41:= FSource1.Sulfate.Value;
  Cl1:= FSource1.Chloride.Value;

  if ClSO4opt >= 1 then //Sulfate should be set to a minimum value
  begin
    SO42:= 50;
    Cl2:= ClSO4opt * SO42;
    if Cl2 > 150 then //make sure the chloride concentration will not be too high
    begin
      Cl2:= 150;
      SO42:= Cl2 / ClSO4opt;
    end;
  end
  else //chloride should be set to a minimum value
  begin
    Cl2:= 50;
    SO42:= Cl2 / ClSO4opt;
    if SO42 > 600 then
    begin
      SO42:= 600;
      Cl2:= SO42 * ClSO4opt;
    end;
  end;

  //Then, find out if the source 1 water should be diluted with demiwater
  Wdest:= Waters.GetDemiWater;
  if Wdest <> NIL then
  begin
    SO4d:= Wdest.Sulfate.Value;
    Cld:= Wdest.Chloride.Value;

    dCl:= CalcDilution(Cl1, Cl2, Cld, Vol);
    dSO4:= CalcDilution(SO41, SO42, SO4d, Vol);

    dmax:= MaxA([dCl, dSO4]);
    Dilute(dmax);
  end;

  if ClSO4opt >= 1 then //Sulfate should be set to a minimum value
  begin
    SO42:= 50;
    Cl2:= ClSO4opt * SO42;
  end
  else //chloride should be set to a minimum value
  begin
    Cl2:= 50;
    SO42:= Cl2 / ClSO4opt;
  end;

  // Get concentration of ions in diluted brewwater (1) and target water (2) in mmol/l
  SO41:= FMashWater.Sulfate.Value / MMSO4;
  SO42:= MaxD(SO41, SO42) / MMSO4;
  Cl1:= FMashWater.Chloride.Value / MMCl;
  Cl2:= MaxD(Cl1, Cl2) / MMCl;

  dCl:= MaxD(Cl2 - Cl1, 0);
  dSO4:= MaxD(SO42 - SO41, 0);

  //Now, add chloride and sulfate
  CaSO4:= dSO4;
  CaCl2:= dCl / 2;

  //calculate addition in grams per salt
  CaCl2:= CaCl2 * MMCaCl2 * Vol / 1000;
  CaSO4:= CaSO4 * MMCaSO4 * Vol / 1000;

  fseCaCl2.Value:= CaCl2;
  fseCaSO4.Value:= CaSO4;
  fseBase.Value:= 0;
  fseAcid.Value:= 0;

  //Set autocalulate acid or base addition to true and calculate
  cbAutoAcid.Checked:= TRUE;
end;

Function TFrmWaterAdjustment.PartCO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * Ka1 * Ka2 / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function TFrmWaterAdjustment.PartHCO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * Ka1 * H / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function TFrmWaterAdjustment.PartH2CO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * H * H / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function TFrmWaterAdjustment.Charge(pH : double) : double;
begin
  Result:= (-2 * PartCO3(pH) - PartHCO3(pH));
end;

procedure TFrmWaterAdjustment.bbResetClick(Sender: TObject);
begin
  FUserClicked:= false;
  fseCaCl2.Value:= 0;
  fseCaSO4.Value:= 0;
  fseMgSO4.Value:= 0;
  fseBase.Value:= 0;
  fseNaCl.Value:= 0;
  fseAcid.Value:= 0;
  cbSource2.ItemIndex:= -1;
  FSource2.Amount.Value:= 0;
  fseVolume2.Value:= 0;
  fseVolume1.Value:= fseVolume1.MaxValue;
  FUserClicked:= TRUE;
  CalcWater2;
end;

end.

