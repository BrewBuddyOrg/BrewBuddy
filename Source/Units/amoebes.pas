unit amoebes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

interface

uses
{$IFNDEF FPC}
  Windows,
{$ELSE}
  LCLIntf, LCLType, LMessages,
{$ENDIF}
  SysUtils, Controls, Forms, graphics, classes, Clipbrd;

type
  TAmoebeKind = (akClassic, akModern, akSlices);

  TAmoebe = class;

  TAmoebeSerie = class
    Constructor Create(Gr : TAmoebe); virtual;
    Destructor Destroy; override;
  private
    FAmoebe : TAmoebe;
    FTitle, FAxUnit : string;
    FScore, FMinValue, FMaxValue, FNorm, FAngle : Double;
    FLength, FNormLength : LongInt;
    FStartPoint : TPoint;
    FFont : TFont;
    FColor : TColor;
    FLineWidth : LongInt;
    Function GetFont : TFont;
    procedure SetFont(Value : TFont);
    Procedure SetColor(Value : TColor);
    procedure SetLineWidth(Value : Longint);
    Procedure SetScore(Value : double);
    Procedure SetMinValue(Value : double);
    procedure SetMaxValue(Value : double);
    procedure SetNorm(Value : double);
    procedure SetTitle(Value : string);
    procedure SetAxUnit(Value : string);
    Procedure SetAngle(Value : double);
    Procedure SetLength(Value : LongInt);
    procedure SetNormLength(Value : Longint);
    procedure SetStartPoint(Value : TPoint);
    Function GetEndPoint : TPoint;
    Function GetScorePoint : TPoint;
    Function GetNormPoint : TPoint;
    Function ScoreAsString(Dec : LongInt) : string;
    Function CalcTitleWidth(Cnvs : TCanvas) : LongInt;
  protected
    Procedure DrawClassic(Cnvs : TCanvas);
    Procedure DrawModern(Cnvs : TCanvas);
    Procedure DrawSlices(Cnvs : TCanvas);
    Procedure Clear;
  public
    Function NormPointPerc(Perc : single) : TPoint;
    property StartPoint : TPoint read FStartPoint write SetStartPoint;
    property EndPoint : TPoint read GetEndPoint;
    property ScorePoint : TPoint read GetScorePoint;
    property NormPoint : TPoint read GetNormPoint;
  published
    property Font : TFont read GetFont write SetFont;
    property Color : TColor read FColor write SetColor;
    property LineWidth : LongInt read FLineWidth write SetLineWidth;
    property Score : double read FScore write SetScore;
    property Title : string read FTitle write SetTitle;
    property MinValue : double read FMinValue write SetMinValue;
    property MaxValue : double read FMaxValue write SetMaxValue;
    property Norm : double read FNorm write SetNorm;
    property AxUnit : string read FAxUnit write SetAxUnit;
    property Angle : double read FAngle write SetAngle;
    property Length : LongInt read FLength write SetLength;
    property NormLength : LongInt read FNormLength write SetNormLength;
  end;

  TAmoebe = class(TGraphicControl)
  private
    FTitleFont : TFont;
    FTitle : string;
    FSeries : TList;
    FOnPaint : TNotifyEvent;
    FKind : TAmoebeKind;
    FNormLength, FLength : Longint;
    FShowExtendedNorms : boolean;
    FStartPoint : TPoint;
    FFitting : boolean;
    FNormColor, FAmoebeColor : TColor;
    FAllowEditor, FShowValues : boolean;
    FRect : TRect;
    Procedure Initialize;
    Procedure FitToSize(Cnvs : TCanvas; Re : TRect); virtual;
    Procedure SetNormColor(Value : TColor);
    Procedure SetAmoebeColor(Value : TColor);
    Procedure SetShowExtendedNorms(Value : boolean);
    Procedure SetKind(Value : TAmoebeKind);
    Function DrawTitle(Cnvs : TCanvas; Rect : TRect) : LongInt;
    Procedure DrawClassic(Cnvs : TCanvas; Re : TRect);
    Procedure DrawModern(Cnvs : TCanvas; Re : TRect);
    Procedure DrawSlices(Cnvs : TCanvas; Re : TRect);
    Procedure SetTitleFont(Value : TFont);
    Procedure SetTitle(Value : string);

    Function GetAmountSeries : LongInt;
    Procedure SetAmountSeries(Value : LongInt);
    Function GetAngle(SerieNr : LongInt) : double;
    Procedure SetAngle(SerieNr : LongInt; Value : double);
    Function GetLength(SerieNr : LongInt) : LongInt;
    Procedure SetLength(SerieNr, Value : LongInt);
    Procedure SetNormLength(Value : LongInt);
    Procedure SetStartPoint(Value : TPoint);
    property Angle[SerieNr : LongInt] : double read GetAngle write SetAngle;
  protected
    Function ExecuteEditor : boolean; virtual;
  public
    constructor Create(AOwner : TComponent); override;
    Destructor Destroy; override;
    Procedure DblClick; override;
    Procedure Paint; override;
    procedure Resize; override;
    procedure Assign(Source : TPersistent); override;
    procedure Print; virtual;
    Procedure Clear;
    Procedure Draw(Cnvs : TCanvas; Re : TRect); virtual;
    Procedure CopyToClipboard;
    Procedure SaveToBitmap(F : string);
