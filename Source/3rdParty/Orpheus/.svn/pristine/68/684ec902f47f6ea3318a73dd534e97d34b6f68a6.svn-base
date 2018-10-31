{*********************************************************}
{*                  OVCTCCBX.PAS 4.06                    *}
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

{$IFDEF VERSION6}
 {$IFNDEF LCL}
  {$WARN SYMBOL_DEPRECATED OFF}
 {$ENDIF}
{$ENDIF}

unit ovctccbx;
  {-Orpheus Table Cell - combo box type}

interface

uses
  SysUtils, Classes,
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, MyMisc, {$ENDIF} 
  Graphics, Controls, Forms, StdCtrls,
  OvcMisc, OvcTCmmn, OvcTCell, OvcTCStr;

type
  TOvcTCComboBoxState = (otlbsUp, otlbsDown);

type
  TOvcTCComboBoxEdit = class(TCustomComboBox)
    protected {private}
      {.Z+}
      FCell     : TOvcBaseTableCell;

      EditField : HWnd;
      PrevEditWndProc : pointer;
      NewEditWndProc  : pointer;
      {.Z-}
{$IFDEF LCL}
      FCtl3D : Boolean;
{$ENDIF}

    protected
      {.Z+}
      procedure EditWindowProc(var Msg : TMessage);
      function  FilterWMKEYDOWN(var Msg : TWMKey) : boolean;

      procedure CMRelease(var Message: TMessage); message CM_RELEASE;

      procedure WMChar(var Msg : TWMKey); message WM_CHAR;
      procedure WMGetDlgCode(var Msg : TMessage); message WM_GETDLGCODE;
      procedure WMKeyDown(var Msg : TWMKey); message WM_KEYDOWN;
      procedure WMKillFocus(var Msg : TWMKillFocus); message WM_KILLFOCUS;
      procedure WMSetFocus(var Msg : TWMSetFocus); message WM_SETFOCUS;
      {.Z-}

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;
      procedure CreateWnd; override;

      property CellOwner : TOvcBaseTableCell
         read FCell write FCell;
{$IFDEF LCL}
      property Ctl3D : Boolean read FCtl3D write FCtl3D;
{$ENDIF}      
  end;

  TOvcTCCustomComboBox = class(TOvcTCBaseString)
  protected {private}
    {.Z+}
    {property fields - even size}
    FDropDownCount        : Integer;
    FEdit                 : TOvcTCComboBoxEdit;
    FItems                : TStrings;
    FMaxLength            : Word;

    {property fields - odd size}
    FStyle                : TComboBoxStyle;
    FAutoAdvanceChar      : Boolean;
    FAutoAdvanceLeftRight : Boolean;
    FHideButton           : Boolean;
    FSaveStringValue      : boolean;
    FSorted               : Boolean;
    FShowArrow            : Boolean;
    FUseRunTimeItems      : Boolean;

    {events}
    FOnChange             : TNotifyEvent;
    FOnDropDown           : TNotifyEvent;
    FOnDrawItem           : TDrawItemEvent;
    FOnMeasureItem        : TMeasureItemEvent;
    {.Z-}

  protected
    {.Z+}
    function GetCellEditor : TControl; override;

    procedure SetShowArrow(Value : Boolean);
    procedure SetItems(I : TStrings);
    procedure SetSorted(S : boolean);

    procedure DrawArrow(Canvas   : TCanvas;
                  const CellRect : TRect;
                  const CellAttr : TOvcCellAttributes);
    procedure DrawButton(Canvas   : TCanvas;
                   const CellRect : TRect);

    procedure tcPaint(TableCanvas : TCanvas;
                const CellRect    : TRect;
                      RowNum      : TRowNum;
                      ColNum      : TColNum;
                const CellAttr    : TOvcCellAttributes;
                      Data        : pointer); override;
    {.Z-}

    {properties}
    property AutoAdvanceChar : boolean
       read FAutoAdvanceChar write FAutoAdvanceChar;
    property AutoAdvanceLeftRight : boolean
       read FAutoAdvanceLeftRight write FAutoAdvanceLeftRight;
    property DropDownCount : Integer
       read FDropDownCount write FDropDownCount;
    property HideButton : Boolean
       read FHideButton write FHideButton;
    property Items : TStrings
       read FItems write SetItems;
    property MaxLength : word
       read FMaxLength write FMaxLength;
    property SaveStringValue : boolean
       read FSaveStringValue write FSaveStringValue;
    property Sorted : boolean
       read FSorted write SetSorted;
    property ShowArrow : Boolean
       read FShowArrow write SetShowArrow;
    property Style : TComboBoxStyle
       read FStyle write FStyle;
    property UseRunTimeItems : boolean
       read FUseRunTimeItems write FUseRunTimeItems;

    {events}
    property OnChange : TNotifyEvent
       read FOnChange write FOnChange;
    property OnDropDown: TNotifyEvent
       read FOnDropDown write FOnDropDown;
    property OnDrawItem: TDrawItemEvent
       read FOnDrawItem write FOnDrawItem;
    property OnMeasureItem: TMeasureItemEvent
       read FOnMeasureItem write FOnMeasureItem;

  public
    constructor Create(AOwner : TComponent); override;
    destructor Destroy; override;
    function CreateEditControl : TOvcTCComboBoxEdit; virtual;

    function  EditHandle : THandle; override;
    procedure EditHide; override;
    procedure EditMove(CellRect : TRect); override;

    procedure SaveEditedData(Data : pointer); override;
    procedure StartEditing(RowNum : TRowNum; ColNum : TColNum;
                           CellRect : TRect;
                     const CellAttr : TOvcCellAttributes;
                           CellStyle: TOvcTblEditorStyle;
                           Data : pointer); override;
    procedure StopEditing(SaveValue : boolean;
                          Data : pointer); override;
  end;

  TOvcTCComboBox = class(TOvcTCCustomComboBox)
    published
      property AcceptActivationClick default True;
      property Access default otxDefault;
      property Adjust default otaDefault;
      property AutoAdvanceChar default False;
      property AutoAdvanceLeftRight default False;
      property Color;
      property DropDownCount default 8;
      property Font;
      property HideButton default False;
      property Hint;
      property Items;
      property ShowHint default False;
      property Margin default 4;
      property MaxLength default 0;
      property SaveStringValue default False;
      property ShowArrow default False;
      property Sorted default False;
      property Style default csDropDown;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      property UseRunTimeItems default False;

      {events inherited from custom ancestor}
      property OnChange;
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnDrawItem;
      property OnDropDown;
      property OnEndDrag;
      property OnEnter;
      property OnExit;
      property OnKeyDown;
      property OnKeyPress;
      property OnKeyUp;
      property OnMeasureItem;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;


