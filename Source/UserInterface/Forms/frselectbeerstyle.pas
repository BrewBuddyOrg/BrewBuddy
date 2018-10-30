unit frselectbeerstyle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Data;

type

  { TFrmSelectBeerStyle }

  TFrmSelectBeerStyle = class(TForm)
    cbStyles: TComboBox;
    lMessage: TLabel;
    bbOK: TBitBtn;
    BitBtn1: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure cbStylesChange(Sender: TObject);
  private
    { private declarations }
    FBeerStyle : TBeerStyle;
  public
    { public declarations }
    Function Execute(OldBeerstyle : string) : boolean;
  published
    property BeerStyle : TBeerstyle read FBeerStyle;
  end; 

var
  FrmSelectBeerStyle: TFrmSelectBeerStyle;

implementation

{$R *.lfm}

uses Containers, hulpfuncties;

{ TFrmSelectBeerStyle }

procedure TFrmSelectBeerStyle.FormCreate(Sender: TObject);
var i : integer;
    BS : TBeerStyle;
begin
  for i:= 0 to BeerStyles.NumItems - 1 do
  begin
    BS:= TBeerStyle(BeerStyles.Item[i]);
    cbStyles.AddItem(BS.StyleLetter.Value + ' | ' + BS.Name.Value, BS);
  end;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmSelectBeerStyle.cbStylesChange(Sender: TObject);
begin
  FBeerStyle:= TBeerStyle(cbStyles.Items.Objects[cbStyles.ItemIndex]);
end;

function TFrmSelectBeerStyle.Execute(OldBeerstyle : string): boolean;
begin
 lMessage.Caption:= OldBeerstyle + ' niet bekend. Kies een alternatief.';
 Result:= (ShowModal = mrOK);
end;

end.

