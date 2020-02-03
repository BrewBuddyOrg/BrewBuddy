unit FrCheckList;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, ExtCtrls, CheckLst, Data, StdCtrls, Buttons;

type

  { TFrmChecklist }

  TFrmChecklist = class(TForm)
    bbSaveClose: TBitBtn;
    bbClose: TBitBtn;
    Panel1: TPanel;
    ScrollBox1: TScrollBox;
    procedure bbCloseClick(Sender: TObject);
    procedure bbSaveCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormHide(Sender: TObject);
  private
    CLGroups : array of TCheckGroup;
    FRecipe : TRecipe;
    Procedure PlaceWindow;
    Procedure ClearAll;
  public
    Function Execute(R : TRecipe) : boolean;
  end;

var
  FrmChecklist: TFrmChecklist;

implementation

{$R *.lfm}
uses frmain, hulpfuncties, strutils, containers;

{ TFrmChecklist }

procedure TFrmChecklist.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmChecklist.bbSaveCloseClick(Sender: TObject);
var i, j : integer;
    CLG : TCheckListGroup;
begin
  //save checked in recipe
  if (FRecipe <> NIL) and (FRecipe.CheckList <> NIL) and (FRecipe.CheckList.NumItems > 0) then
  begin
    for i:= 0 to FRecipe.CheckList.NumGroups - 1 do
    begin
      CLG:= FRecipe.CheckList.Group[i];
      if CLG <> NIL then
        for j:= 0 to CLG.NumItems - 1 do
          CLG.Item[j].Item.Value:= CLGroups[i].Checked[j];
    end;
    FrmMain.UpdateAndStoreCheckList(FRecipe);
    FreeAndNIL(FRecipe);
  end;
  Close;
end;

procedure TFrmChecklist.bbCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmChecklist.FormDestroy(Sender: TObject);
var i : integer;
begin
  ClearAll;
  for i:= 0 to High(CLGroups) do
    CLGroups[i].Free;
  SetLength(CLGroups, 0);
end;

procedure TFrmChecklist.FormHide(Sender: TObject);
begin
end;

Procedure TFrmCheckList.PlaceWindow;
var ScreenBounds: TRect;
    {tp,} l, h : integer;
const
    {$ifdef windows}
    PanelH = 80;
    {$endif}
    {$ifdef unix}
    PanelH = 0;
    {$endif}
    FOptions = 1;
    FMargin = 10;
begin
  if FOptions = 0 then
  begin
    ScreenBounds := Screen.MonitorFromWindow(WindowHandle).BoundsRect;
    //tp:= ScreenBounds.Top + round(0.5 * (Screenbounds.Bottom - Screenbounds.Top) - 0.5 * Height);
    FrmMain.SetBounds(0, FrmMain.Top, FrmMain.Width, FrmMain.Height);
    l:= FrmMain.Left + FrmMain.Width + FMargin;
    h:= ScreenBounds.Bottom - ScreenBounds.Top - PanelH;
    SetBounds(l, ScreenBounds.Top, 410, h);
  end
  else if FOptions = 1 then
  begin
    FrmMain.SetBounds(0, FrmMain.Top, FrmMain.Width, FrmMain.Height);
    l:= FrmMain.Left + FrmMain.Width + FMargin;
    SetBounds(l, FrmMain.Top, 410, FrmMain.Height);
  end;
end;

Procedure TFrmChecklist.ClearAll;
var i : integer;
begin
  for i:= 0 to High(CLGroups) do
    CLGroups[i].Items.Clear;
end;

Function TFrmChecklist.Execute(R : TRecipe) : boolean;
var i, j : integer;
    CLG : TCheckListGroup;
    CLI : TCheckListItem;
    s : string;
begin
  Result:= True;
  Width:= 422;
  PlaceWindow;
  ClearAll;
  if (R <> NIL) and (R.CheckList <> NIL) and (R.CheckList.NumItems > 0) then
  begin
    Caption:= 'Checklist voor ' + R.NrRecipe.Value + ' - ' + R.Name.Value;
    FRecipe:= TRecipe.Create(NIL);
    FRecipe.Assign(R);
    FRecipe.AutoNr.Value:= R.AutoNr.Value;
    //create and place checkgroups
    SetLength(CLGroups, FRecipe.CheckList.NumGroups);
    for i:= R.CheckList.NumGroups - 1 downto 0 do
    begin
      CLGroups[i]:= TCheckGroup.Create(ScrollBox1);
      CLGroups[i].Parent:= ScrollBox1;
      CLGroups[i].Align:= alTop;
      CLGroups[i].AutoSize:= TRUE;
      CLGroups[i].BorderSpacing.Around:= 2;
    end;
    for i:= FRecipe.CheckList.NumGroups - 1 downto 0 do
    begin
      CLG:= FRecipe.CheckList.Group[i];
      if CLG <> NIL then
      begin
        CLGroups[i].Caption:= CLG.Caption.Value;
        for j:= 0 to CLG.NumItems - 1 do
        begin
          CLI:= CLG.Item[j];
          s:= CLI.Item.Caption;
          CLGroups[i].Items.Add(s);
          CLGroups[i].Checked[j]:= CLI.Item.Value;
        end;
      end;
    end;
  end;
  Show;
end;

Initialization
FrmChecklist:= NIL;

Finalization


end.