var
  OvcComboBoxBitmap      : TBitmap;
  OvcComboBoxButtonWidth : Integer;

implementation

const
  ComboBoxHeight = 24;

var
  ComboBoxResourceCount : longint = 0;

// Workaround for lack of MakeObjectInstance in LCL for making 
//  WindowProc callback function from object method.
// Note: Not using: function appears to work with Win32, but
//  crash when object destroyed. Doesn't work with GTK.
{$IFDEF LCL}  
function LclEditWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM) : LRESULT; stdcall;
var
  CbEdit : TWinControl;
  AMsg   : TMessage;
begin
  CbEdit := FindOwnerControl(hWnd);
  AMsg.Msg := Msg;
  AMsg.WParam := wParam;
  AMsg.LParam := lParam;
  TOvcTCComboBoxEdit(CbEdit).EditWindowProc(AMsg);
//  Result := AMsg.Result;
end;
{$ENDIF}

{===TOvcTCComboBoxEdit================================================}
constructor TOvcTCComboBoxEdit.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
{$IFNDEF LCL}
    NewEditWndProc := MakeObjectInstance(EditWindowProc);
{$ELSE}
//    NewEditWndProc := @LclEditWindowProc;
{$ENDIF}
  end;
{--------}
destructor TOvcTCComboBoxEdit.Destroy;
  begin
    if (Style = csDropDown) or (Style = csSimple) then
      SetWindowLong(EditField, GWL_WNDPROC, longint(PrevEditWndProc));
{$IFNDEF LCL}
    FreeObjectInstance(NewEditWndProc);
{$ENDIF}
    inherited Destroy;
  end;
{--------}
procedure TOvcTCComboBoxEdit.CreateWnd;
  begin
    inherited CreateWnd;

    if (Style = csDropDown) or (Style = csSimple) then
      begin
        EditField := GetWindow(Handle, GW_CHILD);
        if (Style = csSimple) then
          EditField := GetWindow(EditField, GW_HWNDNEXT);
        PrevEditWndProc := pointer(GetWindowLong(EditField, GWL_WNDPROC));
{$IFNDEF LCL}
        SetWindowLong(EditField, GWL_WNDPROC, longint(NewEditWndProc));
{$ENDIF}        
      end;
  end;
{--------}
procedure TOvcTCComboBoxEdit.EditWindowProc(var Msg : TMessage);
  var
    GridUsedIt : boolean;
    KeyMsg : TWMKey absolute Msg;
  begin
    GridUsedIt := false;
    if (Msg.Msg = WM_KEYDOWN) then
      GridUsedIt := FilterWMKEYDOWN(KeyMsg)
    else if (Msg.Msg = WM_CHAR) then
      if (KeyMsg.CharCode = 9) or
         (KeyMsg.CharCode = 13) or
         (KeyMsg.CharCode = 27) then
        GridUsedIt := true;
    if not GridUsedIt then
      with Msg do
        Result := CallWindowProc(PrevEditWndProc, EditField, Msg, wParam, lParam);
  end;
{--------}
function  TOvcTCComboBoxEdit.FilterWMKEYDOWN(var Msg : TWMKey) : boolean;
  procedure GetSelection(var S, E : word);
    type
      LH = packed record L, H : word; end;
    var
      GetSel : longint;
    begin
      GetSel := SendMessage(EditField, EM_GETSEL, 0, 0);
      S := LH(GetSel).L;
      E := LH(GetSel).H;
    end;
  var
    GridReply    : TOvcTblKeyNeeds;
    SStart, SEnd : word;
    GridUsedIt   : boolean;
    PassIton     : boolean;
  begin
    GridUsedIt := false;
    GridReply := otkDontCare;
    if (CellOwner <> nil) then
      GridReply := CellOwner.FilterTableKey(Msg);
    case GridReply of
      otkMustHave :
        begin
          CellOwner.SendKeyToTable(Msg);
          GridUsedIt := true;
        end;
      otkWouldLike :
        begin
          PassItOn := false;
          case Msg.CharCode of
            VK_LEFT :
              begin
                case Style of
                  csDropDown, csSimple :
                    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceLeftRight then
                      begin
                        GetSelection(SStart, SEnd);
                        if (SStart = SEnd) and (SStart = 0) then
                          PassItOn := true;
                      end;
                else
                  PassItOn := true;
                end;{case}
              end;
            VK_RIGHT :
              begin
                case Style of
                  csDropDown, csSimple :
                    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceLeftRight then
                      begin
                        GetSelection(SStart, SEnd);
                        if ((SStart = SEnd) or (SStart = 0)) and
                           (SEnd = GetTextLen) then
                          PassItOn := true;
                      end;
                else
                  PassItOn := true;
                end;{case}
              end;
          end;{case}
          if PassItOn then
            begin
              CellOwner.SendKeyToTable(Msg);
              GridUsedIt := true;
            end;
        end;
    end;{case}
    Result := GridUsedIt;
  end;
{--------}


  procedure TOvcTCComboBoxEdit.CMRelease(var Message: TMessage);
  begin
    Free;
  end;

  procedure TOvcTCComboBoxEdit.WMChar(var Msg : TWMKey);
  var
    CurText : string;
  begin
    inherited;
    if TOvcTCCustomComboBox(CellOwner).AutoAdvanceChar then
      begin
        CurText := Text;
        if (length(CurText) >= MaxLength) then
          begin
            FillChar(Msg, sizeof(Msg), 0);
            with Msg do
              begin
                Msg := WM_KEYDOWN;
                CharCode := VK_RIGHT;
              end;
            CellOwner.SendKeyToTable(Msg);
          end;
      end;
  end;
{--------}
procedure TOvcTCComboBoxEdit.WMGetDlgCode(var Msg : TMessage);
  begin
    inherited;
    if CellOwner.TableWantsTab then
      Msg.Result := Msg.Result or DLGC_WANTTAB;
  end;
{--------}
procedure TOvcTCComboBoxEdit.WMKeyDown(var Msg : TWMKey);
  var
    GridUsedIt : boolean;
  begin
    if (Style <> csDropDown) and (Style <> csSimple) then
      begin
        GridUsedIt := FilterWMKEYDOWN(Msg);
        if not GridUsedIt then
          inherited;
      end
    else
      inherited;
  end;
{--------}
procedure TOvcTCComboBoxEdit.WMKillFocus(var Msg : TWMKillFocus);
  begin
    inherited;
    {ComboBox posts cbn_killfocus message to table}
  end;
{--------}
procedure TOvcTCComboBoxEdit.WMSetFocus(var Msg : TWMSetFocus);
  begin
    inherited;
    CellOwner.PostMessageToTable(ctim_SetFocus, Msg.FocusedWnd, 0);
  end;
{====================================================================}


