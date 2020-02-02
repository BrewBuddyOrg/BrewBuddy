unit BHgraphics;

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
  SysUtils, Graphics, Grids, Classes, Math, Dialogs;

type
  TDataPoint = record
    X, Y : Double;
  end;

  TAlignVert = (avTop, avCenter, avBottom);

  TDirection = (drHorizontal, drVertical);

Const
  Inch = 2.541;

{Related to graphics}
//Procedure Scale(var Min, Max, De : Double; var Astr : LongInt);
Procedure ScaleFixed(var Min, Max, De : Double; var Astr : LongInt);
Procedure ScaleDate(var Min, Max, De : TDateTime; var Astr : LongInt);
Function IsInSquare(P : TPoint; Rec : TRect) : boolean;
Function BetweenPoints(P1, P2, P : TPoint) : boolean;
Function CalcTextHeight( FontSize, PPIY : integer) : integer;
Function CalcMaxWidth( Canvas : TCanvas;  Text : string) : LongInt;
Function Overlap(Re1, Re2 : TRect) : boolean;

Function CmToPixels(Handle : HDC; Cm : Double; Direction : TDirection) : LongInt;
Function PixelsToCm(Handle : HDC; Pix : LongInt; Direction : TDirection) : Double;
Function PixelsToPoints(Handle : HDC; Pix : LongInt; Direction : TDirection) : Double;
Function PointsToPixels(Handle : HDC; Poi : Double; Direction : TDirection) : LongInt;
Function CmToPoints(Cm : Double) : Double;
Function PointsToCm(Poi : Double) : Double;

{Graphics}
Procedure DrawShadow(Canvas : TCanvas; X, Y, W, H, D: SmallInt; Up, OutSide: boolean);
Function DrawInRect(Canvas : TCanvas; P1, P2 : TPoint; Rec : TRect) : boolean;
Function CalcAmountLines(Canvas : TCanvas;  Text : string; Width : LongInt) : LongInt;
Function GiveNextLine( Canvas : TCanvas;  Text : string;
                       Width : LongInt; var Pos : LongInt) : string;
Function DrawTxt( Canvas : TCanvas;  MiddleHeight, Left, Right : LongInt;
                  Text : string;  Alignment : TAlignment;
                  MoreLines : boolean) : integer;
Function DrawTextWin(Canvas : TCanvas; Text : string; Rect : TRect; Alignment : TAlignment;
                     Align : TAlignVert; MoreLines, CalcRect : boolean) : integer;
Function DrawTextRect(Canvas : TCanvas; Text : string; Rect : TRect; Alignment : TAlignment;
                      Align : TAlignVert; MoreLines : boolean) : integer;
{Function RotateText(Canvas : TCanvas; X, Y: LongInt; Angle : Single; Text : string;
                    Transparant : boolean) : TRect;
Function RotateTextRect(Canvas : TCanvas; Re: TRect; Angle : Single; Text : string;
                        Alignment : TAlignment; Align : TAlignVert; Transparant : boolean) : TRect;}
Function Pie(Canvas : TCanvas; X1, Y1, X2, Y2, X3, Y3, X4, Y4 : integer) : boolean;
Function PolyPolygon(Canvas : TCanvas; Points: array of TPoint; {PolyCounts : array of integer;} AmPoly : integer) : boolean;
Function PolyRoundedLine(Canvas : TCanvas; Points : array of TPoint; RoundPerc : single) : boolean;

implementation

uses types, hulpfuncties;                                  {Related to graphics}

Procedure RelativeRound(var Min, Max, X : single);
var Ordr, OMin, Omax : SmallInt;
    A, B : integer;
    C : Extended;
begin
  OMin:= Order(Min); OMax:= Order(Max);
  if OMin < OMax then Ordr:= OMin else Ordr:= OMax;
  if Ordr < 0 then
  begin
    A:= round(InvLog(Abs(Ordr)));
    B:= round(X * A);
    X:= 0;
    C:= B / A;
    X:= C;
    B:= round(Min * A);
    Min:= B / A;
    B:= round(Max * A);
    Max:= B / A;
  end;
end;

Procedure ScaleFixed(var Min, Max, De : Double; var Astr : LongInt);
var   Lg, Fr : Double;
      Ast : LongInt;
Const StrMax = 15;
      StrMin = 6;
begin
  ASt:= round(Max);
  De:= 1;
  While (Ast < StrMin) or (Ast > StrMax) do
  begin
    ASt:= round((Max) / De);

    Lg:= Log10(De);
    if Frac(Lg) = 0 then Lg:= De
    else if (Lg < 0) then Lg:= InvLog(Trunc(Lg) - 1)
    else Lg:= InvLog(Trunc(Lg));
    Fr:= De / Lg;
    if Fr > 5 then Fr:= 1;
    if Fr < 1 then Fr:= 5;
    if Ast <= 2 then De:= 0.1 * De
    else if Ast >= 100 then De:= 10 * De
    else if Ast < StrMin then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De / 2
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De / 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De / 2.5;
    end
    else if Ast > StrMax then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De * 2.5
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De * 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De * 2;
    end;
  end;
  if Frac(Min / De) <> 0.0 then
  begin
    if Min > 0 then Min:= Trunc(Min / De) * De
    else Min:= (Trunc(Min / De) - 1) * De;
  end;
  if Frac(Max / De) <> 0.0 then
  begin
    if Max > 0 then Max:= (Trunc(Max / De) + 1) * De
    else Max:= Trunc(Max / De) * De;
  end;
  AStr:= round((Max) / De);
