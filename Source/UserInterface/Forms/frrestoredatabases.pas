unit FrRestoreDatabases;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls;

type

  { TfrmRestoreDatabase }

  TfrmRestoreDatabase = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cgDatabases: TCheckGroup;
    cbAll: TCheckBox;
    procedure cbAllChange(Sender: TObject);
  private

  public
    Function Execute : boolean;
  end;

var
  frmRestoreDatabase: TfrmRestoreDatabase;

implementation

{$R *.lfm}
uses Containers, Data, Hulpfuncties;

procedure TfrmRestoreDatabase.cbAllChange(Sender: TObject);
var i : integer;
begin
  for i:= 0 to cgDatabases.Items.Count - 1 do
    cgDatabases.Checked[i]:= cbAll.Checked;
end;

Function TfrmRestoreDatabase.Execute : boolean;
  function CheckCopyFile(sd, dd, fn : string) : boolean;
  begin
    Result:= false;
    if FileExists(sd + fn) then
      result:= CopyFile(sd + fn, dd + fn);
  end;
var sourcedata, destdata : string;
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  Result:= (showmodal = mrOK);
  if Result then
    if Question(self, 'Weet je zeker dat je de databanken wilt overschrijven?') then
    begin
      Screen.Cursor:= crHourglass;
      Backup;
      {$ifdef UNIX}
      sourcedata:= '/usr/share/brewbuddy/';
      {$endif}
      {$ifdef Windows}
      sourcedata:= ExtractFilePath(Application.ExeName) + 'brewbuddy\';
      {$endif}
      destdata:= Settings.DataLocation.Value;
      if cgDatabases.Checked[0] then
        if CheckCopyFile(sourcedata, destdata, 'fermentables.xml') then
          Fermentables.ReadXML;
      if cgDatabases.Checked[1] then
        if CheckCopyFile(sourcedata, destdata, 'hops.xml') then
          Hops.ReadXML;
      if cgDatabases.Checked[2] then
        if CheckCopyFile(sourcedata, destdata, 'yeasts.xml') then
          Yeasts.ReadXML;
      if cgDatabases.Checked[3] then
        if CheckCopyFile(sourcedata, destdata, 'miscs.xml') then
          Miscs.ReadXML;
      if cgDatabases.Checked[4] then
        if CheckCopyFile(sourcedata, destdata, 'mashs.xml') then
          Mashs.ReadXML;
      if cgDatabases.Checked[5] then
        if CheckCopyFile(sourcedata, destdata, 'waters.xml') then
          Waters.ReadXML;
      if cgDatabases.Checked[6] then
        if CheckCopyFile(sourcedata, destdata, 'styles.xml') then
          Beerstyles.ReadXML;
      if cgDatabases.Checked[7] then
        if CheckCopyFile(sourcedata, destdata, 'equipments.xml') then
          Equipments.ReadXML;
      if cgDatabases.Checked[8] then
        if CheckCopyFile(sourcedata, destdata, 'recipes.xml') then
          Recipes.ReadXML;
      Screen.Cursor:= crDefault;
    end;
end;

end.

