unit PromashImport;

{$MODE Delphi}

{H+}

interface

uses
  Classes, SysUtils, Math, Graphics, Data;

Type
  TStylePrm = record
    Name : string;
    SubstyleName : string;
    OrigMinSG : single;
    OrigMaxSG : single;
    FinalMinSG : single;
    FinalMaxSG : single;
    MinPercentAlcohol : single;
    MaxPercentAlcohol : single;
    MinIBU : single;
    MaxIBU : single;
    MinClr : single;
    MaxClr : single;
    ColorNote : string;
    MaltNote : string;
    HopNote : string;
    YeastNote : string;
    Examples : string;
    Category : string;
    SubCatLetter : string;
    StyleType : byte;
  end;

  THopPrm = record
    Name : string;
    AlphaDatabase : single;
    Alpha : single;
    Beta : single;
    IsNoble : boolean;
    Cohumulene : single;
    Myrcene : single;
    Humulene : single;
    Carophyllene : single;
    Usage : byte;
    Form : integer;
    StorageFactor : single;
    Description : string;
    Origin : string;
    Use : string;
    Substitutes : string;
    Amount : single;
    Time : byte;
    IBUcontribution : single;
  end;

  TMaltPrm = record
    Name : string;
    Manufacturer : string;
    Origin : string;
    MaltType : byte;
    MaltType2 : byte;
    PPPG : single;
    Color : single;
    Moisture : single;
    Max : single;
    DiastaticPower : single;
    Protein : single;
    TSN : single;
    Use : string;
    Comments : string;
    Amount : single;
    FGDry : single;
    CGDry : single;
  end;

  TExtraPrm = record
    Name : string;
    ExtraType : integer;
    Time : LongWord;
    Use : byte;
    TimeUnit : byte;
    ExtraUnit : integer;
    Amount : single;
    Usage : string;
    Comment : string;
  end;

  TYeastPrm = record
    Name : string;
    Lab : string;
    CatalogNum : string;
    YeastType : byte;
    Medium : byte;
    Flavour : string;
    Comment : string;
    Quantity : single;
    LoAtt : LongWord;
    HiAtt : LongWord;
    Temp : single;
    Flocc: byte;
  end;

  TWaterPrm = record
    Name : string;
    Ca : single;
    Mg : single;
    Na : single;
    Unknown : single;
    SO4 : single;
    Cl : single;
    HCO3 : single;
    pH : single;
    KnownAs : string;
  end;

  TMashSchedule = record
    MashType : byte;
    Unknown1 : single;
    Unknown2 : single;
    AcidTemp : LongWord;
    AcidTime : LongWord;
    ProteinTemp : LongWord;
    ProteinTime : LongWord;
    InterTemp : LongWord;
    InterTime : LongWord;
    SaccTemp : LongWord;
    SaccTime : LongWord;
    MashOutTemp : LongWord;
    MashOutTime : LongWord;
    SpargeTemp : LongWord;
    SpargeTime : LongWord;
    MashQTS : single;
    Unknown3 : byte;
  end;

  TMashStepsCustomAmountPrm = record
    Amount : byte;
    Name : string;
    GrainTemp : LongInt;
  end;

  TMashStepCustomPrm = record
    Name : string;
    HeatType : byte;
    StartTemp : longint;
    EndTemp : longint;
    InfusionTemp : longint;
    RestTime : longint;
    StepTime : longint;
    InfuseRatio : single;
    InfuseAmount : single;
    StepUpTimeClr : Longint;
    RestTimeClr : longint;
  end;

  TNotesPrm = record
    Notes : string;
    Awards : string;
  end;

  TRecipePrm = record
    Name : string;
    HopCount : longint;
    MaltCount : longint;
    ExtraCount : longint;
    BatchSize : single;
    WortSize : single;
    Efficiency : single;
    BoilTime : LongWord;
    RecipeType : byte;
  end;

  TPromash = class(TComponent)
   private
   protected
     FOpened : boolean;
     FFileName : string;
     FRecipe : TRecipePrm;
     FStyle : TStylePrm;
     FYeast : TYeastPrm;
     FNotes : TNotesPrm;
     FWater : TWaterPrm;
     FMashStepsCustomAmount : TMashStepsCustomAmountPrm;
     FMalts : array of TMaltPrm;
     FHops : array of THopPrm;
     FExtras : array of TExtraPrm;
     FMashSchedule : TMashSchedule;
     FMashStepsCustom : array of TMashStepCustomPrm;
     Function GetRecipeName : string;
     Function GetBatchSize : single;
     Function GetWortSize : single;
     Function GetRecipeTypeName : string;
     {Function GetMalt(i : integer) : TMaltPrm;
     Function GetExtra(i : integer) : TExtraPrm;
     Function GetHop(i : integer) : THopPrm;
     Function GetMashStep(i : integer) : TMashStepSimplePrm;
     Function GetMashStepCustom(i : integer) : TMashStepCustomPrm;}

     Function GetStyleOriginMinSG : single;
     Function GetStyleOriginMaxSG : single;
     Function GetStyleMinClr : single;
     Function GetStyleMaxClr : single;
     Function GetStyleTypeName : string;

     Function GetMaltName(i : integer) : string;
     Function GetMaltManufacturer(i : integer) : string;
     Function GetMaltOrigin(i : integer) : string;
     Function GetMaltType(i : integer) : byte;
     Function GetMaltTypeName(i : integer) : string;
     Function GetMaltType2(i : integer) : byte;
     Function GetMaltType2Name(i : integer) : string;
     Function GetMaltYield(i : integer) : single;
     Function GetMaltPPPG(i : integer) : single;
     Function GetMaltColor(i : integer) : single;
     Function GetMaltMoisture(i : integer) : single;
     Function GetMaltMax(i : integer) : single;
     Function GetMaltDiastaticPower(i : integer) : single;
     Function GetMaltProtein(i : integer) : single;
     Function GetMaltTSN(i : integer) : single;
     Function GetMaltUse(i : integer) : string;
     Function GetMaltComments(i : integer) : string;
     Function GetMaltAmount(i : integer) : single;
     Function GetMaltFGDry(i : integer) : single;
     Function GetMaltCGDry(i : integer) : single;

     Function GetHopName(i : integer) : string;
     Function GetHopAlpha(i : integer) : single;
     Function GetHopAlphaDatabase(i : integer) : single;
     Function GetHopBeta(i : integer) : single;
     Function GetHopIsNoble(i : integer) : boolean;
     Function GetHopCohumulene(i : integer) : single;
     Function GetHopMyrcene(i : integer) : single;
     Function GetHopHumulene(i : integer) : single;
     Function GetHopCarophyllene(i : integer) : single;
     Function GetHopUsage(i : integer) : byte;
     Function GetHopUsageName(i : integer) : string;
     Function GetHopForm(i : integer) : byte;
     Function GetHopFormName(i : integer) : string;
     Function GetHopStorageFactor(i : integer) : single;
     Function GetHopDescription(i : integer) : string;
     Function GetHopOrigin(i : integer) : string;
     Function GetHopUse(i : integer) : string;
     Function GetHopSubstitutes(i : integer) : string;
     Function GetHopTime(i : integer) : integer;
     Function GetHopTimeDescription(i : integer) : string;
     Function GetHopAmount(i : integer) : single;
     Function GetHopIBUContribution(i : integer) : single;

     Function GetExtraName(i : integer) : string;
     Function GetExtraType(i : integer) : integer;
     Function GetExtraTypeName(i : integer) : string;
     Function GetExtraTime(i : integer) : LongWord;
     Function GetExtraAddition(i : integer) : integer;
     Function GetExtraAdditionName(i : integer) : string;
     Function GetExtraTimeUnit(i : integer) : byte;
     Function GetExtraTimeUnitName(i : integer) : string;
     Function GetExtraUnit(i : integer) : integer;
     Function GetExtraUnitName(i : integer) : string;
     Function GetExtraAmount(i : integer) : single;
     Function GetExtraUsage(i : integer) : string;
     Function GetExtraComments(i : integer) : string;

     Function GetYeastTypeName : string;
     Function GetYeastMediumName : string;
     Function GetYeastQuantity : single;
     Function GetYeastTemp : single;
     Function GetYeastFloccName : string;

