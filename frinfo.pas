unit frinfo;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, ComCtrls;

type

  { TfrmInfo }

  TfrmInfo = class(TForm)
    lTwitter: TLabel;
    mThanks: TMemo;
    BitBtn1: TBitBtn;
    PageControl1: TPageControl;
    tsInfo: TTabSheet;
    pLogo: TPanel;
    iLogo: TImage;
    Label1: TLabel;
    lFileVersion: TLabel;
    pText: TPanel;
    mText: TMemo;
    tsThanks: TTabSheet;
    tsBrewing: TTabSheet;
    Panel1: TPanel;
    iBook: TImage;
    mBrewing: TMemo;
    procedure iLogoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lTwitterClick(Sender: TObject);
    procedure mBrewingChange(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Function Execute : boolean;
  end; 

var
  frmInfo: TfrmInfo;

implementation

{$R *.lfm}
uses LCLIntf, vinfo, versiontypes, data, hulpfuncties;

{ TfrmInfo }

procedure TfrmInfo.iLogoClick(Sender: TObject);
begin
  //ga naar de website van Het Witte Paard
  OpenURL('http://wittepaard.roodetoren.nl');
end;

procedure TfrmInfo.FormCreate(Sender: TObject);

  function ProductVersionToString(PV: TFileProductVersion): String;
  begin
    Result := sysutils.Format('%d.%d.%d.%d', [PV[0],PV[1],PV[2],PV[3]])
  end;

var
  Info: TVersionInfo;
begin
  Info := TVersionInfo.Create;
  Info.Load(HINSTANCE);

  lFileVersion.Caption:= ProductVersionToString(Info.FixedInfo.FileVersion);
//  lProductVersion.Caption:= ProductVersionToString(Info.FixedInfo.ProductVersion);

  Info.Free;
  PageControl1.ActivePage:= tsInfo;
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TfrmInfo.lTwitterClick(Sender: TObject);
begin
  OpenURL('https://twitter.com/BrouwHulp');
end;

procedure TfrmInfo.mBrewingChange(Sender: TObject);
begin

end;

Function TfrmInfo.Execute : boolean;
begin
  Result:= (ShowModal = mrOK);
end;

end.

