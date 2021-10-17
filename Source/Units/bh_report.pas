unit BH_report;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, ExtCtrls, Printers, Types, TAGraph;

type
  TBHRDocument = class;

  TBHRElement = class(TObject)
    Constructor Create(D : TBHRDocument); virtual;
    Destructor Destroy; override;
   private
     FDocument : TBHRDocument;
     FRect : TRect;
     FPageNrS, FPageNrE, FMinHeight : integer;
     FKeepWithNext : boolean;
     FKeepTogether : boolean;
     FPrior, FNext : TBHRElement;
     Procedure SetRect(R : TRect);
     Function GetLeft : word;
     Function GetRight : word;
     Function GetTop : word;
     Function GetBottom : word;
     Function GetMinHeight : word;
     Procedure SetLeft(l : word); virtual;
     Procedure SetRight(r : word); virtual;
     procedure SetTop(t : word); virtual;
     Procedure SetBottom(b : word); virtual;
     procedure SetMinHeight(h : word); virtual;
     Procedure SetNext(E : TBHRElement); virtual;
     Procedure SetPrior(E : TBHRElement); virtual;
     Procedure SetPageNrS(i : integer); virtual;
     Procedure SetPageNrE(i : integer); virtual;
     Procedure SetKeepTogether(b : boolean); virtual;
   protected
     Procedure DeployKeepWithNext; virtual;
     Procedure Move(PNr, Tp : word); virtual;
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); virtual;
     Procedure CalcRect; virtual;
     property Rect : TRect read FRect write SetRect;
     property Left : word read GetLeft write SetLeft;
     property Right : word read GetRight write SetRight;
     property Top : word read GetTop write SetTop;
     property Bottom : word read GetBottom write SetBottom;
     property MinHeight : word read GetMinHeight write SetMinHeight;
     property PageNrS : integer read FPageNrS write SetPageNrS;
     property PageNrE : integer read FPageNrE write SetPageNrE;
     property KeepWithNext : boolean read FKeepWithNext write FKeepWithNext;
     property KeepTogether : boolean read FKeepTogether write SetKeepTogether;
     property Next : TBHRElement read FNext write SetNext;
     property Prior : TBHRElement read FPrior write SetPrior;
   published
  end;

  TBHRImage = class(TBHRElement)
    Constructor Create(D : TBHRDocument); override;
    Destructor Destroy; override;
   private
     FPicture : TPicture;
     FStretch : boolean;
   protected
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
   published
     property Picture : TPicture read FPicture;
     property Stretch : boolean read FStretch write FStretch;
  end;

 { TBHRBHGraph = class(TBHRElement)
    Constructor Create(D : TBHRDocument); override;
    Destructor Destroy; override;
   private
     FGraph : TBHGraph;
     FStretch : boolean;
   protected
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
   published
     property Graph : TBHGraph read FGraph write FGraph;
     property Stretch : boolean read FStretch write FStretch;
  end; }

  TBHRChart = class(TBHRElement)
    Constructor Create(D : TBHRDocument); override;
    Destructor Destroy; override;
   private
     FChart : TChart;
     FStretch : boolean;
   protected
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
   published
     property Chart : TChart read FChart write FChart;
     property Stretch : boolean read FStretch write FStretch;
  end;

  TBHRText = class;
  TBHRCell = class;

  TBHRTable = class(TBHRElement)
    Constructor Create(D : TBHRDocument); override;
    Destructor Destroy; override;
   private
     FCells : array of array of TBHRCell;
     FAutoSizeCells : boolean;
     FColsEven : boolean;
     Function GetRowColor(i : word) : TColor;
     Procedure SetRowColor(i : word; cl : TColor);
     Function GetColColor(i : word) : TColor;
     Procedure SetColColor(i : word; cl : TColor);
     Procedure SetPageNrS(i : integer); override;
     Procedure SetPageNrE(i : integer); override;
     Procedure SetAutoSizeCells(b : boolean);
     Procedure SetKeepTogether(b : boolean); override;
   protected
     Procedure Move(PNr, Tp : word); override;
   public
     Function GetCell(aRow, aCol : integer) : TBHRCell;
     Function NumRows : integer;
     Function NumCols : integer;
     Function GetColWidth(aCol : integer) : word;
     Procedure SetColWidth(aCol : integer; Width : word);
     Procedure SetColsEven(b : boolean);
     Function GetRowHeight(aRow : integer) : word;
     Procedure SetRowHeight(ARow : integer; Height : word);
     Procedure AddRow;
     Procedure AddCol;
     Procedure SetSize(NRows, NCols : integer);
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
     property Cells[ARow, ACol: integer] : TBHRCell read GetCell;
     property ColWidth[ACol : integer] : word read GetColWidth write SetColWidth;
     property RowHeight[ARow : integer] : word read GetRowHeight write SetRowHeight;
     property RowColor[i : word] : TColor read GetRowColor write SetRowColor;
     property ColColor[i : word] : TColor read GetColColor write SetColColor;
   published
     property AutoSizeCells : boolean read FAutoSizeCells write SetAutoSizeCells;
     property ColsEven : boolean read FColsEven write SetColsEven;
  end;

  TBHRCell = class(TBHRElement)
    Constructor Create(D : TBHRDocument; R, C : integer);
    Destructor Destroy; override;
   private
     FText : TBHRText;
     FTable : TBHRTable;
     FRow, FColumn : integer;
     Procedure SetLeft(l : word); override;
     Procedure SetRight(r : word); override;
     procedure SetTop(t : word); override;
     Procedure SetBottom(b : word); override;
     Function GetFont : TFont;
     Function GetBrush : TBrush;
     Function GetPen : TPen;
     Function GetAlignment : TAlignment;
     Procedure SetAlignment(al : TAlignment);
     Function GetKeepTogether : boolean;
     Function GetMarge : word;
     Procedure SetMarge(w : word);
     Function GetAutoSize : boolean;
     Procedure SetAutoSize(b : boolean);
     Procedure SetKeepTogether(b : boolean); override;
     Procedure SetNext(E : TBHRElement); override;
     Procedure SetPrior(E : TBHRElement); override;
     Function GetCheckBoxes : boolean;
     Procedure SetCheckBoxes(b : boolean);
     Function GetCheckBoxSize : LongInt;
     Procedure SetCheckBoxSize(L : LongInt);
     Procedure SetPageNrS(i : integer); override;
     Procedure SetPageNrE(i : integer); override;
   protected
     Procedure Move(PNr, Tp : word); override;
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
   published
     Property Content : TBHRText read FText;
     property Row : integer read FRow write FRow;
     property Column : integer read FColumn write FColumn;
     property Font : TFont read GetFont;
     property Brush : TBrush read GetBrush;
     property Pen : TPen read GetPen;
     property Alignment : TAlignment read GetAlignment write SetAlignment;
     property KeepTogether : boolean read GetKeepTogether write SetKeepTogether;
     property Marge : word read GetMarge write SetMarge;
     property AutoSize : boolean read GetAutoSize write SetAutoSize;
     property CheckBoxes : boolean read GetCheckBoxes write SetCheckBoxes;
     property CheckBoxSize : LongInt read GetCheckBoxSize write SetCheckBoxSize;
     property Table : TBHRTable read FTable write FTable;
  end;

  TWhere = (twAbove, twBelow);
  TLineProps = record
    Rect : TRect;
    PageNr : integer;
    TextRect : TRect;
  end;

  TBHRText = class(TBHRElement)
    Constructor Create(D : TBHRDocument); override;
    Destructor Destroy; override;
   private
    FCell : TBHRCell;
    FStrings : TStringList;
    FFont : TFont;
    FBrush : TBrush;
    FPen : TPen;
    FAlignment : TAlignment;
    FLineProps : Array of TLineProps;
    FMarge : word;
    FAutoSize : boolean;
    FCheckBoxes : boolean;
    FChecked : boolean;
    FCheckBoxSize : Longint;
    FFontHeight : integer;
    Function GetString(i : integer) : string;
    Procedure SetString(i : integer; s : string);
    Procedure SetMarge(w : word);
   protected
    Procedure Move(PNr, Tp : word); override;
   public
    Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
    Procedure CalcRect; override;
    Procedure AddString(s : string);
    Procedure RemoveString(i : integer);
    Procedure InsertString(s : string; i : integer; Where : TWhere);
    property Line[i : integer] : string read GetString write SetString;
   published
    property Cell : TBHRCell read FCell write FCell;
    property Font : TFont read FFont;
    property Brush : TBrush read FBrush;
    property Pen : TPen read FPen;
    property Alignment : TAlignment read FAlignment write FAlignment;
    property Marge : word read FMarge write SetMarge;
    property AutoSize : boolean read FAutoSize write FAutoSize;
    property CheckBoxes : boolean read FCheckBoxes write FCheckBoxes;
    property Checked : boolean read FChecked write FChecked;
    property CheckBoxSize : LongInt read FCheckBoxSize write FCheckBoxSize;
  end;

  THeaderType = (thHeader, thFooter);

  TBHRHeader = class(TBHRElement)
    Constructor Create(D : TBHRDocument; HT : THeaderType);
    Destructor Destroy; override;
   private
     FPicture : TPicture;
     FPictRect, FTxtRect : TRect;
     FText : string;
     FHeight : LongInt;
     FHeaderType : THeaderType;
     FFont : TFont;
     FFontHeight : integer;
     FBrush : TBrush;
     FPen : TPen;
     FAlignment : TAlignment;
     FMarge : word;
     Procedure SetPictRect(R : TRect);
     Function GetPictRect : TRect;
     Procedure SetTxtRect(R : TRect);
     Function GetTxtRect : TRect;
     Procedure SetHeight(H : LongInt);
     Procedure SetText(S : string);
   protected
   public
     Procedure Draw(Cnvs : TCanvas; Pnr : integer; Scale : single); override;
     Procedure CalcRect; override;
     property PictRect : TRect read GetPictRect write SetPictRect;
     property TxtRect : TRect read GetPictRect write SetPictRect;
   published
     property Picture : TPicture read FPicture;
     property Height : LongInt read FHeight write SetHeight;
     property Text : string read FText write SetText;
     property Font : TFont read FFont;
     property Brush : TBrush read FBrush;
     property Pen : TPen read FPen;
     property Alignment : TAlignment read FAlignment write FAlignment;
     property Marge : word read FMarge write FMarge;
  end;

  TBHRDocument = class(TObject)
   Constructor Create;
   Destructor Destroy; override;
   private
     FHeader : TBHRHeader;
     FFooter : TBHRHeader;
     FNumPages : word;
     FElements : array of TBHRElement;
     FPageRect, FPrintRect : TRect;
     FMarginBT : single;
     FMarginLR : single;
     FMarginBTpx : integer;
     FMarginLRpx : integer;
     FLastY : word;
     FLastPage : word;
     Procedure GetPrinterProps;
     Function GetNumElements : integer;
     Procedure CalcRects;
     Function GetElement(i : integer) : TBHRElement;
   protected
   public
     Procedure AddPage;
     Procedure RemovePage;
     Function AddText(Rect : TRect; s : string) : TBHRText;
     Function AddTable(Rect : TRect; nCol, nRow : integer) : TBHRTable;
     Function AddImage(Rect : TRect) : TBHRImage;
