unit ColorBar;

{$MODE Delphi}

interface

uses
  SysUtils, Classes, Controls, Types, Graphics, Math, LCLIntf;

type
  TDirection = (dUp, dDown, dLeft, dRight);
  TEffect = (ePlain, eGlassy);

  TColorBar = class(TGraphicControl)
  private
    FMin, FMax, FTarget, FValue : LongInt;
    FCaption : string;
    FEffect : TEffect;
    FInsideColor, FOutsideColor, FIntermediateColor : TColor;
    FShowValues, FValuesInBar : boolean;
    FBandWidth : integer;
  protected
    Procedure SetMin(V : LongInt);
    Procedure SetMax(V : LongInt);
    Procedure SetTarget(V : LongInt);
    Procedure SetValue(V : LongInt);
    Procedure SetCaption(S : string);
    Procedure SetEffect(E : TEffect);
    Procedure SetInsideColor(V : TColor);
    Procedure SetOutsideColor(V : TColor);
    Procedure SetIntermediateColor(V : TColor);
    Procedure SetShowValues(V : boolean);
    Procedure SetValuesInBar(V : boolean);
    Procedure SetBandWidth(I : integer);
  public
    Constructor Create(AOwner : TComponent); override;
    procedure Paint; override;
  published
    property Min : LongInt read FMin write SetMin default -10;
    property Max: LongInt read FMax write SetMax default 10;
    property Target : LongInt read FTarget write SetTarget default 0;
    property Value : LongInt read FValue write SetValue default 5;
    property BandWidth : integer read FBandWidth write SetBandWidth default 50;
    property Caption : string read FCaption write SetCaption;
    property Effect : TEffect read FEffect write SetEffect default eGlassy;
    property InsideColor : TColor read FInsideColor write SetInsideColor default clGreen;
    property OutsideColor : TColor read FOutsideColor write SetOutsideColor default clRed;
    property IntermediateColor : TColor read FIntermediateColor write SetIntermediateColor default clYellow;
    property ShowValues : boolean read FShowValues write SetShowValues default true;
    property ValuesInBar : boolean read FValuesInBar write SetValuesInBar default false;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Adrie', [TColorBar]);
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
    Cnvs.MoveTo(X,Rect.Top);
    Cnvs.LineTo(X,Rect.Bottom);
    inc(cnt);
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
Constructor TColorBar.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
//  Parent:= TWinControl(AOwner);
  Visible:= True;
  Left:= 10;
  Top:= 10;
  Width:= 500;
  Height:= 50;
  FCaption:= 'Energiebalans (MJ): ';
  FMin:= -100;
  FMax:= 100;
  FValue:= 45;
  FTarget:= 0;
  FBandWidth:= 100;
  FEffect:= eGlassy;
  FInsideColor:= clGreen;
  FOutsideColor:= clRed;
  FIntermediateColor:= clYellow;
  FShowValues:= TRUE;
  FValuesInBar:= false;
end;

Procedure TColorBar.SetMin(V : LongInt);
begin
  if FMin <> V then
  begin
    FMin:= V;
    if FMax <= FMin then FMax:= FMin + 10;
    if FTarget <= FMin then FTarget:= FMin + 1;
    if FValue <= FMin then FValue:= FMin;
    Invalidate;
  end;
end;

Procedure TColorBar.SetMax(V : LongInt);
begin
  if FMax <> V then
  begin
    FMax:= V;
    if FMin >= FMax then FMin:= FMax - 10;
    if FTarget >= FMax then FTarget:= FMax - 9;
    if FValue >= FMax then FValue:= FMax;
    Invalidate;
  end;
end;

Procedure TColorBar.SetTarget(V : LongInt);
begin
  if FTarget <> V then
  begin
    FTarget:= V;
    if FMin > FTarget then FMin:= FTarget - 1;
    if FMax <= FTarget then FMax:= FTarget + 9;
    Invalidate;
  end;
end;

Procedure TColorBar.SetValue(V : LongInt);
begin
  if FValue <> V then
  begin
    FValue:= V;
    if FValue > FMax then FValue:= FMax;
    if FValue < FMin then FValue:= FMin;
    Invalidate;
  end;
end;

Procedure TColorBar.SetBandWidth(I : integer);
begin
  if (I >= 1) and (I <= 100) then
    FBandWidth:= I
  else if I < 1 then
    FBandWidth:= 1
  else FBandWidth:= 100;
end;

Procedure TColorBar.SetCaption(S : string);
begin
  if FCaption <> S then
  begin
    FCaption:= S;
    Invalidate;
  end;
end;

Procedure TColorBar.SetEffect(E : TEffect);
begin
  if FEffect <> E then
  begin
    FEffect:= E;
    Invalidate;
  end;
end;

