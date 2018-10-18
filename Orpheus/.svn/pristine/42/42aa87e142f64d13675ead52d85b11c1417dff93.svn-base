{*********************************************************}
{*                     mymisc.pas                        *}
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
{* The Original Code is Orpheus for Lazarus Additional Units.                 *}
{*                                                                            *}
{* The Initial Developer of the Original Code is Phil Hess.                   *}
{*                                                                            *}
{* Portions created by Phil Hess are Copyright (C) 2006 Phil Hess.            *}
{* All Rights Reserved.                                                       *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

unit MyMisc;

{
  This unit provides types, constants, and functions that fill
   in some gaps in the Lazarus LCL for compiling the ported 
   Orpheus controls.
   
  Declarations that have been commented out in the interface
   section are no longer needed. It is expected that over time
   more of these can be eliminated as the LCL evolves.
   
  Several of these functions are only used by Orpheus units
   that have not yet been ported to Lazarus. For now, these 
   functions are just stubs on non-Windows platforms, as
   indicated in the function comments.
}

{$I ovc.inc}

interface

uses
  SysUtils,
  {$IFDEF MSWINDOWS} Windows, {$ELSE} Types, {$ENDIF}
   LclIntf, LMessages, LclType, InterfaceBase,
  {$IFDEF LINUX} FileUtil, {$ENDIF}
   GraphType, Graphics, Controls;

type
  TButtonStyle = (bsAutoDetect, bsWin31, bsNew);

  TWMMouse = TLMMouse;
  TWMKeyDown = TLMKeyDown;
  TWMNCHitTest = TLMNCHitTest;
  TWMSetText = TLMSetText;
  TCMDesignHitTest = TWMMouse;
  TWMChar = TLMChar;
  TWMClear = TLMNoParams;
  TWMCopy = TLMNoParams;
  TWMCut = TLMNoParams;
  TWMLButtonDblClk = TLMLButtonDblClk;
  TWMLButtonDown = TLMLButtonDown;
  TWMLButtonUp = TLMLButtonUp;
  TWMRButtonDown = TLMRButtonDown;
  TWMSysKeyDown = TLMSysKeyDown;
  TWMMouseActivate = packed record
    Msg: Cardinal;
{$ifdef cpu64}  //64
    UnusedMsg: Cardinal;
{$endif}
    TopLevel: HWND;
    HitTestCode: Word;
    MouseMsg: Word;
{$ifdef cpu64}  //64
    Unused: Longint;
{$endif}
    Result: LRESULT;  //64
    end;
  TWMMouseMove = TLMMouseMove;
  TWMPaste = TLMNoParams;
  TMessage = TLMessage;
  TWMEraseBkgnd = TLMEraseBkgnd;
  TWMGetText = TLMGetText;
  TWMGetTextLength = TLMGetTextLength;
  TWMKillFocus = TLMKillFocus;
  TWMSetCursor = TLMSetCursor;  //64
//  TWMSetCursor = packed record
//    Msg: Cardinal;
//    CursorWnd: HWND;
//    HitTest: Word;
//    MouseMsg: Word;
//    Result: Longint;
//    end;
  TWMSetFocus = TLMSetFocus;
  TWMGetDlgCode = TLMNoParams;
  TWMSize = TLMSize;
  TWMSetFont = packed record
    Msg: Cardinal;
{$ifdef cpu64}  //64
    UnusedMsg: Cardinal;
{$endif}
    Font: HFONT;
    Redraw: WordBool;
    Unused: Word;
{$ifdef cpu64}  //64
    Unused2: Longint;
{$endif}
    Result: LRESULT;  //64
    end;
  TWMCommand = TLMCommand;
  TWMDrawItem = TLMDrawItems;
  LPDWORD = PDWORD;
  TFNWndEnumProc = TFarProc;
  TNonClientMetrics = packed record
    cbSize: UINT;
    iBorderWidth: Integer;
    iScrollWidth: Integer;
    iScrollHeight: Integer;
    iCaptionWidth: Integer;
    iCaptionHeight: Integer;
    lfCaptionFont: TLogFontA;
    iSmCaptionWidth: Integer;
    iSmCaptionHeight: Integer;
    lfSmCaptionFont: TLogFontA;
    iMenuWidth: Integer;
    iMenuHeight: Integer;
    lfMenuFont: TLogFontA;
    lfStatusFont: TLogFontA;
    lfMessageFont: TLogFontA;
    end;
  TWMKey = TLMKey;
  TWMScroll = TLMScroll;
  TWMNoParams = TLMNoParams;
  TWMPaint = TLMPaint;
  TWMNCPaint = packed record
    Msg: Cardinal;
{$ifdef cpu64}  //64
    UnusedMsg: Cardinal;
{$endif}
    RGN: HRGN;
    Unused: LPARAM;  //64
    Result: LRESULT;  //64
    end;
  TWMHScroll = TLMHScroll;
  TWMVScroll = TLMVScroll;

const  
  WM_WININICHANGE = CM_WININICHANGE;
  WM_CANCELMODE = LM_CANCELMODE;
  WM_ERASEBKGND = LM_ERASEBKGND;
  WM_GETTEXTLENGTH = LM_GETTEXTLENGTH;
  WM_KEYDOWN = LM_KEYDOWN;
  WM_KILLFOCUS = LM_KILLFOCUS;
  WM_LBUTTONDOWN = LM_LBUTTONDOWN;
  WM_LBUTTONUP = LM_LBUTTONUP;
  WM_MOUSEMOVE = LM_MOUSEMOVE;
  WM_NCHITTEST = LM_NCHITTEST;
  WM_SETCURSOR = LM_SETCURSOR;
  WM_SETTEXT = $000C;
  WM_GETTEXT = $000D;
  WM_SETFOCUS = LM_SETFOCUS;
  WM_CHAR = LM_CHAR;
  WM_CLEAR = LM_CLEAR;
  WM_COPY = LM_COPY;
  WM_CUT = LM_CUT;
  WM_PASTE = LM_PASTE;
// With Lazarus versions prior to March 2008, LM_CLEAR, etc. are not defined, 
//  so comment previous 4 lines and uncomment next 4 lines.
{
  WM_CLEAR = LM_CLEARSEL;
  WM_COPY = LM_COPYTOCLIP;
  WM_CUT = LM_CUTTOCLIP;
  WM_PASTE = LM_PASTEFROMCLIP;
}  
  WM_GETDLGCODE = LM_GETDLGCODE;
  WM_SIZE = LM_SIZE;
  WM_SETFONT = LM_SETFONT;
  WM_SYSKEYDOWN = LM_SYSKEYDOWN;  
  WM_RBUTTONUP = LM_RBUTTONUP;
  WM_MOUSEACTIVATE = $0021;  
  WM_LBUTTONDBLCLK = LM_LBUTTONDBLCLK;
  WM_SETREDRAW = $000B;
  WM_NEXTDLGCTL = $0028;
  WM_MOUSEWHEEL = LM_MOUSEWHEEL;
  WM_PAINT = LM_PAINT;
  WM_VSCROLL = LM_VSCROLL;
  WM_HSCROLL = LM_HSCROLL;
  WM_NCPAINT = LM_NCPAINT;
  WM_MEASUREITEM = LM_MEASUREITEM;

  EM_GETMODIFY = $00B8;
  EM_SETMODIFY = $00B9;
  EM_GETSEL = $00B0;
  EM_SETSEL = $00B1;
  EM_GETLINECOUNT = $00BA;
  EM_LINELENGTH = $00C1;
  EM_LINEINDEX = $00BB;
  EM_GETLINE = $00C4;
  EM_REPLACESEL = $00C2;

  CS_SAVEBITS = $800;
  CS_DBLCLKS = 8;
  SPI_GETWORKAREA = 48;
  SPI_GETNONCLIENTMETRICS = 41;
  DLGC_STATIC = $100;
  GW_HWNDLAST = 1;
  GW_HWNDNEXT = 2;
  GW_HWNDPREV = 3;
  GW_CHILD = 5;
  DT_EXPANDTABS = $40;
  DT_END_ELLIPSIS = $8000;
  DT_MODIFYSTRING = $10000;
  GHND = 66;
  TMPF_TRUETYPE = 4;
  SWP_HIDEWINDOW = $80;
  SWP_SHOWWINDOW = $40;
  RDW_INVALIDATE = 1;
  RDW_UPDATENOW = $100;
  RDW_FRAME = $400;
  LANG_JAPANESE = $11;
  ES_PASSWORD = $20;
  ES_LEFT = 0;
  ES_RIGHT = 2;
  ES_CENTER = 1;
  ES_AUTOHSCROLL = $80;
  ES_MULTILINE = 4;
  ODS_COMBOBOXEDIT = $1000;
  CB_FINDSTRING = $014C;
  CB_SETITEMHEIGHT = $0153;
  CB_FINDSTRINGEXACT = $0158;
  CB_SETDROPPEDWIDTH = 352;
  CBS_DROPDOWN = 2;
  CBS_DROPDOWNLIST = 3;
  CBS_OWNERDRAWVARIABLE = $20;
  CBS_AUTOHSCROLL = $40;
  CBS_HASSTRINGS = $200;
  WHEEL_DELTA = 120; 
  LB_GETCARETINDEX = $019F;
  LB_GETCOUNT = $018B;
  LB_GETCURSEL = $0188;
  LB_GETITEMHEIGHT = $01A1;
  LB_GETITEMRECT = $0198;
  LB_GETSEL = $0187;
  LB_GETTOPINDEX = $018E;
  LB_RESETCONTENT = $0184;
  LB_SELITEMRANGE = $019B;
  LB_SETCURSEL = $0186;
  LB_SETSEL = $0185;
  LB_SETTABSTOPS = $0192;
  LB_SETTOPINDEX = $0197;
  LB_ERR = -1;
  MA_ACTIVATE = 1;
  MA_NOACTIVATEANDEAT = 4;


 {These belong in LclIntf unit}
function IsCharAlpha(c : Char) : Boolean;
function DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
function GetProfileInt(lpAppName, lpKeyName: PChar; nDefault: Integer): UINT;
function GetProfileString(lpAppName, lpKeyName, lpDefault: PChar;
                          lpReturnedString: PChar; nSize: DWORD): DWORD;
function GetTickCount : DWORD;
//function SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT;
//                  lpTimerFunc: TFNTimerProc): UINT;
//function KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL;
function GetCaretBlinkTime: UINT; 
function SetCaretBlinkTime(uMSeconds: UINT): BOOL; 
//function DestroyCaret: BOOL;
function MessageBeep(uType: UINT): BOOL;
function SystemParametersInfo(uiAction, uiParam: UINT;
                              pvParam: Pointer; fWinIni: UINT): BOOL;
{$IFNDEF MSWINDOWS}
function GetSystemMetrics(nIndex: Integer): Integer;
{$ENDIF}
function MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL;
function SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND;
                      X, Y, cx, cy: Integer; uFlags: UINT): BOOL;
