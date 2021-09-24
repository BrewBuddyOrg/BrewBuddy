unit FrPrintPreview;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, Printers, PrintersDlgs, BH_report, types;

type

  { TFrmPrintPreview }

  TFrmPrintPreview = class(TForm)
    bbPrior: TBitBtn;
    bbNext: TBitBtn;
    bbPrint: TBitBtn;
    bbCancel: TBitBtn;
    pdPrint: TPrintDialog;
    sbPage: TScrollBox;
    procedure bbCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bbPriorClick(Sender: TObject);
    procedure bbNextClick(Sender: TObject);
    procedure sbPageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure sbPagePaint(Sender: TObject);
    procedure bbPrintClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure sbPageMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure sbPageMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
  private
    FDocument : TBHRDocument;
    FPageNr, FPageHeight, FPageWidth : word;
    FScale, FZoomfactor : single;
    FVPage : TRect;
    Procedure SetDocument(F : TBHRDocument);
    Procedure ShowPage;
  public
    Function Execute(F : TBHRDocument) : boolean;
  published
    property Document : TBHRDocument read FDocument write SetDocument;
  end; 

var
  FrmPrintPreview, FrmPrintPreview2: TFrmPrintPreview;

implementation

uses Data, Hulpfuncties;
{$R *.lfm}

{ TFrmPrintPreview }

procedure TFrmPrintPreview.FormCreate(Sender: TObject);
begin
  FPageNr:= 0;
  FPageHeight:= sbPage.Height;
  FPageWidth:= sbPage.Width;
  FZoomFactor:= 1;
  FVPage.Left:= sbPage.Left;
  FVPage.Top:= sbPage.Top;
  FVPage.Right:= sbPage.Left + sbPage.Width;
  FVPage.Bottom:= sbPage.Top + sbPage.Height;
  bbPrint.Enabled:= (Printer <> NIL);
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmPrintPreview.bbCancelClick(Sender: TObject);
begin
  Destroy;
end;

procedure TFrmPrintPreview.FormDestroy(Sender: TObject);
begin
  FreeAndNIL(FDocument);
//  FDocument:= NIL;
end;

Function TFrmPrintPreview.Execute(F : TBHRDocument) : boolean;
begin
  SetDocument(F);
//  Result:= (ShowModal = mrOK);
  Show;
  Result:= TRUE;
end;

Procedure TFrmPrintPreview.SetDocument(F : TBHRDocument);
begin
  FDocument:= F;
  if F <> NIL then
  begin
    bbPrior.Enabled:= false;
    bbNext.Enabled:= (F.NumPages > 1);
    FPageNr:= 1;

    FormResize(self);

    ShowPage;
  end;
end;

Procedure TFrmPrintPreview.ShowPage;
var shpagerect : TRect;
begin
  if (FDocument <> NIL) and (FPageNr > 0) and (FPageNr <= FDocument.NumPages) then
  begin
    with sbPage.Canvas do
    begin
      Brush.Color:= clWhite;
      Brush.Style:= bsSolid;
      Pen.Color:= clBlack;
      Pen.Style:= psSolid;
      Pen.Width:= 2;
      shPageRect.Top:= 1;
      shPageRect.Left:= 1;
      shPageRect.Right:= Round(FScale * FZoomFactor * FDocument.PageRect.Right);
      shPageRect.Bottom:= Round(FScale * FZoomFactor * FDocument.PageRect.Bottom);
      Rectangle(shPageRect);
    end;
    FDocument.DrawPage(sbPage.Canvas, FPageNr, FZoomfactor * FScale);
  end;
end;

procedure TFrmPrintPreview.bbPriorClick(Sender: TObject);
begin
  FPageNr:= FPageNr - 1;
  sbPage.Invalidate;
  bbPrior.Enabled:= (FPageNr > 1);
  bbNext.Enabled:= (FPageNr < FDocument.NumPages);
end;

procedure TFrmPrintPreview.bbNextClick(Sender: TObject);
begin
  FPageNr:= FPageNr + 1;
  sbPage.Invalidate;
  bbNext.Enabled:= (FPageNr < FDocument.NumPages);
  bbPrior.Enabled:= (FPageNr > 1);
end;

procedure TFrmPrintPreview.sbPagePaint(Sender: TObject);
begin
  ShowPage;
end;