//    Procedure SaveToMetafile(F : string; Enh : boolean);
    Procedure SetWidthMM(Cnvs : TCanvas; Value : double);
    Procedure SetHeightMM(Cnvs : TCanvas; Value : double);
    Function GetSerie(Value : LongInt) : TAmoebeSerie;
    Procedure AddSerie(Text, AxUnit : string; MinValue, MaxValue, Score, Norm : double);
    Procedure DeleteSerie(SerieNr : Longint);

    Function GetScore(SerieNr : LongInt) : double;
    Procedure SetScore(SerieNr : LongInt; Value : double);
    Function ScoreAsString(SerieNr, Dec : LongInt) : string;
    Function GetSerieColor(SerieNr : LongInt) : TColor;
    Procedure SetSerieColor(SerieNr : LongInt; Value : TColor);
    Function GetNorm(SerieNr : LongInt) : double;
    Procedure SetNorm(SerieNr : LongInt; Value : double);
    Function GetMinValue(SerieNr : LongInt) : double;
    procedure SetMinValue(SerieNr : LongInt; Value : double);
    Function GetMaxValue(SerieNr : LongInt) : double;
    procedure SetMaxValue(SerieNr : LongInt; Value : double);
    Function GetSerieTitle(SerieNr : LongInt) : string;
    Procedure SetSerieTitle(SerieNr : LongInt; Value : string);
    Function GetAxUnit(SerieNr : LongInt) : string;
    procedure SetAxUnit(SerieNr : LongInt; Value : string);
    Function GetSerieFont(SerieNr : Longint) : TFont;
    procedure SetSerieFont(SerieNr : LongInt; Value : TFont);
    procedure SetShowValues(b : boolean);

    property Score[SerieNr : LongInt] : double read GetScore write SetScore;
    property Serie[SerieNr : Longint] : TAmoebeSerie read GetSerie;
    property SerieTitle[SerieNr : LongInt] : string read GetSerieTitle write SetSerieTitle;
    property SerieColor[SerieNr : LongInt] : TColor read GetSerieColor write SetSerieColor;
    property SerieFont[SerieNr : LongInt] : TFont read GetSerieFont write SetSerieFont;
    property MinValue[SerieNr : LongInt] : double read GetMinValue write SetMinValue;
    property MaxValue[SerieNr : LongInt] : double read GetMaxValue write SetMaxValue;
    property Norm[SerieNr : LongInt] : double read GetNorm write SetNorm;
    property AxUnit[SerieNr : LongInt] : string read GetAxUnit write SetAxUnit;
    property NormLength : LongInt read FNormLength write SetNormLength;
    property StartPoint : TPoint read FStartPoint write SetStartPoint;
  published
    property Align;
    property Parent;
    property Canvas;
    property Font;
    property Width;
    property Height;
    property Left;
    property Top;
    property Color;
    property Visible;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Enabled;
    property ShowHint;
    property Cursor;
    property Hint;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnResize;

    property AllowEditor : boolean read FAllowEditor write FAllowEditor default TRUE;
    property NormColor : TColor read FNormColor write SetNormColor;
    property AmoebeColor : TColor read FAmoebeColor write SetAmoebeColor;
    property ShowExtendedNorms : boolean read FShowExtendedNorms write SetShowExtendedNorms;
    property Kind : TAmoebeKind read FKind write SetKind;
    property Title : string read FTitle write SetTitle;
    Property TitleFont : TFont read FTitleFont write SetTitleFont;
    property AmountSeries : LongInt read GetAmountSeries write SetAmountSeries;
    property ShowValues : boolean read FShowValues write SetShowValues;
    property OnPaint : TNotifyEvent read FOnPaint write FOnPaint;
  end;


procedure Register;

var Amoebe: TAmoebe;

implementation
uses Math, Printers, BHgraphics, hulpfuncties;

Procedure Register;
begin
  RegisterComponents('Samples', [TAmoebe]);
end;


Constructor TAmoebeSerie.Create(Gr : TAmoebe);
begin
  Inherited Create;
  FAmoebe:= Gr;
  FScore:= 0; FMinValue:= 0; FMaxValue:= 1; FNorm:= 1; FAxUnit:= '';
  FAngle:= 0; FLength:= 100; FNormLength:= 50;
  FFont:= TFont.Create;
  Font.Assign(Gr.Font);
{  FFont.Color:= clBlack;
  FFont.Height:= 10;
  FFont.Name:= 'Arial';
  FFont.Style:= [];}
  FColor:= clBlack;
  FLineWidth:= 1;
end;

Destructor TAmoebeSerie.Destroy;
begin
  FAmoebe:= NIL;
  FScore:= 0; FMinValue:= 0; FMaxValue:= 100; FNorm:= 50; FAxUnit:= '';
  FFont.Free;
  FFont:= NIL;
  Inherited Destroy;
end;

Function TAmoebeSerie.GetFont : TFont;
begin
  Result:= FFont;
end;

procedure TAmoebeSerie.SetFont(Value : TFont);
begin
  if Value <> NIL then FFont.Assign(Value);
end;

Procedure TAmoebeSerie.SetColor(Value : TColor);
begin
  if FColor <> Value then
  begin
    FColor:= Value;
  end;
end;

procedure TAmoebeSerie.SetLineWidth(Value : Longint);
begin
  if (FLineWidth <> Value) and (Value > 0) then
  begin
    FLineWidth:= Value;
  end;
end;

Procedure TAmoebeSerie.SetScore(Value : double);
begin
  if FScore <> Value then
  begin
    FScore:= Value;
    if FMinValue > FScore then FMinValue:= FScore;
    if FMaxValue < FScore then FMaxValue:= FScore;
    {if FNorm < FScore then FMaxValue:= FScore
    else FMaxValue:= FNorm;}
  end;
end;

Procedure TAmoebeSerie.SetMinValue(Value : double);
begin
  if (FMinValue <> Value) and (Value >= 0) then
  begin
    FMinValue:= Value;
    if FMinValue > FScore then FMinValue:= 0;
    if FMaxValue < FMinValue then FMaxValue:= FMinValue + 1;
    if FScore < FMinValue then FMinValue:= 0;
    if FNorm < FMinValue then FMinValue:= 0;
  end;
end;

procedure TAmoebeSerie.SetMaxValue(Value : double);
begin
  if (FMaxValue <> Value) and (Value > 0) then
  begin
    FMaxValue:= Value;
    if FNorm > FMaxValue then FMaxValue:= FNorm;
    if FMinValue > FMaxValue then FMinValue:= 0;
    if FMaxValue < FScore then FMaxValue:= FScore;
  end;
end;

procedure TAmoebeSerie.SetNorm(Value : double);
begin
  if (FNorm <> Value) and (Value > 0) then
  begin
    FNorm:= Value;
    if FNorm < FMinValue then FMinValue:= 0;
    if FNorm > FMaxValue then FMaxValue:= FNorm;
  end;
end;

procedure TAmoebeSerie.SetAxUnit(Value : string);
begin
  if (FAxUnit <> Value) then
  begin
    FAxUnit:= Value;
  end;
end;

procedure TAmoebeSerie.SetTitle(Value : string);
begin
  if (FTitle <> Value) then
  begin
    FTitle:= Value;
  end;
end;

Procedure TAmoebeSerie.SetAngle(Value : double);
begin
  if (FAngle <> Value) then
  begin
    FAngle:= Value;
    while FAngle < 0 do FAngle:= FAngle + 360;
    while FAngle > 360 do FAngle:= FAngle - 360;
  end;
end;

