{*********************************************************}
{*                    O32VLOP1.PAS 4.06                  *}
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

unit o32vlop1;
  {-ValidatorOptions class for use in components and classes which contain
    their own validator objects, like the ValidatorPool, FlexEdit, Etc...}

interface


uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, Types, LclType, MyMisc, {$ENDIF} 
  Controls, Classes, Forms, SysUtils,
  O32Vldtr, OvcData, OvcExcpt, OvcConst;

type
  TValidationType = (vtNone, vtUser, vtValidator);

  TProtectedControl = class(TWinControl);

  TValidatorOptions = class(TPersistent)
  protected {private}
    FOwner          : TWinControl;
    FHookedControl  : TWinControl;
    FValidationType : TValidationType;
    FValidatorType  : String;
    FValidatorClass : TValidatorClass;
    FSoftValidation : Boolean;
    FMask           : String;
    FLastValid      : Boolean;
    FLastErrorCode  : Word;
    FBeepOnError    : Boolean;
    FInputRequired  : Boolean;
    FEnableHooking  : Boolean;
    FUpdating       : Integer;

    {Event for which this object will execute a validation}
    FEvent          : TValidationEvent;

    {WndProc Pointers}
    NewWndProc      : Pointer;
    PrevWndProc     : Pointer;

    procedure HookControl;
    procedure UnHookControl;
    procedure voWndProc(var Msg : TMessage);

    procedure RecreateHookedWnd;
    function Validate: Boolean;

    procedure AssignValidator;
    procedure SetValidatorType(const VType: String);
    procedure SetEvent(Event: TValidationEvent);
    procedure SetEnableHooking(Value: Boolean);

    property InputRequired: Boolean read FInputRequired write FInputRequired;

  public
    constructor Create(AOwner: TWinControl); dynamic;
    destructor Destroy; override;

    procedure AttachTo(Value : TWinControl);
    procedure SetLastErrorCode(Code: Word);
    procedure SetLastValid(Valid: Boolean);

    procedure BeginUpdate;
    procedure EndUpdate;

    property LastValid: Boolean read FLastValid;
    property LastErrorCode: Word read FLastErrorCode;
    property EnableHooking: Boolean read FEnableHooking write SetEnableHooking;
    property ValidatorClass: TValidatorClass read FValidatorClass
      write FValidatorClass;
  published
    property BeepOnError: Boolean read FBeepOnError write FBeepOnError;


    property SoftValidation: Boolean read FSoftValidation write FSoftValidation;

    property ValidationEvent: TValidationEvent read FEvent write SetEvent
      stored true;
    property ValidatorType : string
      read FValidatorType write SetValidatorType stored true;
    property ValidationType: TValidationType
      read FValidationType write FValidationType stored true;
    property Mask: String read FMask write FMask stored true;
  end;

implementation


// Note that workaround below currently works only with win32.
//  Other widgetsets currently don't implement Get/SetWindowLong
//  or never call LclWndProc (don't implement CallWindowProc 
//  correctly?), but the workaround code appears harmless.
//  Just undefine LCLWndProc to disable workaround code.
{$IFDEF LCL}
 {$DEFINE LCLWndProc}
{$ENDIF}

{$IFDEF LCLWndProc}  
// Workaround for lack of MakeObjectInstance in LCL for making 
//  a WindowProc callback function from an object method.
//  Pass pointer to this function to SetWindowLong wherever using 
//  MakeObjectInstance. Also set window's user data to pointer to
//  object method's pointers so method can be reconstituted here.
// Note: Adapted from Felipe's CallbackAllocateHWnd procedure. 
function LclWndProc(hWnd: HWND; Msg: UINT; wParam: WPARAM; lParam: LPARAM) : LRESULT; 
          {$IFDEF MSWINDOWS} stdcall; {$ELSE} cdecl; {$ENDIF}
var
  AMsg      : TMessage;
  MethodPtr : ^TWndMethod;
