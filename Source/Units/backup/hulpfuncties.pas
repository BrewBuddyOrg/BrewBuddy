unit Hulpfuncties;

// temporarily removed the whole OpenAL sound library from the program for Linux since it causes weird floating point exceptions

interface
uses
  {$ifdef unix}clocale,{$endif} Classes, SysUtils, Variants, Math, Graphics,
  Forms, Dialogs, strutils, {frQuestion, frgetstring, frgetpasswd,}
  FrNotification //{$ifdef linux}, openal{$endif}
  {$ifdef windows}, MMsystem{$endif}, Process;

type
  TUnit = (milligram, gram, kilogram, milliliter, liter, hectoliter, IBU, EBC, SRM,
           SG, plato, brix, celcius, fahrenheit, minuut, uur, dag, week, ppm, volco2,
           abv, perc, euro, pH, pph, calgdeg, kPa, bar, lintner, windischkolbach,
           gpl, cal, pks, stks, depots, watt, lph, lpm, lpkg, meter, centimeter, meql, none);
  THopUse = (huMash, huFirstwort, huBoil, huAroma, huWhirlpool, huDryhop);
  THopType = (htBittering, htAroma, htBoth);
  THopForm = (hfPellet, hfPlug, hfLeaf);
  TFermentableType = (ftGrain, ftSugar, ftExtract, ftDryExtract, ftAdjunct);
  TGrainType = (gtBase, gtRoast, gtCrystal, gtKilned, gtSour, gtSpecial, gtNone);
  TAddedType = (atMash, atBoil, atFermentation, atLagering, atBottle);
  TYeastType = (ytLager, ytAle, ytWheat, ytWine, ytChampagne);
  TYeastForm = (yfLiquid, yfDry, yfSlant, yfCulture, yfFrozen, yfBottle);
  TFlocculation = (flLow, flMedium, flHigh, lfVeryHigh);
  TStarterType = (stSimple, stAerated, stStirred);
  TMiscType = (mtSpice, mtHerb, mtFlavor, mtFining, mtWaterAgent, mtNutrient, mtOther);
  TMiscUse = (muStarter, muMash, muBoil, muPrimary, muSecondary, muBottling);
  TStyleType = (stLager, stAle, stMead, stWheat, stMixed, stCider);
  TMashStepType = (mstInfusion, mstTemperature, mstDecoction);
  TRecipeType = (rtExtract, rtPartialMash, rtAllGrain);
  TIBUmethod = (imTinseth, imRager, imGaretz, imDaniels, imMosher, imNoonan);
  TColorMethod = (cmMorey, cmMosher, cmDaniels);
  TIngredientType = (itFermentable, itHop, itMisc, itYeast, itWater);
  TDataType = (dtFermentable, dtHop, dtMisc, dtYeast, dtWater, dtMash, dtEquipment,
               dtRecipe, dtStyle, dtMeasurements);
  TCoolingMethod = (cmEmpty, cmEmersion, cmCouterFlow, cmAuBainMarie, cmNatural);
  TAerationType = (atNone, atAir, atOxygen);
  TPrimingSugar = (psSaccharose, psGlucose, psHoney, psDME, psMolassis);
  TFileType = (ftPromash, ftXML, ftOther);
  TAcidType = (atLactic, atHydrochloric, atPhosphoric, atSulfuric);
  TBaseType = (btNaHCO3, btNa2CO3, btCaCO3, btCaOH2);

  TRecType = (rtRecipe, rtBrew, rtCloud);

  TSpecificHeat = record
    Material : string;
    SpecificHeat : double;
  end;

  TCellCoord = record
    Col : integer;
    Row : integer;
  end;

  TEndChar = set of char;

