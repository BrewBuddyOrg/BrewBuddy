unit FrHop;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus, EditBtn, Amoebes;

type

  { TFrmHop }

  TFrmHop = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbAlwaysOnStock: TCheckBox;
    cbForm: TComboBox;
    cbOnStock: TCheckBox;
    cbType: TComboBox;
    deHarvestDate: TDateEdit;
    eName: TEdit;
    eOrigin: TEdit;
    eSearch: TEdit;
    eSubstitutes: TEdit;
    fseAlfa: TFloatSpinEdit;
    fseBeta: TFloatSpinEdit;
    fseCaryophyllene: TFloatSpinEdit;
    fseCohumulone: TFloatSpinEdit;
    fseCost: TFloatSpinEdit;
    fseHSI: TFloatSpinEdit;
    fseHumulene: TFloatSpinEdit;
    fseInventory: TFloatSpinEdit;
    fseInventoryValue: TFloatSpinEdit;
    fseMyrcene: TFloatSpinEdit;
    fseTotalOil: TFloatSpinEdit;
    gbInfo: TGroupBox;
    gbInventory: TGroupBox;
    gbOil: TGroupBox;
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
    Label2: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lAlfa: TLabel;
    lBeta: TLabel;
    lCaryophyllene: TLabel;
    lCohumulone: TLabel;
    lCost: TLabel;
    lHumulene: TLabel;
    lInventory: TLabel;
    lInventoryValue: TLabel;
    lMyrcene: TLabel;
    lTotalOil: TLabel;
    mNotes: TMemo;
    Panel2: TPanel;
    pcEdit: TPageControl;
    Panel1: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    sbClear: TSpeedButton;
    tsProperties: TTabSheet;
    tsAmoebe: TTabSheet;
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
    procedure eSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseCohumuloneChange(Sender: TObject);
    procedure fseCostChange(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure fseInventoryChange(Sender: TObject);
    procedure eOriginExit(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure bbCopyClick(Sender: TObject);
  private
    FNew : boolean;
    FSelectedNode : TTreeNode;
    FUserClicked : boolean;
    Procedure Store;
    Procedure FillTree;
    Procedure UpdateAmoebe;
  public

  end; 

var
  FrmHop: TFrmHop;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers, StrUtils;

{ TFrmHop }

procedure TFrmHop.FormCreate(Sender: TObject);
var hf : THopForm;
    ht : THopType;
    alfam, betam, hsim, cohm, myrm, humm, carym, olm : double;
    i : longint;
    H : THop;
begin
  alfam:= 0; betam:= 0; hsim:= 0; cohm:= 0; olm:= 0; myrm:= 0; humm:= 0; carym:= 0;
  for i:= 0 to Hops.NumItems - 1 do
  begin
    H:= THop(Hops.Item[i]);
    if H <> NIL then
    begin
      if H.Alfa.Value > alfam then alfam:= H.Alfa.Value;
      if H.Beta.Value > betam then betam:= H.Beta.Value;
      if H.HSI.Value > hsim then hsim:= H.HSI.Value;
      if H.Cohumulone.Value > cohm then cohm:= H.Cohumulone.Value;
      if H.TotalOil.Value > olm then olm:= H.TotalOil.Value;
      if H.Myrcene.Value > myrm then myrm:= H.Myrcene.Value;
      if H.Humulene.Value > humm then humm:= H.Humulene.Value;
      if H.Caryophyllene.Value > carym then carym:= H.Caryophyllene.Value;
    end;
  end;
  FAmoebe:= TAmoebe.Create(tsAmoebe);
  FAmoebe.Parent:= tsAmoebe;
  FAmoebe.Align:= alClient;
  FAmoebe.Kind:= akClassic;
  FAmoebe.NormColor:= RGBtocolor(255, 255, 180);
  FAmoebe.AmoebeColor:= RGBtocolor(88, 243, 175);
  FAmoebe.AddSerie('Alfa', '%', 0, alfam, 5, alfam);
  FAmoebe.AddSerie('Beta', '%', 0, betam, 3, betam);
  FAmoebe.AddSerie('HSI', '%', 0, hsim, 50, hsim);
  FAmoebe.AddSerie('Cohumulone', '%', 0, cohm, 25, cohm);
  FAmoebe.AddSerie('Oliegehalte', '%', 0, olm, 1, olm);
  FAmoebe.AddSerie('Myrceen', '%', 0, myrm, 12, myrm);
  FAmoebe.AddSerie('Humuleen', '%', 0, humm, 5, humm);
  FAmoebe.AddSerie('Caryofyleen', '%', 0, carym, 5, carym);

  FUserClicked:= TRUE;
  FNew:= false;
  Hops.UnSelect;
  cbForm.Items.Clear;
  for hf:= Low(HopFormDisplayNames) to High(HopFormDisplayNames) do
    cbForm.Items.Add(HopFormDisplayNames[hf]);
  cbForm.ItemIndex:= 0;
  cbType.Items.Clear;
  for ht:= Low(HopTypeDisplayNames) to High(HopTypeDisplaynames) do
    cbType.Items.Add(HopTypeDisplayNames[ht]);
  cbType.ItemIndex:= 0;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FillTree;
end;

Procedure TFrmHop.FillTree;
var i : integer;
    H : THop;
    s : string;
    Node, ChildNode, {%H-}ChildNode2 : TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'Herkomst');
  for i:= 0 to Hops.NumItems - 1 do
  begin
    H:= THop(Hops.Item[i]);
    s:= H.Origin.Value;
    if s = '' then s:= 'onbekend';
    ChildNode:= tvSelect.Items.FindNodeWithText(s);
    if ChildNode = NIL then
      ChildNode:= tvSelect.Items.AddChild(Node, s);
    ChildNode2:= tvSelect.Items.AddChildObject(ChildNode, H.Name.Value, H);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Hops.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  tvSelectSelectionChanged(self);
end;

Procedure TFrmHop.Store;
var Hop : THop;
    OriginChanged : boolean;
    Node, RootNode : TTreeNode;
    Mode : TNodeAttachMode;
begin
  Hop:= NIL;
  if FSelectedNode <> NIL then Hop:= THop(FSelectedNode.Data);
  if Hop <> NIL then
  begin
    Hop.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    Hop.Notes.Value:= mNotes.Text;
    Hop.Inventory.DisplayValue:= fseInventory.Value;
    Hop.Cost.Value:= fseCost.Value * 10;
    Hop.Alfa.Value:= fseAlfa.Value;
    Hop.Beta.Value:= fseBeta.Value;
    Hop.HSI.Value:= fseHSI.Value;
    Hop.FormDisplayName:= cbForm.Items[cbForm.ItemIndex];
    Hop.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    OriginChanged:= not (Hop.Origin.Value = eOrigin.Text);
    Hop.Origin.Value:= eOrigin.Text;
    Hop.Substitutes.Value:= eSubstitutes.Text;
    Hop.Humulene.Value:= fseHumulene.Value;
    Hop.Caryophyllene.Value:= fseCaryophyllene.Value;
    Hop.Cohumulone.Value:= fseCohumulone.Value;
    Hop.Myrcene.Value:= fseMyrcene.Value;
    Hop.TotalOil.Value:= fseTotalOil.Value;
    Hop.AlwaysOnStock.Value:= cbAlwaysOnStock.Checked;
    Hop.HarvestDate.Value:= deHarvestDate.Date;

    if OriginChanged then
    begin
      //first look if supplier already exist
      Node:= tvSelect.Items.FindNodeWithText(Hop.Origin.Value);
      if Node = NIL then  //supplier does not exist. Move the node to the right supplier
      begin
        RootNode:= tvSelect.Items[0];
        Node:= tvSelect.Items.AddChild(RootNode, Hop.Origin.Value);
      end;
      Mode:= naAddChild;
      FSelectedNode.MoveTo(Node, Mode);
    end;
    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmHop.tvSelectSelectionChanged(Sender: TObject);
var Hop : THop;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    if FSelectedNode <> NIL then Store;

    Hop:= NIL;
    Node:= NIL;

    if tvSelect.Selected <> NIL then
    begin
      bbDelete.Enabled:= (tvSelect.Selected.Level > 0);
      bbCopy.Enabled:= (tvSelect.Selected.Level = 2);

      if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        Hop:= THop(Node.Data);
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

    if Hop <> NIL then
    begin
      eName.Text:= Hop.Name.Value;
      mNotes.Text:= Hop.Notes.Value;
      SetControl(fseInventory, lInventory, Hop.Inventory, TRUE);
      SetControl(fseCost, lCost, Hop.Cost, TRUE);
      fseCost.Value:= Hop.Cost.Value / 10;
      SetControl(fseInventoryValue, lInventoryValue, Hop.Cost, false);
      fseInventoryValue.Value:= Hop.Inventory.Value * Hop.Cost.Value;
      SetControl(fseAlfa, lAlfa, Hop.Alfa, TRUE);
      SetControl(fseBeta, lBeta, Hop.Beta, TRUE);
      SetFloatSpinEdit(fseHSI, Hop.HSI, TRUE);
      cbForm.ItemIndex:= cbForm.Items.IndexOf(HopFormDisplayNames[Hop.Form]);
      cbType.ItemIndex:= cbType.Items.IndexOf(HopTypeDisplayNames[Hop.HopType]);
      eOrigin.Text:= Hop.Origin.Value;
      eSubstitutes.Text:= Hop.Substitutes.Value;
      SetControl(fseHumulene, lHumulene, Hop.Humulene, TRUE);
      SetControl(fseCaryophyllene, lCaryophyllene, Hop.Caryophyllene, TRUE);
      SetControl(fseCohumulone, lCohumulone, Hop.Cohumulone, TRUE);
      SetControl(fseMyrcene, lMyrcene, Hop.Myrcene, TRUE);
      SetControl(fseTotalOil, lTotalOil, Hop.TotalOil, TRUE);
      cbAlwaysOnStock.Checked:= Hop.AlwaysOnStock.Value;
      deHarvestDate.Date:= Hop.HarvestDate.Value;
      UpdateAmoebe;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

Procedure TFrmHop.UpdateAmoebe;
var Hop : THop;
    Node : TTreeNode;
begin
  Hop:= NIL;
  Node:= NIL;

  if tvSelect.Selected <> NIL then
  begin
    if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
    else Node:= NIL;
    if Node <> NIL then
      Hop:= THop(Node.Data);
  end;

  if Hop <> NIL then
  begin
    FAmoebe.Score[1]:= Hop.Alfa.Value; //Alpha acids
    FAmoebe.Score[2]:= Hop.Beta.Value; //Beta acids
    FAmoebe.Score[3]:= Hop.HSI.Value; //HSI
    FAmoebe.Score[4]:= Hop.Cohumulone.Value; //Cohumulone
    FAmoebe.Score[5]:= Hop.TotalOil.Value; //total oil content
    FAmoebe.Score[6]:= Hop.Myrcene.Value; //Myrceen
    FAmoebe.Score[7]:= Hop.Humulene.Value; //Humuleen
    FAmoebe.Score[8]:= Hop.Caryophyllene.Value; //Caryofyleen
  end;
end;

procedure TFrmHop.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmHop.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    st : string;
    ToD : TDateTime;
    D, M, Y : word;
begin
  //if the root node is selected then add a origin
  if (tvSelect.Selected.Level = 0) then
  begin
    st:= GetAnswer(self, 'Nieuw land van herkomst:');
    if st <> '' then
    begin
      Node:= tvSelect.Items[0];
      ChildNode:= tvSelect.Items.AddChild(Node, st);
    end;
  end
  else
  begin
    Hops.AddItem;
    Hops.Selected:= Hops.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Hops.SelectedItem);
    ChildNode.Selected:= TRUE;
    if (tvSelect.Selected.Level = 1) then st:= tvSelect.Selected.Text
    else st:= tvSelect.Selected.Parent.Text;
    eName.Text:= 'Nieuwe hop';
    mNotes.Text:= '';
    fseInventory.Value:= 0;
    fseCost.Value:= 0;
    fseAlfa.Value:= 0;
    fseBeta.Value:= 0;
    fseHSI.Value:= 0;
    cbForm.ItemIndex:= 0;
    cbType.ItemIndex:= 0;
    eOrigin.Text:= st;
    eSubstitutes.Text:= '';
    fseHumulene.Value:= 0;
    fseCaryophyllene.Value:= 0;
    fseCohumulone.Value:= 0;
    fseMyrcene.Value:= 0;
    cbAlwaysOnStock.Checked:= false;
    ToD:= Now;
    DecodeDate(ToD, Y, M, D);
    if M < 8 then Y:= Y - 1;
    ToD:= EncodeDate(Y, 9, 1);
    deHarvestDate.Date:= ToD;

    ChildNode.Text:= eName.Text;
  end;