Procedure TAmoebeSerie.SetLength(Value : LongInt);
begin
  if (Value > 0) and (FMaxValue > FMinValue) then
  begin
    FLength:= Value;
    FNormLength:= round(FLength * (FNorm - FMinValue) / (FMaxValue - FMinValue));
  end;
end;

Procedure TAmoebeSerie.SetNormLength(Value : LongInt);
//var L : LongInt;
begin
  if (Value > 0) and (FNorm > FMinValue) then
  begin
    FNormLength:= Value;
   // L:= round(FNormLength * (FMaxValue - FMinValue) / (FNorm - FMinValue));
   // FLength:= L;
  end;
end;

procedure TAmoebeSerie.SetStartPoint(Value : TPoint);
begin
  if ((FStartPoint.X <> Value.X) or (FStartPoint.Y <> Value.Y))
  and (Value.X >= 0) and (Value.Y >= 0) then
    FStartPoint:= Value;
end;

Function TAmoebeSerie.ScoreAsString(Dec : LongInt) : string;
begin
  try
    Result:= RealToStrDec(FScore, Dec);
  except
    Result:= '';
  end;
end;

Function TAmoebeSerie.CalcTitleWidth(Cnvs : TCanvas) : LongInt;
begin
  Result:= Cnvs.TextWidth(FTitle);
end;

Function TAmoebeSerie.GetEndPoint : TPoint;
begin
  Result.X:= round(FStartPoint.X + FLength * Sinus(FAngle));
  Result.Y:= round(FStartPoint.Y - FLength * Cosinus(FAngle));
end;

Function TAmoebeSerie.GetScorePoint : TPoint;
var L : double;
begin
//  L:= FLength * (FScore - FMinValue) / (FMaxValue - FMinValue);
  L:= FNormLength * (FScore - FMinValue) / (FNorm - FMinValue);
  Result.X:= round(FStartPoint.X + L * Sinus(FAngle));
  Result.Y:= round(FStartPoint.Y - L * Cosinus(FAngle));
end;

Function TAmoebeSerie.GetNormPoint : TPoint;
var L : double;
begin
  L:= FNormLength; //FLength * (FNorm - FMinValue) / (FMaxValue - FMinValue);
  Result.X:= round(FStartPoint.X + L * Sinus(FAngle));
  Result.Y:= round(FStartPoint.Y - L * Cosinus(FAngle));
end;

Function TAmoebeSerie.NormPointPerc(Perc : single) : TPoint;
var L : double;
begin
  L:= Perc/100 * FNormLength; //FLength * Perc/100 * (FNorm - FMinValue) / (FMaxValue - FMinValue);
  Result.X:= round(FStartPoint.X + L * Sinus(FAngle));
  Result.Y:= round(FStartPoint.Y - L * Cosinus(FAngle));
end;

Procedure TAmoebeSerie.DrawClassic(Cnvs : TCanvas);
var StP, EP : TPoint;
    Re, Re2 : TRect;
    S, Ss : String;
    Scale : single;
    H, W, H2, W2 : LongInt;
begin
  if (FLength > 0) and (FAngle >= 0) then
  begin
    StP.X:= FStartPoint.X; StP.Y:= FStartPoint.Y;
    EP.X:= round(StP.X + FLength * Sinus(FAngle));
    EP.Y:= round(StP.Y - FLength * Cosinus(FAngle));
    with Cnvs do
    begin
      Pen.Color:= FColor;
      Pen.Width:= FLineWidth;
      Brush.Style:= bsClear;
      Font.Assign(FFont);
      MoveTo(StP.X, StP.Y);
      if FScore > FNorm then EP:= GetScorePoint
      else EP:= GetNormPoint;
      LineTo(EP.X, EP.Y);
    end;
  // Titel:
    if AxUnit <> '' then S:= FTitle + ' (' + FAxUnit + ')'
    else S:= FTitle;
    Cnvs.Font.Assign(FFont);

  {  EP.X:= round(StP.X + 0.5 * FLength * Sinus(FAngle));
    EP.Y:= round(StP.Y - 0.5 * FLength * Cosinus(FAngle));}
    if FAmoebe.FLength > 1.5 * FNormLength then Scale:= 1.5
    else if FAmoebe.FLength > FNormLength then Scale:= 1
    else Scale:= 0.5;

    H:= Cnvs.TextHeight(S);
    W:= Cnvs.TextWidth(S);

   { EP.X:= round(StP.X + Scale * FNormLength * Sinus(FAngle));
    EP.Y:= round(StP.Y - Scale * FNormLength * Cosinus(FAngle));

    Re.Left:= round(EP.X - 0.5 * W);
    Re.Right:= Re.Left + W;
    Re.Bottom:= EP.Y + round(0.5 * H);
    Re.Top:= Re.Bottom - H;}

    EP.X:= round(StP.X + FLength * Sinus(FAngle));
    EP.Y:= round(StP.Y - FLength * Cosinus(FAngle));
    Re.Left:= round(EP.X - 0.5 * W - 2);
    Re.Right:= Re.Left + W + 2;
    Re.Bottom:= EP.Y + round(0.5 * H) + 2;
    Re.Top:= Re.Bottom - H - 2;
    if Re.Top < FAmoebe.Top then
    begin
      Re.Top:= FAmoebe.Top + 2;
      Re.Bottom:= Re.Top + H;
    end;
    if Re.Bottom > (FAmoebe.Top + FAmoebe.Height) then
    begin
      Re.Bottom:= FAmoebe.Top + FAmoebe.Height - 2;
      Re.Top:= Re.Bottom - H;
    end;

    //Draw Score value
    Ss:= RealToStrSignif(FScore, 3);
    H2:= Cnvs.TextHeight(Ss);
    W2:= Cnvs.TextWidth(Ss);
    EP:= GetScorePoint;
    Re2.Left:= round(EP.X - 0.5 * W2);
    Re2.Right:= Re2.Left + W2;
    Re2.Bottom:= EP.Y + round(0.5 * H2);
    Re2.Top:= Re2.Bottom - H2;
    if Re2.Top < FAmoebe.Top then
    begin
      Re2.Top:= FAmoebe.Top + 2;
      Re2.Bottom:= Re2.Top + H;
    end;
    if Re2.Bottom > (FAmoebe.Top + FAmoebe.Height) then
    begin
      Re2.Bottom:= FAmoebe.Top + FAmoebe.Height - 2;
      Re2.Top:= Re2.Bottom - H;
    end;

    if Overlap(Re, Re2) then
    begin
      EP.X:= round(StP.X + Scale * FNormLength * Sinus(FAngle));
      EP.Y:= round(StP.Y - Scale * FNormLength * Cosinus(FAngle));
      Re.Left:= round(EP.X - 0.5 * W - 2);
      Re.Right:= Re.Left + W + 2;
      Re.Bottom:= EP.Y + round(0.5 * H) + 2;
      Re.Top:= Re.Bottom - H - 2;
      if Re.Top < FAmoebe.Top then
      begin
        Re.Top:= FAmoebe.Top + 2;
        Re.Bottom:= Re.Top + H;
      end;
      if Re.Bottom > (FAmoebe.Top + FAmoebe.Height) then
      begin
        Re.Bottom:= FAmoebe.Top + FAmoebe.Height - 2;
        Re.Top:= Re.Bottom - H;
      end;
    end;

    Cnvs.Brush.Style:= bsSolid;
    Cnvs.Brush.Color:= clWhite;
    Cnvs.Rectangle(Re);
    Re.Top:= Re.Top + 1;
    Re.Bottom:= Re.Bottom - 1;
    Re.Left:= Re.Left + 1;
    Re.Right:= Re.Right - 1;
    DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);

    DrawTextRect(Cnvs, Ss, Re2, taCenter, avCenter, false);

    Cnvs.Brush.Style:= bsSolid;
  end;
