{*********************************************************}
{*                  OVCTCHDR.PAS 4.06                    *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit ovctchdr;
  {Orpheus Table Cell - Headers for columns and rows}

interface

uses
  {$IFNDEF LCL} Windows, {$ELSE} LclIntf, {$ENDIF}
  SysUtils, Graphics, Classes, OvcTCmmn, OvcTCell, OvcTCStr;

type
  TOvcTCColHead = class(TOvcTCBaseString)
    protected {private}
      {.Z+}
      FHeadings      : TStringList;
      FShowActiveCol : boolean;
      FShowLetters   : boolean;
      {.Z-}

    protected
      {.Z+}
      procedure SetHeadings(H : TStringList);
      procedure SetShowActiveCol(SAC : boolean);
      procedure SetShowLetters(SL : boolean);

      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;
      {.Z-}

     public {protected}
      {.Z+}
      procedure chColumnsChanged(ColNum1, ColNum2 : TColNum; Action : TOvcTblActions);
      {.Z-}

    public
      constructor Create(AOwner : TComponent); override;
      destructor Destroy; override;

    published
      property Headings : TStringList
         read FHeadings write SetHeadings;

      property ShowActiveCol : boolean
         read FShowActiveCol write SetShowActiveCol
           default False;

      property ShowLetters : boolean
         read FShowLetters write SetShowLetters
           default True;

      {properties inherited from custom ancestor}
      property About;
      property Adjust default otaDefault;
      property Color;
      property Font;
      property Margin default 4;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;
      property UseASCIIZStrings default False;
      property UseWordWrap default False;

      {events inherited from custom ancestor}
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;

  TOvcTCRowHead = class(TOvcTCBaseString)
    protected {private}
      {.Z+}
      FShowActiveRow : boolean;
      FShowNumbers   : boolean;
      {.Z-}

    protected
      {.Z+}
      procedure SetShowActiveRow(SAR : boolean);
      procedure SetShowNumbers(SN : boolean);
      procedure tcPaint(TableCanvas : TCanvas;
                  const CellRect    : TRect;
                        RowNum      : TRowNum;
                        ColNum      : TColNum;
                  const CellAttr    : TOvcCellAttributes;
                        Data        : pointer); override;
      {.Z-}

    public
      constructor Create(AOwner : TComponent); override;

    published
      property ShowActiveRow : boolean
         read FShowActiveRow write SetShowActiveRow
          default False;

      property ShowNumbers : boolean
         read FShowNumbers write SetShowNumbers
           default True;

      {properties inherited from custom ancestor}
      property About;
      property Adjust default otaDefault;
      property Color;
      property Font;
      property Margin default 4;
      property Table;
      property TableColor default True;
      property TableFont default True;
      property TextHiColor default clBtnHighlight;
      property TextStyle default tsFlat;

      {events inherited from custom ancestor}
      property OnClick;
      property OnDblClick;
      property OnDragDrop;
      property OnDragOver;
      property OnEndDrag;
      property OnMouseDown;
      property OnMouseMove;
      property OnMouseUp;
      property OnOwnerDraw;
  end;

implementation



{===TOvcTCColHead====================================================}
constructor TOvcTCColHead.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    FHeadings := TStringList.Create;
    Access := otxReadOnly;
    UseASCIIZStrings := false;
    {UseWordWrap := false;}
    ShowLetters := true;
  end;
{--------}
destructor TOvcTCColHead.Destroy;
  begin
    FHeadings.Free;
    inherited Destroy;
  end;
{--------}
procedure TOvcTCColHead.chColumnsChanged(ColNum1, ColNum2 : TColNum;
                                         Action : TOvcTblActions);
  var
    MaxColNum : TColNum;
    ColNum    : TColNum;
    Temp : string;
  begin
    case Action of
      taInsert :
        if (0 <= ColNum1) and (ColNum1 < FHeadings.Count) then
          FHeadings.Insert(ColNum1, '')
        else if (ColNum1 = FHeadings.Count) then
          FHeadings.Add('');
      taDelete :
        if (0 <= ColNum1) and (ColNum1 < FHeadings.Count) then
          FHeadings.Delete(ColNum1);
      taExchange :
        begin
          MaxColNum := MaxL(ColNum1, ColNum2);
          if (MaxColNum >= FHeadings.Count) and (FHeadings.Count > 0) then
            for ColNum := FHeadings.Count to MaxColNum do
              FHeadings.Add('');
          if (0 <= ColNum1) and (0 <= ColNum2) and
             (FHeadings.Count > 0) then
            begin
              Temp := FHeadings[ColNum1];
              FHeadings[ColNum1] := FHeadings[ColNum2];
              FHeadings[ColNum2] := Temp;
            end;
        end;
    end;
  end;
{--------}
procedure TOvcTCColHead.tcPaint(TableCanvas : TCanvas;
                          const CellRect    : TRect;
                                RowNum      : TRowNum;
                                ColNum      : TColNum;
                          const CellAttr    : TOvcCellAttributes;
                                Data        : pointer);
  {------}
  procedure PaintAnArrow;
    var
      ArrowDim : Integer;
      X, Y     : Integer;
      LeftPoint, RightPoint, BottomPoint : TPoint;
      CellWidth  : integer;
      CellHeight : integer;
    begin
      CellWidth := CellRect.Right - CellRect.Left;
      CellHeight := CellRect.Bottom - CellRect.Top;
      with TableCanvas do
        begin
          Pen.Color := CellAttr.caFont.Color;
          Brush.Color := Pen.Color;
          ArrowDim := MinI(CellWidth, CellHeight) div 3;
          case CellAttr.caAdjust of
            otaTopLeft, otaCenterLeft, otaBottomLeft:
              X := Margin;
            otaTopRight, otaCenterRight, otaBottomRight:
              X := CellWidth-Margin-ArrowDim;
          else
            X := (CellWidth - ArrowDim) div 2;
          end;{case}
          inc(X, CellRect.Left);
          case CellAttr.caAdjust of
            otaTopLeft, otaTopCenter, otaTopRight:
              Y := Margin;
            otaBottomLeft, otaBottomCenter, otaBottomRight:
              Y := CellHeight-Margin-ArrowDim;
          else
            Y := (CellHeight - ArrowDim) div 2;
          end;{case}
          inc(Y, CellRect.Top);
          LeftPoint := Point(X, Y);
          RightPoint := Point(X+ArrowDim, Y);
          BottomPoint := Point(X+(ArrowDim div 2), Y+ArrowDim);
          Polygon([LeftPoint, RightPoint, BottomPoint]);
        end;
    end;
  {------}
  var
    DataSt    : POvcShortString absolute Data;
    LockedCols: TColNum;
    ActiveCol : TColNum;
    WorkCol   : TColNum;
    C         : string[1];
    HeadSt    : ShortString;
    CA        : TOvcCellAttributes;
  begin
    CA := CellAttr;
    if Assigned(FTable) then
      begin
        LockedCols := tcRetrieveTableLockedCols;
        ActiveCol := tcRetrieveTableActiveCol;
      end
    else
      begin
        LockedCols := 0;
        ActiveCol := -1;
      end;
    HeadSt := '';
    { Set the cell color and font }
    if not TableColor then
      CA.caColor := Color;
    if not TableFont then begin
      CA.caFont.Assign(Font);
      CA.caFontColor := Font.Color;
    end;
    { if required show a down arrow for the active column }
    if ShowActiveCol and (ColNum = ActiveCol) then
      begin
        {this call to inherited tcPaint blanks out the cell}
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA,
          @HeadSt);
        PaintAnArrow;
      end
    else if ShowLetters then
      begin
        {convert the column number to the spreadsheet-style letters}
        WorkCol := ColNum - LockedCols + 1;
        HeadSt := '.';
        while (WorkCol > 0) do
          begin
            C := AnsiChar(pred(WorkCol) mod 26 + ord('A'));
            System.Insert(C, HeadSt, 1);
            WorkCol := pred(WorkCol) div 26;
          end;
        Delete(HeadSt, length(HeadSt), 1);
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA,
          @HeadSt);
      end
    else {Data points to a column heading}
      begin
        if Assigned(Data) then
          HeadSt := DataSt^
        else if (0 <= ColNum) and (ColNum < Headings.Count) then
          HeadSt := Headings[ColNum];
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CA,
          @HeadSt);
      end;
  end;
{--------}
procedure TOvcTCColHead.SetHeadings(H : TStringList);
  begin
    FHeadings.Assign(H);
    tcDoCfgChanged;
  end;
{--------}
procedure TOvcTCColHead.SetShowActiveCol(SAC : boolean);
  begin
    if (SAC <> ShowActiveCol) then
      begin
        FShowActiveCol := SAC;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTCColHead.SetShowLetters(SL : boolean);
  begin
    if (SL <> ShowLetters) then
      begin
        FShowLetters := SL;
        tcDoCfgChanged;
      end;
  end;
{====================================================================}