function UpdateWindow(hWnd: HWND): BOOL;
function ValidateRect(hWnd: HWND; lpRect: PRect): BOOL;
function InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL;
function InvalidateRgn(hWnd: HWND; hRgn: HRGN; bErase: BOOL): BOOL;
function GetRgnBox(RGN : HRGN; lpRect : PRect) : Longint;
function PtInRegion(RGN: HRGN; X, Y: Integer) : Boolean;
function SetWindowText(hWnd: HWND; lpString: PChar): BOOL;
function GetBkColor(hDC: HDC): COLORREF;
function GetBkMode(hDC: HDC): Integer;
function GetWindow(hWnd: HWND; uCmd: UINT): HWND;
function GetNextWindow(hWnd: HWND; uCmd: UINT): HWND;
function RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL;
function GetWindowDC(hWnd: HWND): HDC;
function ScrollDC(DC: HDC; DX, DY: Integer; var Scroll, Clip: TRect; Rgn: HRGN;
                  Update: PRect): BOOL;
function SetScrollRange(hWnd: HWND; nBar, nMinPos, nMaxPos: Integer; bRedraw: BOOL): BOOL;
function GetTabbedTextExtent(hDC: HDC; lpString: PChar;
                             nCount, nTabPositions: Integer; 
                             var lpnTabStopPositions): DWORD; 
