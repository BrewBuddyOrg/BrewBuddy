{*********************************************************}
{*                     OVCBCALC.PAS 4.06                 *}
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


unit ovcbcalc;
  {-base edit field class w/ label and borders}

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, MyMisc, {$ENDIF} 
  Buttons, Classes, Controls, ExtCtrls, Forms, Graphics, Menus,
  {$IFDEF VERSION4}{$IFNDEF LCL} MultiMon, {$ENDIF}{$ENDIF}
  StdCtrls, SysUtils, OvcBase, OvcVer, OvcMisc,
  OvcEditF, OvcBordr, OvcEdClc, ovcCalc, ovcEdPop;

const
  BorderMsgClose = WM_USER+10;
  BorderMsgOpen  = WM_USER+11;

type
  TOvcPopupEvent =
    procedure(Sender : TObject) of object;

  TOvcPopupAnchor = (paLeft, paRight);


  TOvcBorderEdPopup = class;

  TOvcNumberEditEx = class(TOvcNumberEdit)
  protected
    BorderParent : TOvcBorderEdPopup;
  end;

  TOvcBorderEdPopup = class(TOvcBorderParent)
  protected {private}
    {new property variables}
    FEdit          : TOvcCustomEdit;
    FButton        : TOvcEdButton;

    FButtonGlyph   : TBitmap;
    FController    : TOvcController;
    FPopupActive   : Boolean;
    FPopupAnchor   : TOvcPopupAnchor;
    FOnPopupClose  : TOvcPopupEvent;
    FOnPopupOpen   : TOvcPopupEvent;
    FShowButton    : Boolean;


  protected
    {property methods}
    function  GetButtonGlyph : TBitmap;

    procedure SetButtonGlyph(Value : TBitmap);
    procedure SetShowButton(Value : Boolean);

    {internal methods}
    function GetButtonWidth : Integer;

{$IFDEF VERSION4}
    procedure CMDialogKey(var Msg : TCMDialogKey);
      message CM_DIALOGKEY;
{$ENDIF}

    procedure CreateParams(var Params : TCreateParams);
      override;
    procedure CreateWnd;
      override;

    function GetButtonEnabled : Boolean;
      dynamic;
    procedure GlyphChanged;
      dynamic;
    procedure Loaded;
      override;

    procedure OnMsgClose(var M : TMessage);
      message BorderMsgClose;
    procedure OnMsgOpen(var M : TMessage);
      message BorderMsgOpen;

  public
    constructor Create(AOwner : TComponent);
      override;
    destructor Destroy;
      override;

    procedure PopupClose(Sender : TObject);
      dynamic;
    procedure PopupOpen;
      dynamic;

    procedure SetBounds(ALeft, ATop, AWidth, AHeight: Integer);
      override;

    procedure SetEditControl(EC : TOvcCustomEdit); override;

    property Canvas;

    property PopupActive : Boolean
      read FPopupActive;

    property PopupAnchor : TOvcPopupAnchor
      read FPopupAnchor
      write FPopupAnchor;

  published
    property ButtonGlyph : TBitmap
      read GetButtonGlyph
      write SetButtonGlyph;
  end;


  TOvcBorderedNumberEdit = class(TOvcBorderEdPopup)
  protected
    {base property values}
    FOvcEdit : TOvcNumberEditEx;

    {$IFDEF VERSION4}
{$IFNDEF LCL}
    FBiDiMode      : TBiDiMode;
{$ENDIF}
    FConstraints   : TSizeConstraints;
    FParentBiDiMode: Boolean;
    FDragKind      : TDragKind;
    {$ENDIF}
    FAbout         : string;
{$IFNDEF LCL}
    FAutoSelect    : Boolean;
{$ENDIF}
    FAutoSize      : Boolean;
    FBorderStyle   : TBorderStyle;
    FCharCase      : TEditCharCase;
    FController    : TOvcController;
    FCursor        : TCursor;
    FDragCursor    : TCursor;
    FDragMode      : TDragMode;
    FEnabled       : Boolean;
    FFont          : TFont;
    FHeight        : integer;
{$IFNDEF LCL}
    FHideSelection : Boolean;
    FImeMode       : TImeMode;
{$ENDIF}
    FImeName       : string;
    FMaxLength     : Integer;
{$IFNDEF LCL}
    FOEMConvert    : Boolean;
{$ENDIF}
    FParentFont    : Boolean;
    FParentShowHint: Boolean;
    FPasswordChar  : Char;
    FPopupMenu     : TPopupMenu;
    FReadOnly      : Boolean;
    FShowHint      : Boolean;
    FTabOrder      : TTabOrder;
    FVisible       : Boolean;
    FWidth         : integer;

    {events}
    FOnChange      : TNotifyEvent;
    FOnClick       : TNotifyEvent;
    FOnDblClick    : TNotifyEvent;
    FOnDragDrop    : TDragDropEvent;
    FOnDragOver    : TDragOverEvent;

    FOnEndDrag     : TEndDragEvent;
    FOnEnter       : TNotifyEvent;
    FOnExit        : TNotifyEvent;
    FOnKeyDown     : TKeyEvent;
    FOnKeyPress    : TKeyPressEvent;
    FOnKeyUp       : TKeyEvent;
    FOnMouseDown   : TMouseEvent;
    FOnMouseMove   : TMouseMoveEvent;
    FOnMouseUp     : TMouseEvent;
    FOnStartDrag   : TStartDragEvent;


    FAllowIncDec     : Boolean;
    FCalculator      : TOvcCalculator;

    {internal variables}
    PopupClosing     : Boolean;
    HoldCursor       : TCursor;
    WasAutoScroll    : Boolean;

    {base property methods}
    {$IFDEF VERSION4}
     {$IFNDEF LCL}
    function GetBiDiMode : TBiDiMode;
     {$ENDIF}
    function GetDragKind : TDragKind;
     {$IFNDEF LCL}
    function GetParentBiDiMode : Boolean;
     {$ENDIF}

