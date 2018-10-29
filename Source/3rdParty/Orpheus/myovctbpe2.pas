{*********************************************************}
{*                   myovctbpe2.pas                      *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{*  Phil Hess - adapted ovctbpe2.pas to eliminate TOvcSimpleField.            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit MyOvcTbPE2;
  {Lazarus-specific Columns property editor for the table component}

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Classes, Graphics, Controls,
  {$IFNDEF LCL} {$IFDEF VERSION6} DesignIntf, DesignEditors, {$ELSE} DsgnIntf, {$ENDIF} {$ELSE} PropEdits, ComponentEditors, {$ENDIF}
  TypInfo, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,
  OvcBase, OvcTCmmn, OvcTCell, OvcTbCls, OvcTable, OvcSc;

type
  TOvcfrmColEditor = class(TForm)
    ctlColNumber: TEdit;
    ctlDefaultCell: TComboBox;
    ctlHidden: TCheckBox;
    ctlWidth: TEdit;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    GroupBox1: TGroupBox;
    DoneButton: TBitBtn;
    ApplyButton: TBitBtn;
    OvcSpinner1: TOvcSpinner;
    OvcSpinner2: TOvcSpinner;
    procedure ctlColNumberExit(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ctlColNumberChange(Sender: TObject);
  private
    { Private declarations }
    FCols : TOvcTableColumns;
    FColNum : TColNum;
    CurCellIndex : integer;
    Cells     : TStringList;

  protected
    procedure GetCells;
    procedure RefreshColData;
    procedure SetColNum(C : TColNum);

    procedure AddCellComponentName(const S : string);

  public
    { Public declarations }
    Editor : TObject;
    procedure SetCols(CS : TOvcTableColumns);

    property Cols : TOvcTableColumns
       read FCols
       write SetCols;

    property ColNum : TColNum
       read FColNum
       write SetColNum;

  end;

  {-A table column property editor}
  TOvcTableColumnProperty = class(TClassProperty)
    public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
    end;


implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ENDIF}



{===TOvcTableColumnProperty==========================================}
procedure TOvcTableColumnProperty.Edit;
  var
    ColEditor : TOvcfrmColEditor;
  begin
    ColEditor := TOvcfrmColEditor.Create(Application);
    try
      ColEditor.Editor := Self;
      ColEditor.SetCols(TOvcTableColumns(GetOrdValue));
      ColEditor.ShowModal;
{$IFNDEF LCL}
      Designer.Modified;
{$ELSE}
      Modified;      
{$ENDIF}      
      finally
      ColEditor.Free;
    end;{try..finally}
  end;
{--------}
function TOvcTableColumnProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;
{====================================================================}


{===TColEditor=======================================================}
procedure TOvcfrmColEditor.AddCellComponentName(const S : string);
  begin
    Cells.Add(S);
  end;
{--------}
procedure TOvcfrmColEditor.ApplyButtonClick(Sender: TObject);
  var
    NewColWidth : Integer;
  begin
     {20070204 workaround for recent change to Lazarus where 
       ctlColNumberChange gets called by ShowModal for some reason 
       (thus calling this method) before FormShow event handler 
       which creates and initializes Cells.} 
    if not Assigned(Cells) then
      Exit;
    FCols[ColNum].Hidden := ctlHidden.Checked;
    NewColWidth := StrToIntDef(ctlWidth.Text, FCols[ColNum].Width);
    if (NewColWidth < 5) or (NewColWidth > 32767) then  {Out of range?}
      NewColWidth := FCols[ColNum].Width;  {Restore previous column width}
    FCols[ColNum].Width := NewColWidth;
    ctlWidth.Text := IntToStr(NewColWidth);
    if (ctlDefaultCell.ItemIndex <> CurCellIndex) then
      begin
        CurCellIndex := ctlDefaultCell.ItemIndex;
        FCols[FColNum].DefaultCell := TOvcBaseTableCell(Cells.Objects[CurCellIndex]);
      end;
  end;
{--------}
procedure TOvcfrmColEditor.ctlColNumberExit(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := StrToInt(ctlColNumber.Text);
  end;
{--------}
procedure TOvcfrmColEditor.DoneButtonClick(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    Cells.Free;
  end;
{--------}
procedure TOvcfrmColEditor.FormShow(Sender: TObject);
  begin
    if not Assigned(Cells) then
      begin
        Cells := TStringList.Create;
        GetCells;
      end;
    RefreshColData;
  end;
{--------}
procedure TOvcfrmColEditor.GetCells;
  var
    {$IFDEF VERSION4}
    {$IFDEF VERSION6}
{$IFNDEF LCL}    
      Designer : IDesigner;
{$ENDIF}        
    {$ELSE}
      Designer : IFormDesigner;
    {$ENDIF}
    {$ELSE}
    Designer : TFormDesigner;
    {$ENDIF}
    TI   : PTypeInfo;
    Index: Integer;
    C    : TComponent;
    Cell : TOvcBaseTableCell absolute C;
  begin
    Cells.Sorted := true;
    Cells.AddObject('(None)', nil);
    TI := TOvcBaseTableCell.ClassInfo;
{$IFNDEF LCL}
    if (Editor is TClassProperty) then
      Designer := TClassProperty(Editor).Designer
    else {the editor is a TDefaultEditor}
      Designer := TDefaultEditor(Editor).Designer;
    Designer.GetComponentNames(GetTypeData(TI), AddCellComponentName);
    for Index := 1 to pred(Cells.Count) do
      Cells.Objects[Index] := Designer.GetComponent(Cells[Index]);      
{$ELSE}
    if (Editor is TClassProperty) then
      begin
      TClassProperty(Editor).PropertyHook.GetComponentNames(GetTypeData(TI), AddCellComponentName);      
      for Index := 1 to pred(Cells.Count) do
        Cells.Objects[Index] := TClassProperty(Editor).PropertyHook.GetComponent(Cells[Index]);
      end
    else  {the editor is a TDefaultComponentEditor}
      begin
      TDefaultComponentEditor(Editor).Designer.PropertyEditorHook.GetComponentNames(GetTypeData(TI), AddCellComponentName);
      for Index := 1 to pred(Cells.Count) do
        Cells.Objects[Index] := TDefaultComponentEditor(Editor).Designer.PropertyEditorHook.GetComponent(Cells[Index]);
      end;
{$ENDIF}      
    ctlDefaultCell.Items := Cells;
  end;
{--------}
procedure TOvcfrmColEditor.RefreshColData;
  begin
    CurCellIndex := Cells.IndexOfObject(FCols[ColNum].DefaultCell);

    ctlHidden.Checked := FCols[ColNum].Hidden;
    ctlWidth.Text := IntToStr(FCols[ColNum].Width);
    ctlDefaultCell.ItemIndex := CurCellIndex;
  end;
{--------}
procedure TOvcfrmColEditor.SetColNum(C : TColNum);
  begin
    if (FColNum <> C) then
      begin
        FColNum := C;
        RefreshColData;
        ctlColNumber.Text := IntToStr(C);  //Do this after refresh
      end;
  end;
{--------}
procedure TOvcfrmColEditor.SetCols(CS : TOvcTableColumns);
  begin
    if Assigned(FCols) then
      FCols.Free;
    FCols := CS;
    FColNum := 0;
    ctlColNumber.Text := '0';
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton1Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (ColNum > 0) then
      ColNum := ColNum - 1;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton2Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (ColNum < pred(FCols.Count)) then
      ColNum := ColNum + 1;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton3Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := 0;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton4Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    ColNum := pred(FCols.Count);
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton5Click(Sender: TObject);
  var
    C : TOvcTableColumn;
  begin
    C := TOvcTableColumn.Create(FCols.Table);
    FCols.Insert(FColNum, C);
    RefreshColData;
  end;
{--------}
procedure TOvcfrmColEditor.SpeedButton6Click(Sender: TObject);
  begin
    if (FCols.Count > 1) then
      begin
        FCols.Delete(FColNum);
        if (FColNum = FCols.Count) then
             ColNum := pred(FColNum)
        else RefreshColData;
      end;
  end;
{====================================================================}


procedure TOvcfrmColEditor.ctlColNumberChange(Sender: TObject);
var
  NewColNum : Integer;
begin
  ApplyButtonClick(Self);
  if not TryStrToInt(ctlColNumber.Text, NewColNum) then  {Invalid?}
    ctlColNumber.Text := IntToStr(ColNum)  {Restore previous column number}
  else if NewColNum = -1 then  {Wrap around to last column?}
    ctlColNumber.Text := IntToStr(Pred(FCols.Count))
  else if NewColNum = FCols.Count then  {Wrap around to first column?}
    ctlColNumber.Text := '0'
  else if not (NewColNum in [0..Pred(FCols.Count)]) then  {Out of range?}
    ctlColNumber.Text := IntToStr(ColNum);  {Restore previous column number} 
  ColNum := StrToInt(ctlColNumber.Text);
end;

initialization
{$IFDEF LCL}
{$I myovctbpe2.lrs}  {Include form's resource file}
{$ENDIF}

end.
