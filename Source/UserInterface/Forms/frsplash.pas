unit FrSplash;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFrmSplash }

  TFrmSplash = class(TForm)
    tSplash: TTimer;
    Image1: TImage;
    procedure tSplashStartTimer(Sender: TObject);
    procedure tSplashTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FSecs, FDuration : integer;
  public
    Procedure Execute;
  end; 

var
  FrmSplash: TFrmSplash;

implementation

{$R *.lfm}

procedure TFrmSplash.tSplashStartTimer(Sender: TObject);
begin
  FSecs:= 0;
end;

procedure TFrmSplash.tSplashTimer(Sender: TObject);
begin
  FSecs:= FSecs + 1;
  if FSecs >= FDuration then
  begin
    Visible:= false;
    Free;
  end;
end;

procedure TFrmSplash.FormCreate(Sender: TObject);
begin
  tSplash.Enabled:= false;
end;

procedure TFrmSplash.Execute;
begin
  FSecs:= 0;
  FDuration:= 5;
  Visible:= TRUE;
  tSplash.Enabled:= TRUE;
end;

end.

