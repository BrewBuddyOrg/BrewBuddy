unit FrSynchronize;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Grids, Buttons, ComCtrls, ftpsend, synsock, blcksock;

type

  { TfrmFTPList }

  TfrmFTPList = class(TForm)
    sgFiles: TStringGrid;
    lMessage: TLabel;
    bbTransfer: TBitBtn;
    bbClose: TBitBtn;
    PageControl1: TPageControl;
    tsFTP: TTabSheet;
    Label1: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    eFTPSite: TEdit;
    eDirectory: TEdit;
    eUserName: TEdit;
    ePassword: TEdit;
    bbRetrieve: TBitBtn;
    tsLocal: TTabSheet;
    Label6: TLabel;
    sddBackupDir: TSelectDirectoryDialog;
    lLocation: TLabel;
    bbChooseLocation: TBitBtn;
    bbRetrieveLoc: TBitBtn;
    procedure bbRetrieveClick(Sender: TObject);
    procedure sgFilesSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure bbTransferClick(Sender: TObject);
    procedure eFTPSiteChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure bbCloseClick(Sender: TObject);
    procedure OnHeartBeat(Sender:TObject);
    procedure OnMonitor(Sender: TObject; Writing: Boolean;
      const Buffer: TMemory; Len: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure sgFilesDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure eFTPSiteExit(Sender: TObject);
    procedure eDirectoryExit(Sender: TObject);
    procedure bbChooseLocationClick(Sender: TObject);
    procedure eUserNameExit(Sender: TObject);
    procedure ePasswordExit(Sender: TObject);
    procedure bbRetrieveLocClick(Sender: TObject);
    procedure PageControl1PageChanged(Sender: TObject);
  private
    Function GetFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
    Function SendFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
    Function GetAndSendFilesFTP(Host, User, Password : string) : boolean;
    Function GetAndSendFilesLocal : boolean;
    Procedure FillStringGrid;
    Procedure Reset;
  public

  end;

  TBHFileRec = record
    Name : string;
    DateTimeLocal, DateTimeRemote : TDateTime;
  end;

const
  cpUp = '-->';
  cpDown = '<--';
  cpNone = '-';

var
  frmFTPList: TfrmFTPList;

implementation

{$R *.lfm}
uses Hulpfuncties, data, dos;

{ TfrmFTPList }

var FLRArray : array of TBHFileRec;

procedure TfrmFTPList.FormCreate(Sender: TObject);
var i : integer;
    SL : TStringList;
begin
  PageControl1.ActivePage:= tsFTP;

  eFTPSiteChange(self);
  SL:= FindAllFiles(Settings.DataLocation.Value, '*.nn', false);
  i:= SL.Count;

  SetLength(FLRArray, 14 + i);
  FLRArray[0].Name:= 'settings.xml';
  FLRArray[1].Name:= 'brews.xml';
  FLRArray[2].Name:= 'recipes.xml';
  FLRArray[3].Name:= 'fermentables.xml';
  FLRArray[4].Name:= 'hops.xml';
  FLRArray[5].Name:= 'miscs.xml';
  FLRArray[6].Name:= 'yeasts.xml';
  FLRArray[7].Name:= 'waters.xml';
  FLRArray[8].Name:= 'mashs.xml';
  FLRArray[9].Name:= 'styles.xml';
  FLRArray[10].Name:= 'equipments.xml';
  FLRArray[11].Name:= 'logo.png';
  FLRArray[12].Name:= 'cloud.xml';
  FLRArray[13].Name:= 'neuralnetworks.xml';
  for i:= 0 to SL.Count-1 do
    FLRArray[14+i].Name:= ExtractFileName(SL.Strings[i]);

  FreeAndNIL(SL);

  eFTPSite.Text:= Settings.FTPSite.Value;
  eDirectory.Text:= Settings.FTPDir.Value;
  eUserName.Text:= Settings.FTPUser.Value;
  ePassWord.Text:= Settings.FTPPasswd.Value;
  lLocation.Caption:= Settings.RemoteLoc.Value;

  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);

  Reset;