{     Function GetWaterCa : single;
     Function GetWaterMg : single;
     Function GetWaterNa : single;
     Function GetWaterSO4 : single;
     Function GetWaterCl : single;
     Function GetWaterHCO3 : single;
     Function GetWaterKnownAs : string; }

     Function GetMashTypeName : string;
     Function GetAcidTemp : LongWord;
     Function GetProteinTemp : LongWord;
     Function GetInterTemp : LongWord;
     Function GetSaccTemp : LongWord;
     Function GetMashoutTemp : LongWord;
     Function GetSpargeTemp : LongWord;
     Function GetMashVolume : single;
     Function GetMashStepsCustomGrainTemp : single;

     Function GetMashStepCustomName(i : integer) : string;
     Function GetMashStepCustomHeatType(i : integer) : byte;
     Function GetMashStepCustomHeatTypeName(i : integer) : string;
     Function GetMashStepCustomStartTemp(i : integer) : longint;
     Function GetMashStepCustomEndTemp(i : integer) : longint;
     Function GetMashStepCustomInfusionTemp(i : integer) : longint;
     Function GetMashStepCustomRestTime(i : integer) : longint;
     Function GetMashStepCustomStepTime(i : integer) : longint;
     Function GetMashStepCustomInfuseRatio(i : integer) : single;
     Function GetMashStepCustomInfuseAmount(i : integer) : single;
     Function GetMashStepCustomStepUpTimeClr(i : integer) : TColor;
     Function GetMashStepCustomRestTimeClr(i : integer) : TColor;
   public
     Constructor Create(AOwner : TComponent); override;
     Destructor Destroy; override;
     Function OpenReadRec(FN : string) : boolean;
     Procedure Clear;
     Function Convert(R : TRecipe) : boolean;
  //   Function WriteRec : boolean;
     {property Malt[i : integer] : TMaltPrm read GetMalt;
     property Extra[i : integer] : TExtraPrm read GetExtra;
     property Hop[i : integer] : THopPrm read GetHop;
     property MashStep[i : integer] : TMashStepSimplePrm read GetMashStep;
     property MashStepCustom[i : integer] : TMashStepCustomPrm read GetMashStepCustom;}
     property MaltName[i : integer] : string read GetMaltName;                  //Name of the fermentable
     property MaltManufacturer[i : integer] : string read GetMaltManufacturer;  //Manufacturer of the fermentable
     property MaltOrigin[i : integer] : string read GetMaltOrigin;              //Origin of the fermentable (country)
     property MaltType[i : integer] : byte read GetMaltType;                    //Type: 1 = grain, 2 = Extract, 3 = Sugar, 4 = other
     property MaltTypeName[i : integer] : string read GetMaltTypeName;          //Description of the type
     property MaltType2[i : integer] : byte read GetMaltType2;                  //Extract: 0 = LME, 1 = DME; graan/suiker: 0 = Mustmash = no, 1 Mustmash = yes; other: ignored
     property MaltType2Name[i : integer] : string read GetMaltType2Name;        //Description of the second type
     property MaltYield[i : integer] : single read GetMaltYield;                //Yield in mass-% (kg extract per kg malt)
     property MaltPPPG[i : integer] : single read GetMaltPPPG;                  //Yield in SG per pound per gallon
     property MaltColor[i : integer] : single read GetMaltColor;                //Color in EBC
     property MaltMoisture[i : integer] : single read GetMaltMoisture;          //Typical moisture content
     property MaltMax[i : integer] : single read GetMaltMax;                    //Maximum amount in total grist
     property MaltDiastaticPower[i : integer] : single read GetMaltDiastaticPower; //Diastatic power
     property MaltProtein[i : integer] : single read GetMaltProtein;            //Protein content in mass-%.
     property MaltTSN[i : integer] : single read GetMaltTSN;                    //Total soluble nitrogen content in mass-%
     property MaltUse[i : integer] : string read GetMaltUse;                    //Use of the malt (description)
     property MaltComments[i : integer] : string read GetMaltComments;          //Comments
     property MaltAmount[i : integer] : single read GetMaltAmount;              //Amount of fermentable in the grist in kg
     property MaltFGDry[i : integer] : single read GetMaltFGDry;                //Yield fine grist on dry basis
     property MaltCGDry[i : integer] : single read GetMaltCGDry;                //Yield corse grist on dry basis

     property HopName[i : integer] : string read GetHopName;                    //Name of the hop
     property HopAlpha[i : integer] : single read GetHopAlpha;                  //Actual alpha-acid content of hop in mass-%
     property HopAlphaDatabase[i : integer] : single read GetHopAlphaDatabase;  //Alpha-acid content of hop as listed in the hop-database in mass-%
     property HopBeta[i : integer] : single read GetHopBeta;                    //Beta-acid content of hop in mass-%
     property HopIsNoble[i : integer] : boolean read GetHopIsNoble;             //Is hop a noble hop? (boolean: yes-no)
     property HopCohumulene[i : integer] : single read GetHopCohumulene;        //Cohumulene content of hop in mass-% of alpha-acids
     property HopMyrcene[i : integer] : single read GetHopMyrcene;              //Myrcene content of hop in mass-% of alpha-acids
     property HopHumulene[i : integer] : single read GetHopHumulene;            //Humulene content of hop in mass-% of alpha-acids
     property HopCarophyllene[i : integer] : single read GetHopCarophyllene;    //Carophyllene content of hop in mass-% of alpha-acids
     property HopUsage[i : integer] : byte read GetHopUsage;                    //Usage of the hop: 1 = bittering, 2 = aroma, 3 = both
     property HopUsageName[i : integer] : string read GetHopUsageName;          //Description of the usage of the hop
     property HopForm[i : integer] : byte read GetHopForm;                      //Form of the hop: 3: flowers, 19: plugs, 35: pellets
     property HopFormName[i : integer] : string read GetHopFormName;            //Description of the form of the hops
     property HopStorageFactor[i : integer] : single read GetHopStorageFactor;  //Storage factor
     property HopDescription[i : integer] : string read GetHopDescription;      //Description of the hop
     property HopOrigin[i : integer] : string read GetHopOrigin;                //Origin of the hop (country)
     property HopUse[i : integer] : string read GetHopUse;                      //Typical use of the hop
     property HopSubstitutes[i : integer] : string read GetHopSubstitutes;      //Substitutes for the hop
     property HopTime[i : integer] : integer read GetHopTime;                   //Time in the boil. If time = boiltime + 2 then mash hop, if time = boiltime + 1 then First Wort Hop, if time = -1 then dry hop.
     property HopTimeDescription[i : integer] : string read GetHopTimeDescription; //Description of boil time (maish hop, eerste wort hop, bitterhop, smaakhop, aromahop, koudhop)
     property HopAmount[i : integer] : single read GetHopAmount;                //Amount of hop added in gram
     property HopIBUContribution[i : integer] : single read GetHopIBUContribution; //Contribution of this hop gift to total bitterness in IBU

     property ExtraName[i : integer] : string read GetExtraName;                //Name of the extra ingredient
     property ExtraType[i : integer] : integer read GetExtraType;               //Type of the extra ingredient: 0 = specerij, 1 = fruit, 2 = koffie, 3 = anders, 4 = klaringsmiddel, 5 = kruid
     property ExtraTypeName[i : integer] : string read GetExtraTypeName;        //Descrition of the type
     property ExtraTime[i : integer] : LongWord read GetExtraTime;              //Time according to use and time unit (see below)
     property ExtraAddition[i : integer] : integer read GetExtraAddition;       //Type of addition: 0 = in the boil, 1 = during fermentation, 2 = during mashing
     property ExtraAdditionName[i : integer] : string read GetExtraAdditionName;//Description of type of addition
     property ExtraTimeUnit[i : integer] : byte read GetExtraTimeUnit;          //Time unit : 0 = minutes, 1 = days
     property ExtraTimeUnitName[i : integer] : string read GetExtraTimeUnitName;//Description of time unit
     property ExtraUnit[i : integer] : integer read GetExtraUnit;               //Unit of quantity of addition
     property ExtraUnitName[i : integer] : string read GetExtraUnitName;        //Description of unit
     property ExtraAmount[i : integer] : single read GetExtraAmount;            //Quantity of addition in gram or number
     property ExtraUsage[i : integer] : string read GetExtraUsage;              //Typical usage of the extra ingredient
     property ExtraComments[i : integer] : string read GetExtraComments;        //Comments

     property MashStepCustomName[i : integer] : string read GetMashStepCustomName;              //Name of custom mash step
     property MashStepCustomHeatType[i : integer] : byte read GetMashStepCustomHeatType;            //Heat type of step: 0 = Infusie, 1 = Directe verwarming, 2 = Decoctie
     property MashStepCustomHeatTypeName[i : integer] : string read GetMashStepCustomHeatTypeName;  //Description of heat type
     property MashStepCustomStartTemp[i : integer] : longint read GetMashStepCustomStartTemp;       //Start temperature of mash step in deg. C
     property MashStepCustomEndTemp[i : integer] : longint read GetMashStepCustomEndTemp;           //End temperature of mash step in deg. C
     property MashStepCustomInfusionTemp[i : integer] : longint read GetMashStepCustomInfusionTemp; //Temperature of infusion water in deg. C
     property MashStepCustomRestTime[i : integer] : longint read GetMashStepCustomRestTime;         //Duration of the rest in minutes
     property MashStepCustomStepTime[i : integer] : longint read GetMashStepCustomStepTime;         //Time needed to reach the rest temperature in minutes
     property MashStepCustomInfuseRatio[i : integer] : single read GetMashStepCustomInfuseRatio;    //Infuse ratio in liters/liters
     property MashStepCustomInfuseAmount[i : integer] : single read GetMashStepCustomInfuseAmount;  //Infuse amount in liters
     property MashStepCustomStepUpTimeClr[i : integer] : TColor read GetMashStepCustomStepUpTimeClr;//Color of step time in the mash graph
     property MashStepCustomRestTimeClr[i : integer] : TColor read GetMashStepCustomRestTimeClr;    //Color of the rest time in the mash graph

    { property Recipe : TRecipePrm read FRecipe;
     property Style : TStylePrm read FStyle;
     property Yeast : TYeastPrm read FYeast;
     property Water : TWaterPrm read FWater;
     property UnKnown : TUnknownPrm read FUnKnown;
     property Mash : TMashPrm read FMash;
     property Sparge : TSpargePrm read FSparge;
     property Notes : TNotesPrm read FNotes;
     property OtherStuff : TOtherStuffPrm read FOtherStuff; }
   published
     property FileName : string read FFileName;                 //Name of the file including path
     property Opened : boolean read FOpened;                    //Has the file been opened succesfully?
     property RecipeName : string read FRecipe.Name;            //Name of the recipe
     property HopCount : longint read FRecipe.HopCount;         //Number of hop additions
     property MaltCount : longint read FRecipe.MaltCount;       //Number of fermentables
     property ExtraCount : longint read FRecipe.ExtraCount;     //Number of extra ingredients
     property Efficiency : single read FRecipe.Efficiency;      //Brew house efficiency in %
     property BatchSize : single read GetBatchSize;             //Batch size in liters
     property WortSize : single read GetWortSize;               //Wort size in liters
     property BoilTime : LongWord read FRecipe.BoilTime;        //Total boil time in minutes
     property RecipeType : byte read FRecipe.RecipeType;        //Recipe type: 1 = All grain, 2 = Partial Mash, 3 = Extract
     property RecipeTypeName : string read GetRecipeTypeName;   //Description of recipe type

     property StyleName : string read FStyle.Name;                           //Name of the beer style
     property SubStyleName : string read FStyle.SubStyleName;                //Substyle description
     property StyleOriginMinSG : single read GetStyleOriginMinSG;            //Minimum original gravity for the style in SG
     property StyleOriginMaxSG : single read GetStyleOriginMaxSG;            //Maximum original gravity for the style in SG
     property StyleMinPercentAlcohol : single read FStyle.MinPercentAlcohol; //Minimum alcohol percentage in volume-%
     property StyleMaxPercentAlcohol : single read FStyle.MaxPercentAlcohol; //Maximum alcohol percentage in volume-%
     property StyleMinIBU : single read FStyle.MinIBU;                       //Minimum bitterness in IBU
     property StyleMaxIBU : single read FStyle.MaxIBU;                       //Maximum bitterness in IBU
     property StyleMinClr : single read GetStyleMinClr;                      //Minimum color in SRM
     property StyleMaxClr : single read GetStyleMaxClr;                      //Maximum color in SRM
     property StyleColorNote : string read FStyle.ColorNote;                 //Color note
     property StyleMaltNote : string read FStyle.MaltNote;                   //Malt note
     property StyleHopNote : string read FStyle.HopNote;                     //Hop note
     property StyleYeastNote : string read FStyle.YeastNote;                 //Yeast note
     property StyleExamples : string read FStyle.Examples;                   //Examples of the style
     property StyleCatNr : string read FStyle.Category;                      //Category of the style
     property StyleSubCatLetter : string read FStyle.SubCatLetter;           //Subcategory letter
     property StyleType : byte read FStyle.StyleType;                        //Style type: 1 = Ale, 2 = Lager, 3 = Ale/Lager Mixed, 4 = Cider, 5 = Mead
     property StyleTypeName : string read GetStyleTypeName;

     property YeastName : string read FYeast.Name;                           //Name of the yeast
     property YeastLab : string read FYeast.lab;                             //Name of the laboratory (manufacturer)
     property YeastNum : string read FYeast.CatalogNum;                      //Catalog number of the yeast
     property YeastType : byte read FYeast.YeastType;                        //Yeast Type: 0 = ale, 1 = lager, 2 = wine, 3 = champagne
     property YeastTypeName : string read GetYeastTypeName;                  //Yeast type description
     property YeastMedium : byte read FYeast.Medium;                         //Medium: 0 = dry, 1 = liquid, 2 = Agar slant
     property YeastMediumName : string read GetYeastMediumName;              //Description of medium
     property YeastDescription : string read FYeast.Flavour;                 //Flavour description
     property YeastQuantity : single read GetYeastQuantity;                  //Quantity added
     property YeastLoAtt : LongWord read FYeast.LoAtt;                       //Minimum typical apparent attenuation
     property YeastHiAtt : LongWord read FYeast.HiAtt;                       //Maximum typical apparent attenuation
     property YeastTemp : single read GetYeastTemp;                          //Optimum fermentation temperature
     property YeastFlocc : byte read FYeast.Flocc;                           //Flocculation: 0 = high, 1 = medium, 2 = low
     property YeastFloccName : string read GetYeastFloccName;                //Flocculation description

     property WaterName : string read FWater.Name;                           //Name of the water profile
     property WaterCa : single read FWater.Ca;                               //Calcium concentration in mg/l or ppm
     property WaterMg : single read FWater.Mg;                               //Magnesium concentration in mg/l or ppm
     property WaterNa : single read FWater.Na;                               //Sodium concentration in mg/l or ppm
     property WaterSO4 : single read FWater.SO4;                             //Sulphate concentration in mg/l or ppm
     property WaterCl : single read FWater.Cl;                               //Chloride concentration in mg/l or ppm
     property WaterHCO3 : single read FWater.HCO3;                           //Bicarbonate concentration in mg/l or ppm
     property WaterpH : single read FWater.pH;                               //pH of the water
     property WaterKnownAs : string read FWater.KnownAs;                     //Description or origin

     property MashType : byte read FMashSchedule.MashType;                   //Mash type: 2 = single step, 3 = multi step
     property MashTypeName : string read GetMashTypeName;                    //Description of mash type
     property AcidTemp : LongWord read GetAcidTemp;                          //Temperature of acid rest in deg. C.
     property AcidTime : LongWord read FMashSchedule.AcidTime;               //Duration of acid rest in minutes
     property ProteinTemp : LongWord read GetProteinTemp;                    //Temperature of protein rest in deg. C
     property ProteinTime : LongWord read FMashSchedule.ProteinTime;         //Duration of protein rest in minutes
     property InterTemp : LongWord read GetInterTemp;                        //Temperature of intermediate rest in deg. C
     property InterTime : LongWord read FMashSchedule.InterTime;             //Duration of intermediate rest in minutes
     property SaccTemp : LongWord read GetSaccTemp;                          //Temperature of saccharification rest in deg. C
     property Sacctime : LongWord read FMashSchedule.Sacctime;               //Duration of saccharification rest in minutes
     property MashoutTemp : LongWord read GetMashoutTemp;                    //Temperature of mashout in deg. C
     property MashoutTime : LongWord read FMashSchedule.MashoutTime;         //Duration of mashout in minutes
     property SpargeTemp : LongWord read GetSpargeTemp;                      //Temperature of sparge water
     property SpargeTime : LongWord read FMashSchedule.SpargeTime;           //Duration of sparge in minutes
     property MashVolume : single read GetMashVolume;                        //Total mash volume

     property Notes : string read FNotes.Notes;                          //Notes
     property Awards : string read FNotes.Awards;                        //Awards

     property AmountMashStepsCustom : byte read FMashStepsCustomAmount.Amount;    //Number of custom mash steps
     property MashStepsCustomName : string read FMashStepsCustomAmount.Name;  //Name of custom mash scheme
     property MashStepsCustomGrainTemp : single read GetMashStepsCustomGrainTemp; //Temperature of the grains in deg. C
  end;

