unit PositieInterval;

interface

uses
  LCLIntF, SysUtils, Classes, Controls, Types, Graphics, Math, Hulpfuncties;

type
  TDirection = (dUp, dDown, dLeft, dRight);
  TEffect = (ePlain, eGlassy);

  TPosInterval = class(TGraphicControl)
  private
    FMin, FMax, FLow, FHigh, FValue : double;
    FCaption : string;
    FEffect : TEffect;
    FInsideColor, FOutsideColor, FIntermediateColor : TColor;
    FColorScale, FShowValues, FValuesInBar : boolean;
    FDecimals : integer;
    { Private declarations }
  protected
    { Protected declarations }
    Procedure SetMin(V : double);
    Procedure SetMax(V : double);
    Procedure SetLow(V : double);
    Procedure SetHigh(V : double);
    Procedure SetValue(V : double);
    Procedure SetCaption(S : string);
    Procedure SetEffect(E : TEffect);
    Procedure SetInsideColor(V : TColor);
    Procedure SetOutsideColor(V : TColor);
    Procedure SetIntermediateColor(V : TColor);
    Procedure SetColorScale(V : boolean);
    Procedure SetShowValues(V : boolean);
    Procedure SetValuesInBar(V : boolean);
    Procedure SetDecimals(i : integer);
    Procedure PaintLinux;
    Procedure PaintWindows;
  public
    { Public declarations }
    Constructor Create(AOwner : TComponent); override;
    procedure Paint; override;
  published
    { Published declarations }
    property Min : double read FMin write SetMin;
    property Max: double read FMax write SetMax;
    property Low : double read FLow write SetLow;
    property High : double read FHigh write SetHigh;
    property Value : double read FValue write SetValue;
    property Caption : string read FCaption write SetCaption;
    property Effect : TEffect read FEffect write SetEffect default eGlassy;
    property InsideColor : TColor read FInsideColor write SetInsideColor default clGreen;
    property OutsideColor : TColor read FOutsideColor write SetOutsideColor default clRed;
    property IntermediateColor : TColor read FIntermediateColor write SetIntermediateColor default clYellow;
    property ColorScale : boolean read FColorScale write SetColorScale default false;
    property ShowValues : boolean read FShowValues write SetShowValues default true;
    property ValuesInBar : boolean read FValuesInBar write SetValuesInBar default false;
    property Decimals : integer read FDecimals write SetDecimals default 0;
  end;
  
procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Adrie', [TPosInterval]);
end;


//Create the glass-effect in a rectangular area (Rect) on a given Canvas (Cnvs)
Procedure Glassify(Cnvs : TCanvas; Rect: TRect);
var
  X, Y: integer;
  C1, C2: TColor;
  r1, r2, g1, g2, b1, b2, aR, aG, aB: Byte;
  R, Ymp: integer;
  rico: real;
const whiteangle = -0.60;  //the angle at which the light band is
      darkfact = 0.3;      //the maximum darkening factor
      whitefact = 0.9;     //the maximum whitening factor
begin
  R:= round((Rect.Bottom - Rect.Top)/2);
  Ymp:= Rect.Top + R;

  for Y:= Rect.Top to Rect.Bottom-1 do
  begin
    if sqr(R) <> sqr(Y - Ymp) then
    begin
      rico:= (Y - Ymp) / sqrt(sqr(R) - sqr(Y - Ymp));
    end
    else if Y = Rect.Top then
      Rico:= -1000
    else if R = Rect.Bottom-1 then
      Rico:= 1000;
    Rico:= TanH(Rico); //-1 -> 1

    if Rico < 0 then
      if Rico >= whiteangle then
        Rico:= -Rico / whiteangle
      else
        Rico:= -1 - (Rico - whiteangle);

    for X:= Rect.Left to Rect.Right-1 do
    begin
      C1:= Cnvs.Pixels[X, Y];
      R1 := GetRValue(C1);
      G1 := GetGValue(C1);
      B1 := GetBValue(C1);
      if Rico < 0 then //make more white
      begin
        aR:= 255 - R1;
        aG:= 255 - G1;
        aB:= 255 - B1;
        R2:= Ceil(R1 - aR * whitefact * rico);
        G2:= Ceil(G1 - aG * whitefact * rico);
        B2:= Ceil(B1 - aB * whitefact * rico);
      end
      else if Rico > 0 then //make more black
      begin
        R2:= Ceil(R1 * (1- darkfact*rico));
        G2:= Ceil(G1 * (1- darkfact*rico));
        B2:= Ceil(B1 * (1- darkfact*rico));
      end
      else
      begin
        R2:= R1;
        G2:= G1;
        B2:= B1;
      end;

      C2:= RGB(R2, G2, B2);
      Cnvs.Pixels[X, Y]:= C2;
    end;
  end;
