unit frmashs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls, Grids, Menus;

type

  { TFrmMashs }

  TFrmMashs = class(TForm)
    bbOK: TBitBtn;
    bbAdd: TBitBtn;
    bbDelete: TBitBtn;
    bbCancel: TBitBtn;
    bbAddStep: TBitBtn;
    bbDeleteStep: TBitBtn;
    eName: TEdit;
    gbInfo: TGroupBox;
    gbProperties: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    mNotes: TMemo;
    Panel1: TPanel;
    pSelect: TPanel;
    pEdit: TPanel;
    sgMashSteps: TStringGrid;
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
    procedure bbAddStepClick(Sender: TObject);
    procedure bbDeleteClick(Sender: TObject);
    procedure bbDeleteStepClick(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sgMashStepsDblClick(Sender: TObject);
    procedure sgMashStepsSelection(Sender: TObject; aCol, aRow: Integer);
    procedure tvSelectKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure tvSelectSelectionChanged(Sender: TObject);
    procedure bbImportClick(Sender: TObject);
    procedure bbCopyClick(Sender: TObject);
  private
    { private declarations }
    FSelectedNode : TTreeNode;
    FNew : boolean;
    FSelectedRow : integer;
    FUserClicked :  boolean;
    Procedure Store;
    Procedure FillTree;
  public
    { public declarations }
  end; 

var
  FrmMashs: TFrmMashs;

implementation

{$R *.lfm}
uses Hulpfuncties, Data, Containers, frmashstep;

{ TFrmMashs }

procedure TFrmMashs.FormCreate(Sender: TObject);
var i, w : integer;
begin
  FUserClicked:= TRUE;
  Mashs.UnSelect;

  sgMashSteps.ColCount:= 6;
  sgMashSteps.ColWidths[0]:= 130;
  sgMashSteps.ColWidths[1]:= 130;
  w:= round((sgMashSteps.Width - sgMashSteps.ColWidths[0] - sgMashSteps.ColWidths[1]) / 4);
  for i:= 2 to 5 do sgMashSteps.ColWidths[i]:= w;

  sgMashSteps.AlternateColor:= RGBtoColor(243, 251, 158);
  sgMashSteps.FixedColor:= RGBtoColor(158, 226, 251);
  sgMashSteps.SelectedColor:= RGBtoColor(15, 196, 54);
  sgMashSteps.Cells[1, 0]:= 'Type';
  sgMashSteps.Cells[2, 0]:= 'Start temp.';
  sgMashSteps.Cells[3, 0]:= 'Eind temp.';
  sgMashSteps.Cells[4, 0]:= 'Opw. tijd';
  sgMashSteps.Cells[5, 0]:= 'Stap tijd';

  FNew:= false;
  FSelectedRow:= -1;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  FillTree;
end;

Procedure TFrmMashs.FillTree;
var i : integer;
    mname : string;
    Mash : TMash;
    Node, ChildNode: TTreeNode;
begin
  tvSelect.Items.Clear;
  Node:= tvSelect.Items.Add(nil,'');
  for i:= 0 to Mashs.NumItems - 1 do
  begin
    Mash:= TMash(Mashs.Item[i]);
    mname:= Mash.Name.Value;
    ChildNode:= tvSelect.Items.AddChildObject(Node, mname, Mash);
  end;
  tvSelect.SortType:= stText;

  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Mashs.Item[0]);
  FSelectedNode:= tvSelect.Selected;
  FNew:= false;
  FSelectedRow:= -1;
  tvSelectSelectionChanged(self);
end;

Procedure TFrmMashs.Store;
var Mash : TMash;
begin
  Mash:= NIL;
  if FSelectedNode <> NIL then Mash:= TMash(FSelectedNode.Data);
  if Mash <> NIL then
  begin
    Mash.Name.Value:= eName.Text;
    FSelectedNode.Text:= eName.Text;
    Mash.Notes.Value:= mNotes.Text;

    //mash steps will be stored when they are changed
    tvSelect.SortType:= stNone;
    tvSelect.SortType:= stText;
  end;
