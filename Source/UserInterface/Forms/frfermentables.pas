unit FrFermentables;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus, Amoebes;

type

  { TFrmFermentables }

  TFrmFermentables = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbAddAfterBoil: TCheckBox;
    cbAdded: TComboBox;
    cbAlwaysOnStock: TCheckBox;
    cbGrainType: TComboBox;
    cbRecommendMash: TCheckBox;
    cbType: TComboBox;
    cbOnStock: TCheckBox;
    eSearch: TEdit;
    eName: TEdit;
    eOrigin: TEdit;
    eSupplier: TEdit;
    fseDIpH: TFloatSpinEdit;
    fseCoarseFineDiff: TFloatSpinEdit;
    fseColor: TFloatSpinEdit;
    fseCost: TFloatSpinEdit;
    fseDiastaticPower: TFloatSpinEdit;
    fseBaseTo57: TFloatSpinEdit;
    fseInventory: TFloatSpinEdit;
    fseInventoryValue: TFloatSpinEdit;
    fseMaxInBatch: TFloatSpinEdit;
    fseMoisture: TFloatSpinEdit;
    fseProtein: TFloatSpinEdit;
    fseDissProtein: TFloatSpinEdit;
    fseYield: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbInventory: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    lblDIpH: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lblCoarseFineDiff: TLabel;
    lblColor: TLabel;
    lblCost: TLabel;
    lblCost1: TLabel;
    lblDiastaticPower: TLabel;
    lblBaseTo57: TLabel;
    lblInventoryUnit: TLabel;
    lblMaxInBatch: TLabel;
    lblMoisture: TLabel;
    lblProtein: TLabel;
    lblProtein1: TLabel;
    lblYield: TLabel;
    mNotes: TMemo;
    pcEdit: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    shColor: TShape;
    sbClear: TSpeedButton;
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
    procedure cbTypeChange(Sender: TObject);
    procedure eSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseColorChange(Sender: TObject);
    procedure fseCostChange(Sender: TObject);
    procedure fseInventoryChange(Sender: TObject);
    procedure fseYieldChange(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure eSupplierExit(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure bbCopyClick(Sender: TObject);
  private
    FSelectedNode : TTreeNode;
    FUserClicked : boolean;
    Procedure Store;
    Procedure FillTree;
    Procedure UpdateAmoebe;
  public

  end; 

var
  FrmFermentables: TFrmFermentables;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers, StrUtils;

{ TFrmFermentables }

procedure TFrmFermentables.FormCreate(Sender: TObject);
var ft : TFermentableType;
    gt : TGrainType;
    at : TAddedType;
    F : TFermentable;
    i : longint;
    yieldm, colorm, moism, fcdiffm, protm, dprotm, enzm : double;
begin
  FUserClicked:= TRUE;
  Fermentables.UnSelect;
  cbType.Items.Clear;
  for ft:= Low(FermentableTypeDisplayNames) to High(FermentableTypeDisplayNames) do
    cbType.Items.Add(FermentableTypeDisplayNames[ft]);
  cbType.ItemIndex:= 0;
  cbGrainType.Items.Clear;
  for gt:= Low(GrainTypeDisplayNames) to High(GrainTypeDisplayNames) do
    cbGrainType.Items.Add(GrainTypeDisplayNames[gt]);
  cbGrainType.ItemIndex:= 0;
  for at:= Low(AddedTypeDisplayNames) to High(AddedTypeDisplayNames) do
    cbAdded.Items.Add(AddedTypeDisplayNames[at]);

  yieldm:= 0; colorm:= 0; moism:= 0; fcdiffm:= 0; protm:= 0; dprotm:= 0; enzm:= 0;
  for i:= 0 to Fermentables.NumItems - 1 do
  begin
    F:= TFermentable(Fermentables.Item[i]);
    if F <> NIL then
    begin
      if F.Yield.Value > yieldm then yieldm:= F.Yield.Value;
      if F.Color.DisplayValue > colorm then colorm:= F.Color.DisplayValue;
      if F.Moisture.Value > moism then moism:= F.Moisture.Value;
      if F.CoarseFineDiff.Value > fcdiffm then fcdiffm:= F.CoarseFineDiff.Value;
      if F.Protein.Value > protm then protm:= F.Protein.Value;
      if F.DissolvedProtein.Value > dprotm then dprotm:= F.DissolvedProtein.Value;
      if F.DiastaticPower.Value > enzm then enzm:= F.DiastaticPower.Value;
    end;
  end;
  FAmoebe:= TAmoebe.Create(tsAmoebe);
  FAmoebe.Parent:= tsAmoebe;
  FAmoebe.Align:= alClient;
  FAmoebe.Kind:= akClassic;
  FAmoebe.NormColor:= RGBtocolor(255, 255, 180);
  FAmoebe.AmoebeColor:= RGBtocolor(88, 243, 175);
  FAmoebe.AddSerie('Opbrengst', '%', 0, yieldm, 5, yieldm);
  FAmoebe.AddSerie('Kleur', F.Color.DisplayUnitString, 0, colorm, 3, colorm);
  FAmoebe.AddSerie('Vocht', '%', 0, moism, 1, moism);
  FAmoebe.AddSerie('Fijn grof versch.', '%', 0, fcdiffm, 1, fcdiffm);
  FAmoebe.AddSerie('Eiwitgehalte', '%', 0, protm, 1, protm);
  FAmoebe.AddSerie('Opgel. eiwit', '%', 0, dprotm, 1, dprotm);
  FAmoebe.AddSerie('Enzymkracht', F.DiastaticPower.DisplayUnitString, 0, enzm, 1, enzm);

  F:= TFermentable(Fermentables.Item[0]);
  if F <> NIL then
  begin
    lblInventoryUnit.Caption:= UnitNames[F.Inventory.DisplayUnit];
    lblColor.Caption:= UnitNames[F.Color.DisplayUnit];
    lblDiastaticPower.Caption:= UnitNames[F.DiastaticPower.DisplayUnit];
  end;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FillTree;
end;

Procedure TFrmFermentables.FillTree;
var i : integer;
    supp, fname : string;
    F : TFermentable;
    Node, ChildNode, {%H-}ChildNode2 : TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'Fabrikant');
  for i:= 0 to Fermentables.NumItems - 1 do
  begin
    F:= TFermentable(Fermentables.Item[i]);
    supp:= F.Supplier.Value;
    if supp = '' then supp:= 'onbekend';
    fname:= F.Name.Value;
    ChildNode:= tvSelect.Items.FindNodeWithText(supp);
    if ChildNode = NIL then
      ChildNode:= tvSelect.Items.AddChild(Node, supp);
    ChildNode2:= tvSelect.Items.AddChildObject(ChildNode, fname, F);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Fermentables.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  tvSelectSelectionChanged(self);
end;

procedure TFrmFermentables.fseColorChange(Sender: TObject);
begin
  if lblColor.Caption = 'EBC' then shColor.Brush.Color:= EBCtoColor(fseColor.Value)
  else shColor.Brush.Color:= SRMtoColor(fseColor.Value);
  UpdateAmoebe;
end;

Procedure TFrmFermentables.Store;
var Ferm : TFermentable;
    SupplierChanged : boolean;
    Node, RootNode : TTreeNode;
    Mode : TNodeAttachMode;
begin
  Ferm:= NIL;
  if (FSelectedNode <> NIL) and (FSelectedNode.Data <> NIL) then
    Ferm:= TFermentable(FSelectedNode.Data);
  if Ferm <> NIL then
  begin
    Ferm.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    Ferm.Notes.Value:= mNotes.Text;
    Ferm.Inventory.DisplayValue:= fseInventory.Value;
    Ferm.Cost.Value:= fseCost.Value;
    Ferm.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    Ferm.GrainTypeDisplayName:= cbGrainType.Items[cbGrainType.ItemIndex];
    Ferm.Origin.Value:= eOrigin.Text;
    SupplierChanged:= not (Ferm.Supplier.Value = eSupplier.Text);
    Ferm.Supplier.Value:= eSupplier.Text;
    Ferm.MaxInBatch.Value:= fseMaxInBatch.Value;
    Ferm.AddAfterBoil.Value:= cbAddAfterBoil.Checked;
    Ferm.RecommendMash.Value:= cbRecommendMash.Checked;
    Ferm.AddedTypeDisplayName:= cbAdded.Items[cbAdded.ItemIndex];
    Ferm.Yield.Value:= fseYield.Value;
    Ferm.Color.DisplayValue:= fseColor.Value;
    Ferm.CoarseFineDiff.Value:= fseCoarseFineDiff.Value;
    Ferm.Moisture.Value:= fseMoisture.Value;
    Ferm.DiastaticPower.DisplayValue:= fseDiastaticPower.Value;
    Ferm.Protein.Value:= fseProtein.Value;
    Ferm.DissolvedProtein.Value:= fseDissProtein.Value;
    Ferm.AlwaysOnStock.Value:= cbAlwaysOnStock.Checked;
    if fseDIpH.Enabled then
    begin
      Ferm.DIpH.Value:= fseDIpH.Value;
      Ferm.AcidTo57.Value:= fseBaseTo57.Value;
    end;

    if SupplierChanged then
    begin
      //first look if supplier already exist
      Node:= tvSelect.Items.FindNodeWithText(Ferm.Supplier.Value);
      if Node = NIL then  //supplier does not exist. Move the node to the right supplier
      begin
        RootNode:= tvSelect.Items[0];
        Node:= tvSelect.Items.AddChild(RootNode, Ferm.Supplier.Value);
      end;
      Mode:= naAddChild;
      FSelectedNode.MoveTo(Node, Mode);
    end;
    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmFermentables.tvSelectSelectionChanged(Sender: TObject);
var Ferm : TFermentable;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    if FSelectedNode <> NIL then
      Store;

    Ferm:= NIL;
    Node:= NIL;
    if tvSelect.Selected <> NIL then
    begin
      bbDelete.Enabled:= (tvSelect.Selected.Level > 0);
      bbCopy.Enabled:= (tvSelect.Selected.Level = 2);

      if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        Ferm:= TFermentable(Node.Data);
    end
    else
    begin
      bbDelete.Enabled:= false;
      bbCopy.Enabled:= false;
    end;
    miDelete.Enabled:= bbDelete.Enabled;
    miCopy.Enabled:= bbCopy.Enabled;
    gbInfo.Visible:= (Node <> NIL);
    pcEdit.Visible:= (Node <> NIL);

    if Ferm <> NIL then
    begin
      eName.Text:= Ferm.Name.Value;
      mNotes.Text:= Ferm.Notes.Value;
      eOrigin.Text:= Ferm.Origin.Value;
      eSupplier.Text:= Ferm.Supplier.Value;
      cbType.ItemIndex:= cbType.Items.IndexOf(FermentableTypeDisplayNames[Ferm.FermentableType]);
      cbGrainType.ItemIndex:= cbGrainType.Items.IndexOf(GrainTypeDisplayNames[Ferm.GrainType]);
      SetControl(fseInventory, lblInventoryUnit, Ferm.Inventory, TRUE);
      SetControl(fseCost, lblCost, Ferm.Cost, TRUE);
      SetControl(fseInventoryValue, lblCost1, Ferm.Cost, false);
      fseInventoryValue.Value:= Ferm.Inventory.DisplayValue * Ferm.Cost.Value;
      SetControl(fseMaxInBatch, lblMaxInBatch, Ferm.MaxInBatch, TRUE);
      cbAddAfterBoil.Checked:= Ferm.AddAfterBoil.Value;
      cbRecommendMash.Checked:= Ferm.RecommendMash.Value;
      cbAdded.ItemIndex:= cbAdded.Items.IndexOf(AddedTypeDisplayNames[Ferm.AddedType]);

      SetControl(fseYield, lblYield, Ferm.Yield, TRUE);
      SetControl(fseColor, lblColor, Ferm.Color, TRUE);
      SetControl(fseCoarseFineDiff, lblCoarseFineDiff, Ferm.CoarseFineDiff, TRUE);
      SetControl(fseMoisture, lblMoisture, Ferm.Moisture, TRUE);
      SetControl(fseDiastaticPower, lblDiastaticPower, Ferm.DiastaticPower, TRUE);
      SetControl(fseDissProtein, lblProtein1, Ferm.DissolvedProtein, TRUE);
      SetControl(fseProtein, lblProtein, Ferm.Protein, TRUE);
      fseColorChange(Sender);
      cbGrainType.Enabled:= (cbType.ItemIndex = 0);
      if not cbGrainType.Enabled then
      begin
        cbGrainType.ItemIndex:= 5;
        if cbType.ItemIndex = 1 then cbRecommendMash.Checked:= false;
      end;
      cbAlwaysOnStock.Checked:= Ferm.AlwaysOnStock.Value;

      fseDIpH.Enabled:= (Ferm.GrainType <> gtNone);
      fseBaseTo57.Enabled:= fseDIpH.Enabled;
      if fseDIpH.Enabled then
      begin
        SetControl(fseDIpH, lblDIpH, Ferm.DIpH, TRUE);
        SetControl(fseBaseTo57, lblBaseTo57, Ferm.AcidTo57, TRUE);
      end
      else
      begin
        fseDIpH.Value:= 0;
        fseBaseTo57.Value:= 0;
      end;

      UpdateAmoebe;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

Procedure TFrmFermentables.UpdateAmoebe;
var F : TFermentable;
    Node : TTreeNode;
begin
  F:= NIL;
  Node:= NIL;

  if tvSelect.Selected <> NIL then
  begin
    if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
    else Node:= NIL;
    if Node <> NIL then
      F:= TFermentable(Node.Data);
  end;

  if F <> NIL then
  begin
    FAmoebe.Score[1]:= F.Yield.Value;
    FAmoebe.Score[2]:= F.Color.DisplayValue;
    FAmoebe.Score[3]:= F.Moisture.Value;
    FAmoebe.Score[4]:= F.CoarseFineDiff.Value;
    FAmoebe.Score[5]:= F.Protein.Value;
    FAmoebe.Score[6]:= F.DissolvedProtein.Value;
    FAmoebe.Score[7]:= F.DiastaticPower.Value;
  end;
end;

procedure TFrmFermentables.eSupplierExit(Sender: TObject);
var F : TFermentable;
begin
  F:= TFermentable(tvSelect.Selected.Data);
  F.Supplier.Value:= eSupplier.Text;
  FillTree;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(F);
end;

procedure TFrmFermentables.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmFermentables.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    st : string;
    Ferm : TFermentable;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level = 0) then
  begin
    st:= GetAnswer(self, 'Nieuwe fabrikant:');
    if st <> '' then
    begin
      Node:= tvSelect.Items[0];
      ChildNode:= tvSelect.Items.AddChild(Node, st);
    end;
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Fermentables.AddItem;
    Fermentables.Selected:= Fermentables.NumItems - 1;
    Ferm:= Fermentables.SelectedItem;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Fermentables.SelectedItem);
    ChildNode.Selected:= TRUE;
    if (tvSelect.Selected.Level = 1) then st:= tvSelect.Selected.Text
    else st:= tvSelect.Selected.Parent.Text;
    eName.Text:= 'Nieuw vergistbaar ingrediënt';
    mNotes.Text:= '';
    fseInventory.Value:= 0;
    fseCost.Value:= 0;
    cbType.ItemIndex:= 0;
    cbGrainType.ItemIndex:= 0;
    eOrigin.Text:= '';
    eSupplier.Text:= st;
    Ferm.Supplier.Value:= st;
    fseMaxInBatch.Value:= 100;
    cbAddAfterBoil.Checked:= false;
    cbRecommendMash.Checked:= true;
    fseYield.Value:= 80;
    fseColor.Value:= 3;
    fseCoarseFineDiff.Value:= 3;
    fseMoisture.Value:= 4;
    fseDiastaticPower.Value:= 0;
    fseProtein.Value:= 0;
    fseDissProtein.Value:= 0;
    cbAlwaysOnStock.Checked:= false;
    ChildNode.Text:= eName.Text;
    UpdateAmoebe;
  end;