end;

Procedure CalcScale(var Min, Max, De : Double; var AStr : LongInt);
var   Lg, Fr : Double;
      Ast : LongInt;
Const StrMax = 15;
      StrMin = 6;
begin
  if Min <> 0 then De:= InvLog(Order(Min))
  else if Max <> 0 then De:= InvLog(Order(Max));

  ASt:= round(Abs(Max - Min)/ De);
  While (Ast < StrMin) or (Ast > StrMax) do
  begin
    ASt:= round(Abs(Max - Min)/ De);

    Lg:= Log10(De);
    if Frac(Lg) = 0 then Lg:= De
    else if (Lg < 0) then Lg:= InvLog(Trunc(Lg) - 1)
    else Lg:= InvLog(Trunc(Lg));
    Fr:= De / Lg;
    if Fr > 5 then Fr:= 1;
    if Fr < 1 then Fr:= 5;
    if Ast <= 2 then De:= 0.1 * De
    else if Ast >= 100 then De:= 10 * De
    else if Ast < StrMin then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De / 2
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De / 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De / 2.5;
    end
    else if Ast > StrMax then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De * 2.5
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De * 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De * 2;
    end;
  end;
  if Frac(Min / De) <> 0.0 then
  begin
    if Min > 0 then Min:= Trunc(Min / De) * De
    else Min:= (Trunc(Min / De) - 1) * De;
  end;
  if Frac(Max / De) <> 0.0 then
  begin
    if Max > 0 then Max:= (Trunc(Max / De) + 1) * De
    else Max:= Trunc(Max / De) * De;
  end;
  AStr:= round(Abs(Max - Min)/ De);
  if Min > Max then SwapW(Min, Max);
end;

{Procedure Scale(var Min, Max, De : Double; var Astr : LongInt);
var SignMin, SignMax : ShortInt;
begin
  SignMin:= Sign(Min); SignMax:= Sign(Max);
  if ((Min >= 0) and (Max >= 0)) then
  begin
    If Order(Min) = Order(Max) then
    begin
      Min:= RoundOrder(Min); Max:= RoundOrderHigh(Max);
    end
    else
    begin
      Min:= 0; Max:= RoundOrderHigh(Max);
    end;
    CalcScale(Min, Max, De, AStr);
  end
  else if ((Min <= 0) and (Max <= 0)) then
  begin
    if Order(Min) = Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= RoundOrder(Max);
    end
    else
    begin
      Min:= RoundOrderHigh(Min); Max:= 0;
    end;
    CalcScale(Min, Max, De, AStr);
  end
  else
  begin
    if Order(Min) = Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= RoundOrderHigh(Max);
    end
    else if Order(Min) > Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= -Min;
    end
    else if Order(Max) > Order(Min) then
    begin
      Max:= RoundOrderHigh(Max); Min:= -Max;
    end;
    CalcScale(Min, Max, De, AStr);
  end;

  //RelativeRound(Min, Max, De);
  if Sign(Min) <> SignMin then Min:= Abs(Min) * SignMin;
  if Sign(Max) <> SignMax then Max:= Abs(Max) * SignMax;
  if (Abs(round(Max) - Max) < abs(0.001 * Max)) and (abs(Max) > 1) then
    Max:= round(Max);
  if (Abs(round(Min) - Min) < abs(0.001 * Min)) and (abs(Min) > 1) then
    Min:= round(Min);
end;  }

Procedure ScaleDate(var Min, Max, De : TDateTime; var Astr : LongInt);
{var   Y1M1, D1 : longint;
      Y2, M2, D2, MaxD : longint;}
Const StrMax = 15;
      StrMin = 6;
begin
{  DecodeDate(Min, Y1, M1, D1);
  DecodeDate(Max, Y2, M2, D2); }
{  case M2 of
  1, 3, 5, 7, 8, 10, 12 : D2:= 31;
  4, 6, 9, 11 : D2:= 30;
  2 : if Y2 mod 4 = 0 then D2:= 29 else D2:= 28;
  end;}

 { Min:= EncodeDate(Y1, M1, 1);
  Max:= EncodeDate(Y2, M2, D2);}
  AStr:= 6;
  De:= (Max - Min) / 6;
end;

Function Overlap(Re1, Re2 : TRect) : boolean;
var R : TRect;
begin
  Result:= Intersectrect(R, Re1, Re2);
end;

Function IsInSquare(P : TPoint; Rec : TRect) : boolean;
begin
  Result:= TRUE;
  if P.X < Rec.Left then Result:= false;
  if P.X > Rec.Right then Result:= false;
  if P.Y < Rec.Top then Result:= false;
  if P.Y > Rec.Bottom then Result:= false;
end;

Function BetweenPoints(P1, P2, P : TPoint) : boolean;
begin
  Result:= TRUE;
  if ((P.X < P1.X) and (P.X < P2.X)) or ((P.X > P1.X) and (P.X > P2.X)) then
    Result:= false
  else if ((P.Y < P1.Y) and (P.Y < P2.Y)) or ((P.Y < P1.Y) and (P.Y < P2.Y)) then
    Result:= false;
end;

