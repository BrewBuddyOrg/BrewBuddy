unit Containers;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, {$ifdef Windows}windows, windirs, {$endif}Forms, Controls, Dialogs,
  Data, Hulpfuncties, DOM, XMLRead, XMLWrite, XMLUtils, variants;//, frimport;

type
  TContainer = class(TObject)
   private
     FFileName : string;
     FImportFileName : string;
     FLabel : string;
     FCollection : array of TBase;
     FSelected : integer;
     FDoc : TXMLDocument;
     FRootNode, FChild : TDOMNode;
     Procedure SetSelected(i : integer);
   public
     Constructor Create; virtual;
     Destructor Destroy; override;
     Procedure SaveXML; virtual;
     Procedure ReadXML; virtual;
     Function ImportXML : boolean; virtual;
     Procedure SortByIndex(Index : integer; Decending : boolean; Nstart, Nend : integer);
     Procedure SortByIndex2(I1, I2 : integer; Decending : boolean);
     Procedure SortByName(s : string);
     Procedure UnSelect;
     Function AddItem : TBase; virtual;
     Procedure InsertItem(i : integer); virtual;
     Procedure RemoveItem(i : integer); virtual;
     Procedure RemoveByReference(Item : TBase); virtual;
     Procedure FreeCollection;
     Function GetNumItems : integer;
     Function GetItem(i : integer) : TBase;
     Function FindByName(s : string) : TBase;
     Function FindByNameOnStock(s : string) : TBase;
     Function FindByAutoNr(i : integer) : TBase;
     Procedure RemoveByAutoNr(i : integer);
     Function IndexByName(s : string) : integer;
     property Item[i: integer] : TBase read GetItem;
   published
     property FileName : string read FFileName write FFileName;
     property ImportFileName : string read FImportFileName;
     property Selected : integer read FSelected write SetSelected;
     property NodeLabel : string read FLabel write FLabel;
     property NumItems : integer read GetNumItems;
  end;

  TFermentables = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TFermentable;
     Function AddItem : TFermentable; override;
     Procedure InsertItem(i : integer); override;
     Function FindByNameAndSupplier(N, S : string) : TFermentable;
  published
    property SelectedItem : TFermentable read GetSelectedItem;
  end;

  THops = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : THop;
     Function AddItem : THop; override;
     Procedure InsertItem(i : integer); override;
     Function FindByNameAndOriginAndAlfa(N, O : string; A : double) : THop;
  published
    property SelectedItem : THop read GetSelectedItem;
  end;

  TMiscs = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TMisc;
     Function AddItem : TMisc;
     Procedure InsertItem(i : integer); override;
  published
    property SelectedItem : TMisc read GetSelectedItem;
  end;

  TYeasts = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TYeast;
     Function AddItem : TYeast;
     Procedure InsertItem(i : integer); override;
     Function FindByNameAndLaboratory(N, L : string) : TYeast;
  published
    property SelectedItem : TYeast read GetSelectedItem;
  end;

  TWaters = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TWater;
     Function AddItem : TWater;
     Procedure InsertItem(i : integer); override;
     Function GetDefaultWater : TWater;
     Function GetDemiWater : TWater;
  published
    property SelectedItem : TWater read GetSelectedItem;
  end;

  TEquipments = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
//     Function ImportXML : boolean; override;
     Function GetSelectedItem : TEquipment;
     Function AddItem : TEquipment;
     Procedure InsertItem(i : integer); override;
     Procedure CalcEfficiencyRegressionFactors;
     Procedure CalcAttenuationRegressionFactors;
  published
    property SelectedItem : TEquipment read GetSelectedItem;
  end;

  TBeerStyles = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TBeerStyle;
     Function AddItem : TBeerStyle;
     Procedure InsertItem(i : integer); override;
  published
    property SelectedItem : TBeerStyle read GetSelectedItem;
  end;

  TMashs = class(TContainer)
   private
   public
     Constructor Create; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Function ImportXML : boolean; override;
     Function GetSelectedItem : TMash;
     Function AddItem : TMash;
     Procedure InsertItem(i : integer); override;
  published
    property SelectedItem : TMash read GetSelectedItem;
  end;

  TMinMax = record
    Name : string;
    PercRecipes : single; //% of recipes with ingredient
    MinUse, AvUse, MaxUse : single; //use of the ingredient in recipes'
  end;

  TMinMaxArray = array of TMinMax;

  TRecipes = class(TContainer)
   private
     FFermentablesMinMaxArray : TMinMaxArray;
     FBitterhopMinMaxArray : TMinMaxArray;
     FAromahopMinMaxArray : TMinMaxArray;
     FDryhopMinMaxArray : TMinMaxArray;
     FYeastMinMaxArray : TMinMaxArray;
     FMiscMinMaxArray : TMinMaxArray;
     FCommonMinMaxArray : TMinMaxArray;
     Procedure QuickSortRecipes(var Arr : array of TBase);
     Function ImportXMLs(FN : TStrings; DN : string; Equip : TEquipment) : boolean;
     Function ImportXML(FN : string; Equip : TEquipment) : boolean;
     Function ImportRECs(FN : TStrings; DN : string; Equip : TEquipment) : boolean;
     Function ImportREC(FN : string; Equip : TEquipment) : boolean;
     Function GetLastNrRecipe : string;
     Procedure QuickSortA(var Arr : array of TMinMax);
     Function Exists(Arr : TMinMaxArray; FName : string) : integer;
     Function GetMaxAutoNr : integer;
   public
     Constructor Create; override;
     Destructor Destroy; override;
     Procedure SaveXML; override;
     Procedure ReadXML; override;
     Procedure CheckAutoNrs;
     //Function ImportFiles(FN : TStrings; DN : string; Equip : TEquipment;
     //                     FT : TFileType) : boolean;
     Function ImportFiles(FN : TStrings; DN : string; Equip : TEquipment
                          ) : boolean;
     Procedure Sort;
     Function GetSelectedItem : TRecipe;
     Function AddItem : TRecipe;
     Procedure InsertItem(i : integer); override;
     Function FindByNameAndNr(Nm, Nr : string) : TRecipe;
     Function FindByAutoNr(nr : integer) : TRecipe;
     Function ExportToCSV(A : array of integer) : boolean;
     Function AnalyseFermentables(Lett, Nm : string) : integer; //returns number of recipes
     Function AnalyseHops(Lett, Nm : string) : integer; //returns number of recipes
     Function AnalyseYeasts(Lett, Nm : string) : integer; //returns number of recipes
     Function AnalyseMiscs(Lett, Nm : string) : integer;
     Function AnalyseRecipes(Lett, Nm : string) : integer;
     property FermentablesMinMaxArray : TMinMaxArray read FFermentablesMinMaxArray;
     property BitterhopMinMaxArray : TMinMaxArray read FBitterhopMinMaxArray;
     property AromahopMinMaxArray : TMinMaxArray read FAromahopMinMaxArray;
     property DryhopMinMaxArray : TMinMaxArray read FDryhopMinMaxArray;
     property YeastMinMaxArray : TMinMaxArray read FYeastMinMaxArray;
     property MiscMinMaxArray : TMinMaxArray read FMiscMinMaxArray;
     property CommonMinMaxArray : TMinMaxArray read FCommonMinMaxArray;
   published
    property SelectedItem : TRecipe read GetSelectedItem;
    property LastNrRecipe : string read GetLastNrRecipe;
    property MaxAutoNr : integer read GetMaxAutoNr;
  end;

  TStyleRec = record
    Name : string;
    Recipes : array of TRecipe;
  end;

  TStyleLetters = record
    Letter : string;
    Styles : array of TStyleRec;
  end;

  TRecipesByStyle = class(TObject)
   private
     FStyleLetters : array of TStyleLetters;
     FCollection : TRecipes;
     Procedure Fill;
     Procedure Empty;
     Procedure Sort;
     Function GetNumStyleLetters : integer;
     Function GetNumStyles(i : integer) : integer;
     Function GetStyleLetter(i : integer) : string;
     Function GetStyleName(n : integer; s : integer) : string;
     Function GetNumRecipes(n : integer; s : integer) : integer;
     Function GetRecipe(n : integer; s : integer; i : integer) : TRecipe;
     Procedure QuickSortInStyles(var Arr : array of TRecipe);
     Procedure QuickSortStyles(var Arr : array of TStyleRec);
     Procedure QuickSortLetters(var Arr : array of TStyleLetters);
   public
     Constructor Create(R : TRecipes);
     Destructor Destroy; override;
     Procedure SaveXML;
     Function GetLetterByName(Num : string) : integer;
     Function GetStyleByName(Num, Stl : string) : integer;
     property NumStyles[i : integer] : integer read GetNumStyles;
     property NumRecipes[n : integer; s : integer] : integer read GetNumRecipes;
     property Recipe[n : integer; s : integer; i : integer] : TRecipe read GetRecipe;
     property StyleLetter[i : integer] : string read GetStyleLetter;
     property StyleName[n : integer; s : integer] : string read GetStyleName;
   published
     property NumStyleLetters : integer read GetNumStyleLetters;
  end;

  Procedure Reload;
  Procedure Backup;
  Procedure Restore(sourcedata : string);
  Procedure CheckBeerStyle(Rec : TRecipe);
  Procedure CheckFermentables(Rec : TRecipe);
  Procedure CheckYeasts(Rec : TRecipe);
  Procedure CheckDataFolder;
  Procedure ChangeDatabaseLocation(source, destination : string; copy, deleteold : boolean);

var
  Fermentables : TFermentables;
  Hops : THops;
  Miscs : TMiscs;
  Yeasts : TYeasts;
  Waters : TWaters;
  Equipments : TEquipments;
  Beerstyles : TBeerstyles;
  Mashs : TMashs;
  Recipes : TRecipes;
  Brews : TRecipes;

  Loc : string;

  Arr : array of longint;

implementation

uses frmain, ComCtrls, frselectbeerstyle, fileutil, LazFileUtils, {promashimport, cloud, subs,}
     {neuroot, }strutils, math, subs;

Procedure CheckSalts;
var M : TMisc;
begin
  if Miscs.FindByName('CaCl2') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'CaCl2';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Voor het maken van een ander waterprofiel. Voegt calcium en chloride toe. Voor het verbeteren van zoetere bieren.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('CaCO3') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'CaCO3';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Kalk. Voor het maken van een ander waterprofiel. Voegt calcium en (bi)carbonaat toe. Voor het verhogen van de pH tijdens het maischen.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('CaSO4') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'CaSO4';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Gips. Voor het maken van een ander waterprofiel. Voegt calcium en sulfaat toe. Voor het verbeteren van bittere bieren.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('MgSO4') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'MgSO4';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Epsom zout. Voor het maken van een ander waterprofiel. Voegt magnesium en sulfaat toe. Gebruik spaarzaam!';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('NaCl') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'NaCl';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Keukenzout. Voor het maken van een ander waterprofiel. Voegt natrium en chloride toe. Voor het accentueren van zoetheid. Bij hoge dosering wordt het bier ziltig.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('NaHCO3') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'NaHCO3';
    M.AmountIsWeight.Value:= true;
    M.Amount.vUnit:= kilogram;
    M.Amount.DisplayUnit:= gram;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Baksoda of bakpoeder. Voor het maken van een ander waterprofiel. Voegt natrium en bicarbonaat toe. Kan gebruikt worden voor verhoging van de pH tijdens het maischen.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
  if Miscs.FindByName('Melkzuur') = NIL then
  begin
    M:= Miscs.AddItem;
    M.Name.Value:= 'Melkzuur';
    M.AmountIsWeight.Value:= false;
    M.Amount.vUnit:= liter;
    M.Amount.DisplayUnit:= milliliter;
    M.Amount.Value:= 0;
    M.MiscType:= mtWaterAgent;
    M.Use:= muMash;
    M.UseFor.Value:= 'Melkzuur wordt gebruikt voor het verlagen van de pH tijdens het maischen en het verlagen van de pH van het spoelwater.';
    M.Inventory.vUnit:= M.Amount.vUnit;
    M.Inventory.DisplayUnit:= M.Amount.DisplayUnit;
    M.Inventory.Value:= 0;
  end;
end;

Constructor TContainer.Create;
begin
  Inherited;
  FFileName:= '';
  FSelected:= -1;
  FLabel:= '';
end;

Destructor TContainer.Destroy;
begin
  FreeCollection;
  Inherited;
end;

Procedure TContainer.SaveXML;
begin
  FDoc := TXMLDocument.Create;
