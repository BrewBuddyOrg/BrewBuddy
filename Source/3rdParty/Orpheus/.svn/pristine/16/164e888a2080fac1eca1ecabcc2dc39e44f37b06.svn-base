{*********************************************************}
{*                 OVCCLRCB.PAS 4.06                     *}
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

unit ovcclrcb;
  {-color ComboBox selector}

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, MyMisc, {$ENDIF}
  Classes, Controls, Forms, Graphics, Menus, StdCtrls,
  OvcCmbx, OvcConst, OvcData;

type
  TOvcCustomColorComboBox = class(TOvcBaseComboBox)
  protected {private}
    {property Variables}
    FShowColorNames : Boolean;
{$IFDEF LCL}
    FCtl3D          : Boolean;
{$ENDIF}

    {internal variables}
    BoxWidth : Integer;

    {property methods}
    function GetSelectedColor : TColor;
    procedure SetSelectedColor(Value : TColor);
    procedure SetShowColorNames(Value : Boolean);
    function ColorFromString(Str: string): TColor;

    {internal methods}
    procedure CalculateBoxWidth;

    {message methods}
    procedure CMFontChanged(var Message : TMessage);
      message CM_FONTCHANGED;

    procedure CreateWnd; override;

    property SelectedColor : TColor
      read GetSelectedColor write SetSelectedColor;
    property ShowColorNames : Boolean
      read FShowColorNames write SetShowColorNames default True;
{$IFDEF LCL}
    property Ctl3D : Boolean read FCtl3D write FCtl3D;
{$ENDIF}

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    procedure DrawItem(Index : Integer; Rect : TRect; State : TOwnerDrawState);
      override;
    procedure SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
      override;
  end;

  TOvcColorComboBox = class(TOvcCustomColorComboBox)
  published
    {$IFDEF VERSION4}
    property Anchors;
    property Constraints;
    property DragKind;
    {$ENDIF}
    property About;
    property Color;
    property Ctl3D;
    property Cursor;
    property DragCursor;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property HotTrack;
//    property Items;
    property ItemHeight;
    property LabelInfo;
    property ParentColor;
{$IFNDEF LCL}
    property ParentCtl3D;
{$ENDIF}
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property SelectedColor default clBlack;
    property ShowColorNames;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;

    {events}
    property AfterEnter;
    property AfterExit;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDropDown;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnSelectionChange;
    property OnStartDrag;
    property OnMouseWheel;
  end;

implementation

procedure TOvcCustomColorComboBox.CalculateBoxWidth;
var
  I : Integer;
  X : Integer;
  T : Integer;
begin
  if not HandleAllocated or (BoxWidth > 0) then
    Exit;

  if not FShowColorNames then begin
    BoxWidth := ClientWidth - 1;
    Exit;
  end;

  Canvas.Font := Font;
  BoxWidth := 0;
  T := 0;

  {calculate width of the color box}
  for I := 0 to pred(Items.Count) do begin
    X := Canvas.TextWidth(Items[I]+'X');
    if X > T then
      T := X;
  end;

  BoxWidth := ClientWidth - T;
  if BoxWidth < 25 then
    BoxWidth := 25;
end;

procedure TOvcCustomColorComboBox.CMFontChanged(var Message : TMessage);
begin
  inherited;

  BoxWidth := 0;
  Invalidate;
end;

constructor TOvcCustomColorComboBox.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);

  {disable MRU list}
  FMRUList.MaxItems := 0;

  Style := ocsDropDownList;

  FShowColorNames := True;
  
// On Carbon, SetSelectedColor gets called before Items is populated
//  in CreateWnd below, so moved code to here.
// Note: Isn't CreateWnd an odd place to initialize a control?
{$IFDEF LCL}
  Text := '';
  Items.Clear;
  Items.Add(GetOrphStr(SCColorBlack));
  Items.Add(GetOrphStr(SCColorMaroon));
  Items.Add(GetOrphStr(SCColorGreen));
  Items.Add(GetOrphStr(SCColorOlive));
  Items.Add(GetOrphStr(SCColorNavy));
  Items.Add(GetOrphStr(SCColorPurple));
  Items.Add(GetOrphStr(SCColorTeal));
  Items.Add(GetOrphStr(SCColorGray));
  Items.Add(GetOrphStr(SCColorSilver));
  Items.Add(GetOrphStr(SCColorRed));
  Items.Add(GetOrphStr(SCColorLime));
  Items.Add(GetOrphStr(SCColorYellow));
  Items.Add(GetOrphStr(SCColorBlue));
  Items.Add(GetOrphStr(SCColorFuchsia));
  Items.Add(GetOrphStr(SCColorAqua));
  Items.Add(GetOrphStr(SCColorLightGray));
  Items.Add(GetOrphStr(SCColorMediumGray));
  Items.Add(GetOrphStr(SCColorDarkGray));
  Items.Add(GetOrphStr(SCColorWhite));
  Items.Add(GetOrphStr(SCColorMoneyGreen));
  Items.Add(GetOrphStr(SCColorSkyBlue));
  Items.Add(GetOrphStr(SCColorCream));

  ItemIndex := 0;
{$ENDIF}
end;

destructor TOvcCustomColorComboBox.Destroy;
begin
  inherited;
end;

{ - modified}
procedure TOvcCustomColorComboBox.CreateWnd;
begin
  inherited CreateWnd;