Function NextWord( Line : string; var Pos : LongInt) : string;
var Ch : string[1];
begin
  Result:= '';
  repeat
    Ch:= Copy(Line, Pos, 1);
    if (Ch <> ' ') then Result:= Result + Ch;
    Inc(Pos);
  until (Ch = ' ') or (Ch = '-') or (Pos > Length(Line));
end;

Function CalcMaxWidth( Canvas : TCanvas;  Text : string) : LongInt;
var Wrd : string;
    Pos : LongInt;
begin
  Result:= 0;
  Pos:= 1;
  while Pos <= Length(Text) do
  begin
    Wrd:= NextWord(Text, Pos);
    if Canvas.TextWidth(Wrd) > Result then Result:= Canvas.TextWidth(Wrd);
  end;
end;

Function CalcAmountLines( Canvas : TCanvas;  Text : string;
                          Width : LongInt) : LongInt;
var Pos : LongInt;
    Line, LineTst, Wrd : string;
begin
  Result:= 0; Pos:= 1; Wrd:= '';
  repeat
    Line:= Wrd; LineTst:= Wrd;
    repeat
      Wrd:= NextWord(Text, Pos);
      LineTst:= LineTst + ' ' + Wrd;
      if Canvas.TextWidth(LineTst) <= Width then Line:= LineTst;
    until (Canvas.TextWidth(LineTst) >= Width) or (Pos >= Length(Text));
    Inc(Result);
  until Pos >= length(Text);
  if LineTst <> Line then Inc(Result);
end;

Function GiveNextLine( Canvas : TCanvas;  Text : string;
                       Width : LongInt; var Pos : LongInt) : string;
var LineTst, Wrd : string;
    PosOld : longint;
begin
  Result:= ''; LineTst:= ''; PosOld:= Pos;
  repeat
    Wrd:= NextWord(Text, Pos);
    LineTst:= LineTst + Wrd;
    if Canvas.TextWidth(LineTst+' ') <= Width then
    begin
      if Pos <= Length(Text) then LineTst:= LineTst + ' ';
      Result:= LineTst;
      PosOld:= Pos;
    end;
  until ((PosOld <> Pos) or (Canvas.TextWidth(Result) >= width) or (Pos > Length(Text)));
  Pos:= PosOld;
end;

Function CalcTextHeight( FontSize, PPIY : integer) : integer;
begin
  {Room for caption : }
  Result:= round(FontSize * PPIY / 72);
end;

Function DrawTxt( Canvas : TCanvas;  MiddleHeight, Left, Right : LongInt;
                   Text : string;  Alignment : TAlignment;
                   MoreLines : boolean) : integer;
var BoxWidth, X, AmountLines, counter, MH, Pos : LongInt;
    Rec : TRect;
    Lne : string;
begin
  Rec.Right:= Right; Rec.Left:= Left; Result:= 0;
  X:= 0; AmountLines:= 0;
  with Canvas do
  begin
    BoxWidth:= Rec.Right - Rec.Left;
    if MoreLines then
    begin
      Pos:= CalcMaxWidth(Canvas, Text);
      BoxWidth:= MaxI(BoxWidth, Pos);
      AmountLines:= CalcAmountLines(Canvas, Text, BoxWidth);
      Result:= AmountLines * TextHeight(Text);
    end
    else Result:= TextHeight(Text);
    Rec.Left:= Left;
    Rec.Right:= Right;
    Pos:= 1;
    if MoreLines then
    begin
      for counter:= 1 to AmountLines do
      begin
        Lne:= GiveNextLine(Canvas, Text, BoxWidth, Pos);
        if Lne[Length(Lne)] = ' ' then
        Lne:= Copy(Lne, 1, Length(Lne) - 1);
        MH:= MiddleHeight + round(-0.5 * Result + (counter - 0.5) * TextHeight(Text));
        Rec.Top:= MH - round(0.5 * TextHeight(Text));
        Rec.Bottom:= Rec.Top + TextHeight(Text);

        if Alignment = taLeftJustify then X:= Rec.Left
        else if Alignment = taRightJustify then X:= MaxI(Rec.Right - TextWidth(Lne), 0)
        else if Alignment = taCenter then X:= Rec.Left + round(0.5 * (BoxWidth - TextWidth(Lne)));
        TextRect(Rec, X, Rec.Top, Lne);
      end;
    end
    else
    begin
      Rec.Top:= MiddleHeight - round(0.5 * TextHeight(Text));
      Rec.Bottom:= Rec.Top + TextHeight(Text);
      if Alignment = taLeftJustify then X:= Rec.Left
      else if Alignment = taRightJustify then X:= MaxI(Rec.Right - TextWidth(Text), 0)
      else if Alignment = taCenter then X:= MaxI(Rec.Left + round(0.5 * (BoxWidth - TextWidth(Text))), 0);
      TextRect(Rec, X, Rec.Top, Text);
    end;
  end;
  Result:= Rec.Bottom;
end;

Function DrawTextWin(Canvas : TCanvas; Text : string; Rect : TRect; Alignment : TAlignment;
                     Align : TAlignVert; MoreLines, CalcRect : boolean) : integer;
var Parm : Cardinal;
    T : array[0..255] of Char;
