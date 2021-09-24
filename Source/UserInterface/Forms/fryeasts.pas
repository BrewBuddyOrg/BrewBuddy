unit FrYeasts;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, EditBtn, Menus, Amoebes;

type

  { TFrmYeasts }

  TFrmYeasts = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbAlwaysOnStock: TCheckBox;
    cbFlocculation: TComboBox;
    cbOnStock: TCheckBox;
    cbType: TComboBox;
    cbYeastForm: TComboBox;
    deCultureDate: TDateEdit;
    eLaboratory: TEdit;
    eProductID: TEdit;
    eName: TEdit;
    eSearch: TEdit;
    fseAttenuation: TFloatSpinEdit;
    fseCost: TFloatSpinEdit;
    fseInventory: TFloatSpinEdit;
    fseInventoryValue: TFloatSpinEdit;
    fseMaxTemperature: TFloatSpinEdit;
    fseMinTemperature: TFloatSpinEdit;
    gbInventory: TGroupBox;
    gbProperties: TGroupBox;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    gbInfo: TGroupBox;
    Label1: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label21: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lAttenuation: TLabel;
    lCost: TLabel;
    lCost2: TLabel;
    lInventory: TLabel;
    lInventoryValue: TLabel;
    lMaxtemp: TLabel;
    lMintemp: TLabel;
    mBestFor: TMemo;
    mNotes: TMemo;
    pcEdit: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    sbClear: TSpeedButton;
    seMaxReuse: TSpinEdit;
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
    procedure cbYeastFormChange(Sender: TObject);
    procedure eSearchChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseAttenuationChange(Sender: TObject);
    procedure fseCostChange(Sender: TObject);
    procedure fseInventoryChange(Sender: TObject);
    procedure fseMaxTemperatureChange(Sender: TObject);
    procedure fseMinTemperatureChange(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure eLaboratoryExit(Sender: TObject);
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
  FrmYeasts: TFrmYeasts;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers, StrUtils;

{ TFrmYeasts }

procedure TFrmYeasts.FormCreate(Sender: TObject);
var yt : TYeastType;
    yf : TYeastForm;
    fl : TFlocculation;
    Y : TYeast;
    i : longint;
    tminm, tmaxm, attm : double;
begin
  tminm:= 0; tmaxm:= 0; attm:= 0;
  for i:= 0 to Yeasts.NumItems - 1 do
  begin
    Y:= TYeast(Yeasts.Item[i]);
    if Y <> NIL then
    begin
      if Y.MinTemperature.DisplayValue > tminm then tminm:= Y.MinTemperature.DisplayValue;
      if Y.MaxTemperature.DisplayValue > tmaxm then tmaxm:= Y.MaxTemperature.DisplayValue;
      if Y.Attenuation.Value > attm then attm:= Y.Attenuation.Value;
    end;
  end;
  FAmoebe:= TAmoebe.Create(tsAmoebe);
  FAmoebe.Parent:= tsAmoebe;
  FAmoebe.Align:= alClient;
  FAmoebe.Kind:= akClassic;
  FAmoebe.NormColor:= RGBtocolor(255, 255, 180);
  FAmoebe.AmoebeColor:= RGBtocolor(88, 243, 175);
  FAmoebe.AddSerie('Min. temp.', Y.MinTemperature.DisplayUnitString, 0, tminm, 5, tminm);
  FAmoebe.AddSerie('Max. temp.', Y.MinTemperature.DisplayUnitString, 0, tmaxm, 3, tmaxm);
  FAmoebe.AddSerie('Vergistingsgraad', '%', 0, attm, 50, attm);

  FUserClicked:= TRUE;

  Yeasts.UnSelect;
  cbType.Items.Clear;
  for yt:= Low(YeastTypeDisplayNames) to High(YeastTypeDisplayNames) do
    cbType.Items.Add(YeastTypeDisplayNames[yt]);
  cbType.ItemIndex:= 0;
  cbYeastForm.Items.Clear;
  for yf:= Low(YeastFormDisplayNames) to High(YeastFormDisplayNames) do
    cbYeastForm.Items.Add(YeastFormDisplayNames[yf]);
  cbYeastForm.ItemIndex:= 0;
  cbFlocculation.Items.Clear;
  for fl:= Low(FlocculationDisplayNames) to High(FlocculationDisplayNames) do
    cbFlocculation.Items.Add(FlocculationDisplayNames[fl]);
  cbFlocculation.ItemIndex:= 0;


  Y:= TYeast(Yeasts.Item[0]);
  if Y <> NIL then
  begin
    lMintemp.Caption:= UnitNames[Y.MinTemperature.DisplayUnit];
    lMaxtemp.Caption:= UnitNames[Y.MaxTemperature.DisplayUnit];
  end;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FillTree;
end;

Procedure TFrmYeasts.FillTree;
var i : integer;
    supp, yname : string;
    Y : TYeast;
    Node, ChildNode, {%H-}ChildNode2 : TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'Fabrikant');
  for i:= 0 to Yeasts.NumItems - 1 do
  begin
    Y:= TYeast(Yeasts.Item[i]);
    supp:= Y.Laboratory.Value;
    if supp = '' then supp:= 'onbekend';
    yname:= Y.ProductID.Value + ' ' + Y.Name.Value;
    ChildNode:= tvSelect.Items.FindNodeWithText(supp);
    if ChildNode = NIL then
      ChildNode:= tvSelect.Items.AddChild(Node, supp);
    ChildNode2:= tvSelect.Items.AddChildObject(ChildNode, yname, Y);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Yeasts.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  tvSelectSelectionChanged(self);