end;

procedure TFrmMashs.tvSelectSelectionChanged(Sender: TObject);
var Mash : TMash;
    MStep : TMashStep;
    i : integer;
    sn : string;
    Node : TTreeNode;
begin
  if FUserClicked then
  begin
    //store values in record
    if (FSelectedNode <> NIL) and (not FNew) then
      Store;
    FNew:= false;

    Mash:= NIL;
    Node:= NIL;
    if tvSelect.Selected <> NIL then
    begin
      bbDelete.Enabled:= (tvSelect.Selected.Level = 1);

      if tvSelect.Selected.Level = 1 then Node:= tvSelect.Selected
      else Node:= NIL;
      if Node <> NIL then
        Mash:= TMash(Node.Data);
    end
    else
    begin
      bbDelete.Enabled:= false;
    end;
    bbCopy.Enabled:= bbDelete.Enabled;
    miDelete.Enabled:= bbDelete.Enabled;
    miCopy.Enabled:= bbDelete.Enabled;
    pEdit.Visible:= (Node <> NIL);

    if Mash <> NIL then
    begin
      eName.Text:= Mash.Name.Value;
      mNotes.Text:= Mash.Notes.Value;
      sgMashSteps.RowCount:= Mash.NumMashSteps + 1;
      for i:= 0 to Mash.NumMashSteps - 1 do
      begin
        MStep:= Mash.MashStep[i];
        sn:= MStep.Name.Value;
        if sn = '' then sn:= 'Stap ' + IntToStr(i+1);
        sgMashSteps.Cells[0, i+1]:= sn;
        sgMashSteps.Cells[1, i+1]:= MStep.TypeDisplayName;
        sgMashSteps.Cells[2, i+1]:= MStep.StepTemp.DisplayString;
        sgMashSteps.Cells[3, i+1]:= MStep.EndTemp.DisplayString;
        sgMashSteps.Cells[4, i+1]:= MStep.RampTime.DisplayString;
        sgMashSteps.Cells[5, i+1]:= MStep.StepTime.DisplayString;
      end;
    end;
  end;
  FSelectedNode:= tvSelect.Selected;
end;

procedure TFrmMashs.bbImportClick(Sender: TObject);
begin
  if Mashs.ImportXML then
    FillTree;
end;

procedure TFrmMashs.bbCopyClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
    Mash, MashOld : TMash;
begin
  //if the root node is selected then add a supplier
  if (tvSelect.Selected.Level = 0) then
  begin
  end
  else
  begin
  //if a fermentable ingredient is selected, then add one for that supplier
    Store;
    MashOld:= TMash(FSelectedNode.Data);
    Mash:= Mashs.AddItem;
    Mash.Assign(MashOld);
    Mashs.Selected:= Mashs.NumItems - 1;

    if (tvSelect.Selected.Level = 0) then Node:= tvSelect.Selected
    else Node:= tvSelect.Selected.Parent;
    ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Mash);
    ChildNode.Selected:= TRUE;

    tvSelectSelectionChanged(Self);
  end;
end;

procedure TFrmMashs.tvSelectKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
  45: bbAddClick(self); //Ins
  46: bbDeleteClick(self); //del
  end;
end;

procedure TFrmMashs.bbAddClick(Sender: TObject);
var Node, ChildNode : TTreeNode;
begin
  Mashs.AddItem;
  Mashs.Selected:= Mashs.NumItems - 1;
  eName.Text:= 'Nieuw maischschema';
  mNotes.Text:= '';
  sgMashSteps.RowCount:= 1;

  Node:= tvSelect.Selected.Parent;
  ChildNode:= tvSelect.Items.AddChildObject(Node, eName.Text, Mashs.SelectedItem);
  FNew:= TRUE;
  FSelectedNode:= ChildNode;
  ChildNode.Selected:= TRUE;
end;

procedure TFrmMashs.bbDeleteClick(Sender: TObject);
var Mash : TMash;
    Node : TTreeNode;