Function IsPromashFile(FN : string) : boolean;

Procedure ReadSkip(FS : TFileStream; Amount : LongInt);
Function unsignedIntToString(buffer : array of byte) : string;
Function ReadANSIString(FS : TFileStream; i : integer) : string;
Function ReadString(FS : TFileStream; i : integer) : string;
Function unsignedIntToLong(Buffer : array of byte) : LongInt;
Function ReadByte(FS : TFileStream) : byte;
Function ReadBoolean(FS : TFileStream) : boolean;
Function ReadLongInt(FS : TFileStream) : LongInt;
Function ReadLongWord(FS : TFileStream) : LongWord;
Function intBitsToFloat(bits : LongInt) : double;
Function MakeFloat(Buffer : array of byte) : double;
Function ReadFloat(FS : TFileStream) : double;

implementation

uses Dialogs, hulpfuncties, lconvencoding;

var BytesRead : LongWord;

Function PPPGtoYield(P : single) : single;
begin
  Result:= 100 * SGtoPlato(P) * P / 100 * 3.78541178 / 453.59237;
end;

Function PoundToKg(V : single) : single;
begin
  Result:= 0.45359237 * V;
end;

Function GallonsToLiters(V : single) : single;
begin
  Result:= 3.78541178 * V;
end;

Function SRMtoEBC(V : single) : single;
begin
  Result:= 1.76506E-10 * Power(v, 4) + 1.54529E-07 * Power(v, 3) - 1.59428E-04 * SQR(v) + 2.68837E+00 * v - 1.60040E+00;
  If Result < 0 Then
    Result:= 0;
