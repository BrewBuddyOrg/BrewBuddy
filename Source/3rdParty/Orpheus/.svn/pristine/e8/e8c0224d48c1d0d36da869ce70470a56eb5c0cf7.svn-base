unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, 
  ovcbase, ovctcbmp, ovctccbx, ovctcgly, ovctcbox, ovctcedt,
  ovctchdr, ovctcmmn, ovctcell, ovctcstr, ovctable;

const
  MaxDataRecs = 20;
  MaxStrLen = 100;
  MaxMemoLen = 1000;
  cnStr = 1;  {Column numbers for controls}
  cnMemo = 2;
  cnCheckbox = 3;
  cnCombo = 4;
  cnBitmap = 5; 
  
type
  TDataRec = record
    Str : string[MaxStrLen];
    Memo : array[0..MaxMemoLen] of Char;
    Check : TCheckBoxState;
    ComboIndex : Integer;
    Bitmap : TBitmap;
    end;
    
  TDataArray = array[1..MaxDataRecs] of TDataRec;

  TForm1 = class(TForm)
    OvcTable1: TOvcTable;
    OvcController1: TOvcController;
    OvcTCColHead1: TOvcTCColHead;
    OvcTCRowHead1: TOvcTCRowHead;
    OvcTCString1: TOvcTCString;
    OvcTCMemo1: TOvcTCMemo;
    OvcTCCheckBox1: TOvcTCCheckBox;
    OvcTCComboBox1: TOvcTCComboBox;
    OvcTCBitMap1: TOvcTCBitMap;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure OvcTable1GetCellData(Sender: TObject; RowNum,
      ColNum: Integer; var Data: Pointer; Purpose: TOvcCellDataPurpose);
    procedure OvcTCComboBox1Change(Sender: TObject);
  private
    BmpPath : string;        {Path to Orpheus .bmp files}
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
  SearchResult : Integer;
  SearchRec    : TSearchRec;
begin
  OvcTable1.RowLimit := MaxDataRecs + OvcTable1.LockedRows;
  
  OvcTCString1.MaxLength := MaxStrLen;  {Be sure to set this here or in form}
  OvcTCMemo1.MaxLength := MaxMemoLen;

   {Populate cell combo box with names of Orpheus control bitmap files.
     Assumes bitmap files are two levels up from program with Windows and GTK
     or five levels up with OS X app bundle folder.}
  BmpPath := ExtractFilePath(ParamStr(0)) + '..' + PathDelim + '..' + PathDelim;
  if FindFirst(BmpPath + 'TO*.bmp', 0, SearchRec) <> 0 then
    begin
    BmpPath := '..' + PathDelim + '..' + PathDelim;
    if FindFirst(BmpPath + 'TO*.bmp', 0, SearchRec) <> 0 then
      BmpPath := ExtractFilePath(ParamStr(0)) + '..' + PathDelim + '..' + 
                 PathDelim + '..' + PathDelim + '..' + PathDelim + '..' + PathDelim;
    end;
  OvcTCComboBox1.Items.Add(' (None)');  {So we can "unselect"}
  try
    SearchResult := FindFirst(BmpPath + 'TO*.bmp', 0, SearchRec);
    while SearchResult = 0 do  {Do until no more matching files found}
      begin
      OvcTCComboBox1.Items.Add(SearchRec.Name);
      SearchResult := FindNext(SearchRec);
      end;
  finally
    FindClose(SearchRec);
    end;
end;  {TForm1.FormCreate}


procedure TForm1.FormDestroy(Sender: TObject);
var
  RecNum : Integer;
begin
  for RecNum := 1 to MaxDataRecs do  {Free any TBitmap's created}
    DataArray[RecNum].Bitmap.Free;
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
    cnStr : Data := @DataArray[RowNum].Str;
    cnMemo : Data := @DataArray[RowNum].Memo;
    cnCheckbox : Data := @DataArray[RowNum].Check;
    cnCombo : Data := @DataArray[RowNum].ComboIndex;
    cnBitmap : Data := pointer(DataArray[RowNum].Bitmap);      
    end;   
end;  {TForm1.OvcTable1GetCellData}


procedure TForm1.OvcTCComboBox1Change(Sender: TObject);
 {This event handler is called whenever combo box selection
   changes.
  Note: TOvcTCComboBox is not descended from TCustomComboBox, but
   its editing control (Sender) is, so okay to typecast it in order
   to reference ItemIndex.}
begin
  DataArray[OvcTable1.ActiveRow].Bitmap.Free;
  DataArray[OvcTable1.ActiveRow].Bitmap := nil;
  if TCustomComboBox(Sender).ItemIndex > 0 then  {Bitmap file selected?}
    begin
    DataArray[OvcTable1.ActiveRow].Bitmap := TBitmap.Create;
    DataArray[OvcTable1.ActiveRow].Bitmap.LoadFromFile(
     BmpPath + OvcTCComboBox1.Items[TCustomComboBox(Sender).ItemIndex]);
    end;
  OvcTable1.AllowRedraw := False;
  OvcTable1.InvalidateCell(OvcTable1.ActiveRow, cnBitmap); {Force display of bitmap}
  OvcTable1.AllowRedraw := True;
end;  {TForm1.OvcTCComboBox1Change}


end.