begin
  FUserclicked:= false;
  Node:= tvSelect.Selected;
  if Node <> NIL then
  begin
    Mash:= TMash(Node.Data);
    if Question(self, 'Wil je ' + Mash.Name.Value + ' echt verwijderen?') then
    begin
      Mashs.RemoveByReference(Mash);
      tvSelect.Items.Delete(Node);
      FSelectedNode:= NIL;
    end;
  end;
  FUserClicked:= TRUE;
  tvSelect.Selected:= tvSelect.Items.FindNodeWithData(Mashs.Item[0]);
end;

procedure TFrmMashs.sgMashStepsDblClick(Sender: TObject);
var MStep : TMashStep;
    Mash : TMash;
    FRM : TFrmMashStep;
begin
  Mash:= NIL;
  if tvSelect.Selected <> NIL then Mash:= TMash(tvSelect.Selected.Data);
  if Mash <> NIL then
  begin
    MStep:= Mash.MashStep[FSelectedRow - 1];
    if MStep <> NIL then
    begin
    //open mash step form
      FRM:= TFrmMashStep.Create(self);
      FRM.Execute(MStep);
      FRM.Free;
      tvSelectSelectionChanged(Self);
    end;
  end;
end;

procedure TFrmMashs.sgMashStepsSelection(Sender: TObject; aCol, aRow: Integer);
begin
  if (aRow > 0) and (aRow <= sgMashSteps.RowCount) then FSelectedRow:= aRow
  else FSelectedRow:= -1;
end;

procedure TFrmMashs.bbAddStepClick(Sender: TObject);
var new : integer;
    Mash : TMash;
    MStep : TMashStep;
    FRM : TFrmMashStep;
begin
  Mash:= NIL;
  if tvSelect.Selected <> NIL then Mash:= TMash(tvSelect.Selected.Data);
  if Mash <> NIL then
  begin
    if FSelectedRow = -1 then
    begin
      new:= 1;
      sgMashSteps.InsertColRow(false, 1);
      MStep:= Mash.AddMashStep;
    end
    else if FSelectedRow = sgMashSteps.RowCount - 1 then
    begin
      sgMashSteps.RowCount:= sgMashSteps.RowCount + 1;
      new:= sgMashSteps.RowCount-1;
      MStep:= Mash.AddMashStep;
    end
    else
    begin
      sgMashSteps.InsertColRow(false, FSelectedRow + 1);
      new:= FSelectedRow + 1;
      MStep:= Mash.InsertMashStep(new-1);
    end;
    sgMashStepsSelection(self, 1, new);

    if MStep <> NIL then
    begin
    //open mash step form
      FRM:= TFrmMashStep.Create(self);
      if not FRM.Execute(MStep) then
      begin
        Mash.RemoveMashStep(new);
        sgMashSteps.DeleteRow(new);
      end;
      FRM.Free;
      Mash.Sort;
      tvSelectSelectionChanged(Self);
    end;
  end;
end;

procedure TFrmMashs.bbDeleteStepClick(Sender: TObject);
var Mash : TMash;
    i : integer;
begin
  if FSelectedRow > sgMashSteps.FixedRows - 1 then
  begin
    Mash:= NIL;
    if tvSelect.Selected <> NIL then Mash:= TMash(tvSelect.Selected.Data);
    if Mash <> NIL then
    begin
      Mash.RemoveMashStep(FSelectedRow-sgMashSteps.FixedRows);
      sgMashSteps.DeleteRow(FSelectedRow);
      if FSelectedRow > 1 then
        i:= FSelectedRow - 1
      else i:= FSelectedRow;
      if i = 0 then i:= -1;
      if i > 0 then
      begin
        sgMashSteps.Row:= i;
        sgMashStepsSelection(Self, 0, i);
      end
      else FSelectedRow:= -1;
      tvSelectSelectionChanged(Self);
    end;
  end;
end;

procedure TFrmMashs.bbOKClick(Sender: TObject);
begin
  Store;
  Mashs.UnSelect;
end;

procedure TFrmMashs.bbCancelClick(Sender: TObject);
begin
end;

end.

