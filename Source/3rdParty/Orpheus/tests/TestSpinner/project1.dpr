program Project1;

uses
{$IFDEF LCL}
  Interfaces,
{$ENDIF}
  Forms,
  Unit1 in 'unit1.pas' {Form1};

{$IFDEF MSWINDOWS}
{$R *.res}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