end;

Procedure TAmoebeSerie.DrawModern(Cnvs : TCanvas);
var EP : TPoint;
    Re : TRect;
    S : String;
    BC : TColor;
    L : double;
begin
  if (FLength > 0) and (FAngle >= 0) then
  begin
    EP:= NormPoint;
    with Cnvs do
    begin
      Pen.Color:= FColor;
      Pen.Width:= FLineWidth;
      Brush.Style:= bsSolid;
      Brush.Color:= Pen.Color;
      Ellipse(EP.X-2, EP.Y - 2, EP.X + 2, EP.Y + 2);
      Brush.Style:= bsClear;
      Font.Assign(FFont);
    end;
  // Titel:
    if AxUnit <> '' then S:= FTitle + ' (' + FAxUnit + ')'
    else S:= FTitle;
    Cnvs.Font.Assign(FFont);

    if FAmoebe.FLength > 1.5 * FNormLength then
    begin
      L:= FNormLength + Cnvs.TextHeight(FTitle);
      EP.X:= round(FStartPoint.X + L * Sinus(FAngle));
      EP.Y:= round(FStartPoint.Y - L * Cosinus(FAngle));
      if (FAngle > 355) or (FAngle <= 5) then
      begin
        Re.Left:= round(EP.X - 0.5 * Cnvs.TextWidth(S));
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y;
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);
      end
      else if ((FAngle > 5) and (FAngle <= 175)) then
      begin
        Re.Left:= EP.X;
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y + Round(0.5 * Cnvs.TextHeight(S));
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taLeftJustify, avCenter, false);
      end
      else if (FAngle > 175) and (FAngle <= 185) then
      begin
        Re.Left:= round(EP.X - 0.5 * Cnvs.TextWidth(S));
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Top:= EP.Y;
        Re.Bottom:= Re.Top + Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);
      end
      else if (FAngle > 185) and (FAngle <= 355) then
      begin
        Re.Right:= EP.X;
        Re.Left:= Re.Right - Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y + Round(0.5 * Cnvs.TextHeight(S));
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taRightJustify, avCenter, false);
      end;
    end
    else
    begin
      L:= FNormLength - Cnvs.TextHeight(FTitle);
      EP.X:= round(FStartPoint.X + L * Sinus(FAngle));
      EP.Y:= round(FStartPoint.Y - L * Cosinus(FAngle));
      if (FAngle > 345) or (FAngle <= 15) then
      begin
        Re.Left:= round(EP.X - 0.5 * Cnvs.TextWidth(S));
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Top:= EP.Y;
        Re.Bottom:= Re.Top + Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);
      end
      else if ((FAngle > 5) and (FAngle <= 175)) then
      begin
        Re.Right:= EP.X;
        Re.Left:= Re.Right - Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y + Round(0.5 * Cnvs.TextHeight(S));
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taLeftJustify, avCenter, false);
      end
      else if (FAngle > 165) and (FAngle <= 195) then
      begin
        Re.Left:= round(EP.X - 0.5 * Cnvs.TextWidth(S));
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y;
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);
      end
      else if (FAngle > 185) and (FAngle <= 355) then
      begin
        Re.Left:= EP.X;
        Re.Right:= Re.Left + Cnvs.TextWidth(S);
        Re.Bottom:= EP.Y + Round(0.5 * Cnvs.TextHeight(S));
        Re.Top:= Re.Bottom - Cnvs.TextHeight(S);
        DrawTextRect(Cnvs, S, Re, taRightJustify, avCenter, false);
      end;
    end;
    Cnvs.Brush.Style:= bsSolid;
    {$warning TAmoebeSerie.DrawModern: Color BC is not initialized!}
    Cnvs.Brush.Color:= BC;
  end;
end;

Procedure TAmoebeSerie.DrawSlices(Cnvs : TCanvas);
var StP, EP : TPoint;
    Re : TRect;
    S : String;
    Scale : single;
begin
  if (FLength > 0) and (FAngle >= 0) and (FTitle <> '') then
  begin
    StP.X:= FStartPoint.X; StP.Y:= FStartPoint.Y;

    if FAmoebe.FLength > 1.5 * FNormLength then Scale:= 1.5
    else if FAmoebe.FLength > FNormLength then Scale:= 1
    else Scale:= 0.5;

    EP.X:= round(StP.X + Scale * FNormLength * Sinus(FAngle));
    EP.Y:= round(StP.Y - Scale * FNormLength * Cosinus(FAngle));

    if AxUnit <> '' then S:= FTitle + ' (' + FAxUnit + ')'
    else S:= FTitle;

    Re.Left:= EP.X - round(Cnvs.TextWidth(S)/2);
    Re.Right:= Re.Left + Cnvs.TextWidth(S);
    Re.Top:= EP.Y - round(Cnvs.TextHeight(S)/2);
    Re.Bottom:= EP.Y + Cnvs.TextHeight(S);

    with Cnvs do
    begin
      Pen.Color:= FColor;
      Brush.Style:= bsClear;
      Font.Assign(FFont);
      Pen.Width:= FLineWidth;
      Font.Assign(FFont);
    end;
    DrawTextRect(Cnvs, S, Re, taCenter, avCenter, false);
