{*********************************************************}
{*                   O32FLXED.PAS 4.06                   *}
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
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}
{$J+} {Writable constants}

unit o32flxed;
  {OvcFlexEdit and support classes - Introduced in Orpheus 4.0}

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, Types, LclType, MyMisc, {$ENDIF} 
  Classes, Controls, Forms, SysUtils, StdCtrls, Buttons,
  OvcData, O32Editf, OvcEF, Graphics, O32SR, O32bordr, O32Vldtr,
  O32VlOp1, o32ovldr, {$IFNDEF LCL} o32pvldr, {$ENDIF} o32rxvld, Dialogs;

type
  {Forward Declaration}
  TO32CustomFlexEdit = class;

  TO32PopupAnchor = (paLeft, paRight);


//  TO32FlexEditDataType = (feString, feFloat, feInteger, feDateTime, feExtended,
//    feStDate, feStTime, feLogical);

  TO32FEButton = class(TBitBtn)
  public
     procedure Click; override;
  end;

  TO32feButtonClickEvent =
    procedure(Sender: TO32CustomFlexEdit; PopupPoint: TPoint) of object;
  TFEUserValidationEvent =
    procedure(Sender : TObject; var ValidEntry : Boolean) of object;
  TFEValidationErrorEvent =
    procedure(Sender : TObject; ErrorCode : Word; ErrorMsg : string) of object;

  TFlexEditValidatorOptions = class(TValidatorOptions)
  published
    property InputRequired;
  end;

  TO32EditLines = class(TPersistent)
  protected{private}
    FlexEdit       : TO32CustomFlexEdit;
    FMaxLines      : Integer;
    FDefaultLines  : Integer;
    FFocusedLines  : Integer;
    FMouseOverLines: Integer;
    procedure SetDefaultLines(Value: Integer);
    procedure SetMaxLines(Value: Integer);
    procedure SetFocusedLines(Value: Integer);
    procedure SetMouseOverLines(Value: Integer);
  public
    constructor Create; virtual;
    destructor  Destroy; override;
  published
    property MaxLines: Integer       read FMaxLines       write SetMaxLines
      default 3;
    property DefaultLines: Integer   read FDefaultLines   write SetDefaultLines
      default 1;
    property FocusedLines: Integer   read FFocusedLines   write SetFocusedLines
      default 3;
    property MouseOverLines: Integer read FMouseOverLines write SetMouseOverLines
      default 3;
  end;

  TFlexEditStrings = class(TStrings)
  protected {private}
    FCapacity: Integer;
    function  Get(Index: Integer): string; override;
    function  GetCount: Integer; override;
    function  GetTextStr: string; override;
    procedure Put(Index: Integer; const S: string); override;
    procedure SetTextStr(const Value: string); override;
    procedure SetUpdateState(Updating: Boolean); override;

  public
    FlexEdit: TCustomEdit;
    procedure Clear; override;
    procedure SetCapacity(NewCapacity: Integer); override;
    procedure Delete(Index: Integer); override;
    procedure Insert(Index: Integer; const S: string); override;
  end;

  TO32CustomFlexEdit = class(TO32CustomEdit)
  protected {private}
    FAlignment        : TAlignment;
    FBorders          : TO32Borders;
    FButton           : TO32FEButton;
    FButtonGlyph      : TBitmap;
    FCanvas           : TControlCanvas;
//    FDataType         : TO32FlexEditDataType;
    FEditLines        : TO32EditLines;
    FEFColors         : TOvcEFColors;
    FDisplayedLines   : Integer;
    FMaxLines         : Integer;
    FStrings          : TFlexEditStrings;
//    FPasswordChar     : Char;
    FPopupAnchor      : TO32PopupAnchor;
    FShowButton       : Boolean;
    FWordWrap         : Boolean;
    FWantReturns      : Boolean;
    FWantTabs         : Boolean;
    FMouseInControl   : Boolean;
    FValidation       : TFlexEditValidatorOptions;
    FValidator        : TO32BaseValidator;
    FValidationError  : Integer;

    FOnButtonClick    : TO32feButtonClickEvent;
    FOnUserValidation : TFEUserValidationEvent;
    FOnValidationError: TFEValidationErrorEvent;
    FBeforeValidation : TNotifyEvent;
    FAfterValidation  : TNotifyEvent;

    {Internal Variables}
    FSaveEdit        : String;     {saved copy of edit string}
    FCreating        : Boolean;

    FColor           : TColor;
    FFontColor       : TColor;

    FUpdating        : Integer;
    feValid          : Boolean;


    {Property Methods}
    function  GetButtonGlyph          : TBitmap;
    procedure SetButtonGlyph(Value    : TBitmap);
    procedure SetShowButton (Value    : Boolean);
    function  GetBoolean              : Boolean;
    function  GetYesNo                : Boolean;
    function  GetDateTime             : TDateTime;
    function  GetDouble               : Double;
    function  GetExtended             : Extended;
    function  GetInteger              : Integer;
    function  GetStrings              : TStrings;
    function  GetVariant              : Variant;
    function  GetText                 : String;
    function  GetColor                : TColor; virtual;

    procedure SetBoolean       (Value : Boolean);
    procedure SetYesNo         (Value : Boolean);
    procedure SetDateTime      (Value : TDateTime);
