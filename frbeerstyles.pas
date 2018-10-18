unit FrBeerstyles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, ComCtrls, Menus;

type

  { TFrmBeerstyles }

  TFrmBeerstyles = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    cbType: TComboBox;
    eCategory: TEdit;
    eCategoryNumber: TEdit;
    eExamples: TEdit;
    eProfile: TEdit;
    eIngredients: TEdit;
    eStyleLetter: TEdit;
    eName: TEdit;
    fseABVmax: TFloatSpinEdit;
    fseABVMin: TFloatSpinEdit;
    fseFGMax: TFloatSpinEdit;
    fseIBUMax: TFloatSpinEdit;
    fseColorMax: TFloatSpinEdit;
    fseCarbMax: TFloatSpinEdit;
    fseCarbMin: TFloatSpinEdit;
    fseOGMin: TFloatSpinEdit;
    fseOGMax: TFloatSpinEdit;
    fseFGMin: TFloatSpinEdit;
    fseIBUMin: TFloatSpinEdit;
    fseColorMin: TFloatSpinEdit;
    lOGMax: TLabel;
    lFGMin: TLabel;
    lFGMax: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    lIBUmin: TLabel;
    lIBUmax: TLabel;
    Label2: TLabel;
    Label20: TLabel;
    lCarbMin: TLabel;
    lCarbMax: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    lABVmax: TLabel;
    lColorMin: TLabel;
    lColorMax: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lOGmin: TLabel;
    lABVmin: TLabel;
    mNotes: TMemo;
    Panel1: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    tvSelect: TTreeView;
    bbImport: TBitBtn;
    pmIngredients: TPopupMenu;
    miNew: TMenuItem;
    miDelete: TMenuItem;
    MenuItem1: TMenuItem;
    miImport: TMenuItem;
    procedure bbAddClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure fseABVmaxChange(Sender: TObject);
    procedure fseABVMinChange(Sender: TObject);
    procedure fseCarbMaxChange(Sender: TObject);
    procedure fseCarbMinChange(Sender: TObject);
    procedure fseColorMaxChange(Sender: TObject);
    procedure fseColorMinChange(Sender: TObject);
    procedure fseFGMaxChange(Sender: TObject);
    procedure fseFGMinChange(Sender: TObject);
    procedure fseIBUMaxChange(Sender: TObject);
    procedure fseIBUMinChange(Sender: TObject);
    procedure fseOGMaxChange(Sender: TObject);
    procedure fseOGMinChange(Sender: TObject);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure eNameChange(Sender: TObject);
    procedure eStyleLetterExit(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
  private
    { private declarations }
    FSelectedNode : TTreeNode;
    FUserClicked, FMustStore :  boolean;
    Procedure Store;
    Procedure FillTree;
  public
    { public declarations }
  end; 

var
  FrmBeerstyles: TFrmBeerstyles;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers;

{ TFrmBeerstyles }

procedure TFrmBeerstyles.FormCreate(Sender: TObject);
var st : TStyleType;
    S : TBeerStyle;
    Node : TTreenode;
begin
  FUserClicked:= TRUE;
  FMustStore:= false;
  BeerStyles.UnSelect;
  cbType.Items.Clear;
  for st:= Low(StyleTypeDisplayNames) to High(StyleTypeDisplayNames) do
    cbType.Items.Add(StyleTypeDisplayNames[st]);
  cbType.ItemIndex:= 0;

  FillTree;
  bbDelete.Enabled:= (tvSelect.Selected.Level >= 1);
  miDelete.Enabled:= bbDelete.Enabled;

  if tvSelect.Selected <> NIL then
  begin
    if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
    else Node:= NIL;
    if Node <> NIL then
      S:= TBeerStyle(Node.Data);
  end;
  bbDelete.Enabled:= (Node <> NIL);
  miDelete.Enabled:= (Node <> NIL);
  pEdit.Visible:= (Node <> NIL);

  if S <> NIL then
  begin
    SetFloatSpinEdit(fseOGMin, S.OGMin, TRUE);
    SetFloatSpinEdit(fseOGMax, S.OGMax, TRUE);
    SetFloatSpinEdit(fseFGMin, S.FGMin, TRUE);
    SetFloatSpinEdit(fseFGMax, S.FGMax, TRUE);
    lOGMin.Caption:= 'Min. start ' + S.OGMin.DisplayUnitString;
    lOGMax.Caption:= 'Max. start ' + S.OGMax.DisplayUnitString;
    lFGMin.Caption:= 'Min. eind ' + S.FGMin.DisplayUnitString;
    lFGMax.Caption:= 'Max. eind ' + S.FGMax.DisplayUnitString;
    SetControl(fseIBUMin, lIBUMin, S.IBUMin, TRUE);
    SetControl(fseIBUMax, lIBUMax, S.IBUMax, TRUE);
    SetControl(fseColorMin, lColorMin, S.ColorMin, TRUE);
    SetControl(fseColorMax, lColorMax, S.ColorMax, TRUE);
    SetControl(fseCarbMin, lCarbMin, S.CarbMin, TRUE);
    SetControl(fseCarbMax, lCarbMax, S.CarbMax, TRUE);
    SetControl(fseABVMin, lABVMin, S.ABVMin, TRUE);
    SetControl(fseABVMax, lABVMax, S.ABVMax, TRUE);

    eName.Text:= S.Name.Value;
    eStyleLetter.Text:= S.StyleLetter.Value;
    eCategory.Text:= S.Category.Value;
    eCategoryNumber.Text:= S.CategoryNumber.Value;
    mNotes.Text:= S.Notes.Value;
    cbType.ItemIndex:= cbType.Items.IndexOf(StyleTypeDisplayNames[S.StyleType]);
    eProfile.Text:= S.Profile.Value;
    eIngredients.Text:= S.Ingredients.Value;
    eExamples.Text:= S.Examples.Value;
  end;
  FSelectedNode:= tvSelect.Selected;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FMustStore:= TRUE;
end;

Procedure TFrmBeerstyles.FillTree;
var i : integer;
    letter, sname : string;
    S : TBeerStyle;
    Node, ChildNode, ChildNode2 : TTreeNode;
begin
  FUserClicked:= false;
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'Groep');
  for i:= 0 to BeerStyles.NumItems - 1 do
  begin
    S:= TBeerStyle(BeerStyles.Item[i]);
    letter:= S.StyleLetter.Value;
    if letter = '' then letter:= 'onbekend';
    sname:= S.CategoryNumber.Value + ' ' + S.Name.Value;
    ChildNode:= tvSelect.Items.FindNodeWithText(letter);
    if ChildNode = NIL then
      ChildNode:= tvSelect.Items.AddChild(Node, letter);
    ChildNode2:= tvSelect.Items.AddChildObject(ChildNode, sname, S);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(BeerStyles.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  FUserClicked:= TRUE;
  tvSelectSelectionChanged(self);
end;

procedure TFrmBeerstyles.fseABVmaxChange(Sender: TObject);
begin
  if FUserClicked and (fseABVMax.Value <= fseABVMin.Value) then
    fseABVMin.Value:= fseABVMax.Value - 2;
end;

procedure TFrmBeerstyles.fseABVMinChange(Sender: TObject);
begin
  if FUserClicked and (fseABVMax.Value <= fseABVMin.Value) then
    fseABVMax.Value:= fseABVMin.Value + 2;
end;

procedure TFrmBeerstyles.fseCarbMaxChange(Sender: TObject);
begin
  if FUserClicked and (fseCarbMax.Value <= fseCarbMin.Value) then
    fseCarbMin.Value:= fseCarbMax.Value - 2;
end;

procedure TFrmBeerstyles.fseCarbMinChange(Sender: TObject);
begin
  if FUserClicked and (fseCarbMax.Value <= fseCarbMin.Value) then
    fseCarbMax.Value:= fseCarbMin.Value + 2;
end;

procedure TFrmBeerstyles.fseColorMaxChange(Sender: TObject);
begin
  if FUserClicked and (fseColorMax.Value <= fseColorMin.Value) then
    fseColorMin.Value:= fseColorMax.Value - 20;
end;

procedure TFrmBeerstyles.fseColorMinChange(Sender: TObject);
begin
  if FUserClicked and (fseColorMax.Value <= fseColorMin.Value) then
    fseColorMax.Value:= fseColorMin.Value + 20;
end;

procedure TFrmBeerstyles.fseFGMaxChange(Sender: TObject);
begin
  if FUserClicked and (fseFGMax.Value <= fseFGMin.Value) then
    fseFGMin.Value:= fseFGMax.Value - 0.01;
end;

procedure TFrmBeerstyles.fseFGMinChange(Sender: TObject);
begin
  if FUserClicked and (fseFGMax.Value <= fseFGMin.Value) then
    fseFGMax.Value:= fseFGMin.Value + 0.01;
end;

procedure TFrmBeerstyles.fseIBUMaxChange(Sender: TObject);
begin
  if FUserClicked and (fseIBUMax.Value <= fseIBUMin.Value) then
    fseIBUMin.Value:= fseIBUMax.Value - 10;
end;

procedure TFrmBeerstyles.fseIBUMinChange(Sender: TObject);
begin
  if FUserClicked and (fseIBUMax.Value <= fseIBUMin.Value) then
    fseIBUMax.Value:= fseIBUMin.Value + 10;
end;

procedure TFrmBeerstyles.fseOGMaxChange(Sender: TObject);
begin
  if FUserClicked and (fseOGMax.Value <= fseOGMin.Value) then
    fseOGMin.Value:= fseOGMax.Value - 0.01;
end;

procedure TFrmBeerstyles.fseOGMinChange(Sender: TObject);
begin
  if FUserClicked and (fseOGMax.Value <= fseOGMin.Value) then
    fseOGMax.Value:= fseOGMin.Value + 0.01;
end;

Procedure TFrmBeerstyles.Store;
var S : TBeerStyle;
    SupplierChanged : boolean;
    Node, RootNode : TTreeNode;
    Mode : TNodeAttachMode;
    s1, s2 : string;
begin
  if FUserClicked then
  begin
    S:= NIL;
    if FSelectedNode <> NIL then S:= TBeerStyle(FSelectedNode.Data);
    if S <> NIL then
    begin
      S.Name.Value:= eName.Text;
      s1:= S.StyleLetter.Value;
      s2:= eStyleLetter.Text;
      SupplierChanged:= not (s1 = s2);
      S.StyleLetter.Value:= eStyleLetter.Text;
      S.Category.Value:= eCategory.Text;
      S.CategoryNumber.Value:= eCategoryNumber.Text;
      FSelectedNode.Text:= S.CategoryNumber.Value + ' ' + S.Name.Value;
      S.Notes.Value:= mNotes.Text;
      S.TypeDisplayName:= cbType.Items[cbType.ItemIndex];

      S.OGMin.DisplayValue:= fseOGMin.Value;
      S.OGMax.DisplayValue:= fseOGMax.Value;
      S.FGMin.DisplayValue:= fseFGMin.Value;
      S.FGMax.DisplayValue:= fseFGMax.Value;
      S.IBUMin.DisplayValue:= fseIBUMin.Value;
      S.IBUMax.DisplayValue:= fseIBUMax.Value;
      S.ColorMin.DisplayValue:= fseColorMin.Value;
      S.ColorMax.DisplayValue:= fseColorMax.Value;
      S.CarbMin.DisplayValue:= fseCarbMin.Value;
      S.CarbMax.DisplayValue:= fseCarbMax.Value;
      S.ABVMin.DisplayValue:= fseABVMin.Value;
      S.ABVMax.DisplayValue:= fseABVMax.Value;
      S.Profile.Value:= eProfile.Text;
      S.Ingredients.Value:= eIngredients.Text;
      S.Examples.Value:= eExamples.Text;

      if SupplierChanged then
      begin
        //first look if type letter already exist
        Node:= tvSelect.Items.FindNodeWithText(S.StyleLetter.Value);
        if Node = NIL then  //supplier does not exist. Move the node to the right supplier
        begin
          RootNode:= tvSelect.Items[0];
          Node:= tvSelect.Items.AddChild(RootNode, S.StyleLetter.Value);
        end;
        Mode:= naAddChild;
        FSelectedNode.MoveTo(Node, Mode);
        SupplierChanged:= false;
      end;
      tvSelect.SortType:= stNone;
      tvSelect.SortType:= stText;
    end;
  end;
end;

procedure TFrmBeerstyles.tvSelectSelectionChanged(Sender: TObject);
var S : TBeerStyle;
    Node : TTreenode;
begin
  //store values in record
  if FUserClicked then
  begin
    if (FSelectedNode <> NIL) and FMustStore then
      Store;

    S:= NIL;
    Node:= NIL;

    bbDelete.Enabled:= (tvSelect.Selected.Level >= 1);
    miDelete.Enabled:= bbDelete.Enabled;

    if tvSelect.Selected <> NIL then
    begin
      if tvSelect.Selected.Level = 2 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        S:= TBeerStyle(Node.Data);
    end;
    bbDelete.Enabled:= (Node <> NIL);
    miDelete.Enabled:= (Node <> NIL);
    pEdit.Visible:= (Node <> NIL);

    if S <> NIL then
    begin
      SetFloatSpinEdit(fseOGMin, S.OGMin, TRUE);
      SetFloatSpinEdit(fseOGMax, S.OGMax, TRUE);
      SetFloatSpinEdit(fseFGMin, S.FGMin, TRUE);
      SetFloatSpinEdit(fseFGMax, S.FGMax, TRUE);
      lOGMin.Caption:= 'Min. start ' + S.OGMin.DisplayUnitString;
      lOGMax.Caption:= 'Max. start ' + S.OGMax.DisplayUnitString;
      lFGMin.Caption:= 'Min. eind ' + S.FGMin.DisplayUnitString;
      lFGMax.Caption:= 'Max. eind ' + S.FGMax.DisplayUnitString;
      SetControl(fseIBUMin, lIBUMin, S.IBUMin, TRUE);
      SetControl(fseIBUMax, lIBUMax, S.IBUMax, TRUE);
      SetControl(fseColorMin, lColorMin, S.ColorMin, TRUE);
      SetControl(fseColorMax, lColorMax, S.ColorMax, TRUE);
      SetControl(fseCarbMin, lCarbMin, S.CarbMin, TRUE);
      SetControl(fseCarbMax, lCarbMax, S.CarbMax, TRUE);
      SetControl(fseABVMin, lABVMin, S.ABVMin, TRUE);
      SetControl(fseABVMax, lABVMax, S.ABVMax, TRUE);

      eName.Text:= S.Name.Value;
      eStyleLetter.Text:= S.StyleLetter.Value;
      eCategory.Text:= S.Category.Value;
      eCategoryNumber.Text:= S.CategoryNumber.Value;
      mNotes.Text:= S.Notes.Value;
      cbType.ItemIndex:= cbType.Items.IndexOf(StyleTypeDisplayNames[S.StyleType]);
      eProfile.Text:= S.Profile.Value;
      eIngredients.Text:= S.Ingredients.Value;
      eExamples.Text:= S.Examples.Value;
    end;
    FSelectedNode:= tvSelect.Selected;
  end;
end;

procedure TFrmBeerstyles.eNameChange(Sender: TObject);
var ChildNode : TTreeNode;
    i : integer;
begin
  if FUserclicked then
  begin
    ChildNode:= tvSelect.Selected;
    i:= ChildNode.Level;
    if (i = 2) then
      ChildNode.Text:= eName.Text;
  end;
end;

procedure TFrmBeerstyles.eStyleLetterExit(Sender: TObject);
var Sel : TBeerStyle;
begin
  if FUserclicked then
  begin
    FUserClicked:= false;
    Sel:= TBeerStyle(tvSelect.Selected.Data);
    Sel.StyleLetter.Value:= eStyleLetter.Text;
    FillTree;
    tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Sel);
    FUserClicked:= TRUE;
  end;