begin
  Result:= 0;
  case Alignment of
  taLeftJustify : Parm:= DT_Left;
  taCenter : Parm:= DT_CENTER;
  taRightJustify : Parm:= DT_RIGHT;
  end;
  case Align of
  avTop : if MoreLines then Parm:= Parm or DT_WORDBREAK or DT_TOP
          else Parm:= Parm or DT_TOP;
  avCenter: Parm:= Parm or DT_VCENTER or DT_SINGLELINE;
  avBottom: Parm:= Parm or DT_BOTTOM or DT_SINGLELINE;
  end;
  if MoreLines then Parm:= Parm or DT_WORDBREAK;
  if CalcRect then Parm:= Parm or DT_CALCRECT;
  StrPCopy(T, Text);
  Result:= DrawText(Canvas.Handle, T, Length(Text), Rect, Parm);
end;

Function DrawTextRect(Canvas : TCanvas; Text : string; Rect : TRect; Alignment : TAlignment;
                      Align : TAlignVert; MoreLines : boolean) : integer;
var BoxWidth, X, AmountLines, counter, Pos : LongInt;
    Rec : TRect;
    Lne : string;
begin
  Rec.Right:= Rect.Right; Rec.Left:= Rect.Left; Result:= 0;
  X:= 0; AmountLines:= 0;
  with Canvas do
  begin
    BoxWidth:= Rect.Right - Rect.Left;
    if MoreLines then
    begin
      Pos:= CalcMaxWidth(Canvas, Text);
      if Pos > BoxWidth then BoxWidth:= Pos;
      AmountLines:= CalcAmountLines(Canvas, Text, BoxWidth);
      Result:= AmountLines * TextHeight(Text);
    end
    else Result:= TextHeight(Text);
    Rec.Left:= Rect.Left;
    Rec.Right:= Rect.Right;
    Pos:= 1;
    if MoreLines then
    begin
      for counter:= 1 to AmountLines do
      begin
        Lne:= GiveNextLine(Canvas, Text, BoxWidth, Pos);
        if Lne <> '' then
        begin
          if Lne[Length(Lne)] = ' ' then
          Lne:= Copy(Lne, 1, Length(Lne) - 1);
          case Align of
          avCenter: Rec.Top:= round((Rect.Top + Rect.Bottom) / 2 + (counter - 1 - AmountLines / 2) * TextHeight(Text));
          avTop:    Rec.Top:= Rect.Top + (counter - 1) * TextHeight(Text);
          avBottom: Rec.Top:= Rect.Bottom - (AmountLines - counter + 1) * TextHeight(Text);
          end;
          Rec.Bottom:= Rec.Top + TextHeight(Text);

          if Alignment = taLeftJustify then X:= Rec.Left
          else if Alignment = taRightJustify then  X:= Rec.Right - TextWidth(Lne)
          else if Alignment = taCenter then X:= Rec.Left + round(0.5 * (BoxWidth - TextWidth(Lne)));
          TextRect(Rec, X, Rec.Top, Lne);
        end;
      end;
    end
    else
    begin
      case Align of
      avCenter: Rec.Top:= Rect.Top + round(0.5 * (Rect.Bottom - Rect.Top - TextHeight(Text)));
      avTop:    Rec.Top:= Rect.Top;
      avBottom: Rec.Top:= Rect.Bottom - TextHeight(Text);
      end;
      Rec.Bottom:= Rec.Top + TextHeight(Text);

      if Alignment = taLeftJustify then X:= Rec.Left
      else if Alignment = taRightJustify then X:= Rec.Right - TextWidth(Text)
      else if Alignment = taCenter then
      begin
        X:= Rec.Left + round(0.5 * (BoxWidth - TextWidth(Text)));
        if X < 0 then X:= 0;
      end;
      TextRect(Rec, X, Rec.Top, Text);
    end;
  end;
  Result:= Rec.Bottom;
end;

