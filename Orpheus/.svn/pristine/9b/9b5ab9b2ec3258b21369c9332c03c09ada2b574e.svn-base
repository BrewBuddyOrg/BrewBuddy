unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovccal;

type
  TForm1 = class(TForm)
    OvcCalendar1: TOvcCalendar;
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