end;

procedure TFrmBeerstyles.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmBeerstyles.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    st : string;
    BS : TBeerStyle;
begin
  //if a supplier or the root node is selected then add a supplier
  if (tvSelect.Selected.Level = 0) then
  begin
    st:= GetAnswer(self, 'Nieuwe hoofdcategorie:');
    if st <> '' then
    begin
      Node:= tvSelect.Items[0];
      ChildNode:= tvSelect.Items.AddChild(Node, st);
    end;
  end
  else
  begin
  //if a style is selected, then add one for that style letter
    BS:= BeerStyles.AddItem;
    BeerStyles.Selected:= BeerStyles.NumItems - 1;
    if (tvSelect.Selected.Level = 1) then st:= tvSelect.Selected.Text
    else st:= tvSelect.Selected.Parent.Text;

    if (tvSelect.Selected.Level = 1) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, BS);
    ChildNode.Selected:= TRUE;

    eName.Text:= 'Nieuwe bierstijl';
    BS.Name.Value:= 'Nieuwe bierstijl';
    ChildNode.Text:= 'Nieuwe bierstijl';
    BS.StyleLetter.Value:= st;
    eStyleLetter.Text:= st;
    eCategory.Text:= '';
    eCategoryNumber.Text:= '';
    mNotes.Text:= '';
    cbType.ItemIndex:= 0;
  end;