//    procedure SetDataType      (Value : TO32FlexEditDataType);
    procedure SetDouble        (Value : Double);
    procedure SetExtended      (Value : Extended);
    procedure SetInteger       (Value : Integer);
    procedure SetStrings       (Value : TStrings);
    procedure SetVariant       (Value : Variant);
    procedure SetDisplayedLines(Value : Integer);
    procedure SetWordWrap      (Value : Boolean);
    procedure SetWantReturns   (Value : Boolean);
    procedure SetWantTabs      (Value : Boolean);
    procedure SetText          (const Value : String);
    procedure SetColor         (Value : TColor); virtual;

    {Message Handlers}
    procedure WMGetDlgCode (var Message : TWMGetDlgCode); message WM_GETDLGCODE;
    procedure CMMouseEnter (var Message : TMessage);      message CM_MOUSEENTER;
    procedure CMMouseLeave (var Message : TMessage);      message CM_MOUSELEAVE;
{$IFNDEF LCL}
    procedure CMGotFocus   (var Message : TMessage);      message WM_SETFOCUS;
    procedure CMLostFocus  (var Message : TMessage);      message WM_KILLFOCUS;
{$ELSE}
    procedure CMGotFocus   (var Message : TLMSetFocus);   message WM_SETFOCUS;
    procedure CMLostFocus  (var Message : TLMKillFocus);  message WM_KILLFOCUS;
{$ENDIF}

    { - added}
    procedure CMFontChanged(var Message: TMessage);       message CM_FONTCHANGED;

    procedure WMNCPaint    (var Message : TWMNCPaint);    message WM_NCPAINT;

{ - was commented out in 4.02 and re-written in 4.06}
    procedure WMPaint      (var Message : TWMPaint);      message WM_PAINT;

    procedure OMValidate   (var Message : TMessage);      message OM_VALIDATE;
    procedure OMRecreateWnd(var Message : TMessage);      message OM_RECREATEWND;

    {Internal Methods}
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params : TCreateParams); override;
    procedure SetParent(Value: TWinControl); override;
    procedure CreateWnd; override;
{$IFNDEF LCL}
    procedure CreateWindowHandle(const Params: TCreateParams); override;
{$ENDIF}
    procedure AdjustHeight;
    procedure GlyphChanged; dynamic;
    procedure Loaded; override;
    procedure SetAlignment(Value: TAlignment);
    function  MultiLineEnabled: Boolean;
    function  GetButtonWidth : Integer;
    function  GetButtonEnabled : Boolean; dynamic;
    procedure SetMaxLines(Value: Integer);
    function  ValidateSelf: Boolean; virtual;
    procedure SaveEditString;

    procedure DoOnChange; virtual;

{$IFDEF LCL}
    function ChildClassAllowed(ChildClass: TClass): Boolean; override;
{$ENDIF}

  public
    constructor Create(AOwner : TComponent); override;
    destructor  Destroy; override;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer); override;
    procedure ButtonClick; dynamic;
    procedure Restore; virtual;

    procedure BeginUpdate;
    procedure EndUpdate;

    {properties}
    property  Alignment: TAlignment
      read FAlignment   write SetAlignment default taLeftJustify;
//    property DataType: TO32FlexEditDataType
//      read FDataType write SetDataType default feString;
    property  Borders: TO32Borders
      read FBorders     write FBorders;
    property  Color: TColor
      read GetColor write SetColor default clWindow;
    property  EfColors: TOvcEfColors
      read FEFColors    write FEFColors;
    property  EditLines: TO32EditLines
      read FEditLines   write FEditLines;
//    property PasswordChar: char
//      read FPasswordChar write SetPwdChar;
    property  PopupAnchor : TO32PopupAnchor
      read FPopupAnchor write FPopupAnchor;
    property  ShowButton : Boolean
      read FShowButton  write SetShowButton;
    property Validation: TFlexEditValidatorOptions
      read FValidation write FValidation;
    property  WantReturns: Boolean
      read FWantReturns write SetWantReturns default False;
    property  WantTabs: Boolean
      read FWantTabs    write SetWantTabs default False;
    property  WordWrap: Boolean
      read FWordWrap    write SetWordWrap default False;
    property  Text: String
      read GetText      write SetText;
    property  Strings: TStrings
      read GetStrings     write SetStrings;

    property  AsBoolean: Boolean
      read GetBoolean   write SetBoolean;
    property  AsYesNo: Boolean
      read GetYesNo     write SetYesNo;
    property  AsDateTime: TDateTime
      read GetDateTime  write SetDateTime;
    property  AsFloat: Double
      read GetDouble    write SetDouble;
    property  AsExtended: Extended
      read GetExtended  write SetExtended;
    property  AsInteger: Integer
      read GetInteger   write SetInteger;
    property  AsVariant: Variant
      read GetVariant   write SetVariant;
    property  ButtonGlyph : TBitmap
      read GetButtonGlyph write SetButtonGlyph;
    property Canvas :TControlCanvas
      read FCanvas;
    property OnButtonClick : TO32feButtonClickEvent
      read FOnButtonClick write FOnButtonClick;
    property OnUserValidation: TFEUserValidationEvent
      read FOnUserValidation write FOnUserValidation;
    property OnValidationError: TFEValidationErrorEvent
      read FOnValidationError write FOnValidationError;
    property BeforeValidation : TNotifyEvent
      read FBeforeValidation write FBeforeValidation;
    property AfterValidation : TNotifyEvent
      read FAfterValidation write FAfterValidation;
  end;

  {O32FlexEdit}
  TO32FlexEdit = class(TO32CustomFlexEdit)
  published
    {$IFDEF VERSION4}
    property Alignment;
    property Anchors;
{$IFNDEF LCL}
    property BiDiMode;
    property ParentBiDiMode;
{$ENDIF}
    property DragKind;
    property DragMode;
    property OnEndDock;
    property OnStartDock;
    {$ENDIF}
    property AutoSize default False;
    property About;
{$IFNDEF LCL}
    property AutoSelect;  // Added recently to LCL, but leave out for now
{$ENDIF}    
    property Borders;
    property ButtonGlyph;
    property CharCase;
    property Color;
    property Cursor;
    property DragCursor;
    property EditLines;
    property EfColors;
    property Enabled;
    property Font;
{$IFNDEF LCL}
    property HideSelection;
    property ImeMode;
    property ImeName;
{$ENDIF}
    property LabelInfo;
    property MaxLength;
{$IFNDEF LCL}
    property OEMConvert;
{$ENDIF}
    property ParentFont;
    property ParentShowHint;
    property PasswordChar;
    property PopupAnchor default paLeft;
    property PopupMenu;
    property ReadOnly;
    property ShowButton default False;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Validation;
    property Visible;
    property WantReturns;
    property WantTabs;
    property WordWrap;

    property AfterValidation;
    property BeforeValidation;
    property OnButtonClick;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
    property OnUserValidation;
    property OnValidationError;
  end;

