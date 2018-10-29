unit BHprintforms; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StdCtrls, Dialogs, Data, BH_report, Printers, Graphics,
  extctrls, HulpFuncties;

Function CreateCheckList(Doc : TBHRDocument; Rec : TRecipe) : boolean;
Function CreateLogbook(Doc : TBHRDocument; Rec : TRecipe; RT : TRecType) : boolean;
Function CreateStockList(Doc : TBHRDocument) : boolean;
Function CreateStockListClipboard : boolean;
Function CreateStockListFile : boolean;
Function CreateBrewsList(Doc : TBHRDocument; DStart, DEnd : TDateTime; NRStart, NrEnd : string) : boolean;

implementation

uses frmain, StrUtils, Forms, Controls, TAGraph, Containers;

type
  TIngrListItem = record
    Time : integer;
    Caption : string;
    IngrType : TIngredientType;
  end;

  TIngrListArray = array of TIngrListItem;

var Head1FontSize, Head2FontSize, Head3FontSize: word;
    TextFontSize: word;
    clHead, clOneven, clEven : TColor;
    IngrListArray : TIngrListArray;

Function CmToPixX(cm : single) : word;
begin
  if Printer <> NIL then
    Result:= round(cm / 2.54 * Printer.XDPI)
  else
    Result:= round(cm / 2.54 * 600);
end;

Function CmToPixY(cm : single) : word;
begin
  if Printer <> NIL then
    Result:= round(cm / 2.54 * Printer.YDPI)
  else
    Result:= round(cm / 2.54 * 600);
end;

Function PixToCmX(px : single) : word;
begin
  if Printer <> NIL then
    Result:= round(2.54 * px / Printer.XDPI)
  else
    Result:= round(2.54 * px / 600);
end;

Function PixToCmY(px : single) : word;
begin
  if Printer <> NIL then
    Result:= round(2.54 * px / Printer.YDPI)
  else
    Result:= round(2.54 * px / 600);
end;

Function FontSizeToPix(sz, scale : single) : word;
begin
  if Printer <> NIL then
    Result:= round(scale * abs(sz) / 72 * Printer.YDPI)
  else
    Result:= round(scale * abs(sz) / 72 * 600);
end;

Function InsertHead(var R : TRect; Doc : TBHRDocument; Txt : string) : TBHRText;
begin
  R.Top:= Doc.LastY;
  Result:= Doc.AddText(R, Txt);
  Result.Brush.Color:= clHead;
  Result.Pen.Style:= psClear;
  Result.Pen.Color:= clBlack;
  Result.Font.Size:= Head1FontSize;
  Result.Font.Style:= [fsBold];
  Result.AutoSize:= TRUE;
  Result.CheckBoxes:= false;
  Result.KeepWithNext:= TRUE;
  R.Bottom:= Result.Bottom;
end;

Function InsertHeader(var R : TRect; Doc : TBHRDocument; Txt : string) : TBHRText;
begin
  R.Top:= Doc.LastY;
  Result:= Doc.AddText(R, Txt);
  Result.Brush.Color:= clHead;
  Result.Pen.Style:= psClear;
  Result.Pen.Color:= clBlack;
  Result.Font.Size:= Head2FontSize;
  Result.Font.Style:= [fsBold];
  Result.AutoSize:= TRUE;
  Result.CheckBoxes:= false;
  Result.KeepWithNext:= TRUE;

  R.Bottom:= Result.Bottom;
end;

Function InsertSpace(var R : TRect; Doc : TBHRDocument; Height : word) : TBHRElement;
begin
  R.Top:= Doc.LastY;
  R.Bottom:= R.Top + Height;
  Result:= Doc.AddSpace(R, Height);
  R.Bottom:= Result.Bottom;
end;

Function InsertTable(var R : TRect; Doc : TBHRDocument; nCols, nRows : integer) : TBHRTable;
var Ro, Co : integer;
begin
  R.Top:= Doc.LastY;
  Result:= Doc.AddTable(R, nCols, nRows);
//  Result.AutoHeight:= TRUE;
  Result.KeepTogether:= TRUE;
  for Ro:= 0 to nRows - 1 do
    for Co:= 0 to NCols - 1 do
      with Result.Cells[Ro, Co] do
      begin
        Font.Size:= TextFontSize;
        Font.Style:= [];
        Font.Color:= clBlack;
        Brush.Color:= clWhite;
        Content.Alignment:= taLeftJustify;
        Autosize:= TRUE;
      end;
  R.Bottom:= Result.Bottom;
end;

Function InsertText(var R : TRect; Doc : TBHRDocument; Txt : string) : TBHRText;
begin
  R.Top:= Doc.LastY;
  Result:= Doc.AddText(R, Txt);
  with Result do
  begin
    Font.Size:= TextFontSize;
    Font.Style:= [];
    Font.Color:= clBlack;
    Brush.Color:= clWhite;
    Alignment:= taLeftJustify;
  end;
  R.Bottom:= Result.Bottom;
end;

Function InsertPicture(var R : TRect; Doc : TBHRDocument; Pict : TPicture; Height : single) : TBHRImage;
var pr : TRect;
begin
  pr:= R;
  pr.Bottom:= pr.Top + CmToPixY(Height);
  pr.Right:= pr.Left + round(Pict.Width / Pict.Height * (pr.Bottom - pr.Top));
  Result:= Doc.AddImage(pr);
  Result.Top:= pr.Top;
  Result.Bottom:= pr.Bottom;
  Result.Left:= pr.Left;
  Result.Right:= pr.Right;
  Result.Picture.Assign(Pict);
  R.Bottom:= pr.Bottom;
end;

Procedure InsertHeaderPicture(Doc : TBHRDocument; Pict : TPicture);
begin
  if (Doc <> NIL) and (Doc.Header <> NIL) and (Pict <> NIL) then
    Doc.Header.Picture.Assign(Pict);
end;

Procedure SetHeaderText(Doc : TBHRDocument; S : string);
begin
  if (Doc <> NIL) and (Doc.Header <> NIL) then
    Doc.Header.Text:= S;
end;

Procedure InsertFooterPicture(Doc : TBHRDocument; Pict : TPicture);
begin
  if (Doc <> NIL) and (Doc.Footer <> NIL) and (Pict <> NIL) then
  begin
    Doc.Footer.Picture.Assign(Pict);
  end;
end;

Procedure SetFooterText(Doc : TBHRDocument; S : string);
begin
  if (Doc <> NIL) and (Doc.Header <> NIL) then
    Doc.Footer.Text:= S;
end;

{Function InsertGraph(var R : TRect; Doc : TBHRDocument; Gr : TBHGraph) : TBHRBHGraph;
begin
  Result:= Doc.AddGraph(R);
  Result.Graph:= Gr;
end;}

Function InsertChart(var R : TRect; Doc : TBHRDocument; Ch : TChart) : TBHRChart;
begin
  Result:= Doc.AddChart(R);
  Result.Chart:= Ch;
end;

Function CreateCheckList(Doc : TBHRDocument; Rec : TRecipe) : boolean;
var i, j : integer;
    txt : TBHRText;
    Space : TBHRElement;
    logo : TImage;
    R : TRect;
    LineSpace : word;
    s : string;
    CLG : TCheckListGroup;
    CLI : TCheckListItem;