{===TOvcTCCustomComboBox=============================================}
constructor TOvcTCCustomComboBox.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    FItems := TStringList.Create;
    FDropDownCount := 8;
    if (ComboBoxResourceCount = 0) then
      begin
        OvcComboBoxBitmap := TBitMap.Create;
{$IFNDEF LCL}
        OvcComboBoxBitmap.Handle := LoadBaseBitMap('ORTCCOMBOARROW');
{$ELSE}
        OvcComboBoxBitmap.LoadFromLazarusResource('ORTCCOMBOARROW');
{$ENDIF}        
        OvcComboBoxButtonWidth := OvcComboBoxBitmap.Width + 11;
      end;
    inc(ComboBoxResourceCount);
    FAcceptActivationClick := true;
    FShowArrow := False;
    FHideButton := False;
  end;
{--------}
destructor TOvcTCCustomComboBox.Destroy;
  begin
    FItems.Free;
    dec(ComboBoxResourceCount);
    if (ComboBoxResourceCount = 0) then
      OvcComboBoxBitmap.Free;
    inherited Destroy;
  end;
{--------}
function TOvcTCCustomComboBox.CreateEditControl : TOvcTCComboBoxEdit;
  begin
    Result := TOvcTCComboBoxEdit.Create(FTable);
  end;
{--------}
procedure TOvcTCCustomComboBox.DrawArrow(Canvas   : TCanvas;
                                   const CellRect : TRect;
                                   const CellAttr : TOvcCellAttributes);
  var
    ArrowDim : Integer;
    X, Y     : Integer;
    LeftPoint, RightPoint, BottomPoint : TPoint;
{$IFNDEF LCL}
    Width    : integer;
    Height   : integer;
{$ELSE}  //LCL TCanvas has Width and Height properties
    AWidth   : integer;
    AHeight  : integer;
{$ENDIF}
    R        : TRect;
  begin
    R := CellRect;
    R.Left := R.Right - OvcComboBoxButtonWidth;
{$IFNDEF LCL}
    Width := R.Right - R.Left;
    Height := R.Bottom - R.Top;
{$ELSE}
    AWidth := R.Right - R.Left;
    AHeight := R.Bottom - R.Top;
{$ENDIF}
    with Canvas do
      begin
        Brush.Color := CellAttr.caColor;
        FillRect(R);
        Pen.Color := CellAttr.caFont.Color;
        Brush.Color := Pen.Color;
{$IFNDEF LCL}
        ArrowDim := MinI(Width, Height) div 3;
        X := R.Left + (Width - ArrowDim) div 2;
        Y := R.Top + (Height - ArrowDim) div 2;
{$ELSE}
        ArrowDim := MinI(AWidth, AHeight) div 3;
        X := R.Left + (AWidth - ArrowDim) div 2;
        Y := R.Top + (AHeight - ArrowDim) div 2;
{$ENDIF}        
        LeftPoint := Point(X, Y);
        RightPoint := Point(X+ArrowDim, Y);
        BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
        Polygon([LeftPoint, RightPoint, BottomPoint]);
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.DrawButton(Canvas       : TCanvas;
                                    const CellRect     : TRect);
  var
    EffCellWidth : Integer;
    Wd, Ht       : Integer;
    TopPixel     : Integer;
    BotPixel     : Integer;
    LeftPixel    : Integer;
    RightPixel   : Integer;
    SrcRect      : TRect;
    DestRect     : TRect;
  begin
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    EffCellWidth := CellRect.Right - CellRect.Left - OvcComboBoxButtonWidth;

    {Calculate the black border's rectangle}
    LeftPixel := CellRect.Left + EffCellWidth;
    RightPixel := CellRect.Right - 1;
    TopPixel := CellRect.Top + 1;
    BotPixel := CellRect.Bottom - 1;

    {Paint the button}
    with Canvas do
      begin
        {FIRST: paint the black border around the button}
        Pen.Color := clBlack;
        Pen.Width := 1;
        Brush.Color := clBtnFace;
        {Note: Rectangle excludes the Right and bottom pixels}
        Rectangle(LeftPixel, TopPixel, RightPixel, BotPixel);
        {SECOND: paint the highlight border on left/top sides}
        {decrement drawing area}
        inc(TopPixel);
        dec(BotPixel);
        inc(LeftPixel);
        dec(RightPixel);
        {Note: PolyLine excludes the end points of a line segment,
               but since the end points are generally used as the
               starting point of the next we must adjust for it.}
        Pen.Color := clBtnHighlight;
        PolyLine([Point(RightPixel-1, TopPixel),
                  Point(LeftPixel, TopPixel),
                  Point(LeftPixel, BotPixel)]);
        {THIRD: paint the highlight border on bottom/right sides}
        Pen.Color := clBtnShadow;
        PolyLine([Point(LeftPixel, BotPixel-1),
                  Point(RightPixel-1, BotPixel-1),
                  Point(RightPixel-1, TopPixel-1)]);
        inc(TopPixel);
        dec(BotPixel);
        inc(LeftPixel);
        dec(RightPixel);
        PolyLine([Point(LeftPixel, BotPixel-1),
                  Point(RightPixel-1, BotPixel-1),
                  Point(RightPixel-1, TopPixel-1)]);
        {THIRD: paint the arrow bitmap}
        Wd := OvcComboBoxBitmap.Width;
        Ht := OvcComboBoxBitmap.Height;
        SrcRect := Rect(0, 0, Wd, Ht);
        with DestRect do
          begin
            Left := CellRect.Left + EffCellWidth + 5;
            Top := CellRect.Top +
                   ((CellRect.Bottom - CellRect.Top - Ht) div 2);
            Right := Left + Wd;
            Bottom := Top + Ht;
          end;
//{$IFNDEF LCL}
        BrushCopy(DestRect, OvcComboBoxBitmap, SrcRect, clSilver);
//{$ELSE}
//        BrushCopy(Canvas, DestRect, OvcComboBoxBitmap, SrcRect, clSilver);
//{$ENDIF}
      end;
  end;
{--------}
function TOvcTCCustomComboBox.EditHandle : THandle;
  begin
    if Assigned(FEdit) then
      Result := FEdit.Handle
    else
      Result := 0;
  end;
{--------}
procedure TOvcTCCustomComboBox.EditHide;
  begin
    if Assigned(FEdit) then
      with FEdit do
        begin
          SetWindowPos(FEdit.Handle, HWND_TOP,
                       0, 0, 0, 0,
                       SWP_HIDEWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
        end;
  end;
{--------}
procedure TOvcTCCustomComboBox.EditMove(CellRect : TRect);
  var
    EditHandle : HWND;
    NewTop : Integer;
  begin
    if Assigned(FEdit) then
      begin
        EditHandle := FEdit.Handle;
        with CellRect do
          begin
            NewTop := Top;
            if FEdit.Ctl3D then
              InflateRect(CellRect, -1, -1);
            SetWindowPos(EditHandle, HWND_TOP,
                         Left, NewTop, Right-Left, ComboBoxHeight,
                         SWP_SHOWWINDOW or SWP_NOREDRAW or SWP_NOZORDER);
          end;
        InvalidateRect(EditHandle, nil, false);
        UpdateWindow(EditHandle);
      end;
  end;

function TOvcTCCustomComboBox.GetCellEditor : TControl;
begin
  Result := FEdit;
end;

procedure TOvcTCCustomComboBox.tcPaint(TableCanvas : TCanvas;
                                 const CellRect    : TRect;
                                       RowNum      : TRowNum;
                                       ColNum      : TColNum;
                                 const CellAttr    : TOvcCellAttributes;
                                       Data        : pointer);
var
  ItemRec   : PCellComboBoxInfo absolute Data;
  ActiveRow : TRowNum;
  ActiveCol : TColNum;
  R         : TRect;
  S         : ShortString;
  OurItems  : TStrings;
begin
  {Note: Data is a pointer to an integer, or to an integer and a
         shortstring. The first is used for drop down ListBoxes
         (only) and the latter with simple and drop down combo boxes}

  {If the cell is invisible let the ancestor to all the work}
  if (CellAttr.caAccess = otxInvisible) then begin
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, nil);
    Exit;
  end;

  {If we have valid data, get the string to display from the stringlist
   or from the Data pointer. }
  S := '';
  if (Data <> nil) then begin
    if UseRunTimeItems then
      OurItems := ItemRec^.RTItems
    else
      OurItems := Items;
    if (0 <= ItemRec^.Index) and (ItemRec^.Index < OurItems.Count) then
      S := OurItems[ItemRec^.Index]
    else if (Style = csDropDown) or (Style = csSimple) then begin
      if UseRunTimeItems then
        {$IFDEF CBuilder}
        S := StrPas(ItemRec^.RTSt)
        {$ELSE}
        S := ItemRec^.RTSt
        {$ENDIF}
      else
        {$IFDEF CBuilder}
        S := StrPas(ItemRec^.St);
        {$ELSE}
        S := ItemRec^.St;
        {$ENDIF}
      end;
    end
  {Otherwise, mock up a string in design mode.}
  else if (csDesigning in ComponentState) and (Items.Count > 0) then
    S := Items[RowNum mod Items.Count];

  ActiveRow := tcRetrieveTableActiveRow;
  ActiveCol := tcRetrieveTableActiveCol;
  {Calculate the effective cell width (the cell width less the size of the button)}
  R := CellRect;
  dec(R.Right, OvcComboBoxButtonWidth);
  if (ActiveRow = RowNum) and (ActiveCol = ColNum) then begin
    if FHideButton then begin
      {let ancestor paint the text}
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @S);
    end else begin
      {Paint the string in the restricted rectangle}
      inherited tcPaint(TableCanvas, R, RowNum, ColNum, CellAttr, @S);
      {Paint the button on the right side}
      DrawButton(TableCanvas, CellRect);
    end;
  end else if FShowArrow then begin
    {paint the string in the restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, CellAttr, @S);
    {Paint the arrow on the right side}
    DrawArrow(TableCanvas, CellRect, CellAttr);
  end else
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @S);

