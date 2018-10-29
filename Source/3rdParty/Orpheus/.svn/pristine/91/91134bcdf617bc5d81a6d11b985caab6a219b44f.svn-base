unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovcrlbl;

type
  TForm1 = class(TForm)
    OvcRotatedLabel1: TOvcRotatedLabel;
    OvcRotatedLabel2: TOvcRotatedLabel;
    OvcRotatedLabel3: TOvcRotatedLabel;
    OvcRotatedLabel4: TOvcRotatedLabel;
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
{$I Unit1.lrs}  {Include form's resource file}
{$ENDIF}

end.