implementation

// The optional button inside a TO32FlexEdit originally did not work with LCL,
//  so excluded all button-related code. 
// Note now seems to work with win32 and carbon as of 0.9.28. To enable,
//  delete the dot in the two DEFINE's.
// For more information, see Lazarus bug 7097.
{$IFNDEF LCL}
 {$DEFINE ButtonOkay}
{$ELSE}
 {.$DEFINE ButtonOkay}
 {$IFNDEF MSWINDOWS}
  {.$DEFINE ButtonNotChild}  //Manually reposition relative to edit control
 {$ENDIF}
{$ENDIF}

{===== TO32FEButton ==================================================}

procedure TO32FEButton.Click;
begin
  TO32FlexEdit(Parent).SetFocus;
  TO32FlexEdit(Parent).ButtonClick;
end;

{===== TO32EditLines =================================================}

constructor TO32EditLines.Create;
begin
  inherited Create;
  FMaxLines       := 3{1};
  FFocusedLines   := 3{1};
  FMouseOverLines := 3{1};
  FDefaultLines   := 1;
end;
{=====}

destructor  TO32EditLines.Destroy;
begin
  inherited Destroy;
end;
{=====}

procedure TO32EditLines.SetDefaultLines(Value: Integer);
begin
  if FDefaultLines <> Value then
    FDefaultLines := Value;
  if FDefaultLines > FMaxLines then
    FDefaultLines := FMaxLines;
end;
{=====}

procedure TO32EditLines.SetMaxLines(Value: Integer);
begin
  if FMaxLines <> Value then begin
    FMaxLines := Value;
    TO32CustomFlexEdit(FlexEdit).SetMaxLines(FMaxLines);
  end;
end;
{=====}

procedure TO32EditLines.SetFocusedLines(Value: Integer);
begin
  if FFocusedLines <> Value then
    FFocusedLines := Value;
  if FFocusedLines > FMaxLines then
    FFocusedLines := FMaxLines;
end;
{=====}

procedure TO32EditLines.SetMouseOverLines(Value: Integer);
begin
  if FMouseOverLines <> Value then
    FMouseOverLines := Value;
  if FMouseOverLines > FMaxLines then
    FMouseOverLines := FMaxLines;
end;


{===== TFlexEditStrings ==============================================}

function TFlexEditStrings.GetCount: Integer;
begin
  Result := 0;
  if FlexEdit.HandleAllocated then
  begin
    Result := SendMessage(FlexEdit.Handle, EM_GETLINECOUNT, 0, 0);
    if SendMessage(FlexEdit.Handle, EM_LINELENGTH, SendMessage(FlexEdit.Handle,
      EM_LINEINDEX, Result - 1, 0), 0) = 0 then Dec(Result);
  end;
end;
{=====}

function TFlexEditStrings.Get(Index: Integer): string;
var
  Text: array[0..4095] of Char;
begin
  Word((@Text)^) := SizeOf(Text);
  SetString(Result, Text, SendMessage(FlexEdit.Handle, EM_GETLINE, Index,
    LPARAM(@Text)));  //64
end;
{=====}

procedure TFlexEditStrings.Put(Index: Integer; const S: string);
var
  SelStart: Integer;
begin
  SelStart := SendMessage(FlexEdit.Handle, EM_LINEINDEX, Index, 0);
  if SelStart >= 0 then
  begin
    SendMessage(FlexEdit.Handle, EM_SETSEL, SelStart, SelStart +
      SendMessage(FlexEdit.Handle, EM_LINELENGTH, SelStart, 0));
    SendMessage(FlexEdit.Handle, EM_REPLACESEL, 0, LPARAM(PChar(S)));  //64
  end;
end;
{=====}

procedure TFlexEditStrings.Insert(Index: Integer; const S: string);
var
  SelStart, LineLen: Integer;
  Line: string;
begin
  if Count = FCapacity then exit;

  if Index >= 0 then
  begin
    SelStart := SendMessage(FlexEdit.Handle, EM_LINEINDEX, Index, 0);
    if SelStart >= 0 then Line := S + #13#10 else
    begin
      SelStart := SendMessage(FlexEdit.Handle, EM_LINEINDEX, Index - 1, 0);
      if SelStart < 0 then Exit;
      LineLen := SendMessage(FlexEdit.Handle, EM_LINELENGTH, SelStart, 0);
      if LineLen = 0 then Exit;
      Inc(SelStart, LineLen);
      Line := #13#10 + s;
    end;
    SendMessage(FlexEdit.Handle, EM_SETSEL, SelStart, SelStart);
    SendMessage(FlexEdit.Handle, EM_REPLACESEL, 0, LPARAM(PChar(Line)));  //64
  end;
end;
{=====}

procedure TFlexEditStrings.Delete(Index: Integer);
const
  Empty: PChar = '';
var
  SelStart, SelEnd: Integer;