begin
  Result:= false;
  Head1FontSize:= 15;
  Head2FontSize:= 13;
  Head3FontSize:= 10;
  TextFontSize:= 10;
  LineSpace:= round(1.2 * FontSizeToPix(TextFontSize, 1));
  if (Doc <> NIL) and (Rec <> NIL) and (Rec.CheckList <> NIL) and (Rec.CheckList.NumItems > 0) then
  begin
    Screen.Cursor:= crHourglass;
    Application.ProcessMessages;
    try
      R.Top:= Doc.PrintRect.Top;
      R.Bottom:= Doc.PrintRect.Top;
      R.Left:= Doc.PrintRect.Left;
      R.Right:= Doc.PrintRect.Right;
      logo:= frmmain.iLogo;
      InsertHeaderPicture(Doc, Logo.Picture);
      SetHeaderText(Doc, 'CHECKLIST voor ' + Rec.NrRecipe.Value + ' ' + Rec.Name.Value);

      for i:= 0 to Rec.CheckList.NumGroups - 1 do
      begin
        CLG:= Rec.CheckList.Group[i];
        if CLG <> NIL then
        begin
          Space:= InsertSpace(R, Doc, LineSpace);
          txt:= InsertText(R, Doc, CLG.Caption.Value);
          txt.Font.Size:= Head3FontSize;
          txt.Font.Style:= [fsBold];
          for j:= 0 to CLG.NumItems - 1 do
          begin
            CLI:= CLG.Item[j];
            s:= CLI.Item.Caption;
            txt:= InsertText(R, Doc, s);
            txt.CheckBoxes:= TRUE;
            txt.Checked:= CLI.Item.Value;
          end;
        end;
      end;
      Result:= TRUE;
    except
      Result:= false;
      Screen.Cursor:= crDefault;
    end;
    Screen.Cursor:= crDefault;
  end;
end;

Function CreateLogbook(Doc : TBHRDocument; Rec : TRecipe; RT : TRecType) : boolean;
var i, num, nRows, nCols, Ro, Co : integer;
    txt : TBHRText;
    logo : TImage;
    tbl : TBHRTable;
    chart : TBHRChart;
    Space : TBHRElement;
    R : TRect;
    v : double;
    LineSpace : word;
    s : string;
    M : TMisc;
    F : TFermentable;
    H : THop;
    Y : TYeast;
    MS : TMashStep;
    wi : word;
    Procedure NextR;
    begin
      Inc(Ro);
      if Ro > nRows - 1 then
      begin
        Ro:= 1;
//        Co:= Co + 2;
      end;
    end;
    Function GetClr(i : integer) : TColor;
    begin
      if (i mod 2 = 0) then Result:= clEven else Result:= clOneven;
    end;

