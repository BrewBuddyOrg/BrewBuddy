unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, 
  ovctcedt, ovctchdr, ovctcmmn, ovctable, ovcbase, ovctcsim, o32tcflx,
  ovcdata, ovcsf, ovctcbef, ovctcell, ovctcstr;

const
  MaxDataRecs = 20;
  MaxStrLen = 100;
  cnStr = 1;  {Column numbers for controls}
  cnSimp = 2;
  cnFlex = 3;
  
type
  TDataRec = record
    Str  : string[MaxStrLen];
    Simp : string[MaxStrLen];
    Flex : string;
    end;
    
  TDataArray = array[1..MaxDataRecs] of TDataRec;

  TForm1 = class(TForm)
    OvcTable1: TOvcTable;
    OvcController1: TOvcController;
    OvcTCColHead1: TOvcTCColHead;
    OvcTCRowHead1: TOvcTCRowHead;
    OvcTCString1: TOvcTCString;
    OvcTCSimpleField1: TOvcTCSimpleField;
    O32TCFlexEdit1: TO32TCFlexEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OvcTable1GetCellData(Sender: TObject; RowNum,
      ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    procedure OvcTCSimpleField1UserValidation(Sender: TObject;
      var ErrorCode: Word);
    procedure OvcTCSimpleField1Error(Sender: TObject; ErrorCode: Word;
      ErrorMsg: String);
    procedure O32TCFlexEdit1UserValidation(Sender: TObject; Value: String;
      var ValidEntry: Boolean);
  private
    DataArray : TDataArray;  {A place to store data entered in table}
  public
  end;

var
  Form1: TForm1;


implementation

{$IFNDEF LCL}
{$R *.dfm}  {Link Delphi form file}
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
 {Initialize the main form.
  Do anything that needs to be done before the form
   can be displayed.}
var
  RowNum : Integer;
begin
  OvcTable1.RowLimit := MaxDataRecs + OvcTable1.LockedRows;
  
  OvcTCString1.MaxLength := MaxStrLen;  {Be sure to set this here or in form}
  OvcTCSimpleField1.MaxLength := MaxStrLen;
  O32TCFlexEdit1.MaxLength := MaxStrLen;
  
{$IFDEF FPC}
  for RowNum := 1 to MaxDataRecs do
    SetLength(DataArray[RowNum].Flex, MaxStrLen);
{$ENDIF}    
end;  {TForm1.FormCreate}


procedure TForm1.FormDestroy(Sender: TObject);
begin
end;  {TForm1.FormDestroy}


procedure TForm1.OvcTable1GetCellData(Sender: TObject; RowNum,
  ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
 {This event handler is called when the table needs data to display 
   or edit in a cell or a place to save a cell's edited data.}
begin
  Data := nil;
  if (RowNum < OvcTable1.LockedRows) or (RowNum > OvcTable1.RowLimit) then
    Exit;
    
  case ColNum of
    cnStr  : Data := @DataArray[RowNum].Str;
    cnSimp : Data := @DataArray[RowNum].Simp;
    cnFlex : Data := PChar(DataArray[RowNum].Flex);
    end;   
end;  {TForm1.OvcTable1GetCellData}


procedure TForm1.OvcTCSimpleField1UserValidation(Sender: TObject;
  var ErrorCode: Word);
var
  AnInt : Integer;
begin
  ErrorCode := 0;
  if (TOvcSimpleField(Sender).Text <> '') and
     (not TryStrToInt(TOvcSimpleField(Sender).Text, AnInt)) then
    ErrorCode := oeInvalidNumber; 
end;

procedure TForm1.OvcTCSimpleField1Error(Sender: TObject; ErrorCode: Word;
  ErrorMsg: String);
begin
  MessageDlg(ErrorMsg + #13#10 + 'Enter an integer or press Ctrl+Z to undo.', 
             mtError, [mbOK], 0);
end;

procedure TForm1.O32TCFlexEdit1UserValidation(Sender: TObject;
  Value: String; var ValidEntry: Boolean);
var
  AnInt : Integer;
begin
  ValidEntry := True;
  if (Value <> '') and (not TryStrToInt(Value, AnInt)) then
    begin
    ValidEntry := False;
    MessageDlg('Invalid value.' + #13#10 + 
               'Enter an integer or press Ctrl+Z to undo.', mtError, [mbOK], 0);
    end;
end;


end.