begin
  SelStart := SendMessage(FlexEdit.Handle, EM_LINEINDEX, Index, 0);
  if SelStart >= 0 then
  begin
    SelEnd := SendMessage(FlexEdit.Handle, EM_LINEINDEX, Index + 1, 0);
    if SelEnd < 0 then SelEnd := SelStart +
      SendMessage(FlexEdit.Handle, EM_LINELENGTH, SelStart, 0);
    SendMessage(FlexEdit.Handle, EM_SETSEL, SelStart, SelEnd);
    SendMessage(FlexEdit.Handle, EM_REPLACESEL, 0, LPARAM(Empty));  //64
  end;
end;
{=====}

procedure TFlexEditStrings.Clear;
begin
  FlexEdit.Clear;
end;
{=====}

procedure TFlexEditStrings.SetUpdateState(Updating: Boolean);
begin
  if FlexEdit.HandleAllocated then
  begin
    SendMessage(FlexEdit.Handle, WM_SETREDRAW, Ord(not Updating), 0);
    if not Updating then
    begin   // WM_SETREDRAW causes visibility side effects in memo controls
      FlexEdit.Perform(CM_SHOWINGCHANGED,0,0); // This reasserts the visibility we want
      FlexEdit.Refresh;
    end;
  end;
end;
{=====}

function TFlexEditStrings.GetTextStr: string;
begin
  Result := FlexEdit.Text;
end;
{=====}

procedure TFlexEditStrings.SetCapacity(NewCapacity: Integer);
begin
  {Sets line-limit and destructively removes any lines that exceed the limit.}
  if FCapacity <> NewCapacity then begin
    FCapacity := NewCapacity;
    while Count > FCapacity do Delete(FCapacity);
  end;
end;
{=====}

procedure TFlexEditStrings.SetTextStr(const Value: string);
var
  NewText: string;
begin
  NewText := AdjustLineBreaks(Value);
  if (Length(NewText) <> FlexEdit.GetTextLen) or (NewText <> FlexEdit.Text) then
  begin
{$IFNDEF LCL}
    if SendMessage(FlexEdit.Handle, WM_SETTEXT, 0, Longint(NewText)) = 0 then
      raise EInvalidOperation.Create(RSTooManyBytes);
    FlexEdit.Perform(CM_TEXTCHANGED, 0, 0);
{$ELSE}  //Previous SendMessage always returns 0 (error) with LCL
    FlexEdit.SetTextBuf(PAnsiChar(NewText));
{$ENDIF}
  end;
end;

{===== TO32CustomFlexEdit ============================================}

constructor TO32CustomFlexEdit.Create(AOwner : TComponent);
begin
  FCreating := True;

  inherited Create(AOwner);

  FWordWrap := False;
  FWantReturns := False;
  FWantTabs := False;
  Width := 185;
  AutoSize := False;

  {create support classes}
  FCanvas := TControlCanvas.Create;
  TControlCanvas(FCanvas).Control := Self;

  feValid := true;
  FShowButton := False;
{$IFDEF ButtonOkay}
  FButton := TO32FEButton.Create(Self);
  FButton.Visible := True;
  FButton.Parent := Self;
  FButton.Caption := '';
  FButton.TabStop := False;
 {$IFNDEF LCL}
  FButton.Style := bsNew;
 {$ENDIF}
{$ENDIF}

  FButtonGlyph := TBitmap.Create;

  FBorders := TO32Borders.Create(Self);

  FEFColors := TOvcEfColors.Create;

  FStrings := TFlexEditStrings.Create;
  TFlexEditStrings(FStrings).FlexEdit := Self;

  FEditLines := TO32EditLines.Create;
  TO32EditLines(FEditLines).FlexEdit := self;

  { now set in TO32EditLines.Create:
  EditLines.MaxLines := 3;
  EditLines.DefaultLines := 1;
  EditLines.FocusedLines := 3;
  EditLines.MouseOverLines := 3;
  }

  FDisplayedLines := FEditLines.FDefaultLines;
  TFlexEditStrings(FStrings).Capacity := FMaxLines;

  FMouseInControl := false;

  FSaveEdit := '';

  Height := 80;
  AdjustHeight;

  Validation := TFlexEditValidatorOptions.Create(self);
  FColor := Color;
  FFontColor := Font.Color;
  FCreating := False;
end;
{=====}

destructor TO32CustomFlexEdit.Destroy;
begin
  {Free support classes}
{$IFDEF ButtonOkay}
  FButton.Free;
{$ENDIF}  
  FEFColors.Free;
  FEditLines.Free;
  FStrings.Free;
  FButtonGlyph.Free;
  FCanvas.Free;
  FBorders.Free;
  FValidation.Free;

  inherited Destroy;
end;
{=====}

procedure TO32CustomFlexEdit.CreateParams(var Params: TCreateParams);
const
  Passwords: array[Boolean] of DWORD = (0, ES_PASSWORD);
  Alignments: array[Boolean, TAlignment] of DWORD =
    ((ES_LEFT, ES_RIGHT, ES_CENTER),(ES_RIGHT, ES_LEFT, ES_CENTER));
  WordWraps: array[Boolean] of DWORD = (0, ES_AUTOHSCROLL);
