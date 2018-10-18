program Project1;

uses
{$IFDEF LCL}
  Interfaces,
{$ENDIF}
  Forms,
  Unit1 in 'Unit1.pas' {Form1};

{$IFDEF MSWINDOWS}
{$R *.res}  {Include program's icon resource file}
{$ENDIF}

{$IFNDEF FPC}  //With FPC, assume .exe can find .manifest file at runtime
{$R manifest.res}  {Include program's manifest in .exe for XP theme support}
{$ENDIF}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