//    DrawTxtRct(Cnvs, Re, S, taCenter, false);
  end;
end;

Procedure TAmoebeSerie.Clear;
begin
  FScore:= 0;
end;

{==============================================================================}


constructor TAmoebe.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
//  Parent:= TWinControl(AOwner);
  Initialize;
end;

Destructor TAmoebe.Destroy;
var i : LongInt;
begin
  for i:= 0 to FSeries.Count-1 do
    TAmoebeSerie(FSeries.Items[i]).Free;
  FSeries.Clear;
  FSeries.Free;
  FSeries:= NIL;
  FTitleFont.Free; FTitleFont:= NIL;
  Inherited Destroy;
end;

Procedure TAmoebe.Initialize;
var //i : LongInt;
    P : TPoint;
begin
  FFitting:= false;
  Width:= 300;
  Height:= 300;
  FTitle:= '';
  FKind:= akClassic;
  FNormColor:= clRed;
  FAmoebeColor:= clGreen;

  FSeries:= NIL;

  FTitleFont:= TFont.Create;
  with FTitleFont do
  begin
    Size:= 10;
    Style:= [fsBold];
    Name:= 'Arial';
  end;
  with Font do
  begin
    Size:= 8;
    Style:= [];
    Name:= 'Arial';
  end;

  {Default values}
  AmountSeries:= 0;
{  Randomize;
  for i:= 1 to AmountSeries do
  begin
    SerieTitle[i]:= 'Serie ' + IntToStr(i);
    MinValue[i]:= 0;
    MaxValue[i]:= Random(100 * i);
    Norm[i]:= 0.25 * MaxValue[i];
    Score[i]:= Random(round(MaxValue[i]));
  end;}
  NormLength:= 75;
  ShowExtendedNorms:= false;
  P.X:= 150; P.Y:= 150;
  StartPoint:= P;
  FRect.Left:= 0; FRect.Right:= ClientWidth;
  FRect.Top:= 0; FRect.Bottom:= ClientHeight;
  FAllowEditor:= false;
  FShowValues:= TRUE;
  FitToSize(Canvas, FRect);
end;

procedure TAmoebe.Resize;
begin
  FRect.Left:= 0; FRect.Right:= ClientWidth;
  FRect.Top:= 0; FRect.Bottom:= ClientHeight;
  FitToSize(Canvas, FRect);
  Inherited Resize;
end;

Procedure TAmoebe.DblClick;
begin
  if FAllowEditor then ExecuteEditor;
  Inherited DblClick;
end;

Procedure TAmoebe.Paint;
begin
  Inherited Paint;
  FRect.Left:= 1; FRect.Right:= Width - 2; FRect.Top:= 1; FRect.Bottom:= Height - 2;
  if Visible then Draw(Canvas, FRect);
  if Assigned(FOnPaint) then FOnPaint(self);
end;

procedure TAmoebe.Print;
var FactorX, FactorY : double;
    OldRect : TRect;
begin
  OldRect:= FRect;

  FFitting:= TRUE;
  FactorX:= GetDeviceCaps(Printer.Canvas.Handle, LogPixelsX)
            / GetDeviceCaps(Canvas.Handle, LogPixelsX);
  FactorY:= GetDeviceCaps(Printer.Canvas.Handle, LogPixelsY)
            / GetDeviceCaps(Canvas.Handle, LogPixelsY);
  FRect.Left:= round(FactorX * FRect.Left);
  FRect.Right:= round(FactorX * FRect.Right);
  FRect.Top:= round(FactorY * FRect.Top);
  FRect.Bottom:= round(FactorY * FRect.Bottom);
  FFitting:= false;

  if Visible then Draw(Printer.Canvas, FRect);

  FRect:= OldRect;
  Draw(Canvas, FRect);
  if Assigned(FOnPaint) then FOnPaint(self);
end;

Procedure TAmoebe.Clear;
var i : Longint;
begin
  if FSeries <> NIL then
  begin
    for i:= 0 to FSeries.Count - 1 do TAmoebeSerie(FSeries.Items[i]).Free;
    FSeries.Free;
    FSeries:= NIL;
  end;
end;

Procedure TAmoebe.Draw(Cnvs : TCanvas; Re : TRect);
var R : TRect;
    OldBrushColor, OldPenColor : TColor;
    OldBrushStyle : TBrushStyle;
begin
  FitToSize(Cnvs, Re);
  if (FSeries <> NIL) and (FSeries.Count > 0) then
  begin
    with Cnvs do
    begin
      OldBrushColor:= Brush.Color;
      OldBrushStyle:= Brush.Style;
      OldPenColor:= Pen.Color;
      Brush.Color:= Color;
      Brush.Style:= bsSolid;
      Pen.Color:= Brush.Color;
      Pen.Style:= psSolid;
      Rectangle(Re.Left, Re.Top, Re.Right, Re.Bottom);
    end;
    R:= Re;
    if FTitle <> '' then
    begin
      Cnvs.Font.Assign(FTitleFont);
      R.Bottom:= R.Top + Cnvs.TextHeight(FTitle);
      DrawTitle(Cnvs, R);
    end;
    case FKind of
    akClassic: DrawClassic(Cnvs, Re);
    akModern:  DrawModern(Cnvs, Re);
    akSlices:  DrawSlices(Cnvs, Re);
    end;

    with Cnvs do
    begin
      Brush.Color:= OldBrushColor;
      Brush.Style:= OldBrushStyle;
      Pen.Color:= OldPenColor;
    end;
  end;
end;

Function TAmoebe.DrawTitle(Cnvs : TCanvas; Rect : TRect) : LongInt;
begin
  Result:= 0; // What should be returned?
  if FTitle <> '' then
  begin
    Cnvs.Brush.Style:= bsClear;
    Cnvs.Font.Assign(FTitleFont);
    DrawTextRect(Cnvs, FTitle, Rect, taCenter, avBottom, false);
//    DrawTxtRct(Cnvs, Rect, FTitle, taCenter, false);
  end;
end;

Procedure TAmoebe.DrawClassic(Cnvs : TCanvas; Re : TRect);
var i, j : LongInt;
    Serie, Serie2 : TAmoebeSerie;
    PA : array of TPoint;
    //A : double;
begin
//Teken eerst normcircel met kleur, dan de amoebe, dan de normcirkel leeg
//en tenslotte de assen
//Normcirkel
  with Cnvs do
  begin
    Pen.Color:= clBlack;
    Brush.Style:= bsSolid;
    Brush.Color:= FNormColor;
    Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
            FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
  end;
