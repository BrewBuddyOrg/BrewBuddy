unit FrImport;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, EditBtn,
  ExtCtrls, Buttons, StdCtrls, Data;

type

  { TFrmImport }
  TFileType = (ftInvalid, ftXML, ftPromash);
  TDestination = (dRecipes, dBrews);

  TFrmImport = class(TForm)
    bbFile: TBitBtn;
    bbCancel: TBitBtn;
    odFile: TOpenDialog;
    gbImport: TGroupBox;
    Label1: TLabel;
    cbEquipment: TComboBox;
    Label2: TLabel;
    cbDestination: TComboBox;
    bbOK: TBitBtn;
    procedure bbFileClick(Sender: TObject);
    procedure bbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbEquipmentChange(Sender: TObject);
    procedure cbDestinationChange(Sender: TObject);
    procedure bbOKClick(Sender: TObject);
    procedure odFileTypeChange(Sender: TObject);
  private
    FDirName : string;
    FFileName : string;
    FFileType : TFileType;
    FEquipment : TEquipment;
    FDestination : TDestination;
    FFiles : TStrings;
  public
    Function Execute : boolean;
  published
    property DirName : string read FDirName;
    property FileName : string read FFileName;
    property FileType : TFileType read FFileType;
    property Destination : TDestination read FDestination;
    property Equipment : TEquipment read FEquipment;
    property Files : TStrings read FFiles;
  end; 

var
  FrmImport: TFrmImport;

implementation

{$R *.lfm}
uses Containers, hulpfuncties;

{ TFrmImport }

procedure TFrmImport.FormCreate(Sender: TObject);
var i : integer;
begin
  FFileName:= '';
  FDirName:= '';
  FFileType:= ftXML;
  FDestination:= dRecipes;
  cbEquipment.AddItem('Niet converteren', NIL);
  for i:= 0 to Equipments.NumItems - 1 do
    cbEquipment.AddItem(Equipments.Item[i].Name.Value, Equipments.Item[i]);
  cbEquipment.ItemIndex:= 0;
  cbEquipment.Enabled:= false;
  FEquipment:= NIL;
  FFiles:= NIL;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmImport.cbEquipmentChange(Sender: TObject);
begin
  FEquipment:= TEquipment(cbEquipment.Items.Objects[cbEquipment.ItemIndex]);
end;

procedure TFrmImport.cbDestinationChange(Sender: TObject);
begin
  if cbDestination.ItemIndex <= 0 then
  begin
    FDestination:= dRecipes;
    cbEquipment.Enabled:= false;
  end
  else
  begin
    FDestination:= dBrews;
    cbEquipment.Enabled:= TRUE;
  end;
end;

procedure TFrmImport.bbOKClick(Sender: TObject);
begin
//
end;

procedure TFrmImport.odFileTypeChange(Sender: TObject);
begin
  if odFile.FilterIndex = 1 then
  begin
    FFileType:= ftXML;
    odFile.FileName:= '*.xml';
  end
  else if odFile.FilterIndex = 2 then
  begin
    FFileType:= ftPromash;
    odFile.FileName:= '*.rec';
  end
  else FFileType:= ftInvalid;
end;

procedure TFrmImport.bbFileClick(Sender: TObject);
begin
  if odFile.Execute then
  begin
    FFileName:= odFile.FileName;
    FFiles:= odFile.Files;
    FDirName:= '';
  end
  else
    FFileName:= '';
end;

procedure TFrmImport.bbCancelClick(Sender: TObject);
begin
 //
end;

function TFrmImport.Execute: boolean;
begin
  Result:= (ShowModal = mrOK) and ((FFileName <> '') or ((FFiles <> NIL) and (FFiles.Count > 0)));
end;

end.