Procedure TColorBar.SetInsideColor(V : TColor);
begin
  if FInsideColor <> V then
  begin
    FInsideColor:= V;
    Invalidate;
  end;
end;

Procedure TColorBar.SetOutsideColor(V : TColor);
begin
  if FoutsideColor <> V then
  begin
    FOutsideColor:= V;
    Invalidate;
  end;
end;

Procedure TColorBar.SetIntermediateColor(V : TColor);
begin
  if FIntermediateColor <> V then
  begin
    FIntermediateColor:= V;
    Invalidate;
  end;
end;

Procedure TColorBar.SetShowValues(V : boolean);
begin
  if FShowValues <> V then
  begin
    FShowValues:= V;
    Invalidate;
  end;
end;

Procedure TColorBar.SetValuesInBar(V : boolean);
begin
  if FValuesInBar <> V then
  begin
    FValuesInBar:= V;
    Invalidate;
  end;
end;

//Draw the visual component
Procedure TColorBar.Paint;
var Rct, BarRect, MarkRect : TRect;
    TH, TW, BarW, pMin, pTarget, pValue, pMax, pTolerance, TextX, TextY : integer;
    OldFontColor, OldPenColor, OldBrushColor, ValueColor, TargetColor, MinColor, MaxColor : TColor;
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
    pTarget:= pMin + round(BarW * (FTarget - FMin) / (FMax - FMin));
    pValue:= pMin + round(BarW * (FValue - FMin) / (FMax - FMin));
    pTolerance:= round(BarW * FBandWidth/100 * (FTarget - FMin) / (FMax - FMin));

    Rct.Top:= BarRect.Top;
    Rct.Bottom:= BarRect.Bottom;

    // from min to target-tolerance: OutsideColor
    Rct.Left:= pMin;
    Rct.Right:= pTarget - pTolerance;
    Bmp.Canvas.Pen.Color:= FOutsideColor;
    Bmp.Canvas.Brush.Color:= FOutsideColor;
    Bmp.Canvas.Rectangle(Rct);

    // from target-rolerance to target: FOutsideColor to FIntermediateColor
    Rct.Left:= Rct.Right;
    Rct.Right:= pTarget;
    GradHorizontal(Bmp.Canvas, Rct, FOutsideColor, FIntermediateColor);

    //From target to target + tolerance : FIntermediateColor to FInsideColor
    Rct.Left:= Rct.Right;
    Rct.Right:= pTarget + pTolerance;
    GradHorizontal(Bmp.Canvas, Rct, FIntermediateColor, FInsideColor);

    //from Low + tolerance to max : FInsideColor
    Rct.Left:= Rct.Right;
    Rct.Right:= pMax;
    Bmp.Canvas.Pen.Color:= FInsideColor;
    Bmp.Canvas.Brush.Color:= FInsideColor;
    Bmp.Canvas.Rectangle(Rct);

    ValueColor:= Bmp.Canvas.Pixels[pValue, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
    TargetColor:= Bmp.Canvas.Pixels[pTarget, round((BarRect.Bottom - BarRect.Top)/2 + BarRect.Top)];
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
    if FValuesInBar then TextY:= round(Bmp.Height/2) else TextY:= 0;
    ValueString:= IntToStr(FMin);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MinColor);
    if FValuesInBar then TextX:= pMin + 2
    else TextX:= pMin;
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);

    ValueString:= IntToStr(FTarget);
    MarkRect.Top:= 0;
    MarkRect.Bottom:= MarkRect.Top + round(0.7*TH);
    MarkRect.Left:= Round(pTarget - TH/2);
    MarkRect.Right:= MarkRect.Left + TH;
    DrawTriangle(Bmp.Canvas, MarkRect, TargetColor, TargetColor, dDown);
    Bmp.Canvas.MoveTo(pTarget, Rct.Top);
    Bmp.Canvas.LineTo(pTarget, Rct.Bottom);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(TargetColor);
    if FValuesInBar then TextX:= pTarget - round(0.5 * Bmp.Canvas.TextWidth(ValueString))
    else TextX:= pTarget - round(1.5 * Bmp.Canvas.TextWidth(ValueString));
    if FShowValues then Bmp.Canvas.TextOut(TextX, TextY, ValueString);

    ValueString:= IntToStr(FMax);
    if FValuesInBar then Bmp.Canvas.Font.Color:= InverseColor(MaxColor);
    if FValuesInBar then TextX:= pMax - Bmp.Canvas.TextWidth(ValueString) - 1
    else TextX:= pMax - Bmp.Canvas.TextWidth(ValueString);
    if FShowValues then Bmp.Canvas.TextOut(TexTX, TextY, ValueString);

    ValueString:= IntToStr(FValue);
    MarkRect.Left:= Round(pValue - TH/2);
    MarkRect.Right:= MarkRect.Left + TH;
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