const
  UnitNames : array[TUnit] of string = ('mg', 'g', 'kg', 'ml', 'L', 'hl', 'IBU', 'EBC',
              '°L', 'SG', '°P', '°B', '°C', '°F', 'min.', 'uren', 'dagen',
              'weken', 'mg/L', 'vol.', 'vol.%', '%', '€', 'pH', '%/uur', 'cal/g.°C',
              'kPa', 'bar', '°Lintner', '°WK', 'g/L', 'kcal/L', 'pak(ken)',
              'stuks', 'depots', 'W', 'L/uur', 'L/min', 'L/KG',
              'm', 'cm', 'mEq/L', '');
  DefaultDecimals : array[TUnit] of word = (1, 1, 2, 1, 2, 1, 0, 0, 1, 3, 1, 1, 1, 0,
                                            0, 0, 0, 0, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1,
                                            1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0);
  DefaultIncrement : array[TUnit] of single = (1, 1, 0.5, 1, 0.5, 0.5, 1, 1, 1, 0.001, 0.5,
                                               0.5, 1, 1, 1, 1, 1, 1, 1, 1, 0.5, 1, 0.5,
                                               0.1, 0.5, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
                                               1, 1, 1, 1, 1, 1, 0.1, 0);
  DefaultMinValue : array[TUnit] of single = (0, 0, 0, 0, 0, 0, 0, 0, 0, 1.0, 0,
                                              0, 0, 32, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
                                              0, 0, 0, 1, 0, 0, 0, 0);
  DefaultMaxValue : array[TUnit] of single = (2000, 10000, 10000, 10000, 10000, 100000,
                                              200, 1000, 1000, 1.3, 50, 50, 110, 230,
                                              240, 480, 365, 52, 10000, 10000, 100, 100,
                                              100000, 14, 100, 100000, 100, 100, 10000,
                                              10000, 1000, 1000, 1000, 1000, 1000,
                                              10000, 100, 100, 10, 10000, 10000, 1000, 0);
  HopUseNames : array[THopUse] of string = ('Mash', 'First wort', 'Boil', 'Aroma', 'Whirlpool', 'Dry hop');
  HopUseDisplayNames : array[THopUse] of string = ('maischhop', 'first wort hop', 'koken', 'vlamuit', 'whirlpool', 'koudhop');
  HopTypeNames : array[THopType] of string = ('Bittering', 'Aroma', 'Both');
  HopTypeDisplayNames : array[THopType] of string = ('bitterhop', 'aromahop', 'beide');
  HopFormNames : array[THopForm] of string = ('Pellet', 'Plug', 'Leaf');
  HopFormDisplayNames : array[THopForm] of string = ('pellets', 'plugs', 'bellen');
  FermentableTypeNames : array[TFermentableType] of string = ('Grain', 'Sugar', 'Extract', 'Dry extract', 'Adjunct');
  FermentableTypeDisplayNames : array[TFermentableType] of string = ('mout', 'suiker', 'vloeibaar extract', 'droog extract', 'ongemout graan');
  GrainTypeNames : array[TGrainType] of string = ('Base', 'Roast', 'Crystal', 'Kilned', 'Sour malt', 'Special', 'No malt');
  GrainTypeDisplayNames : array[TGrainType] of string = ('basismout', 'geroosterde mout', 'cara- of crystalmout', 'geëeste mout', 'zuurmout', 'speciale mout', 'n.v.t.');
  AddedTypeNames : array[TAddedType] of string = ('Mash', 'Boil', 'Fermentation', 'Lagering', 'Bottle');
  AddedTypeDisplayNames : array[TAddedType] of string = ('maischen', 'koken', 'vergisten', 'nagisten/lageren', 'bottelen');
  YeastTypeNames : array[TYeastType] of string = ('Lager', 'Ale', 'Wheat', 'Wine', 'Champagne');
  YeastTypeDisplayNames : array[TYeastType] of string = ('ondergist', 'bovengist', 'weizengist', 'wijngist', 'champagnegist');
  YeastFormNames : array[TYeastForm] of string = ('Liquid', 'Dry', 'Slant', 'Culture', 'Frozen', 'Bottle');
  YeastFormDisplayNames : array[TYeastForm] of string = ('vloeibaar', 'droog', 'schuine buis', 'slurry', 'ingevroren', 'depot');
  FlocculationNames : array[TFlocculation] of string = ('Low', 'Medium', 'High', 'Very high');
  FlocculationDisplayNames : array[TFlocculation] of string = ('laag', 'medium', 'hoog', 'zeer hoog');
  StarterTypeNames : array[TStarterType] of string = ('Simple', 'Aerated', 'Stirred');
  StarterTypeDisplayNames : array[TStarterType] of string = ('simpel', 'belucht', 'geroerd');
  MiscTypeNames : array[TMiscType] of string = ('Spice', 'Herb', 'Flavor', 'Fining', 'Water agent', 'Yeast nutrient', 'Other');
  MiscTypeDisplayNames : array[TMiscType] of string = ('specerij', 'kruid', 'smaakstof', 'klaringsmiddel', 'brouwzout', 'gistvoeding', 'anders');
  MiscUseNames : array[TMiscUse] of string = ('Starter', 'Mash', 'Boil', 'Primary', 'Secondary', 'Bottling');
  MiscUseDisplayNames : array[TMiscUse] of string = ('starter', 'maischen', 'koken', 'hoofdvergisting', 'nagisting/lagering', 'bottelen');
  StyleTypeNames : array[TStyleType] of string = ('Lager', 'Ale', 'Mead', 'Wheat', 'Mixed', 'Cider');
  StyleTypeDisplayNames : array[TStyleType] of string = ('Ondergistend bier', 'Bovengistend bier', 'Mede', 'Tarwebier', 'Gemengd', 'Cider');
  MashStepTypeNames : array[TMashStepType] of string = ('Infusion', 'Temperature', 'Decoction');
  MashStepTypeDisplayNames : array[TMashStepType] of string = ('Infusie', 'Directe verwarming', 'Decoctie');
  RecipeTypeNames : array[TRecipeType] of string = ('Extract', 'Partial Mash', 'All Grain');
  RecipeTypeDisplayNames : array[TRecipeType] of string = ('Extract', 'Deelmaisch', 'Mout');
  IBUmethodNames : array[TIBUmethod] of string = ('Tinseth', 'Rager', 'Garetz', 'Daniels', 'Mosher', 'Noonan');
  IBUmethodDisplayNames : array[TIBUmethod] of string = ('Tinseth', 'Rager', 'Garetz', 'Daniels', 'Mosher', 'Noonan');
  ColorMethodNames : array[TColorMethod] of string = ('Morey', 'Mosher', 'Daniels');
  ColorMethodDisplayNames : array[TColorMethod] of string = ('Morey', 'Mosher', 'Daniels');
  IngredientTypeDisplayNames : array[TIngredientType] of string = ('Mout', 'Hop', 'Ov.', 'Gist', 'Water');
  CoolingMethodNames : array[TCoolingMethod] of string = ('-', 'Emersion chiller', 'Counterflow chiller', 'Au bain marie', 'Natural');
  CoolingMethodDisplayNames : array[TCoolingMethod] of string = ('-', 'Dompelkoeler', 'Tegenstroomkoeler', 'Au bain marie', 'Laten afkoelen');
  AerationTypeNames : array[TAerationType] of string = ('None', 'Air', 'Oxygen');
  AerationTypeDisplayNames : array[TAerationType] of string = ('Geen', 'Lucht', 'Zuurstof');
  PrimingSugarNames : array[TPrimingSugar] of string = ('Saccharose', 'Glucose or dextrose', 'Honey', 'DME', 'Molassis');
  PrimingSugarDisplayNames : array[TPrimingSugar] of string = ('Kristalsuiker', 'Glucose/dextrose', 'Honing', 'Moutextract', 'Melasse');
  PrimingSugarFactors : array[TPrimingSugar] of double = (1, 1.16, 1.28, 1.74, 3.83);
  FileTypeNames : array[TFileType] of string = ('Promash', 'XML', 'Other');
  FileTypeDisplayNames : array[TFileType] of string = ('Promash', 'XML', 'Anders');
  AcidTypeNames : array[TAcidType] of string = ('Lactic', 'Hydrochloric', 'Phosphoric', 'Sulfuric');
  AcidTypeDisplayNames : array[TAcidType] of string = ('Melkzuur', 'Zoutzuur', 'Fosforzuur', 'Zwavelzuur');
  BaseTypeNames : array[TBaseType] of string = ('Sodiumbicarbonate', 'Sodiumcarbonate', 'Calciumcarbonate', 'Calciumhydroxide');
  BaseTypeDisplayNames : array[TBaseType] of string = ('NaHCO3', 'Na2CO3', 'CaCO3', 'Ca(OH)2');


  SpecificHeatWater : double = 1.0; //cal/g.°C
  SpecificHeatMalt : double = 0.399; //cal/g.°C
  SlakingHeat : double = 10.318; //cal/g.°C
  MaltVolume : double = 0.87; //l/kg 0.688 VOLGENS INTERNETBRONNEN, GEMETEN 0.874 l/kg, na enige tijd maischen 0,715 l/kg
  ExpansionFactor : double = 1.04; //4% increase in water volume between 20 and 100°C
  SugarDensity : double = 1.611; //kg/l in solution
  WaterDensity20 : double = 0.9982; //kg/l at 20°C

  Months : array[1..12] of string = ('januari', 'februari', 'maart', 'april', 'mei',
                                     'juni', 'juli', 'augustus', 'september', 'oktober',
                                     'november', 'december');
  MonthsShort : array[1..12] of string = ('jan', 'feb', 'mrt', 'apr', 'mei',
                                          'jun', 'jul', 'aug', 'sep', 'okt',
                                          'nov', 'dec');

  SRMtoRGB : array[0..299, 0..3] of real = ((0.1, 250, 250, 210), (0.2, 250, 250, 204), (0.3, 250, 250, 199), (0.4, 250, 250, 193), (0.5, 250, 250, 188), (0.6, 250, 250, 182), (0.7, 250, 250, 177), (0.8, 250, 250, 171), (0.9, 250, 250, 166), (1, 250, 250, 160), (1.1, 250, 250, 155), (1.2, 250, 250, 149), (1.3, 250, 250, 144), (1.4, 250, 250, 138), (1.5, 250, 250, 133), (1.6, 250, 250, 127), (1.7, 250, 250, 122), (1.8, 250, 250, 116), (1.9, 250, 250, 111), (2, 250, 250, 105), (2.1, 250, 250, 100), (2.2, 250, 250, 94), (2.3, 250, 250, 89), (2.4, 250, 250, 83), (2.5, 250, 250, 78), (2.6, 249, 250, 72), (2.7, 248, 249, 67), (2.8, 247, 248, 61), (2.9, 246, 247, 56), (3, 245, 246, 50), (3.1, 244, 245, 45), (3.2, 243, 244, 45), (3.3, 242, 242, 45), (3.4, 241, 240, 46), (3.5, 240, 238, 46), (3.6, 239, 236, 46), (3.7, 238, 234, 46), (3.8, 237, 232, 47), (3.9, 236, 230, 47), (4, 235, 228, 47), (4.1, 234, 226, 47), (4.2, 233, 224, 48), (4.3, 232, 222, 48), (4.4, 231, 220, 48), (4.5, 230, 218, 48), (4.6, 229, 216, 49), (4.7, 228, 214, 49), (4.8, 227, 212, 49), (4.9, 226, 210, 49), (5, 225, 208, 50), (5.1, 224, 206, 50), (5.2, 223, 204, 50), (5.3, 222, 202, 50), (5.4, 221, 200, 51), (5.5, 220, 198, 51), (5.6, 219, 196, 51), (5.7, 218, 194, 51), (5.8, 217, 192, 52), (5.9, 216, 190, 52), (6, 215, 188, 52), (6.1, 214, 186, 52), (6.2, 213, 184, 53), (6.3, 212, 182, 53), (6.4, 211, 180, 53), (6.5, 210, 178, 53), (6.6, 209, 176, 54), (6.7, 208, 174, 54), (6.8, 207, 172, 54), (6.9, 206, 170, 54), (7, 205, 168, 55), (7.1, 204, 166, 55), (7.2, 203, 164, 55), (7.3, 202, 162, 55), (7.4, 201, 160, 56), (7.5, 200, 158, 56), (7.6, 200, 156, 56), (7.7, 199, 154, 56), (7.8, 199, 152, 56), (7.9, 198, 150, 56), (8, 198, 148, 56), (8.1, 197, 146, 56), (8.2, 197, 144, 56), (8.3, 196, 142, 56), (8.4, 196, 141, 56), (8.5, 195, 140, 56), (8.6, 195, 139, 56), (8.7, 194, 139, 56), (8.8, 194, 138, 56), (8.9, 193, 137, 56), (9, 193, 136, 56), (9.1, 192, 136, 56), (9.2, 192, 135, 56), (9.3, 192, 134, 56), (9.4, 192, 133, 56), (9.5, 192, 133, 56), (9.6, 192, 132, 56), (9.7, 192, 131, 56), (9.8, 192, 130, 56), (9.9, 192, 130, 56), (10, 192, 129, 56), (10.1, 192, 128, 56), (10.2, 192, 127, 56), (10.3, 192, 127, 56), (10.4, 192, 126, 56), (10.5, 192, 125, 56), (10.6, 192, 124, 56), (10.7, 192, 124, 56), (10.8, 192, 123, 56), (10.9, 192, 122, 56), (11, 192, 121, 56), (11.1, 192, 121, 56), (11.2, 192, 120, 56), (11.3, 192, 119, 56), (11.4, 192, 118, 56), (11.5, 192, 118, 56), (11.6, 192, 117, 56), (11.7, 192, 116, 56), (11.8, 192, 115, 56), (11.9, 192, 115, 56), (12, 192, 114, 56), (12.1, 192, 113, 56), (12.2, 192, 112, 56), (12.3, 192, 112, 56), (12.4, 192, 111, 56), (12.5, 192, 110, 56), (12.6, 192, 109, 56), (12.7, 192, 109, 56), (12.8, 192, 108, 56), (12.9, 191, 107, 56), (13, 190, 106, 56), (13.1, 189, 106, 56), (13.2, 188, 105, 56), (13.3, 187, 104, 56), (13.4, 186, 103, 56), (13.5, 185, 103, 56), (13.6, 184, 102, 56), (13.7, 183, 101, 56), (13.8, 182, 100, 56), (13.9, 181, 100, 56), (14, 180, 99, 56), (14.1, 179, 98, 56), (14.2, 178, 97, 56), (14.3, 177, 97, 56), (14.4, 175, 96, 55), (14.5, 174, 95, 55), (14.6, 172, 94, 55), (14.7, 171, 94, 55), (14.8, 169, 93, 54), (14.9, 168, 92, 54), (15, 167, 91, 54), (15.1, 165, 91, 54), (15.2, 164, 90, 53), (15.3, 162, 89, 53), (15.4, 161, 88, 53), (15.5, 159, 88, 53), (15.6, 158, 87, 52), (15.7, 157, 86, 52), (15.8, 155, 85, 52), (15.9, 154, 85, 52), (16, 152, 84, 51), (16.1, 151, 83, 51), (16.2, 149, 82, 51), (16.3, 148, 82, 51), (16.4, 147, 81, 50), (16.5, 145, 80, 50), (16.6, 144, 79, 50), (16.7, 142, 78, 50), (16.8, 141, 77, 49), (16.9, 139, 76, 49), (17, 138, 75, 48), (17.1, 137, 75, 47), (17.2, 135, 74, 47), (17.3, 134, 73, 46), (17.4, 132, 72, 45), (17.5, 131, 72, 45), (17.6, 129, 71, 44), (17.7, 128, 70, 43), (17.8, 127, 69, 43), (17.9, 125, 69, 42), (18, 124, 68, 41), (18.1, 122, 67, 41), (18.2, 121, 66, 40), (18.3, 119, 66, 39), (18.4, 118, 65, 39), (18.5, 117, 64, 38), (18.6, 115, 63, 37), (18.7, 114, 63, 37), (18.8, 112, 62, 36), (18.9, 111, 61, 35), (19, 109, 60, 34), (19.1, 108, 60, 33), (19.2, 107, 59, 32), (19.3, 105, 58, 31), (19.4, 104, 57, 29), (19.5, 102, 57, 28), (19.6, 101, 56, 27), (19.7, 99, 55, 26), (19.8, 98, 54, 25), (19.9, 97, 54, 24), (20, 95, 53, 23), (20.1, 94, 52, 21), (20.2, 92, 51, 20), (20.3, 91, 51, 19), (20.4, 89, 50, 18), (20.5, 88, 49, 17), (20.6, 87, 48, 16), (20.7, 85, 48, 15), (20.8, 84, 47, 13), (20.9, 82, 46, 12), (21, 81, 45, 11), (21.1, 79, 45, 10), (21.2, 78, 44, 9), (21.3, 77, 43, 8), (21.4, 75, 42, 9), (21.5, 74, 42, 9), (21.6, 72, 41, 10), (21.7, 71, 40, 10), (21.8, 69, 39, 11), (21.9, 68, 39, 11), (22, 67, 38, 12), (22.1, 65, 37, 12), (22.2, 64, 36, 13), (22.3, 62, 36, 13), (22.4, 61, 35, 14), (22.5, 59, 34, 14), (22.6, 58, 33, 15), (22.7, 57, 33, 15), (22.8, 55, 32, 16), (22.9, 54, 31, 16), (23, 52, 30, 17), (23.1, 51, 30, 17), (23.2, 49, 29, 18), (23.3, 48, 28, 18), (23.4, 47, 27, 19), (23.5, 45, 27, 19), (23.6, 44, 26, 20), (23.7, 42, 25, 20), (23.8, 41, 24, 21), (23.9, 39, 24, 21), (24, 38, 23, 22), (24.1, 37, 22, 21), (24.2, 37, 22, 21), (24.3, 36, 22, 21), (24.4, 36, 21, 20), (24.5, 35, 21, 20), (24.6, 35, 21, 20), (24.7, 34, 20, 19), (24.8, 34, 20, 19), (24.9, 33, 20, 19), (25, 33, 19, 18), (25.1, 32, 19, 18), (25.2, 32, 19, 18), (25.3, 31, 18, 17), (25.4, 31, 18, 17), (25.5, 30, 18, 17), (25.6, 30, 17, 16), (25.7, 29, 17, 16), (25.8, 29, 17, 16), (25.9, 28, 16, 15), (26, 28, 16, 15), (26.1, 27, 16, 15), (26.2, 27, 15, 14), (26.3, 26, 15, 14), (26.4, 26, 15, 14), (26.5, 25, 14, 13), (26.6, 25, 14, 13), (26.7, 24, 14, 13), (26.8, 24, 13, 12), (26.9, 23, 13, 12), (27, 23, 13, 12), (27.1, 22, 12, 11), (27.2, 22, 12, 11), (27.3, 21, 12, 11), (27.4, 21, 11, 10), (27.5, 20, 11, 10), (27.6, 20, 11, 10), (27.7, 19, 10, 9), (27.8, 19, 10, 9), (27.9, 18, 10, 9), (28, 18, 9, 8), (28.1, 17, 9, 8), (28.2, 17, 9, 8), (28.3, 16, 8, 7), (28.4, 16, 8, 7), (28.5, 15, 8, 7), (28.6, 15, 7, 6), (28.7, 14, 7, 6), (28.8, 14, 7, 6), (28.9, 13, 6, 5), (29, 13, 6, 5), (29.1, 12, 6, 5), (29.2, 12, 5, 4), (29.3, 11, 5, 4), (29.4, 11, 5, 4), (29.5, 10, 4, 3), (29.6, 10, 4, 3), (29.7, 9, 4, 3), (29.8, 9, 3, 2), (29.9, 8, 3, 2), (30, 8, 3, 2));

  MMCa : double = 40.048;
  MMMg : double = 24.305;
  MMNa : double = 22.98976928;
  MMCl : double = 35.453;
  MMSO4 : double = 96.0626;
  MMCO3 : double = 60.01684;
  MMHCO3 : double = 61.01684;
  MMCaSO4 : double = 172.171;
  MMCaCl2 : double = 147.015;
  MMCaCO3 : double = 100.087;
  MMMgSO4 : double = 246.475;
  MMNaHCO3 : double = 84.007;
  MMNa2CO3 : double = 105.996;
  MMNaCl : double = 58.443;
  MMCaOH2 : double = 74.06268;

  {$ifdef unix}
  numbuffers = 4;
  numsources = 4;
  startprog = 0;
  warning = 1;
  alarm = 2;
  endprog = 3;
  {$endif}

  AnalysisActive = TRUE;
  FANNActive = TRUE;

  DoLog = false;

  {$ifdef windows}
  DefaultFontHeight = 15;
  {$endif}
  {$ifdef linux}
  DefaultFontHeight = 12;
  {$endif}
  {$ifdef darwin}
  DefaultFontHeight = 12;
  {$endif}


var
  SpecificHeats : array[0..3] of TSpecificHeat;
  DriveLetter : string;
  OnUSB : boolean;
  ExecFolder : string;
  BHFolder : string;
  SoundFolder : string;
  IconFolder : string;
  Slash : string;
  EndChar : TEndChar;
  FermentableColor, HopColor, MiscColor, WaterAgentColor, WaterColor, YeastColor,
  FiningColor: TColor;
  MaxGrowthFactor : double;
  AmCellspGramDry, AmCellspPack, AmCellspMlSlurry : double;


//  {$ifdef linux}
//  buffer : array [0..numbuffers] of TALuint; //TALuint;
//  source : array [0..numsources] of TALuint; //TALuint;
//  sourcepos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 ); //TALfloat= ( 0.0, 0.0, 0.0 );
//  sourcevel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0 ); //TALfloat= ( 0.0, 0.0, 0.0 );
//  listenerpos: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0); //TALfloat= ( 0.0, 0.0, 0.0 );
//  listenervel: array [0..2] of TALfloat= ( 0.0, 0.0, 0.0); //TALfloat= ( 0.0, 0.0, 0.0 );
//  listenerori: array [0..5] of TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0); //TALfloat= ( 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
//
//  argv: array of PalByte;
//  format: TALEnum; //TALEnum;
//  size: TALSizei; //TALSizei;
//  freq: TALSizei; //TALSizei;
//  loop: TALInt;  //TALInt;
//  dat: TALVoid;  //TALVoid;
//  {$endif}

  StartSound, EndSound, WarningSound, AlarmSound : string;

  slLog : TStringList;

