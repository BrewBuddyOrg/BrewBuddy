program BrewBuddy_JR;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, pexpandpanels, uniqueinstance_package, tachartlazaruspkg,
  printer4lazarus, lazcontrols, FrMain, FrFermentables, Containers, Data,
  Hulpfuncties, rcstrngs;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='BrewBuddy';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