{$IFNDEF LCL}
    procedure SetBiDiMode(Value : TBiDiMode); override;
{$ENDIF}
    procedure SetDragKind(Value : TDragKind);
{$IFNDEF LCL}
    procedure SetParentBiDiMode(Value : Boolean); override;
{$ENDIF}
    {$ENDIF}

    function GetAbout : string;
{$IFNDEF LCL}
    function GetAutoSelect : Boolean;
{$ENDIF}
    function GetAutoSize : Boolean;
    function GetCharCase : TEditCharCase;
    function GetController : TOvcController;
    function GetCursor : TCursor;
    function GetDragCursor : TCursor;
    function GetDragMode : TDragMode;
    function GetEditEnabled : Boolean;
    function GetFont : TFont;
{$IFNDEF LCL}
    function GetHideSelection : Boolean;
    function GetImeMode : TImeMode;
    function GetImeName : string;
{$ENDIF}
    function GetMaxLength : Integer;
{$IFNDEF LCL}
    function GetOEMConvert : Boolean;
{$ENDIF}
    function GetParentShowHint : Boolean;
    function GetPasswordChar : Char;
    function GetReadOnly : Boolean;
    function GetEditShowButton : Boolean;

    function GetParentFont : Boolean;
    function GetEditParentShowHint : Boolean;

    function GetOnChange   : TNotifyEvent;
    function GetOnClick    : TNotifyEvent;
    function GetOnDblClick : TNotifyEvent;
    function GetOnDragDrop : TDragDropEvent;
    function GetOnDragOver : TDragOverEvent;
    function GetOnEndDrag  : TEndDragEvent;
    function GetOnKeyDown  : TKeyEvent;
    function GetOnKeyPress : TKeyPressEvent;
    function GetOnKeyUp    : TKeyEvent;
    function GetOnMouseDown: TMouseEvent;
    function GetOnMouseMove: TMouseMoveEvent;
    function GetOnMouseUp  : TMouseEvent;

    function  GetOnPopupClose : TOvcPopupEvent;
    function  GetOnPopupOpen : TOvcPopupEvent;
    function  GetPopupAnchor : TOvcPopupAnchor;

    procedure SetAbout(const Value : string);
{$IFNDEF LCL}
    procedure SetAutoSelect(Value : Boolean);
{$ENDIF}
    procedure SetAutoSize(Value : Boolean); {$IFDEF VERSION6}{$IFNDEF LCL} override;{$ENDIF}{$ENDIF}
    procedure SetCharCase(Value : TEditCharCase);
    procedure SetCursor(Value : TCursor);
    procedure SetDragCursor(Value : TCursor);
    procedure SetEditController(Value : TOvcController);
    procedure SetEditDragMode(Value : TDragMode);
    procedure SetEditEnabled(Value : Boolean);
    procedure SetFont(Value : TFont);
{$IFNDEF LCL}
    procedure SetHideSelection(Value : Boolean);
    procedure SetImeMode(Value : TImeMode);
    procedure SetImeName(const Value : string);
{$ENDIF}
    procedure SetMaxLength(Value : Integer);
{$IFNDEF LCL}
    procedure SetOEMConvert(Value : Boolean);
{$ENDIF}
    procedure SetParentShowHint(Value : Boolean);
    procedure SetPasswordChar(Value : Char);
    procedure SetReadOnly(Value : Boolean);
    procedure SetEditShowButton(Value : Boolean);

    procedure SetOnChange(Value : TNotifyEvent);
    procedure SetOnClick(Value : TNotifyEvent);
    procedure SetOnDblClick(Value : TNotifyEvent);
    procedure SetOnDragDrop(Value : TDragDropEvent);
    procedure SetOnDragOver(Value : TDragOverEvent);
    procedure SetOnEndDrag(Value : TEndDragEvent);
    procedure SetOnKeyDown(Value : TKeyEvent);
    procedure SetOnKeyPress(Value : TKeyPressEvent);
    procedure SetOnKeyUp(Value : TKeyEvent);
    procedure SetOnMouseDown(Value : TMouseEvent);
    procedure SetOnMouseMove(Value : TMouseMoveEvent);
    procedure SetOnMouseUp(Value : TMouseEvent);

    procedure SetOnPopupClose(Value : TOvcPopupEvent);
    procedure SetOnPopupOpen(Value : TOvcPopupEvent);
    procedure SetPopupAnchor(Value : TOvcPopupAnchor);


    {property methods}
    function GetAsFloat : Double;
    function GetAsInteger : LongInt;
    function GetAsString : string;
    function GetPopupColors : TOvcCalcColors;
    function GetPopupDecimals : Integer;
    function GetPopupFont : TFont;
    function GetPopupHeight : Integer;
    function GetPopupWidth : Integer;
    procedure SetAsFloat(Value : Double);
    procedure SetAsInteger(Value : LongInt);
    procedure SetAsString(const Value : string);
    procedure SetPopupColors(Value : TOvcCalcColors);
    procedure SetPopupDecimals(Value : Integer);
    procedure SetPopupFont(Value : TFont);
    procedure SetPopupHeight(Value : Integer);
    procedure SetPopupWidth(Value : Integer);

    procedure SetParentFont(Value : Boolean);
    procedure SetEditParentShowHint(Value : Boolean);

  protected
    procedure GlyphChanged;
      override;

  public
    constructor Create(AOwner : TComponent);
      override;

    destructor Destroy; override;

    property AsInteger : LongInt
      read GetAsInteger
      write SetAsInteger;

    property AsFloat : Double
      read GetAsFloat
      write SetAsFloat;

    property AsString : string
      read GetAsString
      write SetAsString;

    property Calculator : TOvcCalculator
      read FCalculator;

    property EditControl : TOvcNumberEditEx
      read FOvcEdit;


  published
    {$IFDEF VERSION4}
    property Anchors;