//Amoebe
  if FSeries <> NIL then
  begin
    if FSeries.Count = 1 then
      System.SetLength(PA, 3)
    else
      System.SetLength(PA, FSeries.Count);
{    if FSeries.Count > 1 then
      A:= 0.5 * TAmoebeSerie(FSeries.Items[1]).Angle
    else
      A:= 90;  }
    j:= 0;
    for i:= 1 to FSeries.Count do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i-1]);
      if i < FSeries.Count then Serie2:= TAmoebeSerie(FSeries.Items[i])
      else Serie2:= TAmoebeSerie(FSeries.Items[0]);
      PA[j]:= Serie.ScorePoint;
      Inc(j);
      if Serie = Serie2 then
      begin
        PA[j].X:= FStartPoint.X - round(0.5 * FNormLength);
        PA[j].Y:= FStartPoint.Y;
        Inc(j);
        PA[j].X:= FStartPoint.X + round(0.5 * FNormLength);
        PA[j].Y:= FStartPoint.Y;
      end;
    end;
    Cnvs.Brush.Style:= bsSolid;
    Cnvs.Brush.Color:= FAmoebeColor;
    Cnvs.Pen.Color:= FAmoebeColor;
    Cnvs.Polygon(PA);

    PA:= NIL;
    //Normcirkel, maar nu leeg
    with Cnvs do
    begin
      Pen.Color:= clBlack;
      Brush.Style:= bsClear;
      Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
              FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
      Brush.Style:= bsSolid;
    end;

    //Assen
    for i:= 0 to FSeries.Count - 1 do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i]);
      Serie.DrawClassic(Cnvs);
    end;
  end;
end;

Procedure TAmoebe.DrawModern(Cnvs : TCanvas; Re : TRect);
var i : LongInt;
    Serie : TAmoebeSerie;
    PA : array of TPoint;
begin
//Teken eerst normcircel met kleur, dan de amoebe, dan de normcirkel leeg
//en tenslotte de assen
//Normcirkel
  with Cnvs do
  begin
    Pen.Color:= clBlack;
    Brush.Style:= bsSolid;
    Brush.Color:= FNormColor;
    Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
            FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
  end;
//Amoebe
  if FSeries <> NIL then
  begin
    if FSeries.Count = 1 then
    begin
      System.SetLength(PA, 3);
    end
    else if FSeries.Count = 2 then
    begin
      System.SetLength(PA, 4);
    end
    else
      System.SetLength(PA, FSeries.Count);

    for i:= 0 to FSeries.Count - 1 do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i]);
      PA[i]:= Serie.ScorePoint;
      if (i = 0) and (FSeries.Count = 1) then
      begin
        PA[1].X:= FStartPoint.X - round(0.5 * FNormLength);
        PA[1].Y:= FStartPoint.Y;
        PA[2].X:= FStartPoint.X + round(0.5 * FNormLength);
        PA[2].Y:= FStartPoint.Y;
      end
      else if (i = 0) and (FSeries.Count = 2) then
      begin
        PA[2]:= PA[1];
        PA[1].X:= FStartPoint.X - round(0.5 * FNormLength);
        PA[1].Y:= FStartPoint.Y;
      end
      else if (i = 1) and (FSeries.Count = 2) then
      begin
        PA[3].X:= FStartPoint.X + round(0.5 * FNormLength);
        PA[3].Y:= FStartPoint.Y;
      end;
    end;
    with Cnvs do
    begin
      Pen.Color:= FAmoebeColor;
      Brush.Color:= FAmoebeColor;
      Polygon(PA);
    end;
    PA:= NIL;

    //Normcirkel, maar nu leeg
    with Cnvs do
    begin
      Pen.Color:= clBlack;
      Brush.Style:= bsClear;
      Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
              FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
      Brush.Style:= bsSolid;
      Brush.Color:= clBlack;
      Ellipse(FStartPoint.X - 1, FStartPoint.Y - 1, FStartPoint.X + 1, FStartPoint.Y + 1);
    //Lege cirkel op maxima
      Pen.Color:= clBlack;
      Brush.Style:= bsClear;
      Ellipse(FStartPoint.X - FLength, FStartPoint.Y - FLength,
              FStartPoint.X + FLength, FStartPoint.Y + FLength);
    end;

    //Assen
    for i:= 0 to FSeries.Count - 1 do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i]);
      Serie.DrawModern(Cnvs);
    end;
  end;
end;

Procedure TAmoebe.DrawSlices(Cnvs : TCanvas; Re : TRect);
var i : LongInt;
    Serie : TAmoebeSerie;
    L, A, A2 : double;
    L2, X1, X2, X3, X4, Y1, Y2, Y3, Y4 : integer;
begin
  //Teken eerst de normcirkel gevuld, dan de slices, dan de normcirkel open en vervolgens de assen
  with Cnvs do
  begin
    Pen.Color:= clBlack;
    Brush.Style:= bsSolid;
    Brush.Color:= FNormColor;
    Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
            FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
  end;
  //Slices
  if (FSeries <> NIL) and (FSeries.Count > 0) then
  begin
    if FSeries.Count > 1 then A:= TAmoebeSerie(FSeries.Items[1]).Angle
    else A:= 45;
    Cnvs.Brush.Style:= bsSolid;
    Cnvs.Brush.Color:= FAmoebeColor;
    Cnvs.Pen.Color:= clBlack;
    Cnvs.Pen.Width:= 1;
    for i:= 1 to FSeries.Count do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i-1]);
      L:= Serie.Length * (Serie.Score - Serie.MinValue) / (Serie.MaxValue - Serie.MinValue);
      L2:= round(L);
      X1:= FStartPoint.X - L2; Y1:= FStartPoint.Y - L2;
      X2:= FStartPoint.X + L2; Y2:= FStartPoint.Y + L2;

      A2:= Serie.Angle + 0.51 * A;
      X3:= Round(FStartPoint.X + L * Sinus(A2));
      Y3:= Round(FStartPoint.Y - L * Cosinus(A2));

      A2:= Serie.Angle - 0.49 * A;
      X4:= Trunc(FStartPoint.X + L * Sinus(A2))+1;
      Y4:= Trunc(FStartPoint.Y - L * Cosinus(A2))+1;
      Cnvs.Brush.Color:= FAmoebeColor;
      Cnvs.Pen.Color:= Serie.Color;
      Cnvs.Pen.Width:= Serie.LineWidth;
      Cnvs.Pie(X1, Y1, X2, Y2, X3, Y3, X4, Y4);
    end;
    //Normcirkel open
    with Cnvs do
    begin
      Pen.Color:= clBlack;
      Brush.Color:= FNormColor;
      Brush.Style:= bsClear;
      Ellipse(FStartPoint.X - FNormLength, FStartPoint.Y - FNormLength,
              FStartPoint.X + FNormLength, FStartPoint.Y + FNormLength);
    end;
    //Assen
    for i:= 0 to FSeries.Count - 1 do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i]);
      Serie.DrawSlices(Cnvs);
    end;
  end;
