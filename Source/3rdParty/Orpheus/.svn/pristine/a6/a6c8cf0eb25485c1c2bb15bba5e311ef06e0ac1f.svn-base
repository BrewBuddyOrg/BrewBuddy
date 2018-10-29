unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ovcbase, ovcdata, ovcef, ovcsf;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    OvcSimpleField1: TOvcSimpleField;
    Label2: TLabel;
    OvcSimpleField2: TOvcSimpleField;
    procedure OvcSimpleField1UserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure OvcSimpleFieldError(Sender: TObject; ErrorCode: Word;
      ErrorMsg: String);
    procedure OvcSimpleField2UserValidation(Sender: TObject;
      var ErrorCode: Word);
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


procedure TForm1.OvcSimpleField1UserValidation(Sender: TObject;
  var ErrorCode: Word);
begin
  ErrorCode := 0;
  if (TOvcSimpleField(Sender).Text <> '') and
     (StrToIntDef(TOvcSimpleField(Sender).Text, 0) <= 0) then
    ErrorCode := oeInvalidNumber;
end;

procedure TForm1.OvcSimpleFieldError(Sender: TObject; ErrorCode: Word;
  ErrorMsg: String);
begin
  MessageDlg(ErrorMsg + #13#10 + 'Press Ctrl+Z to undo.', mtError, [mbOK], 0);
end;

procedure TForm1.OvcSimpleField2UserValidation(Sender: TObject;
  var ErrorCode: Word);
begin
  ErrorCode := 0;
  if (TOvcSimpleField(Sender).Text <> '') and
     (StrToFloatDef(TOvcSimpleField(Sender).Text, 0) <= 0) then
    ErrorCode := oeInvalidNumber;
end;


end.
