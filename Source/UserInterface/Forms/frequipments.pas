unit FrEquipments;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus;

type

  { TFrmEquipments }

  TFrmEquipments = class(TForm)
    bbAdd: TBitBtn;
    bbCancel: TBitBtn;
    bbDelete: TBitBtn;
    bbOK: TBitBtn;
    cbTunMaterial: TComboBox;
    eName: TEdit;
    fseBatchSize: TFloatSpinEdit;
    fseBoilTime: TFloatSpinEdit;
    fseLauterHeight: TFloatSpinEdit;
    fseKettleHeight: TFloatSpinEdit;
    fseTunHeight: TFloatSpinEdit;
    fseTrubChillerLoss: TFloatSpinEdit;
    fseLautervolume: TFloatSpinEdit;
    fseKettleVolume: TFloatSpinEdit;
    fseBoilSize: TFloatSpinEdit;
    fseEvapRate: TFloatSpinEdit;
    fseHopUtilization: TFloatSpinEdit;
    fseLauterDeadspace: TFloatSpinEdit;
    fseTopUpKettle: TFloatSpinEdit;
    fseTunVolume: TFloatSpinEdit;
    fseMashVolume: TFloatSpinEdit;
    fseTunWeight: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbMash: TGroupBox;
    gbProperties: TGroupBox;
    gbBoil: TGroupBox;
    gbLauter: TGroupBox;
    gbChilling: TGroupBox;
    Label12: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    lBoilTime: TLabel;
    lBatchSize: TLabel;
    lLauterHeight: TLabel;
    lKettleHeight: TLabel;
    lTunHeight: TLabel;
    lMashVolume: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    lTrubChillerLoss: TLabel;
    lLauterVolume: TLabel;
    Label11: TLabel;
    Label13: TLabel;
    lHopUtilization: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lKettleVolume: TLabel;
    Label9: TLabel;
    lBoilSize: TLabel;
    lEvapRate: TLabel;
    lLauterDeadspace: TLabel;
    lTopUpKettle: TLabel;
    lTunVolume: TLabel;
    lTunWeight: TLabel;
    mNotes: TMemo;
    Panel1: TPanel;
    pEdit: TPanel;
    pSelect: TPanel;
    tvSelect: TTreeView;
    Label16: TLabel;
    fseEfficiency: TFloatSpinEdit;
    lEfficiency: TLabel;
    pmIngredients: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    Label18: TLabel;
    eEvapRate: TEdit;
    procedure bbAddClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseBatchSizeChange(Sender: TObject);
    procedure fseMashVolumeChange(Sender: TObject);
    procedure fseTunVolumeChange(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure fseBoilSizeChange(Sender: TObject);
    procedure fseEvapRateChange(Sender: TObject);
  private
    { private declarations }
    FSelectedNode : TTreeNode;
    FNew : boolean;
    FUserClicked : boolean;
    Procedure Store;
  public
    { public declarations }
  end; 

var
  FrmEquipments: TFrmEquipments;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers;

{ TFrmEquipments }

procedure TFrmEquipments.FormCreate(Sender: TObject);
var i : integer;
    mname : string;
    E : TEquipment;
    Node, ChildNode: TTreeNode;
begin
  FUserClicked:= TRUE;
  Equipments.UnSelect;

  cbTunMaterial.Items.Clear;
  for i:= 0 to High(SpecificHeats) do
    cbTunMaterial.Items.Add(SpecificHeats[i].Material);
  cbTunMaterial.ItemIndex:= 0;

  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'');
  for i:= 0 to Equipments.NumItems - 1 do
  begin
    E:= TEquipment(Equipments.Item[i]);
    mname:= E.Name.Value;
    ChildNode:= tvSelect.Items.AddChildObject(Node, mname, E);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Equipments.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  FNew:= false;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  tvSelectSelectionChanged(self);
end;

procedure TFrmEquipments.fseMashVolumeChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    if fseTunVolume.Value < fseMashVolume.Value then
      fseTunVolume.Value:= fseMashVolume.Value;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmEquipments.fseTunVolumeChange(Sender: TObject);
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    if fseTunVolume.Value < fseMashVolume.Value then
      fseMashVolume.Value:= fseTunVolume.Value;
    FUserClicked:= TRUE;
  end;
end;