//  FDoc.Encoding:= 'ISO-8859-1';
  FRootNode := FDoc.CreateElement(FLabel);
  FDoc.Appendchild(FRootNode);
end;

Procedure TContainer.ReadXML;
var FN : string;
begin
  FRootNode:= NIL;
  try
    FreeCollection;
    FN:= Settings.DataLocation.Value + FFileName;
    if FileExists(FN) then
    begin
      ReadXMLFile(FDoc, FN);
      FRootNode:= FDoc.FindNode(FLabel);
    end;
  except
    FDoc.Free;
  end;
end;

Function TContainer.ImportXML : boolean;
var dlg : TOpenDialog;
begin
  Result:= false;
  FRootNode:= NIL;
  FDoc := TXMLDocument.Create;
  dlg:= TOpenDialog.Create(frmMain);
  with dlg do
  begin
    DefaultExt:= '.xml';
    FileName:= '*.xml';
    Filter:= 'BrewBuddy xml|*.xml';
  end;
  FImportFileName:= '';
  try
    if (dlg.Execute) and (FileExists(dlg.FileName)) then
    begin
      FImportFileName:= dlg.FileName;
      dlg.Free;
      ReadXMLFile(FDoc, FImportFileName);
      FRootNode:= FDoc.FindNode(FLabel);
      Result:= TRUE;
    end;
  except
    FDoc.Free;
  end;
end;

Procedure TContainer.SortByIndex(Index : integer; Decending : boolean; Nstart, Nend : integer);
  procedure QuickSort(var A: array of TBase; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : variant;
      TB : TBase;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].ValueByIndex[Index];
    repeat
      while A[Lo].ValueByIndex[Index] < v do Inc(Lo);
      while A[Hi].ValueByIndex[Index] > v do Dec(Hi);
      if Lo <= Hi then
      begin
        TB:= A[Lo];
        A[Lo]:= A[Hi];
        A[Hi]:= TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;

  procedure QuickSortDec(var A: array of TBase; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : variant;
      TB : TBase;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].ValueByIndex[Index];
    repeat
      while A[Lo].ValueByIndex[Index] > v do Inc(Lo);
      while A[Hi].ValueByIndex[Index] < v do Dec(Hi);
      if Lo <= Hi then
      begin
        TB := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSortDec(A, iLo, Hi);
    if Lo < iHi then QuickSortDec(A, Lo, iHi);
  end;

begin
  if (High(FCollection) > 0) and (Index > -1) then
  begin
    if (NEnd = 0) or (NStart >= NEnd) then
    begin
      NStart:= Low(FCollection);
      NEnd:= High(FCollection);
    end;
    if Decending then
      QuickSortDec(FCollection, NStart, NEnd)
    else
      QuickSort(FCollection, NStart, NEnd);
  end;
end;

Procedure TContainer.SortByIndex2(I1, I2 : integer; Decending : boolean);
var a, b : integer;
    V1 : variant;
begin
  SortByIndex(I1, Decending, 0, 0);
  a:= 0; b:= 1;
  while b <= High(FCollection) do
  begin
    V1:= FCollection[a].ValueByIndex[I1];
    while (b <= High(FCollection)) and (FCollection[b].ValueByIndex[I1] = V1) do
      Inc(b);
    if (a < (b-1)) then
      SortByIndex(I2, Decending, a, b-1);
    a:= b;
  end;
end;

Procedure TContainer.SortByName(s : string);
var i : integer;
begin
  if High(FCollection) > -1 then
  begin
    i:= FCollection[0].IndexByName[s];
    if i > -1 then SortByIndex(i, false, 0, 0);
  end;
end;

Procedure TContainer.FreeCollection;
var i : integer;
begin
  for i:= Low(FCollection) to High(FCollection) do
    FCollection[i].Free;
  SetLength(FCollection, 0);
end;

Procedure TContainer.SetSelected(i : integer);
begin
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FSelected:= i;
end;

Procedure TContainer.UnSelect;
begin
  FSelected:= -1;
end;

Function TContainer.AddItem : TBase;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    Result:= FCollection[FSelected];
//    Result.AutoNr.Value:= MaxAutoNr;
  finally
  end;
end;

Procedure TContainer.InsertItem(i : integer);
var j : integer;
begin
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
  begin
    SetLength(FCollection, High(FCollection)+2);
    for j:= High(FCollection) downto i + 1 do
      FCollection[j]:= FCollection[j-1];
  end;
end;

Procedure TContainer.RemoveItem(i : integer);
var j : integer;
begin
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
  begin
    FCollection[i].Free;
    for j:= i to High(FCollection) - 1 do
      FCollection[j]:= FCollection[j+1];
    SetLength(FCollection, High(FCollection));
  end;
end;

Procedure TContainer.RemoveByReference(Item : TBase);
var i : integer;
begin
  for i:= Low(FCollection) to High(FCollection) do
    if FCollection[i] = Item then
    begin
      RemoveItem(i);
      Exit;
    end;
end;

Function TContainer.FindByName(s : string) : TBase;
var i : integer;
begin
  Result:= NIL;
  for i:= Low(FCollection) to High(FCollection) do
    if Trim(UpperCase(FCollection[i].Name.Value)) = Trim(Uppercase(s)) then
    begin
      Result:= FCollection[i];
      Exit;
    end;
end;

Function TContainer.FindByNameOnStock(s : string) : TBase;
var i : integer;
    ing : TIngredient;
begin
  Result:= NIL;
  ing:= NIL;
  for i:= Low(FCollection) to High(FCollection) do
  begin
    if FCollection[i] is TIngredient then
    begin
      if Trim(UpperCase(FCollection[i].Name.Value)) = Trim(Uppercase(s)) then
      begin
        ing:= TIngredient(FCollection[i]);
        if Result = NIL then Result:= ing
        else
        begin
          if ing.Inventory.Value > TIngredient(Result).Inventory.Value then
            Result:= ing;
        end;
      end;
    end;
  end;
end;

Function TContainer.IndexByName(s : string) : integer;
var i : integer;
begin
  Result:= -1;
  for i:= Low(FCollection) to High(FCollection) do
    if Trim(UpperCase(FCollection[i].Name.Value)) = Trim(Uppercase(s)) then
    begin
      Result:= i;
      Exit;
    end;
end;

Function TContainer.FindByAutoNr(i : integer) : TBase;
var j : integer;
begin
  Result:= NIL;
  for j:= 0 to High(FCollection) do
    if FCollection[j].AutoNr.Value = i then
    begin
      Result:= FCollection[j];
      Exit;
    end;
end;

Procedure TContainer.RemoveByAutoNr(i : integer);
var j : integer;
begin
  for j:= Low(FCollection) to High(FCollection) do
    if FCollection[j].AutoNr.Value = i then
    begin
      RemoveItem(j);
      Exit;
    end;
end;

Function TContainer.GetNumItems : integer;
begin
  Result:= High(FCollection) + 1;
end;

Function TContainer.GetItem(i : integer) : TBase;
begin
  Result:= NIL;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    Result:= FCollection[i];
end;


{=========================== TFermentables ====================================}

Constructor TFermentables.Create;
begin
  Inherited;
  FLabel:= 'FERMENTABLES';
  FFileName:= 'fermentables.xml';
end;

