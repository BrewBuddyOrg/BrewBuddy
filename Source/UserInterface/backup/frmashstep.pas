unit frmashstep;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Spin, Buttons, Data, Hulpfuncties;

type

  { TFrmMashStep }

  TFrmMashStep = class(TForm)
    bbOK: TBitBtn;
    bbCancel: TBitBtn;
    cbMSType: TComboBox;
    eName: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lRampTime: TLabel;
    lStepTime: TLabel;
    lStepTemp: TLabel;
    lEndTemp: TLabel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    seEndTemp: TSpinEdit;
    seStepTime: TSpinEdit;
    seRampTime: TSpinEdit;
    seStepTemp: TSpinEdit;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    Function Execute(MS : TMashStep) : boolean;
  end; 

var
  FrmMashStep: TFrmMashStep;

implementation

//{$R *.lfm}

Function TFrmMashStep.Execute(MS : TMashStep) : boolean;
var mt : TMashStepType;
begin
  Result:= false;
  if MS <> NIL then
  begin
    eName.Text:= MS.Name.Value;
    cbMSType.Items.Clear;
    for mt:= Low(MashStepTypeDisplayNames) to High(MashStepTypeDisplayNames) do
      cbMSType.Items.Add(MashStepTypeDisplayNames[mt]);
    cbMSType.ItemIndex:= cbMSType.Items.IndexOf(MS.TypeDisplayName);
    seStepTemp.Value:= round(MS.StepTemp.DisplayValue);
    lStepTemp.Caption:= UnitNames[MS.StepTemp.DisplayUnit];
    seEndTemp.Value:= Round(MS.EndTemp.DisplayValue);
    lEndTemp.Caption:= UnitNames[MS.EndTemp.DisplayUnit];
    seStepTime.Value:= round(MS.StepTime.DisplayValue);
    lStepTime.Caption:= UnitNames[MS.StepTime.DisplayUnit];
    seRampTime.Value:= round(MS.RampTime.DisplayValue);
    lRampTime.Caption:= UnitNames[MS.RampTime.DisplayUnit];

    cbMSType.Enabled:= (MS.PriorStep <> NIL);
    if MS.PriorStep = NIL then cbMSType.ItemIndex:= 0;

    Result:= (ShowModal = mrOK);
    if Result then
    begin
      MS.Name.Value:= eName.Text;
      MS.TypeDisplayName:= cbMSType.Items[cbMSType.ItemIndex];
      MS.StepTemp.DisplayValue:= seStepTemp.Value;
      MS.EndTemp.DisplayValue:= seEndTemp.Value;
      MS.StepTime.DisplayValue:= seStepTime.Value;
      MS.RampTime.DisplayValue:= seRampTime.Value;
    end;
  end;
end;

procedure TFrmMashStep.FormCreate(Sender: TObject);
begin
  Settings.Style.SetControlsStyle(self);
//  SetFontHeight(self, Settings.FontHeight.Value);
end;

procedure TFrmMashStep.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  CloseAction := caFree;
end;

end.

