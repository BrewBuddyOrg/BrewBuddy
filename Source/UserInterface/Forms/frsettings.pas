unit FrSettings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, StdCtrls, Spin, ExtCtrls, Grids, Data;

type

  { TfrmSettings }

  TfrmSettings = class(TForm)
    bbColorDefault: TBitBtn;
    bbFontColor: TBitBtn;
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    bbTextColorDefault: TBitBtn;
    BitBtn1: TBitBtn;
    bbPanel: TBitBtn;
    cbAdjustAlfa: TCheckBox;
    cbCheckNewVersions: TCheckBox;
    cbConfirmSave: TCheckBox;
    cbExtract: TComboBox;
    cbFont: TComboBox;
    cbHopStorageType: TComboBox;
    cbShowPossibleWithStock: TCheckBox;
    cbUseCloud: TCheckBox;
    CheckBox1: TCheckBox;
    cgFontStyle: TCheckGroup;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    FloatSpinEdit1: TFloatSpinEdit;
    fseBrixCorrection: TFloatSpinEdit;
    fseFWHFactor: TFloatSpinEdit;
    fseGrainAbsorption: TFloatSpinEdit;
    fseMashHopFactor: TFloatSpinEdit;
    fsePelletFactor: TFloatSpinEdit;
    fsePlugFactor: TFloatSpinEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    gbExample: TGroupBox;
    gbFont: TGroupBox;
    Label1: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    pcSettings: TPageControl;
    ProgressBar1: TProgressBar;
    rgBitterness: TRadioGroup;
    seHopStorageTemp: TSpinEdit;
    seFontSize: TSpinEdit;
    TreeView1: TTreeView;
    tsAppearance: TTabSheet;
    tsGlobal: TTabSheet;
    procedure bbColorDefaultClick(Sender: TObject);
    procedure bbControlsClick(Sender: TObject);
    procedure bbFontColorClick(Sender: TObject);
    procedure bbPanelClick(Sender: TObject);
    procedure bbTextColorDefaultClick(Sender: TObject);
    procedure cbFontChange(Sender: TObject);
    procedure cgFontStyleClick(Sender: TObject);
    procedure cgFontStyleItemClick(Sender: TObject; Index: integer);
    procedure FormCreate(Sender: TObject);
    procedure seFontSizeChange(Sender: TObject);
  private
    FStyle : TStyle;
  public
    Function Execute : boolean;
  end;

var
  frmSettings: TfrmSettings;

implementation

uses Hulpfuncties;

{$R *.lfm}

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  cbFont.Items := Screen.Fonts;
  cbFont.Items.Insert(0, 'Standaard');
  cbFont.ItemIndex:= 0;
  Settings.Style.SetControlsStyle(self);
end;

procedure TfrmSettings.bbPanelClick(Sender: TObject);
begin
  ColorDialog1.Color:= FStyle.PanelColors;
  if ColorDialog1.Execute then
  begin
    FStyle.PanelColors:= ColorDialog1.Color;
    FStyle.SetWinControlsStyle(gbExample);
  end;
end;

procedure TfrmSettings.bbFontColorClick(Sender: TObject);
begin
  ColorDialog1.Color:= FStyle.Font.Color;
  if ColorDialog1.Execute then
  begin
    FStyle.Font.Color:= ColorDialog1.Color;
    FStyle.SetWinControlsStyle(gbExample);
  end;
end;

procedure TfrmSettings.bbTextColorDefaultClick(Sender: TObject);
begin
  FStyle.Font.Color:= clDefault;
  FStyle.SetWincontrolsStyle(gbExample);
end;

procedure TfrmSettings.cbFontChange(Sender: TObject);
begin
  if cbFont.ItemIndex = 0 then FStyle.Font.Name:= 'default'
  else FStyle.Font.Name:= cbFont.Items[cbFont.ItemIndex];
  FStyle.SetWinControlsStyle(gbExample);
end;

procedure TfrmSettings.seFontSizeChange(Sender: TObject);
begin
  FStyle.Font.Height:= seFontSize.Value;
  FStyle.SetWinControlsStyle(gbExample);
end;

procedure TfrmSettings.cgFontStyleClick(Sender: TObject);
begin
end;

procedure TfrmSettings.cgFontStyleItemClick(Sender: TObject; Index: integer);
begin
  FStyle.Font.Style:= [];
  if cgFontStyle.Checked[0] then FStyle.Font.Style:= FStyle.Font.Style + [fsBold];
  if cgFontStyle.Checked[1] then FStyle.Font.Style:= FStyle.Font.Style + [fsItalic];
  FStyle.SetWinControlsStyle(gbExample);
end;

procedure TfrmSettings.bbColorDefaultClick(Sender: TObject);
begin
  FStyle.PanelColors:= clDefault;
  FStyle.SetWincontrolsStyle(gbExample);
end;

