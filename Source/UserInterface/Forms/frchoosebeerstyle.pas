unit FrChooseBeerStyle;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, Data;

type

  { TFrmChooseBeerstyle }

  TFrmChooseBeerstyle = class(TForm)
    cbStyles: TComboBox;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
  private

  public
    Function Execute : TBeerStyle;
  end; 

var
  FrmChooseBeerstyle: TFrmChooseBeerstyle;

implementation

{$R *.lfm}
uses Containers, hulpfuncties;

Function TFrmChooseBeerstyle.Execute : TBeerStyle;
var i : integer;
    BS : TBeerStyle;
begin
  Result:= NIL;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
  for i:= 0 to Beerstyles.NumItems - 1 do
  begin
    BS:= TBeerstyle(Beerstyles.Item[i]);
    cbStyles.Items.AddObject(BS.StyleLetter.Value + ' ' + BS.Name.Value, BS);
  end;
  if ShowModal = mrOK then
  begin
    Result:= TBeerstyle(cbStyles.Items.Objects[cbStyles.ItemIndex]);
  end;
end;

end.