end;

Procedure TFrmYeasts.Store;
var Y : TYeast;
    SupplierChanged : boolean;
    Node, RootNode : TTreeNode;
    Mode : TNodeAttachMode;
begin
  Y:= NIL;
  if FSelectedNode <> NIL then Y:= TYeast(FSelectedNode.Data);
  if Y <> NIL then
  begin
    Y.Name.Value:= eName.Text;
    Y.Amount.Value:= 0;
    Y.ProductID.Value:= eProductID.Text;
    FSelectedNode.Text:= Y.ProductID.Value + ' ' + Y.Name.Value;
    Y.Notes.Value:= mNotes.Text;
    Y.Inventory.DisplayValue:= fseInventory.Value;
    Y.Cost.Value:= fseCost.Value;
    Y.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
    Y.FormDisplayName:= cbYeastForm.Items[cbYeastForm.ItemIndex];
    SupplierChanged:= not (Y.Laboratory.Value = eLaboratory.Text);
    Y.Laboratory.Value:= eLaboratory.Text;
    Y.FlocculationDisplayName:= cbFlocculation.Items[cbFlocculation.ItemIndex];
    Y.MinTemperature.DisplayValue:= fseMinTemperature.Value;
    Y.MaxTemperature.DisplayValue:= fseMaxTemperature.Value;
    Y.Attenuation.DisplayValue:= fseAttenuation.Value;
    Y.BestFor.Value:= mBestFor.Text;
    Y.MaxReuse.Value:= seMaxReuse.Value;
    Y.CultureDate.Value:= deCultureDate.Date;
    Y.AlwaysOnStock.Value:= cbAlwaysOnStock.Checked;

    if SupplierChanged then
    begin
      //first look if supplier already exist
      Node:= tvSelect.Items.FindNodeWithText(Y.Laboratory.Value);
      if Node = NIL then  //supplier does not exist. Move the node to the right supplier
      begin
        RootNode:= tvSelect.Items[0];
        Node:= tvSelect.Items.AddChild(RootNode, Y.Laboratory.Value);
      end;
      Mode:= naAddChild;
      FSelectedNode.MoveTo(Node, Mode);
    end;
    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmYeasts.tvSelectSelectionChanged(Sender: TObject);