function TabbedTextOut(hDC: HDC; X, Y: Integer; lpString: PChar; 
                       nCount, nTabPositions: Integer;
                       var lpnTabStopPositions; nTabOrigin: Integer): Longint;
function SetTextAlign(DC: HDC; Flags: UINT): UINT;
function GetMapMode(DC: HDC): Integer;
function SetMapMode(DC: HDC; p2: Integer): Integer;
//function LoadBitmap(hInstance: HINST; lpBitmapName: PAnsiChar): HBITMAP;
//function LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR;
function EnumThreadWindows(dwThreadId: DWORD; lpfn: TFNWndEnumProc; lParam: LPARAM): BOOL;
procedure OutputDebugString(lpOutputString: PChar);
function SetViewportOrgEx(DC: HDC; X, Y: Integer; Point: PPoint): BOOL;
function GlobalAlloc(uFlags: UINT; dwBytes: DWORD): HGLOBAL;
function GlobalLock(hMem: HGLOBAL): Pointer;
function GlobalUnlock(hMem: HGLOBAL): BOOL;
//function DestroyCursor(hCursor: HICON): BOOL;
//{$IFDEF MSWINDOWS}  //Not needed with GTK and Qt (but doesn't hurt); Win32 and Carbon need it.
function PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL;
function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
//{$ENDIF}
procedure RecreateWnd(const AWinControl:TWinControl);

 {These belong in Classes unit}
//function MakeObjectInstance(Method: TWndMethod): Pointer;
//procedure FreeObjectInstance(ObjectInstance: Pointer);
//function AllocateHWnd(Method: TWndMethod): HWND;
//procedure DeallocateHWnd(Wnd: HWND);

 {This belongs in System unit}
//function FindClassHInstance(ClassType: TClass): LongWord;

 {This belongs in ExtCtrls unit}
procedure Frame3D(Canvas: TCanvas; var Rect: TRect;
                  TopColor, BottomColor: TColor; Width: Integer);

