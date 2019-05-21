program BrewBuddy_JR;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg,
  printer4lazarus, FrMain, FrFermentables, Containers, Data,
  Hulpfuncties, rcstrngs, pexpandpanels, uniqueinstance_package;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Title:='BrewBuddy';
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

