unit OSspecific;

{$mode objfpc}{$H+}

interface

uses
  Graphics;

function GetBlackColor(): TColor;

implementation

function GetBlackColor(): TColor;
begin
  {$ifdef Windows}
  result:= RGBToColor(242, 242, 242);
  {$endif}
  {$ifdef Unix}
  result:= clBackground;
  {$endif}
  {$ifdef darwin}
  result:= clBackground;
  {$endif}
end;

end.

