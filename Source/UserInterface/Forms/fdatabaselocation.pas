unit fdatabaselocation;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  Buttons, StdCtrls, ExtCtrls;

type

  { TFrmDatabaseLocation }

  TFrmDatabaseLocation = class(TForm)
    deSettings: TDirectoryEdit;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    Label1: TLabel;
    rgFiles: TRadioGroup;
    cbRemove: TCheckBox;
    procedure bbOKClick(Sender: TObject);
    procedure deSettingsChange(Sender: TObject);
    procedure cbRemoveClick(Sender: TObject);
  private
    { private declarations }
    FOldDir, FNewDir : string;
  public
    { public declarations }
    Function Execute : boolean;
  end; 

var
  FrmDatabaseLocation: TFrmDatabaseLocation;

implementation

{$R *.lfm}
uses Data, Containers, frmain, Hulpfuncties, subs, neuroot;

procedure TFrmDatabaseLocation.deSettingsChange(Sender: TObject);
var StylesN, FermN, HopN, MiscN, YeastN, WaterN : string;
begin
{  //Check if there are files in the chosen directory
  FNewDir:= deSettings.Directory;
  {$ifdef UNIX}
    FNewDir:= FNewDir + '/';
  {$else}
    FNewDir:= FNewDir + '\';
  {$endif}
  StylesN:= FNewDir + 'styles.xml';
  FermN:= FNewDir + 'fermentables.xml';
  HopN:= FNewDir + 'hops.xml';
  MiscN:= FNewDir + 'miscs.xml';
  YeastN:= FNewDir + 'yeasts.xml';
  WaterN:= FNewDir + 'waters.xml';
  if FileExists(StylesN) and FileExists(FermN) and FileExists(HopN) and
     FileExists(MiscN) and FileExists(YeastN) and FileExists(WaterN) then
  begin
    rgFiles.Enabled:= TRUE;
  end
  else
  begin
    rgFiles.ItemIndex:= 1;
    rgFiles.Enabled:= false;
  end;}
  FNewDir:= deSettings.Directory;
end;

procedure TFrmDatabaseLocation.bbOKClick(Sender: TObject);
begin

end;

procedure TFrmDatabaseLocation.cbRemoveClick(Sender: TObject);
begin
  if cbRemove.Checked then
    cbRemove.Checked:= Question(self, 'Wil je de oude bestanden echt verwijderen?');
end;

Function TFrmDatabaseLocation.Execute : boolean;

  function CheckCopyFile(sd, dd, fn : string) : boolean;
  begin
    Result:= false;
    if FileExists(sd + fn) then
      result:= CopyFile(sd + fn, dd + fn);
  end;

var cpy : boolean;
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  deSettings.Directory:= Settings.DataLocation.Value;
  FOldDir:= Settings.DataLocation.Value;
  Result:= (ShowModal = mrOK);
  if Result then
  begin
    try
      Screen.Cursor:= crHourglass;

      FNewDir:= deSettings.Directory;
      if rgFiles.ItemIndex = 0 then cpy:= false
      else cpy:= TRUE;
      ChangeDatabaseLocation(FOldDir, FNewDir, cpy, cbRemove.Checked);

      Screen.Cursor:= crDefault;
    except
      Result:= false;
      Screen.Cursor:= crDefault;
    end;
  end;
end;

end.

