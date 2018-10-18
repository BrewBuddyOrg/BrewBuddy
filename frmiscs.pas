unit FrMiscs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus;

type

  { TFrmMiscs }

  TFrmMiscs = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbOnStock: TCheckBox;
    cbType: TComboBox;
    cbAmountIsWeight: TCheckBox;
    cbAlwaysOnStock: TCheckBox;
    cbUse: TComboBox;
    eName: TEdit;
    eSearch: TEdit;
    fseFreeField: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label6: TLabel;
    lblFreeFieldUnit: TLabel;
    lblFreeField: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    fseCost: TFloatSpinEdit;
    fseInventoryValue: TFloatSpinEdit;
    gbInventory: TGroupBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lInventoryValue: TLabel;
    lInventory: TLabel;
    lCost: TLabel;
    mUseFor: TMemo;
    mNotes: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    fseInventory: TFloatSpinEdit;
    sbClear: TSpeedButton;
    tvSelect: TTreeView;
    bbImport: TBitBtn;
    bbCopy: TBitBtn;
    pmIngredients: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    MenuItem1: TMenuItem;
    miImport: TMenuItem;
    miCopy: TMenuItem;
    procedure bbAddClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure cbAmountIsWeightChange(Sender: TObject);
    procedure cbUseChange(Sender: TObject);
    procedure eSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseCostChange(Sender: TObject);
    procedure fseInventoryChange(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure bbCopyClick(Sender: TObject);
  private
    { private declarations }
    FSelectedNode : TTreeNode;
    FNew : boolean;
    FUserClicked: boolean;
    Procedure Store;
    Procedure FillTree;
  public
    { public declarations }
  end; 

var
  FrmMiscs: TFrmMiscs;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers, StrUtils;

{ TFrmMiscs }

procedure TFrmMiscs.FormCreate(Sender: TObject);
var mt : TMiscType;
    ut : TMiscUse;
    M : TMisc;
begin
  FUserClicked:= false;
  Miscs.UnSelect;
  cbType.Items.Clear;
  for mt:= Low(MiscTypeDisplayNames) to High(MiscTypeDisplayNames) do
    cbType.Items.Add(MiscTypeDisplayNames[mt]);
  cbType.ItemIndex:= 0;

  for ut:= Low(MiscUseDisplayNames) to High(MiscUseDisplayNames) do
    cbUse.Items.Add(MiscUseDisplayNames[ut]);

  M:= TMisc(Miscs.Item[0]);
  if M <> NIL then
  begin
    cbAmountIsWeight.Checked:= M.AmountIsWeight.Value;
    lInventory.Caption:= UnitNames[M.Inventory.DisplayUnit];
  end;
  FUserClicked:= TRUE;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FillTree;
  FNew:= false;
end;

Procedure TFrmMiscs.FillTree;
var i : integer;
    s : string;
    M : TMisc;
    Node, ChildNode, ChildNode2: TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'Type');
  for i:= 0 to Miscs.NumItems - 1 do
  begin
    M:= TMisc(Miscs.Item[i]);
    s:= M.TypeDisplayName;
    if s = '' then s:= 'onbekend';
    ChildNode:= tvSelect.Items.FindNodeWithText(s);
    if ChildNode = NIL then
      ChildNode:= tvSelect.Items.AddChild(Node, s);
    ChildNode2:= tvSelect.Items.AddChildObject(ChildNode, M.Name.Value, M);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Miscs.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  tvSelectSelectionChanged(self);
end;

Procedure TFrmMiscs.Store;
var M : TMisc;
    Node, RootNode : TTreeNode;
    TypeChanged : boolean;
    Mode : TNodeAttachMode;
begin
  M:= NIL;
  if FSelectedNode <> NIL then M:= TMisc(FSelectedNode.Data);
  if M <> NIL then
  begin
    M.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    M.Notes.Value:= mNotes.Text;
    M.Inventory.DisplayValue:= fseInventory.Value;
    M.Cost.Value:= fseCost.Value;
    TypeChanged:= not (M.TypeDisplayName = cbType.Items[cbType.ItemIndex]);
    M.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    M.UseDisplayName:= cbUse.Items[cbUse.ItemIndex];
    M.UseFor.Value:= mUseFor.Text;
    M.AmountIsWeight.Value:= cbAmountIsWeight.Checked;
    if cbAmountIsWeight.Checked then
    begin
      M.Amount.vUnit:= kilogram;
      M.Amount.DisplayUnit:= gram;
    end
    else
    begin
      M.Amount.vUnit:= liter;
      M.Amount.DisplayUnit:= milliliter;
    end;
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;

    M.AlwaysOnStock.Value:= cbAlwaysOnStock.Checked;
    if M.FreeFieldName.Value <> '' then
      M.FreeField.Value:= fseFreeField.Value;
    if TypeChanged then
    begin
      //first look if supplier already exist
      Node:= tvSelect.Items.FindNodeWithText(M.TypeDisplayName);
      if Node = NIL then  //type does not exist. Move the node to the right type
      begin
        RootNode:= tvSelect.Items[0];
        Node:= tvSelect.Items.AddChild(RootNode, M.TypeDisplayName);
      end;
      Mode:= naAddChild;
      FSelectedNode.MoveTo(Node, Mode);
    end;
    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmMiscs.tvSelectSelectionChanged(Sender: TObject);
