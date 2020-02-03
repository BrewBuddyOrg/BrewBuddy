unit FrDownloadProgress;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, synsock;

type

  { TFrmDownloadProgress }

  TFrmDownloadProgress = class(TForm)
    ProgressBar1: TProgressBar;
    procedure FormCreate(Sender: TObject);
  private
    FProgress, FMax : integer;
    procedure SetProgress(l : integer);
    Procedure SetMaxValue(l : integer);
  public
    procedure OnMonitor(Sender: TObject; Writing: Boolean;
                        const Buffer: TMemory; Len: Integer);
  published
    property Progress : integer read FProgress write SetProgress;
    property MaxValue : integer read FMax write SetMaxValue;
  end;

var
  FrmDownloadProgress: TFrmDownloadProgress;

implementation
uses data, hulpfuncties;

{$R *.lfm}

procedure TFrmDownloadProgress.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmDownloadProgress.SetProgress(l: integer);
begin
  FProgress:= l;
  ProgressBar1.Position:= l;
  Application.ProcessMessages;
end;

Procedure TFrmDownloadProgress.SetMaxValue(l : integer);
begin
  FMax:= l;
  ProgressBar1.Max:= l;
  Application.ProcessMessages;
end;

procedure TFrmDownloadProgress.OnMonitor(Sender: TObject; Writing: Boolean;
                    const Buffer: TMemory; Len: Integer);
begin
  if FMax > 0 then
  begin
    Progress:= Len;
    Application.ProcessMessages;
  end;
end;

end.

