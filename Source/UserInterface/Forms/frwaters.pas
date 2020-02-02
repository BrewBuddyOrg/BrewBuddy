unit FrWaters;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus, Amoebes;

type

  { TFrmWaters }

  TFrmWaters = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbDefault: TCheckBox;
    eHardness: TEdit;
    eRA: TEdit;
    eName: TEdit;
    fseBicarbonate2: TFloatSpinEdit;
    fseAlkalinity: TFloatSpinEdit;
    fseCalcium: TFloatSpinEdit;
    fseChloride: TFloatSpinEdit;
    fseIonenbalans: TFloatSpinEdit;
    fseMagnesium: TFloatSpinEdit;
    fsepH: TFloatSpinEdit;
    fseSodium: TFloatSpinEdit;
    fseSulfate: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lCa: TLabel;
    lCl: TLabel;
    lHCO3: TLabel;
    lHCO4: TLabel;
    lMg: TLabel;
    lNa: TLabel;
    lSO4: TLabel;
    mNotes: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    tsAmoebe: TTabSheet;
    tsProperties: TTabSheet;
    tvSelect: TTreeView;
    bbImport: TBitBtn;
    bbCopy: TBitBtn;
    pmIngredients: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    MenuItem1: TMenuItem;
    miImport: TMenuItem;
    miCopy: TMenuItem;
    FAmoebe : TAmoebe;
    procedure bbAddClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure cbDefaultChange(Sender: TObject);
    procedure eNameChange(Sender: TObject);
    procedure fseBicarbonate2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseCalciumChange(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure bbCopyClick(Sender: TObject);
  private
    FSelectedNode : TTreeNode;
    FNew : boolean;
    FUserClicked : boolean;
    Procedure Store;
    Procedure FillTree;
    Procedure UpdateAmoebe;
  public

  end; 

var
  FrmWaters: TFrmWaters;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers;

{ TFrmWaters }

procedure TFrmWaters.FormCreate(Sender: TObject);
var i : longint;
    W : TWater;
    Cam, Mgm, Nam, Clm, SO4m, HCO3m, Hardnm: double;
begin
  Cam:= 0; Mgm:= 0; Nam:= 0; Clm:= 0; SO4m:= 0; HCO3m:= 0; Hardnm:= 0;
  for i:= 0 to Waters.NumItems - 1 do
  begin
    W:= TWater(Waters.Item[i]);
    if W <> NIL then
    begin
      if W.Calcium.DisplayValue > Cam then Cam:= W.Calcium.DisplayValue;
      if W.Magnesium.DisplayValue > Mgm then Mgm:= W.Magnesium.DisplayValue;
      if W.Sodium.DisplayValue > Nam then Nam:= W.Sodium.DisplayValue;
      if W.Chloride.DisplayValue > Clm then Clm:= W.Chloride.DisplayValue;
      if W.Sulfate.DisplayValue > SO4m then SO4m:= W.Sulfate.DisplayValue;
      if W.Bicarbonate.DisplayValue > HCO3m then HCO3m:= W.Bicarbonate.DisplayValue;
      if W.TotalAlkalinity.DisplayValue > Hardnm then Hardnm:= W.TotalAlkalinity.DisplayValue;
    end;
  end;
  FAmoebe:= TAmoebe.Create(tsAmoebe);
  FAmoebe.Parent:= tsAmoebe;
  FAmoebe.Align:= alClient;
  FAmoebe.Kind:= akClassic;
  FAmoebe.NormColor:= RGBtocolor(255, 255, 180);
  FAmoebe.AmoebeColor:= RGBtocolor(88, 243, 175);
  FAmoebe.AddSerie('Ca', W.Calcium.DisplayUnitString, 0, cam, 5, Cam);
  FAmoebe.AddSerie('Mg', W.Magnesium.DisplayUnitString, 0, Mgm, 3, Mgm);
  FAmoebe.AddSerie('Na', W.Sodium.DisplayUnitString, 0, Nam, 1, Nam);
  FAmoebe.AddSerie('Cl', W.Chloride.DisplayUnitString, 0, Clm, 1, Clm);
  FAmoebe.AddSerie('SO4', W.Sulfate.DisplayUnitString, 0, SO4m, 1, SO4m);
  FAmoebe.AddSerie('Alkaliteit', W.TotalAlkalinity.DisplayUnitString, 0, Hardnm, 250, Hardnm);

  FUserClicked:= TRUE;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  Waters.UnSelect;
  FillTree;
  FNew:= false;
end;

Procedure TFrmWaters.FillTree;
var i : integer;
    mname : string;
    W : TWater;
    Node, {%H-}ChildNode: TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'');
  for i:= 0 to Waters.NumItems - 1 do
  begin
    W:= TWater(Waters.Item[i]);
    mname:= W.Name.Value;
    ChildNode:= tvSelect.Items.AddChildObject(Node, mname, W);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Waters.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  tvSelectSelectionChanged(self);
