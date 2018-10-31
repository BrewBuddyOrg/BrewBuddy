{*********************************************************}
{*                     myovcreg.pas                      *}
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
{*  Phil Hess - adapted ovcreg.pas to register only ported controls.          *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit MyOvcReg;

{
  Registration unit for the ported Orpheus components.
}

interface 

uses
  Classes,
  Forms,
  LResources,
  PropEdits,
  ComponentEditors,
  ovcabot0,  {Property editors}
  ovclbl0,
  myovctbpe1,
  myovctbpe2,
  ovcbase,   {Controls}
  ovctcedt,
  ovctchdr,
  ovctccbx,
  ovctcsim,
  ovctcbox,
  ovctcbmp,
  ovctcgly,
  ovctcico,
  ovctbcls,
  ovctbrws,
  ovctable,
  ovcurl,
  ovcrlbl,
  ovclabel,
  ovcsf,
  o32flxed,
  o32tcflx,
  ovccal,
//  ovcedcal,
//  ovccalc,
//  ovcclrcb,
  ovcsc,
  ovcvlb;
  
procedure Register;
  

implementation

type
  TOvcHeaderProperty = class(TCaptionProperty);

  {component editor for the table}
  TOvcTableEditor = class(TDefaultComponentEditor)
  public
    procedure ExecuteVerb(Index : Integer);
      override;
    function GetVerb(Index : Integer) : AnsiString;
      override;
    function GetVerbCount : Integer;
      override;
  end;

{*** TOvcTableEditor ***}

const
  TableVerbs : array[0..1] of PAnsiChar =
    ('Columns Editor', 'Rows Editor');

procedure TOvcTableEditor.ExecuteVerb(Index : Integer);
var
  Table : TOvcTable;
  C     : TOvcfrmColEditor;
  R     : TOvcfrmRowEditor;
begin
  Table := TOvcTable(Component);
  if Index = 0 then begin
    C := TOvcfrmColEditor.Create(Application);
    try
      C.Editor := Self;
      C.SetCols(TOvcTableColumns(Table.Columns));
      C.ShowModal;
      Designer.Modified;
    finally
      C.Free;
    end;
  end else if Index = 1 then begin
    R := TOvcfrmRowEditor.Create(Application);
    try
      R.SetRows(TOvcTableRows(Table.Rows));
      R.ShowModal;
      Designer.Modified;
    finally
      R.Free;
    end;
  end;
end;

function TOvcTableEditor.GetVerb(Index : Integer) : AnsiString;
begin
  Result := StrPas(TableVerbs[Index]);
end;

function TOvcTableEditor.GetVerbCount : Integer;
begin
  Result := High(TableVerbs) + 1;
end;


procedure Register;
begin
  RegisterPropertyEditor(TypeInfo(string), TOvcURL, 'Caption', TOvcHeaderProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcURL, 'URL', TOvcHeaderProperty);

  RegisterPropertyEditor(TypeInfo(string), TOvcRotatedLabel, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcLabel, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcURL, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcSpinner, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcVirtualListBox, 'About', TOvcAboutProperty);
//{$IFDEF MSWINDOWS}
  RegisterPropertyEditor(TypeInfo(string), TOvcSimpleField, 'About', TOvcAboutProperty);
//{$ENDIF}
  RegisterPropertyEditor(TypeInfo(string), TO32FlexEdit, 'About', TOvcAboutProperty);
//  RegisterPropertyEditor(TypeInfo(string), TOvcCalculator, 'About', TOvcAboutProperty);
//  RegisterPropertyEditor(TypeInfo(string), TOvcColorComboBox, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTable, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCColHead, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCRowHead, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCString, 'About', TOvcAboutProperty);
//{$IFDEF MSWINDOWS}
  RegisterPropertyEditor(TypeInfo(string), TOvcTCSimpleField, 'About', TOvcAboutProperty);
//{$ENDIF}
  RegisterPropertyEditor(TypeInfo(string), TOvcTCMemo, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCCheckBox, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCComboBox, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCBitMap, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCGlyph, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcTCIcon, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TO32TCFlexEdit, 'About', TOvcAboutProperty);
  RegisterPropertyEditor(TypeInfo(string), TOvcController, 'About', TOvcAboutProperty);

  {register label component editor}
  RegisterComponentEditor(TOvcCustomLabel, TOvcLabelEditor);

  {register property editors for the entry fields}
(*
  RegisterPropertyEditor(
    TypeInfo(Char), TOvcSimpleField,    'PictureMask', TSimpleMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'PictureMask', TPictureMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'PictureMask', TNumericMaskProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcSimpleField,  'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcSimpleField,  'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureField, 'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'RangeHi', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcNumericField, 'RangeLo', OvcEfPe.TEfRangeProperty);
  RegisterPropertyEditor(
    TypeInfo(string), TOvcPictureLabel, 'PictureMask', TPictureMaskProperty);
*)

  RegisterPropertyEditor(TypeInfo(TOvcTableRows), TOvcTable, '', TOvcTableRowProperty);
  RegisterPropertyEditor(TypeInfo(TOvcTableColumns), TOvcTable, '', TOvcTableColumnProperty);

  {register component editor for the table}
  RegisterComponentEditor(TOvcTable, TOvcTableEditor);

  RegisterComponents('Orpheus', [TOvcRotatedLabel]);
  RegisterComponents('Orpheus', [TOvcLabel]);
  RegisterComponents('Orpheus', [TOvcURL]);
  RegisterComponents('Orpheus', [TOvcSpinner]);
  RegisterComponents('Orpheus', [TOvcVirtualListBox]);
//{$IFDEF MSWINDOWS}  //If used, crashes IDE with GTK, so only register if Windows
  RegisterComponents('Orpheus', [TOvcSimpleField]);
//{$ENDIF}
  RegisterComponents('Orpheus', [TO32FlexEdit]);
  RegisterComponents('Orpheus', [TOvcCalendar]);
//  RegisterComponents('Orpheus', [TOvcDateEdit]);  //Needs ButtonOkay fixes like TO32FlexEdit
//  RegisterComponents('Orpheus', [TOvcCalculator]);
//  RegisterComponents('Orpheus', [TOvcColorComboBox]);
  RegisterComponents('Orpheus', [TOvcTable]); 
  RegisterComponents('Orpheus', [TOvcTCColHead]);
  RegisterComponents('Orpheus', [TOvcTCRowHead]);
  RegisterComponents('Orpheus', [TOvcTCString]);
//{$IFDEF MSWINDOWS}  //If used, crashes IDE with GTK, so only register if Windows
  RegisterComponents('Orpheus', [TOvcTCSimpleField]); 
//{$ENDIF}
  RegisterComponents('Orpheus', [TOvcTCMemo]); 
  RegisterComponents('Orpheus', [TOvcTCCheckBox]); 
  RegisterComponents('Orpheus', [TOvcTCComboBox]); 
  RegisterComponents('Orpheus', [TOvcTCBitMap]); 
  RegisterComponents('Orpheus', [TOvcTCGlyph]); 
  RegisterComponents('Orpheus', [TOvcTCIcon]); 
  RegisterComponents('Orpheus', [TO32TCFlexEdit]);
  RegisterComponents('Orpheus', [TOvcController]);
end;  {Register}

initialization
{$I ovcreg.lrs}

end.