procedure TfrmSettings.bbControlsClick(Sender: TObject);
begin
  ColorDialog1.Color:= FStyle.ControlColors;
  if ColorDialog1.Execute then
  begin
    FStyle.ControlColors:= ColorDialog1.Color;
    FStyle.SetWinControlsStyle(gbExample);
  end;
end;

Function TfrmSettings.Execute : boolean;
var s : string;
    i : integer;
begin
  pcSettings.ActivePage:= tsGlobal;
  Result:= false;

  FStyle:= TStyle.Create;
  FStyle.Assign(Settings.Style);
  i:= Settings.Style.Font.Height;

  if FStyle.Font.Name = 'default' then cbFont.ItemIndex:= 0
  else cbFont.ItemIndex:= cbFont.Items.IndexOf(FStyle.Font.Name);
  i:= FStyle.Font.Height;
  seFontSize.Value:= i;
  cgFontStyle.Checked[0]:= (fsBold in FStyle.Font.Style);
  cgFontStyle.Checked[1]:= (fsItalic in FStyle.Font.Style);

  cbExtract.Items.Add(UnitNames[SG]);
  cbExtract.Items.Add(UnitNames[Plato]);

  s:= Settings.SGUnit.Value;
  cbExtract.ItemIndex:= cbExtract.Items.IndexOf(s);

  fseBrixCorrection.MinValue:= Settings.BrixCorrection.MinValue;
  fseBrixCorrection.MaxValue:= Settings.BrixCorrection.MaxValue;
  fseBrixCorrection.Value:= Settings.BrixCorrection.Value;
  fseGrainAbsorption.MinValue:= Settings.GrainAbsorption.MinValue;
  fseGrainAbsorption.MaxValue:= Settings.GrainAbsorption.MaxValue;
  fseGrainAbsorption.Value:= Settings.GrainAbsorption.Value;
  fseFWHFactor.MinValue:= Settings.FWHFactor.MinValue;
  fseFWHFactor.MaxValue:= Settings.FWHFactor.MaxValue;
  fseFWHFactor.Value:= Settings.FWHFactor.Value;

  fseBrixCorrection.Value:= Settings.BrixCorrection.Value;
  fseGrainAbsorption.Value:= Settings.GrainAbsorption.Value;
  fseFWHFactor.Value:= Settings.FWHFactor.Value;
  fsePelletFactor.Value:= Settings.PelletFactor.Value;
  fseMashHopFactor.Value:= Settings.MashHopFactor.Value;
  fsePlugFactor.Value:= Settings.PlugFactor.Value;
  cbAdjustAlfa.Checked:= Settings.AdjustAlfa.Value;
  seHopStorageTemp.Value:= Settings.HopStorageTemp.Value;
  cbHopStorageType.ItemIndex:= Settings.HopStorageType.Value;

  i:= Settings.SGBitterness.Value;
  rgBitterness.ItemIndex:= i;

  cbConfirmSave.Checked:= Settings.ConfirmSave.Value;
  cbShowPossibleWithStock.Checked:= Settings.ShowPossibleWithStock.Value;

  cbUseCloud.Checked:= Settings.UseCloud.Value;
  cbCheckNewVersions.Checked:= Settings.CheckForNewVersion.Value;

  FStyle.SetWinControlsStyle(gbExample);

{  seFontHeight.Value:= Settings.FontHeight.Value;
  seFontHeight.MinValue:= Settings.FontHeight.MinValue;
  seFontHeight.MaxValue:= Settings.FontHeight.MaxValue;}

//  SetFontHeight(self, Settings.FontHeight.Value);

  if ShowModal = mrOK then
  begin
    Result:= TRUE;
    Settings.BrixCorrection.Value:= fseBrixCorrection.Value;
    Settings.GrainAbsorption.Value:= fseGrainAbsorption.Value;
    Settings.FWHFactor.Value:= fseFWHFactor.Value;
    Settings.PelletFactor.Value:= fsePelletFactor.Value;
    Settings.MashHopFactor.Value:= fseMashHopFactor.Value;
    Settings.PlugFactor.Value:= fsePlugFactor.Value;
    Settings.SGUnit.Value:= cbExtract.Items[cbExtract.ItemIndex];
    Settings.AdjustAlfa.Value:= cbAdjustAlfa.Checked;
    Settings.HopStorageTemp.Value:= seHopStorageTemp.Value;
    Settings.HopStorageType.Value:= cbHopStorageType.ItemIndex;

    i:= rgBitterness.ItemIndex;
    Settings.SGBitterness.Value:= i;
    Settings.ConfirmSave.Value:= cbConfirmSave.Checked;
    Settings.ShowPossibleWithStock.Value:= cbShowPossibleWithStock.Checked;

    Settings.UseCloud.Value:= cbUseCloud.Checked;
    Settings.CheckForNewVersion.Value:= cbCheckNewVersions.Checked;

//    Settings.FontHeight.Value:= seFontHeight.Value;

    Settings.Style.Assign(FStyle);

    Settings.Save;
  end;
  FStyle.Free;
end;

end.