(*
  {Are we just displaying a button on the active cell?}
  if not FHideButton then begin
    {If we are not the active cell, let the ancestor do the painting (we only
     paint a button when the cell is the active one)}
    if (ActiveRow <> RowNum) or (ActiveCol <> ColNum) then begin
      inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @S);
      Exit;
    end;
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    R := CellRect;
    dec(R.Right, OvcComboBoxButtonWidth);
    {Paint the string in this restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, CellAttr, @S);
    {Paint the button on the right side}
    DrawButton(TableCanvas, CellRect);
  end else if FShowArrow then begin
    {Calculate the effective cell width (the cell width less the size
     of the button)}
    R := CellRect;
    dec(R.Right, OvcComboBoxButtonWidth);
    {Paint the string in this restricted rectangle}
    inherited tcPaint(TableCanvas, R, RowNum, ColNum, CellAttr, @S);
    {Paint the arrow on the right side}
    DrawArrow(TableCanvas, CellRect, CellAttr);
  end else
    inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @S);
*)
end;

procedure TOvcTCCustomComboBox.SaveEditedData(Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    if Assigned(Data) then
      begin
        ItemRec^.Index := FEdit.ItemIndex;
        if (Style = csDropDown) or (Style = csSimple) or SaveStringValue then
          begin
            if (ItemRec^.Index = -1) then
              if UseRunTimeItems then
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.RTSt, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(FEdit.Text, 1, MaxLength)
                {$ENDIF}
              else
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.St, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.St := Copy(FEdit.Text, 1, MaxLength)
                {$ENDIF}
            else
              if UseRunTimeItems then
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.RTSt, Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength)
                {$ENDIF}
              else
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.St, Copy(Items[ItemRec^.Index], 1, MaxLength));
                {$ELSE}
                ItemRec^.St := Copy(Items[ItemRec^.Index], 1, MaxLength);
                {$ENDIF}
          end;
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.SetItems(I : TStrings);
  begin
    FItems.Assign(I);
    if Sorted then
      TStringList(FItems).Sorted := true;
    tcDoCfgChanged;
  end;