end;

procedure TfrmFTPList.FormDestroy(Sender: TObject);
begin
  SetLength(FLRArray, 0);
end;

procedure TfrmFTPList.bbCloseClick(Sender: TObject);
begin
  Close;
end;

Procedure TfrmFTPList.Reset;
var i : integer;
    sr : SearchRec;
    D : TDateTime;
    s : string;
begin
  sgFiles.Clear;
  sgFiles.RowCount:= High(FLRArray) + 2;
  for i:= 0 to High(FLRArray) do
  begin
    FLRArray[i].DateTimeLocal:= 0;
    FLRArray[i].DateTimeRemote:= 0;

    s:= Settings.DataLocation.Value + FLRArray[i].Name;
    FindFirst(s, 0, sr);
    if Doserror = 0 then
    begin
      D:= FiledateToDateTime(FileAge(s));
//      D:= FiledateToDateTime(sr.time);
      FLRArray[i].DateTimeLocal:= D;
    end;
    FindClose(sr);
  end;
  bbTransfer.Enabled:= false;
end;

procedure TfrmFTPList.OnHeartBeat(Sender: TObject);
begin
  application.ProcessMessages;
end;

procedure TfrmFTPList.OnMonitor(Sender: TObject; Writing: Boolean;
  const Buffer: TMemory; Len: Integer);
begin
//  progressbar1.Position:=progressbar1.Position+Len;
end;

Function TfrmFTPList.GetFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
var ftp: TFTPSend;
begin
  try
    Result:= false;
    ftp := TFTPSend.Create;
    try
      ftp.DSock.HeartbeatRate:=150; //lets make our GUI still feel responsive
      ftp.Sock.HeartbeatRate:=150;
      ftp.DSock.OnMonitor:=@OnMonitor;
      ftp.Sock.OnHeartbeat:=@OnHeartBeat;
      ftp.DSock.OnHeartbeat:=@OnHeartBeat;
      //now our props
      ftp.TargetHost := Host;
      ftp.BinaryMode := true;
      ftp.UserName := User;
      ftp.Password := Password;
      ftp.DirectFileName := TargetFileName;
      ftp.DirectFile := true;
      if not ftp.Login then
        raise Exception.Create('Inloggen mislukt');
//      progressbar1.Max:= ftp.FileSize(FileName);
      if not ftp.RetrieveFile(SourceFileName, false) then
        raise Exception.Create('Bestand niet gedownload');
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally

  end;
end;

Function TfrmFTPList.SendFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
var ftp: TFTPSend;
begin
  try
    Result:= false;
    ftp := TFTPSend.Create;
    try
      ftp.DSock.HeartbeatRate:=150; //lets make our GUI still feel responsive
      ftp.Sock.HeartbeatRate:=150;
      ftp.DSock.OnMonitor:=@OnMonitor;
      ftp.Sock.OnHeartbeat:=@OnHeartBeat;
      ftp.DSock.OnHeartbeat:=@OnHeartBeat;
      //now our props
      ftp.TargetHost := Host;
      ftp.BinaryMode := true;
      ftp.UserName := User;
      ftp.Password := Password;
      ftp.DirectFileName := SourceFileName;
      ftp.DirectFile := true;
      if not ftp.Login then
        raise Exception.Create('Inloggen mislukt');
//      progressbar1.Max:= ftp.FileSize(FileName);
      if not ftp.StoreFile(TargetFileName, false) then
        raise Exception.Create('Bestand niet gedownload');
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally

  end;
end;

Function TfrmFTPList.GetAndSendFilesFTP(Host, User, Password : string) : boolean;
var ftp: TFTPSend;
    i : integer;
    target, source : string;