var Y : TYeast;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    if FSelectedNode <> NIL then
      Store;

    Y:= NIL;
    Node:= NIL;

    if tvSelect.Selected <> NIL then
    begin
      bbDelete.Enabled:= (tvSelect.Selected.Level > 0);
      bbCopy.Enabled:= (tvSelect.Selected.Level = 2);

      if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        Y:= TYeast(Node.Data);
    end
    else
    begin
      bbDelete.Enabled:= false;
      bbCopy.Enabled:= false;
    end;
    miDelete.Enabled:= bbDelete.Enabled;
    miCopy.Enabled:= bbCopy.Enabled;
    gbInfo.Visible:= (Y <> NIL);
    pcEdit.Visible:= (Y <> NIL);

    if Y <> NIL then
    begin
      eName.Text:= Y.Name.Value;
      eProductID.Text:= Y.ProductID.Value;
      mNotes.Text:= Y.Notes.Value;
      eLaboratory.Text:= Y.Laboratory.Value;
      cbType.ItemIndex:= cbType.Items.IndexOf(YeastTypeDisplayNames[Y.YeastType]);
      cbYeastForm.ItemIndex:= cbYeastForm.Items.IndexOf(YeastFormDisplayNames[Y.Form]);

      SetControl(fseInventory, lInventory, Y.Inventory, TRUE);
      SetControl(fseCost, lCost, Y.Cost, TRUE);
      fseCost.Value:= Y.Cost.Value;
      lCost2.Caption:= 'Prijs per ' + Y.AmountYeast.DisplayUnitString + ':';
      SetControl(fseInventoryValue, lInventoryValue, Y.Cost, false);
      fseInventoryValue.Value:= Y.Inventory.DisplayValue * Y.Cost.Value;
      cbFlocculation.ItemIndex:= cbFlocculation.Items.IndexOf(FlocculationDisplayNames[Y.Flocculation]);
      deCultureDate.Date:= Y.CultureDate.Value;

      cbFlocculation.ItemIndex:= cbFlocculation.Items.IndexOf(FlocculationDisplayNames[Y.Flocculation]);
      SetControl(fseMinTemperature, lMinTemp, Y.MinTemperature, TRUE);
      SetControl(fseMaxTemperature, lMaxTemp, Y.MaxTemperature, TRUE);
      SetControl(fseAttenuation, lAttenuation, Y.Attenuation, TRUE);
      mBestFor.Text:= Y.BestFor.Value;
      seMaxReuse.Value:= Y.MaxReuse.Value;
      lInventory.Caption:= Y.AmountYeast.DisplayUnitString;
      cbAlwaysOnStock.Checked:= Y.AlwaysOnStock.Value;
      UpdateAmoebe;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

procedure TFrmYeasts.UpdateAmoebe;
var Y : TYeast;
    Node : TTreeNode;
begin
  Y:= NIL;
  Node:= NIL;

  if tvSelect.Selected <> NIL then
  begin
    if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
    else Node:= NIL;
    if Node <> NIL then
      Y:= TYeast(Node.Data);
  end;

  if Y <> NIL then
  begin
    FAmoebe.Score[1]:= Y.MinTemperature.DisplayValue;
    FAmoebe.Score[2]:= Y.MaxTemperature.DisplayValue;
    FAmoebe.Score[3]:= Y.Attenuation.Value;
  end;
end;

procedure TFrmYeasts.eLaboratoryExit(Sender: TObject);
var Y : TYeast;
begin
  Y:= TYeast(tvSelect.Selected.Data);
  Y.Laboratory.Value:= eLaboratory.Text;
  FillTree;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Y);
end;

procedure TFrmYeasts.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    st : string;
    Y : TYeast;
begin
  //if a supplier or the root node is selected then add a supplier
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
    Yeasts.AddItem;
    Yeasts.Selected:= Yeasts.NumItems - 1;
    Y:= Yeasts.SelectedItem;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Yeasts.SelectedItem);
    ChildNode.Selected:= TRUE;

    if (tvSelect.Selected.Level = 1) then st:= tvSelect.Selected.Text
    else st:= tvSelect.Selected.Parent.Text;
    eName.Text:= 'Nieuwe gist';
    eProductID.Text:= '';
    mNotes.Text:= '';
    fseInventory.Value:= 0;
    fseCost.Value:= 0;
    cbType.ItemIndex:= 0;
    cbYeastForm.ItemIndex:= 0;
    eLaboratory.Text:= st;
    Y.Laboratory.Value:= st;
    cbFlocculation.ItemIndex:= 0;
    fseMinTemperature.Value:= 18;
    fseMaxTemperature.Value:= 22;
    fseAttenuation.Value:= 77;
    mBestFor.Text:= '';
    seMaxReuse.Value:= 10;
    ChildNode.Text:= eName.Text;
    UpdateAmoebe;
  end;
end;

