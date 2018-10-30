unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ovclabel;

type

  { TForm1 }

  TForm1 = class(TForm)
    OvcLabel1: TOvcLabel;
    OvcLabel2: TOvcLabel;
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