procedure TOvcTCCustomComboBox.SetShowArrow(Value : Boolean);
begin
  if (Value <> FShowArrow) then begin
    FShowArrow := Value;
    tcDoCfgChanged;
  end;
end;

procedure TOvcTCCustomComboBox.SetSorted(S : boolean);
  begin
    if (S <> Sorted) then
      begin
        FSorted := S;
        if Sorted then
          TStringList(Items).Sorted := True;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.StartEditing(RowNum : TRowNum; ColNum : TColNum;
                                           CellRect : TRect;
                                     const CellAttr : TOvcCellAttributes;
                                           CellStyle: TOvcTblEditorStyle;
                                           Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    FEdit := CreateEditControl;
    with FEdit do
      begin
        Color := CellAttr.caColor;
        Ctl3D := false;
        case CellStyle of
          tes3D     : Ctl3D := true;
        end;{case}
        Left := CellRect.Left;
        Top := CellRect.Top;
        Width := CellRect.Right - CellRect.Left;
        Font := CellAttr.caFont;
        Font.Color := CellAttr.caFontColor;
        MaxLength := Self.MaxLength;
        Hint := Self.Hint;
        ShowHint := Self.ShowHint;
        Visible := true;
        CellOwner := Self;
        TabStop := false;
        Parent := FTable;
        DropDownCount := Self.DropDownCount;
        Sorted := Self.Sorted;
        Style := Self.Style;
        if UseRunTimeItems then
          Items := ItemRec^.RTItems
        else
          Items := Self.Items;
        if Data = nil then
          ItemIndex := -1
        else
          begin
            ItemIndex := ItemRec^.Index;
            if (ItemIndex = -1) and
               ((Style = csDropDown) or (Style = csSimple)) then
              if UseRunTimeItems then
                {$IFDEF CBuilder}
                Text := StrPas(ItemRec^.RTSt)
                {$ELSE}
                Text := ItemRec^.RTSt
                {$ENDIF}
              else
                {$IFDEF CBuilder}
                Text := StrPas(ItemRec^.St)
                {$ELSE}
                Text := ItemRec^.St;
                {$ENDIF}
          end;

        OnChange := Self.OnChange;
        OnClick := Self.OnClick;
        OnDblClick := Self.OnDblClick;
        OnDragDrop := Self.OnDragDrop;
        OnDragOver := Self.OnDragOver;
        OnDrawItem := Self.OnDrawItem;
        OnDropDown := Self.OnDropDown;
        OnEndDrag := Self.OnEndDrag;
        OnEnter := Self.OnEnter;
        OnExit := Self.OnExit;
        OnKeyDown := Self.OnKeyDown;
        OnKeyPress := Self.OnKeyPress;
        OnKeyUp := Self.OnKeyUp;
        OnMeasureItem := Self.OnMeasureItem;
        OnMouseDown := Self.OnMouseDown;
        OnMouseMove := Self.OnMouseMove;
        OnMouseUp := Self.OnMouseUp;
      end;
  end;
{--------}
procedure TOvcTCCustomComboBox.StopEditing(SaveValue : boolean;
                                          Data : pointer);
  var
    ItemRec : PCellComboBoxInfo absolute Data;
  begin
    if SaveValue and Assigned(Data) then
      begin
        ItemRec^.Index := FEdit.ItemIndex;
        if (Style = csDropDown) or (Style = csSimple) or SaveStringValue then
          begin
            if (ItemRec^.Index = -1) then
              if UseRunTimeItems then
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.RTSt, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(FEdit.Text, 1, MaxLength)
                {$ENDIF}
              else
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.St, Copy(FEdit.Text, 1, MaxLength))
                {$ELSE}
                ItemRec^.St := Copy(FEdit.Text, 1, MaxLength)
                {$ENDIF}
            else
              if UseRunTimeItems then
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.RTSt, Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength))
                {$ELSE}
                ItemRec^.RTSt := Copy(ItemRec^.RTItems[ItemRec^.Index], 1, MaxLength)
                {$ENDIF}
              else
                {$IFDEF CBuilder}
                StrPCopy(ItemRec^.St, Copy(Items[ItemRec^.Index], 1, MaxLength));
                {$ELSE}
                ItemRec^.St := Copy(Items[ItemRec^.Index], 1, MaxLength);
                {$ENDIF}
          end;
      end;
    PostMessage(FEdit.Handle, CM_RELEASE, 0, 0);
    {FEdit.Free;}
    FEdit := nil;
  end;
{====================================================================}

end.
