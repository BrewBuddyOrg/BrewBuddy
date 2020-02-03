{
 /***************************************************************************

 timeedit.pp

 Endurance Calculator

 Copyright (C) 2001 by Bart Broersma & Flying Sheep Inc

 This library is free software; you can redistribute it and/or modify it
 under the terms of the GNU Library General Public License as published by
 the Free Software Foundation; either version 2 of the License, or (at your
 option) any later version.

 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
 for more details.

 You should have received a copy of the GNU Library General Public License
 along with this library; if not, write to the Free Software Foundation,
 Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

 /***************************************************************************
  }


{
 The TTimeEdit class provides a control which can be used to input time in either
 hh:mm:ss or hh:mm format.

 For ease of use it has a read/write propert called Time (of type TDateTime),
 thus releiving the application programmer from doing calculations and handling
 exceptions with the various StrToTime functions.
 If a non-valid time is entered (e.g 25:69:71), then the property Time is set to -1.0
 when it is being read.
 A function HasValidTime(out: ATime: TDateTime): Boolean; is provided which returns False
 if an invalid time is in the control. When true, the time is passed in the ATime variable.
 A time of 24:00:00 is considered to be a valid time.

 This control is derived from TCustomMaskEdit, but since it is undesirable that the user
 can set the EditMask property, this property was overridden.
 Setting the TimeEditFormat will set the appropriate EditMask.

 Care is taken so that no EDBEditError can be raised when the control has invalid
 (= non-numeric) characters in it.

 ToDo
 - Really disallow invalid input in a more sophisticated manor than in setting
   ForceValidTimeOnChange or ForceValidTimeOnExit to True (or smartening the code
   in the respective methods).
 - Make it an installable Lazarus package, so it can be put on a form in design time
}

unit TimeEdit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, Clipbrd, LCLType, LCLProc, MaskEdit, ComCtrls;

type
  TTimeEditFormat = (tefLong, tefShort);

type

  { TCustomTimeEdit }
  ETimeEditError = class(Exception);

  TCustomTimeEdit = Class(TCustomMaskEdit)
  private
    //FUpDown: TUpDown;
    FTimeEditFormat: TTimeEditFormat;
    FForceValidTimeOnChange: Boolean;
    FForceValidTimeOnExit: Boolean;
    procedure _SetMask(const AMask: String);
    function _GetMask: String;
    procedure _SetSpaceChar(AValue: Char);
    function _GetSpaceChar: Char;
    function SplitTime(const TimeStr: String; out H, M, Sec: Integer): Boolean;
    procedure DoUpDown(const Up: Boolean);
    function CreateValidContent(S: String): String;
    procedure ForceValidContent;
    procedure ForceValidTime;
  protected
    procedure TextChanged; override;
    procedure DoExit; override;

    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;

    function GetTime: TDateTime;
    procedure SetTime(const ATime: TDateTime);
    procedure SetTimeEditFormat(const ATimeEditFormat: TTimeEditFormat);

    //overridden properties
    property SpaceChar: Char read _GetSpaceChar write _SetSpaceChar;

    property Time: TDateTime read GetTime write SetTime {default 0};
    property TimeEditFormat: TTimeEditFormat read FTimeEditFormat write SetTimeEditFormat default tefLong;
    property ForceValidTimeOnChange: Boolean read FForceValidTimeOnChange write FForceValidTimeOnChange default False;
    property ForceValidTimeOnExit: Boolean read FForceValidTimeOnExit write FForceValidTimeOnExit default False;
  public
    constructor Create(Aowner : TComponent); override;
    function HasValidTime(out ATime: TDateTime): Boolean;

    //overridden properties (these must be in public section!!)
    property EditMask: string read _GetMask write _SetMask;

  end;

  TTimeEdit = class(TCustomTimeEdit)
  public
    property Time;
  published
    //Specific properties for this control
    property TimeEditFormat;
    property ForceValidTimeOnChange;
    property ForceValidTimeOnExit;
    //Ancestor properties
    //Do not publish EditMask or SpaceChar !!
    property Align;
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BiDiMode;
    property BorderSpacing;
    property BorderStyle;
    property CharCase;
    property Color;
    property Constraints;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property MaxLength;
    property ParentBiDiMode;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseEnter;
    property OnMouseLeave;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUTF8KeyPress;
    property Text;
  end;

implementation

const
  LongEditMask = '!99:99:99;1;0'; //Do not change, especially do not change the last '0' !!!
  ShortEditMask  = '!99:99;1;0';  //Do not change, especially do not change the last '0' !!!
  LenLong = 8;
  LenShort = 5;
  Digits = ['0'..'9'];
  SInternalMaskCorruption = 'Internal Mask Corruption';
  //SUnableToForceValidTime = 'Unable to force valid time';

function ZeroPad2(var S: String): String;
begin
  while (Length(S) < 2) do S := '0' + S;
  Result := S;
end;

{ TCustomTimeEdit }

{$PUSH}
{$HINTS OFF} //avoid the "parameter AMask not used" hint
procedure TCustomTimeEdit._SetMask(const AMask: String);
begin
  //do nothing! We do not allow the user changing the EditMask at all
end;
{$POP}

function TCustomTimeEdit._GetMask: String;
begin
  Result := inherited EditMask;
end;

{$PUSH}
{$HINTS OFF}  //avoid the "parameter AValue not used" hint
procedure TCustomTimeEdit._SetSpaceChar(AValue: Char);
begin
  //Do nothing. We disallow setting it
end;
{$POP}

function TCustomTimeEdit._GetSpaceChar: Char;
begin
  Result := inherited SpaceChar;
end;

function TCustomTimeEdit.SplitTime(const TimeStr: String; out H, M, Sec: Integer): Boolean;
var
  SH, SM, SS: String;
begin
  case FTimeEditFormat of
    tefLong:
    begin
      SH := Copy(TimeStr,1,2);
      SM := Copy(TimeStr,4,2);
      SS := Copy(TimeStr,7,2);
    end;
    tefShort:
    begin
      SH := Copy(TimeStr,1,2);
      SM := Copy(TimeStr,4,2);
      SS := '00';
    end;
  end;
  if SH = '' then SH:= '0';
  if SM = '' then SM:= '0';
  if SS = '' then SS:= '0';
  try
    H := StrToInt(SH);
    M := StrToInt(SM);
    Sec := StrToInt(SS);
  except
    H := -1;
    M := -1;
    Sec := -1;
  end;
  Result := (H >= 0);
end;

procedure TCustomTimeEdit.DoUpDown(const Up: Boolean);
var
  CP, Value: LongInt;
  S, ET: String;
begin
  //debugln('DoIncrement');
  CheckCursor;
  CP := SelStart;
  //debugln('  CP = ',dbgs(CP));
  ET := EditText;
  if (CP = Length(ET)) and (SelLength = 0) then Dec(CP);
  case CP of
    0,1:
    begin
      S := Copy(ET,1,2);
      if TryStrToInt(S, Value) and (Length(ET) >= 2) then
      begin
        if Up then Inc(Value) else Dec(Value);
        if (Value > 23) then Value := 0;
        if (Value < 0) then Value := 23;
        S := IntToStr(Value);
        if Value < 10 then S := '0' + S;
        ET[1] := S[1];
        ET[2] := S[2];
        EditText := ET;
        SelStart := CP;
        CheckCursor;
      end;
    end;
    3,4:
    begin
      S := Copy(ET,4,2);
      if TryStrToInt(S, Value) and (Length(ET) >= LenShort)  then
      begin
        if Up then Inc(Value) else Dec(Value);
        if (Value > 59) then Value := 0;
        if (Value < 0) then Value := 59;
        S := IntToStr(Value);
        if Value < 10 then S := '0' + S;
        ET[4] := S[1];
        ET[5] := S[2];
        EditText := ET;
        SelStart := CP;
        CheckCursor;
      end;
    end;
    6,7:
    begin
      S := Copy(ET,7,2);
      if TryStrToInt(S, Value) and (Length(ET) >= LenLong)  then
      begin
        if Up then Inc(Value) else Dec(Value);
        if (Value > 59) then Value := 0;
        if (Value < 0) then Value := 59;
        S := IntToStr(Value);
        if Value < 10 then S := '0' + S;
        ET[7] := S[1];
        ET[8] := S[2];
        EditText := ET;
        SelStart := CP;
        CheckCursor;
      end;
    end;
  end;
end;

function TCustomTimeEdit.CreateValidContent(S: String): String;
var
  i: Integer;
begin
  case FTimeEditFormat of
    tefLong:
    begin
      if Length(S) <> LenLong then Raise ETimeEditError.Create(SInternalMaskCorruption);
      for i := 1 to length(S) do
      begin
        if (not (i in [3,6])) and (not (S[i] in Digits)) then S[i] := '0';
      end;
    end;
    tefShort:
    begin
      if Length(S) <> LenShort then Raise ETimeEditError.Create(SInternalMaskCorruption);
      for i := 1 to length(S) do
      begin
        if (i <> 3) and (not (S[i] in Digits)) then S[i] := '0';
      end;
    end;
  end;
  Result := S;
end;



procedure TCustomTimeEdit.ForceValidContent;
//Force the text in the control to match the EditMask, don't care if it is a valid time ATM
var S: String;
begin
  //debugln('ForceValidContent');
  S := CreateValidContent(EditText);
  //debugln('  Resetting EditText to: ',S);
  EditText := S;
end;

procedure TCustomTimeEdit.ForceValidTime;
var
  H, M, Sec: LongInt;
  ET, SH, SM, SS: String;
  T: TDateTime;
begin
  //debugln('ForceValidTime');
  if HasValidTime(T) then
  begin
    //debugln('  Valid Time = ',dbgs(T));
    Exit;
  end;
  //debugln('  Time is not valid');
  ET := EditText;
  H := -1;
  M := -1;
  Sec := -1;
  //force digits in the right places and ensure right length of string
  ET := CreateValidContent(ET);
  //At this time ET can now only contain digits and TimeSeparators's
  if not SplitTime(ET, H, M, Sec) then Raise ETimeEditError.Create(SInternalMaskCorruption);
  if (H < 0) then H := 23;
  if (H > 23) then H := 0;
  if (M < 0) then M := 59;
  if (M > 59) then M := 0;
  if (Sec < 0) then Sec := 59;
  if (Sec > 59) then Sec := 0;
  SH := IntToStr(H);
  SM := IntToStr(M);
  SS := IntToStr(Sec);
  ET := ZeroPad2(SH) + DefaultFormatSettings.TimeSeparator + ZeroPad2(SM);
  if FTimeEditFormat = tefLong then
    ET := ET + DefaultFormatSettings.TimeSeparator + ZeroPad2(SS);
  //debugln('  Resetting EditText to ',ET);
  EditText := ET;
end;



function TCustomTimeEdit.GetTime: TDateTime;
var
  T: TDateTime;
  H,M,Sec: Integer;
begin
  //We cannot rely on StrToTime, because it will accept strings like '0a:0b:0c'
  //and return Time = 0 ...
  //And StrToTime will reject '24:00:00', which I want to allow
  H := -1;
  M := -1;
  Sec := -1;
  if (not SplitTime(EditText, H, M, Sec)) or (H < 0) or (M < 0) or (Sec < 0) then Result := -1
  else
  begin
    if (H = 24) and (M = 0) and (Sec = 0) then T := 1 else
    begin
      if not TryEncodeTime(Word(H), Word(M), Word(Sec), 0, T) then T := -1;
    end;
    Result := T;
  end;
end;

procedure TCustomTimeEdit.SetTime(const ATime: TDateTime);
var
  H, M, Sec, MS: Word;
  ET, SH, SM, SS: String;
begin
  //Do not rely on TimeToStr
  DecodeTime(ATime, H, M, Sec, MS);
  SH := IntToStr(H);
  SM := IntToStr(M);
  SS := IntToStr(Sec);
  ET := ZeroPad2(SH) + DefaultFormatSettings.TimeSeparator + ZeroPad2(SM);
  if FTimeEditFormat = tefLong then
    ET := ET + DefaultFormatSettings.TimeSeparator + ZeroPad2(SS);
  EditText := ET;
end;

function TCustomTimeEdit.HasValidTime(out ATime: TDateTime): Boolean;
begin
  ATime := GetTime;
  //GetTime returns -1 for any invalid time
  Result := Atime > -0.1;
end;

procedure TCustomTimeEdit.SetTimeEditFormat(const ATimeEditFormat: TTimeEditFormat);
var T: TDateTime;
begin
  if (ATimeEditFormat <> FTimeEditFormat) then
  begin
    if not HasValidTime(T) then T := 0;
    FTimeEditFormat := ATimeEditFormat;
    case FTimeEditFormat of
      tefLong: inherited EditMask := LongEditMask;
      tefShort:  inherited EditMask := ShortEditMask;
    end;
    SetTime(T);
  end;
end;



procedure TCustomTimeEdit.TextChanged;
begin
  inherited TextChanged;
  if FForceValidTimeOnChange then ForceValidTime;
end;


procedure TCustomTimeEdit.DoExit;
begin
  //debugln('DoExit');
  //debugln('  ForceValidTimeOnExit   = ',dbgs(FForceValidTimeOnExit));
  //debugln('  ForceValidTimeOnChange = ',dbgs(FForceValidTimeOnChange));
  if FForceValidTimeOnExit and (not FForceValidTimeOnChange) then ForceValidTime;
  try
    ValidateEdit;
  except
    on EDBEditError do ForceValidContent;
  end;
  inherited DoExit;
end;

procedure TCustomTimeEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  //Need to handle this _before_ inherited KeyDown, since it will eat all keys
  if (Key = VK_UP) and (Shift = []) and (not ReadOnly) then
  begin
    Key := 0;
    DoUpDown(True);
  end;
  if (Key = VK_Down) and (Shift = []) and (not ReadOnly) then
  begin
    Key := 0;
    DoUpDown(False);
  end;
  inherited KeyDown(Key, Shift);
end;

procedure TCustomTimeEdit.KeyPress(var Key: Char);
begin
  //Need to handle this _before_ inherited KeyPress, since it will eat all keys
  if (Key = '+') and (not ReadOnly) then
  begin
    Key := #0;
    DoUpDown(True);
  end;
  if (Key = '-') and (not ReadOnly) then
  begin
    Key := #0;
    DoUpDown(False);
  end;
  inherited KeyPress(Key);
end;

constructor TCustomTimeEdit.Create(Aowner: TComponent);
begin
  inherited Create(Aowner);
  //otherwise SetTimeEditFormat does nothing
  FTimeEditFormat := tefShort;
  SetTimeEditFormat(tefLong);
  Time := 0;
  FForceValidTimeOnExit := False;
  FForceValidTimeOnChange := False;
end;


end.