// {This should be a TCanvas method} <--it is now, but still needed for TBitMap.BrushCopy.
procedure BrushCopy(DestCanvas: TCanvas; const Dest: TRect; Bitmap: TBitmap; 
                    const Source: TRect; Color: TColor);

 {This belongs in Buttons unit}
function DrawButtonFace(Canvas: TCanvas; const Client: TRect; 
                        BevelWidth: Integer; Style: TButtonStyle; 
                        IsRounded, IsDown, IsFocused: Boolean): TRect;

 {Additional routines}
{$IFDEF LINUX}
function GetBrowserPath : string;
{$ENDIF}


implementation

 {These functions belong in LclIntf unit}

function IsCharAlpha(c : Char) : Boolean;
// Doesn't handle upper-ANSI chars, but then LCL IsCharAlphaNumeric
//  function doesn't either.
begin
  Result := ((Ord(c) >= 65) and (Ord(c) <= 90)) or 
            ((Ord(c) >= 97) and (Ord(c) <= 122));
end;

function DefWindowProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
// DefWindowProc is a Win API function for handling any window message
//  that the application doesn't handle.
// Can't find equivalent in LCL.
begin
{$IFDEF MSWINDOWS}
  Result := Windows.DefWindowProc(hWnd, Msg, wParam, lParam);
{$ELSE}
  Result := 0;
{$ENDIF}
end;

function GetProfileInt(lpAppName, lpKeyName: PChar; nDefault: Integer): UINT;
// Return the integer value for the key name in the lpAppName section
//  of the WIN.INI file, which on Win32 maps to the corresponding
//  section of the Windows registry.
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetProfileInt(lpAppName, lpKeyName, nDefault);
{$ELSE}  //Just return default for now.
  Result := nDefault;
{$ENDIF}
end;

function GetProfileString(lpAppName, lpKeyName, lpDefault: PChar;
                          lpReturnedString: PChar; nSize: DWORD): DWORD;
// Return the string value for the key name in the lpAppName section
//  of the WIN.INI file, which on Win32 maps to the corresponding
//  section of the Windows registry.
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetProfileString(lpAppName, lpKeyName, lpDefault,
                                     lpReturnedString, nSize);
{$ELSE}  //Just return default for now.
  StrLCopy(lpReturnedString, lpDefault, Pred(nSize));
{$ENDIF}
end;

function GetTickCount : DWORD;
 {On Windows, this is number of milliseconds since Windows was 
   started. On non-Windows platforms, LCL returns number of 
   milliseconds since Dec. 30, 1899, wrapped by size of DWORD.
   This value can overflow LongInt variable when checks turned on, 
   so "wrap" value here so it fits within LongInt.
  Also, since same thing could happen with Windows that has been
   running for at least approx. 25 days, override it too.} 
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetTickCount mod High(LongInt);
{$ELSE}
  Result := LclIntf.GetTickCount mod High(LongInt);
{$ENDIF}  
end;

function SetTimer(hWnd: HWND; nIDEvent, uElapse: UINT;
                  lpTimerFunc: TFNTimerProc): UINT;
begin
{$IFDEF MSWINDOWS}
  Result := {Windows.}SetTimer(hWnd, nIDEvent, uElapse, lpTimerFunc);
{$ENDIF}
end;

function KillTimer(hWnd: HWND; uIDEvent: UINT): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.KillTimer(hWnd, UIDEvent);
{$ENDIF}
end;

function GetCaretBlinkTime: UINT; 
// This function and SetCaretBlinkTime are only used in OvcCaret unit's
//  TOvcSingleCaret.SetLinked, which is used to write Linked property. 
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetCaretBlinkTime;
{$ELSE}
  Result := 530;  //Default on Win XP, so use as reasonable value
{$ENDIF}
end;

function SetCaretBlinkTime(uMSeconds: UINT): BOOL; 
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetCaretBlinkTime(uMSeconds);
{$ENDIF}
end;

function DestroyCaret: BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.DestroyCaret;
{$ENDIF}
end;

function MessageBeep(uType: UINT): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.MessageBeep(uType);
{$ELSE}
  Beep;  //Most calls pass 0 as uType (MB_OK), which is system default sound}
{$ENDIF}
end;

function SystemParametersInfo(uiAction, uiParam: UINT;
                              pvParam: Pointer; fWinIni: UINT): BOOL;
// Only used in:
//  OvcMisc: PathEllipsis, which is only used in ovcmru (not yet ported).
//  OvcEdClc: TOvcCustomNumberEdit.PopupOpen.
//  OvcEdCal: TOvcCustomDateEdit.PopupOpen.
//  OvcEdSld (not yet ported).
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SystemParametersInfo(uiAction, uiParam, pvParam,
                                         fWinIni);
{$ENDIF}
end;