end;

procedure TFrmHop.bbDeleteClick(Sender: TObject);
var Hop : THop;
    Node, ChildNode : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    if Node.Level = 1 then //delete entire origin
    begin
      if Question(self, 'Wil je echt alle hoppen uit dit land wissen?') then
      begin
        while Node.HasChildren do
        begin
          ChildNode:= Node.GetLastChild;
          Hop:= THop(ChildNode.Data);
          Hops.RemoveByReference(Hop);
          tvSelect.Items.Delete(ChildNode);
        end;
        tvSelect.Items.Delete(Node);
        FSelectedNode:= NIL;
      end;
    end
    else if Node.Level = 2 then
    begin
      Hop:= THop(Node.Data);
      if Question(self, 'Wil je '+ Hop.Name.Value + ' echt verwijderen?') then
      begin
        Hops.RemoveByReference(Hop);
        tvSelect.Items.Delete(Node);
      end;
    end;
  end;
  FUserClicked:= TRUE;
  FSelectedNode:= NIL;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Hops.Item[0]);
end;

procedure TFrmHop.bbImportClick(Sender: TObject);
begin
  if Hops.ImportXML then
    FillTree;
end;

procedure TFrmHop.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Hop, HopOld : THop;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level < 2) then
  begin
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Store;
    HopOld:= THop(FSelectedNode.Data);
    Hop:= Hops.AddItem;
    Hop.Assign(HopOld);
    Hops.Selected:= Hops.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Hop);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmHop.bbOKClick(Sender: TObject);
