unit FrQuestion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TFrmQuestion }

  TFrmQuestion = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    lQuestion: TLabel;
    procedure FormCreate(Sender: TObject);
  private

  public
    Function Question(s : string) : boolean;
  end; 

var
  FrmQuestion: TFrmQuestion;

implementation

{$R *.lfm}

uses Data, Hulpfuncties;

Function TFrmQuestion.Question(s : string) : boolean;
begin
  lQuestion.Caption:= s;
  Result:= (ShowModal = mrYes);
end;

procedure TFrmQuestion.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;
end.