{$IFNDEF MSWINDOWS}
function GetSystemMetrics(nIndex: Integer): Integer;
// SM_CYBORDER, etc. not implemented yet in GTK widgetset.
begin
  if nIndex = SM_SWAPBUTTON then
    Result := 0  {Not implemented on GTK, so assume buttons not swapped}
  else
    begin
    if nIndex = SM_CYBORDER then
//      nIndex := SM_CYEDGE;  //Substitute for now so returned value is valid.
      begin  //Neither implemented, so catch here to eliminate TODO messages.
      Result := 0;  //0 was being returned before.
      Exit;
      end;
    Result := LclIntf.GetSystemMetrics(nIndex);
    end;
end;
{$ENDIF}

function MoveWindow(hWnd: HWND; X, Y, nWidth, nHeight: Integer; bRepaint: BOOL): BOOL;
// Only used in:
//  OvcEdClc: TOvcCustomNumberEdit.PopupOpen.
//  OvcEdCal: TOvcCustomDateEdit.PopupOpen.
//  OvcEdSld (not yet ported).
begin
{$IFDEF MSWINDOWS}
  Result := Windows.MoveWindow(hWnd, X, Y, nWidth, nHeight, bRepaint);
{$ENDIF}  
end;

function SetWindowPos(hWnd: HWND; hWndInsertAfter: HWND;
                      X, Y, cx, cy: Integer; uFlags: UINT): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetWindowPos(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags);
{$ELSE}  //Doesn't do much with GTK, but call it anyway.
  Result := LclIntf.SetWindowPos(hWnd, hWndInsertAfter, X, Y, cx, cy, uFlags); 
  if (uFlags and SWP_HIDEWINDOW) <> 0 then
    FindControl(hWnd).Visible := False
  else if (uFlags and SWP_SHOWWINDOW) <> 0 then
    FindControl(hWnd).Visible := True;
{$ENDIF}
end;                      

function UpdateWindow(hWnd: HWND): BOOL;
 {For some reason, implementing this function in win32 widgetset 
   on 27-May-2008 broke TOvcTable when a manifest is used.
   Since TOvcTable worked when this function was not implemented,
   just intercept and ignore call for now.} 
begin
  Result := True;
end;

function ValidateRect(hWnd: HWND; lpRect: PRect): BOOL;
// Since LCL InvalidateRect redraws window, shouldn't need this function,
//  so leave it as stub for now.
begin
{$IFDEF MSWINDOWS}
//  Result := Windows.ValidateRect(hWnd, lpRect);
{$ENDIF}
  Result := True;
end;

function InvalidateRect(hWnd: HWND; lpRect: PRect; bErase: BOOL): BOOL;
 {InvalidateRect crashes if lpRect is nil with some versions of LCL.}
begin
{$IFDEF MSWINDOWS}
  if Assigned(lpRect) then
    Result := LclIntf.InvalidateRect(hWnd, lpRect, bErase)
  else
    Result := Windows.InvalidateRect(hWnd, lpRect, bErase);
{$ELSE}
  if Assigned(lpRect) then
    Result := LclIntf.InvalidateRect(hWnd, lpRect, bErase)
  else
    Result := True;
   //For now just ignore if nil since no alternative as with Windows.
{$ENDIF}
end;

function InvalidateRgn(hWnd: HWND; hRgn: HRGN; bErase: BOOL): BOOL;
{$IFDEF MSWINDOWS}
begin
  Result := Windows.InvalidateRgn(hWnd, hRgn, bErase);
{$ELSE}  
var
  ARect : TRect;
begin
  GetRgnBox(hRgn, @ARect);
  Result := InvalidateRect(hWnd, @ARect, bErase);
{$ENDIF}
end;

function GetRgnBox(RGN : HRGN; lpRect : PRect) : Longint;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetRgnBox(RGN, lpRect);
{$ELSE}
  Result := LclIntf.GetRgnBox(RGN, lpRect);
{$ENDIF}  
end;

function PtInRegion(RGN: HRGN; X, Y: Integer) : Boolean;
{$IFDEF MSWINDOWS}
begin
  Result := Windows.PtInRegion(RGN, X, Y);
{$ELSE}
var
  ARect : TRect;
  APt   : TPoint;
begin
  GetRgnBox(RGN, @ARect);
  APt.X := X;
  APt.Y := Y;
  Result := LclIntf.PtInRect(ARect, APt);
{$ENDIF}
end;

function SetWindowText(hWnd: HWND; lpString: PChar): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetWindowText(hWnd, lpString);
{$ELSE}
// Use FindControl, then assign to control's Text property?
{$ENDIF}
end;