end;

Function OunceToGram(V : single) : single;
begin
  Result:= 28.3495 * V;
end;

Function TeaspoonToGram(V : single) : single;
begin
  Result:= 3 * V;
end;

Function TablespoonToGram(V : single) : single;
begin
  Result:= 12 * V;
end;

Function CupsToGram(V : single) : single;
begin
  Result:= 250 * V;
end;

Function FtoC(V : single) : single;
begin
  Result:= (V - 32) / 1.8;
  if Result <= 0 then Result:= 0;
end;

Procedure ReadSkip(FS : TFileStream; Amount : LongInt);
var b : byte;
    l : LongInt;
begin
  BytesRead:= BytesRead + Amount;
//  FS.Read(b, Amount);
  for l:= 1 to Amount do
    FS.Read(b, 1);
end;

Function unsignedIntToString(buffer : array of byte) : string;
var i : integer;
    s : string;
begin
 i:= 0;
 s:= '';
 while ((i < High(buffer)) AND (buffer[i] <> $00)) do
 begin
   s:= s + char(buffer[i] and $ff);
   Inc(i);
 end;
 Result:= s;
end;

Function ReadANSIString(FS : TFileStream; i : integer) : string;
var S : ansistring;
    j : integer;
begin
  SetLength(S, i);
  for j:= 1 to i do
    FS.Read(S[j], 1);
//  Result:= Trim((S));
  Result:= ConvertEncoding(Trim((S)),GuessEncoding(Trim((S))),EncodingUTF8);
  if Result <> '' then Result:= RemInvChars(Result);
  BytesRead:= BytesRead + i;
end;

Function ReadString(FS : TFileStream; i : integer) : string;
var S : string;
    j : integer;
begin
  SetLength(S, i);
  for j:= 1 to i do
    FS.Read(S[j], 1);
//  Result:= Trim(AnsiToUTF8(S));
  Result:= ConvertEncoding(Trim((S)),GuessEncoding(Trim((S))),EncodingUTF8);
  if Result <> '' then Result:= RemInvChars(Result);
  BytesRead:= BytesRead + i;
end;

Function unsignedIntToLong(Buffer : array of byte) : LongInt;
var l : longint;
begin
  l:= 0;
  l:= l OR Buffer[0] AND $FF;
  l:= l shl 8;
  l:= l OR Buffer[1] AND $FF;
  l:= l shl 8;
  l:= l OR Buffer[2] AND $FF;
  l:= l shl 8;
  l:= l OR Buffer[3] AND $FF;
  Result:= l;
  Result:= round(l/256);
end;

Function ReadByte(FS : TFileStream) : byte;
var Buffer : byte;
begin
  FS.Read(Buffer, SizeOf(Buffer));
  Result:= Buffer;
  BytesRead:= BytesRead + 1;
end;

Function ReadBoolean(FS : TFileStream) : boolean;
var Buffer : byte;
begin
  FS.Read(Buffer, SizeOf(Buffer));
  case Buffer of
  $00 : Result:= false;
  $01 : Result:= TRUE;
  else Result:= false;
  end;
  BytesRead:= BytesRead + 1;
end;

Function ReadLongInt(FS : TFileStream) : LongInt;
var Buffer : array[0..3] of byte;
    i : longint absolute Buffer;
begin
  FS.Read(Buffer, SizeOf(Buffer));
  Result:= unsignedIntToLong(Buffer);
  BytesRead:= BytesRead + 4;
end;

Function ReadLongWord(FS : TFileStream) : LongWord;
var Buffer : array[0..3] of byte;
    i : LongWord absolute Buffer;
begin
  FS.Read(Buffer, SizeOf(Buffer));
  Result:= i;
  BytesRead:= BytesRead + 4;
end;

Function intBitsToFloat(bits : LongInt) : double;
var s, e, m : LongInt;
begin
 try
   //  s:= ((bits shr 31) = 0) ? 1 : -1;
    if ((bits shr 31) = 0) then
      s:= 1
    else
      s:= -1;

    e:= ((bits shr 23) AND $ff);

  //  m:= (e = 0) ? (bits AND $7fffff) shl 1 : (bits AND $7fffff) XOr $800000;
    if e = 0 then
      m:= (bits AND $7fffff) shl 1
    else
      m:= (bits AND $7fffff) XOr $800000;

    Result:= s * m * Power(2, (e-150));
 except
   on E: Exception do
     Result:= -1;
 end;
end;

Function MakeFloat(Buffer : array of byte) : double;
var i : LongInt;
begin
  i:= (Buffer[0] AND $ff) + ((Buffer[1] AND $ff) shl 8) + ((Buffer[2] AND $ff) shl 16) + (Buffer[3] shl 24);
  Result:= IntBitsToFloat(i);
end;

Function ReadFloat(FS : TFileStream) : double;
var Buffer : array[0..3] of byte;
//    s : double absolute Buffer;
begin
  FS.Read(Buffer, SizeOf(Buffer));
//  Result:= s;
  Result:= MakeFloat(Buffer);
  BytesRead:= BytesRead + 4;
end;

Function QTStoLiter(QTS : single) : single;
begin
  Result:= QTS * 0.946;
end;

Constructor TPromash.Create(AOwner : TComponent);
begin
  Inherited Create(AOwner);
  FFileName:= '';
  FOpened:= false;
end;

Destructor TPromash.Destroy;
begin
  Clear;
  Inherited;
end;

Procedure TPromash.Clear;
begin
   FOpened:= false;
   FFileName := '';
   With FRecipe do
   begin
     Name := '';
     HopCount:= 0;
     MaltCount:= 0;
     ExtraCount:= 0;
     BatchSize:= 0;
     WortSize := 0;
     Efficiency := 0;
     BoilTime := 0;
     RecipeType:= 0;
   end;
   with FStyle do
   begin
     Name := '';
     Name := '';
     SubstyleName := '';
     OrigMinSG := 0;
     OrigMaxSG := 0;
     FinalMinSG := 0;
     FinalMaxSG := 0;
     MinPercentAlcohol := 0;
     MaxPercentAlcohol := 0;
     MinIBU := 0;
     MaxIBU := 0;
     MinClr := 0;
     MaxClr := 0;
     ColorNote := '';
     MaltNote := '';
     HopNote := '';
     YeastNote := '';
     Examples := '';
     Category := '';
     SubCatLetter := '';
     StyleType := 0;  //1 = Ale, 2 = Lager, 3 = Ale/Lager Mixed, 4 = Cider, 5 = Mead
   end;
   with FYeast do
   begin
     Name := '';
     Lab := '';
     CatalogNum := '';
     YeastType := 0; //0 = ale, 1 = lager, 2 = wine, 3 = champagne
     Medium := 0; //0 = dry, 1 = liquid, 2 = Agar slant
     Flavour := '';
     Comment := '';
     Quantity := 0;
     LoAtt := 0;
     HiAtt := 0;
     Temp := 0;
     Flocc:= 0; //0 = high, 1 = medium, 2 = low
   end;
   with FWater do
   begin
     Name := '';
     Ca := 0;
     Mg := 0;
     Na := 0;
     Unknown := 0;
     SO4 := 0;
     Cl := 0;
     HCO3 := 0;
     pH := 0;
     KnownAs := '';
   end;
   With FMashSchedule do
   begin
     MashType := 0;
     Unknown1 := 0;
     Unknown2 := 0;
     AcidTemp := 0;
     AcidTime := 0;
     ProteinTemp := 0;
     ProteinTime := 0;
     InterTemp := 0;
     InterTime := 0;
     SaccTemp := 0;
     SaccTime := 0;
     MashOutTemp := 0;
     MashOutTime := 0;
     SpargeTemp := 0;
     SpargeTime := 0;
     MashQTS := 0;
     Unknown3 := 0;
   end;
   With FMashStepsCustomAmount do
   begin
     Amount := 0;
     GrainTemp := 0;
   end;

   with FNotes do
   begin
     Notes := '';
     Awards := '';
   end;
   FMalts:= NIL;
   FHops:= NIL;
   FExtras:= NIL;
   FMashStepsCustom:= NIL;
end;

Function IsPromashFile(FN : string) : boolean;
var FS : TFileStream;
    //x : single;
    s : string;
    li, hopcount, maltcount, extracount{, boiltime} : LongInt;
    //batchsize, wortsize, efficiency : single;