{$IFNDEF LCL}
    property BiDiMode : TBiDiMode
      read GetBiDiMode
      write SetBiDiMode;
{$ENDIF}

    property Constraints;

{$IFNDEF LCL}
    property ParentBiDiMode : Boolean
      read GetParentBiDiMode
      write SetParentBiDiMode;
{$ENDIF}

    property DragKind : TDragKind
      read GetDragKind
      write SetDragKind;
    {$ENDIF}

    property About : string
      read GetAbout
      write SetAbout;

    property AllowIncDec : Boolean
      read FAllowIncDec
      write FAllowIncDec;

{$IFNDEF LCL}
    property AutoSelect : Boolean
      read GetAutoSelect
      write SetAutoSelect;
{$ENDIF}

    property AutoSize : Boolean
      read GetAutoSize
      write SetAutoSize;

    property CharCase : TEditCharCase
      read GetCharCase
      write SetCharCase;

    property Controller : TOvcController
      read GetController
      write SetEditController;

    property Cursor : TCursor
      read GetCursor
      write SetCursor;

    property DragCursor : TCursor
      read GetDragCursor
      write SetDragCursor;

    {$IFDEF VERSION4}
    property DragMode : TDragMode
      read GetDragMode
      write SetDragMode;
    {$ENDIF}

    property Enabled : Boolean
      read FEnabled
      write FEnabled;

    property Font : TFont
      read GetFont
      write SetFont;

{$IFNDEF LCL}
    property HideSelection : Boolean
      read GetHideSelection
      write SetHideSelection;

    property ImeMode : TImeMode
      read GetImeMode
      write SetImeMode;

    property ImeName;
{$ENDIF}

    property MaxLength : integer
      read GetMaxLength
      write SetMaxLength;

{$IFNDEF LCL}
    property OEMConvert : Boolean
      read GetOEMConvert
      write SetOEMConvert;
{$ENDIF}

    property ParentFont : Boolean
      read GetParentFont
      write SetParentFont;

    property ParentShowHint : Boolean
      read GetParentShowHint
      write SetParentShowHint;

    property PasswordChar : Char
      read GetPasswordChar
      write SetPasswordChar;

    property PopupAnchor : TOvcPopupAnchor
      read GetPopupAnchor
      write SetPopupAnchor;

    property PopupColors : TOvcCalcColors
      read GetPopupColors
      write SetPopupColors;

    property PopupDecimals : Integer
      read GetPopupDecimals
      write SetPopupDecimals;

    property PopupFont : TFont
      read GetPopupFont
      write SetPopupFont;

    property PopupHeight : Integer
      read GetPopupHeight
      write SetPopupHeight;

    property PopupMenu;

    property PopupWidth : Integer
      read GetPopupWidth
      write SetPopupWidth;

    property ReadOnly : Boolean
      read GetReadOnly
      write SetReadOnly;

    property ShowButton : Boolean
      read GetEditShowButton
      write SetEditShowButton;

    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;

    {events}
    property OnChange : TNotifyEvent
      read GetOnChange
      write SetOnChange;

    property OnClick : TNotifyEvent
      read GetOnClick
      write SetOnClick;

    property OnDblClick : TNotifyEvent
      read GetOnDblClick
      write SetOnDblClick;

    property OnDragDrop : TDragDropEvent
      read GetOnDragDrop
      write SetOnDragDrop;

    property OnDragOver : TDragOverEvent
      read GetOnDragOver
      write SetOnDragOver;

    property OnEndDrag : TEndDragEvent
      read GetOnEndDrag
      write SetOnEndDrag;

    property OnEnter;
    property OnExit;

    property OnKeyDown : TKeyEvent
      read GetOnKeyDown
      write SetOnKeyDown;

    property OnKeyPress : TKeyPressEvent
      read GetOnKeyPress
      write SetOnKeyPress;

    property OnKeyUp : TKeyEvent
      read GetOnKeyUp
      write SetOnKeyUp;

    property OnMouseDown : TMouseEvent
      read GetOnMouseDown
      write SetOnMouseDown;

    property OnMouseMove : TMouseMoveEvent
      read GetOnMouseMove
      write SetOnMouseMove;

    property OnMouseUp : TMouseEvent
      read GetOnMouseUp
      write SetOnMouseUp;
    property OnStartDrag;

    property OnPopupClose : TOvcPopupEvent
      read GetOnPopupClose
      write SetOnPopupClose;

    property OnPopupOpen : TOvcPopupEvent
      read GetOnPopupOpen
      write SetOnPopupOpen;
  end;