{$IFNDEF LCL}  //See note above.
  Text := '';
  Items.Clear;
  Items.Add(GetOrphStr(SCColorBlack));
  Items.Add(GetOrphStr(SCColorMaroon));
  Items.Add(GetOrphStr(SCColorGreen));
  Items.Add(GetOrphStr(SCColorOlive));
  Items.Add(GetOrphStr(SCColorNavy));
  Items.Add(GetOrphStr(SCColorPurple));
  Items.Add(GetOrphStr(SCColorTeal));
  Items.Add(GetOrphStr(SCColorGray));
  Items.Add(GetOrphStr(SCColorSilver));
  Items.Add(GetOrphStr(SCColorRed));
  Items.Add(GetOrphStr(SCColorLime));
  Items.Add(GetOrphStr(SCColorYellow));
  Items.Add(GetOrphStr(SCColorBlue));
  Items.Add(GetOrphStr(SCColorFuchsia));
  Items.Add(GetOrphStr(SCColorAqua));
  Items.Add(GetOrphStr(SCColorLightGray));
  Items.Add(GetOrphStr(SCColorMediumGray));
  Items.Add(GetOrphStr(SCColorDarkGray));
  Items.Add(GetOrphStr(SCColorWhite));
  Items.Add(GetOrphStr(SCColorMoneyGreen));
  Items.Add(GetOrphStr(SCColorSkyBlue));
  Items.Add(GetOrphStr(SCColorCream));

  ItemIndex := 0;
{$ENDIF}
end;

procedure TOvcCustomColorComboBox.DrawItem(Index : Integer; Rect : TRect;
                                 State : TOwnerDrawState);
var
  BC : TColor;
  S  : string;
begin
  {get selected color and text to display}
  if Index > -1 then begin
    S := Items[Index];
    BC := ColorFromString(S);
  end else begin
    S := GetOrphStr(SCColorBlack);
    BC := clBlack;
  end;

  CalculateBoxWidth;

  Canvas.Font.Color := Font.Color;
  Canvas.Brush.Color := Color;

  if FShowColorNames then begin
    Canvas.Pen.Color := Canvas.Brush.Color;
    Canvas.Rectangle(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom);
    Inc(Rect.Left);
    DrawText(Canvas.Handle, @S[1], Length(S), Rect,
      DT_LEFT or DT_VCENTER or DT_SINGLELINE);
  end;

  Canvas.Pen.Color := Font.Color;
  Canvas.Brush.Color := BC;
  Canvas.Rectangle(ClientWidth - BoxWidth, Rect.Top + 1, Rect.Right -1,
    Rect.Bottom - 1);
end;

function TOvcCustomColorComboBox.GetSelectedColor : TColor;
begin
  if ItemIndex > -1 then
    Result := ColorFromString(Items[ItemIndex])
  else
    Result := clBlack;
end;

procedure TOvcCustomColorComboBox.SetBounds(ALeft, ATop, AWidth, AHeight : Integer);
begin
  inherited SetBounds(ALeft, ATop, AWidth, AHeight);
  BoxWidth := 0;
  Invalidate;
end;

procedure TOvcCustomColorComboBox.SetSelectedColor(Value : TColor);
var
  I : Integer;
begin
  for I := 0 to Pred(Items.Count) do
    if Value = ColorFromString(Items[I]) then begin
      ItemIndex := I;
      Change;
      Break;
    end;
end;

{ - New}
function TOvcCustomColorComboBox.ColorFromString(Str: string):TColor;
begin
  if Str = GetOrphStr(SCColorBlack) then result := clBlack
  else if Str = GetOrphStr(SCColorMaroon) then result := clMaroon
  else if Str = GetOrphStr(SCColorGreen) then result := clGreen
  else if Str = GetOrphStr(SCColorOlive) then result := clOlive
  else if Str = GetOrphStr(SCColorNavy) then result := clNavy
  else if Str = GetOrphStr(SCColorPurple) then result := clPurple
  else if Str = GetOrphStr(SCColorTeal) then result := clTeal
  else if Str = GetOrphStr(SCColorGray) then result := clGray
  else if Str = GetOrphStr(SCColorSilver) then result := clSilver
  else if Str = GetOrphStr(SCColorRed) then result := clRed
  else if Str = GetOrphStr(SCColorLime) then result := clLime
  else if Str = GetOrphStr(SCColorYellow) then result := clYellow
  else if Str = GetOrphStr(SCColorBlue) then result := clBlue
  else if Str = GetOrphStr(SCColorFuchsia) then result := clFuchsia
  else if Str = GetOrphStr(SCColorAqua) then result := clAqua
  else if Str = GetOrphStr(SCColorLightGray) then result := TColor($C0C0C0)
  else if Str = GetOrphStr(SCColorMediumGray) then result := TColor($A4A0A0)
  else if Str = GetOrphStr(SCColorDarkGray) then result := TColor($808080)
  else if Str = GetOrphStr(SCColorWhite) then result := clWhite
  else if Str = GetOrphStr(SCColorMoneyGreen) then result := TColor($C0DCC0)
  else if Str = GetOrphStr(SCColorSkyBlue) then result := TColor($F0CAA6)
  else if Str = GetOrphStr(SCColorCream) then result := TColor($F0FBFF)
  else result := clBlack;
end;

procedure TOvcCustomColorComboBox.SetShowColorNames(Value : Boolean);
begin
  if Value <> FShowColorNames then begin
    FShowColorNames := Value;
    BoxWidth := 0;
    Invalidate;
  end;
end;

end.