Function GetTaskBarSize: TRect;
Function InitializeHD(FN : string; var Dir : string) : boolean;
Function Convert(FromUnit : TUnit; ToUnit : TUnit; val : double) : double;
Procedure ConvertSeconds(var h, m, s, mi : word); // IN: s. OUT: h, m, s, mi. Converts (s)econds into h:m:s:00
Function Sinus(angle : double) : double; //angle in degrees
Function Cosinus(angle : double) : double; //angle in degrees
Function Between(value, low, high : double) : boolean;
Function MaxD(a, b : double) : double;
Function MinD(a, b : double) : double;
Function MaxA(a : array of double) : double;
Function MinA(a : array of double) : double;
Function MinI(a, b : integer) : integer;
Function MaxI(a, b : integer) : integer;
Function RoundUp( R : Double) : LongInt;
Function InvLog(i : double) : double;
Procedure SwapW(var a, b : double);
Function DecimalsSc(S : Double) : LongInt;
Function GetOrdinals(S : extended) : LongInt;
Function GetDecimals(S : Double) : LongInt;
Function TLC(s : string) : string;
Function FormatString(S : extended; D : LongInt) : String;
Function StringFormat(S, X : Double; D : SmallInt) : string;
Function StrToReal(S : string) : Double;
Function RealToStr(S : Double) : string;
Function ValidateRealStr(S : string) : boolean;
Function RealToStrSci(S : Double; Prec : LongInt) : string;
Function RealToStrDEC(S : Double; D : SmallInt) : string;
Function RealToStrSignif(S : Double; Signif : SmallInt) : string;
Function Order(R : Double) : SmallInt;
Function StringToDate(s : string) : TDateTime;
Function IsValidDate(s : string) : boolean;
Function StringToTime(s : string) : TDateTime;
Function IsValidTime(s : string) : boolean;
Function SetDecimalSeparator(Sin : string) : string;
Function SetDecimalPoint(Sin : string) : string;
Function CountSubssInString(s, sub : string) : integer;
Function IsInString(searchString, SubString : string) : boolean;
Function FloatToStringDec(d : double; Dec: integer) : string;
Function FloatToDisplayString(d : double; Dec : integer; u : string) : string;
Function IntToDisplayString(i : integer; u : string) : string;
Procedure QuickSortArray(var Arr : array of double);
Procedure SelectionSortArray(var List : array of double);
Function SolveQuadratic(a, b, c : double; var X1, X2 : double) : integer;
Function SolveCubic(a, b, c, d : double; var X1, X2, X3 : double) : integer;
Procedure ShowNotification(sender : TComponent; s : string);
Procedure ShowNotificationModal(sender : TComponent; s : string);
Function Question(sender : TComponent; s : string) : boolean;
Function GetAnswer(sender : TComponent; Q : string) : string;
Function GetPasswd(sender : TComponent) : string;
Function RemInvChars(S : string) : string;

Function DrawTxt(Canvas : TCanvas;  MiddleHeight, Left, Right : LongInt;
                 Text : string;  Alignment : TAlignment;
                 MoreLines : boolean) : integer;
Function DrawTxtRct( Canvas : TCanvas;  R : TRect;
                   Text : string;  Alignment : TAlignment;
                   MoreLines : boolean) : integer;
Procedure DrawTxtVarRct(canvas : TCanvas; Text : string; var R : TRect);
Function RotateText(Canvas : TCanvas; Xt, Yl, Deg : LongInt; Txt : string;
                    BackColor : tColor; Transparant : boolean) : boolean;
Procedure Scaling(var Min, Max, De : double; var Astr : LongInt);
Procedure CalcScale(var Min, Max, De : double; var AStr : LongInt);
Procedure ScaleFixed(var Min, Max, De : double; var Astr : LongInt);
Procedure ScaleDate(var Min, Max, De : TDateTime; var Astr : LongInt);
Function CalcTextHeight( FontSize, PPIY : integer) : integer;
Function CalcAmountLines( Canvas : TCanvas;  Text : string;
                          Width : LongInt) : LongInt;
Function CalcAmountLines2(Font : TFont;  Text : string; Width : LongInt) : LongInt;
Function CalcMaxWidth( Canvas : TCanvas;  Text : string) : LongInt;
Function GiveNextLine( Canvas : TCanvas;  Text : string;
                       Width : LongInt; var Pos : LongInt) : string;
Function NextWord( Line : string; var Pos : LongInt) : string;

Function CalcFrac(TpH, pK1, pK2, pK3 : double) : double;
Function SRMtoEBC(d : double) : double;
Function EBCtoSRM(d : double) : double;
Function EBCtoColor(EBC : double) : TColor;
Function SRMtoColor(SRM : double) : TColor;
Function SGtoPlato(SG : Double) : Double;
Function PlatoToSG(plato : Double) : Double;
Function PlatoToExtract(P : Double) : Double;
Function SGtoBrix(SG : Double) : Double;
Function BrixToSG(Brix : Double) : Double;
Function BrixToFG(OBrix, FBrix : double) : double;
Function SGtoExtract(SG : Double) : Double;
Function ExtractToSG(E : Double) : Double;
Function BrixToRI(Brix : Double) : Double;
Function RE(SG : Double; Brix : Double) : Double;
Function AlcByVol(SG : Double; Brix : Double) : Double;
Function ABVol(OG : Double; FG : Double) : Double;
Function ABW(ABVol : Double; FG : Double) : Double;
Function ABW2(FG : Double; Brix : Double) : Double;
Function SGFerm(OBrix : Double; FBrix : Double) : Double;
Function RealExtract(FG : Double; Brix : Double) : Double;
Function FtoC(f : double) : double;
Function CtoF(c : double) : double;
Function Waterdensity(T : Double) : Double;
Function pHRoom(pHmash, Tm : double) : double;
Function DwatT(T : double; Tref : Double) : Double;
Function FreezingPoint(SG : Double; FG : Double) : Double;
Function StarterSize(types : Integer; soort : Double; V : Double; SG : Double; start : Double) : double;
Function StarterSize2(types : Integer; Needed : double; start : Double) : double;
Function AmountCells(types : Integer; V : Double; start : Double) : double;
Function GrowthFactor(types : Integer; V : Double; start : Double) : double;
Function CalcIBU(Method : TIBUmethod; HopUse : THopUse; AA : Double; AM : Double; Vw : Double; Vf : Double; SG : Double; Tboil : Double; HopVorm : THopForm; BNAP : Double) : Double;
Function AmHop(Method : TIBUmethod; HopUse : THopUse; AA : Double; IBU : Double; Vw : double; Vf : Double; SG : Double; Tboil : Double; HopVorm : THopForm; BNAP : Double) : Double;
Function IonBalance(Ca, Mg, Na, Cl, SO4, HCO3 : double) : double;
Function CarbStoCO2(S : double; T : double; SFactor : double) : double;
Function CarbCO2toS(CO2 : double; T : double; SFactor : double) : double;
Function CarbCO2toPressure(CO2 : double; T : double) : double;
Function CarbPressuretoCO2(P : double; T : double) : double;
Function ActualIBU(origibu, HSI, Temp : double; Elapsed, storagetype : longint) : double;

Procedure PlayStartProg;
Procedure PlayEndProg;
Procedure PlayWarning;
Procedure PlayAlarm;

//Procedure SetFontHeight(F : TForm; fs : integer);

Function ConvertStringEnc(s : string) : string;

Function ZipFiles(l : TStringList; zipfn : string) : boolean;
Function UnZipFiles(zipfn, outpath : string) : boolean;

Procedure Log(s : string);

implementation

uses Data, FrMain, lconvencoding, Zipper;

function GetTaskBarSize: TRect;
begin
  {$ifdef Windows}
//  SystemParametersInfo(SPI_GETWORKAREA, 0, @Result, 0);
  {$endif}
end;

Function ConvertStringEnc(s : string) : string;
var encs, encto: string;
begin
  encto := GetDefaultTextEncoding;
  encs := 'utf8';
  Result := ConvertEncoding(s, encs, encto);
//  Result:= UTF8toANSI(Result);
end;

Function InitializeHD(FN : string; var Dir : string) : boolean;
const waitT : word = 1;
      Trials : integer = 5;
var i : integer;
    dlgDir : TSelectDirectoryDialog;