{Function RotateText(Canvas : TCanvas; X, Y: LongInt; Angle : Single; Text : string;
                    Transparant : boolean) : TRect;
var Font, OldFont : HFont;
    LogFont : TLogFont;
    Angle10 : LongInt;
    OldBKMode : integer;
    T : array[0..255] of Char;
begin
  Angle10:= round(10 * Angle);
  OldBKMode:= GetBKMode(Canvas.Handle);
  if Transparant then SetBKMode(Canvas.Handle, TRANSPARENT)
  else SetBKMode(Canvas.Handle, OPAQUE);
  with LogFont do
  begin
    lfHeight:= Canvas.Font.Height;
    lfWidth:= 0;
    lfEscapement:= Angle10;
    lfOrientation:= Angle10;
    if fsBold in Canvas.Font.Style then
      lfWeight:= 700
    else lfWeight:= 400;
    lfItalic:= byte(fsItalic in Canvas.Font.Style);
    lfUnderline:= byte(fsUnderLine in Canvas.Font.Style);
    lfStrikeOut:= byte(fsStrikeOut in Canvas.Font.Style);
    lfCharSet:= Canvas.Font.CharSet;
    lfOutPrecision:= OUT_TT_ONLY_PRECIS;
    lfClipPrecision:= CLIP_DEFAULT_PRECIS;
    lfQuality:= PROOF_QUALITY;
    if Canvas.Font.Pitch = fpDefault then
      lfPitchAndFamily:= DEFAULT_PITCH or FF_DONTCARE
    else if Canvas.Font.Pitch = fpVariable then
      lfPitchAndFamily:= VARIABLE_PITCH or FF_DONTCARE
    else lfPitchAndFamily:= FIXED_PITCH or FF_DONTCARE;
    StrPCopy(lfFaceName, Canvas.Font.Name);
  end;
  Font:= CreateFontIndirect(LogFont);
  OldFont:= SelectObject(Canvas.Handle, Font);
  StrPCopy(T, Text);
  TextOut(Canvas.Handle, X, Y, T, Length(Text));

  Result.Left:= X; Result.Top:= Y;
  Result.Right:= Result.Left + Canvas.TextWidth(Text);
  Result.Bottom:= Result.Top + Canvas.TextHeight(Text);

  SelectObject(Canvas.Handle, OldFont);
  DeleteObject(Font);
  SetBKMode(Canvas.Handle, OldBKMode);
end;

Function RotateTextRect(Canvas : TCanvas; Re: TRect; Angle : Single; Text : string;
                        Alignment : TAlignment; Align : TAlignVert; Transparant : boolean) : TRect;
var Font, OldFont : HFont;
    LogFont : TLogFont;
    Angle10, X, Y, dX, dY, H, W : LongInt;
    OldBKMode : integer;
    T : array[0..255] of Char;
    A : LongInt;
begin
  A:= GetTextAlign(Canvas.Handle);
  OldBKMode:= GetBKMode(Canvas.Handle);
  if Transparant then SetBKMode(Canvas.Handle, TRANSPARENT)
  else SetBKMode(Canvas.Handle, OPAQUE);

  while Angle < 0 do Angle:= Angle + 360;
  while Angle > 360 do Angle:= Angle - 360;
  Angle10:= round(10 * Angle);

  SetTextAlign(Canvas.Handle, ta_BaseLine or ta_Left);

  H:= Canvas.TextHeight(Text);
  W:= Canvas.TextWidth(Text);
  dX:= Round(Abs(Sinus(Angle)) * W + 0.5 * H);
  dY:= Round(Abs(Cosinus(Angle)) * W + 0.5 * H);

  if Align = avTop then
  begin
    Result.Top:= Re.Top; Result.Bottom:= Result.Top + dY;
  end
  else if Align = avCenter then
  begin
    Result.Top:= round((Re.Top + Re.Bottom) / 2 - 0.5 * dY);
    Result.Bottom:= round((Re.Top + Re.Bottom) / 2 + 0.5 * dY);
  end
  else
  begin
    Result.Bottom:= Re.Bottom;
    Result.Top:= Re.Bottom - dY;
  end;
  if Alignment = taLeftJustify then
  begin
    Result.Left:= Re.Left; Result.Right:= Re.Left + dX;
  end
  else if Alignment = taCenter then
  begin
    Result.Left:= round((Re.Right - Re.Left)/2 - 0.5 * dX);
    Result.Right:= round((Re.Right - Re.Left)/2 + 0.5 * dX);
  end
  else if Alignment = taRightJustify then
  begin
    Result.Right:= Re.Right;
    Result.Left:= Re.Right - dX;
  end;

  if (Angle >= 0) and (Angle <= 90) then
  begin
    X:= Result.Left + round(0.5 * H); Y:= Result.Bottom;
  end
  else if (Angle > 90) and (Angle < 180) then
  begin
    X:= Result.Right - round(0.5 * H); Y:= Result.Bottom;
  end
  else if (Angle >= 180) and (Angle < 270) then
  begin
    X:= Result.Right - round(0.5 * H); Y:= Result.Top;
  end
  else
  begin
    X:= Result.Left + round(0.5 * H); Y:= Result.Top;
  end;

  with LogFont do
  begin
    lfHeight:= Canvas.Font.Height;
    lfWidth:= 0;
    lfEscapement:= Angle10;
    lfOrientation:= Angle10;
    if fsBold in Canvas.Font.Style then
      lfWeight:= 700
    else lfWeight:= 400;
    lfItalic:= byte(fsItalic in Canvas.Font.Style);
    lfUnderline:= byte(fsUnderLine in Canvas.Font.Style);
    lfStrikeOut:= byte(fsStrikeOut in Canvas.Font.Style);
    lfCharSet:= Canvas.Font.CharSet;
    lfOutPrecision:= OUT_TT_ONLY_PRECIS;
    lfClipPrecision:= CLIP_DEFAULT_PRECIS;
    lfQuality:= PROOF_QUALITY;
    if Canvas.Font.Pitch = fpDefault then
      lfPitchAndFamily:= DEFAULT_PITCH or FF_DONTCARE
    else if Canvas.Font.Pitch = fpVariable then
      lfPitchAndFamily:= VARIABLE_PITCH or FF_DONTCARE
    else lfPitchAndFamily:= FIXED_PITCH or FF_DONTCARE;
    StrPCopy(lfFaceName, Canvas.Font.Name);
  end;
  Font:= CreateFontIndirect(LogFont);
  OldFont:= SelectObject(Canvas.Handle, Font);
  StrPCopy(T, Text);
  TextOut(Canvas.Handle, X, Y, T, Length(Text));

  SelectObject(Canvas.Handle, OldFont);
  DeleteObject(Font);
  SetTextAlign(Canvas.Handle, A);
  SetBKMode(Canvas.Handle, OldBKMode);
end; }

