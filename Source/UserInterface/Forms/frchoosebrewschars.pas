unit FrChooseBrewsChars;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, EditBtn, Data;

type

  { TFrmChooseBrewChars }

  TFrmChooseBrewChars = class(TForm)
    deBrewDate: TDateEdit;
    Label1: TLabel;
    lNrRecipe: TLabel;
    lLastRecipeNr: TLabel;
    eNrRecipe: TEdit;
    lName: TLabel;
    eName: TEdit;
    lStyle: TLabel;
    cbStyle: TComboBox;
    lEquipment: TLabel;
    cbEquipment: TComboBox;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    procedure FormCreate(Sender: TObject);
  private
    Function GetNrRecipe : string;
    Function GetName : string;
    Function GetBeerStyle : TBeerStyle;
    Procedure SetBeerstyle(BS : TBeerstyle);
    Function GetEquipment : TEquipment;
    Function GetBrewDate : TDateTime;
  public
    Function Execute(brew : boolean) : boolean;
  published
    property NrRecipe : string read GetNrRecipe;
    property Name : string read GetName;
    property Beerstyle : TBeerstyle read GetBeerstyle write SetBeerStyle;
    property Equipment : TEquipment read GetEquipment;
    property BrewDate : TDateTime read GetBrewDate;
  end; 

var
  FrmChooseBrewChars: TFrmChooseBrewChars;

implementation

{$R *.lfm}
uses Containers, hulpfuncties;

procedure TFrmChooseBrewChars.FormCreate(Sender: TObject);
var i : integer;
    BS : TBeerstyle;
    Eq : TEquipment;
begin
  lLastRecipeNr.Caption:= 'Laatste: ' + Brews.LastNrRecipe;
  for i:= 0 to Beerstyles.NumItems - 1 do
  begin
    BS:= TBeerstyle(Beerstyles.Item[i]);
    cbStyle.Items.AddObject(BS.StyleLetter.Value + ' - ' + BS.Name.Value, BS);
  end;
  cbStyle.ItemIndex:= 0;
  for i:= 0 to Equipments.Numitems - 1 do
  begin
    Eq:= TEquipment(Equipments.Item[i]);
    cbEquipment.Items.AddObject(Eq.Name.Value, Eq);
  end;
  cbEquipment.ItemIndex:= 0;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

Function TFrmChooseBrewChars.Execute(brew : boolean) : boolean;
begin
  Result:= false;

  if not brew then
  begin
    lNrRecipe.Visible:= false;
    eNrRecipe.Visible:= false;
    lLastRecipeNr.Visible:= false;
    deBrewDate.Visible:= false;
    Label1.Visible:= false;
  end;

  Result:= (ShowModal = mrOK);
end;

Function TFrmChooseBrewChars.GetNrRecipe : string;
begin
  Result:= eNrRecipe.Text;
end;

Function TFrmChooseBrewChars.GetName : string;
begin
  Result:= eName.Text;
end;

Function TFrmChooseBrewChars.GetBeerStyle : TBeerStyle;
begin
  Result:= TBeerstyle(cbStyle.Items.Objects[cbStyle.ItemIndex]);
end;

Procedure TFrmChooseBrewChars.SetBeerstyle(BS : TBeerstyle);
begin
  cbStyle.ItemIndex:= cbStyle.Items.IndexOfObject(BS);
end;

Function TFrmChooseBrewChars.GetEquipment : TEquipment;
begin
  Result:= TEquipment(cbEquipment.Items.Objects[cbEquipment.ItemIndex]);
end;

Function TFrmChooseBrewChars.GetBrewDate : TDateTime;
begin
  Result:= deBrewDate.Date;
end;

end.