end;

//Make a gradual color morphing (FromColor to ToColor) in a horizontal direction.
//Draw this on the given canvas (Cnvs) in a given rectangular area (Rect).
procedure GradHorizontal(Cnvs: TCanvas; Rect: TRect; FromColor, ToColor: TColor) ;
var
  X: integer;
  dr, dg, db: Extended;
  C1, C2: TColor;
  r1, r2, g1, g2, b1, b2: Byte;
  R, G, B: Byte;
  cnt: integer;
begin
  if Rect.Right > Rect.Left then
  begin
    C1 := FromColor;
    R1 := GetRValue(C1);
    G1 := GetGValue(C1);
    B1 := GetBValue(C1);

    C2 := ToColor;
    R2 := GetRValue(C2);
    G2 := GetGValue(C2);
    B2 := GetBValue(C2);

    dr := (R2-R1) / (Rect.Right-Rect.Left);
    dg := (G2-G1) / (Rect.Right-Rect.Left);
    db := (B2-B1) / (Rect.Right-Rect.Left);

    cnt := 0;
    for X := Rect.Left to Rect.Right-1 do
    begin
      R := R1+Ceil(dr*cnt);
      G := G1+Ceil(dg*cnt);
      B := B1+Ceil(db*cnt);

      Cnvs.Pen.Color := RGB(R,G,B);
      Cnvs.Brush.Color:= Cnvs.Pen.Color;
      Cnvs.MoveTo(X,Rect.Top);
      Cnvs.LineTo(X,Rect.Bottom);
      inc(cnt);
    end;
  end;
end;

//Draw a triangle in a given rectangular area (Rect) on a given Canvas (Cnvs).
//Use the given line and brush colors and point the triangle in the direction.
Procedure DrawTriangle(Cnvs: TCanvas; Rect: TRect; LineColor, BrushColor : TColor; Direction : TDirection);
var OldPenColor, OldBrushColor : TColor;
    OldPenStyle : TPenStyle;
    OldBrushStyle : TBrushStyle;
    Points: array of TPoint;
begin
  OldPenColor:= Cnvs.Pen.Color;
  OldBrushColor:= Cnvs.Brush.Color;
  OldPenStyle:= Cnvs.Pen.Style;
  OldBrushStyle:= Cnvs.Brush.Style;
  SetLength(Points, 3);
  case Direction of
  dUp:
  begin
    Points[0].x:= Rect.Left;
    Points[0].y:= Rect.Bottom;
    Points[1].x:= Rect.Right;
    Points[1].y:= Rect.Bottom;
    Points[2].x:= Rect.Left + Floor((Rect.Right- Rect.Left)/2);
    Points[2].y:= Rect.Top;
  end;
  dDown:
  begin
    Points[0].x:= Rect.Left;
    Points[0].y:= Rect.Top;
    Points[1].x:= Rect.Right;
    Points[1].y:= Rect.Top;
    Points[2].x:= Rect.Left + Floor((Rect.Right- Rect.Left)/2);
    Points[2].y:= Rect.Bottom;
  end;
  dLeft:
  begin
    Points[0].x:= Rect.Right;
    Points[0].y:= Rect.Top;
    Points[1].x:= Rect.Right;
    Points[1].y:= Rect.Bottom;
    Points[2].x:= Rect.Left;
    Points[2].y:= Rect.Top + Floor((Rect.Bottom- Rect.Top)/2);
  end;
  dRight:
  begin
    Points[0].x:= Rect.Left;
    Points[0].y:= Rect.Top;
    Points[1].x:= Rect.Left;
    Points[1].y:= Rect.Bottom;
    Points[2].x:= Rect.Right;
    Points[2].y:= Rect.Top + Floor((Rect.Bottom- Rect.Top)/2);
  end;
  end;
  Cnvs.Pen.Color:= LineColor;
  Cnvs.Brush.Color:= BrushColor;
  Cnvs.Brush.Style:= bsSolid;
  Cnvs.Polygon(Points);
  Cnvs.Pen.Color:= OldPenColor;
  Cnvs.Brush.Color:= OldBrushColor;
  Cnvs.Brush.Style:= OldBrushStyle;
  Cnvs.Pen.Style:= OldPenStyle;
