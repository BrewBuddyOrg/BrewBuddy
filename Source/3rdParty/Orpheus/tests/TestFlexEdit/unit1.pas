unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ovcdata, o32editf, o32flxed;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    O32FlexEdit1: TO32FlexEdit;
    Label2: TLabel;
    O32FlexEdit2: TO32FlexEdit;
    procedure O32FlexEdit1UserValidation(Sender: TObject;
      var ValidEntry: Boolean);
    procedure O32FlexEdit2UserValidation(Sender: TObject;
      var ValidEntry: Boolean);
    procedure O32FlexEditValidationError(Sender: TObject; ErrorCode: Word;
      ErrorMsg: String);
    procedure O32FlexEditExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFNDEF LCL}
{$R *.dfm}
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TForm1.O32FlexEdit1UserValidation(Sender: TObject;
  var ValidEntry: Boolean);
begin
  if TO32FlexEdit(Sender).Text = '' then
    ValidEntry := True
  else
    ValidEntry := StrToIntDef(TO32FlexEdit(Sender).Text, 0) > 0;
end;

procedure TForm1.O32FlexEdit2UserValidation(Sender: TObject;
  var ValidEntry: Boolean);
begin
  if TO32FlexEdit(Sender).Text = '' then
    ValidEntry := True
  else
    ValidEntry := StrToFloatDef(TO32FlexEdit(Sender).Text, 0) > 0;
end;

procedure TForm1.O32FlexEditValidationError(Sender: TObject;
  ErrorCode: Word; ErrorMsg: String);
begin
  MessageDlg(ErrorMsg + #13#10 + 'Press Ctrl+Z to undo.', mtError, [mbOK], 0);
end;

procedure TForm1.O32FlexEditExit(Sender: TObject);
begin
{$IFNDEF MSWINDOWS}  
   {TO32FlexEdit OnUserValidation doesn't work, so validate here
     so user is notified if error, even though focus will change.}
//  SendMessage(TO32FlexEdit(Sender).Handle, OM_VALIDATE, 0, 0);
// This workaround no longer works with LCL 0.9.28 -- error message dialog
//  just repeats. SendMessage/OM_VALIDATE cancels exit event?
//  PostMessage appears to work okay, though.
  PostMessage(TO32FlexEdit(Sender).Handle, OM_VALIDATE, 0, 0);
{$ENDIF}
end;

end.
