unit MyMin;

 {Minimum uses to compile all ported runtime and property 
   editor (design) units.
 
  Note: Doesn't compile orpheus.pas.}

interface

uses
  ovctcsim,
  ovctcedt,
  ovctccbx,
  ovctcbox,
  ovctcico,
  ovctable,
  o32tcflx,
  o32vpool,
  ovcrlbl,
  ovcurl,
  ovclabel,
  ovcsc,
  ovcvlb,
  ovcclrcb
{$IFDEF FPC},  {These already installed in Delphi}
  ovcabot0,
  ovclbl0,
  ovclbl1,
  myovctbpe1,
  myovctbpe2,
  myovcreg
{$ENDIF};

implementation

end.
