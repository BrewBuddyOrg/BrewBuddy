unit FrRecipeToBrew;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, EditBtn, Data;

type

  { TfrmRecipeToBrew }

  TfrmRecipeToBrew = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    lVolume: TLabel;
    Label3: TLabel;
    eNrRecipe: TEdit;
    cbEquipment: TComboBox;
    fseVolume: TFloatSpinEdit;
    bbOK: TBitBtn;
    BitBtn1: TBitBtn;
    Label4: TLabel;
    lLastNrRecipe: TLabel;
    Label5: TLabel;
    deBrewDate: TDateEdit;
    procedure FormCreate(Sender: TObject);
    procedure cbEquipmentChange(Sender: TObject);
    procedure fseVolumeChange(Sender: TObject);
    procedure eNrRecipeChange(Sender: TObject);
    procedure deBrewDateChange(Sender: TObject);
  private
    FEquipment : TEquipment;
    FNrRecipe : string;
    FVolume : double;
    FBrewDate : TDate;
  public
    Function Execute(R : TRecipe) : boolean;
  end; 

var
  frmRecipeToBrew: TfrmRecipeToBrew;

implementation

{$R *.lfm}
uses Containers, HulpFuncties;

{ TfrmRecipeToBrew }

procedure TfrmRecipeToBrew.FormCreate(Sender: TObject);
var i : integer;
begin
  FEquipment:= NIL;
  FNrRecipe:= '';
  FVolume:= 0;
  for i:= 0 to Equipments.NumItems - 1 do
    cbEquipment.AddItem(Equipments.Item[i].Name.Value, Equipments.Item[i]);
  cbEquipment.ItemIndex:= 0;
  FEquipment:= TEquipment(cbEquipment.Items.Objects[0]);
  FVolume:= FEquipment.BatchSize.DisplayValue;
  fseVolume.Value:= FVolume;
  lVolume.Caption:= FEquipment.BatchSize.DisplayUnitString;
  lLastNrRecipe.Caption:= 'Laatste kenmerk: ' + Brews.LastNrRecipe;
  FBrewDate:= Now;
  deBrewDate.Date:= FBrewDate;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TfrmRecipeToBrew.cbEquipmentChange(Sender: TObject);
begin
  FEquipment:= TEquipment(cbEquipment.Items.Objects[cbEquipment.ItemIndex]);
  FVolume:= FEquipment.BatchSize.DisplayValue;
  fseVolume.Value:= FVolume;
end;

procedure TfrmRecipeToBrew.fseVolumeChange(Sender: TObject);
begin
  FVolume:= fseVolume.Value;
end;

procedure TfrmRecipeToBrew.eNrRecipeChange(Sender: TObject);
begin
  FNrRecipe:= eNrRecipe.Caption;
end;

procedure TfrmRecipeToBrew.deBrewDateChange(Sender: TObject);
begin
  FBrewDate:= deBrewDate.Date;
end;

function TfrmRecipeToBrew.Execute(R: TRecipe): boolean;
begin
  if R <> NIL then
  begin
    Result:= (ShowModal = mrOK);
    if Result then
    begin
      R.Equipment.Assign(FEquipment);
      R.NrRecipe.Value:= FNrRecipe;
      FVolume:= Convert(FEquipment.BatchSize.vUnit, liter, FVolume);
      R.Scale(FVolume);
      R.Date.Value:= FBrewDate;
    end;
  end;
end;

end.