{Function RotateText(Canvas : TCanvas; Xt, Yl, Deg : LongInt; Txt : string;
                    BackColor : tColor; Transparant : boolean) : boolean;
var Bitmap : TBitmap;
    Rec, Rec2 : TRect;
    P1, P5, P6 : TPoint;
    X, Y, W, H : LongInt;
    Angle, Si, Co : Double;
begin
  Rec:= Rect(0, 0, Canvas.TextWidth(Txt), Canvas.TextHeight(Txt));
  Bitmap:= TBitmap.Create;
  Bitmap.PixelFormat:= pfDevice;
  with Bitmap.Canvas do
  begin
    Font.Assign(Canvas.Font);
    Pen.Assign(Canvas.Pen);
    Brush.Assign(Canvas.Brush);
  end;
  Bitmap.Width:= Rec.Right - Rec.Left;
  Bitmap.Height:= Rec.Bottom - Rec.Top;
  Bitmap.Canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);
  Bitmap.Canvas.TextRect(Rec, 1, 1, Txt);
  Angle:= Deg/180*PI;
  Si:= Sin(Angle); Co:= Cos(Angle);
  W:= Rec.Right - Rec.Left;
  H:= Rec.Bottom - Rec.Top;
  P1.X:= Xt - round(0.5 * W * Co + 0.5 * H * Si);
  P1.Y:= Yl - round(-0.5 * W * Si + 0.5 * H * Co);
  if P1.X < 0 then P1.X:= 0;
  if P1.Y < 0 then P1.Y:= 0;

  for Y:= 0 to Bitmap.Height - 2 do
  begin
    X:= 0;
    P5.X:= P1.X + round(Y * Si); P5.Y:= P1.Y + round(Y * Co);
    for X:= 0 to Bitmap.Width - 1 do
    begin
      P6.X:= P5.X + round(X * Co); P6.Y:= P5.Y - round(X * Si);

      if TransParant and ((Canvas.Pixels[P6.X, P6.Y] = BackColor) or (Canvas.Pixels[P6.X, P6.Y] = Canvas.Brush.Color)) then
        Canvas.Pixels[P6.X, P6.Y]:= Bitmap.Canvas.Pixels[X, Y]
      else if not Transparant then
        Canvas.Pixels[P6.X, P6.Y]:= Bitmap.Canvas.Pixels[X, Y];
    end;
  end;
end;}

Function CmToPixels(Handle : HDC; Cm : Double; Direction : TDirection) : LongInt;
var PPI : LongInt;
begin
  if Direction = drHorizontal then PPI:= GetDeviceCaps(Handle, LogPixelsX)
  else if Direction = drVertical then  PPI:= GetDeviceCaps(Handle, LogPixelsY);
  Result:= Round(cm / Inch * PPI);
end;

Function PixelsToCm(Handle : HDC; Pix : LongInt; Direction : TDirection) : Double;
var PPI : LongInt;
begin
  if Direction = drHorizontal then PPI:= GetDeviceCaps(Handle, LogPixelsX)
  else if Direction = drVertical then  PPI:= GetDeviceCaps(Handle, LogPixelsY);
  Result:= Pix / PPI * Inch;
end;