//     Function AddGraph(Rect : TRect) : TBHRBHGraph;
     Function AddChart(Rect : TRect) : TBHRChart;
     Function AddSpace(Rect : TRect; h : word) : TBHRElement;
     Procedure Print(FromPage, ToPage, Copies : integer);
     Procedure PrintPreview;
     Procedure DrawPages(cnvs : TCanvas; Scale : single);
     Procedure DrawPage(cnvs : TCanvas; PageNr : integer; Scale : single);
     Procedure Repaginate;
     Function GetLineHeight(fh : integer) : integer;
     property Element[i : integer] : TBHRElement read GetElement;
     property Header : TBHRHeader read FHeader;
     property Footer : TBHRHeader read FFooter;
     property PageRect : TRect read FPageRect;
     property PrintRect : TRect read FPrintRect;
   published
     property MarginBT : single read FMarginBT write FMarginBT;
     property MarginLR : single read FMarginLR write FMarginLR;
     property NumElements : integer read GetNumElements;
     property NumPages : word read FNumPages;
     property LastY : word read FLastY;
  end;

implementation

uses frmain, HulpFuncties, frprintpreview, StrUtils, TASeries, Controls;

Function CmToPixX(cm : single) : word;
begin
  if Printer <> NIL then Result:= round(cm / 2.54 * Printer.XDPI)
  else Result:= round(cm / 2.54 * 600);
end;

Function CmToPixY(cm : single) : word;
begin
  if Printer <> NIL then Result:= round(cm / 2.54 * Printer.YDPI)
  else Result:= round(cm / 2.54 * 600);
end;

Function FontSizeToPix(sz, scale : single) : word;
var dpy : integer;
begin
  if Printer <> NIL then dpy:= Printer.YDPI
  else dpy:= 600;
  if abs(sz) < 40 then Result:= round(scale * abs(sz) / 72 * dpy)
  else Result:= round(scale * 8 / 72 * dpy);
end;

Function ScaleRect(R : TRect; scale : single) : TRect;
begin
  Result.Left:= round(scale * R.Left);
  Result.Right:= round(scale * R.Right);
  Result.Top:= round(scale * R.Top);
  Result.Bottom:= round(scale * R.Bottom);
end;

Constructor TBHRElement.Create(D : TBHRDocument);
begin
  Inherited Create;
  FDocument:= D;
  FRect.Bottom:= 0;
  FRect.Top:= 0;
  FRect.Left:= 0;
  FRect.Right:= 0;
  FPageNrS:= FDocument.NumPages;
  FPageNrE:= FDocument.NumPages;
  FKeepWithNext:= false;
  FKeepTogether:= TRUE;
  FNext:= NIL;
  FPrior:= NIL;
end;

Destructor TBHRElement.Destroy;
begin
  Inherited Destroy;
end;

Procedure TBHRElement.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
begin
end;

Procedure TBHRElement.SetRect(R : TRect);
begin
  FRect.Left:= R.Left;
  FRect.Right:= R.Right;
  FRect.Top:= R.Top;
  FRect.Bottom:= R.Bottom;
end;

Function TBHRElement.GetLeft : word;
begin
  Result:= FRect.Left;
end;

Procedure TBHRElement.SetLeft(l : word);
begin
  FRect.Left:= l;
end;

Function TBHRElement.GetRight : word;
begin
  Result:= FRect.Right;
end;

Procedure TBHRElement.SetRight(r : word);
begin
  FRect.Right:= r;
end;

Function TBHRElement.GetTop : word;
begin
  Result:= FRect.Top;
end;

procedure TBHRElement.SetTop(t : word);
begin
  FRect.Top:= t;
end;

Function TBHRElement.GetBottom : word;
begin
  Result:= FRect.Bottom;
end;

Procedure TBHRElement.SetBottom(b : word);
begin
  FRect.Bottom:= b;
end;

Procedure TBHRElement.SetKeepTogether(b : boolean);
begin
  if FKeepTogether <> b then
  begin
    FKeepTogether:= b;
  end;
end;

Function TBHRElement.GetMinHeight : word;
begin
  Result:= FMinHeight;
end;

Procedure TBHRElement.SetMinHeight(h : word);
begin
  FMinHeight:= h;
end;

Procedure TBHRElement.SetNext(E : TBHRElement);
begin
  FNext:= E;
end;

Procedure TBHRElement.SetPrior(E : TBHRElement);
begin
  FPrior:= E;
end;

Procedure TBHRElement.SetPageNrS(i : integer);
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    FPageNrS:= i;
    if FPageNrE < FPageNrS then
      FPageNrE:= FPageNrS;
  end;
end;

Procedure TBHRElement.SetPageNrE(i : integer);
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    FPageNrE:= i;
    if FPageNrE < FPageNrS then
      FPageNrS:= FPageNrE;
  end;
end;

Procedure TBHRElement.Move(PNr, Tp : word);
var h : word;
    i, j : integer;
begin
  j:= 0;
  if FPageNrE > FPageNrS then
  begin
    h:= FDocument.PrintRect.Bottom - FRect.Top;
    for i:= 1 to (FPageNrE - FPageNrS - 1) do
    begin
      Inc(j);
      h:= h + FDocument.PrintRect.Bottom - FDocument.PrintRect.Top;
    end;
    Inc(j);
    h:= FRect.Bottom - FDocument.PrintRect.Top;
  end
  else
    h:= FRect.Bottom - FRect.Top;
  FRect.Top:= tp;
  FPageNrS:= PNr;
  FPageNrE:= FPageNrS + j;
  while h > 0 do
  begin
    FRect.Bottom:= tp + h;
    if FRect.Bottom > FDocument.PrintRect.Bottom then
    begin
      h:= h - (FDocument.PrintRect.Bottom - FDocument.PrintRect.Top);
      tp:= FDocument.PrintRect.Top;
    end
    else
    begin
      h:= 0;
    end;
  end;
end;

Procedure TBHRElement.CalcRect;
begin
  if FPrior <> NIL then
  begin
    Top:= FPrior.Bottom;
    FPageNrS:= FPrior.PageNrE;
  end
  else
  begin
    //Top:= FDocument.FPrintRect.Top;
    //FPageNrS:= 1;
  end;
  FPageNRE:= FPageNRS;
  Bottom:= Top + FMinHeight;
end;

Procedure TBHRElement.DeployKeepWithNext;
var E : TBHRElement;
    PNr, Tp : word;
begin
   if FPrior <> NIL then
   begin
     if (FPrior.KeepWithNext) and (FPageNRS > FPrior.PageNrE) then
     begin
       E:= FPrior;
       While (E.Prior <> NIL) and E.Prior.KeepWithNext do
         E:= E.Prior;
       Tp:= FDocument.PrintRect.Top;
       PNr:= E.PageNrS + 1;
       While E <> self.Next do
       begin
         E.Move(PNr, Tp);
         PNr:= E.PageNrE;
         Tp:= E.Bottom;
         E:= E.Next;
       end;
     end;
   end;
end;

{========================== TBHRHeader =======================================}

Constructor TBHRHeader.Create(D : TBHRDocument; HT : THeaderType);
begin
  Inherited Create(D);
  FHeaderType:= HT;
  FText:= '';
  FPicture := TPicture.Create;
  FFont := TFont.Create;
  with FFont do
  begin
//    CharSet:= DEFAULT_CHARSET;
    Color:= clBlack;
    Size:= 14;
//    Name:= default;
    Orientation:= 0;
    Pitch:= fpDefault;
    Quality:= fqDefault; //fqAntiAliased
    Style:= [];
  end;
  FBrush:= TBrush.Create;
  with FBrush do
  begin
    Color:= clWhite;
    Style:= bsSolid;
  end;
  FPen:= TPen.Create;
  with FPen do
  begin
    Color:= clBlack;
    Style:= psSolid;
    Width:= 1;
  end;
  FMarge:= CmToPixY(0.2);

  if FHeaderType = thHeader then
  begin
    FRect.Top:= FMarge;
    FRect.Left:= FMarge;
    FRect.Right:= FDocument.PageRect.Right - FMarge;
    FRect.Bottom:= FDocument.PrintRect.Top;
    FPictRect.Top:= FRect.Top + FMarge;
    FPictRect.Bottom:= FRect.Bottom - FMarge;
    FPictRect.Left:= 0;
    FPictRect.Right:= 0;
    FAlignment:= taCenter;
  end
  else
  begin
    FRect.Top:= FDocument.PrintRect.Bottom + FMarge;
    FRect.Left:= FMarge;
    FRect.Right:= FDocument.PageRect.Right - FMarge;
    FRect.Bottom:= FDocument.PageRect.Bottom - FMarge;
    FPictRect.Top:= FRect.Top + 5;
    FPictRect.Bottom:= FRect.Bottom - 5;
    FPictRect.Left:= 0;
    FPictRect.Right:= 0;
    FAlignment:= taRightJustify;
  end;
  FHeight:= FRect.Bottom - FRect.Top;