procedure TFrmPrintPreview.bbPrintClick(Sender: TObject);
var st, en, num : integer;
begin
  pdPrint.MinPage:= 1;
  pdPrint.MaxPage:= FDocument.NumPages;
  pdPrint.FromPage:= 1;
  pdPrint.ToPage:= FDocument.NumPages;
  if pdPrint.Execute then
  begin
    if pdPrint.PrintRange = prAllPages then
    begin
      st:= 1;
      en:= FDocument.NumPages;
    end
    else if pdPrint.PrintRange = prCurrentPage then
    begin
      st:= FPageNr;
      en:= FPageNr;
    end
    else if pdPrint.PrintRange = prPageNums then
    begin
      st:= pdPrint.FromPage;
      en:= pdPrint.ToPage;
    end;
    num:= pdPrint.Copies;
    FDocument.Repaginate;
    FDocument.Print(st, en, num);
  end;
end;

procedure TFrmPrintPreview.FormResize(Sender: TObject);
var m : word;
    WH, WHsh : single;
begin
  if Width < 350 then Width:= 350;
  if Height < 570 then Height:= 570;
  sbPage.Left:= 5;
  sbPage.Top:= 38;
  sbPage.Width:= Width - 2 * sbPage.Left;
  sbPage.Height:= Height - 82;

  WH:= (FDocument.PageRect.Right - FDocument.PageRect.Left) /
       (FDocument.PageRect.Bottom - FDocument.PageRect.Top);
  WHsh:= sbPage.Width / sbPage.Height;
  if WH >= WHsh then
  begin
    sbPage.Width:= Width - 2 * sbPage.Left;
    sbPage.Height:= round(sbPage.Width / WH);
  end
  else if WH < WHsh then
  begin
    sbPage.Height:= Height - 82;
    sbPage.Width:= round(sbPage.Height * WH);
  end;
  sbPage.Left:= round((Width - sbPage.Width) / 2);
  sbPage.Top:= round((Height - sbPage.Height) / 2);
  FScale:= sbPage.Height / (FDocument.PageRect.Bottom - FDocument.PageRect.Top);

  FVPage.Left:= sbPage.Left;
  FVPage.Top:= sbPage.Top;
  FVPage.Right:= sbPage.Left + round(FZoomFactor * sbPage.Width);
  FVPage.Bottom:= sbPage.Top + round(FZoomFactor * sbPage.Height);
  sbPage.HorzScrollBar.Range:= sbPage.Width;
  sbPage.HorzScrollBar.Visible:= false;
  sbPage.VertScrollBar.Range:= sbPage.Height;
  sbPage.VertScrollBar.Visible:= false;
  if FVPage.Right - FVPage.Left > sbPage.Width then
  begin
    if FVPage.Right - FVPage.Left < Width - 10 then
    begin
      sbPage.Width:= FVPage.Right - FVPage.Left;
      sbPage.Left:= round((Width - sbPage.Width) / 2);
    end
    else
    begin
      sbPage.Width:= Width - 10;
      sbPage.HorzScrollBar.Range:= FVPage.Right - FVPage.Left;
      sbPage.HorzScrollBar.Visible:= TRUE;
      sbPage.Left:= 5;
    end;
  end;
  if FVPage.Bottom - FVPage.Top > sbPage.Height then
  begin
    if FVPage.Bottom - FVPage.Top < Height - 82 then
    begin
      sbPage.Height:= FVPage.Bottom - FVPage.Top;
      sbPage.Top:= round((Height - sbPage.Height) / 2);
    end
    else
    begin
      sbPage.Height:= Height - 82;
      sbPage.VertScrollBar.Range:= FVPage.Bottom - FVPage.Top;
      sbPage.VertScrollBar.Visible:= TRUE;
      sbPage.Top:= 38;
    end;
  end;

  m:= round(Width / 2);
  bbPrior.Left:= m - 2 - bbPrior.Width;
  bbNext.Left:= m + 2;
  bbPrint.Left:= bbPrior.Left;
  bbCancel.Left:= bbNext.Left;
  bbPrint.Top:= sbPage.Top + sbPage.Height + 7;
  bbCancel.Top:= bbPrint.Top;
end;

procedure TFrmPrintPreview.sbPageMouseWheelUp(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  FZoomFactor:= FZoomFactor + 0.1;
  FormResize(self);
  Handled:= TRUE;
end;

procedure TFrmPrintPreview.sbPageMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  if FZoomFactor > 1.1 then
  begin
    FZoomFactor:= FZoomFactor - 0.1;
    FormResize(self);
    Handled:= TRUE;
  end;
end;

procedure TFrmPrintPreview.sbPageMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (FZoomFactor > 1.1) then
    FZoomFactor:= FZoomFactor - 0.1
  else if Button = mbRight then
    FZoomFactor:= FZoomFactor + 0.1;
  FormResize(self);
end;

end.