begin
  Result:= false;
  if FileExists(FN) { *Converted from FileExists*  } then
  begin
    try
      FS:= TFileStream.Create(FN, fmOpenRead);
      bytesread:= 0;
      //Recipe Chunk
      s:= ReadString(FS, 83);
      s:= ConvertStringEnc(s);
      li:= ReadLongInt(FS);
      HopCount:= li;
      li:= ReadLongInt(FS);
      MaltCount:= li;
      li:= ReadLongInt(FS);
      ExtraCount:= li;
      {ReadSkip(FS, 2);
      x:= ReadFloat(FS);
      BatchSize:= x;
      x:= ReadFloat(FS);
      WortSize:= x;
      ReadSkip(FS, 8);
      x:= ReadFloat(FS);
      Efficiency:= 100 * x;
      BoilTime:= ReadLongWord(FS);}

      if (hopcount > 0) and (hopcount < 20) and
         (maltcount > 0) and (maltcount < 20) and
         (extracount >= 0) and (extracount < 20){ and
         (batchsize > 0) and
         (wortsize > 0) and (wortsize >= batchsize) and
         (efficiency >= 30) and (efficiency <= 100) and
         (boiltime >= 0) and (boiltime <= 240)} then
        Result:= TRUE;
    Finally
      FreeAndNil(FS);
    end;
  end;
end;

Function TPromash.OpenReadRec(FN : string) : boolean;
var i : longint;
    FS : TFileStream;
    chunksize, sk : longword;
    x : single;
    s : string;
    li : LongInt;
begin
  Result:= false;
  BytesRead:= 0;
  try
   if FileExists(FN) { *Converted from FileExists*  } then
   begin
     FFileName:= FN;
     FS:= TFileStream.Create(FFileName, fmOpenRead);

     //Recipe Chunk
     s:= ReadString(FS, 83);
     s:= ConvertStringEnc(s);
     FRecipe.Name:= s;
     li:= ReadLongInt(FS);
     FRecipe.HopCount:= li;
     li:= ReadLongInt(FS);
     FRecipe.MaltCount:= li;
     li:= ReadLongInt(FS);
     FRecipe.ExtraCount:= li;
     ReadSkip(FS, 2);
     x:= ReadFloat(FS);
     FRecipe.BatchSize:= x;
     x:= ReadFloat(FS);
     FRecipe.WortSize:= x;
     ReadSkip(FS, 8);
     x:= ReadFloat(FS);
     FRecipe.Efficiency:= 100 * x;
     FRecipe.BoilTime:= ReadLongWord(FS);
     ReadSkip(FS, 4);
     FRecipe.RecipeType:= ReadByte(FS);

     //Style chunk
     FStyle.Name:= ReadString(FS, 55);
     FStyle.SubstyleName:= ReadString(FS, 56);
     FStyle.OrigMinSG:= ReadFloat(FS);
     FStyle.OrigMaxSG:= ReadFloat(FS);
     FStyle.FinalMinSG:= ReadFloat(FS);
     FStyle.FinalMaxSG:= ReadFloat(FS);
     FStyle.MinPercentAlcohol:= ReadFloat(FS);
     FStyle.MaxPercentAlcohol:= ReadFloat(FS);
     FStyle.MinIBU:= ReadFloat(FS);
     FStyle.MaxIBU:= ReadFloat(FS);
     FStyle.MinClr:= ReadFloat(FS);
     FStyle.MaxClr:= ReadFloat(FS);
     FStyle.ColorNote:= ReadString(FS, 155);
     FStyle.MaltNote:= ReadString(FS, 155);
     FStyle.HopNote:= ReadString(FS, 155);
     FStyle.YeastNote:= ReadString(FS, 155);
     FStyle.Examples:= ReadString(FS, 255);
     FStyle.Category:= ReadString(FS, 2);
     FStyle.SubCatLetter:= ReadString(FS, 2);
     FStyle.StyleType:= ReadByte(FS);
     
     //Hop Chunk
     SetLength(FHops, FRecipe.HopCount);
     for i:= 1 to FRecipe.HopCount do
     begin
       FHops[i-1].Name:= ReadString(FS, 55);
       FHops[i-1].AlphaDatabase:= ReadFloat(FS);
       FHops[i-1].Beta:= ReadFloat(FS);
       FHops[i-1].IsNoble:= ReadBoolean(FS);
       FHops[i-1].Cohumulene:= ReadFloat(FS);
       FHops[i-1].Myrcene:= ReadFloat(FS);
       FHops[i-1].Humulene:= ReadFloat(FS);
       FHops[i-1].Carophyllene:= ReadFloat(FS);
       FHops[i-1].Usage:= ReadByte(FS);
       FHops[i-1].Form:= ReadByte(FS);
       FHops[i-1].StorageFactor:= ReadFloat(FS);
       FHops[i-1].Description:= ReadString(FS, 155);
       FHops[i-1].Origin:= ReadString(FS, 55);
       FHops[i-1].Use:= ReadString(FS, 155);
       s:= ReadString(FS, 165);
       FHops[i-1].Substitutes:= '';
       x:= ReadFloat(FS);
       FHops[i-1].Alpha:= ReadFloat(FS);
       ReadSkip(FS, 1);
       FHops[i-1].Amount:= ReadFloat(FS);
       FHops[i-1].Time:= ReadByte(FS);
       ReadSkip(FS, 1);
       FHops[i-1].IBUContribution:= ReadFloat(FS);
     end;

     //Fermentables chunk
     SetLength(FMalts, FRecipe.MaltCount);
     for i:= 1 to FRecipe.MaltCount do
     begin
       FMalts[i-1].Name:= ReadString(FS, 55);
       FMalts[i-1].Manufacturer:= ReadString(FS, 55);
       FMalts[i-1].Origin:= ReadString(FS, 55);
       FMalts[i-1].MaltType:= ReadByte(FS);
       FMalts[i-1].MaltType2:= ReadByte(FS);
       FMalts[i-1].PPPG:= ReadFloat(FS);
       FMalts[i-1].Color:= ReadFloat(FS);
       FMalts[i-1].Moisture:= ReadFloat(FS);
       FMalts[i-1].Max:= ReadFloat(FS);
       FMalts[i-1].DiastaticPower:= ReadFloat(FS);
       FMalts[i-1].Protein:= ReadFloat(FS);
       FMalts[i-1].TSN:= ReadFloat(FS);
       FMalts[i-1].Use:= ReadString(FS, 155);
       FMalts[i-1].Comments:= ReadString(FS, 159);
       ReadSkip(FS, 4);
       FMalts[i-1].FGDry:= ReadFloat(FS);
       FMalts[i-1].CGDry:= ReadFloat(FS);
       FMalts[i-1].Amount:= ReadFloat(FS);
       ReadSkip(FS, 4);
     end;
     
     //Extra Chunk
     SetLength(FExtras, FRecipe.ExtraCount);
     for i:= 1 to FRecipe.ExtraCount do
     begin
       FExtras[i-1].Name:= ReadString(FS, 55);
       FExtras[i-1].ExtraType:= ReadByte(FS);
       FExtras[i-1].Time:= ReadLongWord(FS);
       FExtras[i-1].Use:= ReadByte(FS);
       FExtras[i-1].TimeUnit:= ReadByte(FS);
       FExtras[i-1].ExtraUnit:= ReadByte(FS);
       ReadSkip(FS, 4);
       FExtras[i-1].Usage:= ReadString(FS, 255);
       FExtras[i-1].Comment:= ReadString(FS, 255);
       FExtras[i-1].Amount:= ReadFloat(FS);
       ReadSkip(FS, 8);
     end;

     //Yeast chunk
     FYeast.Name:= ReadString(FS, 55);
     FYeast.Lab:= ReadString(FS, 55);
     FYeast.CatalogNum:= ReadString(FS, 25);
     FYeast.YeastType:= ReadByte(FS);
     FYeast.Medium:= ReadByte(FS);
     FYeast.Flavour:= ReadString(FS, 155);
     FYeast.Comment:= ReadString(FS, 159);
     FYeast.Quantity:= ReadFloat(FS);
     FYeast.LoAtt:= ReadLongWord(FS);
     FYeast.HiAtt:= ReadLongWord(FS);
     FYeast.Temp:= ReadFloat(FS);
     FYeast.Flocc:= ReadByte(FS);
     ReadSkip(FS, 5);
     
     //Water chunk
     FWater.Name:= ReadString(FS, 27);
     FWater.Ca:= ReadFloat(FS);
     FWater.Mg:= ReadFloat(FS);
     FWater.Na:= ReadFloat(FS);
     FWater.Unknown:= ReadFloat(FS);
     FWater.SO4:= ReadFloat(FS);
     FWater.Cl:= ReadFloat(FS);
     FWater.HCO3:= ReadFloat(FS);
     FWater.pH:= ReadFloat(FS);
     FWater.KnownAs:= ReadString(FS, 163);    //47

     //Mash Schedule chunk
     FMashSchedule.MashType:= ReadByte(FS);
     ReadSkip(FS, 8);
     FMashSchedule.AcidTemp:= ReadLongWord(FS);
     FMashSchedule.AcidTime:= ReadLongWord(FS);
     FMashSchedule.ProteinTemp:= ReadLongWord(FS);
     FMashSchedule.ProteinTime:= ReadLongWord(FS);
     FMashSchedule.InterTemp:= ReadLongWord(FS);
     FMashSchedule.InterTime:= ReadLongWord(FS);
     FMashSchedule.SaccTemp:= ReadLongWord(FS);
     FMashSchedule.SaccTime:= ReadLongWord(FS);
     FMashSchedule.MashoutTemp:= ReadLongWord(FS);
     FMashSchedule.MashoutTime:= ReadLongWord(FS);
     FMashSchedule.SpargeTemp:= ReadLongWord(FS);
     FMashSchedule.SpargeTime:= ReadLongWord(FS);
     FMashSchedule.MashQTS:= ReadFloat(FS);
     ReadSkip(FS, 1);

     //Notes chunk
     FNotes.Notes:= ReadANSIString(FS, 4028);
     FNotes.Awards:= ReadANSIString(FS, 4283);

     ChunkSize:= 0;
     //Custom mash chunk
     FMashStepsCustomAmount.Amount:= ReadByte(FS);
     Inc(ChunkSize, 1);
     ReadSkip(FS, 1);
     Inc(ChunkSize, 1);
     FMashStepsCustomAmount.GrainTemp:= ReadLongint(FS);
     Inc(ChunkSize, 4);
     ReadSkip(FS, 6);
     Inc(ChunkSize, 6);
     SetLength(FMashStepsCustom, FMashStepsCustomAmount.Amount);
     for i:= 1 to FMashStepsCustomAmount.Amount do
     begin
        FMashStepsCustom[i-1].Name:= ReadANSIString(FS, 255);
        Inc(ChunkSize, 255);
        FMashStepsCustom[i-1].HeatType:= ReadByte(FS);
        Inc(ChunkSize, 1);
        FMashStepsCustom[i-1].StartTemp:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].EndTemp:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].InfusionTemp:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].RestTime:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].StepTime:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].InfuseRatio:= ReadFloat(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].InfuseAmount:= ReadFloat(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].StepUpTimeClr:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
        FMashStepsCustom[i-1].RestTimeClr:= ReadLongWord(FS);
        Inc(ChunkSize, 4);
     End;
     sk:= 14612 - ChunkSize;
     ReadSkip(FS, sk);
     FMashStepsCustomAmount.Name:= ReadANSIString(FS, 255);
     ReadSkip(FS, 1);

     FS.Free;
     Result:= TRUE;
     FOpened:= TRUE;
   end
   else
   begin
     Result:= TRUE;
     FOpened:= TRUE;
   end;
  except
   FOpened:= false;
   FS.Free;
  end;