begin
  Result:= false;
  Head1FontSize:= 15;
  Head2FontSize:= 12;
  Head3FontSize:= 8;
  TextFontSize:= 8;
  LineSpace:= round(1.2 * FontSizeToPix(TextFontSize, 1));
  if (Doc <> NIL) and (Rec <> NIL) then
  begin
    Screen.Cursor:= crHourglass;
    Application.ProcessMessages;
    try
      R.Top:= Doc.PrintRect.Top;
      R.Bottom:= Doc.PrintRect.Top;
      R.Left:= Doc.PrintRect.Left;
      R.Right:= Doc.PrintRect.Right;
      logo:= frmmain.iLogo;
      InsertHeaderPicture(Doc, Logo.Picture);
      SetHeaderText(Doc, 'LOGBOEK van ' + Rec.NrRecipe.Value + ' ' + Rec.Name.Value);

      txt:= InsertHeader(R, Doc, 'Basiskenmerken');
      nRows:= 8;
      nCols:= 4;
      tbl:= InsertTable(R, Doc, nCols, nRows);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Omschrijving';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Waarde';
        Content.AddString(s);
      end;
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Omschrijving';
        Content.AddString(s);
      end;
      Co:= 3;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Waarde';
        Content.AddString(s);
      end;
      Ro:= 1;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Kenmerk';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        s:= rec.NrRecipe.Value;
        Content.AddString(s);
      end;
      Ro:= 2;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Naam';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        s:= rec.Name.Value;
        Content.AddString(s);
      end;
      Ro:= 3;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Brouwdatum';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        s:= rec.Date.DisplayString;
        Content.AddString(s);
      end;
      Ro:= 4;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Bierstijl';
        Content.AddString(s);
      end;
      if rec.Style <> NIL then
      begin
        Co:= 1;
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.Style.Name.Value;
          Content.AddString(s);
        end;
      end;
      Ro:= 5;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Volume';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        if (Rec.VolumeFermenter.Value > 0) and (Rec.VolumeFermenter.Value > Rec.VolumeAfterBoil.Value) then
        begin
          v:= Rec.VolumeFermenter.DisplayValue;
          if Rec.Equipment <> NIL then
            v:= v + Rec.Equipment.TopUpWater.DisplayValue;
          s:= RealToStrDec(v, Rec.VolumeFermenter.Decimals);
        end
        else if Rec.VolumeAfterBoil.Value > 0 then s:= rec.VolumeAfterBoil.DisplayString
        else s:= rec.BatchSize.DisplayString;
        Content.AddString(s);
      end;
      Ro:= 6;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Brouwzaalrendement';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        if rec.ActualEfficiency.Value > 30 then s:= rec.ActualEfficiency.DisplayString
        else s:= RealToStrDec(rec.Efficiency, 1) + '%';
        Content.AddString(s);
      end;
      Ro:= 1;
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Begin SG';
        Content.AddString(s);
      end;
      Co:= 3;
      with tbl.Cells[Ro, Co] do
      begin
        if rec.OGFermenter.Value > 1.001 then s:= rec.OGFermenter.DisplayString
        else if rec.OG.Value > 1.005 then s:= rec.OG.DisplayString
        else s:= rec.EstOG.DisplayString;
        Content.AddString(s);
      end;
      Inc(Ro);
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Eind SG';
        Content.AddString(s);
      end;
      if rec.FG.Value > 1.000 then
      begin
        Co:= 3;
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.FG.DisplayString;
          Content.AddString(s);
        end;
      end;
      if rec.ABVCalc.Value > 0 then
      begin
        Inc(Ro);
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Alcoholgehalte';
          Content.AddString(s);
        end;
        Co:= 3;
        if rec.FG.Value > 1.000 then
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.ABVcalc.DisplayString;
            Content.AddString(s);
          end;
      end;
      Inc(Ro);
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Berekende kleur';
        Content.AddString(s);
      end;
      Co:= 3;
      v:= Convert(srm, rec.EstColor.DisplayUnit, rec.CalcColorFermenter);
      if v > 0 then s:= RealToStrDec(v, 0) + ' ' + rec.EstColor.DisplayUnitString
      else s:= rec.EstColor.DisplayString;
      s:= s + ' (' + ColorMethodDisplayNames[rec.ColorMethod] + ')';
      with tbl.Cells[Ro, Co] do
      begin
        Content.AddString(s);
      end;
      Inc(Ro);
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Berekende bitterheid';
        Content.AddString(s);
      end;
      Co:= 3;
      v:= rec.CalcIBUFermenter;
      if v > 0 then s:= RealToStrDec(v, 0) + ' ' + rec.IBUcalc.DisplayUnitString
      else s:= rec.IBUCalc.DisplayString;
      s:= s + ' (' + IBUMethodDisplayNames[rec.IBUmethod] + ')';
      with tbl.Cells[Ro, Co] do
      begin
        Content.AddString(s);
      end;
      Inc(Ro);
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Bitterheidsindex';
        Content.AddString(s);
      end;
      Co:= 3;
      with tbl.Cells[Ro, Co] do
      begin
        s:= RealToStrDec(rec.BUGU, 2) + ' BU/GU';
        Content.AddString(s);
      end;
      Inc(Ro);
      tbl.RowColor[Ro]:= GetClr(Ro);
      Co:= 2;
      with tbl.Cells[Ro, Co] do
      begin
        s:= 'Kooktijd';
        Content.AddString(s);
      end;
      Co:= 3;
      with tbl.Cells[Ro, Co] do
      begin
        s:= rec.BoilTime.DisplayString;
        Content.AddString(s);
      end;

      R.Right:= round(0.5 * Doc.PrintRect.Right);
      Space:= InsertSpace(R, Doc, LineSpace);
      txt:= InsertHeader(R, Doc, 'Water(behandeling)');
      nRows:= 1 + rec.NumWaters + rec.NumWaterAgents;
      if rec.Mash <> NIL then Inc(nRows);
      nCols:= 2;
      tbl:= InsertTable(R, Doc, nCols, nRows);
      //set column widths
      wi:= R.Right - R.Left;
      tbl.ColWidth[0]:= round(0.7 * wi);
      tbl.ColWidth[1]:= round(0.3 * wi);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Hoeveelheid';
        Content.AddString(s);
      end;
      Co:= 1;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Ingrediënt';
        Content.AddString(s);
      end;
      NextR;
      for i:= 0 to rec.NumWaters - 1 do
      begin
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.Water[i].Name.Value;
          if NPos('water', s, 1) < 1 then
            s:= 'Water uit ' + s;
          Content.AddString(s);
        end;
        Co:= 1;
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.Water[i].Amount.DisplayString;
          Content.AddString(s);
        end;
        NextR;
      end;
      for i:= 0 to rec.NumMiscs - 1 do
      begin
        if rec.Misc[i].MiscType = mtWaterAgent then
        begin
          tbl.RowColor[Ro]:= GetClr(Ro);
          Co:= 0;
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Misc[i].Name.Value;
            Content.AddString(s);
          end;
          Co:= 1;
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Misc[i].Amount.DisplayString;
            Content.AddString(s);
          end;
          NextR;
        end;
      end;
      if rec.Mash <> NIL then
      begin
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Spoelwater';
          Content.AddString(s);
        end;
        Co:= 1;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.Mash.SpargeVolume, 2)
              + ' ' + UnitNames[rec.BatchSize.DisplayUnit];
          Content.AddString(s);
        end;
      end;

      R.Right:= Doc.PrintRect.Right;
      if (rec.Water[0] <> NIL) and (rec.SO4 > 0) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        Txt:= InsertHeader(R, Doc, 'Waterprofiel');
        nRows:= 2;
        if rec.Mash <> NIL then Inc(nRows);
        nCols:= 9;
        R.Top:= R.Bottom;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Ca';
          Content.AddString(s);
        end;
        Co:= 1;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Mg';
          Content.AddString(s);
        end;
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Na';
          Content.AddString(s);
        end;
        Co:= 3;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'HCO3';
          Content.AddString(s);
        end;
        Co:= 4;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Cl';
          Content.AddString(s);
        end;
        Co:= 5;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'SO4';
          Content.AddString(s);
        end;
        Co:= 6;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'pH besl.';
          Content.AddString(s);
        end;
        Co:= 7;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Rstalk.';
          Content.AddString(s);
        end;
        Co:= 8;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Cl/SO4';
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.Ca, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 1;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.Mg, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.Na, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 3;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.HCO3, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 4;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.Cl, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 5;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.SO4, 0) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 7;
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.RA, 1) + ' mg/l';
          Content.AddString(s);
        end;
        Co:= 6;
        with tbl.Cells[Ro, Co] do
        begin
          if Between(rec.pHAdjusted.Value, 4.0, 6.0) then
            s:= rec.pHAdjusted.DisplayString
          else s:= rec.TargetpH.DisplayString;
          Content.AddString(s);
        end;
        Co:= 8;
        with tbl.Cells[Ro, Co] do
        begin
          s:= '';
          if rec.SO4 > 0 then
            s:= RealToStrDec(rec.Cl / rec.SO4, 1);
          Content.AddString(s);
        end;
      end;

      Space:= InsertSpace(R, Doc, LineSpace);
      txt:= InsertHeader(R, Doc, 'Vergistbare ingrediënten');
      nRows:= 1 + rec.NumFermentables;
      nCols:= 5;
      tbl:= InsertTable(R, Doc, nCols, nRows);
      //set column widths
      wi:= R.Right - R.Left;
      tbl.ColWidth[0]:= round(0.17 * wi);
      tbl.ColWidth[1]:= round(0.15 * wi);
      tbl.ColWidth[2]:= round(0.28 * wi);
      tbl.ColWidth[3]:= round(0.28 * wi);
      tbl.ColWidth[4]:= round(0.12 * wi);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Hoeveelheid';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Percentage';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Naam';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Mouterij/herkomst';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Kleur';
        Content.AddString(s);
      end;
      NextR;
      for i:= 0 to rec.NumFermentables - 1 do
      begin
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        F:= rec.Fermentable[i];
        with tbl.Cells[Ro, Co] do
        begin
          s:= F.Amount.DisplayString;
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= F.Percentage.DisplayString;
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= F.Name.Value;
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= F.Supplier.Value;
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= F.Color.DisplayString;
          Content.AddString(s);
        end;
        NextR;
      end;

      if (Rec.Mash <> NIL) and (Rec.Mash.NumMashSteps > 0) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Maischschema');
        nRows:= 1 + rec.Mash.NumMashSteps;
        nCols:= 6;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.25 * wi);
        tbl.ColWidth[1]:= round(0.15 * wi);
        tbl.ColWidth[2]:= round(0.22 * wi);
        tbl.ColWidth[3]:= round(0.13 * wi);
        tbl.ColWidth[4]:= round(0.10 * wi);
        tbl.ColWidth[5]:= round(0.15 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Temp.';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Type';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Opw.tijd';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Rust';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Beslagdikte';
          Content.AddString(s);
        end;
        NextR;
        for i:= 0 to rec.Mash.NumMashSteps - 1 do
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          MS:= rec.Mash.MashStep[i];
          with tbl.Cells[Ro, Co] do
          begin
            s:= MS.Name.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= MS.StepTemp.DisplayString;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= MashStepTypeDisplayNames[MS.MashStepType];
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= MS.RampTime.DisplayString;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= MS.StepTime.DisplayString;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= RealToStrDec(MS.WaterToGrainRatio, 1) + ' ' + UnitNames[lpkg];
            Content.AddString(s);
          end;
          NextR;
        end;
      end;

      if rec.NumHops > 0 then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Hop');
        nRows:= 1 + rec.NumHops;
        nCols:= 5;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.17 * wi);
        tbl.ColWidth[1]:= round(0.38 * wi);
        tbl.ColWidth[2]:= round(0.15 * wi);
        tbl.ColWidth[3]:= round(0.15 * wi);
        tbl.ColWidth[4]:= round(0.15 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Hoeveelheid';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Alfazuur';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kooktijd';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'IBU';
          Content.AddString(s);
        end;
        NextR;
        for i:= 0 to rec.NumHops - 1 do
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          H:= rec.Hop[i];
          with tbl.Cells[Ro, Co] do
          begin
            s:= H.Amount.DisplayString;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= H.Name.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= RealToStrDec(H.AlfaAdjusted, 1) + '%';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            case H.Use of
            huBoil: s:= H.Time.DisplayString;
            huDryhop, huMash, huFirstwort, huAroma: s:= HopUseDisplayNames[H.Use];
            end;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= RealToStrDec(H.BitternessContribution, 0);
            Content.AddString(s);
          end;
          NextR;
        end;
      end;

      num:= rec.NumMiscs - rec.NumWaterAgents;
      if num > 0 then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Overige ingrediënten');
        nRows:= 1 + num;
        nCols:= 5;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Hoeveelheid';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Type';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Gebruik';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Tijd';
          Content.AddString(s);
        end;
        NextR;
        for i:= 0 to rec.NumMiscs - 1 do
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          M:= rec.Misc[i];
          if M.MiscType <> mtWaterAgent then
          begin
            with tbl.Cells[Ro, Co] do
            begin
              s:= M.Amount.DisplayString;
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= M.Name.Value;
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= MiscTypeDisplayNames[M.MiscType];
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= MiscUseDisplayNames[M.Use];
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= M.Time.DisplayString;
              Content.AddString(s);
            end;
            if i < rec.NumMiscs - 1 then NextR;
          end;
        end;
      end;

      if rec.NumYeasts > 0 then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Gist');
        nRows:= 1 + rec.NumYeasts;
        nCols:= 5;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.17 * wi);
        tbl.ColWidth[1]:= round(0.17 * wi);
        tbl.ColWidth[2]:= round(0.28 * wi);
        tbl.ColWidth[3]:= round(0.23 * wi);
        tbl.ColWidth[4]:= round(0.15 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Hoedanigheid';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Hoeveelheid';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Herkomst';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Type';
          Content.AddString(s);
        end;
        NextR;
        for i:= 0 to rec.NumYeasts - 1 do
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          Y:= rec.Yeast[i];
          with tbl.Cells[Ro, Co] do
          begin
            s:= YeastFormDisplayNames[Y.Form];
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            if Y.StarterMade.Value then
            begin
              if Y.StarterVolume1.Value > 0 then
                s := Y.StarterVolume1.DisplayString;
              if Y.StarterVolume2.Value > 0 then
                s:= s + ' + ' + Y.StarterVolume2.DisplayString;
              if Y.StarterVolume3.Value > 0 then
                s:= s + ' + ' + Y.StarterVolume3.DisplayString;
              if Y.StarterVolume2.Value > 0 then
                s:= s + ' getrapte starter'
              else
                s:= s + ' starter';
            end
            else
              s:= Y.AmountYeast.DisplayString;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= Y.ProductID.Value + ' ' + Y.Name.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= Y.Laboratory.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= YeastTypeDisplayNames[Y.YeastType];
            Content.AddString(s);
          end;
          NextR;
        end;
      end;

      if (rec.Date.Value <= Now) and (RT = rtBrew) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Brouwdag');
        if rec.Mash <> NIL then nRows:= 17 else nRows:= 14;
        if rec.SGEndMash.Value > 1.010 then Inc(nRows);
        nCols:= 4;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.30 * wi);
        tbl.ColWidth[1]:= round(0.20 * wi);
        tbl.ColWidth[2]:= round(0.30 * wi);
        tbl.ColWidth[3]:= round(0.20 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Starttijd';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TimeStarted.DisplayString;
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Eindtijd';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TimeEnded.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        if rec.Mash <> NIL then
        begin
          Co:= 0;
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'pH maischen';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.pHAdjusted.DisplayString;
            Content.AddString(s);
          end;
          if rec.SGEndMash.Value > 1.010 then
          begin
            Inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= 'SG eind maischen';
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= rec.SGEndMash.DisplayString;
              Content.AddString(s);
            end;
            NextR;
            tbl.RowColor[Ro]:= GetClr(Ro);
            Co:= 2;
            with tbl.Cells[Ro, Co] do
            begin
              s:= 'Maischrendement';
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= RealToStrDec(rec.CalcMashEfficiency, 1) + '%';
              Content.AddString(s);
            end;
          end;
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
          Co:= 0;
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Temp. spoelwater';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Mash.SpargeTemp.DisplayString;
            Content.AddString(s);
          end;
          Inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'pH laatste afloop';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Mash.pHlastRunnings.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
          Co:= 0;
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'pH spoelwater';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Mash.pHsparge.DisplayString;
            Content.AddString(s);
          end;
          Inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'SG laatste afloop';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.Mash.SGLastRunnings.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
        end;
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'pH start koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.pHBeforeBoil.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'pH eind koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.pHAfterBoil.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'SG start koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.OGBeforeBoil.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'SG eind koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.OG.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Volume start koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.VolumeBeforeBoil.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Volume eind koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.VolumeAfterBoil.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Rendement start koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.CalcEfficiencyBeforeBoil, 1) + '%';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Rendement eind koken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.CalcEfficiencyAfterBoil, 1) + '%';
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Whirlpooltijd';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.WhirlpoolTime.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Koelertype';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.CoolingMethodDisplayName;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Koeltijd';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.CoolingTime.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 0;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Gekoeld tot';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.CoolingTo.DisplayString;
          Content.AddString(s);
        end;
        Ro:= Ro - 3;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Volume naar gistingsvat';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.VolumeFermenter.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Beluchtingstijd';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TimeAeration.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Beluchtingssnelheid';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.AerationFlowRate.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        tbl.RowColor[Ro]:= GetClr(Ro);
        Co:= 2;
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Belucht met';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.AerationTypeDisplayName;
          Content.AddString(s);
        end;
      end;

      if (((rec.FermMeasurements <> NIL) and (rec.FermMeasurements.NumMeasurements > 3))
         or (rec.StartTempPrimary.Value > 0)) and (RT = rtBrew) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Vergisting');
        if (rec.FermMeasurements <> NIL) and (rec.FermMeasurements.NumMeasurements > 3) then
        begin
          Chart:= InsertChart(R, Doc, FrmMain.chTControl);
          Space:= InsertSpace(R, Doc, LineSpace);
        end;

        nRows:= 9;
        if rec.PrimaryAge.Value > 0 then Inc(NRows);
        if rec.SecondaryAge.Value > 0 then Inc(NRows);
        nCols:= 4;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.35 * wi);
        tbl.ColWidth[1]:= round(0.15 * wi);
        tbl.ColWidth[2]:= round(0.35 * wi);
        tbl.ColWidth[3]:= round(0.15 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Starttemperatuur vergisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.StartTempPrimary.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Maximum temp. hoofdvergisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.MaxTempPrimary.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Eind temperatuur hoofdvergisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.EndTempPrimary.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Eind SG hoofdvergisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.SGEndPrimary.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Schijnbare vergistingsgraad';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          if rec.OG.Value > 1 then
            s:= RealToStrDec(100 * (rec.OG.Value - rec.SGEndPrimary.Value) / (rec.OG.Value - 1), 1) + '%'
          else
            s:= '0%';
          Content.AddString(s);
        end;
        NextR;
        if rec.PrimaryAge.Value > 0 then
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Start nagisting';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= DateToStr(rec.Date.Value + rec.PrimaryAge.Value);
            Content.AddString(s);
          end;
          NextR;
        end;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Temperatuur nagisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.SecondaryTemp.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        if rec.SecondaryAge.Value > rec.PrimaryAge.Value then
        begin
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Start lagering';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= DateToStr(rec.Date.Value + rec.SecondaryAge.Value);
            Content.AddString(s);
          end;
          NextR;
          Co:= 0;
          tbl.RowColor[Ro]:= GetClr(Ro);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Temperatuur lagering';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.TertiaryTemp.DisplayString;
            Content.AddString(s);
          end;
          NextR;
        end;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Eind SG';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.FG.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Schijnbare vergistingsgraad';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          if rec.OG.Value > 1 then
            s:= RealToStrDec(100 * (rec.OG.Value - rec.FG.Value) / (rec.OG.Value - 1), 1) + '%'
          else
            s:= '0%';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Alcoholgehalte';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.ABVcalc.DisplayString;
          Content.AddString(s);
        end;
      end;

      if (rec.DateBottling.Value > 0) and (RT = rtBrew) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Verpakken');
        nRows:= 10;
        nCols:= 4;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.35 * wi);
        tbl.ColWidth[1]:= round(0.15 * wi);
        tbl.ColWidth[2]:= round(0.35 * wi);
        tbl.ColWidth[3]:= round(0.15 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Bottelen';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= '';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Op fust zetten';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= '';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Datum verpakken';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.DateBottling.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Volume op fles';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.VolumeBottles.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Volume op fust';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.VolumeKegs.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'CO2 gehalte';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.Carbonation.DisplayString;
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'CO2 gehalte';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.CarbonationKegs.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Type suiker';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= PrimingSugarDisplayNames[rec.PrimingSugarBottles];
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Hoeveelheid';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.AmountPrimingBottles.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Totaal';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.AmountPrimingBottles.DisplayValue * rec.VolumeBottles.DisplayValue, 0) + ' g';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Alcohol op fles';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= RealToStrDec(rec.ABVcalc.Value
                           + rec.AmountPrimingBottles.Value * 0.47 / 7.907,
                           1) + ' vol.%';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro+1);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Temp. hergisting';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.CarbonationTemp.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Ro:= 5;
        if rec.ForcedCarbonationKegs.Value then
        begin
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Druk op fust';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.PressureKegs.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Alcohol op fust';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.ABVcalc.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Temperatuur fust';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.CarbonationTempKegs.DisplayString;
            Content.AddString(s);
          end;
        end
        else
        begin
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Type suiker';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= PrimingSugarDisplayNames[rec.PrimingSugarKegs];
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Hoeveelheid';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.AmountPrimingKegs.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Totaal';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= RealToStrDec(rec.AmountPrimingKegs.DisplayValue * rec.VolumeKegs.DisplayValue, 0) + ' g';
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Alcohol op fust';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= RealToStrDec(rec.ABVcalc.Value
                           + rec.AmountPrimingKegs.Value * 0.47 / 7.907,
                           1) + ' vol.%';
            Content.AddString(s);
          end;
          NextR;
          Co:= 2;
          tbl.RowColor[Ro]:= GetClr(Ro+1);
          with tbl.Cells[Ro, Co] do
          begin
            s:= 'Temp. hergisting';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= rec.CarbonationTempKegs.DisplayString;
            Content.AddString(s);
          end;
        end;
      end;

      if (rec.TasteDate.Value > 0) then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Proeven');
        nRows:= 13;
        nCols:= 2;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.20 * wi);
        tbl.ColWidth[1]:= round(0.80 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Kenmerk';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Waarde';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Proefdatum';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteDate.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Bewaartemp.';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.AgeTemp.DisplayString;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Kleur';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteColor.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Helderheid';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteTransparency.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Schuim';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteHead.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Aroma';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteAroma.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Smaak';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteTaste.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Nasmaak';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteAftertaste.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Mondgevoel';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteMouthfeel.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Oordeel';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TasteNotes.Value;
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        tbl.RowColor[Ro]:= GetClr(Ro);
        with tbl.Cells[Ro, Co] do
        begin
          s:= 'Cijfer';
          Content.AddString(s);
        end;
        inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          s:= rec.TastingRate.DisplayString;
          Content.AddString(s);
        end;
      end;

      if (rec.Notes.Value <> '') then
      begin
        //R.Top:= tbl.Bottom;
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Notities');
        txt:= InsertText(R, Doc, rec.Notes.Value);
        txt.Brush.Color:= clOneven;
        txt.AutoSize:= TRUE;
        R.Top:= txt.Bottom;
      end;

      Result:= TRUE;
    except
      Result:= false;
      Screen.Cursor:= crDefault;
    end;
    Screen.Cursor:= crDefault;
  end;
end;

Function CreateStockList(Doc : TBHRDocument) : boolean;
var i, nRows, nCols, Ro, Co : integer;
    txt : TBHRText;
//    img : TBHRImage;
    logo : TImage;
    tbl : TBHRTable;
    Space : TBHRElement;
    R : TRect;
    LineSpace : word;
    s : string;
    M : TMisc;
    F : TFermentable;
    H : THop;
    Y : TYeast;
    wi : word;
    Procedure NextR;
    begin
      Inc(Ro);
      if Ro > nRows - 1 then
      begin
        Ro:= 1;
//        Co:= Co + 2;
      end;
    end;
    Function GetClr(i : integer) : TColor;
    begin
      if (i mod 2 = 0) then Result:= clEven else Result:= clOneven;
    end;

begin
  Result:= false;
  Head1FontSize:= 15;
  Head2FontSize:= 12;
  Head3FontSize:= 8;
  TextFontSize:= 8;
  LineSpace:= round(1.2 * FontSizeToPix(TextFontSize, 1));
  if (Doc <> NIL) then
  begin
    Screen.Cursor:= crHourglass;
    Application.ProcessMessages;
    try
      R.Top:= Doc.PrintRect.Top;
      R.Bottom:= Doc.PrintRect.Top;
      R.Left:= Doc.PrintRect.Left;
      R.Right:= Doc.PrintRect.Right;
      logo:= frmmain.iLogo;
      InsertHeaderPicture(Doc, Logo.Picture);
      SetHeaderText(Doc, 'VOORRAADLIJST');

      txt:= InsertHeader(R, Doc, 'Vergistbare ingrediënten');
      nRows:= 1;
      Fermentables.SortByIndex2(17, 0, false);
      for i:= 0 to Fermentables.NumItems - 1 do
      begin
        F:= TFermentable(Fermentables.Item[i]);
        if (F.Inventory.Value > 0.001) or (F.AlwaysOnStock.Value) then Inc(nRows);
      end;
      nCols:= 3;
      tbl:= InsertTable(R, Doc, nCols, nRows);
      //set column widths
      wi:= R.Right - R.Left;
      tbl.ColWidth[0]:= round(0.40 * wi);
      tbl.ColWidth[1]:= round(0.40 * wi);
      tbl.ColWidth[2]:= round(0.20 * wi);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Herkomst';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Naam';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Voorraad';
        Content.AddString(s);
      end;
      NextR;
      Co:= 0;
      for i:= 0 to Fermentables.NumItems - 1 do
      begin
        F:= TFermentable(Fermentables.Item[i]);
        if (F.Inventory.Value > 0) or (F.AlwaysOnStock.Value) then
        begin
          tbl.RowColor[Ro]:= GetClr(Ro);
          with tbl.Cells[Ro, Co] do
          begin
            s:= F.Supplier.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= F.Inventory.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          Co:= 0;
        end;
      end;

      Space:= InsertSpace(R, Doc, LineSpace);
      txt:= InsertHeader(R, Doc, 'Hop');
      nRows:= 1;
      Hops.SortByIndex2(0, 8, false);
      for i:= 0 to Hops.NumItems - 1 do
      begin
        H:= THop(Hops.Item[i]);
        if (H.Inventory.Value > 0.001) or H.AlwaysOnStock.Value then Inc(nRows);
      end;
      nCols:= 3;
      tbl:= InsertTable(R, Doc, nCols, nRows);
      //set column widths
      wi:= R.Right - R.Left;
      tbl.ColWidth[0]:= round(0.40 * wi);
      tbl.ColWidth[1]:= round(0.40 * wi);
      tbl.ColWidth[2]:= round(0.20 * wi);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Naam';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Vorm';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Voorraad';
        Content.AddString(s);
      end;
      NextR;
      Co:= 0;
      for i:= 0 to Hops.NumItems - 1 do
      begin
        H:= THop(Hops.Item[i]);
        if (H.Inventory.Value > 0) or H.AlwaysOnStock.Value then
        begin
          tbl.RowColor[Ro]:= GetClr(Ro);
          with tbl.Cells[Ro, Co] do
          begin
            s:= H.Name.Value + ' (' + H.Alfa.DisplayString + ')';
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= HopFormDisplayNames[H.Form];
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= H.Inventory.DisplayString;
            Content.AddString(s);
          end;
          NextR;
          Co:= 0;
        end;
      end;

      nRows:= 1;
      Yeasts.SortByIndex2(5, 6, false);
      for i:= 0 to Yeasts.NumItems - 1 do
      begin
        Y:= TYeast(Yeasts.Item[i]);
        if (Y.Inventory.Value > 0.001) or Y.AlwaysOnStock.Value then Inc(nRows);
      end;
      if nRows > 1 then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Gist');
        nCols:= 3;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.40 * wi);
        tbl.ColWidth[1]:= round(0.40 * wi);
        tbl.ColWidth[2]:= round(0.20 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Fabrikant';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Voorraad';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        for i:= 0 to Yeasts.NumItems - 1 do
        begin
          Y:= TYeast(Yeasts.Item[i]);
          if (Y.Inventory.Value > 0) or Y.AlwaysOnStock.Value then
          begin
            tbl.RowColor[Ro]:= GetClr(Ro);
            with tbl.Cells[Ro, Co] do
            begin
              s:= Y.Laboratory.Value;
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= Y.ProductID.Value + ' ' + Y.Name.Value;
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= Y.Inventory.DisplayString;
              Content.AddString(s);
            end;
            NextR;
            Co:= 0;
          end;
        end;
      end;

      nRows:= 1;
      Miscs.SortByIndex2(0, 5, false);
      for i:= 0 to Miscs.NumItems - 1 do
      begin
        M:= TMisc(Miscs.Item[i]);
        if (M.Inventory.Value > 0.001) or M.AlwaysOnStock.Value then Inc(nRows);
      end;
      if nRows > 1 then
      begin
        Space:= InsertSpace(R, Doc, LineSpace);
        txt:= InsertHeader(R, Doc, 'Overige ingrediënten');
        nCols:= 3;
        tbl:= InsertTable(R, Doc, nCols, nRows);
        //set column widths
        wi:= R.Right - R.Left;
        tbl.ColWidth[0]:= round(0.40 * wi);
        tbl.ColWidth[1]:= round(0.40 * wi);
        tbl.ColWidth[2]:= round(0.20 * wi);
        Ro:= 0;
        Co:= 0;
        tbl.RowColor[Ro]:= clHead;
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Naam';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Type';
          Content.AddString(s);
        end;
        Inc(Co);
        with tbl.Cells[Ro, Co] do
        begin
          Font.Size:= Head3FontSize;
          Font.Style:= [fsBold];
          Font.Color:= clBlack;
          s:= 'Voorraad';
          Content.AddString(s);
        end;
        NextR;
        Co:= 0;
        for i:= 0 to Miscs.NumItems - 1 do
        begin
          M:= TMisc(Miscs.Item[i]);
          if (M.Inventory.Value > 0) or M.AlwaysOnStock.Value then
          begin
            tbl.RowColor[Ro]:= GetClr(Ro);
            with tbl.Cells[Ro, Co] do
            begin
              s:= M.Name.Value;
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= MiscTypeDisplayNames[M.MiscType];
              Content.AddString(s);
            end;
            inc(Co);
            with tbl.Cells[Ro, Co] do
            begin
              s:= M.Inventory.DisplayString;
              Content.AddString(s);
            end;
            NextR;
            Co:= 0;
          end;
        end;
      end;
      Result:= TRUE;
    except
      Result:= false;
      Screen.Cursor:= crDefault;
    end;
    Screen.Cursor:= crDefault;
  end;
end;

Function CreateStockListClipboard : boolean;
var i, j : integer;
    Memo : TMemo;
    s, s1 : string;
    M : TMisc;
    F : TFermentable;
    H : THop;
    Y : TYeast;
    wi : word;
const ItemLength = 40;
begin
  Result:= false;
  Screen.Cursor:= crHourglass;
  Application.ProcessMessages;
  try
    Memo:= TMemo.Create(frmMain);
    Memo.Parent := FrmMain;
    Memo.Visible := False;
    Memo.Lines.Clear;

    s:= 'VOORRAADLIJST';
    Memo.Lines.Add(s);
    Memo.Lines.Add('');

    s:= 'Vergistbare ingrediënten';
    Memo.Lines.Add(s);
    Fermentables.SortByIndex2(17, 0, false);
    s:= 'Herkomst';
    for i:= Length(s) to ItemLength do s:= s + ' ';
    s:= s + 'Naam';
    for i:= length('Naam') to ItemLength do s:= s + ' ';
    s:= s + 'Voorraad';
    Memo.Lines.Add(s);

    for i:= 0 to Fermentables.NumItems - 1 do
    begin
      F:= TFermentable(Fermentables.Item[i]);
      if (F.Inventory.Value > 0) or (F.AlwaysOnStock.Value) then
      begin
        s:= F.Supplier.Value;
        for j:= Length(s) to ItemLength do s:= s + ' ';
        s1:= F.Name.Value + ' (' + F.Color.DisplayString + ')';
        s:= s + s1;
        for j:= Length(s1) to ItemLength do s:= s + ' ';
        s:= s + F.Inventory.DisplayString;
        Memo.Lines.Add(s);
      end;
    end;
    Memo.Lines.Add('');

    Hops.SortByIndex2(0, 8, false);
    s:= 'Hop';
    Memo.Lines.Add(s);
    s:= 'Naam';
    for i:= Length(s) to ItemLength do s:= s + ' ';
    s:= s + 'Vorm';
    for i:= length('Vorm') to ItemLength do s:= s + ' ';
    s:= s + 'Voorraad';
    Memo.Lines.Add(s);

    for i:= 0 to Hops.NumItems - 1 do
    begin
      H:= THop(Hops.Item[i]);
      if (H.Inventory.Value > 0) or H.AlwaysOnStock.Value then
      begin
        s1:= H.Name.Value + ' (' + H.Alfa.DisplayString + ')';
        s:= s1;
        for j:= Length(s1) to ItemLength do s:= s + ' ';
        s1:= HopFormDisplayNames[H.Form];
        s:= s + s1;
        for j:= Length(s1) to ItemLength do s:= s + ' ';
        s1:= H.Inventory.DisplayString;
        s:= s + s1;
        Memo.Lines.Add(s);
      end;
    end;
    Memo.Lines.Add('');

    Yeasts.SortByIndex2(5, 6, false);
    s:= 'Gist';
    Memo.Lines.Add(s);
    s:= 'Fabrikant';
    for i:= Length(s) to ItemLength do s:= s + ' ';
    s:= s + 'Naam';
    for i:= length('Naam') to ItemLength do s:= s + ' ';
    s:= s + 'Voorraad';
    Memo.Lines.Add(s);
    for i:= 0 to Yeasts.NumItems - 1 do
    begin
      Y:= TYeast(Yeasts.Item[i]);
      if (Y.Inventory.Value > 0) or Y.AlwaysOnStock.Value then
      begin
        s1:= Y.Laboratory.Value;
        s:= s1;
        for j:= Length(s1) to ItemLength do s:= s + ' ';
        s1:= Y.ProductID.Value + ' ' + Y.Name.Value;
        s:= s + s1;
        for j:= Length(s1) to ItemLength do s:= s + ' ';
        s1:= Y.Inventory.DisplayString;
        s:= s + s1;
        Memo.Lines.Add(s);
      end;
    end;
    Memo.Lines.Add('');

    Miscs.SortByIndex2(0, 5, false);
    s:= 'Overige ingrediënten';
    Memo.Lines.Add(s);
    s:= 'Naam';
    for i:= Length(s) to ItemLength do s:= s + ' ';
    s:= s + 'Type';
    for i:= length('Type') to ItemLength do s:= s + ' ';
    s:= s + 'Voorraad';
    Memo.Lines.Add(s);
    for i:= 0 to Miscs.NumItems - 1 do
    begin
      M:= TMisc(Miscs.Item[i]);
      if (M.Inventory.Value > 0) or M.AlwaysOnStock.Value then
      begin
        s1:= M.Name.Value;
        s:= s1;
        for j:= length(s1) to ItemLength do s:= s + ' ';
        s1:= MiscTypeDisplayNames[M.MiscType];
        s:= s + s1;
        for j:= length(s1) to ItemLength do s:= s + ' ';
        s:= s + M.Inventory.DisplayString;
        Memo.Lines.Add(s);
      end;
    end;
    Memo.SelectAll;
    Memo.CopyToClipboard;
    FreeAndNIL(Memo);
    Result:= TRUE;
  except
    Result:= false;
    Screen.Cursor:= crDefault;
  end;
  Screen.Cursor:= crDefault;
end;

Function CreateStockListFile : boolean;
var i, j : integer;
    Memo : TMemo;
    dlg : TSaveDialog;
    s, FN : string;
    M : TMisc;
    F : TFermentable;
    H : THop;
    Y : TYeast;
    wi : word;
    ds, ls : char;
const ItemLength = 40;
begin
  Result:= false;
  ds:= DecimalSeparator;
  ls:= ListSeparator;
  if ds = ls then ls:= ';';

  Application.ProcessMessages;
  try
    dlg:= TSaveDialog.Create(frmMain);
    with dlg do
    begin
      DefaultExt:= '.csv';
      FileName:= 'inventarislijst.csv';
      Filter:= 'Comma seperated values|*.csv';
    end;
    if (dlg.Execute) and (dlg.FileName <> '') then
    begin
      Screen.Cursor:= crHourglass;
      FN:= dlg.FileName;
      FreeAndNIL(dlg);

      Memo:= TMemo.Create(frmMain);
      Memo.Parent := FrmMain;
      Memo.Visible := False;
      Memo.Lines.Clear;

      s:= 'VOORRAADLIJST';
      Memo.Lines.Add(s);
      Memo.Lines.Add('');

      s:= 'Vergistbare ingrediënten';
      Memo.Lines.Add(s);
      Fermentables.SortByIndex2(17, 0, false);
      s:= 'Herkomst' + ls;
      s:= s + 'Naam' + ls;
      s:= s + 'Voorraad' + ls;
      s:= s + 'Eenheid';
      Memo.Lines.Add(s);

      for i:= 0 to Fermentables.NumItems - 1 do
      begin
        F:= TFermentable(Fermentables.Item[i]);
        if (F.Inventory.Value > 0) or (F.AlwaysOnStock.Value) then
        begin
          s:= F.Supplier.Value + ls;
          s:= s + F.Name.Value + ' (' + F.Color.DisplayString + ')' + ls;
          s:= s + RealToStrDec(F.Inventory.DisplayValue, F.Inventory.Decimals) + ls;
          s:= s + F.Inventory.DisplayUnitString;
          Memo.Lines.Add(s);
        end;
      end;
      Memo.Lines.Add('');

      Hops.SortByIndex2(0, 8, false);
      s:= 'Hop';
      Memo.Lines.Add(s);
      s:= 'Naam' + ls;
      s:= s + 'Vorm' + ls;
      s:= s + 'Voorraad' + ls;
      s:= s + 'Eenheid';
      Memo.Lines.Add(s);

      for i:= 0 to Hops.NumItems - 1 do
      begin
        H:= THop(Hops.Item[i]);
        if (H.Inventory.Value > 0) or H.AlwaysOnStock.Value then
        begin
          s:= H.Name.Value + ' (' + H.Alfa.DisplayString + ')' + ls;
          s:= s + HopFormDisplayNames[H.Form] + ls;
          s:= s + RealToStrDec(H.Inventory.DisplayValue, H.Inventory.Decimals) + ls;
          s:= s + H.Inventory.DisplayUnitString;
          Memo.Lines.Add(s);
        end;
      end;
      Memo.Lines.Add('');

      Yeasts.SortByIndex2(5, 6, false);
      s:= 'Gist';
      Memo.Lines.Add(s);
      s:= 'Fabrikant' + ls;
      s:= s + 'Naam' + ls;
      s:= s + 'Voorraad' + ls;
      s:= s + 'Eenheid';
      Memo.Lines.Add(s);
      for i:= 0 to Yeasts.NumItems - 1 do
      begin
        Y:= TYeast(Yeasts.Item[i]);
        if (Y.Inventory.Value > 0) or Y.AlwaysOnStock.Value then
        begin
          s:= Y.Laboratory.Value + ls;
          s:= s + Y.ProductID.Value + ' ' + Y.Name.Value + ls;
          s:= s + RealToStrDec(Y.Inventory.DisplayValue, Y.Inventory.Decimals) + ls;
          s:= s + Y.Inventory.DisplayUnitString;
          Memo.Lines.Add(s);
        end;
      end;
      Memo.Lines.Add('');

      Miscs.SortByIndex2(0, 5, false);
      s:= 'Overige ingrediënten';
      Memo.Lines.Add(s);
      s:= 'Naam' + ls;
      s:= s + 'Type' + ls;
      s:= s + 'Voorraad' + ls;
      s:= s + 'Eenheid';
      Memo.Lines.Add(s);
      for i:= 0 to Miscs.NumItems - 1 do
      begin
        M:= TMisc(Miscs.Item[i]);
        if (M.Inventory.Value > 0) or M.AlwaysOnStock.Value then
        begin
          s:= M.Name.Value + ls;
          s:= s + MiscTypeDisplayNames[M.MiscType] + ls;
          s:= s + RealToStrDec(M.Inventory.DisplayValue, M.Inventory.Decimals) + ls;
          s:= s + M.Inventory.DisplayUnitString;
          Memo.Lines.Add(s);
        end;
      end;
      Memo.Lines.SaveToFile(FN);
      FreeAndNIL(Memo);
      Result:= TRUE;
    end;
  except
    Result:= false;
    Screen.Cursor:= crDefault;
  end;
  Screen.Cursor:= crDefault;
end;

Function CreateBrewsList(Doc : TBHRDocument; DStart, DEnd : TDateTime; NRStart, NrEnd : string) : boolean;
var i, nRows, nCols, Ro, Co : integer;
    logo : TImage;
    tbl : TBHRTable;
    R : TRect;
    LineSpace, wi, totbr : word;
    totvol, x : double;
    s : string;
    Rec : TRecipe;
    Procedure NextR;
    begin
      Inc(Ro);
      if Ro > nRows - 1 then
      begin
        Ro:= 0;
        Inc(Co);
      end;
    end;
    Function GetClr(i : integer) : TColor;
    begin
      if (i mod 2 = 0) then Result:= clEven else Result:= clOneven;
    end;
begin
  Result:= false;
  totbr:= 0;
  totvol:= 0;
  Head1FontSize:= 15;
  Head2FontSize:= 13;
  Head3FontSize:= 10;
  TextFontSize:= 9;
  LineSpace:= round(1.2 * FontSizeToPix(TextFontSize, 1));
  if (Doc <> NIL)  then
  begin
    Screen.Cursor:= crHourglass;
    Application.ProcessMessages;
    try
      R.Top:= Doc.PrintRect.Top;
      R.Bottom:= Doc.PrintRect.Top;
      R.Left:= Doc.PrintRect.Left;
      R.Right:= Doc.PrintRect.Right;
      logo:= frmmain.iLogo;
      InsertHeaderPicture(Doc, Logo.Picture);
      SetHeaderText(Doc, 'OVERZICHT van brouwsels');

      nRows:= 1;
      if (DStart > 0) and (DEnd > 0) then
      begin
        for i:= 0 to Brews.NumItems - 1 do
        begin
          Rec:= TRecipe(Brews.Item[i]);
          if (Rec.Date.Value >= DStart) and (Rec.Date.Value <= DEnd) then
          begin
            Inc(nRows);
            Rec.Selected:= TRUE;
            inc(totbr);
          end
          else Rec.Selected:= false;
        end;
      end
      else if (NrStart <> '') and (NrEnd <> '') then
      begin
        for i:= 0 to Brews.NumItems - 1 do
        begin
          Rec:= TRecipe(Brews.Item[i]);
          if (Rec.NrRecipe.Value >= NrStart) and (Rec.NrRecipe.Value <= NrEnd) then
          begin
            Inc(nRows);
            Rec.Selected:= TRUE;
            inc(totbr);
          end
          else Rec.Selected:= false;
        end;
      end;

      nCols:= 5;
      Inc(nRows);
      tbl:= InsertTable(R, Doc, nCols, nRows);
      tbl.KeepWithNext:= false;
      tbl.KeepTogether:= false;
      //set column widths
      wi:= R.Right - R.Left;
      tbl.ColWidth[0]:= round(0.15 * wi);
      tbl.ColWidth[1]:= round(0.30 * wi);
      tbl.ColWidth[2]:= round(0.25 * wi);
      tbl.ColWidth[3]:= round(0.18 * wi);
      tbl.ColWidth[4]:= round(0.12 * wi);
      Ro:= 0;
      Co:= 0;
      tbl.RowColor[Ro]:= clHead;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Code';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Naam';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Stijl';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Brouwdatum';
        Content.AddString(s);
      end;
      Inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Size:= Head3FontSize;
        Font.Style:= [fsBold];
        Font.Color:= clBlack;
        s:= 'Volume';
        Content.AddString(s);
      end;
      for i:= 0 to Brews.NumItems - 1 do
      begin;
        Rec:= TRecipe(Brews.Item[i]);
        if Rec.Selected then
        begin
          NextR;
          tbl.RowColor[Ro]:= GetClr(Ro);
          Co:= 0;
          with tbl.Cells[Ro, Co] do
          begin
            s:= Rec.NrRecipe.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= Rec.Name.Value;
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            if Rec.Style <> NIL then
            begin
              s:= Rec.Style.Name.Value;
              Content.AddString(s);
            end;
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            s:= DateToStr(Rec.Date.Value);
            Content.AddString(s);
          end;
          inc(Co);
          with tbl.Cells[Ro, Co] do
          begin
            if Rec.VolumeFermenter.Value > 0 then
            begin
              x:= Rec.VolumeFermenter.DisplayValue;
              if Rec.Equipment <> NIL then
                x:= x + Rec.Equipment.TopUpWater.DisplayValue;
              s:= RealToStrDec(x, Rec.VolumeFermenter.Decimals);
            end
            else if Rec.VolumeAfterBoil.Value > 0 then
            begin
              s:= Rec.VolumeAfterBoil.DisplayString;
              x:= Rec.VolumeAfterBoil.DisplayValue;
            end
            else
            begin
              s:= Rec.BatchSize.DisplayString;
              x:= Rec.BatchSize.DisplayValue;
            end;
            totvol:= totvol + x;
            Content.AddString(s);
          end;
        end;
      end;

      NextR;
      tbl.RowColor[Ro]:= clHead;
      Co:= 0;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Style:= [fsBold];
        s:= 'TOTAAL';
        Content.AddString(s);
      end;
      inc(Co);
      with tbl.Cells[Ro, Co] do
      begin
        Font.Style:= [fsBold];
        s:= IntToStr(Totbr) + ' brouwsels';
        Content.AddString(s);
      end;
      Co:= 4;
      with tbl.Cells[Ro, Co] do
      begin
        Font.Style:= [fsBold];
        s:= RealToStrDec(totvol, 0) + ' ' + Rec.BatchSize.DisplayUnitString;
        Content.AddString(s);
      end;

      Result:= TRUE;
    except
      Result:= false;
      Screen.Cursor:= crDefault;
    end;
    Screen.Cursor:= crDefault;
  end;
end;

Initialization
  clHead:= RGBtoColor(210, 250, 160);
  clEven:= RGBtoColor(255, 255, 180);
  clOneven:= RGBtoColor(255, 255, 150);

end.

