#!/bin/sh
lazdir=~/lazarus
if ! [ -e $lazdir ] 
then
  lazdir=/usr/local/share/lazarus
fi
$lazdir/lazbuild -d --ws=gtk tests/TestFlexEdit/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestLabel/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestRLbl/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestSimpField/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestSpinner/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestTable/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestTblEdits/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestURL/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestVLB/project1.lpi
$lazdir/lazbuild -d --ws=gtk tests/TestCalendar/project1.lpi