end;

Function TPromash.GetRecipeName : string;
begin
  Result:= FRecipe.Name;
end;

Function TPromash.GetRecipeTypeName : string;
begin
  case FRecipe.RecipeType of
  0: Result:= 'Mout';
  1: Result:= 'Partieel maischen';
  2: Result:= 'Extract';
  else Result:= 'Anders';
  end;
end;

Function TPromash.GetBatchSize : single;     //in liters !!!
begin
  Result:= GallonsToLiters(FRecipe.BatchSize);
end;

Function TPromash.GetWortSize : single;      //in liters !!!
begin
  Result:= GallonsToLiters(FRecipe.WortSize);
end;

Function TPromash.GetStyleOriginMinSG : single;
begin
  Result:= FStyle.OrigMinSG;
end;

Function TPromash.GetStyleOriginMaxSG : single;
begin
  Result:= FStyle.OrigMaxSG;
end;

Function TPromash.GetStyleMinClr : single;
begin
  Result:= FStyle.MinClr;
end;

Function TPromash.GetStyleMaxClr : single;
begin
  Result:= FStyle.MaxClr;
end;

Function TPromash.GetStyleTypeName : string;
begin
  case FStyle.StyleType of
  0: Result:= '';
  1: Result:= 'Bovengistend';
  2: Result:= 'Ondergistend';
  3: Result:= 'Bier';
  4: Result:= 'Cider';
  5: Result:= 'Mede';
  else Result:= '';
  end;
end;

{Function TPromash.GetMalt(i : integer) : TMaltPrm;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i];
  end
  else
    Result:= FMalts[Low(FMalts)];
end;

Function TPromash.GetExtra(i : integer) : TExtraPrm;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i];
  end
  else
    Result:= FExtras[Low(FExtras)];
end;

Function TPromash.GetHop(i : integer) : THopPrm;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i];
  end
  else
    Result:= FHops[Low(FHops)];
end;

Function TPromash.GetMashStep(i : integer) : TMashStepSimplePrm;
begin
  if (i >= Low(FMashSteps)) and (i <= High(FMashSteps)) then
  begin
    Result:= FMashSteps[i];
  end
  else
    Result:= FMashSteps[Low(FMashSteps)];
end;

Function TPromash.GetMashStepCustom(i : integer) : TMashStepCustomPrm;
begin
  if (i >= Low(FMashStepCustom)) and (i <= High(FMashStepCustom)) then
  begin
    Result:= FMashStepCustom[i];
  end
  else
    Result:= FMashStepCustom[Low(FMashStepsCustom)];
end;  }

Function TPromash.GetMaltName(i : integer) : string;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Name;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltManufacturer(i : integer) : string;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Manufacturer;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltOrigin(i : integer) : string;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Origin;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltType(i : integer) : byte;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].MaltType;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltTypeName(i : integer) : string;
var j : integer;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    j:= FMalts[i].MaltType;
    Case j of
    0: Result:= '';
    1: Result:= 'Graan';
    2: Result:= 'Extract';
    3: Result:= 'Suiker';
    4: Result:= 'Overig';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltType2(i : integer) : byte;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].MaltType2;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltType2Name(i : integer) : string;
var j : integer;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    j:= FMalts[i].MaltType;
    Case j of
    0: Result:= '';
    1:
    begin
      case FMalts[i].MaltType2 of //Maischen nodig?
      0: Result:= 'Nee';
      1: Result:= 'Ja';
      else Result:= '';
      end;
    end;
    2:
    begin
      case FMalts[i].MaltType2 of //type extract
      0: Result:= 'Vloeibaar extract';
      1: Result:= 'Droog extract';
      else Result:= '';
      end;
    end;
    else Result:= 'Suiker';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltYield(i : integer) : single;   //in % !!!