end;

Destructor TBHRHeader.Destroy;
begin
  FPicture.Free;
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  Inherited;
end;

Procedure TBHRHeader.SetPictRect(R : TRect);
begin
  FPictRect:= R;
end;

Function TBHRHeader.GetPictRect : TRect;
begin
  Result:= FPictRect;
end;

Procedure TBHRHeader.SetTxtRect(R : TRect);
begin
  FTxtRect:= R;
end;

Function TBHRHeader.GetTxtRect : TRect;
begin
  Result:= FTxtRect;
end;

Procedure TBHRHeader.SetText(S : string);
begin
  FText:= S;
end;

Procedure TBHRHeader.SetHeight(H : LongInt);
begin
  if (FHeight <> H) and (H >= 0) and
    (H < round(0.1 * (FDocument.PageRect.Bottom - FDocument.PageRect.Top))) then
  begin
    FHeight:= H;
    if FHeaderType = thHeader then
      FDocument.FPrintRect.Top:= FDocument.PageRect.Top + FHeight
    else
      FDocument.FPrintRect.Bottom:= FDocument.PageRect.Bottom - FHeight;
    CalcRect;
  end;
end;

Procedure TBHRHeader.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var R, SRect : TRect;
    mh, FH : LongInt;
begin
  //Draw the picture
  if (not FPicture.Bitmap.Empty) or (not FPicture.Graphic.Empty) or (not FPicture.Jpeg.Empty)
  or (not FPicture.PNG.Empty) or (not FPicture.PNM.Empty) or (not FPicture.Pixmap.Empty) then
  begin
    R.Left:= 0;
    R.Top:= 0;
    R.Right:= FPicture.Width;
    R.Bottom:= FPicture.Height;
    SRect:= ScaleRect(FPictRect, Scale);

    cnvs.Pen.Style:= psClear;
    cnvs.Brush.Color:= clWhite;
    cnvs.Rectangle(FPictRect);
    cnvs.CopyMode:= cmSrcCopy;
    cnvs.CopyRect(SRect, FPicture.Bitmap.Canvas, R);
  end;

  //Draw the text
  cnvs.Font.Assign(FFont);
  FH:= round(1.2 * FontSizeToPix(cnvs.Font.Size, 1));
  //first, try if the text fits in the designated area. If not, lower the font size
  mh:= cnvs.TextWidth(FText);
  while (mh > (FTxtRect.Right - FTxtRect.Left)) and (FFont.Size >= 1) do
  begin
    cnvs.Font.Size:= cnvs.Font.Size - 1;
    FH:= round(1.2 * FontSizeToPix(cnvs.Font.Size, 1));
    mh:= cnvs.TextWidth(FText);
  end;
  FTxtRect.Top:= FTxtRect.Bottom - FH;

  SRect:= ScaleRect(FTxtRect, Scale);
  cnvs.Font.Height:= FontSizeToPix(FFont.Size, Scale);
  mh:= round((SRect.Bottom + SRect.Top) / 2);
  DrawTxt(Cnvs, mh, SRect.Left, SRect.Right, FText, FAlignment, TRUE);

  //Draw the line
  cnvs.Pen.Assign(FPen);
  SRect:= ScaleRect(FRect, Scale);
  if FHeaderType = thHeader then
  begin
    cnvs.MoveTo(SRect.Left, SRect.Bottom);
    cnvs.LineTo(SRect.Right, SRect.Bottom);
  end
  else
  begin
    cnvs.MoveTo(SRect.Left, SRect.Top);
    cnvs.LineTo(SRect.Right, SRect.Top);
  end;
end;

Procedure TBHRHeader.CalcRect;
var W, H : LongInt;
    WH : double;
begin
  if FHeaderType = thHeader then
  begin
    FRect.Top:= FDocument.PageRect.Top + FMarge;
    FRect.Left:= FDocument.PrintRect.Left;
    FRect.Right:= FDocument.PrintRect.Right;
    FRect.Bottom:= FDocument.PrintRect.Top - FMarge;
    FPictRect.Top:= FRect.Top + FMarge;
    FPictRect.Bottom:= FRect.Bottom - FMarge;
    FPictRect.Left:= FRect.Left;
    FPictRect.Right:= 0;
  end
  else
  begin
    FRect.Top:= FDocument.PrintRect.Bottom + FMarge;
    FRect.Left:= FDocument.PrintRect.Left;
    FRect.Right:= FDocument.PrintRect.Right;
    FRect.Bottom:= FDocument.PageRect.Bottom - FMarge;
    FPictRect.Top:= FRect.Top + FMarge;
    FPictRect.Bottom:= FRect.Bottom - FMarge;
    FPictRect.Left:= FRect.Left;
    FPictRect.Right:= 0;
  end;
  FHeight:= FRect.Bottom - FRect.Top;

  W:= FPicture.Width;
  H:= FPicture.Height;
  if H > 0 then
  begin
    WH:= W / H;
    FPictRect.Right:= FPictRect.Left + round(WH * (FPictRect.Bottom - FPictRect.Top));
  end;

  FTxtRect.Left:= FPictRect.Right + FMarge;
  FTxtRect.Right:= FRect.Right;
  FFontHeight:= round(1.2 * FontSizeToPix(FFont.Size, 1));

  if FHeaderType = thHeader then
  begin
    FTxtRect.Bottom:= FRect.Bottom - FMarge;
    FTxtRect.Top:= FTxtRect.Bottom - FFontHeight;
  end
  else
  begin
    FTxtRect.Top:= FRect.Top + FMarge;
    FTxtRect.Bottom:= FTxtRect.Top + FFontHeight;
  end;
end;

{========================== TBHRImage =======================================}

Constructor TBHRImage.Create(D : TBHRDocument);
begin
  Inherited Create(D);
  FPicture := TPicture.Create;
  FStretch:= false;
end;

Destructor TBHRImage.Destroy;
begin
  FPicture.Free;
  Inherited;
end;

Procedure TBHRImage.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var R, SRect : TRect;
begin
  if (FPageNrS = PNr) then
  begin
    R.Left:= 0;
    R.Top:= 0;
    R.Right:= FPicture.Width;
    R.Bottom:= FPicture.Height;
    SRect:= ScaleRect(FRect, Scale);

    cnvs.Brush.Color:= clWhite;
    cnvs.Rectangle(FRect);
    cnvs.CopyMode:= cmSrcCopy;
    cnvs.CopyRect(SRect, FPicture.Bitmap.Canvas, R);
  end;
end;

Procedure TBHRImage.CalcRect;
var W, H : LongInt;
    WH : double;
begin
  Inherited CalcRect;
  if not FStretch then
  begin
    W:= FPicture.Width;
    H:= FPicture.Height;
    if H > 0 then
    begin
      WH:= W / H;
      if WH > 1 then
      begin
        FRect.Right:= FRect.Left + W;
        FRect.Bottom:= FRect.Top + round((FRect.Right - FRect.Left) / WH);
      end
      else
      begin
        FRect.Bottom:= FRect.Top + H;
        FRect.Right:= FRect.Left + round((FRect.Bottom - FRect.Top) * WH);
      end;
    end;
  end;
  DeployKeepWithNext;
end;

{============================TBHRBHGraph ======================================}

{Constructor TBHRBHGraph.Create(D : TBHRDocument);
begin
  Inherited Create(D);
  FStretch:= false;
  FGraph:= NIL;
end;

Destructor TBHRBHGraph.Destroy;
begin
  FGraph:= NIL;
  Inherited;
end;

Procedure TBHRBHGraph.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var SRect : TRect;
begin
  if (FPageNrS = PNr) and (FGraph <> NIL) then
  begin
    SRect:= ScaleRect(FRect, Scale);

    cnvs.Brush.Color:= clWhite;
    cnvs.Rectangle(FRect);

    FGraph.PaintTo(cnvs, SRect);
  end;
end;

Procedure TBHRBHGraph.CalcRect;
var W, H : LongInt;
    WH : double;
begin
  Inherited CalcRect;
  if not FStretch then
  begin
    W:= FGraph.Width;
    H:= FGraph.Height;
    if H > 0 then
    begin
      WH:= W / H;
      if WH > 1 then
      begin
        FRect.Bottom:= FRect.Top + round((FRect.Right - FRect.Left) / WH);
        FRect.Right:= FRect.Left + W;
      end
      else
      begin
        FRect.Right:= FRect.Left + round((FRect.Bottom - FRect.Top) * WH);
        FRect.Bottom:= FRect.Top + H;
      end;
    end;
  end;
  DeployKeepWithNext;
end;    }

{============================TBHRChart =========================================}

Constructor TBHRChart.Create(D : TBHRDocument);
begin
  Inherited Create(D);
  FStretch:= false;
  FChart:= NIL;
end;

Destructor TBHRChart.Destroy;
begin
  FChart:= NIL;
  Inherited;
end;

Procedure TBHRChart.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var SRect, BRect : TRect;
    bmp : tbitmap;
    GSc : single;
    i, OLineWidth, OLegendMargin, OSymbolWidth : integer;
    OMFH, OTFH, OTL, OLFH : integer;
{const FH = 100;
      PenW = 10;}