{===TOvcTCRowHead====================================================}
constructor TOvcTCRowHead.Create(AOwner : TComponent);
  begin
    inherited Create(AOwner);
    Access := otxReadOnly;
    UseASCIIZStrings := false;
    UseWordWrap := false;
    ShowNumbers := true;
  end;
{--------}
procedure TOvcTCRowHead.tcPaint(TableCanvas : TCanvas;
                          const CellRect    : TRect;
                                RowNum      : TRowNum;
                                ColNum      : TColNum;
                          const CellAttr    : TOvcCellAttributes;
                                Data        : pointer);
  {------}
  procedure PaintAnArrow;
    var
      ArrowDim : Integer;
      X, Y     : Integer;
      TopPoint, BottomPoint, RightPoint : TPoint;
      CellWidth  : integer;
      CellHeight : integer;
    begin
      CellWidth := CellRect.Right - CellRect.Left;
      CellHeight := CellRect.Bottom - CellRect.Top;
      with TableCanvas do
        begin
          Pen.Color := CellAttr.caFont.Color;
          Brush.Color := Pen.Color;
          ArrowDim := MinI(CellWidth-8, CellHeight div 3);
          case CellAttr.caAdjust of
            otaTopLeft, otaCenterLeft, otaBottomLeft    : X := Margin;
            otaTopRight, otaCenterRight, otaBottomRight : X := CellWidth-Margin-ArrowDim;
          else
            X := (CellWidth - ArrowDim) div 2;
          end;{case}
          inc(X, CellRect.Left);
          case CellAttr.caAdjust of
            otaTopLeft, otaTopCenter, otaTopRight          : Y := Margin;
            otaBottomLeft, otaBottomCenter, otaBottomRight : Y := CellHeight-Margin-ArrowDim;
          else
            Y := (CellHeight - ArrowDim) div 2;
          end;{case}
          inc(Y, CellRect.Top);
          TopPoint := Point(X, Y);
          BottomPoint := Point(X, Y+ArrowDim);
          RightPoint := Point(X+ArrowDim, Y+(ArrowDim div 2));
          Polygon([RightPoint, TopPoint, BottomPoint]);
        end;
    end;
  {------}
  var
    HeadSt : ShortString;
    ActiveRow  : TRowNum;
    LockedRows : TRowNum;
    WorkRow    : TRowNum;
  begin
    if Assigned(FTable) then
      begin
        LockedRows := tcRetrieveTableLockedRows;
        ActiveRow := tcRetrieveTableActiveRow;
      end
    else
      begin
        LockedRows := 0;
        ActiveRow := -1;
      end;
    {display the row number, etc}
    HeadSt := '';
    if (ShowActiveRow and (RowNum = ActiveRow)) then
      begin
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @HeadSt);
        PaintAnArrow;
      end
    else
      begin
        if ShowNumbers then
          begin
            WorkRow := (RowNum + 1) - LockedRows;
            HeadSt := Format('%d', [WorkRow]);
          end;
        inherited tcPaint(TableCanvas, CellRect, RowNum, ColNum, CellAttr, @HeadSt);
      end;
  end;
{--------}
procedure TOvcTCRowHead.SetShowActiveRow(SAR : boolean);
  begin
    if (SAR <> ShowActiveRow) then
      begin
        FShowActiveRow := SAR;
        tcDoCfgChanged;
      end;
  end;
{--------}
procedure TOvcTCRowHead.SetShowNumbers(SN : boolean);
  begin
    if (SN <> ShowNumbers) then
      begin
        FShowNumbers := SN;
        tcDoCfgChanged;
      end;
  end;
{====================================================================}


end.