end;

Procedure TAmoebe.FitToSize(Cnvs : TCanvas; Re : TRect);
var i, NormL, TitleHeight : LongInt;
    Mid : TPoint;
    Serie : TAmoebeSerie;
begin
  if (FSeries <> NIL) and (FSeries.Count > 0) then
  begin
    FFitting:= TRUE;

    if FTitle = '' then TitleHeight:= 0
    else
    begin
      Cnvs.Font.Assign(FTitleFont);
      TitleHeight:= round(1.25 * Cnvs.TextHeight(FTitle));
    end;

    Mid.X:= round(Re.Left + (Re.Right - Re.Left - 2)/2);
    Mid.Y:= TitleHeight + round(Re.Top + (Re.Bottom - Re.Top - 2 - TitleHeight)/2);
    StartPoint:= Mid;
    FLength:= MinI(Mid.X - Re.Left, Mid.Y - Re.Top - TitleHeight);
    NormL:= 1000000000;
    for i:= 1 to FSeries.Count do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i-1]);
      Serie.Length:= FLength;
      if Serie.NormLength < NormL then NormL:= Serie.NormLength;
    end;
    NormLength:= NormL;

    FFitting:= false;
  end;
end;

Procedure TAmoebe.SetNormColor(Value : TColor);
begin
  if FNormColor <> Value then
  begin
    FNormColor:= Value;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SetAmoebeColor(Value : TColor);
begin
  if FAmoebeColor <> Value then
  begin
    FAmoebeColor:= Value;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SetShowExtendedNorms(Value : boolean);
begin
  if FShowExtendedNorms <> Value then
  begin
    FShowExtendedNorms:= Value;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SetKind(Value : TAmoebeKind);
begin
  if FKind <> Value then
  begin
    FKind:= Value;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SetTitleFont(Value : TFont);
begin
  if (FTitleFont <> NIL) and (Value <> NIL) then
  begin
    FTitleFont.Assign(Value);
    if not FFitting then Invalidate;
  end;
end;

Function TAmoebe.GetSerie(Value : LongInt) : TAmoebeSerie;
begin
  if (FSeries <> NIL) AND (Value > 0) and (Value <= FSeries.Count) then
    Result:= FSeries.Items[Value-1]
  else Result:= NIL;
end;

Function TAmoebe.GetAmountSeries : LongInt;
begin
  Result:= 0;
  if FSeries <> NIL then Result:= FSeries.Count;
end;

Procedure TAmoebe.SetAmountSeries(Value : LongInt);
var i : LongInt;
begin
  if Value < 0 then Value:= 0;
  if FSeries = NIL then FSeries:= TList.Create;

  if FSeries.Count < Value then
    for i:= FSeries.Count + 1 to Value do
      AddSerie('Serie ' + IntToStr(i), '', 0, 10, 3, 5)
  else if FSeries.Count > Value then
    for i:= FSeries.Count downto Value + 1 do DeleteSerie(i);

  if not FFitting then Invalidate;
end;

Procedure TAmoebe.AddSerie(Text, AxUnit : string; MinValue, MaxValue, Score, Norm : double);
var i : LongInt;
    Serie : TAmoebeSerie;
begin
  if FSeries = NIL then FSeries:= TList.Create;
  FSeries.Capacity:= FSeries.Capacity + 1;
  FSeries.Add(TAmoebeSerie.Create(self));
  Serie:= FSeries.Items[FSeries.Count-1];
  Serie.Title:= Text;
  Serie.AxUnit:= AxUnit;
  Serie.MinValue:= MinValue;
  Serie.MaxValue:= MaxValue;
  Serie.Score:= Score;
  Serie.Norm:= Norm;
  Serie.Font.Assign(Font);
  for i:= 0 to FSeries.Count - 1 do
  begin
    Serie:= TAmoebeSerie(FSeries.Items[i]);
    Serie.StartPoint:= FStartPoint;
    Serie.Angle:= i * 360 / FSeries.Count;
  end;
  if not FFitting then Invalidate;
end;

Procedure TAmoebe.DeleteSerie(SerieNr : Longint);
var i : LongInt;
    Serie : TAmoebeSerie;
begin
  if (FSeries <> NIL) and (SerieNr <= FSeries.Count) then
  begin
    FSeries.Delete(SerieNr-1);
    FSeries.Pack;
    FSeries.Capacity:= FSeries.Capacity - 1;
    for i:= 0 to FSeries.Count - 1 do
    begin
      Serie:= TAmoebeSerie(FSeries.Items[i]);
      Serie.StartPoint:= FStartPoint;
      Serie.Angle:= i * 360 / FSeries.Count;
    end;
    if not FFitting then Invalidate;
  end;
end;

Function TAmoebe.GetScore(SerieNr : LongInt) : double;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Score;
end;

Procedure TAmoebe.SetScore(SerieNr : LongInt; Value : double);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Score:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.ScoreAsString(SerieNr, Dec : LongInt) : string;
begin
  Result:= RealToStrDec(GetScore(SerieNr), Dec);
end;

Function TAmoebe.GetSerieColor(SerieNr : LongInt) : TColor;
var Serie : TAmoebeSerie;
begin
  Result:= clWhite;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Color;
end;

Procedure TAmoebe.SetSerieColor(SerieNr : LongInt; Value : TColor);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Color:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetMinValue(SerieNr : LongInt) : double;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.MinValue;
end;

procedure TAmoebe.SetMinValue(SerieNr : LongInt; Value : double);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.MinValue:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetMaxValue(SerieNr : LongInt) : double;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.MaxValue;
end;

procedure TAmoebe.SetMaxValue(SerieNr : LongInt; Value : double);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.MaxValue:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetNorm(SerieNr : LongInt) : double;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Norm;
end;

Procedure TAmoebe.SetNorm(SerieNr : LongInt; Value : double);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Norm:= Value;
  if not FFitting then Invalidate;