procedure TFrmYeasts.bbDeleteClick(Sender: TObject);
var Y : TYeast;
    Node, ChildNode : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    if Node.Level = 1 then //delete entire supplier
    begin
      if Question(self, 'Wil je echt alle gisten van deze leverancier wissen?') then
      begin
        while Node.HasChildren do
        begin
          ChildNode:= Node.GetLastChild;
          Y:= TYeast(ChildNode.Data);
          Yeasts.RemoveByReference(Y);
          tvSelect.Items.Delete(ChildNode);
        end;
        tvSelect.Items.Delete(Node);
        FSelectedNode:= NIL;
      end;
    end
    else if Node.Level = 2 then
    begin
      Y:= TYeast(Node.Data);
      if Question(self, 'Wil je ' + Y.Name.Value + ' echt verwijderen?') then
      begin
        Yeasts.RemoveByReference(Y);
        tvSelect.Items.Delete(Node);
        FSelectedNode:= NIL;
      end;
    end;
  end;
  FUserClicked:= TRUE;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Yeasts.Item[0]);
end;

procedure TFrmYeasts.bbImportClick(Sender: TObject);
begin
  if Yeasts.ImportXML then
    FillTree;
end;

procedure TFrmYeasts.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Yeast, YeastOld : TYeast;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level < 2) then
  begin
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Store;
    YeastOld:= TYeast(FSelectedNode.Data);
    Yeast:= Yeasts.AddItem;
    Yeast.Assign(YeastOld);
    Yeasts.Selected:= Yeasts.NumItems - 1;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Yeast);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmYeasts.bbOKClick(Sender: TObject);
begin
  Store;
  Yeasts.UnSelect;
end;

procedure TFrmYeasts.bbCancelClick(Sender: TObject);
begin
end;

procedure TFrmYeasts.cbYeastFormChange(Sender: TObject);
var Y : TYeast;
begin
  Y:= NIL;
  if FSelectedNode <> NIL then Y:= TYeast(FSelectedNode.Data);
  if Y <> NIL then
  begin
    Y.FormDisplayName:= cbYeastForm.Items[cbYeastForm.ItemIndex];
    lInventory.Caption:= Y.AmountYeast.DisplayUnitString;
    lCost2.Caption:= 'Prijs per ' + Y.AmountYeast.DisplayUnitString + ':';
    Y.Inventory.vUnit:= Y.AmountYeast.vUnit;
    Y.Inventory.DisplayUnit:= Y.AmountYeast.DisplayUnit;
  end;
end;

procedure TFrmYeasts.eSearchChange(Sender: TObject);
var N : TTreeNode;
    Y : TYeast;
    s, s2 : string;
    Vis : boolean;
begin
  s:= LowerCase(eSearch.Text);
  N:= tvSelect.Items[0];
  while N <> NIL do
  begin
    if N.Level = 2 then
    begin
      Y:= TYeast(N.Data);
      if Y <> NIL then
      begin
        vis:= false;
        if s <> '' then
        begin
          s2:= LowerCase(Y.Name.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          s2:= LowerCase(Y.ProductID.Value);
          if NPos(s, s2, 1) > 0 then Vis:= TRUE;
          N.Visible:= Vis;
        end
        else Vis:= TRUE;
        if vis and cbOnStock.Checked and (Y.Inventory.Value = 0) then vis:= false;
        N.Visible:= Vis;
      end;
    end;
    N:= N.GetNext;
  end;
end;

procedure TFrmYeasts.sbClearClick(Sender: TObject);
begin
  eSearch.Text:= '';
end;

procedure TFrmYeasts.fseInventoryChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value;
end;

procedure TFrmYeasts.fseCostChange(Sender: TObject);
begin
  fseInventoryValue.Value:= fseCost.Value * fseInventory.Value;
end;

procedure TFrmYeasts.fseMinTemperatureChange(Sender: TObject);
begin
  if fseMinTemperature.Value > fseMaxTemperature.Value then
    fseMaxTemperature.Value:= fseMinTemperature.Value + 2;
  UpdateAmoebe;
end;

procedure TFrmYeasts.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmYeasts.fseMaxTemperatureChange(Sender: TObject);
begin
  if fseMaxTemperature.Value < fseMinTemperature.Value then
    fseMinTemperature.Value:= fseMaxTemperature.Value - 2;
  UpdateAmoebe;
end;

procedure TFrmYeasts.fseAttenuationChange(Sender: TObject);
begin
  UpdateAmoebe;
end;

end.