begin
  FillChar(AMsg, SizeOf(Msg), #0);
  
   {Populate message}
  AMsg.Msg := Msg;  
  AMsg.WParam := wParam;
  AMsg.LParam := lParam;

   {Get pointer to memory containing method's code and data pointers}
  MethodPtr := Pointer(GetWindowLong(hWnd, GWL_USERDATA));

  if Assigned(MethodPtr) then
    MethodPtr^(AMsg);  {Dereference pointer and call method with message}
end;
{$ENDIF}


{===== TValidatorOptions =============================================}
constructor TValidatorOptions.Create(AOwner: TWinControl);
begin
  inherited Create;

  FOwner := AOwner;

{$IFNDEF LCL}
  {create a callable window proc pointer}
  {$IFDEF VERSION6}
    NewWndProc := Classes.MakeObjectInstance(voWndProc);
  {$ELSE}
    NewWndProc := MakeObjectInstance(voWndProc);
  {$ENDIF}
{$ELSE}
  {$IFDEF LCLWndProc}
    NewWndProc := @LclWndProc;
  {$ENDIF}
{$ENDIF}

  ValidatorType := 'None';
  FSoftValidation := false;
  ValidationType := vtNone;
  ValidationEvent := veOnExit;
  FInputRequired := false;
  FEnableHooking := true;
  BeepOnError := true;
  FValidatorClass := nil;
  FMask := '';
  FLastValid := false;
  FLastErrorCode := 0;
end;
{=====}

destructor TValidatorOptions.Destroy;
begin
  UnhookControl;
  FValidatorClass := nil;
  inherited destroy;
end;
{=====}

procedure TValidatorOptions.HookControl;
var
  P : Pointer;
{$IFDEF LCLWndProc}
  MethodPtr : ^TWndMethod;
{$ENDIF}
begin
  if not FEnableHooking then exit;
  {hook into owner's window procedure}
  if (FHookedControl <> nil) then begin
    if not FHookedControl.HandleAllocated then FHookedControl.HandleNeeded;
    {save original window procedure if not already saved}
    P := Pointer(GetWindowLong(FHookedControl.Handle, GWL_WNDPROC));
    if (P <> NewWndProc) then begin
      PrevWndProc := P;
      {redirect message handling to ours}
{$IFDEF LCLWndProc}
      GetMem(MethodPtr, SizeOf(TMethod));  {Allocate memory}
      MethodPtr^ := voWndProc;  {Store method's code and data pointers}
       {Associate pointer to memory with window}
      SetWindowLong(FHookedControl.Handle, GWL_USERDATA, PtrInt(MethodPtr));
      if not Assigned(Pointer(GetWindowLong(FHookedControl.Handle, GWL_USERDATA))) then
        FreeMem(MethodPtr);  //SetWindowLong not implemented for widgetset
{$ENDIF}
      SetWindowLong(FHookedControl.Handle, GWL_WNDPROC, LPARAM(NewWndProc));  //64
    end;
  end;
end;
{=====}

procedure TValidatorOptions.UnHookControl;
{$IFDEF LCLWndProc}
var
  MethodPtr : ^TWndMethod;
{$ENDIF}
begin
  if (FHookedControl <> nil) then begin
    if Assigned(PrevWndProc) and FHookedControl.HandleAllocated then
      begin
{$IFDEF LCLWndProc}
       {Get pointer to memory allocated previously}
      MethodPtr := Pointer(GetWindowLong(FHookedControl.Handle, GWL_USERDATA));
      if Assigned(MethodPtr) then
        FreeMem(MethodPtr);
{$ENDIF}    
      SetWindowLong(FHookedControl.Handle, GWL_WNDPROC, LPARAM(PrevWndProc));  //64
      end;
  end;
  PrevWndProc := nil;
end;
{=====}

procedure TValidatorOptions.AttachTo(Value : TWinControl);
var
  WC : TWinControl;
begin
  if not FEnableHooking then Exit;

  FHookedControl := Value;

  {unhook from attached control's window procedure}
  UnHookControl;

  {insure that we are the only one to hook to this control}
  if not (csLoading in FOwner.ComponentState) and Assigned(Value) then begin
    {send message asking if this control is attached to anything}
    {the control itself won't be able to respond unless it is attached}
    {in which case, it will be our hook into the window procedure that}
    {is actually responding}

    if not Value.HandleAllocated then
      Value.HandleNeeded;

    if Value.HandleAllocated then begin
      WC := TWinControl(SendMessage(Value.Handle, OM_ISATTACHED, 0, 0));
      if Assigned(WC) then
        raise EOvcException.CreateFmt(GetOrphStr(SCControlAttached),
          [WC.Name])
      else
        HookControl;
    end;
  end;
end;
{=====}

procedure TValidatorOptions.SetEvent(Event: TValidationEvent);
begin
  if Event <> FEvent then
    FEvent := Event;
end;
{=====}

procedure TValidatorOptions.SetEnableHooking(Value: Boolean);
begin
  if FEnableHooking <> Value then begin
    FEnableHooking := Value;
    if FEnableHooking and (FHookedControl <> nil) then
      AttachTo(FHookedControl);
  end else
    UnHookControl;
end;
{=====}

procedure TValidatorOptions.RecreateHookedWnd;
begin
  if not (csDestroying in FHookedControl.ComponentState) then
    PostMessage(FHookedControl.Handle, OM_RECREATEWND, 0, 0);
end;
{=====}

procedure TValidatorOptions.voWndProc(var Msg : TMessage);
begin
  with Msg do begin
    case FEvent of
      veOnEnter  : if Msg = {$IFNDEF LCL} CM_ENTER {$ELSE} LM_SETFOCUS {$ENDIF} then
        Validate;

      veOnExit   : if Msg = {$IFNDEF LCL} CM_EXIT {$ELSE} LM_KILLFOCUS {$ENDIF} then
        if (not Validate) and (not FSoftValidation) then
          begin
          FHookedControl.SetFocus;
{$IFDEF LCL}
          Exit;
{$ENDIF}          
          end;

      {TextChanged}
      veOnChange : if Msg = 48435 then  //Probably doesn't work with LCL
        Validate;

    end;

    {Pass the message on...}
    if PrevWndProc <> nil then
      Result := CallWindowProc(PrevWndProc, FHookedControl.Handle, Msg,
        WParam, LParam)
    else
      Result := CallWindowProc(TProtectedControl(FHookedControl).DefWndProc,
        FHookedControl.Handle, Msg, wParam, lParam);
  end;
end;
{=====}

procedure TValidatorOptions.AssignValidator;
begin
  if (FValidatorType = 'None') or (FValidatorType = '')then
    FValidatorClass := nil
  else try
    FValidatorClass := TValidatorClass(FindClass(FValidatorType));
  except
    FValidatorClass := nil;
  end;
end;
{=====}

procedure TValidatorOptions.SetLastErrorCode(Code: Word);
begin
  FLastErrorCode := Code;
end;
{=====}

function TValidatorOptions.Validate: Boolean;
begin
  {Don't validate if we're in the middle of updates.}
  if FUpdating > 0 then begin
    result := true;
    exit;
  end;

  {Send a Validate message to the Owner}
  SetLastErrorCode(SendMessage(FOwner.Handle, OM_VALIDATE, 0, 0));
  SetLastValid(FLastErrorCode = 0);
  result := FLastValid;
end;

procedure TValidatorOptions.SetLastValid(Valid: Boolean);
begin
  FLastValid := Valid;
end;
{=====}

procedure TValidatorOptions.BeginUpdate;
begin
  Inc(FUpdating);
end;
{=====}

procedure TValidatorOptions.EndUpdate;
begin
  Dec(FUpdating);
  if FUpdating < 0 then
    FUpdating := 0;
end;
{=====}

procedure TValidatorOptions.SetValidatorType(const VType: String);
begin
  if FValidatorType <> VType then begin
    FValidatorType := VType;
    AssignValidator;
  end;
end;


end.