begin
  try
    Result:= false;
    ftp := TFTPSend.Create;
    try
      ftp.DSock.HeartbeatRate:= 150; //lets make our GUI still feel responsive
      ftp.Sock.HeartbeatRate:= 150;
      ftp.DSock.OnMonitor:=@OnMonitor;
      ftp.Sock.OnHeartbeat:=@OnHeartBeat;
      ftp.DSock.OnHeartbeat:=@OnHeartBeat;
      //now our props
      ftp.TargetHost := Host;
      ftp.BinaryMode := true;
      ftp.UserName := User;
      ftp.Password := Password;
      if not ftp.Login then
        raise Exception.Create('Inloggen mislukt');
      for i:= 0 to High(FLRArray) do
      begin
        if sgFiles.Cells[2, i+1] = cpDown then
        begin
          target:= Settings.DataLocation.Value + sgFiles.Cells[0, i+1];
          source:= eDirectory.Text;
          if RightStr(source, 1) <> '/' then source:= source + '/';
          source:= source + sgFiles.Cells[0, i+1];

          lMessage.Caption:= 'Downloaden van ' + sgFiles.Cells[0, i+1];
          Application.ProcessMessages;
          ftp.DirectFileName := target;
          ftp.DirectFile := true;
          if ftp.RetrieveFile(source, false) then
            lMessage.Caption:= 'Downloaden van ' + sgFiles.Cells[0, i+1] + ' geslaagd'
          else
            lMessage.Caption:= 'Downloaden van ' + sgFiles.Cells[0, i+1] + ' mislukt';
        end
        else if sgFiles.Cells[2, i+1] = cpUp then
        begin
          source:= Settings.DataLocation.Value + sgFiles.Cells[0, i+1];
          target:= eDirectory.Text;
          if RightStr(target, 1) <> '/' then target:= target + '/';
          target:= target + sgFiles.Cells[0, i+1];

          lMessage.Caption:= 'Uploaden van ' + sgFiles.Cells[0, i+1];
          Application.ProcessMessages;
          ftp.DirectFileName := source;
          ftp.DirectFile := true;
          if ftp.StoreFile(target, false) then
            lMessage.Caption:= 'Uploaden van ' + sgFiles.Cells[0, i+1] + ' geslaagd'
          else
            lMessage.Caption:= 'Uploaden van ' + sgFiles.Cells[0, i+1] + ' mislukt';
        end;
      end;
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally
    Reset;
    bbRetrieveClick(self);
  end;
end;

procedure TfrmFTPList.bbRetrieveClick(Sender: TObject);
var ftp: TFTPSend;
    i, j : integer;
begin
  if (eFTPSite.Text <> '') and (eUserName.Text <> '') and (ePassword.Text <> '') then
  begin
    Reset;
    try
      ftp := TFTPSend.Create;
      try
        ftp.DSock.HeartbeatRate:= 150; //lets make our GUI still feel responsive
        ftp.Sock.HeartbeatRate:= 150;
        //now our props
        ftp.TargetHost := eFTPSite.Text;
        ftp.BinaryMode := true;
        ftp.UserName := eUserName.Text;
        ftp.Password := ePassword.Text;

        lMessage.Caption:= 'Inloggen...';
        if not ftp.Login then
          raise Exception.Create('Inloggen mislukt')
        else
        begin
          lMessage.Caption:= 'Ingelogd, bestandenlijst ophalen.';
          ftp.CreateDir(eDirectory.Text);
          if not ftp.List(eDirectory.Text, false) then
          begin
            if Question(self, 'Map bestaat niet. Aanmaken?') then
            begin
              if (not ftp.CreateDir(eDirectory.Text))  then
              begin
                FillStringGrid;
                exit;
              end
              else
              begin
                if (not ftp.List(eDirectory.Text, false)) then
                begin
                  FillStringGrid;
                  exit;
                end;
              end;
            end
            else
            begin
              FillStringGrid;
              exit;
            end;
          end;
          //get remote files
          for j:= 0 to High(FLRArray) do
            for i:= 0 to ftp.FTPList.Count - 1 do
              if FLRArray[j].Name = ftp.FtpList[i].FileName then
                FLRArray[j].DateTimeRemote:= ftp.FtpList[i].FileTime;
          lMessage.Caption:= 'Bestandenlijst opgehaald.';
          ftp.Logout;
          bbTransfer.Enabled:= TRUE;
        end;
        FillStringGrid;
      finally
        ftp.free;
      end;
    finally

    end;
  end;
