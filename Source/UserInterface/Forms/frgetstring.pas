unit FrGetString;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons;

type

  { TFrmGetString }

  TFrmGetString = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    leAnswer: TLabeledEdit;
    procedure FormCreate(Sender: TObject);
  private

  public
    Function GetAnswer(Q : string) : string;
  end; 

var
  FrmGetString: TFrmGetString;

implementation

{$R *.lfm}

uses Data, HulpFuncties;

procedure TFrmGetString.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

Function TFrmGetString.GetAnswer(Q : string) : string;
begin
  Result:= '';
  leAnswer.EditLabel.Caption:= Q;
  If ShowModal = mrOK then
    Result:= leAnswer.Text;
end;

end.