end;

procedure TFrmFermentables.bbDeleteClick(Sender: TObject);
var Ferm : TFermentable;
    Node, ChildNode{, Node2} : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    if Node.Level = 1 then //delete entire supplier
    begin
      if Question(self, 'Wil je echt alle mouten van deze leverancier wissen?') then
      begin
        while Node.HasChildren do
        begin
          ChildNode:= Node.GetLastChild;
          Ferm:= TFermentable(ChildNode.Data);
          Fermentables.RemoveByReference(Ferm);
          tvSelect.Items.Delete(ChildNode);
        end;
        tvSelect.Items.Delete(Node);
      end;
      FSelectedNode:= NIL;
    end
    else if Node.Level = 2 then
    begin
{      Node2:= Node.GetNextSibling;
      if Node2 = NIL then
        Node2:= Node.GetPrevSibling;}
      Ferm:= TFermentable(Node.Data);
      if Question(self, 'Wil je ' + Ferm.Name.Value + ' echt verwijderen?') then
      begin
        Fermentables.RemoveByReference(Ferm);
        tvSelect.Items.Delete(Node);
      end;
     // FSelectedNode:= Node2;
    end;
  end;
  FUserClicked:= TRUE;
  FSelectedNode:= NIL;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Fermentables.Item[0]);