end;

Procedure TfrmFTPList.FillStringGrid;
var i : integer;
begin
  sgFiles.RowCount:= High(FLRArray) + 2;
  for i:= 0 to High(FLRArray) do
  begin
    sgFiles.Cells[0, i+1]:= FLRArray[i].Name;
    if FLRArray[i].DateTimeLocal > 0 then
      sgFiles.Cells[1, i+1]:= DateTimetoStr(FLRArray[i].DateTimeLocal);
    if FLRArray[i].DateTimeRemote > 0 then
      sgFiles.Cells[3, i+1]:= DateTimetoStr(FLRArray[i].DateTimeRemote);

    if FLRArray[i].DateTimeLocal > FLRArray[i].DateTimeRemote then
      sgFiles.Cells[2, i+1]:= cpUp
    else if FLRArray[i].DateTimeLocal < FLRArray[i].DateTimeRemote then
      sgFiles.Cells[2, i+1]:= cpDown
    else
      sgFiles.Cells[2, i+1]:= cpNone;
  end;
end;

procedure TfrmFTPList.sgFilesDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
//var OldColor : TColor;
begin
 { if (aRow > 0) and ((sgFiles.Cells[3, aRow] <> '') or (sgFiles.Cells[4, aRow] <> '')) and
     ((aCol = 3) and (FLRArray[aRow-1].DateTimeLocal > FLRArray[aRow-1].DateTimeRemote)) or
     ((aCol = 4) and (FLRArray[aRow-1].DateTimeLocal < FLRArray[aRow-1].DateTimeRemote)) then
  begin
    Oldcolor:= sgFiles.Canvas.Brush.Color;
    sgFiles.Canvas.Brush.Color:= RGBtoColor(100, 250, 65);
    sgFiles.canvas.fillrect(arect);
    sgFiles.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, sgFiles.Cells[ACol, ARow]);
    sgFiles.Canvas.Brush.Color:= OldColor;
  end
  else if aRow = 0 then
  begin
    Oldcolor:= sgFiles.Canvas.Brush.Color;
    sgFiles.Canvas.Brush.Color:= clWindow;
    sgFiles.canvas.fillrect(arect);
    sgFiles.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, sgFiles.Cells[ACol, ARow]);
    sgFiles.Canvas.Brush.Color:= OldColor;
  end;}
end;

procedure TfrmFTPList.eFTPSiteExit(Sender: TObject);
const FTPScheme='ftp://'; //URI scheme name for FTP URLs
var s : string;
begin
  s:= eFTPSite.Text;
  // Strip out scheme info:
  if LeftStr(s, length(FTPScheme)) = FTPScheme then
    s:= Copy(s, length(FTPScheme)+1, length(s));
  if RightStr(s, 1) = '/' then
    s:= Copy(s, 0, Length(s) - 1);
  eFTPSite.Text:= s;
  Settings.FTPSite.Value:= s;
end;

procedure TfrmFTPList.eDirectoryExit(Sender: TObject);
var s : string;
begin
  s:= eDirectory.Text;
  if LeftStr(s, 1) <> '/' then s:= '/' + s;
  if RightStr(s, 1) <> '/' then s:= s + '/';
  eDirectory.Text:= s;
  Settings.FTPDir.Value:= s;
end;

procedure TfrmFTPList.eUserNameExit(Sender: TObject);
begin
  Settings.FTPUser.Value:= eUserName.Text;
end;

procedure TfrmFTPList.ePasswordExit(Sender: TObject);
begin
  Settings.FTPPasswd.Value:= ePassword.Text;
end;

procedure TfrmFTPList.sgFilesSelectCell(Sender: TObject; aCol, aRow: Integer;
  var CanSelect: Boolean);
begin
  if (sgFiles.RowCount > 1) and (aCol = 2) then
  begin
    if sgFiles.Cells[2, aRow] = cpUp then
      sgFiles.Cells[2, aRow]:= cpDown
    else if sgFiles.Cells[2, aRow] = cpDown then
      sgFiles.Cells[2, aRow]:= cpNone
    else
      sgFiles.Cells[2, aRow]:= cpUp;
  end;