end;

Procedure TAmoebe.SetTitle(Value : string);
begin
  if FTitle <> Value then
  begin
    FTitle:= Value;
    if not FFitting then Invalidate;
  end;
end;

Function TAmoebe.GetSerieTitle(SerieNr : LongInt) : string;
var Serie : TAmoebeSerie;
begin
  Result:= '';
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Title;
end;

Procedure TAmoebe.SetSerieTitle(SerieNr : LongInt; Value : string);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Title:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetAxUnit(SerieNr : LongInt) : string;
var Serie : TAmoebeSerie;
begin
  Result:= '';
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.AxUnit;
end;

procedure TAmoebe.SetAxUnit(SerieNr : LongInt; Value : string);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.AxUnit:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetSerieFont(SerieNr : Longint) : TFont;
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  Result:= NIL;
  if Serie <> NIL then Result:= Serie.Font;
end;

procedure TAmoebe.SetSerieFont(SerieNr : LongInt; Value : TFont);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Font.Assign(Value);
end;

Function TAmoebe.GetAngle(SerieNr : LongInt) : double;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Angle;
end;

Procedure TAmoebe.SetAngle(SerieNr : LongInt; Value : double);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Angle:= Value;
  if not FFitting then Invalidate;
end;

Function TAmoebe.GetLength(SerieNr : LongInt) : LongInt;
var Serie : TAmoebeSerie;
begin
  Result:= 0;
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Result:= Serie.Length;
end;

Procedure TAmoebe.SetLength(SerieNr, Value : LongInt);
var Serie : TAmoebeSerie;
begin
  Serie:= GetSerie(SerieNr);
  if Serie <> NIL then Serie.Length:= Value;
  if not FFitting then Invalidate;
end;

Procedure TAmoebe.SetNormLength(Value : LongInt);
var Serie : TAmoebeSerie;
    i : LongInt;
begin
  if Value > 0 then
  begin
    FNormLength:= Value;
    if FSeries <> NIL then
      for i:= 1 to FSeries.Count do
      begin
        Serie:= GetSerie(i);
        Serie.NormLength:= FNormLength;
      end;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SetStartPoint(Value : TPoint);
var Serie : TAmoebeSerie;
    i : LongInt;
begin
  if (FStartPoint.X <> Value.X) or (FStartPoint.Y <> Value.Y) then
  begin
    FStartPoint:= Value;
    if FSeries <> NIL then
      for i:= 1 to FSeries.Count do
      begin
        Serie:= GetSerie(i);
        Serie.StartPoint:= FStartPoint;
      end;
    if not FFitting then Invalidate;
  end;
end;

Procedure TAmoebe.SaveToBitmap(F : string);
var Bmp : TBitmap;
begin
  Bmp:= TBitmap.Create;
  Bmp.Height:= Height;
  Bmp.Width:= Width;
  try
    Draw(Bmp.Canvas, Rect(0, 0, Width, Height));
    Bmp.SaveToFile(F);
  finally
    Bmp.Free;
  end;
end;

{Procedure TAmoebe.SaveToMetafile(F : string; Enh : boolean);
var MyMetafile : TMetaFile;
    MfC : TMetaFileCanvas;
begin
  MyMetaFile:= TMetafile.Create;
  MyMetaFile.Enhanced:= Enh;
  MyMetaFile.Height:= Height;
  MyMetaFile.Width:= Width;
  MfC:= TMetafileCanvas.Create(MyMetafile, Canvas.Handle);
  try
    Draw(MfC, Rect(0, 0, Width, Height));
    MfC.Free;
    MyMetaFile.SaveToFile(F);
  finally
    MyMetafile.free;
  end;
end; }

Procedure TAmoebe.CopyToClipboard;
var MyBitmap : TBitmap;
begin
  Clipboard.Clear;
  MyBitmap:= TBitmap.Create;
  MyBitmap.Width:= Width;
  MyBitmap.Height:= Height;
  try
    Draw(MyBitmap.Canvas, Rect(0, 0, Width, Height));
    ClipBoard.Assign(MyBitmap);
  finally
    MyBitmap.free;
  end;
end;

Procedure TAmoebe.SetWidthMM(Cnvs : TCanvas; Value : double);
begin
  Width:= CmToPixels(Cnvs.Handle, Value/10, drHorizontal);
end;

Procedure TAmoebe.SetHeightMM(Cnvs : TCanvas; Value : double);
begin
  Height:= CmToPixels(Cnvs.Handle, Value/10, drVertical);
end;

Procedure TAmoebe.SetShowValues(b : boolean);
begin
  if FShowValues <> b then
  begin
    FShowValues:= b;
    Invalidate;
  end;
end;

Function TAmoebe.ExecuteEditor : boolean;
begin
  Result:= True;
{  if FAllowEditor then
  begin
    Application.CreateForm(TFrmAmoebeDlg, FrmAmoebeDlg);
    FrmAmoebeDlg.Execute(Self);
    frmAmoebeDlg.Free;
  end; }
end;

procedure TAmoebe.Assign(Source : TPersistent);
var i : LongInt;
    S1, S2 : TAmoebeSerie;
begin
  if (Source <> NIL) and (Source is TAmoebe) then
  begin
    FAmoebeColor:= TAmoebe(Source).AmoebeColor;
    FNormColor:= TAmoebe(Source).NormColor;
    Color:= TAmoebe(Source).Color;
    AmountSeries:= TAmoebe(Source).AmountSeries;
    Font.Assign(TAmoebe(Source).Font);
    FTitleFont.Assign(TAmoebe(Source).TitleFont);
    FTitle:= TAmoebe(Source).Title;
    FKind:= TAmoebe(Source).Kind;
    FShowValues:= TAmoebe(Source).ShowValues;
    for i:= 1 to AmountSeries do
    begin
      S1:= Serie[i];
      S2:= TAmoebe(Source).Serie[i];
      S1.FScore:= S2.Score;
      S1.FMinValue:= S2.MinValue;
      S1.FMaxValue:= S2.MaxValue;
      S1.FNorm:= S2.Norm;
      S1.FTitle:= S2.Title;
      S1.FAxUnit:= S2.AxUnit;
      S1.Color:= S2.Color;
      S1.LineWidth:= S2.LineWidth;
      S1.Font.Assign(S2.Font);
    end;
//    Inherited Assign(Source);
    FitToSize(Canvas, FRect);
    Invalidate;
  end;
end;

end.
 