end;

Function InverseColor(C : TColor) : TColor;
var r1, r2, g1, g2, b1, b2: Byte;
begin
  R1 := GetRValue(C);
  G1 := GetGValue(C);
  B1 := GetBValue(C);

  R2 := 255 - R1;
  G2 := 255 - G1;
  B2 := 255 - B1;
  Result:= RGB(R2, G2, B2);
end;

//Constructor for the component
Constructor TPosInterval.Create(AOwner : TComponent);
begin
  Inherited;
  Left:= 10;
  Top:= 10;
  Width:= 500;
  Height:= 70;
  FCaption:= 'Bitterheid: ';
  FMin:= 0;
  FMax:= 100;
  FValue:= 45;
  FLow:= 40;
  FHigh:= 65;
  FEffect:= ePlain;
  FInsideColor:= clGreen;
  FOutsideColor:= clRed;
  FIntermediateColor:= clYellow;
  FColorScale:= false;
  FShowValues:= TRUE;
  FValuesInBar:= false;
end;

Procedure TPosInterval.SetMin(V : double);
begin
  if FMin <> V then
  begin
    FMin:= V;
    if FMax <= FMin then FMax:= FMin + 10;
    if FLow <= FMin then FLow:= FMin + 1;
    if FHigh <= FMin then FHigh:= FMin + 9;
    if FValue <= FMin then FValue:= FMin;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetMax(V : double);
begin
  if FMax <> V then
  begin
    FMax:= V;
    if FMin >= FMax then FMin:= FMax - 10;
    if FLow >= FMax then FLow:= FMax - 9;
    if FHigh >= FMax then FHigh:= FMax - 1;
    if FValue >= FMax then FValue:= FMax;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetLow(V : double);
begin
  if FLow <> V then
  begin
    FLow:= V;
    if FMin >= FLow then FLow:= FMin + 1;
    if FHigh <= FLow then FHigh:= FLow + 8;
    if FMax <= FLow then FMax:= FLow + 9;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetDecimals(i : integer);
begin
  if (FDecimals <> i) and (i >= 0) and (i <= 6) then
  begin
    FDecimals:= i;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetHigh(V : double);
begin
  if FHigh <> V then
  begin
    FHigh:= V;
    if FLow >= FHigh then FLow:= FHigh - 8;
    if FMin >= FHigh then FMin:= FHigh - 9;
    if FMax < FHigh then FMax:= FHigh + 1;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetValue(V : double);
begin
  if FValue <> V then
  begin
    FValue:= V;
    if FValue > FMax then FValue:= FMax;
    if FValue < FMin then FValue:= FMin;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetCaption(S : string);
begin
  if FCaption <> S then
  begin
    FCaption:= S;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetEffect(E : TEffect);
begin
  if FEffect <> E then
  begin
    FEffect:= E;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetInsideColor(V : TColor);
begin
  if FInsideColor <> V then
  begin
    FInsideColor:= V;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetOutsideColor(V : TColor);
begin
  if FoutsideColor <> V then
  begin
    FOutsideColor:= V;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetIntermediateColor(V : TColor);
begin
  if FIntermediateColor <> V then
  begin
    FIntermediateColor:= V;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetColorScale(V : boolean);
begin
  if FColorScale <> V then
  begin
    FColorScale:= V;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetShowValues(V : boolean);
begin
  if FShowValues <> V then
  begin
    FShowValues:= V;
    Invalidate;
  end;
end;

Procedure TPosInterval.SetValuesInBar(V : boolean);
begin
  if FValuesInBar <> V then
  begin
    FValuesInBar:= V;
    Invalidate;
  end;
end;

//Draw the visual component
Procedure TPosInterval.Paint;
begin
  {$ifdef Linux}
  PaintLinux;
  {$endif}
  {$ifdef Windows}
  PaintWindows;
  {$endif}
end;