function GetBkColor(hDC: HDC): COLORREF;
// Only used in:
//  OvcEF: TOvcBaseEntryField.efPaintPrim.
//  OvcLkOut (not yet ported).
//  O32LkOut (not yet ported).
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetBkColor(hDC);
{$ELSE}  // Since SetBkColor returns previous color, use it to get color.  
  Result := SetBkColor(hDC, 0);  //Set background color to black.
  SetBkColor(hDC, Result);  //Restore background color
{$ENDIF}
end;

function GetBkMode(hDC: HDC): Integer;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetBkMode(hDC);
{$ELSE}
  Result := TRANSPARENT;  //For now
//  Result := SetBkMode(hDC, TRANSPARENT);  //Use when widgetsets support it
//  SetBkMode(hDC, Result);
{$ENDIF}
end;

function GetWindow(hWnd: HWND; uCmd: UINT): HWND;
{$IFDEF MSWINDOWS}
begin
  Result := Windows.GetWindow(hWnd, uCmd);
{$ELSE}
var
  AWinControl : TWinControl;
begin
  Result := 0;
  AWinControl := FindControl(hWnd);
  if AWinControl <> nil then
    begin
    case uCmd of
      GW_HWNDNEXT :
        begin
// FindNextControl is declared in protected section, so can't use it.
//        AWinControl := AWinControl.FindNextControl(AWinControl, True, False, False);
//        if AWinControl <> nil then
//          Result := AWinControl.Handle;
        end; 
      GW_CHILD :
        begin
        if AWinControl.ControlCount > 0 then
          Result := TWinControl(AWinControl.Controls[0]).Handle;
        end;
      GW_HWNDLAST :
        begin
        if AWinControl.Parent <> nil then
          Result := TWinControl(AWinControl.Parent.Controls[Pred(AWinControl.Parent.ControlCount)]).Handle;
        end; 
      end;
    end;  
{$ENDIF}
end;

function GetNextWindow(hWnd: HWND; uCmd: UINT): HWND;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetNextWindow(hWnd, uCmd);
{$ELSE}
  Result := GetWindow(hWnd, uCmd);  
{$ENDIF}
end;

function RedrawWindow(hWnd: HWND; lprcUpdate: PRect; hrgnUpdate: HRGN; flags: UINT): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.RedrawWindow(hWnd, lprcUpdate, hrgnUpdate, flags);
{$ELSE}
{$ENDIF}
end;

function GetWindowDC(hWnd: HWND): HDC;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetWindowDC(hWnd);
{$ELSE}
{$ENDIF}
end;

function ScrollDC(DC: HDC; DX, DY: Integer; var Scroll, Clip: TRect; Rgn: HRGN;
                  Update: PRect): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.ScrollDC(DC, DX, DY, Scroll, Clip, Rgn, Update);
{$ELSE}
{$ENDIF}
end;

function SetScrollRange(hWnd: HWND; nBar, nMinPos, nMaxPos: Integer; bRedraw: BOOL): BOOL;
{$IFDEF MSWINDOWS}
begin
  Result := Windows.SetScrollRange(hWnd, nBar, nMinPos, nMaxPos, bRedraw);
end;
{$ELSE}  //GTK needs more information, so use SetScrollInfo
var
  ScrInfo : TScrollInfo;
begin
  ScrInfo.fMask := SIF_RANGE or SIF_UPDATEPOLICY;
  ScrInfo.nTrackPos := SB_POLICY_CONTINUOUS;
  ScrInfo.nMin := nMinPos;
  ScrInfo.nMax := nMaxPos;
  LclIntf.SetScrollInfo(hWnd, nBar, ScrInfo, True);
  Result := True;
end;
{$ENDIF}

function GetTabbedTextExtent(hDC: HDC; lpString: PChar;
                             nCount, nTabPositions: Integer; 
                             var lpnTabStopPositions): DWORD;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetTabbedTextExtent(hDC, lpString, nCount, nTabPositions, 
                                        lpnTabStopPositions);
{$ELSE}
  Result := 0;  //Not implemented yet (see comment below).
{$ENDIF}
end;

function TabbedTextOut(hDC: HDC; X, Y: Integer; lpString: PChar; 
                       nCount, nTabPositions: Integer;
                       var lpnTabStopPositions; nTabOrigin: Integer): Longint;
{$IFDEF MSWINDOWS}
begin
  Result := Windows.TabbedTextOut(hDC, X, Y, lpString, nCount, nTabPositions,
                                  lpnTabStopPositions, nTabOrigin);
{$ELSE}
// TODO: Not yet implemented since not needed by Orpheus:
//  -Special case where nTabPositions is 0 and lpnTabStopPositions is nil.
//  -Special case where nTabPositions is 1 and >1 tab in string.
//  -Return value (height and width of string).   
//  -Use of nTabOrigin. This is used in OvcVLB as a negative offset
//    with horizontal scrolling, but value passed is determined by 
//    GetTabbedTextExtent, which is not yet implemented (above). Shouldn't
//    be needed if virtual list box doesn't have horizontal scrollbar.
type
  TTabArray = array[1..1000] of Integer;  {Assume no more than this many tabs}