Procedure TFrmEquipments.Store;
var E : TEquipment;
begin
  E:= NIL;
  if FSelectedNode <> NIL then E:= TEquipment(FSelectedNode.Data);
  if E <> NIL then
  begin
    E.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    E.Notes.Value:= mNotes.Text;

    E.TunVolume.DisplayValue:= fseTunVolume.Value;
    E.TunWeight.DisplayValue:= fseTunWeight.Value;
    if cbTunMaterial.ItemIndex > -1 then
    begin
      E.TunMaterial.Value:= cbTunMaterial.Items[cbTunMaterial.ItemIndex];
      E.TunSpecificHeat.Value:= SpecificHeats[cbTunMaterial.ItemIndex].SpecificHeat;
    end;
    E.TunHeight.DisplayValue:= fseTunHeight.Value;
    E.LauterDeadspace.DisplayValue:= fseLauterDeadspace.Value;
    E.LauterVolume.DisplayValue:= fseLauterVolume.Value;
    E.LauterHeight.DisplayValue:= fseLauterHeight.Value;
    E.EvapRate.DisplayValue:= fseEvapRate.Value;
    E.TopUpKettle.DisplayValue:= fseTopUpKettle.Value;
    E.BoilSize.DisplayValue:= fseBoilSize.Value;
    E.BoilTime.DisplayValue:= fseBoilTime.Value;
    E.KettleVolume.DisplayValue:= fseKettleVolume.Value;
    E.KettleHeight.DisplayValue:= fseKettleHeight.Value;
    E.HopUtilization.Value:= fseHopUtilization.Value;
    E.TrubChillerLoss.DisplayValue:= fseTrubChillerLoss.Value;
    E.BatchSize.DisplayValue:= fseBatchSize.Value;
    E.MashVolume.DisplayValue:= fseMashVolume.Value;
    E.Efficiency.DisplayValue:= fseEfficiency.Value;

    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmEquipments.tvSelectSelectionChanged(Sender: TObject);
var E : TEquipment;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    if (FSelectedNode <> NIL) and (not FNew) then
      Store;

    FNew:= false;
    E:= NIL;

    bbDelete.Enabled:= (tvSelect.Selected.Level = 1);
  //  bbCopy.Enabled:= bbDelete.Enabled;
    miDelete.Enabled:= bbDelete.Enabled;
  //  miCopy.Enabled:= bbDelete.Enabled;

    if tvSelect.Selected <> NIL then
    begin
      if tvSelect.Selected.Level = 1 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then E:= TEquipment(Node.Data)
      else E:= NIL;

    end;
    bbDelete.Enabled:= (Node <> NIL);
    miDelete.Enabled:= (Node <> NIL);
    pEdit.Visible:= (Node <> NIL);

    if E <> NIL then
    begin
      SetControl(fseTunVolume, lTunVolume, E.TunVolume, TRUE);
      SetControl(fseTunWeight, lTunWeight, E.TunWeight, TRUE);
      SetControl(fseLauterDeadspace, lLauterDeadspace, E.LauterDeadspace, TRUE);
      SetControl(fseTunHeight, lTunHeight, E.TunHeight, TRUE);
      SetControl(fseMashVolume, lMashVolume, E.MashVolume, TRUE);
      SetControl(fseKettleHeight, lKettleHeight, E.KettleHeight, TRUE);
      SetControl(fseLauterVolume, lLauterVolume, E.LauterVolume, TRUE);
      SetControl(fseLauterHeight, lLauterHeight, E.LauterHeight, TRUE);
      SetControl(fseEvapRate, lEvapRate, E.EvapRate, TRUE);
      SetControl(fseTopUpKettle, lTopUpKettle, E.TopUpKettle, TRUE);
      SetControl(fseBoilSize, lBoilSize, E.BoilSize, TRUE);
      SetControl(fseBoilTime, lBoilTime, E.BoilTime, TRUE);
      SetControl(fseHopUtilization, lHopUtilization, E.HopUtilization, TRUE);
      SetControl(fseKettleVolume, lKettleVolume, E.KettleVolume, TRUE);
      SetControl(fseTrubChillerLoss, lTrubChillerLoss, E.TrubChillerLoss, TRUE);
      SetControl(fseBatchSize, lBatchSize, E.BatchSize, TRUE);
      SetControl(fseEfficiency, lEfficiency, E.Efficiency, TRUE);

      eName.Text:= E.Name.Value;
      mNotes.Text:= E.Notes.Value;
      cbTunMaterial.ItemIndex:= cbTunMaterial.Items.IndexOf(E.TunMaterial.Value);
      fseBoilSizeChange(Self);
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

procedure TFrmEquipments.fseBoilSizeChange(Sender: TObject);
var er : double;
    s : string;
    E : TEquipment;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    E:= NIL;
    if tvSelect.Selected <> NIL then
    begin
      Node:= NIL;
      if tvSelect.Selected.Level = 0 then
        Node:= tvSelect.Selected.GetFirstChild
      else
        Node:= tvSelect.Selected;
      if Node <> NIL then
        E:= TEquipment(Node.Data);
    end;
    if E <> NIL then
    begin
      er:= fseEvapRate.Value / 100 * fseBoilSize.Value;
      er:= convert(E.BoilSize.vUnit, E.BoilSize.DisplayUnit, er);
      s:= RealToStrDec(er, 1) + ' ' + E.BoilSize.DisplayUnitString + '/uur';
      eEvapRate.Text:= s;
      er:= fseEvapRate.Value / 100 * fseBoilSize.Value * fseBoilTime.Value / 60;
      fseBatchSize.Value:= fseBoilSize.Value - er;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmEquipments.fseEvapRateChange(Sender: TObject);
begin
  fseBoilSizeChange(sender);
end;

