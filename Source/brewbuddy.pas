program brewbuddy;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  {$ifdef UNIX}
  clocale,
  {$endif}
  SysUtils, Interfaces, // this includes the LCL widgetset
  printer4lazarus, tachartprint, Forms, FrMain, Data, subs, Hulpfuncties,
  Containers, FrBeerstyles, FrHop2, frQuestion, frgetstring, FrEquipments,
  FrFermentables2, FrMiscs2, frmashs, FrYeasts2, FrWaters, frmashstep,
  FrFermentables, PositieInterval, FrHop, FrMiscs, FrYeasts, frmiscs3,
  frfermentables3, frhop3, frwateradjustment, FrNotification, TimeEdit,
  frmeasurements, frimport, frselectbeerstyle, frrecipetobrew, BH_report,
  frprintpreview, BHprintforms, frpropagation, frrefractometer, frboilmethod,
  fdatabaselocation, utypes, umulfit, frdividebrew, fryeasts3,
  frchoosebeerstyle, frchoosebrewschars, frsplash, frinfo, vinfo, frsynchronize,
  frchoosebrews, PromashImport, laz_synapse, frrestoredatabases, frsettings,
  cloud, frgetpasswd, frdownloadprogress, pexpandpanels, uniqueinstance_package;//, neuroot;

{$R *.res}

begin
  Application.Title:='BrewBuddy';
  try
    Application.Initialize;
    Application.CreateForm(TfrmMain, frmMain);
    Application.Run;
  except
    {if CloudActive then} FreeAndNIL(BHCloud);
    FreeAndNIL(StyleSubs);
    FreeAndNIL(FermentableSubs);
    FreeAndNIL(YeastSubs);
    FreeAndNIL(Fermentables);
    FreeAndNIL(Hops);
    FreeAndNIL(Miscs);
    FreeAndNIL(Yeasts);
    FreeAndNIL(Waters);
    FreeAndNIL(Equipments);
    FreeAndNIL(Beerstyles);
    FreeAndNIL(Mashs);
    FreeAndNIL(Recipes);
    FreeAndNIL(Brews);
    FreeAndNIL(Settings);
  end;
end.

