unit frchoosebrews;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls,
  StdCtrls, EditBtn, Buttons;

type

  { TfrmChooseBrewsList }

  TfrmChooseBrewsList = class(TForm)
    pcChoose: TPageControl;
    tsDate: TTabSheet;
    tsNumber: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    deStart: TDateEdit;
    deEnd: TDateEdit;
    Label3: TLabel;
    Label4: TLabel;
    cbStart: TComboBox;
    cbEnd: TComboBox;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    procedure deStartEditingDone(Sender: TObject);
    procedure deEndEditingDone(Sender: TObject);
    procedure cbStartChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
    Function GetStartDate : TDateTime;
    Function GetEndDate : TDateTime;
    Function GetStartNr : string;
    Function GetEndNR : string;
  public
    { public declarations }
    Function Execute : integer;
  published
    property StartDate : TDateTime read GetStartDate;
    property EndDate : TDateTime read GetEndDate;
    property StartNR : string read GetStartNr;
    property EndNr : string read GetEndNr;
  end; 

var
  frmChooseBrewsList: TfrmChooseBrewsList;

implementation

{$R *.lfm}
uses Containers, Data, hulpfuncties;

{ TfrmChooseBrewsList }

procedure TfrmChooseBrewsList.FormCreate(Sender: TObject);
var i : integer;
    Nr : string;
    D, DS, DE : TDateTime;
    Rec : TRecipe;
begin
  for i:= 0 to Brews.NumItems - 1 do
  begin
    Rec:= TRecipe(Brews.Item[i]);
    Nr:= Rec.NrRecipe.Value;
    D:= Rec.Date.Value;
    if i = 0 then
    begin
      DS:= D;
      DE:= D;
    end;
    if (D < DS) and (D > 0) then DS:= D;
    if D > DE then DE:= D;
    cbStart.Items.Add(Nr);
    cbEnd.Items.Add(Nr);
  end;
  deStart.Date:= DS;
  deEnd.Date:= DE;
  cbStart.ItemIndex:= 0;
  cbEnd.ItemIndex:= Brews.NumItems - 1;
  pcChoose.ActivePage:= tsDate;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

Function TfrmChooseBrewsList.Execute : integer;
begin
  Result:= -1;
  if ShowModal = mrOK then
  begin
    if pcChoose.ActivePage = tsDate then Result:= 0
    else if pcChoose.ActivePage = tsNumber then Result:= 1;
  end;
end;

procedure TfrmChooseBrewsList.deStartEditingDone(Sender: TObject);
begin
  if deStart.Date > deEnd.Date then
    deEnd.Date:= deStart.Date;
end;

procedure TfrmChooseBrewsList.deEndEditingDone(Sender: TObject);
begin
  deStartEditingDone(sender);
end;

procedure TfrmChooseBrewsList.cbStartChange(Sender: TObject);
begin
  if cbStart.ItemIndex > cbEnd.ItemIndex then
    cbEnd.ItemIndex:= cbStart.ItemIndex;
end;

Function TfrmChooseBrewsList.GetStartDate : TDateTime;
begin
  if pcChoose.ActivePage = tsDate then Result:= deStart.Date
  else Result:= 0;
end;

Function TfrmChooseBrewsList.GetEndDate : TDateTime;
begin
  if pcChoose.ActivePage = tsDate then Result:= deEnd.Date
  else Result:= 0;
end;

Function TfrmChooseBrewsList.GetStartNr : string;
begin
  if pcChoose.ActivePage = tsNumber then Result:= cbStart.Items[cbStart.ItemIndex]
  else Result:= '';
end;

Function TfrmChooseBrewsList.GetEndNR : string;
begin
  if pcChoose.ActivePage = tsNumber then Result:= cbEnd.Items[cbEnd.ItemIndex]
  else Result:= '';
end;

end.