Procedure TFermentables.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TFermentable(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TFermentables.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TFermentable.Create(NIL);
        TFermentable(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TFermentables.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TFermentable.Create(NIL);
        TFermentable(FCollection[i-1]).ReadXML(FChild);
        if TFermentable(FCollection[i-1]).Yield.Value < 1 then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TFermentables.GetSelectedItem : TFermentable;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TFermentable(FCollection[FSelected]);
end;

Function TFermentables.AddItem : TFermentable;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TFermentable.Create(NIL);
    Result:= TFermentable(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TFermentables.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TFermentable.Create(NIL);
end;

Function TFermentables.FindByNameAndSupplier(N, S : string) : TFermentable;
var i : integer;
begin
  Result:= NIL;
  if (N <> '') AND (S <> '') then
  begin
    for i:= Low(FCollection) to High(FCollection) do
      if (Lowercase(TFermentable(FCollection[i]).Name.Value) = Lowercase(N)) and
         (Lowercase(TFermentable(FCollection[i]).Supplier.Value) = Lowercase(S)) then
      begin
        Result:= TFermentable(FCollection[i]);
        Exit;
      end;
  end;
end;

{================================== THops =====================================}

Constructor THops.Create;
begin
  Inherited;
  FLabel:= 'HOPS';
  FFileName:= 'hops.xml';
  FSelected:= -1;
end;

Procedure THops.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    for i:= Low(FCollection) to High(FCollection) do
      THop(FCollection[i]).SaveXML(FDoc, FRootNode, false);
    FN:= Settings.DataLocation.Value + FFileName;
    writeXMLFile(FDoc, FN);
 finally
    FDoc.Free;
  end;
end;

Procedure THops.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= THop.Create(NIL);
        THop(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function THops.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= THop.Create(NIL);
        THop(FCollection[i-1]).ReadXML(FChild);
        if THop(FCollection[i-1]).Alfa.Value <= 0.5 then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;

Function THops.GetSelectedItem : THop;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= THop(FCollection[FSelected]);
end;

Function THops.AddItem : THop;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    Result:= NIL;
    FCollection[High(FCollection)]:= THop.Create(NIL);
    Result:= THop(FCollection[FSelected]);
  finally
  end;
end;

Procedure THops.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= THop.Create(NIL);
end;

Function THops.FindByNameAndOriginAndAlfa(N, O : string; A : double) : THop;
var i : integer;
    A2 : double;
    N2, O2 : string;
begin
  Result:= NIL;
  N:= LowerCase(Trim(N));
  O:= LowerCase(Trim(O));
  A:= RoundTo(A, -1);
  if (N <> '') AND (O <> '') then
  begin
    for i:= Low(FCollection) to High(FCollection) do
    begin
      N2:= Lowercase(Trim(THop(FCollection[i]).Name.Value));
      O2:= Lowercase(Trim(THop(FCollection[i]).Origin.Value));
      A2:= THop(FCollection[i]).Alfa.Value;
      A2:= RoundTo(A2, -1);
      if (N2 = N) and (O2 = O) and (A2 = A) then
      begin
        Result:= THop(FCollection[i]);
        Exit;
      end;
    end;
  end;
end;

{================================== TMiscs ====================================}

Constructor TMiscs.Create;
begin
  Inherited;
  FLabel:= 'MISCS';
  FFileName:= 'miscs.xml';
  FSelected:= -1;
end;

Procedure TMiscs.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TMisc(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TMiscs.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TMisc.Create(NIL);
        TMisc(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TMiscs.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TMisc.Create(NIL);
        TMisc(FCollection[i-1]).ReadXML(FChild);
        {if TMisc(FCollection[i-1])..Value < 1 then
          RemoveByReference(FCollection[i-1]);}
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TMiscs.GetSelectedItem : TMisc;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TMisc(FCollection[FSelected]);
end;

Function TMiscs.AddItem : TMisc;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TMisc.Create(NIL);
    Result:= TMisc(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TMiscs.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TMisc.Create(NIL);
end;

{================================== TYeasts ===================================}

Constructor TYeasts.Create;
begin
  Inherited;
  FLabel:= 'YEASTS';
  FFileName:= 'yeasts.xml';
  FSelected:= -1;
end;

Procedure TYeasts.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TYeast(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TYeasts.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TYeast.Create(NIL);
        TYeast(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TYeasts.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TYeast.Create(NIL);
        TYeast(FCollection[i-1]).ReadXML(FChild);
        if TYeast(FCollection[i-1]).Laboratory.Value = '' then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;
Function TYeasts.GetSelectedItem : TYeast;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TYeast(FCollection[FSelected]);
end;

Function TYeasts.AddItem : TYeast;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TYeast.Create(NIL);
    Result:= TYeast(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TYeasts.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TYeast.Create(NIL);
end;

Function TYeasts.FindByNameAndLaboratory(N, L : string) : TYeast;
var i : integer;
begin
  Result:= NIL;
  if (N <> '') and (L <> '') then
  begin
    for i:= Low(FCollection) to High(FCollection) do
      if (Lowercase(TYeast(FCollection[i]).Name.Value) = Lowercase(N)) and
         (Lowercase(TYeast(FCollection[i]).Laboratory.Value) = Lowercase(L)) then
      begin
        Result:= TYeast(FCollection[i]);
        Exit;
      end;
  end;
end;

{================================== TWaters ===================================}

Constructor TWaters.Create;
begin
  Inherited;
  FLabel:= 'WATERS';
  FFileName:= 'waters.xml';
  FSelected:= -1;
end;

Procedure TWaters.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TWater(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TWaters.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TWater.Create(NIL);
        TWater(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TWaters.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TWater.Create(NIL);
        TWater(FCollection[i-1]).ReadXML(FChild);
        if TWater(FCollection[i-1]).Bicarbonate.Value < 0.1 then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TWaters.GetSelectedItem : TWater;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TWater(FCollection[FSelected]);
end;

Function TWaters.AddItem : TWater;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TWater.Create(NIL);
    Result:= TWater(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TWaters.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TWater.Create(NIL);
end;

Function TWaters.GetDefaultWater : TWater;
var i : integer;
    W : TWater;
begin
  Result:= NIL;
  for i:= 0 to NumItems - 1 do
  begin
    W:= TWater(Item[i]);
    if W.DefaultWater.Value then Result:= W;
  end;
end;

Function TWaters.GetDemiWater : TWater;
var i : integer;
    W : TWater;
begin
  Result:= NIL;
  for i:= 0 to NumItems - 1 do
  begin
    W:= TWater(Item[i]);
    if W.DemiWater then Result:= W;
  end;
  if Result = NIL then
    W:= TWater(FindByName('Gedemineraliseerd water'));
  if Result = NIL then
    W:= TWater(FindByName('Demiwater'));
  if Result = NIL then
    W:= TWater(FindByName('Osmosewater'));
end;

{================================== TBeerstyles ===============================}

Constructor TBeerstyles.Create;
begin
  Inherited;
  FLabel:= 'STYLES';
  FFileName:= 'styles.xml';
  FSelected:= -1;
end;

Procedure TBeerstyles.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TBeerstyle(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TBeerstyles.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TBeerStyle.Create(NIL);
        TBeerStyle(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TBeerstyles.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TBeerstyle.Create(NIL);
        TBeerstyle(FCollection[i-1]).ReadXML(FChild);
        if TBeerstyle(FCollection[i-1]).StyleLetter.Value = '' then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;
Function TBeerstyles.GetSelectedItem : TBeerstyle;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TBeerstyle(FCollection[FSelected]);
end;

Function TBeerstyles.AddItem : TBeerStyle;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TBeerstyle.Create(NIL);
    Result:= TBeerstyle(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TBeerstyles.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TBeerstyle.Create(NIL);
end;

{================================== TEquipments ===============================}

Constructor TEquipments.Create;
begin
  Inherited;
  FLabel:= 'EQUIPMENTS';
  FFileName:= 'equipments.xml';
  FSelected:= -1;
end;

Procedure TEquipments.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TEquipment(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TEquipments.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TEquipment.Create(NIL);
        TEquipment(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TEquipments.GetSelectedItem : TEquipment;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TEquipment(FCollection[FSelected]);
end;

Function TEquipments.AddItem : TEquipment;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TEquipment.Create(NIL);
    Result:= TEquipment(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TEquipments.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TEquipment.Create(NIL);
end;

Procedure TEquipments.CalcEfficiencyRegressionFactors;
var i : integer;
begin
  for i:= Low(FCollection) to High(FCollection) do
    TEquipment(FCollection[i]).CalcEfficiencyFactors;
end;

Procedure TEquipments.CalcAttenuationRegressionFactors;
var i : integer;
begin
  for i:= Low(FCollection) to High(FCollection) do
    TEquipment(FCollection[i]).CalcAttenuationFactors;
end;

{================================== TMashs ====================================}

Constructor TMashs.Create;
begin
  Inherited;
  FLabel:= 'MASHS';
  FFileName:= 'mashs.xml';
  FSelected:= -1;
end;

Procedure TMashs.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
      TMash(FCollection[i]).SaveXML(FDoc, FRootNode, false);
     writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TMashs.ReadXML;
var i : integer;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TMash.Create(NIL);
        TMash(FCollection[i-1]).ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TMashs.ImportXML : boolean;
var i : integer;
begin
  Inherited ImportXML;
  if FRootNode <> NIL then
  begin
    try
      i:= High(FCollection) + 1;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        FCollection[i-1]:= TMash.Create(NIL);
        TMash(FCollection[i-1]).ReadXML(FChild);
        if TMash(FCollection[i-1]).NumMashSteps = 0 then
          RemoveByReference(FCollection[i-1]);
        FChild:= FChild.NextSibling;
      end;
      Result:= TRUE;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TMashs.GetSelectedItem : TMash;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TMash(FCollection[FSelected]);
end;

Function TMashs.AddItem : TMash;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TMash.Create(NIL);
    Result:= TMash(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TMashs.InsertItem(i : integer);
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
    FCollection[i]:= TMash.Create(NIL);
end;

{================================== TRecipes ==================================}


Constructor TRecipes.Create;
begin
  Inherited;
  FLabel:= 'RECIPES';
  FFileName:= 'recipes.xml';
  FSelected:= -1;
  SetLength(FFermentablesMinMaxArray, 0);
  SetLength(FBitterhopMinMaxArray, 0);
  SetLength(FAromahopMinMaxArray, 0);
  SetLength(FDryhopMinMaxArray, 0);
  SetLength(FYeastMinMaxArray, 0);
  SetLength(FMiscMinMaxArray, 0);
  SetLength(FCommonMinMaxArray, 0);
end;

Destructor TRecipes.Destroy;
begin
  SetLength(FFermentablesMinMaxArray, 0);
  SetLength(FBitterhopMinMaxArray, 0);
  SetLength(FAromahopMinMaxArray, 0);
  SetLength(FDryhopMinMaxArray, 0);
  SetLength(FYeastMinMaxArray, 0);
  SetLength(FMiscMinMaxArray, 0);
  SetLength(FCommonMinMaxArray, 0);
  Inherited;
end;

Procedure TRecipes.SaveXML;
var i : integer;
    FN : string;
begin
  try
    Inherited SaveXML;
    FN:= Settings.DataLocation.Value + FFileName;
    for i:= Low(FCollection) to High(FCollection) do
    begin
      TRecipe(FCollection[i]).SaveXML(FDoc, FRootNode, false);
      Application.ProcessMessages;
    end;
    writeXMLFile(FDoc, FN);
   finally
    FDoc.Free;
  end;
end;

Procedure TRecipes.ReadXML;
var i : integer;
    R : TRecipe;
begin
  Inherited ReadXML;
  if FRootNode <> NIL then
  begin
    try
      i:= 0;
      FChild:= FRootNode.FirstChild;
      while FChild <> NIL do
      begin
        inc(i);
        SetLength(FCollection, i);
        Application.ProcessMessages;
        FCollection[i-1]:= TRecipe.Create(NIL);
        R:= TRecipe(FCollection[i-1]);
        if FFileName = 'brews.xml' then R.RecType:= rtBrew
        else if FFileName = 'recipes.xml' then
        R.RecType:= rtRecipe
        else R.RecType:= rtCloud;
        R.ReadXML(FChild);
        FChild:= FChild.NextSibling;
      end;
    finally
      FDoc.Free;
    end;
  end;
end;

Function TRecipes.FindByNameAndNr(Nm, Nr : string) : TRecipe;
var i : integer;
    R : TRecipe;
begin
  Result:= NIL;
  Nm:= Lowercase(Nm);
  Nr:= Lowercase(Nr);
  for i:= 0 to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (Lowercase(R.NrRecipe.Value) = Nr) and (Lowercase(R.Name.Value) = Nm) then
    begin
      Result:= R;
      Exit;
    end;
  end;
end;

Function TRecipes.FindByAutoNr(nr : integer) : TRecipe;
var i : integer;
    R : TRecipe;
begin
  Result:= NIL;
  for i:= 0 to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.AutoNr.Value = Nr) then
    begin
      Result:= R;
      Exit;
    end;
  end;
end;

Procedure TRecipes.CheckAutoNrs;
var i, maxnr : integer;
    R : TRecipe;
begin
  maxnr:= MaxAutoNr;
  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if R.AutoNr.Value = 0 then
    begin
      inc(maxnr);
      R.AutoNr.Value:= maxnr;
    end;
  end;
end;

{ JR: Shortcut --> FileType removed, not necessary
Function TRecipes.ImportFiles(FN : TStrings; DN : string; Equip : TEquipment;
                              FT : TFileType) : boolean;}
Function TRecipes.ImportFiles(FN : TStrings; DN : string; Equip : TEquipment
                             ) : boolean;

begin
  Result:= false;
//  case FT of
//  ftXML: Result:= ImportXMLs(FN, DN, Equip);
//  ftPromash: Result:= ImportRECs(FN, DN, Equip);
////  ftInvalid: Result:= false;
//  end;
  Result := ImportXMLs(FN, DN, Equip);
  SaveXML;
end;

Function TRecipes.ImportXMLs(FN : TStrings; DN : string; Equip : TEquipment) : boolean;
var SL : TStringList;
    i : integer;
    mask : string;
    ps : TProgressBar;
begin
  Result:= false;
  if DN <> '' then
  begin
    try
      Screen.Cursor:= crHourglass;
      {$ifdef WINDOWS}
        mask:= '*.xml';
      {$else}
        mask:= '*xml';
      {$endif}
      SL:= FindAllFiles(DN, mask, false);
{      FrmMain.sbMain.Panels[0].Text:= 'Importeren...';
      ps:= TProgressBar.Create(FrmMain.sbMain);
      ps.Parent:= FrmMain.sbMain;
      ps.Left:= FrmMain.sbMain.Panels[0].Width + 1;
      ps.Width:= FrmMain.sbMain.Panels[1].Width;
      ps.Min:= 0;
      ps.Max:= SL.Count - 1;
      ps.Position:= 0;}
      for i:= 0 to SL.Count - 1 do
      begin
        ImportXML(SL[i], Equip);
//        ps.Position:= i;
        Application.ProcessMessages;
      end;
      Result:= TRUE;
    finally
      Screen.Cursor:= crDefault;
//      ps.Free;
      SL.Free;
//      FrmMain.sbMain.Panels[0].Text:= '';
      ShowMessage('Importeren klaar');
    end;
  end
  else
  begin
    for i:= 0 to FN.Count - 1 do
    begin
      Result:= ImportXML(FN[i], Equip);
    end;
  end;
end;

Function TRecipes.GetMaxAutoNr : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FCollection) to High(FCollection) do
    if TRecipe(FCollection[i]).AutoNr.Value > Result then
      Result:= TRecipe(FCollection[i]).AutoNr.Value;
end;

Function TRecipes.ImportXML(FN : string; Equip : TEquipment) : boolean;
var R : TRecipe;
    s : string;
begin
  Result:= false;
  FDoc := TXMLDocument.Create;
  FRootNode:= NIL;
  try
    if FileExists(FN) then
    begin
      ReadXMLFile(FDoc, FN);
      s:= ExtractFileNameOnly(FN);
      FRootNode:= FDoc.FindNode(FLabel);
      if FRootNode <> NIL then
      begin
        FChild:= FRootNode.FirstChild;
        while FChild <> NIL do
        begin
          R:= AddItem;
          Application.ProcessMessages;
          R.ReadXML(FChild);
          R.AutoNr.Value:= GetMaxAutoNr + 1;
          R.ParentAutoNr.Value:= '';

          CheckBeerStyle(R);
          CheckFermentables(R);
          CheckYeasts(R);

          //change the equipment
          if Equip <> NIL then R.ChangeEquipment(Equip)
          else R.RemoveNonBrewsData;

          if FFileName = 'brews.xml' then R.RecType:= rtBrew
          else if FFileName = 'recipes.xml' then R.RecType:= rtRecipe
          else R.RecType:= rtCloud;

          FChild:= FChild.NextSibling;
          Result:= TRUE;
        end;
      end;
    end;
  finally
    FDoc.Free;
  end;
end;

Function TRecipes.ImportRECs(FN : TStrings; DN : string; Equip : TEquipment) : boolean;
var SL : TStringList;
    i : integer;
    mask : string;
    ps : TProgressBar;
begin
  Result:= false;
  if DN <> '' then
  begin
    try
      Screen.Cursor:= crHourglass;
      {$ifdef WINDOWS}
        mask:= '*.rec';
      {$else}
        mask:= '*rec';
      {$endif}
      SL:= FindAllFiles(DN, mask, false);
{      FrmMain.sbMain.Panels[0].Text:= 'Importeren...';
      ps:= TProgressBar.Create(FrmMain.sbMain);
      ps.Parent:= FrmMain.sbMain;
      ps.Left:= FrmMain.sbMain.Panels[0].Width + 1;
      ps.Width:= FrmMain.sbMain.Panels[1].Width;
      ps.Min:= 0;
      ps.Max:= SL.Count - 1;
      ps.Position:= 0;}
      for i:= 0 to SL.Count - 1 do
      begin
        ImportREC(SL[i], Equip);
//        ps.Position:= i;
        Application.ProcessMessages;
      end;
      Result:= TRUE;
    finally
      Screen.Cursor:= crDefault;
//      ps.Free;
      SL.Free;
//      FrmMain.sbMain.Panels[0].Text:= '';
      ShowMessage('Importeren klaar');
    end;
  end
  else
  for i:= 0 to FN.Count - 1 do
  begin
    Result:= ImportREC(FN[i], Equip);
  end;
end;

Function TRecipes.ImportREC(FN : string; Equip : TEquipment) : boolean;
//var PI : TPromash;
//    R : TRecipe;
//    s : string;
begin
//  Result:= false;
//  PI := TPromash.Create(FrmMain);
//  try
//    FN:= ConvertStringEnc(FN);
//    if FileExists(FN) then
//    begin
//      if PI.OpenReadRec(FN) then
//      begin
//       R:= AddItem;
//       if R <> NIL then
//       begin
//         PI.Convert(R);
//         s:= R.Style.Name.Value;
//         R.AutoNr.Value:= MaxAutoNr + 1;
//
//         CheckBeerStyle(R);
//         CheckFermentables(R);
//         CheckYeasts(R);
//
//         //change the equipment
//         if Equip <> NIL then
//           R.ChangeEquipment(Equip);
//
//         if FFileName = 'brews.xml' then R.RecType:= rtBrew
//         else if FFileName = 'recipes.xml' then R.RecType:= rtRecipe
//         else R.RecType:= rtCloud;
//
//         Result:= TRUE;
//       end;
//      end;
//    end;
//  finally
//    PI.Free;
//  end;
end;

Procedure TRecipes.QuickSortRecipes(var Arr : array of TBase);
  procedure QuickSort(var A: array of TBase; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      s : string;
      T : TRecipe;
  begin
    Lo := iLo;
    Hi := iHi;
    s:= TRecipe(A[(Lo + Hi) div 2]).NrRecipe.Value;
    repeat
      while TRecipe(A[Lo]).NrRecipe.Value < s do Inc(Lo);
      while TRecipe(A[Hi]).NrRecipe.Value > s do Dec(Hi);
      if Lo <= Hi then
      begin
        T := TRecipe(A[Lo]);
        TRecipe(A[Lo]) := TRecipe(A[Hi]);
        TRecipe(A[Hi]) := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(Arr) > -1 then QuickSort(Arr, Low(Arr), High(Arr));
end;

Procedure TRecipes.Sort;
begin
  QuickSortRecipes(FCollection);
end;

Function TRecipes.GetLastNrRecipe : string;
begin
  Sort;
  Result:= '';
  if High(FCollection) >= 0 then
    Result:= TRecipe(FCollection[High(FCollection)]).NrRecipe.Value;
end;

Function TRecipes.GetSelectedItem : TRecipe;
begin
  Result:= NIL;
  if FSelected > -1 then
    Result:= TRecipe(FCollection[FSelected]);
end;

Function TRecipes.AddItem : TRecipe;
begin
  Result:= NIL;
  try
    SetLength(FCollection, High(FCollection)+2);
    FSelected:= High(FCollection);
    FCollection[High(FCollection)]:= TRecipe.Create(NIL);
    Result:= TRecipe(FCollection[High(FCollection)]);
  finally
  end;
end;

Procedure TRecipes.InsertItem(i : integer);
var R : TRecipe;
begin
  Inherited;
  if (i >= Low(FCollection)) and (i <= High(FCollection)) then
  begin
    FCollection[i]:= TRecipe.Create(NIL);
    R:= TRecipe(FCollection[i]);
    if FFileName = 'brews.xml' then R.RecType:= rtBrew
    else if FFileName = 'recipes.xml' then R.RecType:= rtRecipe
    else R.RecType:= rtCloud;
  end;
end;

Function TRecipes.ExportToCSV(A : array of longint) : boolean;
var i, j : integer;
    dlg : TSaveDialog;
    SL : TStringList;
    line : string;
    R : TRecipe;
begin
  Result:= false;
  dlg:= TSaveDialog.Create(frmMain);
  if High(FCollection) > 0 then
    try
      SL:= TStringList.Create;
      SL.Sorted:= false;
      with dlg do
      begin
        DefaultExt:= '.csv';
        FileName:= '*.csv';
        Filter:= 'Comma separated values|*.csv';
        if dlg.Execute then
        begin
          R:= TRecipe(FCollection[0]);
          Line:= 'Code;Nr;Naam;Gist naam;';
          for j:= Low(A) to High(A) do
          begin
            line:= line + R.GetNumberNameByIndex(A[j]);
            if j < High(A) then line:= line + ';';
          end;
          SL.Add(line);
          for i:= Low(FCollection) to High(FCollection) do
          begin
            line:= '';
            R:= TRecipe(FCollection[i]);
            line:= R.NrRecipe.Value + ';';
            line:= line + R.Name.Value + ';';
            line:= line + R.Yeast[0].Name.Value + ';';
            for j:= Low(A) to High(A) do
            begin
              line:= line + VarToStr(R.GetNumberByIndex(A[j]));
              if j < High(A) then line:= line + ';';
            end;
            SL.Add(line);
          end;
          SL.SaveToFile(dlg.FileName);
        end;
      end;
      Result:= TRUE;
    finally
      dlg.Free;
      SL.Free;
    end;
end;

Procedure TRecipes.QuickSortA(var Arr : array of TMinMax);
  procedure QuickSort(var A: array of TMinMax; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      s : single;
      T : TMinMax;
  begin
    Lo := iLo;
    Hi := iHi;
    s:= A[(Lo + Hi) div 2].PercRecipes;
    repeat
      while A[Lo].PercRecipes > s do Inc(Lo);
      while A[Hi].PercRecipes < s do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(Arr) > -1 then QuickSort(Arr, Low(Arr), High(Arr));
end;

Function TRecipes.Exists(Arr : TMinMaxArray; FName : string) : integer;
var n : integer;
begin
  Result:= -1;
  for n:= Low(Arr) to High(Arr) do
    if Arr[n].Name = FName then
    begin
      Result:= n;
      Exit;
    end;
end;

Function TRecipes.AnalyseFermentables(Lett, Nm : string) : integer; //returns number of recipes
var i, j, k : integer;
    R : TRecipe;
    F : TFermentable;
    FN : string;
begin
  Result:= 0;
  SetLength(FFermentablesMinMaxArray, 0);
  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.Style <> NIL) and
       ((LowerCase(R.Style.StyleLetter.Value) = LowerCase(Lett)) and
        (Lowercase(R.Style.Name.Value) = Lowercase(Nm))) then
    begin
      Inc(Result);
      R.CalcOG;
      for j:= 0 to R.NumFermentables - 1 do
      begin
        F:= R.Fermentable[j];
        FN:= F.Name.Value;
        k:= Exists(FFermentablesMinMaxArray, FN);
        if k = -1 then
        begin
          SetLength(FFermentablesMinMaxArray, High(FFermentablesMinMaxArray) + 2);
          k:= High(FFermentablesMinMaxArray);
          FFermentablesMinMaxArray[k].Name:= FN;
          FFermentablesMinMaxArray[k].PercRecipes:= 1;
          FFermentablesMinMaxArray[k].MinUse:= F.Percentage.Value;
          FFermentablesMinMaxArray[k].AvUse:= F.Percentage.Value;
          FFermentablesMinMaxArray[k].MaxUse:= F.Percentage.Value;
        end
        else
        begin
          //temporarily store the number of recipes with this ingredient in PercRecipes
          FFermentablesMinMaxArray[k].PercRecipes:= FFermentablesMinMaxArray[k].PercRecipes + 1;
          FFermentablesMinMaxArray[k].AvUse:= FFermentablesMinMaxArray[k].AvUse + F.Percentage.Value;
          if F.Percentage.Value < FFermentablesMinMaxArray[k].MinUse then
            FFermentablesMinMaxArray[k].MinUse:= F.Percentage.Value;
          if F.Percentage.Value > FFermentablesMinMaxArray[k].MaxUse then
            FFermentablesMinMaxArray[k].MaxUse:= F.Percentage.Value;
        end;
      end;
    end;
  end;
  if (High(FCollection) >= 0) then
  begin
    for i:= Low(FFermentablesMinMaxArray) to High(FFermentablesMinMaxArray) do
    begin
      if FFermentablesMinMaxArray[i].PercRecipes > 0 then
        FFermentablesMinMaxArray[i].AvUse:= FFermentablesMinMaxArray[i].AvUse / FFermentablesMinMaxArray[i].PercRecipes
      else
        FFermentablesMinMaxArray[i].AvUse:= 0;
      if Result > 0 then
        FFermentablesMinMaxArray[i].PercRecipes:= 100 * FFermentablesMinMaxArray[i].PercRecipes / Result
      else
        FFermentablesMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FFermentablesMinMaxArray);
  end;
end;

Function TRecipes.AnalyseHops(Lett, Nm : string) : integer; //returns number of recipes
type
  THR = record
    name : string;
    conc : double;
  end;
var i, j, k : integer;
    R : TRecipe;
    H : THop;
    FN : string;
    conc : double;
    HRAB, HRAA, HRAD : array of THR;
  function FindHR(var HRA : array of THR; nm : string) : integer;
  var n : integer;
  begin
    Result:= -1;
    for n:= Low(HRA) to High(HRA) do
      if HRA[n].name = nm then
      begin
        Result:= n;
        Exit;
      end;
  end;
  Procedure FillArrays(var MMA : TMinMaxArray; HRA : array of THR);
  var j : integer;
  begin
    for j:= 0 to High(HRA) do
    begin
      k:= Exists(MMA, HRA[j].Name);
      if k = -1 then
      begin
        SetLength(MMA, High(MMA) + 2);
        k:= High(MMA);
        MMA[k].Name:= HRA[j].Name;
        MMA[k].PercRecipes:= 1;
        MMA[k].MinUse:= HRA[j].Conc;
        MMA[k].AvUse:= MMA[k].MinUse;
        MMA[k].MaxUse:= MMA[k].MinUse;
      end
      else
      begin
        //temporarily store the number of recipes with this ingredient in PercRecipes
        MMA[k].PercRecipes:= MMA[k].PercRecipes + 1;
        MMA[k].AvUse:= MMA[k].AvUse + HRA[j].Conc;
        if HRA[j].Conc < MMA[k].MinUse then
          MMA[k].MinUse:= HRA[j].Conc;
        if HRA[j].Conc > MMA[k].MaxUse then
          MMA[k].MaxUse:= HRA[j].Conc;
      end;
    end;
  end;

begin
  Result:= 0;
  SetLength(FBitterhopMinMaxArray, 0);
  SetLength(FAromahopMinMaxArray, 0);
  SetLength(FDryhopMinMaxArray, 0);
  SetLength(HRAB, 0);
  SetLength(HRAA, 0);
  SetLength(HRAD, 0);
  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.Style <> NIL) and
       ((LowerCase(R.Style.StyleLetter.Value) = LowerCase(Lett)) and
        (Lowercase(R.Style.Name.Value) = Lowercase(Nm))) then
    begin
      Inc(Result);
      for j:= 0 to R.NumHops - 1 do
      begin
        H:= R.Hop[j];
        FN:= H.Name.Value;
        if (H.Use = huBoil) or (H.Use = huAroma) or (H.Use = huFirstWort)
           or (H.Use = huWhirlpool) then
        begin
          if H.Time.Value > 30 then
          begin
            conc:= H.BitternessContribution;
            k:=  FindHR(HRAB, FN);
            if k = -1 then
            begin
              SetLength(HRAB, High(HRAB) + 2);
              k:= High(HRAB);
              HRAB[k].Name:= FN;
              HRAB[k].Conc:= 0;
            end;
            HRAB[k].Conc:= HRAB[k].Conc + conc;
          end
          else if R.BatchSize.DisplayValue > 0 then
          begin
            Conc:= H.Amount.DisplayValue / R.BatchSize.DisplayValue;
            k:=  FindHR(HRAA, FN);
            if k = -1 then
            begin
              SetLength(HRAA, High(HRAA) + 2);
              k:= High(HRAA);
              HRAA[k].Name:= FN;
              HRAA[k].Conc:= 0;
            end;
            HRAA[k].Conc:= HRAA[k].Conc + conc;
          end;
        end
        else if H.Use = huDryhop then
        begin
          if R.BatchSize.DisplayValue > 0 then
          begin
            conc:= H.Amount.DisplayValue / R.BatchSize.DisplayValue;
            k:=  FindHR(HRAD, FN);
            if k = -1 then
            begin
              SetLength(HRAD, High(HRAD) + 2);
              k:= High(HRAD);
              HRAD[k].Name:= FN;
              HRAD[k].Conc:= 0;
            end;
            HRAD[k].Conc:= HRAD[k].Conc + conc;
          end;
        end;
      end;

      FillArrays(FBitterhopMinMaxArray, HRAB);
      FillArrays(FAromahopMinMaxArray, HRAA);
      FillArrays(FDryHopMinMaxArray, HRAD);
      SetLength(HRAB, 0);
      SetLength(HRAA, 0);
      SetLength(HRAD, 0);
    end;
  end;
  if (High(FCollection) >= 0) then
  begin
    for i:= Low(FBitterhopMinMaxArray) to High(FBitterhopMinMaxArray) do
    begin
      if FBitterhopMinMaxArray[i].PercRecipes > 0 then
        FBitterhopMinMaxArray[i].AvUse:= FBitterhopMinMaxArray[i].AvUse
                                         / FBitterhopMinMaxArray[i].PercRecipes
      else
        FBitterhopMinMaxArray[i].AvUse:= 0;
      if Result > 0 then
        FBitterhopMinMaxArray[i].PercRecipes:=
                            100 * FBitterhopMinMaxArray[i].PercRecipes / Result
      else
        FBitterhopMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FBitterhopMinMaxArray);

    for i:= Low(FAromahopMinMaxArray) to High(FAromahopMinMaxArray) do
    begin
      if FAromahopMinMaxArray[i].PercRecipes > 0 then
        FAromahopMinMaxArray[i].AvUse:= FAromahopMinMaxArray[i].AvUse
                                         / FAromahopMinMaxArray[i].PercRecipes
      else
        FAromahopMinMaxArray[i].AvUse:= 0;
      if Result > 0 then
        FAromahopMinMaxArray[i].PercRecipes:=
                            100 * FAromahopMinMaxArray[i].PercRecipes / Result
      else
        FAromahopMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FAromahopMinMaxArray);

    for i:= Low(FDryhopMinMaxArray) to High(FDryhopMinMaxArray) do
    begin
      if FDryhopMinMaxArray[i].PercRecipes > 0 then
        FDryhopMinMaxArray[i].AvUse:= FDryhopMinMaxArray[i].AvUse
                                         / FDryhopMinMaxArray[i].PercRecipes
      else
        FDryhopMinMaxArray[i].AvUse:= 0;
      if Result > 0 then
        FDryhopMinMaxArray[i].PercRecipes:=
                            100 * FDryhopMinMaxArray[i].PercRecipes / Result
      else
        FDryhopMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FDryhopMinMaxArray);
  end;
end;

Function TRecipes.AnalyseYeasts(Lett, Nm : string) : integer; //returns number of recipes
var i, j, k : integer;
    R : TRecipe;
    Y : TYeast;
    FN : string;
begin
  Result:= 0;
  if High(FYeastMinMaxArray) >= 0 then
    SetLength(FYeastMinMaxArray, 0);
  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.Style <> NIL) and
       ((LowerCase(R.Style.StyleLetter.Value) = LowerCase(Lett)) and
        (Lowercase(R.Style.Name.Value) = Lowercase(Nm))) then
    begin
      Inc(Result);
      for j:= 0 to R.NumYeasts - 1 do
      begin
        Y:= R.Yeast[j];
        FN:= Y.Name.Value;
        k:= Exists(FYeastMinMaxArray, FN);
        if k = -1 then
        begin
          SetLength(FYeastMinMaxArray, High(FYeastMinMaxArray) + 2);
          k:= High(FYeastMinMaxArray);
          FYeastMinMaxArray[k].Name:= FN;
          FYeastMinMaxArray[k].PercRecipes:= 1;
          {FYeastMinMaxArray[k].MinUse:= F.Percentage.Value;
          FYeastMinMaxArray[k].AvUse:= F.Percentage.Value;
          FYeastMinMaxArray[k].MaxUse:= F.Percentage.Value;}
        end
        else
        begin
          //temporarily store the number of recipes with this ingredient in PercRecipes
          FYeastMinMaxArray[k].PercRecipes:= FYeastMinMaxArray[k].PercRecipes + 1;
          {FYeastMinMaxArray[k].AvUse:= FYeastMinMaxArray[k].AvUse + F.Percentage.Value;
          if F.Percentage.Value < FYeastMinMaxArray[k].MinUse then
            FYeastMinMaxArray[k].MinUse:= F.Percentage.Value;
          if F.Percentage.Value > FYeastMinMaxArray[k].MaxUse then
            FYeastMinMaxArray[k].MaxUse:= F.Percentage.Value;}
        end;
      end;
    end;
  end;
  if (High(FCollection) >= 0) then
  begin
    for i:= Low(FYeastMinMaxArray) to High(FYeastMinMaxArray) do
    begin
     { if FYeastMinMaxArray[i].PercRecipes > 0 then
        FYeastMinMaxArray[i].AvUse:= FYeastMinMaxArray[i].AvUse / FYeastMinMaxArray[i].PercRecipes
      else
        FYeastMinMaxArray[i].AvUse:= 0;}
      if Result > 0 then
        FYeastMinMaxArray[i].PercRecipes:= 100 * FYeastMinMaxArray[i].PercRecipes / Result
      else
        FYeastMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FYeastMinMaxArray);
  end;
end;

Function TRecipes.AnalyseMiscs(Lett, Nm : string) : integer; //returns number of recipes
var i, j, k : integer;
    R : TRecipe;
    M : TMisc;
    FN : string;
    conc : double;
begin
  Result:= 0;
  if High(FMiscMinMaxArray) >= 0 then
    SetLength(FMiscMinMaxArray, 0);
  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.Style <> NIL) and
       ((LowerCase(R.Style.StyleLetter.Value) = LowerCase(Lett)) and
        (Lowercase(R.Style.Name.Value) = Lowercase(Nm))) then
    begin
      Inc(Result);
      for j:= 0 to R.NumMiscs - 1 do
      begin
        M:= R.Misc[j];
        FN:= M.Name.Value;
        if ((M.MiscType = mtSpice) or (M.MiscType = mtHerb) or (M.MiscType = mtFlavor)
            or (M.MiscType = mtOther)) and (R.BatchSize.DisplayValue > 0) then
        begin
          conc:= M.Amount.DisplayValue / R.BatchSize.DisplayValue;
          k:= Exists(FMiscMinMaxArray, FN);
          if k = -1 then
          begin
            SetLength(FMiscMinMaxArray, High(FMiscMinMaxArray) + 2);
            k:= High(FMiscMinMaxArray);
            FMiscMinMaxArray[k].Name:= FN;
            FMiscMinMaxArray[k].PercRecipes:= 1;
            FMiscMinMaxArray[k].MinUse:= Conc;
            FMiscMinMaxArray[k].AvUse:= Conc;
            FMiscMinMaxArray[k].MaxUse:= Conc;
          end
          else
          begin
            //temporarily store the number of recipes with this ingredient in PercRecipes
            FMiscMinMaxArray[k].PercRecipes:= FMiscMinMaxArray[k].PercRecipes + 1;
            FMiscMinMaxArray[k].AvUse:= FMiscMinMaxArray[k].AvUse + Conc;
            if Conc < FMiscMinMaxArray[k].MinUse then
              FMiscMinMaxArray[k].MinUse:= Conc;
            if Conc > FMiscMinMaxArray[k].MaxUse then
              FMiscMinMaxArray[k].MaxUse:= Conc;
          end;
        end;
      end;
    end;
  end;
  if (High(FCollection) >= 0) then
  begin
    for i:= Low(FMiscMinMaxArray) to High(FMiscMinMaxArray) do
    begin
      if FMiscMinMaxArray[i].PercRecipes > 0 then
        FMiscMinMaxArray[i].AvUse:= FMiscMinMaxArray[i].AvUse / FMiscMinMaxArray[i].PercRecipes
      else
        FMiscMinMaxArray[i].AvUse:= 0;
      if Result > 0 then
        FMiscMinMaxArray[i].PercRecipes:= 100 * FMiscMinMaxArray[i].PercRecipes / Result
      else
        FMiscMinMaxArray[i].PercRecipes:= 0;
    end;
    QuickSortA(FMiscMinMaxArray);
  end;
end;

Function TRecipes.AnalyseRecipes(Lett, Nm : string) : integer; //returns number of recipes
var i, j : integer;
    R : TRecipe;
    SGp, bitt, x : double;
begin
  Result:= 0;
  SetLength(FCommonMinMaxArray, 0);
  SetLength(FCommonMinMaxArray, 3);
  for j:= 0 to High(FCommonMinMaxArray) do
  begin
    FCommonMinMaxArray[j].PercRecipes:= 0;
    FCommonMinMaxArray[j].MinUse:= 10000;
    FCommonMinMaxArray[j].AvUse:= 0;
    FCommonMinMaxArray[j].MaxUse:= 0;
    FCommonMinMaxArray[j].Name:= '';
  end;
  //0 = SG points
  FCommonMinMaxArray[0].Name:= 'SG punten';
  //1 = Bitterness
  FCommonMinMaxArray[1].Name:= 'Bitterheid (IBU)';
  //2 = Color
  FCommonMinMaxArray[2].Name:= 'Kleur (' + TRecipe(FCollection[0]).EstColor.DisplayUnitString + ')';
 { //3 = BitternessIndex
  FCommonMinMaxArray[3].Name:= 'Bitterheidsindex';}

  for i:= Low(FCollection) to High(FCollection) do
  begin
    R:= TRecipe(FCollection[i]);
    if (R.Style <> NIL) and
       ((LowerCase(R.Style.StyleLetter.Value) = LowerCase(Lett)) and
        (Lowercase(R.Style.Name.Value) = Lowercase(Nm))) then
    begin
      Inc(Result);

      R.CalcOG;
      if R.OG.Value > 1 then
        SGp:= 1000 * (R.OG.Value - 1)
      else
        SGp:= 1000 * (R.EstOG.Value - 1);
      FCommonMinMaxArray[0].AvUse:= FCommonMinMaxArray[0].AvUse + SGp;
      if SGp < FCommonMinMaxArray[0].MinUse then
        FCommonMinMaxArray[0].MinUse:= SGp;
      if SGp > FCommonMinMaxArray[0].MaxUse then
        FCommonMinMaxArray[0].MaxUse:= SGp;

      R.CalcBitterness;
      bitt:= R.IBUcalc.DisplayValue;
      FCommonMinMaxArray[1].AvUse:= FCommonMinMaxArray[1].AvUse + bitt;
      if bitt < FCommonMinMaxArray[1].MinUse then
        FCommonMinMaxArray[1].MinUse:= bitt;
      if bitt > FCommonMinMaxArray[1].MaxUse then
        FCommonMinMaxArray[1].MaxUse:= bitt;

{      if SGp > 0 then x:= bitt / SGp
      else x:= 0;
      FCommonMinMaxArray[2].AvUse:= FCommonMinMaxArray[2].AvUse + x;
      if x < FCommonMinMaxArray[2].MinUse then
        FCommonMinMaxArray[2].MinUse:= x;
      if x > FCommonMinMaxArray[2].MaxUse then
        FCommonMinMaxArray[2].MaxUse:= x;}

      R.CalcColor;
      x:= R.EstColor.DisplayValue;
      FCommonMinMaxArray[2].AvUse:= FCommonMinMaxArray[2].AvUse + x;
      if x < FCommonMinMaxArray[2].MinUse then
        FCommonMinMaxArray[2].MinUse:= x;
      if x > FCommonMinMaxArray[2].MaxUse then
        FCommonMinMaxArray[2].MaxUse:= x;
    end;
  end;
  if (High(FCollection) >= 0) then
  begin
    for i:= Low(FCommonMinMaxArray) to High(FCommonMinMaxArray) do
    begin
      if Result > 0 then
        FCommonMinMaxArray[i].AvUse:= FCommonMinMaxArray[i].AvUse / Result
      else
        FCommonMinMaxArray[i].AvUse:= 0;
    end;
  end;
end;
{============================= TRecipesByStyle ================================}

{   TStyleRec = record
    Name : string;
    Recipes : array of TRecipe;
  end;

  TStyleLetters = record
    Letter : string;
    Styles : array of TStyleRec;
  end;}

Constructor TRecipesByStyle.Create(R : TRecipes);
 begin
   Inherited Create;
   FCollection:= R;
   Fill;
   Sort;
 end;

Destructor TRecipesByStyle.Destroy;
begin
  Empty;
  Inherited;
end;

Procedure TRecipesByStyle.SaveXML;
var Doc : TXMLDocument;
    iRootNode : TDOMNode;
    n, s, i : integer;
begin
  try
    Doc := TXMLDocument.Create;
    iRootNode := Doc.CreateElement('RECIPES');
    Doc.Appendchild(iRootNode);

    for n:= Low(FStyleLetters) to High(FStyleLetters) do
    begin
      for s:= Low(FStyleLetters[n].Styles) to High(FStyleLetters[n].Styles) do
      begin
        for i:= Low(FStyleLetters[n].Styles[s].Recipes) to High(FStyleLetters[n].Styles[s].Recipes) do
          FStyleLetters[n].Styles[s].Recipes[i].SaveXML(Doc, iRootNode, false);
      end;
    end;

    writeXMLFile(Doc, Settings.DataLocation.Value + 'recipes.xml');
  finally
    Doc.Free;
  end;
end;

Procedure TRecipesByStyle.Fill;
var n, n2, s, s2, i, r : integer;
    Num, Stl : string;
    Rec : TRecipe;
begin
  Empty;
  for i:= 1 to FCollection.GetNumItems do
  begin
    Rec:= TRecipe(FCollection.Item[i-1]);
    Num:= Rec.Style.StyleLetter.Value;
    Stl:= Rec.Style.Name.Value;
    n:= GetLetterByName(Num);
    s:= GetStyleByName(Num, Stl);
    if n < 0 then //Style Number does not exist
    begin
      n2:= High(FStyleLetters) + 1;
      SetLength(FStyleLetters, n2 + 1);
      FStyleLetters[n2].Letter:= Num;
      SetLength(FStyleLetters[n2].Styles, 1);
      FStyleLetters[n2].Styles[0].Name:= Stl;
      SetLength(FStyleLetters[n2].Styles[0].Recipes, 1);
      FStyleLetters[n2].Styles[0].Recipes[0]:= Rec;
    end
    else if s < 0 then //Style does not exist
    begin
      s2:= High(FStyleLetters[n].Styles) + 1;
      SetLength(FStyleLetters[n].Styles, s2 + 1);
      FStyleLetters[n].Styles[s2].Name:= Stl;
      SetLength(FStyleLetters[n].Styles[s2].Recipes, 1);
      FStyleLetters[n].Styles[s2].Recipes[0]:= Rec;
    end
    else //Both exist
    begin
      r:= High(FStyleLetters[n].Styles[s].Recipes) + 1;
      SetLength(FStyleLetters[n].Styles[s].Recipes, r+1);
      FStyleLetters[n].Styles[s].Recipes[r]:= Rec;
    end;
  end;
end;

Procedure TRecipesByStyle.Empty;
var n, s, i : integer;
begin
  for n:= Low(FStyleLetters) to High(FStyleLetters) do
  begin
    for s:= Low(FStyleLetters[n].Styles) to High(FStyleLetters[n].Styles) do
    begin
      for i:= Low(FStyleLetters[n].Styles[s].Recipes) to High(FStyleLetters[n].Styles[s].Recipes) do
        FStyleLetters[n].Styles[s].Recipes[i]:= NIL;
      SetLength(FStyleLetters[n].Styles[s].Recipes, 0);
    end;
    SetLength(FStyleLetters[n].Styles, 0);
  end;
  SetLength(FStyleLetters, 0);
end;

Procedure TRecipesByStyle.QuickSortInStyles(var Arr : array of TRecipe);
  procedure QuickSort(var A: array of TRecipe; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      l : string;
      T : TRecipe;
  begin
    Lo := iLo;
    Hi := iHi;
    l:= A[(Lo + Hi) div 2].NrRecipe.Value;
    repeat
      while A[Lo].NrRecipe.Value < l do Inc(Lo);
      while A[Hi].NrRecipe.Value > l do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(Arr) > -1 then QuickSort(Arr, Low(Arr), High(Arr));
end;

Procedure TRecipesByStyle.QuickSortStyles(var Arr : array of TStyleRec);
  procedure QuickSort(var A: array of TStyleRec; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      s : string;
      T : TStyleRec;
  begin
    Lo := iLo;
    Hi := iHi;
    s:= A[(Lo + Hi) div 2].Name;
    repeat
      while A[Lo].Name < s do Inc(Lo);
      while A[Hi].Name > s do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(Arr) > -1 then QuickSort(Arr, Low(Arr), High(Arr));
end;

Procedure TRecipesByStyle.QuickSortLetters(var Arr : array of TStyleLetters);
  procedure QuickSort(var A: array of TStyleLetters; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      l : string;
      T : TStyleLetters;
  begin
    Lo := iLo;
    Hi := iHi;
    l := A[(Lo + Hi) div 2].Letter;
    repeat
      while A[Lo].Letter < l do Inc(Lo);
      while A[Hi].Letter > l do Dec(Hi);
      if Lo <= Hi then
      begin
        T := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := T;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;
begin
  if High(Arr) > -1 then QuickSort(Arr, Low(Arr), High(Arr));
end;

Procedure TRecipesByStyle.Sort;
var n, s : integer;
begin
//sort recipes in every style by recipe number
  for n:= Low(FStyleLetters) to High(FStyleLetters) do
    for s:= Low(FStyleLetters[n].Styles) to High(FStyleLetters[n].Styles) do
      QuickSortInStyles(FStyleLetters[n].Styles[s].Recipes);

//sort style names
  for n:= Low(FStyleLetters) to High(FStyleLetters) do
    QuickSortStyles(FStyleLetters[n].Styles);
//sort style letters
  QuickSortLetters(FStyleLetters);
end;

Function TRecipesByStyle.GetLetterByName(Num : string) : integer;
var n : integer;
begin
  Result:= -1;
  for n:= Low(FStyleLetters) to High(FStyleLetters) do
    if FStyleLetters[n].Letter = Num then
    begin
      Result:= n;
      Exit;
    end;
end;

Function TRecipesByStyle.GetStyleByName(Num, Stl : string) : integer;
var n, s : integer;
begin
  Result:= -1;
  n:= GetLetterByName(Num);
  if n > -1 then
  begin
    for s:= Low(FStyleLetters[n].Styles) to High(FStyleLetters[n].Styles) do
      if FStyleLetters[n].Styles[s].Name = Stl then
      begin
        Result:= s;
        Exit;
      end;
  end;
end;

Function TRecipesByStyle.GetNumStyleLetters : integer;
begin
  Result:= High(FStyleLetters) + 1;
end;

Function TRecipesByStyle.GetNumStyles(i : integer) : integer;
begin
  Result:= -1;
  if (i >= Low(FStyleLetters)) and (i <= High(FStyleLetters)) then
    Result:= High(FStyleLetters[i].Styles) + 1;
end;

Function TRecipesByStyle.GetStyleLetter(i : integer) : string;
begin
  Result:= '';
  if (i >= Low(FStyleLetters)) and (i <= High(FStyleLetters)) then
    Result:= FStyleLetters[i].Letter;
end;

Function TRecipesByStyle.GetStyleName(n : integer; s : integer) : string;
begin
  Result:= '';
  if (n >= Low(FStyleLetters)) and (n <= High(FStyleLetters)) then
    if (s >= Low(FStyleLetters[n].Styles)) and (s <= High(FStyleLetters[n].Styles)) then
      Result:= FStyleLetters[n].Styles[s].Name;
end;

Function TRecipesByStyle.GetNumRecipes(n : integer; s : integer) : integer;
begin
  Result:= -1;
  if (n >= Low(FStyleLetters)) and (n <= High(FStyleLetters)) then
    if (s >= Low(FStyleLetters[n].Styles)) and (s <= High(FStyleLetters[n].Styles)) then
      Result:= High(FStyleLetters[n].Styles[s].Recipes) + 1;
end;

Function TRecipesByStyle.GetRecipe(n : integer; s : integer; i : integer) : TRecipe;
begin
  Result:= NIL;
  if (n >= Low(FStyleLetters)) and (n <= High(FStyleLetters)) then
    if (s >= Low(FStyleLetters[n].Styles)) and (s <= High(FStyleLetters[n].Styles)) then
      if (i >= Low(FStyleLetters[n].Styles[s].Recipes)) and (i <= High(FStyleLetters[n].Styles[s].Recipes)) then
        Result:= FStyleLetters[n].Styles[s].Recipes[i];
end;

{============================= System functions ===============================}

Procedure CheckBeerStyle(Rec : TRecipe);
var s : string;
    OK : boolean;
    BS : TBeerStyle;
begin
//check if beerstyle exist in the database.
//If not, check the substitution database, otherwise ask for an alternative
  s:= '';
  if Rec.Style <> NIL then
    s:= Rec.Style.Name.Value;
  if Beerstyles.FindByName(s) = NIL then
  begin
    //first, look for subtitute in the substitutions database
    OK:= StyleSubs.OriginalExists(s);
    if OK then
    begin
      s:= StyleSubs.FindSubstitute(s);
      BS:= TBeerStyle(BeerStyles.FindByName(s));
      OK:= (BS <> NIL);
      if not OK then
        StyleSubs.RemoveOriginal(s);
    end;
    if OK then
      Rec.Style.Assign(BS)
    else
    begin
      FrmSelectBeerStyle:= TFrmSelectBeerStyle.Create(FrmMain);
      if FrmSelectBeerStyle.Execute(s) then
      begin
        //put style replacement in the substitutions database
        if (not StyleSubs.OriginalExists(s)) then
          StyleSubs.Add(s, FrmSelectBeerStyle.BeerStyle.Name.Value);
        Rec.Style.Assign(FrmSelectBeerStyle.BeerStyle);
      end;
      FrmSelectBeerStyle.Free;
    end;
  end;
end;

Procedure CheckFermentables(Rec : TRecipe);
var s, s2 : string;
    OK : boolean;
    i : integer;
    F : TFermentable;
    am, perc, yield, color, CoarseFineDiff, moisture, DiastaticPower, Protein,
    DissolvedProtein, IbuGalPerLb: double;
begin
//check if fermentable exist in the database.
//If not, check the substitution database, otherwise ask for an alternative
  for i:= 0 to Rec.NumFermentables - 1 do
  begin
    s:= Rec.Fermentable[i].Name.Value;
    s2:= Rec.Fermentable[i].Supplier.Value;
    OK:= (Fermentables.FindByNameAndSupplier(s, s2) <> NIL);
    if (not OK) then
    begin
      OK:= FermentableSubs.OriginalExists(s, s2);
      if OK then
      begin
        FermentableSubs.FindSubstitute(s, s2, s, s2);
        F:= TFermentable(Fermentables.FindByNameAndSupplier(s, s2));
        if F <> NIL then
        begin
          am:= Rec.Fermentable[i].Amount.Value;
          perc:= Rec.Fermentable[i].Percentage.Value;
          Yield:= Rec.Fermentable[i].Yield.Value;
          Color:= Rec.Fermentable[i].Color.Value;
          CoarseFineDiff:= Rec.Fermentable[i].CoarseFineDiff.Value;
          Moisture:= Rec.Fermentable[i].Moisture.Value;
          DiastaticPower:= Rec.Fermentable[i].DiastaticPower.Value;
          Protein:= Rec.Fermentable[i].Protein.Value;
          DissolvedProtein:= Rec.Fermentable[i].DissolvedProtein.Value;
          IbuGalPerLb:= Rec.Fermentable[i].IbuGalPerLb.Value;

          Rec.Fermentable[i].Assign(F);
          Rec.Fermentable[i].Amount.Value:= am;
          Rec.Fermentable[i].Percentage.Value:= perc;
          Rec.Fermentable[i].Yield.Value:= Yield;
          Rec.Fermentable[i].Color.Value:= Color;
          Rec.Fermentable[i].CoarseFineDiff.Value:= CoarseFineDiff;
          Rec.Fermentable[i].Moisture.Value:= Moisture;
          Rec.Fermentable[i].DiastaticPower.Value:= DiastaticPower;
          Rec.Fermentable[i].Protein.Value:= Protein;
          Rec.Fermentable[i].DissolvedProtein.Value:= DissolvedProtein;
          Rec.Fermentable[i].IbuGalPerLb.Value:= IbuGalPerLb;
        end
        else
          FermentableSubs.RemoveOriginal(s, s2);
      end;
    end;
  end;
end;

Procedure CheckYeasts(Rec : TRecipe);
var s, s2 : string;
    OK : boolean;
    i : integer;
    Y : TYeast;
    am : double;
begin
//check if beerstyle exist in the database.
//If not, check the substitution database, otherwise ask for an alternative
  for i:= 0 to Rec.NumYeasts - 1 do
  begin
    s:= Rec.Yeast[i].Name.Value;
    s2:= Rec.Yeast[i].Laboratory.Value;
    OK:= (Yeasts.FindByNameAndLaboratory(s, s2) <> NIL);
    if (not OK) then
    begin
      OK:= YeastSubs.OriginalExists(s, s2);
      if OK then
      begin
        YeastSubs.FindSubstitute(s, s2, s, s2);
        Y:= TYeast(Yeasts.FindByNameAndLaboratory(s, s2));
        if Y <> NIL then
        begin
          am:= Rec.Yeast[i].Amount.Value;
          Rec.Yeast[i].Assign(Y);
          Rec.Yeast[i].Amount.Value:= am;
        end
        else
          YeastSubs.RemoveOriginal(s, s2);
      end;
    end;
  end;
end;

Procedure Backup;
  function CheckCopyFile(sd, dd, fn : string) : boolean;
  begin
    Result:= false;
    if FileExists(sd + fn) then
      result:= CopyFile(sd + fn, dd + fn);
  end;
var sourcedata, destdata : string;
    year, month, day : word;
    i : integer;
    SearchResult : TSearchRec;
    SL : TStringList;
begin
  sourcedata:= Settings.DataLocation.Value;
  DecodeDate(now, year, month, day);
  destdata:= BHFolder + 'backup-' + IntToStr(Year) + '-' + IntToStr(Month) + '-'
             + IntToStr(day) + Slash;
  CreateDir(destdata);
  CheckCopyFile(sourcedata, destdata, 'settings.xml');
  CheckCopyFile(sourcedata, destdata, 'fermentables.xml');
  CheckCopyFile(sourcedata, destdata, 'hops.xml');
  CheckCopyFile(sourcedata, destdata, 'yeasts.xml');
  CheckCopyFile(sourcedata, destdata, 'miscs.xml');
  CheckCopyFile(sourcedata, destdata, 'mashs.xml');
  CheckCopyFile(sourcedata, destdata, 'waters.xml');
  CheckCopyFile(sourcedata, destdata, 'styles.xml');
  CheckCopyFile(sourcedata, destdata, 'equipments.xml');
  CheckCopyFile(sourcedata, destdata, 'recipes.xml');
  CheckCopyFile(sourcedata, destdata, 'brews.xml');
  CheckCopyFile(sourcedata, destdata, 'cloud.xml');
  CheckCopyFile(sourcedata, destdata, 'stylesubs.xml');
  CheckCopyFile(sourcedata, destdata, 'fermentablesubs.xml');
  CheckCopyFile(sourcedata, destdata, 'yeastsubs.xml');
  CheckCopyFile(sourcedata, destdata, 'neuralnetworks.xml');
  SL:= FindAllFiles(sourcedata, '*.nn', false);
  for i:= 0 to SL.Count - 1 do
    CheckCopyFile(sourcedata, destdata, ExtractFileName(SL.Strings[i]));
  FreeAndNIL(SL);
  //  CheckCopyFile(sourcedata, destdata, 'styles-BJCP.xml');
  //  CheckCopyFile(sourcedata, destdata, 'White Labs.xml');
  CheckCopyFile(sourcedata, destdata, 'logo.png');
end;

Procedure Restore(sourcedata : string);
  function CheckCopyFile(sd, dd, fn : string) : boolean;
  begin
    Result:= false;
    if FileExists(sd + fn) then
      result:= CopyFile(sd + fn, dd + fn);
  end;
var destdata : string;
    year, month, day : word;
    i : integer;
    SL : TStringList;
begin
  destdata:= Settings.DataLocation.Value;
  if not DirectoryExists(destdata) then CreateDir(destdata);
  CheckCopyFile(sourcedata, destdata, 'settings.xml');
  CheckCopyFile(sourcedata, destdata, 'fermentables.xml');
  CheckCopyFile(sourcedata, destdata, 'hops.xml');
  CheckCopyFile(sourcedata, destdata, 'yeasts.xml');
  CheckCopyFile(sourcedata, destdata, 'miscs.xml');
  CheckCopyFile(sourcedata, destdata, 'mashs.xml');
  CheckCopyFile(sourcedata, destdata, 'waters.xml');
  CheckCopyFile(sourcedata, destdata, 'styles.xml');
  CheckCopyFile(sourcedata, destdata, 'equipments.xml');
  CheckCopyFile(sourcedata, destdata, 'recipes.xml');
  CheckCopyFile(sourcedata, destdata, 'brews.xml');
  CheckCopyFile(sourcedata, destdata, 'cloud.xml');
  CheckCopyFile(sourcedata, destdata, 'stylesubs.xml');
  CheckCopyFile(sourcedata, destdata, 'fermentablesubs.xml');
  CheckCopyFile(sourcedata, destdata, 'yeastsubs.xml');
  CheckCopyFile(sourcedata, destdata, 'neuralnetworks.xml');
  SL:= FindAllFiles(sourcedata, '*.nn', false);
  for i:= 0 to SL.Count - 1 do
    CheckCopyFile(sourcedata, destdata, ExtractFileName(SL.Strings[i]));
  FreeAndNIL(SL);

//  CheckCopyFile(sourcedata, destdata, 'styles-BJCP.xml');
//  CheckCopyFile(sourcedata, destdata, 'White Labs.xml');
  CheckCopyFile(sourcedata, destdata, 'logo.png');

  Fermentables.ReadXML;
  Hops.ReadXML;
  Miscs.ReadXML;
  Yeasts.ReadXML;
  Waters.ReadXML;
  Equipments.ReadXML;
  Beerstyles.ReadXML;
  Mashs.ReadXML;
  Application.ProcessMessages;
  Recipes.ReadXML;
  Application.ProcessMessages;
  Brews.ReadXML;
end;

Procedure CheckDataFolder;
  function CheckFile(sd, dd, fn : string) : boolean;
  var destOK, sourceOK : boolean;
  begin
    Result:= false;
    destOK:= FileExists(dd + fn);
    sourceOK:= FileExists(sd + fn);
    if (not destOK) and (sourceOK) then // Source exists, destination doesn't
    try
      result:= CopyFile(sd + fn, dd + fn); // Copy source to destination
    except
      ShowMessage('Fout bij aanmaken ' + dd + fn + '.');
      Halt;
    end
    else if (not destOK) and (not sourceOK) then
      ShowMessage('Fout: ' + sd + fn + ' niet gevonden.');
  end;
var sourcedata, destdata, sourcesounds, destsounds : string;
begin
  {$ifdef UNIX}
    sourcedata:= '/usr/share/brewbuddy/';
  {$endif}
  {$ifdef darwin}
    sourcedata:= '/usr/share/brewbuddy/';
  {$endif}
  {$ifdef Windows}
    sourcedata:= ExtractFilePath(Application.ExeName) + 'brewbuddy\';
    if OnUSB then BHFolder:= DriveLetter + '\brewbuddy\brewbuddy\';
    log('Checkdatafolder: BHFolder = ' + BHFolder);
  {$endif}
  destdata:= BHFolder;
  if not DirectoryExists(BHFolder) then
    CreateDir(BHFolder);
  if not DirectoryExists(SoundFolder) then
    CreateDir(SoundFolder);
  sourcesounds:= sourcedata + 'sounds' + Slash;
  destsounds:= SoundFolder;
  Settings := TBSettings.Create;
  if CheckFile(sourcedata, destdata, 'settings.xml') then
  begin
    Settings.DataLocation.Value:= BHFolder;
  end
  else
    Settings.Read;
  log('Settings.Datalocation = ' + Settings.DataLocation.Value);

  IF OnUSB then
  begin
    Settings.DataLocation.Value:= BHFolder;
    destdata:= BHFolder;
  end
  else if (Settings.DataLocation.Value <> '') and (not OnUSB) then
    destdata:= Settings.DataLocation.Value
  else
    destdata:= BHFolder;
  log('Settings.Datalocation = ' + Settings.DataLocation.Value);
  if not DirectoryExists(destdata) then
    CreateDir(destdata);

  if CheckFile(sourcedata, destdata, 'equipments.xml') then
    ShowMessage('Data niet gevonden. Nieuwe databank wordt gemaakt.');
  CheckFile(sourcedata, destdata, 'fermentables.xml');
  CheckFile(sourcedata, destdata, 'hops.xml');
  CheckFile(sourcedata, destdata, 'mashs.xml');
  CheckFile(sourcedata, destdata, 'miscs.xml');
  CheckFile(sourcedata, destdata, 'recipes.xml');
  CheckFile(sourcedata, destdata, 'styles-BJCP.xml');
  CheckFile(sourcedata, destdata, 'styles.xml');
  CheckFile(sourcedata, destdata, 'waters.xml');
//  CheckFile(sourcedata, destdata, 'White Labs.xml');
  CheckFile(sourcedata, destdata, 'yeasts.xml');
  CheckFile(sourcedata, destdata, 'logo.png');
  {$ifdef Windows}
  //CheckFile(sourcedata, destdata, 'Introductie BrewBuddy Sassy Saison.pdf');
  {$endif}
  {$ifdef Darwin}
  CheckFile('/usr/share/doc/brewbuddy/', destdata, 'Introductie BrewBuddy Sassy Saison.pdf');
  {$endif}
  {$ifdef Unix}
  CheckFile('/usr/share/doc/brewbuddy/', destdata, 'Introductie BrewBuddy Sassy Saison.pdf');
  {$endif}
  CheckFile(sourcesounds, destsounds, 'alarm.wav');
//  CheckFile(sourcesounds, destsounds, 'alarm02.wav');
  CheckFile(sourcesounds, destsounds, 'end.wav');
  CheckFile(sourcesounds, destsounds, 'warning.wav');
  CheckFile(sourcesounds, destsounds, 'welcome.wav');
end;

Procedure Reload;
begin
  Fermentables.Free;
  Hops.Free;
  Miscs.Free;
  Yeasts.Free;
  Waters.Free;
  Equipments.Free;
  Beerstyles.Free;
  Mashs.Free;
  Recipes.Free;
  Brews.Free;
  Settings.Free;
  Settings := TBSettings.Create;
  Settings.Read;

  CheckDataFolder;

  Fermentables:= TFermentables.Create;
  Hops:= THops.Create;
  Miscs:= TMiscs.Create;
  Yeasts:= TYeasts.Create;
  Waters:= TWaters.Create;
  Equipments:= TEquipments.Create;
  Beerstyles:= TBeerstyles.Create;
  Mashs:= TMashs.Create;
  Recipes:= TRecipes.Create;

  Brews:= TRecipes.Create;
  Brews.FileName:= 'brews.xml';

  loc:= Settings.DataLocation.Value;
  if (loc = '') or OnUSB then loc:= BHFolder;
  if InitializeHD('fermentables.xml', loc) then
  begin
    Settings.DataLocation.Value:= loc;
    Fermentables.ReadXML;
    Hops.ReadXML;
    Miscs.ReadXML;
    Yeasts.ReadXML;
    Waters.ReadXML;
    Equipments.ReadXML;
    Beerstyles.ReadXML;
    Mashs.ReadXML;
    Application.ProcessMessages;
    Recipes.ReadXML;
    Recipes.CheckAutoNrs;
    Application.ProcessMessages;
    Brews.ReadXML;
    Brews.CheckAutoNrs;

    CheckSalts;
  end
  else
    ShowMessage('Databestanden niet gevonden');
end;

Procedure ChangeDatabaseLocation(source, destination : string; copy, deleteold : boolean);
  function CheckCopyFile(sd, dd, fn : string) : boolean;
  begin
    Result:= false;
    if FileExists(sd + fn) then
      result:= CopyFile(sd + fn, dd + fn);
  end;
var SearchResult : TSearchRec;
    i : integer;
    SL : TStringList;
    StylesN, FermN, HopN, MiscN, YeastN, WaterN, sourcedata : string;
begin
  {$ifdef UNIX}
    destination:= destination + '/';
  {$else}
    destination:= destination + '\';
  {$endif}
  Settings.DataLocation.Value:= destination;

  if not copy then
  begin
    StylesN:= destination + 'styles.xml';
    FermN:= destination + 'fermentables.xml';
    HopN:= destination + 'hops.xml';
    MiscN:= destination + 'miscs.xml';
    YeastN:= destination + 'yeasts.xml';
    WaterN:= destination + 'waters.xml';
    if FileExists(StylesN) and FileExists(FermN) and FileExists(HopN) and
       FileExists(MiscN) and FileExists(YeastN) and FileExists(WaterN) then
    begin
      Brews.ReadXML;
      Equipments.ReadXML;
      Fermentables.ReadXML;
      Hops.ReadXML;
      Mashs.ReadXML;
      Miscs.ReadXML;
      Recipes.ReadXML;
      Beerstyles.ReadXML;
      Waters.ReadXML;
      Yeasts.ReadXML;
      StyleSubs.ReadXML;
      FermentableSubs.ReadXML;
      YeastSubs.ReadXML;
//      BHNNs.ReadXML;
    end
    else //copy previous database to new location, but clear brews
    begin
      {$ifdef UNIX}
        sourcedata:= '/usr/share/brewbuddy/';
      {$endif}
      {$ifdef darwin}
        sourcedata:= '/usr/share/brewbuddy/';
      {$endif}
      {$ifdef Windows}
        sourcedata:= ExtractFilePath(Application.ExeName) + 'brewbuddy\';
        if OnUSB then BHFolder:= DriveLetter + '\brewbuddy\brewbuddy\'
        else BHFolder:= destination;
      {$endif}

      Equipments.SaveXML;
      Fermentables.SaveXML;
      Hops.SaveXML;
      Mashs.SaveXML;
      Miscs.SaveXML;
      Recipes.SaveXML;
      Beerstyles.SaveXML;
      Waters.SaveXML;
      Yeasts.SaveXML;
      StyleSubs.SaveXML;
      FermentableSubs.SaveXML;
      YeastSubs.SaveXML;
//      BHNNs.SaveXML;
      SL:= FindAllFiles(source, '*.nn', false);
      for i:= 0 to SL.Count - 1 do
        CheckCopyFile(source, destination, ExtractFileName(SL.Strings[i]));
      FreeAndNIL(SL);
      Brews.FreeCollection;
      CheckCopyFile(source, destination, 'Introductie BrewBuddy Sassy Saison.pdf');
      CheckCopyFile(source, destination, 'styles-BJCP.xml');
      CheckCopyFile(source, destination, 'logo.png');
      CheckDataFolder;
    end;

    //delete files in old directory
    if deleteold then
    begin
      DeleteFile(PChar(source + 'brews.xml'));
      DeleteFile(PChar(source + 'equipments.xml'));
      DeleteFile(PChar(source + 'fermentables.xml'));
      DeleteFile(PChar(source + 'hops.xml'));
      DeleteFile(PChar(source + 'mashs.xml'));
      DeleteFile(PChar(source + 'miscs.xml'));
      DeleteFile(PChar(source + 'recipes.xml'));
      DeleteFile(PChar(source + 'styles.xml'));
      DeleteFile(PChar(source + 'waters.xml'));
      DeleteFile(PChar(source + 'yeasts.xml'));
      DeleteFile(PChar(source + 'stylesubs.xml'));
      DeleteFile(PChar(source + 'fermentablesubs.xml'));
      DeleteFile(PChar(source + 'yeastsubs.xml'));
      DeleteFile(PChar(source + 'neuralnetworks.xml'));
      SL:= FindAllFiles(source, '*.nn', false);
      for i:= 0 to SL.Count - 1 do
        DeleteFile(PChar(SL.Strings[i]));
      FreeAndNIL(SL);
      DeleteFile(PChar(source + 'Introductie BrewBuddy Sassy Saison.pdf'));
      DeleteFile(PChar(source + 'styles-BJCP.xml'));
      DeleteFile(PChar(source + 'logo.png'));
    end;
    //FrmMain.cbBrewsSortChange(FrmMain);
    //FrmMain.cbRecipesSortChange(FrmMain);
  end
  else //copy from old directory and overwrite files in new directory
  begin
    Brews.SaveXML;
    Equipments.SaveXML;
    Fermentables.SaveXML;
    Hops.SaveXML;
    Mashs.SaveXML;
    Miscs.SaveXML;
    Recipes.SaveXML;
    Beerstyles.SaveXML;
    Waters.SaveXML;
    Yeasts.SaveXML;
    StyleSubs.SaveXML;
    FermentableSubs.SaveXML;
    YeastSubs.SaveXML;
//    BHNNs.SaveXML;
    SL:= FindAllFiles(source, '*.nn', false);
    for i:= 0 to SL.Count - 1 do
      CheckCopyFile(source, destination, ExtractFileName(SL.Strings[i]));
    FreeAndNIL(SL);

    //delete files in old directory
    if deleteold then
    begin
      DeleteFile(PChar(source + 'brews.xml'));
      DeleteFile(PChar(source + 'equipments.xml'));
      DeleteFile(PChar(source + 'fermentables.xml'));
      DeleteFile(PChar(source + 'hops.xml'));
      DeleteFile(PChar(source + 'mashs.xml'));
      DeleteFile(PChar(source + 'miscs.xml'));
      DeleteFile(PChar(source + 'recipes.xml'));
      DeleteFile(PChar(source + 'styles.xml'));
      DeleteFile(PChar(source + 'waters.xml'));
      DeleteFile(PChar(source + 'yeasts.xml'));
      DeleteFile(PChar(source + 'stylesubs.xml'));
      DeleteFile(PChar(source + 'fermentablesubs.xml'));
      DeleteFile(PChar(source + 'yeastsubs.xml'));
      DeleteFile(PChar(source + 'neuralnetworks.xml'));
      SL:= FindAllFiles(source, '*.nn', false);
      for i:= 0 to SL.Count - 1 do
        DeleteFile(PChar(SL.Strings[i]));
      FreeAndNIL(SL);
    end;
  end;
  Settings.Save;
end;

{====================== Initialization and Finalization =======================}

Initialization
  // JR: Initialize logging if DoLog is enabled
  if DoLog then slLog:= TStringList.Create
  else slLog:= NIL;
  Screen.Cursor:= crHourglass;

  ExecFolder:= Application.Location;
  log('ExecFolder = ' + ExecFolder);
  OnUSB:= false;
  {$ifdef UNIX}
    {DriveLetter:= LeftStr(ExecFolder, 6);
    if DriveLetter = '/media' then
    begin
      BHFolder:= ExecFolder;
    end
    else
    begin}
      BHFolder:= GetUserDir + '.brewbuddy/';
  //    DataFolder:= GetUserDir + '.brewbuddy/';
   { end;}
    SoundFolder:= BHFolder + 'sounds/';
    IconFolder:= BHFolder + 'icons/';
    Slash:= '/';
  {$endif}
  {$ifdef darwin}
    BHFolder:= GetUserDir + '.brewbuddy/';
//    DataFolder:= GetUserDir + '.brewbuddy/';
    SoundFolder:= BHFolder + 'sounds/';
  IconFolder:= BHFolder + 'icons/';
    Slash:= '/';
  {$endif}
  {$ifdef windows}
    DriveLetter:= LeftStr(ExecFolder, 2);
    if GetDriveType(PChar(DriveLetter)) = DRIVE_REMOVABLE then
    begin
      Log('Gestart van USB');
      BHFolder:= DriveLetter + '\brewbuddy\brewbuddy\';
      OnUSB:= TRUE;
    end
    else
    begin
      Log('Gestart van harddisk');
      BHFolder:= GetWindowsSpecialDir(CSIDL_PERSONAL); //GetUserDir
      if FileExists(BHFolder + 'My Documents\brewbuddy\settings.xml') then
        BHFolder:= BHFolder + 'My Documents\brewbuddy\'
      else
        BHFolder:= BHFolder + 'brewbuddy\';
    end;
    log('BHFolder = ' + BHFolder);
    SoundFolder:= BHFolder + 'sounds\';
    IconFolder:= BHFolder + 'icons\';
    Slash:= '\';
  {$endif}

  CheckDataFolder;  //settings are read here

  Fermentables:= TFermentables.Create;
  Hops:= THops.Create;
  Miscs:= TMiscs.Create;
  Yeasts:= TYeasts.Create;
  Waters:= TWaters.Create;
  Equipments:= TEquipments.Create;
  Beerstyles:= TBeerstyles.Create;
  Mashs:= TMashs.Create;
  Recipes:= TRecipes.Create;

  Brews:= TRecipes.Create;
  Brews.FileName:= 'brews.xml';

//  BHNNs:= TBHNNs.Create;

  loc:= Settings.DataLocation.Value;
  if loc = '' then loc:= BHFolder;
  if OnUSB then //datalocation is also on the USB
    loc:= BHFolder;
  if InitializeHD('fermentables.xml', loc) then
  begin
    if not OnUSB then Settings.DataLocation.Value:= loc;

//    BHCloud:= TBHCloud.Create;
//    BHCloud.ReadCloud;

    Fermentables.ReadXML;
    Hops.ReadXML;
    Miscs.ReadXML;
    Yeasts.ReadXML;
    Waters.ReadXML;
    Equipments.ReadXML;
    Beerstyles.ReadXML;
    Mashs.ReadXML;
    Application.ProcessMessages;
    Recipes.ReadXML;
    Recipes.CheckAutoNrs;
    Application.ProcessMessages;
    Brews.ReadXML;
    Brews.CheckAutoNrs;

    StyleSubs.ReadXML;
    FermentableSubs.ReadXML;
    YeastSubs.ReadXML;

    //BHNNs.ReadXML;

    CheckSalts;
  end
  else
    ShowMessage('Databestanden niet gevonden');
//  Equipments.CalcEfficiencyRegressionFactors;
//  Equipments.CalcAttenuationRegressionFactors;

 { SetLength(Arr, 8);
  Arr[0]:= 4;
  Arr[1]:= 56;
  Arr[2]:= 45;
  Arr[3]:= 19;
  Arr[4]:= 22;
  Arr[5]:= 23;
  Arr[6]:= 9;
  Arr[7]:= 11;
  Brews.ExportToCSV(Arr);
  SetLength(Arr, 0);}

  Screen.Cursor:= crDefault;

Finalization
  if OnUSB then
  begin
    Settings.DataLocation.Value:= '';
    Settings.Save;
  end;
  Log('');
////  Log('CONTAINERS');
//  FreeAndNIL(BHCloud);
////  Log('BHCloud afgesloten');
  StyleSubs.SaveXML;
//  Log('StyleSubs opgeslagen');
  FermentableSubs.SaveXML;
//  Log('FermentableSubs opgeslagen');
  YeastSubs.SaveXML;
//  Log('YeastSubs opgeslagen');
  FreeAndNIL(StyleSubs);
//  Log('StyleSubs afgesloten');
  FreeAndNIL(FermentableSubs);
//  Log('FermentableSubs afgesloten');
  FreeAndNIL(YeastSubs);
//  Log('YeastSubs afgesloten');
//
  FreeAndNIL(Fermentables);
//  Log('Fermentables afgesloten');
  FreeAndNIL(Hops);
//  Log('Hops afgesloten');
  FreeAndNIL(Miscs);
//  Log('Miscs afgesloten');
  FreeAndNIL(Yeasts);
//  Log('Yeasts afgesloten');
  FreeAndNIL(Waters);
//  Log('Waters afgesloten');
  FreeAndNIL(Equipments);
//  Log('Equipments afgesloten');
  FreeAndNIL(Beerstyles);
//  Log('Beerstyles afgesloten');
  FreeAndNIL(Mashs);
//  Log('Mashs afgesloten');
  FreeAndNIL(Recipes);
//  Log('Recipes afgesloten');
  FreeAndNIL(Brews);
////  Log('Brews afgesloten');
//  FreeAndNIL(BHNNs);
//  Log('BHNNs afgesloten');

  Settings.Save;
  Log('Settings opgeslagen');
  FreeAndNIL(Settings);
//  Log('Settings afgesloten');

  if DoLog then FreeAndNIL(slLog);
end.