Function PixelsToPoints(Handle : HDC; Pix : LongInt; Direction : TDirection) : Double;
var PPI : LongInt;
begin
  if Direction = drHorizontal then PPI:= GetDeviceCaps(Handle, LogPixelsX)
  else if Direction = drVertical then  PPI:= GetDeviceCaps(Handle, LogPixelsY);
  Result:= Pix * PPI / Inch * 120 / 4.4; {=(Pix * (PPIY * 120) / (Inch * 4.4) }
end;

Function PointsToPixels(Handle : HDC; Poi : Double; Direction : TDirection) : LongInt;
var PPI : LongInt;
begin
  if Direction = drHorizontal then PPI:= GetDeviceCaps(Handle, LogPixelsX)
  else if Direction = drVertical then  PPI:= GetDeviceCaps(Handle, LogPixelsY);
  Result:= round(Poi * (Inch * 4.4) / (PPI * 120));
end;

Function CmToPoints(Cm : double) : double;
begin
  Result:= 28.35 * cm;
end;

Function PointsToCm(Poi : double) : Double;
begin
  Result:= Poi / 28.35;
end;


{==============================================================================}
                                   {Graphics}

Procedure DrawShadow( Canvas : TCanvas;  X, Y, W, H, D: SmallInt;
                      Up, OutSide: boolean);
var Point                      : array[1..6] of TPoint;
    Light, Dark                : LongInt;
    OldBrushColor, OldPenColor : TColor;
begin
  Light:= clBtnHighLight; Dark:= clBtnShadow;
  with Canvas do
  begin
    OldBrushColor:= Brush.Color;
    OldPenColor:= Pen.Color;
    if OutSide then
    begin
      if Up then Brush.Color:= Light
      else Brush.Color:= Dark;
      Pen.Color:= Brush.Color;
      Point[1].X:= X;                      Point[1].Y:= Y + H;
      Point[2].X:= X - D;                  Point[2].Y:= Y + H - D;
      Point[3].X:= X - D;                  Point[3].Y:= Y - D;
      Point[4].X:= X + W + D;              Point[4].Y:= Y - D;
      Point[5].X:= X + W;                  Point[5].Y:= Y;
      Point[6].X:= X;                      Point[6].Y:= Y;
      Polygon(Point);
      if Up then Brush.Color:= Dark
      else Brush.Color:= Light;
      Pen.Color:= Brush.Color;
      Point[1].X:= Point[5].X;             Point[1].Y:= Point[5].Y;
      Point[2].X:= Point[4].X;             Point[2].Y:= Point[4].Y;
      Point[3].X:= Point[2].X;             Point[3].Y:= Point[2].Y + H + 2 * D;
      Point[4].X:= Point[3].X - W - 2 * D; Point[4].Y:= Point[3].Y;
      Point[5].X:= Point[4].X + D;         Point[5].Y:= Point[4].Y - D;
      Point[6].X:= Point[1].X;             Point[6].Y:= Point[5].Y;
      Polygon(Point);
    end
    else
    begin
      if Up then Brush.Color:= Light
      else Brush.Color:= Dark;
      Pen.Color:= Brush.Color;
      Point[1].X:= X + D;                  Point[1].Y:= Y + H - D;
      Point[2].X:= X;                      Point[2].Y:= Y + H;
      Point[3].X:= X;                      Point[3].Y:= Y;
      Point[4].X:= X + W;                  Point[4].Y:= Y;
      Point[5].X:= X + W - D;              Point[5].Y:= Y + D;
      Point[6].X:= X + D;                  Point[6].Y:= Y + D;
      Polygon(Point);
      if Up then Brush.Color:= Dark
      else Brush.Color:= Light;
      Pen.Color:= Brush.Color;
      Point[3].X:= X + W;                  Point[3].Y:= Y + H;
      Point[6].X:= X + W - D;              Point[6].Y:= Y + H - D;
      Polygon(Point);
    end;
    Brush.Color:= OldBrushColor;
    Pen.Color:= OldPenColor;
  end;
end;

Function DrawInRect(Canvas : TCanvas; P1, P2 : TPoint; Rec : TRect) : boolean;
var P3, P4 : TPoint;

  Function CrossOneIn(P1, P2 : TPoint; var P : TPoint; Rec : TRect) : boolean;
  var a, b : single;
  begin
    Result:= false;
    {Calculate line function}
    if P2.X <> P1.X then
    begin
      a:= (P2.Y - P1.Y) / (P2.X - P1.X);
      b:= P1.Y - a * P1.X;
      {Cross with top line : calculate X}
      P.X:= round((Rec.Top - b) / a); P.Y:= Rec.Top;
      if IsInSquare(P, Rec) and BetweenPoints(P1, P2, P) then result:= TRUE;
      if not Result then
      begin {Cross with bottom line : calculate X}
        P.X:= round((Rec.Bottom - b) / a); P.Y:= Rec.Bottom;
        if IsInSquare(P, Rec) and BetweenPoints(P1, P2, P) then result:= TRUE;
      end;
      if not Result then
      begin {Cross with left line : calculate Y}
        P.Y:= round(a * Rec.left + b); P.X:= Rec.Left;
        if IsInSquare(P, Rec) and BetweenPoints(P1, P2, P) then result:= TRUE;
      end;
      if not Result then
      begin {Cross with right line : calculate Y}
        P.Y:= round(a * Rec.right + b); P.X:= Rec.Right;
        if IsInSquare(P, Rec) and BetweenPoints(P1, P2, P) then result:= TRUE;
      end;
      if not Result then begin P.X:= -1; P.Y:= -1; end;
    end
    else
    begin
      P.X:= P1.X; if P1.Y < P2.Y then P.Y:= Rec.Bottom else P.Y:= Rec.Top;
    end;
  end;

  Function Cross(P1, P2 : TPoint; var P3, P4 : TPoint; Rec : TRect) : boolean;
  var a, b : single;
      P5, P6, P7, P8 : TPoint;
  begin
    Result:= false;
    P5.X:= -1; P5.Y:= -1; P6.X:= -1; P6.Y:= -1;
    P7.X:= -1; P7.Y:= -1; P8.X:= -1; P8.Y:= -1;
    {Calculate line function}
    if P2.X <> P1.X then
    begin
      a:= (P2.Y - P1.Y) / (P2.X - P1.X);
      b:= P1.Y - a * P1.X;
      if a <> 0 then
      begin
        {Cross with top line : calculate X}
        P5.X:= round((Rec.Top - b) / a); P5.Y:= Rec.Top;
        {Cross with bottom line : calculate X}
        P6.X:= round((Rec.Bottom - b) / a); P6.Y:= Rec.Bottom;
      end;
      {Cross with left line : calculate Y}
      P7.Y:= round(a * Rec.Left + b); P7.X:= Rec.Left;
      {Cross with right line : calculate Y}
      P8.Y:= round(a * Rec.Right + b); P8.X:= Rec.Right;
    end
    else
    begin
      {Cross with top line : calculate X}
      P5.X:= P1.X; P5.Y:= Rec.Top;
      {Cross with bottom line : calculate X}
      P6.X:= P1.X; P6.Y:= Rec.Bottom;
    end;
    Result:= TRUE;
    if IsInSquare(P5, Rec) and BetweenPoints(P1, P2, P5) then
    begin
      P3.X:= P5.X; P3.Y:= P5.Y;
    end
    else if IsInSquare(P6, Rec) and BetweenPoints(P1, P2, P6) then
    begin
      P3.X:= P6.X; P3.Y:= P6.Y;
    end
    else if IsInSquare(P7, Rec) and BetweenPoints(P1, P2, P7) then
    begin
      P3.X:= P7.X; P3.Y:= P7.Y;
      Result:= false;
    end
    else
    begin
      P3.X:= -1; P3.Y:= -1;
    end;
    if IsInSquare(P8, Rec) and BetweenPoints(P1, P2, P8) then
    begin
      P4.X:= P8.X; P4.Y:= P8.Y;
    end
    else if IsInSquare(P7, Rec) and BetweenPoints(P1, P2, P7) then
    begin
      P4.X:= P7.X; P4.Y:= P7.Y;
    end
    else if IsInSquare(P6, Rec) and BetweenPoints(P1, P2, P6) then
    begin
      P4.X:= P6.X; P4.Y:= P6.Y;
    end
    else
    begin
      P4.X:= -1; P4.Y:= -1;
      Result:= false;
    end;
  end;
begin
   Result:= false;
   P3.X:= -1; P3.Y:= -1; P4.X:= -1; P4.Y:= -1;
   if IsInSquare(P1, Rec) then P3:= P1;
   if IsInSquare(P2, Rec) then P4:= P2;
   if IsInSquare(P1, Rec) and IsInSquare(P2, Rec) then
   begin {both inside.}
     with Canvas do
     begin
       if (Canvas.PenPos.X <> P1.X) and (Canvas.PenPos.Y <> P1.Y) then
         Canvas.MoveTo(P1.X, P1.Y);
       Canvas.LineTo(P2.X, P2.Y);
     end;
     Result:= TRUE;
   end
   else if IsInSquare(P1, Rec) and not IsInSquare(P2, Rec) then
   begin {P1 is inside, P2 is outside}
     if CrossOneIn(P1, P2, P4, Rec) then
     begin
       with Canvas do
       begin
         if (Canvas.PenPos.X <> P1.X) and (Canvas.PenPos.Y <> P1.Y) then
           Canvas.MoveTo(P1.X, P1.Y);
         Canvas.LineTo(P4.X, P4.Y);
       end;
       Result:= TRUE;
     end;
   end
   else if IsInSquare(P2, Rec) and not IsInSquare(P1, Rec) then
   begin {P2 is inside, P1 is outside}
     if CrossOneIn(P2, P1, P3, Rec) then
     begin
       with Canvas do
       begin
         Canvas.MoveTo(P3.X, P3.Y);
         Canvas.LineTo(P2.X, P2.Y);
       end;
       Result:= TRUE;
     end;
   end
   else if (not IsInSquare(P1, Rec)) and (not IsInSquare(P2, Rec)) then
   begin
     if Cross(P1, P2, P3, P4, Rec) then
     begin
       with Canvas do
       begin
         Canvas.MoveTo(P3.X, P3.Y);
         Canvas.LineTo(P4.X, P4.Y);
       end;
       Result:= TRUE;
     end;
   end;
end;

Function Pie(Canvas : TCanvas; X1, Y1, X2, Y2, X3, Y3, X4, Y4 : integer) : boolean;
begin
  Result:= LCLIntf.Pie(Canvas.Handle, X1, Y1, X2, Y2, X3, Y3, X4, Y4);
end;

Function PolyPolygon(Canvas : TCanvas; Points: array of TPoint; {PolyCounts : array of integer;} AmPoly : integer) : boolean;
begin
  Result:= True;
  Canvas.Polygon(Points, {PolyCounts,} AmPoly, false);
end;

Function PolyRoundedLine(Canvas : TCanvas; Points : array of TPoint; RoundPerc : single) : boolean;
var i, dX, dY : LongInt;
    PB : array[1..4] of TPoint;
    Line : array[1..2] of TPoint;
begin
  Result:= True;
  if RoundPerc < 0 then RoundPerc:= 0;
  if RoundPerc > 50 then RoundPerc:= 50;
  Line[1].X:= Points[0].X; Line[1].Y:= Points[0].Y;
  dX:= round(RoundPerc/100 * (Points[1].X - Points[0].X));
  dY:= round(RoundPerc/100 * (Points[1].Y - Points[0].Y));
  Line[2].X:= Points[1].X - dX; Line[2].Y:= Points[1].Y - dY;
  Canvas.MoveTo(Line[1].X, Line[1].Y);
  Canvas.LineTo(Line[2].X, Line[2].Y);
  for i:= 1 to High(Points) - 1 do
  begin
    PB[1]:= Line[2];

    PB[2].X:= Points[i].X;
    PB[2].Y:= Points[i].Y;
    dX:= round(RoundPerc/100 * (Points[i+1].X - Points[i].X));
    dY:= round(RoundPerc/100 * (Points[i+1].Y - Points[i].Y));
    PB[3].X:= Points[i].X;
    PB[3].Y:= Points[i].Y;

    PB[4].X:= Points[i].X + dX;
    PB[4].Y:= Points[i].Y + dY;
    Canvas.PolyBezier(PB);
    Line[1]:= PB[4];
    Line[2].X:= Points[i+1].X - dX;
    Line[2].Y:= Points[i+1].Y - dY;
    Canvas.MoveTo(Line[1].X, Line[1].Y);
    Canvas.LineTo(Line[2].X, Line[2].Y);
  end;
  Line[1]:= Line[2];
  Line[2]:= Points[High(Points)];
  Canvas.MoveTo(Line[1].X, Line[1].Y);
  Canvas.LineTo(Line[2].X, Line[2].Y);
end;


end.