begin
  if FPageNrS = Pnr then
  begin
    GSc:= Scale * (FRect.Right - FRect.Left) / (FChart.Width);

    FChart.Paint;
    FChart.Proportional:= TRUE;

    SRect:= ScaleRect(FRect, Scale);
    bmp:= TBitmap.Create;
    Bmp.SetSize(SRect.Right - SRect.Left, SRect.Bottom - SRect.Top);
    BRect.Top:= 0;
    BRect.Left:= 0;
    BRect.Bottom:= SRect.Bottom - SRect.Top;
    BRect.Right:= SRect.Right - SRect.Left;

    OTFH:= FChart.AxisList[0].Title.LabelFont.Size;
    OMFH:= FChart.AxisList[0].Marks.LabelFont.Size;
    OTL:= FChart.AxisList[0].TickLength;
    OLFH:= FChart.Legend.Font.Size;
    OLegendMargin:= FChart.Legend.MarginX;
    OSymbolWidth:= FChart.Legend.SymbolWidth;
    OLineWidth:= TLineSeries(FChart.Series[0]).LinePen.Width;

    for i:= 0 to FChart.AxisList.Count - 1 do
    begin
      FChart.AxisList[i].Marks.LabelFont.Size:= round(GSc * 9);
      FChart.AxisList[i].Title.LabelFont.Size:= round(GSC * 9);
      FChart.AxisList[i].TickLength:= round(GSc * OTL);
    end;
    FChart.Legend.Font.Size:= round(GSc * 9);
    FChart.Legend.MarginX:= round(GSc * OLegendMargin);
    FChart.Legend.SymbolWidth:= round(GSc * OSymbolWidth);

    //Adjust line width of chart series
    for i:= 0 to FChart.SeriesCount - 1 do
      TLineSeries(FChart.Series[i]).LinePen.Width:= round(GSc * OLineWidth);

    FChart.PaintOnCanvas(Bmp.Canvas, BRect);

    for i:= 0 to FChart.AxisList.Count - 1 do
    begin
      FChart.AxisList[i].Marks.LabelFont.Size:= OMFH;
      FChart.AxisList[i].Title.LabelFont.Size:= OTFH;
      FChart.AxisList[i].TickLength:= OTL;
    end;
    FChart.Legend.Font.Size:= OLFH;
    FChart.Legend.MarginX:= OLegendMargin;
    FChart.Legend.SymbolWidth:= OSymbolWidth;
    for i:= 0 to FChart.SeriesCount - 1 do
      TLineSeries(FChart.Series[i]).LinePen.Width:= OLineWidth;

    cnvs.Brush.Color:= clWhite;
    cnvs.Rectangle(FRect);
    cnvs.CopyMode:= cmSrcCopy;
    cnvs.CopyRect(SRect, Bmp.Canvas, BRect);
    Bmp.Free;
  end;
end;

Procedure TBHRChart.CalcRect;
var W, H : LongInt;
    WH : double;
begin
  Inherited CalcRect;
  if not FStretch then
  begin
    W:= FChart.Width;
    H:= FChart.Height;
    if H > 0 then
    begin
      WH:= W / H;
      if WH > 1 then
      begin
        FRect.Bottom:= FRect.Top + round((FRect.Right - FRect.Left) / WH);
       // FRect.Right:= FRect.Left + W;
      end
      else
      begin
        FRect.Right:= FRect.Left + round((FRect.Bottom - FRect.Top) * WH);
       // FRect.Bottom:= FRect.Top + H;
      end;
    end;
    if FRect.Bottom > FDocument.FPrintRect.Bottom then
    begin
      FPageNrS:= FPageNrS + 1;
      FPageNrE:= FPageNrS;
      FRect.Top:= FDocument.PrintRect.Top;
      if WH > 1 then
      begin
        FRect.Bottom:= FRect.Top + round((FRect.Right - FRect.Left) / WH);
       // FRect.Right:= FRect.Left + W;
      end
      else
      begin
        FRect.Right:= FRect.Left + round((FRect.Bottom - FRect.Top) * WH);
        FRect.Bottom:= FRect.Top + H;
      end;
    end;
  end;
  DeployKeepWithNext;
end;


{========================== TBHRText ==========================================}

Constructor TBHRText.Create(D : TBHRDocument);
begin
  Inherited Create(D);
  FCell:= NIL;
  FStrings := TStringList.Create;
  FFont := TFont.Create;
  with FFont do
  begin
//    CharSet:= DEFAULT_CHARSET;
    Color:= clBlack;
    Size:= 10;
//    Name:= default;
    Orientation:= 0;
    Pitch:= fpDefault;
    Quality:= fqDefault; //fqAntiAliased
    Style:= [];
  end;
  FAlignment:= taLeftJustify;
  FBrush:= TBrush.Create;
  with FBrush do
  begin
    Color:= clWhite;
    Style:= bsSolid;
  end;
  FPen:= TPen.Create;
  with FPen do
  begin
    Color:= clWhite;
    Style:= psSolid;
    Width:= 1;
  end;
  FMarge:= CmToPixY(0.05);
  FAutoSize:= false;
  FCheckBoxes:= false;
  FChecked:= false;
  FCheckBoxSize:= CmToPixY(0.4);
end;

Destructor TBHRText.Destroy;
begin
  FStrings.Free;
  SetLength(FLineProps, 0);
  FFont.Free;
  FBrush.Free;
  FPen.Free;
  Inherited;
end;

Function TBHRText.GetString(i : integer) : string;
begin
  Result:= '';
  if (i >= 0) and (i < FStrings.Count) then
    Result:= FStrings[i];
end;

Procedure TBHRText.SetString(i : integer; s : string);
begin
  if (i >= 0) and (i < FStrings.Count) then
    FStrings[i]:= s
  else if (i > FStrings.Count - 1) then
    AddString(s)
  else if (i < 0) then
    InsertString(s, 0, twBelow);
end;

Procedure TBHRText.AddString(s : string);
var i : integer;
begin
  FStrings.Add(s);
  SetLength(FLineProps, High(FLineProps) + 2);
  i:= High(FLineProps);
  FLineProps[i].Rect.Left:= FRect.Left;
  FLineProps[i].Rect.Right:= FRect.Right;
  FLineProps[i].PageNr:= FPageNrS;
  FLineProps[i].TextRect.Left:= FRect.Left + FMarge;
  FLineProps[i].TextRect.Right:= FRect.Right - FMarge;
  FKeepTogether:= false;
end;

Procedure TBHRText.RemoveString(i : integer);
var j : integer;
begin
  if (i >= 0) and (i < FStrings.Count) then
  begin
    FStrings.Delete(i);
    for j:= i to High(FLineProps) - 1 do
      FLineProps[j]:= FLineProps[j-1];
    SetLength(FLineProps, High(FLineProps));
  end;
end;

Procedure TBHRText.InsertString(s : string; i : integer; Where : TWhere);
var j : integer;
begin
  if (i >= 0) and (i < FStrings.Count) then
    case Where of
    twAbove:
     begin
        FStrings.Insert(i, s);
        SetLength(FLineProps, High(FLineProps) + 2);
        for j:= High(FLineProps) downto i + 1 do
          FLineProps[j]:= FLineProps[j-1];
        FLineProps[i].Rect.Left:= FRect.Left;
        FLineProps[i].Rect.Right:= FRect.Right;
        FLineProps[i].PageNr:= FPageNrS;
        FLineProps[i].TextRect.Left:= FRect.Left + FMarge;
        FLineProps[i].TextRect.Right:= FRect.Right - FMarge;
     end;
    twBelow:
      if i = 0 then
      begin
        FStrings.Add('');
        for j:= FStrings.Count - 1 to 1 do
          FStrings[j]:= FStrings[j-1];
        FStrings[0]:= s;
        SetLength(FLineProps, High(FLineProps) + 2);
        for j:= High(FLineProps) downto 1 do
          FLineProps[j]:= FLineProps[j-1];
        FLineProps[0].Rect.Left:= FRect.Left;
        FLineProps[0].Rect.Right:= FRect.Right;
        FLineProps[0].PageNr:= FPageNrS;
        FLineProps[0].TextRect.Left:= FRect.Left + FMarge;
        FLineProps[0].TextRect.Right:= FRect.Right - FMarge;
      end
      else
      begin
        FStrings.Insert(i-1, s);
        SetLength(FLineProps, High(FLineProps) + 2);
        for j:= High(FLineProps) downto i + 1 do
          FLineProps[j]:= FLineProps[j-1];
        FLineProps[i].Rect.Left:= FRect.Left;
        FLineProps[i].Rect.Right:= FRect.Right;
        FLineProps[i].PageNr:= FPageNrS;
        FLineProps[i].TextRect.Left:= FRect.Left + FMarge;
        FLineProps[i].TextRect.Right:= FRect.Right - FMarge;
      end;
    end;
end;

Procedure TBHRText.SetMarge(w : word);
begin
  if FMarge <> w then FMarge:= w;
end;

Procedure TBHRText.Move(PNr, Tp : word);
var i, j, t, h: integer;
    tot, LL, LMarge, w,fh : LongInt;
    s : string;