var M : TMisc;
    Node : TTReeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    if (FSelectedNode <> NIL) and (not FNew) then
      Store;
    FNew:= false;
    M:= NIL;
    Node:= NIL;

    if tvSelect.Selected <> NIL then
    begin
      if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
      else Node:= NIL;

      if Node <> NIL then
        M:= TMisc(Node.Data);

      bbDelete.Enabled:= (tvSelect.Selected.Level = 2);
    end
    else
      bbDelete.Enabled:= false;
    bbCopy.Enabled:= bbDelete.Enabled;
    miDelete.Enabled:= bbDelete.Enabled;
    miCopy.Enabled:= bbDelete.Enabled;
    gbInfo.Visible:= (Node <> NIL);
    gbProperties.Visible:= (Node <> NIL);
    gbInventory.Visible:= (Node <> NIL);

    if M <> NIL then
    begin
      eName.Text:= M.Name.Value;
      mNotes.Text:= M.Notes.Value;
      mUseFor.Text:= M.UseFor.Value;
      cbType.ItemIndex:= cbType.Items.IndexOf(MiscTypeDisplayNames[M.MiscType]);
      cbUse.ItemIndex:= cbUse.Items.IndexOf(MiscUseDisplayNames[M.Use]);
      cbAmountIsWeight.Checked:= M.AmountIsWeight.Value;
      SetControl(fseInventory, lInventory, M.Inventory, TRUE);
      SetControl(fseCost, lCost, M.Cost, TRUE);
      SetControl(fseInventoryValue, lInventoryValue, M.Cost, false);
      fseInventoryValue.Value:= M.Inventory.Value * M.Cost.Value;
      cbAlwaysOnStock.Checked:= M.AlwaysOnStock.Value;
      lblFreeField.Visible:= M.FreeFieldName.Value <> '';
      fseFreeField.Visible:= lblFreeField.Visible;
      lblFreeFieldUnit.Visible:= lblFreeField.Visible;
      if M.FreeFieldName.Value <> '' then
      begin
        lblFreeField.Caption:= M.FreeFieldName.Value + ':';
        SetControl(fseFreeField, lblFreeFieldUnit, M.FreeField, TRUE);
        fseFreeField.DecimalPlaces:= M.FreeField.Decimals;
      end;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

procedure TFrmMiscs.cbTypeChange(Sender: TObject);
var M : TMisc;
begin
  M:= TMisc(tvSelect.Selected.Data);
  M.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
  FillTree;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(M);
end;

procedure TFrmMiscs.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmMiscs.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    st : string;
begin
    if (tvSelect.Selected.Level = 0) then
  begin
    st:= GetAnswer(self, 'Nieuw type overig ingrediënt:');
    if st <> '' then
    begin
      Node:= tvSelect.Items[0];
      ChildNode:= tvSelect.Items.AddChild(Node, st);
    end;
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Miscs.AddItem;
    Miscs.Selected:= Miscs.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Miscs.SelectedItem);
    ChildNode.Selected:= TRUE;
    if (tvSelect.Selected.Level = 1) then st:= tvSelect.Selected.Text
    else st:= tvSelect.Selected.Parent.Text;

    FNew:= TRUE;
    eName.Text:= 'Nieuw ingrediënt';
    mNotes.Text:= '';
    fseInventory.Value:= 0;
    fseCost.Value:= 0;
    cbType.ItemIndex:= cbType.Items.IndexOf(st);
    cbUse.ItemIndex:= 0;
    mUseFor.Text:= '';
    cbAmountIsWeight.Checked:= TRUE;
    ChildNode.Text:= eName.Text;
  end;
end;

procedure TFrmMiscs.bbDeleteClick(Sender: TObject);
var M : TMisc;
    Node : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    if Node.Level > 1 then
    begin
      Node:= tvSelect.Selected;
      if Node <> NIL then
      begin
        M:= TMisc(Node.Data);
        if Question(self, 'Wil je ' + M.Name.Value + ' echt verwijderen?') then
        begin
          Miscs.RemoveByReference(M);
          tvSelect.Items.Delete(Node);
          FSelectedNode:= NIL;
        end;
      end;
    end;
  end;
  FUserClicked:= TRUE;
  FSelectedNode:= NIL;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Miscs.Item[0]);
end;

procedure TFrmMiscs.bbImportClick(Sender: TObject);
begin
  if Miscs.ImportXML then
    FillTree;
end;

procedure TFrmMiscs.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Misc, MiscOld : TMisc;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level < 2) then
  begin
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Store;
    MiscOld:= TMisc(FSelectedNode.Data);
    Misc:= Miscs.AddItem;
    Misc.Assign(MiscOld);
    Miscs.Selected:= Miscs.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Misc);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmMiscs.bbOKClick(Sender: TObject);
begin
  Store;
  Miscs.UnSelect;
end;

procedure TFrmMiscs.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmMiscs.cbAmountIsWeightChange(Sender: TObject);
begin
  if cbAmountIsWeight.Checked then lInventory.Caption:= 'g'
  else lInventory.Caption:= 'ml';
end;

procedure TFrmMiscs.cbUseChange(Sender: TObject);
begin

end;

procedure TFrmMiscs.eSearchChange(Sender: TObject);
var i : integer;
    N : TTreeNode;
    M : TMisc;
    s, s2 : string;
    Vis : boolean;
begin
  s:= LowerCase(eSearch.Text);
  N:= tvSelect.Items[0];
  while N <> NIL do
  begin
    if N.Level = 2 then
    begin
      M:= TMisc(N.Data);
      if M <> NIL then
      begin
        vis:= false;
        if s <> '' then
        begin
          s2:= LowerCase(M.Name.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          N.Visible:= Vis;
        end
        else Vis:= TRUE;
        if vis and cbOnStock.Checked and (M.Inventory.Value = 0) then vis:= false;
        N.Visible:= Vis;
      end;
    end;
    N:= N.GetNext;
  end;
end;

procedure TFrmMiscs.fseInventoryChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value / 1000;
end;

procedure TFrmMiscs.sbClearClick(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmMiscs.fseCostChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value / 1000;
end;

end.