begin
  Result:= false;
  i:= 1;
  while (not Result) and (i < Trials) do
  begin
    Result:= FileExists(Dir + FN);
    if (not Result) then
      Sleep(1000 * waitT);
    inc(i);
  end;
  if not Result then
  begin
    dlgDir := TSelectDirectoryDialog.Create(nil);
    dlgDir.Title:= 'Geef map met ' + FN;
    dlgDir.Filter:= 'XML bestand|*.xml';
    dlgDir.FilterIndex:= 0;
    if dlgDir.Execute then
    begin
      Dir:= dlgDir.FileName + Slash;
      Result:= FileExists(Dir + FN);
    end;
    dlgDir.free;
    MessageDlg('Foutmelding', FN + ' niet gevonden.' + #10#10 + 'Brewbuddy sluit af.', mtError, [mbOK], 0);
//    ShowNotification(frmMain, FN + 'niet gevonden.' + #10#13 + 'BrouwHulp sluit af');
  end;
end;

Function Convert(FromUnit : TUnit; ToUnit : TUnit; val : double) : double;
begin
//  TUnit = (milligram, gram, kilogram, milliliter, liter, hectoliter, IBU, EBC, SRM,
//           SG, plato, brix, celcius, fahrenheit, minuut, uur, dag, week, ppm,
//           volco2, abv, perc, euro, pH, pph, calgdeg, empty);
  Result:= val;
  case FromUnit of
  milligram:
    case ToUnit of
    gram: Result:= val / 1000;
    kilogram: Result:= val / 1000000;
    end;
  gram:
    case ToUnit of
    milligram: Result:= 1000 * val;
    kilogram: Result:= val / 1000;
    end;
  kilogram:
    case ToUnit of
    milligram: Result:= 1000000 * val;
    gram: Result:= 1000 * val;
    end;
  milliliter:
    case ToUnit of
    liter: Result:= val / 1000;
    hectoliter: Result:= val / 100000;
    end;
  liter:
    case ToUnit of
    milliliter: Result:= 1000 * val;
    hectoliter: Result:= 100 * val;
    end;
  hectoliter:
    case ToUnit of
    milliliter: Result:= 100000 * val;
    liter: Result:= 100 * val;
    end;
  meter:
    case ToUnit of
    centimeter: Result:= 100 * val;
    end;
  centimeter:
    case ToUnit of
    meter: Result:= val / 100;
    end;
  EBC:
    case ToUnit of
    SRM: Result:= EBCtoSRM(val);
    end;
  SRM:
    case ToUnit of
    EBC: Result:= SRMtoEBC(val);
    end;
  SG:
    case ToUnit of
    plato: Result:= SGtoPlato(val);
    brix: Result:= SGToPlato(val) * Settings.BrixCorrection.Value;
    end;
  plato:
    case ToUnit of
    SG: Result:= PlatoToSG(val);
    brix: Result:= val * Settings.BrixCorrection.Value;
    end;
  brix:
    if Settings.BrixCorrection.Value > 0 then
      case ToUnit of
      SG: Result:= PlatoToSG(val / Settings.BrixCorrection.Value);
      plato: Result:= val / Settings.BrixCorrection.Value;
      end;
  celcius:
    case ToUnit of
    fahrenheit: Result:= CtoF(val);
    end;
  fahrenheit:
    Case ToUnit of
    celcius: Result:= FtoC(val);
    end;
  minuut:
    case ToUnit of
    uur: Result:= val / 60;
    dag: Result:= val / (60 * 24);
    week: Result:= val / (60 * 24 * 7);
    end;
  uur:
    case ToUnit of
    minuut: Result:= val * 60;
    dag: Result:= val / 24;
    week: Result:= val / (7 * 24);
    end;
  dag:
    case ToUnit of
    minuut : Result:= val * (60 * 24);
    uur : Result:= val * 24;
    week: Result:= val / 7;
    end;
  week:
    case ToUnit of
    minuut: Result:= val * 7 * 24 * 60;
    uur: Result:= val * 7 * 24;
    dag : Result:= val * 7;
    end;
  kPa:
    case ToUnit of
    bar: Result:= val / 100;
    end;
  bar:
    case ToUnit of
    kPa: Result:= 100 * val;
    end;
  lintner:
    case ToUnit of
    windischkolbach: Result:= 3.5 * val - 16;
    end;
  windischkolbach:
    case ToUnit of
    lintner: Result:= (val + 16) /  3.5;
    end;
  end;
end;

Procedure ConvertSeconds(var h, m, s, mi : word);
begin
  mi:= 0;
  m:= s div 60;
  s:= s mod 60;
  h:= m div 60;
  m:= m mod 60;
end;

Function Sinus(angle : double) : double; //angle in degrees
var rad : double;
begin
  rad:= 2 * PI * angle/360;
  Result:= Sin(rad);
end;

Function Cosinus(angle : double) : double; //angle in degrees
var rad : double;
begin
  rad:= 2 * PI * angle/360;
  Result:= Cos(rad);
end;

Function Between(value, low, high : double) : boolean;
begin
  Result:= false;
  if (value >= low) and (value <= high) then Result:= TRUE;
end;

Function MaxD(a, b : double) : double;
begin
  if a > b then result:= a else result:= b;
end;

Function MinD(a, b : double) : double;
begin
  if a < b then result:= a else result:= b;
end;

Function MaxA(a : array of double) : double;
var i : integer;
begin
  Result:= a[Low(a)];
  for i:= Low(a) + 1 to High(a) do
    if a[i] > Result then
      Result:= a[i];
end;

Function MinA(a : array of double) : double;
var i : integer;
begin
  Result:= a[Low(a)];
  for i:= Low(a) + 1 to High(a) do
    if a[i] < Result then
      Result:= a[i];
end;

Function MinI(a, b : integer) : integer;
begin
  if a < b then Result:= a
  else Result:= b;
end;

Function MaxI(a, b : integer) : integer;
begin
  if a > b then Result:= a
  else Result:= b;
end;

Function RoundUp( R : Double) : LongInt;
begin
  Result:= Trunc(R);
  if R < 0 then Result:= Trunc(R) - 1
  else if R > 0 then Result:= Trunc(R) + 1;
end;

Function InvLog(i : double) : double;
begin
  Result:= power(10, i);
end;

Procedure SwapW(var a, b : double);
var c : double;
begin
  c:= b;
  b:= a;
  a:= c;
end;

Function DecimalsSc( S: Double): LongInt;
begin
  if Abs(S) < 1 then Result:= Abs(Order(S))
  else Result:= 0;
end;

Function GetOrdinals( S : Extended) : LongInt;
var AbsS : Extended;
begin
  AbsS:= Abs(S);
  if AbsS < 1 then result:= 1  {0,..}
  else Result:= Trunc(Log10(AbsS)) + 1;
  if S < 0 then Inc(Result); {Minus-sign}
end;

Function GetDecimals( S : Double) : LongInt;
begin
  if (ABS(S) < 100) and (S <> 0) then
  begin
    if S >= 1 then Result:= 1 - Trunc( log10(ABS(S)) )
    else Result:= Abs(Order(S)) + 2;
  end
  else Result:= 0;
end;

Function TLC(s : string) : string;
begin
  Result:= Trim(LowerCase(s));
end;

Function FormatString(S : extended; D : LongInt) : String;
var O : LongInt;
begin
  O:= GetOrdinals(S);
  if D > 0 then O:= O + 1 + D;
  Result:= '%' + IntToStr(O) + '.' + IntToStr(D) + 'f';
  FmtStr(Result, Result, [S]);
end;

Function StringFormat( S, X : Double;  D : SmallInt) : string;
var Total, Whole, dec : LongInt;
begin
  if (ABS(S) < 100) and (S <> 0) and (D < 0) then
  begin
    if S >= 1 then Dec:= 1 - Trunc( log10(ABS(S)) )
    else Dec:= Abs(Order(S)) + 2;
  end
  else if (ABS(S) < 100) and (S <> 0) and (D >= 0) then
    Dec:= D
  else Dec:= 0;

  if X > 1 then Whole:= Trunc(log10(abs(X))) + 1
  else Whole:= 1;

  if Dec > 0 then Total:= Whole + Dec + 1
  else Total:= Whole;

  if X < 0 then Inc(Total);

  Result:= '%' + IntToStr(Total) + '.' + IntToStr(Dec) + 'f';
end;

Function RealToStr( S : Double) : string;
var StrF : string;
    Total, D : LongInt;
begin
  Total:= GetOrdinals(S);
  D:= GetDecimals(S);
  if D > 0 then Total:= Total + 1 + D;
  StrF:= '%' + IntToStr(Total) + '.' + IntToStr(D) + 'f';

  FmtStr(Result, StrF, [S]);
end;

Function RealToStrSci(S : Double; Prec : LongInt) : string;
var StrF, str : string;
    p : LongInt;
begin
  StrF:= '%.' + IntToStr(Prec) + 'e';
  FmtStr(Result, StrF, [S]);
  p:= pos('E', Result) + 1;
  str:= Copy(Result, p, Length(Result) - p + 1);
  result:= copy(result, 1, p - 1);
  result:= result + IntToStr(StrToInt(str));
end;

Function RealToStrDEC( S : Double;  D : SmallInt) : string;
var StrF : string;
    Total : LongInt;
begin
  Total:= GetOrdinals(S);
  if D > 0 then
  begin
    Total:= Total + 1 + D;
    StrF:= '%' + IntToStr(Total) + '.' + IntToStr(D) + 'f';
    FmtStr(Result, StrF, [S]);
  end
  else Result:= IntToStr(Round(S));
end;

Function RealToStrSignif(S : Double; Signif : SmallInt) : string;
var O, D : LongInt;
begin
  O:= GetOrdinals(S);
  if O > Signif then Result:= RealToStrSci(S, Signif)
  else if GetDecimals(S) <= Signif then
  begin
    D:= Signif - O;
    Result:= RealToStrDec(S, D);
  end
  else Result:= RealToStrSci(S, Signif);
end;

Function Pos2(LS, S : string) : LongInt;
var i : LongInt;
begin
  Result:= -1;
  for i:= 1 to Length(S) do
  begin
    if S[i] = LS then Result:= i;
  end;
end;

Function StrToReal( S : string) : Double;
var Code, p : integer;
    SO : string;
    D : double;
begin
  Code:= 0;
  try
    p:= Pos2(DefaultFormatSettings.DecimalSeparator, S);
    if (p >= 0) and (p < Length(S)) then S[p]:= '.';
    Val(S, D, Code);
    Result:= D;
  except
    SO:= Copy(S, Code, 1);
    ShowMessage('Fout in conversie van tekst naar getal (karakter ' + SO + ')');
    Result:= 0;
  end;
end;

Function ValidateRealStr(S : string) : boolean;
var Code, p : integer;
    SO : string;
    D : double;
begin
  Code:= 0;
  try
    p:= Pos2(DefaultFormatSettings.DecimalSeparator, S);
    if (p >= 0) and (p < Length(S)) then S[p]:= '.';
    Val(S, D, Code);
    Result:= TRUE;
  except
    SO:= Copy(S, Code, 1);
    ShowMessage('Fout in conversie van tekst naar getal (karakter ' + SO + ')');
    Result:= false;
  end;
end;

Function Order( R : Double) : SmallInt;
begin
  if R = 0 then Result:= 0
  else
  begin
    if Abs(R) >= 1 then
    begin
      Result:= Trunc(Log10(Abs(R)));
    end
    else Result:= Trunc(Log10(Abs(R)))-1;
  end;
end;

{function MyStrToDate(DateStr: String): TDateTime;
var
  F: TFormatSettings;
  s: String;
  i: Integer;
  separator: integer;
begin
  GetLocaleFormatSettings(0, F);
  F.DefaultFormatSettings.ShortDateFormat := 'd-m-yyyy';
  F.ShortTimeFormat := 'hh:mm:ss';
  F.DateSeparator := '-';
  F.TimeSeparator := ':';

  separator := Pos(F.DateSeparator, DateStr);

  if separator = 0 then
    Raise Exception.Create('No date separator in date ' + DateStr);

  s := Copy(DateStr, 1, separator-1 );

  i := High(ShortMonthNames);

  while ( i >= Low(ShortMonthNames) ) and not SameText ( s, ShortMonthNames[i] ) do
    dec ( i );

  s := IntToStr(i) + Copy ( DateStr, separator, length(DateStr) );
  if i >=  Low(ShortMonthNames) then
    result := StrToDateTime ( s, F )
  else
    Raise Exception.Create('Could not convert the date ' + DateStr)
end;}

Function StringToDate(s : string) : TDateTime;
var ns : string;
    rf : TReplaceFlags;
const OldPattern : array[0..19] of string = (' ', '/', '\', '.', '. ', 'jan', 'feb', 'mrt', 'mar', 'apr', 'mei', 'may', 'jun', 'jul', 'aug', 'sep', 'okt', 'oct', 'nov', 'dec');
      NewPattern : array[0..19] of string = ('-', '-', '-', '-', '-', '1', '2', '3', '3', '4', '5', '5', '6', '7', '8', '9', '10', '10', '11', '12');
begin
  rf:= [rfReplaceAll, rfIgnoreCase];
  ns:= StringsReplace(s, OldPattern, NewPattern, rf);

  Result:= 0;

  if s <> 'NTB' then
  begin
    DefaultFormatSettings.LongTimeFormat := 'hh:mm:ss';
    DefaultFormatSettings.ShortDateFormat := 'DD-MM-YYYY';
    DefaultFormatSettings.DateSeparator := '-';
    DefaultFormatSettings.TimeSeparator := ':';
    try
      Result:= StrToDate(ns);
    except
      Result:= 0;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'DD-MM-YY';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'MM-DD-YY';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'YY-MM-DD';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'YYYY-MM-DD';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'D-M-YY';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'M-D-YYYY';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'M-D-YY';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat := 'YY-M-D';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
    if Result = 0 then
    begin
      DefaultFormatSettings.ShortDateFormat:= 'YYYY-M-D';
//      DefaultFormatSettings.ShortDateFormat := 'YYYY-M-D';
      try
        Result:= StrToDate(ns);
      except
        Result:= 0;
      end;
    end;
  end;
end;

Function IsValidDate(s : string) : boolean;
begin
  Result:= (StringToDate(s) > 0);
end;

Function StringToTime(s : string) : TDateTime;
begin
  DefaultFormatSettings.LongTimeFormat := 'hh:mm:ss';
  DefaultFormatSettings.ShortDateFormat := 'DD-MM-YYY';
  DefaultFormatSettings.DateSeparator := '-';
  DefaultFormatSettings.TimeSeparator := ':';
  try
    Result:= StrToTime(s);
  except
    Result:= 0;
  end;
end;

Function IsValidTime(s : string) : boolean;
begin
  Result:= (StringToTime(s) > 0);
end;

Function SetDecimalSeparator(Sin : string) : string;
var OldPattern : array[0..0] of string;
    NewPattern : array[0..0] of string;
    rf : TReplaceFlags;
begin
  rf:= [rfReplaceAll, rfIgnoreCase];
  OldPattern[0]:= '.';
  NewPattern[0]:= DefaultFormatSettings.DecimalSeparator;
  Result:= StringsReplace(Sin, OldPattern, NewPattern, rf);
end;

Function SetDecimalPoint(Sin : string) : string;
var OldPattern : array[0..0] of string;
    NewPattern : array[0..0] of string;
    rf : TReplaceFlags;
begin
  rf:= [rfReplaceAll, rfIgnoreCase];
  OldPattern[0]:= DefaultFormatSettings.DecimalSeparator;
  NewPattern[0]:= '.';
  Result:= StringsReplace(Sin, OldPattern, NewPattern, rf);
end;

Function CountSubssInString(s, sub : string) : integer;
var i, lsub : integer;
    ssub : string;
begin
  Result:= 0;
  lsub:= length(sub);
  for i:= 0 to Length(s) - lsub + 1 do
  begin
    ssub:= midstr(s, i, lsub);
    if ssub = sub then
      Inc(Result);
  end;
end;

Function IsInString(searchString, SubString : string) : boolean;
begin
  Result:= false;
  Result:= countsubssinstring(lowercase(searchstring), LowerCase(SubString)) > 0;
end;

Function FloatToStringDec(d : double; Dec: integer) : string;
begin
  Result:= RealToStrDec(d, Dec);
end;

Function FloatToDisplayString(d : double; Dec : integer; u : string) : string;
begin
  Result:= RealToStrDec(d, Dec) + ' ' + u;
end;

Function IntToDisplayString(i : integer; u : string) : string;
begin
  Result:= IntToStr(i) + ' ' + u;
end;

Function SolveQuadratic(a, b, c : double; var X1, X2 : double) : integer;
var D : double;
begin
  X1:= 0; X2:= 0;
  Result:= 0;
  D:= b * b - 4 * a * c;
  if D < 0 then Result:= 0
  else if D = 0 then Result:= 1
  else Result:= 2;
  if (Result = 1) and (a > 0) then
  begin
    X1:= -b / (2 * a);
  end
  else if (Result = 2) and (a <> 0) then
  begin
    X1:= (-b - SQRT(D)) / (2 * a);
    X2:= (-b + SQRT(D)) / (2 * a);
  end;
end;

Function SolveCubic(a, b, c, d : double; var X1, X2, X3 : double) : integer;
var Di, E : double;
begin
  Result:= 0;
  X1:= 0; X2:= 0; X3:= 0;
  Di:= 4 * Power(-b*b + 3*a*c, 3) +
      Power(-2 * Power(b, 3) + 9*a*b*c - 27*a*a*d, 2);
  if (Di > 0) and (a <> 0) then
  begin
    E:= Power(-2*b*b*b + 9*a*b*c - 27*a*a*d + SQRT(Di), 1/3);
    X1:= -b/(3*a) - (Power(2, 1/3) * (-b*b+3*a*c)) / (3 * a * E)
         + E / (3 * Power(2, 1/3) * a);
  end;
end;

Procedure QuickSortArray(var Arr : array of double);
  procedure QuickSort(var A: array of double; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      Mid, T : double;
  begin
    Lo := iLo;
    Hi := iHi;
    Mid := A[(Lo + Hi) div 2];
    repeat
      while A[Lo] < Mid do Inc(Lo);
      while A[Hi] > Mid do Dec(Hi);
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
  QuickSort(Arr, Low(Arr), High(Arr));
end;

Procedure SelectionSortArray(var List : array of double);
var
    i, j, best_j : integer;
    best_value   : double;
begin
    for i := Low(List) to High(List) - 1 do
    begin
        best_value := List[i];
        best_j := i;
        for j := i + 1 to High(List) do
        begin
            if (List[j] < best_value) Then
            begin
                best_value := List[j];
                best_j := j;
            end;
        end;    // for j := i + 1 to max do
        List[best_j] := List[i];
        List[i] := best_value;
    end;        // for i := min to max - 1 do
end;

Procedure ShowNotification(sender : TComponent; s : string);
begin
//  ShowMessage(s);
  MessageDlg(s, mtInformation, [mbOK], 0);
{  if FrmNotification = NIL then
  begin
    FrmNotification:= TFrmNotification.Create(sender);
    FrmNotification.ShowFrm(s);
  end
  else if FrmNotification.Showing then
    FrmNotification.AddText(s)
  else
  begin
    FreeAndNIL(FrmNotification);
    FrmNotification:= TFrmNotification.Create(sender);
    FrmNotification.ShowFrm(s);
  end;}
end;

Procedure ShowNotificationModal(sender : TComponent; s : string);
begin
  FrmNotification:= TFrmNotification.Create(sender);
  FrmNotification.Execute(s);
end;

Function Question(sender : TComponent; s : string) : boolean;
begin
  if (MessageDlg(s, mtConfirmation, [mbYes], 0) = 6) then
     Result := true
  else
     Result := false ;
end;

Function GetAnswer(sender : TComponent; Q : string) : string;
begin
//  FrmGetString:= TFrmGetString.Create(sender);
//  Result:= FrmGetString.GetAnswer(Q);
//  FreeAndNil(FrmGetString);
end;

Function GetPasswd(sender : TComponent) : string;
begin
//  FrmGetPasswd:= TFrmGetPasswd.Create(sender);
//  Result:= FrmGetPasswd.GetAnswer;
//  FreeAndNil(FrmGetString);
end;

{Graph related functions}

Procedure CalcScale(var Min, Max, De : double; var AStr : LongInt);
var   Lg, Fr : double;
      Ast : LongInt;
Const StrMax = 15;
      StrMin = 6;
begin
  if Min <> 0 then De:= InvLog(Order(Min))
  else if Max <> 0 then De:= InvLog(Order(Max));

  if De <> 0 then ASt:= round(Abs(Max - Min)/ De)
  else Ast:= StrMin;
  While ((Ast < StrMin) or (Ast > StrMax)) and (De <> 0) do
  begin
    ASt:= round(Abs(Max - Min)/ De);

    Lg:= Log10(De);
    if Frac(Lg) = 0 then Lg:= De
    else if (Lg < 0) then Lg:= InvLog(Trunc(Lg) - 1)
    else Lg:= InvLog(Trunc(Lg));
    Fr:= De / Lg;
    if Fr > 5 then Fr:= 1;
    if Fr < 1 then Fr:= 5;
    if Ast <= 2 then De:= 0.1 * De
    else if Ast >= 100 then De:= 10 * De
    else if Ast < StrMin then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De / 2
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De / 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De / 2.5;
    end
    else if Ast > StrMax then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De * 2.5
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De * 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De * 2;
    end;
  end;
  if De > 0 then
  begin
    if Frac(Min / De) <> 0.0 then
    begin
      if Min > 0 then Min:= Trunc(Min / De) * De
      else Min:= (Trunc(Min / De) - 1) * De;
    end;
    if Frac(Max / De) <> 0.0 then
    begin
      if Max > 0 then Max:= (Trunc(Max / De) + 1) * De
      else Max:= Trunc(Max / De) * De;
    end;
    AStr:= round(Abs(Max - Min)/ De);
    if Min > Max then SwapW(Min, Max);
  end;
end;

Function RoundOrder( R : double) : double;
begin
  Result:= Int(R / InvLog(Order(R))) * InvLog(Order(R));
end;

Function OrderHigh( R : double) : integer;
begin
  if Frac(Log10(R)) = 0 then Result:= Order(R)
  else Result:= Order(R) + 1;
end;

Function RoundOrderHigh( R : double) : double;
begin
  Result:= RoundUp(R / InvLog(Order(R))) * InvLog(Order(R));
end;

Procedure Scaling(var Min, Max, De : double; var Astr : LongInt);
var SignMin, SignMax : ShortInt;
begin
  SignMin:= Sign(Min); SignMax:= Sign(Max);
  if ((Min >= 0) and (Max >= 0)) then
  begin
    If Order(Min) = Order(Max) then
    begin
      Min:= RoundOrder(Min); Max:= RoundOrderHigh(Max);
    end
    else
    begin
      Min:= 0; Max:= RoundOrderHigh(Max);
    end;
    CalcScale(Min, Max, De, AStr);
  end
  else if ((Min <= 0) and (Max <= 0)) then
  begin
    if Order(Min) = Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= RoundOrder(Max);
    end
    else
    begin
      Min:= RoundOrderHigh(Min); Max:= 0;
    end;
    CalcScale(Min, Max, De, AStr);
  end
  else
  begin
    if Order(Min) = Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= RoundOrderHigh(Max);
    end
    else if Order(Min) > Order(Max) then
    begin
      Min:= RoundOrderHigh(Min); Max:= -Min;
    end
    else if Order(Max) > Order(Min) then
    begin
      Max:= RoundOrderHigh(Max); Min:= -Max;
    end;
    CalcScale(Min, Max, De, AStr);
  end;

  {RelativeRound(Min, Max, De);}
  if Sign(Min) <> SignMin then Min:= Abs(Min) * SignMin;
  if Sign(Max) <> SignMax then Max:= Abs(Max) * SignMax;
  if (Abs(round(Max) - Max) < abs(0.001 * Max)) and (abs(Max) > 1) then
    Max:= round(Max);
  if (Abs(round(Min) - Min) < abs(0.001 * Min)) and (abs(Min) > 1) then
    Min:= round(Min);
end;

Procedure ScaleDate(var Min, Max, De : TDateTime; var Astr : LongInt);
var   //Y1, M1, D1 : longint;
      Y2, M2, D2 : word;
{Const StrMax = 15;
      StrMin = 6;}
begin
//  DecodeDate(Min, Y1, M1, D1);
  DecodeDate(Max, Y2, M2, D2);
{  case M2 of
  1, 3, 5, 7, 8, 10, 12 : D2:= 31;
  4, 6, 9, 11 : D2:= 30;
  2 : if Y2 mod 4 = 0 then D2:= 29 else D2:= 28;
  end;}

 { Min:= EncodeDate(Y1, M1, 1);
  Max:= EncodeDate(Y2, M2, D2);}
  AStr:= 6;
  De:= (Max - Min) / 6;
end;

Procedure ScaleFixed(var Min, Max, De : double; var Astr : LongInt);
var   Lg, Fr : double;
      Ast : LongInt;
Const StrMax = 15;
      StrMin = 6;
begin
  ASt:= round(Max);
  De:= 1;
  While ((Ast < StrMin) or (Ast > StrMax)) and (De <> 0) do
  begin
    ASt:= round((Max) / De);

    Lg:= Log10(De);
    if Frac(Lg) = 0 then Lg:= De
    else if (Lg < 0) then Lg:= InvLog(Trunc(Lg) - 1)
    else Lg:= InvLog(Trunc(Lg));
    Fr:= De / Lg;
    if Fr > 5 then Fr:= 1;
    if Fr < 1 then Fr:= 5;
    if Ast <= 2 then De:= 0.1 * De
    else if Ast >= 100 then De:= 10 * De
    else if Ast < StrMin then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De / 2
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De / 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De / 2.5;
    end
    else if Ast > StrMax then
    begin
      if (Fr > 0.9) and (Fr < 1.1) then De:= De * 2.5
      else if (Fr > 4.9) and (Fr < 5.1) then De:= De * 2
      else if (Fr > 2.4) and (Fr < 2.6) then De:= De * 2;
    end;
  end;
  if De <> 0 then
  begin
    if Frac(Min / De) <> 0.0 then
    begin
      if Min > 0 then Min:= Trunc(Min / De) * De
      else Min:= (Trunc(Min / De) - 1) * De;
    end;
    if Frac(Max / De) <> 0.0 then
    begin
      if Max > 0 then Max:= (Trunc(Max / De) + 1) * De
      else Max:= Trunc(Max / De) * De;
    end;
    AStr:= round((Max) / De);
  end;
end;

Function DrawTxt( Canvas : TCanvas;  MiddleHeight, Left, Right : LongInt;
                   Text : string;  Alignment : TAlignment;
                   MoreLines : boolean) : integer;
var BoxWidth, X, AmountLines, counter, MH, Pos : LongInt;
    Rec : TRect;
    s : string;
begin
  Rec.Right:= Right; Rec.Left:= Left; Result:= 0;
  X:= 0; AmountLines:= 0;
  with Canvas do
  begin
    BoxWidth:= Rec.Right - Rec.Left;
    if MoreLines then
    begin
      Pos:= CalcMaxWidth(Canvas, Text);
      BoxWidth:= MaxI(BoxWidth, Pos);
      AmountLines:= CalcAmountLines(Canvas, Text, BoxWidth);
      Result:= AmountLines * TextHeight(Text);
    end
    else Result:= TextHeight(Text);
    Rec.Left:= Left;
    Rec.Right:= Right;
    Pos:= 1;
    if MoreLines then
    begin
      for counter:= 1 to AmountLines do
      begin
        s:= GiveNextLine(Canvas, Text, BoxWidth, Pos);
        MH:= MiddleHeight + round(-0.5 * Result + (counter - 0.5) * TextHeight(Text));
        Rec.Top:= MH - round(0.5 * TextHeight(Text));
        Rec.Bottom:= Rec.Top + TextHeight(Text);

        if Alignment = taLeftJustify then X:= Rec.Left
        else if Alignment = taRightJustify then X:= MaxI(Rec.Right - TextWidth(s), 0)
        else if Alignment = taCenter then X:= Rec.Left + round(0.5 * (BoxWidth - TextWidth(s)));
        TextRect(Rec, X, Rec.Top, s);
      end;
    end
    else
    begin
      Rec.Top:= MiddleHeight - round(0.5 * TextHeight(Text));
      Rec.Bottom:= Rec.Top + TextHeight(Text);
      if Alignment = taLeftJustify then X:= Rec.Left
      else if Alignment = taRightJustify then X:= MaxI(Rec.Right - TextWidth(Text), 0)
      else if Alignment = taCenter then X:= MaxI(Rec.Left + round(0.5 * (BoxWidth - TextWidth(Text))), 0);
      TextRect(Rec, X, Rec.Top, Text);
    end;
  end;
  Result:= Rec.Bottom;
end;

Procedure DrawTxtVarRct(canvas : TCanvas; Text : string; var R : TRect);
var TW : integer;
begin
  TW:= canvas.TextWidth(Text);
  R.Right:= R.Left + TW;
  TW:= canvas.TextHeight(Text);
  R.Bottom:= R.Top + TW;
end;

Function DrawTxtRct( Canvas : TCanvas;  R : TRect;
                   Text : string;  Alignment : TAlignment;
                   MoreLines : boolean) : integer;
var BoxWidth, X, AmountLines, counter, TH, Pos : LongInt;
    s : string;
begin
  Result:= 0;
  X:= 0; AmountLines:= 0;
  with Canvas do
  begin
    BoxWidth:= R.Right - R.Left;
    if MoreLines then
    begin
      Pos:= CalcMaxWidth(Canvas, Text);
      BoxWidth:= MaxI(BoxWidth, Pos);
      AmountLines:= CalcAmountLines(Canvas, Text, BoxWidth);
      Result:= AmountLines * TextHeight(Text);
    end
    else Result:= TextHeight(Text);
    TH:= TextHeight(Text);
    Pos:= 1;
    if MoreLines then
    begin
      for counter:= 1 to AmountLines do
      begin
        s:= GiveNextLine(Canvas, Text, BoxWidth, Pos);
        if Alignment = taLeftJustify then X:= R.Left
        else if Alignment = taRightJustify then X:= MaxI(R.Right - TextWidth(s), 0)
        else if Alignment = taCenter then X:= R.Left + round(0.5 * (BoxWidth - TextWidth(s)));
        TextRect(R, X, R.Top + (counter - 1) * TH , s);
      end;
    end
    else
    begin
      if Alignment = taLeftJustify then X:= R.Left
      else if Alignment = taRightJustify then X:= MaxI(R.Right - TextWidth(Text), 0)
      else if Alignment = taCenter then X:= MaxI(R.Left + round(0.5 * (BoxWidth - TextWidth(Text))), 0);
      TextRect(R, X, R.Top, Text);
    end;
  end;
  Result:= R.Bottom;
end;

Function RotateText(Canvas : TCanvas; Xt, Yl, Deg : LongInt; Txt : string;
                    BackColor : tColor; Transparant : boolean) : boolean;
var Bitmap : TBitmap;
    Rec: TRect;
    P1, P5, P6 : TPoint;
    X, Y, W, H : LongInt;
    Angle, Si, Co : double;
begin
  Result:= false;
  Rec:= Rect(0, 0, Canvas.TextWidth(Txt), Canvas.TextHeight(Txt));
  Bitmap:= TBitmap.Create;
  Bitmap.PixelFormat:= pfDevice;
  with Bitmap.Canvas do
  begin
    Font.Assign(Canvas.Font);
    Pen.Assign(Canvas.Pen);
    Brush.Assign(Canvas.Brush);
  end;
  Bitmap.Width:= Rec.Right - Rec.Left;
  Bitmap.Height:= Rec.Bottom - Rec.Top;
  Bitmap.Canvas.Rectangle(0, 0, Bitmap.Width, Bitmap.Height);
  Bitmap.Canvas.TextRect(Rec, 1, 1, Txt);
  Angle:= Deg/180*PI;
  Si:= Sin(Angle); Co:= Cos(Angle);
  W:= Rec.Right - Rec.Left;
  H:= Rec.Bottom - Rec.Top;
  P1.X:= Xt - round(0.5 * W * Co + 0.5 * H * Si);
  P1.Y:= Yl - round(-0.5 * W * Si + 0.5 * H * Co);
  if P1.X < 0 then P1.X:= 0;
  if P1.Y < 0 then P1.Y:= 0;

  for Y:= 0 to Bitmap.Height - 2 do
  begin
    X:= 0;
    P5.X:= P1.X + round(Y * Si); P5.Y:= P1.Y + round(Y * Co);
    for X:= 0 to Bitmap.Width - 1 do
    begin
      P6.X:= P5.X + round(X * Co); P6.Y:= P5.Y - round(X * Si);

      if TransParant and ((Canvas.Pixels[P6.X, P6.Y] = BackColor) or (Canvas.Pixels[P6.X, P6.Y] = Canvas.Brush.Color)) then
        Canvas.Pixels[P6.X, P6.Y]:= Bitmap.Canvas.Pixels[X, Y]
      else if not Transparant then
        Canvas.Pixels[P6.X, P6.Y]:= Bitmap.Canvas.Pixels[X, Y];
    end;
  end;
  Result:= TRUE;
end;

Function GiveNextLine( Canvas : TCanvas;  Text : string;
                       Width : LongInt; var Pos : LongInt) : string;
var LineTst, Wrd : string;
    PosOld : longint;
begin
  Result:= ''; LineTst:= ''; PosOld:= Pos;
  repeat
    Wrd:= NextWord(Text, Pos);
    LineTst:= LineTst + Wrd;
    if Canvas.TextWidth(LineTst) <= Width then
    begin
      if Pos <= Length(Text) then LineTst:= LineTst + ' ';
      Result:= LineTst;
      PosOld:= Pos;
    end;
  until ((PosOld <> Pos) or (Canvas.TextWidth(Result) >= width) or (Pos > Length(Text)));
  Pos:= PosOld;
end;

Function NextWord( Line : string; var Pos : LongInt) : string;
var Ch : string[1];
begin
  Result:= '';
  repeat
    Ch:= Copy(Line, Pos, 1);
    if (Ch <> ' ') then Result:= Result + Ch;
    Inc(Pos);
  until (Ch = ' ') or (Pos > Length(Line));
end;

Function RemInvChars(S : string) : string;
var i : integer;
    C : char;
    invCh : char;
begin
  Result:= '';
  invch:= Char(0);
  i:= 1;
  Repeat
    C:= S[i];
    if C <> invch then Result:= Result + S[i];
    inc(i);
  until ((C = invch) or (i > Length(S)));
end;

Function CalcTextHeight( FontSize, PPIY : integer) : integer;
begin
  {Room for caption : }
  Result:= round(FontSize * PPIY / 72);
end;

Function CalcAmountLines( Canvas : TCanvas;  Text : string; Width : LongInt) : LongInt;
var Pos : LongInt;
    Line, LineTst, Wrd : string;
begin
  Result:= 0; Pos:= 1; Wrd:= '';
  repeat
    Line:= Wrd; LineTst:= Wrd;
    repeat
      Wrd:= NextWord(Text, Pos);
      LineTst:= LineTst + ' ' + Wrd;
      if Canvas.TextWidth(LineTst) <= Width then Line:= LineTst;
    until (Canvas.TextWidth(LineTst) >= Width) or (Pos >= Length(Text));
    Inc(Result);
  until Pos >= length(Text);
  if LineTst <> Line then Inc(Result);
end;

Function CalcAmountLines2(Font : TFont;  Text : string; Width : LongInt) : LongInt;
var Pos : LongInt;
    Line, LineTst, Wrd : string;
    bmp : TBitmap;
begin
  Result:= 0;
  if Width > 0 then
  begin
    bmp:= TBitmap.Create;
    bmp.Canvas.Font.Assign(Font);
    Result:= 0; Pos:= 1; Wrd:= '';
    repeat
      Line:= Wrd; LineTst:= Wrd;
      repeat
        Wrd:= NextWord(Text, Pos);
        LineTst:= LineTst + ' ' + Wrd;
        if bmp.Canvas.TextWidth(LineTst) <= Width then Line:= LineTst;
      until (bmp.Canvas.TextWidth(LineTst) >= Width) or (Pos >= Length(Text));
      Inc(Result);
    until Pos >= length(Text);
    if LineTst <> Line then Inc(Result);
    if Result > 1 then
      bmp.Free
    else
      bmp.Free;
  end;
end;

Function CalcMaxWidth( Canvas : TCanvas;  Text : string) : LongInt;
var Wrd : string;
    Pos : LongInt;
begin
  Result:= 0;
  Pos:= 1;
  while Pos <= Length(Text) do
  begin
    Wrd:= NextWord(Text, Pos);
    if Canvas.TextWidth(Wrd) > Result then Result:= Canvas.TextWidth(Wrd);
  end;
end;

{============================= Brewing functions ==============================}

Function CalcFrac(TpH, pK1, pK2, pK3 : double) : double;
var r1d, r2d, r3d, dd, f1d, f2d, f3d, f4d : double;
begin
  r1d:= Power(10, TpH - pK1);
  r2d:= Power(10, TpH - pK2);
  r3d:= Power(10, TpH - pK3);
  dd:= 1/(1 + r1d + r1d*r2d + r1d*r2d*r3d);
  f1d:= dd;
  f2d:= r1d*dd;
  f3d:= r1d*r2d*dd;
  f4d:= r1d*r2d*r3d*dd;
  Result:= f2d + 2*f3d + 3*f4d;
end;

Function SRMtoEBC(d : double) : double;
begin
  Result:= 1.76506E-10 * Power(d, 4) + 1.54529E-07 * Power(d, 3) - 1.59428E-04 * SQR(d)
           + 2.68837E+00 * d - 1.60040E+00;
  If Result < 0 Then
    Result:= 0;
end;

Function EBCtoSRM(d : Double) : Double;
begin
  Result:= -1.32303E-12 * Power(d, 4) - 0.00000000291515 * Power(d, 3)
           + 0.00000818515 * SQR(d) + 0.372038 * d + 0.596351;
end;

Function EBCtoColor(EBC : double) : TColor;
var SRM : Double;
begin
  SRM:= EBCtoSRM(EBC);
  Result:= SRMtoColor(SRM);
end;

Function SRMtoColor(SRM : double) : TColor;
var i : integer;
    R, G, B : longint;
    Found : boolean;
begin
  R:= 0; G:= 0; B:= 0;
  Found:= false;
  i:= 0;
  while (not found) and (i <= 299) do
  begin
    if SRM <= SRMtoRGB[i, 0] then
    begin
      R:= Round(SRMtoRGB[i, 1]);
      G:= Round(SRMtoRGB[i, 2]);
      B:= Round(SRMtoRGB[i, 3]);
      Found:= TRUE;
    end;
    Inc(i);
  end;
  Result:= RGBtoColor(R, G, B);
end;

Function SGtoPlato(SG : Double) : Double;
begin
//  Result:= -0.0000013437885 * Power(SG*1000, 3) + 0.004067348 * SQR(SG*1000) - 3.8532613 * SG*1000 + 1129.6644;
  if SG > 0.5 then
    Result:= 259 - 259 / SG
  else Result:= 0;
end;

Function PlatoToSG(plato : Double) : Double;
begin
//  Result:= 0.0000006077377 * Power(plato, 3) - 0.00001025564 * SQR(plato) + 0.0040681865 * plato + 1;
  Result:= 1.000;
  if Plato < 259 then Result:= 259 / (259 - plato);
end;

Function SGtoBrix(SG : Double) : Double;
begin
  Result:= SGtoPlato(SG) * Settings.BrixCorrection.Value;
end;

Function BrixToSG(Brix : Double) : Double;
begin
  Result:= 1.000;
  if Settings.BrixCorrection.Value > 0 then
    Result:= PlatoToSG(Brix / Settings.BrixCorrection.Value);
end;

Function BrixToFG(OBrix, FBrix : double) : double;
begin
  Result:= 1.0031 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
           - 0.000000034 * Power(OBrix, 3) + 0.00574 * (FBrix)
           + 0.00003344 * (FBrix * FBrix) + 0.000000086 * Power(FBrix, 3);
end;

Function PlatoToExtract(P : Double) : Double;
begin
  Result:= 0.0061289 + 0.99464 * P + 0.0042888 * SQR(P); //kg/hl
  Result:= 10 * Result; //g/l
  If Result < 0 Then Result:= 0;
end;

Function SGtoExtract(SG : Double) : Double;
begin
  Result:= 10 * (-676.67 * SG + 1286.4 * SQR(SG) - 800.47 * Power(SG, 3) + 190.74 * Power(SG, 4));
end;

Function ExtractToSG(E : Double) : Double;
begin
  Result:= -1.5703394E-14 * Power(E, 4) + 9.2822793E-012 * Power(E, 3) - 0.000000017126328 * Power(E, 2) + 0.00038807583 * E + 1;
end;

Function BrixToRI(Brix : Double) : Double;
begin
  Result:= 1.33302 + 0.001427193 * Brix + 0.000005791157 * SQR(Brix);
end;

Function FtoC(f : double) : double;
begin
  Result:= (f - 32) / 1.8;
end;

Function CtoF(c : double) : double;
begin
   Result:= 1.8 * c + 32 ;
end;

Function RE(SG : Double; Brix : Double) : Double;
var RI : Double;
begin
  RI:= BrixToRI(Brix);
  Result:= 194.5935 + 129800 * SG + RI * (410.8815 * RI - 790.8732);
end;

Function AlcByVol(SG : Double; Brix : Double) : Double;
begin;
  Result:= (277.8851 - 277.4 * SG + 0.9956 * Brix + 0.00523 * SQR(Brix) + 0.000015 * Power(Brix, 3)) * (SG / 0.79);
end;

Function ABVol(OG : Double; FG : Double) : Double;
begin
  Result:= 0;
  if (4.749804 - FG) <> 0 then
    Result:= 486.8693 * (OG - FG) / (4.749804 - FG);
end;

Function ABW(ABVol : Double; FG : Double) : Double;
begin
  Result:= 0;
  if FG > 0 then
    Result:= ABVol * 794 / (1000 * FG);
end;

Function ABW2(FG : Double; Brix : Double) : Double;
var RI : Double;
begin
  RI:= BrixToRI(Brix);
  Result:= 1017.5596 - (0.2774 * FG) + RI * ((937.8135 * RI) - 1805.1228);
end;

Function SGFerm(OBrix : Double; FBrix : Double) : Double;
begin
  Result:= ((1.001843 - 0.002318474 * OBrix - 0.000007775 * SQR(OBrix) - 0.000000034 * Power(OBrix, 3) + 0.00574 * (FBrix) + 0.00003344 * SQR(FBrix)
           + 0.000000086 * Power(FBrix, 3)) + (1.313454) * 0.001) * 1000;
end;

Function RealExtract(FG : Double; Brix : Double) : Double;
var RI : Double;
begin
 RI:= BrixToRI(Brix);
 Result:= 129.8 * FG + 194.5935 + RI * (410.882 * RI - 790.8732);
end;

Function Waterdensity(T : Double) : Double;
begin
  Result:= 1;
  if (1 + 0.01687985 * T) <> 0 then
    Result:= (999.83952 + 16.945176 * T - 0.0079870401 * SQR(T) - 0.000046170461 * Power(T, 3) + 0.00000010556302 * Power(T, 4) - 2.8054253E-10 * Power(T, 5)) / (1 + 0.01687985 * T);
end;

Function pHRoom(pHmash, Tm : double) : double;
begin
  Result:= pHmash + 0.0055 * (Tm - 20);
end;

Function pHMash(pHroom, Tm : double) : double;
begin
  Result:= pHRoom - 0.0055 * (Tm - 20);
end;

Function DwatT(T : double; Tref : Double) : Double;
begin
  Result:= Waterdensity(T) / Waterdensity(Tref);
end;

Function FreezingPoint(SG : Double; FG : Double) : Double;
var SGP : Double;
    AlBV : Double;
    AlBW : Double;
begin
   AlBV:= ABVol(SG, FG);
   AlBW:= ABW(AlBV, FG);
   SGP:= SGtoPlato(SG);
   Result:= -0.42 * AlBW + 0.04 * SGP + 0.2;
end;

Function StarterSize(types : Integer; soort : Double; V : Double; SG : Double;
                       start : Double) : double;

{ types: 0 = simpel, 1 = belucht, 2 = geroerd
  soort: 0 = bovengist, 1 = ondergist
  V: volume te vergisten wort in liters
  SG: startSG te vergisten wort in grammen per l of kilogrammen per liter
  start: aantal gistcellen bij aanvang starter in miljard gistcellen
  StarterSize: benodigde grootte giststarter in liters}

var plato : Double;
    a : Double;
    b : Double;
    f : Double;
    acellen : Double;
begin
  plato:= SGtoPlato(SG);
  If soort = 0 Then
    f:= 0.75
  Else f:= 1.5;

  acellen:= f * plato * V; //benodigd aantal cellen in miljard cellen

  if types = 0 Then
  begin
    a:= 0.8473;
    b:= 85.577;
  end
  else If types = 1 Then
  begin
    a:= 1.02;
    b:= 115;
  end
  else
  begin
    a:= 1.06302;
    b:= 134.78259;
  end;

  a:= a * start + b;
  b:= 0.434;

  b:= 1 / b;
{  a:= Power((1 / a), b);}

  If acellen <= start Then
    Result:= 0
  Else if a <> 0 then
    Result:= Power(acellen/a, b);
end;

Function StarterSize2(types : Integer; Needed : double; start : Double) : double;
{ types: 0 = simpel, 1 = belucht, 2 = geroerd
  Needed: aantal te kweken cellen in miljard
  start: aantal gistcellen bij aanvang starter in miljard gistcellen
  StarterSize: benodigde grootte giststarter in liters}

var a : Double;
    b : Double;
begin
  if types = 0 Then
  begin
    a:= 0.8473;
    b:= 85.577;
  end
  else If types = 1 Then
  begin
    a:= 1.02;
    b:= 115;
  end
  else
  begin
    a:= 1.06302;
    b:= 134.78259;
  end;

  a:= a * start + b;
  b:= 0.434;

  b:= 1 / b;
{  a:= Power((1 / a), b);}

  If needed <= start Then
    Result:= 0
  Else if a <> 0 then
    Result:= Power(needed / a, b);
end;

Function GrowthFactor(types : Integer; V : Double; start : Double) : double;
{ types: 0 = simpel, 1 = belucht, 2 = geroerd
  V: volume van de giststarter, in liters
  start: aantal gistcellen bij aanvang starter, in miljard gistcellen
  Result: groeifactor}

var a : Double;
    b : Double;
begin
  If types = 0 Then
  begin
    a:= 0.8473;
    b:= 85.577;
  end
  Else If types = 1 Then
  begin
    a:= 1.02;
    b:= 115;
  end
  Else
  begin
    a:= 1.06302;
    b:= 134.78259;
  End;

  a:= a * start + b;
  b:= 0.434;

  Result:= a * Power(V, b);
  if (start > 0) then
    Result:= Result / start;
  if Result > 6.1 then Result:= 6.1;
end;

Function AmountCells(types : Integer; V : Double; start : Double) : double;

{ types: 0 = simpel, 1 = belucht, 2 = geroerd
  V: volume van de giststarter, in liters
  start: aantal gistcellen bij aanvang starter, in miljard gistcellen
  Result: aantal cellen na kweken, in miljard gistcellen}

var a : Double;
    b : Double;
begin
  If types = 0 Then
  begin
    a:= 0.8473;
    b:= 85.577;
  end
  Else If types = 1 Then
  begin
    a:= 1.02;
    b:= 115;
  end
  Else
  begin
    a:= 1.06302;
    b:= 134.78259;
  End;

  a:= a * start + b;
  b:= 0.434;

  Result:= a * Power(V, b);
  if (start > 0) and (Result / start > 6.1) then Result:= 6.1 * start;
end;

Function UkRager(kt : Double) : Double;
begin
  If kt = -2 Then
    Result:= 25
  Else If kt = -1 Then
    Result:= 0
  Else If (kt >= 0) And (kt <= 5) Then
    Result:= 5
  Else If kt <= 10 Then
    Result:= 6
  Else If kt <= 15 Then
    Result:= 8
  Else If kt <= 20 Then
    Result:= 10.1
  Else If kt <= 25 Then
    Result:= 12.1
  Else If kt <= 30 Then
    Result:= 15.3
  Else If kt <= 35 Then
    Result:= 18.8
  Else If kt <= 40 Then
    Result:= 22.8
  Else If kt <= 45 Then
    Result:= 26.9
  Else If kt <= 50 Then
    Result:= 28.1
  Else If kt > 50 Then
    Result:= 30
  Else
    Result:= 0;
end;

Function UkGaretz(kt : Double) : Double;
begin
  If kt = -2 Then
    Result:= 20
  Else If kt = -1 Then
    Result:= 0
  Else If (kt >= 0) And (kt <= 10) Then
    Result:= 0
  Else If kt <= 15 Then
    Result:= 2
  Else If kt <= 20 Then
    Result:= 5
  Else If kt <= 25 Then
    Result:= 8
  Else If kt <= 30 Then
    Result:= 11
  Else If kt <= 35 Then
    Result:= 14
  Else If kt <= 40 Then
    Result:= 16
  Else If kt <= 45 Then
    Result:= 18
  Else If kt <= 50 Then
    Result:= 19
  Else If kt <= 60 Then
    Result:= 20
  Else If kt <= 70 Then
    Result:= 21
  Else If kt <= 80 Then
    Result:= 22
  Else If kt > 80 Then
    Result:= 23
  Else
    Result:= 0;
end;

Function UkNoonan(kt : Double) : Double;
begin
  If kt = -2 Then
    Result:= 25
  Else If kt = -1 Then
    Result:= 0
  Else If (kt >= 0) And (kt <= 5) Then
    Result:= 5
  Else If kt <= 15 Then
    Result:= 0.3 * kt + 3.5
  Else If kt <= 60 Then
    Result:= 0.44444 * kt + 1 + 1 / 3
  Else If kt <= 90 Then
    Result:= 0.1 * kt + 22
  Else If kt > 90 Then
    Result:= 31
  Else
    Result:= 0;
end;

Function UkDaniels(kt : Double) : Double;
begin
  If kt = -2 Then
    Result:= 23
  Else If kt = -1 Then
    Result:= 0
  Else If (kt >= 0) And (kt <= 7.5) Then
    Result:= 5
  Else If kt <= 17.5 Then
    Result:= 12
  Else If kt <= 27.5 Then
    Result:= 15
  Else If kt <= 42.5 Then
    Result:= 19
  Else If kt <= 57.5 Then
    Result:= 22
  Else If kt <= 72.5 Then
    Result:= 24
  Else If kt <= 90 Then
    Result:= 27
  Else If kt > 90 Then
    Result:= 27
  Else
    Result:= 0;
end;

Function CalcIbuU(Method : TIBUmethod; SG : Double; Tboil : Double; HopVorm : THopForm;
                  HopUse : THopUse; BNAP : Double) : double;
var Ubt : Double;
    Fbg : Double;
    Fhf : Double;
    Fhu : double;
    Fbp : Double;
    Fst : Double;
    Fhb : Double;
    Fyf : Double;
    Ffil : Double;
begin
  Ubt:= 25;
  Fbg:= 1;
  Fhf:= 1;
  Fhu:= 1;
  Fbp:= 1;
  Fst:= 1;
  Fhb:= 1;
  Fyf:= 1;
  Ffil:= 1;

  Case Method of
  imRager:
  begin
    Ubt:= UkRager(Tboil);
    If SG > 1.050 Then Fbg:= 1 / (1 + 5 * (SG - 1.050));
    Case HopVorm of
    hfLeaf:
      Fhf:= 1;
    hfPlug:
      Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      Fhf:= 1 + Settings.PelletFactor.Value / 100;
    End;
  end;
  imGaretz:
  begin
    Ubt:= UkGaretz(Tboil);
    If SG > 1.050 Then Fbg:= 1 / (1 + 5 * (SG - 1.050));
    Case HopVorm of
    hfLeaf:
      Fhf:= 1;
    hfPlug:
    Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      If (Tboil >= 10) And (Tboil <= 30) Then
        Fhf:= 1 + Settings.PelletFactor.Value / 100;
      Else
        Fhf:= 1;
    End;
  end;
  imMosher:
  begin
    If Tboil = -1 Then
      Ubt:= 0
    Else If Tboil = -2 Then
      Ubt:= 21.23082 * (1 - Exp(-0.028784 * 60))
    Else
      Ubt:= 21.23082 * (1 - Exp(-0.028784 * Tboil));

    Fbg:= 1.0526 * (SG - 40 * SQR(SG - 1));
    Case HopVorm of
    hfLeaf:
      Fhf:= 1;
    hfPlug:
      Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      Fhf:= 1 + Settings.PelletFactor.Value / 100;
    End;
  end;
  imTinseth:
  begin
    If Tboil = -1 Then
      Ubt:= 0
    Else If Tboil = -2 Then
      Ubt:= 25.367715 * (1 - Exp(-0.04 * 60))
    Else
      Ubt:= 25.367715 * (1 - Exp(-0.04 * Tboil));
    Fbg:= 1.5673 * Power(0.000125, (SG - 1));
    Case HopVorm of
    hfPlug:
      Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      Fhf:= 1 + Settings.PelletFactor.Value / 100;
    End;
  end;
  imNoonan:
  begin
    Ubt:= UkNoonan(Tboil);
    If SG > 1.050 Then
      Fbg:= 1 / (1 + 5 * (SG - 1.050));
    Case HopVorm of
    hfLeaf:
      Fhf:= 1;
    hfPlug:
      Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      Fhf:= 1 + Settings.PelletFactor.Value / 100;
    End;
  end;
  imDaniels:
  begin
    Ubt:= UkDaniels(Tboil);
    If SG > 1.050 Then
      Fbg:= 1 / (1 + 5 * (SG - 1.050));
    Case HopVorm of
    hfLeaf:
      Fhf:= 1;
    hfPlug:
      Fhf:= 1 + Settings.PlugFactor.Value / 100;
    hfPellet:
      Fhf:= 1 + Settings.PelletFactor.Value / 100;
    End;
  end;
  end;

  case HopUse of
  huBoil: Fhu:= 1.0;
  huAroma: Fhu:= 1.0; //vlamuit
  huDryhop: Fhu:= 0.0;
  huMash: Fhu:= 1 + Settings.MashHopFactor.Value / 100;
  huFirstWort: FHu:= 1 + Settings.FWHFactor.Value / 100;
  end;

  Fbp:= 1 / (1 + (BNAP / 0.3048) / 27500);

  Result:= (Ubt * Fbg * Fhf * Fhu * Fbp * Fst * Fhb * Fyf * Ffil) / 100;
end;

Function CalcIBU(Method : TIBUmethod; HopUse : THopUse; AA : Double; AM : Double; Vw : Double;
                 Vf : Double; SG : Double; Tboil : Double; HopVorm : THopForm;
                 BNAP : Double) : Double;
var IBUi : Double;
    U : Double;
    a : Double;
    b : Double;
    c : Double;
begin
  U:= 1;
  if Vf > 0 then IBUi:= 10 * AM * AA / Vf
  else IBUi:= 0;

  U:= CalcIBUU(Method, SG, Tboil, HopVorm, HopUse, BNAP);

 { If (Method = imGaretz) Or (Method = imDaniels) Then
  begin
    a:= Vf / (260 * Vw);
    b:= 1;
    c:= -IBUi * U;

    Result:= (-b + Sqrt(SQR(b) - 4 * a * c)) / (2 * a);
  end
  Else }
     Result:= IBUi * U;
end;

Function AmHop(Method : TIBUmethod; HopUse : THopUse; AA : Double; IBU : Double; Vw : double; Vf : Double; SG : Double;
               Tboil : Double; HopVorm : THopForm; BNAP : Double) : Double;
var U : Double;
begin
  Result:= 0;
  U:= CalcIBUU(Method, SG, Tboil, HopVorm, HopUse, BNAP);

  if (U > 0) and (AA > 0) then
    Result:= (Vf * IBU) / (10 * AA * U)
end;

Function IonBalance(Ca, Mg, Na, Cl, SO4, HCO3 : double) : double;
var MCa, MMg, MNa, MCl, MSO4, MHCO3 : double;
begin
  MCa:= Ca / MMCa;
  MMg:= Mg / MMMg;
  MNa:= Na / MMNa;
  MCl:= Cl / MMCl;
  MSO4:= SO4 / MMSO4;
  MHCO3:= HCO3 / MMHCO3;

  Result:= 2 * MCa + 2 * MMg + MNa - MCl - 2 * MSO4 - MHCO3;
end;

Function CarbStoCO2(S : double; T : double; SFactor : double) : double;
begin
  Result:= 0;
  if SFactor > 0 then
    Result:= 0.286 * S / SFactor + 0.000849151 * T * T - 0.0587512 * T + 1.71137;
end;

Function CarbCO2toS(CO2 : double; T : double; SFactor : double) : double;
begin
  Result:= SFactor * (CO2 - (0.000849151 * T * T - 0.0587512 * T + 1.71137)) / 0.286;
end;

Function CarbCO2toPressure(CO2 : double; T : double) : double;
begin
  Result:= (CO2 - (-0.000005594056 * Power(T, 4) + 0.000144357886 * Power(T, 3)
              + 0.000362999168 * T * T - 0.064872987645 * T + 1.641145175049))
           / (0.00000498031 * Power(T, 4) - 0.00024358267 * Power(T, 3)
              + 0.00385867329 * T * T - 0.05671206825 * T + 1.53801423376);
end;

Function CarbPressuretoCO2(P : double; T : double) : double;
begin
  Result:= P * (0.00000498031 * Power(T, 4) - 0.00024358267 * Power(T, 3)
              + 0.00385867329 * T * T - 0.05671206825 * T + 1.53801423376) +
              (-0.000005594056 * Power(T, 4) + 0.000144357886 * Power(T, 3)
              + 0.000362999168 * T * T - 0.064872987645 * T + 1.641145175049);
end;

Function ActualIBU(origibu, HSI, Temp : double; Elapsed, storagetype : longint) : double;
var iTemp, iType, e : double;
begin
  iTemp:= 0.396865 * EXP(0.046221 * Temp);
  case storagetype of
  0: iType:= 1;
  1: iType:= 0.75;
  else iType:= 0.5;
  end;
  e:= 2 * (Elapsed / 365.25) * iTemp * iType; //years
  Result:= origibu * Power(1 - HSI/100, e);
end;

Function ZipFiles(l : TStringList; zipfn : string) : boolean;
var i : integer;
    Zipper: TZipper;
begin
  Result:= false;
  if (l <> NIL) and (l.Count > 0) then
  begin
    Zipper := TZipper.Create;
    try
      Zipper.FileName := zipfn;
      for I := 1 to l.Count - 1 do
        Zipper.Entries.AddFileEntry(l.Strings[i], zipfn);
      Zipper.ZipAllFiles;
      Result:= TRUE;
    finally
      Zipper.Free;
    end;
  end;
end;

Function UnZipFiles(zipfn, outpath : string) : boolean;
var i : integer;
    Zipper: TUnZipper;
begin
  Result:= false;
  Zipper := TUnZipper.Create;
  try
    Zipper.FileName := zipfn;
    Zipper.OutputPath := outpath;
    Zipper.Examine;
    Zipper.UnZipAllFiles;
    Result:= TRUE;
  finally
    Zipper.Free;
  end;
end;

{Procedure SetFontHeight(F : TForm; fs : integer);
var i : integer;
begin
  if F <> NIL then
  begin
    F.Font.Height:= fs;
    for i:= 0 to F.ControlCount - 1 do
    begin
      F.Controls[i].Font.Height:= fs;
      F.Repaint;
    end;
  end;
end;}

Procedure PlayStartProg;
var sound : TProcess;
begin
//  {$ifdef linux}
//  AlSourcePlay(source[startprog]);
//  {$endif}
  {$ifdef darwin}
  sound:= TProcess.Create(NIL);
  sound.CommandLine:= 'afplay ' + StartSound;
  sound.Execute;
  sound.Free;
  {$endif}
  {$ifdef windows}
  Application.ProcessMessages;
  sndPlaySound(PChar(StartSound), snd_Async or snd_NoDefault);//snd_Async or snd_NoDefault);
  Application.ProcessMessages;
  {$endif}
end;

Procedure PlayWarning;
var sound : TProcess;
begin
//  {$ifdef linux}
//  AlSourcePlay(source[warning]);
//  {$endif}
  {$ifdef darwin}
  sound:= TProcess.Create(NIL);
  sound.CommandLine:= 'afplay ' + StartSound;
  sound.Execute;
  sound.Free;
  {$endif}
  {$ifdef windows}
  Application.ProcessMessages;
  sndPlaySound(PChar(WarningSound), snd_Async or snd_NoDefault);//snd_Async or snd_NoDefault);
  Application.ProcessMessages;
  {$endif}
end;

Procedure PlayAlarm;
var sound : TProcess;
begin
//  {$ifdef linux}
//  AlSourcePlay(source[alarm]);
//  {$endif}
  {$ifdef darwub}
  sound:= TProcess.Create(NIL);
  sound.CommandLine:= 'afplay ' + StartSound;
  sound.Execute;
  sound.Free;
  {$endif}
  {$ifdef windows}
  Application.ProcessMessages;
  sndPlaySound(PChar(AlarmSound), snd_Async or snd_NoDefault);//snd_Async or snd_NoDefault);
  Application.ProcessMessages;
  {$endif}
end;

Procedure PlayEndProg;
var sound : TProcess;
begin
//  {$ifdef linux}
//  AlSourcePlay(source[endprog]);
//  {$endif}
  {$ifdef darwin}
  sound:= TProcess.Create(NIL);
  sound.CommandLine:= 'afplay ' + StartSound;
  sound.Execute;
  sound.Free;
  {$endif}
  {$ifdef windows}
  Application.ProcessMessages;
  sndPlaySound(PChar(EndSound), snd_Async or snd_NoDefault);//snd_Async or snd_NoDefault);
  Application.ProcessMessages;
  {$endif}
end;

Procedure Log(s : string);
const fn = 'brewbuddy.log';
var fnp : string;
begin
  if (slLog <> NIL) and DoLog then
  begin
    slLog.Add(s);
    try
      fnp:= Settings.DataLocation.Value + fn;
      slLog.SaveToFile(fnp);
    except
      ShowMessage('Fout bij schrijven van logbestand');
    end;
  end;
end;

Initialization
  MaxGrowthFactor:= 6.1;

  AmCellspGramDry:=  15000000000; //8695652173; //20000000000 according to MrMalty
  AmCellspPack:=   100000000000;
  AmCellspMlSlurry:= 1700000000;

  SpecificHeats[0].Material:= 'Aluminium';
  SpecificHeats[0].SpecificHeat:= 0.22; //cal/g.°C
  SpecificHeats[1].Material:= 'Koper';
  SpecificHeats[1].SpecificHeat:= 0.092; //cal/g.°C
  SpecificHeats[2].Material:= 'Kunststof';
  SpecificHeats[2].SpecificHeat:= 0.46; //cal/g.°C
  SpecificHeats[3].Material:= 'RVS';
  SpecificHeats[3].SpecificHeat:= 0.11; //cal/g.°C

  EndChar:= ['a', 'e', 'i', 'o', 'u', 's'];

  if not DirectoryExists(Settings.DataLocation.Value) then
    if not CreateDir(Settings.DataLocation.Value) then ShowMessage('Data folder could not be created.');

  FermentableColor:= RGBtoColor(250, 195, 65);
  HopColor:= RGBtoColor(100, 250, 65);
  MiscColor:= RGBtoColor(240, 250, 65);
  WaterAgentColor:= RGBtoColor(240, 140, 130);
  FiningColor:= RGBtoColor(95, 180, 25);
  YeastColor:= RGBtoColor(175, 175, 255);
  WaterColor:= RGBtoColor(120, 255, 250);

  AlarmSound:= SoundFolder + 'alarm.wav';
  StartSound:= SoundFolder + 'welcome.wav';
  EndSound:= SoundFolder + 'end.wav';
  WarningSound:= SoundFolder + 'warning.wav';

//  {$ifdef linux}
//  //Initialize the sound system
//  InitOpenAL;
//  AlutInit(nil,argv);
//  alGenBuffers(numbuffers, buffer);
//  alGenSources(numsources, source);

//  AlutLoadWavFile(StartSound, format, dat, size, freq, loop);
//  AlBufferData(buffer[startprog], format, dat, size, freq);
//  AlutUnloadWav(format, dat, size, freq);

//  AlutLoadWavFile(WarningSound, format, dat, size, freq, loop);
//  AlBufferData(buffer[warning], format, dat, size, freq);
//  AlutUnloadWav(format, dat, size, freq);

//  AlutLoadWavFile(AlarmSound, format, dat, size, freq, loop);
//  AlBufferData(buffer[alarm], format, dat, size, freq);
//  AlutUnloadWav(format, dat, size, freq);

//  AlutLoadWavFile(EndSound, format, dat, size, freq, loop);
//  AlBufferData(buffer[endprog], format, dat, size, freq);
//  AlutUnloadWav(format, dat, size, freq);

//  AlSourcei( source[startprog], AL_BUFFER, buffer[startprog]);
//  AlSourcef( source[startprog], AL_PITCH, 1.0 );
//  AlSourcef( source[startprog], AL_GAIN, 1.0 );
//  AlSourcefv( source[startprog], AL_POSITION, @sourcepos);
//  AlSourcefv( source[startprog], AL_VELOCITY, @sourcevel);
//  AlSourcei( source[startprog], AL_LOOPING, loop);

//  AlSourcei( source[warning], AL_BUFFER, buffer[warning]);
//  AlSourcef( source[warning], AL_PITCH, 1.0 );
//  AlSourcef( source[warning], AL_GAIN, 1.0 );
//  AlSourcefv( source[warning], AL_POSITION, @sourcepos);
//  AlSourcefv( source[warning], AL_VELOCITY, @sourcevel);
//  AlSourcei( source[warning], AL_LOOPING, loop);

//  AlSourcei( source[alarm], AL_BUFFER, buffer[alarm]);
//  AlSourcef( source[alarm], AL_PITCH, 1.0 );
//  AlSourcef( source[alarm], AL_GAIN, 1.0 );
//  AlSourcefv( source[alarm], AL_POSITION, @sourcepos);
//  AlSourcefv( source[alarm], AL_VELOCITY, @sourcevel);
//  AlSourcei( source[alarm], AL_LOOPING, loop);

//  AlSourcei( source[endprog], AL_BUFFER, buffer[endprog]);
//  AlSourcef( source[endprog], AL_PITCH, 1.0 );
//  AlSourcef( source[endprog], AL_GAIN, 1.0 );
//  AlSourcefv( source[endprog], AL_POSITION, @sourcepos);
//  AlSourcefv( source[endprog], AL_VELOCITY, @sourcevel);
//  AlSourcei( source[endprog], AL_LOOPING, loop);

//  AlListenerfv( AL_POSITION, @listenerpos);
//  AlListenerfv( AL_VELOCITY, @listenervel);
//  AlListenerfv( AL_ORIENTATION, @listenerori);
//  {$endif}

finalization
//  {$ifdef linux}
//Terminate the sound system
//  Log('');
//  Log('HULPFUNCTIES');
//  AlDeleteBuffers(1, @buffer);
//  Log('alBuffers afgesloten');
//  AlDeleteSources(1, @source);
//  Log('alSources afgesloten');
//  AlutExit();
//  Log('Sound system afgesloten');
//  {$endif}
    {$ifdef linux}
    Log('');
    {$endif}
end.