begin
  Inherited Move(PNr, Tp);
  FFontHeight:= round(1.2 * FontSizeToPix(FFont.Size, 1));
  if (High(FLineProps) >= 0) then
  begin
    if FCheckBoxes then LMarge:= 2 * FMarge + FCheckBoxSize + 2 * FMarge
    else LMarge:= 2 * FMarge;
    tot:= 0;
    FLineProps[0].Rect.Top:= FRect.Top;
    FLineProps[0].TextRect.Top:= FRect.Top + FMarge;
    for i:= 0 to FStrings.Count - 1 do
    begin
      if i = 0 then FLineProps[i].PageNr:= FPageNrS
      else FLineProps[i].PageNr:= FLineProps[i-1].PageNr;
      FLineProps[i].TextRect.Left:= FRect.Left + LMarge;
      FLineProps[i].TextRect.Right:= FRect.Right - 2 * FMarge;
      if i > 0 then
      begin
        FLineProps[i].Rect.Top:= FLineProps[i-1].Rect.Bottom;
        FLineProps[i].PageNr:= FLineProps[i-1].PageNr;
      end;
      FLineProps[i].TextRect.Top:= FLineProps[i].Rect.Top + FMarge;
      s:= FStrings[i];
      w:= FLineProps[i].TextRect.Right - FLineProps[i].TextRect.Left;
      if FAutoSize and (w > 0) then
      begin
        fh:= FFont.Height;
        FFont.Height:= FFontHeight;
        LL:= CalcAmountLines2(FFont, s, w);
        FFont.Height:= fh;
      end
      else
       LL:= 1;

      LL:= LL * FFontHeight;
      FLineProps[i].TextRect.Bottom:= FLineProps[i].TextRect.Top + LL;
      FLineProps[i].Rect.Bottom:= FLineProps[i].TextRect.Bottom + FMarge;
      t:= FLineProps[i].Rect.Bottom - FLineProps[i].Rect.Top;
      if (FLineProps[i].Rect.Bottom > FDocument.FPrintRect.Bottom) and
         ((not FKeepTogether) or (i = 0))then
      begin
        FLineProps[i].PageNr:= FLineProps[i].PageNr + 1;
        FPageNrE:= FPageNrE + 1;
        if i = 0 then FPageNRS:= FPageNRE;
        FLineProps[i].Rect.Top:= FDocument.FPrintRect.Top;
        FLineProps[i].Rect.Bottom:= FLineProps[i].Rect.Top + t;
        FLineProps[i].TextRect.Top:=  FLineProps[i].Rect.Top + FMarge;
        FLineProps[i].TextRect.Bottom:=  FLineProps[i].Rect.Bottom - FMarge;
      end;
      if (i > 0) and FKeepTogether and (FLineProps[i-1].PageNr < FLineProps[i].PageNr) then
      begin
        FPageNrS:= FPageNRE;
        for j:= 0 to i do
        begin
          h:= FLineProps[j].Rect.Bottom - FLineProps[j].Rect.Top;
          if j = 0 then FLineProps[j].Rect.Top:= FDocument.FPrintRect.Top
          else FLineProps[j].Rect.Top:= FLineProps[j-1].Rect.Bottom;
          FLineProps[j].Rect.Bottom:= FLineProps[j].Rect.Top + h;
          FLineProps[j].TextRect.Top:=  FLineProps[j].Rect.Top + FMarge;
          FLineProps[j].TextRect.Bottom:=  FLineProps[j].Rect.Bottom - FMarge;
          FLineProps[j].PageNr:= FPageNrS;
        end;
        if (FLineProps[i].Rect.Bottom > FDocument.FPrintRect.Bottom) and FKeeptogether then
        //lines do not fit on the page all, so Keeptogether cannot be implemented
        begin
          FKeeptogether:= false;
          CalcRect;
        end;
      end;
      tot:= tot + t;
    end;
    FRect.Top:= FLineProps[0].Rect.Top;
    FRect.Bottom:= FLineProps[FStrings.Count - 1].Rect.Bottom;
  end
  else //make the text at least 1 line high
  begin
    FRect.Bottom:= FRect.Top + FFontHeight;
  end;
end;

Procedure TBHRText.CalcRect;
//Calculate the height of the text given the width and font size
var i, j, t, h: integer;
    tot, LL, LMarge, w,fh : LongInt;
    s : string;
begin
  Inherited CalcRect;
  FFontHeight:= round(1.2 * FontSizeToPix(FFont.Size, 1));
  if (High(FLineProps) >= 0) then
  begin
    if FCheckBoxes then LMarge:= 2 * FMarge + FCheckBoxSize + 2 * FMarge
    else LMarge:= 2 * FMarge;
    tot:= 0;
    FLineProps[0].Rect.Top:= FRect.Top;
    FLineProps[0].TextRect.Top:= FRect.Top + FMarge;
    for i:= 0 to FStrings.Count - 1 do
    begin
      if i = 0 then FLineProps[i].PageNr:= FPageNrS
      else FLineProps[i].PageNr:= FLineProps[i-1].PageNr;
      FLineProps[i].TextRect.Left:= FRect.Left + LMarge;
      FLineProps[i].TextRect.Right:= FRect.Right - 2 * FMarge;
      if i > 0 then
      begin
        FLineProps[i].Rect.Top:= FLineProps[i-1].Rect.Bottom;
        FLineProps[i].PageNr:= FLineProps[i-1].PageNr;
      end;
      FLineProps[i].TextRect.Top:= FLineProps[i].Rect.Top + FMarge;
      s:= FStrings[i];
      w:= FLineProps[i].TextRect.Right - FLineProps[i].TextRect.Left;
      if FAutoSize and (w > 0) then
      begin
        fh:= FFont.Height;
        FFont.Height:= FFontHeight;
        LL:= CalcAmountLines2(FFont, s, w);
        FFont.Height:= fh;
      end
      else
       LL:= 1;

      LL:= LL * FFontHeight;
      FLineProps[i].TextRect.Bottom:= FLineProps[i].TextRect.Top + LL;
      FLineProps[i].Rect.Bottom:= FLineProps[i].TextRect.Bottom + FMarge;
      t:= FLineProps[i].Rect.Bottom - FLineProps[i].Rect.Top;
      if (FLineProps[i].Rect.Bottom > FDocument.FPrintRect.Bottom) and
         ((not FKeepTogether) or (i = 0))then
      begin
        FLineProps[i].PageNr:= FLineProps[i].PageNr + 1;
        FPageNrE:= FPageNrE + 1;
        if i = 0 then FPageNRS:= FPageNRE;
        FLineProps[i].Rect.Top:= FDocument.FPrintRect.Top;
        FLineProps[i].Rect.Bottom:= FLineProps[i].Rect.Top + t;
        FLineProps[i].TextRect.Top:=  FLineProps[i].Rect.Top + FMarge;
        FLineProps[i].TextRect.Bottom:=  FLineProps[i].Rect.Bottom - FMarge;
      end;
      if (i > 0) and FKeepTogether and (FLineProps[i-1].PageNr < FLineProps[i].PageNr) then
      begin
        FPageNrS:= FPageNRE;
        for j:= 0 to i do
        begin
          h:= FLineProps[j].Rect.Bottom - FLineProps[j].Rect.Top;
          if j = 0 then FLineProps[j].Rect.Top:= FDocument.FPrintRect.Top
          else FLineProps[j].Rect.Top:= FLineProps[j-1].Rect.Bottom;
          FLineProps[j].Rect.Bottom:= FLineProps[j].Rect.Top + h;
          FLineProps[j].TextRect.Top:=  FLineProps[j].Rect.Top + FMarge;
          FLineProps[j].TextRect.Bottom:=  FLineProps[j].Rect.Bottom - FMarge;
          FLineProps[j].PageNr:= FPageNrS;
        end;
        if (FLineProps[i].Rect.Bottom > FDocument.FPrintRect.Bottom) and FKeeptogether then
        //lines do not fit on the page all, so Keeptogether cannot be implemented
        begin
          FKeeptogether:= false;
          CalcRect;
        end;
      end;
      tot:= tot + t;
    end;
    FRect.Top:= FLineProps[0].Rect.Top;
    FRect.Bottom:= FLineProps[FStrings.Count - 1].Rect.Bottom;
  end
  else //make the text at least 1 line high
  begin
    FRect.Bottom:= FRect.Top + FFontHeight;
  end;
  DeployKeepWithNext;
end;

Procedure TBHRText.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var i : integer;
    s : string;
    t, mh : LongInt;
    fsz : word;
    OFont : TFont;
    OBrush : TBrush;
    OPen : TPen;
    cbR : TRect;
    SRect : TRect;
begin
  if (FPageNrS <= PNr) and (FPageNrE >= PNr) then
  begin
    t:= FRect.Top;
    OFont:= TFont.Create;
    OBrush:= TBrush.Create;
    OPen:= TPen.Create;
    OFont.Assign(Cnvs.Font);
    OBrush.Assign(Cnvs.Brush);
    OPen.Assign(Cnvs.Pen);
    Cnvs.Font.Assign(FFont);

    Cnvs.Brush.Assign(FBrush);
    Cnvs.Pen.Color:= Cnvs.Brush.Color;
    Cnvs.Pen.Width:= 0;
    if FRect.Bottom < FRect.Top then //Text spans more pages
    begin
      CbR:= FRect;
      if PNr = FPageNrS then
      begin
        CbR.Bottom:= FDocument.PrintRect.Bottom;
      end
      else if (PNr > FPageNrS) and (PNr < FPageNrE) then
      begin
        CbR.Top:= FDocument.PrintRect.Top;
        CbR.Bottom:= FDocument.PrintRect.Bottom;
      end
      else if PNr = FPageNrE then
      begin
        CbR.Top:= FDocument.PrintRect.Top;
      end;
      SRect:= ScaleRect(CbR, Scale);
    end
    else
    begin
      SRect:= ScaleRect(FRect, Scale);
    end;
    Cnvs.Rectangle(SRect);

    for i:= 0 to FStrings.Count - 1 do
      if FLineProps[i].PageNr = PNr then
      begin
        Cnvs.Pen.Assign(FPen);
        cnvs.Pen.Style:= psSolid;
        cnvs.Pen.Color:= clBlack;
        Cnvs.Brush.Color:= clWhite;
        fsz:= FFont.Size;
        if FCheckBoxes then
        begin
          cbR.Top:= FLineProps[i].TextRect.Top;
          cbR.Bottom:= cbR.Top + FontSizeToPix(fsz, 1);
          cbR.Left:= FRect.Left + FMarge;
          cbR.Right:= cbR.Left + FontSizeToPix(fsz, 1);
          cbR:= ScaleRect(cbR, Scale);
          Cnvs.Rectangle(cbR);
          if FChecked then
          begin
            Cnvs.MoveTo(cbR.Left, cbR.Top);
            Cnvs.LineTo(cbR.Right, cbR.Bottom);
            Cnvs.MoveTo(cbR.Right, cbR.Top);
            Cnvs.LineTo(cbR.Left, cbR.Bottom);
          end;
        end;

        Cnvs.Font.Height:= FontSizeToPix(fsz, Scale);
        SRect:= ScaleRect(FLineProps[i].TextRect, Scale);
        mh:= Round((SRect.Bottom + SRect.Top) / 2);
        s:= FStrings[i];
        t:= t + DrawTxt(Cnvs, mh, SRect.Left, SRect.Right, s, FAlignment, TRUE);
        Cnvs.Font.Size:= fsz;
      end;

    Cnvs.Font.Assign(OFont);
    Cnvs.Brush.Assign(OBrush);
    Cnvs.Pen.Assign(OPen);
    OFont.Free;
    OBrush.Free;
    OPen.Free;
  end;
