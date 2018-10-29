unit Unit1;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, {$ENDIF}
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ovcbase, ovcvlb, StdCtrls;

type
  TForm1 = class(TForm)
    OvcVirtualListBox1: TOvcVirtualListBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure OvcVirtualListBox1GetItem(Sender: TObject; Index: Integer;
      var ItemString: String);
    procedure OvcVirtualListBox1DblClick(Sender: TObject);
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
{$ELSE}
{$R *.lfm}
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
var
  TabStops : array[0..1] of Integer;
begin
  TabStops[0] := 150;
  TabStops[1] := 300;
  OvcVirtualListBox1.SetTabStops(TabStops);

  OvcVirtualListBox1.Header := 'Name column'#9'Address column'#9'City column';

  if OvcVirtualListBox1.IntegralHeight then
    OvcVirtualListBox1.ClientHeight := 
     (OvcVirtualListBox1.ClientHeight div OvcVirtualListBox1.RowHeight) * 
     OvcVirtualListBox1.RowHeight;
      {Since RowHeight might have changed based on font used by current
        platform, make sure height still integral.}
end;

procedure TForm1.OvcVirtualListBox1GetItem(Sender: TObject; Index: Integer;
  var ItemString: String);
begin
  ItemString := 'Item ' + IntToStr(Index) + ' name'#9 + 
                'Item ' + IntToStr(Index) + ' address'#9 + 
                'Item ' + IntToStr(Index) + ' city';
end;

procedure TForm1.OvcVirtualListBox1DblClick(Sender: TObject);
begin
  Label1.Caption := 
   'You double-clicked item ' + IntToStr(OvcVirtualListBox1.ItemIndex);
end;


end.