end;

procedure TFrmFermentables.bbImportClick(Sender: TObject);
begin
  if Fermentables.ImportXML then
    FillTree;
end;

procedure TFrmFermentables.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Ferm, FermOld : TFermentable;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level < 2) then
  begin
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Store;
    FermOld:= TFermentable(FSelectedNode.Data);
    Ferm:= Fermentables.AddItem;
    Ferm.Assign(FermOld);
    Fermentables.Selected:= Fermentables.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Ferm);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmFermentables.bbOKClick(Sender: TObject);
begin
  Store;
  Fermentables.UnSelect;
end;

procedure TFrmFermentables.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmFermentables.cbTypeChange(Sender: TObject);
begin
  cbGrainType.Enabled:= (cbType.ItemIndex = 0);
  if not cbGrainType.Enabled then
  begin
    cbGrainType.ItemIndex:= 6;
    if cbType.ItemIndex = 1 then cbRecommendMash.Checked:= false;
  end;
end;

procedure TFrmFermentables.eSearchChange(Sender: TObject);
var N : TTreeNode;
    Ferm : TFermentable;
    s, s2 : string;
    Vis : boolean;
begin
  s:= LowerCase(eSearch.Text);
  N:= tvSelect.Items[0];
  while N <> NIL do
  begin
    if N.Level = 2 then
    begin
      Ferm:= TFermentable(N.Data);
      if Ferm <> NIL then
      begin
        vis:= false;
        if s <> '' then
        begin
          s2:= LowerCase(Ferm.Name.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          s2:= LowerCase(Ferm.Supplier.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          N.Visible:= Vis;
        end
        else Vis:= TRUE;
        if vis and cbOnStock.Checked and (Ferm.Inventory.Value = 0) then vis:= false;
        N.Visible:= Vis;
      end;
    end;
    N:= N.GetNext;
  end;
end;

procedure TFrmFermentables.sbClearClick(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmFermentables.fseInventoryChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value;
end;

procedure TFrmFermentables.fseYieldChange(Sender: TObject);
begin
  UpdateAmoebe;
end;

procedure TFrmFermentables.fseCostChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value;
end;

end.