end;

{============================TBHRCell =========================================}

Constructor TBHRCell.Create(D : TBHRDocument; R, C : integer);
begin
  Inherited Create(D);
  FText := TBHRText.Create(D);
  FText.Cell:= self;
  FText.AutoSize:= false;
  FTable:= NIL;
  FRow:= R;
  FColumn:= C;
end;

Destructor TBHRCell.Destroy;
begin
  FText.Free;
  Inherited Destroy;
end;

Procedure TBHRCell.SetLeft(l : word);
begin
  Inherited SetLeft(l);
  if FText <> NIL then
    FText.Left:= l;
end;

Procedure TBHRCell.SetRight(r : word);
begin
  Inherited SetRight(r);
  if FText <> NIL then
    FText.Right:= r;
end;

procedure TBHRCell.SetTop(t : word);
begin
  Inherited SetTop(t);
  if FText <> NIL then
  begin
    FText.Top:= t;
 //   FText.CalcRect;
  end;
end;

Procedure TBHRCell.SetBottom(b : word);
begin
  Inherited SetBottom(b);
  if FText <> NIL then
    FText.Bottom:= b;
end;

Procedure TBHRCell.SetKeepTogether(b : boolean);
begin
  if FKeepTogether <> b then
  begin
    FKeepTogether:= b;
    FKeepWithNext:= b;
    FText.KeepTogether:= b;
    FText.KeepWithNext:= b;
  end;
end;

Function TBHRCell.GetFont : TFont;
begin
  Result:= NIL;
  if FText <> NIL then Result:= FText.Font;
end;

Function TBHRCell.GetBrush : TBrush;
begin
  Result:= NIL;
  if FText <> NIL then Result:= FText.Brush;
end;

Function TBHRCell.GetPen : TPen;
begin
  Result:= NIL;
  if FText <> NIL then Result:= FText.Pen;
end;

Function TBHRCell.GetAlignment : TAlignment;
begin
  Result:= taLeftJustify;
  if FText <> NIL then Result:= FText.Alignment;
end;

Procedure TBHRCell.SetAlignment(al : TAlignment);
begin
  if FText <> NIL then FText.Alignment:= al;
end;

Function TBHRCell.GetKeepTogether : boolean;
begin
  Result:= TRUE;
  if FText <> NIL then Result:= FText.KeepTogether;
end;

Function TBHRCell.GetMarge : word;
begin
  Result:= 0;
  if FText <> NIL then Result:= FText.Marge;
end;

Procedure TBHRCell.SetMarge(w : word);
begin
  if FText <> NIL then FText.Marge:= w;
end;

Function TBHRCell.GetAutoSize : boolean;
begin
  Result:= false;
  if FText <> NIL then Result:= FText.AutoSize;
end;

Procedure TBHRCell.SetAutoSize(b : boolean);
begin
  if FText <> NIL then FText.AutoSize:= b;
end;

Function TBHRCell.GetCheckBoxes : boolean;
begin
  Result:= false;
  if FText <> NIL then Result:= FText.CheckBoxes;
end;

Procedure TBHRCell.SetCheckBoxes(b : boolean);
begin
  if FText <> NIL then FText.CheckBoxes:= b;
end;

Function TBHRCell.GetCheckBoxSize : LongInt;
begin
  Result:= 0;
  if FText <> NIL then Result:= FText.CheckBoxSize;
end;

Procedure TBHRCell.SetCheckBoxSize(L : LongInt);
begin
  if FText <> NIL then FText.CheckBoxSize:= L;
end;

Procedure TBHRCell.SetNext(E : TBHRElement);
begin
  Inherited SetNext(E);
  FText.Next:= E;
end;

Procedure TBHRCell.SetPrior(E : TBHRElement);
begin
  Inherited SetPrior(E);
  FText.Prior:= E;
end;

Procedure TBHRCell.SetPageNrS(i : integer);
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    Inherited SetPageNrS(i);
    FText.PageNrS:= i;
  end;
end;

Procedure TBHRCell.SetPageNrE(i : integer);
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    Inherited SetPageNrE(i);
    FText.PageNrE:= i;
  end;
end;

Procedure TBHRCell.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
begin
  if FText <> NIL then FText.Draw(Cnvs, Pnr, Scale);
end;

Procedure TBHRCell.Move(PNr, Tp : word);
begin
  if (FRow = 0) and (FColumn = 0) and (FTable <> NIL) then FTable.Move(PNr, Tp);
{  if FText <> NIL then FText.Move(PNr, Tp);
  FRect:= FText.Rect;
  FPageNrS:= FText.PageNrS;
  FPageNrE:= FText.PageNrE;}
end;

Procedure TBHRCell.CalcRect;
begin
  Inherited CalcRect;
  if FText <> NIL then FText.CalcRect;
  FRect:= FText.Rect;
  FPageNrS:= FText.PageNrS;
  FPageNrE:= FText.PageNrE;
  DeployKeepWithNext;
end;

{========================== TBHRTable =========================================}

Constructor TBHRTable.Create(D : TBHRDocument);
begin
  Inherited Create(D);
  FAutoSizeCells := false;
  FColsEven := TRUE;
  FKeepTogether:= TRUE;
end;

Destructor TBHRTable.Destroy;
var R, C : integer;
begin
  for R:= Low(FCells) to High(FCells) do
  begin
    for C:= Low(FCells[R]) to High(FCells[R]) do
      FCells[R, C].Free;
    SetLength(FCells[R], 0);
  end;
  SetLength(FCells, 0);
  Inherited Destroy;
end;

Function TBHRTable.GetCell(aRow, aCol : integer) : TBHRCell;
begin
  if (aRow >= Low(FCells)) and (aRow <= High(FCells)) then
    if (aCol >= Low(FCells[aRow])) and (aCol <= High(FCells[aRow])) then
      Result:= FCells[aRow, aCol];
end;

Procedure TBHRTable.SetSize(NRows, NCols : integer);
var R, C : integer;
begin
  SetLength(FCells, NRows);
  for R:= 0 to NRows - 1 do
  begin
    SetLength(FCells[R], NCols);
    for C:= 0 to NCols - 1 do
    begin
      if FCells[R, C] = NIL then
      begin
        FCells[R, C]:= TBHRCell.Create(FDocument, R, C);
        FCells[R, C].Table:= self;
        if C = 0 then FCells[R, C].Left:= FRect.Left
        else FCells[R, C].Left:= FCells[R, C-1].Right;
        if R = 0 then
        begin
          FCells[R, C].Top:= FRect.Top;
        end
        else
        begin
          FCells[R, C].Top:= FCells[R-1, C].Bottom;
          FCells[R, C].Prior:= FCells[R-1, C];
          FCells[R-1, C].Next:= FCells[R, C];
        end;
      end;
      FCells[R, C].Keeptogether:= FKeepTogether;
    end;
  end;
  SetColsEven(TRUE);
end;

Function TBHRTable.NumRows : integer;
begin
  Result:= High(FCells) + 1;
end;

Function TBHRTable.NumCols : integer;
begin
  Result:= 0;
  if NumRows > 0 then
    Result:= High(FCells[0]) + 1;
end;

Procedure TBHRTable.SetKeepTogether(b : boolean);
var C, R : integer;
begin
  FKeepTogether:= b;
  for R:= 0 to NumRows - 2 do
    for C:= 0 to NumCols - 1 do
      FCells[R, C].KeepWithNext:= b;
  FDocument.CalcRects;
end;

Function TBHRTable.GetRowColor(i : word) : TColor;
begin
  Result:= clWhite;
  if (i >= Low(FCells)) and (i <= High(FCells)) then
    Result:= FCells[i, 0].Brush.Color;
end;

Procedure TBHRTable.SetRowColor(i : word; cl : TColor);
var j : integer;
begin
  if (i >= Low(FCells)) and (i <= High(FCells)) then
    for j:= Low(FCells[i]) to High(FCells[i]) do
    begin
      FCells[i, j].Brush.Color:= cl;
      FCells[i, j].Brush.Style:= bsSolid;
    end;
end;

Function TBHRTable.GetColColor(i : word) : TColor;
begin
  Result:= clWhite;
  if (i >= Low(FCells[0])) and (i <= High(FCells[0])) then
    Result:= FCells[0, i].Brush.Color;
end;

Procedure TBHRTable.SetColColor(i : word; cl : TColor);
var j : integer;
begin
  if (i >= Low(FCells[0])) and (i <= High(FCells[0])) then
    for j:= Low(FCells) to High(FCells) do
    begin
      FCells[j, i].Brush.Color:= cl;
      FCells[j, i].Brush.Style:= bsSolid;
    end;
end;

Function TBHRTable.GetColWidth(aCol : integer) : word;
var C : TBHRCell;
begin
  Result:= 0;
  C:= GetCell(0, aCol);
  if C <> NIL then Result:= C.Rect.Right - C.Rect.Left;
end;

Procedure TBHRTable.SetColWidth(aCol : integer; Width : word);
var Cell, Cell2 : TBHRCell;
    R : integer;