end;

procedure TFrmWaters.fseCalciumChange(Sender: TObject);
var HCO3, RA : double;
begin
  HCO3:= fseAlkalinity.Value * 61 / 50;
  fseIonenBalans.Value:= IonBalance(fseCalcium.Value, fseMagnesium.Value, fseSodium.Value,
                                    fseChloride.Value, fseSulfate.Value, HCO3);
  RA:= fseAlkalinity.Value - (fseCalcium.Value / 1.4 + fseMagnesium.Value / 1.7);
  eRA.Caption:= RealToStrDec(RA, 0);
  UpdateAmoebe;
end;

procedure TFrmWaters.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

Procedure TFrmWaters.Store;
var W, W2 : TWater;
    i : integer;
begin
  W:= NIL;
  if FSelectedNode <> NIL then W:= TWater(FSelectedNode.Data);
  if W <> NIL then
  begin
    W.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    W.Notes.Value:= mNotes.Text;

    W.Calcium.DisplayValue:= fseCalcium.Value;
    W.Magnesium.DisplayValue:= fseMagnesium.Value;
    W.Sodium.DisplayValue:= fseSodium.Value;
    W.TotalAlkalinity.DisplayValue:= fseAlkalinity.Value;
    W.Bicarbonate.Value:= W.TotalAlkalinity.Value * 61 / 50;
    W.Sulfate.DisplayValue:= fseSulfate.Value;
    W.Chloride.DisplayValue:= fseChloride.Value;
    W.pHwater.DisplayValue:= fsepH.Value;
    W.DefaultWater.Value:= cbDefault.Checked;
    if cbDefault.Checked then
    begin
      for i:= 0 to Waters.NumItems - 1 do
      begin
        W2:= TWater(Waters.Item[i]);
        if W <> W2 then if W2.DefaultWater.Value then W2.DefaultWater.Value:= false;
      end;
    end;

    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmWaters.tvSelectSelectionChanged(Sender: TObject);
var W : TWater;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    FUserClicked:= false;
    if (FSelectedNode <> NIL) and (not FNew) then
      Store;
    FNew:= false;

    W:= NIL;
    Node:= NIL;

    if tvSelect.Selected <> NIL then
    begin
      bbDelete.Enabled:= (tvSelect.Selected.Level = 1);

      if tvSelect.Selected.Level = 1 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        W:= TWater(Node.Data);
    end
    else
      bbDelete.Enabled:= false;
    bbCopy.Enabled:= bbDelete.Enabled;
    miDelete.Enabled:= bbDelete.Enabled;
    miCopy.Enabled:= bbDelete.Enabled;
    pEdit.Visible:= (Node <> NIL);

    if W <> NIL then
    begin
      eName.Text:= W.Name.Value;
      mNotes.Text:= W.Notes.Value;
      SetControl(fseCalcium, lCa, W.Calcium, TRUE);
      SetControl(fseMagnesium, lMg, W.Magnesium, TRUE);
      SetControl(fseSodium, lNa, W.Sodium, TRUE);
      SetControl(fseAlkalinity, lHCO3, W.TotalAlkalinity, TRUE);
      SetControl(fseSulfate, lSO4, W.Sulfate, TRUE);
      SetControl(fseChloride, lCl, W.Chloride, TRUE);
      SetFloatSpinEdit(fsepH, W.pHWater, TRUE);
      cbDefault.Checked:= W.DefaultWater.Value;
      UpdateAmoebe;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
  FUserClicked:= TRUE;