var
  OutX      : Integer;
  TabCnt    : Integer;
  StartPos  : Integer;
  CharPos   : Integer;
  OutCnt    : Integer;
  TextSize  : TSize;
begin
  OutX := X;
  TabCnt := 0;
  StartPos := 0;
  for CharPos := 0 to Pred(nCount) do
    begin
    if (lpString[CharPos] = #9) or (CharPos = Pred(nCount)) then  {Output text?}
      begin
      OutCnt := CharPos - StartPos;
      if CharPos = Pred(nCount) then  {Include last char?}
        Inc(OutCnt);
      if (TabCnt > 0) and (TTabArray(lpnTabStopPositions)[TabCnt] < 0) then
        begin  {Negative tab position means following text is right-aligned to it}
        GetTextExtentPoint(hDC, lpString+StartPos, OutCnt, TextSize);
        OutX := X + Abs(TTabArray(lpnTabStopPositions)[TabCnt]) - TextSize.cx;
        end;
      LclIntf.TextOut(hDC, OutX, Y, lpString+StartPos, OutCnt);
      StartPos := Succ(CharPos);
      if (lpString[CharPos] = #9) and (TabCnt < nTabPositions) then
        begin
        Inc(TabCnt);
        OutX := X + TTabArray(lpnTabStopPositions)[TabCnt];
        end;
      end;
    end;
  Result := 0;  //Just return this for now.
{$ENDIF}
end;

function SetTextAlign(DC: HDC; Flags: UINT): UINT;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetTextAlign(DC, Flags);
{$ELSE}
{$ENDIF}
end;

function GetMapMode(DC: HDC): Integer;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GetMapMode(DC);
{$ELSE}
{$ENDIF}
end;

function SetMapMode(DC: HDC; p2: Integer): Integer;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetMapMode(DC, p2);
{$ELSE}
{$ENDIF}
end;

function LoadBitmap(hInstance: HINST; lpBitmapName: PAnsiChar): HBITMAP;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.LoadBitmap(hInstance, lpBitmapName);
{$ENDIF}
end;

function LoadCursor(hInstance: HINST; lpCursorName: PAnsiChar): HCURSOR;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.LoadCursor(hInstance, lpCursorName);
{$ENDIF}
end;

function EnumThreadWindows(dwThreadId: DWORD; lpfn: TFNWndEnumProc; lParam: LPARAM): BOOL;
// Only used in OvcMisc IsForegroundTask function, which is only
//  used in OvcSpeed (not yet ported).
begin
{$IFDEF MSWINDOWS}
  Result := Windows.EnumThreadWindows(dwThreadId, lpfn, lParam);
{$ENDIF}   
end;

procedure OutputDebugString(lpOutputString: PChar);
begin
{$IFDEF MSWINDOWS}
  Windows.OutputDebugString(lpOutputString);
{$ENDIF}
end;

function SetViewportOrgEx(DC: HDC; X, Y: Integer; Point: PPoint): BOOL;
// Only used in OvcMisc CopyParentImage procedure, which is only
//  used by TOvcCustomSpeedButton.Paint in OvcSpeed (not yet ported).
begin
{$IFDEF MSWINDOWS}
  Result := Windows.SetViewportOrgEx(DC, X, Y, Point);
{$ENDIF}
end;

function GlobalAlloc(uFlags: UINT; dwBytes: DWORD): HGLOBAL;
// GlobalAlloc, GlobalLock, and GlobalUnlock are only used in:
//  OvcEF: TOvcBaseEntryField.efCopyPrim and TOvcBaseEntryField.WMPaste.
//  OvcEdit (not yet ported).
//  OvcViewr (not yet ported).
// Replace code in those units with calls to standard Clipboard methods?
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GlobalAlloc(uFlags, dwBytes);
{$ELSE}
  Result := THandle(GetMem(dwBytes));
{$ENDIF}
end;

function GlobalLock(hMem: HGLOBAL): Pointer;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GlobalLock(hMem);
{$ELSE}
  Result := PAnsiChar(hMem);
{$ENDIF}
end;

function GlobalUnlock(hMem: HGLOBAL): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.GlobalUnlock(hMem);
{$ELSE}
  FreeMem(Pointer(hMem));
  Result := True;
{$ENDIF}
end;

function DestroyCursor(hCursor: HICON): BOOL;
begin
{$IFDEF MSWINDOWS}
  Result := Windows.DestroyCursor(hCursor);
{$ENDIF}
end;


function PostMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): BOOL;
 {Use control's Perform method to force it to respond to posted message.
  This doesn't work:  Result := LclIntf.PostMessage(hWnd, Msg, wParam, lParam); }
var
  AWinControl : TWinControl;
begin
  Assert(hWnd <> 0, 'Window handle not assigned on entry to PostMessage');
  AWinControl := FindOwnerControl(hWnd);
//  Assert(AWinControl <> nil, 
//         'Owner control not found in PostMessage ($' + IntToHex(Msg, 4) + ') ');
  if AWinControl <> nil then
    AWinControl.Perform(Msg, wParam, lParam);
  Result := True;
end;

function SendMessage(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM): LRESULT;
 {Use control's Perform method to force it to respond to sent message.
  This doesn't work: Result := LclIntf.SendMessage(hWnd, Msg, wParam, lParam); }
var
  AWinControl : TWinControl;
begin
  Assert(hWnd <> 0, 'Window handle not assigned on entry to SendMessage');
  AWinControl := FindOwnerControl(hWnd);
//  Assert(AWinControl <> nil,
//         'Owner control not found in SendMessage ($' + IntToHex(Msg, 4) + ') ');
  if AWinControl <> nil then
    Result := AWinControl.Perform(Msg, wParam, lParam);
end;

procedure RecreateWnd(const AWinControl:TWinControl);
// Calls to Controls.RecreateWnd shouldn't be needed with GTK widgetset,
//  so just ignore them.
begin
{$IFDEF MSWINDOWS}
  Controls.RecreateWnd(AWinControl);
{$ENDIF}
end;


 {These belong in Classes unit}
function MakeObjectInstance(Method: TWndMethod): Pointer;
begin
end;

procedure FreeObjectInstance(ObjectInstance: Pointer);
begin
end;

function AllocateHWnd(Method: TWndMethod): HWND;
begin
end;

procedure DeallocateHWnd(Wnd: HWND);
begin
end;


 {This belongs in System unit}
function FindClassHInstance(ClassType: TClass): LongWord;
begin
(*
  Result := System.MainInstance;
*)
  Result := System.HInstance;
end;


 {This belongs in ExtCtrls unit}
procedure Frame3D(Canvas: TCanvas; var Rect: TRect;
                  TopColor, BottomColor: TColor; Width: Integer);
begin
  Canvas.Frame3D(Rect, Width, bvLowered);
   {Need a way of determining whether to pass bvNone, bvLowered,
     bvRaised, or bvSpace based on TopColor and BottomColor.
     See Delphi help for Frame3D.} 
end;


 {This should be a TCanvas method}
procedure BrushCopy(DestCanvas: TCanvas; const Dest: TRect; Bitmap: TBitmap; 
                    const Source: TRect; Color: TColor);
begin
  StretchBlt(DestCanvas.Handle, Dest.Left, Dest.Top,
             Dest.Right - Dest.Left, Dest.Bottom - Dest.Top,
             Bitmap.Canvas.Handle, Source.Left, Source.Top,
             Source.Right - Source.Left, Source.Bottom - Source.Top, SrcCopy);
end;


 {This belongs in Buttons unit}
function DrawButtonFace(Canvas: TCanvas; const Client: TRect;
                        BevelWidth: Integer; Style: TButtonStyle; 
                        IsRounded, IsDown, IsFocused: Boolean): TRect;
 {Draw a push button.
  Style, IsRounded and IsFocused params appear to be left over
   from Win 3.1, so ignore them.}  
var
  ARect : TRect;
begin
  ARect := Client;
   {The way LCL TCustomSpeedButton draws a button}
  if IsDown then
    begin
    if WidgetSet.LCLPlatform <> lpCarbon then
      Canvas.Frame3D(ARect, BevelWidth, bvLowered)
    else  //bvLowered currently not supported on Carbon.
      Canvas.Frame3D(ARect, BevelWidth, bvRaised)
    end
  else
    Canvas.Frame3D(ARect, BevelWidth, bvRaised);
  Result := Client;  //Should reduce dimensions by edges and bevels.
end;


 {Additional routines}
{$IFDEF LINUX}
function SearchForBrowser(const BrowserFileName : string) : string;
 {Search path for specified browser file name, returning
   its expanded file name that includes path to it.}
begin
  Result :=
   SearchFileInPath(BrowserFileName, '', GetEnvironmentVariable('PATH'),
                    PathSeparator, [sffDontSearchInBasePath]);
end;

function GetBrowserPath : string;
 {Return path to first browser found.}
begin
  Result := SearchForBrowser('firefox');
  if Result = '' then
    Result := SearchForBrowser('konqueror');  {KDE browser}
  if Result = '' then
    Result := SearchForBrowser('epiphany');  {GNOME browser}
  if Result = '' then
    Result := SearchForBrowser('mozilla');
  if Result = '' then
    Result := SearchForBrowser('opera'); 
end;
{$ENDIF}


end.
