unit Cloud;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, forms, controls, ftpsend, synsock, blcksock, Data,
  DOM, XMLRead, XMLWrite, XMLUtils, hulpfuncties;

type
  TBHCloudFile = class(TObject)
    FFileName, FRecCode, FRecName, FRecStyleLetter, FRecBeerStyle : TBString;
    FDateTimeRemote : TBDateTime;
    FInCloud : Boolean; //is the file (still) in the cloud?
    FShowRecipe : TBBoolean; //show the recipe in the cloud recipe tree
    FFileType : TFileType;
    Constructor Create;
    Destructor Destroy; override;
    Procedure ReadXML(iNode: TDOMNode);
    Procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode);
  private
    procedure SetFileType(ft : TFileType);
  public
  published
    property FileName : TBString read FFileName;
    property RecCode : TBString read FRecCode;
    property RecName : TBString read FRecName;
    property RecBeerStyle : TBString read FRecBeerStyle;
    property RecStyleLetter : TBString read FRecStyleLetter;
    property DateTimeRemote : TBDateTime read FDateTimeRemote;
    property FileType : TFileType read FFileType write SetFileType;
    property InCloud : Boolean read FInCloud write FInCloud;
    property ShowRecipe : TBBoolean read FShowRecipe;
  end;

  TOnCloudReady = procedure(ASender : TObject; NumFiles : longint) of object;
  TOnFileRead = procedure(ASender : TObject; PercDone : single) of object;
  TOnCloudError = procedure(ASender : TObject; Msg : string) of object;

  TBHCloud = class(TObject)
  private
    FRecipe : TRecipe;
    FFiles : array of TBHCloudFile;
    FFTPSite : string;
    FDirectory : string;
    FLogInName : string;
    FPassWord : string;
    FProgress : single;
    FFileName : string;
    FOnCloudReady : TOncloudReady;
    FOnFileRead : TOnFileRead;
    FOnCloudError : TOnCloudError;
    FIsCloudRead, FIsBusy : boolean;
    FSelected : longint;
    Function GetPassword : string;
    Function GetFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
    Function SendFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
    procedure OnHeartBeat(Sender:TObject);
    procedure OnMonitor(Sender: TObject; Writing: Boolean;
                        const Buffer: TMemory; Len: Integer);
    Procedure Reset;
    Function ReadRecipeXML(fn : string) : boolean;
    Function ImportRec(fn : string) : boolean;
    Function FindByName(fn : string): LongInt;
    Function FindByReference(CB : TBHCloudFile): LongInt;
    Function FindBySpecs(RecCode, RecName, RecStyleLetter, RecBeerStyle : string) : LongInt;
    Procedure AddCloudFile(FN, Code, Name, StyleLetter, BeerStyle : string;
                           DTR : TDateTime; ft : TFileType);
    Procedure RemoveLostFiles;
    Procedure RemoveCloudFile(i : longint);
    Procedure RemoveCloudFileByName(s : string);
    Procedure RemoveCloudFileByReference(CB : TBHCloudFile);
    Function GetNumFiles : longint;
    Procedure SetSelected(i : longint);
  protected
    Function GetFileRec(i : longint) : TBHCloudFile;
  public
    Constructor Create; virtual;
    Destructor Destroy; override;
    Function ReadCloud : boolean; //retrieve file info of all files in the cloud
    Procedure SaveXML;
    Procedure ReadXML;
    Procedure Sort;
    Procedure SortByRecName;
    Function LoadRecipeByName(FN : string) : boolean;
    Function LoadRecipeByIndex(i : longint) : boolean;
    Function DetermineFileType(FN : string) : TFileType;
    property FileRec[i : longint] : TBHCloudFile read GetFileRec;
  published
    property Recipe : TRecipe read FRecipe;
    property FTPSite : string read FFTPSite write FFTPSite;
    property Directory : string read FDirectory write FDirectory;
    property LogInName : string read FLogInName write FLogInName;
    property PassWord : string read FPassWord write FPassWord;
    property NumFiles : longint read GetNumFiles;
    property Progress : single read FProgress;
    property IsCloudRead : boolean read FIsCloudRead;
    property IsBusy : boolean read FIsBusy;
    property OnCloudReady : TOnCloudReady read FOnCloudReady write FOnCloudReady;
    property OnFileRead : TOnFileRead read FOnFileRead write FOnFileRead;
    property OnCloudError : TOnCloudError read FOnCloudError write FOnCloudError;
    property Selected : longint read FSelected Write SetSelected;
  end;

  Function CheckNewVersion : boolean;
  Function DownloadNewVersion(fn : string) : boolean;

var BHCloud : TBHCloud;

implementation

uses frmain, math, promashimport, strutils, httpsend, vinfo,
     versiontypes, versionresource, process, fileutil, FrNotification,
     frdownloadprogress{$ifdef windows}, windows, ShellApi{$endif};

Constructor TBHCloudFile.Create;
begin
  INherited Create;
  FFileName:= TBString.Create(NIL);
  FFileName.Value:= '';
  FFileName.NodeLabel:= 'FILE_NAME';

  FRecCode:= TBString.Create(NIL);
  FRecCode.Value:= '';
  FRecCode.NodeLabel:= 'RECIPE_CODE';

  FRecName:= TBString.Create(NIL);
  FRecName.Value:= '';
  FRecName.NodeLabel:= 'RECIPE_NAME';

  FRecStyleLetter:= TBString.Create(NIL);
  FRecStyleLetter.Value:= '';
  FRecStyleLetter.NodeLabel:= 'STYLE_LETTER';

  FRecBeerStyle:= TBString.Create(NIL);
  FRecBeerStyle.Value:= '';
  FRecBeerStyle.NodeLabel:= 'STYLE_NAME';

  FDateTimeRemote:= TBDateTime.Create(NIL);
  FDateTimeRemote.Value:= 0;
  FDateTimeRemote.NodeLabel:= 'FILE_DATETIME';

  FShowRecipe:= TBBoolean.Create(NIL);
  FShowRecipe.Value:= true;
  FShowRecipe.NodeLabel:= 'SHOW_RECIPE';

  FInCloud:= false;

  FFileType:= ftOther;
