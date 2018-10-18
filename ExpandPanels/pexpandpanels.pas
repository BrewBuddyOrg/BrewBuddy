{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit Pexpandpanels;

interface

uses
  ExpandPanels, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ExpandPanels', @ExpandPanels.Register);
end;

initialization
  RegisterPackage('Pexpandpanels', @Register);
end.
