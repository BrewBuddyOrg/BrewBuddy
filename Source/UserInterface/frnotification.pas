unit FrNotification; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Math;

type

  { TFrmNotification }

  TFrmNotification = class(TForm)
    BitBtn1: TBitBtn;
    Image1: TImage;
    Label1: TLabel;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Procedure ShowFrm(s : string);
    Procedure SetText(s : string);
    Procedure AddText(s : string);
    Procedure AdjustSz;
    Function Execute(s : string) : boolean;
  end; 

var
  FrmNotification: TFrmNotification;

implementation

{$R *.lfm}

uses Data, HulpFuncties;

procedure TFrmNotification.BitBtn1Click(Sender: TObject);
begin
  Close;
  FreeAndNIL(self);
end;

procedure TFrmNotification.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmNotification.FormDestroy(Sender: TObject);
begin
  //
end;

procedure TFrmNotification.FormHide(Sender: TObject);
begin
  //
end;

Procedure TFrmNotification.ShowFrm(s : string);
begin
  Label1.Caption:= s;
  AdjustSz;
  Show;//Modal;
end;

Function TFrmNotification.Execute(s : string) :  boolean;
begin
  Label1.Caption:= s;
  AdjustSz;
  Result:= (ShowModal = mrNone);
end;

Procedure TFrmNotification.SetText(s : string);
begin
  Label1.Caption:= s;
  AdjustSz;
end;

Procedure TFrmNotification.AddText(s : string);
begin
  Label1.Caption:= Label1.Caption + #10#13 + s;
  AdjustSz;
end;

Procedure TFrmNotification.AdjustSz;
begin
  Label1.AdjustSize;
  Application.ProcessMessages;
  Width:= Max(340, Max(Label1.Left + Label1.Width + 5, Image1.Left + Image1.Width + BitBtn1.Width + 5));
  Application.ProcessMessages;
  BitBtn1.Top:= Label1.Top + Label1.Height + 5;
  Application.ProcessMessages;
  Height:= BitBtn1.Top + BitBtn1.Height + 5;
  Application.ProcessMessages;
  BitBtn1.Left:= Round((Width - BitBtn1.Width) / 2);
  Application.ProcessMessages;
end;

end.