end;

Destructor TBHCloudFile.Destroy;
begin
  FFileName.Free;
  FRecCode.Free;
  FRecName.Free;
  FRecStyleLetter.Free;
  FRecBeerStyle.Free;
  FDateTimeRemote.Free;
  FShowRecipe.Free;
  Inherited Destroy;
end;

Procedure TBHCloudFile.ReadXML(iNode: TDOMNode);
var ft : TFileType;
    s : string;
begin
  FFileName.ReadXML(iNode);
  FRecCode.ReadXML(iNode);
  FRecName.ReadXML(iNode);
  FRecStyleLetter.ReadXML(iNode);
  FRecBeerStyle.ReadXML(iNode);
  FDateTimeRemote.ReadXML(iNode);
  FShowRecipe.ReadXML(iNode);
  s:= GetNodeString(iNode, 'FILE_TYPE');
  for ft:= Low(FileTypeNames) to High(FileTypeNames) do
    if s =  FileTypeNames[ft] then
      FFileType:= ft;
end;

Procedure TBHCloudFile.SaveXML(Doc: TXMLDocument; iNode: TDOMNode);
var iChild : TDOMNode;
begin
  iChild := Doc.CreateElement('CLOUD_FILE');
  iNode.AppendChild(iChild);

  FFileName.SaveXML(Doc, iChild, false);
  FRecCode.SaveXML(Doc, iChild, false);
  FRecName.SaveXML(Doc, iChild, false);
  FRecStyleLetter.SaveXML(Doc, iChild, false);
  FRecBeerStyle.SaveXML(Doc, iChild, false);
  FDateTimeRemote.SaveXML(Doc, iChild, false);
  FShowRecipe.SaveXML(Doc, iChild, false);
  AddNode(Doc, iChild, 'FILE_TYPE', FileTypeNames[FFileType]);
end;

Procedure TBHCloudFile.SetFileType(FT : TFileType);
begin
  FFileType:= FT;
  if FT = ftOther then FShowRecipe.Value:= false;
end;

{==============================================================================}

Constructor TBHCloud.Create;
begin
  Inherited Create;
  FRecipe:= TRecipe.Create(NIL);
  FFTPSite := 'ftp.hobbybrouwen.nl';
  FDirectory:= '/public_html/forum/attachments';
  FLogInName := 'a2642hob';
//  FPassWord := GetPassWord;//'2wdc5g8';
  FProgress:= 0;
  FFileName:= 'cloud.xml';
  FIsCloudRead:= false;
  FIsBusy:= false;
  FSelected:= -1;
  ReadXML;
end;

Destructor TBHCloud.Destroy;
begin
  Reset;
  FRecipe.Free;
  FRecipe:= NIL;
  Inherited Destroy;
end;

Procedure TBHCloud.Reset;
var i : longint;
begin
  for i:= Low(FFiles) to High(FFiles) do
    FFiles[i].Free;
  SetLength(FFiles, 0);
end;

Procedure TBHCloud.SaveXML;
var FN : string;
    RootNode : TDOMNode;
    Doc : TXMLDocument;
    i : longint;
begin
  try
    Doc := TXMLDocument.Create;
  //  FDoc.Encoding:= 'ISO-8859-1';
    RootNode := Doc.CreateElement('CLOUD_FILES');
    Doc.AppendChild(RootNode);
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FFiles) to High(FFiles) do
      FFiles[i].SaveXML(Doc, RootNode);
     writeXMLFile(Doc, FN);
   finally
    Doc.Free;
  end;
end;

Procedure TBHCloud.ReadXML;
var FN : string;
    i : longint;
    RootNode, Child : TDOMNode;
    Doc : TXMLDocument;
begin
  RootNode:= NIL;
  Doc:= NIL;
  try
    FN:= Settings.DataLocation.Value + FFileName;
    if FileExists(FN) then
    begin
      ReadXMLFile(Doc, FN);
      Reset;
      RootNode:= Doc.FindNode('CLOUD_FILES');
      if RootNode <> NIL then
      begin
        i:= 0;
        Child:= RootNode.FirstChild;
        while Child <> NIL do
        begin
          inc(i);
          SetLength(FFiles, i);
          FFiles[i-1]:= TBHCloudFile.Create;
          FFiles[i-1].ReadXML(Child);
          Child:= Child.NextSibling;
        end;
      end;
    end;
  finally
    if Doc <> NIL then Doc.Free;
  end;
end;

Function TBHCloud.ReadRecipeXML(fn : string) : boolean;
var RootNode, Child : TDOMNode;
    Doc : TXMLDocument;
begin
  Result:= false;
  RootNode:= NIL;
  if FileExists(FN) then
  begin
    try
      ReadXMLFile(Doc, FN);
      RootNode:= Doc.FindNode('RECIPES');
      if RootNode <> NIL then
      begin
        Child:= RootNode.FirstChild;
        while Child <> NIL do
        begin
          FRecipe.ReadXML(Child);
          Result:= TRUE;
          Child:= Child.NextSibling;
        end;
      end;
      Doc.Free;
    Except
      On E: Exception do
      begin
        Doc.Free;
        Result:= false;
      end;
    end;
  end;
end;

Function TBHCloud.ImportRec(fn : string) : boolean;
var PI : TPromash;
begin
  Result:= false;
  PI := TPromash.Create(NIL);
  try
    FN:= ConvertStringEnc(FN);
    if FileExists(FN) then
    begin
      if PI.OpenReadRec(FN) then
      begin
       if FRecipe <> NIL then
       begin
         PI.Convert(FRecipe);
         Result:= TRUE;
       end;
      end;
    end;
  finally
    PI.Free;
  end;
end;