begin
  FColsEven:= false;
  for R:= 0 to NumRows - 1 do
  begin
    Cell:= GetCell(R, aCol);
    if Cell <> NIL then
    begin
      if aCol = 0 then
      begin
        //Cell.FText.Left:= FRect.Left;
        Cell.Left:= FRect.Left;
      end
      else
      begin
        Cell2:= GetCell(R, aCol-1);
        if Cell2 <> NIL then
        begin
          //Cell.FText.Left:= Cell2.Rect.Right;
         Cell.Left:= Cell2.Rect.Right;
        end;
      end;
      //Cell.FText.Right:= Cell.Rect.Left + Width;
      Cell.Right:= Cell.Rect.Left + Width;
    end;
  end;
end;

Procedure TBHRTable.SetColsEven(b : boolean);
var Cell, Cell2, Cell1 : TBHRCell;
    R, C : integer;
    W : single;
begin
  FColsEven:= b;
  if b and (NumCols > 0) then
  begin
    W:= (FRect.Right - FRect.Left) / NumCols;
    for R:= 0 to NumRows - 1 do
    begin
      Cell1:= GetCell(R, 0);
      for C:= 0 to NumCols - 1 do
      begin
        Cell:= GetCell(R, C);
        if Cell <> NIL then
        begin
          if C = 0 then
            Cell.FText.Left:= FRect.Left
          else
          begin
            Cell2:= GetCell(R, C-1);
            if Cell2 <> NIL then
              Cell.FText.Left:= Cell2.Rect.Right;
          end;
          Cell.Right:= Cell1.Left + round((C + 1) * W);
        end;
      end;
    end;
  end;
end;

Function TBHRTable.GetRowHeight(aRow : integer) : word;
var C : TBHRCell;
begin
  Result:= 0;
  C:= GetCell(aRow, 0);
  if C <> NIL then Result:= C.Rect.Bottom - C.Rect.Top;
end;

Procedure TBHRTable.SetRowHeight(ARow : integer; Height : word);
var Cell, Cell2 : TBHRCell;
    C : integer;
begin
  for C:= 0 to NumCols - 1 do
  begin
    Cell:= GetCell(aRow, C);
    if Cell <> NIL then
    begin
      if aRow = 0 then
        Cell.FText.Top:= FRect.Top
      else
      begin
        Cell2:= GetCell(aRow-1, C);
        if Cell2 <> NIL then
          Cell.FText.Left:= Cell2.Rect.Bottom;
      end;
      Cell.FText.Bottom:= Cell.FText.Top + Height;
    end;
  end;
end;

Procedure TBHRTable.SetAutoSizeCells(b : boolean);
var C, R : integer;
begin
  FAutoSizeCells:= b;
  for R:= 0 to NumRows - 1 do
    for C:= 0 to NumCols - 1 do
      FCells[R, C].AutoSize:= b;
  FDocument.CalcRects;
end;

Procedure TBHRTable.SetPageNrS(i : integer);
var C, R : integer;
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    Inherited SetPageNrS(i);
    for R:= 0 to NumRows - 1 do
      for C:= 0 to NumCols - 1 do
        FCells[R, C].PageNrS:= i;
  end;
end;

Procedure TBHRTable.SetPageNrE(i : integer);
var C, R : integer;
begin
  if (i > 0) {and (i <= FDocument.NumPages)} then
  begin
    Inherited SetPageNrE(i);
    for R:= 0 to NumRows - 1 do
      for C:= 0 to NumCols - 1 do
        FCells[R, C].PageNrE:= i;
  end;
end;

Procedure TBHRTable.AddRow;
var C, R : integer;
    Cell : TBHRCell;
begin
  SetLength(FCells, High(FCells) + 2);
  SetLength(FCells[High(FCells)], NumCols);
  R:= High(FCells);
  for C:= 0 to NumCols - 1 do
  begin
    FCells[R, C]:= TBHRCell.Create(FDocument, R, C);
    FCells[R, C].Table:= self;
    FCells[R, C].Keeptogether:= FKeeptogether;
    if (R > 0) then
    begin
      Cell:= GetCell(R-1, C);
      if Cell <> NIL then
      begin
      {  if (not FAutoHeight) then
        begin
          FCells[R, C].Top:= Cell.Bottom;
          FCells[R, C].Bottom:= Cell.Bottom + (Cell.Bottom - Cell.Top);
        end; }
        FCells[R, C].Left:= Cell.Left;
        FCells[R, C].Right:= Cell.Right;
        FCells[R, C].Prior:= Cell;
        Cell.Next:= FCells[R, C];
      end;
    end
    else
    begin
      FCells[R, C].Top:= FRect.Top;
      FCells[R, C].Bottom:= FRect.Bottom;
      if C = 0 then
      begin
        FCells[R, C].Left:= FRect.Left;
        if NumCols = 0 then
          FCells[R, C].Right:= FRect.Right
        else
          FCells[R, C].Right:= FRect.Left + round((FRect.Right - FRect.Left) / NumCols);
      end
      else
      begin
        Cell:= GetCell(R, C-1);
        FCells[R, C].Left:= Cell.Right;
        FCells[R, C].Right:= FRect.Left + round((C + 1) * (FRect.Right - FRect.Left) / NumCols);
      end;
    end;
  end;
end;

Procedure TBHRTable.AddCol;
var C, R : integer;
    Cell : TBHRCell;
begin
  for R:= 0 to High(FCells) do
  begin
    SetLength(FCells[R], High(FCells[R]) + 2);
    C:= High(FCells[R]);
    FCells[R, C]:= TBHRCell.Create(FDocument, R, C);
    FCells[R, C].Table:= self;
    FCells[R, C].Keeptogether:= FKeepTogether;
    if R > 0 then
    begin
      FCells[R, C].Prior:= FCells[R-1, C];
      FCells[R-1, C].Next:= FCells[R, C];
    end;
  end;

  if FColsEven then SetColsEven(TRUE)
  else if C > 0 then
  begin
    for R:= 0 to High(FCells) do
    begin
      Cell:= GetCell(R, C-1);
      FCells[R, C].Top:= Cell.Top;
      FCells[R, C].Bottom:= Cell.Bottom;
      FCells[R, C].Left:= Cell.Right;
      FCells[R, C].Right:= Cell.Right + (Cell.Right - Cell.Left);
    end;
  end
  else
  begin
    for R:= 0 to High(FCells) do
    begin
      FCells[R, C].Left:= FRect.Right;
      FCells[R, C].Right:= FRect.Left;
    end;
{    if not FAutoHeight then
    begin
      FCells[0, C].Top:= FRect.Top;
      if NumRows > 0 then
        FCells[0, C].Bottom:= FRect.Top + round((FRect.Bottom - FRect.Top) / NumRows)
      else FCells[0, C].Bottom:= FRect.Bottom;
      for R:= 1 to High(FCells) do
      begin
        Cell:= GetCell(R-1, C);
        FCells[R, C].Top:= Cell.Top;
        FCells[R, C].Bottom:= FRect.Top + round((R + 1) * (FRect.Bottom - FRect.Top) / NumRows);
        FCells[R, C].Left:= FRect.Right;
        FCells[R, C].Right:= FRect.Left;
      end;
    end;}
  end;
end;

Procedure TBHRTable.Draw(Cnvs : TCanvas; Pnr : integer; Scale : single);
var R, C : integer;
begin
  for R:= 0 to NumRows - 1 do
    for C:= 0 to NumCols - 1 do
      FCells[R, C].Draw(Cnvs, PNr, Scale);
end;

Procedure TBHRTable.Move(PNr, Tp : word);
var R, C, PaNr : integer;
    MaxH : word;
    RTp : LongInt;
    Cell : TBHRCell;
begin
  Inherited Move(PNr, Tp);
  RTp:= FRect.Top;
  MaxH:= 0;
  PaNr:= FPageNrS;
  for R:= 0 to NumRows - 1 do
  begin
    //first, calculate the height of every cell in row R
    for C:= 0 to NumCols - 1 do
    begin
      Cell:= FCells[R, C];
      if R = 0 then
      begin
        Cell.PageNrS:= FPageNrS;
        Cell.PageNrE:= FPageNrS;
        Cell.Top:= RTp;
      end
      else
      begin
        Cell.PageNrS:= FCells[R-1, C].FPageNrE;
        Cell.PageNrE:= Cell.FPageNrS;
      end;
      Cell.CalcRect;
    end;

    //then find the maximum height of the cells in row R
    MaxH:= 0;
    for C:= 0 to NumCols - 1 do
    begin
      Cell:= FCells[R, C];
      if (Cell.Bottom - Cell.Top) > MaxH then
        MaxH:= Cell.Bottom - Cell.Top;
      if Cell.PageNrE > FPageNrE then
        PaNr:= Cell.PageNrE;
    end;
    if PaNr > FPageNrE then
    begin
      for C:= 0 to NumCols - 1 do
      begin
        Cell:= FCells[R, C];
        Cell.Top:= FDocument.PrintRect.Top;
        Cell.PageNrS:= PaNr;
        Cell.PageNrE:= PaNr;
      end;
      FPageNrE:= PaNr;
    end;
    RTp:= FCells[R, 0].Top + MaxH;
    for C:= 0 to NumCols - 1 do
      FCells[R, C].Bottom:= RTp;
  end;

  Cell:= FCells[NumRows-1, NumCols-1];
  Bottom:= Cell.Bottom;
  FPageNrE:= Cell.PageNrE;
end;