end;

procedure TFrmBeerstyles.bbDeleteClick(Sender: TObject);
var S : TBeerStyle;
    Node, ChildNode : TTreeNode;
begin
  FUserClicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    if Node.Level = 1 then //delete entire style categorie
    begin
      if Question(self, 'Wil je echt alle bierstijlen van deze hoofdcategorie wissen?') then
      begin
        while Node.HasChildren do
        begin
          ChildNode:= Node.GetLastChild;
          S:= TBeerStyle(ChildNode.Data);
          BeerStyles.RemoveByReference(S);
          tvSelect.Items.Delete(ChildNode);
        end;
        tvSelect.Items.Delete(Node);
        FSelectedNode:= NIL;
      end;
    end
    else if (Node.Level = 2) then
    begin
      S:= TBeerStyle(Node.Data);
      if Question(self, 'Wil je ' + S.Name.Value + ' echt verwijderen?') then
      begin
        BeerStyles.RemoveByReference(S);
        tvSelect.Selected.Delete;
        FSelectedNode:= NIL;
      end;
    end;
  end;
  FUserClicked:= TRUE;
end;

procedure TFrmBeerstyles.bbImportClick(Sender: TObject);
begin
  if BeerStyles.ImportXML then
    FillTree;
end;

procedure TFrmBeerstyles.bbOKClick(Sender: TObject);
begin
  Store;
  BeerStyles.UnSelect;
end;

procedure TFrmBeerstyles.bbCancelClick(Sender: TObject);
begin
end;

end.