Procedure TBHCloud.Sort;
  procedure QuickSort(var A: array of TBHCloudFile; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : string;
      TB : TBHCloudFile;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].FileName.Value;
    repeat
      Application.ProcessMessages;
      while A[Lo].FileName.Value < v do Inc(Lo);
      Application.ProcessMessages;
      while A[Hi].FileName.Value > v do Dec(Hi);
      Application.ProcessMessages;
      if Lo <= Hi then
      begin
        TB:= A[Lo];
        A[Lo]:= A[Hi];
        A[Hi]:= TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(FFiles) > Low(FFiles) then
    QuickSort(FFiles, Low(FFiles), High(FFiles));
end;

Procedure TBHCloud.SortByRecName;
  procedure QuickSort(var A: array of TBHCloudFile; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : string;
      TB : TBHCloudFile;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].RecName.Value;
    repeat
      Application.ProcessMessages;
      while A[Lo].RecName.Value < v do Inc(Lo);
      Application.ProcessMessages;
      while A[Hi].RecName.Value > v do Dec(Hi);
      Application.ProcessMessages;
      if Lo <= Hi then
      begin
        TB:= A[Lo];
        A[Lo]:= A[Hi];
        A[Hi]:= TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(FFiles) > Low(FFiles) then
    QuickSort(FFiles, Low(FFiles), High(FFiles));
end;

Function TBHCloud.GetFileRec(i : longint) : TBHCloudFile;
begin
  Result:= NIL;
  if (i >= Low(FFiles)) and (i <= High(FFiles)) then
    Result:= FFiles[i];
end;

Procedure TBHCloud.SetSelected(i : longint);
begin
  if (i >= Low(FFiles)) and (i <= High(FFiles)) and (FSelected <> i) then
  begin
    FSelected:= i;
    LoadRecipeByIndex(FSelected);
  end;
end;

Function TBHCloud.FindByName(fn : string): LongInt;
var first: Longint;
    last: Longint;
    middle: Longint;
begin
   first:= Low(FFiles);
   last:= High(FFiles);

   // assume searches failed
   Result:= -1;
   if (FFiles <> NIL) and (High(FFiles) > -1) then
     Repeat
       Application.ProcessMessages;
       middle:= round((first + last) / 2);
       if (FFiles[middle].FileName.Value = fn) then
       begin
         Result:= middle;
         exit;
       end
       else if (FFiles[middle].FileName.Value < fn) then
         first:= middle + 1
       else
         last:= middle - 1;
       Application.ProcessMessages;
     until first > last;
end;

Function TBHCloud.FindByReference(CB : TBHCloudFile): LongInt;
var i, first, last : longint;
begin
   first:= Low(FFiles);
   last:= High(FFiles);
   Result:= -1;
   for i:= first to last do
   begin
     Application.ProcessMessages;
     if FFiles[i] = CB then
     begin
       Result:= i;
       Exit;
     end;
   end;
end;

Function TrLC(s : string) : string;
begin
  Result:= Trim(Lowercase(s));
end;

Function TBHCloud.FindBySpecs(RecCode, RecName, RecStyleLetter, RecBeerStyle : string) : LongInt;
var first: Longint;
    last: Longint;
    middle: Longint;
begin
   first:= Low(FFiles);
   last:= High(FFiles);

   // assume searches failed
   Result:= -1;
   if (FFiles <> NIL) and (High(FFiles) > -1) then
     Repeat
       Application.ProcessMessages;
       middle:= round((first + last) / 2);
       if (TrLC(FFiles[middle].RecName.Value) = TrLC(RecName))
       and (TrLC(FFiles[middle].RecCode.Value) = TrLC(RecCode))
       and (TrLC(FFiles[middle].RecStyleLetter.Value) = TrLC(RecStyleLetter))
       and (TrLC(FFiles[middle].RecBeerStyle.Value) = TrLC(RecBeerStyle)) then
       begin
         Result:= middle;
         exit;
       end
       else if (TrLC(FFiles[middle].RecName.Value) < TrLC(RecName)) then
         first:= middle + 1
       else
         last:= middle - 1;
       Application.ProcessMessages;
     until first > last;
end;

Procedure TBHCloud.AddCloudFile(FN, Code, Name, StyleLetter, BeerStyle : string;
                                DTR : TDateTime; FT : TFileType);
var i : longint;
begin
  i:= High(FFiles) + 1;
  SetLength(FFiles, i + 1);
  FFiles[i]:= TBHCloudFile.Create;
  FFiles[i].FileName.Value:= FN;
  FFiles[i].RecCode.Value:= Code;
  FFiles[i].RecName.Value:= Name;
  FFiles[i].RecStyleLetter.Value:= StyleLetter;
  FFiles[i].RecBeerStyle.Value:= BeerStyle;
  FFiles[i].DateTimeRemote.Value:= DTR;
  FFiles[i].FileType:= FT;
  FFiles[i].InCloud:= TRUE;
end;

Procedure TBHCloud.RemoveLostFiles;
var i : longint;
begin
  for i:= High(FFiles) downto Low(FFiles) do
    if (not FFiles[i].InCloud) then
      RemoveCloudFile(i);
end;

Procedure TBHCloud.RemoveCloudFile(i : longint);
var j : longint;
begin
  if (i >= Low(FFiles)) and (i <= High(FFiles)) then
  begin
    FFiles[i].Free;
    for j:= i to High(FFiles) - 1 do
      FFiles[j]:= FFiles[j+1];
    SetLength(FFiles, High(FFiles));
  end;
end;

Procedure TBHCloud.RemoveCloudFileByName(s : string);
var i : longint;
begin
  i:= FindByName(s);
  if i > -1 then RemoveCloudFile(i);
end;

Procedure TBHCloud.RemoveCloudFileByReference(CB : TBHCloudFile);
var i : longint;
begin
  i:= FindByReference(CB);
  if i > -1 then RemoveCloudFile(i);
end;

Function TBHCloud.GetNumFiles : longint;
begin
  Result:= High(FFiles);
end;