end;

Procedure TFrmWaters.UpdateAmoebe;
var W : TWater;
    Node : TTreeNode;
begin
  W:= NIL;
  Node:= NIL;

  if tvSelect.Selected <> NIL then
  begin
    if tvSelect.Selected.Level = 1 then Node:= tvSelect.Selected
    else Node:= NIL;
    if Node <> NIL then
      W:= TWater(Node.Data);
  end;

  if W <> NIL then
  begin
    FAmoebe.Score[1]:= W.Calcium.DisplayValue;
    FAmoebe.Score[2]:= W.Magnesium.DisplayValue;
    FAmoebe.Score[3]:= W.Sodium.DisplayValue;
    FAmoebe.Score[4]:= W.Chloride.DisplayValue;
    FAmoebe.Score[5]:= W.Sulfate.DisplayValue;
    FAmoebe.Score[6]:= W.TotalAlkalinity.DisplayValue;
  end;
end;


procedure TFrmWaters.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
begin
  //if a fermentable ingredient is selected, then add one for that supplier
  Waters.AddItem;
  Waters.Selected:= Waters.NumItems - 1;

  Node:= tvSelect.Selected.Parent;
  ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Waters.SelectedItem);
  FNew:= TRUE;
  ChildNode.Selected:= TRUE;

  eName.Text:= 'Nieuw waterprofiel';
  mNotes.Text:= '';
  fseCalcium.Value:= 0;
  fseMagnesium.Value:= 0;
  fseSodium.Value:= 0;
  fseAlkalinity.Value:= 0;
  fseSulfate.Value:= 0;
  fseChloride.Value:= 0;
  fsepH.Value:= 7;
  fseAlkalinity.Value:= 0;
  ChildNode.Text:= eName.Text;
  UpdateAmoebe;
end;

procedure TFrmWaters.eNameChange(Sender: TObject);
var W : TWater;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    FUserClicked:= false;
    Node:= tvSelect.Selected;
    if Node <> NIL then
    begin
      W:= TWater(Node.Data);
      Node.Text:= eName.Text;
      if W <> NIL then W.Name.Value:= eName.Text;
    end;
  end;
end;

procedure TFrmWaters.bbDeleteClick(Sender: TObject);
var W : TWater;
    Node : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    W:= TWater(Node.Data);
    if Question(self, 'Wil je ' + W.Name.Value + ' echt verwijderen?') then
    begin
      Waters.RemoveByReference(W);
      tvSelect.Items.Delete(Node);
      FSelectedNode:= NIL;
    end;
  end;
  FUserClicked:= TRUE;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Waters.Item[0]);
end;

procedure TFrmWaters.bbImportClick(Sender: TObject);
begin
  if Waters.ImportXML then
    FillTree;
end;

procedure TFrmWaters.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Water, WaterOld : TWater;
begin
  //if the root node is selected then add a supplier
  //if a fermentable ingredient is selected, then add one for that supplier
  if (tvSelect.Selected.Level = 1) then
  begin
    Store;
    WaterOld:= TWater(FSelectedNode.Data);
    Water:= Waters.AddItem;
    Water.Assign(WaterOld);
    Waters.Selected:= Waters.NumItems - 1;

    if (tvSelect.Selected.Level = 0) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Water);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmWaters.bbOKClick(Sender: TObject);
begin
  Store;
  Waters.UnSelect;
end;

procedure TFrmWaters.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmWaters.cbDefaultChange(Sender: TObject);
begin

end;

procedure TFrmWaters.fseBicarbonate2Change(Sender: TObject);
var H : double;
begin
  H:= fseBicarbonate2.Value * 50 / 61;
  eHardness.Caption:= RealToStrDec(H, 0);
end;

end.