end;

procedure TfrmFTPList.bbTransferClick(Sender: TObject);
var Succes : boolean;
begin
  Succes:= false;
  Screen.Cursor:= crHourglass;
  bbClose.Enabled:= false;
  Application.ProcessMessages;

  if PageControl1.ActivePage = tsFTP then
    Succes:= GetAndSendFilesFTP(eFTPSite.Text, eUserName.Text, ePassword.Text)
  else if PageControl1.ActivePage = tsLocal then
    Succes:= GetAndSendFilesLocal;

  if Succes then lMessage.Caption:= 'Synchroniseren van bestanden geslaagd'
  else lMessage.Caption:= 'Synchroniseren van bestanden mislukt';

  Application.ProcessMessages;

  Screen.Cursor:= crDefault;
  bbClose.Enabled:= TRUE;
end;

procedure TfrmFTPList.eFTPSiteChange(Sender: TObject);
begin
  bbRetrieve.Enabled:= (eFTPSite.Text <> '') and (eUserName.Text <> '')
                       and (ePassword.Text <> '') and (eDirectory.Text <> '');
end;

procedure TfrmFTPList.bbChooseLocationClick(Sender: TObject);
var s : string;
begin
  if sddBackupDir.Execute then
  begin
    Reset;
    s:= sddBackupDir.FileName + Slash;
    lLocation.Caption:= s;
    Settings.RemoteLoc.Value:= lLocation.Caption;
    bbRetrieveLocClick(self);
  end;
end;

procedure TfrmFTPList.bbRetrieveLocClick(Sender: TObject);
var i : integer;
    sr : SearchRec;
    D : TDateTime;
    s : string;
begin
  if (lLocation.Caption <> '') and (DirectoryExists(lLocation.Caption)) then
  begin
    for i:= 0 to High(FLRArray) do
    begin
      FLRArray[i].DateTimeRemote:= 0;

      s:= lLocation.Caption + FLRArray[i].Name;
      FindFirst(s, 0, sr);
      if Doserror = 0 then
      begin
        D:= FiledateToDateTime(FileAge(s));
        FLRArray[i].DateTimeRemote:= D;
      end;
      FindClose(sr);
    end;
    FillStringGrid;
    bbTransfer.Enabled:= TRUE;
  end;
end;

Function TfrmFTPList.GetAndSendFilesLocal : boolean;
var i : integer;
    target, source : string;
begin
  try
    Result:= false;
    for i:= 0 to High(FLRArray) do
    begin
      if sgFiles.Cells[2, i+1] = cpUp then
      begin
        source:= Settings.DataLocation.Value + sgFiles.Cells[0, i+1];
        target:= lLocation.Caption + sgFiles.Cells[0, i+1];
      end
      else if sgFiles.Cells[2, i+1] = cpDown then
      begin
        source:= lLocation.Caption + sgFiles.Cells[0, i+1];
        target:= Settings.DataLocation.Value + sgFiles.Cells[0, i+1];
     end
     else
     begin
       source:= '';
       target:= '';
     end;
     lMessage.Caption:= 'Kopiëren van ' + sgFiles.Cells[0, i+1];
     Application.ProcessMessages;
     if (source <> '') and (target <> '') then
       if CopyFile(source, target, TRUE) then
        lMessage.Caption:= 'Kopiëren van ' + sgFiles.Cells[0, i+1] + ' geslaagd'
      else
        lMessage.Caption:= 'Kopiëren van ' + sgFiles.Cells[0, i+1] + ' mislukt'
    end;
    Result:= TRUE;
  finally
    Reset;
    bbRetrieveLocClick(self);
  end;
end;

procedure TfrmFTPList.PageControl1PageChanged(Sender: TObject);
begin
  bbTransfer.Enabled:= false;
  if PageControl1.ActivePage = tsFTP then
  begin
    Reset;
  end
  else
  begin
    Reset;
    bbRetrieveLocClick(Self);
  end;
end;

end.

