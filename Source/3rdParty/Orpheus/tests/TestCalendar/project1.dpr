program Project1;

uses
{$IFDEF LCL}
  Interfaces,
 {$IFDEF UNIX}
  clocale,
 {$ENDIF}
{$ENDIF}
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$IFDEF MSWINDOWS}
{$R *.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