implementation

constructor TOvcBorderEdPopup.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  ControlStyle := ControlStyle - [csSetCaption];

  ButtonWidth := ButtonGlyph.Width;
  DoShowButton := FShowButton;
end;


procedure TOvcBorderEdPopup.CreateParams(var Params : TCreateParams);
begin
  inherited CreateParams(Params);

  Params.Style := Params.Style or WS_CLIPCHILDREN;
end;

procedure TOvcBorderEdPopup.CreateWnd;
begin
  inherited CreateWnd;

  {force button placement}
  SetBounds(Left, Top, Width, Height);

  if (Assigned(FButton)) then
    FButton.Enabled := GetButtonEnabled;
end;

destructor TOvcBorderEdPopup.Destroy;
begin
  { Freeing the button glyph throws access violation for some reason }
  { we'll just let it leak for now. }
//  if FButtonGlyph <> nil then
//    FButtonGlyph.Free;
  inherited Destroy;
end;



function TOvcBorderEdPopup.GetButtonEnabled : Boolean;
begin
  Result := not TOvcEdit(FEdit).ReadOnly;
end;


function TOvcBorderEdPopup.GetButtonWidth : Integer;
begin
  if FShowButton then begin
    Result := GetSystemMetrics(SM_CXHSCROLL);
    if Assigned(FButtonGlyph) and not FButtonGlyph.Empty then
      if FButtonGlyph.Width + 4 > Result then
        Result := FButtonGlyph.Width + 4;
  end else
    Result := 0;
end;

function TOvcBorderEdPopup.GetButtonGlyph : TBitmap;
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  Result := FButtonGlyph
end;

procedure TOvcBorderEdPopup.GlyphChanged;
begin
end;

procedure TOvcBorderEdPopup.Loaded;
begin
  inherited Loaded;

  if Assigned(FButtonGlyph) then
    FButton.Glyph.Assign(FButtonGlyph);
end;


procedure TOvcBorderEdPopup.OnMsgClose(var M : TMessage);
begin
  if (Assigned(FOnPopupClose)) then
    FOnPopupClose(Self);
end;

procedure TOvcBorderEdPopup.OnMsgOpen(var M : TMessage);
begin
  if (Assigned(FOnPopupOpen)) then
    FOnPopupOpen(Self);
end;


procedure TOvcBorderEdPopup.PopupClose;
begin
  FPopupActive := False;
  PostMessage(Handle, BorderMsgClose, 0, 0);
end;

procedure TOvcBorderEdPopup.PopupOpen;
begin
  FPopupActive := True;
  PostMessage(Handle, BorderMsgOpen, 0, 0);
end;


procedure TOvcBorderEdPopup.SetEditControl(EC : TOvcCustomEdit);
begin
  inherited SetEditControl(EC);
  FEdit := EC;
end;

procedure TOvcBorderEdPopup.SetButtonGlyph(Value : TBitmap);
begin
  if not Assigned(FButtonGlyph) then
    FButtonGlyph := TBitmap.Create;

  if not Assigned(Value) then begin
    FButtonGlyph.Free;
    FButtonGlyph := TBitmap.Create;
  end else
    FButtonGlyph.Assign(Value);

  GlyphChanged;

  FButton.Glyph.Assign(FButtonGlyph);
  SetBounds(Left, Top, Width, Height);
end;

procedure TOvcBorderEdPopup.SetShowButton(Value : Boolean);
begin
  FShowButton := Value;
  {force resize and redisplay of button}
  SetBounds(Left, Top, Width, Height);
end;

{$IFDEF VERSION4}
procedure TOvcBorderEdPopup.CMDialogKey(var Msg : TCMDialogKey);
begin
(*
  if PopupActive then begin
    with Msg do begin
      if ((CharCode = VK_RETURN) or (CHarCode = VK_ESCAPE)) then begin
        PopupClose(Self);
        Result := 1;
      end;
    end;
  end else
    inherited;
*)
end;
{$ENDIF}


procedure TOvcBorderEdPopup.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
end;


{******************************************************************************}
{                        TOvcBorderedNumberEdit                                }
{******************************************************************************}

constructor TOvcBorderedNumberEdit.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  FOvcEdit := TOvcNumberEditEx.Create(Self);
  SetEditControl(TOvcCustomEdit(FOvcEdit));

  FOvcEdit.Ctl3D := False;
  FOvcEdit.BorderStyle := bsNone;
  FOvcEdit.ParentColor := True;
  FOvcEdit.Parent := Self;
  FOvcEdit.Top := 0;
  FOvcEdit.Left := 0;
  FOvcEdit.TabStop := TabStop;
  FOvcEdit.BorderParent := Self;

  DoShowButton := FOvcEdit.ShowButton;
  ButtonWidth := FOvcEdit.ButtonGlyph.Width + 4;

  Height := FEdit.Height;
  Width  := FEdit.Width;
  Borders.BottomBorder.Enabled := True;

  FController    := FOvcEdit.Controller;
  FButton        := FOvcEdit.FButton;
  FButtonGlyph   := FOvcEdit.FButtonGlyph;
  FPopupActive   := FOvcEdit.FPopupActive;
  FOnPopupClose  := FOvcEdit.FOnPopupClose;
  FShowButton    := FOvcEdit.FShowButton;

  {$IFDEF VERSION4}
   {$IFNDEF LCL}
  FBiDiMode      := FOvcEdit.BiDiMode;
   {$ENDIF}
  FDragKind      := FOvcEdit.DragKind;
   {$IFNDEF LCL}
  FParentBiDiMode:= FOvcEdit.ParentBiDiMode;
   {$ENDIF}
  {$ENDIF}
  FAbout         := FOvcEdit.About;
   {$IFNDEF LCL}
  FAutoSelect    := FOvcEdit.AutoSelect;
   {$ENDIF}
  FAutoSize      := FOvcEdit.AutoSize;
  FBorderStyle   := FOvcEdit.BorderStyle;
  FCharCase      := FOvcEdit.CharCase;
  FCursor        := FOvcEdit.Cursor;
  FDragCursor    := FOvcEdit.DragCursor;
  FDragMode      := FOvcEdit.DragMode;
  FEnabled       := True;
  FFont          := FOvcEdit.Font;
   {$IFNDEF LCL}
  FHideSelection := FOvcEdit.HideSelection;
  FImeMode       := FOvcEdit.ImeMode;
  FImeName       := FOvcEdit.ImeName;
   {$ENDIF}
  FMaxLength     := FOvcEdit.MaxLength;
   {$IFNDEF LCL}
  FOEMConvert    := FOvcEdit.OEMConvert;
   {$ENDIF}
  FParentFont    := FOvcEdit.ParentFont;
  FParentShowHint:= FOvcEdit.ParentShowHint;
  FPasswordChar  := FOvcEdit.PasswordChar;
  FPopupMenu     := FOvcEdit.PopupMenu;
  FReadOnly      := FOvcEdit.ReadOnly;
  FShowHint      := FOvcEdit.ShowHint;
  FTabOrder      := FOvcEdit.TabOrder;
  FVisible       := True;

  FOnChange      := FOvcEdit.OnChange;
  FOnClick       := FOvcEdit.OnClick;
  FOnDblClick    := FOvcEdit.OnDblClick;
  FOnDragDrop    := FOvcEdit.OnDragDrop;
  FOnDragOver    := FOvcEdit.OnDragOver;

  FOnEndDrag     := FOvcEdit.OnEndDrag;
  FOnEnter       := FOvcEdit.OnEnter;
  FOnExit        := FOvcEdit.OnExit;
  FOnKeyDown     := FOvcEdit.OnKeyDown;
  FOnKeyPress    := FOvcEdit.OnKeyPress;
  FOnKeyUp       := FOvcEdit.OnKeyUp;
  FOnMouseDown   := FOvcEdit.OnMouseDown;
  FOnMouseMove   := FOvcEdit.OnMouseMove;
  FOnMouseUp     := FOvcEdit.OnMouseUp;
  FOnStartDrag   := FOvcEdit.OnStartDrag;

  {load button glyph}
{$IFNDEF LCL}
  FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCLC');
{$ELSE}
  FButtonGlyph.LoadFromLazarusResource('ORBTNCLC');
{$ENDIF}
  FButton.Glyph.Assign(FButtonGlyph);

  FCalculator := FOvcEdit.Calculator;
end;

destructor TOvcBorderedNumberEdit.Destroy;
begin
  FOvcEdit.Free;
  FOvcEdit := nil;

  inherited Destroy;
end;


function TOvcBorderedNumberEdit.GetAsFloat : Double;
var
  I : Integer;
  S : string;
begin
  S := Text;
  for I := Length(S) downto 1 do
    if not (S[I] in ['0'..'9', '+', '-', DecimalSeparator]) then
      Delete(S, I, 1);
  Result := StrToFloat(S);
end;

function TOvcBorderedNumberEdit.GetAsInteger : LongInt;
begin
  Result := Round(GetAsFloat);
end;

function TOvcBorderedNumberEdit.GetAsString : string;
begin
  Result := Text;
end;

function TOvcBorderedNumberEdit.GetPopupColors : TOvcCalcColors;
begin
  Result := FCalculator.Colors;
end;

function TOvcBorderedNumberEdit.GetPopupDecimals : Integer;
begin
  Result := FCalculator.Decimals;
end;

function TOvcBorderedNumberEdit.GetPopupFont : TFont;
begin
  Result := FCalculator.Font;
end;

function TOvcBorderedNumberEdit.GetPopupHeight : Integer;
begin
  Result := FCalculator.Height;
end;

function TOvcBorderedNumberEdit.GetPopupWidth : Integer;
begin
  Result := FCalculator.Width;
end;

function TOvcBorderedNumberEdit.GetReadOnly : Boolean;
begin
  Result := FOvcEdit.ReadOnly;
  FReadOnly := Result;
end;

function TOvcBorderedNumberEdit.GetParentFont : Boolean;
begin
  Result := FOvcEdit.ParentFont;
  FParentFont := Result;
end;

function TOvcBorderedNumberEdit.GetEditParentShowHint : Boolean;
begin
  Result := FOvcEdit.ParentShowHint;
  FParentShowHint := Result;
end;


procedure TOvcBorderedNumberEdit.GlyphChanged;
begin
  inherited GlyphChanged;

  if FButtonGlyph.Empty then
{$IFNDEF LCL}
    FButtonGlyph.Handle := LoadBaseBitmap('ORBTNCLC');
{$ELSE}
    FButtonGlyph.LoadFromLazarusResource('ORBTNCLC');
{$ENDIF}
end;


procedure TOvcBorderedNumberEdit.SetAsFloat(Value : Double);
begin
  Text := FloatToStr(Value);
end;

procedure TOvcBorderedNumberEdit.SetAsInteger(Value : LongInt);
begin
  Text := IntToStr(Value);
end;

procedure TOvcBorderedNumberEdit.SetAsString(const Value : string);
begin
  Text := Value;
end;

procedure TOvcBorderedNumberEdit.SetPopupColors(Value : TOvcCalcColors);
begin
  FCalculator.Colors := Value;
end;

procedure TOvcBorderedNumberEdit.SetPopupDecimals(Value : Integer);
begin
  FCalculator.Decimals := Value;
end;

procedure TOvcBorderedNumberEdit.SetPopupFont(Value : TFont);
begin
  if Assigned(Value) then
    FCalculator.Font.Assign(Value);
end;

procedure TOvcBorderedNumberEdit.SetPopupHeight(Value : Integer);
begin
  FCalculator.Height := Value;
end;

procedure TOvcBorderedNumberEdit.SetPopupWidth(Value : Integer);
begin
  FCalculator.Width := Value;
end;

procedure TOvcBorderedNumberEdit.SetReadOnly(Value : Boolean);
begin
  FReadOnly := Value;
  FOvcEdit.ReadOnly := Value;
end;

procedure TOvcBorderedNumberEdit.SetParentFont(Value : Boolean);
begin
  FParentFont := Value;
  FOvcEdit.ParentFont := Value;
end;

procedure TOvcBorderedNumberEdit.SetEditParentShowHint(Value : Boolean);
begin
  FOvcEdit.ParentShowHint := Value;
  FParentShowHint := Value;
end;


function  TOvcBorderedNumberEdit.GetOnPopupClose : TOvcPopupEvent;
begin
  Result := FOvcEdit.OnPopupClose;
  FOnPopupClose := Result;
end;

function  TOvcBorderedNumberEdit.GetOnPopupOpen : TOvcPopupEvent;
begin
  Result := FOvcEdit.OnPopupOpen;
  FOnPopupOpen := Result;
end;

function  TOvcBorderedNumberEdit.GetPopupAnchor : TOvcPopupAnchor;
begin
  Result := FOvcEdit.BorderParent.PopupAnchor;
  FPopupAnchor := Result;
end;

function  TOvcBorderedNumberEdit.GetEditShowButton : Boolean;
begin
  Result := FOvcEdit.ShowButton;
  FShowButton := Result;
end;


procedure TOvcBorderedNumberEdit.SetOnPopupClose(Value : TOvcPopupEvent);
begin
  FOvcEdit.OnPopupClose := Value;
  FOnPopupClose := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnPopupOpen(Value : TOvcPopupEvent);
begin
  FOvcEdit.OnPopupOpen := Value;
  FOnPopupOpen := Value;
end;

procedure TOvcBorderedNumberEdit.SetPopupAnchor(Value : TOvcPopupAnchor);
begin
  FOvcEdit.BorderParent.PopupAnchor := Value;
  FPopupAnchor := Value;
end;

procedure TOvcBorderedNumberEdit.SetEditShowButton(Value : Boolean);
begin
  FOvcEdit.ShowButton := Value;
  FShowButton := Value;
end;


{base property methods}
{$IFDEF VERSION4}
 {$IFNDEF LCL}
function TOvcBorderedNumberEdit.GetBiDiMode : TBiDiMode;
begin
  Result := FOvcEdit.BiDiMode;
  FBiDiMode := Result;
end;
 {$ENDIF}

function TOvcBorderedNumberEdit.GetDragKind : TDragKind;
begin
  Result := FOvcEdit.DragKind;
  FDragKind := Result;
end;

(*
function TOvcBorderedNumberEdit.GetEditConstraints : TSizeConstraints;
begin
  Result := FOvcEdit.Constraints;
  FConstraints := Result;
end;
*)

{$IFNDEF LCL}
function TOvcBorderedNumberEdit.GetParentBiDiMode : Boolean;
begin
  Result := FOvcEdit.ParentBiDiMode;
  FParentBiDiMode := Result;
end;

procedure TOvcBorderedNumberEdit.SetBiDiMode(Value : TBiDiMode);
begin
  if (Value <> FBiDiMode) then begin
    inherited;
    FBiDiMode := Value;
    FOvcEdit.BiDiMode := Value;
  end;
end;
{$ENDIF}

(*
procedure TOvcBorderedNumberEdit.SetEditConstraints(Value : TSizeConstraints);
begin
  FConstraints := Value;
  FOvcEdit.Constraints := Value;
end;
*)

{$IFNDEF LCL}
procedure TOvcBorderedNumberEdit.SetParentBiDiMode(Value : Boolean);
begin
  if (Value <> FParentBiDiMode) then begin
    inherited;
    FParentBiDiMode := Value;
    FOvcEdit.ParentBiDiMode := Value;
  end;
end;
{$ENDIF}

procedure TOvcBorderedNumberEdit.SetDragKind(Value : TDragKind);
begin
  if (Value <> FDragKind) then begin
    FDragKind := Value;
    FOvcEdit.DragKind := Value;
  end;
end;
{$ENDIF}


function TOvcBorderedNumberEdit.GetAbout : string;
begin
  Result := OrVersionStr;
end;

{$IFNDEF LCL}
function TOvcBorderedNumberEdit.GetAutoSelect : Boolean;
begin
  Result := FOvcEdit.AutoSelect;
  FAutoSelect := FOvcEdit.AutoSelect;
end;
{$ENDIF}

function TOvcBorderedNumberEdit.GetAutoSize : Boolean;
begin
  Result := FOvcEdit.AutoSize;
  FAutoSize := FOvcEdit.AutoSize;
end;

function TOvcBorderedNumberEdit.GetCharCase : TEditCharCase;
begin
  Result := FOvcEdit.CharCase;
  FCharCase := Result;
end;

function TOvcBorderedNumberEdit.GetController : TOvcController;
begin
  Result := FOvcEdit.Controller;
  FController := Result;
end;

function TOvcBorderedNumberEdit.GetCursor : TCursor;
begin
  Result := FOvcEdit.Cursor;
  FCursor := Result;
end;


function TOvcBorderedNumberEdit.GetDragCursor : TCursor;
begin
  Result := FOvcEdit.DragCursor;
  FDragCursor := Result;
end;


function TOvcBorderedNumberEdit.GetDragMode : TDragMode;
begin
  Result := FOvcEdit.DragMode;
  FDragMode := Result;
end;


function TOvcBorderedNumberEdit.GetEditEnabled : Boolean;
begin
  Result := FOvcEdit.Enabled;
  FEnabled := FOvcEdit.Enabled;
end;

function TOvcBorderedNumberEdit.GetFont : TFont;
begin
  Result := FOvcEdit.Font;
  FFont  := Result;
end;

{$IFNDEF LCL}
function TOvcBorderedNumberEdit.GetHideSelection : Boolean;
begin
  Result := FOvcEdit.HideSelection;
  FHideSelection := Result;
end;

function TOvcBorderedNumberEdit.GetImeMode : TImeMode;
begin
  Result := FOvcEdit.ImeMode;
  FImeMode := Result;
end;

function TOvcBorderedNumberEdit.GetImeName : string;
begin
  Result := FOvcEdit.ImeName;
  FImeName := Result;
end;
{$ENDIF}

function TOvcBorderedNumberEdit.GetMaxLength : Integer;
begin
  Result := FOvcEdit.MaxLength;
  FMaxLength := Result;
end;

{$IFNDEF LCL}
function TOvcBorderedNumberEdit.GetOEMConvert : Boolean;
begin
  Result := FOvcEdit.OEMConvert;
  FOEMConvert := Result;
end;
{$ENDIF}

function TOvcBorderedNumberEdit.GetParentShowHint : Boolean;
begin
  Result := FOvcEdit.ParentShowHint;
  FParentShowHint := Result;
end;

function TOvcBorderedNumberEdit.GetPasswordChar : Char;
begin
  Result := FOvcEdit.PasswordChar;
  FPasswordChar := Result;
end;

function TOvcBorderedNumberEdit.GetOnChange : TNotifyEvent;
begin
  Result := FOvcEdit.OnChange;
  FOnChange := Result;
end;

function TOvcBorderedNumberEdit.GetOnClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnClick;
  FOnClick := Result;
end;

function TOvcBorderedNumberEdit.GetOnDblClick : TNotifyEvent;
begin
  Result := FOvcEdit.OnDblClick;
  FOnDblClick := Result;
end;

function TOvcBorderedNumberEdit.GetOnDragDrop : TDragDropEvent;
begin
  Result := FOvcEdit.OnDragDrop;
  FOnDragDrop := Result;
end;

function TOvcBorderedNumberEdit.GetOnDragOver : TDragOverEvent;
begin
  Result := FOvcEdit.OnDragOver;
  FOnDragOver := Result;
end;

function TOvcBorderedNumberEdit.GetOnEndDrag : TEndDragEvent;
begin
  Result := FOvcEdit.OnEndDrag;
  FOnEndDrag := Result;
end;

function TOvcBorderedNumberEdit.GetOnKeyDown : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyDown;
  FOnKeyDown := Result;
end;

function TOvcBorderedNumberEdit.GetOnKeyPress : TKeyPressEvent;
begin
  Result := FOvcEdit.OnKeyPress;
  FOnKeyPress := Result;
end;

function TOvcBorderedNumberEdit.GetOnKeyUp : TKeyEvent;
begin
  Result := FOvcEdit.OnKeyUp;
  FOnKeyUp := Result;
end;

function TOvcBorderedNumberEdit.GetOnMouseDown : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseDown;
  FOnMouseDown := Result;
end;

function TOvcBorderedNumberEdit.GetOnMouseMove : TMouseMoveEvent;
begin
  Result := FOvcEdit.OnMouseMove;
  FOnMouseMove := Result;
end;

function TOvcBorderedNumberEdit.GetOnMouseUp : TMouseEvent;
begin
  Result := FOvcEdit.OnMouseUp;
  FOnMouseUp := Result;
end;



procedure TOvcBorderedNumberEdit.SetAbout(const Value : string);
begin
end;


{$IFNDEF LCL}
procedure TOvcBorderedNumberEdit.SetAutoSelect(Value : Boolean);
begin
  if (Value <> FAutoSelect) then begin
    FAutoSelect := Value;
    FOvcEdit.AutoSelect := Value;
  end;
end;
{$ENDIF}


procedure TOvcBorderedNumberEdit.SetAutoSize(Value : Boolean);
begin
  FAutoSize := Value;
  FOvcEdit.AutoSize := Value;
end;


procedure TOvcBorderedNumberEdit.SetCharCase(Value : TEditCharCase);
begin
  FCharCase := Value;
  FOvcEdit.CharCase := Value;
end;

procedure TOvcBorderedNumberEdit.SetEditController(Value : TOvcController);
begin
  FController := Value;
  FOvcEdit.Controller := Value;
end;

procedure TOvcBorderedNumberEdit.SetCursor(Value : TCursor);
begin
  FCursor := Value;
  FOvcEdit.Cursor := Value;
end;


procedure TOvcBorderedNumberEdit.SetDragCursor(Value : TCursor);
begin
  if (Value <> FDragCursor) then begin
    FDragCursor := Value;
    FOvcEdit.DragCursor := Value;
  end;
end;


procedure TOvcBorderedNumberEdit.SetEditDragMode(Value : TDragMode);
begin
  if (Value <> FDragMode) then begin
    FDragMode := Value;
    FOvcEdit.DragMode := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetEditEnabled(Value : Boolean);
begin
  if (Value <> FEnabled) then begin
    FEnabled := Value;
    Enabled  := Value;
    FOvcEdit.Enabled := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetFont(Value : TFont);
begin
  if (Value <> FFont) then begin
    FFont := Value;
    FOvcEdit.Font := Value;
  end;
end;

{$IFNDEF LCL}
procedure TOvcBorderedNumberEdit.SetHideSelection(Value : Boolean);
begin
  if (Value <> FHideSelection) then begin
    FHideSelection := Value;
    FOvcEdit.HideSelection := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetImeMode(Value : TImeMode);
begin
  if (Value <> FImeMode) then begin
    FImeMode := Value;
    FOvcEdit.ImeMode := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetImeName(const Value : string);
begin
  if (Value <> FImeName) then begin
    FImeName := Value;
    FOvcEdit.ImeName := Value;
  end;
end;
{$ENDIF}

procedure TOvcBorderedNumberEdit.SetMaxLength(Value : Integer);
begin
  if (Value <> FMaxLength) then begin
    FMaxLength := Value;
    FOvcEdit.MaxLength := Value;
  end;
end;

{$IFNDEF LCL}
procedure TOvcBorderedNumberEdit.SetOEMConvert(Value : Boolean);
begin
  if (Value <> FOEMConvert) then begin
    FOEMConvert := Value;
    FOvcEdit.OEMConvert := Value;
  end;
end;
{$ENDIF}

procedure TOvcBorderedNumberEdit.SetParentShowHint(Value : Boolean);
begin
  if (Value <> FParentShowHint) then begin
    FParentShowHint := Value;
    FOvcEdit.ParentShowHint := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetPasswordChar(Value : Char);
begin
  if (Value <> FPasswordChar) then begin
    FPasswordChar := Value;
    FOvcEdit.PasswordChar := Value;
  end;
end;

procedure TOvcBorderedNumberEdit.SetOnChange(Value : TNotifyEvent);
begin
  FOnChange := Value;
  FOvcEdit.OnChange := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnClick(Value : TNotifyEvent);
begin
  FOnClick := Value;
  FOvcEdit.OnClick := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnDblClick(Value : TNotifyEvent);
begin
  FOnDblClick := Value;
  FOvcEdit.OnDblClick := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnDragDrop(Value : TDragDropEvent);
begin
  FOnDragDrop := Value;
  FOvcEdit.OnDragDrop := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnDragOver(Value : TDragOverEvent);
begin
  FOnDragOver := Value;
  FOvcEdit.OnDragOver := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnEndDrag(Value : TEndDragEvent);
begin
  FOnEndDrag := Value;
  FOvcEdit.OnEndDrag := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnKeyDown(Value : TKeyEvent);
begin
  FOnKeyDown := Value;
  FOvcEdit.OnKeyDown := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnKeyPress(Value : TKeyPressEvent);
begin
  FOnKeyPress := Value;
  FOvcEdit.OnKeyPress := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnKeyUp(Value : TKeyEvent);
begin
  FOnKeyUp := Value;
  FOvcEdit.OnKeyUp := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnMouseDown(Value : TMouseEvent);
begin
  FOnMouseDown := Value;
  FOvcEdit.OnMouseDown := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnMouseMove(Value : TMouseMoveEvent);
begin
  FOnMouseMove := Value;
  FOvcEdit.OnMouseMove := Value;
end;

procedure TOvcBorderedNumberEdit.SetOnMouseUp(Value : TMouseEvent);
begin
  FOnMouseUp := Value;
  FOvcEdit.OnMouseUp := Value;
end;

end.