begin
  inherited CreateParams(Params);
  with Params do
  begin
  { - begin}
    if MultilineEnabled then
      Style := Style and not WordWraps[FWordWrap] or ES_MULTILINE
        {$IFDEF VERSION4}
{$IFNDEF LCL}
        or Alignments[UseRightToLeftAlignment, FAlignment]
{$ELSE}
        or Alignments[False, FAlignment]
{$ENDIF}
        {$ENDIF}
        or WS_CLIPCHILDREN
    else
      Style := Style and not WordWraps[FWordWrap]
        or Passwords[PasswordChar <> #0]
        {$IFDEF VERSION4}
{$IFNDEF LCL}
        or Alignments[UseRightToLeftAlignment, FAlignment]
{$ELSE}
        or Alignments[False, FAlignment]
{$ENDIF}
        {$ENDIF}
        or WS_CLIPCHILDREN
  { - end}
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SetParent(Value: TWinControl);
begin
  inherited;
  {$IFNDEF VERSION4}
    {$IFDEF CBuilder}
      HandleNeeded; {BCB3 needs a handle here}
    {$ENDIF}
  {$ENDIF}
end;
{=====}

procedure TO32CustomFlexEdit.WMGetDlgCode(var Message: TWMGetDlgCode);
begin
  inherited;
  if FWantTabs then Message.Result := Message.Result or DLGC_WANTTAB
  else Message.Result := Message.Result and not DLGC_WANTTAB;
  if not FWantReturns then
    Message.Result := Message.Result and not DLGC_WANTALLKEYS;
end;
{=====}

procedure TO32CustomFlexEdit.WMNCPaint(var Message: TWMNCPaint);
var
  DC: HDC;
begin
  if (FUpdating > 0) then exit;

  inherited;

  if Borders.Active then begin
    DC := GetWindowDC(Handle);
    FCanvas.Handle := DC;
    try
      FBorders.DrawBorders(FCanvas, Color);
    finally
      FCanvas.Handle := 0;
      ReleaseDC( Handle, DC );
    end;
    Message.Result := 0;
  end;
end;
{=====}

{WMPaint had been completely commented out in 4.02.  It is now }
{ re introduced as follows....                                 }
{ - Re-written}
procedure TO32CustomFlexEdit.WMPaint(var Message: TWMPaint);
begin
  { known limitation, The ancestor is overriding the font color when the }
  { control is disabled }
  if not Enabled then begin
    inherited Color := efColors.Disabled.BackColor;
    Font.Color := efColors.Disabled.TextColor;
  end else begin
    if feValid then begin
      inherited Color := FColor;
      Font.Color := FFontColor;
    end else if Validation.SoftValidation then begin
      inherited Color := EFColors.Error.BackColor;
      Font.Color := EFColors.Error.TextColor;
    end;
  end;
  inherited;
end;

{ - Not necessary }
(*
procedure TO32CustomFlexEdit.WMPaint(var Message: TWMPaint);
var
  Rct: TRect;
  Str: string;
  DC: HDC;
  PS: TPaintStruct;
begin
  if (FUpdating > 0) then exit;

  if ((FAlignment = taLeftJustify ) or Focused)
    and not (csPaintCopy in ControlState)
  then inherited
  else begin
    DC := Message.DC;
    if DC = 0 then DC := BeginPaint(Handle, PS);
    FCanvas.Handle := DC;
    try
      if (FAlignment = taRightJustify) then begin
        FCanvas.Font := Font;
        with FCanvas do begin
          Rct := ClientRect;
          Brush.Color := Color;
          Str := Text;
          TextRect(Rct, Rct.Right - TextWidth(Str) - 2, 2, Str);
        end;
      end;
    finally
      FCanvas.Handle := 0;
      if Message.DC = 0 then EndPaint( Handle, PS );
    end;
  end;
end;
{=====}
*)

procedure TO32CustomFlexEdit.OMValidate (var Message : TMessage);
begin
  if not ValidateSelf then begin
    if Assigned(FOnValidationError) then
// TurboPower bug: With vtUser, FValidator is nil here.
//      FOnValidationError(Self, FValidator.ErrorCode, 'Invalid input');
      FOnValidationError(Self, FValidationError, 'Invalid input');  //Fixed
    Message.Result := FValidationError;
    if (Validation.ValidationEvent  = veOnChange) then begin
      Validation.BeginUpdate;
      Restore;
      Validation.EndUpdate;
    end;
  end else begin
    Message.Result := 0;
  end;
end;
{=====}

function TO32CustomFlexEdit.ValidateSelf: Boolean;
begin
  result := true;
  if (FUpdating > 0) then exit;

  case Validation.ValidationType of

    vtNone: begin
      {User can specify that the field be non-empty even if he is specifying no
       custom validation}
      if Validation.InputRequired and (Text = '') then
        result := false;
      exit;
    end;

    vtUser: begin
      if (Text = '') then begin
        if Validation.InputRequired then
          result := false
        else
          result := true;
      end;  { else  }  //Commented out; otherwise our validation handler never 
                       // gets called if Text is blank - TurboPower bug?.
        if Assigned(FOnUserValidation) then
          FOnUserValidation(Self, result);

      if not Result then
        FValidationError := 1;
    end; {vtUser}

    vtValidator: begin

      if (text = '') then begin
        if Validation.InputRequired then begin
          {Fail Validation for an empty, required field}
          result := false;
          FValidationError := 1;
        end else begin
          {Pass validation for a non-required, empty field}
          result := true;
          FValidationError := 0;
        end;
      end

      else if Validation.Mask = '' then begin
        result := true;
        FValidationError := 0;
        exit;
      end

      else if FValidation.ValidatorClass = nil then begin
        result := false;
        raise(Exception.Create('Error: Unknown validator Class.'));
      end

      else begin
        FValidator := FValidation.ValidatorClass.Create(Self);
        try
          FValidator.Mask := Validation.Mask;
          FValidator.Input := Text;

          if Assigned(FBeforeValidation) then
            FBeforeValidation(self);

          result := FValidator.IsValid;
          FValidationError := FValidator.ErrorCode;

          if Assigned(FAfterValidation) then
            FAfterValidation(self);

        finally
          FValidator.Free;
        end; {try}
      end; {if}
    end; {VtValidator}

  end; {case}

{ - begin}
  feValid := result;
  if result then
    SaveEditString
  else
    if Validation.BeepOnError then
      MessageBeep(0);

  { Invalidate; } { !!.04 - Commented out - Causes flicker } {!!!!}
{ - end}
end;
{=====}

procedure TO32CustomFlexEdit.OMRecreateWnd(var Message : TMessage);
begin
  if (FUpdating > 0) then exit;
{$IFNDEF LCL}
  RecreateWnd;
{$ELSE}
  MyMisc.RecreateWnd(Self);
{$ENDIF}
end;
{=====}

procedure TO32CustomFlexEdit.CMMouseEnter(var Message : TMessage);
begin
  inherited;
  if Enabled and MultiLineEnabled and (not FMouseInControl)
  and (not Focused) then begin
    if FDisplayedLines <> FEditLines.FMouseOverLines then begin
      SetDisplayedLines(FEditLines.FMouseOverLines);
      AdjustHeight;
    end;
  end;
  FMouseInControl := True;
end;
{=====}

procedure TO32CustomFlexEdit.CMMouseLeave(var Message : TMessage);
begin
  inherited;
{$IFDEF ButtonOkay}
  if FButton.Focused then exit;
{$ENDIF}
  if Enabled and FMouseInControl and MultiLineEnabled then begin
    if (Focused) then begin
      if FDisplayedLines <> FEditLines.FocusedLines then
        SetDisplayedLines(FEditLines.FocusedLines);
    end else begin
      if FDisplayedLines <> FEditLines.DefaultLines then
        SetDisplayedLines(FEditLines.DefaultLines);
    end;
    AdjustHeight;
  end;
  FMouseInControl := False;
end;
{=====}

{$IFNDEF LCL}
procedure TO32CustomFlexEdit.CMGotFocus(var Message : TMessage);
{$ELSE}
procedure TO32CustomFlexEdit.CMGotFocus(var Message : TLMSetFocus);
{$ENDIF}
begin
  inherited;
  if Enabled and MultiLineEnabled then begin
    if FDisplayedLines <> FEditLines.FocusedLines then begin
      SetDisplayedLines(FEditLines.FocusedLines);
      AdjustHeight;
    end;
  end;
{$IFNDEF LCL}  // AutoSelect is False by default in LCL TEdit
  if AutoSelect then
    SelectAll;
{$ENDIF}    
  SaveEditString;
end;
{=====}

{$IFNDEF LCL}
procedure TO32CustomFlexEdit.CMLostFocus(var Message : TMessage);
{$ELSE}
procedure TO32CustomFlexEdit.CMLostFocus(var Message : TLMKillFocus);
{$ENDIF}
begin
  inherited;
  if Enabled and MultiLineEnabled then begin
    if FMouseInControl then begin
      if FDisplayedLines <> FEditLines.MouseOverLines then
        SetDisplayedLines(FEditLines.MouseOverLines);
    end else begin
      if FDisplayedLines <> FEditLines.DefaultLines then
        SetDisplayedLines(FEditLines.DefaultLines);
    end;
    AdjustHeight;
  end;
end;
{=====}

{ - added}
procedure TO32CustomFlexEdit.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustHeight;
end;
{=====}

function TO32CustomFlexEdit.GetText: String;
begin
  result := FStrings.Text;
end;
{=====}

procedure TO32CustomFlexEdit.SetText(const Value: String);
var
  buffer: String;
  i  : Integer;
begin
  buffer := Value;

  if buffer <> '' then begin
    if not MultiLineEnabled then
    {strip out cr and lf's}
//      for i := Length(buffer) downto 0 do  <== TurboPower bug!
      for i := Length(buffer) downto 1 do
        if (buffer[i] = #13) or (buffer[i] = #10) then begin
          Delete(buffer, i, 1);
          if ((buffer[i - 1] <> ' ') and (buffer[i - 1] <> #10)
          and (buffer[i - 1] <> #13))and (buffer[i] <> ' ') then
            Insert(' ', buffer, i);
        end;
  end;

  FStrings.Text := buffer;

  SetTextBuf(PAnsiChar(buffer));

  if Borders.Active then Borders.RedrawControl;
end;
{=====}

function TO32CustomFlexEdit.GetColor: TColor;
begin
  Result := inherited Color;
end;
{=====}

procedure TO32CustomFlexEdit.SetColor( Value: TColor );
begin
  if Color <> Value then begin
    inherited Color := Value;
    FColor := Value;
    if Borders.Active then Borders.RedrawControl;
  end;
end;
{=====}

procedure TO32CustomFlexEdit.KeyPress(var Key: Char);
begin
  inherited KeyPress(Key);
  if (Key = Char(VK_RETURN)) then
    if not FWantReturns then
      Key := #0
    else begin
      if TFlexEditStrings(FStrings).Count >= FMaxLines then
        Key := #0;
    end;
end;
{=====}

procedure TO32CustomFlexEdit.CreateWnd;
begin
  if (FUpdating > 0) then exit;

  inherited CreateWnd;

  {force button placement}
  SetBounds(Left, Top, Width, Height);

{$IFDEF ButtonOkay}
  FButton.Enabled := GetButtonEnabled;
{$ENDIF}
  AdjustHeight;

  if Validation <> nil then
    Validation.AttachTo(Self);
end;

{$IFNDEF LCL}  //With LCL, will never be called since not in ancestor
procedure TO32CustomFlexEdit.CreateWindowHandle(const Params: TCreateParams);
begin
  if (FUpdating > 0) then exit;

  if not HandleAllocated then begin
    if (csDesigning in ComponentState) then
      inherited
    else begin
      with Params do
        WindowHandle := CreateWindowEx(ExStyle, WinClassName, '', Style,
          X, Y, Width, Height, WndParent, 0, WindowClass.HInstance,
          Param);
      SendMessage(WindowHandle, WM_SETTEXT, 0, Longint(Caption));
    end;
  end;
end;
{$ENDIF}
{=====}

procedure TO32CustomFlexEdit.AdjustHeight;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
  Str: String;
begin
  if (FUpdating > 0) then exit;

  if FCreating then exit;

  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  if NewStyleControls then
  begin
    if Ctl3D then I := 8 else I := 6;
    I := GetSystemMetrics(SM_CYBORDER) * I;
  end else
  begin
    I := SysMetrics.tmHeight;
    if I > Metrics.tmHeight then I := Metrics.tmHeight;
    I := I div 4 + GetSystemMetrics(SM_CYBORDER) * 4;
  end;
  Height := (Metrics.tmHeight * FDisplayedLines) + I;
  if Borders.Active and not FCreating then begin
    Str := Text;
    Borders.RedrawControl;
    Text := Str;
  end;
end;
{=====}

function TO32CustomFlexEdit.GetButtonEnabled : Boolean;
begin
  result := (not ReadOnly);
end;
{=====}

procedure TO32CustomFlexEdit.SetMaxLines(Value: Integer);
var
  buffer: String;
begin
  if Value <> FMaxLines then begin
    FMaxLines := Value;
    TFlexEditStrings(FStrings).Capacity := FMaxLines;
    buffer := FStrings.Text;
    if buffer <> '' then
      while (buffer[Length(buffer)] = #13) or (buffer[Length(buffer)] = #10) do
        Delete(buffer, Length(buffer), 1);
    FStrings.Text := buffer;
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SaveEditString;
begin
  if (Text <> FSaveEdit) then
    FSaveEdit := Text;
end;
{=====}

procedure TO32CustomFlexEdit.DoOnChange;
begin
  if Assigned(OnChange) then
    OnChange(Self);
end;
{=====}

function TO32CustomFlexEdit.GetButtonWidth : Integer;
begin
  if FShowButton then begin
    Result := GetSystemMetrics(SM_CXHSCROLL);
    if Assigned(FButtonGlyph) and not FButtonGlyph.Empty then
      if FButtonGlyph.Width + 4 > Result then
        Result := FButtonGlyph.Width + 4;
  end else
    Result := 0;
end;
{=====}

function TO32CustomFlexEdit.GetButtonGlyph : TBitmap;
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  Result := FButtonGlyph
end;
{=====}

procedure TO32CustomFlexEdit.GlyphChanged;
begin
end;
{=====}

procedure TO32CustomFlexEdit.Loaded;
begin
  inherited Loaded;

{$IFDEF ButtonOkay}
  if Assigned(FButtonGlyph) then
    FButton.Glyph.Assign(FButtonGlyph);
{$ENDIF}
end;
{=====}

{ - rewritten to solve the "Text disappearing at alignment change" bug. }
procedure TO32CustomFlexEdit.SetAlignment(Value: TAlignment);
var
  Str: string;
begin
{$IFDEF LCL}
  if Value <> taLeftJustify then
    Exit;  {taCenter and taRightJustify not supported and crash IDE, so ignore}
{$ENDIF}
  if FAlignment <> Value then
  begin
    Str := Text;
    FAlignment := Value;
{$IFNDEF LCL}
    RecreateWnd;
{$ELSE}
    MyMisc.RecreateWnd(Self);
{$ENDIF}
    Text := Str;
  end;
end;
{=====}

function TO32CustomFlexEdit.MultiLineEnabled: Boolean;
begin
  { The control is only multi-line able if either WordWrap or WantReturns is }
  { set and Password char is not being used }
  result := (FWantReturns or FWordWrap) and (PasswordChar = #0);
end;
{=====}

procedure TO32CustomFlexEdit.ButtonClick;
var
  P: TPoint;
begin
  if (Assigned(FOnButtonClick)) then begin
    {Get the screen coordinates of the bottom-left or bottom-right corner of
    the control.}
    if PopupAnchor = paLeft then
      P := Point(Left, Top + Height)
    else
      P := Point(Left + Width, Top + Height);

    {Call the user defined event handler, passing the desired popup point}
    FOnButtonClick(Self, P);
  end;
end;
{=====}

procedure TO32CustomFlexEdit.Restore;
  {-restore the previous contents of the FlexEdit}
var
  CursorPos: Integer;
begin
  BeginUpdate;
  CursorPos := SelStart;
  Text := FSaveEdit;
  Repaint;
  DoOnChange;
  SelStart := CursorPos;
  EndUpdate;
end;
{=====}

procedure TO32CustomFlexEdit.BeginUpdate;
begin
  Inc(FUpdating);
  Validation.BeginUpdate;
end;
{=====}

procedure TO32CustomFlexEdit.EndUpdate;
begin
  Dec(FUpdating);
  Validation.EndUpdate;
  if (FUpdating < 0) then
    FUpdating := 0;
end;
{=====}

procedure TO32CustomFlexEdit.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
var
  CHgt : Integer;
begin
  if (FUpdating > 0) then exit;

  inherited SetBounds(ALeft, ATop, AWidth, AHeight);

  if not HandleAllocated then
    Exit;

{$IFDEF ButtonOkay}
  if not FShowButton then begin
    FButton.Height := 0;
    FButton.Width := 0;
    Exit;
  end;

  CHgt := ClientHeight;
  if BorderStyle = bsNone then begin
    FButton.Height := CHgt;
    FButton.Width := GetButtonWidth;
    FButton.Left := Width - FButton.Width;
    FButton.Top := 0;
  end else if Ctl3D then begin
    FButton.Height := CHgt;
    FButton.Width := GetButtonWidth;
    FButton.Left := Width - FButton.Width - 4;
    FButton.Top := 0;
  end else begin
    FButton.Height := CHgt - 2;
    FButton.Width := GetButtonWidth;
{$IFNDEF ButtonNotChild}
    FButton.Left := Width - FButton.Width - 1;
    FButton.Top := 1;
{$ELSE}
    FButton.Left := Left + Width - FButton.Width - 1;
    FButton.Top := Top + 1;
{$ENDIF}
  end;
{$ENDIF}
end;
{=====}

procedure TO32CustomFlexEdit.SetButtonGlyph(Value : TBitmap);
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  if not Assigned(Value) then begin
    FButtonGlyph.Free;
    FButtonGlyph := TBitmap.Create;
  end else
    FButtonGlyph.Assign(Value);

  GlyphChanged;

{$IFDEF ButtonOkay}
  FButton.Glyph.Assign(FButtonGlyph);
{$ENDIF}
  SetBounds(Left, Top, Width, Height);
end;
{=====}

procedure TO32CustomFlexEdit.SetShowButton(Value : Boolean);
begin
  if Value <> FShowButton then begin
    FShowButton := Value;
    {force resize and redisplay of button}
    SetBounds(Left, Top, Width, Height);
  end;
end;
{=====}

function TO32CustomFlexEdit.GetBoolean: Boolean;
begin
 result := (AnsiUpperCase(Text) = AnsiUppercase(RSTrue));
end;
{=====}

function TO32CustomFlexEdit.GetYesNo: Boolean;
begin
  result := (AnsiUpperCase(Text) = AnsiUppercase(RSYes));
end;
{=====}

function TO32CustomFlexEdit.GetDateTime: TDateTime;
begin
  try
    result := StrToDateTime(Text);
  except
    result := 0;
  end;
end;
{=====}

function TO32CustomFlexEdit.GetDouble: Double;
begin
  try
    result := StrToFloat(Text);
  except
    result := -1;
  end;
end;
{=====}

function TO32CustomFlexEdit.GetExtended: Extended;
begin
  {Note: StrToFloat returns an Extended}
  try
    result := StrToFloat(Text);
  except
    result := -1;
  end;
end;
{=====}

function TO32CustomFlexEdit.GetInteger: Integer;
begin
  result := StrToIntDef(Text, -1);
end;
{=====}

function TO32CustomFlexEdit.GetStrings: TStrings;
begin
  result := TStrings(FStrings);
end;
{=====}

function TO32CustomFlexEdit.GetVariant: Variant;
begin
  result := Text;
end;
{=====}

procedure TO32CustomFlexEdit.SetBoolean(Value: Boolean);
begin
  if Value then
    Text := 'True'
  else
    Text := 'False';
end;
{=====}

procedure TO32CustomFlexEdit.SetYesNo(Value: Boolean);
begin
  if Value then
    Text := 'Yes'
  else
    Text := 'No';
end;
{=====}

procedure TO32CustomFlexEdit.SetDateTime(Value: TDateTime);
begin
  Text := DateTimeToStr(Value);
end;
{=====}

(*
procedure TO32CustomFlexEdit.SetDataType(Value : TO32FlexEditDataType);
begin
 { TODO : Implement }
end;
{=====}
*)

procedure TO32CustomFlexEdit.SetDouble(Value: Double);
begin
  Text := FloatToStr(Value);
end;
{=====}

procedure TO32CustomFlexEdit.SetExtended(Value: Extended);
begin
  Text := FloatToStr(Value);
end;
{=====}

procedure TO32CustomFlexEdit.SetInteger(Value: Integer);
begin
  Text := IntToStr(Value);
end;
{=====}

procedure TO32CustomFlexEdit.SetStrings(Value: TStrings);
begin
  FStrings.Assign(Value);
  Invalidate;
end;
{=====}

procedure TO32CustomFlexEdit.SetVariant(Value: Variant);
begin
  try
    Text := Value;
  except
    Text := '';
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SetDisplayedLines(Value: Integer);
var
  buffer: String;
begin
  if Value <> FDisplayedLines then begin
    buffer := Text;
    FDisplayedLines := Value;
    AdjustHeight;
    Text:= Buffer;
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SetWordWrap(Value: Boolean);
var
  buffer: String;
begin
  if Value <> FWordWrap then
  begin
    buffer := Text;
    FWordWrap := Value;
{$IFNDEF LCL}
    RecreateWnd;
{$ELSE}
    MyMisc.RecreateWnd(Self);
{$ENDIF}    
    Text:= buffer;
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SetWantReturns (Value : Boolean);
var
  buffer: String;
begin
  if Value <> FWantReturns then
  begin
    buffer := Text;
    FWantReturns := Value;
{$IFNDEF LCL}
    RecreateWnd;
{$ELSE}
    MyMisc.RecreateWnd(Self);
{$ENDIF}    
    Text:= buffer;
  end;
end;
{=====}

procedure TO32CustomFlexEdit.SetWantTabs(Value : Boolean);
var
  buffer: String;
begin
  if Value <> FWantTabs then
  begin
    buffer := Text;
    FWantTabs := Value;
{$IFNDEF LCL}
    RecreateWnd;
{$ELSE}
    MyMisc.RecreateWnd(Self);
{$ENDIF}
    Text:= buffer;
  end;
end;
    
{$IFDEF LCL}
// Eliminates LCL "[Type1] can not have [Type2] as child" runtime message,
//  but button still doesn't work with all widgetsets. See Lazarus bug 7097.
function TO32CustomFlexEdit.ChildClassAllowed(ChildClass: TClass): Boolean;
begin
  Result := True;
end;
{$ENDIF}


end.