procedure TFrmEquipments.fseBatchSizeChange(Sender: TObject);
var er : double;
    s : string;
    E : TEquipment;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    E:= NIL;
    if tvSelect.Selected <> NIL then
    begin
      Node:= NIL;
      if tvSelect.Selected.Level = 0 then
        Node:= tvSelect.Selected.GetFirstChild
      else
        Node:= tvSelect.Selected;
      if Node <> NIL then
        E:= TEquipment(Node.Data);
    end;
    if E <> NIL then
    begin
      if (fseBoilTime.Value > 0) and (fseBoilSize.Value > 0) then
      begin
        er:= (fseBoilSize.Value - fseBatchSize.Value) / (fseBoilTime.Value / 60);
        fseEvapRate.Value:= 100 * er / fseBoilSize.Value;
        er:= convert(E.BoilSize.vUnit, E.BoilSize.DisplayUnit, er);
        s:= RealToStrDec(er, 1) + ' ' + E.BoilSize.DisplayUnitString + '/uur';
        eEvapRate.Text:= s;
      end;
    end;
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmEquipments.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmEquipments.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    E : TEquipment;
begin
  //if a fermentable ingredient is selected, then add one for that supplier
  E:= Equipments.AddItem;
  Equipments.Selected:= Equipments.NumItems - 1;
  eName.Text:= 'Nieuwe brouwinstallatie';
  E.Name.Value:= eName.Text;
  mNotes.Text:= '';

  E.TunVolume.Value:= 20;
  E.TunWeight.Value:= 2;
  E.TunMaterial.Value:= 'Aluminium';
  E.TunHeight.Value:= 0.2;
  E.LauterDeadspace.Value:= 0.5;
  E.LauterVolume.Value:= 20;
  E.LauterHeight.Value:= 0.2;
  E.EvapRate.Value:= 8;
  E.TopUpKettle.Value:= 0;
  E.BoilSize.Value:= 18;
  E.BoilTime.Value:= 90;
  E.KettleVolume.Value:= 20;
  E.KettleHeight.Value:= 0.2;
  E.HopUtilization.Value:= 100;
  E.TrubChillerLoss.Value:= 0.5;
  E.BatchSize.Value:= 15;
  E.MashVolume.Value:= 18;
  E.Efficiency.Value:= 75;

  SetControl(fseTunVolume, lTunVolume, E.TunVolume, TRUE);
  SetControl(fseTunWeight, lTunWeight, E.TunWeight, TRUE);
  SetControl(fseLauterDeadspace, lLauterDeadspace, E.LauterDeadspace, TRUE);
  SetControl(fseTunHeight, lTunHeight, E.TunHeight, TRUE);
  SetControl(fseMashVolume, lMashVolume, E.MashVolume, TRUE);
  SetControl(fseKettleHeight, lKettleHeight, E.KettleHeight, TRUE);
  SetControl(fseLauterVolume, lLauterVolume, E.LauterVolume, TRUE);
  SetControl(fseLauterHeight, lLauterHeight, E.LauterHeight, TRUE);
  SetControl(fseEvapRate, lEvapRate, E.EvapRate, TRUE);
  SetControl(fseTopUpKettle, lTopUpKettle, E.TopUpKettle, TRUE);
  SetControl(fseBoilSize, lBoilSize, E.BoilSize, TRUE);
  SetControl(fseBoilTime, lBoilTime, E.BoilTime, TRUE);
  SetControl(fseHopUtilization, lHopUtilization, E.HopUtilization, TRUE);
  SetControl(fseKettleVolume, lKettleVolume, E.KettleVolume, TRUE);
  SetControl(fseTrubChillerLoss, lTrubChillerLoss, E.TrubChillerLoss, TRUE);
  SetControl(fseBatchSize, lBatchSize, E.BatchSize, TRUE);
  SetControl(fseEfficiency, lEfficiency, E.Efficiency, TRUE);

  eName.Text:= E.Name.Value;
  mNotes.Text:= E.Notes.Value;
  cbTunMaterial.ItemIndex:= cbTunMaterial.Items.IndexOf(E.TunMaterial.Value);

  if (tvSelect.Selected <> NIL) and (tvSelect.Selected.Level = 1) then
    Node:= tvSelect.Selected.Parent
  else
    Node:= tvSelect.Items[0];
  ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Equipments.SelectedItem);
  FNew:= TRUE;
  ChildNode.Selected:= TRUE;
  ActiveControl:= eName;
end;

procedure TFrmEquipments.bbDeleteClick(Sender: TObject);
var E : TEquipment;
    Node : TTreeNode;
begin
  FUserclicked:= false;
  Node:= tvSelect.Selected;
  if (Node <> NIL) then
  begin
    E:= TEquipment(Node.Data);
    if Question(FrmEquipments, 'Wil je '+ E.Name.Value + ' echt verwijderen?') then
    begin
      Equipments.RemoveByReference(E);
      tvSelect.Items.Delete(Node);
      FSelectedNode:= NIL;
    end;
  end;
  FUserClicked:= TRUE;
end;

procedure TFrmEquipments.bbOKClick(Sender: TObject);
begin
  Store;
  Equipments.UnSelect;
end;

procedure TFrmEquipments.bbCancelClick(Sender: TObject);
begin
end;

end.

