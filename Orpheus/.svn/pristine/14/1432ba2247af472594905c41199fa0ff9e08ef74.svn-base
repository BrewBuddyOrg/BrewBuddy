unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ovcsc, ovcbase;

type
  TForm1 = class(TForm)
    OvcSpinner1: TOvcSpinner;
    Edit1: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$IFNDEF LCL}
{$R *.dfm}
{$ENDIF}


initialization
{$IFDEF LCL}
{$I unit1.lrs}  {Include form's resource file}
{$ENDIF}

end.