Function TBHCloud.GetPassword : string;
var Lines : TStringList;
    Header : TStringList;
    HTTPGetResult: boolean;
    HTTPSender: THTTPSend;
    RetryAttempt, i: integer;
    URL, s : string;
const key : array[0..6] of integer = (5, 3, 7, 9, 2, 4, 5);
      MaxRetries = 1;
begin
  Url:= 'http://www.hobbybrouwen.nl/brh.txt';
  result:= '';
  RetryAttempt:=1;
  //Optional: mangling of Sourceforge file download URLs; see below.
  //URL:=SourceForgeURL(URL); //Deal with sourceforge URLs
  HTTPSender:= THTTPSend.Create;
  Lines:= TStringList.Create;
  Header := TStringList.Create;
  Header.Add('Accept: text/html');
  HTTPSender.Headers.AddStrings(Header);
  try
    // Try to get the file
    try
      HTTPGetResult:= HTTPSender.HTTPMethod('GET', URL);
      while (HTTPGetResult = false) and (RetryAttempt < MaxRetries) do
      begin
        sleep(500 * RetryAttempt);
        HTTPGetResult:= HTTPSender.HTTPMethod('GET', URL);
        RetryAttempt:= RetryAttempt + 1;
      end;
      // If we have an answer from the server, check if the file
      // was sent to us.
      if HTTPGetResult then
        Lines.loadfromstream(HTTPSender.Document);

      case HTTPSender.Resultcode of
        100..299:
        begin
          for i:= 0 to 6 do
          begin
            s:= Lines[i];
            Result:= Result + s[Key[i]];
          end;
        end;
       { 300..399: ShowNotification(NIL, 'Fout bij ophalen bestand'); //redirection. Not implemented, but could be.
        400..499: ShowNotification(NIL, 'Bestand niet gevonden'); //client error; 404 not found etc
        500..599: ShowNotification(NIL, 'Interne server fout'); //internal server error
        else ShowNotification(NIL, 'Onbekende fout');; //unknown code   }
      end;
    except
      // We don't care for the reason for this error; the download failed.
    end;
  finally
    HTTPSender.Free;
    Lines.Free;
    Header.Free;
  end;

  //check: 2wdc5g8
end;

Function IsXMLFile(FN : string) : boolean;
var l : TStringList;
    i : longint;
    s : string;
begin
  result:= false;
  l:= TStringList.Create;
  try
    l.LoadFromFile(FN);
    for i:= 0 to 9 do
      if i <= l.count - 1 then
      begin
        s:= l.Strings[i];
        if Trim(Lowercase(s)) = '<recipes>' then
          Result:= TRUE;
      end;
  finally
    FreeAndNIL(l);
  end;
end;

Function TBHCloud.DetermineFileType(FN : string) : TFileType;
begin
  Result:= ftOther;
  if IsXMLFile(FN) then Result:= ftXML
  else if IsPromashFile(FN) then Result:= ftPromash;
end;

Function TBHCloud.ReadCloud : boolean; //retrieve file info of all files in the cloud
var ftp: TFTPSend;
    i, j, fnr, n : integer;
    localfn, remotefn, remotefnd, ext, sl, sn, rn : string;
    delfile : PChar;
    filetype : TFileType;
    OK : boolean;
    BHCF, BHCFother : TBHCloudFile;
begin
  Result:= false;
  FPassWord := GetPassWord;//'2wdc5g8';

  if (FFTPSite <> '') and (FLogInName <> '') and (FPassword <> '') then
  begin
    FIsBusy:= TRUE;
    localfn:= Settings.DataLocation.Value + 'tmp';
    try
      Screen.Cursor:= crHourglass;
      ftp := TFTPSend.Create;
      try
        FProgress:= 0;
        if assigned(OnFileRead) then
          OnFileRead(Self, FProgress);
        ftp.DSock.HeartbeatRate:= 150; //lets make our GUI still feel responsive
        ftp.Sock.HeartbeatRate:= 150;
        ftp.DSock.OnMonitor:=@OnMonitor;
        ftp.Sock.OnHeartbeat:=@OnHeartBeat;
        ftp.DSock.OnHeartbeat:=@OnHeartBeat;
        //now our props
        ftp.TargetHost := FFTPSite;
        ftp.BinaryMode := true;
        ftp.UserName := FLogInName;
        ftp.Password := FPassword;

//        lMessage.Caption:= 'Inloggen...';
        if not ftp.Login then
        begin
          Screen.Cursor:= crDefault;
          if Assigned(FOnCloudError) then
            FOnCloudError(self, 'Inloggen mislukt. Controleer de internetverbinding');
        end
        else
        begin
          Screen.Cursor:= crDefault;
          Application.ProcessMessages;
          if ftp.List(FDirectory, false) then
          begin
            Application.ProcessMessages;
            //get remote files
            j:= 0;
            for i:= 0 to ftp.FTPList.Count - 1 do
            begin
              Application.ProcessMessages;
              FProgress:= (i+1) / ftp.FTPList.Count;
              Remotefn:= ftp.FtpList[i].FileName;
              fnr:= FindByName(remotefn);
              if fnr = -1 then
              begin
                ext:= Lowercase(ExtractFileExt(remotefn));
                if (ext = '.xml') or (ext = '.rec') or
                   ((ext = '') and (FTP.FTPList[i].FileSize > 5000)
                                    and (FTP.FTPList[i].FileSize < 36000)) then
                begin
                  inc(j);
                  Application.ProcessMessages;
                  Application.ProcessMessages;
                  //download file if data is not already in local database
                  fnr:= FindByName(remotefn);
                  ftp.DirectFileName := localfn;
                  ftp.DirectFile := true;
                  remotefnd:= FDirectory;
                  if RightStr(remotefnd, 1) <> '/' then remotefnd:= remotefnd + '/';
                  remotefnd:= remotefnd + remotefn;
                  Application.ProcessMessages;
                  if not ftp.RetrieveFile(remotefnd, false) then
                  begin
                    Screen.Cursor:= crDefault;
                    if Assigned(FOnCloudError) then
                      FOnCloudError(self, 'Bestand binnenhalen mislukt. Controleer de internetverbinding');
                  end
                  else
                  begin
                    Application.ProcessMessages;
                    FRecipe.Free;
                    Application.ProcessMessages;
                    FRecipe:= TRecipe.Create(NIL);
                    Application.ProcessMessages;
                    if ext = '' then filetype:= DetermineFileType(localfn)
                    else if ext = '.xml' then filetype:= ftXML
                    else if ext = '.rec' then filetype:= ftPromash;

                    if (filetype = ftXML) and (FileExists(localfn)) then
                    begin
                      OK:= ReadRecipeXML(localfn);
                      filetype:= ftXML;
                    end
                    else if (filetype = ftPromash) and (FileExists(localfn)) then
                    begin
                      OK:= ImportRec(localfn);
                      filetype:= ftPromash;
                    end;

                    if OK then
                    begin
                      Application.ProcessMessages;
                      if FRecipe.Style <> NIL then
                      begin
                        sl:= FRecipe.Style.StyleLetter.Value;
                        sn:= FRecipe.Style.Name.Value;
                      end
                      else
                      begin
                        sl:= 'nb';
                        sn:= 'niet bekend';
                      end;
                      rn:= Trim(FRecipe.Name.Value);
                      if rn = '' then
                      begin
                        rn:= ExtractFileName(remotefn);
                        n:= CountSubssInString(rn, '.');
                        if n > 0 then
                          rn:= Leftstr(rn, NPos('.', rn, n) - 1)
                      end;
                      if (FRecipe <> NIL) and (FRecipe.Style <> NIL) then
                        AddCloudFile(remotefn, FRecipe.NrRecipe.Value, rn,
                                     sl, sn, ftp.FtpList[i].FileTime, filetype);
                      Application.ProcessMessages;
                      Sort;
                      Application.ProcessMessages;
                    end
                    else //invalid XML or REC file.
                    begin
                      AddCloudFile(remotefn, '', '', '', '', 0, ftOther);
                    end;
                    if assigned(OnFileRead) then
                      OnFileRead(Self, FProgress);
                    Application.ProcessMessages;
                  end;
                end
                else //file too small or too large or invalid extension
                begin
  //                AddCloudFile(remotefn, '', '', '', '', 0, ftOther);
  //                Sort;
                  Application.ProcessMessages;
                  if assigned(OnFileRead) then
                    OnFileRead(Self, FProgress);
                  Application.ProcessMessages;
                end;
              end
              else
              begin
                FFiles[fnr].InCloud:= TRUE;
                if (ext = '.xml') then FFiles[fnr].FileType:= ftXML
                else if (ext = '.rec') then FFiles[fnr].FileType:= ftPromash;
              end;
            end;
          end;
          Application.ProcessMessages;
        end;
        Application.ProcessMessages;
        ftp.Logout;
        Application.ProcessMessages;
        if FileExists(localfn) then
        begin
          delfile:= PChar(localfn);
          DeleteFile(delfile);
        end;

        //Remove duplicate recipes from tree by setting ShowRecipe.Value on false
        SortByRecName;
        for i:= Low(FFiles) to High(FFiles) do
        begin
          BHCF:= FFiles[i];
          if BHCF.ShowRecipe.Value then
          begin
            j:= i+1;
            if j <= High(FFiles) then
            begin
              BHCFother:= FFiles[j];
              while (j <= High(FFiles)) and (BHCF.RecName.Value = BHCFother.RecName.Value) do
              begin
                if (TrLC(BHCF.RecCode.Value) = TrLC(BHCFother.RecCode.Value))
                and (TrLC(BHCF.RecStyleLetter.Value) = TrLC(BHCFother.RecStyleLetter.Value))
                and (TrLC(BHCF.RecBeerStyle.Value) = TrLC(BHCFother.RecBeerStyle.Value))
                and (BHCF.DateTimeRemote.Value >= BHCFother.DateTimeRemote.Value) then
                  BHCFother.ShowRecipe.Value:= false;

                inc(j);
                if j <= High(FFiles) then BHCFother:= FFiles[j]
                else BHCFother:= NIL;
              end;
            end;
            j:= i-1;
            if j >= Low(FFiles) then
            begin
              BHCFother:= FFiles[j];
              while (j >= Low(FFiles)) and (BHCF.RecName.Value = BHCFother.RecName.Value) do
              begin
                if (TrLC(BHCF.RecCode.Value) = TrLC(BHCFother.RecCode.Value))
                and (TrLC(BHCF.RecStyleLetter.Value) = TrLC(BHCFother.RecStyleLetter.Value))
                and (TrLC(BHCF.RecBeerStyle.Value) = TrLC(BHCFother.RecBeerStyle.Value))
                and (BHCF.DateTimeRemote.Value >= BHCFother.DateTimeRemote.Value) then
                  BHCFother.ShowRecipe.Value:= false;

                j:= j-1;
                if j >= Low(FFiles) then BHCFother:= FFiles[j]
                else BHCFother:= NIL;
              end;
            end;
          end;
        end;

        Sort;
        SaveXML;
        Result:= TRUE;

        FIsCloudRead:= TRUE;
        if assigned(OnCloudReady) then
          OnCloudReady(Self, GetNumFiles);
      finally
        Application.ProcessMessages;
        ftp.free;
        Application.ProcessMessages;
        RemoveLostFiles;
        Application.ProcessMessages;
      end;
    finally
    end;
  end;
  FIsBusy:= false;
  Screen.Cursor:= crDefault;
end;

Function TBHCloud.LoadRecipeByName(FN : string) : boolean;
var ftp: TFTPSend;
    i : integer;
    localfn, remotefn, remotefnd, ext : string;
    bhr : TBHCloudFile;
begin
  Result:= false;
  FIsBusy:= TRUE;
  if (FFTPSite <> '') and (FLogInName <> '') and (FPassword <> '') then
  begin
    localfn:= Settings.DataLocation.Value + 'tmp';
    try
      ftp := TFTPSend.Create;
      try
        ftp.DSock.HeartbeatRate:= 150; //lets make our GUI still feel responsive
        ftp.Sock.HeartbeatRate:= 150;
        ftp.DSock.OnMonitor:=@OnMonitor;
        ftp.Sock.OnHeartbeat:=@OnHeartBeat;
        ftp.DSock.OnHeartbeat:=@OnHeartBeat;
        //now our props
        ftp.TargetHost := FFTPSite;
        ftp.BinaryMode := true;
        ftp.UserName := FLogInName;
        ftp.Password := FPassword;

        if not ftp.Login then
        begin
          if Assigned(FOnCloudError) then
            FOnCloudError(self, 'Inloggen mislukt. Controleer de internetverbinding');
        end
        else
        begin
          Application.ProcessMessages;
          Remotefn:= FN;
          i:= FindByName(RemoteFN);
          bhr:= FFiles[i];
          ext:= Lowercase(ExtractFileExt(remotefn));
          if (ext = '.xml') or (ext = '.rec') or (bhr.FileType = ftXML) or (bhr.FileType = ftPromash) then
          begin
            Application.ProcessMessages;
            ftp.DirectFileName := localfn;
            ftp.DirectFile := true;
            remotefnd:= FDirectory;
            if RightStr(remotefnd, 1) <> '/' then remotefnd:= remotefnd + '/';
            remotefnd:= remotefnd + remotefn;
            Application.ProcessMessages;
            Screen.Cursor:= crHourglass;
            if not ftp.RetrieveFile(remotefnd, false) then
            begin
              Screen.Cursor:= crDefault;
              if Assigned(FOnCloudError) then
                FOnCloudError(self, 'Bestand dowloaden mislukt. Controleer de internetverbinding');
            end
            else
            begin
              Application.ProcessMessages;
              FRecipe.Free;
              Application.ProcessMessages;
              FRecipe:= TRecipe.Create(NIL);
              Application.ProcessMessages;
              if ((ext = '.xml') or (bhr.FileType = ftXML)) and (FileExists(localfn)) then
                Result:= ReadRecipeXML(localfn)
              else if ((ext = '.rec') or (bhr.FileType = ftPromash)) and (FileExists(localfn)) then
                Result:= ImportRec(localfn);
              Application.ProcessMessages;
            end;
          end;
          Application.ProcessMessages;
          ftp.Logout;
          Application.ProcessMessages;
        end;
      finally
        Application.ProcessMessages;
        ftp.free;
        Application.ProcessMessages;
      end;
    finally
    end;
  end;
  FIsBusy:= false;
  Screen.Cursor:= crDefault;
end;

Function TBHCloud.LoadRecipeByIndex(i : longint) : boolean;
begin
  Result:= True;
  if (i >= Low(FFiles)) and (i <= High(FFiles)) then
    LoadRecipeByName(FFiles[i].FileName.Value);
end;

Function TBHCloud.GetFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
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
      Screen.Cursor:= crHourglass;
      if not ftp.Login then
      begin
        if Assigned(FOnCloudError) then
          FOnCloudError(self, 'Inloggen mislukt. Controleer de internetverbinding');
      end;
//      progressbar1.Max:= ftp.FileSize(FileName);
      if not ftp.RetrieveFile(SourceFileName, false) then
        if Assigned(FOnCloudError) then
          FOnCloudError(self, 'Bestand binnenhalen mislukt. Controleer de internetverbinding');
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

Function TBHCloud.SendFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
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
        if Assigned(FOnCloudError) then
          FOnCloudError(self, 'Inloggen mislukt. Controleer de internetverbinding');
      if not ftp.StoreFile(TargetFileName, false) then
        if Assigned(FOnCloudError) then
          FOnCloudError(self, 'Bestand uploaden mislukt. Controleer de internetverbinding');
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally

  end;
end;

procedure TBHCloud.OnHeartBeat(Sender:TObject);
begin
  application.ProcessMessages;
end;

procedure TBHCloud.OnMonitor(Sender: TObject; Writing: Boolean;
                             const Buffer: TMemory; Len: Integer);
begin
//  progressbar1.Position:= progressbar1.Position+Len;
end;

{==============================================================================}
{$ifdef windows}
function RunAsAdmin(const Handle: Hwnd; const Path, Params: string): Boolean;
var
  sei: TShellExecuteInfoA;
begin
  FillChar(sei, SizeOf(sei), 0);
  sei.cbSize := SizeOf(sei);
  sei.Wnd := Handle;
  sei.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
  sei.lpVerb := 'runas';
  sei.lpFile := PAnsiChar(Path);
  sei.lpParameters := PAnsiChar(Params);
  sei.nShow := SW_SHOWNORMAL;
  Result := ShellExecuteExA(@sei);
end;
{$endif}

{$ifdef Unix}
Function RunAsRoot(cmd, cmd2 : string) : boolean;
var Proc: TProcess;
    CharBuffer: array [0..511] of char;
    RestCount: integer;
    //ExitCode: integer;
    SudoPassword: string;
begin
  Result:= false;
  sudopassword:= GetPasswd(frmMain);
//  ExitCode := -1; //Start out with failure, let's see later if it works
  Proc := TProcess.Create(nil); //Create a new process
  try
    Proc.Options := [poUsePipes]; //Use pipes to redirect program stdin,stdout,stderr
    Proc.CommandLine := 'sudo -S ' + cmd;
    // -S causes sudo to read the password from stdin.
    Proc.Execute; //start it. sudo will now probably ask for a password
     // write the password to stdin of sudo
    SudoPassword := SudoPassword + LineEnding;
    Proc.Input.Write(SudoPassword[1], Length(SudoPassword));
     // main loop to read output from stdout and stderr of sudo
    while Proc.Running or (Proc.Output.NumBytesAvailable > 0) or
     (Proc.Stderr.NumBytesAvailable > 0) do
    begin
      // read stdout and write to our stdout
      while Proc.Output.NumBytesAvailable > 0 do
      begin
        RestCount := Min(512, Proc.Output.NumBytesAvailable); //Read up to buffer, not more
        Proc.Output.Read(CharBuffer, RestCount);
//        Write(StdOut, Copy(CharBuffer, 0, RestCount));
      end;
      // read stderr and write to our stderr
      while Proc.Stderr.NumBytesAvailable > 0 do
      begin
        RestCount := Min(512, Proc.Stderr.NumBytesAvailable); //Read up to buffer, not more
        Proc.Stderr.Read(CharBuffer, RestCount);
//        Write(StdErr, Copy(CharBuffer, 0, RestCount));
      end;
    end;
    if cmd2 <> '' then
    begin
      Proc.CommandLine := 'sudo -S ' + cmd2;
      // -S causes sudo to read the password from stdin.
      Proc.Execute; //start it. sudo will now probably ask for a password
       // write the password to stdin of sudo
//      Proc.Input.Write(SudoPassword[1], Length(SudoPassword));
       // main loop to read output from stdout and stderr of sudo
      while Proc.Running or (Proc.Output.NumBytesAvailable > 0) or
       (Proc.Stderr.NumBytesAvailable > 0) do
      begin
        // read stdout and write to our stdout
        while Proc.Output.NumBytesAvailable > 0 do
        begin
          RestCount := Min(512, Proc.Output.NumBytesAvailable); //Read up to buffer, not more
          Proc.Output.Read(CharBuffer, RestCount);
  //        Write(StdOut, Copy(CharBuffer, 0, RestCount));
        end;
        // read stderr and write to our stderr
        while Proc.Stderr.NumBytesAvailable > 0 do
        begin
          RestCount := Min(512, Proc.Stderr.NumBytesAvailable); //Read up to buffer, not more
          Proc.Stderr.Read(CharBuffer, RestCount);
  //        Write(StdErr, Copy(CharBuffer, 0, RestCount));
        end;
      end;
    end;
    SudoPassword := 'password'; //hope this will scramble memory
    SudoPassword := ''; // and make the program a bit safer from snooping?!?
    //ExitCode := Proc.ExitStatus;
    Result:= true;
  finally
    Proc.Free;
  end;
end;
{$endif}

Function GetFileFTP(Host, SourceFileName, TargetFileName, User, Password : string) : boolean;
var ftp: TFTPSend;
begin
  try
    Result:= false;
    ftp := TFTPSend.Create;
    try
      ftp.DSock.HeartbeatRate:=150; //lets make our GUI still feel responsive
      ftp.Sock.HeartbeatRate:=150;
      //now our props
      ftp.TargetHost := Host;
      ftp.BinaryMode := true;
      ftp.UserName := User;
      ftp.Password := Password;
      ftp.DirectFileName := TargetFileName;
      ftp.DirectFile := true;
      Screen.Cursor:= crHourglass;
      if not ftp.Login then
      begin
      end;
//      progressbar1.Max:= ftp.FileSize(FileName);
      if not ftp.RetrieveFile(SourceFileName, false) then
      ftp.Logout;
      Result:= TRUE;
    finally
      ftp.free;
    end;
  finally
    Screen.Cursor:= crDefault;
  end;
end;

Function DownloadFile(const Url, PathToSaveTo: string) : boolean;
var fs : TFileStream;
    HTTP: THTTPSend;
    TotalBytes, i : integer;
    s : string;
begin
  Result:= false;
  HTTP := THTTPSend.Create;
  frmDownloadProgress:= TFrmDownloadProgress.Create(FrmMain);
  frmDownloadProgress.visible:= TRUE;
  frmDownloadProgress.MaxValue:= 100;
  frmDownloadProgress.Progress:= 0;

  HTTP.Sock.HeartbeatRate:= 100;
  HTTP.Sock.OnMonitor:= @frmDownloadProgress.OnMonitor;

  try
    if http.HTTPMethod('HEAD', Url) then
    begin
      // search for "Content-Length:" in header
      for i:=0 to http.Headers.Count-1 do
      begin
        s:= UpperCase(http.Headers[i]);
        if pos('CONTENT-LENGTH:',s)>0 then
        begin
          TotalBytes := StrToIntDef(copy(s,pos(':',s)+1,length(s)),0);
          frmDownloadProgress.MaxValue:= TotalBytes;
        end;
      end;
      // get the file
      fs := TFileStream.Create(PathToSaveTo, fmOpenWrite or fmCreate);
      http.Headers.Clear;
      if HTTP.HTTPMethod('GET', URL) then
      begin
        fs.Seek(0, soFromBeginning);
        fs.CopyFrom(HTTP.Document, 0);
        Result:= TRUE;
      end;
    end;
  finally
    fs.Free;
    HTTP.Free;
    frmDownloadProgress.Free;
  end;
end;

Function GetHTTPFile(URL, localfn : string) : boolean;
var Lines : TStringList;
    //Header : TStringList;
    HTTPGetResult: boolean;
    HTTPSender: THTTPSend;
    RetryAttempt: integer;
    dir : string;
const MaxRetries = 1;
begin
  result:= false;
  RetryAttempt:=1;
  //Optional: mangling of Sourceforge file download URLs; see below.
  //URL:=SourceForgeURL(URL); //Deal with sourceforge URLs
  HTTPSender:= THTTPSend.Create;
  Lines:= TStringList.Create;
//  Header := TStringList.Create;
//  Header.Add('Accept: text/html');
//  HTTPSender.Headers.AddStrings(Header);
  try
    // Try to get the file
    try
      HTTPGetResult:= HTTPSender.HTTPMethod('GET', URL);
      while (HTTPGetResult = false) and (RetryAttempt < MaxRetries) do
      begin
        sleep(500 * RetryAttempt);
        HTTPGetResult:= HTTPSender.HTTPMethod('GET', URL);
        RetryAttempt:= RetryAttempt + 1;
      end;
      // If we have an answer from the server, check if the file
      // was sent to us.
      if HTTPGetResult then
        Lines.loadfromstream(HTTPSender.Document);

      case HTTPSender.Resultcode of
        100..299:
        begin
          dir:= ExtractFilePath(localfn);
          if not DirectoryExists(dir) then
            CreateDir(dir);
          Lines.SaveToFile(localfn);
          Result:= TRUE;
        end;
        {300..399: ShowNotification(NIL, 'Fout bij ophalen bestand'); //redirection. Not implemented, but could be.
        400..499: ShowNotification(NIL, 'Bestand niet gevonden'); //client error; 404 not found etc
        500..599: ShowNotification(NIL, 'Interne server fout'); //internal server error
        else ShowNotification(NIL, 'Onbekende fout');; //unknown code}
      end;
    except
      // We don't care for the reason for this error; the download failed.
    end;
  finally
    HTTPSender.Free;
    Lines.Free;
//    Header.Free;
  end;
end;

Function CheckNewVersion : boolean;
{  function ProductVersionToString(PV: TFileProductVersion): String;
  begin
//    Result:= Format(['%d.%d.%d.%d'], [PV[0],PV[1],PV[2],PV[3]]);
    Result:= IntToStr(PV[0]) + '.' + IntToStr(PV[1]) + '.'
             + IntToStr(PV[2]) + '.' + IntToStr(PV[3]);
  end;}
  Function NewVersion(PV : TFileProductVersion; NewVersionStr : string) : boolean;
  var i, n : integer;
      nr : array[0..3] of integer;
      s : string;
      s1 : string;
  begin
    Result:= false;
    s:= '';
    n:= 0;
    for i:= 0 to 3 do nr[i]:= 0;
    for i:= 1 to Length(NewVersionStr) do
    begin
      s1:= MidStr(NewVersionStr, i, 1);
      if s1 <> '.' then s:= s + s1
      else
      begin
        nr[n]:= StrToInt(s);
        Inc(n);
        s:= '';
      end;
    end;
    nr[n]:= StrToInt(s);
    Result:= (nr[0] > PV[0]) or
             ((nr[0] = PV[0]) and (nr[1] > PV[1])) or
             ((nr[0] = PV[0]) and (nr[1] = PV[1]) and (nr[2] > PV[2])) or
             ((nr[0] = PV[0]) and (nr[1] = PV[1]) and (nr[2] = PV[2]) and (nr[3] > PV[3]));
  end;
var localfn, {fnwin, fnlin32, fnlin64,} version{, currentversion} : string;
    delfile : PChar;
    Info: TVersionInfo;
    list : TStringList;
begin
  Result:= false;

  try
    //get current version info
    Info := TVersionInfo.Create;
    Info.Load(HINSTANCE);
  //  currentversion:= lowercase(ProductVersionToString(Info.FixedInfo.FileVersion));

    localfn:= Settings.DataLocation.Value + 'tmp';

    if GetHTTPFile('http://wittepaard.roodetoren.nl/version.txt', localfn) then
    begin
      if FileExists(localfn) then
      begin
        list:= TStringList.Create;
        list.LoadFromFile(localfn);
        //first line contains version number
        version:= lowercase(list.Strings[0]);
        list.Free;
        if FileExists(localfn) then
        begin
          delfile:= PChar(localfn);
          DeleteFile(delfile);
        end;

        Result:= NewVersion(Info.FixedInfo.FileVersion, version);
      end;
    end;
  finally
    Info.Free;
  end;
end;

Function DownloadNewVersion(fn : string) : boolean;
var localfn: string;
    aProcess : TProcess; //TProcess is crossplatform is best way
    delfile : PChar;
    {$ifdef windows}
    s, bs : string;
    l : TStringList;
    {$endif}
begin
  Result:= false;
  try
    Screen.Cursor:= crHourglass;
    {$ifdef Windows}
      localfn:= Settings.DataLocation.Value + 'brewbuddy.zip';
    {$endif}
    {$ifdef unix}
      localfn:= Settings.DataLocation.Value + 'brewbuddy';
    {$endif}

//    if GetHTTPFile('http://wittepaard.roodetoren.nl/' + fn, localfn) then

    if DownloadFile('http://wittepaard.roodetoren.nl/' + fn, localfn) then
    begin
      {$ifdef windows}
      //unzip file
      UnZipFiles(localfn, ExtractFilePath(localfn));
      if FileExists(localfn) then
      begin
        delfile:= PChar(localfn);
        DeleteFile(delfile);
      end;
      localfn:= Settings.DataLocation.Value + 'brewbuddy.exe';
      //new exe file is now downloaded to localfn
      //replace old exe file with new one
      s:= Application.ExeName;
//      s:= 'C:\Program Files (x86)\BrouwHulp\brewbuddy.exe';
      l:= TStringList.Create;
      bs:= 'copy "' + localfn + '" "' + s + '"';
      l.Add(bs);
      bs:= Settings.DataLocation.Value + 'cp.bat';
      l.SaveToFile(bs);
      FreeAndNIL(l);
      Result:= RunAsAdmin(FrmMain.Handle, bs, '');
      if FileExists(bs) then
      begin
        delfile:= PChar(bs);
        DeleteFile(delfile);
      end;
      {$endif}
      {$ifdef Linux}
      Result:= RunAsRoot('cp ' + localfn + ' /usr/bin/brewbuddy', 'chmod +x /usr/bin/brewbuddy');
      {$endif}
      if not Result then ShowNotification(frmMain, 'Fout bij kopiëren nieuwe BrouwHulp');
      if FileExists(localfn) then
      begin
        delfile:= PChar(localfn);
        DeleteFile(delfile);
      end;
      if Result then
      begin
        aProcess := TProcess.Create(nil);
        aProcess.CommandLine := Application.ExeName;
        aProcess.Execute;
        aProcess.Free;
        Application.Terminate;
      end;
    end;
  finally
    Application.ProcessMessages;
    Result:= false; //if this code is executed, the application has not restarted
  end;
end;

end.