Procedure TBHRTable.CalcRect;
  Procedure DoCalcRect;
  var R, C, PNr : integer;
      MaxH, RTp : word;
      Cell : TBHRCell;
  begin
    RTp:= FRect.Top;
    MaxH:= 0;
    PNr:= FPageNrS;
    for R:= 0 to NumRows - 1 do
    begin
      //first, calculate the height of every cell in row R
      for C:= 0 to NumCols - 1 do
      begin
        Cell:= FCells[R, C];
        if R = 0 then
        begin
          Cell.PageNrS:= FPageNrS;
          Cell.PageNrE:= FPageNrS;
          Cell.Top:= RTp;
        end
        else
        begin
         { Cell.PageNrS:= FCells[R-1, C].FPageNrE;
          Cell.PageNrE:= Cell.FPageNrS;}
        end;
        Cell.CalcRect;
      end;

      //then find the maximum height of the cells in row R
      MaxH:= 0;
      for C:= 0 to NumCols - 1 do
      begin
        Cell:= FCells[R, C];
        if (Cell.Bottom - Cell.Top) > MaxH then
          MaxH:= Cell.Bottom - Cell.Top;
        if Cell.PageNrE > FPageNrE then
          PNr:= Cell.PageNrE;
      end;
      if PNr > FPageNrE then
      begin
        for C:= 0 to NumCols - 1 do
        begin
          Cell:= FCells[R, C];
          Cell.Top:= FDocument.PrintRect.Top;
          Cell.PageNrS:= PNr;
          Cell.PageNrE:= PNr;
        end;
        FPageNrE:= PNr;
      end;
      RTp:= FCells[R, 0].Top + MaxH;
      for C:= 0 to NumCols - 1 do
        FCells[R, C].Bottom:= RTp;
    end;

    Cell:= FCells[NumRows-1, NumCols-1];
    Bottom:= Cell.Bottom;
    FPageNrE:= Cell.PageNrE;
  end;

begin
  Inherited CalcRect;

  DoCalcRect;

  if FKeepTogether and (FPageNrE > FPageNrS) then
  begin
    if FPageNrE - FPageNRS > 1 then //cannot keep together
    begin
      KeepTogether:= false;
    end
    else //place table on FPageNRE
    begin
      FPageNRS:= FPageNrE;
      FRect.Top:= FDocument.PrintRect.Top;
    end;
    DoCalcRect;
  end;

  DeployKeepWithNext;
end;

{====================== TBHRDocument ==========================================}

Constructor TBHRDocument.Create;
begin
  Inherited;
  FNumPages:= 1;
  FMarginBT := 2; //cm
  FMarginLR := 1.5; //cm
  GetPrinterProps;
  FHeader:= TBHRHeader.Create(self, thHeader);
  FFooter:= TBHRHeader.Create(self, thFooter);
end;

Destructor TBHRDocument.Destroy;
var i : integer;
begin
  FHeader.Free;
  FFooter.Free;
  for i:= 0 to High(FElements) do
    FElements[i].Free;
  SetLength(FElements, 0);
  Inherited;
end;

Function TBHRDocument.GetLineHeight(fh : integer) : integer;
begin
  Result:= Round(1.0 * FontSizeToPix(fh, 1));
end;

Procedure TBHRDocument.GetPrinterProps;
var dx : word;
    dy : word;
begin
  if Printer <> NIL then
  begin
    dx:= Printer.XDPI;
    dy:= Printer.YDPI;
    FMarginBTpx := round(FMarginBT / 2.54 * dy);
    FMarginLRpx := round(FMarginLR / 2.54 * dx);

    FPageRect.Top:= 0;
    FPageRect.Left:= 0;
    FPageRect.Right:= Printer.PageWidth;
    FPageRect.Bottom:= Printer.PageHeight;

    FPrintRect.Top:= FMarginBTpx;
    FPrintRect.Bottom:= Printer.PageHeight - FMarginBTpx;
    FPrintRect.Left:= FMarginLRpx;
    FPrintRect.Right:= Printer.PageWidth - FMarginLRpx;
  end
  else
  begin
    dx:= 600;
    dy:= 600;
    FMarginBTpx := round(FMarginBT / 2.54 * dy);
    FMarginLRpx := round(FMarginLR / 2.54 * dx);

    FPageRect.Top:= 0;
    FPageRect.Left:= 0;
    FPageRect.Right:= round(21.0 / 2.54 * 600);
    FPageRect.Bottom:= round(29.7 / 2.54 * 600);

    FPrintRect.Top:= FMarginBTpx;
    FPrintRect.Bottom:= round(29.7 / 2.54 * 600) - FMarginBTpx;
    FPrintRect.Left:= FMarginLRpx;
    FPrintRect.Right:= round(21.0 / 2.54 * 600) - FMarginLRpx;
  end;
end;

Function TBHRDocument.GetNumElements : integer;
begin
  Result:= High(FElements) + 1;
end;

Function Overlap(R1, R2 : TRect) : boolean;
var R : TRect;
begin
  Result:= Intersectrect(R, R1, R2);
end;

Procedure TBHRDocument.CalcRects;
var i  : integer;
    E : TBHRElement;
begin
  if FHeader <> NIL then FHeader.CalcRect;
  if FFooter <> NIL then FFooter.CalcRect;
  FLastY:= FPrintRect.Top;
  FLastPage:= 1; FNumPages:= 1;
  for i:= 0 to High(FElements) do
  begin
    E:= FElements[i];
    if i = 0 then
    begin
      E.Top:= FPrintRect.Top;
      E.PageNrS:= 1;
      E.PageNrE:= 1;
    end;
    E.CalcRect;
    FLastPage:= E.PageNrE;
    FNumPages:= FLastPage;
  end;
end;

Procedure TBHRDocument.AddPage;
begin
  Inc(FNumPages);
end;

Procedure TBHRDocument.RemovePage;
begin
  FNumPages:= FNumPages - 1;
  if FNumPages < 1 then FNumPages:= 1;
end;

Function TBHRDocument.AddSpace(Rect : TRect; h : word) : TBHRElement;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRElement.Create(self);
  Result:= FElements[High(FElements)];
  Result.Top:= FLastY;
  Result.MinHeight:= h;
  Result.Bottom:= Result.Top + h;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end;

Function TBHRDocument.AddText(Rect : TRect; s : string) : TBHRText;
var n : integer;
    line : string;
    ch : TSysCharSet;
//const lnrt = #10#13;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRText.Create(self);
  Result:= TBHRText(FElements[High(FElements)]);
  ch:= [#10];
  n:= 1; Line:= '';
  repeat
    Line:= ExtractWord(n, s, ch);
    if Line <> '' then Result.AddString(Line);
    inc(n);
  until Line = '';

//  Result.AddString(s);
  Result.Top:= FLastY;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end;

Function TBHRDocument.AddTable(Rect : TRect; nCol, nRow : integer) : TBHRTable;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRTable.Create(self);
  Result:= TBHRTable(FElements[High(FElements)]);
  Result.Top:= Rect.Top;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  Result.SetSize(nRow, nCol);
  Result.ColsEven:= TRUE;
//  Result.AutoHeight:= TRUE;
  Result.Top:= FLastY;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end;

Function TBHRDocument.AddImage(Rect : TRect) : TBHRImage;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRImage.Create(self);
  Result:= TBHRImage(FElements[High(FElements)]);
  Result.Top:= FLastY;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end;

{Function TBHRDocument.AddGraph(Rect : TRect) : TBHRBHGraph;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRBHGraph.Create(self);
  Result:= TBHRBHGraph(FElements[High(FElements)]);
  Result.Top:= FLastY;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end; }

Function TBHRDocument.AddChart(Rect : TRect) : TBHRChart;
begin
  Result:= NIL;
  CalcRects;
  SetLength(FElements, High(FElements) + 2);
  FElements[High(FElements)]:= TBHRChart.Create(self);
  Result:= TBHRChart(FElements[High(FElements)]);
  Result.Top:= FLastY;
  Result.Left:= Rect.Left;
  Result.Right:= Rect.Right;
  if High(FElements) > 0 then
  begin
    Result.Prior:= FElements[High(FElements)-1];
    FElements[High(FElements)-1].Next:= Result;
  end;
end;

Function TBHRDocument.GetElement(i : integer) : TBHRElement;
begin
  Result:= NIL;
  if (i >= Low(FElements)) and (i <= High(FElements)) then
    Result:= FElements[i];
end;

Procedure TBHRDocument.Print(FromPage, ToPage, Copies : integer);
var p, i : integer;
begin
  try
    if Printer <> NIL then
    begin
      for i:= 1 to Copies do
      begin
        Printer.BeginDoc;
        Printer.Canvas.CopyMode:= cmSrcCopy;
        for p:= FromPage to ToPage do
        begin
          DrawPage(Printer.Canvas, p, 1);
          if p < ToPage then Printer.NewPage;
        end;
        Printer.EndDoc;
      end;
    end;
  finally
  end;
end;

Procedure TBHRDocument.PrintPreview;
var fpp : TFrmPrintPreview;
begin
  CalcRects;
  fpp:= TFrmPrintPreview.Create(FrmMain);
  fpp.Execute(self);
  { try
    CalcRects;
    FrmPrintPreview:= TFrmPrintPreview.Create(FrmMain);
    FrmPrintPreview.Execute(self);
  finally
    FrmPrintPreview.Free;
    Free;
  end; }
end;

Procedure TBHRDocument.DrawPages(cnvs : TCanvas; Scale : single);
var p : integer;
begin
  if Printer <> NIL then
    for p:= 1 to FNumPages do
    begin
      DrawPage(cnvs, p, Scale);
      if p < FNumPages then Printer.NewPage;
    end;
end;

Procedure TBHRDocument.DrawPage(cnvs : TCanvas; PageNr : integer; Scale : single);
var i : integer;
    E : TBHRElement;
    SRect : TRect;
begin
  CalcRects;
  with Cnvs do
  begin
    Brush.Color:= clWhite;
    Pen.Color:= clWhite;
    SRect:= ScaleRect(FPageRect, Scale);
    Rectangle(SRect);
  end;
  FFooter.Text:= 'Bladzijde '+ IntToStr(PageNr) + ' van ' + IntToStr(NumPages);
  if FHeader <> NIL then FHeader.Draw(Cnvs, PageNr, Scale);
  if FFooter <> NIL then FFooter.Draw(Cnvs, PageNr, Scale);

  for i:= Low(FElements) to High(FElements) do
  begin
    E:= Element[i];
    if E <> NIL then
      E.Draw(cnvs, PageNr, Scale);
  end;
end;

Procedure TBHRDocument.Repaginate;
begin
  CalcRects;
end;

end.