Procedure TPosInterval.PaintWindows;
var Rct, BarRect, MarkRect, PIRect : TRect;
    TH, TW, BarW, pMin, pLow, pValue, pHigh, pMax, pTolerance, TextX, TextY : integer;
    OldFontColor, OldPenColor, OldBrushColor, ValueColor, LowColor, HighColor, MinColor, MaxColor : TColor;
    MinC, MaxC : double;
    valuestring : string;
    i, j, step : integer;
const Margin : integer = 5;
begin
  OldPenColor:= Canvas.Pen.Color;
  OldBrushColor:= Canvas.Brush.Color;
  OldFontColor:= Canvas.Pen.Color;

  //Calculate the rect where the control needs to be drawn
  PIRect.Left:= Margin;
  PIRect.Right:= PIRect.Left + Width - 2 * Margin;
  PIRect.Top:= Margin;
  PIRect.Bottom:= PIRect.Top + Height - 2 * Margin;

  TH:= Canvas.TextHeight(FCaption);   //Height of the caption
  TW:= round(1.2 * Canvas.TextWidth(FCaption));    //Width of the caption
  BarW:= (PIRect.Right - PIRect.Left) - TW; //calculate the width of the bar
  If BarW < 0 then BarW:= 0;
  if BarW > 0 then
  begin
    BarRect:= Rect(TW, TH, (PIRect.Right - PIRect.Left) - 1,
                   (PIRect.Bottom - PIRect.Top)-1); //the rectangular area of the bar

    //Draw the caption
    TextY:= round((PIRect.Bottom - PIRect.Top)/2);
    Canvas.TextOut(PIRect.Left, TextY, FCaption);

    // paint background
    pMin:= TW;
    pMax:= BarRect.Right;
    pLow:= pMin + round(BarW * (FLow - FMin) / (FMax - FMin));
    pHigh:= pMin + round(BarW * (FHigh - FMin) / (FMax - FMin));
    pValue:= pMin + round(BarW * (FValue - FMin) / (FMax - FMin));
    pTolerance:= round(BarW * 0.1 * (FHigh - FLow) / (FMax - FMin));

    Rct.Top:= BarRect.Top;
    Rct.Bottom:= BarRect.Bottom;

    j:= pMin;
    if FColorScale then
    begin
      step:= round(BarW/20);
      Rct.Right:= pMin;
      MinC:= FMin;
      for i:= 1 to step do
      begin
        MaxC:= FMin + round(i / step * (FMax - FMin));
        Rct.Left:= Rct.Right;
        Rct.Right:= pMin + round(i/step * BarW);
        if Rct.Right > BarRect.Right then Rct.Right:= BarRect.Right;
        GradHorizontal(Canvas, Rct, SRMToColor(MinC), SRMToColor(MaxC));
        MinC:= MaxC;
      end;
    end
    else
    begin
      // from min to low-tolerance: OutsideColor
      Rct.Left:= pMin;
      Rct.Right:= pLow - pTolerance;
      Canvas.Pen.Color:= FOutsideColor;
      Canvas.Brush.Color:= FOutsideColor;
      Canvas.Rectangle(Rct);

      // from low-rolerance to low: FOutsideColor to FIntermediateColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pLow;
      GradHorizontal(Canvas, Rct, FOutsideColor, FIntermediateColor);

      //From low to low + tolerance : FIntermediateColor to FInsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pLow + pTolerance;
      GradHorizontal(Canvas, Rct, FIntermediateColor, FInsideColor);

      //from Low + tolerance to high - tolerance : FInsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh - pTolerance;
      Canvas.Pen.Color:= FInsideColor;
      Canvas.Brush.Color:= FInsideColor;
      Canvas.Rectangle(Rct);

      //from high - tolerance to high: from FInsideColor to FIntermediateColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh;
      GradHorizontal(Canvas, Rct, FInsideColor, FIntermediateColor);

      //from high to high + tolerance: from FIntermediateColor to FOutsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh + pTolerance;
      GradHorizontal(Canvas, Rct, FIntermediateColor, FOutsideColor);

      //from high+tolerance to max : FOutsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pMax;
      Canvas.Pen.Color:= FOutsideColor;
      Canvas.Brush.Color:= FOutsideColor;
      Canvas.Rectangle(Rct);
    end;
    
    ValueColor:= Canvas.Pixels[pValue, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    LowColor:= Canvas.Pixels[pLow, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    HighColor:= Canvas.Pixels[pHigh, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    MinColor:= Canvas.Pixels[pMin, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    MaxColor:= Canvas.Pixels[pMax, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];


    //Create Glassy effect
    if FEffect = eGlassy then Glassify(Canvas, BarRect);

    //Paint black line around bar
    Canvas.Brush.Style := bsClear;
    Canvas.Pen.Color:= clBlack;
    Rct.Left:= pMin;
    Canvas.Rectangle(BarRect);

    //Paint values and markings
{    if FValuesInBar then TextY:= round(Bmp.Height/2) else TextY:= 0;
    ValueString:= RealToStrDec(FMin, FDecimals);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MinColor);
    if FValuesInBar then TextX:= pMin + 2
    else TextX:= pMin;
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);}

    ValueString:= RealToStrDec(FLow, FDecimals);
    MarkRect.Top:= 0;
    MarkRect.Bottom:= MarkRect.Top + round(0.4*TH);
    MarkRect.Left:= pLow;
    MarkRect.Right:= pLow + round(0.4*TH);
    DrawTriangle(Canvas, MarkRect, LowColor, LowColor, dRight);
    Canvas.MoveTo(pLow, Rct.Top);
    Canvas.LineTo(pLow, Rct.Bottom);
    if FValuesInBar then Canvas.Font.Color:= InverseColor(LowColor);
    if FValuesInBar then TextX:= pLow - round(0.5 * Canvas.TextWidth(ValueString))
    else TextX:= pLow - round(1.5 * Canvas.TextWidth(ValueString));
    if FShowValues then Canvas.TextOut(TextX, TextY, ValueString);

    ValueString:= RealToStrDec(FHigh, FDecimals);
    MarkRect.Left:= pHigh - round(0.4*TH);
    MarkRect.Right:= pHigh;
    DrawTriangle(Canvas, MarkRect, HighColor, HighColor, dLeft);
    Canvas.MoveTo(pHigh, Rct.Top);
    Canvas.LineTo(pHigh, Rct.Bottom);
    if FValuesInBar then Canvas.Font.Color:= InverseColor(HighColor);
    if FValuesInBar then TextX:= pHigh - round(0.5 * Canvas.TextWidth(ValueString))
    else TextX:= pHigh + round(0.5 * Canvas.TextWidth(ValueString));
    if FShowValues then Canvas.TextOut(TextX, TextY, ValueString);

{    ValueString:= RealToStrDec(FMax, FDecimals);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MaxColor);
    if FValuesInBar then TextX:= pMax - Bmp.Canvas.TextWidth(ValueString) - 1
    else TextX:= pMax - Bmp.Canvas.TextWidth(ValueString);
    if FShowValues then Bmp.Canvas.TextOut(TexTX, TextY, ValueString);}

//    ValueString:= RealToStrDec(FValue, FDecimals);
    MarkRect.Left:= Round(pValue - (0.4*TH)/2);
    MarkRect.Right:= MarkRect.Left + round(0.4*TH);
    DrawTriangle(Canvas, MarkRect, ValueColor, ValueColor, dDown);
    Canvas.MoveTo(pValue, Rct.Top);
    Canvas.LineTo(pValue, Rct.Bottom);
    if FValuesInBar then Canvas.Font.Color:= InverseColor(ValueColor);
    if FValuesInBar then TextX:= pValue - round(0.5 * Canvas.TextWidth(ValueString))
    else TextX:= pValue - round(1.5 * Canvas.TextWidth(ValueString));
    if FShowValues then Canvas.TextOut(TextX, TextY, ValueString);
  end;
  Canvas.Pen.Color:= OldPenColor;
  Canvas.Brush.Color:= OldBrushColor;
  Canvas.Font.Color:= OldFontColor;
  Canvas.Brush.Style:= bsSolid;
end;

Procedure TPosInterval.PaintLinux;
var Rct, BarRect, MarkRect, PIRect : TRect;
    TH, TW, BarW, pMin, pLow, pValue, pHigh, pMax, pTolerance, TextX, TextY : integer;
    OldFontColor, OldPenColor, OldBrushColor, ValueColor, LowColor, HighColor, MinColor, MaxColor : TColor;
    MinC, MaxC : double;
    valuestring : string;
    Bmp : TBitmap;
    i, step : integer;
const Margin : integer = 5;
begin
  OldPenColor:= Canvas.Pen.Color;
  OldBrushColor:= Canvas.Brush.Color;
  OldFontColor:= Canvas.Pen.Color;

  //Create a bitmap to draw the component on.
  //Later we copy the bitmap to the component canvas.
  //This way we reduce the time needed to draw the component on the canvas.
  Bmp:= TBitmap.Create;
  Bmp.Width:= Width - 2 * Margin;
  Bmp.Height:= Height - 2 * Margin;
  Bmp.Canvas.Brush.Color:= Parent.Brush.Color;
  Bmp.Canvas.Pen.Color:= Parent.Brush.Color;
  Bmp.Canvas.Rectangle(Rect(0, 0, Bmp.Width-1, Bmp.Height-1));
  Bmp.Canvas.Font.Assign(Font);

  TH:= Bmp.Canvas.TextHeight(FCaption);   //Height of the caption
  TW:= Bmp.Canvas.TextWidth(FCaption);    //Width of the caption
  BarW:= Bmp.Width - TW; //calculate the width of the bar
  If BarW < 0 then BarW:= 0;
  if BarW > 0 then
  begin
    BarRect:= Rect(TW, TH, Bmp.Width - 1, Bmp.Height-1); //the rectangular area of the bar

    //Draw the caption
    TextY:= round(Bmp.Height/2);
    Bmp.Canvas.TextOut(0, TextY, FCaption);

    // paint background
    pMin:= TW;
    pMax:= BarRect.Right;
    pLow:= pMin + round(BarW * (FLow - FMin) / (FMax - FMin));
    pHigh:= pMin + round(BarW * (FHigh - FMin) / (FMax - FMin));
    pValue:= pMin + round(BarW * (FValue - FMin) / (FMax - FMin));
    pTolerance:= round(BarW * 0.1 * (FHigh - FMin) / (FMax - FMin));

    Rct.Top:= BarRect.Top;
    Rct.Bottom:= BarRect.Bottom;

    if FColorScale then
    begin
      step:= round(BarW/20);
      Rct.Right:= pMin;
      MinC:= FMin;
      for i:= 1 to step do
      begin
        MaxC:= FMin + round(i / step * (FMax - FMin));
        Rct.Left:= Rct.Right;
        Rct.Right:= pMin + round(i/step * BarW);
        if Rct.Right > BarRect.Right then Rct.Right:= BarRect.Right;
        GradHorizontal(Bmp.Canvas, Rct, SRMToColor(MinC), SRMToColor(MaxC));
        MinC:= MaxC;
      end;
    end
    else
    begin
      // from min to low-tolerance: OutsideColor
      Rct.Left:= pMin;
      Rct.Right:= pLow - pTolerance;
      Bmp.Canvas.Pen.Color:= FOutsideColor;
      Bmp.Canvas.Brush.Color:= FOutsideColor;
      Bmp.Canvas.Rectangle(Rct);

      // from low-rolerance to low: FOutsideColor to FIntermediateColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pLow;
      GradHorizontal(Bmp.Canvas, Rct, FOutsideColor, FIntermediateColor);

      //From low to low + tolerance : FIntermediateColor to FInsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pLow + pTolerance;
      GradHorizontal(Bmp.Canvas, Rct, FIntermediateColor, FInsideColor);

      //from Low + tolerance to high - tolerance : FInsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh - pTolerance;
      Bmp.Canvas.Pen.Color:= FInsideColor;
      Bmp.Canvas.Brush.Color:= FInsideColor;
      Bmp.Canvas.Rectangle(Rct);

      //from high - tolerance to high: from FInsideColor to FIntermediateColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh;
      GradHorizontal(Bmp.Canvas, Rct, FInsideColor, FIntermediateColor);

      //from high to high + tolerance: from FIntermediateColor to FOutsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pHigh + pTolerance;
      GradHorizontal(Bmp.Canvas, Rct, FIntermediateColor, FOutsideColor);

      //from high+tolerance to max : FOutsideColor
      Rct.Left:= Rct.Right;
      Rct.Right:= pMax;
      Bmp.Canvas.Pen.Color:= FOutsideColor;
      Bmp.Canvas.Brush.Color:= FOutsideColor;
      Bmp.Canvas.Rectangle(Rct);
    end;

    ValueColor:= Bmp.Canvas.Pixels[pValue, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    LowColor:= Bmp.Canvas.Pixels[pLow, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    HighColor:= Bmp.Canvas.Pixels[pHigh, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    MinColor:= Bmp.Canvas.Pixels[pMin, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    MaxColor:= Bmp.Canvas.Pixels[pMax, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];


    //Create Glassy effect
    if FEffect = eGlassy then Glassify(Bmp.Canvas, BarRect);

    //Paint black line around bar
    Bmp.Canvas.Brush.Style := bsClear;
    Bmp.Canvas.Pen.Color:= clBlack;
    Rct.Left:= pMin;
    Bmp.Canvas.Rectangle(BarRect);

    //Paint values and markings
{    if FValuesInBar then TextY:= round(Bmp.Height/2) else TextY:= 0;
    ValueString:= RealToStrDec(FMin, FDecimals);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MinColor);
    if FValuesInBar then TextX:= pMin + 2
    else TextX:= pMin;
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);}

    ValueString:= RealToStrDec(FLow, FDecimals);
    MarkRect.Top:= 0;
    MarkRect.Bottom:= MarkRect.Top + round(0.4*TH);
    MarkRect.Left:= pLow;
    MarkRect.Right:= pLow + round(0.4*TH);
    DrawTriangle(Bmp.Canvas, MarkRect, LowColor, LowColor, dRight);
    Bmp.Canvas.MoveTo(pLow, Rct.Top);
    Bmp.Canvas.LineTo(pLow, Rct.Bottom);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(LowColor);
    if FValuesInBar then TextX:= pLow - round(0.5 * Bmp.Canvas.TextWidth(ValueString))
    else TextX:= pLow - round(1.5 * Bmp.Canvas.TextWidth(ValueString));
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);

    ValueString:= RealToStrDec(FHigh, FDecimals);
    MarkRect.Left:= pHigh - round(0.4*TH);
    MarkRect.Right:= pHigh;
    DrawTriangle(Bmp.Canvas, MarkRect, HighColor, HighColor, dLeft);
    Bmp.Canvas.MoveTo(pHigh, Rct.Top);
    Bmp.Canvas.LineTo(pHigh, Rct.Bottom);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(HighColor);
    if FValuesInBar then TextX:= pHigh - round(0.5 * Bmp.Canvas.TextWidth(ValueString))
    else TextX:= pHigh + round(0.5 * Bmp.Canvas.TextWidth(ValueString));
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);

{    ValueString:= RealToStrDec(FMax, FDecimals);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MaxColor);
    if FValuesInBar then TextX:= pMax - Bmp.Canvas.TextWidth(ValueString) - 1
    else TextX:= pMax - Bmp.Canvas.TextWidth(ValueString);
    if FShowValues then Bmp.Canvas.TextOut(TexTX, TextY, ValueString);}