begin
  Store;
  Hops.UnSelect;
end;

procedure TFrmHop.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmHop.sbClearClick(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmHop.eSearchChange(Sender: TObject);
var N : TTreeNode;
    H : THop;
    s, s2 : string;
    Vis : boolean;
begin
  s:= LowerCase(eSearch.Text);
  N:= tvSelect.Items[0];
  while N <> NIL do
  begin
    if N.Level = 2 then
    begin
      H:= THop(N.Data);
      if H <> NIL then
      begin
        vis:= false;
        if s <> '' then
        begin
          s2:= LowerCase(H.Name.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          N.Visible:= Vis;
        end
        else Vis:= TRUE;
        if vis and cbOnStock.Checked and (H.Inventory.Value = 0) then vis:= false;
        N.Visible:= Vis;
      end;
      N.Parent.Expand(false);
    end;
    N:= N.GetNext;
  end;
end;

procedure TFrmHop.eOriginExit(Sender: TObject);
var H : THop;
begin
  H:= THop(tvSelect.Selected.Data);
  H.Origin.Value:= eOrigin.Text;
  FillTree;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(H);
end;

procedure TFrmHop.fseCostChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value / 100;
end;

procedure TFrmHop.fseInventoryChange(Sender: TObject);
begin
  fseCostChange(sender);
end;

procedure TFrmHop.fseCohumuloneChange(Sender: TObject);
begin
  UpdateAmoebe;
end;

end.

