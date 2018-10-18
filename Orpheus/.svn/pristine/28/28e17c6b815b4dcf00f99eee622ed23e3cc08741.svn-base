{*********************************************************}
{*                   myovctbpe1.pas                      *}
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
{*  Phil Hess - adapted ovctbpe1.pas to eliminate TOvcSimpleField.            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit MyOvcTbPE1;
  {Lazarus-specific Rows property editor for the table component.}

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  Classes, Graphics, Controls,
  {$IFNDEF LCL} {$IFDEF VERSION6} DesignIntf, DesignEditors, {$ELSE} DsgnIntf, {$ENDIF} {$ELSE} PropEdits, {$ENDIF}
  SysUtils, Forms, Dialogs, StdCtrls, Buttons, ExtCtrls,
  OvcBase, OvcTCmmn, OvcTable, OvcTbRws, OvcSc;

type
  TOvcfrmRowEditor = class(TForm)
    ctlHidden: TCheckBox;
    ctlUseDefHeight: TRadioButton;
    ctlUseCustHeight: TRadioButton;
    DoneButton: TBitBtn;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton5: TSpeedButton;
    SpeedButton6: TSpeedButton;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Reset: TBitBtn;
    ctlHeight: TEdit;
    ctlDefaultHeight: TEdit;
    ctlRowLimit: TEdit;
    ctlRowNumber: TEdit;
    ApplyButton: TBitBtn;
    OvcSpinner1: TOvcSpinner;
    OvcSpinner2: TOvcSpinner;
    OvcSpinner3: TOvcSpinner;
    OvcSpinner4: TOvcSpinner;
    procedure ctlUseDefHeightClick(Sender: TObject);
    procedure ctlUseCustHeightClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure SpeedButton6Click(Sender: TObject);
    procedure ctlRowNumberExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ResetClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
    procedure DoneButtonClick(Sender: TObject);
    procedure ctlRowNumberChange(Sender: TObject);
  private
    { Private declarations }
    FRows : TOvcTableRows;
    FRowNum : TRowNum;
    CurDefHt  : boolean;
    FormShowCalled : Boolean;

  protected
    procedure RefreshRowData;
    procedure SetRowNum(R : TRowNum);

  public
    { Public declarations }
    procedure SetRows(RS : TOvcTableRows);

    property Rows : TOvcTableRows
       read FRows
       write SetRows;

    property RowNum : TRowNum
       read FRowNum
       write SetRowNum;

  end;

  {-A table row property editor}
  TOvcTableRowProperty = class(TClassProperty)
    public
      procedure Edit; override;
      function GetAttributes: TPropertyAttributes; override;
    end;


implementation

{$IFNDEF LCL}
{$R *.DFM}
{$ENDIF}



{===TOvcTableRowProperty=============================================}
procedure TOvcTableRowProperty.Edit;
  var
    RowEditor : TOvcfrmRowEditor;
  begin
    RowEditor := TOvcfrmRowEditor.Create(Application);
    try
      RowEditor.SetRows(TOvcTableRows(GetOrdValue));
      RowEditor.ShowModal;
{$IFNDEF LCL}
      Designer.Modified;
{$ELSE}
      Modified;      
{$ENDIF}      
    finally
      RowEditor.Free;
    end;{try..finally}
  end;
{--------}
function TOvcTableRowProperty.GetAttributes: TPropertyAttributes;
  begin
    Result := [paMultiSelect, paDialog, paReadOnly];
  end;
{====================================================================}


{===TRowEditor=======================================================}
procedure TOvcfrmRowEditor.ApplyButtonClick(Sender: TObject);
  var
    NewRowLimit : Integer;
    NewDefHeight : Integer;
    NewHeight : Integer;
    RS : TRowStyle;
  begin
     {20070204 workaround for recent change to Lazarus where 
       ctlRowNumberChange gets called by ShowModal for some reason 
       (thus calling this method) before FormShow event handler 
       which initializes things.} 
    if not FormShowCalled then
      Exit;
    NewRowLimit := StrToIntDef(ctlRowLimit.Text, FRows.Limit);
    if (NewRowLimit < 1) or (NewRowLimit > MaxInt) then  {Out of range?}
      NewRowLimit := FRows.Limit;  {Restore previous row limit}
    FRows.Limit := NewRowLimit;
    ctlRowLimit.Text := IntToStr(NewRowLimit); 
    if FRowNum >= FRows.Limit then
      RowNum := pred(FRows.Limit);

    NewDefHeight := StrToIntDef(ctlDefaultHeight.Text, FRows.DefaultHeight);
    if (NewDefHeight < 5) or (NewDefHeight > 32767) then  {Out of range?}
      NewDefHeight := FRows.DefaultHeight;  {Restore previous default height}
    FRows.DefaultHeight := NewDefHeight;
    ctlDefaultHeight.Text := IntToStr(NewDefHeight); 

    with RS do
      begin
        if ctlUseDefHeight.Checked then
          Height := StrToIntDef(ctlDefaultHeight.Text, Height)
        else
          begin
            NewHeight := StrToIntDef(ctlHeight.Text, Height);
            if (NewHeight < 5) or (NewHeight > 32767) then  {Out of range?}
              NewHeight := Height;  {Restore previous row height}
            Height := NewHeight;
            ctlHeight.Text := IntToStr(NewHeight);
            if (Height = FRows.DefaultHeight) then
              ctlUseDefHeight.Checked := true;
          end;
        Hidden := ctlHidden.Checked;
        FRows[RowNum] := RS;
      end;
  end;
{--------}
procedure TOvcfrmRowEditor.ctlRowNumberExit(Sender: TObject);
  begin
    RowNum := StrToInt(ctlRowNumber.Text);
  end;
{--------}
procedure TOvcfrmRowEditor.ctlUseCustHeightClick(Sender: TObject);
  begin
    CurDefHt := false;
    ctlHeight.Enabled := true;
  end;
{--------}
procedure TOvcfrmRowEditor.ctlUseDefHeightClick(Sender: TObject);
  begin
    CurDefHt := true;
    ctlHeight.Text := IntToStr(FRows.DefaultHeight);
    ctlHeight.Enabled := false;
  end;
{--------}
procedure TOvcfrmRowEditor.FormShow(Sender: TObject);
  begin
    ctlDefaultHeight.Text := IntToStr(FRows.DefaultHeight);
    ctlRowLimit.Text := IntToStr(FRows.Limit);
    RefreshRowData;
    FormShowCalled := True;
  end;
{--------}
procedure TOvcfrmRowEditor.RefreshRowData;
  begin
    CurDefHt := FRows.Height[RowNum] = FRows.DefaultHeight;

    ctlHidden.Checked := FRows.Hidden[RowNum];
    ctlHeight.Text := IntToStr(FRows.Height[RowNum]);
    if CurDefHt then
      begin
        ctlUseDefHeight.Checked := true;
        ctlHeight.Enabled := false;
      end
    else
      begin
        ctlUseCustHeight.Checked := true;
        ctlHeight.Enabled := true;
      end;

    ctlRowLimit.Text := IntToStr(FRows.Limit);
  end;
{--------}
procedure TOvcfrmRowEditor.ResetClick(Sender: TObject);
  begin
    FRows.Clear;
    ctlDefaultHeight.Text := IntToStr(FRows.DefaultHeight);
    RefreshRowData;
  end;
{--------}
procedure TOvcfrmRowEditor.SetRowNum(R : TRowNum);
  begin
    if (FRowNum <> R) then
      begin
        FRowNum := R;
        RefreshRowData;
        ctlRowNumber.Text := IntToStr(R);  //Do this after refresh
      end;
  end;
{--------}
procedure TOvcfrmRowEditor.SetRows(RS : TOvcTableRows);
  begin
    if Assigned(FRows) then
      FRows.Free;
    FRows := RS;
    FRowNum := 0;
    ctlRowNumber.Text := '0';
    CurDefHt := FRows.Height[RowNum] = FRows.DefaultHeight;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton1Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (RowNum > 0) then
      RowNum := RowNum - 1;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton2Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    if (RowNum < pred(FRows.Limit)) then
      RowNum := RowNum + 1;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton3Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    RowNum := 0;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton4Click(Sender: TObject);
  begin
    ApplyButtonClick(Self);
    RowNum := pred(FRows.Limit);
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton5Click(Sender: TObject);
  var
    RS : TRowStyle;
  begin
    RS.Hidden := false;
    RS.Height := FRows.DefaultHeight;
    FRows.Insert(FRowNum, RS);
    RefreshRowData;
  end;
{--------}
procedure TOvcfrmRowEditor.SpeedButton6Click(Sender: TObject);
  begin
    FRows.Delete(FRowNum);
    RefreshRowData;
  end;
{====================================================================}

procedure TOvcfrmRowEditor.DoneButtonClick(Sender: TObject);
begin
  ApplyButtonClick(Self);
end;

procedure TOvcfrmRowEditor.ctlRowNumberChange(Sender: TObject);
var
  NewRowNum : Integer;
begin
  ApplyButtonClick(Self);
  if not TryStrToInt(ctlRowNumber.Text, NewRowNum) then  {Invalid?}
    ctlRowNumber.Text := IntToStr(RowNum)  {Restore previous row number}
  else if NewRowNum = -1 then  {Wrap around to last row?}
    ctlRowNumber.Text := IntToStr(Pred(FRows.Limit))
  else if NewRowNum = FRows.Limit then  {Wrap around to first row?}
    ctlRowNumber.Text := '0'
  else if not (NewRowNum in [0..Pred(FRows.Limit)]) then  {Out of range?}
    ctlRowNumber.Text := IntToStr(RowNum);  {Restore previous row number} 
  RowNum := StrToInt(ctlRowNumber.Text);
end;

initialization
{$IFDEF LCL}
{$I myovctbpe1.lrs}  {Include form's resource file}
{$ENDIF}

end.