//    ValueString:= RealToStrDec(FValue, FDecimals);
    MarkRect.Left:= Round(pValue - (0.4*TH)/2);
    MarkRect.Right:= MarkRect.Left + round(0.4*TH);
    DrawTriangle(Bmp.Canvas, MarkRect, ValueColor, ValueColor, dDown);
    Bmp.Canvas.MoveTo(pValue, Rct.Top);
    Bmp.Canvas.LineTo(pValue, Rct.Bottom);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(ValueColor);
    if FValuesInBar then TextX:= pValue - round(0.5 * Bmp.Canvas.TextWidth(ValueString))
    else TextX:= pValue - round(1.5 * Bmp.Canvas.TextWidth(ValueString));
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);
  end;
  //copy the bitmap to the canvas
  Canvas.CopyMode:= cmSrcCopy;
  Rct.Left:= Margin;
  Rct.Right:= Rct.Left + Bmp.Width;
  Rct.Top:= Margin;
  Rct.Bottom:= Rct.Top + Bmp.Height;
  Canvas.CopyRect(Rct, Bmp.Canvas, Rect(0,0, Bmp.Width-1, Bmp.Height-1));

  Bmp.Canvas.Pen.Color:= OldPenColor;
  Bmp.Canvas.Brush.Color:= OldBrushColor;
  Bmp.Canvas.Font.Color:= OldFontColor;
  Bmp.Canvas.Brush.Style:= bsSolid;
  Canvas.Pen.Color:= OldPenColor;
  Canvas.Brush.Color:= OldBrushColor;
  Canvas.Font.Color:= OldFontColor;
  Canvas.Brush.Style:= bsSolid;

  //Release the memory occupied by the bitmap
  Bmp.Free;
end;

end.