//var s : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
   // s:= FMalts[i].PPPG;
   // Result:= PPPGtoYield(s);
    Result:= MaltFGDry[i];
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltPPPG(i : integer) : single;   //in SG per Pound per Gallon
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].PPPG;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltColor(i : integer) : single;   //in SRM !!!
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Color;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltMoisture(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Moisture;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltMax(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Max;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltDiastaticPower(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].DiastaticPower;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltProtein(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Protein;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltTSN(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].TSN;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltUse(i : integer) : string;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Use;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltComments(i : integer) : string;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].Comments;
  end
  else
    Result:= '';
end;

Function TPromash.GetMaltAmount(i : integer) : single;  //in kg !!!
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= PoundToKg(FMalts[i].Amount);
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltFGDry(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].FGDry;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMaltCGDry(i : integer) : single;
begin
  if (i >= Low(FMalts)) and (i <= High(FMalts)) then
  begin
    Result:= FMalts[i].CGDry;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopName(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Name;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopAlpha(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Alpha;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopAlphaDatabase(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].AlphaDatabase;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopBeta(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Beta;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopIsNoble(i : integer) : boolean;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].IsNoble;
  end
  else
    Result:= false;
end;

Function TPromash.GetHopCohumulene(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Cohumulene;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopMyrcene(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Myrcene;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopHumulene(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Humulene;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopCarophyllene(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Carophyllene;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopUsage(i : integer) : byte;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Usage;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopUsageName(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    case FHops[i].Usage of
    1: Result:= 'Bitterhop';
    2: Result:= 'Aromahop';
    3: Result:= 'Beide';
    else Result:= '';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopForm(i : integer) : byte;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Form;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopFormName(i : integer) : string;
var j : integer;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    j:= FHops[i].Form;
    case j of
    3: Result:= 'Bloemen';
    19: Result:= 'Plugs';
    35: Result:= 'Pellets';
    else Result:= '';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopStorageFactor(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].StorageFactor;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopDescription(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Description;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopOrigin(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Origin;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopUse(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Use;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopSubstitutes(i : integer) : string;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].Substitutes;
  end
  else
    Result:= '';
end;

Function TPromash.GetHopTime(i : integer) : LongInt;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    if FHops[i].Time = 251 then
      Result:= -1
    else
      Result:= FHops[i].Time;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopTimeDescription(i : integer) : string;
var T : LongWord;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    T:= FHops[i].Time;
    if T = FRecipe.BoilTime + 2 then
      Result:= 'Maisch hop'
    else if T = FRecipe.BoilTime + 1 then
      Result:= 'Eerste wort hop'
    else if T = 251 then
      Result:= 'Koudhop'
    else if T > 45 then
      Result:= 'Bitterhop'
    else if T > 15 then
      Result:= 'Smaakhop'
    else if T >= 0 then
      Result:= 'Aromahop'
    else
      Result:= '';
  end
  else
    Result:= '';
end;

Function TPromash.GetHopAmount(i : integer) : single;   //in kilogram !!!
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= OunceToGram(FHops[i].Amount) / 1000;
  end
  else
    Result:= 0;
end;

Function TPromash.GetHopIBUContribution(i : integer) : single;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    Result:= FHops[i].IBUContribution;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraName(i : integer) : string;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].Name;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraType(i : integer) : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].ExtraType;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraTypeName(i : integer) : string;
var t : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    t:= FExtras[i].ExtraType;
    case t of
    0: Result:= 'Specerij';
    1: Result:= 'fruit';
    2: Result:= 'koffie';
    3: Result:= 'anders';
    4: Result:= 'klaringsmiddel';
    5: Result:= 'kruid';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraTime(i : integer) : LongWord;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].Time;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraAddition(i : integer) : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].Use;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraAdditionName(i : integer) : string;
var t : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    t:= FExtras[i].Use;
    case t of
    0: Result:= 'koken';
    1: Result:= 'vergisting';
    2: Result:= 'maischen';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraTimeUnit(i : integer) : byte;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].TimeUnit;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraTimeUnitName(i : integer) : string;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    case FExtras[i].TimeUnit of
    0: Result:= 'Dagen';
    1: Result:= 'Minuten';
    else Result:= '';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraUnit(i : integer) : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].ExtraUnit;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraUnitName(i : integer) : string;
var t : integer;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    t:= FExtras[i].ExtraUnit;
    case t of
    0..5: Result:= 'gram';
    6: Result:= 'aantal';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraAmount(i : integer) : single;  //in kilogram or number !!!
var t : integer;
    a : single;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    t:= FExtras[i].ExtraUnit;
    a:= FExtras[i].Amount;
    case t of
    0: Result:= OunceToGram(a);
    1: Result:= a;
    2: Result:= PoundToKg(a) * 1000;
    3: Result:= TeaspoonToGram(a);
    4: Result:= TablespoonToGram(a);
    5: Result:= CupsToGram(a);
    6: Result:= a;
    end;
    Result:= a / 1000;
  end
  else
    Result:= 0;
end;

Function TPromash.GetExtraUsage(i : integer) : string;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].Usage;
  end
  else
    Result:= '';
end;

Function TPromash.GetExtraComments(i : integer) : string;
begin
  if (i >= Low(FExtras)) and (i <= High(FExtras)) then
  begin
    Result:= FExtras[i].Comment;
  end
  else
    Result:= '';
end;

Function TPromash.GetYeastTypeName : string;
begin
  case FYeast.YeastType of
  0: Result:= 'Bovengist';
  1: Result:= 'Ondergist';
  2: Result:= 'Wijn';
  3: Result:= 'Champagne';
  else Result:= 'Anders';
  end;
end;

Function TPromash.GetYeastMediumName : string;
begin
  case FYeast.Medium of
  0: Result:= 'Korrelgist';
  1: Result:= 'Vloeibaar';
  2: Result:= 'Agarplaat/schuine buis';
  else Result:= 'Anders';
  end;
end;

Function TPromash.GetYeastQuantity : single;
begin
  Result:= FYeast.Quantity;
end;

Function TPromash.GetYeastTemp : single; // in gr. C
begin
  Result:= FtoC(FYeast.Temp);
end;

Function TPromash.GetYeastFloccName : string;
begin
  case FYeast.Flocc of
  0: Result:= 'Hoog';
  1: Result:= 'Middel';
  2: Result:= 'Laag';
  else Result:= 'Niet bekend';
  end;
end;

Function TPromash.GetMashTypeName : string;
begin
  case FMashSchedule.MashType of
  2: Result:= 'Eenstapsmaisch';
  3: Result:= 'Meerstapsmaisch';
  else Result:= 'Anders';
  end;
end;

Function TPromash.GetAcidTemp : LongWord;     //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.AcidTemp));
end;

Function TPromash.GetProteinTemp : LongWord;  //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.ProteinTemp));
end;

Function TPromash.GetInterTemp : LongWord;    //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.InterTemp));
end;

Function TPromash.GetSaccTemp : LongWord;     //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.SaccTemp));
end;

Function TPromash.GetMashoutTemp : LongWord;  //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.MashoutTemp));
end;

Function TPromash.GetSpargeTemp : LongWord;   //in gr. C
begin
  Result:= Round(FtoC(FMashSchedule.SpargeTemp));
end;

Function TPromash.GetMashVolume : single;   //in liters
begin
  Result:= QTStoLiter(FMashSchedule.MashQTS);
end;

Function TPromash.GetMashStepsCustomGrainTemp : single;
begin
  Result:= FtoC(FMashStepsCustomAmount.GrainTemp);
end;

Function TPromash.GetMashStepCustomName(i : integer) : ansistring;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= FMashStepsCustom[i].Name;
  end
  else
    Result:= '';
end;

Function TPromash.GetMashStepCustomHeatType(i : integer) : byte;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= FMashStepsCustom[i].HeatType;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomHeatTypeName(i : integer) : string;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    case FMashStepsCustom[i].HeatType of
    0: Result:= 'Infusie';
    1: Result:= 'Directe verwarming';
    2: Result:= 'Decoctie';
    else Result:= '';
    end;
  end
  else
    Result:= '';
end;

Function TPromash.GetMashStepCustomStartTemp(i : integer) : longint;  //in deg. C !!!
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= Round(FtoC(FMashStepsCustom[i].StartTemp));
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomEndTemp(i : integer) : longint;  //in deg. C !!!
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= Round(FtoC(FMashStepsCustom[i].EndTemp));
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomInfusionTemp(i : integer) : longint; //in deg. C !!!
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= Round(FtoC(FMashStepsCustom[i].InfusionTemp));
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomStepTime(i : integer) : longint;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= FMashStepsCustom[i].StepTime;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomRestTime(i : integer) : longint;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= FMashStepsCustom[i].RestTime;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomInfuseRatio(i : integer) : single;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= FMashStepsCustom[i].InfuseRatio;
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomInfuseAmount(i : integer) : single;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= QTStoLiter(FMashStepsCustom[i].InfuseAmount);
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomStepUpTimeClr(i : integer) : TColor;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= TColor(FMashStepsCustom[i].StepUpTimeClr);
  end
  else
    Result:= 0;
end;

Function TPromash.GetMashStepCustomRestTimeClr(i : integer) : TColor;
begin
  if (i >= Low(FMashStepsCustom)) and (i <= High(FMashStepsCustom)) then
  begin
    Result:= TColor(FMashStepsCustom[i].RestTimeClr);
  end
  else
    Result:= 0;
end;

Function TPromash.Convert(R : TRecipe) : boolean;
var Y : TYeast;
    F : TFermentable;
    H : THop;
    M : TMisc;
    W : TWater;
    MS : TMashStep;
    i : integer;
begin
  Result:= false;
  if R <> NIL then
  begin
    R.Name.Value:= Trim(RecipeName);
    R.Efficiency:= Efficiency;
    R.BatchSize.Value:= BatchSize;
//    R.BoilSize.Value:= WortSize;
    R.BoilTime.Value:= BoilTime;
    case RecipeType of
    1: R.RecipeType:= rtAllGrain;
    2: R.RecipeType:= rtPartialMash;
    3: R.RecipeType:= rtExtract;
    end;
    R.Notes.Value:= Trim(Notes);

    R.Style.Name.Value:= Trim(SubStyleName);
    R.Style.OGMin.Value:= Styleoriginminsg;
    R.Style.OGMax.Value:= StyleOriginMaxSG;
    R.Style.ABVMin.Value:= StyleMinPercentAlcohol;
    R.Style.ABVMax.Value:= StyleMaxPercentAlcohol;
    R.Style.IBUMin.Value:= StyleMinIBU;
    R.Style.IBUMax.Value:= StyleMaxIBU;
    R.Style.ColorMin.Value:= StyleMinClr;
    R.Style.ColorMax.Value:= StyleMaxClr;
    case StyleType of//1 = Ale, 2 = Lager, 3 = Ale/Lager Mixed, 4 = Cider, 5 = Mead
    1: R.Style.StyleType:= stAle;
    2: R.Style.StyleType:= stLager;
    3: R.Style.StyleType:= stMixed;
    4: R.Style.StyleType:= stCider;
    5: R.Style.StyleType:= stMead;
    end;
    R.Style.Category.Value:= Trim(StyleCatNr);
    R.Style.Examples.Value:= Trim(StyleExamples);
    R.Style.StyleLetter.Value:= Trim(StyleSubCatLetter);

    Y:= R.AddYeast;
    Y.Name.Value:= Trim(YeastName);
    Y.Laboratory.Value:= Trim(YeastLab);
    Y.ProductID.Value:= Trim(YeastNum);
    case YeastType of //0 = ale, 1 = lager, 2 = wine, 3 = champagne
    0: Y.YeastType:= ytAle;
    1: Y.YeastType:= ytLager;
    2: Y.YeastType:= ytWine;
    3: Y.YeastType:= ytChampagne;
    end;
    case YeastMedium of //0 = dry, 1 = liquid, 2 = Agar slant
    0: Y.Form:= yfDry;
    1: Y.Form:= yfLiquid;
    2: Y.Form:= yfSlant;
    end;
    Y.Notes.Value:= Trim(YeastDescription);
    Y.Amount.Value:= YeastQuantity;
    if Y.Amount.Value = 0 then Y.Amount.Value:= 1;
    Y.Attenuation.Value:= YeastHiAtt;
    case YeastFlocc of //0 = high, 1 = medium, 2 = low
    0: Y.Flocculation:= flHigh;
    1: Y.Flocculation:= flMedium;
    2: Y.Flocculation:= flLow;
    end;

    W:= R.AddWater;
    W.Name.Value:= Trim(WaterName);
    if W.Name.Value = 'utf8' then W.Name.Value:= 'Water';
    W.Amount.Value:= MashVolume;
    W.Calcium.Value:= WaterCa;
    W.Magnesium.Value:= WaterMg;
    W.Sodium.Value:= WaterNa;
    W.Sulfate.Value:= WaterSO4;
    W.Chloride.Value:= WaterCl;
    W.Bicarbonate.Value:= WaterHCO3;
    W.pHwater.Value:= WaterpH;
    W.Notes.Value:= WaterKnownAs;

    for i:= 0 to MaltCount - 1 do
    begin
      F:= R.AddFermentable;
      F.Name.Value:= Trim(MaltName[i]);
      F.Supplier.Value:= Trim(MaltManufacturer[i]);
      F.Origin.Value:= Trim(MaltOrigin[i]);
      case MaltType[i] of //1 = grain, 2 = Extract, 3 = Sugar, 4 = other
      1: F.FermentableType:= ftGrain;
      2:
      begin
        F.FermentableType:= ftExtract;
        if MaltType2[i] = 1 then F.FermentableType:= ftDryExtract;
      end;
      3: F.FermentableType:= ftSugar;
      4: F.FermentableType:= ftAdjunct;
      end;
      if (MaltType[i] = 1) or (MaltType[i] = 3) then
      case MaltType2[i] of
      0: F.RecommendMash.Value:= false;
      1: F.RecommendMash.Value:= TRUE;
      end;
      F.Yield.Value:= MaltYield[i];
      F.Color.Value:= MaltColor[i];
      F.Moisture.Value:= MaltMoisture[i];
      F.MaxInBatch.Value:= MaltMax[i];
      F.DiastaticPower.Value:= MaltDiastaticPower[i];
      F.Protein.Value:= MaltProtein[i];
      F.DissolvedProtein.Value:= MaltTSN[i];
      F.Notes.Value:= Trim(MaltComments[i]);
      F.Amount.Value:= MaltAmount[i];
      F.CoarseFineDiff.Value:= MaltFGDry[i] - MaltCGDry[i];
    end;

    for i:= 0 to HopCount - 1 do
    begin
      H:= R.AddHop;
      H.Name.Value:= Trim(HopName[i]);
      H.Alfa.Value:= HopAlpha[i];
      H.Beta.Value:= HopBeta[i];
      H.Cohumulone.Value:= HopCohumulene[i];
      H.Myrcene.Value:= HopMyrcene[i];
      H.Caryophyllene.Value:= HopCarophyllene[i];
      case HopUsage[i] of //1 = bittering, 2 = aroma, 3 = both
      1: H.HopType:= htBittering;
      2: H.HopType:= htAroma;
      3: H.HopType:= htBoth;
      end;
      case HopForm[i] of //3: flowers, 19: plugs, 35: pellets
      3: H.Form:= hfLeaf;
      19 : H.Form:= hfPlug;
      35: H.Form:= hfPellet;
      end;
      //If time = boiltime + 2 then mash hop, if time = boiltime + 1 then First Wort Hop,
      //if time = -1 then dry hop.
      if HopTime[i] = -1 then
      begin
        H.Use:= huDryHop;
        H.Time.Value:= 0;
      end
      else if HopTime[i] = round(double(R.BoilTime.Value)) + 1 then
      begin
        H.Use:= huFirstWort;
        H.Time.Value:= R.BoilTime.Value;
      end
      else if HopTime[i] = round(double(R.BoilTime.Value)) + 1 then
      begin
        H.Use:= huMash;
        H.Time.Value:= R.BoilTime.Value;
      end
      else if HopTime[i] = 0 then
      begin
        H.Use:= huAroma;
        H.Time.Value:= 0;
      end
      else
      begin
        H.Use:= huBoil;
        H.Time.Value:= HopTime[i];
      end;
      H.Substitutes.Value:= Trim(HopSubstitutes[i]);
      H.Amount.Value:= HopAmount[i];
    end;

    for i:= 0 to ExtraCount - 1 do
    begin
      M:= R.AddMisc;
      M.Name.Value:= Trim(ExtraName[i]);
      case ExtraType[i] of //0 = specerij, 1 = fruit, 2 = koffie, 3 = anders, 4 = klaringsmiddel, 5 = kruid
      0: M.MiscType:= mtSpice;
      1, 3: M.MiscType:= mtOther;
      2: M.MiscType:= mtFlavor;
      4: M.MiscType:= mtFining;
      5: M.MiscType:= mtHerb;
      end;
      if ExtraTimeUnit[i] =  0 then
        M.Time.Value:= ExtraTime[i]
      else
        M.Time.Value:= ExtraTime[i] * 24 * 60;
      case ExtraUnit[i] of
      0..5: M.Amount.vUnit:= gram;
      6: M.Amount.vUnit:= none;
      end;
      M.Amount.Value:= ExtraAmount[i];
      M.UseFor.Value:= Trim(ExtraUsage[i]);
      M.Notes.Value:= Trim(ExtraComments[i]);
    end;

    i:= 0;
    if AmountMashStepsCustom <= 0 then
    begin
      if (AcidTemp > 0) and (AcidTime > 0) then
      begin
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= 'Zuurrust';
        MS.StepTemp.Value:= AcidTemp;
        MS.EndTemp.Value:= AcidTemp;
        MS.RampTime.Value:= 0;
        MS.StepTime.Value:= AcidTime;
        if i = 0 then MS.MashStepType:= mstInfusion
        else MS.MashStepType:= mstTemperature;
        inc(i);
      end;
      if (ProteinTemp > 0) and (ProteinTime > 0) then
      begin
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= 'Eiwitrust';
        MS.StepTemp.Value:= ProteinTemp;
        MS.EndTemp.Value:= ProteinTemp;
        MS.RampTime.Value:= 0;
        MS.StepTime.Value:= ProteinTime;
        if i = 0 then MS.MashStepType:= mstInfusion
        else MS.MashStepType:= mstTemperature;
        inc(i);
      end;
      if (InterTemp > 0) and (InterTime > 0) then
      begin
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= 'Tussenrust';
        MS.StepTemp.Value:= InterTemp;
        MS.EndTemp.Value:= InterTemp;
        MS.RampTime.Value:= 0;
        MS.StepTime.Value:= InterTime;
        if i = 0 then MS.MashStepType:= mstInfusion
        else MS.MashStepType:= mstTemperature;
        inc(i);
      end;
      if (SaccTemp > 0) and (SaccTime > 0) then
      begin
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= 'Amylaserust';
        MS.StepTemp.Value:= SaccTemp;
        MS.EndTemp.Value:= SaccTemp;
        MS.RampTime.Value:= 0;
        MS.StepTime.Value:= SaccTime;
        if i = 0 then MS.MashStepType:= mstInfusion
        else MS.MashStepType:= mstTemperature;
        inc(i);
      end;
      if (MashOutTemp > 0) and (MashoutTime > 0) then
      begin
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= 'Uitmaischen';
        MS.StepTemp.Value:= MashoutTemp;
        MS.EndTemp.Value:= MashoutTemp;
        MS.RampTime.Value:= 0;
        MS.StepTime.Value:= MashoutTime;
        if i = 0 then MS.MashStepType:= mstInfusion
        else MS.MashStepType:= mstTemperature;
      end;
      R.Mash.SpargeTemp.Value:= SpargeTemp;
      R.Mash.MashWaterVolume:= MashVolume;
    end
    else
    begin
      for i:= 0 to AmountMashStepsCustom - 1 do
      begin
        R.Mash.Name.Value:= Trim(MashStepsCustomName);
        R.Mash.GrainTemp.Value:= MashStepsCustomGrainTemp;
        MS:= R.Mash.AddMashStep;
        MS.Name.Value:= MashStepCustomName[i];
        case MashStepCustomHeatType[i] of //0 = Infusie, 1 = Directe verwarming, 2 = Decoctie
        0: MS.MashStepType:= mstInfusion;
        1: MS.MashStepType:= mstTemperature;
        2: MS.MashStepType:= mstDecoction;
        end;
        MS.StepTemp.Value:= MashStepCustomStartTemp[i];
        MS.EndTemp.Value:= MashStepCustomEndTemp[i];
        MS.InfuseAmount.Value:= MashStepCustomInfuseAmount[i];
        MS.StepTime.Value:= MashStepCustomRestTime[i];
        MS.RampTime.Value:= MashStepCustomStepTime[i];
      end;
    end;
  end;
end;

end.

