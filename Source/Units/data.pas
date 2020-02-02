{The data structure is fully compatible with BeerXML v1. Some fields
 are added. These added fields are mentioned under BrouwHulpXML.
 All data are stored in units according to the BeerXML v1 standard.
 For more info on BeerXML see: http://www.beerxml.com.}

unit Data;

{Nog doen:
  - berekeningen
  - opslag en laden van default waarden, eenheden en decimalen
}

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils, Dialogs, Graphics, Forms, Controls, StdCtrls, ComCtrls,
  ExtCtrls, DOM, FileUtil, Math, Hulpfuncties, XMLRead, XMLWrite, Spin;

type
  TRecipe = class;
  TBase = class;

  TBData = class(TObject)
  private
    FParent : TBase;
//    FValue: variant;
    FLabel: string;
    FCaption : string;
//    procedure SetValue(v: variant); virtual;
//    function GetValue: variant; virtual;
  public
    constructor Create(aParent : TBase); virtual;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); virtual;
    procedure ReadXML(iNode: TDOMNode); virtual;
    procedure Assign(Source: TBData);
  published
//    property Value: variant read GetValue write SetValue;
    property NodeLabel: string read FLabel write FLabel;
    property Caption : string read FCaption write FCaption;
  end;


  TBFloat = class(TBData)
  private
    //units of values are always the standards of BeerXML. User can adjust
    //the display units.
    FValue : double;
    FMinValue: double;
    FMaxValue: double;
    FUnit: TUnit;
    FDisplayUnit: TUnit;
    FDisplayValue: double;
    FDecimals: integer;
    FDisplayLabel: string;
    FIncrement : double;
    procedure SetValue(v: double);
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
    procedure SetMinValue(d: double);
    procedure SetMaxValue(d: double);
    procedure SetUnit(u: TUnit);
    procedure SetDisplayValue(d: double);
    procedure SetDisplayUnit(u: TUnit);
    procedure SetDisplayString(s: string);
    procedure SetDisplayUnitString(s : string);
    function GetDisplayUnit : TUnit;
    function GetDisplayMinValue: double;
    function GetDisplayMaxValue: double;
    function GetDisplayString: string;
    function GetDisplayUnitString: string;
    procedure SetDecimals(i: integer);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure SaveXMLDisplayValue(Doc: TXMLDocument; iNode: TDomNode);
    procedure ReadXML(iNode: TDOMNode); override;
    procedure ReadXMLDisplayValue(iNode: TDOMNode);
    procedure Assign(Source: TBFloat);
    procedure Add(x : double);
    procedure Subtract(x : double);
  published
    property Value: double read FValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property MinValue: double read FMinValue write SetMinValue;
    property MaxValue: double read FMaxValue write SetMaxValue;
    property vUnit: TUnit read FUnit write SetUnit;
    property DisplayValue: double read FDisplayValue write SetDisplayValue;
    property DisplayMinValue: double read GetDisplayMinValue;
    property DisplayMaxValue: double read GetDisplayMaxValue;
    property DisplayUnit: TUnit read GetDisplayUnit write SetDisplayUnit;
    property DisplayUnitString: string read GetDisplayUnitString write SetDisplayUnitString;
    property DisplayString: string read GetDisplayString write SetDisplayString;
    property Decimals: integer read FDecimals write SetDecimals;
    property DisplayLabel: string read FDisplayLabel write FDisplayLabel;
    property Increment : double read FIncrement write FIncrement;
  end;

  TBInteger = class(TBData)
  private
    FValue : integer;
    FMinValue: integer;
    FMaxValue: integer;
    FUnit: TUnit;
    procedure SetValue(v: integer);
    function GetValue: integer;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
    procedure SetMinValue(v: integer);
    procedure SetMaxValue(v: integer);
    function GetDisplayString: string;
    procedure SetDisplayString(s: string);
    procedure Add(x : integer);
    procedure Subtract(x : integer);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBInteger);
  published
    property Value: integer read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property MinValue: integer read FMinValue write SetMinValue;
    property MaxValue: integer read FMaxValue write SetMaxValue;
    property vUnit: TUnit read FUnit write FUnit;
    property DisplayString: string read GetDisplayString write SetDisplayString;
  end;

  TBLongInt = class(TBData)
  private
    FValue : LongInt;
    FMinValue: Longint;
    FMaxValue: longint;
    FUnit: TUnit;
    procedure SetValue(v: LongInt);
    function GetValue: LongInt;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
    procedure SetMinValue(v: longint);
    procedure SetMaxValue(v: longint);
    function GetDisplayString: string;
    procedure SetDisplayString(s: string);
    procedure Add(x : longint);
    procedure Subtract(x : longint);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBlongint);
  published
    property Value: longint read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property MinValue: longint read FMinValue write SetMinValue;
    property MaxValue: longint read FMaxValue write SetMaxValue;
    property vUnit: TUnit read FUnit write FUnit;
    property DisplayString: string read GetDisplayString write SetDisplayString;
  end;

  TBString = class(TBData)
  private
    FValue : string;
    procedure SetValue(v: string);
    function GetValue: string;
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBString);
  published
    property Value: string read GetValue write SetValue;
  end;

  TBDate = class(TBData)
  private
    FValue : TDate;
    procedure SetValue(v: TDate);
    function GetValue: TDate;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBDate);
  published
    property Value: TDate read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property DisplayString: string read GetSaveValue write SetSaveValue;
  end;

  TBTime = class(TBData)
  private
    FValue : TTime;
    procedure SetValue(v: TTime);
    function GetValue: TTime;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBTime);
  published
    property Value: TTime read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property DisplayString: string read GetSaveValue write SetSaveValue;
  end;

  TBDateTime = class(TBData)
  private
    FValue : TDateTime;
    procedure SetValue(v: TDateTime);
    function GetValue: TDateTime;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBDateTime);
  published
    property Value: TDateTime read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
    property DisplayString: string read GetSaveValue write SetSaveValue;
  end;

  TBBoolean = class(TBData)
  private
    FValue : boolean;
    procedure SetValue(v: boolean);
    function GetValue: boolean;
    function GetSaveValue: string;
    procedure SetSaveValue(s: string);
  public
    constructor Create(aParent : TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBBoolean);
  published
    property Value: boolean read GetValue write SetValue;
    property SaveValue: string read GetSaveValue write SetSaveValue;
  end;

  TStyle = class(TObject)
  private
    FFont : TFont;
    FControlColors : TColor;
    FPanelColors : TColor;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Assign(St : TStyle);
    procedure SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
    procedure ReadXML(iNode: TDOMNode);
    procedure SetStyle(Ctrl : TControl);
    procedure SetWinControlsStyle(WC : TWinControl);
    procedure SetControlsStyle(Frm : TForm);
  published
    property Font : TFont read FFont;
    property ControlColors : TColor read FControlColors write FControlColors;
    property PanelColors : TColor read FPanelColors write FPanelColors;
  end;

  TBSettings = class(TObject)
  private
    FFileName: string;
    FColorMethod: TBString;
    FIBUMethod: TBString;
    FDataLocation: TBString;
    FBrixCorrection: TBFloat;
    FFWHFactor: TBFloat;
    FMashHopFactor: TBFloat;
    FPelletFactor: TBFloat;
    FPlugFactor: TBFloat;
    FGrainAbsorption: TBFLoat;
    FPlaySounds: TBBoolean;
    FShowSplash: TBBoolean;
    FFTPSite : TBString;
    FFTPDir : TBString;
    FFTPUser : TBString;
    FFTPPasswd : TBString;
    FRemoteLoc : TBString;
    FUseCloud : TBBoolean;
    FSGBitterness : TBInteger;
    FSGUnit : TBString;
    FCheckForNewVersion: TBBoolean;
    FPercentages : TBBoolean;
    FScaleWithVolume : TBBoolean;
    FConfirmSave : TBBoolean;
    FShowOnlyInStock : TBBoolean;
    FAdjustAlfa : TBBoolean;
    FHopStorageTemp : TBInteger;
    FHopStorageType : TBInteger;
    FShowPossibleWithStock : TBBoolean;
    FStyle : TStyle;
    FSortBrews : TBInteger;
    FSortRecipes : TBInteger;
    FSortCloud : TBInteger;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Save;
    procedure Read;
  published
    property ColorMethod: TBString read FColorMethod;
    property IBUMethod: TBString read FIBUMethod;
    property DataLocation: TBString read FDataLocation;
    property BrixCorrection: TBFloat read FBrixCorrection; //1.03
    property FWHFactor: TBFloat read FFWHFactor;         //-30%
    property MashHopFactor: TBFloat read FMashHopFactor; //-10%
    property PelletFactor: TBFloat read FPelletFactor;  //10%
    property PlugFactor: TBFloat read FPlugFactor;      //2%
    property GrainAbsorption: TBFloat read FGrainAbsorption; //1.01
    property PlaySounds: TBBoolean read FPlaySounds;
    property ShowSplash: TBBoolean read FShowSplash;
    property FTPSite : TBString read FFTPSite;
    property FTPDir : TBString read FFTPDir;
    property FTPUser : TBString read FFTPUser;
    property FTPPasswd : TBString read FFTPPasswd;
    property RemoteLoc : TBString read FRemoteLoc;
    property UseCloud : TBBoolean read FUseCloud;
    property CheckForNewVersion : TBBoolean read FCheckForNewVersion;
    property SGBitterness : TBInteger read FSGBitterness;
    property SGUnit : TBString read FSGUnit;
    property Percentages : TBBoolean read FPercentages;
    property ScaleWithVolume : TBBoolean read FScaleWithVolume;
    property ConfirmSave : TBBoolean read FConfirmSave;
    property ShowOnlyInStock : TBBoolean read FShowOnlyInStock;
    property AdjustAlfa : TBBoolean read FAdjustAlfa;
    property HopStorageTemp : TBInteger read FHopStorageTemp;
    property HopStorageType : TBInteger read FHopStorageType;
    property ShowPossibleWithStock : TBBoolean read FShowPossibleWithStock;
    property Style : TStyle read FStyle;
    property SortBrews : TBInteger read FSortBrews;
    property SortRecipes : TBInteger read FSortRecipes;
    property SortCloud : TBInteger read FSortCloud;
  end;

  TBase = class(TObject)
  private
    FDataType : TDataType;
    FAutoNr: TBLongInt;
    FRecipe: TRecipe;
    FName: TBString;
    FVersion: TBInteger;
    FNotes: TBString;
    FSelected : boolean;
    function GetValueByIndex(i: integer): variant; virtual;
    function GetIndexByName(s: string): integer; virtual;
    function GetNameByIndex(i: integer): string; virtual;
    function GetValueByName(s: string): variant; virtual;
  public
    constructor Create(R: TRecipe); virtual;
    {$warning Destructor should have "override", not "virtual" but it causes crash. Serious memory issues!}
    //destructor Destroy; override;
    destructor Destroy; virtual;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); virtual;
    procedure ReadXML(iNode: TDOMNode); virtual;
    procedure Assign(Source: TBase); virtual;
    property ValueByIndex[i: integer]: variant read GetValueByIndex;
    property IndexByName[s: string]: integer read GetIndexByName;
    property ValueByName[s: string]: variant read GetValueByName;
  published
    property AutoNr: TBLongInt read FAutoNr;
    property Name: TBString read FName;
    property Notes: TBString read FNotes;
    property Recipe: TRecipe read FRecipe write FRecipe;
    property Selected : boolean read FSelected write FSelected;
    property DataType : TDataType read FDataType;
  end;

  TBaseArray = array of TBase;

  TIngredient = class(TBase)
  private
    FAmount: TBFloat;
    //BrewBuddyXML
    FInventory: TBFloat;
    FCost: TBFloat; //kosten per kilogram of per stuk
    FIngredientType: TIngredientType;
    FAlwaysOnStock: TBBoolean;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    Function IsInstock : boolean; virtual;
  published
    property Amount: TBFloat read FAmount;
    //BrewBuddyXML
    property Inventory: TBFloat read FInventory;
    property Cost: TBFloat read FCost;
    property IngredientType: TIngredientType
      read FIngredientType write FIngredientType;
    property AlwaysOnStock: TBBoolean read FAlwaysOnStock write FAlwaysOnStock;
  end;

  THop = class(TIngredient)
  private
    FAlfa: TBFloat;
    FUse: THopUse;
    FTime: TBFloat;
    FHopType: THopType;
    FForm: THopForm;
    FBeta: TBFloat;
    FHSI: TBFloat;
    FOrigin: TBString;
    FSubstitutes: TBString;
    FHumulene: TBFloat;
    FCaryophyllene: TBFloat;
    FCohumulone: TBFloat;
    FMyrcene: TBFloat;
    FTotalOil: TBFloat;
    FHarvestDate : TBDate;
    FLock : boolean;
    procedure SetUseName(s: string);
    procedure SetUseDisplayName(s: string);
    procedure SetTypeName(s: string);
    procedure SetTypeDisplayName(s: string);
    procedure SetFormName(s: string);
    procedure SetFormDisplayName(s: string);
    function GetUseName: string;
    function GetUseDisplayName: string;
    function GetTypeName: string;
    function GetTypeDisplayName: string;
    function GetFormName: string;
    function GetFormDisplayName: string;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetBitternessContribution: double;
    procedure SetBitternessContribution(d: double);
    function GetBitternessContributionWort : double;
    Function GetAlfaAdjusted : double;
    Function GetHumulene : double;
    Function GetCaryophyllene : double;
    Function GetMyrcene : double;
    Function GetCohumulone : double;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    Function GetAlfaFromAdjusted(Adj : double) : double;
    Function IsInstock : boolean; override;
    Function AmountToBitternessContribution(a : double) : double;
    Function BitternessContributionToAmount(bc : double) : double;
    Function FlavourContribution : double;
    Function AromaContribution : double;
  published
    property Alfa: TBFloat read FAlfa;
    property AlfaAdjusted : double read GetAlfaAdjusted;
    property Use: THopUse read FUse write FUse;
    property UseName: string read GetUseName write SetUseName;
    property UseDisplayName: string read GetUseDisplayName write SetUseDisplayName;
    property Time: TBFloat read FTime;
    property HopType: THopType read FHopType write FHopType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property Form: THopForm read FForm write FForm;
    property FormName: string read GetFormName write SetFormName;
    property FormDisplayName: string read GetFormDisplayName write SetFormDisplayName;
    property Beta: TBFloat read FBeta;
    property HSI: TBFloat read FHSI;
    property Origin: TBString read FOrigin;
    property Substitutes: TBString read FSubstitutes;
    property Humulene: TBFloat read FHumulene;
    property Caryophyllene: TBFloat read FCaryophyllene;
    property Cohumulone: TBFloat read FCohumulone;
    property Myrcene: TBFloat read FMyrcene;
    property TotalOil: TBFloat read FTotalOil;
    property HarvestDate : TBDate read FHarvestDate;
    property BitternessContribution: double
      read GetBitternessContribution write SetBitternessContribution;
    property BitternessContributionWort : double read GetBitternessContributionWort;
    property Lock : boolean read FLock write FLock;
    property HumuleneConc : double read GetHumulene;
    property CaryophylleneConc : double read GetCaryophyllene;
    property MyrceneConc : double read GetMyrcene;
    property CohumuloneConc : double read GetCohumulone;
  end;

  TFermentable = class(TIngredient)
  private
    FFermentableType: TFermentableType;
    FYield: TBFloat;
    FColor: TBFloat;
    FAddAfterBoil: TBBoolean;
    FOrigin: TBString;
    FSupplier: TBString;
    FCoarseFineDiff: TBFloat;
    FMoisture: TBFloat;
    FDiastaticPower: TBFloat;
    FProtein: TBFloat;
    FDissolvedProtein: TBFloat;
    FMaxInBatch: TBFloat;
    FRecommendMash: TBBoolean;
    FIbuGalPerLb: TBFloat;
    //BrewBuddyXML
    FGrainType: TGrainType;
    FAdded: TAddedType;
    FPercentage: TBFloat;
    FAdjustToTotal100 : TBBoolean;
    FDIpH : TBFloat;
    FAcidTo57 : TBFloat;
    FLockPercentage : boolean;
    procedure SetTypeName(s: string);
    procedure SetTypeDisplayName(s: string);
    procedure SetGrainTypeName(s: string);
    procedure SetGrainTypeDisplayName(s: string);
    procedure SetAddedTypeName(s: string);
    procedure SetAddedTypeDisplayName(s: string);
    function GetTypeName: string;
    function GetTypeDisplayName: string;
    function GetGrainTypeName: string;
    function GetGrainTypeDisplayName: string;
    function GetAddedTypeName: string;
    function GetAddedTypeDisplayName: string;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetKolbachIndex: double;
    function GetExtract: double;
    Procedure SetpHParameters(force : boolean);
    Procedure AdjustGrainType(gt : TGrainType);
    Procedure CheckMissingFields;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    Function IsInstock : boolean; override;
    Function BufferCapacity : double;  //mEq/kg.pH
    Function AcidRequired(ZpH : double) : double; //mEq/kg
  published
    property FermentableType: TFermentableType
      read FFermentableType write FFermentableType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property Yield: TBFloat read FYield;
    property Color: TBFloat read FColor;
    property AddAfterBoil: TBBoolean read FAddAfterBoil;
    property Origin: TBString read FOrigin;
    property Supplier: TBString read FSupplier;
    property CoarseFineDiff: TBFloat read FCoarseFineDiff;
    property Moisture: TBFloat read FMoisture;
    property DiastaticPower: TBFloat read FDiastaticPower;
    property Protein: TBFloat read FProtein;
    property DissolvedProtein: TBFloat read FDissolvedProtein;
    property KolbachIndex: double read GetKolbachIndex;
    property MaxInBatch: TBFloat read FMaxInBatch;
    property RecommendMash: TBBoolean read FRecommendMash;
    property IbuGalPerLb: TBFloat read FIbuGalPerLb;
    property GrainType: TGrainType read FGRainType;
    property GrainTypeName: string read GetGrainTypeName write SetGrainTypeName;
    property GrainTypeDisplayName: string
      read GetGrainTypeDisplayName write SetGrainTypeDisplayName;
    property AddedType: TAddedType read FAdded write FAdded;
    property AddedTypeName: string read GetAddedTypeName write SetAddedTypeName;
    property AddedTypeDisplayName: string
      read GetAddedTypeDisplayName write SetAddedTypeDisplayName;
    property Percentage: TBFloat read FPercentage;
    property Extract: double read GetExtract;
    property AdjustToTotal100 : TBBoolean read FAdjustToTotal100;
    property DIpH : TBFloat read FDIpH;
    property AcidTo57 : TBFloat read FAcidTo57;
    property LockPercentage : boolean read FLockPercentage write FLockPercentage;
  end;

  TYeast = class(TIngredient)
  private
    FYeastType: TYeastType;
    FForm: TYeastForm;
    FAmountIsWeight: TBBoolean;
    FLaboratory: TBString;
    FProductID: TBString;
    FMinTemperature: TBFloat;
    FMaxTemperature: TBFloat;
    FFlocculation: TFlocculation;
    FAttenuation: TBFloat;
    FBestFor: TBString;
    FTimesCultured: TBInteger;
    FMaxReuse: TBInteger;
    FAddToSecondary: TBBoolean;
    //Extensions
    FCultureDate: TBDate;
    //BrewBuddy XML
    FStarterType: TStartertype;
    FStarterMade: TBBoolean;
    FStarterVolume1, FStarterVolume2, FStarterVolume3: TBFloat;
    FOGStarter: TBFloat;
    FTimeAerated: TBFloat; //in hours
    FTemperature: TBFloat;
//    FNutrientsAdded: TBBoolean;
//    FNameNutrients: TBString;
//    FAmountNutrients: TBFloat; //in kg
    FZincAdded: TBBoolean;
    FAmountZinc: TBFloat; //in kg
    FAmountYeast: TBFloat;
    //amount of yeast used in batch or in starter (kg, l or packs)
    FAmountExtract: TBFloat; // in kg
    FCostExtract: TBFloat;
    function GetTypeName: string;
    procedure SetTypeName(s: string);
    function GetTypeDisplayName: string;
    procedure SetTypeDisplayName(s: string);
    function GetFormName: string;
    procedure SetFormName(s: string);
    function GetFormDisplayName: string;
    procedure SetFormDisplayName(s: string);
    function GetFlocculationName: string;
    procedure SetFlocculationName(s: string);
    function GetFlocculationDisplayName: string;
    procedure SetFlocculationDisplayName(s: string);
    function GetStarterTypeName: string;
    procedure SetStarterTypeName(s: string);
    function GetStarterTypeDisplayName: string;
    procedure SetStarterTypeDisplayName(s: string);
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    function CalcAmountYeast: double; //calculate the amount of yeast in number of cells
    Function IsInstock : boolean; override;
  published
    property YeastType: TYeastType read FYeastType write FYeastType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property Form: TYeastForm read FForm write FForm;
    property FormName: string read GetFormName write SetFormName;
    property FormDisplayName: string read GetFormDisplayName write SetFormDisplayName;
    property AmountIsWeight: TBBoolean read FAmountIsWeight;
    property Laboratory: TBString read FLaboratory;
    property ProductID: TBString read FProductID;
    property MinTemperature: TBFloat read FMinTemperature;
    property MaxTemperature: TBFloat read FMaxTemperature;
    property Flocculation: TFlocculation read FFlocculation write FFlocculation;
    property FlocculationName: string read GetFlocculationName
      write SetFlocculationName;
    property FlocculationDisplayName: string
      read GetFlocculationDisplayName write SetFlocculationDisplayName;
    property Attenuation: TBFloat read FAttenuation;
    property BestFor: TBString read FBestFor write FBestFor;
    property TimesCultured: TBInteger read FTimesCultured;
    property MaxReuse: TBInteger read FMaxReuse;
    property AddToSecondary: TBBoolean read FAddToSecondary;
    property CultureDate: TBDate read FCultureDate;
    property StarterType: TStartertype read FStarterType;
    property StarterTypeName: string read GetStarterTypeName write SetStarterTypeName;
    property StarterTypeDisplayName: string
      read GetStarterTypeDisplayName write SetStarterTypeDisplayName;
    property StarterMade: TBBoolean read FStarterMade;
    property StarterVolume1: TBFloat read FStarterVolume1;
    property StarterVolume2: TBFloat read FStarterVolume2;
    property StarterVolume3: TBFloat read FStarterVolume3;
    property OGStarter: TBFloat read FOGstarter;
    property TimeAerated: TBFloat read FTimeAerated;
    property Temperature: TBFloat read FTemperature;
//    property NutrientsAdded: TBBoolean read FNutrientsAdded;
//    property NameNutrients: TBString read FNameNutrients;
//    property AmountNutrients: TBFloat read FAmountNutrients;
    property ZincAdded: TBBoolean read FZincAdded;
    property AmountZinc: TBFloat read FAmountZinc;
    property AmountYeast: TBFloat read FAmountYeast;
    property AmountExtract: TBFloat read FAmountExtract;
    property CostExtract: TBFloat read FCostExtract;
  end;

  TMisc = class(TIngredient)
  private
    FMiscType: TMiscType;
    FUse: TMiscUse;
    FTime: TBFloat;
    FAmountIsWeight: TBBoolean;
    FUseFor: TBString;
    FFreeField : TBFloat;
    FFreeFieldName : TBString;
    function GetTypeName: string;
    procedure SetTypeName(s: string);
    function GetTypeDisplayName: string;
    procedure SetTypeDisplayName(s: string);
    function GetUseName: string;
    procedure SetUseName(s: string);
    function GetUseDisplayName: string;
    procedure SetUseDisplayName(s: string);
    procedure SetAmountIsWeight(b: boolean);
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    Function IsInstock : boolean; override;
  published
    property MiscType: TMiscType read FMiscType write FMiscType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property Use: TMiscUse read FUse write FUse;
    property UseName: string read GetUseName write SetUseName;
    property UseDisplayName: string read GetUseDisplayName write SetUseDisplayName;
    property Time: TBFloat read FTime;
    property AmountIsWeight: TBBoolean read FAmountIsWeight;
    property UseFor: TBString read FUseFor;
    property FreeField : TBFloat read FFreeField;
    property FreeFieldName : TBString read FFreeFieldName;
  end;

  TWater = class(TIngredient)
  private
    FCalcium: TBFloat;
    FBicarbonate: TBFloat;
    FSulfate: TBFloat;
    FChloride: TBFloat;
    FSodium: TBFloat;
    FMagnesium: TBFloat;
    FpH: TBFloat;
    //BrewBuddyXML
    FTotalAlkalinity : TBFloat;
    FDefault : TBBoolean;
    FDilutionFactor: TBFloat; //% diluted with distilled water
    FCaSO4: TBFloat; //kg added CaSO4
    FCaCl2: TBFloat; //kg added CaCl
    FCaCO3: TBFloat; //kg added CaCO3
    FMgSO4: TBFloat; //kg added MgSO4
    FNaHCO3: TBFloat; //kg added NaHCO3
    FNaCl: TBFloat; //kg added NaCl
    FHCl: TBFloat; //kg added Hcl
    FH3PO4: TBFloat; //kg added H3PO4
    FLacticAcid: TBFloat; //kg added Lactic acid
    FMHCl: TBFloat; //% w/w of HCl in added HCl solution
    FMH3PO4: TBFloat; //% w/w of H3PO4 in added H3PO4 solution
    FMLacticAcid: TBFloat; //% w/w of lactic acid in added lactic acid solution
    FDemiWater : boolean;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    Function ZRA(pHZ : double) : double;
    Function ZAlkalinity(pHZ : double) : double;
    Function ProtonDeficit(pHZ : double) : double;
    Function MashpH : double;
    Function MashpH2(PrDef : double) : double;
    Procedure AddMinerals(Ca, Mg, Na, HCO3, Cl, SO4 : double);
  private
    function GetResidualAlkalinity: double;
    function GetAlkalinity: double; //mEq/l
    function GetHardness: double;
    function GetEstpHMash: double;
  published
    property Calcium: TBFloat read FCalcium;
    property Bicarbonate: TBFloat read FBicarbonate;
    property Sulfate: TBFloat read FSulfate;
    property Chloride: TBFloat read FChloride;
    property Sodium: TBFloat read FSodium;
    property Magnesium: TBFloat read FMagnesium;
    property pHwater: TBFloat read FpH;
    property TotalAlkalinity : TBFloat read FTotalAlkalinity;
    property ResidualAlkalinity: double read GetResidualAlkalinity;
//    property Alkalinity: double read GetAlkalinity;//mEq/l
    property Hardness: double read GetHardness;
    property EstpHMash: double read GetEstpHMash;
    property DefaultWater : TBBoolean read FDefault;
    property DemiWater : boolean read FDemiWater;
  end;

  TEquipment = class(TBase)
  private
    FBoilSize: TBFloat;
    FBatchSize: TBFloat; //Volume at start of fermentation
    FTunVolume: TBFloat;
    FTunWeight: TBFloat;
    FTunSpecificHeat: TBFloat;  //Cal/gram-deg C
    FTopUpWater: TBFloat;
    FTopUpWaterBrewDay : TBFloat;
    FTrubChillerLoss: TBFloat;
    FEvapRate: TBFloat;  // %/h
    FBoilTime: TBFloat;
    FCalcBoilVolume: TBBoolean;
    FLauterDeadSpace: TBFloat;
    FTopUpKettle: TBFloat;
    FHopUtilization: TBFloat;
    // Large batch hop utilization. This value should be 100% for batches less than 20 gallons, but may be higher (200% or more) for very large batch equipment.
    //BrewBuddyXML
    FLauterVolume: TBFloat;
    FKettleVolume: TBFloat;
    FEfficiency: TBFloat;
    FTunMaterial: TBString;
    FTunHeight : TBFloat;
    FKettleHeight : TBFloat;
    FLauterHeight : TBFloat;
    FMashVolume : TBFloat;
    FEffFactBD: TBFloat;
    FEffFactSG: TBFloat;
    FEffFactC: TBFloat;
    FAttFactAttY: TBFloat;
    FAttFactBD: TBFloat;
    FAttFactTemp: TBFloat;
    FAttFactTTime: TBFloat;
    FAttFactPercCara: TBFloat;
    FAttFactPercS: TBFloat;
    FAttFactC: TBFloat;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    procedure CalcEfficiencyFactors;
    function CalcEfficiency(OG, WtGR: double): double;
    procedure CalcAttenuationFactors;
    function EstimateFG(AttY, BD, Temp, TTime, PCara, PSugar: double): double;
    Function VolumeInKettle(h : double) : double;
    Function CmInKettle(vol : double) : double;
    Function VolumeInTun(h : double) : double;
    Function CmInTun(vol : double) : double;
    Function VolumeInLautertun(h : double) : double;
    Function CmInLautertun(vol : double) : double;
  published
    property BoilSize: TBFloat read FBoilSize;
    property BatchSize: TBFloat read FBatchSize;
    property TunVolume: TBFloat read FTunVolume;
    property TunWeight: TBFloat read FTunWeight;
    property TunSpecificHeat: TBFloat read FTunSpecificHeat;
    property TopUpWater: TBFloat read FTopUpWater;
    property TopUpWaterBrewDay : TBFloat read FTopUpWaterBrewDay;
    property TrubChillerLoss: TBFloat read FTrubChillerLoss;
    property EvapRate: TBFloat read FEvapRate;
    property BoilTime: TBFloat read FBoilTime;
    property CalcBoilVolume: TBBoolean read FCalcBoilVolume;
    property LauterDeadSpace: TBFloat read FLauterDeadSpace;
    property TopUpKettle: TBFloat read FTopUpKettle;
    property HopUtilization: TBFloat read FHopUtilization;
    property LauterVolume: TBFloat read FLauterVolume;
    property KettleVolume: TBFloat read FKettleVolume;
    property TunMaterial: TBString read FTunMaterial;
    property TunHeight : TBFloat read FTunHeight;
    property KettleHeight : TBFloat read FKettleHeight;
    property LauterHeight : TBFloat read FLauterHeight;
    property MashVolume : TBFloat read FMashVolume;
    property Efficiency: TBFloat read FEfficiency;
    property EffFactBD: TBFloat read FEffFactBD;
    property EffFactSG: TBFloat read FEffFactSG;
    property EffFactC: TBFloat read FEffFactC;
    property AttFactAttY: TBFloat read FAttFactAttY;
    property AttFactBD: TBFloat read FAttFactBD;
    property AttFactTemp: TBFloat read FAttFactTemp;
    property AttFactTTime: TBFloat read FAttFactTTime;
    property AttFactPercCara: TBFloat read FAttFactPercCara;
    property AttFactPercS: TBFloat read FAttFactPercS;
    property AttFactC: TBFloat read FAttFactC;
//    property NN : TBHNN read FNN;
  end;

  TBeerStyle = class(TBase)
  private
    FCategory: TBString;
    FCategoryNumber: TBString;
    FStyleLetter: TBString;
    FStyleGuide: TBString;
    FStyleType: TStyleType;
    FOGMin: TBFloat;
    FOGMax: TBFloat;
    FFGMin: TBFloat;
    FFGMax: TBFloat;
    FIBUMIn: TBFloat;
    FIBUMax: TBFloat;
    FColorMin: TBFloat;
    FColorMax: TBFloat;
    FCarbMin: TBFloat;
    FCarbMax: TBFloat;
    FABVMin: TBFloat;
    FABVMax: TBFloat;
    FProfile: TBString;
    FIngredients: TBString;
    FExamples: TBString;
    function GetTypeName: string;
    procedure SetTypeName(s: string);
    function GetTypeDisplayName: string;
    procedure SetTypeDisplayName(s: string);
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetBUGUMin: double;
    function GetBUGUMax: double;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    function GetValueByIndex(i: integer): variant; override;
  published
    property Category: TBString read FCategory;
    property CategoryNumber: TBString read FCategoryNumber;
    property StyleLetter: TBString read FStyleLetter;
    property StyleGuide: TBString read FStyleGuide;
    property StyleType: TStyleType read FStyleType write FStyleType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property OGMin: TBFloat read FOGMin;
    property OGMax: TBFloat read FOGMax;
    property FGMin: TBFloat read FFGMin;
    property FGMax: TBFloat read FFGMax;
    property IBUMIn: TBFloat read FIBUmin;
    property IBUMax: TBFloat read FIBUmax;
    property ColorMin: TBFloat read FColorMin;
    property ColorMax: TBFloat read FColorMax;
    property CarbMin: TBFloat read FCarbMin;
    property CarbMax: TBFloat read FCarbMax;
    property ABVMin: TBFloat read FABVmin;
    property ABVMax: TBFloat read FABVmax;
    property Profile: TBString read FProfile;
    property Ingredients: TBString read FIngredients;
    property Examples: TBString read FExamples;
    property BUGUmin: double read GetBUGUmin;
    property BUGUmax: double read GetBUGUmax;
  end;

  TMashStep = class(TBase)
  private
    FPriorStep: TMashStep;
    FNextStep: TMashStep;
    FMashStepType: TMashStepType;
    FInfuseAmount: TBFloat;
    FInfuseTemp: TBFloat;
    FStepTemp: TBFloat;
    FStepTime: TBFloat;
    FRampTime: TBFloat;
    FEndTemp: TBFloat;
    //BrewBuddyXML
    FpH: TBFloat;
    function GetTypeName: string;
    procedure SetTypeName(s: string);
    function GetTypeDisplayName: string;
    procedure SetTypeDisplayName(s: string);
    function GetWaterToGrainRatio: double;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetDisplayString: string;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    procedure CalcStep;
  published
    property PriorStep: TMashStep read FPriorStep write FPriorStep;
    property NextStep: TMashStep read FNextStep write FNextStep;
    property MashStepType: TMashStepType read FMashStepType write FMashStepType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property InfuseAmount: TBFloat read FInfuseAmount;
    property InfuseTemp: TBFloat read FInfuseTemp;
    property StepTemp: TBFloat read FStepTemp;
    property StepTime: TBFloat read FStepTime;
    property RampTime: TBFloat read FRampTime;
    property EndTemp: TBFloat read FEndTemp;
    property pHstep: TBFloat read FpH;
    property WaterToGrainRatio: double read GetWaterToGrainRatio;
    property DisplayString: string read GetDisplayString;
  end;

  TMash = class(TBase)
  private
    FMashSteps: array of TMashStep;
    FGrainTemp: TBFloat;
    FTunTemp: TBFloat;
    FSpargeTemp: TBFloat;
    FSGLastRunnings: TBFloat;
    FpHLastRunnings: TBFloat;
    FpH: TBFloat;
    FTunWeight: TBFloat;
    FTunSpecificHeat: TBFloat;
    FEquipAdjust: TBBoolean;
    function GetMashStep(i: integer): TMashStep;
    function GetNumMashSteps: integer;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetMashWaterVolume: double;
    procedure SetMashWaterVolume(V: double);
    function GetSpargeVolume: double;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    function AddMashStep: TMashStep;
    function InsertMashStep(i: integer): TMashStep;
    procedure RemoveMashStep(i: integer);
    procedure Assign(Source: TBase); override;
    Procedure Sort;
    procedure CalcMash;
    function TotalMashTime: double;
    function AverageTemperature: double;
    Function TimeBelow65 : double;
    Function TimeAbove65 : double;
    property MashStep[i: integer]: TMashStep read GetMashStep;
  published
    property NumMashSteps: integer read GetNumMashSteps;
    property GrainTemp: TBFloat read FGrainTemp;
    property TunTemp: TBFloat read FTunTemp;
    property SpargeTemp: TBFloat read FSpargeTemp;
    property SGLastRunnings: TBFloat read FSGLastRunnings;
    property pHlastRunnings: TBFloat read FpHLastRunnings;
    property pHsparge: TBFloat read FpH;
    property TunWeight: TBFloat read FTunWeight;
    property TunSpecificHeat: TBFloat read FTunSpecificHeat;
    property EquipAdjust: TBBoolean read FEquipAdjust;
    property MashWaterVolume: double read GetMashWaterVolume write SetMashWaterVolume;
    property SpargeVolume: double read GetSpargeVolume;
  end;

  TFermMeasurement = class(TBase)
  private
    FDateTime: TBDateTime;
    FTempS1: TBFloat;
    FSetPoint: TBFloat;
    FCoolpower: TBFloat;
    FCooling: TBInteger;
    FTempS2: TBFloat;
    FCO2: TBFloat;
    FSG: TBFloat;
    FHeating: TBInteger;
    FCO22: TBFloat;
    function GetDisplayStringByIndex(i: integer): string;
    procedure SetDisplayStringByIndex(i: integer; s: string);
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    property DisplayStringByIndex[i: integer]: string
      read GetDisplayStringByIndex write SetDisplayStringByIndex;
  published
    property DateTime: TBDateTime read FDateTime;
    property TempS1: TBFloat read FTempS1;
    property SetPoint: TBFloat read FSetPoint;
    property Coolpower: TBFloat read FCoolpower;
    property Cooling: TBInteger read FCooling;
    property TempS2: TBFloat read FTempS2;
    property CO2: TBFloat read FCO2;
    property SGmeas: TBFloat read FSG;
    property Heating: TBInteger read FHeating;
    property CO22: TBFloat read FCO22;
  end;

  TFermMeasurements = class(TBase)
  private
    FMeasurements: TBaseArray; //array of TFermMeasurement;
    function GetMeasurement(i: integer): TFermMeasurement;
    function GetNumMeasurements: integer;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure Assign(Source: TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    function AddMeasurement: TFermMeasurement;
    procedure RemoveMeasurement(i: integer);
    procedure Clear;
    procedure Sort;
    function IsEmpty(index: integer): boolean;
    property Measurement[i: integer]: TFermMeasurement read GetMeasurement;
    property Measurements: TBaseArray read FMeasurements;
  published
    property NumMeasurements: integer read GetNumMeasurements;
  end;

  TCheckListItem = class(TBase)
  private
    FItem : TBBoolean;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure Assign(Source: TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
  published
    property Item : TBBoolean read FItem;
  end;

  TCheckListGroup = class(TBase)
  private
    FCaption : TBString;
    FItems : array of TCheckListItem;
    Function GetItem(i : integer) : TCheckListItem;
    Function GetNumItems : integer;
    Function GetNumItemsChecked : integer;
    Function GetChecked(i : integer) : boolean;
    procedure SetChecked(i : integer; b : boolean);
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure Assign(Source: TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    function AddItem : TCheckListItem;
    procedure RemoveItem(i : integer);
    procedure Clear;
    property Checked[i : integer] : boolean read GetChecked write SetChecked;
    property Item[i : integer] : TCheckListItem read GetItem;
  published
    property Caption : TBString read FCaption;
    property NumItems : integer read GetNumItems;
    property NumItemsChecked : integer read GetNumItemsChecked;
  end;

  TCheckList = class(TBase)
  private
    FGroups : array of TCheckListGroup;
    Function GetNumItems : integer;
    Function GetNumItemsChecked : integer;
    Function GetNumGroups : integer;
    Function GetGroup(i : integer) : TCheckListGroup;
    procedure DoCreateCheckList(CL : TCheckList);
    Function HasChanged(CL : TCheckList) : boolean;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure Assign(Source: TBase); override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    function AddGroup : TCheckListGroup;
    procedure RemoveGroup(i : integer);
    procedure Clear;
    Procedure CreateCheckList;
    property Group[i : integer] : TCheckListGroup read GetGroup;
  published
    property NumGroups : integer read GetNumGroups;
    property NumItems : integer read GetNumItems;
    property NumItemsChecked : integer read GetNumItemsChecked;
  end;

  TIngredientsArray = array of TIngredient;

  TRecipe = class(TBase)
  private
    FRecipeType: TRecipeType;
    FStyle: TBeerStyle;
    FEquipment: TEquipment;
    FBrewer: TBString;
    FAsstBrewer: TBString;
    FBatchSize: TBFloat;
    FBoilSize: TBFloat;
    FBoilTime: TBFloat;
    FEfficiency: TBFloat;
    FHops: TIngredientsArray;
    FFermentables: TIngredientsArray;
    FMiscs: TIngredientsArray;
    FYeasts: TIngredientsArray;
    FWaters: TIngredientsArray;
    FMash: TMash;
    FCheckList : TCheckList;
    FTasteNotes: TBString;
    FTastingRate: TBFloat;
    FOG: TBFloat;
    FFG: TBFloat;
    FFermentationStages: TBInteger;
    FPrimaryAge: TBFloat;
    FPrimaryTemp: TBFloat;
    FSecondaryAge: TBFloat;
    FSecondaryTemp: TBFloat;
    FTertiaryAge: TBFloat;
    FTertiaryTemp: TBFloat;
    FAge: TBFloat;
    FAgeTemp: TBFloat;
    FDate: TBDate;
    FCarbonation: TBFloat;
    FForcedCarbonation: TBBoolean;
    FPrimingSugarName: TBString;
    FCarbonationTemp: TBFloat;
    FPrimingSugarEquiv: TBFloat;
    FKegPrimingFactor: TBFloat;
    //BeerXML Extensions
    FEstOG: TBFloat;
    FEstFG: TBFloat; //estimated on predicted OG
    FEstFG2: TBFloat; //estimated on measured OG
    FEstColor: TBFloat;
    FIBU: TBFloat;
    FIBUmethod: TIBUmethod;
    FEstABV: TBFloat;
    FABV: TBFloat;
    FActualEfficiency: TBFloat;
    FCalories: TBFloat; //bv 200 kCal/30 cl
    //BrewBuddyXML
//    FEstOGFermenter : TBFloat;
    FParentAutoNr : TBString;
    FColorMethod: TColorMethod;
    FNrRecipe: TBString; //code given by brewer
    FpHAdjustmentWith: TBString;
    FpHAdjusted: TBFloat;
    FTargetpH : TBFloat;
    FSGEndMash : TBFloat;
    FOGBeforeBoil: TBFloat;
    FpHBeforeBoil: TBFloat;
    FpHAfterBoil: TBFloat;
    FAcidSparge : TBFloat;
    FAcidSpargePerc : TBFloat;
    FAcidSpargeType : TAcidType;
    FVolumeBeforeBoil: TBFloat;
    FVolumeAfterBoil: TBFloat;
    FVolumeFermenter: TBFloat; //volume of wort measured in the fermenter
    FOGFermenter: TBFloat; //OG in fermenter after top-up water
    FTimeAeration: TBFloat; //length of aeration of wort in hours
    FSGEndPrimary: TBFloat;
    FStartTempPrimary: TBFloat;
    FMaxTempPrimary: TBFloat;
    FEndTempPrimary: TBFloat;
    FDateBottling: TBDate;
    FVolumeBottles: TBFloat; //volume of beer bottled
    FVolumeKegs: TBFloat;    //Volume of beer kegged
    FCarbonationKegs: TBFloat;  //volumes of CO2 in the keg
    FForcedCarbonationKegs: TBBoolean;
    FCarbonationTempKegs: TBFloat;
    FAmountPrimingBottles: TBFloat; //amount of priming sugar in bottles g/l
    FAmountPrimingKegs: TBFloat;    //amount of priming sugar in kegs    g/l
    FPressureKegs: TBFloat;         //pressure set on kegs when forced carbonated
    FPrimingSugarBottles: TPrimingSugar;
    FPrimingSugarKegs: TPrimingSugar;
    FTasteDate: TBDate;
    FTasteColor: TBString;
    FTasteTransparency: TBString;
    FTasteHead: TBString;
    FTasteAroma: TBString;
    FTasteTaste: TBString;
    FTasteMouthfeel: TBString;
    FTasteAftertaste: TBString;
    FTimeStarted: TBTime;
    FTimeEnded: TBTime;
    FLocked: TBBoolean;
    FInventoryReduced: TBBoolean;
    FCoolingMethod: TCoolingMethod;
    FCoolingTime: TBFloat;
    FCoolingTo: TBFloat;
    FWhirlpoolTime: TBFloat;
    FAerationType: TAerationType;
    FAerationFlowRate : TBFloat;
    FAbsorbedByGrain: double;
    FFermMeasurements: TFermMeasurements;
    FVolumeHLT: TBFloat; //amount of water in the HLT (sparge + other)
    FSpargeWaterComposition: integer;
    FLockEfficiency: boolean;
    FDividedType: TBInteger;
    //if batch is divided then 0:after mash; 1:after boil; 2:after primary;else -1
    FDivisionType: TBInteger;
    //if batch a dividion of another batch then 0:after mash; 1:after boil; 2:after primary; else -1
    FDivisionFrom: TBInteger; //AutoNr of batch from which this batch is divided
    FRecType : TRecType;
    FNumMissingIngredients : longint;
    FMashWater : TWater;
    FCalcAcid : TBBoolean;
    function GetHop(i: integer): THop;
    function GetNumHops: integer;
    function GetNumHopsMash: integer;
    function GetNumHopsBoil: integer;
    function GetFermentable(i: integer): TFermentable;
    function GetBaseMalt(i : integer) : TFermentable;
    function GetSpecialtyMalt(i : integer) : TFermentable;
    function GetSugar(i : integer) : TFermentable;
    function GetNumFermentables: integer;
    function GetNumBasemalts : integer;
    function GetNumSpecialtymalts : integer;
    function GetNumSugars : integer;
    function GetNumFermentablesMash: integer;
    function GetNumFermentablesBoil: integer;
    function GetMisc(i: integer): TMisc;
    function GetNumMiscs: integer;
    function GetNumWaterAgents: integer;
    function GetNumMiscsBoil: integer;
    function GetYeast(i: integer): TYeast;
    function GetNumYeasts: integer;
    function GetWater(i: integer): TWater;
    function GetNumWaters: integer;
    function GetTypeName: string;
    procedure SetTypeName(s: string);
    function GetTypeDisplayName: string;
    procedure SetTypeDisplayName(s: string);
    procedure SetIBUmethod(im: TIBUmethod);
    function GetIBUMethodName: string;
    procedure SetIBUMethodName(s: string);
    function GetIBUMethodDisplayName: string;
    procedure SetIBUMethodDisplayName(s: string);
    procedure SetColorMethod(cm: TColorMethod);
    function GetColorMethodName: string;
    procedure SetColorMethodName(s: string);
    function GetColorMethodDisplayName: string;
    procedure SetColorMethodDisplayName(s: string);
    function GetGrainMass: double;
    function GetValueByIndex(i: integer): variant; override;
    function GetIndexByName(s: string): integer; override;
    function GetNameByIndex(i: integer): string; override;
    function GetIngredient(i: integer): TIngredient;
    function GetIngredientType(i: integer): TIngredientType;
    function GetNumIngredients: integer;
    function GetSGEndMashCalc : double;
    function GetSGStartBoil: double;
    function GetVolumeBeforeBoil : double;
    function GetVolumeAfterBoil : double;
    function GetTotalFermentableMass: double;
    function GetTotalSugars: double;
    function GetGrainMassMash: double;
    function GetPercBaseMalt: double;
    function GetPercCrystalMalt: double;
    function GetPercRoastMalt: double;
    function GetPercSugar: double;
    function GetMashThickness: double;
    function GetpHdemi: double;
    function GetRAmin: double;
    function GetRAopt: double;
    function GetRAmax: double;
    function GetBUGU: double;
    function GetOptClSO4ratio: double;
    function GetCoolingMethodName: string;
    procedure SetCoolingMethodName(s: string);
    function GetCoolingMethodDisplayName: string;
    procedure SetCoolingMethodDisplayName(s: string);
    function GetPrimingSugarBottlesName: string;
    procedure SetPrimingSugarBottlesName(s: string);
    function GetPrimingSugarBottlesDisplayName: string;
    procedure SetPrimingSugarBottlesDisplayName(s: string);
    function GetPrimingSugarKegsName: string;
    procedure SetPrimingSugarKegsName(s: string);
    function GetPrimingSugarKegsDisplayName: string;
    procedure SetPrimingSugarKegsDisplayName(s: string);
    function GetAerationTypeName : string;
    procedure SetAerationTypeName(s : string);
    function GetAerationTypeDisplayName : string;
    procedure SetAerationTypeDisplayName(s : string);
    Function GetAcidSpargeTypeName : string;
    procedure SetAcidSpargeTypeName(s : string);
    Function GetAcidSpargeTypeDisplayName : string;
    procedure SetAcidSpargeTypeDisplayName(s : string);
    function GetApparentAttenuation: double;
    function GetAAEndPrimary: double;
    function GetRealAttenuation: double;
    function GetCa: double;
    function GetMg: double;
    function GetNa: double;
    function GetHCO3: double;
    function GetCl: double;
    function GetSO4: double;
    Function GetTotalAlkalinity : double;
    function GetRA: double;
    function GetEfficiency: double;
    procedure SetEfficiency(d: double);
    Function GetNumNumbers : Longint;
  public
    constructor Create(R: TRecipe); override;
    destructor Destroy; override;
    procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode; bxml: boolean); override;
    procedure ReadXML(iNode: TDOMNode); override;
    procedure Assign(Source: TBase); override;
    Function GetNumberByIndex(i : longint) : double;
    Function GetNumberDecimalsByName(s : string) : integer;
    Function GetNumberDecimalsByIndex(i : longint) : integer;
    Function GetNumberNameByIndex(i : Longint) : string;
    Function GetNumberByName(s : string) : double;
    Function GetNumberIndexByName(s : string) : LongInt;
    Function GetNumberDisplayUnitByIndex(i : longint) : string;
    Function GetNumberDisplayUnitByName(s : string) : string;
    procedure CalcBitterness;
    function GetAromaBitterness : double;
    procedure AdjustBitterness(NewIBU: double);
    Function CalcBitternessWort : double;
    procedure CalcColor;
    function CalcColorMash: double;
    function CalcColorWort: double;
    procedure CalcWaterBalance;
    procedure CalcOG;
    procedure EstimateFG;
    Function CalcMashEfficiency : double;
    function CalcEfficiencyBeforeBoil: double;
    function CalcOGAfterBoil: double;
    function CalcEfficiencyAfterBoil: double;
    function CalcVirtualOGduringFermentation: double;
    Function CalcOGFermenter : double;
    Function CalcIBUFermenter : double;
    Function CalcColorFermenter : double;
    procedure CalcFermentablesFromPerc(OG: double);
    procedure CheckPercentage;
    procedure RecalcPercentages;
    Function CalcCosts : double;
    Procedure CalcCalories;
    Function OverPitchFactor : double;
    function AddHop: THop;
    procedure RemoveHop(i: integer);
    procedure RemoveHopByReference(I: TIngredient);
    procedure RemoveHops;
    function AddFermentable: TFermentable;
    procedure RemoveFermentable(i: integer);
    procedure RemoveFermentableByReference(I: TIngredient);
    procedure RemoveFermentables;
    function AddMisc: TMisc;
    procedure RemoveMisc(i: integer);
    procedure RemoveMiscByReference(I: TIngredient);
    procedure RemoveMiscs;
    function AddYeast: TYeast;
    procedure RemoveYeast(i: integer);
    procedure RemoveYeastByReference(I: TIngredient);
    procedure RemoveYeasts;
    function AddWater: TWater;
    procedure RemoveWater(i: integer);
    procedure RemoveWaterByReference(I: TIngredient);
    procedure RemoveWaters;
    procedure RemoveIngredient(i: integer);
    Procedure CalcMashWater;
    function GetIngredientIndex(I: TIngredient): integer;
    function GetPercFermentable(i: integer): double;
    function GetPercSugarContent(i: integer): double;
    procedure Scale(NewSize: double);
    function GetNeededYeastCells: double;//number of yeast cells needed in billion cells
    procedure SortFermentables(I1, I2: integer; Decending1, Decending2: boolean);
    procedure SortHops(I1, I2: integer; Decending1, Decending2: boolean);
    procedure SortMiscs(I1, I2: integer; Decending1, Decending2: boolean);
    procedure SortYeasts(I1, I2: integer; Decending1, Decending2: boolean);
    procedure SortWaters(I1, I2: integer; Decending1, Decending2: boolean);
    function Filter(s : string) : boolean;
    function FindFermentable(n, s: string): TFermentable;
    function FindHop(n: string): THop;
    function FindMisc(n: string): TMisc;
    function FindYeast(n, l: string): TYeast;
    function FindWater(n: string): TWater;
    function CopyToClipboardForumFormat: boolean;
    function CopyToClipboardHTML: boolean;
    function SaveHTML(s : string) : boolean;
    procedure ChangeEquipment(E: TEquipment);
    procedure RemoveNonBrewsData;
    procedure DivideBrew(R: TRecipe; DiType: integer; NumBatches: word;
      VNr: integer);
    Procedure CalcNumMissingIngredients;
    property Hop[i: integer]: THop read GetHop;
    property Fermentable[i: integer]: TFermentable read GetFermentable;
    property BaseMalt[i: integer]: TFermentable read GetBaseMalt;
    property SpecialtyMalt[i: integer]: TFermentable read GetSpecialtyMalt;
    property Sugar[i: integer]: TFermentable read GetSugar;
    property Misc[i: integer]: TMisc read GetMisc;
    property Yeast[i: integer]: TYeast read GetYeast;
    property Water[i: integer]: TWater read GetWater;
    property Ingredient[i: integer]: TIngredient read GetIngredient;
    property IngredientType[i: integer]: TIngredientType read GetIngredientType;
    property NameByIndex[i: integer]: string read GetNameByIndex;
  published
    property NumHops: integer read GetNumHops;
    property NumHopsMash: integer read GetNumHopsMash;
    property NumHopsBoil: integer read GetNumHopsBoil;
    property NumFermentables: integer read GetNumFermentables;
    property NumBaseMalts: integer read GetNumBaseMalts;
    property NumSpecialtyMalts: integer read GetNumSpecialtymalts;
    property NumSugars: integer read GetNumSugars;
    property NumFermentablesMash: integer read GetNumFermentablesMash;
    property NumFermentablesBoil: integer read GetNumFermentablesBoil;
    property NumMiscs: integer read GetNumMiscs;
    property NumMiscsBoil: integer read GetNumMiscsBoil;
    property NumYeasts: integer read GetNumYeasts;
    property NumWaters: integer read GetNumWaters;
    property NumWaterAgents: integer read GetNumWaterAgents;
    property CheckList : TCheckList read FCheckList;
    property RecipeType: TRecipeType read FRecipeType write FRecipeType;
    property TypeName: string read GetTypeName write SetTypeName;
    property TypeDisplayName: string read GetTypeDisplayName write SetTypeDisplayName;
    property Style: TBeerStyle read FStyle;
    property Equipment: TEquipment read FEquipment;
    property Brewer: TBString read FBrewer;
    property AsstBrewer: TBString read FAsstBrewer;
    property BatchSize: TBFloat read FBatchSize;
    property BoilSize: TBFloat read FBoilSize;
    property BoilTime: TBFloat read FBoilTime;
    //    property Efficiency : TBFloat read FEfficiency;
    property Efficiency: double read GetEfficiency write SetEfficiency;
    property Mash: TMash read FMash;
    property TasteNotes: TBString read FTasteNotes;
    property TastingRate: TBFloat read FTastingRate;
    property OG: TBFloat read FOG;
    property FG: TBFloat read FFG;
    property FermentationStages: TBInteger read FFermentationStages;
    property PrimaryAge: TBFloat read FPrimaryAge;
    property PrimaryTemp: TBFloat read FPrimaryTemp;
    property SecondaryAge: TBFloat read FSecondaryAge;
    property SecondaryTemp: TBFloat read FSecondaryTemp;
    property TertiaryAge: TBFloat read FTertiaryAge;
    property TertiaryTemp: TBFloat read FTertiaryTemp;
    property Age: TBFloat read FAge;
    property AgeTemp: TBFloat read FAgeTemp;
    property Date: TBDate read FDate;
    property Carbonation: TBFloat read FCarbonation;
    property ForcedCarbonation: TBBoolean read FForcedCarbonation;
    property PrimingSugarName: TBString read FPrimingSugarName;
    property CarbonationTemp: TBFloat read FCarbonationTemp;
    property PrimingSugarEquiv: TBFloat read FPrimingSugarEquiv;
    property KegPrimingFactor: TBFloat read FKegPrimingFactor;
    property EstOG: TBFloat read FEstOG;
//    property EstOGFermenter : TBFloat read FEstOGFermenter;
    property EstFG: TBFloat read FEstFG;
    property EstFG2: TBFloat read FEstFG2;
    property EstColor: TBFloat read FEstColor;
    property IBUcalc: TBFloat read FIBU;
    property IBUmethod: TIBUmethod read FIBUmethod write SetIBUmethod;
    property IBUmethodName: string read GetIBUMethodName write SetIBUMethodName;
    property IBUmethodDisplayName: string read GetIBUMethodDisplayName
      write SetIBUMethodDisplayName;
    property EstABV: TBFloat read FEstABV;
    property ABVcalc: TBFloat read FABV;
    property ActualEfficiency: TBFloat read FActualEfficiency;
    property Calories: TBFloat read FCalories;
    property ColorMethod: TColorMethod read FColorMethod write SetColorMethod;
    property ColorMethodName: string read GetColorMethodName write SetColorMethodName;
    property ColorMethodDisplayName: string
      read GetColorMethodDisplayName write SetColorMethodDisplayName;
    property CoolingMethod: TCoolingMethod read FCoolingMethod write FCoolingMethod;
    property CoolingMethodName: string read GetCoolingMethodName
      write SetCoolingMethodName;
    property CoolingMethodDisplayName: string
      read GetCoolingMethodDisplayName write SetCoolingMethodDisplayName;
    property NrRecipe: TBString read FNrRecipe;
    property pHAdjustmentWith: TBString read FpHAdjustmentWith;
    property pHAdjusted: TBFloat read FpHAdjusted;
    property TargetpH : TBFloat read FTargetpH;
    property SGEndMash : TBFloat read FSGEndMash;
    property SGEndMashCalc : double read GetSGEndMashCalc;
    property OGBeforeBoil: TBFloat read FOGBeforeBoil;
    property pHBeforeBoil: TBFloat read FpHBeforeBoil;
    property pHAfterBoil: TBFloat read FpHAfterBoil;
    property VolumeBeforeBoil: TBFloat read FVolumeBeforeBoil;
    property VolumeAfterBoil: TBFloat read FVolumeAfterBoil;
    property VolumeFermenter: TBFloat read FVolumeFermenter;
    property OGFermenter : TBFloat read FOGFermenter;
    property TimeAeration: TBFloat read FTimeAeration;
    property SGEndPrimary: TBFloat read FSGEndPrimary;
    property StartTempPrimary: TBFloat read FStartTempPrimary;
    property MaxTempPrimary: TBFloat read FMaxTempPrimary;
    property EndTempPrimary: TBFloat read FEndTempPrimary;
    property DateBottling: TBDate read FDateBottling;
    property VolumeBottles: TBFloat read FVolumeBottles; //volume of beer bottled
    property VolumeKegs: TBFloat read FVolumeKegs;    //Volume of beer kegged
    property CarbonationKegs: TBFloat read FCarbonationKegs;
    property CarbonationTempKegs: TBFloat read FCarbonationTempKegs;
    //amount of priming sugar in kegs    g/l
    property ForcedCarbonationKegs: TBBoolean read FForcedCarbonationKegs;
    property AmountPrimingBottles: TBFloat read FAmountPrimingBottles;
    //amount of priming sugar in bottles g/l
    property AmountPrimingKegs: TBFloat read FAmountPrimingKegs;
    //amount of priming sugar in kegs    g/l
    property PressureKegs: TBFloat read FPressureKegs;
    //pressure set on kegs when forced carbonated
    property TasteDate: TBDate read FTasteDate;
    property TasteColor: TBString read FTasteColor;
    property TasteTransparency: TBString read FTasteTransparency;
    property TasteHead: TBString read FTasteHead;
    property TasteAroma: TBString read FTasteAroma;
    property TasteTaste: TBString read FTasteTaste;
    property TasteMouthfeel: TBString read FTasteMouthfeel;
    property TasteAftertaste: TBString read FTasteAftertaste;
    property TimeStarted: TBTime read FTimeStarted;
    property TimeEnded: TBTime read FTimeEnded;
    property GrainMass: double read GetGrainMass;
    property NumIngredients: integer read GetNumIngredients;
    property SGStartBoil: double read GetSGStartBoil;
    property AbsorbedByGrain: double read FAbsorbedByGrain;
    property TotalFermentableMass: double read GetTotalFermentableMass;
    property TotalSugars: double read GetTotalSugars;
    property GrainMassMash: double read GetGrainMassMash;
    property PercBaseMalt: double read GetPercBaseMalt;
    property PercCrystalMalt: double read GetPercCrystalMalt;
    property PercRoastMalt: double read GetPercRoastMalt;
    property PercSugar: double read GetPercSugar;
    property MashThickness: double read GetMashThickness;
    property pHdemi: double read GetpHDemi;
    property RAmin: double read GetRAmin;
    property RAopt: double read GetRAopt;
    property RAmax: double read GetRAmax;
    property BUGU: double read GetBUGU;
    property OptClSO4ratio: double read GetOptClSO4ratio;
    property CoolingTime: TBFloat read FCoolingTime;
    property CoolingTo : TBFloat read FCoolingTo;
    property WhirlpoolTime: TBFloat read FWhirlpoolTime;
    property AerationType : TAerationType read FAerationType write FAerationType;
    property AerationTypeName : string read GetAerationTypeName write SetAerationTypeName;
    property AerationTypeDisplayName : string read GetAerationTypeDisplayName write SetAerationTypeDisplayName;
    property AerationFlowRate : TBFloat read FAerationFlowRate;
    property NeededYeastCells: double read GetNeededYeastCells;
    //number of yeast cells needed in billion cells
    property InventoryReduced: TBBoolean read FInventoryReduced;
    property Locked: TBBoolean read FLocked;
    property FermMeasurements: TFermMeasurements read FFermMeasurements;
    property PrimingSugarBottles: TPrimingSugar
      read FPrimingSugarBottles write FPrimingSugarBottles;
    property PrimingSugarKegs: TPrimingSugar
      read FPrimingSugarKegs write FPrimingSugarKegs;
    property PrimingSugarBottlesName: string
      read GetPrimingSugarBottlesName write SetPrimingSugarBottlesName;
    property PrimingSugarBottlesDisplayName: string
      read GetPrimingSugarBottlesDisplayName write SetPrimingSugarBottlesDisplayName;
    property PrimingSugarKegsName: string read GetPrimingSugarKegsName
      write SetPrimingSugarKegsName;
    property PrimingSugarKegsDisplayName: string
      read GetPrimingSugarKegsDisplayName write SetPrimingSugarKegsDisplayName;
    property AAEndPrimary: double read GetAAEndPrimary;
    property ApparentAttenuation: double read GetApparentAttenuation;
    property RealAttenuation: double read GetRealAttenuation;
    property Ca: double read GetCa;
    property Mg: double read GetMg;
    property Na: double read GetNa;
    property HCO3: double read GetHCO3;
    property Cl: double read GetCl;
    property SO4: double read GetSO4;
    property RA: double read GetRA;
    property TotalAlkalinity : double read GetTotalAlkalinity;
    property AcidSparge: TBFloat read FAcidSparge;
    property AcidSpargePerc : TBFloat read FAcidSpargePerc;
    property AcidSpargeType : TAcidType read FAcidSpargeType write FAcidSpargeType;
    property AcidSpargeTypeName : string read GetAcidSpargeTypeName write SetAcidSpargeTypeName;
    property AcidSpargeTypeDisplayName : string read GetAcidSpargeTypeDisplayName write SetAcidSpargeTypeDisplayName;
    property VolumeHLT: TBFloat read FVolumeHLT;
    //amount of water in the HLT (sparge + other)
    property SpargeWaterComposition: integer
      read FSpargeWaterComposition write FSpargeWaterComposition;
    property LockEfficiency: boolean read FLockEfficiency write FLockEfficiency;
    property DividedType: TBInteger read FDividedType;
    property DivisionType: TBInteger read FDivisionType;
    property DivisionFrom: TBInteger read FDivisionFrom;
    property ParentAutoNr : TBString read FParentAutoNr;
    property NumNumbers : Longint read GetNumNumbers;
    property RecType : TRecType read FRecType write FRecType;
    property NumMissingIngredients : longint read FNumMissingIngredients;
    property MashWater : TWater read FMashWater;
    property CalcAcid : TBBoolean read FCalcAcid;
  end;

  Procedure SetFloatSpinEdit(fse : TFloatSpinEdit; f : TBFloat; SetValue : boolean);
  Procedure SetUnitLabel(lbl : TLabel; f : TBFloat);
  Procedure SetControl(fse : TFloatSpinEdit; lbl : TLabel; f : TBFloat; SetValue : boolean);
  Procedure SetSpinEdit(se : TSpinEdit; f : TBInteger; SetValue : boolean);
  Procedure SetControlI(se : TSpinEdit; lbl : TLabel; f : TBInteger; SetValue : boolean);

  function GetNodeString(iNode: TDOMNode; Title: string): string;
  procedure AddNode(Doc: TXMLDocument; iNode: TDOMNode; Title: string; Value: string);

var
  Settings: TBSettings;

implementation

uses frmain, Containers, umulfit, utypes, lconvencoding, typinfo;

Procedure SetFloatSpinEdit(fse : TFloatSpinEdit; f : TBFloat; SetValue : boolean);
var {%H-}u : TUnit;
begin
  fse.AutoSize:= false;
  fse.Height:= 23;
  u:= f.GetDisplayUnit;
  fse.Increment:= f.Increment;
  fse.DecimalPlaces:= f.Decimals;
  fse.MinValue:= f.DisplayMinValue;
  fse.MaxValue:= f.DisplayMaxValue;
  if SetValue then
    fse.Value:= f.DisplayValue;
end;

Procedure SetUnitLabel(lbl : TLabel; f : TBFloat);
begin
  lbl.Caption:= f.DisplayUnitString;
  lbl.AutoSize:= false;
  lbl.Height:= 23;
end;

Procedure SetControl(fse : TFloatSpinEdit; lbl : TLabel; f : TBFloat; SetValue : boolean);
begin
  SetFloatSpinEdit(fse, f, SetValue);
  SetUnitLabel(lbl, f);
end;

Procedure SetSpinEdit(se : TSpinEdit; f : TBInteger; SetValue : boolean);
begin
  se.AutoSize:= false;
  se.Height:= 23;
  se.Increment:= 1;//f.Increment;
  se.MinValue:= f.MinValue;
  se.MaxValue:= f.MaxValue;
  if SetValue then
    se.Value:= f.Value;
end;

Procedure SetUnitLabelI(lbl : TLabel; f : TBInteger);
begin
  lbl.Caption:= UnitNames[f.vUnit];
end;

Procedure SetControlI(se : TSpinEdit; lbl : TLabel; f : TBInteger; SetValue : boolean);
begin
  SetSpinEdit(se, f, SetValue);
  SetUnitLabelI(lbl, f);
end;

function ReplaceSpecialChars(s: string): string;
{const OldPattern : array[0..0] of string = ('&');
      NewPattern : array[0..0] of string = ('&amp;');
      OldPattern2 : array[0..7] of string = ('<', '>', '“', '”', '"', '‘', '΄', '''');
      NewPattern2 : array[0..7] of string = ('&lt;', '&gt;', '&quot;', '&quot;', '&quot;', '&apos;', '&apos;', '&apos;');}
//var rf : TReplaceFlags;
  //encs, encto: string;
begin
  //  rf:= [rfReplaceAll, rfIgnoreCase];
  Result := s;
  //Result:= StringsReplace(Result, OldPattern, NewPattern, rf);
  //Result:= StringsReplace(Result, OldPattern2, NewPattern2, rf);
end;

procedure AddNode(Doc: TXMLDocument; iNode: TDOMNode; Title: string; Value: string);
var
  iChild, iTextNode: TDOMNode;
  s: string;
begin
  iChild := Doc.CreateElement(Title{%H-});
  s := ReplaceSpecialChars(Value);
  s := SetDecimalPoint(s);
  iTextNode := Doc.CreateTextNode(s{%H-});
  iChild.AppendChild(iTextNode);
  iNode.AppendChild(iChild);
end;

procedure AddNodeS(Doc: TXMLDocument; iNode: TDOMNode; Title: string; Value: string);
var
  iChild, iTextNode: TDOMNode;
  s: string;
begin
  iChild := Doc.CreateElement(Title{%H-});
  s := ReplaceSpecialChars(Value);
  iTextNode := Doc.CreateTextNode(s{%H-});
  iChild.AppendChild(iTextNode);
  iNode.AppendChild(iChild);
end;

function ResetSpecialChars(s: string): string;
{const NewPattern : array[0..4] of string = ('&', '<', '>', '"', '''');
      OldPattern : array[0..4] of string = ('&amp;', '&lt;', '&gt;', '&quot;', '&apos;');}
//var rf : TReplaceFlags;
  //encs, encto: string;
begin
  //  rf:= [rfReplaceAll, rfIgnoreCase];
  Result := s;
  //  Result:= StringsReplace(Result, OldPattern, NewPattern, rf);
end;

function GetNodeString(iNode: TDOMNode; Title: string): string;
var
  iChild: TDOMNode;
  s: string;
begin
  iChild := iNode.FindNode(Title{%H-});
  if (iChild <> nil) and (iChild.FirstChild <> nil) then
    s := iChild{%H-}.FirstChild.NodeValue
  else
    s := '';
  Result := Trim(ResetSpecialChars(s));
end;

function GetNodeFloat(iNode: TDOMNode; Title: string): double;
var
  s: string;
begin
  try
    s := Trim(GetNodeString(iNode, Title));
    s := SetDecimalSeparator(s);
    if s <> '' then
      Result := StrToFloat(s)
    else
      Result := 0.0;
  except
    ShowMessage('Fout bij omzetting naar getal (tekst = ' + Title);
    Result := 0.0;
  end;
end;

function GetNodeInt(iNode: TDOMNode; Title: string): integer;
var
  s: string;
begin
  try
    s := Trim(GetNodeString(iNode, Title));
    if s <> '' then
      Result := StrToInt(s)
    else
      Result := 0;
  except
    ShowMessage('Fout bij omzetting naar getal (tekst = ' + Title);
    Result := 0;
  end;
end;

function GetNodeBool(iNode: TDOMNode; Title: string): boolean;
var
  s: string;
begin
  try
    s := Trim(GetNodeString(iNode, Title));
    if s <> '' then
      Result := StrToBool(s)
    else
      Result := False;
  except
    ShowMessage('Fout bij omzetting naar boolean waarde (tekst = ' + Title);
    Result := False;
  end;
end;

constructor TBData.Create(aParent : TBase);
begin
  inherited Create;
  FLabel := '';
  FParent:= aParent;
  FCaption:= '';
end;

procedure TBData.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  v: string;
  {$ifdef WINDOWS}
  encs, encto: string;
  {$endif}
begin
  if (FCaption <> '') then
  begin
    v := FCaption;
    {$ifdef WINDOWS}
    encs := 'utf8';
    encto := GetDefaultTextEncoding;
    v := ConvertEncoding(FCaption, encs, encto);
    {$endif}
    AddNodeS(Doc, iNode, 'CAPTION', v);
  end;
end;

procedure TBData.ReadXML(iNode: TDOMNode);
var
  v: string;
  {$ifdef WINDOWS}
  encs, encto: string;
  {$endif}
begin
  if (FLabel <> '') then
  begin
    v := GetNodeString(iNode, 'CAPTION');
    if v <> '' then
    begin
      {$ifdef WINDOWS}
      encs := GetDefaultTextEncoding;
      encto := 'utf8';
      FCaption := ConvertEncoding(v, encs, encto);
      //  FValue:= ANSItoUTF8(v);
      {$else}
      FCaption := v;
      {$endif}
    end;
  end;
end;

procedure TBData.Assign(Source: TBData);
begin
  if Source <> NIL then
  begin
//    FValue := Source.Value;
    FLabel := Source.NodeLabel;
    FCaption:= Source.Caption;
  end;
end;

{procedure TBData.SetValue(v: variant);
begin
  FValue := v;
end;

function TBData.GetValue: variant;
begin
  Result := FValue;
end;}

constructor TBFloat.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := 0.0;
  FMinValue := 0.0;
  FMaxValue := 1E10;
  FUnit := kilogram;
  FDisplayUnit := kilogram;
  FDisplayValue := 0;
  FDisplayLabel := '';
  FDecimals:= 3;
end;

procedure TBFloat.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  inherited;
  if (FLabel <> '') and (FValue > 0.0) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBFloat.SaveXMLDisplayValue(Doc: TXMLDocument; iNode: TDomNode);
begin
  if (FValue > 0.0) and (FDisplayLabel <> '') then
    AddNode(Doc, iNode, FDisplayLabel, DisplayString);
end;

procedure TBFloat.ReadXML(iNode: TDOMNode);
var s : string;
begin
  inherited;
  if FLabel <> '' then
  begin
    s := GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

procedure TBFloat.ReadXMLDisplayValue(iNode: TDOMNode);
var
  s, sval, sunit: string;
  i: integer;
  d: double;
  u: TUnit;
begin
  Value := 0;
  if FDisplayLabel <> '' then
  begin
    s := GetNodeString(iNode, FDisplayLabel);
    if s <> '' then
    begin
      i := NPos(' ', s, 1);
      if i > 0 then
      begin
        sval := Trim(LeftStr(s, i - 1));
        sval := SetDecimalSeparator(sval);
        sunit := Trim(RightStr(s, Length(s) - i));
        try
          d := StrToFloat(sval);
        except
          d := 0.0;
        end;
        for u := Low(UnitNames) to High(UnitNames) do
          if Uppercase(UnitNames[u]) = Uppercase(sunit) then
            FDisplayUnit := u;

        d := Convert(FDisplayUnit, FUnit, d);
        Value := d;
      end;
    end;
  end;
end;

procedure TBFloat.Assign(Source: TBFloat);
var D : integer;
begin
  if Source <> NIL then
  begin
    MinValue := Source.MinValue;
    MaxValue := Source.MaxValue;
    Value := Source.Value;
    vUnit := Source.vUnit;
    D:= Decimals;
    DisplayUnit := Source.DisplayUnit;
    Decimals:= D;
    NodeLabel := Source.NodeLabel;
    DisplayLabel := Source.DisplayLabel;
  end;
end;

procedure TBFloat.Add(x : double);
begin
  SetValue(FValue + x);
end;

procedure TBFloat.Subtract(x : double);
begin
  SetValue(FValue - x);
end;

procedure TBFloat.SetValue(v: double);
begin
  if (FValue <> v) then
  begin
    try
      FValue := MaxD(FMinValue, MinD(v, FMaxValue));
      FDisplayValue := Convert(FUnit, FDisplayUnit, FValue);
    except
      On E: Exception do
      begin

      end;
    end;
  end;
end;

function TBFloat.GetSaveValue: string;
begin
  Result := FloatToStringDec(FValue, FDecimals+3);
  Result := SetDecimalPoint(Result);
end;

procedure TBFloat.SetSaveValue(s: string);
begin
  if s <> '' then
    try
      s := SetDecimalSeparator(s);
      Value := StrToFloat(s);
    except
      FValue := 0.0;
    end;
end;

procedure TBFloat.SetMinValue(d: double);
begin
  FMinValue := d;
  if FValue < FMinValue then
    FValue := FMinValue;
end;

procedure TBFloat.SetMaxValue(d: double);
begin
  FMaxValue := d;
  if FValue > FMaxValue then
    Value := FMaxValue;
end;

procedure TBFloat.SetUnit(u: TUnit);
begin
  if FUnit <> u then
  begin
    FUnit := u;
    FDisplayValue := Convert(FUnit, FDisplayUnit, FValue);
  end;
end;

procedure TBFloat.SetDisplayValue(d: double);
begin
  if FDisplayValue <> d then
  begin
    FDisplayValue := d;
    Value := Convert(FDisplayUnit, FUnit, FDisplayValue);
  end;
end;

Function TBFloat.GetDisplayUnit : TUnit;
begin
  if FUnit = SG then
    DisplayUnitString:= Settings.SGUnit.Value;
  Result:= FDisplayUnit;
end;

procedure TBFloat.SetDisplayUnit(u: TUnit);
begin
  {if FDisplayUnit <> u then
  begin}
    FDisplayUnit := u;
//    FMinValue:= DefaultMinValue[FUnit];
//    FMaxValue:= DefaultMaxValue[FUnit];
    FDecimals:= DefaultDecimals[u];
    FIncrement:= DefaultIncrement[u];
    FDisplayValue := Convert(FUnit, FDisplayUnit, FValue);
  //end;
end;

procedure TBFloat.SetDecimals(i: integer);
begin
  FDecimals := 0;
  if i > 0 then
    FDecimals := i;
end;

function TBFloat.GetDisplayMinValue: double;
begin
  Result := Convert(FUnit, FDisplayUnit, FMinValue);
end;

function TBFloat.GetDisplayMaxValue: double;
begin
  Result := Convert(FUnit, FDisplayUnit, FMaxValue);
end;

function TBFloat.GetDisplayString: string;
begin
  Result := FloatToDisplayString(FDisplayValue, FDecimals, UnitNames[FDisplayUnit]);
end;

procedure TBFloat.SetDisplayString(s: string);
var
  i: integer;
  sval, sunit: string;
  u, du: TUnit;
  d: double;
begin
  if s <> '' then
  begin
    i := NPos(UnitNames[FDisplayUnit], s, 1);
    if i > 0 then
    begin
      sval := Trim(LeftStr(s, i - 1));
      sval := SetDecimalSeparator(sval);
      sunit := Trim(RightStr(s, Length(s) - i));
      try
        d := StrToFloat(sval);
      except
        d := 0.0;
      end;
      for u := Low(UnitNames) to High(UnitNames) do
        if Uppercase(UnitNames[u]) = Uppercase(sunit) then
          du := u;
      d := Convert(du, FUnit, d);
      Value := d;
    end;
  end;
end;

function TBFloat.GetDisplayUnitString: string;
begin
  Result := UnitNames[FDisplayUnit];
end;

Procedure TBFloat.SetDisplayUnitString(s : string);
var u : TUnit;
begin
  for u:= Low(UnitNames) to High(UnitNames) do
    if Uppercase(UnitNames[u]) = Uppercase(s) then
    begin
      DisplayUnit:= u;
      Exit;
    end;
end;

{==============================================================================}

constructor TBInteger.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := 0;
  FMinValue := 0;
  FMaxValue := 0;
  FLabel := '';
  FUnit := none;
end;

procedure TBInteger.Add(x : integer);
begin
  SetValue(FValue + x);
end;

procedure TBInteger.Subtract(x : integer);
begin
  SetValue(FValue - x);
end;

Function TBInteger.GetValue : integer;
begin
  Result:= FValue;
end;

procedure TBInteger.SetValue(v: integer);
begin
  if (v <> FValue) then
    FValue := Max(FMinValue, Min(v, FMaxValue));
end;

function TBInteger.GetSaveValue: string;
begin
  Result := '';
  Result := IntToStr(FValue);
end;

procedure TBInteger.SetSaveValue(s: string);
begin
  if s <> '' then
    try
      Value := StrToInt(s);
    except
      Value := 0;
    end;
end;

procedure TBInteger.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') and (FValue >= FMinValue) and (FValue <= FMaxValue) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBInteger.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if FLabel <> '' then
  begin
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

function TBInteger.GetDisplayString: string;
begin
  Result := IntToDisplayString(FValue, UnitNames[FUnit]);
end;

procedure TBInteger.SetDisplayString(s: string);
var
  i: integer;
  sval: string;
  d: integer;
begin
  if s <> '' then
  begin
    i := NPos(UnitNames[FUnit], s, 1);
    if i > 0 then
    begin
      sval := Trim(LeftStr(s, i - 1));
      //sunit:= Trim(RightStr(s, Length(s)- i));
      try
        d := StrToInt(sval);
      except
        d := 0;
      end;
      Value := d;
    end;
  end;
end;

procedure TBInteger.Assign(Source: TBInteger);
begin
  if Source <> NIL then
  begin
    MinValue := Source.MinValue;
    MaxValue := Source.MaxValue;
    Value := Source.Value;
    vUnit := Source.vUnit;
    NodeLabel := Source.NodeLabel;
  end;
end;

procedure TBInteger.SetMinValue(v: integer);
begin
  FMinValue := v;
  if (FValue > -99) and (FValue < FMinValue) then
    Value := FMinValue;
end;

procedure TBInteger.SetMaxValue(v: integer);
begin
  FMaxValue := v;
  if FValue > FMaxValue then
    Value := FMaxValue;
end;

{==============================================================================}

constructor TBLongInt.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := 0;
  FMinValue := 0;
  FMaxValue := 0;
  FLabel := '';
  FUnit := none;
end;

procedure TBLongInt.Add(x : LongInt);
begin
  SetValue(FValue + x);
end;

procedure TBLongInt.Subtract(x : LongInt);
begin
  SetValue(FValue - x);
end;

Function TBLongInt.GetValue : longint;
begin
  Result:= FValue;
end;

procedure TBLongInt.SetValue(v: LongInt);
begin
  if (v <> FValue) then
    FValue := Max(FMinValue, Min(v, FMaxValue));
end;

function TBLongInt.GetSaveValue: string;
begin
  Result := '';
  Result := IntToStr(FValue);
end;

procedure TBLongInt.SetSaveValue(s: string);
begin
  if s <> '' then
    try
      Value := StrToInt(s);
    except
      Value := 0;
    end;
end;

procedure TBLongInt.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') and (FValue >= FMinValue) and (FValue <= FMaxValue) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBLongInt.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if FLabel <> '' then
  begin
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

function TBLongInt.GetDisplayString: string;
begin
  Result := IntToDisplayString(FValue, UnitNames[FUnit]);
end;

procedure TBLongInt.SetDisplayString(s: string);
var
  i: integer;
  sval: string;
  d: LongInt;
begin
  if s <> '' then
  begin
    i := NPos(UnitNames[FUnit], s, 1);
    if i > 0 then
    begin
      sval := Trim(LeftStr(s, i - 1));
      //sunit:= Trim(RightStr(s, Length(s)- i));
      try
        d := StrToInt(sval);
      except
        d := 0;
      end;
      Value := d;
    end;
  end;
end;

procedure TBLongInt.Assign(Source: TBLongInt);
begin
  if Source <> NIL then
  begin
    MinValue := Source.MinValue;
    MaxValue := Source.MaxValue;
    Value := Source.Value;
    vUnit := Source.vUnit;
    NodeLabel := Source.NodeLabel;
  end;
end;

procedure TBLongInt.SetMinValue(v: LongInt);
begin
  FMinValue := v;
  if (FValue > -99) and (FValue < FMinValue) then
    Value := FMinValue;
end;

procedure TBLongInt.SetMaxValue(v: LongInt);
begin
  FMaxValue := v;
  if FValue > FMaxValue then
    Value := FMaxValue;
end;

{==============================================================================}

constructor TBString.Create(aParent : TBase);
begin
  Inherited Create(aParent);
  FValue := '';
end;

procedure TBString.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  v: string;
  {$ifdef WINDOWS}
  encs, encto: string;
  {$endif}
begin
  if (FValue <> '') and (FLabel <> '') then
  begin
    v := FValue;
    {$ifdef WINDOWS}
    encs := 'utf8';
    encto := GetDefaultTextEncoding;
    v := ConvertEncoding(FValue, encs, encto);
    {$endif}
    AddNodeS(Doc, iNode, FLabel, v);
  end;
end;

procedure TBString.ReadXML(iNode: TDOMNode);
var
  v: string;
  {$ifdef WINDOWS}
  encs, encto: string;
  {$endif}
begin
  if FLabel <> '' then
  begin
    v := GetNodeString(iNode, FLabel);
    if v <> '' then
    begin
      {$ifdef WINDOWS}
      encs := GetDefaultTextEncoding;
      encto := 'utf8';
      FValue := ConvertEncoding(v, encs, encto);
      //  FValue:= ANSItoUTF8(v);
      {$else}
      FValue := v;
      {$endif}
    end;
  end;
end;

procedure TBString.Assign(Source: TBString);
begin
  if Source <> NIL then
  begin
    FValue := Source.Value;
    FLabel := Source.NodeLabel;
  end;
end;

procedure TBString.SetValue(v: string);
begin
  FValue := v;
end;

function TBString.GetValue: string;
var
  {$ifdef Windows}
  i: integer;
  {$endif}
  s: string;
begin
  s := FValue;
  {$ifdef Windows}
  for i := length(s) downto 1 do
    if (s[i] = #10) and (s[i - 1] <> #13) then
      insert(#13, s, i);
  {$endif}
  Result := s;
end;

{==============================================================================}

constructor TBDate.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := 0;
  FLabel := '';
end;

procedure TBDate.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') and (FValue > 0) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBDate.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if FLabel <> '' then
  begin
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

procedure TBDate.Assign(Source: TBDate);
begin
  if Source <> NIL then
  begin
    FValue := Source.Value;
    FLabel := Source.NodeLabel;
  end;
end;

function TBDate.GetSaveValue: string;
begin
  Result:= '';
  if FValue > 0 then
    Result := DateToStr(FValue);
end;

procedure TBDate.SetSaveValue(s: string);
begin
  if s <> '' then
    try
      FValue := StringToDate(s);
    except
      FValue := 0;
    end;
end;

function TBDate.GetValue: TDate;
begin
  Result := FValue;
end;

Procedure TBDate.SetValue(v : TDate);
begin
  if (v > 0) then FValue:= v;
end;

{==============================================================================}

constructor TBTime.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := 0;
  FLabel := '';
end;

procedure TBTime.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') and (FValue > 0) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBTime.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if FLabel <> '' then
  begin
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

procedure TBTime.Assign(Source: TBTime);
begin
  if Source <> NIL then
  begin
    FValue := Source.Value;
    FLabel := Source.NodeLabel;
  end;
end;

function TBTime.GetSaveValue: string;
begin
  if FValue > 0 then
    Result := TimeToStr(FValue);
end;

procedure TBTime.SetSaveValue(s: string);
begin
  if s <> '' then
    try
      FValue := StringToTime(s);
    except
      FValue := 0;
    end;
end;

function TBTime.GetValue: TTime;
begin
  Result := FValue;
end;

Procedure TBTime.SetValue(v : TTime);
begin
  if v >= 0 then FValue:= v;
end;

{==============================================================================}

constructor TBDateTime.Create(aParent : TBase);
begin
  inherited Create (aParent);
  FValue := 0;
  FLabel := '';
end;

procedure TBDateTime.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') and (FValue > 0) then
    AddNode(Doc, iNode, FLabel, SaveValue);
end;

procedure TBDateTime.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if FLabel <> '' then
  begin
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

procedure TBDateTime.Assign(Source: TBDateTime);
begin
  if Source <> NIL then
  begin
    FValue := Source.Value;
    FLabel := Source.NodeLabel;
  end;
end;

function TBDateTime.GetSaveValue: string;
var
  Fmt: TFormatSettings;
begin
  if FValue > 0 then
  begin
    Fmt.DateSeparator := '-';
    Fmt.ShortDateFormat := 'dd-mm-yyyy hh:mm:ss';
    Fmt.TimeSeparator := ':';
    Result := Trim(DateTimeToStr(FValue, Fmt));
  end;
end;

procedure TBDateTime.SetSaveValue(s: string);
var
  Fmt: TFormatSettings;
begin
  Fmt.DateSeparator := '-';
  Fmt.ShortDateFormat := 'dd-mm-yyyy hh:mm:ss';
  Fmt.TimeSeparator := ':';
  FValue := StrToDateTime(s, Fmt);
end;

function TBDateTime.GetValue: TDateTime;
begin
  Result := FValue;
end;

procedure TBDateTime.SetValue(v : TDateTime);
begin
  if v > 0 then FValue:= v;
end;

{==============================================================================}

constructor TBBoolean.Create(aParent : TBase);
begin
  inherited Create(aParent);
  FValue := False;
  FLabel := '';
end;

procedure TBBoolean.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (FLabel <> '') {and (FValue)} then
  begin
    Inherited SaveXML(Doc, iNode, bxml);
    AddNode(Doc, iNode, FLabel, SaveValue);
  end;
end;

procedure TBBoolean.ReadXML(iNode: TDOMNode);
var s : string;
begin
  if (FLabel <> '') then
  begin
    Inherited ReadXML(iNode);
    FValue:= false;
    s:= GetNodeString(iNode, FLabel);
    if s <> '' then SaveValue:= s;
  end;
end;

procedure TBBoolean.Assign(Source: TBBoolean);
begin
  if Source <> NIL then
  begin
    FCaption:= Source.Caption;
    FValue := Source.Value;
    FLabel := Source.NodeLabel;
  end;
end;

function TBBoolean.GetSaveValue: string;
begin
  if FValue = False then
    Result := 'FALSE'
  else
    Result := 'TRUE';
end;

procedure TBBoolean.SetSaveValue(s: string);
begin
  if s = 'TRUE' then
    FValue := True
  else
    FValue := False;
end;

Function TBBoolean.GetValue : boolean;
begin
  Result:= FValue;
end;

Procedure TBBoolean.SetValue(v : boolean);
begin
  FValue:= v;
end;

{================================= Base class for all classes =================}

constructor TBase.Create(R: TRecipe);
begin
  inherited Create;
  FAutoNr := TBLongInt.Create(NIL);
  FAutoNr.NodeLabel := 'AUTONR';
  FAutoNr.Value := 0;
  FAutoNr.MinValue := 0;
  FAutoNr.MaxValue := maxlongint;

  FName := TBString.Create(NIL);
  FName.Value := '';
  FName.NodeLabel := 'NAME';

  FNotes := TBString.Create(NIL);
  FNotes.Value := '';
  FNotes.NodeLabel := 'NOTES';

  FVersion := TBInteger.Create(NIL);
  FVersion.MinValue := 1;
  FVersion.MaxValue := 1;
  FVersion.Value := 1;
  FVersion.NodeLabel := 'VERSION';
  FVersion.vUnit := none;

  FSelected:= false;

  FRecipe := R;
end;

destructor TBase.Destroy;
begin
  FRecipe := nil;
  FAutoNr.Free;
  FName.Free;
  FNotes.Free;
  FVersion.Free;
  inherited;
end;

procedure TBase.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  if (not bxml) and (FAutoNr.Value > 0) then FAutoNr.SaveXML(Doc, iNode, bxml);
  FName.SaveXML(Doc, iNode, bxml);
  FNotes.SaveXML(Doc, iNode, bxml);
  FVersion.SaveXML(Doc, iNode, bxml);
end;

procedure TBase.ReadXML(iNode: TDOMNode);
begin
  FAutoNr.ReadXML(iNode);
  FName.ReadXML(iNode);
  FNotes.ReadXML(iNode);
end;

procedure TBase.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    FName.Assign(Source.Name);
    FNotes.Assign(Source.Notes);
  end;
end;

function TBase.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
  end;
end;

function TBase.GetIndexByName(s: string): integer;
begin
  Result := -1;
  if s = 'Naam' then
    Result := 0
  else if s = 'Notities' then
    Result := 1;
end;

function TBase.GetNameByIndex(i: integer): string;
begin
  Result := '';
  case i of
    0: Result := 'Naam';
    1: Result := 'Notities';
  end;
end;

function TBase.GetValueByName(s: string): variant;
begin
  Result := GetValueByIndex(GetIndexByName(s));
end;

{====================== Ingredients base class ================================}

constructor TIngredient.Create(R: TRecipe);
begin
  inherited Create(R);
  FAmount := TBFloat.Create(self);
  FAmount.vUnit := kilogram;
  FAmount.DisplayUnit := kilogram;
  FAmount.MinValue := 0.0;
  FAmount.MaxValue := 1E10;
  FAmount.Value := 0;
  FAmount.Decimals := 3;
  FAmount.NodeLabel := 'AMOUNT';
  FAmount.DisplayLabel := 'DISPLAY_AMOUNT';
  //BrewBuddyXML
  FCost := TBFloat.Create(self);
  FCost.vUnit := euro;
  FCost.DisplayUnit := euro;
  FCost.MinValue := 0.0;
  FCost.MaxValue := 1000000;
  FCost.Value := 0;
  FCost.Decimals := 2;
  FCost.NodeLabel := 'COST';
  FCost.DisplayLabel := 'DISPLAY_COST';

  FInventory := TBFloat.Create(self);
  FInventory.vUnit := kilogram;
  FInventory.DisplayUnit := kilogram;
  FInventory.MinValue := 0.0;
  FInventory.MaxValue := 1E10;
  FInventory.Value := 0;
  FInventory.Decimals := 0;
  FInventory.NodeLabel := '';
  FInventory.DisplayLabel := 'INVENTORY';

  //BrouwHulp velden
  FAlwaysOnStock := TBBoolean.Create(self);
  FAlwaysOnStock.Value := False;
  FAlwaysOnStock.NodeLabel := 'ALWAYS_ON_STOCK';
end;

destructor TIngredient.Destroy;
begin
  FAmount.Free;
  FInventory.Free;
  FCost.Free;
  FAlwaysOnStock.Free;
  inherited;
end;

procedure TIngredient.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FAmount.Assign(TIngredient(Source).Amount);
    FInventory.Assign(TIngredient(Source).Inventory);
    FCost.Assign(TIngredient(Source).Cost);
    FAlwaysOnStock.Assign(TIngredient(Source).AlwaysOnStock);
  end;
end;

function TIngredient.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
  end;
end;

function TIngredient.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Hoeveelheid' then
    Result := 2
  else if s = 'Voorraad' then
    Result := 3
  else if s = 'Kosten' then
    Result := 4;
end;

function TIngredient.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Hoeveelheid';
    3: Result := 'Voorraad';
    4: Result := 'Kosten';
  end;
end;

procedure TIngredient.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
begin
  inherited SaveXML(Doc, iNode, bxml);
  FAmount.SaveXML(Doc, iNode, bxml);
  //Extensions
  FAmount.SaveXMLDisplayValue(Doc, iNode);
  FInventory.SaveXML(Doc, iNode, bxml);
  //BrouwHulp XML
  FCost.SaveXML(Doc, iNode, bxml);
  FInventory.SaveXMLDisplayValue(Doc, iNode);
  FCost.SaveXMLDisplayValue(Doc, iNode);
  FAlwaysOnStock.SaveXML(Doc, iNode, bxml);
end;

procedure TIngredient.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  FAmount.ReadXML(iNode);
  FInventory.ReadXML(iNode);
  //Extensions
  FInventory.ReadXMLDisplayValue(iNode);
  //  FInventory.ReadXML(iNode);
  //BrouwHulp XML
  FCost.ReadXML(iNode);
  FAlwaysOnStock.ReadXML(iNode);
end;

Function TIngredient.IsInstock : boolean;
begin
  Result:= TRUE;
end;

{========================== HOP ===============================================}

constructor THop.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtHop;
  FIngredientType := itHop;

  FAmount.vUnit := kilogram;
  FAmount.DisplayUnit := gram;
  FAmount.Decimals := 1;

  FInventory.vUnit := kilogram;
  FInventory.DisplayUnit := gram;
  FInventory.Decimals := 1;

  FAlfa := TBFloat.Create(self);
  FAlfa.vUnit := perc;
  FAlfa.DisplayUnit := perc;
  FAlfa.MinValue := 0.0;
  FAlfa.MaxValue := 100;
  FAlfa.Value := 0.0;
  FAlfa.Decimals := 1;
  FAlfa.NodeLabel := 'ALPHA';
  FAlfa.DisplayLabel := '';

  FUse := huboil;

  FTime := TBFloat.Create(self);
  FTime.vUnit := minuut;
  FTime.DisplayUnit := minuut;
  FTime.MinValue := 0.0;
  FTime.MaxValue := 120;
  FTime.Value := 0;
  FTime.Decimals := 0;
  FTime.NodeLabel := 'TIME';
  FTime.DisplayLabel := 'DISPLAY_TIME';

  FHopType := htbittering;
  FForm := hfleaf;

  FBeta := TBFloat.Create(self);
  FBeta.vUnit := perc;
  FBeta.DisplayUnit := perc;
  FBeta.MinValue := 0.0;
  FBeta.MaxValue := 100;
  FBeta.Value := 0.0;
  FBeta.Decimals := 1;
  FBeta.NodeLabel := 'BETA';
  FBeta.DisplayLabel := '';

  FHSI := TBFloat.Create(self);
  FHSI.vUnit := perc;
  FHSI.DisplayUnit := perc;
  FHSI.MinValue := 0.0;
  FHSI.MaxValue := 100;
  FHSI.Value := 0.0;
  FHSI.Decimals := 1;
  FHSI.NodeLabel := 'HSI';
  FHSI.DisplayLabel := '';

  FOrigin := TBString.Create(self);
  FOrigin.Value := '';
  FOrigin.NodeLabel := 'ORIGIN';

  FSubstitutes := TBString.Create(self);
  FSubstitutes.Value := '';
  FSubstitutes.NodeLabel := 'SUBSTITUTES';

  FHumulene := TBFloat.Create(self);
  FHumulene.vUnit := perc;
  FHumulene.DisplayUnit := perc;
  FHumulene.MinValue := 0.0;
  FHumulene.MaxValue := 100;
  FHumulene.Value := 0.0;
  FHumulene.Decimals := 1;
  FHumulene.NodeLabel := 'HUMULENE';
  FHumulene.DisplayLabel := '';

  FCaryophyllene := TBFloat.Create(self);
  FCaryophyllene.vUnit := perc;
  FCaryophyllene.DisplayUnit := perc;
  FCaryophyllene.MinValue := 0.0;
  FCaryophyllene.MaxValue := 100;
  FCaryophyllene.Value := 0.0;
  FCaryophyllene.Decimals := 1;
  FCaryophyllene.NodeLabel := 'CAROPHYLLENE';
  FCaryophyllene.DisplayLabel := '';

  FCohumulone := TBFloat.Create(self);
  FCohumulone.vUnit := perc;
  FCohumulone.DisplayUnit := perc;
  FCohumulone.MinValue := 0.0;
  FCohumulone.MaxValue := 100;
  FCohumulone.Value := 0.0;
  FCohumulone.Decimals := 1;
  FCohumulone.NodeLabel := 'COHUMULONE';
  FCohumulone.DisplayLabel := '';

  FMyrcene := TBFloat.Create(self);
  FMyrcene.vUnit := perc;
  FMyrcene.DisplayUnit := perc;
  FMyrcene.MinValue := 0.0;
  FMyrcene.MaxValue := 100;
  FMyrcene.Value := 0.0;
  FMyrcene.Decimals := 1;
  FMyrcene.NodeLabel := 'MYRCENE';
  FMyrcene.DisplayLabel := '';

  FTotalOil := TBFloat.Create(self);
  FTotalOil.vUnit := perc;
  FTotalOil.DisplayUnit := perc;
  FTotalOil.MinValue := 0;
  FTotalOil.MaxValue := 20;
  FTotalOil.Decimals := 1;
  FTotalOil.NodeLabel := 'TOTAL_OIL';
  FTotalOil.DisplayLabel := '';

  FHarvestDate := TBDate.Create(self);
  FHarvestDate.Value:= 0;
  FHarvestDate.NodeLabel:= 'HARVEST_DATE';

  FLock:= false;
end;

destructor THop.Destroy;
begin
  FAlfa.Free;
  FTime.Free;
  FBeta.Free;
  FHSI.Free;
  FOrigin.Free;
  FSubstitutes.Free;
  FHumulene.Free;
  FCaryophyllene.Free;
  FCohumulone.Free;
  FMyrcene.Free;
  FTotalOil.Free;
  FHarvestDate.Free;
  inherited;
end;

procedure THop.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FUse := THop(Source).Use;
    FHopType := THop(Source).HopType;
    FForm := THop(Source).Form;
    FAlfa.Assign(THop(Source).Alfa);
    FTime.Assign(THop(Source).Time);
    FBeta.Assign(THop(Source).Beta);
    FHSI.Assign(THop(Source).HSI);
    FOrigin.Assign(THop(Source).Origin);
    FSubstitutes.Assign(THop(Source).Substitutes);
    FHumulene.Assign(THop(Source).Humulene);
    FCaryophyllene.Assign(THop(Source).Caryophyllene);
    FCohumulone.Assign(THop(Source).Cohumulone);
    FMyrcene.Assign(THop(Source).Myrcene);
    FTotalOil.Assign(THop(Source).TotalOil);
    FHarvestDate.Assign(THop(Source).HarvestDate);
    FLock:= THop(Source).Lock;
  end;
end;

function THop.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
    5: Result := FUse; //HopUseDisplayNames[FUse];
    6: Result := HopTypeDisplayNames[FHopType];
    7: Result := HopFormDisplayNames[FForm];
    8: Result := FAlfa.Value;
    9: Result := FTime.Value;
    10: Result := FBeta.Value;
    11: Result := FHSI.Value;
    12: Result := FOrigin.Value;
    13: Result := FSubstitutes.Value;
    14: Result := FHumulene.Value;
    15: Result := FCaryophyllene.Value;
    16: Result := FCohumulone.Value;
    17: Result := FMyrcene.Value;
    18: Result := FTotalOil.Value;
    19: Result := FHarvestDate.Value;
  end;
end;

function THop.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Gebruik' then
    Result := 5
  else if s = 'Type' then
    Result := 6
  else if s = 'Vorm' then
    Result := 7
  else if s = '% Alfazuren' then
    Result := 8
  else if s = '(Kook)tijd' then
    Result := 9
  else if s = '% Betazuren' then
    Result := 10
  else if s = 'Houdbaarheidsindex' then
    Result := 11
  else if s = 'Herkomst' then
    Result := 12
  else if s = 'Vervanging' then
    Result := 13
  else if s = '% Humuleen' then
    Result := 14
  else if s = '% Carofylleen' then
    Result := 15
  else if s = '% Cohumuloon' then
    Result := 16
  else if s = '% Myrceen' then
    Result := 17
  else if s = 'Totaal olie' then
    Result := 18
  else if s = 'Oogstdatum' then
    Result:= 19;
end;

function THop.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    5: Result := 'Gebruik';
    6: Result := 'Type';
    7: Result := 'Vorm';
    8: Result := '% Alfazuren';
    9: Result := '(Kook)tijd';
    10: Result := '% Betazuren';
    11: Result := 'Houdbaarheidsindex';
    12: Result := 'Herkomst';
    13: Result := 'Vervanging';
    14: Result := '% Humuleen';
    15: Result := '% Carofylleen';
    16: Result := '% Cohumuloon';
    17: Result := '% Myrceen';
    18: Result := 'Totaal olie';
    19: Result := 'Oogstdatum';
  end;
end;

procedure THop.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
  d : double;
begin
  iChild := Doc.CreateElement('HOP');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  FAlfa.SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'TYPE', TypeName);
  AddNode(Doc, iChild, 'FORM', FormName);
  if bxml then
  begin
    if FUse = huWhirlpool then
    begin
      AddNode(Doc, iChild, 'USE', HopUseNames[huAroma]);
      d:= FTime.Value;
      FTime.Value:= 0;
      FTime.SaveXML(Doc, iChild, bxml);
      FTime.Value:= d;
    end
    else
    begin
      AddNode(Doc, iChild, 'USE', UseName);
      FTime.SaveXML(Doc, iChild, bxml);
    end;
  end
  else
  begin
    AddNode(Doc, iChild, 'USE', UseName);
    FTime.SaveXML(Doc, iChild, bxml);
  end;
  FBeta.SaveXML(Doc, iChild, bxml);
  FHSI.SaveXML(Doc, iChild, bxml);
  FOrigin.SaveXML(Doc, iChild, bxml);
  FSubstitutes.SaveXML(Doc, iChild, bxml);
  FHumulene.SaveXML(Doc, iChild, bxml);
  FCaryophyllene.SaveXML(Doc, iChild, bxml);
  FCohumulone.SaveXML(Doc, iChild, bxml);
  FMyrcene.SaveXML(Doc, iChild, bxml);
  //extensions
  FTime.SaveXMLDisplayValue(Doc, iChild);
  //BrewBuddyXML
  if not bxml then
  begin
    FTotalOil.SaveXML(Doc, iChild, bxml);
    FHarvestDate.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure THop.ReadXML(iNode: TDOMNode);
var s : string;
    bt : double;
begin
  inherited ReadXML(iNode);
  FAlfa.ReadXML(iNode);
  FTime.ReadXML(iNode);
  bt:= FTime.Value;
  TypeName := GetNodeString(iNode, 'TYPE');
  FormName := GetNodeString(iNode, 'FORM');
  s:= GetNodeString(iNode, 'USE');
  if s = '' then FUse:= huBoil
  else UseName := s;
  if (FTime.Value = 0) and (FUse = huBoil) then
    FUse:= huAroma;
  if (bt > 0) and (FUse = huAroma) then
  begin
    FUse:= huBoil;
    FTime.Value:= bt;
  end;
  FBeta.ReadXML(iNode);
  FHSI.ReadXML(iNode);
  FOrigin.ReadXML(iNode);
  FSubstitutes.ReadXML(iNode);
  FHumulene.ReadXML(iNode);
  FCaryophyllene.ReadXML(iNode);
  FCohumulone.ReadXML(iNode);
  FMyrcene.ReadXML(iNode);
  //BrewBuddyXML
  FTotalOil.ReadXML(iNode);
  FHarvestDate.ReadXML(iNode);
end;

Function THop.IsInstock : boolean;
var i : integer;
    H : THop;
begin
  Result:= TRUE;
  for i:= 0 to Hops.NumItems - 1 do
  begin
    H:= Hops.FindByNameAndOriginAndAlfa(FName.Value, FOrigin.Value, FAlfa.Value);
    if H <> NIL then
    begin
      if H.Inventory.Value < FAmount.Value then Result:= false;
    end
    else Result:= false;
  end;

end;

procedure THop.SetUseName(s: string);
var
  hu: THopUse;
begin
  for hu := Low(HopUseNames) to High(HopUseNames) do
    if HopUseNames[hu] = s then
      FUse := hu;
  case FUse of
    huAroma, huWhirlpool: FTime.Value := 0;
    huFirstWort, huMash: if FRecipe <> nil then
        FTime.Value := FRecipe.BoilTime.Value
      else
        FTime.Value := 60;
    huDryhop: FTime.Value := 0;
  end;
end;

function THop.GetUseName: string;
begin
  Result := HopUseNames[FUse];
end;

procedure THop.SetUseDisplayName(s: string);
var
  hu: THopUse;
begin
  for hu := Low(HopUseDisplayNames) to High(HopUseDisplayNames) do
    if LowerCase(HopUseDisplayNames[hu]) = LowerCase(s) then
      FUse := hu;
  case FUse of
    huAroma, huWhirlpool: FTime.Value := 0;
    huFirstWort, huMash: if FRecipe <> nil then
        FTime.Value := FRecipe.BoilTime.Value
      else
        FTime.Value := 75;
    huDryhop: FTime.Value := 0;
  end;
end;

function THop.GetUseDisplayName: string;
begin
  Result := HopUseDisplayNames[FUse];
end;

procedure THop.SetTypeName(s: string);
var
  ht: THopType;
begin
  for ht := Low(HopTypeNames) to High(HopTypeNames) do
    if LowerCase(HopTypeNames[ht]) = LowerCase(s) then
      FHopType := ht;
end;

function THop.GetTypeName: string;
begin
  Result := HopTypeNames[FHopType];
end;

procedure THop.SetTypeDisplayName(s: string);
var
  ht: THopType;
begin
  for ht := Low(HopTypeDisplayNames) to High(HopTypeDisplayNames) do
    if LowerCase(HopTypeDisplayNames[ht]) = LowerCase(s) then
      FHopType := ht;
end;

function THop.GetTypeDisplayName: string;
begin
  Result := HopTypeDisplayNames[FHopType];
end;

procedure THop.SetFormName(s: string);
var
  hf: THopForm;
begin
  for hf := Low(HopFormNames) to High(HopFormNames) do
    if LowerCase(HopFormNames[hf]) = LowerCase(s) then
      FForm := hf;
end;

function THop.GetFormName: string;
begin
  Result := HopFormNames[FForm];
end;

procedure THop.SetFormDisplayName(s: string);
var
  hf: THopForm;
begin
  for hf := Low(HopFormDisplayNames) to High(HopFormDisplayNames) do
    if LowerCase(HopFormDisplayNames[hf]) = LowerCase(s) then
      FForm := hf;
end;

function THop.GetFormDisplayName: string;
begin
  Result := HopFormDisplayNames[FForm];
end;

Function THop.GetAlfaAdjusted : double;
var HD, Dr : TDateTime;
    iHSI, iTemp: double;
    Elapsed, iType : integer;
    D, M, Y : word;
begin
  Result:= FAlfa.Value;
  if FRecipe.RecType = rtBrew then //only adjust bitterness of the hop in brews.
  begin
    Dr:= round(FRecipe.Date.Value);
    if Dr <= 1 then Dr:= Now;
    HD:= FHarvestDate.Value;
    if HD <= 1 then //if harvestdate is not available, take the last harvest. This obviously does not work well for hops from the southern hemisphere.
    begin
      DecodeDate(Dr, Y, M, D);
      if M < 8 then Y:= Y - 1;
      HD:= EncodeDate(Y, 9, 1);
    end;
    iHSI:= FHSI.Value;
    if iHSI <= 0.5 then iHSI:= 25; //if no HSI has been given, presume a HSI of 25%
    if (Settings.AdjustAlfa.Value) and (HD > 0) and
       (iHSI > 0) and (iHSI < 100) then
    begin
      iTemp:= Settings.HopStorageTemp.Value;
      iType:= Settings.HopStorageType.Value;
      if Dr > HD then
      begin
        Elapsed:= round(Dr - HD);
        Result:= ActualIBU(FAlfa.Value, iHSI, iTemp, Elapsed, iType);
      end;
    end;
  end;
end;

Function THop.GetHumulene : double;
var bt, vol : double;
begin //assume all is gone after 30 minutes of boil
  vol:= 0;
  if (FRecipe <> NIL) then vol:= FRecipe.BatchSize.DisplayValue;
  bt:= FTime.Value;
  if bt > 30 then Result:= 0
  else Result:= (1 - bt / 30) * FHumulene.Value / 100 * FTotalOil.Value / 100 * FAmount.DisplayValue;
  if vol > 0 then Result:= Result / vol  //g/l
  else Result:= 0;
end;

Function THop.GetCaryophyllene : double;
var bt, vol : double;
begin //assume all is gone after 60 minutes of boil
  vol:= 0;
  if (FRecipe <> NIL) then vol:= FRecipe.BatchSize.DisplayValue;
  bt:= FTime.Value;
  if bt > 60 then Result:= 0
  else Result:= (1 - bt / 60) * FCaryophyllene.Value / 100 * FTotalOil.Value / 100 * FAmount.DisplayValue;
  if vol > 0 then Result:= Result / vol  //g/l
  else Result:= 0;
end;

Function THop.GetMyrcene : double;
var fact, vol : double;
begin //none survives boil
  vol:= 0;
  if (FRecipe <> NIL) then vol:= FRecipe.BatchSize.DisplayValue;
  if FUse = huDryHop then fact:= 1
  else if (FUse = huAroma) or (FUse = huWhirlpool) then fact:= 0.5
  else fact:= 0;
  Result:= fact * FMyrcene.Value / 100 * FTotalOil.Value / 100 * FAmount.DisplayValue;
  if vol > 0 then Result:= Result / vol   //g/l
  else Result:= 0;
end;

Function THop.GetCohumulone : double;
begin
  Result:= FCohumulone.Value / 100 * BitternessContribution; //mg/l
end;

Function THop.FlavourContribution : double; //in % * concentration in g/l
var bt, vol : double;
begin
  bt:= FTime.Value;
  vol:= 0;
  if FRecipe <> NIL then vol:= FRecipe.BatchSize.Value;
  if FUse = huFirstWort then Result:= 0.15 * FAmount.Value * 1000 //assume 15% flavourcontribution for fwh
  else if bt > 50 then Result:= 0.10 * FAmount.Value * 1000 //assume 10% flavourcontribution as a minimum
  else
  begin
    Result:= 15.25 / (6 * sqrt(2 * PI)) * Exp(-0.5*Power((bt-21)/6, 2))
             * FAmount.Value * 1000;
    if result < 0.10 * FAmount.Value * 1000 then
      Result:= 0.10 * FAmount.Value * 1000 //assume 10% flavourcontribution as a minimum
  end;
  if vol > 0 then Result:= Result / vol;
end;

Function THop.AromaContribution : double; //in % * concentration in g/l
var bt, vol : double;
begin
  bt:= FTime.Value;
  vol:= 0;
  if FRecipe <> NIL then vol:= FRecipe.BatchSize.Value;
  if bt > 20 then Result:= 0
  else if bt > 7.5 then
    Result:= 10.03 / (4 * sqrt(2 * PI)) * Exp(-0.5*Power((bt-7.5)/4, 2))
             * FAmount.Value * 1000
  else if FUse = huBoil then Result:= FAmount.Value * 1000
  else if FUse = huAroma then Result:= 1.2 * FAmount.Value * 1000
  else if FUse = huWhirlpool then Result:= 1.2 * FAmount.Value * 1000
  else if FUse = huDryHop then Result:= 1.33 * FAmount.Value * 1000;
    if vol > 0 then Result:= Result / vol;
end;

Function THop.GetAlfaFromAdjusted(Adj : double) : double;
var HD, Dr : TDateTime;
    Elapsed, iHSI, iTemp, iType : double;
    D, M, Y : word;
begin
  Result:= Adj;
  if (Settings.AdjustAlfa.Value) and (FRecipe.RecType = rtBrew) then //only adjust bitterness of the hop in brews.
  begin
    Dr:= round(FRecipe.Date.Value);
    if Dr <= 1 then Dr:= Now;
    HD:= FHarvestDate.Value;
    if HD <= 1 then //if harvestdate is not available, take the last harvest. This obviously does not work well for hops from the southern hemisphere.
    begin
      DecodeDate(Dr, Y, M, D);
      if M < 8 then Y:= Y - 1;
      HD:= EncodeDate(Y, 9, 1);
    end;
    iHSI:= FHSI.Value;
    if iHSI <= 0.5 then iHSI:= 25; //if no HSI has been given, presume a HSI of 25%
    if (HD > 0) and (iHSI > 0) and (iHSI < 100) then
    begin
      iTemp:= Settings.HopStorageTemp.Value;
      iTemp:= 0.396865 * EXP(0.046221 * iTemp);
      case Settings.HopStorageType.Value of
      0: iType:= 1;
      1: iType:= 0.75;
      2: iType:= 0.5;
      end;
      if Dr > HD then
      begin
        Elapsed:= 2 * ((Dr - HD) / 365.25) * iTemp * iType; //years
        Result:= Adj / Power(1 - iHSI/100, Elapsed);
      end;
    end;
  end;
end;

Function THop.AmountToBitternessContribution(a : double) : double;
var
  VBB, VAB, HU, SGstartboil, SGav, Alf: double;
begin
  Result := 0;
  if FRecipe <> nil then
  begin
    SGstartboil := FRecipe.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + FRecipe.EstOG.Value) / 2;
    Alf:= AlfaAdjusted;
    if FRecipe.Equipment <> nil then
    begin
      VBB:= FRecipe.Equipment.BoilSize.Value;
      if (not FRecipe.Equipment.CalcBoilVolume.Value) or (VBB <= 0) then
        VBB:= FRecipe.BoilSize.Value;
      if VBB <= 0 then VBB:= 1.1 * FRecipe.BatchSize.Value;
      VAB := FRecipe.BatchSize.Value;
      HU := FRecipe.Equipment.HopUtilization.Value / 100;
    end
    else
    begin
      VBB := FRecipe.BoilSize.Value;
      VAB := 0.9 * VBB;
      HU := 1;
    end;
    Result := HU * CalcIBU(FRecipe.IBUmethod, FUse, Alf,
              a * 1000, VBB, VAB, SGav, FTime.Value, FForm, 0);
    if (FRecipe.Equipment <> NIL) and ((FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value
                  + FRecipe.Equipment.TopUpWater.Value) > 0) then
    begin
      Result:= Result * (FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value)
               / (FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value
                  + FRecipe.Equipment.TopUpWater.Value);
    end;
  end;
end;

Function THop.BitternessContributionToAmount(bc : double) : double;
var
  VBB, VAB, HU, SGstartboil, SGav, x, Alf: double;
begin
  if FRecipe <> nil then
  begin
    if (FRecipe.Equipment <> NIL) and ((FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value) > 0) then
    begin
      bc:= bc * (FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value
               + FRecipe.Equipment.TopUpWater.Value)
            / (FRecipe.BatchSize.Value - FRecipe.Equipment.TrubChillerLoss.Value);
    end;

    Alf:= AlfaAdjusted;
    if (FRecipe.Equipment <> NIL) and (not FRecipe.Equipment.CalcBoilVolume.Value) then
      VBB:= FRecipe.Equipment.BoilSize.Value;
    SGstartboil := FRecipe.SGstartboil;
    SGav := SGStartBoil; //(SGstartboil + FRecipe.EstOG.Value) / 2;
    if FRecipe.Equipment <> nil then
    begin
      VBB:= FRecipe.Equipment.BoilSize.Value;
      if (not FRecipe.Equipment.CalcBoilVolume.Value) or (VBB <= 0) then
        VBB:= FRecipe.BoilSize.Value;
      if VBB <= 0 then VBB:= 1.1 * FRecipe.BatchSize.Value;
      VAB := FRecipe.BatchSize.Value;
      HU := FRecipe.Equipment.HopUtilization.Value / 100;
    end
    else
    begin
      VBB := FRecipe.BoilSize.Value;
      VAB := 0.9 * VBB;
      HU := 1;
    end;
    if HU > 0 then bc:= bc / HU;
    x := AmHop(FRecipe.IBUmethod, FUse, Alf, bc, VBB, VAB, SGav,
               FTime.Value, FForm, 0) / 1000;
    Result:= x;
  end;
end;

function THop.GetBitternessContribution: double;
begin
  Result := AmountToBitternessContribution(FAmount.Value);
end;

procedure THop.SetBitternessContribution(d: double);
begin
  FAmount.Value:= BitternessContributionToAmount(d);
end;

function THop.GetBitternessContributionWort: double;
//Calculates bitternessContribution in the undilluted wort
var
  VBB, VAB, HU, SGstartboil, SGav, Alf: double;
begin
  Result := 0;
  if FRecipe <> nil then
  begin
    SGstartboil := FRecipe.SGstartboil;
    SGav := SGstartboil; //(SGstartboil + FRecipe.EstOG.Value) / 2;
    Alf:= AlfaAdjusted;
    if FRecipe.Equipment <> nil then
    begin
      VBB:= FRecipe.Equipment.BoilSize.Value;
      if (not FRecipe.Equipment.CalcBoilVolume.Value) or (VBB <= 0) then
        VBB:= FRecipe.BoilSize.Value;
      if VBB <= 0 then VBB:= 1.1 * FRecipe.BatchSize.Value;
      VAB := FRecipe.BatchSize.Value;
      HU := FRecipe.Equipment.HopUtilization.Value / 100;
    end
    else
    begin
      VBB := FRecipe.BoilSize.Value;
      VAB := 0.9 * VBB;
      HU := 1;
    end;
    Result := HU * CalcIBU(FRecipe.IBUmethod, FUse, Alf,
              FAmount.Value * 1000, VBB, VAB, SGav, FTime.Value, FForm, 0);
  end;
end;

{============================= FERMENTABLES ===================================}

constructor TFermentable.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtFermentable;
  FIngredientType := itFermentable;
  FFermentableType := ftgrain;

  FAmount.vUnit := kilogram;
  FAmount.DisplayUnit := kilogram;
  FAmount.Decimals := 2;

  FInventory.vUnit := kilogram;
  FInventory.DisplayUnit := kilogram;
  FInventory.Decimals := 3;

  FYield := TBFloat.Create(self);
  FYield.vUnit := perc;
  FYield.DisplayUnit := perc;
  FYield.MinValue := 0.0;
  FYield.MaxValue := 100.0;
  FYield.Value := 0.0;
  FYield.Decimals := 1;
  FYield.NodeLabel := 'YIELD';
  FYield.DisplayLabel := '';

  FColor := TBFloat.Create(self);
  FColor.vUnit := srm;
  FColor.DisplayUnit := ebc;
  FColor.MinValue := 0.0;
  FColor.MaxValue := 1000;
  FColor.Value := 0.0;
  FColor.Decimals := 0;
  FColor.NodeLabel := 'COLOR';
  FColor.DisplayLabel := 'DISPLAY_COLOR';

  FAddAfterBoil := TBBoolean.Create(self);
  FAddAfterBoil.Value := False;
  FAddAfterBoil.NodeLabel := 'ADD_AFTER_BOIL';

  FOrigin := TBString.Create(self);
  FOrigin.Value := '';
  FOrigin.NodeLabel := 'ORIGIN';

  FSupplier := TBString.Create(self);
  FSupplier.Value := '';
  FSupplier.NodeLabel := 'SUPPLIER';

  FCoarseFineDiff := TBFloat.Create(self);
  FCoarseFineDiff.vUnit := perc;
  FCoarseFineDiff.DisplayUnit := perc;
  FCoarseFineDiff.MinValue := 0.0;
  FCoarseFineDiff.MaxValue := 25;
  FCoarseFineDiff.Value := 0.0;
  FCoarseFineDiff.Decimals := 1;
  FCoarseFineDiff.NodeLabel := 'COARSE_FINE_DIFF';
  FCoarseFineDiff.DisplayLabel := '';

  FMoisture := TBFloat.Create(self);
  FMoisture.vUnit := perc;
  FMoisture.DisplayUnit := perc;
  FMoisture.MinValue := 0.0;
  FMoisture.MaxValue := 100;
  FMoisture.Value := 0.0;
  FMoisture.Decimals := 1;
  FMoisture.NodeLabel := 'MOISTURE';
  FMoisture.DisplayLabel := '';

  FDiastaticPower := TBFloat.Create(self);
  FDiastaticPower.vUnit := lintner;
  FDiastaticPower.DisplayUnit := windischkolbach;
  FDiastaticPower.MinValue := 0.0;
  FDiastaticPower.MaxValue := 200;
  FDiastaticPower.Value := 0.0;
  FDiastaticPower.Decimals := 0;
  FDiastaticPower.NodeLabel := 'DIASTATIC_POWER';
  FDiastaticPower.DisplayLabel := '';

  FProtein := TBFloat.Create(self);
  FProtein.vUnit := perc;
  FProtein.DisplayUnit := perc;
  FProtein.MinValue := 0.0;
  FProtein.MaxValue := 25;
  FProtein.Value := 0.0;
  FProtein.Decimals := 1;
  FProtein.NodeLabel := 'PROTEIN';
  FProtein.DisplayLabel := '';

  FDissolvedProtein := TBFloat.Create(self);
  FDissolvedProtein.vUnit := perc;
  FDissolvedProtein.DisplayUnit := perc;
  FDissolvedProtein.MinValue := 0.0;
  FDissolvedProtein.MaxValue := 25;
  FDissolvedProtein.Value := 0.0;
  FDissolvedProtein.Decimals := 1;
  FDissolvedProtein.NodeLabel := 'DISSOLVED_PROTEIN';
  FDissolvedProtein.DisplayLabel := '';

  FMaxInBatch := TBFloat.Create(self);
  FMaxInBatch.vUnit := perc;
  FMaxInBatch.DisplayUnit := perc;
  FMaxInBatch.MinValue := 0.0;
  FMaxInBatch.MaxValue := 100;
  FMaxInBatch.Value := 0.0;
  FMaxInBatch.Decimals := 0;
  FMaxInBatch.NodeLabel := 'MAX_IN_BATCH';
  FMaxInBatch.DisplayLabel := '';

  FRecommendMash := TBBoolean.Create(self);
  FRecommendMash.Value := True;
  FRecommendMash.NodeLabel := 'RECOMMEND_MASH';

  FIbuGalPerLb := TBFloat.Create(self);
  FIbuGalPerLb.vUnit := ibu;
  FIbuGalPerLb.DisplayUnit := ibu;
  FIbuGalPerLb.MinValue := 0.0;
  FIbuGalPerLb.MaxValue := 1000;
  FIbuGalPerLb.Value := 0.0;
  FIbuGalPerLb.Decimals := 0;
  FIbuGalPerLb.NodeLabel := 'IBU_GAL_PER_LB';
  FIbuGalPerLb.DisplayLabel := '';

  //BrewBuddyXML
  FGrainType := gtNone;
  FAdded := atMash;

  FPercentage := TBFloat.Create(self);
  FPercentage.vUnit := perc;
  FPercentage.DisplayUnit := perc;
  FPercentage.MinValue := 0.0;
  FPercentage.MaxValue := 100.0;
  FPercentage.Value := 0.0;
  FPercentage.Decimals := 1;
  FPercentage.NodeLabel := 'PERCENTAGE';
  FPercentage.DisplayLabel := 'DISPLAY_PERCENTAGE';

  FAdjustToTotal100 := TBBoolean.Create(self);
  FAdjustToTotal100.Value:= false;
  FAdjustToTotal100.NodeLabel:= 'ADJUST_TO_TOTAL_100';

  FDIpH := TBFloat.Create(self);
  FDIpH.vUnit := ph;
  FDIpH.DisplayUnit := ph;
  FDIpH.MinValue := 0.0;
  FDIpH.MaxValue := 14.0;
  FDIpH.Value := 0.0;
  FDIpH.Decimals := 2;
  FDIpH.NodeLabel := 'DI_pH';
  FDIpH.DisplayLabel := '';

  FAcidTo57 := TBFloat.Create(self);
  FAcidTo57.vUnit := meql;
  FAcidTo57.DisplayUnit := meql;
  FAcidTo57.MinValue := -1000.0;
  FAcidTo57.MaxValue := 1000.0;
  FAcidTo57.Value := 0.0;
  FAcidTo57.Decimals := 2;
  FAcidTo57.NodeLabel := 'ACID_TO_pH_5.7';
  FAcidTo57.DisplayLabel := '';

  FLockPercentage:= false;
end;

destructor TFermentable.Destroy;
begin
  FYield.Free;
  FColor.Free;
  FCoarseFineDiff.Free;
  FMoisture.Free;
  FDiastaticPower.Free;
  FProtein.Free;
  FDissolvedProtein.Free;
  FMaxInBatch.Free;
  FIbuGalPerLb.Free;
  FAddAfterBoil.Free;
  FOrigin.Free;
  FSupplier.Free;
  FRecommendMash.Free;
  FPercentage.Free;
  FAdjustToTotal100.Free;
  FDIpH.Free;
  FAcidTo57.Free;
  inherited;
end;

procedure TFermentable.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FFermentableType := TFermentable(Source).FermentableType;

    FYield.Assign(TFermentable(Source).Yield);
    FColor.Assign(TFermentable(Source).Color);
    FCoarseFineDiff.Assign(TFermentable(Source).CoarseFineDiff);
    FMoisture.Assign(TFermentable(Source).Moisture);
    FDiastaticPower.Assign(TFermentable(Source).DiastaticPower);
    FProtein.Assign(TFermentable(Source).Protein);
    FDissolvedProtein.Assign(TFermentable(Source).DissolvedProtein);
    FMaxInBatch.Assign(TFermentable(Source).MaxInBatch);
    FIbuGalPerLb.Assign(TFermentable(Source).IbuGalPerLb);
    FAddAfterBoil.Assign(TFermentable(Source).AddAfterBoil);
    FOrigin.Assign(TFermentable(Source).Origin);
    FSupplier.Assign(TFermentable(Source).Supplier);
    FRecommendMash.Assign(TFermentable(Source).RecommendMash);
    FGrainType := TFermentable(Source).GrainType;
    FAdded := TFermentable(Source).AddedType;
    FPercentage := TFermentable(Source).Percentage;
    FAdjustToTotal100.Assign(TFermentable(Source).AdjustToTotal100);
    FDIpH.Assign(TFermentable(Source).DIpH);
    FAcidTo57.Assign(TFermentable(Source).AcidTo57);
    FLockPercentage:= TFermentable(Source).LockPercentage;
  end;
end;

function TFermentable.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
    5: Result := FermentableTypeDisplayNames[FFermentableType];
    6: Result := FYield.Value;
    7: Result := FColor.Value;
    8: Result := FCoarseFineDiff.Value;
    9: Result := FMoisture.Value;
    10: Result := FDiastaticPower.Value;
    11: Result := FProtein.Value;
    12: Result := FDissolvedProtein.Value;
    13: Result := FMaxInBatch.Value;
    14: Result := FIbuGalPerLb.Value;
    15: Result := FAddAfterBoil.Value;
    16: Result := FOrigin.Value;
    17: Result := FSupplier.Value;
    18: Result := FRecommendMash.Value;
    19: Result := GrainTypeDisplayNames[FGrainType];
    20: Result := AddedTypeNames[FAdded];
    21: Result := FPercentage.Value;
    22: Result:= FAdjustToTotal100.Value;
    23: Result:= FDIpH.Value;
    24: Result:= FAcidTo57.Value;
  end;
end;

function TFermentable.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Type' then
    Result := 5
  else if s = 'Opbrengst' then
    Result := 6
  else if s = 'Kleur' then
    Result := 7
  else if s = 'Fijn/grof verschil' then
    Result := 8
  else if s = '% Vocht' then
    Result := 9
  else if s = 'Enzymkracht' then
    Result := 10
  else if s = '% Eiwit' then
    Result := 11
  else if s = '% Opgelost eiwit' then
    Result := 12
  else if s = 'Max. in stort' then
    Result := 13
  else if s = 'IBU.gal/lb' then
    Result := 14
  else if s = 'Na koken toevoegen' then
    Result := 15
  else if s = 'Herkomst' then
    Result := 16
  else if s = 'Leverancier' then
    Result := 17
  else if s = 'Meemaischen?' then
    Result := 18
  else if s = 'Mout type' then
    Result := 19
  else if s = 'Toegevoegd bij' then
    Result := 20
  else if s = 'Percentage' then
    Result := 21
  else if s = 'Pas percentage aan tot totaal = 100' then
    Result:= 22
  else if s = 'DI pH' then
    Result:= 23
  else if s = 'Zuur tot pH = 5,7' then
    Result:= 24;
end;

function TFermentable.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    5: Result := 'Type';
    6: Result := 'Opbrengst';
    7: Result := 'Kleur';
    8: Result := 'Fijn/grof verschil';
    9: Result := '% Vocht';
    10: Result := 'Enzymkracht';
    11: Result := '% Eiwit';
    12: Result := '% Opgelost eiwit';
    13: Result := 'Max. in stort';
    14: Result := 'IBU.gal/lb';
    15: Result := 'Na koken toevoegen';
    16: Result := 'Herkomst';
    17: Result := 'Leverancier';
    18: Result := 'Meemaischen?';
    19: Result := 'Mout type';
    20: Result := 'Toegevoegd bij';
    21: Result := 'Percentage';
    22: Result:= 'Pas percentage aan tot totaal = 100';
    23: Result:= 'DI pH';
    24: Result:= 'Zuur tot pH = 5,7';
  end;
end;

procedure TFermentable.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('FERMENTABLE');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'TYPE', FermentableTypeNames[FFermentableType]);
  FYield.SaveXML(Doc, iChild, bxml);
  FColor.SaveXML(Doc, iChild, bxml);
  FAddAfterBoil.SaveXML(Doc, iChild, bxml);
  FOrigin.SaveXML(Doc, iChild, bxml);
  FSupplier.SaveXML(Doc, iChild, bxml);
  FCoarseFineDiff.SaveXML(Doc, iChild, bxml);
  FMoisture.SaveXML(Doc, iChild, bxml);
  FDiastaticPower.SaveXML(Doc, iChild, bxml);
  FProtein.SaveXML(Doc, iChild, bxml);
  FMaxInBatch.SaveXML(Doc, iChild, bxml);
  FRecommendMash.SaveXML(Doc, iChild, bxml);
  FIbuGalPerLb.SaveXML(Doc, iChild, bxml);
  //Extensions
  FColor.SaveXMLDisplayValue(Doc, iChild);
  //BrewBuddyXML
  if not bxml then
  begin
    AddNode(Doc, iChild, 'GRAINTYPE', GrainTypeNames[FGrainType]);
    AddNode(Doc, iChild, 'ADDED', AddedTypeNames[FAdded]);
    FDissolvedProtein.SaveXML(Doc, iChild, bxml);
    FPercentage.SaveXML(Doc, iChild, bxml);
    FAdjustToTotal100.SaveXML(Doc, iChild, bxml);
    FDIpH.SaveXML(Doc, iChild, bxml);
    FAcidTo57.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TFermentable.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  TypeName := GetNodeString(iNode, 'TYPE');
  FYield.ReadXML(iNode);
  FColor.ReadXML(iNode);
  AddAfterBoil.ReadXML(iNode);
  Origin.ReadXML(iNode);
  Supplier.ReadXML(iNode);
  FCoarseFineDiff.ReadXML(iNode);
  FMoisture.ReadXML(iNode);
  FDiastaticPower.ReadXML(iNode);
  FProtein.ReadXML(iNode);
  FMaxInBatch.ReadXML(iNode);
  RecommendMash.ReadXML(iNode);
  FIbuGalPerLb.ReadXML(iNode);
  //BrewBuddyXML
  GrainTypeName := GetNodeString(iNode, 'GRAINTYPE');
  AddedTypeName := GetNodeString(iNode, 'ADDED');
  FDissolvedProtein.ReadXML(iNode);
  FPercentage.ReadXML(iNode);
  FAdjustToTotal100.ReadXML(iNode);
  FDIpH.ReadXML(iNode);
  FAcidTo57.ReadXML(iNode);

  CheckMissingFields;

  SetpHParameters(TRUE);

  if FFermentableType <> ftGrain then FGrainType:= gtNone;
end;

Procedure TFermentable.SetpHParameters(force : boolean);
var x, ebc : double;
begin
  if Between(FDIpH.Value, -0.01, 0.01) or Between(FAcidTo57.Value, -0.1, 0.1) or force then
  begin
    ebc:= SRMtoEBC(FColor.Value);
    case FGrainType of
    gtBase, gtKilned:
    begin
      FDIpH.Value:= -0.0132 * ebc + 5.7605;
      x:= 0.4278 * ebc - 1.8106;
      FAcidTo57.Value:= x;
    end;
    gtRoast:
    begin
      FDIpH.Value:= 0.00018 * ebc + 4.558;
      FAcidTo57.Value:= -0.0176 * ebc + 60.04;
    end;
    gtCrystal:
    begin
      FDIpH.Value:= -0.0019 * ebc + 5.2175;
      FAcidTo57.Value:= 0.132 * ebc + 14.277;
    end;
    gtSour:
    begin
      FDIpH.Value:= 3.44;
      FAcidTo57.Value:= 337;
    end;
    gtSpecial: //this could be anything. Assume for now it is a non-acidulated base or kilned malt
    begin
      FDIpH.Value:= -0.0132 * ebc + 5.7605;
      FAcidTo57.Value:= 0.4278 * ebc - 1.8106;
    end;
    end;
  end;
  //known parameters should be filled in here
  if FSupplier.Value = 'Weyermann' then
  begin
    if FName.Value = 'Vienna mout' then
    begin
      FDIpH.Value:= 5.65;
      FAcidTo57.Value:= 1.6;
    end;
    if FName.Value = 'Münchner I' then
    begin
      FDIpH.Value:= 5.44;
      FAcidTo57.Value:= 8.4;
    end;
    if FName.Value = 'Münchner II' then
    begin
      FDIpH.Value:= 5.54;
      FAcidTo57.Value:= 5.6;
    end;
    if FName.Value = 'Caramunich I' then
    begin
      FDIpH.Value:= 5.1;
      FAcidTo57.Value:= 22.4;
    end;
    if FName.Value = 'Caramunich II' then
    begin
      FDIpH.Value:= 4.71;
      FAcidTo57.Value:= 49;
    end;
    if FName.Value = 'Caramunich III' then
    begin
      FDIpH.Value:= 4.92;
      FAcidTo57.Value:= 31.2;
    end;
    if FName.Value = 'Cara-aroma' then
    begin
      FDIpH.Value:= 4.48;
      FAcidTo57.Value:= 74.4;
    end;
    if FName.Value = 'Carafa I' then
    begin
      FDIpH.Value:= 4.71;
      FAcidTo57.Value:= 42;
    end;
    if FName.Value = 'Carafa III' then
    begin
      FDIpH.Value:= 4.81;
      FAcidTo57.Value:= 35.4;
    end;
    if FName.Value = 'Carafa II' then
    begin
      FDIpH.Value:= 4.76;
      FAcidTo57.Value:= 38.7;
    end;
    if FName.Value = 'Carafa Special I' then
    begin
      FDIpH.Value:= 4.73;
      FAcidTo57.Value:= 46.4;
    end;
    if FName.Value = 'Carafa Special II' then
    begin
      FDIpH.Value:= 4.78;
      FAcidTo57.Value:= 42.9;
    end;
    if FName.Value = 'Carafa Special III' then
    begin
      FDIpH.Value:= 4.83;
      FAcidTo57.Value:= 38.9;
    end;
    if IsInString(FName.Value, 'Zuurmout') then
    begin
      FDIpH.Value:= 3.44;
      FAcidTo57.Value:= 358.2;
    end;
  end;
end;

Procedure TFermentable.AdjustGrainType(gt : TGrainType);
begin
  FGrainType:= gt;
  SetpHParameters(TRUE);
end;

Procedure TFermentable.CheckMissingFields;
var s : string;
begin
  s:= FName.Value;
  //routine for checking imported xml files for missing fields, especially FGrainType
  //for adjusting imported Brouwvisie grains/recipes
  if (FFermentableType = ftGrain) and (FGrainType = gtNone) then
  begin
    if IsInString(s, 'carafa') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'cara') then AdjustGrainType(gtCrystal)
    else if IsInString(s, 'karamel') then AdjustGrainType(gtCrystal)
    else if IsInString(s, 'roost') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'brouw') then AdjustGrainType(gtBase)
    else if IsInString(s, 'amber') then AdjustGrainType(gtKilned)
    else if IsInString(s, 'aroma') then AdjustGrainType(gtKilned)
    else if IsInString(s, 'biscuit') then AdjustGrainType(gtKilned)
    else if IsInString(s, 'black') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'brown') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'choco') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'crystal') then AdjustGrainType(gtCrystal)
    else if IsInString(s, 'diastase') then AdjustGrainType(gtBase)
    else if IsInString(s, 'gebrand') then AdjustGrainType(gtRoast)
    else if IsInString(s, 'melanoi') then AdjustGrainType(gtKilned)
    else if IsInString(s, 'mild') then AdjustGrainType(gtBase)
    else if IsInString(s, 'münch') then AdjustGrainType(gtBase)
    else if IsInString(s, 'munch') then AdjustGrainType(gtBase)
    else if IsInString(s, 'munich') then AdjustGrainType(gtBase)
    else if IsInString(s, 'münich') then AdjustGrainType(gtBase)
    else if IsInString(s, 'pale') then AdjustGrainType(gtBase)
    else if IsInString(s, 'pils') then AdjustGrainType(gtBase)
    else if IsInString(s, 'roggemout') then AdjustGrainType(gtBase)
    else if IsInString(s, 'rook') then AdjustGrainType(gtBase)
    else if IsInString(s, 'special b') then AdjustGrainType(gtCrystal)
    else if IsInString(s, 'special-b') then AdjustGrainType(gtCrystal)
    else if IsInString(s, 'tarwe') then AdjustGrainType(gtBase)
    else if IsInString(s, 'vienna') then AdjustGrainType(gtBase)
    else if IsInString(s, 'weizen') then AdjustGrainType(gtBase)
    else if IsInString(s, 'whiskey') then AdjustGrainType(gtBase)
    else if IsInString(s, 'wiener') then AdjustGrainType(gtBase)
    else if IsInString(s, 'zuur') then AdjustGrainType(gtBase)
    else if IsInString(s, 'zwart') then AdjustGrainType(gtRoast);
  end; //gtBase, gtRoast, gtCrystal, gtKilned, gtSour, gtSpecial, gtNone

  if IsInString(s, 'vlok') and ((FFermentableType <> ftAdjunct) or (FGrainType <> gtNone)) then
  begin
    FFermentableType:= ftAdjunct;
    AdjustGrainType(gtNone);
  end;
  if IsInString(s, 'gierst') and ((FFermentableType <> ftAdjunct) or (FGrainType <> gtNone)) then
  begin
    FFermentableType:= ftAdjunct;
    AdjustGrainType(gtNone);
  end;
  if IsInString(s, 'kandij') and ((FFermentableType <> ftSugar) or (FGrainType <> gtNone)) then
  begin
    FFermentableType:= ftSugar;
    AdjustGrainType(gtNone);
  end;
  if IsInString(s, 'siroop') and ((FFermentableType <> ftSugar) or (FGrainType <> gtNone)) then
  begin
    FFermentableType:= ftSugar;
    AdjustGrainType(gtNone);
  end;
  if IsInString(s, 'suiker') and ((FFermentableType <> ftSugar) or (FGrainType <> gtNone)) then
  begin
    FFermentableType:= ftSugar;
    AdjustGrainType(gtNone);
  end;
end;

Function TFermentable.BufferCapacity : double;  //mEq/kg.pH
var C1, ebc: double;
    //x, y: double;
begin
  //x:= FAcidTo57.Value;
  //y:= FDIpH.Value;
  if (FDIpH.Value <> 5.7) and (not Between(FAcidTo57.Value, -0.1, 0.1)) then
    C1:= FAcidTo57.Value / (FDIpH.Value - 5.7)
  else
  begin
    ebc:= SRMtoEBC(FColor.Value);
    case FGrainType of
    gtBase, gtKilned: C1:= 0.014 * ebc - 34.192;
    gtCrystal: C1:= -0.0597 * ebc - 32.457;
    gtRoast: C1:= 0.0107 * ebc - 54.768;
    gtSour: C1:= -149;
    gtSpecial: C1:= 0.014 * ebc - 34.192;
    end;
  end;
  Result:= C1;
end;

Function TFermentable.AcidRequired(ZpH : double) : double; //mEq/kg
var C1, x : double;
begin
  C1:= BufferCapacity;
  x:= FDIpH.Value;
  Result:= C1 * (ZpH - x);
end;

Function TFermentable.IsInstock : boolean;
var i : integer;
    F : TFermentable;
begin
  Result:= TRUE;
  for i:= 0 to Fermentables.NumItems - 1 do
  begin
    F:= Fermentables.FindByNameAndSupplier(FName.Value, FSupplier.Value);
    if F <> NIL then
    begin
      if F.Inventory.Value < FAmount.Value then Result:= false;
    end
    else Result:= false;
  end;

end;

procedure TFermentable.SetTypeName(s: string);
var
  ft: TFermentableType;
begin
  for ft := Low(FermentableTypeNames) to High(FermentableTypeNames) do
    if LowerCase(FermentableTypeNames[ft]) = LowerCase(s) then
      FFermentableType := ft;
end;

procedure TFermentable.SetTypeDisplayName(s: string);
var
  ft: TFermentableType;
begin
  for ft := Low(FermentableTypeDisplayNames) to High(FermentableTypeDisplayNames) do
    if LowerCase(FermentableTypeDisplayNames[ft]) = LowerCase(s) then
      FFermentableType := ft;
end;

function TFermentable.GetTypeName: string;
begin
  Result := FermentableTypeNames[FFermentableType];
end;

function TFermentable.GetTypeDisplayName: string;
begin
  Result := FermentableTypeDisplayNames[FFermentableType];
end;

procedure TFermentable.SetGrainTypeName(s: string);
var
  ft: TGrainType;
begin
  for ft := Low(GrainTypeNames) to High(GrainTypeNames) do
    if LowerCase(GrainTypeNames[ft]) = LowerCase(s) then
      FGrainType := ft;
end;

procedure TFermentable.SetGrainTypeDisplayName(s: string);
var
  ft: TGrainType;
begin
  for ft := Low(GrainTypeDisplayNames) to High(GrainTypeDisplayNames) do
    if LowerCase(GrainTypeDisplayNames[ft]) = LowerCase(s) then
      FGrainType := ft;
end;

function TFermentable.GetGrainTypeName: string;
begin
  Result := GrainTypeNames[FGrainType];
end;

function TFermentable.GetGrainTypeDisplayName: string;
begin
  Result := GrainTypeDisplayNames[FGrainType];
end;

procedure TFermentable.SetAddedTypeName(s: string);
var
  ft: TAddedType;
begin
  for ft := Low(AddedTypeNames) to High(AddedTypeNames) do
    if LowerCase(AddedTypeNames[ft]) = LowerCase(s) then
      FAdded := ft;
end;

procedure TFermentable.SetAddedTypeDisplayName(s: string);
var
  ft: TAddedType;
begin
  for ft := Low(AddedTypeDisplayNames) to High(AddedTypeDisplayNames) do
    if LowerCase(AddedTypeDisplayNames[ft]) = LowerCase(s) then
      FAdded := ft;
end;

function TFermentable.GetAddedTypeName: string;
begin
  Result := AddedTypeNames[FAdded];
end;

function TFermentable.GetAddedTypeDisplayName: string;
begin
  Result := AddedTypeDisplayNames[FAdded];
end;

function TFermentable.GetExtract: double;
begin
  Result := 0;
  if FRecipe <> nil then
  begin
    Result := FAmount.Value * FYield.Value / 100 * (1 - FMoisture.Value / 100);
    if FAdded = atMash then
      Result := Result * FRecipe.Efficiency / 100;
  end;
end;

function TFermentable.GetKolbachIndex: double;
begin
  if FProtein.Value > 0 then
    Result := FDissolvedProtein.Value / FProtein.Value
  else
    Result := 0;
end;

{==============================================================================}

constructor TYeast.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtYeast;
  FIngredientType := itYeast;

  FAmount.vUnit := pks;
  FAmount.DisplayUnit := pks;
  FAmount.Decimals := 1;

  FInventory.vUnit := pks;
  FInventory.DisplayUnit := pks;
  FInventory.Decimals := 0;

  FAmountIsWeight := TBBoolean.Create(self);
  FAmountIsWeight.Value := False;
  FAmountIsWeight.NodeLabel := 'AMOUNT_IS_WEIGHT';

  FYeastType := ytAle;
  FForm := yfLiquid;

  FLaboratory := TBString.Create(self);
  FLaboratory.Value := '';
  FLaboratory.NodeLabel := 'LABORATORY';

  FProductID := TBString.Create(self);
  FProductID.Value := '';
  FProductID.NodeLabel := 'PRODUCT_ID';

  FMinTemperature := TBFloat.Create(self);
  FMinTemperature.vUnit := celcius;
  FMinTemperature.DisplayUnit := celcius;
  FMinTemperature.MinValue := 0.0;
  FMinTemperature.MaxValue := 40;
  FMinTemperature.Value := 0.0;
  FMinTemperature.Decimals := 0;
  FMinTemperature.NodeLabel := 'MIN_TEMPERATURE';
  FMinTemperature.DisplayLabel := 'DISP_MIN_TEMP';

  FMaxTemperature := TBFloat.Create(self);
  FMaxTemperature.vUnit := celcius;
  FMaxTemperature.DisplayUnit := celcius;
  FMaxTemperature.MinValue := 0.0;
  FMaxTemperature.MaxValue := 40;
  FMaxTemperature.Value := 0.0;
  FMaxTemperature.Decimals := 0;
  FMaxTemperature.NodeLabel := 'MAX_TEMPERATURE';
  FMaxTemperature.DisplayLabel := 'DISP_MAX_TEMP';

  FFlocculation := flLow;

  FAttenuation := TBFloat.Create(self);
  FAttenuation.vUnit := perc;
  FAttenuation.DisplayUnit := perc;
  FAttenuation.MinValue := 30.0;
  FAttenuation.MaxValue := 100;
  FAttenuation.Value := 77;
  FAttenuation.Decimals := 1;
  FAttenuation.NodeLabel := 'ATTENUATION';
  FAttenuation.DisplayLabel := '';

  FBestFor := TBString.Create(self);
  FBestFor.Value := '';
  FBestFor.NodeLabel := 'BEST_FOR';

  FTimesCultured := TBInteger.Create(self);
  FTimesCultured.vUnit := none;
  FTimesCultured.MinValue := 0;
  FTimesCultured.MaxValue := 100;
  FTimesCultured.Value := 0;
  FTimesCultured.NodeLabel := 'TIMES_CULTURED';

  FMaxReuse := TBInteger.Create(self);
  FMaxReuse.vUnit := none;
  FMaxReuse.MinValue := 0;
  FMaxReuse.MaxValue := 10;
  FMaxReuse.Value := 0;
  FMaxReuse.NodeLabel := 'MAX_REUSE';

  FAddToSecondary := TBBoolean.Create(self);
  FAddToSecondary.Value := False;
  FAddToSecondary.NodeLabel := 'ADD_TO_SECONDARY';

  //BrouwHulp XML
  FStarterType := stSimple;

  FStarterMade := TBBoolean.Create(self);
  FStarterMade.Value := True;
  FStarterMade.NodeLabel := 'STARTER_MADE';

  FStarterVolume1 := TBFloat.Create(self);
  FStarterVolume1.vUnit := liter;
  FStarterVolume1.DisplayUnit := liter;
  FStarterVolume1.MinValue := 0.0;
  FStarterVolume1.MaxValue := 1000;
  FStarterVolume1.Value := 0.0;
  FStarterVolume1.Decimals := 1;
  FStarterVolume1.NodeLabel := 'STARTER_VOLUME';
  FStarterVolume1.DisplayLabel := '';

  FStarterVolume2 := TBFloat.Create(self);
  FStarterVolume2.vUnit := liter;
  FStarterVolume2.DisplayUnit := liter;
  FStarterVolume2.MinValue := 0.0;
  FStarterVolume2.MaxValue := 1000;
  FStarterVolume2.Value := 0.0;
  FStarterVolume2.Decimals := 1;
  FStarterVolume2.NodeLabel := 'STARTER_VOLUME_2';
  FStarterVolume2.DisplayLabel := '';

  FStarterVolume3 := TBFloat.Create(self);
  FStarterVolume3.vUnit := liter;
  FStarterVolume3.DisplayUnit := liter;
  FStarterVolume3.MinValue := 0.0;
  FStarterVolume3.MaxValue := 1000;
  FStarterVolume3.Value := 0.0;
  FStarterVolume3.Decimals := 1;
  FStarterVolume3.NodeLabel := 'STARTER_VOLUME_3';
  FStarterVolume3.DisplayLabel := '';

  FOGStarter := TBFloat.Create(self);
  FOGStarter.vUnit := sg;
  FOGStarter.DisplayUnit := sg;
  FOGStarter.MinValue := 1.0;
  FOGStarter.MaxValue := 1.1;
  FOGStarter.Value := 1.04;
  FOGStarter.Decimals := 3;
  FOGStarter.NodeLabel := 'OG_STARTER';
  FOGStarter.DisplayLabel := '';

  FCultureDate := TBDate.Create(self);
  FCultureDate.Value := 0;
  FCultureDate.NodeLabel := 'CULTURE_DATE';

  FTimeAerated := TBFloat.Create(self);
  FTimeAerated.vUnit := uur;
  FTimeAerated.DisplayUnit := uur;
  FTimeAerated.MinValue := 0.0;
  FTimeAerated.MaxValue := 100;
  FTimeAerated.Value := 0.0;
  FTimeAerated.Decimals := 1;
  FTimeAerated.NodeLabel := 'TIME_AERATED';
  FTimeAerated.DisplayLabel := '';

  FTemperature := TBFloat.Create(self);
  FTemperature.vUnit := celcius;
  FTemperature.DisplayUnit := celcius;
  FTemperature.MinValue := 0.0;
  FTemperature.MaxValue := 40;
  FTemperature.Value := 0.0;
  FTemperature.Decimals := 1;
  FTemperature.NodeLabel := 'TEMP';
  FTemperature.DisplayLabel := '';

{  FNutrientsAdded := TBBoolean.Create(self);
  FNutrientsAdded.Value := True;
  FNutrientsAdded.NodeLabel := 'NUTRIENTS_ADDED';

  FNameNutrients := TBString.Create(self);
  FNameNutrients.Value := '';
  FNameNutrients.NodeLabel := 'NAME_NUTRIENTS';

  FAmountNutrients := TBFloat.Create(self);
  FAmountNutrients.vUnit := kilogram;
  FAmountNutrients.DisplayUnit := gram;
  FAmountNutrients.MinValue := 0.0;
  FAmountNutrients.MaxValue := 1;
  FAmountNutrients.Value := 0.0;
  FAmountNutrients.Decimals := 1;
  FAmountNutrients.NodeLabel := 'AMOUNT_NUTRIENTS';
  FAmountNutrients.DisplayLabel := ''; }

  FZincAdded := TBBoolean.Create(self);
  FZincAdded.Value := False;
  FZincAdded.NodeLabel := 'ZINC_ADDED';

  FAmountZinc := TBFloat.Create(self);
  FAmountZinc.vUnit := kilogram;
  FAmountZinc.DisplayUnit := gram;
  FAmountZinc.MinValue := 0.0;
  FAmountZinc.MaxValue := 1;
  FAmountZinc.Value := 0.0;
  FAmountZinc.Decimals := 2;
  FAmountZinc.NodeLabel := 'AMOUNT_ZINC';
  FAmountZinc.DisplayLabel := '';

  FAmountYeast := TBFloat.Create(self);
  //amount of packs, kg or l of yeast used in batch or in starter
  FAmountYeast.vUnit := pks;
  FAmountYeast.DisplayUnit := pks;
  FAmountYeast.MinValue := 0;
  FAmountYeast.MaxValue := 10000;
  FAmountYeast.Value := 0.0;
  FAmountYeast.Decimals := 1;
  FAmountYeast.NodeLabel := 'AMOUNT_YEAST';
  FAmountYeast.DisplayLabel := '';

  FAmountExtract := TBFloat.Create(self);
  FAmountExtract.vUnit := kilogram;
  FAmountExtract.DisplayUnit := kilogram;
  FAmountExtract.MinValue := 0.0;
  FAmountExtract.MaxValue := 100;
  FAmountExtract.Value := 0.0;
  FAmountExtract.Decimals := 3;
  FAmountExtract.NodeLabel := 'AMOUNT_EXTRACT';
  FAmountExtract.DisplayLabel := '';

  FCostExtract := TBFloat.Create(self);
  FCostExtract.vUnit := euro;
  FCostExtract.DisplayUnit := euro;
  FCostExtract.MinValue := 0.0;
  FCostExtract.MaxValue := 20;
  FCostExtract.Value := 0.0;
  FCostExtract.Decimals := 2;
  FCostExtract.NodeLabel := 'COST_EXTRACT';
  FCostExtract.DisplayLabel := '';
end;

destructor TYeast.Destroy;
begin
  FLaboratory.Free;
  FProductID.Free;
  FMinTemperature.Free;
  FMaxTemperature.Free;
  FAttenuation.Free;
  FStarterVolume1.Free;
  FStarterVolume2.Free;
  FStarterVolume3.Free;
  FOGStarter.Free;
  FTimeAerated.Free;
  FTemperature.Free;
//  FAmountNutrients.Free;
  FAmountZinc.Free;
  FAmountExtract.Free;
  FCostExtract.Free;
  FAmountIsWeight.Free;
  FBestFor.Free;
  FTimesCultured.Free;
  FMaxReuse.Free;
  FAddToSecondary.Free;
  FStarterMade.Free;
  FCultureDate.Free;
//  FNutrientsAdded.Free;
//  FNameNutrients.Free;
  FZincAdded.Free;
  FAmountYeast.Free;
  inherited;
end;

procedure TYeast.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FYeastType := TYeast(Source).YeastType;
    FForm := TYeast(Source).Form;
    FFlocculation := TYeast(Source).Flocculation;
    FStarterType := TYeast(Source).StarterType;
    FLaboratory.Assign(TYeast(Source).Laboratory);
    FProductID.Assign(TYeast(Source).ProductID);

    FMinTemperature.Assign(TYeast(Source).MinTemperature);
    FMaxTemperature.Assign(TYeast(Source).MaxTemperature);
    FAttenuation.Assign(TYeast(Source).Attenuation);
    FStarterVolume1.Assign(TYeast(Source).StarterVolume1);
    FStarterVolume2.Assign(TYeast(Source).StarterVolume2);
    FStarterVolume3.Assign(TYeast(Source).StarterVolume3);
    FOGStarter.Assign(TYeast(Source).OGStarter);
    FTimeAerated.Assign(TYeast(Source).TimeAerated);
    FTemperature.Assign(TYeast(Source).Temperature);
//    FAmountNutrients.Assign(TYeast(Source).AmountNutrients);
    FAmountZinc.Assign(TYeast(Source).AmountZinc);
    FAmountExtract.Assign(TYeast(Source).AmountExtract);
    FCostExtract.Assign(TYeast(Source).CostExtract);
    FAmountIsWeight.Assign(TYeast(Source).AmountIsWeight);
    FBestFor.Assign(TYeast(Source).BestFor);
    FTimesCultured.Assign(TYeast(Source).TimesCultured);
    FMaxReuse.Assign(TYeast(Source).MaxReuse);
    FAddToSecondary.Assign(TYeast(Source).AddToSecondary);
    FStarterMade.Assign(TYeast(Source).StarterMade);
    FCultureDate.Assign(TYeast(Source).CultureDate);
//    FNutrientsAdded.Assign(TYeast(Source).NutrientsAdded);
//    FNameNutrients.Assign(TYeast(Source).NameNutrients);
    FZincAdded.Assign(TYeast(Source).ZincAdded);
    FAmountYeast.Assign(TYeast(Source).AmountYeast);
  end;
end;

function TYeast.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
    5: Result := FLaboratory.Value;
    6: Result := FProductID.Value;
    7: Result := YeastTypeDisplayNames[FYeastType];
    8: Result := YeastFormDisplayNames[FForm];
    9: Result := FlocculationDisplayNames[FFlocculation];
    10: Result := StarterTypeDisplayNames[FStarterType];
    11: Result := FMinTemperature.Value;
    12: Result := FMaxTemperature.Value;
    13: Result := FAttenuation.Value;
    14: Result := FStarterVolume1.Value;
    15: Result := FStarterVolume2.Value;
    16: Result := FStarterVolume3.Value;
    17: Result := FOGStarter.Value;
    18: Result := FTimeAerated.Value;
    19: Result := FTemperature.Value;
//    18: Result := FAmountNutrients.Value;
    20: Result := FAmountZinc.Value;
    21: Result := FAmountExtract.Value;
    22: Result := FCostExtract.Value;
    23: Result := FAmountIsWeight.Value;
    24: Result := FBestFor.Value;
    25: Result := FTimesCultured.Value;
    26: Result := FMaxReuse.Value;
    27: Result := FAddToSecondary.Value;
    28: Result := FStarterMade.Value;
    29: Result := FCultureDate.Value;
//    29: Result := FNutrientsAdded.Value;
//    30: Result := FNameNutrients.Value;
    30: Result := FZincAdded.Value;
    31: Result := FAmountYeast.Value;
  end;
end;

function TYeast.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Herkomst' then
    Result := 5
  else if s = 'Productcode' then
    Result := 6
  else if s = 'Type' then
    Result := 7
  else if s = 'Vorm' then
    Result := 8
  else if s = 'Flocculatie' then
    Result := 9
  else if s = 'Starter type' then
    Result := 10
  else if s = 'Min. temperatuur' then
    Result := 11
  else if s = 'Max. temperatuur' then
    Result := 12
  else if s = 'Vergistingsgraad' then
    Result := 13
  else if s = 'Starter volume' then
    Result := 14
  else if s = 'SG starter' then
    Result := 15
  else if s = 'Tijd belucht/geroerd' then
    Result := 16
  else if s = 'Temperatuur' then
    Result := 17
  else if s = 'Hoeveelheid voeding' then
    Result := 18
  else if s = 'Hoeveelheid zink' then
    Result := 19
  else if s = 'Hoeveelheid moutextract' then
    Result := 20
  else if s = 'Kosten moutextract' then
    Result := 21
  else if s = 'Hoeveelheid is gewicht' then
    Result := 22
  else if s = 'Aanbevolen stijlen' then
    Result := 23
  else if s = 'Aantal keren hergebruikt' then
    Result := 24
  else if s = 'Maximum hergebruik' then
    Result := 25
  else if s = 'Gebruikt bij nagisting' then
    Result := 26
  else if s = 'Starter gemaakt?' then
    Result := 27
  else if s = 'Starter datum' then
    Result := 28
  else if s = 'Voeding toegevoegd?' then
    Result := 29
  else if s = 'Naam voeding' then
    Result := 30
  else if s = 'Zink(gist) toegevoegd?' then
    Result := 31
  else if s = 'Hoeveelheid gist' then
    Result := 32;
end;

function TYeast.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    5: Result := 'Herkomst';
    6: Result := 'Productcode';
    7: Result := 'Type';
    8: Result := 'Vorm';
    9: Result := 'Flocculatie';
    10: Result := 'Starter type';
    11: Result := 'Min. temperatuur';
    12: Result := 'Max. temperatuur';
    13: Result := 'Vergistingsgraad';
    14: Result := 'Starter volume';
    15: Result := 'SG starter';
    16: Result := 'Tijd belucht/geroerd';
    17: Result := 'Temperatuur';
    18: Result := 'Hoeveelheid voeding';
    19: Result := 'Hoeveelheid zink';
    20: Result := 'Hoeveelheid moutextract';
    21: Result := 'Kosten moutextract';
    22: Result := 'Hoeveelheid is gewicht';
    23: Result := 'Aanbevolen stijlen';
    24: Result := 'Aantal keren hergebruikt';
    25: Result := 'Maximum hergebruik';
    26: Result := 'Gebruikt bij nagisting';
    27: Result := 'Starter gemaakt?';
    28: Result := 'Starter datum';
    29: Result := 'Voeding toegevoegd?';
    30: Result := 'Naam voeding';
    31: Result := 'Zink(gist) toegevoegd?';
    32: Result := 'Hoeveelheid gist';
  end;
end;

procedure TYeast.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('YEAST');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'TYPE', YeastTypeNames[FYeastType]);
  if bxml then
  begin
    if (FForm = yfFrozen) or (FForm = yfBottle) then
      AddNode(Doc, iChild, 'FORM', YeastFormNames[yfCulture])
    else
      AddNode(Doc, iChild, 'FORM', YeastFormNames[FForm]);
  end
  else
    AddNode(Doc, iChild, 'FORM', YeastFormNames[FForm]);
  FAmountIsWeight.SaveXML(Doc, iChild, bxml);
  FLaboratory.SaveXML(Doc, iChild, bxml);
  FProductID.SaveXML(Doc, iChild, bxml);
  FMinTemperature.SaveXML(Doc, iChild, bxml);
  FMaxTemperature.SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'FLOCCULATION', FlocculationNames[FFlocculation]);
  FAttenuation.SaveXML(Doc, iChild, bxml);
  FBestFor.SaveXML(Doc, iChild, bxml);
  FTimesCultured.SaveXML(Doc, iChild, bxml);
  FMaxReuse.SaveXML(Doc, iChild, bxml);
  FAddToSecondary.SaveXML(Doc, iChild, bxml);
  //Extensions
  FMinTemperature.SaveXMLDisplayValue(Doc, iChild);
  FMaxTemperature.SaveXMLDisplayValue(Doc, iChild);
  FCultureDate.SaveXML(Doc, iChild, bxml);
  //BrouwHulp XML
  if not bxml then
  begin
    AddNode(Doc, iChild, 'STARTER_TYPE', StarterTypeNames[FStarterType]);
    FStarterMade.SaveXML(Doc, iChild, bxml);
    FStarterVolume1.SaveXML(Doc, iChild, bxml);
    FStarterVolume2.SaveXML(Doc, iChild, bxml);
    FStarterVolume3.SaveXML(Doc, iChild, bxml);
    FOGStarter.SaveXML(Doc, iChild, bxml);
    FTimeAerated.SaveXML(Doc, iChild, bxml);
    FTemperature.SaveXML(Doc, iChild, bxml);
  //  FNutrientsAdded.SaveXML(Doc, iChild);
  //  FNameNutrients.SaveXML(Doc, iChild);
  //  FAmountNutrients.SaveXML(Doc, iChild);
    FZincAdded.SaveXML(Doc, iChild, bxml);
    FAmountZinc.SaveXML(Doc, iChild, bxml);
    FAmountYeast.SaveXML(Doc, iChild, bxml);
    //amount of packs of yeast used in batch or in starter
    FAmountExtract.SaveXML(Doc, iChild, bxml);
    FCostExtract.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TYeast.ReadXML(iNode: TDOMNode);
var am : double;
    s, samun : string;
begin
  inherited ReadXML(iNode);
  am:= FAmount.Value;
  TypeName := GetNodeString(iNode, 'TYPE');
  FAmountIsWeight.ReadXML(iNode);

  //Code om foutieve BrouwVisie XML te corrigeren
  s:= GetNodeString(iNode, 'FORM');
  samun:= GetNodeString(iNode, 'AMOUNT_UNIT');
  if (s = 'Lager') or (s = 'Ale') then
  begin
    if (samun = 'gr Korrelgist') then
    begin
      FAmount.Value:= FAmount.Value / 1000;
      FAmount.vUnit:= kilogram;
      FAmount.FDisplayUnit:= gram;
      FForm:= yfDry;
      FAmountIsWeight.Value:= TRUE;
      FAmountYeast.vUnit:= kilogram;
      FAmountYeast.FDisplayUnit:= gram;
      FAmountYeast.Value:= FAmount.Value;
    end;
  end
  else FormName:= s;
  if (samun = 'Propagator') or (samun = 'Activator') then
  begin
    FAmount.vUnit:= pks;
    FAmount.FDisplayUnit:= pks;
    FForm:= yfLiquid;
    FAmountIsWeight.Value:= false;
    FAmountYeast.vUnit:= pks;
    FAmountYeast.FDisplayUnit:= pks;
    FAmountYeast.Value:= am;
  end;

  FLaboratory.ReadXML(iNode);
  FProductID.ReadXML(iNode);
  FMinTemperature.ReadXML(iNode);
  FMaxTemperature.ReadXML(iNode);
  FlocculationName := GetNodeString(iNode, 'FLOCCULATION');
  FAttenuation.ReadXML(iNode);
  FBestFor.ReadXML(iNode);
  FTimesCultured.ReadXML(iNode);
  FMaxReuse.ReadXML(iNode);
  FAddToSecondary.ReadXML(iNode);
  FInventory.ReadXMLDisplayValue(iNode);
  //Extensions
  FCultureDate.ReadXML(iNode);
  //BrouwHulp XML
  StarterTypeName := GetNodeString(iNode, 'STARTER_TYPE');
  FStarterMade.ReadXML(iNode);
  FStarterVolume1.ReadXML(iNode);
  FStarterVolume2.ReadXML(iNode);
  FStarterVolume3.ReadXML(iNode);
  FOGStarter.ReadXML(iNode);
  FTimeAerated.ReadXML(iNode);
  FTemperature.ReadXML(iNode);
//  FNutrientsAdded.ReadXML(iNode);
//  FNameNutrients.ReadXML(iNode);
//  FAmountNutrients.ReadXML(iNode);
  FZincAdded.ReadXML(iNode);
  FAmountZinc.ReadXML(iNode);
  FAmountYeast.ReadXML(iNode);
  FAmountExtract.ReadXML(iNode);
  FCostExtract.ReadXML(iNode);
  FInventory.vUnit:= FAmountYeast.vUnit;
  FInventory.DisplayUnit:= FAmountYeast.DisplayUnit;
end;

Function TYeast.IsInstock : boolean;
var i : integer;
    Y : TYeast;
begin
  Result:= TRUE;
  for i:= 0 to Yeasts.NumItems - 1 do
  begin
    Y:= Yeasts.FindByNameAndLaboratory(FName.Value, FLaboratory.Value);
    if Y <> NIL then
    begin
      if Y.Inventory.Value < 0 then Result:= false;
    end
    else Result:= false;
  end;

end;

function TYeast.GetTypeName: string;
begin
  Result := YeastTypeNames[FYeastType];
end;

procedure TYeast.SetTypeName(s: string);
var
  yt: TYeastType;
begin
  for yt := Low(YeastTypeNames) to High(YeastTypeNames) do
    if LowerCase(YeastTypeNames[yt]) = LowerCase(s) then
      FYeastType := yt;
end;

function TYeast.GetTypeDisplayName: string;
begin
  Result := YeastTypeDisplayNames[FYeastType];
end;

procedure TYeast.SetTypeDisplayName(s: string);
var
  yt: TYeastType;
begin
  for yt := Low(YeastTypeDisplayNames) to High(YeastTypeDisplayNames) do
    if LowerCase(YeastTypeDisplayNames[yt]) = LowerCase(s) then
      FYeastType := yt;
end;

function TYeast.GetFormName: string;
begin
  Result := YeastFormNames[FForm];
end;

procedure TYeast.SetFormName(s: string);
var
  yf: TYeastForm;
begin
  for yf := low(YeastFormNames) to High(YeastFormNames) do
    if LowerCase(YeastFormNames[yf]) = LowerCase(s) then
    begin
      FForm := yf;
      case FForm of
        yfLiquid:
        begin
          FAmountYeast.vUnit := pks;
          FAmountYeast.DisplayUnit := pks;
          FAmountIsWeight.Value := False;
        end;
        yfSlant:
        begin
          FAmountYeast.vUnit := liter;
          FAmountYeast.DisplayUnit := milliliter;
          FAmountIsWeight.Value := False;
        end;
        yfCulture:
        begin
          FAmountYeast.vUnit := liter;
          FAmountYeast.DisplayUnit := milliliter;
          FAmountIsWeight.Value := False;
        end;
        yfDry:
        begin
          FAmountYeast.vUnit := kilogram;
          FAmountYeast.DisplayUnit := gram;
          FAmountIsWeight.Value := TRUE;
        end;
        yfBottle:
        begin
          FAmountYeast.vUnit := liter;
          FAmountYeast.DisplayUnit := milliliter;
          FAmountIsWeight.Value := False;
        end;
        yfFrozen:
        begin
          FAmountYeast.vUnit := liter;
          FAmountYeast.DisplayUnit := milliliter;
          FAmountIsWeight.Value := False;
        end;
      end;
      FInventory.vUnit := FAmountYeast.vUnit;
      FInventory.DisplayUnit := FAmountYeast.DisplayUnit;
    end;
end;

function TYeast.GetFormDisplayName: string;
begin
  Result := YeastFormDisplayNames[FForm];
end;

procedure TYeast.SetFormDisplayName(s: string);
var
  yf, lastyf: TYeastForm;
begin
  for yf := low(YeastFormDisplayNames) to High(YeastFormDisplayNames) do
    if LowerCase(YeastFormDisplayNames[yf]) = LowerCase(s) then
    begin
      if FForm <> yf then
      begin
        lastyf := FForm;
        FForm := yf;
        case FForm of
          yfLiquid:
          begin
            FAmountYeast.vUnit := pks;
            FAmountYeast.DisplayUnit := pks;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 1;
            FAmountYeast.Decimals:= 0;
            FAmountIsWeight.Value := False;
          end;
          yfSlant:
          begin
            FAmountYeast.vUnit := liter;
            FAmountYeast.DisplayUnit := milliliter;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 0.001;
            FAmountYeast.Decimals:= 3;
            FAmountIsWeight.Value := False;
            if lastyf = yfCulture then
              FAmountYeast.Value := FAmountYeast.Value / 1000;
          end;
          yfCulture:
          begin
            FAmountYeast.vUnit := liter;
            FAmountYeast.DisplayUnit := milliliter;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 1;
            FAmountYeast.Decimals:= 1;
            FAmountIsWeight.Value := False;
          end;
          yfDry:
          begin
            FAmountYeast.vUnit := kilogram;
            FAmountYeast.DisplayUnit := gram;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 1;
            FAmountYeast.Decimals:= 1;
            FAmountIsWeight.Value := TRUE;
            if lastyf = yfCulture then
              FAmountYeast.Value := FAmountYeast.Value / 1000;
          end;
          yfBottle:
          begin
            FAmountYeast.vUnit := liter;
            FAmountYeast.DisplayUnit := milliliter;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 1;
            FAmountYeast.Decimals:= 0;
            FAmountIsWeight.Value := False;
          end;
          yfFrozen:
          begin
            FAmountYeast.vUnit := liter;
            FAmountYeast.DisplayUnit := milliliter;
            FAmountYeast.MinValue:= 0;
            FAmountYeast.MaxValue:= 10000;
            FAmountYeast.Increment:= 1;
            FAmountYeast.Decimals:= 0;
            FAmountIsWeight.Value := False;
          end;
        end;
        FInventory.vUnit:= FAmountYeast.vUnit;
        FInventory.DisplayUnit:= FAmountYeast.DisplayUnit;
        FInventory.MinValue:= FAmountYeast.MinValue;
        FInventory.MaxValue:= FAmountYeast.MaxValue;
        FInventory.Increment:= FAmountYeast.Increment;
        FInventory.Decimals:= FAmountYeast.Decimals;
      end;
    end;
end;

function TYeast.GetFlocculationName: string;
begin
  Result := FlocculationNames[FFlocculation];
end;

procedure TYeast.SetFlocculationName(s: string);
var
  fl: TFlocculation;
begin
  for fl := low(FlocculationNames) to High(FlocculationNames) do
    if LowerCase(FlocculationNames[fl]) = LowerCase(s) then
      FFlocculation := fl;
end;

function TYeast.GetFlocculationDisplayName: string;
begin
  Result := FlocculationDisplayNames[FFlocculation];
end;

procedure TYeast.SetFlocculationDisplayName(s: string);
var
  fl: TFlocculation;
begin
  for fl := low(FlocculationDisplayNames) to High(FlocculationDisplayNames) do
    if LowerCase(FlocculationDisplayNames[fl]) = LowerCase(s) then
      FFlocculation := fl;
end;

function TYeast.GetStarterTypeName: string;
begin
  Result := StarterTypeNames[FStarterType];
end;

procedure TYeast.SetStarterTypeName(s: string);
var
  st: TStarterType;
begin
  for st := low(StarterTypeNames) to High(StarterTypeNames) do
    if LowerCase(StarterTypeNames[st]) = LowerCase(s) then
      FStarterType := st;
end;

function TYeast.GetStarterTypeDisplayName: string;
begin
  Result := StarterTypeDisplayNames[FStarterType];
end;

procedure TYeast.SetStarterTypeDisplayName(s: string);
var
  st: TStarterType;
begin
  for st := low(StarterTypeDisplayNames) to High(StarterTypeDisplayNames) do
    if LowerCase(StarterTypeDisplayNames[st]) = LowerCase(s) then
      FStarterType := st;
end;

function TYeast.CalcAmountYeast: double;
  //calculate the amount of yeast in number of cells
  //Amount in billions of cells
var
  i: integer;
begin
  Result := 0;
  case FForm of
    yfDry: //calculate amount of cells from number of kilograms of dry yeast
    begin
      Result := FAmountYeast.Value * 1000 * AmCellspGramDry / 1000000000;
      FAmount.Value := FAmountYeast.Value;
    end;
    yfLiquid: //calculate amount of cells from number of Wyeast Activatorpacks or WhiteLabs tubes
    begin
      if AmCellspMlSlurry > 0 then
      begin
        Result := FAmountYeast.Value * AmCellspPack / 1000000000;
        FAmount.Value := Result * 1000000000 / AmCellspMlSlurry / 1000;
        FAmount.vUnit := liter;
        FAmount.DisplayUnit := milliliter;
      end;
    end;
    yfSlant: //amount of cells from slant (1 colony)
    begin //assume 1 colony is 1/100 of a ml.
      Result := FAmountYeast.Value * 1000 * AmCellspMlSlurry / 1000000000;
      FAmount.Value := FAmountYeast.Value;
      FAmount.vUnit := liter;
      FAmount.DisplayUnit := milliliter;
    end;
    yfCulture: //calculate amount of cells from liters of slurry
    begin
      Result := FAmountYeast.Value * 1000 * AmCellspMlSlurry / 1000000000;
      FAmount.Value := FAmountYeast.Value;
      FAmount.vUnit := liter;
      FAmount.DisplayUnit := milliliter;
    end;
    yfBottle:
    begin  //sediment in a bottle holds in ml
      if AmCellspMlSlurry > 0 then
      begin
        Result := FAmountYeast.Value * 1000 * AmCellspMlSlurry / 1000000000;
        FAmount.Value := FAmountYeast.Value;
        FAmount.vUnit := liter;
        FAmount.DisplayUnit := milliliter;
      end;
    end;
    yfFrozen:
    begin  //sediment in cup holds 1 ml of yeast
      if AmCellspMlSlurry > 0 then
      begin
        Result := FAmountYeast.Value * 1000 * AmCellspMlSlurry / 1000000000;
        FAmount.Value := FAmountYeast.Value; //Result * 1000000000 / AmCellspMlSlurry / 1000;
        FAmount.vUnit := liter;
        FAmount.DisplayUnit := milliliter;
      end;
    end;
  end;
  if (FStarterMade.Value) then
  begin
    if (FStarterVolume1.Value > 0) then
    begin
      case FStarterType of
        stSimple: i := 0;
        stAerated: i := 1;
        stStirred: i := 2;
      end;
      Result := AmountCells(i, FStarterVolume1.Value, Result);
    end;
    if (FStarterVolume2.Value > 0) then
      Result := AmountCells(i, FStarterVolume2.Value, Result);
    if (FStarterVolume3.Value > 0) then
      Result := AmountCells(i, FStarterVolume3.Value, Result);
  end;
end;

{============================== MISC ==========================================}

constructor TMisc.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtMisc;
  FIngredientType := itMisc;

  FAmount.vUnit := kilogram;
  FAmount.DisplayUnit := gram;
  FAmount.Decimals := 2;

  FInventory.vUnit := kilogram;
  FInventory.DisplayUnit := gram;
  FInventory.Decimals := 2;

  FMiscType := mtSpice;
  FUse := muBoil;

  FTime := TBFloat.Create(self);
  FTime.vUnit := minuut;
  FTime.DisplayUnit := minuut;
  FTime.MinValue := 0.0;
  FTime.MaxValue := 1000000;
  FTime.Value := 0.0;
  FTime.Decimals := 0;
  FTime.NodeLabel := 'TIME';
  FTime.DisplayLabel := 'DISPLAY_TIME';

  FAmountIsWeight := TBBoolean.Create(self);
  FAmountIsWeight.Value := True;
  FAmountIsWeight.NodeLabel := 'AMOUNT_IS_WEIGHT';

  FUseFor := TBString.Create(self);
  FUseFor.Value := '';
  FUseFor.NodeLabel := 'USE_FOR';

  FFreeField := TBFloat.Create(self);
  FFreeField.vUnit := perc;
  FFreeField.DisplayUnit := perc;
  FFreeField.MinValue := -1000000;
  FFreeField.MaxValue := 1000000;
  FFreeField.Value := 0.0;
  FFreeField.Decimals := 3;
  FFreeField.NodeLabel := 'FREE_FIELD';
  FFreeField.DisplayLabel := '';

  FFreeFieldName := TBString.Create(self);
  FFreeFieldName.Value:= '';
  FFreeFieldName.NodeLabel:= 'FREE_FIELD_NAME';
end;

destructor TMisc.Destroy;
begin
  FTime.Free;
  FAmountIsWeight.Free;
  FUseFor.Free;
  FFreeField.Free;
  FFreeFieldName.Free;
  inherited;
end;

procedure TMisc.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FMiscType := TMisc(Source).MiscType;
    FUse := TMisc(Source).Use;
    FTime.Assign(TMisc(Source).Time);
    FAmountIsWeight.Assign(TMisc(Source).AmountIsWeight);
    FUseFor.Assign(TMisc(Source).UseFor);
    FFreeField.Assign(TMisc(Source).FreeField);
    FFreeFieldName.Assign(TMisc(Source).FreeFieldName);
  end;
end;

function TMisc.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
    5: Result := FMiscType; //MiscTypeDisplayNames[FMiscType];
    6: Result := FUse;//MiscUseDisplayNames[FUse];
    7: Result := FTime.Value;
    8: Result := FAmountIsWeight.Value;
    9: Result := FUseFor.Value;
    10: Result:= FFreeField.Value;
    11: Result:= FFreeFieldName.Value;
  end;
end;

function TMisc.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Type' then
    Result := 5
  else if s = 'Toegevoegd bij' then
    Result := 6
  else if s = 'Tijd' then
    Result := 7
  else if s = 'Aantal is gewicht' then
    Result := 8
  else if s = 'Gebruik' then
    Result := 9
  else if s = 'Vrij veld' then
    Result:= 10
  else if s = 'Vrij veld naam' then
    Result:= 11;
end;

function TMisc.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    5: Result := 'Type';
    6: Result := 'Toegevoegd bij';
    7: Result := 'Tijd';
    8: Result := 'Aantal is gewicht';
    9: Result := 'Gebruik';
    10: Result:= 'Vrij veld';
    11: Result:= 'Vrij veld naam';
  end;
end;

procedure TMisc.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('MISC');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  if bxml then
  begin
    if (TypeName = MiscTypeNames[mtWateragent]) or (TypeName = MiscTypeNames[mtNutrient]) then
      AddNode(Doc, iChild, 'TYPE', MiscTypeNames[mtOther])
    else
      AddNode(Doc, iChild, 'TYPE', TypeName);
    if UseName = MiscUseNames[muStarter] then
      AddNode(Doc, iChild, 'USE', MiscUseNames[muPrimary])
    else
      AddNode(Doc, iChild, 'USE', UseName);
  end
  else
  begin
    AddNode(Doc, iChild, 'TYPE', TypeName);
    AddNode(Doc, iChild, 'USE', UseName);
  end;
  FTime.SaveXML(Doc, iChild, bxml);
  FAmountIsWeight.SaveXML(Doc, iChild, bxml);
  FUseFor.SaveXML(Doc, iChild, bxml);
  FTime.SaveXMLDisplayValue(Doc, iChild);
  if not bxml then
  begin
    FFreeField.SaveXML(doc, iChild, bxml);
    FFreeFieldName.SaveXML(doc, iChild, bxml);
  end;
end;

procedure TMisc.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  TypeName := GetNodeString(iNode, 'TYPE');
  UseName := GetNodeString(iNode, 'USE');
  FTime.ReadXML(iNode);
  FAmountIsWeight.ReadXML(iNode);
  FUseFor.ReadXML(iNode);
  FFreeField.ReadXML(iNode);
  FFreeFieldName.ReadXML(iNode);
  if FAmountIsWeight.Value then
  begin
    FAmount.vUnit := kilogram;
    FAmount.DisplayUnit := gram;
  end
  else
  begin
    FAmount.vUnit := liter;
    FAmount.DisplayUnit := milliliter;
  end;
end;

Function TMisc.IsInstock : boolean;
var i : integer;
    M : TMisc;
begin
  Result:= TRUE;
  for i:= 0 to Miscs.NumItems - 1 do
  begin
    M:= TMisc(Miscs.FindByName(FName.Value));
    if M <> NIL then
    begin
      if M.Inventory.Value < FAmount.Value then Result:= false;
    end
    else Result:= false;
  end;

end;

function TMisc.GetTypeName: string;
begin
  Result := MiscTypeNames[FMiscType];
end;

procedure TMisc.SetTypeName(s: string);
var
  mt: TMiscType;
begin
  for mt := Low(MiscTypeNames) to High(MiscTypeNames) do
    if LowerCase(MiscTypeNames[mt]) = LowerCase(s) then
      FMiscType := mt;
end;

function TMisc.GetTypeDisplayName: string;
begin
  Result := MiscTypeDisplayNames[FMiscType];
end;

procedure TMisc.SetTypeDisplayName(s: string);
var
  mt: TMiscType;
begin
  for mt := Low(MiscTypeDisplayNames) to High(MiscTypeDisplayNames) do
    if LowerCase(MiscTypeDisplayNames[mt]) = LowerCase(s) then
      FMiscType := mt;
end;

function TMisc.GetUseName: string;
begin
  Result := MiscUseNames[FUse];
end;

procedure TMisc.SetUseName(s: string);
var
  mu: TMiscUse;
begin
  for mu := Low(MiscUseNames) to High(MiscUseNames) do
    if LowerCase(MiscUseNames[mu]) = LowerCase(s) then
      FUse := mu;
  case FUse of
    muStarter: FTime.DisplayUnit:= uur;
    muMash, muBoil: FTime.DisplayUnit:= minuut;
    muPrimary, muSecondary, muBottling: FTime.DisplayUnit:= dag;
  end;
end;

function TMisc.GetUseDisplayName: string;
begin
  Result := MiscUseDisplayNames[FUse];
end;

procedure TMisc.SetUseDisplayName(s: string);
var mu: TMiscUse;
begin
  for mu := Low(MiscUseDisplayNames) to High(MiscUseDisplayNames) do
    if LowerCase(MiscUseDisplayNames[mu]) = LowerCase(s) then
      FUse := mu;
  case FUse of
    muStarter: FTime.DisplayUnit:= uur;
    muMash, muBoil: FTime.DisplayUnit:= minuut;
    muPrimary, muSecondary, muBottling: FTime.DisplayUnit:= dag;
  end;
end;

procedure TMisc.SetAmountIsWeight(b: boolean);
begin
  FAmountIsWeight.Value := b;
  if b then
  begin
    FAmount.vUnit := kilogram;
    FAmount.DisplayUnit := gram;
    FAmount.Decimals := 1;
  end
  else
  begin
    FAmount.vUnit := liter;
    FAmount.DisplayUnit := milliliter;
    FAmount.Decimals := 0;
  end;
end;

{======================== Water ===============================================}

constructor TWater.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtWater;
  FIngredientType := itWater;

  FAmount.vUnit := liter;
  FAmount.DisplayUnit := liter;
  FAmount.Decimals := 2;

  FInventory.vUnit := liter;
  FInventory.DisplayUnit := liter;
  FInventory.Decimals := 3;

  FCalcium := TBFloat.Create(self);
  FCalcium.vUnit := ppm;
  FCalcium.DisplayUnit := ppm;
  FCalcium.MinValue := 0.0;
  FCalcium.MaxValue := 10000;
  FCalcium.Value := 0.0;
  FCalcium.Decimals := 0;
  FCalcium.NodeLabel := 'CALCIUM';
  FCalcium.DisplayLabel := '';

  FBicarbonate := TBFloat.Create(self);
  FBicarbonate.vUnit := ppm;
  FBicarbonate.DisplayUnit := ppm;
  FBicarbonate.MinValue := 0.0;
  FBicarbonate.MaxValue := 10000;
  FBicarbonate.Value := 0.0;
  FBicarbonate.Decimals := 0;
  FBicarbonate.NodeLabel := 'BICARBONATE';
  FBicarbonate.DisplayLabel := '';

  FSulfate := TBFloat.Create(self);
  FSulfate.vUnit := ppm;
  FSulfate.DisplayUnit := ppm;
  FSulfate.MinValue := 0.0;
  FSulfate.MaxValue := 10000;
  FSulfate.Value:= 0;
  FSulfate.Decimals:= 0;
  FSulfate.NodeLabel := 'SULFATE';
  FSulfate.DisplayLabel := '';

  FChloride := TBFloat.Create(self);
  FChloride.vUnit := ppm;
  FChloride.DisplayUnit := ppm;
  FChloride.MinValue := 0.0;
  FChloride.MaxValue := 10000;
  FChloride.Value := 0.0;
  FChloride.Decimals := 0;
  FChloride.NodeLabel := 'CHLORIDE';
  FChloride.DisplayLabel := '';

  FSodium := TBFloat.Create(self);
  FSodium.vUnit := ppm;
  FSodium.DisplayUnit := ppm;
  FSodium.MinValue := 0.0;
  FSodium.MaxValue := 10000;
  FSodium.Value := 0.0;
  FSodium.Decimals := 0;
  FSodium.NodeLabel := 'SODIUM';
  FSodium.DisplayLabel := '';

  FMagnesium := TBFloat.Create(self);
  FMagnesium.vUnit := ppm;
  FMagnesium.DisplayUnit := ppm;
  FMagnesium.MinValue := 0.0;
  FMagnesium.MaxValue := 10000;
  FMagnesium.Value := 0.0;
  FMagnesium.Decimals := 0;
  FMagnesium.NodeLabel := 'MAGNESIUM';
  FMagnesium.DisplayLabel := '';

  FpH := TBFloat.Create(self);
  FpH.vUnit := pH;
  FpH.DisplayUnit := pH;
  FpH.MinValue := 0.0;
  FpH.MaxValue := 14;
  FpH.Value := 0.0;
  FpH.Decimals := 1;
  FpH.NodeLabel := 'PH';
  FpH.DisplayLabel := '';

  FTotalAlkalinity:= TBFloat.Create(self);
  FTotalAlkalinity.vUnit:= ppm;
  FTotalAlkalinity.DisplayUnit:= ppm;
  FTotalAlkalinity.MinValue:= 0;
  FTotalAlkalinity.MaxValue:= 1000;
  FTotalAlkalinity.Value:= 0.0;
  FTotalAlkalinity.Decimals:= 0;
  FTotalAlkalinity.NodeLabel:= 'TOTAL_ALKALINITY';
  FTotalAlkalinity.DisplayLabel:= '';

  FDefault:= TBBoolean.Create(self);
  FDefault.Value:= false;
  FDefault.NodeLabel:= 'DEFAULT_WATER';

  FDilutionFactor := TBFloat.Create(self);
  FDilutionFactor.vUnit := perc;
  FDilutionFactor.DisplayUnit := perc;
  FDilutionFactor.MinValue := 0.0;
  FDilutionFactor.MaxValue := 100;
  FDilutionFactor.Value := 0.0;
  FDilutionFactor.Decimals := 2;
  FDilutionFactor.NodeLabel := 'DILUTION_FACTOR';
  FDilutionFactor.DisplayLabel := '';

  FCaSO4 := TBFloat.Create(self);
  FCaSO4.vUnit := kilogram;
  FCaSO4.DisplayUnit := gram;
  FCaSO4.MinValue := 0.0;
  FCaSO4.MaxValue := 100;
  FCaSO4.Value := 0.0;
  FCaSO4.Decimals := 2;
  FCaSO4.NodeLabel := 'CASO4';
  FCaSO4.DisplayLabel := '';

  FCaCl2 := TBFloat.Create(self);
  FCaCl2.vUnit := kilogram;
  FCaCl2.DisplayUnit := gram;
  FCaCl2.MinValue := 0.0;
  FCaCl2.MaxValue := 1000;
  FCaCl2.Value := 0.0;
  FCaCl2.Decimals := 2;
  FCaCl2.NodeLabel := 'CACL2';
  FCaCl2.DisplayLabel := '';

  FCaCO3 := TBFloat.Create(self);
  FCaCO3.vUnit := kilogram;
  FCaCO3.DisplayUnit := gram;
  FCaCO3.MinValue := 0.0;
  FCaCO3.MaxValue := 1000;
  FCaCO3.Value := 0.0;
  FCaCO3.Decimals := 2;
  FCaCO3.NodeLabel := 'CACO3';
  FCaCO3.DisplayLabel := '';

  FMgSO4 := TBFloat.Create(self);
  FMgSO4.vUnit := kilogram;
  FMgSO4.DisplayUnit := gram;
  FMgSO4.MinValue := 0.0;
  FMgSO4.MaxValue := 1000;
  FMgSO4.Value := 0.0;
  FMgSO4.Decimals := 2;
  FMgSO4.NodeLabel := 'MGSO4';
  FMgSO4.DisplayLabel := '';

  FNaHCO3 := TBFloat.Create(self);
  FNaHCO3.vUnit := kilogram;
  FNaHCO3.DisplayUnit := gram;
  FNaHCO3.MinValue := 0.0;
  FNaHCO3.MaxValue := 1000;
  FNaHCO3.Value := 0.0;
  FNaHCO3.Decimals := 2;
  FNaHCO3.NodeLabel := 'NAHCO3';
  FNaHCO3.DisplayLabel := '';

  FNaCl := TBFloat.Create(self);
  FNaCl.vUnit := kilogram;
  FNaCl.DisplayUnit := gram;
  FNaCl.MinValue := 0.0;
  FNaCl.MaxValue := 1000;
  FNaCl.Value := 0.0;
  FNaCl.Decimals := 2;
  FNaCl.NodeLabel := 'NACL';
  FNaCl.DisplayLabel := '';

  FHCl := TBFloat.Create(self);
  FHCl.vUnit := kilogram;
  FHCl.DisplayUnit := gram;
  FHCl.MinValue := 0.0;
  FHCl.MaxValue := 1000;
  FHCl.Value := 0.0;
  FHCl.Decimals := 2;
  FHCl.NodeLabel := 'HCL';
  FHCl.DisplayLabel := '';

  FH3PO4 := TBFloat.Create(self);
  FH3PO4.vUnit := kilogram;
  FH3PO4.DisplayUnit := gram;
  FH3PO4.MinValue := 0.0;
  FH3PO4.MaxValue := 1000;
  FH3PO4.Value := 0.0;
  FH3PO4.Decimals := 2;
  FH3PO4.NodeLabel := 'H3PO4';
  FH3PO4.DisplayLabel := '';

  FLacticAcid := TBFloat.Create(self);
  FLacticAcid.vUnit := kilogram;
  FLacticAcid.DisplayUnit := gram;
  FLacticAcid.MinValue := 0.0;
  FLacticAcid.MaxValue := 1000;
  FLacticAcid.Value := 0.0;
  FLacticAcid.Decimals := 2;
  FLacticAcid.NodeLabel := 'LACTIC_ACID';
  FLacticAcid.DisplayLabel := '';

  FMHCl := TBFloat.Create(self);
  FMHCl.vUnit := perc;
  FMHCl.DisplayUnit := perc;
  FMHCl.MinValue := 0.0;
  FMHCl.MaxValue := 1000;
  FMHCl.Value := 0.0;
  FMHCl.Decimals := 1;
  FMHCl.NodeLabel := 'MHCL';
  FMHCl.DisplayLabel := '';

  FMH3PO4 := TBFloat.Create(self);
  FMH3PO4.vUnit := perc;
  FMH3PO4.DisplayUnit := perc;
  FMH3PO4.MinValue := 0.0;
  FMH3PO4.MaxValue := 1000;
  FMH3PO4.Value := 0.0;
  FMH3PO4.Decimals := 1;
  FMH3PO4.NodeLabel := 'MH3PO4';
  FMH3PO4.DisplayLabel := '';

  FMLacticAcid := TBFloat.Create(self);
  FMLacticAcid.vUnit := perc;
  FMLacticAcid.DisplayUnit := perc;
  FMLacticAcid.MinValue := 0.0;
  FMLacticAcid.MaxValue := 1000;
  FMLacticAcid.Value := 0.0;
  FMLacticAcid.Decimals := 1;
  FMLacticAcid.NodeLabel := 'MLACTIC_ACID';
  FMLacticAcid.DisplayLabel := '';

  FDemiWater:= false;
end;

destructor TWater.Destroy;
begin
  FCalcium.Free;
  FBicarbonate.Free;
  FSulfate.Free;
  FChloride.Free;
  FSodium.Free;
  FMagnesium.Free;
  FpH.Free;
  FTotalAlkalinity.Free;
  FDilutionFactor.Free;
  FCaSO4.Free;
  FCaCl2.Free;
  FCaCO3.Free;
  FMgSO4.Free;
  FNaHCO3.Free;
  FNaCl.Free;
  FHCl.Free;
  FH3PO4.Free;
  FLacticAcid.Free;
  FMHCl.Free;
  FMH3PO4.Free;
  FMLacticAcid.Free;
  FDefault.Free;
  inherited;
end;

procedure TWater.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FCalcium.Assign(TWater(Source).Calcium);
    FBicarbonate.Assign(TWater(Source).Bicarbonate);
    FSulfate.Assign(TWater(Source).Sulfate);
    FChloride.Assign(TWater(Source).Chloride);
    FSodium.Assign(TWater(Source).Sodium);
    FMagnesium.Assign(TWater(Source).Magnesium);
    FpH.Assign(TWater(Source).pHwater);
    FTotalAlkalinity.Assign(TWater(Source).TotalAlkalinity);
    FDefault.Assign(TWater(Source).DefaultWater);
  {  FDilutionFactor.Assign(TWater(Source).pHwater);
    FCaSO4.Assign(TWater(Source).CaSO4);
    FCaCl2.Assign(TWater(Source).CaCl2);
    FCaCO3.Assign(TWater(Source).CaCO3);
    FMgSO4.Assign(TWater(Source).MgSO4);
    FNaHCO3.Assign(TWater(Source).NaHCO3);
    FNaCl.Assign(TWater(Source).NaCl);
    FHCl.Assign(TWater(Source).HCl);
    FH3PO4.Assign(TWater(Source).H3PO4);
    FLacticAcid.Assign(TWater(Source).LacticAcid);
    FMHCl.Assign(TWater(Source).MHCl);
    FMH3PO4.Assign(TWater(Source).MH3PO4);
    FMLacticAcid.Assign(TWater(Source).MLacticAcid); }
  end;
end;

function TWater.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FAmount.Value;
    3: Result := FInventory.Value;
    4: Result := FCost.Value;
    5: Result := FCalcium.Value;
    6: Result := FBicarbonate.Value;
    7: Result := FSulfate.Value;
    8: Result := FChloride.Value;
    9: Result := FSodium.Value;
    10: Result := FMagnesium.Value;
    11: Result := FpH.Value;
    12: Result:= FTotalAlkalinity.Value;
    13: Result:= FDefault.Value;
{  12: Result:= FDilutionFactor.Value;
  13: Result:= FCaSO4.Value;
  14: Result:= FCaCl2.Value;
  15: Result:= FCaCO3.Value;
  16: Result:= FMgSO4.Value;
  17: Result:= FNaHCO3.Value;
  18: Result:= FNaCl.Value;
  19: Result:= FHCl.Value;
  20: Result:= FH3PO4.Value;
  21: Result:= FLacticAcid.Value;
  22: Result:= FMHCl.Value;
  23: Result:= FMH3PO4.Value;
  24: Result:= FMLacticAcid.Value;}
  end;
end;

function TWater.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Calcium' then
    Result := 5
  else if s = 'Bicarbonaat' then
    Result := 6
  else if s = 'Sulfaat' then
    Result := 7
  else if s = 'Chloride' then
    Result := 8
  else if s = 'Natrium' then
    Result := 9
  else if s = 'Magnesium' then
    Result := 10
  else if s = 'pH' then
    Result := 11
  else if s = 'Alkaliniteit' then
    Result:= 12
  else if s = 'Standaard water' then
    Result:= 13
 { else if s = 'Verdunfactor' then Result:= 12
  else if s = 'Gips' then Result:= 13
  else if s = 'Calciumchloride' then Result:= 14
  else if s = 'Kalk' then Result:= 15
  else if s = 'Epsom zout' then Result:= 16
  else if s = 'Soda' then Result:= 17
  else if s = 'Keukenzout' then Result:= 18
  else if s = 'Zoutzuur' then Result:= 19
  else if s = 'Fosforzuur' then Result:= 20
  else if s = 'Melkzuur' then Result:= 21
  else if s = '%w/w zoutzuur' then Result:= 22
  else if s = '%w/w fosforzuur' then Result:= 23
  else if s = '%w/w melkzuur' then Result:= 24};
end;

function TWater.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    5: Result := 'Calcium';
    6: Result := 'Bicarbonaat';
    7: Result := 'Sulfaat';
    8: Result := 'Chloride';
    9: Result := 'Natrium';
    10: Result := 'Magnesium';
    11: Result := 'pH';
    12: Result:= 'Alkaliniteit';
    13: Result:= 'Standaard water';
{  12: Result:= 'Verdunfactor';
  13: Result:= 'Gips';
  14: Result:= 'Calciumchloride';
  15: Result:= 'Kalk';
  16: Result:= 'Epsom zout';
  17: Result:= 'Soda';
  18: Result:= 'Keukenzout';
  19: Result:= 'Zoutzuur';
  20: Result:= 'Fosforzuur';
  21: Result:= 'Melkzuur';
  22: Result:= '%w/w zoutzuur';
  23: Result:= '%w/w fosforzuur';
  24: Result:= '%w/w melkzuur';}
  end;
end;

procedure TWater.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('WATER');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  FCalcium.SaveXML(Doc, iChild, bxml);
  FBicarbonate.SaveXML(Doc, iChild, bxml);
  FSulfate.SaveXML(Doc, iChild, bxml);
  FChloride.SaveXML(Doc, iChild, bxml);
  FSodium.SaveXML(Doc, iChild, bxml);
  FMagnesium.SaveXML(Doc, iChild, bxml);
  FpH.SaveXML(Doc, iChild, bxml);
  if not bxml then
  begin
    FTotalAlkalinity.SaveXML(Doc, iChild, bxml);
    FDefault.SaveXML(doc, iChild, bxml);
  {  FDilutionFactor.SaveXML(Doc, iChild);
    FCaSO4.SaveXML(Doc, iChild);
    FCaCl2.SaveXML(Doc, iChild);
    FCaCO3.SaveXML(Doc, iChild);
    FMgSO4.SaveXML(Doc, iChild);
    FNaHCO3.SaveXML(Doc, iChild);
    FNaCl.SaveXML(Doc, iChild);
    FHCl.SaveXML(Doc, iChild);
    FH3PO4.SaveXML(Doc, iChild);
    FLacticAcid.SaveXML(Doc, iChild);
    FMHCl.SaveXML(Doc, iChild);
    FMH3PO4.SaveXML(Doc, iChild);
    FMLacticAcid.SaveXML(Doc, iChild);}
  end;
end;

procedure TWater.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  FCalcium.ReadXML(iNode);
  FBicarbonate.ReadXML(iNode);
  FSulfate.ReadXML(iNode);
  FChloride.ReadXML(iNode);
  FSodium.ReadXML(iNode);
  FMagnesium.ReadXML(iNode);
  FpH.ReadXML(iNode);
  FTotalAlkalinity.ReadXML(iNode);
  FDefault.ReadXML(iNode);
  if FTotalAlkalinity.Value = 0 then
    FTotalAlkalinity.Value:= FBicarbonate.Value * 50 / 61;
  if FBicarbonate.Value = 0 then
    FBicarbonate.Value:= FTotalAlkalinity.Value * 61 / 50;
  FDilutionFactor.ReadXML(iNode);
  FCaSO4.ReadXML(iNode);
  FCaCl2.ReadXML(iNode);
  FCaCO3.ReadXML(iNode);
  FMgSO4.ReadXML(iNode);
  FNaHCO3.ReadXML(iNode);
  FNaCl.ReadXML(iNode);
  FHCl.ReadXML(iNode);
  FH3PO4.ReadXML(iNode);
  FLacticAcid.ReadXML(iNode);
  FMHCl.ReadXML(iNode);
  FMH3PO4.ReadXML(iNode);
  FMLacticAcid.ReadXML(iNode);
  if (FCalcium.Value <= 5.01) and (FBicarbonate.Value <= 12.01) and (FSulfate.Value <= 5.01)
  and (FChloride.Value <= 6.01) and (FSodium.Value <= 5.01) and (FMagnesium.Value <= 2.01)
  and (FpH.Value >= 6.499) and (FpH.Value <= 7.501) then FDemiWater:= TRUE;
end;

Procedure TWater.AddMinerals(Ca, Mg, Na, HCO3, Cl, SO4 : double);
begin
  FCalcium.Add(Ca);
  FMagnesium.Add(Mg);
  FSodium.Add(Na);
  FBicarbonate.Add(HCO3);
  FChloride.Add(Cl);
  FSulfate.Add(SO4);
end;

function TWater.GetResidualAlkalinity: double;
begin
  //Result in mg/l as CaCO3
  Result:= FTotalAlkalinity.Value - (FCalcium.Value / 1.4 + FMagnesium.Value / 1.7);
end;

const
  Ka1 = 0.0000004445;
  Ka2 = 0.0000000000468;

Function PartCO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * Ka1 * Ka2 / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function PartHCO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * Ka1 * H / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function PartH2CO3(pH : double) : double;
var H : double;
begin
  H:= Power(10, -pH);
  Result:= 100 * H * H / (H*H + H * Ka1 + Ka1 * Ka2);
end;

Function Charge(pH : double) : double;
begin
  Result:= (-2 * PartCO3(pH) - PartHCO3(pH));
end;

//Z alkalinity is the amount of acid (in mEq/l) needed to bring water to the target pH (Z pH)
Function TWater.ZAlkalinity(pHZ : double) : double;  //in mEq/l
var CT, DeltaCNaught, DeltaCZ, C43, Cw, Cz : double;
begin
  C43:= Charge(4.3);
  Cw:= Charge(FpH.Value);
  Cz:= Charge(pHz);
  DeltaCNaught:= -C43+Cw;
  CT:= GetAlkalinity / 50 / DeltaCNaught;
  DeltaCZ:= -Cz+Cw;
  Result:= CT * DeltaCZ;
end;

//Z Residual alkalinity is the amount of acid (in mEq/l) needed to bring the water in the mash to the target pH (Z pH)
Function TWater.ZRA(pHZ : double) : double; //in mEq/l
var Calc, Magn, Z : double;
begin
  Calc:= FCalcium.Value / (MMCa / 2);
  Magn:= FMagnesium.Value / (MMMg / 2);
  Z:= ZAlkalinity(pHZ);
  Result:= Z - (Calc / 3.5 + Magn / 7);
end;

Function TWater.ProtonDeficit(pHZ : double) : double;
var i : integer;
    F : TFermentable;
    x : double;
begin
  Result:= ZRA(pHZ) * FAmount.Value;
  //proton deficit for the added malts
  for i:= 0 to FRecipe.NumFermentables - 1 do
  begin
    F:= FRecipe.Fermentable[i];
    if (F.AddedType = atMash) and (F.GrainType <> gtNone) then
    begin
      x:= F.AcidRequired(pHZ) * F.Amount.Value;
      Result:= Result + x;
    end;
  end;
end;

Function TWater.MashpH : double;
var n : integer;
    pd : double;
    pH, deltapH, deltapd : double;
begin
  Result:= 0;
  n:= 0;
  pH:= 5.4;
  deltapH:= 0.001;
  deltapd:= 0.1;
  pd:= ProtonDeficit(pH);
  while ((pd < -deltapd) or (pd > deltapd)) and (n < 1000) do
  begin
    inc(n);
    if pd < -deltapd then ph:= ph - deltapH
    else if pd > deltapd then pH:= pH + deltapH;
    pd:= ProtonDeficit(pH);
  end;
  Result:= pH;
end;

Function TWater.MashpH2(PrDef : double) : double;
var n : integer;
    pd : double;
    pH, deltapH, deltapd : double;
begin
  Result:= 0;
  n:= 0;
  pH:= 5.4;
  deltapH:= 0.001;
  deltapd:= 0.1;
  pd:= ProtonDeficit(pH);
  while ((pd < PrDef-deltapd) or (pd > PrDef + deltapd)) and (n < 1000) do
  begin
    inc(n);
    if pd < PrDef-deltapd then ph:= ph - deltapH
    else if pd > PrDef+deltapd then pH:= pH + deltapH;
    pd:= ProtonDeficit(pH);
  end;
  Result:= pH;
end;

function TWater.GetAlkalinity: double;
begin
  Result := FBicarbonate.Value / 1.22; //mEq/l
end;

function TWater.GetHardness: double;
begin
  Result := 0.14 * FCalcium.Value - 0.23 * FMagnesium.Value;
end;

function TWater.GetEstPhMash: double;
{var
  pHdemi, S: double;}
begin
  Result:= MashpH;
{  Result := 0;
  if FRecipe <> nil then
  begin
    pHDemi := FRecipe.pHdemi;
    S := 0.013 * FRecipe.MashThickness + 0.013;
    Result := pHDemi + ResidualAlkalinity / 50 * S;
  end;}
end;

{========================= Equipment ==========================================}

constructor TEquipment.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtEquipment;

  FBoilSize := TBFloat.Create(NIL);
  FBoilSize.vUnit := liter;
  FBoilSize.DisplayUnit := liter;
  FBoilSize.MinValue := 0.0;
  FBoilSize.MaxValue := 10000000;
  FBoilSize.Value := 0.0;
  FBoilSize.Decimals := 1;
  FBoilSize.NodeLabel := 'BOIL_SIZE';
  FBoilSize.DisplayLabel := 'DISPLAY_BOIL_SIZE';

  FBatchSize := TBFloat.Create(NIL);
  FBatchSize.vUnit := liter;
  FBatchSize.DisplayUnit := liter;
  FBatchSize.MinValue := 0.0;
  FBatchSize.MaxValue := 10000000;
  FBatchSize.Value := 0.0;
  FBatchSize.Decimals := 1;
  FBatchSize.NodeLabel := 'BATCH_SIZE';
  FBatchSize.DisplayLabel := 'DISPLAY_BATCH_SIZE';

  FTunVolume := TBFloat.Create(NIL);
  FTunVolume.vUnit := liter;
  FTunVolume.DisplayUnit := liter;
  FTunVolume.MinValue := 0.0;
  FTunVolume.MaxValue := 100000000;
  FTunVolume.Value := 0.0;
  FTunVolume.Decimals := 1;
  FTunVolume.NodeLabel := 'TUN_VOLUME';
  FTunVolume.DisplayLabel := 'DISPLAY_TUN_VOLUME';

  FTunWeight := TBFloat.Create(NIL);
  FTunWeight.vUnit := kilogram;
  FTunWeight.DisplayUnit := kilogram;
  FTunWeight.MinValue := 0.0;
  FTunWeight.MaxValue := 1000;
  FTunWeight.Value := 0.0;
  FTunWeight.Decimals := 2;
  FTunWeight.NodeLabel := 'TUN_WEIGHT';
  FTunWeight.DisplayLabel := 'DISPLAY_TUN_WEIGHT';

  FTunSpecificHeat := TBFloat.Create(NIL);  //0.2 Cal/gram-deg C
  FTunSpecificHeat.vUnit := calgdeg;
  FTunSpecificHeat.DisplayUnit := calgdeg;
  FTunSpecificHeat.MinValue := 0.0;
  FTunSpecificHeat.MaxValue := 10;
  FTunSpecificHeat.Value := 0.0;
  FTunSpecificHeat.Decimals := 2;
  FTunSpecificHeat.NodeLabel := 'TUN_SPECIFIC_HEAT';
  FTunSpecificHeat.DisplayLabel := '';

  FTopUpWater := TBFloat.Create(NIL);
  FTopUpWater.vUnit := liter;
  FTopUpWater.DisplayUnit := liter;
  FTopUpWater.MinValue := 0.0;
  FTopUpWater.MaxValue := 1000000;
  FTopUpWater.Value := 0.0;
  FTopUpWater.Decimals := 1;
  FTopUpWater.NodeLabel := 'TOP_UP_WATER';
  FTopUpWater.DisplayLabel := 'DISPLAY_TOP_UP_WATER';

  FTrubChillerLoss := TBFloat.Create(NIL);
  FTrubChillerLoss.vUnit := liter;
  FTrubChillerLoss.DisplayUnit := liter;
  FTrubChillerLoss.MinValue := 0.0;
  FTrubChillerLoss.MaxValue := 1000000;
  FTrubChillerLoss.Value := 0.0;
  FTrubChillerLoss.Decimals := 1;
  FTrubChillerLoss.NodeLabel := 'TRUB_CHILLER_LOSS';
  FTrubChillerLoss.DisplayLabel := 'DISPLAY_TRUB_CHILLER_LOSS';

  FEvapRate := TBFloat.Create(NIL);
  FEvapRate.vUnit := pph;
  FEvapRate.DisplayUnit := pph;
  FEvapRate.MinValue := 0.0;
  FEvapRate.MaxValue := 100;
  FEvapRate.Value := 0.0;
  FEvapRate.Decimals := 1;
  FEvapRate.NodeLabel := 'EVAP_RATE';
  FEvapRate.DisplayLabel := '';

  FBoilTime := TBFloat.Create(NIL);
  FBoilTime.vUnit := minuut;
  FBoilTime.DisplayUnit := minuut;
  FBoilTime.MinValue := 0.0;
  FBoilTime.MaxValue := 300;
  FBoilTime.Value := 0.0;
  FBoilTime.Decimals := 0;
  FBoilTime.NodeLabel := 'BOIL_TIME';
  FBoilTime.DisplayLabel := '';

  FCalcBoilVolume := TBBoolean.Create(self);
  FCalcBoilVolume.Value := True;
  FCalcBoilVolume.NodeLabel := 'CALC_BOIL_VOLUME';

  FLauterDeadSpace := TBFloat.Create(self);
  FLauterDeadSpace.vUnit := liter;
  FLauterDeadSpace.DisplayUnit := liter;
  FLauterDeadSpace.MinValue := 0.0;
  FLauterDeadSpace.MaxValue := 1000000;
  FLauterDeadSpace.Value := 0.0;
  FLauterDeadSpace.Decimals := 1;
  FLauterDeadSpace.NodeLabel := 'LAUTER_DEADSPACE';
  FLauterDeadSpace.DisplayLabel := 'DISPLAY_LAUTERDEADSPACE';

  FTopUpKettle := TBFloat.Create(self);
  FTopUpKettle.vUnit := perc;
  FTopUpKettle.DisplayUnit := perc;
  FTopUpKettle.MinValue := 0.0;
  FTopUpKettle.MaxValue := 100000;
  FTopUpKettle.Value := 0.0;
  FTopUpKettle.Decimals := 1;
  FTopUpKettle.NodeLabel := 'TOP_UP_KETTLE';
  FTopUpKettle.DisplayLabel := 'DISPLAY_TOP_UP_KETTLE';

  FHopUtilization := TBFloat.Create(self);
  FHopUtilization.vUnit := perc;
  FHopUtilization.DisplayUnit := perc;
  FHopUtilization.MinValue := 100;
  FHopUtilization.MaxValue := 300;
  FHopUtilization.Value := 0.0;
  FHopUtilization.Decimals := 0;
  FHopUtilization.NodeLabel := 'HOP_UTILIZATION';
  FHopUtilization.DisplayLabel := '';

  //BrewBuddyXML
  FTopUpWaterBrewDay := TBFloat.Create(NIL);
  FTopUpWaterBrewDay.vUnit := liter;
  FTopUpWaterBrewDay.DisplayUnit := liter;
  FTopUpWaterBrewDay.MinValue := 0.0;
  FTopUpWaterBrewDay.MaxValue := 1000000;
  FTopUpWaterBrewDay.Value := 0.0;
  FTopUpWaterBrewDay.Decimals := 1;
  FTopUpWaterBrewDay.NodeLabel := 'TOP_UP_WATER_BREWDAY';
  FTopUpWaterBrewDay.DisplayLabel := '';

  FLauterVolume := TBFloat.Create(self);
  FLauterVolume.vUnit := liter;
  FLauterVolume.DisplayUnit := liter;
  FLauterVolume.MinValue := 0;
  FLauterVolume.MaxValue := 100000;
  FLauterVolume.Value := 0.0;
  FLauterVolume.Decimals := 1;
  FLauterVolume.NodeLabel := 'LAUTER_VOLUME';
  FLauterVolume.DisplayLabel := '';

  FKettleVolume := TBFloat.Create(self);
  FKettleVolume.vUnit := liter;
  FKettleVolume.DisplayUnit := liter;
  FKettleVolume.MinValue := 0;
  FKettleVolume.MaxValue := 100000;
  FKettleVolume.Value := 0.0;
  FKettleVolume.Decimals := 1;
  FKettleVolume.NodeLabel := 'KETTLE_VOLUME';
  FKettleVolume.DisplayLabel := '';

  FTunMaterial := TBString.Create(self);
  FTunMaterial.Value := 'RVS';
  FTunMaterial.NodeLabel := 'TUN_MATERIAL';

  FTunHeight := TBFloat.Create(self);
  FTunHeight.vUnit := meter;
  FTunHeight.DisplayUnit := centimeter;
  FTunHeight.MinValue := 0.01;
  FTunHeight.MaxValue := 100;
  FTunHeight.Value := 0.01;
  FTunHeight.Decimals := 1;
  FTunHeight.NodeLabel := 'TUN_HEIGHT';
  FTunHeight.DisplayLabel := '';

  FKettleHeight := TBFloat.Create(self);
  FKettleHeight.vUnit := meter;
  FKettleHeight.DisplayUnit := centimeter;
  FKettleHeight.MinValue := 0.01;
  FKettleHeight.MaxValue := 100;
  FKettleHeight.Value := 0.01;
  FKettleHeight.Decimals := 1;
  FKettleHeight.NodeLabel := 'KETTLE_HEIGHT';
  FKettleHeight.DisplayLabel := '';

  FLauterHeight := TBFloat.Create(self);
  FLauterHeight.vUnit := meter;
  FLauterHeight.DisplayUnit := centimeter;
  FLauterHeight.MinValue := 0.01;
  FLauterHeight.MaxValue := 100;
  FLauterHeight.Value := 0.01;
  FLauterHeight.Decimals := 1;
  FLauterHeight.NodeLabel := 'LAUTER_HEIGHT';
  FLauterHeight.DisplayLabel := '';

  FMashVolume := TBFloat.Create(self);
  FMashVolume.vUnit := liter;
  FMashVolume.DisplayUnit := liter;
  FMashVolume.MinValue := 1;
  FMashVolume.MaxValue := 1000000;
  FMashVolume.Value := 20;
  FMashVolume.Decimals := 1;
  FMashVolume.NodeLabel := 'MASH_VOLUME';
  FMashVolume.DisplayLabel := '';

  FEfficiency := TBFloat.Create(self);
  FEfficiency.vUnit := perc;
  FEfficiency.DisplayUnit := perc;
  FEfficiency.MinValue := 10;
  FEfficiency.MaxValue := 100;
  FEfficiency.Value := 75;
  FEfficiency.Decimals := 1;
  FEfficiency.NodeLabel := 'EFFICIENCY';
  FEfficiency.DisplayLabel := '';

  FEffFactBD := TBFloat.Create(self);
  FEffFactBD.vUnit := none;
  FEffFactBD.DisplayUnit := none;
  FEffFactBD.MinValue := -1000;
  FEffFactBD.MaxValue := 1000;
  FEffFactBD.Value := 0;
  FEffFactBD.Decimals := 2;
  FEffFactBD.NodeLabel := 'EFFICIENCY_FACTOR_BESLAGDIKTE';
  FEffFactBD.DisplayLabel := '';

  FEffFactSG := TBFloat.Create(self);
  FEffFactSG.vUnit := none;
  FEffFactSG.DisplayUnit := none;
  FEffFactSG.MinValue := -1000;
  FEffFactSG.MaxValue := 1000;
  FEffFactSG.Value := 0;
  FEffFactSG.Decimals := 2;
  FEffFactSG.NodeLabel := 'EFFICIENCY_FACTOR_OG';
  FEffFactSG.DisplayLabel := '';

  FEffFactC := TBFloat.Create(self);
  FEffFactC.vUnit := none;
  FEffFactC.DisplayUnit := none;
  FEffFactC.MinValue := -1000;
  FEffFactC.MaxValue := 1000;
  FEffFactC.Value := 0;
  FEffFactC.Decimals := 2;
  FEffFactC.NodeLabel := 'EFFICIENCY_FACTOR_CONSTANTE';
  FEffFactC.DisplayLabel := '';

  FAttFactAttY := TBFloat.Create(self);
  FAttFactAttY.vUnit := none;
  FAttFactAttY.DisplayUnit := none;
  FAttFactAttY.MinValue := -1;
  FAttFactAttY.MaxValue := 1;
  FAttFactAttY.Value := 0.00825;
  FAttFactAttY.Decimals := 5;
  FAttFactAttY.NodeLabel := 'ATTENUATION_FACTOR_YEAST';
  FAttFactAttY.DisplayLabel := '';

  FAttFactBD := TBFloat.Create(self);
  FAttFactBD.vUnit := none;
  FAttFactBD.DisplayUnit := none;
  FAttFactBD.MinValue := -1;
  FAttFactBD.MaxValue := 1;
  FAttFactBD.Value := 0.00817;
  FAttFactBD.Decimals := 5;
  FAttFactBD.NodeLabel := 'ATTENUATION_FACTOR_WATER_TO_GRAIN_RATIO';
  FAttFactBD.DisplayLabel := '';

  FAttFactTemp := TBFloat.Create(self);
  FAttFactTemp.vUnit := none;
  FAttFactTemp.DisplayUnit := none;
  FAttFactTemp.MinValue := -1;
  FAttFactTemp.MaxValue := 1;
  FAttFactTemp.Value := -0.00684;
  FAttFactTemp.Decimals := 5;
  FAttFactTemp.NodeLabel := 'ATTENUATION_FACTOR_MASH_TEMPERATURE';
  FAttFactTemp.DisplayLabel := '';

  FAttFactTTime := TBFloat.Create(self);
  FAttFactTTime.vUnit := none;
  FAttFactTTime.DisplayUnit := none;
  FAttFactTTime.MinValue := -1;
  FAttFactTTime.MaxValue := 1;
  FAttFactTTime.Value := 0.00026;
  FAttFactTTime.Decimals := 5;
  FAttFactTTime.NodeLabel := 'ATTENUATION_FACTOR_TOTAL_MASH_TIME';
  FAttFactTTime.DisplayLabel := '';

  FAttFactPercCara := TBFloat.Create(self);
  FAttFactPercCara.vUnit := none;
  FAttFactPercCara.DisplayUnit := none;
  FAttFactPercCara.MinValue := -1;
  FAttFactPercCara.MaxValue := 1;
  FAttFactPercCara.Value := -0.00356;
  FAttFactPercCara.Decimals := 5;
  FAttFactPercCara.NodeLabel := 'ATTENUATION_FACTOR_PERC_CRYSTAL';
  FAttFactPercCara.DisplayLabel := '';

  FAttFactPercS := TBFloat.Create(self);
  FAttFactPercS.vUnit := none;
  FAttFactPercS.DisplayUnit := none;
  FAttFactPercS.MinValue := -1;
  FAttFactPercS.MaxValue := 1;
  FAttFactPercS.Value := 0.00553;
  FAttFactPercS.Decimals := 5;
  FAttFactPercS.NodeLabel := 'ATTENUATION_FACTOR_PERC_SIMPLE_SUGAR';
  FAttFactPercS.DisplayLabel := '';

  FAttFactC := TBFloat.Create(self);
  FAttFactC.vUnit := none;
  FAttFactC.DisplayUnit := none;
  FAttFactC.MinValue := -1;
  FAttFactC.MaxValue := 1;
  FAttFactC.Value := 0.547;
  FAttFactC.Decimals := 5;
  FAttFactC.NodeLabel := 'ATTENUATION_FACTOR_CONSTANT';
  FAttFactC.DisplayLabel := '';

//  FNN:= TBHNN.Create;
end;

destructor TEquipment.Destroy;
begin
  FBoilSize.Free;
  FBatchSize.Free;
  FTunVolume.Free;
  FTunWeight.Free;
  FTunSpecificHeat.Free;
  FTopUpWater.Free;
  FTrubChillerLoss.Free;
  FEvapRate.Free;
  FBoilTime.Free;
  FCalcBoilVolume.Free;
  FLauterDeadSpace.Free;
  FTopUpKettle.Free;
  FHopUtilization.Free;
  FTopUpWaterBrewDay.Free;
  FLauterVolume.Free;
  FKettleVolume.Free;
  FTunMaterial.Free;
  FTunHeight.Free;
  FKettleHeight.Free;
  FLauterHeight.Free;
  FMashVolume.Free;
  FEfficiency.Free;
  FEffFactBD.Free;
  FEffFactSG.Free;
  FEffFactC.Free;
  FAttFactAttY.Free;
  FAttFactBD.Free;
  FAttFactTemp.Free;
  FAttFactTTime.Free;
  FAttFactPercCara.Free;
  FAttFactPercS.Free;
  FAttFactC.Free;
//  FNN.Free;
  inherited;
end;

procedure TEquipment.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FBoilSize.Assign(TEquipment(Source).BoilSize);
    FBatchSize.Assign(TEquipment(Source).BatchSize);
    FTunVolume.Assign(TEquipment(Source).TunVolume);
    FTunWeight.Assign(TEquipment(Source).TunWeight);
    FTunSpecificHeat.Assign(TEquipment(Source).TunSpecificHeat);
    FTopUpWater.Assign(TEquipment(Source).TopUpWater);
    FTrubChillerLoss.Assign(TEquipment(Source).TrubChillerLoss);
    FEvapRate.Assign(TEquipment(Source).EvapRate);
    FBoilTime.Assign(TEquipment(Source).BoilTime);
    FCalcBoilVolume.Assign(TEquipment(Source).CalcBoilVolume);
    FLauterDeadSpace.Assign(TEquipment(Source).LauterDeadSpace);
    FTopUpKettle.Assign(TEquipment(Source).TopUpKettle);
    FHopUtilization.Assign(TEquipment(Source).HopUtilization);
    FTopUpWaterBrewDay.Assign(TEquipment(Source).TopUpWaterBrewDay);
    FLauterVolume.Assign(TEquipment(Source).LauterVolume);
    FKettleVolume.Assign(TEquipment(Source).KettleVolume);
    FTunMaterial.Assign(TEquipment(Source).TunMaterial);
    FTunHeight.Assign(TEquipment(Source).TunHeight);
    FKettleHeight.Assign(TEquipment(Source).KettleHeight);
    FLauterHeight.Assign(TEquipment(Source).LauterHeight);
    FMashVolume.Assign(TEquipment(Source).MashVolume);
    FEfficiency.Assign(TEquipment(Source).Efficiency);
    FEffFactBD.Assign(TEquipment(Source).EffFactBD);
    FEffFactSG.Assign(TEquipment(Source).EffFactSG);
    FEffFactC.Assign(TEquipment(Source).EffFactC);
    FAttFactAttY.Assign(TEquipment(Source).AttFactAttY);
    FAttFactBD.Assign(TEquipment(Source).AttFactBD);
    FAttFactTemp.Assign(TEquipment(Source).AttFactTemp);
    FAttFactTTime.Assign(TEquipment(Source).AttFactTTime);
    FAttFactPercCara.Assign(TEquipment(Source).AttFactPercCara);
    FAttFactPercS.Assign(TEquipment(Source).AttFactPercS);
    FAttFactC.Assign(TEquipment(Source).AttFactC);
  end;
end;

function TEquipment.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FBoilSize.Value;
    3: Result := FBatchSize.Value;
    4: Result := FTunVolume.Value;
    5: Result := FTunWeight.Value;
    6: Result := FTunSpecificHeat.Value;
    7: Result := FTopUpWater.Value;
    8: Result := FTrubChillerLoss.Value;
    9: Result := FEvapRate.Value;
    10: Result := FBoilTime.Value;
    11: Result := FCalcBoilVolume.Value;
    12: Result := FLauterDeadSpace.Value;
    13: Result := FTopUpKettle.Value;
    14: Result := FHopUtilization.Value;
    15: Result := FLauterVolume.Value;
    16: Result := FKettleVolume.Value;
    17: Result := FTunMaterial.Value;
    18: Result := FEfficiency.Value;
    19: Result := FEffFactBD.Value;
    20: Result := FEffFactSG.Value;
    21: Result := FEffFactC.Value;
    22: Result := FAttFactAttY.Value;
    23: Result := FAttFactBD.Value;
    24: Result := FAttFactTemp.Value;
    25: Result := FAttFactTTime.Value;
    26: Result := FAttFactPercCara.Value;
    27: Result := FAttFactPercS.Value;
    28: Result := FAttFactC.Value;
    29: Result:= FTunHeight.Value;
    30: Result:= FKettleHeight.value;
    31: Result:= FLauterHeight.Value;
    32: Result:= FMashVolume.Value;
    33: Result:= FTopUpWaterBrewDay.Value;
  end;
end;

function TEquipment.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Kookvolume' then
    Result := 2
  else if s = 'Batch volume' then
    Result := 3
  else if s = 'Volume maischvat' then
    Result := 4
  else if s = 'Massa maischvat' then
    Result := 5
  else if s = 'Warmtecapaciteit maischvat' then
    Result := 6
  else if s = 'Extra water in gistvat' then
    Result := 7
  else if s = 'Verliezen koeler/kookketel' then
    Result := 8
  else if s = 'Verdamping' then
    Result := 9
  else if s = 'Kooktijd' then
    Result := 10
  else if s = 'Bereken kookvolumes' then
    Result := 11
  else if s = 'Filterkuip dode ruimte' then
    Result := 12
  else if s = 'Extra water in kookketel' then
    Result := 13
  else if s = 'Hopextractiefactor' then
    Result := 14
  else if s = 'Volume filterkuip' then
    Result := 15
  else if s = 'Volume kookketel' then
    Result := 16
  else if s = 'Materiaal maischkuip' then
    Result := 17
  else if s = 'Gem. brouwzaalrendement' then
    Result := 18
  else if s = 'Rendement factor beslagdikte' then
    Result := 19
  else if s = 'Rendement factor SG' then
    Result := 20
  else if s = 'Rendement factor constante' then
    Result := 21
  else if s = 'SVG factor SVG gist' then
    Result := 22
  else if s = 'SVG factor beslagdikte' then
    Result := 23
  else if s = 'SVG factor maischtemperatuur' then
    Result := 24
  else if s = 'SVG factor totale maischtijd' then
    Result := 25
  else if s = 'SVG factor percentage caramouten' then
    Result := 26
  else if s = 'SVG factor percentage suiker' then
    Result := 27
  else if s = 'SVG factor constante' then
    Result := 28
  else if s = 'Hoogte maischkuip' then
    Result:= 29
  else if s = 'Hoogte kookketel' then
    Result:= 30
  else if s = 'Hoogte filterkuip' then
    Result:= 31
  else if s = 'Maischwater volume' then
    Result:= 32
  else if s = 'Extra water in gistvat op brouwdag' then
    Result:= 33;
end;

function TEquipment.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Kookvolume';
    3: Result := 'Batch volume';
    4: Result := 'Volume maischvat';
    5: Result := 'Massa maischvat';
    6: Result := 'Warmtecapaciteit maischvat';
    7: Result := 'Extra water in gistvat';
    8: Result := 'Verliezen koeler/kookketel';
    9: Result := 'Verdamping';
    10: Result := 'Kooktijd';
    11: Result := 'Bereken kookvolumes';
    12: Result := 'Filterkuip dode ruimte';
    13: Result := 'Extra water in kookketel';
    14: Result := 'Hopextractiefactor';
    15: Result := 'Volume filterkuip';
    16: Result := 'Volume kookketel';
    17: Result := 'Materiaal maischkuip';
    18: Result := 'Gem. brouwzaalrendement';
    19: Result := 'Rendement factor beslagdikte';
    20: Result := 'Rendement factor SG';
    21: Result := 'Rendement factor constante';
    22: Result := 'SVG factor SVG gist';
    23: Result := 'SVG factor beslagdikte';
    24: Result := 'SVG factor maischtemperatuur';
    25: Result := 'SVG factor totale maischtijd';
    26: Result := 'SVG factor percentage caramouten';
    27: Result := 'SVG factor percentage suiker';
    28: Result := 'SVG factor constante';
    29: Result := 'Hoogte maischkuip';
    30: Result := 'Hoogte kookketel';
    31: Result := 'Hoogte filterkuip';
    32: Result:= 'Maischwater volume';
    33: Result:= 'Extra water in gistvat op brouwdag';
  end;
end;

procedure TEquipment.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('EQUIPMENT');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  FBoilSize.SaveXML(Doc, iChild, bxml);
  FBatchSize.SaveXML(Doc, iChild, bxml);
  FTunVolume.SaveXML(Doc, iChild, bxml);
  FTunWeight.SaveXML(Doc, iChild, bxml);
  FTunSpecificHeat.SaveXML(Doc, iChild, bxml);
  FTopUpWater.SaveXML(Doc, iChild, bxml);
  FTrubChillerLoss.SaveXML(Doc, iChild, bxml);
  FEvapRate.SaveXML(Doc, iChild, bxml);
  FBoilTime.SaveXML(Doc, iChild, bxml);
  FCalcBoilVolume.SaveXML(Doc, iChild, bxml);
  FLauterDeadSpace.SaveXML(Doc, iChild, bxml);
  FTopUpKettle.SaveXML(Doc, iChild, bxml);
  FHopUtilization.SaveXML(Doc, iChild, bxml);
  //extensions
  FBoilSize.SaveXMLDisplayValue(Doc, iChild);
  FBatchSize.SaveXMLDisplayValue(Doc, iChild);
  FTunVolume.SaveXMLDisplayValue(Doc, iChild);
  FTunWeight.SaveXMLDisplayValue(Doc, iChild);
  FTopUpWater.SaveXMLDisplayValue(Doc, iChild);
  FTrubChillerLoss.SaveXMLDisplayValue(Doc, iChild);
  FLauterDeadSpace.SaveXMLDisplayValue(Doc, iChild);
  FTopUpKettle.SaveXMLDisplayValue(Doc, iChild);
  //BrouwHulpXLM
  if not bxml then
  begin
    FTopUpWaterBrewDay.SaveXML(Doc, iChild, bxml);
    FLauterVolume.SaveXML(Doc, iChild, bxml);
    FKettleVolume.SaveXML(Doc, iChild, bxml);
    FTunMaterial.SaveXML(Doc, iChild, bxml);
    FTunHeight.SaveXML(Doc, iChild, bxml);
    FKettleHeight.SaveXML(Doc, iChild, bxml);
    FLauterHeight.SaveXML(Doc, iChild, bxml);
    FMashVolume.SaveXML(Doc, iChild, bxml);
    FEfficiency.SaveXML(Doc, iChild, bxml);
    FEffFactBD.SaveXML(Doc, iChild, bxml);
    FEffFactSG.SaveXML(Doc, iChild, bxml);
    FEffFactC.SaveXML(Doc, iChild, bxml);
    FAttFactAttY.SaveXML(Doc, iChild, bxml);
    FAttFactBD.SaveXML(Doc, iChild, bxml);
    FAttFactTemp.SaveXML(Doc, iChild, bxml);
    FAttFactTTime.SaveXML(Doc, iChild, bxml);
    FAttFactPercCara.SaveXML(Doc, iChild, bxml);
    FAttFactPercS.SaveXML(Doc, iChild, bxml);
    FAttFactC.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TEquipment.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  FBoilSize.ReadXML(iNode);
  FBatchSize.ReadXML(iNode);
  FTunVolume.ReadXML(iNode);
  FTunWeight.ReadXML(iNode);
  FTunSpecificHeat.ReadXML(iNode);
  FTopUpWater.ReadXML(iNode);
  FTrubChillerLoss.ReadXML(iNode);
  FEvapRate.ReadXML(iNode);
  FBoilTime.ReadXML(iNode);
  FCalcBoilVolume.ReadXML(iNode);
  FLauterDeadSpace.ReadXML(iNode);
  FTopUpKettle.ReadXML(iNode);
  FHopUtilization.ReadXML(iNode);
  FTopUpWaterBrewDay.ReadXML(iNode);
  FLauterVolume.ReadXML(iNode);
  FKettleVolume.ReadXML(iNode);
  FTunHeight.ReadXML(iNode);
  FKettleHeight.ReadXML(iNode);
  FLauterHeight.ReadXML(iNode);
  FTunMaterial.ReadXML(iNode);
  FMashVolume.ReadXML(iNode);
  FEfficiency.ReadXML(iNode);
  FEffFactBD.ReadXML(iNode);
  FEffFactSG.ReadXML(iNode);
  FEffFactC.ReadXML(iNode);
  FAttFactAttY.ReadXML(iNode);
  FAttFactBD.ReadXML(iNode);
  FAttFactTemp.ReadXML(iNode);
  FAttFactTTime.ReadXML(iNode);
  FAttFactPercCara.ReadXML(iNode);
  FAttFactPercS.ReadXML(iNode);
  FAttFactC.ReadXML(iNode);
end;

procedure TEquipment.CalcEfficiencyFactors;
var
  i: integer;
  R: TRecipe;
  OG, WtGR, Eff: double;
  X: TMatrix;
  Y: TVector;
  Lb, Ub, Nvar: integer;
  B: TVector;
  V: TMatrix;
begin
  NVar := 2;
  SetLength(Y, 0);
  SetLength(B, NVar + 1);
  for i := 0 to NVar do
    B[i] := 0.0;

  Lb := 0;
  Ub := -1;
  for i := 0 to Brews.NumItems - 1 do
  begin
    R := TRecipe(Brews.Item[i]);
    if (R <> nil) and (R.Equipment <> nil) and
      (R.Equipment.Name.Value = FName.Value) and (R.SGStartBoil > 1.0) and
      (R.ActualEfficiency.Value > 30) and (R.Mash <> nil) and
      (R.Mash.MashStep[0].WaterToGrainRatio > 0) then
    begin
      Inc(Ub);
      SetLength(X, Ub + 1);
      SetLength(X[Ub], 3);
      SetLength(Y, Ub + 1);

      OG := R.SGStartBoil;
      WtGR := R.Mash.MashStep[0].WaterToGrainRatio;
      Eff := R.ActualEfficiency.Value;
      X[Ub, 1] := OG;
      X[Ub, 2] := WtGR;
      Y[Ub] := Eff;
    end;
  end;
  SetLength(V, Ub + 1);
  for i := 0 to Ub do
    SetLength(V[i], Ub + 1);

  if Ub > 4 then
  begin
    try
      MulFit(X, Y, Lb, Ub, Nvar, True, B, V);

      FEffFactBD.Value := B[2];
      FEffFactSG.Value := B[1];
      FEffFactC.Value := B[0];
    except
      FEffFactBD.Value := 0;
      FEffFactSG.Value := 0;
      FEffFactC.Value := FEfficiency.Value;
    end;
  end
  else
  begin
    FEffFactBD.Value := 0;
    FEffFactSG.Value := 0;
    FEffFactC.Value := FEfficiency.Value;
  end;

  for i := 0 to Ub do
  begin
    SetLength(V[i], 0);
    SetLength(X[i], 0);
  end;
  SetLength(X, 0);
  SetLength(Y, 0);
  SetLength(V, 0);
  SetLength(B, 0);
end;

function TEquipment.CalcEfficiency(OG, WtGR: double): double;
begin
  Result := FEffFactC.Value + FEffFActSG.Value * OG + FEffFActBD.Value * WtGR;
end;

procedure TEquipment.CalcAttenuationFactors;
var
  i: integer;
  R: TRecipe;
  Att, AttY, WtGR, Temp, TTime, PC, PS: double;
  X: TMatrix;
  Y: TVector;
  Lb, Ub, Nvar: integer;
  B: TVector;
  V: TMatrix;
begin
  NVar := 5;
  SetLength(Y, 0);
  SetLength(B, NVar + 1);
  for i := 0 to NVar do
    B[i] := 0.0;

  Lb := 0;
  Ub := -1;
  for i := 0 to Brews.NumItems - 1 do
  begin
    R := TRecipe(Brews.Item[i]);
    if (R <> nil) and (R.Equipment <> nil) and
      (R.Equipment.Name.Value = FName.Value) and (R.Mash <> nil) and
      (R.Mash.MashStep[0] <> nil) and (R.Mash.MashStep[0].WaterToGrainRatio > 0) and
      (R.Yeast[0] <> nil) and (R.Yeast[0].Attenuation.Value > 0) and
      (R.Mash.TotalMashTime > 0) and (R.Mash.AverageTemperature > 0) and
      (R.OG.Value > 1) and (R.FG.Value > 1) then
    begin
      Inc(Ub);
      SetLength(X, Ub + 1);
      SetLength(X[Ub], Nvar + 1);
      SetLength(Y, Ub + 1);

      AttY := R.Yeast[0].Attenuation.Value;
      Temp := R.Mash.AverageTemperature;
      TTime := R.Mash.TotalMashTime;
      PC := R.PercCrystalMalt;
      PS := R.PercSugar;
      WtGR := R.Mash.MashStep[0].WaterToGrainRatio;
      if R.OG.Value > 1 then
        Att := (R.OG.Value - R.FG.Value) / (R.OG.Value - 1)
      else Att:= 0;
      X[Ub, 1] := AttY;
      X[Ub, 2] := WtGR;
      X[Ub, 3] := Temp;
      X[Ub, 4] := TTime;
      X[Ub, 5] := PC;
      X[Ub, 6] := PS;
      Y[Ub] := Att;
    end;
  end;
  SetLength(V, Ub + 1);
  for i := 0 to Ub do
    SetLength(V[i], Ub + 1);

  if Ub > 4 then
  begin
    try
      MulFit(X, Y, Lb, Ub, Nvar, True, B, V);

      FAttFactC.Value := B[0];
      FAttFactAttY.Value := B[1];
      FAttFactBD.Value := B[2];
      FAttFactTemp.Value := B[3];
      FAttFactTTime.Value := B[4];
      FAttFactPercCara.Value := B[5];
      FAttFactPercS.Value := B[6];
    except
      FAttFactC.Value := 0.547;
      FAttFactAttY.Value := 0.00825;
      FAttFactBD.Value := 0.00817;
      FAttFactTemp.Value := -0.00684;
      FAttFactTTime.Value := 0.0026;
      FAttFactPercCara.Value := -0.00356;
      FAttFactPercS.Value := 0.00553;
    end;
  end
  else
  begin
    FAttFactC.Value := 0.547;
    FAttFactAttY.Value := 0.00825;
    FAttFactBD.Value := 0.00817;
    FAttFactTemp.Value := -0.00684;
    FAttFactTTime.Value := 0.0026;
    FAttFactPercCara.Value := -0.00356;
    FAttFactPercS.Value := 0.00553;
  end;

  for i := 0 to Ub do
  begin
    SetLength(V[i], 0);
    SetLength(X[i], 0);
  end;
  SetLength(X, 0);
  SetLength(Y, 0);
  SetLength(V, 0);
  SetLength(B, 0);
end;

function TEquipment.EstimateFG(AttY, BD, Temp, TTime, PCara, PSugar: double): double;
begin
  Result := AttY * FAttFactAttY.Value + BD * FAttFactBD.Value + TTime *
    FAttFactTTime.Value + PCara * FAttFactPercCara.Value +
    PSugar * FAttFactPercS.Value + FAttFactC.Value;
end;

Function TEquipment.VolumeInKettle(h : double) : double;
begin //h in m
  Result:= 0;
  if (FKettleHeight.Value > 0) and (h >= 0) and (h <= FKettleHeight.Value) then
    Result:= (FKettleHeight.Value - h) / FKettleHeight.Value * FKettleVolume.Value;
end;

Function TEquipment.VolumeInTun(h : double) : double;
begin //h in m
  Result:= 0;
  if (FTunHeight.Value > 0) and (h >= 0) and (h <= FTunHeight.Value) then
    Result:= (FTunHeight.Value - h) / FTunHeight.Value * FTunVolume.Value;
end;

Function TEquipment.VolumeInLautertun(h : double) : double;
begin //h in m
  Result:= 0;
  if (FLauterHeight.Value > 0) and (h >= 0) and (h <= FLauterHeight.Value) then
    Result:= (FLauterHeight.Value - h) / FLauterHeight.Value * FLauterVolume.Value;
end;

Function TEquipment.CmInKettle(vol : double) : double;
begin
  Result:= 0;
  if (FKettleVolume.Value > 0) and (vol >= 0) and (vol <= FKettleVolume.Value) then
    Result:= (1 - vol / FKettleVolume.Value) * FKettleHeight.Value * 100;
end;

Function TEquipment.CmInTun(vol : double) : double;
var tv, th : double;
begin
  Result:= 0;
  if (FTunVolume.Value > 0) and (vol >= 0) and (vol <= FTunVolume.Value) then
  begin
    tv:= FTunVolume.Value;
    th:= FTunHeight.Value;
    Result:= (1 - vol / tv) * th * 100;
  end;
end;

Function TEquipment.CmInLautertun(vol : double) : double;
begin
  Result:= 0;
  if (FLauterVolume.Value > 0) and (vol >= 0) and (vol <= FLauterVolume.Value) then
    Result:= (1 - vol / FLauterVolume.Value) * FLauterHeight.Value * 100;
end;

{=========================== Beerstyles =======================================}

constructor TBeerStyle.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtStyle;

  FCategory := TBString.Create(self);
  FCategory.Value := '';
  FCategory.NodeLabel := 'CATEGORY';

  FCategoryNumber := TBString.Create(self);
  FCategoryNumber.Value := '';
  FCategoryNumber.NodeLabel := 'CATEGORY_NUMBER';

  FStyleLetter := TBString.Create(self);
  FStyleLetter.Value := '';
  FStyleLetter.NodeLabel := 'STYLE_LETTER';

  FStyleGuide := TBString.Create(self);
  FStyleGuide.Value := '';
  FStyleGuide.NodeLabel := 'STYLE_GUIDE';

  FStyleType := stLager;

  FOGMin := TBFloat.Create(self);
  FOGMin.vUnit := sg;
  FOGMin.DisplayUnit := sg;
  FOGMin.MinValue := 1.0;
  FOGMin.MaxValue := 1.2;
  FOGMin.Value := 1.03;
  FOGMin.Decimals := 3;
  FOGMin.NodeLabel := 'OG_MIN';
  FOGMin.DisplayLabel := 'DISPLAY_OG_MIN';

  FOGMax := TBFloat.Create(self);
  FOGMax.vUnit := sg;
  FOGMax.DisplayUnit := sg;
  FOGMax.MinValue := 1.0;
  FOGMax.MaxValue := 1.3;
  FOGMax.Value := 1.05;
  FOGMax.Decimals := 3;
  FOGMax.NodeLabel := 'OG_MAX';
  FOGMax.DisplayLabel := 'DISPLAY_OG_MAX';

  FFGMin := TBFloat.Create(self);
  FFGMin.vUnit := sg;
  FFGMin.DisplayUnit := sg;
  FFGMin.MinValue := 0.9;
  FFGMin.MaxValue := 1.1;
  FFGMin.Value := 1.005;
  FFGMin.Decimals := 3;
  FFGMin.NodeLabel := 'FG_MIN';
  FFGMin.DisplayLabel := 'DISPLAY_FG_MIN';

  FFGMax := TBFloat.Create(self);
  FFGMax.vUnit := sg;
  FFGMax.DisplayUnit := sg;
  FFGMax.MinValue := 0.9;
  FFGMax.MaxValue := 1.100;
  FFGMax.Value := 1.010;
  FFGMax.Decimals := 3;
  FFGMax.NodeLabel := 'FG_MAX';
  FFGMax.DisplayLabel := 'DISPLAY_FG_MAX';

  FIBUMIn := TBFloat.Create(self);
  FIBUMIn.vUnit := ibu;
  FIBUMIn.DisplayUnit := ibu;
  FIBUMIn.MinValue := 0.0;
  FIBUMIn.MaxValue := 200;
  FIBUMIn.Value := 20.0;
  FIBUMIn.Decimals := 0;
  FIBUMIn.NodeLabel := 'IBU_MIN';
  FIBUMIn.DisplayLabel := 'DISPLAY_IBU_MIN';

  FIBUMax := TBFloat.Create(self);
  FIBUMax.vUnit := ibu;
  FIBUMax.DisplayUnit := ibu;
  FIBUMax.MinValue := 0.0;
  FIBUMax.MaxValue := 200;
  FIBUMax.Value := 30.0;
  FIBUMax.Decimals := 0;
  FIBUMax.NodeLabel := 'IBU_MAX';
  FIBUMax.DisplayLabel := 'DISPLAY_IBU_MAX';

  FColorMin := TBFloat.Create(self);
  FColorMin.vUnit := srm;
  FColorMin.DisplayUnit := ebc;
  FColorMin.MinValue := 0.0;
  FColorMin.MaxValue := 1000;
  FColorMin.Value := 20.0;
  FColorMin.Decimals := 0;
  FColorMin.NodeLabel := 'COLOR_MIN';
  FColorMin.DisplayLabel := 'DISPLAY_COLOR_MIN';

  FColorMax := TBFloat.Create(self);
  FColorMax.vUnit := srm;
  FColorMax.DisplayUnit := ebc;
  FColorMax.MinValue := 0.0;
  FColorMax.MaxValue := 1000;
  FColorMax.Value := 30.0;
  FColorMax.Decimals := 0;
  FColorMax.NodeLabel := 'COLOR_MAX';
  FColorMax.DisplayLabel := 'DISPLAY_COLOR_MAX';

  FCarbMin := TBFloat.Create(self);
  FCarbMin.vUnit := volco2;
  FCarbMin.DisplayUnit := volco2;
  FCarbMin.MinValue := 0.0;
  FCarbMin.MaxValue := 5.0;
  FCarbMin.Value := 2.0;
  FCarbMin.Decimals := 1;
  FCarbMin.NodeLabel := 'CARB_MIN';
  FCarbMin.DisplayLabel := 'DISPLAY_CARB_MIN';

  FCarbMax := TBFloat.Create(self);
  FCarbMax.vUnit := volco2;
  FCarbMax.DisplayUnit := volco2;
  FCarbMax.MinValue := 0.0;
  FCarbMax.MaxValue := 5.0;
  FCarbMax.Value := 2.5;
  FCarbMax.Decimals := 1;
  FCarbMax.NodeLabel := 'CARB_MAX';
  FCarbMax.DisplayLabel := 'DISPLAY_CARB_MAX';

  FABVMin := TBFloat.Create(self);
  FABVMin.vUnit := abv;
  FABVMin.DisplayUnit := abv;
  FABVMin.MinValue := 0.0;
  FABVMin.MaxValue := 20;
  FABVMin.Value := 4.0;
  FABVMin.Decimals := 1;
  FABVMin.NodeLabel := 'ABV_MIN';
  FABVMin.DisplayLabel := 'DISPLAY_ABV_MIN';

  FABVMax := TBFloat.Create(self);
  FABVMax.vUnit := abv;
  FABVMax.DisplayUnit := abv;
  FABVMax.MinValue := 0.0;
  FABVMax.MaxValue := 20;
  FABVMax.Value := 5.0;
  FABVMax.Decimals := 1;
  FABVMax.NodeLabel := 'ABV_MAX';
  FABVMax.DisplayLabel := 'DISPLAY_ABV_MAX';

  FProfile := TBString.Create(self);
  FProfile.Value := '';
  FProfile.NodeLabel := 'PROFILE';

  FIngredients := TBString.Create(self);
  FIngredients.Value := '';
  FIngredients.NodeLabel := 'INGREDIENTS';

  FExamples := TBString.Create(self);
  FExamples.Value := '';
  FExamples.NodeLabel := 'EXAMPLES';
end;

destructor TBeerStyle.Destroy;
begin
  FCategory.Free;
  FCategoryNumber.Free;
  FStyleLetter.Free;
  FStyleGuide.Free;
  FOGMin.Free;
  FOGMax.Free;
  FFGMin.Free;
  FFGMax.Free;
  FIBUMIn.Free;
  FIBUMax.Free;
  FColorMin.Free;
  FColorMax.Free;
  FCarbMin.Free;
  FCarbMax.Free;
  FABVMin.Free;
  FABVMax.Free;
  FProfile.Free;
  FIngredients.Free;
  FExamples.Free;
  inherited;
end;

procedure TBeerStyle.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FStyleType := TBeerStyle(Source).StyleType;
    FCategory.Assign(TBeerStyle(Source).Category);
    FCategoryNumber.Assign(TBeerStyle(Source).CategoryNumber);
    FStyleLetter.Assign(TBeerStyle(Source).StyleLetter);
    FStyleGuide.Assign(TBeerStyle(Source).StyleGuide);
    FOGMin.Assign(TBeerStyle(Source).OGMin);
    FOGMax.Assign(TBeerStyle(Source).OGMax);
    FFGMin.Assign(TBeerStyle(Source).FGMin);
    FFGMax.Assign(TBeerStyle(Source).FGMax);
    FIBUMIn.Assign(TBeerStyle(Source).IBUmin);
    FIBUMax.Assign(TBeerStyle(Source).IBUmax);
    FColorMin.Assign(TBeerStyle(Source).ColorMin);
    FColorMax.Assign(TBeerStyle(Source).ColorMax);
    FCarbMin.Assign(TBeerStyle(Source).CarbMin);
    FCarbMax.Assign(TBeerStyle(Source).CarbMax);
    FABVMin.Assign(TBeerStyle(Source).ABVMin);
    FABVMax.Assign(TBeerStyle(Source).ABVMax);
    FProfile.Assign(TBeerStyle(Source).Profile);
    FIngredients.Assign(TBeerStyle(Source).Ingredients);
    FExamples.Assign(TBeerStyle(Source).Examples);
  end;
end;

function TBeerStyle.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := StyleTypeDisplayNames[FStyleType];
    3: Result := FCategory.Value;
    4: Result := FCategoryNumber.Value;
    5: Result := FStyleLetter.Value;
    6: Result := FStyleGuide.Value;
    7: Result := FOGMin.Value;
    8: Result := FOGMax.Value;
    9: Result := FFGMin.Value;
    10: Result := FFGMax.Value;
    11: Result := FIBUMIn.Value;
    12: Result := FIBUMax.Value;
    13: Result := FColorMin.Value;
    14: Result := FColorMax.Value;
    15: Result := FCarbMin.Value;
    16: Result := FCarbMax.Value;
    17: Result := FABVMin.Value;
    18: Result := FABVMax.Value;
    19: Result := FProfile.Value;
    20: Result := FIngredients.Value;
    21: Result := FExamples.Value;
  end;
end;

function TBeerStyle.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Type' then
    Result := 2
  else if s = 'Category' then
    Result := 3
  else if s = 'Category nummer' then
    Result := 4
  else if s = 'Klasse' then
    Result := 5
  else if s = 'Bron' then
    Result := 6
  else if s = 'Min. start SG' then
    Result := 7
  else if s = 'Max. start SG' then
    Result := 8
  else if s = 'Min. eind SG' then
    Result := 9
  else if s = 'Max. eind SG' then
    Result := 10
  else if s = 'Min. bitterheid' then
    Result := 11
  else if s = 'Max. bitterheid' then
    Result := 12
  else if s = 'Min. kleur' then
    Result := 13
  else if s = 'Max. kleur' then
    Result := 14
  else if s = 'Min. koolzuur' then
    Result := 15
  else if s = 'Max. koolzuur' then
    Result := 16
  else if s = 'Min. alcohol' then
    Result := 17
  else if s = 'Max. alcohol' then
    Result := 18
  else if s = 'Profiel' then
    Result := 19
  else if s = 'Ingrediënten' then
    Result := 20
  else if s = 'Voorbeelden' then
    Result := 21;
end;

function TBeerStyle.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Type';
    3: Result := 'Category';
    4: Result := 'Category nummer';
    5: Result := 'Klasse';
    6: Result := 'Bron';
    7: Result := 'Min. start SG';
    8: Result := 'Max. start SG';
    9: Result := 'Min. eind SG';
    10: Result := 'Max. eind SG';
    11: Result := 'Min. bitterheid';
    12: Result := 'Max. bitterheid';
    13: Result := 'Min. kleur';
    14: Result := 'Max. kleur';
    15: Result := 'Min. koolzuur';
    16: Result := 'Max. koolzuur';
    17: Result := 'Min. alcohol';
    18: Result := 'Max. alcohol';
    19: Result := 'Profiel';
    20: Result := 'Ingrediënten';
    21: Result := 'Voorbeelden';
  end;
end;

procedure TBeerStyle.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
  s: string;
begin
  iChild := Doc.CreateElement('STYLE');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  FCategory.SaveXML(Doc, iChild, bxml);
  FCategoryNumber.SaveXML(Doc, iChild, bxml);
  FStyleLetter.SaveXML(Doc, iChild, bxml);
  FStyleGuide.SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'TYPE', TypeName);
  FOGmin.SaveXML(Doc, iChild, bxml);
  FOGmax.SaveXML(Doc, iChild, bxml);
  FFGmin.SaveXML(Doc, iChild, bxml);
  FFGmax.SaveXML(Doc, iChild, bxml);
  FIBUmin.SaveXML(Doc, iChild, bxml);
  FIBUmax.SaveXML(Doc, iChild, bxml);
  FColorMin.SaveXML(Doc, iChild, bxml);
  FColorMax.SaveXML(Doc, iChild, bxml);
  FCarbMin.SaveXML(Doc, iChild, bxml);
  FCarbMax.SaveXML(Doc, iChild, bxml);
  FAbvMin.SaveXML(Doc, iChild, bxml);
  FABVmax.SaveXML(Doc, iChild, bxml);
  FProfile.SaveXML(Doc, iChild, bxml);
  FIngredients.SaveXML(Doc, iChild, bxml);
  FExamples.SaveXML(Doc, iChild, bxml);
  //extensions
  FOGmin.SaveXMLDisplayValue(Doc, iChild);
  FOGmax.SaveXMLDisplayValue(Doc, iChild);
  FFGmin.SaveXMLDisplayValue(Doc, iChild);
  FFGmax.SaveXMLDisplayValue(Doc, iChild);
  FIBUmin.SaveXMLDisplayValue(Doc, iChild);
  FIBUmax.SaveXMLDisplayValue(Doc, iChild);
  FColorMin.SaveXMLDisplayValue(Doc, iChild);
  FColorMax.SaveXMLDisplayValue(Doc, iChild);
  FCarbMin.SaveXMLDisplayValue(Doc, iChild);
  FCarbMax.SaveXMLDisplayValue(Doc, iChild);
  FAbvMin.SaveXMLDisplayValue(Doc, iChild);
  FABVmax.SaveXMLDisplayValue(Doc, iChild);
  s := RealToStrDec(FOGMin.Value, FOGMin.Decimals) + '-' +
    RealToStrDec(FOGMax.Value, FOGMax.Decimals) + ' ' + UnitNames[FOGMin.DisplayUnit];
  AddNode(Doc, iChild, 'OG_RANGE', s);
  s := RealToStrDec(FFGMin.Value, FFGMin.Decimals) + '-' +
    RealToStrDec(FFGMax.Value, FFGMax.Decimals) + ' ' + UnitNames[FFGMin.DisplayUnit];
  AddNode(Doc, iChild, 'FG_RANGE', s);
  s := RealToStrDec(FIBUMin.Value, FIBUMin.Decimals) + '-' +
    RealToStrDec(FIBUMax.Value, FIBUMax.Decimals) + ' ' +
    UnitNames[FIBUMin.DisplayUnit];
  AddNode(Doc, iChild, 'IBU_RANGE', s);
  s := RealToStrDec(FCarbMin.Value, FCarbMin.Decimals) + '-' +
    RealToStrDec(FCarbMax.Value, FCarbMax.Decimals) + ' ' +
    UnitNames[FCarbMin.DisplayUnit];
  AddNode(Doc, iChild, 'CARB_RANGE', s);
  s := RealToStrDec(FColorMin.Value, FColorMin.Decimals) + '-' +
    RealToStrDec(FColorMax.Value, FColorMax.Decimals) + ' ' +
    UnitNames[FColorMin.DisplayUnit];
  AddNode(Doc, iChild, 'COLOR_RANGE', s);
  s := RealToStrDec(FABVMin.Value, FABVMin.Decimals) + '-' +
    RealToStrDec(FABVMax.Value, FABVMax.Decimals) + ' ' +
    UnitNames[FABVMin.DisplayUnit];
  AddNode(Doc, iChild, 'ABV_RANGE', s);
end;

procedure TBeerStyle.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  FCategory.ReadXML(iNode);
  FCategoryNumber.ReadXML(iNode);
  FStyleLetter.ReadXML(iNode);
  FStyleGuide.ReadXML(iNode);
  TypeName := GetNodeString(iNode, 'TYPE');
  FOGmin.ReadXML(iNode);
  FOGmax.ReadXML(iNode);
  FFGmin.ReadXML(iNode);
  FFGmax.ReadXML(iNode);
  FIBUmin.ReadXML(iNode);
  FIBUmax.ReadXML(iNode);
  FColorMin.ReadXML(iNode);
  FColorMax.ReadXML(iNode);
  FCarbMin.ReadXML(iNode);
  FCarbMax.ReadXML(iNode);
  FAbvMin.ReadXML(iNode);
  FABVmax.ReadXML(iNode);
  FProfile.ReadXML(iNode);
  FIngredients.ReadXML(iNode);
  FExamples.ReadXML(iNode);
end;

function TBeerStyle.GetTypeName: string;
begin
  Result := StyleTypeNames[FStyleType];
end;

procedure TBeerStyle.SetTypeName(s: string);
var
  st: TStyleType;
begin
  for st := Low(StyleTypeNames) to High(StyleTypeNames) do
    if LowerCase(StyleTypeNames[st]) = LowerCase(s) then
      FStyleType := st;
end;

function TBeerStyle.GetTypeDisplayName: string;
begin
  Result := StyleTypeDisplayNames[FStyleType];
end;

procedure TBeerStyle.SetTypeDisplayName(s: string);
var
  st: TStyleType;
begin
  for st := Low(StyleTypeDisplayNames) to High(StyleTypeDisplayNames) do
    if LowerCase(StyleTypeDisplayNames[st]) = LowerCase(s) then
      FStyleType := st;
end;

function TBeerStyle.GetBUGUMin: double;
var
  B, G: double;
begin
  Result:= 0;
  if ((FOGMax.Value + FOGMin.Value) > 0) and ((FIBUMax.Value + FIBUMin.Value) > 0) then
  begin
    G := (FOGMax.Value - FOGMin.Value) / ((FOGMax.Value + FOGMin.Value) / 2);
    B := (FIBUMax.Value - FIBUMin.Value) / ((FIBUMax.Value + FIBUMin.Value) / 2);
    if G > B then
      Result := ((FIBUMin.Value + FIBUMax.Value) / 2) / (1000 * (FOGMax.Value - 1))
    else
      Result := FIBUMin.Value / (1000 * (((FOGMax.Value + FOGMin.Value) / 2) - 1));
  end;
end;

function TBeerStyle.GetBUGUMax: double;
var
  B, G: double;
begin
  Result:= 0;
  if ((FOGMax.Value + FOGMin.Value) > 0) and ((FIBUMax.Value + FIBUMin.Value) > 0)
  and (FOGMin.Value > 1) then
  begin
    G := (FOGMax.Value - FOGMin.Value) / ((FOGMax.Value + FOGMin.Value) / 2);
    B := (FIBUMax.Value - FIBUMin.Value) / ((FIBUMax.Value + FIBUMin.Value) / 2);
    if G > B then
      Result := ((FIBUMin.Value + FIBUMax.Value) / 2) / (1000 * (FOGMin.Value - 1))
    else
      Result := FIBUMax.Value / (1000 * (((FOGMax.Value + FOGMin.Value) / 2) - 1));
  end;
end;

{==============================Mash step=======================================}

constructor TMashStep.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtMash;

  FPriorStep := nil;
  FNextStep := nil;
  FNotes.NodeLabel := 'DESCRIPTION';

  FMashStepType := mstInfusion;

  FInfuseAmount := TBFloat.Create(self);
  FInfuseAmount.vUnit := liter;
  FInfuseAmount.DisplayUnit := liter;
  FInfuseAmount.MinValue := 0.0;
  FInfuseAmount.MaxValue := 1000000;
  FInfuseAmount.Value := 0.0;
  FInfuseAmount.Decimals := 1;
  FInfuseAmount.NodeLabel := 'INFUSE_AMOUNT';
  FInfuseAmount.DisplayLabel := 'DISPLAY_INFUSE_AMT';

  FInfuseTemp := TBFloat.Create(self);
  FInfuseTemp.vUnit := celcius;
  FInfuseTemp.DisplayUnit := celcius;
  FInfuseTemp.MinValue := 0.0;
  FInfuseTemp.MaxValue := 100;
  FInfuseTemp.Value := 99.0;
  FInfuseTemp.Decimals := 1;
  FInfuseTemp.NodeLabel := '';
  FInfuseTemp.DisplayLabel := 'INFUSE_TEMP';

  FStepTemp := TBFloat.Create(self);
  FStepTemp.vUnit := celcius;
  FStepTemp.DisplayUnit := celcius;
  FStepTemp.MinValue := 30.0;
  FStepTemp.MaxValue := 100.0;
  FStepTemp.Value := 63;
  FStepTemp.Decimals := 1;
  FStepTemp.NodeLabel := 'STEP_TEMP';
  FStepTemp.DisplayLabel := 'DISPLAY_STEP_TEMP';

  FStepTime := TBFloat.Create(self);
  FStepTime.vUnit := minuut;
  FStepTime.DisplayUnit := minuut;
  FStepTime.MinValue := 0.0;
  FStepTime.MaxValue := 120;
  FStepTime.Value := 30;
  FStepTime.Decimals := 0;
  FStepTime.NodeLabel := 'STEP_TIME';
  FStepTime.DisplayLabel := '';

  FRampTime := TBFloat.Create(self);
  FRampTime.vUnit := minuut;
  FRampTime.DisplayUnit := minuut;
  FRampTime.MinValue := 0.0;
  FRampTime.MaxValue := 120;
  FRampTime.Value := 1;
  FRampTime.Decimals := 0;
  FRampTime.NodeLabel := 'RAMP_TIME';
  FRampTime.DisplayLabel := '';

  FEndTemp := TBFloat.Create(self);
  FEndTemp.vUnit := celcius;
  FEndTemp.DisplayUnit := celcius;
  FEndTemp.MinValue := 30.0;
  FEndTemp.MaxValue := 100;
  FEndTemp.Value := 63;
  FEndTemp.Decimals := 1;
  FEndTemp.NodeLabel := 'END_TEMP';
  FEndTemp.DisplayLabel := '';

  //BrewBuddyXML
  FpH := TBFloat.Create(self);
  FpH.vUnit := ph;
  FpH.DisplayUnit := ph;
  FpH.MinValue := 1.0;
  FpH.MaxValue := 14.0;
  FpH.Value := 5.3;
  FpH.Decimals := 2;
  FpH.NodeLabel := 'PH';
  FpH.DisplayLabel := '';
end;

destructor TMashStep.Destroy;
begin
  FPriorStep := nil;
  FNextStep := nil;
  FMashStepType := mstInfusion;
  FInfuseAmount.Free;
  FInfuseTemp.Free;
  FStepTemp.Free;
  FStepTime.Free;
  FRampTime.Free;
  FEndTemp.Free;
  FpH.Free;
  inherited;
end;

procedure TMashStep.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FMashStepType := TMashStep(Source).MashStepType;
    FInfuseAmount.Assign(TMashStep(Source).InfuseAmount);
    FInfuseTemp.Assign(TMashStep(Source).InfuseTemp);
    FStepTemp.Assign(TMashStep(Source).StepTemp);
    FStepTime.Assign(TMashStep(Source).StepTime);
    FRampTime.Assign(TMashStep(Source).RampTime);
    FEndTemp.Assign(TMashStep(Source).EndTemp);
    FpH.Assign(TMashStep(Source).pHstep);
  end;
end;

function TMashStep.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := MashStepTypeDisplayNames[FMashStepType];
    3: Result := FRampTime.Value;
    4: Result := FStepTemp.Value;
    5: Result := FEndTemp.Value;
    6: Result := FStepTime.Value;
    7: Result := FInfuseAmount.Value;
    8: Result := FInfuseTemp.Value;
    9: Result := FpH.Value;
  end;
end;

function TMashStep.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Type' then
    Result := 2
  else if s = 'Opwarmtijd' then
    Result := 3
  else if s = 'Stap begintemperatuur' then
    Result := 4
  else if s = 'Stap eindtemperatuur' then
    Result := 5
  else if s = 'Stap tijd' then
    Result := 6
  else if s = 'Infusie volume' then
    Result := 7
  else if s = 'Infusie temperatuur' then
    Result := 8
  else if s = 'pH' then
    Result := 9;
end;

function TMashStep.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Type';
    3: Result := 'Opwarmtijd';
    4: Result := 'Stap begintemperatuur';
    5: Result := 'Stap eindtemperatuur';
    6: Result := 'Stap tijd';
    7: Result := 'Infusie volume';
    8: Result := 'Infusie temperatuur';
    9: Result := 'pH';
  end;
end;

procedure TMashStep.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('MASH_STEP');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);
  AddNode(Doc, iChild, 'TYPE', TypeName);
  FInfuseAmount.SaveXML(Doc, iChild, bxml);
  FStepTemp.SaveXML(Doc, iChild, bxml);
  FStepTime.SaveXML(Doc, iChild, bxml);
  FRampTime.SaveXML(Doc, iChild, bxml);
  FEndTemp.SaveXML(Doc, iChild, bxml);
  //Extensions
  AddNode(Doc, iChild, 'WATER_GRAIN_RATIO', RealToStrDec(WaterToGrainRatio,
    2) + ' l/kg');
  if FMashStepType = mstDecoction then
  begin
    AddNode(Doc, iChild, 'DECOCTION_AMT', RealToStrDec(FInfuseAmount.Value, 2) +
      UnitNames[liter]);
    AddNode(Doc, iChild, 'INFUSE_AMOUNT', '0.0');
  end
  else
  begin
    AddNode(Doc, iChild, 'DECOCTION_AMT', '0.0');
    FInfuseAmount.SaveXMLDisplayValue(Doc, iChild);
  end;

  FInfuseTemp.SaveXMLDisplayValue(Doc, iChild);
  FStepTemp.SaveXMLDisplayValue(Doc, iChild);
  //BrewBuddyXML
  if not bxml then
    FpH.SaveXML(Doc, iChild, bxml);
end;

procedure TMashStep.ReadXML(iNode: TDOMNode);
var s: string;
begin
  inherited ReadXML(iNode);
  s := GetNodeString(iNode, 'TYPE');
  TypeName := s;
  FInfuseAmount.ReadXML(iNode);
  FStepTemp.ReadXML(iNode);
  FStepTime.ReadXML(iNode);
  FRampTime.ReadXML(iNode);
  FEndTemp.ReadXML(iNode);
  //Extensions
  FInfuseTemp.ReadXMLDisplayValue(iNode);
  //BrewBuddyXML
  FpH.ReadXML(iNode);
end;

function TMashStep.GetTypeName: string;
begin
  Result := MashStepTypeNames[FMashStepType];
end;

procedure TMashStep.SetTypeName(s: string);
var
  mst: TMashStepType;
begin
  for mst := Low(MashStepTypeNames) to High(MashStepTypeNames) do
    if LowerCase(MashStepTypeNames[mst]) = LowerCase(s) then
      FMashStepType := mst;
end;

function TMashStep.GetTypeDisplayName: string;
begin
  Result := MashStepTypeDisplayNames[FMashStepType];
end;

procedure TMashStep.SetTypeDisplayName(s: string);
var
  mst: TMashStepType;
begin
  for mst := Low(MashStepTypeDisplayNames) to High(MashStepTypeDisplayNames) do
    if LowerCase(MashStepTypeDisplayNames[mst]) = LowerCase(s) then
      FMashStepType := mst;
end;

function TMashStep.GetWaterToGrainRatio: double;
var
  vol, mass: double;
  pr: TMashStep;
begin
  Result := 0;
  vol := 0;
  mass := 0;
  if FRecipe <> nil then
  begin
    if FMashStepType = mstInfusion then
      vol := FInfuseAmount.Value
    else
      vol := 0;
    pr := FPriorStep;
    while pr <> nil do
    begin
      if pr.MashStepType = mstInfusion then
        vol := vol + pr.InfuseAmount.Value;
      pr := pr.PriorStep;
    end;
    mass := FRecipe.GrainMass;
    if mass <> 0 then
      Result := vol / mass;
  end;
end;

function TMashStep.GetDisplayString: string;
begin
  Result := FStepTime.DisplayString + ' bij ' + FStepTemp.DisplayString;
end;

procedure TMashStep.CalcStep;
var
  A, B, GrM, {VolMalt,} VWater, Temp, Vol: double;
  i, n: integer;
  Mash: TMash;
  Prior: TMashStep;
begin
  if (FRecipe <> nil) and (FRecipe.Mash <> nil) then
  begin
    VWater := 0;
    Prior := FPriorStep;
    while (Prior <> nil) do
    begin
      if Prior.MashStepType = mstInfusion then
        VWater := VWater + Prior.InfuseAmount.Value;
      Prior := Prior.PriorStep;
    end;
    Mash := FRecipe.Mash;
    GrM := FRecipe.GrainMassMash;
    //VolMalt := GrM * MaltVolume;
    case MashStepType of
      mstInfusion:
      begin
        if FPriorStep = nil then
        begin // calculate first infusion temperature from kettle and grain temperature
          if Mash.EquipAdjust.Value then
          begin
            n := 1;
          end
          else
          begin
            n := 20;
            Mash.TunTemp.Value := StepTemp.Value;
          end;
          if FInfuseAmount.Value <= 0 then
            FInfuseAmount.Value := FRecipe.BatchSize.Value;
          for i := 1 to n do
          begin
            A := GrM * Mash.GrainTemp.Value * SpecificHeatMalt +
              Mash.TunTemp.Value * Mash.TunWeight.Value * Mash.TunSpecificHeat.Value;
            B := StepTemp.Value * (Mash.TunWeight.Value *
              Mash.TunSpecificHeat.Value + FInfuseAmount.Value *
              SpecificHeatWater + GrM * SpecificHeatMalt) - SlakingHeat * GrM;
            if FInfuseAmount.Value > 0 then
              Temp := (B - A) / (FInfuseAmount.Value * SpecificHeatWater)
            else Temp:= 99;
            if not Mash.EquipAdjust.Value then
              Mash.TunTemp.Value := Mash.TunTemp.Value + (Temp - Mash.TunTemp.Value) / 2;
          end;
        end
        else //calculate amount of infusion water
        begin
          Temp := 99; //°C
          A := FPriorStep.EndTemp.Value * (Mash.TunWeight.Value *
            Mash.TunSpecificHeat.Value + Vwater * SpecificHeatWater +
            GrM * SpecificHeatMalt);
          B := StepTemp.Value * (Mash.TunWeight.Value *
            Mash.TunSpecificHeat.Value + Vwater * SpecificHeatWater +
            GrM * SpecificHeatMalt);
          if ((Temp - FStepTemp.Value) * SpecificHeatWater > 0) then
            Vol := (B - A) / ((Temp - FStepTemp.Value) * SpecificHeatWater)
          else Vol:= 0;
          InfuseAmount.Value := Vol;
        end;
        FInfuseTemp.Value := Temp;
      end;
      mstTemperature:
      begin
        if FPriorStep <> nil then
          FInfuseAmount.Value := 0;
        FInfuseTemp.Value := 0;
      end;
      mstDecoction:
      begin
        if FPriorStep <> nil then
        begin
          Temp := 99;
          A:= (Mash.TunWeight.Value * Mash.TunSpecificHeat.Value +
               Vwater * SpecificHeatWater)
               * (FStepTemp.Value - FPriorStep.EndTemp.Value);
          B:= SpecificHeatWater * (Temp - FStepTemp.Value);
          if B > 0 then Vol:= A / B
          else Vol:= 0;
          FInfuseAmount.Value := Vol;
          FInfuseTemp.Value := Temp;
        end;
      end;
    end;
  end;
end;

{============================ MASH ============================================}

constructor TMash.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtMash;

  FGrainTemp := TBFloat.Create(self);
  FGrainTemp.vUnit := celcius;
  FGrainTemp.DisplayUnit := celcius;
  FGrainTemp.MinValue := 0.0;
  FGrainTemp.MaxValue := 50.0;
  FGrainTemp.Value := 10.0;
  FGrainTemp.Decimals := 1;
  FGrainTemp.NodeLabel := 'GRAIN_TEMP';
  FGrainTemp.DisplayLabel := 'DISPLAY_GRAIN_TEMP';

  FTunTemp := TBFloat.Create(self);
  FTunTemp.vUnit := celcius;
  FTunTemp.DisplayUnit := celcius;
  FTunTemp.MinValue := 0.0;
  FTunTemp.MaxValue := 100.0;
  FTunTemp.Value := 10.0;
  FTunTemp.Decimals := 1;
  FTunTemp.NodeLabel := 'TUN_TEMP';
  FTunTemp.DisplayLabel := 'DISPLAY_TUN_TEMP';

  FSpargeTemp := TBFloat.Create(self);
  FSpargeTemp.vUnit := celcius;
  FSpargeTemp.DisplayUnit := celcius;
  FSpargeTemp.MinValue := 0.0;
  FSpargeTemp.MaxValue := 100.0;
  FSpargeTemp.Value := 78;
  FSpargeTemp.Decimals := 1;
  FSpargeTemp.NodeLabel := 'SPARGE_TEMP';
  FSpargeTemp.DisplayLabel := 'DISPLAY_SPARGE_TEMP';

  FSGLastRunnings := TBFloat.Create(self);
  FSGLastRunnings.vUnit := sg;
  FSGLastRunnings.DisplayUnit := sg;
  FSGLastRunnings.MinValue := 1.000;
  FSGLastRunnings.MaxValue := 1.100;
  FSGLastRunnings.Value := 1.010;
  FSGLastRunnings.Decimals := 3;
  FSGLastRunnings.NodeLabel := 'SG_LAST_RUNNINGS';
  FSGLastRunnings.DisplayLabel := 'DISPLAY_SG_LAST_RUNNINGS';

  FpHLastRunnings := TBFloat.Create(self);
  FpHLastRunnings.vUnit := pH;
  FpHLastRunnings.DisplayUnit := pH;
  FpHLastRunnings.MinValue := 1;
  FpHLastRunnings.MaxValue := 14;
  FpHLastRunnings.Value := 6.0;
  FpHLastRunnings.Decimals := 1;
  FpHLastRunnings.NodeLabel := 'PH_LAST_RUNNINGS';
  FpHLastRunnings.DisplayLabel := 'DISPLAY_PH_LAST_RUNNINGS';

  FpH := TBFloat.Create(self);
  FpH.vUnit := pH;
  FpH.DisplayUnit := pH;
  FpH.MinValue := 1.0;
  FpH.MaxValue := 14.0;
  FpH.Value := 6.0;
  FpH.Decimals := 1;
  FpH.NodeLabel := 'PH';
  FpH.DisplayLabel := '';

  FTunWeight := TBFloat.Create(self);
  FTunWeight.vUnit := kilogram;
  FTunWeight.DisplayUnit := kilogram;
  FTunWeight.MinValue := 0.0;
  FTunWeight.MaxValue := 10000.0;
  FTunWeight.Value := 5;
  FTunWeight.Decimals := 1;
  FTunWeight.NodeLabel := 'TUN_WEIGHT';
  FTunWeight.DisplayLabel := 'DISPLAY_TUN_WEIGHT';

  FTunSpecificHeat := TBFloat.Create(self);
  FTunSpecificHeat.vUnit := calgdeg;
  FTunSpecificHeat.DisplayUnit := calgdeg;
  FTunSpecificHeat.MinValue := 0.05;
  FTunSpecificHeat.MaxValue := 2.000;
  FTunSpecificHeat.Value := 0.110;
  FTunSpecificHeat.Decimals := 3;
  FTunSpecificHeat.NodeLabel := 'TUN_SPECIFIC_HEAT';
  FTunSpecificHeat.DisplayLabel := '';

  FEquipAdjust := TBBoolean.Create(self);
  FEquipAdjust.Value := True;
  FEquipAdjust.NodeLabel := 'EQUIP_ADJUST';
end;

destructor TMash.Destroy;
var
  i: integer;
begin
  for i := Low(FMashSteps) to High(FMashSteps) do
    FMashSteps[i].Free;
  SetLength(FMashSteps, 0);
  FGrainTemp.Free;
  FTunTemp.Free;
  FSpargeTemp.Free;
  FSGLastRunnings.Free;
  FpHLastRunnings.Free;
  FpH.Free;
  FTunWeight.Free;
  FTunSpecificHeat.Free;
  FEquipAdjust.Free;
  inherited;
end;

procedure TMash.Assign(Source: TBase);
var
  i: integer;
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    for i := Low(FMashSteps) to High(FMashSteps) do
      FMashSteps[i].Free;
    SetLength(FMashSteps, TMash(Source).NumMashSteps);
    for i := Low(FMashSteps) to High(FMashSteps) do
    begin
      FMashSteps[i] := TMashStep.Create(FRecipe);
      FMashSteps[i].Assign(TMash(Source).MashStep[i]);
    end;

    FGrainTemp.Assign(TMash(Source).GrainTemp);
    FTunTemp.Assign(TMash(Source).TunTemp);
    FSpargeTemp.Assign(TMash(Source).SpargeTemp);
    FpH.Assign(TMash(Source).pHsparge);
    FSGLastRunnings.Assign(TMash(Source).SGLastRunnings);
    FpHLastRunnings.Assign(TMash(Source).pHLastRunnings);
    FTunWeight.Assign(TMash(Source).TunWeight);
    FTunSpecificHeat.Assign(TMash(Source).TunSpecificHeat);
    FEquipAdjust.Assign(TMash(Source).EquipAdjust);
  end;
end;

function TMash.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FGrainTemp.Value;
    3: Result := FTunTemp.Value;
    4: Result := FTunWeight.Value;
    5: Result := FTunSpecificHeat.Value;
    6: Result := FEquipAdjust.Value;
    7: Result := FSpargeTemp.Value;
    8: Result := FpH.Value;
    9: Result := FSGLastRunnings.Value;
    10: Result := FpHLastRunnings.Value;
  end;
end;

function TMash.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Temperatuur mout' then
    Result := 2
  else if s = 'Temperatuur maischvat' then
    Result := 3
  else if s = 'Massa maischvat' then
    Result := 4
  else if s = 'Warmte-inhoud maischvat' then
    Result := 5
  else if s = 'Reken warmte-inhoud van maischvat mee' then
    Result := 6
  else if s = 'Spoelwatertemperatuur' then
    Result := 7
  else if s = 'pH spoelwater' then
    Result := 8
  else if s = 'SG laatste afloop' then
    Result := 9
  else if s = 'pH laatste afloop' then
    Result := 10;
end;

function TMash.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Temperatuur mout';
    3: Result := 'Temperatuur maischvat';
    4: Result := 'Massa maischvat';
    5: Result := 'Warmte-inhoud maischvat';
    6: Result := 'Reken warmte-inhoud van maischvat mee';
    7: Result := 'Spoelwatertemperatuur';
    8: Result := 'pH spoelwater';
    9: Result := 'SG laatste afloop';
    10: Result := 'pH laatste afloop';
  end;
end;

procedure TMash.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild, iChild2: TDOMNode;
  i: integer;
begin
  iChild := Doc.CreateElement('MASH');
  iNode.AppendChild(iChild);

  inherited SaveXML(Doc, iChild, bxml);

  FGrainTemp.SaveXML(Doc, iChild, bxml);
  FTunTemp.SaveXML(Doc, iChild, bxml);
  FSpargeTemp.SaveXML(Doc, iChild, bxml);
  FSGLastRunnings.SaveXML(Doc, iChild, bxml);
  FpHLastRunnings.SaveXML(Doc, iChild, bxml);
  FpH.SaveXML(Doc, iChild, bxml);
  FTunWeight.SaveXML(Doc, iChild, bxml);
  FTunSpecificHeat.SaveXML(Doc, iChild, bxml);
  FEquipAdjust.SaveXML(Doc, iChild, bxml);

  iChild2 := Doc.CreateElement('MASH_STEPS');
  iChild.AppendChild(iChild2);
  for i := Low(FMashSteps) to High(FMashSteps) do
    FMashSteps[i].SaveXML(Doc, iChild2, bxml);
end;

procedure TMash.ReadXML(iNode: TDOMNode);
var
  i: integer;
  iChild, iChild2: TDOMNode;
begin
  inherited ReadXML(iNode);

  for i := Low(FMashSteps) to High(FMashSteps) do
    FMashSteps[i].Free;
  SetLength(FMashSteps, 0);

  iChild := iNode.FindNode('MASH_STEPS');
  i := 0;
  iChild2 := iChild.FirstChild;
  while iChild2 <> nil do
  begin
    Inc(i);
    SetLength(FMashSteps, i);
    FMashSteps[i - 1] := TMashStep.Create(FRecipe);
    FMashSteps[i - 1].ReadXML(iChild2);
    if (FMashSteps[i-1].FStepTime.Value = 0) and (FMashSteps[i-1].FStepTemp.Value = 30) then
    begin
      FMashSteps[i-1].Free;
      SetLength(FMashSteps, i-1);
      i:= i-1;
    end;
    iChild2 := iChild2.NextSibling;
  end;

  FGrainTemp.ReadXML(iNode);
  FTunTemp.ReadXML(iNode);
  FSpargeTemp.ReadXML(iNode);
  FSGLastRunnings.ReadXML(iNode);
  FpHLastRunnings.ReadXML(iNode);
  FpH.ReadXML(iNode);
  FTunWeight.ReadXML(iNode);
  FTunSpecificHeat.ReadXML(iNode);
  FEquipAdjust.ReadXML(iNode);

  if High(FMashSteps) >= 0 then
    if FMashSteps[0].MashStepType <> mstInfusion then FMashSteps[0].MashStepType := mstInfusion;

  CalcMash;
end;

function TMash.AddMashStep: TMashStep;
begin
  Result := nil;
  SetLength(FMashSteps, High(FMashSteps) + 2);
  FMashSteps[High(FMashSteps)] := TMashStep.Create(FRecipe);
  Result := FMashSteps[High(FMashSteps)];
  CalcMash;
end;

function TMash.InsertMashStep(i: integer): TMashStep;
var
  j: integer;
begin
  Result := nil;
  if (i >= Low(FMashSteps)) and (i <= High(FMashSteps)) then
  begin
    SetLength(FMashSteps, High(FMashSteps) + 2);
    for j := High(FMashSteps) - 1 downto i do
      FMashSteps[j + 1] := FMashSteps[j];
    FMashSteps[i] := nil;
    FMashSteps[i] := TMashStep.Create(FRecipe);
    Result := FMashSteps[i];
    CalcMash;
  end;
end;

procedure TMash.RemoveMashStep(i: integer);
var
  j: integer;
begin
  if (i >= Low(FMashSteps)) and (i <= High(FMashSteps)) then
  begin
    FMashSteps[i].Free;
    for j := i to High(FMashSteps) - 1 do
      FMashSteps[j] := FMashSteps[j + 1];
    SetLength(FMashSteps, High(FMashSteps));
    CalcMash;
  end;
end;

function TMash.GetNumMashSteps: integer;
begin
  Result := High(FMashSteps) + 1;
end;

function TMash.GetMashStep(i: integer): TMashStep;
begin
  Result := nil;
  if (i >= Low(FMashSteps)) and (i <= High(FMashSteps)) then
    Result := FMashSteps[i];
end;

function TMash.GetMashWaterVolume: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FMashSteps) to High(FMashSteps) do
    if FMashSteps[i].MashStepType = mstInfusion then
      Result := Result + FMashSteps[i].InfuseAmount.Value;
end;

procedure TMash.SetMashWaterVolume(V: double);
//var Vol: double;
begin
  if (NumMashSteps > 0) and (V > 0) then
  begin
    FMashSteps[0].InfuseAmount.Value := V;
    CalcMash;
{    Vol := GetMashWaterVolume;
    while (Vol > 1.001 * V) or (Vol < 0.999 * V) do
    begin
      Vol:= Vol + (V - Vol) / 2;
      FMashSteps[0].InfuseAmount.Value := Vol;
      CalcMash;
//      Vol := GetMashWaterVolume;
    end; }
  end;
end;

Procedure TMash.Sort;
  procedure QuickSort(var A: array of TMashStep; iLo, iHi: integer);
  var
    Lo, Hi: integer;
    v: double;
    MS: TMashStep;
  begin
    Lo := iLo;
    Hi := iHi;
    v := A[(Lo + Hi) div 2].StepTemp.Value;
    repeat
      while A[Lo].StepTemp.Value < v do
        Inc(Lo);
      while A[Hi].StepTemp.Value > v do
        Dec(Hi);
      if Lo <= Hi then
      begin
        MS := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := MS;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then
      QuickSort(A, iLo, Hi);
    if Lo < iHi then
      QuickSort(A, Lo, iHi);
  end;

  procedure Selectionsort(var List : array of TMashStep;
                          min, max : integer);
  var
      i, j, best_j : integer;
      best_value   : double;
      MS : TMashStep;
  begin
      for i := min to max - 1 do
      begin
          best_value := List[i].StepTemp.Value;
          best_j := i;
          MS:= List[i];
          for j := i + 1 to max do
          begin
              if (List[j].StepTemp.Value < best_value) Then
              begin
                  best_value := List[j].StepTemp.Value;
                  MS:= List[j];
                  best_j := j;
              end;
          end;    // for j := i + 1 to max do
          List[best_j] := List[i];
          List[i] := MS;
      end;        // for i := min to max - 1 do
  end;

var i : integer;
begin
  if High(FMashSteps) > 0 then
  begin
    SelectionSort(FMashSteps, 0, High(FMashSteps));
    //    QuickSort(FMashSteps, 0, High(FMashSteps));
    FMashSteps[0].PriorStep:= NIL;
    for i:= 1 to High(FMashSteps) do
    begin
      FMashSteps[i-1].NextStep:= FMashSteps[i];
      FMashSteps[i].PriorStep:= FMashSteps[i-1];
    end;
    FMashSteps[High(FMashSteps)].NextStep:= NIL;
  end;
end;

procedure TMash.CalcMash;
var i: integer;
begin
  if High(FMashSteps) >= 0 then
  begin
    FMashSteps[0].PriorStep:= NIL;
    for i := Low(FMashSteps) + 1 to High(FMashSteps) do
    begin
      FMashSteps[i].PriorStep := FMashSteps[i - 1];
      FMashSteps[i - 1].NextStep := FMashSteps[i];
    end;
    FMashSteps[High(FMashSteps)].NextStep:= NIL;
    for i := Low(FMashSteps) to High(FMashSteps) do
      FMashSteps[i].CalcStep;
  end;
end;

function TMash.TotalMashTime: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FMashSteps) to High(FMashSteps) do
    Result := Result + FMashSteps[i].RampTime.Value + FMashSteps[i].StepTime.Value;
end;

function TMash.AverageTemperature: double;
var
  i: integer;
  MS: TMashStep;
  tot, tme, TotTme: double;
begin
  Result := 0;
  tot := 0;
  Tme:= 0; TotTme:= 0;
  for i := 0 to NumMashSteps - 1 do
  begin
    MS := MashStep[i];
    if MS.StepTemp.Value > 59 then
    begin
      tot := tot + MS.StepTime.Value * (MS.StepTemp.Value + MS.EndTemp.Value) / 2;
      Tme := Tme + MS.StepTime.Value;
      TotTme := TotTme + MS.StepTime.Value + MS.RampTime.Value;
    end;
  end;
  if Tme <> 0 then
    Result := tot / Tme;
end;

Function TMash.TimeBelow65 : double;
var
  i: integer;
  MS, MS2: TMashStep;
  pt: double;
begin
  Result := 0;
  pt:= 0;
  MS:= NIL;
  for i := 0 to NumMashSteps - 1 do
  begin
    MS2:= MS;
    MS := MashStep[i];
    if ((MS.StepTemp.Value > 59) and (MS.StepTemp.Value <= 65)) or
     ((MS.EndTemp.Value > 59) and (MS.EndTemp.Value <= 65)) then
    begin
      if ((MS.StepTemp.Value > 59) and (MS.StepTemp.Value <= 65)) AND
         ((MS.EndTemp.Value > 59) and (MS.EndTemp.Value <= 65)) then
         pt:= 1
      else if ((MS.EndTemp.Value > 59) and (MS.EndTemp.Value <= 65)) then
        pt:= (65 - MS.EndTemp.Value) / Abs((MS.StepTemp.Value - MS.EndTemp.Value))
      else
        pt:= (65 - MS.StepTemp.Value) / Abs((MS.StepTemp.Value - MS.EndTemp.Value));
      Result:= Result + pt * MS.StepTime.Value;
    end;

    //ramp trajectory
    if (MS2 <> NIL) then
      if ((MS.StepTemp.Value > 59) and (MS.StepTemp.Value <= 65)) or
         ((MS2.EndTemp.Value > 59) and (MS2.EndTemp.Value <= 65)) then
      begin
         if ((MS.StepTemp.Value > 59) and (MS.StepTemp.Value <= 65)) AND
            ((MS2.EndTemp.Value > 59) and (MS2.EndTemp.Value <= 65)) then
            pt:= 1
         else if ((MS2.EndTemp.Value > 59) and (MS2.EndTemp.Value <= 65)) then
           pt:= (65 - MS2.EndTemp.Value) / Abs((MS.StepTemp.Value - MS2.EndTemp.Value))
         else
           pt:= (65 - MS.StepTemp.Value) / Abs((MS.StepTemp.Value - MS2.EndTemp.Value));
         Result:= Result + pt * MS.RampTime.Value;
      end;
  end;
end;

Function TMash.TimeAbove65 : double;
var
  i: integer;
  MS, MS2: TMashStep;
  pt: double;
begin
  Result := 0;
  pt:= 0;
  MS:= NIL;
  for i := 0 to NumMashSteps - 1 do
  begin
    MS2:= MS;
    MS := MashStep[i];
    if ((MS.StepTemp.Value > 65) and (MS.StepTemp.Value <= 75)) or
     ((MS.EndTemp.Value > 65) and (MS.EndTemp.Value <= 75)) then
    begin
      if ((MS.StepTemp.Value > 65) and (MS.StepTemp.Value <= 75)) AND
         ((MS.EndTemp.Value > 65) and (MS.EndTemp.Value <= 75)) then
         pt:= 1
      else if ((MS.EndTemp.Value > 65) and (MS.EndTemp.Value <= 75)) then
        pt:= (MS.EndTemp.Value - 65) / Abs((MS.StepTemp.Value - MS.EndTemp.Value))
      else
        pt:= (MS.StepTemp.Value - 65) / Abs((MS.StepTemp.Value - MS.EndTemp.Value));
      Result:= Result + pt * MS.StepTime.Value;
    end;

    //ramp trajectory
    if (MS2 <> NIL) then
      if ((MS.StepTemp.Value > 65) and (MS.StepTemp.Value <= 75)) or
         ((MS2.EndTemp.Value > 65) and (MS2.EndTemp.Value <= 75)) then
      begin
         if ((MS.StepTemp.Value > 65) and (MS.StepTemp.Value <= 75)) AND
            ((MS2.EndTemp.Value > 65) and (MS2.EndTemp.Value <= 75)) then
            pt:= 1
         else if ((MS2.EndTemp.Value > 65) and (MS2.EndTemp.Value <= 75)) then
           pt:= (MS2.EndTemp.Value - 65) / Abs((MS.StepTemp.Value - MS2.EndTemp.Value))
         else
           pt:= (MS.StepTemp.Value - 65) / Abs((MS.StepTemp.Value - MS2.EndTemp.Value));
         Result:= Result + pt * MS.RampTime.Value;
      end;
  end;
end;

function TMash.GetSpargeVolume: double;
var
  volmalt, spdspc, mashvol, vol: double;
begin
  volMalt := FRecipe.GrainMassMash * Settings.GrainAbsorption.Value;
  spdspc := FRecipe.Equipment.LauterDeadSpace.Value;
  mashvol := MashWaterVolume; // / ExpansionFactor;
  vol:= FRecipe.BoilSize.Value - mashvol + volmalt + spdspc;

//  vol := Vol * ExpansionFactor;
  Result := Convert(FRecipe.BatchSize.vUnit, liter, vol);
end;

{=========================== FermMeasurement ==================================}

constructor TFermMeasurement.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtMeasurements;

  FDateTime := TBDateTime.Create(self);
  FDateTime.NodeLabel := 'DATE_TIME';

  FTempS1 := TBFloat.Create(self);
  FTempS1.vUnit := celcius;
  FTempS1.DisplayUnit := celcius;
  FTempS1.MinValue := -20.0;
  FTempS1.MaxValue := 40.0;
  FTempS1.Value := 0;
  FTempS1.Decimals := 1;
  FTempS1.NodeLabel := 'TEMP_SENSOR_1';
  FTempS1.DisplayLabel := 'DISPLAY_TEMP_SENSOR_1';

  FSetPoint := TBFloat.Create(self);
  FSetPoint.vUnit := celcius;
  FSetPoint.DisplayUnit := celcius;
  FSetPoint.MinValue := -20.0;
  FSetPoint.MaxValue := 40.0;
  FSetPoint.Value := 0;
  FSetPoint.Decimals := 1;
  FSetPoint.NodeLabel := 'SETPOINT';
  FSetPoint.DisplayLabel := 'DISPLAY_SETPOINT';

  FCoolpower := TBFloat.Create(self);
  FCoolpower.vUnit := watt;
  FCoolpower.DisplayUnit := watt;
  FCoolpower.MinValue := 0;
  FCoolpower.MaxValue := 2000.0;
  FCoolpower.Value := 0;
  FCoolpower.Decimals := 0;
  FCoolpower.NodeLabel := 'COOLPOWER';
  FCoolpower.DisplayLabel := 'DISPLAY_COOLPOWER';

  FCooling := TBInteger.Create(self);
  FCooling.Value := 0;
  FCooling.NodeLabel := 'COOLING';
  FCooling.MinValue := 0;
  FCooling.MaxValue := 10;

  FTempS2 := TBFloat.Create(self);
  FTempS2.vUnit := celcius;
  FTempS2.DisplayUnit := celcius;
  FTempS2.MinValue := -20.0;
  FTempS2.MaxValue := 40.0;
  FTempS2.Value := 0;
  FTempS2.Decimals := 1;
  FTempS2.NodeLabel := 'TEMP_SENSOR_2';
  FTempS2.DisplayLabel := 'DISPLAY_TEMP_SENSOR_2';

  FCO2 := TBFloat.Create(self);
  FCO2.vUnit := lph;
  FCO2.DisplayUnit := lph;
  FCO2.MinValue := 0;
  FCO2.MaxValue := 1000.0;
  FCO2.Value := 0;
  FCO2.Decimals := 1;
  FCO2.NodeLabel := 'CO2_1';
  FCO2.DisplayLabel := 'DISPLAY_CO2_1';

  FSG := TBFloat.Create(self);
  FSG.vUnit := SG;
  FSG.DisplayUnit := SG;
  FSG.MinValue := 0;
  FSG.MaxValue := 1.300;
  FSG.Value := 0;
  FSG.Decimals := 3;
  FSG.NodeLabel := 'SG';
  FSG.DisplayLabel := 'DISPLAY_SG';

  FHeating := TBInteger.Create(self);
  FHeating.Value := 0;
  FHeating.NodeLabel := 'HEATING';
  FHeating.MinValue := 0;
  FHeating.MaxValue := 10;

  FCO22 := TBFloat.Create(self);
  FCO22.vUnit := lph;
  FCO22.DisplayUnit := lph;
  FCO22.MinValue := 0;
  FCO22.MaxValue := 1000.0;
  FCO22.Value := 0;
  FCO22.Decimals := 1;
  FCO22.NodeLabel := 'CO2_2';
  FCO22.DisplayLabel := 'DISPLAY_CO2_2';
end;

destructor TFermMeasurement.Destroy;
begin
  FDateTime.Free;
  FTempS1.Free;
  FSetPoint.Free;
  FCoolpower.Free;
  FCooling.Free;
  FTempS2.Free;
  FCO2.Free;
  FSG.Free;
  FHeating.Free;
  FCO22.Free;
  inherited;
end;

procedure TFermMeasurement.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild: TDOMNode;
begin
  if FDateTime.Value > 0 then
  begin
    iChild := Doc.CreateElement('FERM_MEASUREMENT');
    iNode.AppendChild(iChild);
    inherited SaveXML(Doc, iChild, bxml);
    FDateTime.SaveXML(Doc, iChild, bxml);
    FTempS1.SaveXML(Doc, iChild, bxml);
    FSetPoint.SaveXML(Doc, iChild, bxml);
    FCoolpower.SaveXML(Doc, iChild, bxml);
    FCooling.SaveXML(Doc, iChild, bxml);
    FTempS2.SaveXML(Doc, iChild, bxml);
    FCO2.SaveXML(Doc, iChild, bxml);
    FSG.SaveXML(Doc, iChild, bxml);
    FHeating.SaveXML(Doc, iChild, bxml);
    FCO22.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TFermMeasurement.ReadXML(iNode: TDOMNode);
begin
  inherited ReadXML(iNode);
  FDateTime.ReadXML(iNode);
  FTempS1.ReadXML(iNode);
  FSetPoint.ReadXML(iNode);
  FCoolpower.ReadXML(iNode);
  FCooling.ReadXML(iNode);
  FTempS2.ReadXML(iNode);
  FCO2.ReadXML(iNode);
  FSG.ReadXML(iNode);
  FHeating.ReadXML(iNode);
  FCO22.ReadXML(iNode);
end;

procedure TFermMeasurement.Assign(Source: TBase);
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    FDateTime.Assign(TFermMeasurement(Source).DateTime);
    FTempS1.Assign(TFermMeasurement(Source).TempS1);
    FSetPoint.Assign(TFermMeasurement(Source).SetPoint);
    FCoolpower.Assign(TFermMeasurement(Source).Coolpower);
    FCooling.Assign(TFermMeasurement(Source).Cooling);
    FTempS2.Assign(TFermMeasurement(Source).TempS2);
    FCO2.Assign(TFermMeasurement(Source).CO2);
    FSG.Assign(TFermMeasurement(Source).SGmeas);
    FHeating.Assign(TFermMeasurement(Source).Heating);
    FCO22.Assign(TFermMeasurement(Source).CO22);
  end;
end;

function TFermMeasurement.GetValueByIndex(i: integer): variant;
begin
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FDateTime.Value;
    3: Result := FTempS1.Value;
    4: Result := FSetpoint.Value;
    5: Result := FCoolpower.Value;
    6: Result := FCooling.Value;
    7: Result := FTempS2.Value;
    8: Result := FCO2.Value;
    9: Result := FSG.Value;
    10: Result := FHeating.Value;
    11: Result := FCO22.Value;
  end;
end;

function TFermMeasurement.GetDisplayStringByIndex(i: integer): string;
begin
  Result := '';
  case i of
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: if FDateTime.Value > 0 then
        Result := FDateTime.DisplayString;
    3: if FTempS1.Value > FTempS1.MinValue then
        Result := FTempS1.DisplayString;
    4: if FSetpoint.Value > FSetpoint.MinValue then
        Result := FSetpoint.DisplayString;
    5: if FCoolpower.Value > FCoolpower.MinValue then
        Result := FCoolpower.DisplayString;
    6: if FCooling.Value = 0 then
        Result := 'uit'
      else
        Result := 'aan';
    7: if FTempS2.Value > FTempS2.MinValue then
        Result := FTempS2.DisplayString;
    8: if FCO2.Value > FCO2.MinValue then
        Result := FCO2.DisplayString;
    9: if FSG.Value > FSG.MinValue then
        Result := FSG.DisplayString;
    10: if FHeating.Value = 0 then
        Result := 'uit'
      else
        Result := 'aan';
    11: if FCO22.Value > FCO22.MinValue then
        Result := FCO22.DisplayString;
  end;
end;

procedure TFermMeasurement.SetDisplayStringByIndex(i: integer; s: string);
begin
  if s <> '' then
    case i of
      0: FName.Value := s;
      1: FNotes.Value := s;
      2: FDateTime.DisplayString := s;
      3: FTempS1.DisplayString := s;
      4: FSetpoint.DisplayString := s;
      5: FCoolpower.DisplayString := s;
      6: if s = 'uit' then
          FCooling.Value := 0
        else
          FCooling.Value := 10;
      7: FTempS2.DisplayString := s;
      8: FCO2.DisplayString := s;
      9: FSG.DisplayString := s;
      10: if s = 'uit' then
          FHeating.Value := 0
        else
          FHeating.Value := 10;
      11: FCO22.DisplayString := s;
    end;
end;

function TFermMeasurement.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Tijdstip' then
    Result := 2
  else if s = 'Temperatuur sensor 1' then
    Result := 3
  else if s = 'Instellingstemperatuur' then
    Result := 4
  else if s = 'Koelvermogen' then
    Result := 5
  else if s = 'Koelen?' then
    Result := 6
  else if s = 'Temperatuur sensor 2' then
    Result := 7
  else if s = 'Koolzuurdebiet' then
    Result := 8
  else if s = 'SG' then
    Result := 9
  else if s = 'Verwarmen?' then
    Result := 10
  else if s = 'Koolzuurdebiet 2' then
    Result := 11;
end;

function TFermMeasurement.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Temperatuur sensor 1';
    3: Result := 'Instellingstemperatuur';
    4: Result := 'Koelvermogen';
    5: Result := 'Koelen?';
    6: Result := 'Reken warmte-inhoud van maischvat mee';
    7: Result := 'Temperatuur sensor 2';
    8: Result := 'Koolzuurdebiet';
    9: Result := 'SG';
    10: Result := 'Verwarmen?';
    11: Result := 'Koolzuurdebiet 2';
  end;
end;

{=========================== FermMeasurements =================================}

constructor TFermMeasurements.Create(R: TRecipe);
begin
  inherited Create(R);
  SetLength(FMeasurements, 0);
end;

destructor TFermMeasurements.Destroy;
begin
  Clear;
  inherited;
end;

procedure TFermMeasurements.Clear;
var
  i: integer;
begin
  for i := Low(FMeasurements) to High(FMeasurements) do
    FMeasurements[i].Free;
  SetLength(FMeasurements, 0);
end;

procedure TFermMeasurements.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  i: integer;
  iChild: TDOMNode;
begin
  if NumMeasurements > 0 then
  begin
    inherited SaveXML(Doc, iNode, bxml);

    iChild := Doc.CreateElement('FERM_MEASUREMENTS');
    iNode.AppendChild(iChild);

    for i := Low(FMeasurements) to High(FMeasurements) do
      FMeasurements[i].SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TFermMeasurements.ReadXML(iNode: TDOMNode);
var
  i: integer;
  iChild, iChild2: TDOMNode;
begin
  inherited ReadXML(iNode);

  for i := Low(FMeasurements) to High(FMeasurements) do
    FMeasurements[i].Free;
  SetLength(FMeasurements, 0);

  iChild := iNode.FindNode('FERM_MEASUREMENTS');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FMeasurements, i);
      FMeasurements[i - 1] := TFermMeasurement.Create(FRecipe);
      FMeasurements[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;
end;

function TFermMeasurements.AddMeasurement: TFermMeasurement;
begin
  Result := nil;
  SetLength(FMeasurements, High(FMeasurements) + 2);
  FMeasurements[High(FMeasurements)] := TFermMeasurement.Create(FRecipe);
  Result := TFermMeasurement(FMeasurements[High(FMeasurements)]);
  Sort;
end;

procedure TFermMeasurements.RemoveMeasurement(i: integer);
var
  j: integer;
begin
  if (i >= Low(FMeasurements)) and (i <= High(FMeasurements)) then
  begin
    FMeasurements[i].Free;
    for j := i to High(FMeasurements) - 1 do
      FMeasurements[j] := FMeasurements[j + 1];
    SetLength(FMeasurements, High(FMeasurements));
  end;
end;

procedure TFermMeasurements.Assign(Source: TBase);
var
  i: integer;
begin
  if Source <> nil then
  begin
    inherited Assign(Source);
    for i := Low(FMeasurements) to High(FMeasurements) do
      FMeasurements[i].Free;

    SetLength(FMeasurements, TFermMeasurements(Source).NumMeasurements);
    for i := Low(FMeasurements) to High(FMeasurements) do
    begin
      FMeasurements[i] := TFermMeasurement.Create(FRecipe);
      FMeasurements[i].Assign(TFermMeasurements(Source).Measurement[i]);
    end;
  end;
end;

function TFermMeasurements.GetMeasurement(i: integer): TFermMeasurement;
begin
  Result := nil;
  if (i >= Low(FMeasurements)) and (i <= High(FMeasurements)) then
    Result := TFermMeasurement(FMeasurements[i]);
end;

function TFermMeasurements.GetNumMeasurements: integer;
begin
  Result := High(FMeasurements) + 1;
end;

function TFermMeasurements.IsEmpty(index: integer): boolean;
var
  i: integer;
begin
  Result := True;
  for i := Low(FMeasurements) to High(FMeasurements) do
    if FMeasurements[i].ValueByIndex[index] > 0 then
    begin
      Result := False;
      Exit;
    end;
end;

procedure TFermMeasurements.Sort;

  procedure QuickSort(var A: TBaseArray; iLo, iHi: integer);
  var
    Lo, Hi: integer;
    DT: TDateTime;
    FM: TFermMeasurement;
  begin
    Lo := iLo;
    Hi := iHi;
    DT := TFermMeasurement(A[(Lo + Hi) div 2]).DateTime.Value;
    repeat
      while TFermMeasurement(A[Lo]).DateTime.Value < DT do
        Inc(Lo);
      while TFermMeasurement(A[Hi]).DateTime.Value > DT do
        Dec(Hi);
      if Lo <= Hi then
      begin
        FM := TFermMeasurement(A[Lo]);
        A[Lo] := A[Hi];
        A[Hi] := FM;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then
      QuickSort(A, iLo, Hi);
    if Lo < iHi then
      QuickSort(A, Lo, iHi);
  end;

begin
  if High(FMeasurements) > -1 then
    QuickSort(FMeasurements, Low(FMeasurements), High(FMeasurements));
end;

{=========================== ChecklistItem ====================================}

constructor TCheckListItem.Create(R: TRecipe);
begin
  Inherited Create(R);
  FItem:= TBBoolean.Create(self);
  FItem.FCaption:= '';
  FItem.NodeLabel:= 'CHECKLIST_ITEM';
  FItem.Value:= false;
end;

destructor TCheckListItem.Destroy;
begin
  FItem.Free;
  Inherited;
end;

procedure TCheckListItem.Assign(Source: TBase);
begin
  Inherited Assign(Source);
  FItem.Assign(TCheckListItem(Source).Item);
end;

procedure TCheckListItem.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var iChild: TDOMNode;
begin
  iChild := Doc.CreateElement('CHECKLISTITEM');
  iNode.AppendChild(iChild);
  FItem.SaveXML(Doc, iChild, bxml);
end;

procedure TCheckListItem.ReadXML(iNode: TDOMNode);
begin
  FItem.ReadXML(iNode);
end;

{=========================== ChecklistItem ====================================}


constructor TCheckListGroup.Create(R: TRecipe);
begin
  Inherited Create(R);
  FCaption:= TBString.Create(self);
  FCaption.Value:= '';
  FCaption.NodeLabel:= 'CHECKLIST_GROUP_CAPTION';
end;

destructor TCheckListGroup.Destroy;
begin
  Clear;
  FCaption.Free;
  Inherited;
end;

procedure TCheckListGroup.Assign(Source: TBase);
var i : integer;
    Grp : TCheckListGroup;
    It, Ito : TCheckListItem;
begin
  Clear;
  Grp:= TCheckListGroup(Source);
  SetLength(FItems, Grp.NumItems);
  for i:= 0 to Grp.NumItems - 1 do
  begin
    FItems[i]:= TCheckListItem.Create(FRecipe);
    It:= FItems[i];
    Ito:= Grp.Item[i];
    It.Assign(Ito);
  end;
  FCaption.Assign(Grp.Caption);
end;

procedure TCheckListGroup.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var i : LongInt;
    iChild, iChild2: TDOMNode;
begin
  if NumItems > 0 then
  begin
    iChild := Doc.CreateElement('CHECKLISTGROUP');
    iNode.AppendChild(iChild);

    iChild2:= Doc.CreateElement('ITEMS');
    iChild.AppendChild(iChild2);

    for i := Low(FItems) to High(FItems) do
      FItems[i].SaveXML(Doc, iChild2, bxml);

    FCaption.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TCheckListGroup.ReadXML(iNode: TDOMNode);
var i: integer;
    iChild, iChild2: TDOMNode;
begin
  Clear;
  if iNode <> nil then
  begin
    i := 0;
    iChild := iNode.FindNode('ITEMS');
    if iChild <> NIL then
    begin
      iChild2:= iChild.FirstChild;
      while iChild2 <> nil do
      begin
        Inc(i);
        SetLength(FItems, i);
        FItems[i - 1] := TCheckListItem.Create(FRecipe);
        FItems[i - 1].ReadXML(iChild2);
        iChild2 := iChild2.NextSibling;
      end;
      FCaption.ReadXML(iNode);
    end;
  end;
end;

function TCheckListGroup.AddItem : TCheckListItem;
begin
  Result:= NIL;
  SetLength(FItems, High(FItems) + 2);
  FItems[High(FItems)]:= TCheckListItem.Create(FRecipe);
  Result:= FItems[High(FItems)];
end;

procedure TCheckListGroup.RemoveItem(i : integer);
var j : integer;
begin
  if (i >= 0) and (i <= High(FItems)) then
  begin
    FItems[i].Free;
    for j:= i to High(FItems) - 1 do
      FItems[j]:= FItems[j+1];
    SetLength(FItems, High(FItems));
  end;
end;

procedure TCheckListGroup.Clear;
var i : integer;
begin
  for i:= Low(FItems) to High(FItems) do
    FItems[i].Free;
  SetLength(FItems, 0);
end;

Function TCheckListGroup.GetItem(i : integer) : TCheckListItem;
begin
  Result:= NIL;
  if (i >= Low(FItems)) and (i <= High(FItems)) then
    Result:= FItems[i];
end;

Function TCheckListGroup.GetNumItems : integer;
begin
  Result:= High(FItems) + 1;
end;

Function TCheckListGroup.GetNumItemsChecked : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FItems) to High(FItems) do
    if FItems[i].Item.Value then
      Inc(Result);
end;

Function TCheckListGroup.GetChecked(i : integer) : boolean;
begin
  Result:= false;
  if (i >= Low(FItems)) and (i <= High(FItems)) then
    Result:= FItems[i].Item.Value;
end;

procedure TCheckListGroup.SetChecked(i : integer; b : boolean);
begin
  if (i >= Low(FItems)) and (i <= High(FItems)) then
    FItems[i].Item.Value:= b;
end;


{=========================== Checklist ========================================}

constructor TCheckList.Create(R: TRecipe);
begin
  Inherited Create(R);
end;

destructor TCheckList.Destroy;
begin
  Clear;
  Inherited;
end;

procedure TCheckList.Assign(Source: TBase);
var i : integer;
begin
  if Source <> NIL then
  begin
    Clear;
    i:= TCheckList(Source).NumGroups;
    SetLength(FGroups, i);
    for i:= 0 to i-1 do
    begin
      FGroups[i]:= TCheckListGroup.Create(FRecipe);
      FGroups[i].Assign(TCheckList(Source).Group[i]);
    end;
  end
  else
    Clear;
end;

procedure TCheckList.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var i : LongInt;
    iChild, iChild2: TDOMNode;
begin
  if (NumGroups > 0) and (NumItemsChecked > 0) then
  begin
    iChild := Doc.CreateElement('CHECKLIST');
    iNode.AppendChild(iChild);

    iChild2:= Doc.CreateElement('GROUPS');
    iChild.AppendChild(iChild2);

    for i := Low(FGroups) to High(FGroups) do
      FGroups[i].SaveXML(Doc, iChild2, bxml);
  end;
end;

procedure TCheckList.ReadXML(iNode: TDOMNode);
var i: integer;
    iChild, iChild2, iChild3: TDOMNode;
begin
  Clear;
  iChild := iNode.FindNode('CHECKLIST');
  if iChild <> nil then
  begin
    iChild2:= iChild.FindNode('GROUPS');
    if iChild2 <> NIL then
    begin
      i := 0;
      iChild3 := iChild2.FirstChild;
      while iChild3 <> nil do
      begin
        Inc(i);
        SetLength(FGroups, i);
        FGroups[i - 1] := TCheckListGroup.Create(FRecipe);
        FGroups[i - 1].ReadXML(iChild3);
        iChild3 := iChild3.NextSibling;
      end;
    end;
  end;
end;

Function TCheckList.GetGroup(i : integer) : TCheckListGroup;
begin
  Result:= NIL;
  if (i >= 0) and (i <= High(FGroups)) then
    Result:= FGroups[i];
end;

Function TCheckList.GetNumGroups : integer;
begin
  Result:= High(FGroups) + 1;
end;

function TCheckList.AddGroup : TCheckListGroup;
begin
  Result:= NIL;
  SetLength(FGroups, High(FGroups) + 2);
  FGroups[High(FGroups)]:= TCheckListGroup.Create(FRecipe);
  Result:= FGroups[High(FGroups)];
end;

procedure TCheckList.RemoveGroup(i : integer);
var j : integer;
begin
  if (i >= 0) and (i <= High(FGroups)) then
  begin
    FGroups[i].Free;
    for j:= i to High(FGroups) - 1 do
      FGroups[j]:= FGroups[j+1];
    SetLength(FGroups, High(FGroups));
  end;
end;

Function TCheckList.GetNumItems : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FGroups) to High(FGroups) do
    Result:= Result + FGroups[i].NumItems;
end;

Function TCheckList.GetNumItemsChecked : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FGroups) to High(FGroups) do
    Result:= Result + FGroups[i].NumItemsChecked;
end;

procedure TCheckList.Clear;
var i : integer;
begin
  for i:= Low(FGroups) to High(FGroups) do
    FGroups[i].Free;
  SetLength(FGroups, 0);
end;

Function TCheckList.HasChanged(CL : TCheckList) : boolean;
var i, j : integer;
    CG : TCheckListGroup;
    st1, st2 : string;
begin
  Result:= false;
  if NumGroups <> CL.NumGroups then
  begin
    Result:= TRUE;
    Exit;
  end;
  for i:= 0 to NumGroups - 1 do
  begin
    CG:= GetGroup(i);
    st1:= LowerCase(Trim(CG.Caption.Value));
    st2:= LowerCase(Trim(CL.Group[i].Caption.Value));
    if (st1 <> st2) or (CG.NumItems <> CL.Group[i].NumItems) then
    begin
      Result:= TRUE;
      Exit;
    end;
    for j:= 0 to CG.NumItems - 1 do
    begin
      st1:= Lowercase(Trim(CL.Group[i].Item[j].Item.Caption));
      st2:= Lowercase(Trim(CG.Item[j].Item.Caption));
      if st1 <> st2 then
      begin
        Result:= TRUE;
        Exit;
      end;
    end;
  end;
end;

procedure TCheckList.CreateCheckList;
var NewCL : TCheckList;
begin
  if NumGroups = 0 then
    DoCreateCheckList(self)
  else //check if anything in the recipe has changed and therefore the checklist has changed
  begin
    NewCL:= TCheckList.Create(FRecipe);
    DoCreateCheckList(NewCL);
    if HasChanged(NewCL) then
      self.Assign(NewCL); //if so, use the newly created checklist
    FreeAndNIL(NewCL);
  end;
end;

procedure TCheckList.DoCreateCheckList(CL : TCheckList);
type
  TIngrListItem = record
    Time : integer;
    Caption : string;
    IngrType : TIngredientType;
  end;

  TIngrListArray = array of TIngrListItem;

var IngrListArray : TIngrListArray;
    i, j, n : integer;
    v : double;
    s, ch : string;
    M : TMisc;
    F : TFermentable;
    H : THop;
    MS : TMashStep;
    numsalts : longint;
    CLG : TCheckListGroup;
    CLI : TCheckListItem;
    Tm : TDateTime;

  procedure SelectionsortDec(var List : TIngrListArray;
                             min, max : integer);
  var
      i, j, best_j : integer;
      best_value   : integer;
      TB : TIngrListItem;
  begin
      for i := min to max - 1 do
      begin
          best_value := List[i].Time;
          best_j := i;
          TB:= List[i];
          for j := i + 1 to max do
          begin
              if (List[j].Time > best_value) Then
              begin
                  best_value := List[j].Time;
                  TB:= List[j];
                  best_j := j;
              end;
          end;
          List[best_j] := List[i];
          List[i] := TB;
      end;
  end;
begin
  if FRecipe <> NIL then
  begin
    i:= CL.NumItemsChecked;
    if (i = 0) then
    begin
      CL.Clear;
      //Water en waterbehandeling
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Water en -behandeling';

      for i:= 0 to FRecipe.NumWaters - 1 do
      begin
        s:= FRecipe.Water[i].Name.Value;
        j:= FindPart('water', LowerCase(s));
        if j = 0 then
        begin
          ch:= rightstr(s, 1);
          if (ch = 'a') or (ch = 'e') or (ch = 'i') or (ch = 'o') or (ch = 'u')
              or (ch = 's') then
            s:= s + '''';
          if ch = 's' then
            s:= s + ' water'
          else
            s:= s + 's water';
        end;
        s:= FRecipe.Water[i].Amount.DisplayString + ' ' + s;
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
      end;
      numsalts:= 0;
      for i:= 0 to FRecipe.NumMiscs - 1 do
      begin
        M:= FRecipe.Misc[i];
        if M.MiscType = mtWaterAgent then
        begin
          s:= M.Amount.DisplayString + ' ' + M.Name.Value;
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
          Inc(numsalts);
        end;
      end;

      //Mout afwegen en schroten
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Mout afwegen en schroten';
      for i:= 0 to FRecipe.NumFermentables - 1 do
      begin
        F:= FRecipe.Fermentable[i];
        if F.AddedType = atMash then
        begin
          s:= F.Amount.DisplayString + ' ' + F.Name.Value;
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
        end;
      end;
      s:= 'mout schroten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;

      //Maischen
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Maischen';
      if (FRecipe.Mash <> NIL) and (FRecipe.Mash.NumMashSteps > 0) then
      begin
        s:= FRecipe.Mash.MashStep[0].InfuseAmount.DisplayString
            + ' maischwater opwarmen tot '
            + FRecipe.Mash.MashStep[0].InfuseTemp.DisplayString;
        v:= FRecipe.Mash.MashStep[0].InfuseAmount.Value;
        v:= FRecipe.Equipment.CmInTun(v);
        s:= s + ' (' + RealToStrDec(v, 1) + ' cm onder de rand)';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        if numsalts > 0 then
        begin
          s:= 'brouwzouten en -zuren toevoegen';
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
        end;
        s:= 'mout storten';
        if FRecipe.NumHopsMash > 0 then s:= s + ' en maischhop toevoegen';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        MS:= FRecipe.Mash.MashStep[0];
        s:= MS.DisplayString;
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        s:= 'pH meten en bijstellen (doel pH beslag: '
            + FRecipe.TargetpH.DisplayString + ')';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        if FRecipe.Mash.NumMashSteps > 1 then
          for i:= 1 to FRecipe.Mash.NumMashSteps - 1 do
          begin
            MS:= FRecipe.Mash.MashStep[i];
            if MS.MashStepType = mstInfusion then
            begin
              s:= 'toevoegen ' + MS.InfuseAmount.Displaystring + ' water van ' + MS.InfuseTemp.DisplayString;
              CLI:= CLG.AddItem;
              CLI.Item.Caption:= s;
            end
            else if MS.MashStepType = mstDecoction then
            begin
              s:= 'uitnemen, opwarmen, koken en terugstorten van ' + MS.InfuseAmount.Displaystring + ' deelbeslag';
              CLI:= CLG.AddItem;
              CLI.Item.Caption:= s;
            end
            else
            begin
              s:= 'opwarmen tot ' + MS.StepTemp.DisplayString;
              CLI:= CLG.AddItem;
              CLI.Item.Caption:= s;
            end;
            s:= MS.DisplayString;
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        v:= FRecipe.SGEndMashCalc;
        s:= 'doel sg eind maischen: ' + RealToStrDec(v, 3) + ' SG (' +
            RealToStrDec(SGtoBrix(v), 1) + ' °Brix; ' + RealToStrDec(SGtoPlato(v), 1) + ' °P)';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;

        //Filteren en spoelen
        CLG:= CL.AddGroup;
        CLG.Caption.Value:= 'Filteren en spoelen';

        v:= FRecipe.Mash.SpargeVolume;
        {if v < FRecipe.VolumeHLT.Value then
          v:= FRecipe.VolumeHLT.Value;}
        s:= RealToStrDec(v, 1)
            + ' ' + UnitNames[FRecipe.BatchSize.DisplayUnit] + ' spoelwater opwarmen';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        s:= 'spoelwater aanzuren tot pH <= 6.0 ';
        if FRecipe.AcidSparge.Value > 0 then
          s:= s + 'met ' + FRecipe.AcidSparge.DisplayString
              + ' ' + FRecipe.AcidSpargeTypeDisplayName;
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        s:= 'spoelen met ' + RealToStrDec(FRecipe.Mash.SpargeVolume, 1) + ' '
            + UnitNames[FRecipe.BatchSize.DisplayUnit] + ' water';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        s:= 'doelvolume in kookketel: ' + RealToStrDec(ExpansionFactor * FRecipe.BoilSize.DisplayValue, 1)
            + ' ' + UnitNames[FRecipe.BatchSize.DisplayUnit];
        v:= FRecipe.Equipment.CmInKettle(ExpansionFactor * FRecipe.BoilSize.Value);
        s:= s + ' (' + RealToStrDec(v, 1) + ' cm onder de rand)';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        v:= FRecipe.SGStartBoil;
        s:= 'doel SG in kookketel: ' + RealToStrDec(v, 3) + ' SG (' +
            RealToStrDec(SGtoBrix(v), 1) + ' °Brix; ' + RealToStrDec(SGtoPlato(v), 1) + ' °P)';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
      end;

      //Koken
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Koken';

      for i:= 0 to FRecipe.NumHops - 1 do
      begin
        H:= FRecipe.Hop[i];
        if H.Use = huFirstWort then
        begin
          s:= H.Amount.DisplayString + ' ' + H.Name.Value
              + ' ('+ H.Alfa.DisplayString + ') toevoegen voor koken';
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
        end;
      end;
      s:= 'totale kooktijd: ' + FRecipe.BoilTime.Displaystring;
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;

      n:= -1;
      for i:= 0 to FRecipe.NumHops - 1 do
      begin
        H:= FRecipe.Hop[i];
        if (H.Use = huBoil) or (H.Use = huAroma) then
        begin
          Inc(n);
          SetLength(IngrListArray, n+1);
          Tm:= H.Time.Value;
//          DecodeTime(H.Time.Value, ho, mi, se, mis);
          IngrListArray[n].Time:= Round(Tm);
          if H.Time.Value > 0 then
            s:= H.Amount.DisplayString + ' ' + H.Name.Value
                + ' ('+ H.Alfa.DisplayString + ') bij '
                + H.Time.Displaystring + ' voor einde koken'
          else
            s:= H.Amount.DisplayString + ' ' + H.Name.Value + ' ('+ H.Alfa.DisplayString
                + ') bij einde koken';
          IngrListArray[n].Caption:= s;
          IngrListArray[n].IngrType:= itHop;
        end;
      end;
      for i:= 0 to FRecipe.NumFermentables - 1 do
      begin
        F:= FRecipe.Fermentable[i];
        if (F.AddedType = atBoil) then
        begin
          Inc(n);
          SetLength(IngrListArray, n+1);
          IngrListArray[n].Time:= 10;
          s:= F.Amount.DisplayString + ' ' + F.Name.Value
              + ' bij 10 minuten voor einde koken';
          IngrListArray[n].Caption:= s;
          IngrListArray[n].IngrType:= itFermentable;
        end;
      end;
      for i:= 0 to FRecipe.NumMiscs - 1 do
      begin
        M:= FRecipe.Misc[i];
        if (M.Use = muBoil) then
        begin
          Inc(n);
          SetLength(IngrListArray, n+1);
          Tm:= M.Time.Value;
//          DecodeTime(M.Time.Value, ho, mi, se, mis);
          IngrListArray[n].Time:= round(Tm);
          if M.Time.Value > 0 then
            s:= M.Amount.DisplayString + ' ' + M.Name.Value + ' bij '
                + M.Time.Displaystring + ' voor einde koken'
          else
            s:= M.Amount.DisplayString + ' ' + M.Name.Value + ' bij einde koken';
          IngrListArray[n].Caption:= s;
          IngrListArray[n].IngrType:= itMisc;
        end;
      end;
      SelectionsortDec(IngrListArray, 0, n);
      for i:= 0 to n do
      begin
        s:= IngrListArray[i].Caption;
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
      end;

      v:= ExpansionFactor * FRecipe.BatchSize.DisplayValue;
      s:= 'doelvolume einde koken: ' + realToStrDec(v, 1)
          + UnitNames[FRecipe.BatchSize.DisplayUnit];
      v:= FRecipe.Equipment.CmInKettle(ExpansionFactor * FRecipe.BatchSize.Value);
      s:= s + ' (' + RealToStrDec(v, 1) + ' cm onder de rand)';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      v:= FRecipe.CalcOGAfterBoil;
      v:= Convert(FRecipe.EstOG.vUnit, FRecipe.EstOG.DisplayUnit, v);
      s:= 'doel SG einde koken: ' + RealToStrDec(v, 3) + ' SG (' +
          RealToStrDec(SGtoBrix(v), 1) + ' °Brix; ' + RealToStrDec(SGtoPlato(v), 1) + ' °P)';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;

      //Whirlpool
      n:= 0;
      for i:= 0 to FRecipe.NumHops - 1 do
      begin
        H:= FRecipe.Hop[i];
        if (H.Use = huWhirlpool) then Inc(n);
      end;
      if n > 0 then
      begin
        CLG:= CL.AddGroup;
        CLG.Caption.Value:= 'Whirlpool';

        s:= 'Wort naar whirlpool brengen of wort in kookketel roeren';
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
        s:= '';
        for i:= 0 to FRecipe.NumHops - 1 do
        begin
          H:= FRecipe.Hop[i];
          if (H.Use = huWhirlpool) then
          begin
            s:= H.Amount.DisplayString + ' ' + H.Name.Value + ' (' + H.Alfa.DisplayString + ') toevoegen';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
      end;

      //Koelen
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Koelen';

      s:= 'koeling in stelling brengen en aanzetten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      s:= 'gistvat ontsmetten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      s:= 'evt. pomp en slangen ontsmetten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      s:= 'beluchtingssteentje ontsmetten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      s:= 'evt. filterdoek ontsmetten';
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      v:= FRecipe.CoolingTo.Value;
      if v > 0 then
      begin
        s:= 'koelen tot ' + FRecipe.CoolingTo.DisplayString;
        CLI:= CLG.AddItem;
        CLI.Item.Caption:= s;
      end;

      //Gist enten
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Gist enten';

      if FRecipe.Yeast[0] <> NIL then
        if (FRecipe.Yeast[0].Form <> yfDry) then
        begin
          s:= 'wort beluchten';
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
          if FRecipe.Yeast[0].StarterMade.Value then
          begin
            s:= 'evt. giststarter afgieten';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end
        else
        begin
          s:= 'gist hydrateren in ';
          v:= 10 * FRecipe.Yeast[0].Amount.Value * 1000;
          s:= s + RealToStrDec(v, 0) + ' ml gedesinfecteerd water van ';
          v:= Convert(FRecipe.PrimaryTemp.vUnit, FRecipe.PrimaryTemp.DisplayUnit, 32);
          s:= s + RealToStrDec(v, 0) + ' ' + FRecipe.PrimaryTemp.DisplayUnitString;
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
          s:= '15 minuten laten staan bij ' + RealToStrDec(v, 0) + ' ' + FRecipe.PrimaryTemp.DisplayUnitString;
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
          s:= 'gistmengsel voorzichtig roeren';
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
          s:= '';
          v:= FRecipe.CoolingTo.Value;
          if v > 0 then
            s:= FRecipe.CoolingTo.DisplayString
          else
            s:= 'temperatuur wort';
          s:= 'langzaam laten afkoelen tot ' + s;
          CLI:= CLG.AddItem;
          CLI.Item.Caption:= s;
        end;

      s:= 'gist toevoegen';
      if FRecipe.Yeast[0] <> NIL then
      begin
        if FRecipe.Yeast[0].ProductID.Value = '' then
          s:= s + ' (' + FRecipe.Yeast[0].Name.Value + ')'
        else
        s:= s + ' (' + FRecipe.Yeast[0].ProductID.Value + ' - ' + FRecipe.Yeast[0].Name.Value + ')';
      end;
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;
      if (FRecipe.Equipment <> NIL) and (FRecipe.Equipment.TopUpWater.Value > 0) then
      begin
       s:= FRecipe.Equipment.Topupwater.DisplayString + ' water toevoegen in gistvat';
       CLI:= CLG.AddItem;
       CLI.Item.Caption:= s;
      end;

      //Vergisting starten
      CLG:= CL.AddGroup;
      CLG.Caption.Value:= 'Vergisting starten';

      v:= FRecipe.StartTempPrimary.Value;
      s:= 'klimaatkast instellen';
      if v > 0 then
        s:= s  + ': ' + FRecipe.StartTempPrimary.DisplayString;
      CLI:= CLG.AddItem;
      CLI.Item.Caption:= s;

      //Additions in fermenter
      j:= 0;
      for i:= 0 to FRecipe.NumFermentables - 1 do
      begin
        F:= FRecipe.Fermentable[i];
        if (F.AddedType = atFermentation) then Inc(j);
      end;
      for i:= 0 to FRecipe.NumMiscs - 1 do
      begin
        M:= FRecipe.Misc[i];
        if (M.Use = muPrimary) then Inc(j);
      end;
      if j > 0 then
      begin
        s:= 'Toevoegingen tijdens vergisting';
        CLG:= CL.AddGroup;
        CLG.Caption.Value:= s;
        for i:= 0 to FRecipe.NumFermentables - 1 do
        begin
          F:= FRecipe.Fermentable[i];
          if (F.AddedType = atFermentation) then
          begin
            s:= F.Amount.DisplayString + ' ' + F.Name.Value
                + ' bij hoofdvergisting';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
        for i:= 0 to FRecipe.NumMiscs - 1 do
        begin
          M:= FRecipe.Misc[i];
          if (M.Use = muPrimary) then
          begin
            s:= M.Amount.DisplayString + ' ' + M.Name.Value + ' bij hoofdvergisting';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
      end;

      //Additions in secondary
      j:= 0;
      for i:= 0 to FRecipe.NumFermentables - 1 do
      begin
        F:= FRecipe.Fermentable[i];
        if (F.AddedType = atLagering) then Inc(j);
      end;
      for i:= 0 to FRecipe.NumMiscs - 1 do
      begin
        M:= FRecipe.Misc[i];
        if (M.Use = muSecondary) then Inc(j);
      end;
      for i:= 0 to FRecipe.NumHops - 1 do
      begin
        H:= FRecipe.Hop[i];
        if (H.Use = huDryHop) then Inc(j);
      end;
      if j > 0 then
      begin
        s:= 'Toevoegingen tijdens nagisting/lagering';
        CLG:= CL.AddGroup;
        CLG.Caption.Value:= s;
        for i:= 0 to FRecipe.NumFermentables - 1 do
        begin
          F:= FRecipe.Fermentable[i];
          if (F.AddedType = atLagering) then
          begin
            s:= F.Amount.DisplayString + ' ' + F.Name.Value
                + ' bij nagisting/lagering';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
        for i:= 0 to FRecipe.NumHops - 1 do
        begin
          H:= FRecipe.Hop[i];
          if (H.Use = huDryHop) then
          begin
            s:= H.Amount.DisplayString + ' ' + H.Name.Value
                + ' ('+ H.Alfa.DisplayString + ') bij nagisting/lagering';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
        for i:= 0 to FRecipe.NumMiscs - 1 do
        begin
          M:= FRecipe.Misc[i];
          if (M.Use = muSecondary) then
          begin
            s:= M.Amount.DisplayString + ' ' + M.Name.Value + ' bij nagisting/lagering';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
      end;

      //Additions at bottling
      j:= 0;
      for i:= 0 to FRecipe.NumFermentables - 1 do
      begin
        F:= FRecipe.Fermentable[i];
        if (F.AddedType = atBottle) then Inc(j);
      end;
      for i:= 0 to FRecipe.NumMiscs - 1 do
      begin
        M:= FRecipe.Misc[i];
        if (M.Use = muBottling) then Inc(j);
      end;
      if j > 0 then
      begin
        s:= 'Toevoegingen tijdens bottelen/op fust zetten';
        CLG:= CL.AddGroup;
        CLG.Caption.Value:= s;
        for i:= 0 to FRecipe.NumFermentables - 1 do
        begin
          F:= FRecipe.Fermentable[i];
          if (F.AddedType = atBottle) then
          begin
            s:= F.Amount.DisplayString + ' ' + F.Name.Value
                + ' bij bottelen/op fust zetten';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
        for i:= 0 to FRecipe.NumMiscs - 1 do
        begin
          M:= FRecipe.Misc[i];
          if (M.Use = muBottling) then
          begin
            s:= M.Amount.DisplayString + ' ' + M.Name.Value + ' bij bottelen/op fust zetten';
            CLI:= CLG.AddItem;
            CLI.Item.Caption:= s;
          end;
        end;
      end;
    end;
  end;
end;

{=========================== Recipe ===========================================}

constructor TRecipe.Create(R: TRecipe);
begin
  inherited Create(R);
  FDataType:= dtRecipe;
  FRecType:= rtBrew;
  FNumMissingIngredients:= 0;

  FLockEfficiency := False;
  FRecipeType := rtAllGrain;
  FStyle := TBeerStyle.Create(self);
  FEquipment := TEquipment.Create(self);
  FCheckList:= TCheckList.Create(self);

  FBrewer := TBString.Create(self);
  FBrewer.Value := '';
  FBrewer.NodeLabel := 'BREWER';

  FAsstBrewer := TBString.Create(self);
  FAsstBrewer.Value := '';
  FAsstBrewer.NodeLabel := 'ASST_BREWER';

  FBatchSize := TBFloat.Create(self);
  FBatchSize.vUnit := liter;
  FBatchSize.DisplayUnit := liter;
  FBatchSize.MinValue := 0.0;
  FBatchSize.MaxValue := 10000000;
  FBatchSize.Value := 20.0;
  FBatchSize.Decimals := 1;
  FBatchSize.NodeLabel := 'BATCH_SIZE';
  FBatchSize.DisplayLabel := 'DISPLAY_BATCH_SIZE';

  FBoilSize := TBFloat.Create(self);
  FBoilSize.vUnit := liter;
  FBoilSize.DisplayUnit := liter;
  FBoilSize.MinValue := 0.0;
  FBoilSize.MaxValue := 100000000;
  FBoilSize.Value := 0;
  FBoilSize.Decimals := 1;
  FBoilSize.NodeLabel := 'BOIL_SIZE';
  FBoilSize.DisplayLabel := 'DISPLAY_BOIL_SIZE';

  FBoilTime := TBFloat.Create(self);
  FBoilTime.vUnit := minuut;
  FBoilTime.DisplayUnit := minuut;
  FBoilTime.MinValue := 0.0;
  FBoilTime.MaxValue := 180;
  FBoilTime.Value := 0;
  FBoilTime.Decimals := 0;
  FBoilTime.NodeLabel := 'BOIL_TIME';
  FBoilTime.DisplayLabel := '';

  FEfficiency := TBFloat.Create(self);
  FEfficiency.vUnit := perc;
  FEfficiency.DisplayUnit := perc;
  FEfficiency.MinValue := 0.0;
  FEfficiency.MaxValue := 100.0;
  FEfficiency.Value := 0;
  FEfficiency.Decimals := 1;
  FEfficiency.NodeLabel := 'EFFICIENCY';
  FEfficiency.DisplayLabel := '';

  FMash := TMash.Create(self);

  FTasteNotes := TBString.Create(self);
  FTasteNotes.Value := '';
  FTasteNotes.NodeLabel := 'TASTE_NOTES';

  FTastingRate := TBFloat.Create(self);
  FTastingRate.vUnit := none;
  FTastingRate.DisplayUnit := none;
  FTastingRate.MinValue := 0.0;
  FTastingRate.MaxValue := 100.0;
  FTastingRate.Value := 0.0;
  FTastingRate.Decimals := 1;
  FTastingRate.NodeLabel := 'TASTING_RATE';
  FTastingRate.DisplayLabel := '';

  FOG := TBFloat.Create(self);
  FOG.vUnit := sg;
  FOG.DisplayUnit := sg;
  FOG.MinValue := 1.0;
  FOG.MaxValue := 1.150;
  FOG.Value := 1.000;
  FOG.Decimals := 3;
  FOG.NodeLabel := 'OG';
  FOG.DisplayLabel := '';

  FFG := TBFloat.Create(self);
  FFG.vUnit := sg;
  FFG.DisplayUnit := sg;
  FFG.MinValue := 0.9;
  FFG.MaxValue := 1.3;
  FFG.Value := 1.000;
  FFG.Decimals := 3;
  FFG.NodeLabel := 'FG';
  FFG.DisplayLabel := '';

  FFermentationStages := TBInteger.Create(self);
  FFermentationStages.vUnit := none;
  FFermentationStages.MinValue := 0;
  FFermentationStages.MaxValue := 5;
  FFermentationStages.Value := 0;
  FFermentationStages.NodeLabel := 'FERMENTATION_STAGES';

  FPrimaryAge := TBFloat.Create(self);
  FPrimaryAge.vUnit := dag;
  FPrimaryAge.DisplayUnit := dag;
  FPrimaryAge.MinValue := 0.0;
  FPrimaryAge.MaxValue := 100.0;
  FPrimaryAge.Value := 0.0;
  FPrimaryAge.Decimals := 1;
  FPrimaryAge.NodeLabel := 'PRIMARY_AGE';
  FPrimaryAge.DisplayLabel := '';

  FPrimaryTemp := TBFloat.Create(self);
  FPrimaryTemp.vUnit := celcius;
  FPrimaryTemp.DisplayUnit := celcius;
  FPrimaryTemp.MinValue := 0.0;
  FPrimaryTemp.MaxValue := 40.0;
  FPrimaryTemp.Value := 0.0;
  FPrimaryTemp.Decimals := 1;
  FPrimaryTemp.NodeLabel := 'PRIMARY_TEMP';
  FPrimaryTemp.DisplayLabel := '';

  FSecondaryAge := TBFloat.Create(self);
  FSecondaryAge.vUnit := dag;
  FSecondaryAge.DisplayUnit := dag;
  FSecondaryAge.MinValue := 0.0;
  FSecondaryAge.MaxValue := 3000.0;
  FSecondaryAge.Value := 0.0;
  FSecondaryAge.Decimals := 0;
  FSecondaryAge.NodeLabel := 'SECONDARY_AGE';
  FSecondaryAge.DisplayLabel := '';

  FSecondaryTemp := TBFloat.Create(self);
  FSecondaryTemp.vUnit := celcius;
  FSecondaryTemp.DisplayUnit := celcius;
  FSecondaryTemp.MinValue := 0.0;
  FSecondaryTemp.MaxValue := 40.0;
  FSecondaryTemp.Value := 0.0;
  FSecondaryTemp.Decimals := 1;
  FSecondaryTemp.NodeLabel := 'SECONDARY_TEMP';
  FSecondaryTemp.DisplayLabel := '';

  FTertiaryAge := TBFloat.Create(self);
  FTertiaryAge.vUnit := dag;
  FTertiaryAge.DisplayUnit := dag;
  FTertiaryAge.MinValue := 0.0;
  FTertiaryAge.MaxValue := 3000.0;
  FTertiaryAge.Value := 0.0;
  FTertiaryAge.Decimals := 0;
  FTertiaryAge.NodeLabel := 'TERTIARY_AGE';
  FTertiaryAge.DisplayLabel := '';

  FTertiaryTemp := TBFloat.Create(self);
  FTertiaryTemp.vUnit := celcius;
  FTertiaryTemp.DisplayUnit := celcius;
  FTertiaryTemp.MinValue := -20.0;
  FTertiaryTemp.MaxValue := 40.0;
  FTertiaryTemp.Value := 0.0;
  FTertiaryTemp.Decimals := 1;
  FTertiaryTemp.NodeLabel := 'TERTIARY_TEMP';
  FTertiaryTemp.DisplayLabel := '';

  FAge := TBFloat.Create(self);
  FAge.vUnit := dag;
  FAge.DisplayUnit := dag;
  FAge.MinValue := 0.0;
  FAge.MaxValue := 3000.0;
  FAge.Value := 0.0;
  FAge.Decimals := 0;
  FAge.NodeLabel := 'AGE';
  FAge.DisplayLabel := '';

  FAgeTemp := TBFloat.Create(self);
  FAgeTemp.vUnit := celcius;
  FAgeTemp.DisplayUnit := celcius;
  FAgeTemp.MinValue := 0.0;
  FAgeTemp.MaxValue := 40.0;
  FAgeTemp.Value := 0.0;
  FAgeTemp.Decimals := 1;
  FAgeTemp.NodeLabel := 'AGE_TEMP';
  FAgeTemp.DisplayLabel := '';

  FDate := TBDate.Create(self);
  FDate.Value := 0;
  FDate.NodeLabel := 'DATE';

  FCarbonation := TBFloat.Create(self);
  FCarbonation.vUnit := volco2;
  FCarbonation.DisplayUnit := volco2;
  FCarbonation.MinValue := 0.0;
  FCarbonation.MaxValue := 5.0;
  FCarbonation.Value := 0.0;
  FCarbonation.Decimals := 1;
  FCarbonation.NodeLabel := 'CARBONATION';
  FCarbonation.DisplayLabel := '';

  FForcedCarbonation := TBBoolean.Create(self);
  FForcedCarbonation.Value := False;
  FForcedCarbonation.NodeLabel := 'FORCED_CARBONATION';

  FPrimingSugarName := TBString.Create(self);
  FPrimingSugarName.Value := '';
  FPrimingSugarName.NodeLabel := 'PRIMING_SUGAR_NAME';

  FCarbonationTemp := TBFloat.Create(self);
  FCarbonationTemp.vUnit := celcius;
  FCarbonationTemp.DisplayUnit := celcius;
  FCarbonationTemp.MinValue := 0.0;
  FCarbonationTemp.MaxValue := 40.0;
  FCarbonationTemp.Value := 0.0;
  FCarbonationTemp.Decimals := 1;
  FCarbonationTemp.NodeLabel := 'CARBONATION_TEMP';
  FCarbonationTemp.DisplayLabel := 'DISPLAY_CARB_TEMP';

  FPrimingSugarEquiv := TBFloat.Create(self);
  FPrimingSugarEquiv.vUnit := none;
  FPrimingSugarEquiv.DisplayUnit := none;
  FPrimingSugarEquiv.MinValue := 0.0;
  FPrimingSugarEquiv.MaxValue := 5.0;
  FPrimingSugarEquiv.Value := 0.0;
  FPrimingSugarEquiv.Decimals := 1;
  FPrimingSugarEquiv.NodeLabel := 'PRIMING_SUGAR_EQUIV';
  FPrimingSugarEquiv.DisplayLabel := '';

  FKegPrimingFactor := TBFloat.Create(self);
  FKegPrimingFactor.vUnit := none;
  FKegPrimingFactor.DisplayUnit := none;
  FKegPrimingFactor.MinValue := 0.0;
  FKegPrimingFactor.MaxValue := 1.0;
  FKegPrimingFactor.Value := 0.0;
  FKegPrimingFactor.Decimals := 1;
  FKegPrimingFactor.NodeLabel := 'KEG_PRIMING_FACTOR';
  FKegPrimingFactor.DisplayLabel := '';

  //BeerXML Extensions
  FEstOG := TBFloat.Create(self);
  FEstOG.vUnit := sg;
  FEstOG.DisplayUnit := sg;
  FEstOG.MinValue := 1.0;
  FEstOG.MaxValue := 1.3;
  FEstOG.Value := 1.000;
  FEstOG.Decimals := 3;
  FEstOG.NodeLabel := 'EST_OG';
  FEstOG.DisplayLabel := 'EST_OG';

  FEstFG := TBFloat.Create(self);
  FEstFG.vUnit := sg;
  FEstFG.DisplayUnit := sg;
  FEstFG.MinValue := 1.0;
  FEstFG.MaxValue := 1.05;
  FEstFG.Value := 1.000;
  FEstFG.Decimals := 3;
  FEstFG.NodeLabel := 'EST_FG';
  FEstFG.DisplayLabel := 'EST_FG';

  FEstFG2 := TBFloat.Create(self);
  FEstFG2.vUnit := sg;
  FEstFG2.DisplayUnit := sg;
  FEstFG2.MinValue := 1.0;
  FEstFG2.MaxValue := 1.05;
  FEstFG2.Value := 1.000;
  FEstFG2.Decimals := 3;
  FEstFG2.NodeLabel := 'EST_FG';
  FEstFG2.DisplayLabel := 'EST_FG';

  FEstColor := TBFloat.Create(self);
  FEstColor.vUnit := srm;
  FEstColor.DisplayUnit := ebc;
  FEstColor.MinValue := 0.0;
  FEstColor.MaxValue := 300.0;
  FEstColor.Value := 0.0;
  FEstColor.Decimals := 0;
  FEstColor.NodeLabel := 'EST_COLOR';
  FEstColor.DisplayLabel := 'EST_COLOR';

  FIBU := TBFloat.Create(self);
  FIBU.vUnit := ibu;
  FIBU.DisplayUnit := ibu;
  FIBU.MinValue := 0.0;
  FIBU.MaxValue := 200;
  FIBU.Value := 0.0;
  FIBU.Decimals := 0;
  FIBU.NodeLabel := 'IBU';
  FIBU.DisplayLabel := 'IBU';

  FIBUmethod := imTinseth;

  FEstABV := TBFloat.Create(self);
  FEstABV.vUnit := abv;
  FEstABV.DisplayUnit := abv;
  FEstABV.MinValue := 0.0;
  FEstABV.MaxValue := 20.0;
  FEstABV.Value := 0.0;
  FEstABV.Decimals := 1;
  FEstABV.NodeLabel := 'EST_ABV';
  FEstABV.DisplayLabel := '';

  FABV := TBFloat.Create(self);
  FABV.vUnit := abv;
  FABV.DisplayUnit := abv;
  FABV.MinValue := 0.0;
  FABV.MaxValue := 20.0;
  FABV.Value := 0.0;
  FABV.Decimals := 1;
  FABV.NodeLabel := 'ABV';
  FABV.DisplayLabel := '';

  FActualEfficiency := TBFloat.Create(self);
  FActualEfficiency.vUnit := perc;
  FActualEfficiency.DisplayUnit := perc;
  FActualEfficiency.MinValue := 0.0;
  FActualEfficiency.MaxValue := 100.0;
  FActualEfficiency.Value := 0.0;
  FActualEfficiency.Decimals := 1;
  FActualEfficiency.NodeLabel := 'ACTUAL_EFFICIENCY';
  FActualEfficiency.DisplayLabel := '';

  FCalories := TBFloat.Create(self);
  FCalories.vUnit := cal;
  FCalories.DisplayUnit := cal;
  FCalories.MinValue := 0.0;
  FCalories.MaxValue := 1000.0;
  FCalories.Value := 0.0;
  FCalories.Decimals := 0;
  FCalories.NodeLabel := '';
  FCalories.DisplayLabel := 'CALORIES';

  //BrewBuddyXML
{  FEstOGFermenter := TBFloat.Create(self);
  FEstOGFermenter.vUnit := sg;
  FEstOGFermenter.DisplayUnit := sg;
  FEstOGFermenter.MinValue := 1.0;
  FEstOGFermenter.MaxValue := 1.3;
  FEstOGFermenter.Value := 1.000;
  FEstOGFermenter.Decimals := 3;
  FEstOGFermenter.NodeLabel := '';
  FEstOGFermenter.DisplayLabel := 'EST_OG_FERMENTER';}

  FColorMethod := cmMorey;

  FParentAutoNr := TBString.Create(self);
  FParentAutoNr.Value:= '';
  FParentAutoNr.NodeLabel:= 'PARENT';

  FNrRecipe := TBString.Create(self); //code given by brewer
  FNrRecipe.Value := '';
  FNrRecipe.NodeLabel := 'NR_RECIPE';

  FpHAdjustmentWith := TBString.Create(self);
  FpHAdjustmentWith.Value := '';
  FpHAdjustmentWith.NodeLabel := 'PH_ADJUSTMENT_WITH';

  FVolumeHLT := TBFloat.Create(self); //amount of water in the HLT (sparge + other)
  FVolumeHLT.vUnit := liter;
  FVolumeHLT.DisplayUnit := liter;
  FVolumeHLT.MinValue := 0.0;
  FVolumeHLT.MaxValue := 100000.0;
  FVolumeHLT.Value := 0.0;
  FVolumeHLT.Decimals := 1;
  FVolumeHLT.NodeLabel := 'VOLUME_HLT';
  FVolumeHLT.DisplayLabel := '';

  FSpargeWaterComposition := 0;

  FpHAdjusted := TBFloat.Create(self);
  FpHAdjusted.vUnit := pH;
  FpHAdjusted.DisplayUnit := pH;
  FpHAdjusted.MinValue := 0.0;
  FpHAdjusted.MaxValue := 14.0;
  FpHAdjusted.Value := 0.0;
  FpHAdjusted.Decimals := 1;
  FpHAdjusted.NodeLabel := 'PH_ADJUSTED';
  FpHAdjusted.DisplayLabel := '';

  FTargetpH:= TBFloat.Create(self);
  FTargetpH.vUnit:= pH;
  FTargetpH.DisplayUnit:= pH;
  FTargetpH.MinValue:= 0.0;
  FTargetpH.MaxValue:= 14.0;
  FTargetpH.Value:= 5.4;
  FTargetpH.Decimals:= 1;
  FTargetpH.NodeLabel:= 'TARGET_PH';
  FTargetpH.DisplayLabel:= '';

  FSGEndMash:= TBFloat.Create(self);
  FSGEndMash.vUnit:= sg;
  FSGEndMash.DisplayUnit:= sg;
  FSGEndMash.MinValue:= 1;
  FSGEndMash.MaxValue:= 2;
  FSGEndMash.Value:= 1.000;
  FSGEndMash.Decimals:= 3;
  FSGEndMash.NodeLabel:= 'SG_END_MASH';
  FSGEndMash.DisplayLabel:= '';

  FAcidSparge:= TBFloat.Create(self);
  FAcidSparge.vUnit:= liter;
  FAcidSparge.DisplayUnit:= milliliter;
  FAcidSparge.MinValue:= 0;
  FAcidSparge.MaxValue:= 10;
  FAcidSparge.Value:= 0;
  FAcidSparge.Decimals:= 2;
  FAcidSparge.NodeLabel:= 'LACTIC_SPARGE';
  FAcidSparge.DisplayLabel:= '';

  FAcidSpargePerc := TBFloat.Create(self);
  FAcidSpargePerc.vUnit:= perc;
  FAcidSpargePerc.DisplayUnit:= perc;
  FAcidSpargePerc.MinValue:= 0;
  FAcidSpargePerc.MaxValue:= 100;
  FAcidSpargePerc.Value:= 80;
  FAcidSpargePerc.Decimals:= 0;
  FAcidSpargePerc.NodeLabel:= 'ACID_SPARGE_PERC';
  FAcidSpargePerc.DisplayLabel:= '';

  FAcidSpargeType := atLactic;

  FOGBeforeBoil := TBFloat.Create(self);
  FOGBeforeBoil.vUnit := sg;
  FOGBeforeBoil.DisplayUnit := sg;
  FOGBeforeBoil.MinValue := 1.0;
  FOGBeforeBoil.MaxValue := 1.300;
  FOGBeforeBoil.Value := 1.000;
  FOGBeforeBoil.Decimals := 3;
  FOGBeforeBoil.NodeLabel := 'OG_BEFORE_BOIL';
  FOGBeforeBoil.DisplayLabel := '';

  FpHBeforeBoil := TBFloat.Create(self);
  FpHBeforeBoil.vUnit := pH;
  FpHBeforeBoil.DisplayUnit := pH;
  FpHBeforeBoil.MinValue := 0.0;
  FpHBeforeBoil.MaxValue := 14.0;
  FpHBeforeBoil.Value := 0.0;
  FpHBeforeBoil.Decimals := 1;
  FpHBeforeBoil.NodeLabel := 'PH_BEFORE_BOIL';
  FpHBeforeBoil.DisplayLabel := '';

  FpHAfterBoil := TBFloat.Create(self);
  FpHAfterBoil.vUnit := pH;
  FpHAfterBoil.DisplayUnit := pH;
  FpHAfterBoil.MinValue := 0.0;
  FpHAfterBoil.MaxValue := 14.0;
  FpHAfterBoil.Value := 0.0;
  FpHAfterBoil.Decimals := 1;
  FpHAfterBoil.NodeLabel := 'PH_AFTER_BOIL';
  FpHAfterBoil.DisplayLabel := '';

  FVolumeBeforeBoil := TBFloat.Create(self);
  FVolumeBeforeBoil.vUnit := liter;
  FVolumeBeforeBoil.DisplayUnit := liter;
  FVolumeBeforeBoil.MinValue := 0.0;
  FVolumeBeforeBoil.MaxValue := 100000000;
  FVolumeBeforeBoil.Value := 0.0;
  FVolumeBeforeBoil.Decimals := 1;
  FVolumeBeforeBoil.NodeLabel := 'VOLUME_BEFORE_BOIL';
  FVolumeBeforeBoil.DisplayLabel := '';

  FVolumeAfterBoil := TBFloat.Create(self);
  FVolumeAfterBoil.vUnit := liter;
  FVolumeAfterBoil.DisplayUnit := liter;
  FVolumeAfterBoil.MinValue := 0.0;
  FVolumeAfterBoil.MaxValue := 100000000;
  FVolumeAfterBoil.Value := 0.0;
  FVolumeAfterBoil.Decimals := 1;
  FVolumeAfterBoil.NodeLabel := 'VOLUME_AFTER_BOIL';
  FVolumeAfterBoil.DisplayLabel := '';

  FVolumeFermenter := TBFloat.Create(self);//volume of wort measured in the fermenter
  FVolumeFermenter.vUnit := liter;
  FVolumeFermenter.DisplayUnit := liter;
  FVolumeFermenter.MinValue := 0.0;
  FVolumeFermenter.MaxValue := 100000000;
  FVolumeFermenter.Value := 0.0;
  FVolumeFermenter.Decimals := 1;
  FVolumeFermenter.NodeLabel := 'VOLUME_FERMENTER';
  FVolumeFermenter.DisplayLabel := '';

  FOGFermenter:= TBFloat.Create(self); //og in fermenter after top-up water addition
  FOGFermenter.vUnit:= sg;
  FOGFermenter.DisplayUnit:= sg;
  FOGFermenter.MinValue:= 1.0;
  FOGFermenter.MaxValue:= 1.3;
  FOGFermenter.Value:= 1;
  FOGFermenter.Decimals:= 3;
  FOGFermenter.NodeLabel:= 'OG_FERMENTER';
  FOGFermenter.DisplayLabel:= '';

  FTimeAeration := TBFloat.Create(self);  //length of aeration of wort in hours
  FTimeAeration.vUnit := uur;
  FTimeAeration.DisplayUnit := minuut;
  FTimeAeration.MinValue := 0.0;
  FTimeAeration.MaxValue := 24;
  FTimeAeration.Value := 0.0;
  FTimeAeration.Decimals := 1;
  FTimeAeration.NodeLabel := 'TIME_AERATION';
  FTimeAeration.DisplayLabel := '';

  FAerationType:= atNone;

  FAerationFlowRate := TBFloat.Create(self);
  FAerationFlowRate.vUnit := lph;
  FAerationFlowRate.DisplayUnit := lpm;
  FAerationFlowRate.MinValue := 0.0;
  FAerationFlowRate.MaxValue := 10;
  FAerationFlowRate.Value := 0.0;
  FAerationFlowRate.Decimals := 1;
  FAerationFlowRate.NodeLabel := 'AERATION_FLOW_RATE';
  FAerationFlowRate.DisplayLabel := '';

  FSGEndPrimary := TBFloat.Create(self);
  FSGEndPrimary.vUnit := sg;
  FSGEndPrimary.DisplayUnit := sg;
  FSGEndPrimary.MinValue := 1.0;
  FSGEndPrimary.MaxValue := 1.300;
  FSGEndPrimary.Value := 1.000;
  FSGEndPrimary.Decimals := 3;
  FSGEndPrimary.NodeLabel := 'SG_END_PRIMARY';
  FSGEndPrimary.DisplayLabel := '';

  FStartTempPrimary := TBFloat.Create(self);
  FStartTempPrimary.vUnit := celcius;
  FStartTempPrimary.DisplayUnit := celcius;
  FStartTempPrimary.MinValue := 0.0;
  FStartTempPrimary.MaxValue := 40.0;
  FStartTempPrimary.Value := 0.0;
  FStartTempPrimary.Decimals := 1;
  FStartTempPrimary.NodeLabel := 'START_TEMP_PRIMARY';
  FStartTempPrimary.DisplayLabel := '';

  FMaxTempPrimary := TBFloat.Create(self);
  FMaxTempPrimary.vUnit := celcius;
  FMaxTempPrimary.DisplayUnit := celcius;
  FMaxTempPrimary.MinValue := 0.0;
  FMaxTempPrimary.MaxValue := 40.0;
  FMaxTempPrimary.Value := 0.0;
  FMaxTempPrimary.Decimals := 1;
  FMaxTempPrimary.NodeLabel := 'MAX_TEMP_PRIMARY';
  FMaxTempPrimary.DisplayLabel := '';

  FEndTempPrimary := TBFloat.Create(self);
  FEndTempPrimary.vUnit := celcius;
  FEndTempPrimary.DisplayUnit := celcius;
  FEndTempPrimary.MinValue := 0.0;
  FEndTempPrimary.MaxValue := 40.0;
  FEndTempPrimary.Value := 0.0;
  FEndTempPrimary.Decimals := 1;
  FEndTempPrimary.NodeLabel := 'END_TEMP_PRIMARY';
  FEndTempPrimary.DisplayLabel := '';

  FDateBottling := TBDate.Create(self);
  FDateBottling.Value := 0;
  FDateBottling.NodeLabel := 'DATE_BOTTLING';

  FVolumeBottles := TBFloat.Create(self);   //volume of beer bottled
  FVolumeBottles.vUnit := liter;
  FVolumeBottles.DisplayUnit := liter;
  FVolumeBottles.MinValue := 0.0;
  FVolumeBottles.MaxValue := 1000000;
  FVolumeBottles.Value := 0.0;
  FVolumeBottles.Decimals := 1;
  FVolumeBottles.NodeLabel := 'AMOUNT_BOTTLING';
  FVolumeBottles.DisplayLabel := '';

  FVolumeKegs := TBFloat.Create(self);   //volume of beer Kegged
  FVolumeKegs.vUnit := liter;
  FVolumeKegs.DisplayUnit := liter;
  FVolumeKegs.MinValue := 0.0;
  FVolumeKegs.MaxValue := 1000000;
  FVolumeKegs.Value := 0.0;
  FVolumeKegs.Decimals := 1;
  FVolumeKegs.NodeLabel := 'AMOUNT_KEGGED';
  FVolumeKegs.DisplayLabel := '';

  FAmountPrimingBottles := TBFloat.Create(self);
  //amount of priming sugar in bottles per liter of beer
  FAmountPrimingBottles.vUnit := gpl;
  FAmountPrimingBottles.DisplayUnit := gpl;
  FAmountPrimingBottles.MinValue := 0.0;
  FAmountPrimingBottles.MaxValue := 15.0;
  FAmountPrimingBottles.Value := 0.0;
  FAmountPrimingBottles.Decimals := 1;
  FAmountPrimingBottles.NodeLabel := 'AMOUNT_PRIMING';
  FAmountPrimingBottles.DisplayLabel := '';

  FAmountPrimingKegs := TBFloat.Create(self);
  //amount of priming sugar in kegs per liter of beer
  FAmountPrimingKegs.vUnit := gpl;
  FAmountPrimingKegs.DisplayUnit := gpl;
  FAmountPrimingKegs.MinValue := 0.0;
  FAmountPrimingKegs.MaxValue := 15.0;
  FAmountPrimingKegs.Value := 0.0;
  FAmountPrimingKegs.Decimals := 1;
  FAmountPrimingKegs.NodeLabel := 'AMOUNT_PRIMING_KEGS';
  FAmountPrimingKegs.DisplayLabel := '';

  FCarbonationKegs := TBFloat.Create(self);
  FCarbonationKegs.vUnit := volco2;
  FCarbonationKegs.DisplayUnit := volco2;
  FCarbonationKegs.MinValue := 0.0;
  FCarbonationKegs.MaxValue := 5.0;
  FCarbonationKegs.Value := 0.0;
  FCarbonationKegs.Decimals := 1;
  FCarbonationKegs.NodeLabel := 'CARBONATION';
  FCarbonationKegs.DisplayLabel := '';

  FForcedCarbonationKegs := TBBoolean.Create(self);
  FForcedCarbonationKegs.NodeLabel := 'FORCED_CARB_KEGS';

  FCarbonationTempKegs := TBFloat.Create(self);
  FCarbonationTempKegs.vUnit := celcius;
  FCarbonationTempKegs.DisplayUnit := celcius;
  FCarbonationTempKegs.MinValue := 0.0;
  FCarbonationTempKegs.MaxValue := 30.0;
  FCarbonationTempKegs.Value := 0.0;
  FCarbonationTempKegs.Decimals := 1;
  FCarbonationTempKegs.NodeLabel := 'KEG_CARB_TEMP';
  FCarbonationTempKegs.DisplayLabel := '';

  FPressureKegs := TBFloat.Create(self);
  FPressureKegs.vUnit := bar;
  FPressureKegs.DisplayUnit := bar;
  FPressureKegs.MinValue := 0.0;
  FPressureKegs.MaxValue := 5.0;
  FPressureKegs.Value := 0.0;
  FPressureKegs.Decimals := 1;
  FPressureKegs.NodeLabel := 'KEG_PRESSURE';
  FPressureKegs.DisplayLabel := '';

  FTasteDate := TBDate.Create(self);
  FTasteDate.Value := 0;
  FTasteDate.NodeLabel := 'TASTE_DATE';

  FTasteColor := TBString.Create(self);
  FTasteColor.Value := '';
  FTasteColor.NodeLabel := 'TASTE_COLOR';

  FTasteTransparency := TBString.Create(self);
  FTasteTransparency.Value := '';
  FTasteTransparency.NodeLabel := 'TASTE_TRANSPARENCY';

  FTasteHead := TBString.Create(self);
  FTasteHead.Value := '';
  FTasteHead.NodeLabel := 'TASTE_HEAD';

  FTasteAroma := TBString.Create(self);
  FTasteAroma.Value := '';
  FTasteAroma.NodeLabel := 'TASTE_AROMA';

  FTasteTaste := TBString.Create(self);
  FTasteTaste.Value := '';
  FTasteTaste.NodeLabel := 'TASTE_TASTE';

  FTasteMouthfeel := TBString.Create(self);
  FTasteMouthfeel.Value := '';
  FTasteMouthfeel.NodeLabel := 'TASTE_MOUTHFEEL';

  FTasteAftertaste := TBString.Create(self);
  FTasteAftertaste.Value := '';
  FTasteAftertaste.NodeLabel := 'TASTE_AFTERTASTE';

  FTimeStarted := TBTime.Create(self);
  FTimeStarted.Value := 0;
  FTimeStarted.NodeLabel := 'TIME_STARTED';

  FTimeEnded := TBTime.Create(self);
  FTimeEnded.Value := 0;
  FTimeEnded.NodeLabel := 'TIME_ENDED';

  FCoolingMethod := cmEmpty;

  FCoolingTime := TBFloat.Create(self);
  FCoolingTime.vUnit := minuut;
  FCoolingTime.DisplayUnit := minuut;
  FCoolingTime.MinValue := 0.0;
  FCoolingTime.MaxValue := 120.0;
  FCoolingTime.Value := 0.0;
  FCoolingTime.Decimals := 0;
  FCoolingTime.NodeLabel := 'COOLING_TIME';
  FCoolingTime.DisplayLabel := '';

  FCoolingTo := TBFloat.Create(self);
  FCoolingTo.vUnit := celcius;
  FCoolingTo.DisplayUnit := celcius;
  FCoolingTo.MinValue := 0.0;
  FCoolingTo.MaxValue := 100.0;
  FCoolingTo.Value := 0.0;
  FCoolingTo.Decimals := 1;
  FCoolingTo.NodeLabel := 'COOLING_TO';
  FCoolingTo.DisplayLabel := '';

  FWhirlpoolTime := TBFloat.Create(self);
  FWhirlpoolTime.vUnit := minuut;
  FWhirlpoolTime.DisplayUnit := minuut;
  FWhirlpoolTime.MinValue := 0.0;
  FWhirlpoolTime.MaxValue := 120.0;
  FWhirlpoolTime.Value := 0.0;
  FWhirlpoolTime.Decimals := 0;
  FWhirlpoolTime.NodeLabel := 'WHIRLPOOL_TIME';
  FWhirlpoolTime.DisplayLabel := '';

  FInventoryReduced := TBBoolean.Create(self);
  FInventoryReduced.Value := False;
  FInventoryReduced.NodeLabel := 'INVENTORY_REDUCED';

  FLocked := TBBoolean.Create(self);
  FLocked.Value := False;
  FLocked.NodeLabel := 'LOCKED';

  FFermMeasurements := TFermMeasurements.Create(self);

  FPrimingSugarBottles := psSaccharose;
  FPrimingSugarKegs := psSaccharose;

  FDividedType := TBInteger.Create(self);
  //if batch is divided then 0:after mash; 1:after boil; 2:after primary;else -1
  FDividedType.MinValue := -1;
  FDividedType.MaxValue := 2;
  FDividedType.Value := -1;
  FDividedType.vUnit := none;
  FDividedType.NodeLabel := 'BATCH_DIVIDED';

  FDivisionType := TBInteger.Create(self);
  //if batch is divided then 0:after mash; 1:after boil; 2:after primary;else -1
  FDivisionType.MinValue := -1;
  FDivisionType.MaxValue := 2;
  FDivisionType.Value := -1;
  FDivisionType.vUnit := none;
  FDivisionType.NodeLabel := 'BATCH_DIVISION';

  FDivisionFrom := TBInteger.Create(self);
  FDivisionFrom.MinValue := 0;
  FDivisionFrom.MaxValue := maxint;
  FDivisionFrom.Value := 0;
  FDivisionFrom.vUnit := none;
  FDivisionFrom.NodeLabel := 'DIVIDED_FROM';

  FMashWater:= TWater.Create(self);

  FCalcAcid:= TBBoolean.Create(self);
  FCalcAcid.Value:= false;
  FCalcAcid.NodeLabel:= 'CALC_ACID';

  if R <> nil then
    Assign(R);
end;

destructor TRecipe.Destroy;
var
  i: integer;
begin
  FStyle.Free;
  FEquipment.Free;
  for i := Low(FHops) to High(FHops) do
    FHops[i].Free;
  SetLength(FHops, 0);

  for i := Low(FFermentables) to High(FFermentables) do
    FFermentables[i].Free;
  SetLength(FFermentables, 0);
  for i := Low(FMiscs) to High(FMiscs) do
    FMiscs[i].Free;
  SetLength(FMiscs, 0);
  for i := Low(FYeasts) to High(FYeasts) do
    FYeasts[i].Free;
  SetLength(FYeasts, 0);
  for i := Low(FWaters) to High(FWaters) do
    FWaters[i].Free;
  SetLength(FWaters, 0);
  FMash.Free;
  FCheckList.Free;

  FBatchSize.Free;
  FBoilSize.Free;
  FBoilTime.Free;
  FEfficiency.Free;
  FTastingRate.Free;
  FTasteNotes.Free;
  FOG.Free;
  FFG.Free;
  FPrimaryTemp.Free;
  FPrimaryAge.Free;
  FSecondaryTemp.Free;
  FSecondaryAge.Free;
  FTertiaryTemp.Free;
  FTertiaryAge.Free;
  FAgeTemp.Free;
  FAge.Free;
  FCarbonation.Free;
  FCarbonationTemp.Free;
  FPrimingSugarEquiv.Free;
  FKegPrimingFactor.Free;
  FEstOG.Free;
//  FEstOGFermenter.Free;
  FEstFG.Free;
  FEstFG2.Free;
  FEstColor.Free;
  FIBU.Free;
  FEstABV.Free;
  FABV.Free;
  FActualEfficiency.Free;
  FpHAdjusted.Free;
  FTargetpH.Free;
  FOGBeforeBoil.Free;
  FpHBeforeBoil.Free;
  FpHAfterBoil.Free;
  FVolumeBeforeBoil.Free;
  FVolumeAfterBoil.Free;
  FVolumeFermenter.Free;
  FOGFermenter.Free;
  FSGEndPrimary.Free;
  FStartTempPrimary.Free;
  FMaxTempPrimary.Free;
  FEndTempPrimary.Free;
  FBrewer.Free;
  FAsstBrewer.Free;
  FFermentationStages.Free;
  FDate.Free;
  FForcedCarbonation.Free;
  FPrimingSugarName.Free;
  FParentAutoNr.Free;
  FNrRecipe.Free; //code given by brewer
  FpHAdjustmentWith.Free;
  FSGEndMash.Free;
  FAcidSparge.Free;
  FAcidSpargePerc.Free;
  FWhirlpoolTime.Free;
  FCoolingTo.Free;
  FCoolingTime.Free;
  FTimeAeration.Free;
  FAerationFlowRate.Free;
  FDateBottling.Free;
  FVolumeBottles.Free;
  FVolumeKegs.Free;
  FCarbonationKegs.Free;
  FForcedCarbonationKegs.Free;
  FCarbonationTempKegs.Free;
  FAmountPrimingBottles.Free;
  FAmountPrimingKegs.Free;
  FPressureKegs.Free;
  FTasteDate.Free;
  FTasteColor.Free;
  FTasteTransparency.Free;
  FTasteHead.Free;
  FTasteAroma.Free;
  FTasteTaste.Free;
  FTasteMouthfeel.Free;
  FTasteAftertaste.Free;
  FTimeStarted.Free;
  FTimeEnded.Free;
  FLocked.Free;
  FInventoryReduced.Free;
  FFermMeasurements.Free;
  FVolumeHLT.Free;
  FDividedType.Free;
  FDivisionType.Free;
  FDivisionFrom.Free;

  FMashWater.Free;
  FCalcAcid.Free;
  inherited;
end;

procedure TRecipe.Assign(Source: TBase);
var
  i: integer;
begin
  if Source <> nil then
  begin
    inherited Assign(Source);

    FRecipeType := TRecipe(Source).RecipeType;
    FIBUmethod := TRecipe(Source).IBUmethod;
    FColorMethod := TRecipe(Source).ColorMethod;

    FStyle.Assign(TRecipe(Source).Style);
    FEquipment.Assign(TRecipe(Source).Equipment);

    for i := Low(FHops) to High(FHops) do
      FHops[i].Free;
    SetLength(FHops, TRecipe(Source).NumHops);
    for i := Low(FHops) to High(FHops) do
    begin
      FHops[i] := THop.Create(self);
      FHops[i].Assign(TRecipe(Source).Hop[i]);
    end;

    for i := Low(FFermentables) to High(FFermentables) do
      FFermentables[i].Free;
    SetLength(FFermentables, TRecipe(Source).NumFermentables);
    for i := Low(FFermentables) to High(FFermentables) do
    begin
      FFermentables[i] := TFermentable.Create(self);
      FFermentables[i].Assign(TRecipe(Source).Fermentable[i]);
    end;

    for i := Low(FMiscs) to High(FMiscs) do
      FMiscs[i].Free;
    SetLength(FMiscs, TRecipe(Source).NumMiscs);
    for i := Low(FMiscs) to High(FMiscs) do
    begin
      FMiscs[i] := TMisc.Create(self);
      FMiscs[i].Assign(TRecipe(Source).Misc[i]);
    end;

    for i := Low(FYeasts) to High(FYeasts) do
      FYeasts[i].Free;
    SetLength(FYeasts, TRecipe(Source).NumYeasts);
    for i := Low(FYeasts) to High(FYeasts) do
    begin
      FYeasts[i] := TYeast.Create(self);
      FYeasts[i].Assign(TRecipe(Source).Yeast[i]);
    end;

    for i := Low(FWaters) to High(FWaters) do
      FWaters[i].Free;
    SetLength(FWaters, TRecipe(Source).NumWaters);
    for i := Low(FWaters) to High(FWaters) do
    begin
      FWaters[i] := TWater.Create(self);
      FWaters[i].Assign(TRecipe(Source).Water[i]);
    end;

    FMash.Assign(TRecipe(Source).Mash);

    FBatchSize.Assign(TRecipe(Source).BatchSize);
    FBoilSize.Assign(TRecipe(Source).BoilSize);
    FBoilTime.Assign(TRecipe(Source).BoilTime);
    FEfficiency.Assign(TRecipe(Source).FEfficiency);
    FTastingRate.Assign(TRecipe(Source).TastingRate);
    FTasteNotes.Assign(TRecipe(Source).TasteNotes);
    FOG.Assign(TRecipe(Source).OG);
    FFG.Assign(TRecipe(Source).FG);
    FPrimaryTemp.Assign(TRecipe(Source).PrimaryTemp);
    FPrimaryAge.Assign(TRecipe(Source).PrimaryAge);
    FSecondaryTemp.Assign(TRecipe(Source).SecondaryTemp);
    FSecondaryAge.Assign(TRecipe(Source).SecondaryAge);
    FTertiaryTemp.Assign(TRecipe(Source).TertiaryTemp);
    FTertiaryAge.Assign(TRecipe(Source).TertiaryAge);
    FAgeTemp.Assign(TRecipe(Source).AgeTemp);
    FAge.Assign(TRecipe(Source).Age);
    FCarbonation.Assign(TRecipe(Source).Carbonation);
    FCarbonationTemp.Assign(TRecipe(Source).CarbonationTemp);
    FPrimingSugarEquiv.Assign(TRecipe(Source).PrimingSugarEquiv);
    FKegPrimingFactor.Assign(TRecipe(Source).KegPrimingFactor);
    FEstOG.Assign(TRecipe(Source).EstOG);
    FEstFG.Assign(TRecipe(Source).EstFG);
    FEstFG2.Assign(TRecipe(Source).EstFG2);
    FEstColor.Assign(TRecipe(Source).EstColor);
    FIBU.Assign(TRecipe(Source).IBUcalc);
    FEstABV.Assign(TRecipe(Source).EstABV);
    FABV.Assign(TRecipe(Source).ABVcalc);
    FActualEfficiency.Assign(TRecipe(Source).ActualEfficiency);
    FVolumeHLT.Assign(TRecipe(Source).VolumeHLT);
    FSpargeWaterComposition := TRecipe(Source).SpargeWaterComposition;
    FpHAdjusted.Assign(TRecipe(Source).pHAdjusted);
    FTargetpH.Assign(TRecipe(Source).TargetpH);
    FSGEndMash.Assign(TRecipe(Source).SGEndMash);
    FAcidSparge.Assign(TRecipe(Source).AcidSparge);
    FAcidSpargePerc.Assign(TRecipe(Source).AcidSpargePerc);
    AcidSpargeTypeName:= TRecipe(Source).AcidSpargeTypeName;
    FOGBeforeBoil.Assign(TRecipe(Source).OGBeforeBoil);
    FpHBeforeBoil.Assign(TRecipe(Source).pHBeforeBoil);
    FpHAfterBoil.Assign(TRecipe(Source).pHAfterBoil);
    FVolumeBeforeBoil.Assign(TRecipe(Source).VolumeBeforeBoil);
    FVolumeAfterBoil.Assign(TRecipe(Source).VolumeAfterBoil);
    FVolumeFermenter.Assign(TRecipe(Source).VolumeFermenter);
    FOGFermenter.Assign(TRecipe(Source).OGFermenter);
    FSGEndPrimary.Assign(TRecipe(Source).SGEndPrimary);
    FStartTempPrimary.Assign(TRecipe(Source).StartTempPrimary);
    FMaxTempPrimary.Assign(TRecipe(Source).MaxTempPrimary);
    FEndTempPrimary.Assign(TRecipe(Source).EndTempPrimary);
    FBrewer.Assign(TRecipe(Source).Brewer);
    FAsstBrewer.Assign(TRecipe(Source).AsstBrewer);
    FFermentationStages.Assign(TRecipe(Source).FermentationStages);
    FDate.Assign(TRecipe(Source).Date);
    FForcedCarbonation.Assign(TRecipe(Source).ForcedCarbonation);
    FPrimingSugarName.Assign(TRecipe(Source).PrimingSugarName);
    FNrRecipe.Assign(TRecipe(Source).NrRecipe);
    FpHAdjustmentWith.Assign(TRecipe(Source).pHAdjustmentWith);
    FDateBottling.Assign(TRecipe(Source).DateBottling);
    FVolumeBottles.Assign(TRecipe(Source).VolumeBottles);
    FVolumeKegs.Assign(TRecipe(Source).VolumeKegs);
    FCarbonationKegs.Assign(TRecipe(Source).CarbonationKegs);
    FForcedCarbonationKegs.Assign(TRecipe(Source).ForcedCarbonationKegs);
    FCarbonationTempKegs.Assign(TRecipe(Source).CarbonationTempKegs);
    FAmountPrimingBottles.Assign(TRecipe(Source).AmountPrimingBottles);
    FAmountPrimingKegs.Assign(TRecipe(Source).AmountPrimingKegs);
    FPressureKegs.Assign(TRecipe(Source).PressureKegs);

    FTasteDate.Assign(TRecipe(Source).TasteDate);
    FTasteColor.Assign(TRecipe(Source).TasteColor);
    FTasteTransparency.Assign(TRecipe(Source).TasteTransparency);
    FTasteHead.Assign(TRecipe(Source).TasteHead);
    FTasteAroma.Assign(TRecipe(Source).TasteAroma);
    FTasteTaste.Assign(TRecipe(Source).TasteTaste);
    FTasteMouthfeel.Assign(TRecipe(Source).TasteMouthFeel);
    FTasteAftertaste.Assign(TRecipe(Source).TasteAftertaste);
    FTimeStarted.Assign(TRecipe(Source).TimeStarted);
    FTimeEnded.Assign(TRecipe(Source).TimeEnded);
    FCoolingMethod := TREcipe(Source).CoolingMethod;
    FCoolingTime.Assign(TRecipe(Source).CoolingTime);
    FCoolingTo.Assign(TRecipe(Source).CoolingTo);
    FWhirlpoolTime.Assign(TRecipe(Source).WhirlpoolTime);
    FTimeAeration.Assign(TRecipe(Source).TimeAeration);
    FAerationType:= TRecipe(Source).AerationType;
    FAerationFlowRate.Assign(TRecipe(Source).AerationFlowRate);
    FInventoryReduced.Assign(TRecipe(Source).InventoryReduced);
    FLocked.Assign(TRecipe(Source).Locked);
    FFermMeasurements.Assign(TRecipe(Source).FermMeasurements);
    FPrimingSugarBottles := TRecipe(Source).PrimingSugarBottles;
    FPrimingSugarKegs := TRecipe(Source).PrimingSugarKegs;
    FDividedType.Assign(TRecipe(Source).DividedType);
    FDivisionType.Assign(TRecipe(Source).DivisionType);
    FDivisionFrom.Assign(TRecipe(Source).DivisionFrom);
    FParentAutoNr.Assign(TRecipe(Source).ParentAutoNr);
    FRecType:= TRecipe(Source).RecType;
    FCalcAcid.Assign(TRecipe(Source).CalcAcid);
    FCheckList.Assign(TRecipe(Source).CheckList);

    FMashWater.Assign(TRecipe(Source).MashWater);
  end;
end;

function TRecipe.GetValueByIndex(i: integer): variant;
begin
  Result := '';
  case i of
    //recept
    0: Result := FName.Value;
    1: Result := FNotes.Value;
    2: Result := FBrewer.Value;
    3: Result := FAsstBrewer.Value;
    4: Result := FNrRecipe.Value;
    5: Result := FDate.Value;
    6: Result := FRecipeType;
    7: Result := FIBUmethod;
    8: Result := FColorMethod;
    9: Result := FBatchSize.Value;
    10: Result := FBoilSize.Value;
    11: Result := FBoilTime.Value;
    12: Result := FEfficiency.Value;
    13: Result := FEstOG.Value;
    14: Result := FEstFG.Value;
    15: Result := FIBU.Value;
    16: Result := FEstColor.Value;
    17: Result := FEstABV.Value;
    //brouwdag
    18: Result := FTimeStarted.Value;
    19: Result := FpHAdjustmentWith.Value;
    20: Result := FpHAdjusted.Value;
    21: Result := FSGEndMash.Value;
    22: Result := CalcMashEfficiency;
    23: Result := FVolumeHLT.Value;
    24: Result := FSpargeWaterComposition;
    25: Result := FOGBeforeBoil.Value;
    26: Result := FpHBeforeBoil.Value;
    27: Result := FpHAfterBoil.Value;
    28: Result := FVolumeBeforeBoil.Value;
    29: Result := FVolumeAfterBoil.Value;
    30: Result := FVolumeFermenter.Value;
    31: if FActualEfficiency.Value < 20 then
        Result := CalcEfficiencyAfterBoil
      else
        Result := FActualEfficiency.Value;
    32: Result := FOG.Value;
    33: Result := FWhirlpoolTime.Value;
    34: Result := FCoolingMethod;
    35: Result := FCoolingTime.Value;
    36: Result := FCoolingTo.Value;
    37: Result := FAerationType;
    38: Result := FTimeAeration.Value;
    39: Result := FAerationFlowRate.Value;
    40: Result := FTimeEnded.Value;
    //vergisting
    41: Result := FFermentationStages.Value;
    42: Result := FPrimaryTemp.Value;
    43: Result := FPrimaryAge.Value;
    44: Result := FStartTempPrimary.Value;
    45: Result := FMaxTempPrimary.Value;
    46: Result := FEndTempPrimary.Value;
    47: Result := FSGEndPrimary.Value;
    48: Result := FSecondaryTemp.Value;
    49: Result := FSecondaryAge.Value;
    50: Result := FTertiaryTemp.Value;
    51: Result := FTertiaryAge.Value;
    52: Result := FFG.Value;
    //verpakken
    53: Result := FDateBottling.Value;
    54: Result := FCarbonation.Value;
    55: Result := FCarbonationTemp.Value;
    56: Result := FPrimingSugarEquiv.Value;
    57: Result := FKegPrimingFactor.Value;
    58: Result := FCarbonationKegs.Value;
    59: Result := FForcedCarbonation.Value;
    60: Result := FPrimingSugarName.Value;
    61: Result := FABV.Value;
    62: Result := FVolumeBottles.Value;
    63: Result := FVolumeKegs.Value;
    64: Result := FForcedCarbonationKegs.Value;
    65: Result := FCarbonationTempKegs.Value;
    66: Result := FAmountPrimingBottles.Value;
    67: Result := FAmountPrimingKegs.Value;
    68: Result := FPressureKegs.Value;

    //proeven
    69: Result := FAgeTemp.Value;
    70: Result := FAge.Value;
    71: Result := FTasteNotes.Value;
    72: Result := FTasteDate.Value;
    73: Result := FTasteColor.Value;
    74: Result := FTasteTransparency.Value;
    75: Result := FTasteHead.Value;
    76: Result := FTasteAroma.Value;
    77: Result := FTasteTaste.Value;
    78: Result := FTasteMouthfeel.Value;
    79: Result := FTasteAftertaste.Value;
    80: Result := FTastingRate.Value;

    //Later toegevoegd
    81: if (FMash <> nil) and (FMash.MashStep[0] <> nil) then
        Result := FMash.MashStep[0].WaterToGrainRatio;
    82: Result := FDividedType.Value;
    83: Result := FDivisionType.Value;
    84: Result := FDivisionFrom.Value;
    85: Result := FOGFermenter.Value;
    86: Result := FMash.AverageTemperature;
    87: Result := FAcidSparge.Value;
    88: Result := FAcidSpargePerc.Value;
    89: Result := FAcidSpargeType;
    90: Result:= FCalcAcid.Value;
  end;
end;

function TRecipe.GetIndexByName(s: string): integer;
begin
  Result := inherited GetIndexByName(s);
  if s = 'Brouwer' then
    Result := 2
  else if s = 'Assistent brouwer' then
    Result := 3
  else if s = 'Volgnummer' then
    Result := 4
  else if s = 'Brouwdatum' then
    Result := 5
  else if s = 'Type' then
    Result := 6
  else if s = 'IBU methode' then
    Result := 7
  else if s = 'Kleurmethode' then
    Result := 8
  else if s = 'Volume' then
    Result := 9
  else if s = 'Volume bij koken' then
    Result := 10
  else if s = 'Kooktijd' then
    Result := 11
  else if s = 'Brouwzaalrendement' then
    Result := 12
  else if s = 'Geschat begin SG' then
    Result := 13
  else if s = 'Geschat eind SG' then
    Result := 14
  else if s = 'Geschatte bitterheid' then
    Result := 15
  else if s = 'Geschatte kleur' then
    Result := 16
  else if s = 'Geschat alcohol%' then
    Result := 17

  else if s = 'Start tijd' then
    Result := 18
  else if s = 'pH aangepast met' then
    Result := 19
  else if s = 'pH na aanpassing' then
    Result := 20
  else if s = 'SG eind maischen' then
    Result := 21
  else if s = 'Maischrendement' then
    Result := 22
  else if s = 'Volume heetwatertank' then
    Result := 23
  else if s = 'Spoelwatersamenstelling' then
    Result := 24
  else if s = 'SG voor koken' then
    Result := 25
  else if s = 'pH voor koken' then
    Result := 26
  else if s = 'pH na koken' then
    Result := 27
  else if s = 'Volume voor koken' then
    Result := 28
  else if s = 'Volume na koken' then
    Result := 29
  else if s = 'Volume in gistvat' then
    Result := 30
  else if s = 'Brouwzaalrendement' then
    Result := 31
  else if s = 'Begin SG' then
    Result := 32
  else if s = 'Whirlpooltijd' then
    Result := 33
  else if s = 'Koelmethode' then
    Result := 34
  else if s = 'Koeltijd' then
    Result := 35
  else if s = 'Koelen tot' then
    Result:= 36
  else if s = 'Type beluchting' then
    Result:= 37
  else if s = 'Beluchtingstijd' then
    Result:= 38
  else if s = 'Beluchtingssnelheid' then
    Result:= 39
  else if s = 'Eind tijd' then
    Result := 40

  else if s = 'Vergistingsstadia' then
    Result := 41
  else if s = 'Temp. hoofdvergisting' then
    Result := 42
  else if s = 'Duur hoofdvergisting' then
    Result := 43
  else if s = 'Temp. start hoofdvg' then
    Result := 44
  else if s = 'Max. temp. hoofdvg' then
    Result := 45
  else if s = 'Eind temp. hoofdvg' then
    Result := 46
  else if s = 'SG eind hoofdvg' then
    Result := 47
  else if s = 'Temp. nagisting' then
    Result := 48
  else if s = 'Duur nagisting' then
    Result := 49
  else if s = 'Temp. lagering' then
    Result := 50
  else if s = 'Duur lagering' then
    Result := 51
  else if s = 'Eind SG' then
    Result := 52

  else if s = 'Datum verpakken' then
    Result := 53
  else if s = 'CO2 gehalte' then
    Result := 54
  else if s = 'Hergistingstemp.' then
    Result := 55
  else if s = 'Suikerequivalenten' then
    Result := 56
  else if s = 'Fust factor' then
    Result := 57
  else if s = 'CO2 gehalte in fust' then
    Result := 58
  else if s = 'Geforceerd op druk brengen?' then
    Result := 59
  else if s = 'Bottelsuiker naam' then
    Result := 60
  else if s = 'Vol.% alcohol' then
    Result := 61
  else if s = 'Volume op fles' then
    Result := 62
  else if s = 'Volume op fust' then
    Result := 63
  else if s = 'Fusten geforceerd op druk' then
    Result := 64
  else if s = 'Hergisttemp. fusten' then
    Result := 65
  else if s = 'Hoeveelheid bottelsuiker' then
    Result := 66
  else if s = 'Hoeveelheid suiker in fust' then
    Result := 67
  else if s = 'Druk op fust' then
    Result := 68

  else if s = 'Opslagtemperatuur' then
    Result := 69
  else if s = 'Leeftijd bij proeven' then
    Result := 70
  else if s = 'Proefnotities' then
    Result := 71
  else if s = 'Proef datum' then
    Result := 72
  else if s = 'Kleur' then
    Result := 73
  else if s = 'Helderheid' then
    Result := 74
  else if s = 'Schuim' then
    Result := 75
  else if s = 'Aroma' then
    Result := 76
  else if s = 'Smaak' then
    Result := 77
  else if s = 'Mondgevoel' then
    Result := 78
  else if s = 'Nasmaak' then
    Result := 79
  else if s = 'Waardering' then
    Result := 80

  else if s = 'Beslagdikte' then
    Result := 81
  else if s = 'Batch gesplitst' then
    Result := 82
  else if s = 'Afgesplitste batch' then
    Result := 83
  else if s = 'Afgesplitst van' then
    Result := 84
  else if s = 'SG in gistingsvat' then
    Result:= 85
  else if s = 'Gemiddelde maischtemperatuur' then
    Result:= 86
  else if s = 'Hoeveelheid zuur voor aanzuren spoelwater' then
    Result:= 87
  else if s = 'Zuur percentage' then
    Result:= 88
  else if s = 'Type zuur' then
    Result:= 89
  else if s = 'Bereken toe te voegen zuur of base' then
    Result:= 90;
end;

function TRecipe.GetNameByIndex(i: integer): string;
begin
  Result := inherited GetNameByIndex(i);
  case i of
    2: Result := 'Brouwer';
    3: Result := 'Assistent brouwer';
    4: Result := 'Volgnummer';
    5: Result := 'Brouwdatum';
    6: Result := 'Type';
    7: Result := 'IBU methode';
    8: Result := 'Kleurmethode';
    9: Result := 'Volume';
    10: Result := 'Volume bij koken';
    11: Result := 'Kooktijd';
    12: Result := 'Brouwzaalrendement';
    13: Result := 'Geschat begin SG';
    14: Result := 'Geschat eind SG';
    15: Result := 'Geschatte bitterheid';
    16: Result := 'Geschatte kleur';
    17: Result := 'Geschat alcohol%';
    18: Result := 'Start tijd';
    19: Result := 'pH aangepast met';
    20: Result := 'pH na aanpassing';
    21: Result := 'SG eind maischen';
    22: Result := 'Maischrendement';
    23: Result := 'Volume heetwatertank';
    24: Result := 'Spoelwatersamenstelling';
    25: Result := 'SG voor koken';
    26: Result := 'pH voor koken';
    27: Result := 'pH na koken';
    28: Result := 'Volume voor koken';
    29: Result := 'Volume na koken';
    30: Result := 'Volume in gistvat';
    31: Result := 'Brouwzaalrendement';
    32: Result := 'Begin SG';
    33: Result := 'Whirlpooltijd';
    34: Result := 'Koelmethode';
    35: Result := 'Koeltijd';
    36: Result := 'Koelen tot';
    37: Result := 'Type beluchting';
    38: Result := 'Beluchtingstijd';
    39: Result:= 'Beluchtingssnelheid';
    40: Result := 'Eind tijd';
    41: Result := 'Vergistingsstadia';
    42: Result := 'Temp. hoofdvergisting';
    43: Result := 'Duur hoofdvergisting';
    44: Result := 'Temp. start hoofdvg';
    45: Result := 'Max. temp. hoofdvg';
    46: Result := 'Eind temp. hoofdvg';
    47: Result := 'SG eind hoofdvg';
    48: Result := 'Temp. nagisting';
    49: Result := 'Duur nagisting';
    50: Result := 'Temp. lagering';
    51: Result := 'Duur lagering';
    52: Result := 'Eind SG';
    53: Result := 'Datum verpakken';
    54: Result := 'CO2 gehalte';
    55: Result := 'Hergistingstemp';
    56: Result := 'Suikerequivalenten';
    57: Result := 'Fust factor';
    58: Result := 'CO2 gehalte in fust';
    59: Result := 'Geforceerd op druk brengen?';
    60: Result := 'Bottelsuiker naam';
    61: Result := 'Vol.% alcohol';
    62: Result := 'Volume op fles';
    63: Result := 'Volume op fust';
    64: Result := 'Fusten geforceerd op druk';
    65: Result := 'Hergisttemp. fusten';
    66: Result := 'Hoeveelheid bottelsuiker';
    67: Result := 'Hoeveelheid suiker in fust';
    68: Result := 'Druk op fust';

    69: Result := 'Opslagtemperatuur';
    70: Result := 'Leeftijd bij proeven';
    71: Result := 'Proefnotities';
    72: Result := 'Proef datum';
    73: Result := 'Kleur';
    74: Result := 'Helderheid';
    75: Result := 'Schuim';
    76: Result := 'Aroma';
    77: Result := 'Smaak';
    78: Result := 'Mondgevoel';
    79: Result := 'Nasmaak';
    80: Result := 'Waardering';
    81: Result := 'Beslagdikte';
    82: Result := 'Batch gesplitst';
    83: Result := 'Afgesplitste batch';
    84: Result := 'Afgesplitst van';
    85: Result := 'SG in gistingsvat';
    86: Result:= 'Gemiddelde maischtemperatuur';
    87: Result:= 'Hoeveelheid zuur voor aanzuren spoelwater';
    88: Result:= 'Zuur percentage';
    89: Result:= 'Type zuur';
    90: Result:= 'Bereken toe te voegen zuur of base';
  end;
end;

procedure TRecipe.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
var
  iChild, iChild2: TDOMNode;
  i, n: integer;
  v : double;
begin
  iChild := Doc.CreateElement('RECIPE');
  iNode.AppendChild(iChild);
  inherited SaveXML(Doc, iChild, bxml);

  AddNode(Doc, iChild, 'TYPE', TypeName);
  if FStyle <> nil then
    FStyle.SaveXML(Doc, iChild, bxml);
  if FEquipment <> nil then
    FEquipment.SaveXML(Doc, iChild, bxml);
  FBrewer.SaveXML(Doc, iChild, bxml);
  FAsstBrewer.SaveXML(Doc, iChild, bxml);
  FBatchSize.SaveXML(Doc, iChild, bxml);
  FBoilSize.SaveXML(Doc, iChild, bxml);
  FBoilTime.SaveXML(Doc, iChild, bxml);
  FEfficiency.SaveXML(Doc, iChild, bxml);
  iChild2 := Doc.CreateElement('HOPS');
  iChild.AppendChild(iChild2);
  for i := Low(FHops) to High(FHops) do
    FHops[i].SaveXML(Doc, iChild2, bxml);
  iChild2 := Doc.CreateElement('FERMENTABLES');
  iChild.AppendChild(iChild2);
  for i := Low(FFermentables) to High(FFermentables) do
    FFermentables[i].SaveXML(Doc, iChild2, bxml);

  n := 0;
  for i := Low(FMiscs) to High(FMiscs) do
    if FMiscs[i].Name.Value <> '' then
      Inc(n);
  if n > 0 then
  begin
    iChild2 := Doc.CreateElement('MISCS');
    iChild.AppendChild(iChild2);
    for i := Low(FMiscs) to High(FMiscs) do
      FMiscs[i].SaveXML(Doc, iChild2, bxml);
  end;

  iChild2 := Doc.CreateElement('YEASTS');
  iChild.AppendChild(iChild2);
  for i := Low(FYeasts) to High(FYeasts) do
    FYeasts[i].SaveXML(Doc, iChild2, bxml);

  n := 0;
  for i := Low(FWaters) to High(FWaters) do
    if FWaters[i].Name.Value <> '' then
      Inc(n);
  if n > 0 then
  begin
    iChild2 := Doc.CreateElement('WATERS');
    iChild.AppendChild(iChild2);
    for i := Low(FWaters) to High(FWaters) do
      if FWaters[i].Name.Value <> '' then
        FWaters[i].SaveXML(Doc, iChild2, bxml);
  end;

  if FMash <> nil then
    FMash.SaveXML(Doc, iChild, bxml);
  FTasteNotes.SaveXML(Doc, iChild, bxml);
  FTastingRate.SaveXML(Doc, iChild, bxml);
  v:= FOG.Value;
  if FOG.Value <= 1 then FOG.Value:= FEstOG.Value;
  FOG.SaveXML(Doc, iChild, bxml);
  FOG.SaveXMLDisplayValue(Doc, iChild);
  FOG.Value:= v;
  v:= FFG.Value;
  if FFG.Value <= FFG.MinValue then FFG.Value:= FEstFG.Value;
  FFG.SaveXML(Doc, iChild, bxml);
  FFG.SaveXMLDisplayValue(Doc, iChild);
  FFG.Value:= v;
  FFermentationStages.SaveXML(Doc, iChild, bxml);
  FPrimaryAge.SaveXML(Doc, iChild, bxml);
  FPrimaryTemp.SaveXML(Doc, iChild, bxml);
  FSecondaryAge.SaveXML(Doc, iChild, bxml);
  FSecondaryTemp.SaveXML(Doc, iChild, bxml);
  FTertiaryAge.SaveXML(Doc, iChild, bxml);
  FTertiaryTemp.SaveXML(Doc, iChild, bxml);
  FAge.SaveXML(Doc, iChild, bxml);
  FAgeTemp.SaveXML(Doc, iChild, bxml);
  FDate.SaveXML(Doc, iChild, bxml);
  FCarbonation.SaveXML(Doc, iChild, bxml);
  FForcedCarbonation.SaveXML(Doc, iChild, bxml);
  FPrimingSugarName.SaveXML(Doc, iChild, bxml);
  FCarbonationTemp.SaveXML(Doc, iChild, bxml);
  FPrimingSugarEquiv.SaveXML(Doc, iChild, bxml);
  FKegPrimingFactor.SaveXML(Doc, iChild, bxml);
  //extensions
  FEstOG.SaveXML(Doc, iChild, bxml);
  FEstFG.SaveXML(Doc, iChild, bxml);
  CalcColor;
  FEstColor.SaveXML(Doc, iChild, bxml);
  CalcBitterness;
  FIBU.SaveXML(Doc, iChild, bxml);
  if bxml then
  begin
    if (IBUMethodName = IBUmethodNames[imDaniels]) or (IBUMethodName = IBUmethodNames[imMosher]) or (IBUMethodName = IBUmethodNames[imNoonan]) then
      AddNode(doc, iChild, 'IBU_METHOD', IBUMethodNames[imTinseth])
    else
      AddNode(Doc, iChild, 'IBU_METHOD', IBUmethodName);
  end
  else
    AddNode(Doc, iChild, 'IBU_METHOD', IBUmethodName);
  FEstABV.SaveXML(Doc, iChild, bxml);
  FABV.SaveXML(Doc, iChild, bxml);
  FActualEfficiency.SaveXML(Doc, iChild, bxml);
  FCalories.SaveXMLDisplayValue(Doc, iChild);

  FBatchSize.SaveXMLDisplayValue(Doc, iChild);
  FBoilSize.SaveXMLDisplayValue(Doc, iChild);
  FPrimaryTemp.SaveXMLDisplayValue(Doc, iChild);
  FSecondaryTemp.SaveXMLDisplayValue(Doc, iChild);
  FAgeTemp.SaveXMLDisplayValue(Doc, iChild);
  FCarbonationTemp.SaveXMLDisplayValue(Doc, iChild);
  //BrewBuddyXML
  if not bxml then
  begin
    FParentAutoNr.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'COLOR_METHOD', ColorMethodName);
    FNrRecipe.SaveXML(Doc, iChild, bxml);
    FEstOG.SaveXML(Doc, iChild, bxml);
    FpHAdjustmentWith.SaveXML(Doc, iChild, bxml);
    FAcidSparge.SaveXML(Doc, iChild, bxml);
    FAcidSpargePerc.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'SPARGE_ACID_TYPE', AcidTypeNames[FAcidSpargeType]);
    FpHAdjusted.SaveXML(Doc, iChild, bxml);
    FTargetpH.SaveXML(Doc, iChild, bxml);
    FSGEndMash.SaveXML(Doc, iChild, bxml);
    FVolumeHLT.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'SPARGE_WATER_COMP', IntToStr(FSpargeWaterComposition));
    FOgBeforeBoil.SaveXML(Doc, iChild, bxml);
    FpHBeforeBoil.SaveXML(Doc, iChild, bxml);
    FpHAfterBoil.SaveXML(Doc, iChild, bxml);
    FVolumeBeforeBoil.SaveXML(Doc, iChild, bxml);
    FVolumeAfterBoil.SaveXML(Doc, iChild, bxml);
    FVolumeFermenter.SaveXML(Doc, iChild, bxml);
    FOGFermenter.SaveXML(Doc, iChild, bxml);
    FWhirlpoolTime.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'COOLING_METHOD', CoolingMethodName);
    FCoolingTime.SaveXML(Doc, iChild, bxml);
    FCoolingTo.SaveXML(Doc, iChild, bxml);
    FTimeAeration.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'AERATION_TYPE', AerationTypeName);
    FAerationFlowRate.SaveXML(Doc, iChild, bxml);
    FSgEndPrimary.SaveXML(Doc, iChild, bxml);
    FStartTempPrimary.SaveXML(Doc, iChild, bxml);
    FMaxTempPrimary.SaveXML(Doc, iChild, bxml);
    FEndTempPrimary.SaveXML(Doc, iChild, bxml);
    FDateBottling.SaveXML(Doc, iChild, bxml);
    FVolumeBottles.SaveXML(Doc, iChild, bxml);
    FVolumeKegs.SaveXML(Doc, iChild, bxml);
    FCarbonationKegs.SaveXML(Doc, iChild, bxml);
    FForcedCarbonationKegs.SaveXML(Doc, iChild, bxml);
    FCarbonationTempKegs.SaveXML(Doc, iChild, bxml);
    FAmountPrimingBottles.SaveXML(Doc, iChild, bxml);
    FAmountPrimingKegs.SaveXML(Doc, iChild, bxml);
    FPressureKegs.SaveXML(Doc, iChild, bxml);

    FTasteDate.SaveXML(Doc, iChild, bxml);
    FTasteColor.SaveXML(Doc, iChild, bxml);
    FTasteTransparency.SaveXML(Doc, iChild, bxml);
    FTasteHead.SaveXML(Doc, iChild, bxml);
    FTasteAroma.SaveXML(Doc, iChild, bxml);
    FTasteTaste.SaveXML(Doc, iChild, bxml);
    FTasteMouthfeel.SaveXML(Doc, iChild, bxml);
    FTasteAftertaste.SaveXML(Doc, iChild, bxml);
    FTimeStarted.SaveXML(Doc, iChild, bxml);
    FTimeEnded.SaveXML(Doc, iChild, bxml);
    FInventoryReduced.SaveXML(Doc, iChild, bxml);
    FLocked.SaveXML(Doc, iChild, bxml);
    FFermMeasurements.SaveXML(Doc, iChild, bxml);
    AddNode(Doc, iChild, 'PRIMING_SUGAR_BOTTLES', PrimingSugarBottlesName);
    AddNode(Doc, iChild, 'PRIMING_SUGAR_KEGS', PrimingSugarKegsName);
    FDividedType.SaveXML(Doc, iChild, bxml);
    FDivisionType.SaveXML(Doc, iChild, bxml);
    FDivisionFrom.SaveXML(Doc, iChild, bxml);
    FCalcAcid.SaveXML(Doc, iChild, bxml);
    if (FRecType = rtBrew) and (FCheckList <> NIL) and (FCheckList.NumItems > 0) then
      FCheckList.SaveXML(Doc, iChild, bxml);
  end;
end;

procedure TRecipe.ReadXML(iNode: TDOMNode);
var
  i, j: integer;
  iChild, iChild2: TDOMNode;
  W, W2, W3: TWater;
  M: TMisc;
  DF, diff: double;
  s: string;
  dCa, dNa, dMg, dCl, dSO4, dHCO3: double;
  Na1, Na2, Ca1, Ca2, Mg1, Mg2: double;
  Cl1, Cl2, SO41, SO42, CO31, CO32: double;
  NaCl1, NaHCO31, CaCl21, CaCO31: double;
  NaCl2, NaHCO32, CaCl22, CaCO32: double;
  NaCl3, NaHCO33, CaCl23, CaCO33: double;
  NaCl4, NaHCO34, CaCl24, CaCO34: double;
  MgSO4, CaSO4: double;
  Neg1, Neg2, Neg3, Neg4, MaxNeg: double;
  Vol: double;
begin
  inherited ReadXML(iNode);
  FLockEfficiency := True;

  SetTypeName(GetNodeString(iNode, 'TYPE'));

  iChild := iNode.FindNode('STYLE');
  if iChild <> nil then
    FStyle.ReadXML(iChild);
  iChild := iNode.FindNode('EQUIPMENT');
  if iChild <> nil then
    FEquipment.ReadXML(iChild);
  FBrewer.ReadXML(iNode);
  FAsstBrewer.ReadXML(iNode);
  FBatchSize.ReadXML(iNode);
  FBoilSize.ReadXML(iNode);
  FBoilTime.ReadXML(iNode);
  FEfficiency.ReadXML(iNode);

  for i := Low(FHops) to High(FHops) do
    FHops[i].Free;
  SetLength(FHops, 0);
  iChild := iNode.FindNode('HOPS');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FHops, i);
      FHops[i - 1] := THop.Create(self);
      FHops[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;
  //correctie voor foutief geplaatst <notes> veld in BrouwVisie XML, waardoor er een lege hop wordt geïmporteerd
  for i:= High(FHops) downto Low(FHops) do
    if THop(FHops[i]).Name.Value = '' then
      RemoveHop(i);


  for i := Low(FFermentables) to High(FFermentables) do
    FFermentables[i].Free;
  SetLength(FFermentables, 0);
  iChild := iNode.FindNode('FERMENTABLES');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FFermentables, i);
      FFermentables[i - 1] := TFermentable.Create(self);
      FFermentables[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;

  for i := Low(FMiscs) to High(FMiscs) do
    FMiscs[i].Free;
  SetLength(FMiscs, 0);
  iChild := iNode.FindNode('MISCS');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FMiscs, i);
      FMiscs[i - 1] := TMisc.Create(self);
      FMiscs[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;
  //correctie voor foutief geplaatst <notes> veld in BrouwVisie XML, waardoor er een lege Misc wordt geïmporteerd
  for i:= High(FMiscs) downto Low(FMiscs) do
    if TMisc(FMiscs[i]).Name.Value = '' then
      RemoveMisc(i);

  for i := Low(FYeasts) to High(FYeasts) do
    FYeasts[i].Free;
  SetLength(FYeasts, 0);
  iChild := iNode.FindNode('YEASTS');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FYeasts, i);
      FYeasts[i - 1] := TYeast.Create(self);
      FYeasts[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;

  for i := Low(FWaters) to High(FWaters) do
    FWaters[i].Free;
  SetLength(FWaters, 0);
  iChild := iNode.FindNode('WATERS');
  if iChild <> nil then
  begin
    i := 0;
    iChild2 := iChild.FirstChild;
    while iChild2 <> nil do
    begin
      Inc(i);
      SetLength(FWaters, i);
      FWaters[i - 1] := TWater.Create(self);
      FWaters[i - 1].ReadXML(iChild2);
      iChild2 := iChild2.NextSibling;
    end;
  end;

  iChild := iNode.FindNode('MASH');
  if iChild <> nil then
    FMash.ReadXML(iChild);

  FTasteNotes.ReadXML(iNode);
  FTastingRate.ReadXML(iNode);
  FOG.ReadXML(iNode);
  FFG.ReadXML(iNode);
  FFermentationStages.ReadXML(iNode);
  FPrimaryAge.ReadXML(iNode);
  FPrimaryTemp.ReadXML(iNode);
  FSecondaryAge.ReadXML(iNode);
  FSecondaryTemp.ReadXML(iNode);
  FTertiaryAge.ReadXML(iNode);
  FTertiaryTemp.ReadXML(iNode);
  FAge.ReadXML(iNode);
  FAgeTemp.ReadXML(iNode);
  FDate.ReadXML(iNode);
  FCarbonation.ReadXML(iNode);
  FForcedCarbonation.ReadXML(iNode);
  FPrimingSugarName.ReadXML(iNode);
  FCarbonationTemp.ReadXML(iNode);
  FPrimingSugarEquiv.ReadXML(iNode);
  FKegPrimingFactor.ReadXML(iNode);
  //The recipe extensions are calculated by BrouwHulp
  FParentAutoNr.ReadXML(iNode);
  IBUMethodName := GetNodeString(iNode, 'IBU_METHOD');
  ColorMethodName := GetNodeString(iNode, 'COLOR_METHOD');
  FNrRecipe.ReadXML(iNode);
  FEstOG.ReadXML(iNode);
  FpHAdjustmentWith.ReadXML(iNode);
  FpHAdjusted.ReadXML(iNode);
  FTargetpH.ReadXML(iNode);
  FSGEndMash.ReadXML(iNode);
  FVolumeHLT.ReadXML(iNode);
  FSpargeWaterComposition := GetNodeInt(iNode, 'SPARGE_WATER_COMP');
  FAcidSparge.ReadXML(iNode);
  FAcidSpargePerc.ReadXML(iNode);
  AcidSpargeTypeName:= GetNodeString(iNode, 'SPARGE_ACID_TYPE');
  FOgBeforeBoil.ReadXML(iNode);
  FpHBeforeBoil.ReadXML(iNode);
  FpHAfterBoil.ReadXML(iNode);
  FVolumeBeforeBoil.ReadXML(iNode);
  FVolumeAfterBoil.ReadXML(iNode);
  FActualEfficiency.ReadXML(iNode);
  FVolumeFermenter.ReadXML(iNode);
  FOGFermenter.ReadXML(iNode);
  s := GetNodeString(iNode, 'COOLING_METHOD');
  if s = '' then
    FCoolingMethod := cmEmpty
  else
    CoolingMethodName := s;
  FCoolingTime.ReadXML(iNode);
  FCoolingTo.ReadXML(iNode);
  FWhirlpoolTime.ReadXML(iNode);
  FTimeAeration.ReadXML(iNode);
  AerationTypeName:= GetNodeString(iNode, 'AERATION_TYPE');
  FAerationFlowRate.ReadXML(iNode);
  FSgEndPrimary.ReadXML(iNode);
  FStartTempPrimary.ReadXML(iNode);
  FMaxTempPrimary.ReadXML(iNode);
  FEndTempPrimary.ReadXML(iNode);
  FDateBottling.ReadXML(iNode);
  FVolumeBottles.ReadXML(iNode);
  FVolumeKegs.ReadXML(iNode);
  FCarbonationKegs.ReadXML(iNode);
  FForcedCarbonationKegs.ReadXML(iNode);
  FCarbonationTempKegs.ReadXML(iNode);
  FAmountPrimingBottles.ReadXML(iNode);
  FAmountPrimingKegs.ReadXML(iNode);
  FPressureKegs.ReadXML(iNode);

  FTasteDate.ReadXML(iNode);
  FTasteColor.ReadXML(iNode);
  FTasteTransparency.ReadXML(iNode);
  FTasteHead.ReadXML(iNode);
  FTasteAroma.ReadXML(iNode);
  FTasteTaste.ReadXML(iNode);
  FTasteMouthfeel.ReadXML(iNode);
  FTasteAftertaste.ReadXML(iNode);
  FTimeStarted.ReadXML(iNode);
  FTimeEnded.ReadXML(iNode);
  FInventoryReduced.ReadXML(iNode);
  FLocked.ReadXML(iNode);
  FFermMeasurements.ReadXML(iNode);
  s := GetNodeString(iNode, 'PRIMING_SUGAR_BOTTLES');
  if s = '' then
    FPrimingSugarBottles := psSaccharose
  else
    PrimingSugarBottlesName := s;
  s := GetNodeString(iNode, 'PRIMING_SUGAR_KEGS');
  if s = '' then
    FPrimingSugarKegs := psSaccharose
  else
    PrimingSugarKegsName := s;
  FDividedType.ReadXML(iNode);
  FDivisionType.ReadXML(iNode);
  FDivisionFrom.ReadXML(iNode);
  FCalcAcid.ReadXML(iNode);
  if (FRecType = rtBrew) then FCheckList.ReadXML(iNode);

  CalcOG;
  CalcBitterness;

  //correctie voor foutieve BrewBuddyXML code
  for i := 0 to High(FWaters) do
  begin
    W := TWater(FWaters[i]);
    if W.FCaSO4.Value > 0 then
    begin
      M := AddMisc;
      M.Name.Value := 'CaSO4';
      M.AmountIsWeight.Value := True;
      M.Amount.Value := W.FCaSO4.Value;
      M.Amount.DisplayUnit := gram;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FCaCl2.Value > 0 then
    begin
      M := AddMisc;
      M.Name.Value := 'CaCl2';
      M.AmountIsWeight.Value := True;
      M.Amount.DisplayUnit := gram;
      M.Amount.Value := W.FCaCl2.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FCaCO3.Value > 0 then
    begin
      M := AddMisc;
      M.Name.Value := 'CaCO3';
      M.AmountIsWeight.Value := True;
      M.Amount.DisplayUnit := gram;
      M.Amount.Value := W.FCaCO3.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FMgSO4.Value > 0 then
    begin
      M := AddMisc;
      M.Name.Value := 'MgSO4';
      M.AmountIsWeight.Value := True;
      M.Amount.DisplayUnit := gram;
      M.Amount.Value := W.FMgSO4.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FNaHCO3.Value > 0 then
    begin
      M := AddMisc;
      M.Name.Value := 'NaHCO3';
      M.AmountIsWeight.Value := True;
      M.Amount.DisplayUnit := gram;
      M.Amount.Value := W.FNaHCO3.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FNaCl.Value > 0 then
    begin
      AddMisc;
      M := AddMisc;
      M.Name.Value := 'NaCl';
      M.AmountIsWeight.Value := True;
      M.Amount.DisplayUnit := gram;
      M.Amount.Value := W.FNaCl.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FLacticAcid.Value > 0 then
    begin
      AddMisc;
      M := AddMisc;
      M.Name.Value := 'Melkzuur';
      M.AmountIsWeight.Value := False;
      M.Amount.vUnit := liter;
      M.Amount.DisplayUnit := milliliter;
      M.Amount.Value := W.FLacticAcid.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FH3PO4.Value > 0 then
    begin
      AddMisc;
      M := TMisc(FMiscs[High(FMiscs)]);
      M.Name.Value := 'Fosforzuur';
      M.AmountIsWeight.Value := False;
      M.Amount.DisplayUnit := milliliter;
      M.Amount.Value := W.FH3PO4.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;
    if W.FHCl.Value > 0 then
    begin
      AddMisc;
      M := TMisc(FMiscs[High(FMiscs)]);
      M.Name.Value := 'Zoutzuur';
      M.AmountIsWeight.Value := False;
      M.Amount.DisplayUnit := milliliter;
      M.Amount.Value := W.FHCl.Value;
      M.MiscType := mtWaterAgent;
      M.Use := muMash;
    end;

    DF := W.FDilutionFactor.Value / 100;
    if DF > 0 then
    begin
      W2 := AddWater;
      W2.Name.Value := 'Gedestilleerd/RO water';
      W2.Amount.Value := DF * FMash.MashStep[0].InfuseAmount.Value;
      W := nil;
      for j := 0 to High(FWaters) do
        if FWaters[j].Name.Value = 'Original water' then
          W := TWater(FWaters[j]);
      if W <> nil then
        W.Amount.Value := (1 - DF) * FMash.MashStep[0].InfuseAmount.Value;
      W2.Calcium.Value := 0.0;
      W2.Sodium.Value := 0.0;
      W2.Magnesium.Value := 0.0;
      W2.Chloride.Value := 0.0;
      W2.Sulfate.Value := 0.0;
      W2.Bicarbonate.Value := 0.0;
      W2.pHwater.Value := 7.0;
    end;
  end;

  //Correctie voor foutieve BrouwHulp en BrouwVisie code
  if (NumWaters >= 2) then
  begin
    W := FindWater('Original water');
    W2 := FindWater('Treated water');
    if (W <> nil) and (W2 <> nil) then
    begin
      W3 := TWater.Create(self);

      if W.Chloride.Value > 0 then
        W.Name.Value := 'Kraanwater'
      else
        W.Name.Value := 'Gedemineraliseerd water';

      dCa := W2.Calcium.Value - W.Calcium.Value;
      dNa := W2.Sodium.Value - W.Sodium.Value;
      dMg := W2.Magnesium.Value - W.Magnesium.Value;
      dCl := W2.Chloride.Value - W.Chloride.Value;
      dSO4 := W2.Sulfate.Value - W.Sulfate.Value;
      dHCO3 := W2.Bicarbonate.Value - W.Bicarbonate.Value;

      DF := 0;
      if (dCa < 0) and (W.Calcium.Value > 0) then
      begin
        Diff := (W.Calcium.Value - W2.Calcium.Value) / W.Calcium.Value;
        if Diff > DF then
          DF := Diff;
      end;
      if (dCa < 0) and (W.Sodium.Value > 0) then
      begin
        Diff := (W.Sodium.Value - W2.Sodium.Value) / W.Sodium.Value;
        if Diff > DF then
          DF := Diff;
      end;
      if (dCa < 0) and (W.Magnesium.Value > 0) then
      begin
        Diff := (W.Magnesium.Value - W2.Magnesium.Value) / W.Magnesium.Value;
        if Diff > DF then
          DF := Diff;
      end;
      if (dCa < 0) and (W.Chloride.Value > 0) then
      begin
        Diff := (W.Chloride.Value - W2.Chloride.Value) / W.Chloride.Value;
        if Diff > DF then
          DF := Diff;
      end;
      if (dCa < 0) and (W.Sulfate.Value > 0) then
      begin
        Diff := (W.Sulfate.Value - W2.Sulfate.Value) / W.Sulfate.Value;
        if Diff > DF then
          DF := Diff;
      end;
      if (dCa < 0) and (W.Bicarbonate.Value > 0) then
      begin
        Diff := (W.Bicarbonate.Value - W2.Bicarbonate.Value) / W.Bicarbonate.Value;
        if Diff > DF then
          DF := Diff;
      end;

      if (DF > 0) and (FMash <> nil) then
      begin
        W3.Name.Value := 'Gedestilleerd/RO water';
        W.Amount.Value := (1 - DF) * FMash.MashWaterVolume;
        W3.Amount.Value := DF * FMash.MashWaterVolume;
      end;

      if (dCa <> 0) or (dNa > 0) or (dMg > 0) or (dCl > 0) or (dSO4 > 0) or
        (dHCO3 > 0) then
      begin
        Na1 := 0;
        Na2 := 0;
        Ca1 := 0;
        Ca2 := 0;
        Mg1 := 0;
        Mg2 := 0;
        Cl1 := 0;
        Cl2 := 0;
        SO41 := 0;
        SO42 := 0;
        CO31 := 0;
        CO32 := 0;
        dNa := 0;
        dCa := 0;
        dMg := 0;
        dCl := 0;
        dSO4 := 0;
        dHCO3 := 0;
        NaCl1 := 0;
        NaHCO31 := 0;
        CaCl21 := 0;
        CaCO31 := 0;
        NaCl2 := 0;
        NaHCO32 := 0;
        CaCl22 := 0;
        CaCO32 := 0;
        NaCl3 := 0;
        NaHCO33 := 0;
        CaCl23 := 0;
        CaCO33 := 0;
        NaCl4 := 0;
        NaHCO34 := 0;
        CaCl24 := 0;
        CaCO34 := 0;
        MgSO4 := 0;
        CaSO4 := 0;
        Neg1 := 0;
        Neg2 := 0;
        Neg3 := 0;
        Neg4 := 0;
        MaxNeg := 0;
        Vol := 0;

        // Get concentration of ions in diluted brewwater (1) and target water (2) in mmol/l
        Ca1 := W.Calcium.Value / MMCa;
        Ca2 := W2.Calcium.Value / MMCa;
        Mg1 := W.Magnesium.Value / MMMg;
        Mg2 := W2.Magnesium.Value / MMMg;
        Na1 := W.Sodium.Value / MMNa;
        Na2 := W2.Sodium.Value / MMNa;

        CO31 := W.Bicarbonate.Value / MMHCO3;
        CO32 := W2.Bicarbonate.Value / MMHCO3;
        SO41 := W.Sulfate.Value / MMSO4;
        SO42 := W2.Sulfate.Value / MMSO4;
        Cl1 := W.Sulfate.Value / MMSO4;
        Cl2 := W2.Sulfate.Value / MMSO4;

        Vol := W2.Amount.Value;

        dNa := MaxD(Na2 - Na1, 0);
        dCa := MaxD(Ca2 - Ca1, 0);
        dMg := MaxD(Mg2 - Mg1, 0);
        dCl := MaxD(Cl2 - Cl1, 0);
        dSO4 := MaxD(SO42 - SO41, 0);
        dHCO3 := MaxD(CO32 - CO31, 0);

        MgSO4 := dMg;
        CaSO4 := MaxD(dSO4 - dMg, 0);

        //situation 1: no Na2CO3
        NaHCO31 := 0;
        NaCl1 := dNa;
        CaCl21 := (dCl - dNa) / 2;
        CaCO31 := dHCO3;
        Neg1 := MinA([NaHCO31, NaCl1, CaCl21, CaCO31]);

        //situation 2: no NaCl
        NaCl2 := 0;
        CaCl22 := dCl / 2;
        CaCO32 := dCa + dMg - dSO4 - dCl / 2;
        NaHCO32 := dNa;
        Neg2 := MinA([NaHCO32, NaCl2, CaCl22, CaCO32]);

        //situation 3: no CaCO3
        CaCO33 := 0;
        NaHCO33 := dHCO3;
        NaCl3 := dNa - 2 * dHCO3;
        CaCl23 := dCa + dMg - dSO4;
        Neg3 := MinA([NaHCO33, NaCl3, CaCl23, CaCO33]);

        //situation 4: no CaCl2
        CaCl24 := 0;
        NaCl4 := dCl;
        CaCO34 := dCa + dMg - dSO4;
        NaHCO34 := dNa - dCl;
        Neg4 := MinA([NaHCO34, NaCl4, CaCl24, CaCO34]);

        MaxNeg := MaxA([Neg1, Neg2, Neg3, Neg4]);

        if Neg1 = MaxNeg then
        begin
          NaCl1 := MaxD(NaCl1, 0);
          CaCl21 := MaxD(CaCl21, 0);
          CaCO31 := MaxD(CaCO31, 0);
          NaHCO31 := MaxD(NaHCO31, 0);
        end
        else if Neg2 = MaxNeg then
        begin
          NaCl1 := MaxD(NaCl2, 0);
          CaCl21 := MaxD(CaCl22, 0);
          CaCO31 := MaxD(CaCO32, 0);
          NaHCO31 := MaxD(NaHCO32, 0);
        end
        else if Neg3 = MaxNeg then
        begin
          NaCl1 := MaxD(NaCl3, 0);
          CaCl21 := MaxD(CaCl23, 0);
          CaCO31 := MaxD(CaCO33, 0);
          NaHCO31 := MaxD(NaHCO33, 0);
        end
        else if Neg4 = MaxNeg then
        begin
          NaCl1 := MaxD(NaCl4, 0);
          CaCl21 := MaxD(CaCl24, 0);
          CaCO31 := MaxD(CaCO34, 0);
          NaHCO31 := MaxD(NaHCO34, 0);
        end;

        //calculate addition in kilograms per salt
        NaCl1 := NaCl1 * MMNaCl * Vol / 1000000;
        CaCl21 := CaCl21 * MMCaCl2 * Vol / 1000000;
        NaHCO31 := NaHCO31 * MMNaHCO3 * Vol / 1000000;
        CaCO31 := CaCO31 * MMCaCO3 * Vol / 1000000;
        MgSO4 := MgSO4 * MMMgSO4 * Vol / 1000000;
        CaSO4 := CaSO4 * MMCaSO4 * Vol / 1000000;
        if NaCl1 > 0 then
        begin
          M := FindMisc('NaCl');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'NaCl';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := NaCl1;
        end;
        if CaCl21 > 0 then
        begin
          M := FindMisc('CaCl2');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'CaCl2';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := CaCl21;
        end;
        if NaHCO31 > 0 then
        begin
          M := FindMisc('NaHCO3');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'NaHCO3';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := NaHCO31;
        end;
        if CaCO31 > 0 then
        begin
          M := FindMisc('CaCO3');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'CaCO3';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := CaCO31;
        end;
        if MgSO4 > 0 then
        begin
          M := FindMisc('MgSO4');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'MgSO4';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := MgSO4;
        end;
        if CaSO4 > 0 then
        begin
          M := FindMisc('CaSO4');
          if M = nil then
          begin
            M := AddMisc;
            M.Name.Value := 'CaSO4';
            M.AmountIsWeight.Value := True;
            M.Amount.DisplayUnit := gram;
            M.MiscType := mtWaterAgent;
            M.Use := muMash;
          end;
          M.Amount.Value := CaSO4;
        end;
      end;

      TWater(Water[0]).Assign(W);
      if DF > 0 then
        W2.Assign(W3);
      W3.Free;
      RemoveWaterByReference(W2);
      W := nil;
      W2 := nil;
      for i := NumWaters - 1 downto 2 do
        RemoveWater(i);
      vol := 0;
      for i := 0 to NumWaters - 1 do
        vol := vol + TWater(Water[0]).Amount.Value;
      if vol <> FMash.MashWaterVolume then
        TWater(Water[0]).Amount.Value :=
          TWater(Water[0]).Amount.Value - (vol - FMash.MashWaterVolume);
    end
    else if (W <> nil) then
    begin
      W.Amount.Value := FMash.MashWaterVolume;
    end;
  end
  else if (NumWaters = 1) and (FMash <> nil) then
  begin
    W := TWater(Water[0]);
    W.Amount.Value := FMash.MashWaterVolume;
  end;

  for i:= High(FWaters) downto Low(FWaters) do
    if TWater(Water[i]).Amount.Value = 0 then
      RemoveWater(i);
  CalcMashWater;
end;

Function CheckInterval(v, min, max : double) : double;
begin
  if (v >= min) and (v <= max) then Result:= v
  else Result:= -1000;
end;

Function TRecipe.GetNumberByIndex(i : longint) : double;
var x, y : double;
    j : integer;
begin
  Result:= 0;
  case i of
    //recept
    1: Result:= CheckInterval(Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, GetVolumeAfterBoil),
                              Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, 1),
                              Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, 1E10));
    2: Result := CheckInterval(FVolumeFermenter.DisplayValue, 1, 1E10);
    3: Result := CheckInterval(FBoilTime.DisplayValue, 10, 240);
    4: begin
         CalcOGFermenter;
         Result := CheckInterval(FOGFermenter.DisplayValue,
                                convert(FOGFermenter.vUnit, FOGFermenter.DisplayUnit, 1.001),
                                convert(FOGFermenter.vUnit, FOGFermenter.DisplayUnit, 1.299));
       end;
    5: Result:= CheckInterval(CalcIBUFermenter, 1, 200);   //always IBU
    6: Result:= CheckInterval(GetBUGU, 0.01, 3);
    7: Result:= CheckInterval(Convert(FEstColor.vUnit, FEstColor.DisplayUnit, CalcColorFermenter),
                              Convert(FEstColor.vUnit, FEstColor.DisplayUnit, 1),
                              Convert(FEstColor.vUnit, FEstColor.DisplayUnit, 1000));
    //vergistbare ingrediënten
    8: Result:= GetPercBaseMalt;
    9: Result:= CheckInterval(GetPercCrystalMalt, -1, 100);
    10: Result:= CheckInterval(GetPercRoastMalt, -1, 30);
    11: Result:= CheckInterval(GetPercSugar, -1, 50);
    12: Result:= CheckInterval(GetCa, 1, 500);
    13: Result:= CheckInterval(GetMg, 1, 500);
    14: Result:= CheckInterval(GetNa, 1, 500);
    15: Result:= CheckInterval(GetHCO3, 1, 500);
    16: Result:= CheckInterval(GetCl, 1, 500);
    17: Result:= CheckInterval(GetSO4, 1, 500);
    18: Result:= CheckInterval(GetRA, -200, 200);
    //maischen
    19: Result:= CheckInterval(GetMashThickness, 1, 10);
    20: if FMash <> NIL then
          Result:= CheckInterval(Convert(FPrimaryTemp.vUnit, FPrimaryTemp.DisplayUnit, FMash.AverageTemperature),
                                 Convert(FPrimaryTemp.vUnit, FPrimaryTemp.DisplayUnit, 50),
                                 Convert(FPrimaryTemp.vUnit, FPrimaryTemp.DisplayUnit, 75));
    21: if FMash <> NIL then
          Result:= CheckInterval(FMash.TotalMashTime, 5, 180);

    22: if FMash <> NIL then
          Result:= CheckInterval(FMash.TimeBelow65, 0, 240);
    23: if FMash <> NIL then
          Result:= CheckInterval(FMash.TimeAbove65, 0, 240);
    24: Result:= CheckInterval(Convert(FOG.vUnit, FOG.DisplayUnit, GetSGEndMashCalc),
                               Convert(FOG.vUnit, FOG.DisplayUnit, 1.010),
                               Convert(FOG.vUnit, FOG.DisplayUnit, 1.299));
    25: Result := CheckInterval(FpHAdjusted.Value, 4, 7);
    26: Result:= Convert(FEstColor.vUnit, FEstColor.DisplayUnit,CalcColorMash);
    27: Result:= CheckInterval(FSGEndMash.Value, 1.001, 1.299);
    28: Result:= CheckInterval(CalcMashEfficiency, 10, 150);
    29: Result:= CheckInterval(FMash.GetMashWaterVolume, 1, 100000);
    30:
        begin
          x:= FMash.GetMashWaterVolume;
          y:= FMash.SpargeVolume;
          if x > 0 then x:= y / x else x:= 0;
          Result:= CheckInterval(x, 0, 3);
        end;
    //spoelen
    31: Result:= CheckInterval((TimeStarted.Value - TimeEnded.Value) * 24 * 60, 1, 180); //minutes
    32: begin
          Result:= -100;
          if FMash <> NIL then
            Result:= CheckInterval(Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, FMash.SpargeVolume), 1, 1E10);
        end;
    //koken
    33: Result:= CheckInterval(Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, GetVolumeBeforeBoil),
                              Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, 1),
                              Convert(FBatchSize.vUnit, FBatchSize.DisplayUnit, 1E10));
    34: if FOGBeforeBoil.Value > 1.000 then
          Result := CheckInterval(FOGBeforeBoil.DisplayValue,
                                  Convert(FOGBeforeBoil.vUnit, FOGBeforeBoil.DisplayUnit, 1.001),
                                  Convert(FOGBeforeBoil.vUnit, FOGBeforeBoil.DisplayUnit, 1.299))
        else
        begin
          x:= GetSGStartBoil;
          Result:= CheckInterval(Convert(FOGBeforeBoil.vUnit, FOGBeforeBoil.DisplayUnit, x),
                                 Convert(FOGBeforeBoil.vUnit, FOGBeforeBoil.DisplayUnit, 1.001),
                                 Convert(FOGBeforeBoil.vUnit, FOGBeforeBoil.DisplayUnit, 1.299))
        end;
    35: Result := CheckInterval(FpHBeforeBoil.DisplayValue, 4, 7);
    36: Result := CheckInterval(FpHAfterBoil.DisplayValue, 4, 7);
    37: if FActualEfficiency.DisplayValue < 20 then
          Result := CheckInterval(CalcEfficiencyAfterBoil, 20, 99)
        else
          Result := CheckInterval(FActualEfficiency.DisplayValue, 25, 99);
    //koelen
    38: Result := CheckInterval(FWhirlpoolTime.DisplayValue, 1, 120);
    39: Result := CheckInterval(FCoolingTime.DisplayValue, 1, 120);
    40: Result := CheckInterval(FCoolingTo.DisplayValue, 1, 30);
    41: Result := CheckInterval(FTimeAeration.DisplayValue, 0.1, 90);
    42: Result := CheckInterval(FAerationFlowRate.DisplayValue, 0.1, 10);
    43: Result := CheckInterval(FTimeAeration.DisplayValue * FAerationFlowRate.DisplayValue,
                                0.1, 1E10);
    //vergisten
    44: Result:= CheckInterval(OverPitchFactor, 0, 1000);
    45: begin
          x:= 0;
          for j:= 0 to NumYeasts-1 do
          begin
            y:= TYeast(FYeasts[j]).Attenuation.Value;
            if y > x then x:= y;
          end;
          if x < 50 then Result:= -100 else Result:= x;
        end;
    46: Result := CheckInterval(FPrimaryTemp.DisplayValue,
                                Convert(FPrimaryTemp.vUnit, FPrimaryTemp.DisplayUnit, 5),
                                Convert(FPrimaryTemp.vUnit, FPrimaryTemp.DisplayUnit, 40));
    47: Result := CheckInterval(FPrimaryAge.DisplayValue, 1, 30);
    48: Result := CheckInterval(FStartTempPrimary.DisplayValue,
                                Convert(FStartTempPrimary.vUnit, FStartTempPrimary.DisplayUnit, 1),
                                Convert(FStartTempPrimary.vUnit, FStartTempPrimary.DisplayUnit, 40));
    49: Result := CheckInterval(FMaxTempPrimary.DisplayValue,
                                Convert(FMaxTempPrimary.vUnit, FMaxTempPrimary.DisplayUnit, 1),
                                Convert(FMaxTempPrimary.vUnit, FMaxTempPrimary.DisplayUnit, 40));
    50: Result := CheckInterval(FEndTempPrimary.DisplayValue,
                                Convert(FEndTempPrimary.vUnit, FEndTempPrimary.DisplayUnit, 1),
                                Convert(FEndTempPrimary.vUnit, FEndTempPrimary.DisplayUnit, 40));
    51: Result := CheckInterval(FSGEndPrimary.DisplayValue,
                                Convert(FSGEndPrimary.vUnit, FSGEndPrimary.DisplayUnit, 1.001),
                                Convert(FSGEndPrimary.vUnit, FSGEndPrimary.DisplayUnit, 1.299));
    52: Result := CheckInterval(FSecondaryTemp.DisplayValue,
                                Convert(FSecondaryTemp.vUnit, FSecondaryTemp.DisplayUnit, 1),
                                Convert(FSecondaryTemp.vUnit, FSecondaryTemp.DisplayUnit, 40));
    53: Result := CheckInterval(FSecondaryAge.DisplayValue, 1, 1000);
    54: Result := CheckInterval(FTertiaryTemp.DisplayValue,
                                Convert(FTertiaryTemp.vUnit, FTertiaryTemp.DisplayUnit, -3),
                                Convert(FTertiaryTemp.vUnit, FTertiaryTemp.DisplayUnit, 30));
    55: Result := CheckInterval(FTertiaryAge.DisplayValue, 1, 2000);
    56: Result := CheckInterval(FFG.DisplayValue,
                                Convert(FFG.vUnit, FFG.DisplayUnit, 1.0005),
                                Convert(FFG.vUnit, FFG.DisplayUnit, 1.050));
    57: Result := CheckInterval(GetApparentAttenuation, 60, 99);
    58: begin
          x:= CalcOGFermenter;
          x:= ABVol(x, FFG.Value);
          FABV.Value:= x;
          Result := CheckInterval(FABV.DisplayValue, 0.5, 20);
        end;
    //proeven
    59: Result := CheckInterval(FAgeTemp.DisplayValue,
                                Convert(FAgeTemp.vUnit, FAgeTemp.DisplayUnit, -3),
                                Convert(FAgeTemp.vUnit, FAgeTemp.DisplayUnit, 30));
    60: Result := CheckInterval(FAge.DisplayValue, 1, 3650);
    61: Result := CheckInterval(FTastingRate.DisplayValue, 0.1, 10);
  end;
end;

Function TRecipe.GetNumberDecimalsByName(s : string) : integer;
begin
  Result:= GetNumberDecimalsByIndex(GetNumberIndexByName(s));
end;

Function TRecipe.GetNumberDecimalsByIndex(i : longint) : integer;
begin
  Result:= 0;
  case i of
    //recept
    1: Result := FVolumeAfterBoil.Decimals;
    2: Result := FVolumeFermenter.Decimals;
    3: Result := FBoilTime.Decimals;
    4: Result:= FOGFermenter.Decimals;
    5: Result:= 0;   //always IBU
    6: Result:= 1;
    7: Result:= FEstColor.Decimals;
    //vergistbare ingrediënten
    8: Result:= 1;
    9: Result:= 1;
    10: Result:= 1;
    11: Result:= 1;
    12: Result:= 0;
    13: Result:= 0;
    14: Result:= 0;
    15: Result:= 0;
    16: Result:= 0;
    17: Result:= 0;
    18: Result:= 1;
    //maischen
    19: Result:= 1;
    20: Result:= 1;
    21: Result:= 0;
    22: Result:= 0;
    23: Result:= 0;
    24: Result:= FOG.Decimals;
    25: Result := FpHAdjusted.Decimals;
    26: Result:= FEstColor.Decimals;
    27: Result:= FSGEndMash.Decimals;
    28: Result:= 1;
    29: Result:= 1;
    //spoelen
    30: Result:= 2;
    31: Result:= 0; //minutes
    32: Result:= 1;
    //koken
    33: Result := FVolumeBeforeBoil.Decimals;
    34: Result := FOGBeforeBoil.Decimals;
    35: Result := FpHBeforeBoil.Decimals;
    36: Result := FpHAfterBoil.Decimals;
    37: Result := FActualEfficiency.Decimals;
    //koelen
    38: Result := FWhirlpoolTime.Decimals;
    39: Result := FCoolingTime.Decimals;
    40: Result := FCoolingTo.Decimals;
    41: Result := FTimeAeration.Decimals;
    42: Result := FAerationFlowRate.Decimals;
    43: Result := FTimeAeration.Decimals;
    //vergisten
    44: Result:= 2;
    45: Result:= 1;
    46: Result := FPrimaryTemp.Decimals;
    47: Result := FPrimaryAge.Decimals;
    48: Result := FStartTempPrimary.Decimals;
    49: Result := FMaxTempPrimary.Decimals;
    50: Result := FEndTempPrimary.Decimals;
    51: Result := FSGEndPrimary.Decimals;
    52: Result := FSecondaryTemp.Decimals;
    53: Result := FSecondaryAge.Decimals;
    54: Result := FTertiaryTemp.Decimals;
    55: Result := FTertiaryAge.Decimals;
    56: Result := FFG.Decimals;
    57: Result := 1;
    58: Result := 1;
    //proeven
    59: Result := FAgeTemp.Decimals;
    60: Result := FAge.Decimals;
    61: Result := FTastingRate.Decimals;
  end;
end;

Function TRecipe.GetNumberNameByIndex(i : Longint) : string;
begin
  Result:= '';
  case i of
    //recept
    1: Result := 'Volume eind koken';
    2: Result := 'Volume in gistvat';
    3: Result := 'Kooktijd';
    4: Result := 'SG in gistvat';
    5: Result:= 'Bitterheid';
    6: Result:= 'Bitterheidsindex';
    7: Result:= 'Kleur';
    //vergistbare ingrediënten
    8: Result:= '% basismout';
    9: Result:= '% cara/crystalmout';
    10: Result:= '% geroosterde mout';
    11: Result:= '% suiker';
    12: Result:= 'Ca';
    13: Result:= 'Mg';
    14: Result:= 'Na';
    15: Result:= 'HCO3';
    16: Result:= 'Cl';
    17: Result:= 'SO4';
    18: Result:= 'Restalkaliteit';
    //maischen
    19: Result:= 'Beslagdikte';
    20: Result:= 'Gem. maischtemp';
    21: Result:= 'Tot. maischduur';
    22: Result:= 'Tijd <= 65 graden';
    23: Result:= 'Tijd > 65 graden';
    24: Result:= 'SG eind maischen';
    25: Result := 'pH beslag';
    26: Result:= 'Kleur beslag';
    27: Result:= 'SG eind maischen';
    28: Result:= 'Maischrendement';
    29: Result:= 'Maischwater';
    //spoelen
    30: Result:= 'Spoelwater/maischwater';
    31: Result:= 'Spoeltijd';
    32: Result:= 'Spoelvolume';
    //koken
    33: Result := 'Volume start koken';
    34: Result := 'SG start koken';
    35: Result := 'pH start koken';
    36: Result := 'pH eind koken';
    37: Result := 'Brouwzaalrendement';
    //koelen
    38: Result := 'Whirlpooltijd';
    39: Result := 'Koeltijd';
    40: Result := 'Gekoeld tot';
    41: Result := 'Beluchtingstijd';
    42: Result := 'Beluchtingssnelheid';
    43: Result := 'Beluchtingshoeveelheid';
    //vergisten
    44: Result := 'Overpitch factor';
    45: Result := 'Vergistingsgraad van de gist';
    46: Result := 'Temp. hoofdvergisting';
    47: Result := 'Duur hoofdvergisting';
    48: Result := 'Start temp. hoofdverg.';
    49: Result := 'Max. temp. hoofdverg.';
    50: Result := 'Eind temp. hoofdverg.';
    51: Result := 'SG eind hoofdverg.';
    52: Result := 'Temp. nagisting';
    53: Result := 'Duur nagisting';
    54: Result := 'Temp. lagering';
    55: Result := 'Duur lagering';
    56: Result := 'Eind SG';
    57: Result := 'Schijnbare vergistingsgraad';
    58: Result := 'Alcoholgehalte';
    //proeven
    59: Result := 'Rijpingstemperatuur';
    60: Result := 'Rijpingstijd';
    61: Result := 'Waardering';
  end;
end;

Function TRecipe.GetNumberByName(s : string) : double;
begin
  Result:= GetNumberByIndex(GetNumberIndexByName(s));
end;

Function TRecipe.GetNumberIndexByName(s : string) : LongInt;
begin
  Result:= 0;
  //recept
  if s = 'Volume eind koken' then Result:= 1
  else if s = 'Volume in gistvat' then Result:= 2
  else if s = 'Kooktijd' then Result:= 3
  else if s = 'SG in gistvat' then Result:= 4
  else if s = 'Bitterheid' then Result:= 5
  else if s = 'Bitterheidsindex' then Result:= 6
  else if s = 'Kleur' then Result:= 7
  //vergistbare ingrediënten
  else if s = '% basismout' then Result:= 8
  else if s = '% cara/crystalmout' then Result:= 9
  else if s = '% geroosterde mout' then Result:= 10
  else if s = '% suiker' then Result:= 11
  else if s = 'Ca' then Result:= 12
  else if s = 'Mg' then Result:= 13
  else if s = 'Na' then Result:= 14
  else if s = 'HCO3' then Result:= 15
  else if s = 'Cl' then Result:= 16
  else if s = 'SO4' then Result:= 17
  else if s = 'Restalkaliteit' then Result:= 18
  //maischen
  else if s = 'Beslagdikte' then Result:= 19
  else if s = 'Gem. maischtemp' then Result:= 20
  else if s = 'Tot. maischduur' then Result:= 21
  else if s = 'Tijd <= 65 graden' then Result:= 22
  else if s = 'Tijd > 65 graden' then Result:= 23
  else if s = 'SG eind maischen' then Result:= 24
  else if s = 'pH beslag' then Result:= 25
  else if s = 'Kleur beslag' then Result:= 26
  else if s = 'SG eind maischen' then Result:= 27
  else if s = 'Maischrendement' then Result:= 28
  else if s = 'Maischwater' then Result:= 29
  //spoelen
  else if s = 'Spoelwater/maischwater' then Result:= 30
  else if s = 'Spoeltijd' then Result:= 31
  else if s = 'Spoelvolume' then Result:= 32
  //koken
  else if s = 'Volume start koken' then Result:= 33
  else if s = 'SG start koken' then Result:= 34
  else if s = 'pH start koken' then Result:= 35
  else if s = 'pH eind koken' then Result:= 36
  else if s = 'Brouwzaalrendement' then Result:= 37
  //koelen
  else if s = 'Whirlpooltijd' then Result:= 38
  else if s = 'Koeltijd' then Result:= 39
  else if s = 'Gekoeld tot' then Result:= 40
  else if s = 'Beluchtingstijd' then Result:= 41
  else if s = 'Beluchtingssnelheid' then Result:= 42
  else if s = 'Beluchtingshoeveelheid' then Result:= 43
  //vergisten
  else if s = 'Overpitch factor' then Result:= 44
  else if s = 'Vergistingsgraad van de gist' then Result:= 45
  else if s = 'Temp. hoofdvergisting' then Result:= 46
  else if s = 'Duur hoofdvergisting' then Result:= 47
  else if s = 'Start temp. hoofdverg.' then Result:= 48
  else if s = 'Max. temp. hoofdverg.' then Result:= 49
  else if s = 'Eind temp. hoofdverg.' then Result:= 50
  else if s = 'SG eind hoofdverg.' then Result:= 51
  else if s = 'Temp. nagisting' then Result:= 52
  else if s = 'Duur nagisting' then Result:= 53
  else if s = 'Temp. lagering' then Result:= 54
  else if s = 'Duur lagering' then Result:= 55
  else if s = 'Eind SG' then Result:= 56
  else if s = 'Schijnbare vergistingsgraad' then Result:= 57
  else if s = 'Alcoholgehalte' then Result:= 58
  //proeven
  else if s = 'Rijpingstemperatuur' then Result:= 59
  else if s = 'Rijpingstijd' then Result:= 60
  else if s = 'Waardering' then Result:= 61;
end;

Function TRecipe.GetNumberDisplayUnitByName(s : string) : string;
begin
  Result:= GetNumberDisplayUnitByIndex(GetNumberIndexByName(s));
end;

Function TRecipe.GetNumberDisplayUnitByIndex(i : longint) : string;
begin
  Result:= '';
  case i of
    //recept
    1: Result := FVolumeAfterBoil.DisplayUnitString;
    2: Result := FVolumeFermenter.DisplayUnitString;
    3: Result := FBoilTime.DisplayUnitString;
    4: Result := FOGFermenter.DisplayUnitString;
    5: Result:= UnitNames[ibu];   //always IBU
    6: Result:= 'BU/GU';
    7: Result:= FEstColor.DisplayUnitString;
    //vergistbare ingrediënten
    8: Result:= '%';
    9: Result:= '%';
    10: Result:= '%';
    11: Result:= '%';
    12: Result:= UnitNames[ppm];
    13: Result:= UnitNames[ppm];
    14: Result:= UnitNames[ppm];
    15: Result:= UnitNames[ppm];
    16: Result:= UnitNames[ppm];
    17: Result:= UnitNames[ppm];
    18: Result:= UnitNames[ppm];
    //maischen
    19: if FFermentables[0] <> NIL then
          Result:= FVolumeFermenter.DisplayUnitString + '/' + FFermentables[0].Amount.DisplayUnitString
        else Result:= FVolumeFermenter.DisplayUnitString + '/kg';
    20: Result:= FPrimaryTemp.DisplayUnitString;
    21: Result:= UnitNames[minuut];
    22: Result:= UnitNames[minuut];
    23: Result:= UnitNames[minuut];
    24: Result:= FOG.DisplayUnitString;
    25: Result := FpHAdjusted.DisplayUnitString;
    26: Result:= FEstColor.DisplayUnitString;
    27: Result:= FSGEndMash.DisplayUnitString;
    28: Result:= '%';
    29: Result:= FBatchSize.DisplayUnitString;
    //spoelen
    30: Result:= '-';
    31: Result:= UnitNames[minuut]; //minutes
    32: Result:= FBatchSize.DisplayUnitString;
    //koken
    33: Result := FVolumeBeforeBoil.DisplayUnitString;
    34: Result := FOGBeforeBoil.DisplayUnitString;
    35: Result := FpHBeforeBoil.DisplayUnitString;
    36: Result := FpHAfterBoil.DisplayUnitString;
    37: Result := FActualEfficiency.DisplayUnitString;
    //koelen
    38: Result := FWhirlpoolTime.DisplayUnitString;
    39: Result := FCoolingTime.DisplayUnitString;
    40: Result := FCoolingTo.DisplayUnitString;
    41: Result := FTimeAeration.DisplayUnitString;
    42: Result := FAerationFlowRate.DisplayUnitString;
    43: Result := UnitNames[liter];
    //vergisten
    44: Result:= '-';
    45: Result:= '%';
    46: Result := FPrimaryTemp.DisplayUnitString;
    47: Result := FPrimaryAge.DisplayUnitString;
    48: Result := FStartTempPrimary.DisplayUnitString;
    49: Result := FMaxTempPrimary.DisplayUnitString;
    50: Result := FEndTempPrimary.DisplayUnitString;
    51: Result := FSGEndPrimary.DisplayUnitString;
    52: Result := FSecondaryTemp.DisplayUnitString;
    53: Result := FSecondaryAge.DisplayUnitString;
    54: Result := FTertiaryTemp.DisplayUnitString;
    55: Result := FTertiaryAge.DisplayUnitString;
    56: Result := FFG.DisplayUnitString;
    57: Result := '%';
    58: Result := FABV.DisplayUnitString;
    //proeven
    59: Result := FAgeTemp.DisplayUnitString;
    60: Result := FAge.DisplayUnitString;
    61: Result := FTastingRate.DisplayUnitString;
  end;
end;

Function TRecipe.GetNumNumbers : Longint;
begin
  Result:= 61;
end;

function TRecipe.AddHop: THop;
begin
  SetLength(FHops, High(FHops) + 2);
  FHops[High(FHops)] := THop.Create(self);
  Result := THop(FHops[High(FHops)]);
end;

procedure TRecipe.RemoveHop(i: integer);
var
  j: integer;
begin
  if (i >= Low(FHops)) and (i <= High(FHops)) then
  begin
    FHops[i].Free;
    for j := i to High(FHops) - 1 do
      FHops[j] := FHops[j + 1];
    SetLength(FHops, High(FHops));
  end;
end;

procedure TRecipe.RemoveHopByReference(I: TIngredient);
var
  n: integer;
begin
  for n := Low(FHops) to High(FHops) do
    if FHops[n] = THop(I) then
    begin
      RemoveHop(n);
      Exit;
    end;
end;

procedure TRecipe.RemoveHops;
var
  i: integer;
begin
  for i := Low(FHops) to High(FHops) do
    FHops[i].Free;
  SetLength(FHops, 0);
end;

function TRecipe.GetNumHops: integer;
begin
  Result := High(FHops) + 1;
end;

function TRecipe.GetNumHopsMash: integer;
var
  i: integer;
  hub: set of THopUse;
begin
  hub := [huMash];
  Result := 0;
  if FHops <> nil then
    for i := 0 to NumHops - 1 do
      if Hop[i].Use in hub then
        Inc(Result);
end;

function TRecipe.GetNumHopsBoil: integer;
var
  i: integer;
  hub: set of THopUse;
begin
  hub := [huBoil, huFirstwort, huAroma];
  Result := 0;
  if FHops <> nil then
    for i := 0 to NumHops - 1 do
      if Hop[i].Use in hub then
        Inc(Result);
end;

function TRecipe.GetHop(i: integer): THop;
begin
  Result := nil;
  if (i >= Low(FHops)) and (i <= High(FHops)) then
    Result := THop(FHops[i]);
end;

function TRecipe.AddFermentable: TFermentable;
begin
  SetLength(FFermentables, High(FFermentables) + 2);
  FFermentables[High(FFermentables)] := TFermentable.Create(self);
  Result := TFermentable(FFermentables[High(FFermentables)]);
end;

procedure TRecipe.RemoveFermentable(i: integer);
var
  j: integer;
begin
  if (i >= Low(FFermentables)) and (i <= High(FFermentables)) then
  begin
    FFermentables[i].Free;
    for j := i to High(FFermentables) - 1 do
      FFermentables[j] := FFermentables[j + 1];
    j:= High(FFermentables);
    SetLength(FFermentables, j);
    j:= High(FFermentables);
    GetEfficiency;
    CalcWaterBalance;
    CalcColor;
  end;
end;

procedure TRecipe.RemoveFermentableByReference(I: TIngredient);
var
  n: integer;
begin
  for n := Low(FFermentables) to High(FFermentables) do
    if FFermentables[n] = TFermentable(I) then
    begin
      RemoveFermentable(n);
      Exit;
    end;
end;

procedure TRecipe.RemoveFermentables;
var
  i: integer;
begin
  for i := Low(FFermentables) to High(FFermentables) do
    FFermentables[i].Free;
  SetLength(FFermentables, 0);
end;

function TRecipe.GetNumFermentables: integer;
begin
  if FFermentables <> nil then
    Result := High(FFermentables) + 1
  else
    Result := 0;
end;

function TRecipe.GetNumFermentablesMash: integer;
var
  i: integer;
begin
  Result := 0;
  if FFermentables <> nil then
    for i := 0 to NumFermentables - 1 do
      if Fermentable[i].AddedType = atMash then
        Inc(Result);
end;

function TRecipe.GetNumFermentablesBoil: integer;
var
  i: integer;
begin
  Result := 0;
  if FFermentables <> nil then
    for i := 0 to NumFermentables - 1 do
      if Fermentable[i].AddedType = atBoil then
        Inc(Result);
end;

function TRecipe.GetFermentable(i: integer): TFermentable;
begin
  Result := nil;
  if (i >= Low(FFermentables)) and (i <= High(FFermentables)) then
    Result := TFermentable(FFermentables[i]);
end;

function TRecipe.GetBaseMalt(i : integer) : TFermentable;
var j, k : integer;
    F : TFermentable;
begin
  Result := nil;
  j:= GetNumBaseMalts;
  if (i >= 0) and (i < j) then
  begin
    j:= -1;
    for k:= Low(FFermentables) to High(FFermentables) do
    begin
      F:= TFermentable(FFermentables[k]);
      if (F.GrainType = gtBase) or (F.FermentableType = ftExtract)
      or (F.FermentableType = ftDryExtract) then Inc(j);
      if i = j then
      begin
        Result:= TFermentable(FFermentables[k]);
        Exit;
      end;
    end;
  end;
end;

function TRecipe.GetSpecialtyMalt(i : integer) : TFermentable;
var j, k : integer;
begin
  Result := nil;
  j:= GetNumSpecialtyMalts;
  if (i >= 0) and (i < j) then
  begin
    j:= -1;
    for k:= Low(FFermentables) to High(FFermentables) do
    begin
      if (TFermentable(FFermentables[k]).GrainType = gtRoast)
      or (TFermentable(FFermentables[k]).GrainType = gtCrystal)
      or (TFermentable(FFermentables[k]).GrainType = gtKilned)
      or (TFermentable(FFermentables[k]).GrainType = gtSour)
      or (TFermentable(FFermentables[k]).GrainType = gtSpecial)
      or (TFermentable(FFermentables[k]).FermentableType = ftAdjunct) then Inc(j);
      if i = j then
      begin
        Result:= TFermentable(FFermentables[k]);
        Exit;
      end;
    end;
  end;
end;

function TRecipe.GetSugar(i : integer) : TFermentable;
var j, k : integer;
begin
  Result := nil;
  j:= GetNumSugars;
  if (i >= 0) and (i < j) then
  begin
    j:= -1;
    for k:= Low(FFermentables) to High(FFermentables) do
    begin
      if (TFermentable(FFermentables[k]).FermentableType = ftSugar) then Inc(j);
      if i = j then
      begin
        Result:= TFermentable(FFermentables[k]);
        Exit;
      end;
    end;
  end;
end;

function TRecipe.GetNumBasemalts : integer;
var i : integer;
    F : TFermentable;
begin
  Result:= 0;
  for i:= Low(FFermentables) to High(FFermentables) do
  begin
    F:= TFermentable(FFermentables[i]);
    if (F.GrainType = gtBase) or (F.FermentableType = ftExtract)
    or (F.FermentableType = ftDryExtract) then
      Inc(Result);
  end;
end;

function TRecipe.GetNumSpecialtymalts : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FFermentables) to High(FFermentables) do
    if (TFermentable(FFermentables[i]).GrainType = gtRoast)
    or (TFermentable(FFermentables[i]).GrainType = gtCrystal)
    or (TFermentable(FFermentables[i]).GrainType = gtKilned)
    or (TFermentable(FFermentables[i]).GrainType = gtSour)
    or (TFermentable(FFermentables[i]).GrainType = gtSpecial)
    or (TFermentable(FFermentables[i]).FermentableType = ftAdjunct) then
      Inc(Result);
end;

function TRecipe.GetNumSugars : integer;
var i : integer;
begin
  Result:= 0;
  for i:= Low(FFermentables) to High(FFermentables) do
    if TFermentable(FFermentables[i]).FermentableType = ftSugar then
      Inc(Result);
end;

function TRecipe.AddMisc: TMisc;
begin
  SetLength(FMiscs, High(FMiscs) + 2);
  FMiscs[High(FMiscs)] := TMisc.Create(self);
  Result := TMisc(FMiscs[High(FMiscs)]);
end;

procedure TRecipe.RemoveMisc(i: integer);
var
  j: integer;
begin
  if (i >= Low(FMiscs)) and (i <= High(FMiscs)) then
  begin
    FMiscs[i].Free;
    for j := i to High(FMiscs) - 1 do
      FMiscs[j] := FMiscs[j + 1];
    SetLength(FMiscs, High(FMiscs));
  end;
end;

procedure TRecipe.RemoveMiscByReference(I: TIngredient);
var
  n: integer;
begin
  for n := Low(FMiscs) to High(FMiscs) do
    if FMiscs[n] = TMisc(I) then
    begin
      RemoveMisc(n);
      Exit;
    end;
end;

procedure TRecipe.RemoveMiscs;
var
  i: integer;
begin
  for i := Low(FMiscs) to High(FMiscs) do
    FMiscs[i].Free;
  SetLength(FMiscs, 0);
end;

function TRecipe.GetNumMiscs: integer;
begin
  if FMiscs = nil then
    Result := 0
  else
    Result := High(FMiscs) + 1;
end;

function TRecipe.GetNumMiscsBoil: integer;
var
  i: integer;
begin
  Result := 0;
  if FMiscs <> nil then
    for i := 0 to NumMiscs - 1 do
      if Misc[i].Use = muBoil then
        Inc(Result);
end;

function TRecipe.GetNumWaterAgents: integer;
var
  i: integer;
begin
  Result := 0;
  if FMiscs <> nil then
    for i := 0 to NumMiscs - 1 do
      if Misc[i].MiscType = mtWaterAgent then
        Inc(Result);
end;

function TRecipe.GetMisc(i: integer): TMisc;
begin
  Result := nil;
  if (i >= Low(FMiscs)) and (i <= High(FMiscs)) then
    Result := TMisc(FMiscs[i]);
end;

function TRecipe.AddYeast: TYeast;
begin
  SetLength(FYeasts, High(FYeasts) + 2);
  FYeasts[High(FYeasts)] := TYeast.Create(self);
  Result := TYeast(FYeasts[High(FYeasts)]);
end;

procedure TRecipe.RemoveYeast(i: integer);
var
  j: integer;
begin
  if (i >= Low(FYeasts)) and (i <= High(FYeasts)) then
  begin
    FYeasts[i].Free;
    for j := i to High(FYeasts) - 1 do
      FYeasts[j] := FYeasts[j + 1];
    SetLength(FYeasts, High(FYeasts));
  end;
end;

procedure TRecipe.RemoveYeastByReference(I: TIngredient);
var
  n: integer;
begin
  for n := Low(FYeasts) to High(FYeasts) do
    if FYeasts[n] = TYeast(I) then
    begin
      RemoveYeast(n);
      Exit;
    end;
end;

procedure TRecipe.RemoveYeasts;
var
  i: integer;
begin
  for i := Low(FYeasts) to High(FYeasts) do
    FYeasts[i].Free;
  SetLength(FYeasts, 0);
end;

function TRecipe.GetNumYeasts: integer;
begin
  Result := High(FYeasts) + 1;
end;

function TRecipe.GetYeast(i: integer): TYeast;
begin
  Result := nil;
  if (i >= Low(FYeasts)) and (i <= High(FYeasts)) then
    Result := TYeast(FYeasts[i]);
end;

function TRecipe.AddWater: TWater;
begin
  SetLength(FWaters, High(FWaters) + 2);
  FWaters[High(FWaters)] := TWater.Create(self);
  Result := TWater(FWaters[High(FWaters)]);
end;

procedure TRecipe.RemoveWater(i: integer);
var
  j: integer;
begin
  if (i >= Low(FWaters)) and (i <= High(FWaters)) then
  begin
    FWaters[i].Free;
    for j := i to High(FWaters) - 1 do
      FWaters[j] := FWaters[j + 1];
    SetLength(FWaters, High(FWaters));
  end;
end;

procedure TRecipe.RemoveWaterByReference(I: TIngredient);
var
  n: integer;
begin
  for n := Low(FWaters) to High(FWaters) do
    if FWaters[n] = TWater(I) then
    begin
      RemoveWater(n);
      Exit;
    end;
end;

procedure TRecipe.RemoveWaters;
var
  i: integer;
begin
  for i := Low(FWaters) to High(FWaters) do
    FWaters[i].Free;
  SetLength(FWaters, 0);
end;

function TRecipe.GetNumWaters: integer;
begin
  Result := High(FWaters) + 1;
end;

function TRecipe.GetWater(i: integer): TWater;
begin
  Result := nil;
  if (i >= Low(FWaters)) and (i <= High(FWaters)) then
    Result := TWater(FWaters[i]);
end;

function TRecipe.GetNumIngredients: integer;
begin
  Result := NumFermentables + NumHops + NumMiscs + NumYeasts + NumWaters;
end;

Procedure TRecipe.CalcNumMissingIngredients;
var i, n : integer;
    IDB : TIngredient;
    F : TFermentable;
    M : TMisc;
    Y : TYeast;
    SL : TStringList;
    s : string;
    amounts : array of double;
begin
  FNumMissingIngredients:= 0;
  for n:= 0 to NumFermentables - 1 do
  begin
    F:= Fermentable[n];
    if F <> NIL then
    begin
      IDB:= TIngredient(Fermentables.FindByNameOnStock(F.Name.Value));
      if IDB <> NIL then
      begin
        if IDB.Inventory.Value < F.Amount.Value then Inc(FNumMissingIngredients);
      end
      else Inc(FNumMissingIngredients);
    end;
  end;

  SetLength(Amounts, 0);
  SL:= TStringList.Create;
  //avoid dubble counts, make a list of unique hops
  for n:= 0 to NumHops - 1 do
  begin
    s:= Trim(Hop[n].Name.Value);
    i:= SL.Indexof(s);
    if i < 0 then
    begin
      SL.Add(s);
      SetLength(Amounts, high(amounts) + 2);
      amounts[high(amounts)]:= Hop[n].Amount.Value;
    end
    else
      amounts[i]:= amounts[i] + Hop[n].Amount.Value;
  end;
  for n:= 0 to SL.Count - 1 do
  begin
    IDB:= TIngredient(Hops.FindByNameOnStock(SL[n]));
    if IDB <> NIL then
    begin
      if IDB.Inventory.Value < amounts[n] then Inc(FNumMissingIngredients);
    end
    else Inc(FNumMissingIngredients);
  end;
  SetLength(amounts, 0);
  FreeAndNIL(SL);

  for n:= 0 to NumMiscs - 1 do
  begin
    M:= Misc[n];
    if M <> NIL then
    begin
      IDB:= TMisc(Miscs.FindByName(M.Name.Value));
      if IDB <> NIL then
      begin
        if IDB.Inventory.Value < M.Amount.Value then Inc(FNumMissingIngredients);
      end
      else Inc(FNumMissingIngredients);
    end;
  end;
  for n:= 0 to NumYeasts - 1 do
  begin
    Y:= Yeast[n];
    if Y <> NIL then
    begin
      IDB:= Yeasts.FindByNameAndLaboratory(Y.Name.Value, Y.Laboratory.Value);
      if IDB <> NIL then
      begin
        if IDB.Inventory.Value = 0 then Inc(FNumMissingIngredients);
      end
      else Inc(FNumMissingIngredients);
    end;
  end;
end;

function TRecipe.GetIngredientIndex(I: TIngredient): integer;
var
  j: integer;
begin
  Result := -1;
  for j := 0 to NumFermentables - 1 do
    if Fermentable[j] = I then
    begin
      Result := j;
      Exit;
    end;
  for j := 0 to NumHops - 1 do
    if Hop[j] = I then
    begin
      Result := NumFermentables + j;
      Exit;
    end;
  for j := 0 to NumMiscs - 1 do
    if Misc[j] = I then
    begin
      Result := NumFermentables + NumHops + j;
      Exit;
    end;
  for j := 0 to NumYeasts - 1 do
    if Yeast[j] = I then
    begin
      Result := NumFermentables + NumHops + NumMiscs + j;
      Exit;
    end;
  for j := 0 to NumWaters - 1 do
    if Water[j] = I then
    begin
      Result := NumFermentables + NumHops + NumMiscs + NumYeasts + j;
      Exit;
    end;
end;

function TRecipe.GetIngredient(i: integer): TIngredient;
begin
  Result := nil;
  if i < NumFermentables then
    Result := Fermentable[i]
  else if i < NumFermentables + NumHops then
    Result := Hop[i - NumFermentables]
  else if i < NumFermentables + NumHops + NumMiscs then
    Result := Misc[i - NumFermentables - NumHops]
  else if i < NumFermentables + NumHops + NumMiscs + NumYeasts then
    Result := Yeast[i - NumFermentables - NumHops - NumMiscs]
  else if i < NumFermentables + NumHops + NumMiscs + NumYeasts + NumWaters then
    Result := Water[i - NumFermentables - NumHops - NumMiscs - NumYeasts];
end;

function TRecipe.GetIngredientType(i: integer): TIngredientType;
var
  Ing: TIngredient;
begin
  Result := itMisc;
  Ing := Ingredient[i];
  if Ing <> nil then
    Result := Ingredient[i].IngredientType;
end;

procedure TRecipe.RemoveIngredient(i: integer);
begin
  if i < NumFermentables then
    RemoveFermentable(i)
  else if i < NumFermentables + NumHops then
    RemoveHop(i - NumFermentables)
  else if i < NumFermentables + NumHops + NumMiscs then
    RemoveMisc(i - NumFermentables - NumHops)
  else if i < NumFermentables + NumHops + NumMiscs + NumYeasts then
    RemoveYeast(i - NumFermentables - NumHops - NumMiscs)
  else if i < NumFermentables + NumHops + NumMiscs + NumYeasts + NumWaters then
    RemoveWater(i - NumFermentables - NumHops - NumMiscs - NumYeasts);
end;

function TRecipe.GetTypeName: string;
begin
  Result := RecipeTypeNames[FRecipeType];
end;

procedure TRecipe.SetTypeName(s: string);
var
  rt: TRecipeType;
begin
  for rt := Low(RecipeTypeNames) to High(RecipeTypeNames) do
    if LowerCase(RecipeTypeNames[rt]) = LowerCase(s) then
      FRecipeType := rt;
end;

function TRecipe.GetTypeDisplayName: string;
begin
  Result := RecipeTypeDisplayNames[FRecipeType];
end;

procedure TRecipe.SetTypeDisplayName(s: string);
var
  rt: TRecipeType;
begin
  for rt := Low(RecipeTypeDisplayNames) to High(RecipeTypeDisplayNames) do
    if LowerCase(RecipeTypeDisplayNames[rt]) = LowerCase(s) then
      FRecipeType := rt;
end;

procedure TRecipe.SetIBUmethod(im: TIBUmethod);
begin
  if FIBUmethod <> im then
  begin
    FIBUmethod := im;
    CalcBitterness;
  end;
end;

function TRecipe.GetIBUMethodName: string;
begin
  Result := IBUmethodNames[FIBUmethod];
end;

procedure TRecipe.SetIBUMethodName(s: string);
var
  im: TIBUmethod;
begin
  for im := Low(IBUmethodNames) to High(IBUmethodNames) do
    if LowerCase(IBUmethodNames[im]) = LowerCase(s) then
      FIBUmethod := im;
end;

function TRecipe.GetIBUMethodDisplayName: string;
begin
  Result := IBUmethodDisplayNames[FIBUmethod];
end;

procedure TRecipe.SetIBUMethodDisplayName(s: string);
var
  im: TIBUmethod;
begin
  for im := Low(IBUmethodDisplayNames) to High(IBUmethodDisplayNames) do
    if LowerCase(IBUmethodDisplayNames[im]) = LowerCase(s) then
      FIBUmethod := im;
end;

procedure TRecipe.SetColorMethod(cm: TColorMethod);
begin
  if FColorMethod <> cm then
  begin
    FColorMethod := cm;
    CalcColor;
  end;
end;

function TRecipe.GetColorMethodName: string;
begin
  Result := ColorMethodNames[FColorMethod];
end;

procedure TRecipe.SetColorMethodName(s: string);
var
  cm: TColormethod;
begin
  for cm := Low(ColorMethodNames) to High(ColorMethodNames) do
    if LowerCase(ColorMethodNames[cm]) = LowerCase(s) then
      FColorMethod := cm;
end;

function TRecipe.GetColorMethodDisplayName: string;
begin
  Result := ColorMethodDisplayNames[FColorMethod];
end;

procedure TRecipe.SetColorMethodDisplayName(s: string);
var
  cm: TColormethod;
begin
  for cm := Low(ColorMethodDisplayNames) to High(ColorMethodDisplayNames) do
    if LowerCase(ColorMethodDisplayNames[cm]) = LowerCase(s) then
      FColorMethod := cm;
end;

function TRecipe.GetVolumeBeforeBoil : double;
begin
  if FVolumeBeforeBoil.Value > 0 then Result:= FVolumeBeforeBoil.Value
  else Result:= FBoilSize.Value;
end;

function TRecipe.GetVolumeAfterBoil : double;
begin
  if FVolumeAfterBoil.Value > 0 then Result:= FVolumeAfterBoil.Value
  else Result:= FBatchSize.Value;
end;


procedure MixWater(W1, W2, Wr: TWater);

  function Mix(V1, V2, C1, C2: double): double;
  begin
    if (V1 + V2) > 0 then
      Result := (V1 * C1 + V2 * C2) / (V1 + V2)
    else
      Result := 0;
  end;

var
  vol1, vol2: double;
  phnew: double;
begin
  vol1 := W1.Amount.Value;
  vol2 := W2.Amount.Value;
  if (vol1 + vol2) > 0 then
  begin
    Wr.Amount.Value := vol1 + vol2;
    Wr.Calcium.Value := Mix(vol1, vol2, W1.Calcium.Value, W2.Calcium.Value);
    Wr.Magnesium.Value := Mix(vol1, vol2, W1.Magnesium.Value, W2.Magnesium.Value);
    Wr.Sodium.Value := Mix(vol1, vol2, W1.Sodium.Value, W2.Sodium.Value);
    Wr.Bicarbonate.Value := Mix(vol1, vol2, W1.Bicarbonate.Value, W2.Bicarbonate.Value);
    Wr.Sulfate.Value := Mix(vol1, vol2, W1.Sulfate.Value, W2.Sulfate.Value);
    Wr.Chloride.Value := Mix(vol1, vol2, W1.Chloride.Value, W2.Chloride.Value);
    pHnew := -log10((power(10, -W1.pHWater.Value) * vol1 +
      power(10, -W2.pHWater.Value) * vol2) / (vol1 + vol2));
    Wr.pHwater.Value := pHnew;
  end;
end;

function TRecipe.GetCoolingMethodName: string;
begin
  Result := CoolingMethodNames[FCoolingMethod];
end;

procedure TRecipe.SetCoolingMethodName(s: string);
var
  cm: TCoolingMethod;
begin
  for cm := Low(CoolingMethodNames) to High(CoolingMethodNames) do
    if LowerCase(CoolingMethodNames[cm]) = LowerCase(s) then
      FCoolingMethod := cm;
end;

function TRecipe.GetCoolingMethodDisplayName: string;
begin
  Result := CoolingMethodDisplayNames[FCoolingMethod];
end;

procedure TRecipe.SetCoolingMethodDisplayName(s: string);
var
  cm: TCoolingMethod;
begin
  for cm := Low(CoolingMethodDisplayNames) to High(CoolingMethodDisplayNames) do
    if LowerCase(CoolingMethodDisplayNames[cm]) = LowerCase(s) then
      FCoolingMethod := cm;
end;

function TRecipe.GetAerationTypeName : string;
begin
  Result:= AerationTypeNames[FAerationType];
end;

procedure TRecipe.SetAerationTypeName(s : string);
var at : TAerationType;
begin
  for at:= Low(AerationTypeNames) to High(AerationTypeNames) do
    if LowerCase(AerationTypeNames[at]) = LowerCase(s) then
      FAerationType:= at;
end;

function TRecipe.GetAerationTypeDisplayName : string;
begin
  Result:= AerationTypeDisplayNames[FAerationType];
end;

procedure TRecipe.SetAerationTypeDisplayName(s : string);
var at : TAerationType;
begin
  for at:= Low(AerationTypeDisplayNames) to High(AerationTypeDisplayNames) do
    if LowerCase(AerationTypeDisplayNames[at]) = LowerCase(s) then
      FAerationType:= at;
end;

Function TRecipe.GetAcidSpargeTypeName : string;
begin
  Result:= AcidTypeNames[FAcidSpargeType];
end;

procedure TRecipe.SetAcidSpargeTypeName(s : string);
var at : TAcidType;
begin
  for at:= Low(AcidTypeNames) to High(AcidTypeNames) do
    if LowerCase(AcidTypeNames[at]) = LowerCase(s) then
      FAcidSpargeType:= at;
end;

Function TRecipe.GetAcidSpargeTypeDisplayName : string;
begin
  Result:= AcidTypeDisplayNames[FAcidSpargeType];
end;

procedure TRecipe.SetAcidSpargeTypeDisplayName(s : string);
var at : TAcidType;
begin
  for at:= Low(AcidTypeDisplayNames) to High(AcidTypeDisplayNames) do
    if LowerCase(AcidTypeDisplayNames[at]) = LowerCase(s) then
      FAcidSpargeType:= at;
end;

function TRecipe.GetPrimingSugarBottlesName: string;
begin
  Result := PrimingSugarNames[FPrimingSugarBottles];
end;

procedure TRecipe.SetPrimingSugarBottlesName(s: string);
var
  ps: TPrimingSugar;
begin
  FPrimingSugarBottles := psSaccharose;
  for ps := Low(PrimingSugarNames) to High(PrimingSugarNames) do
    if LowerCase(PrimingSugarNames[ps]) = LowerCase(s) then
      FPrimingSugarBottles := ps;
end;

function TRecipe.GetPrimingSugarBottlesDisplayName: string;
begin
  Result := PrimingSugarDisplayNames[FPrimingSugarBottles];
end;

procedure TRecipe.SetPrimingSugarBottlesDisplayName(s: string);
var
  ps: TPrimingSugar;
begin
  FPrimingSugarBottles := psSaccharose;
  for ps := Low(PrimingSugarDisplayNames) to High(PrimingSugarDisplayNames) do
    if LowerCase(PrimingSugarDisplayNames[ps]) = LowerCase(s) then
      FPrimingSugarBottles := ps;
end;

function TRecipe.GetPrimingSugarKegsName: string;
begin
  Result := PrimingSugarNames[FPrimingSugarKegs];
end;

procedure TRecipe.SetPrimingSugarKegsName(s: string);
var
  ps: TPrimingSugar;
begin
  FPrimingSugarKegs := psSaccharose;
  for ps := Low(PrimingSugarNames) to High(PrimingSugarNames) do
    if LowerCase(PrimingSugarNames[ps]) = LowerCase(s) then
      FPrimingSugarKegs := ps;
end;

function TRecipe.GetPrimingSugarKegsDisplayName: string;
begin
  Result := PrimingSugarDisplayNames[FPrimingSugarKegs];
end;

procedure TRecipe.SetPrimingSugarKegsDisplayName(s: string);
var
  ps: TPrimingSugar;
begin
  FPrimingSugarKegs := psSaccharose;
  for ps := Low(PrimingSugarDisplayNames) to High(PrimingSugarDisplayNames) do
    if LowerCase(PrimingSugarDisplayNames[ps]) = LowerCase(s) then
      FPrimingSugarKegs := ps;
end;

function TRecipe.GetGrainMass: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FFermentables) to High(FFermentables) do
    if (TFermentable(FFermentables[i]).FermentableType = ftGrain) or
      (TFermentable(FFermentables[i]).FermentableType = ftAdjunct) then
      Result := Result + FFermentables[i].Amount.Value;
end;

procedure TRecipe.ChangeEquipment(E: TEquipment);
begin
  FEquipment.Assign(E);
  CalcWaterBalance;
end;

procedure TRecipe.CalcBitterness;
var
  i: integer;
  H: THop;
  b: double;
begin
  b := 0;
  for i := Low(FHops) to High(FHops) do
  begin
    H := THop(FHops[i]);
    b := b + H.BitternessContribution;
  end;
  FIBU.Value := b;
end;

function TRecipe.GetAromaBitterness : double;
var
  i: integer;
  H: THop;
begin
  Result:= 0;
  for i:= Low(FHops) to High(FHops) do
  begin
    H:= THop(FHops[i]);
    if H.Time.Value < 45 then Result:= Result + H.BitternessContribution;
  end;
end;

procedure TRecipe.AdjustBitterness(NewIBU: double);
var
  i, numb: integer;
  H: THop;
  perc: array of double;
  a, totb, tot, ibuaroma, iburest, iburestnew, totibu: double;
begin
  ibuaroma := 0;
  totb := 0;
  tot := 0;
  numb:= 0;
  SetLength(perc, High(FHops) + 1);
  for i := Low(FHops) to High(FHops) do
  begin
    H := THop(FHops[i]);
    a := H.BitternessContribution;
    tot := tot + a;
    if H.Time.Value < 45 then
    begin
      ibuaroma := ibuaroma + a;
      perc[i] := 0;
    end
    else
    begin
      perc[i] := a;
      totb := totb + a;
      Inc(numb);
    end;
  end;
  if totb > 0 then
    for i := Low(perc) to High(perc) do
      perc[i] := perc[i] / totb
  else if numb > 0 then
    for i := Low(perc) to High(perc) do
      if THop(FHops[i]).Time.Value >= 45 then
        perc[i] := 100 / numb;

  iburest := FIBU.Value;
  iburestnew := NewIBU - ibuaroma;
  totibu := 0;

  if (iburestnew >= 0) and (iburest > 0) and (numb > 0) then
  begin
    for i := Low(FHops) to High(FHops) do
    begin
      H := THop(FHops[i]);
      if H.Time.Value >= 45 then
        H.BitternessContribution := perc[i] * iburestnew;
      totibu := totibu + H.BitternessContribution;
    end;
  end
  else if (tot > 0) then
    //there is no hop that boils for longer than 45 minutes. Adjust all bitterness contributions.
  begin
    for i := Low(FHops) to High(FHops) do
    begin
      H := THop(FHops[i]);
      perc[i] := H.BitternessContribution / tot;
      if perc[i] > 0 then H.BitternessContribution := perc[i] * NewIBU;
      totibu := totibu + H.BitternessContribution;
    end;
  end;
  SetLength(perc, 0);
  FIBU.Value:= NewIBU;
  //  CalcBitterness;
end;

Function TRecipe.CalcBitternessWort : double;
var
  i: integer;
  H: THop;
begin
  result := 0;
  for i := Low(FHops) to High(FHops) do
  begin
    H := THop(FHops[i]);
    Result := Result + H.BitternessContributionWort;
  end;
end;

procedure TRecipe.CalcColor;
var
  i: integer;
  F: TFermentable;
  c, v: double;
begin
  c := 0;
  v := FBatchSize.Value;
  if (v > 0) and (High(FFermentables) >= 0) then
  begin
    for i := Low(FFermentables) to High(FFermentables) do
    begin
      F := TFermentable(FFermentables[i]);
      c := c + F.Amount.Value * F.Color.Value / v;
    end;
    c := c * 8.34436;
    case FColorMethod of
      cmMorey: c := 1.49 * Power(c, 0.69);
      cmMosher: c := 0.3 * c + 4.7;
      cmDaniels: c := 0.2 * c + 8.4;
    end;
  end;
  if (FEquipment <> NIL) and ((FBatchSize.Value - FEquipment.TrubChillerLoss.Value + FEquipment.TopUpWater.Value) > 0) then
  begin
    c:= c * (FBatchSize.Value - FEquipment.TrubChillerLoss.Value)
        / (FBatchSize.Value - FEquipment.TrubChillerLoss.Value + FEquipment.TopUpWater.Value);
  end;
  FEstColor.Value := c;
end;

function TRecipe.CalcColorWort : double;
var
  i: integer;
  F: TFermentable;
  c, v: double;
begin
  c := 0;
  v := FBatchSize.Value;
  if (v > 0) and (High(FFermentables) >= 0) then
  begin
    for i := Low(FFermentables) to High(FFermentables) do
    begin
      F := TFermentable(FFermentables[i]);
      c := c + F.Amount.Value * F.Color.Value / v;
    end;
    c := c * 8.34436;
    case FColorMethod of
      cmMorey: c := 1.49 * Power(c, 0.69);
      cmMosher: c := 0.3 * c + 4.7;
      cmDaniels: c := 0.2 * c + 8.4;
    end;
  end;
  Result:= c;
end;

function TRecipe.CalcColorMash: double;
var
  i: integer;
  F: TFermentable;
  v: double;
begin
  Result := 0;
  if FMash <> nil then
  begin
    v := FMash.MashWaterVolume;
    if v > 0 then
    begin
      for i := Low(FFermentables) to High(FFermentables) do
      begin
        F := TFermentable(FFermentables[i]);
        if F.AddedType = atMash then
          Result := Result + F.Amount.Value * F.Color.Value / v;
      end;
      Result := Result * 8.34436;
      case FColorMethod of
        cmMorey: Result := 1.49 * Power(Result, 0.69);
        cmMosher: Result := 0.3 * Result + 4.7;
        cmDaniels: Result := 0.2 * Result + 8.4;
      end;
    end;
  end;
end;

procedure TRecipe.CalcWaterBalance;
var
  i: integer;
  F: TFermentable;
begin
  FAbsorbedByGrain := 0;
  for i := Low(FFermentables) to High(FFermentables) do
  begin
    F := TFermentable(FFermentables[i]);
    if (F.FermentableType = ftGrain) or (F.FermentableType = ftAdjunct) then
      FAbsorbedByGrain := FAbsorbedByGrain + F.Amount.Value;
  end;
  FAbsorbedByGrain := FAbsorbedByGrain * Settings.GrainAbsorption.Value;

  if FEquipment.CalcBoilVolume.Value then
    {FBoilSize.Value := FBatchSize.Value / (1 - (FEquipment.EvapRate.Value / 100) *
      (FBoilTime.Value / 60));}
    FBoilSize.Value:= FBatchSize.Value + FEquipment.BoilSize.Value
                              * FEquipment.EvapRate.Value / 100 *
                              (FBoilTime.Value / 60);
end;

function TRecipe.GetSGEndMashCalc : double;
var i : integer;
    mvol, d, v, s, gs : double;
    F : TFermentable;
begin
  mvol:= 0;
  v:= 0;
  d:= 0;
  s:= 0;
  gs:= 0; //grain absorption
  if (FMash <> NIL) and (FMash.NumMashSteps > 0) then
  begin
    for i:= 0 to FMash.NumMashSteps - 1 do
      mvol:= mvol + TMashStep(FMash.MashStep[i]).InfuseAmount.Value;
  end;
  if mvol > 0 then
  begin
    for i := 0 to NumFermentables - 1 do
    begin
      F := TFermentable(Fermentable[i]);
      if F.AddedType = atMash then
      begin
        d := F.Amount.Value * (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
        mvol:= mvol + F.Amount.Value * F.Moisture.Value / 100;
        gs:= gs + Settings.GrainAbsorption.Value * F.Amount.Value;
        s := s + d;
      end;
    end;
    v:= s / sugardensity + mvol;// - gs;
//    v:= s / sugardensity + mvol * 0.975 - gs;
    s := 1000 * s / (v * 10); //deg. Plato
    Result := PlatoToSG(s);
  end;
end;

Function TRecipe.CalcMashEfficiency : double;
var m, c : double;
begin
  c:= SGtoPlato(GetSGEndMashCalc);
  m:= SGtoPlato(FSGendmash.Value);
  if c > 0.5 then
    Result:= 100 * m / c
  else
    Result:= 0;
end;

function TRecipe.GetSGStartBoil: double;
var
  i: integer;
  d, Pl, s, v: double;
  F: TFermentable;
begin
  if FBatchSize.Value <> 0 then
  begin
    v := 0;
    s:= 0;
    //    FEfficiency.Value:= GetEfficiency;
    for i := 0 to NumFermentables - 1 do
    begin
      F := TFermentable(Fermentable[i]);
      if (F.AddedType = atMash) then
      begin
        d := FEfficiency.Value / 100 * F.Amount.Value * (F.Yield.Value / 100)
             * (1 - F.Moisture.Value / 100);
        s := s + d;
      end;
    end;

    if FBatchSize.Value > 0 then
      v:= FBatchSize.Value + FEquipment.EvapRate.Value / 100
          * FEquipment.BoilSize.Value * (FBoilTime.Value / 60);

    if FBoilSize.Value > 0 then
      v:= FBoilSize.Value;

    if v <= 0 then v:= FEquipment.BoilSize.Value;

    if v > 0 then
      Pl:= 1000 * s / (v * 10) //deg. Plato
    else
      Pl:= 0;

    Result := PlatoToSG(Pl);
    for i:= 1 to 10 do
    begin
      Pl:= 1000 * s / (v * Result * 10);
      Result:= PlatoToSG(Pl);
    end;
  end
  else
    Result := FEstOG.Value;
end;

procedure TRecipe.CalcOG;
var
  i, j, k: integer;
  sg, d, tot, tot2, vol, vol1, vol2, sugF, sug, sug2, p, x: double;
  //mass1, mass2 : double;
  F: TFermentable;
//  ibu, bindex : double;
begin
{  ibu:= FIBU.Value;
  bIndex:= -1;
  if FEstOG.Value > 1 then
    bindex:= ibu / (1000 * (FEstOG.Value - 1));}
  for j := 1 to 1 do
  begin
    sug:= 0;
    sugf:= 0;
    sug2:= 0;
    tot := 0;
    tot2:= 0;
    vol:= 0;
    FEfficiency.Value := GetEfficiency;
    for i := 0 to NumFermentables - 1 do
    begin
      F := TFermentable(Fermentable[i]);
      if (F.AddedType = atMash) or (F.AddedType = atBoil) then
      begin
        d := F.Amount.Value * (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
        if (F.AddedType = atMash) then
          d := FEfficiency.Value / 100 * d;
        sugf := sugf + d;
        tot := tot + F.Amount.Value;
      end
      else
      begin
        x:= (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
        sug2:= sug2 + F.Amount.Value * x;
        tot2:= tot2 + F.Amount.Value;
        tot := tot + F.Amount.Value;
        vol:= vol + F.Amount.Value / (x * SugarDensity + (1 - x) * 1);
      end;
    end;
    if tot > 0 then
      for i := 0 to NumFermentables - 1 do
      begin
        F := Fermentable[i];
        F.Percentage.Value := 100 * F.Amount.Value / tot;
      end;

   { if (FEquipment <> NIL) then
    begin
      vol1:= FBatchSize.Value - FEquipment.TrubChillerLoss.Value;
      vol2:= vol1 + FEquipment.TopUpWater.Value + vol;
      sug:= sugf * vol1 / FBatchSize.Value;       //kg
      sug:= sug + sug2;                     //kg
      sug:= sug / vol2; //kg/l
      p:= 100 * sug;
      sg:= PlatoToSG(p);
      for k:= 1 to 30 do
      begin
        mass1:= vol1 * sg * WaterDensity20;
        sug:= sugf * vol1 / FBatchSize.Value;       //kg
        sug:= sug + sug2; //kg
        mass2:= mass1 + sug2 + FEquipment.TopUpWater.Value / Waterdensity20;  //kg
        sug:= sug / mass2; //g/g
        p := 100 * sug; //deg. Plato
        sg := PlatoToSG(p);
      end;
      FEstOG.Value:= sg;
    end
    else if FBatchSize.Value <> 0 then
    begin
      p := 100 * sugf / FBatchSize.Value; //deg. Plato
      sg := PlatoToSG(p);
      for k:= 1 to 20 do
      begin
        p := 100 * sugf / (FBatchSize.Value * sg * Waterdensity20); //deg. Plato
        sg := PlatoToSG(p);
      end;
      FEstOG.Value := sg;
    end
    else
      FEstOG.Value := 1.0;}

    if (FEquipment <> NIL) and (FBatchSize.Value > 0) then
    begin
      vol1:= FBatchSize.Value - FEquipment.TrubChillerLoss.Value;
      vol2:= vol1 + FEquipment.TopUpWater.Value + vol;
      sug:= sugf * vol1 / FBatchSize.Value;       //kg
      sug:= sug + sug2;                     //kg
      if vol2 > 0 then
        sug:= sug / vol2; //kg/l
      p:= 100 * sug;
      sg:= PlatoToSG(p);
      for k:= 1 to 30 do
      begin
        if sg > 0 then
          p := 100 * sug / sg; //deg. Plato
        sg := PlatoToSG(p);
      end;
      FEstOG.Value:= sg;
    end
    else if FBatchSize.Value <> 0 then
    begin
      p := 100 * sugf / FBatchSize.Value; //deg. Plato
      sg := PlatoToSG(p);
      for k:= 1 to 20 do
      begin
        if sg > 0 then
          p := 100 * sugf / (FBatchSize.Value * sg); //deg. Plato
        sg := PlatoToSG(p);
      end;
      FEstOG.Value := sg;
    end
    else
      FEstOG.Value := 1.0;
  end;

  CalcWaterBalance;
{  if ibu > 0 then
    if Settings.SGBitterness.Value = 0 then
      AdjustBitterness(ibu)
    else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
      AdjustBitterness(1000 * (FEstOG.Value - 1) * bIndex)
    else
      CalcBitterness;}
end;

procedure TRecipe.CalcFermentablesFromPerc(OG: double);
var
  i, j: integer;
  sug, d, tot, totmass, x: double;
  vol, vol1, vol2, sug2: double;
  F: TFermentable;
//  ibu, bindex : double;
begin
{  ibu:= FIBU.Value;
  bIndex:= -1;
  if FEstOG.Value > 1 then
    bindex:= ibu / (1000 * (FEstOG.Value - 1));}

  for j := 1 to 15 do
  begin
    vol:= 0; sug2:= 0;
    FEfficiency.Value := GetEfficiency;
    for i := 0 to NumFermentables - 1 do
    begin
      F := TFermentable(Fermentable[i]);
      if (F.AddedType = atFermentation) or (F.AddedType = atLagering) or (F.AddedType = atBottle) then
      begin
        x:= (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
        vol:= vol + F.Amount.Value / (x * SugarDensity + (1 - x) * 1);
        sug2:= sug2 + F.Amount.Value * x;
      end;
    end;

    if FEquipment <> NIL then
    begin
      sug:= SGToPlato(OG) * OG / 100; //kg/l
      vol1:= FBatchSize.Value - FEquipment.TrubChillerLoss.Value;
      vol2:= vol1 + FEquipment.TopUpWater.Value + vol;
      sug:= sug * vol2; //kg in het gistvat
      sug:= sug - sug2; //kg voor toevoeging in gistvat
      if vol1 > 0 then
        sug:= sug * FBatchSize.Value / vol1; //kg in kookketel
      sug:= sug + sug2;
    end
    else
      sug := SGtoPlato(OG) * FBatchSize.Value * OG / 100; //total amount of sugars in kg

    tot := 0;
    d:= 0;
    for i := 0 to NumFermentables - 1 do
    begin
      F := Fermentable[i];
      d := F.Percentage.Value / 100 * (F.Yield.Value / 100) *
           (1 - F.Moisture.Value / 100);
      if (F.AddedType = atMash) then
        d := FEfficiency.Value / 100 * d;
      tot := tot + d;
    end;
    if tot > 0 then totmass := sug / tot else totmass:= 0;
    if totmass > 0 then
      for i := 0 to NumFermentables - 1 do
      begin
        F := Fermentable[i];
        F.Amount.Value := F.Percentage.Value / 100 * totmass;
      end;
  end;
  CalcWaterBalance;

  {if ibu > 0 then
    if Settings.SGBitterness.Value = 0 then
      AdjustBitterness(ibu)
    else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
      AdjustBitterness(1000 * (FEstOG.Value - 1) * bIndex)
    else
      CalcBitterness;}
end;

function TRecipe.CalcEfficiencyBeforeBoil: double;
var
  i: integer;
  d, m, tot: double;
  F: TFermentable;
begin
  m := 0; //amount of sugars extracted from mash
  tot := 0;
  for i := 0 to NumFermentables - 1 do
  begin
    F := TFermentable(Fermentable[i]);
    if (F.AddedType = atMash) then
    begin
      d := F.Amount.Value * (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
      m := m + d;
    end;
  end;
  tot := SGtoPlato(FOGBeforeBoil.Value) * FVolumeBeforeBoil.Value * FOGBeforeBoil.Value * 10 / 1000;
  if m > 0 then
    Result := tot / m * 100
  else
    Result := 0;
end;

function TRecipe.CalcEfficiencyAfterBoil: double;
var
  i: integer;
  d, m, b, tot: double;
  F: TFermentable;
begin
  m := 0; //amount of sugars extracted from mash
  b := 0; //amount of sugars added to boil
  tot := 0;
  for i := 0 to NumFermentables - 1 do
  begin
    F := TFermentable(Fermentable[i]);
    d := F.Amount.Value * (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
    if (F.AddedType = atMash) then
      m := m + d
    else if (F.AddedType = atBoil) then
      b := b + d;
  end;
  tot := SGtoPlato(FOG.Value) * FVolumeAfterBoil.Value * FOG.Value * 10 / 1000;
  //am. of sugars in wort after boil
  tot := tot - b; //amount of sugars in wort from mash
  if m > 0 then
    Result := tot / m * 100
  else
    Result := 0;
  FActualEfficiency.Value := Result;
end;

function TRecipe.CalcOGAfterBoil: double;
var
  i, k: integer;
  v, d, p: double;
  eff: double;
  F: TFermentable;
begin
  Result := 0;
  v := 0;
  {if FActualEfficiency.Value > 20 then
    eff := FActualEfficiency.Value
  else }
    eff := FEfficiency.Value;
  for i := 0 to NumFermentables - 1 do
  begin
    F := TFermentable(Fermentable[i]);
    if (F.AddedType = atMash) or (F.AddedType = atBoil) then
    begin
      d := F.Amount.Value * (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
      if (F.AddedType = atMash) then
        d := eff / 100 * d
      else if (F.AddedType <> atBoil) then
        d := 0;
      v := v + d;
    end;
  end;

  if FBatchSize.Value <> 0 then
  begin
    p := 100 * v / FBatchSize.Value; //deg. Plato
    Result := PlatoToSG(p);
    for k:= 1 to 20 do
    begin
      p := 100 * v / (FBatchSize.Value * Result); //deg. Plato
      Result := PlatoToSG(p);
    end;
  end;
end;

function TRecipe.CalcVirtualOGduringFermentation: double;
var totstartferm, addedmass, addedS, ogx, top: double;
    F: TFermentable;
    i: integer;
begin   //og in fermenter, calculated from estimated OG and volumes
  Result := 0;
  addedS := 0;
  addedmass := 0;
  ogx := CalcOGAfterBoil;
  top:= 0;
  if FEquipment <> NIL then
    if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
    else top:= FEquipment.TopUpWater.Value;

  totstartferm := 10 * SGtoPlato(ogx) * FVolumeFermenter.Value * ogx / 1000; //kg of sugar in
  for i := 0 to NumFermentables - 1 do
  begin
    F := TFermentable(Fermentable[i]);
    if (F.AddedType = atFermentation) or (F.AddedType = atLagering) then
    begin
      addedS := addedS + F.Amount.Value * (F.Yield.Value / 100) *
        (1 - F.Moisture.Value / 100);
      addedmass := addedmass + F.Amount.Value;
    end;
  end;
  if ((FVolumeFermenter.Value * ogx + addedmass) > 0) then
  begin
    Result := 100 * (totstartferm + addedS) / (FVolumeFermenter.Value * ogx + addedmass + top);
    Result := PlatoToSG(Result);
    FOGFermenter.Value:= Result;
  end
  else
    Result := FOG.Value;
end;

Function TRecipe.CalcOGFermenter : double;
var vol1, {vol2,} sug, addedmass, addedS, ogx, top, vol, x: double;
    F: TFermentable;
    i: integer;
begin //og in fermenter, calculated from measured OG and volumes
  Result := 0;
  addedS := 0;
  addedmass := 0;
  vol:= 0;
  if FOG.Value > 1.001 then ogx := FOG.Value
  else ogx:= CalcOGAfterBoil;
  top:= 0;
  if FEquipment <> NIL then
    if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
    else top:= FEquipment.TopUpWater.Value;
  vol1:= FVolumeFermenter.Value;
  if (vol1 = 0) and (FEquipment <> NIL) then
    vol1:= FBatchSize.Value - FEquipment.TrubChillerLoss.Value;

  Result := ogx;
  if vol1 > 0 then
  begin
    sug := SGtoPlato(ogx) * vol1 * ogx / 100; //kg of sugar in
    vol:= 0;
    for i := 0 to NumFermentables - 1 do
    begin
      F := TFermentable(Fermentable[i]);
      if (F.AddedType = atFermentation) or (F.AddedType = atLagering) then
      begin
        x:= (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
        addedS := addedS + F.Amount.Value * x;
        addedmass := addedmass + F.Amount.Value;
        vol:= vol + (x * SugarDensity + (1 - x) * 1) * F.Amount.Value;
      end;
    end;
    //vol2:= vol1 + top + vol;
    sug:= sug + addedS; //kg

    if ((vol1 * ogx + addedmass) > 0) then
    begin
      Result := 100 * sug / (vol1 * ogx + addedmass + top);
      Result := PlatoToSG(Result);
    end;
  end;
  FOGFermenter.Value:= Result;
end;

Function TRecipe.CalcIBUFermenter : double;
var V, V2, x, top, addedvolume : double;
    i : integer;
    F : TFermentable;
begin
  Result:= CalcBitternessWort;
  addedvolume:= 0;
  if FEquipment <> NIL then
  begin
    V:= FVolumeFermenter.Value;
    if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
    else top:= FEquipment.TopUpWater.Value;
    V2:= V + top;
    if V2 > 0 then
    begin
      for i := 0 to NumFermentables - 1 do
      begin
        F := TFermentable(Fermentable[i]);
        if (F.AddedType = atFermentation) or (F.AddedType = atLagering) then
        begin
          x:= (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
          addedVolume:= addedvolume + (x * sugardensity + (1-x) * 1) * F.Amount.Value;
        end;
      end;
      V2:= V2 + addedvolume;

      if (V2 > 0) then
        Result:= Result * V / V2;
    end;
  end;
end;

Function TRecipe.CalcColorFermenter : double;
var V, V2, x, addedvolume, top : double;
    i : integer;
    F : TFermentable;
begin
  CalcColor;
  Result:= FEstColor.Value;
  addedVolume:= 0;
  if FEquipment <> NIL then
  begin
    if FEquipment.TopUpWaterBrewday.Value > 0 then
      top:= FEquipment.TopUpWaterBrewDay.Value
    else
      top:= FEquipment.TopUpWater.Value;
    V2:= FVolumeFermenter.Value + top;
    if V2 > 0 then
    begin
      V:= FVolumeFermenter.Value;
      Result:= CalcColorWort;
      for i := 0 to NumFermentables - 1 do
      begin
        F := TFermentable(Fermentable[i]);
        if (F.AddedType = atFermentation) or (F.AddedType = atLagering) then
        begin
          x:= (F.Yield.Value / 100) * (1 - F.Moisture.Value / 100);
          addedVolume:= addedvolume + (x * sugardensity + (1-x) * 1) * F.Amount.Value;
        end;
      end;
      V2:= V2 + addedvolume;
      if V2 > 0 then
        Result:= Result * V / V2;
  //    Result:= Convert(Result, FEstColor.vUnit, FEstColor.DisplayUnit);
    end;
  end;
end;

procedure TRecipe.EstimateFG;
var
  percS, percCara, BD, Att, AttBeer, sg: double;
  Temp, TotTme: double;
  Y: TYeast;
//  Eq: TEquipment;
begin
  percS := GetPercSugar;
  //if PercS > 40 then PercS:= 0;
  percCara := GetPercCrystalMalt;
  if percCara > 50 then PercCara:= 0;
  if (Mash <> nil) and (Mash.MashStep[0] <> nil) then
  begin
    BD := Mash.MashStep[0].WaterToGrainRatio;
    BD:= Max(2, Min(5.5, BD));
    Temp := Mash.AverageTemperature;
    Temp:= Max(60, Min(72, Temp));
    TotTme := Mash.TotalMashTime;
    TotTme:= Max(20, Min(90, TotTme));
  end
  else
  begin
    BD := 3.5;
    Temp := 67;
    TotTme := 75;
  end;
  Y := Yeast[0];
  if Y <> nil then
  begin
    Att := Y.Attenuation.Value;
    if Att < 30 then Att:= 77;
  end
  else
    Att := 77;
  AttBeer := 0.00825 * Att + 0.00817 * BD - 0.00684 * Temp + 0.00026 *
             TotTme - 0.00356 * PercCara + 0.00553 * PercS + 0.547;

{  Eq := nil;
  if FEquipment <> nil then
    Eq := TEquipment(Equipments.FindByName(FEquipment.Name.Value));
  if Eq <> nil then
    AttBeer2 := Eq.EstimateFG(Att, BD, Temp, TotTme, PercCara, PercS);}

  FEstFG.Value := 1 + (1 - AttBeer) * (FEstOG.Value - 1);
  CalcOGFermenter;
  if FOGFermenter.Value > 1.001 then
  begin
    sg:= FOGFermenter.Value;
    FEstFG2.Value := 1 + (1 - AttBeer) * (sg - 1);
    FEstABV.Value := ABVol(FEstOG.Value, FEstFG.Value);
  end
  else if FOG.Value > 1.001 then
  begin
    sg:= FOG.Value;
    FEstFG2.Value := 1 + (1 - AttBeer) * (sg - 1);
    FEstABV.Value := ABVol(FEstOG.Value, FEstFG.Value);
  end
  else
  begin
    FEstFG2.Value := 1 + (1 - AttBeer) * (FEstOG.Value - 1);
    FEstABV.Value := ABVol(FEstOG.Value, FEstFG.Value);
  end;
end;

Function TRecipe.CalcCosts : double;
var i : integer;
begin
  Result:= 0;
  for i:= 0 to High(FFermentables) do
    Result:= Result + FFermentables[i].Amount.Value * FFermentables[i].Cost.Value;
  for i:= 0 to High(FHops) do
    Result:= Result + FHops[i].Amount.Value * FHops[i].Cost.Value;
  for i:= 0 to High(FMiscs) do
    Result:= Result + FMiscs[i].Amount.Value * FMiscs[i].Cost.Value;
  for i:= 0 to High(FYeasts) do
    if (TYeast(FYeasts[i]).Form = yfLiquid) or (TYeast(FYeasts[i]).Form = yfDry) then
      Result:= Result + TYeast(FYeasts[i]).AmountYeast.DisplayValue * FYeasts[i].Cost.Value;
end;

Procedure TRecipe.CalcCalories;
var sug, alc, org, fig : double;
begin
  if FOGFermenter.Value > 1.001 then org:= FOGFermenter.Value
  else if FOG.Value > 1.001 then org:= FOG.Value
  else org:= 0;
  if FFG.Value > 0.999 then fig:= FFG.Value
  else if FEstFG.Value > 1.000 then fig:= FEstFG.Value
  else if FEstFG2.Value > 1.000 then fig:= FEstFG2.Value
  else fig:= 0;
  if (org > 0) and (fig > 0) then
  begin
    alc:= 1881.22 * fig * (org - fig) / (1.775 - org);
    sug:= 3550 * fig * (0.1808 * org + 0.8192 * fig - 1.0004);
    FCalories.Value:= (alc + sug) / (12 * 0.0295735296);
  end
  else FCalories.Value:= 0;
end;

Function TRecipe.OverPitchFactor : double;
var AmCells, AmCellsNeeded : double;
    i : integer;
begin
  Result:= 0;
  if Yeast[0] <> NIL then
  begin
    AmCells:= Yeast[0].CalcAmountYeast; //in billion
    AmCellsNeeded:= NeededYeastCells; //in billion
  end;
  for i:= 1 to NumYeasts - 1 do
    AmCells:= AmCells + Yeast[i].CalcAmountYeast;
  if AmCellsNeeded > 0 then Result:= AmCells / AmCellsNeeded;
end;

procedure TRecipe.CheckPercentage;
var
  i, num: integer;
  tot: double;
  FFerm: TFermentable;
begin
  tot := 0;
  for i := 0 to NumFermentables - 1 do
  begin
    FFerm := Fermentable[i];
    if not FFerm.AdjustToTotal100.Value then
      tot := tot + FFerm.Percentage.Value;
  end;
{  if (tot < 99.9999) or (tot > 100.0001) then
  begin }
    num:= 0;
    tot := 100 - tot;
    for i := 0 to NumFermentables - 1 do
    begin
      FFerm := Fermentable[i];
      if FFerm.AdjustToTotal100.Value then inc(num);
    end;
    if num > 0 then
      for i := 0 to NumFermentables - 1 do
      begin
        FFerm := Fermentable[i];
        if FFerm.AdjustToTotal100.Value then
          FFerm.Percentage.Value:= tot/num;
      end;
    CalcFermentablesFromPerc(FEstOG.Value);
//  end;
end;

procedure TRecipe.RecalcPercentages;
var
  i: integer;
  tot: double;
begin
  tot := 0;
  for i := 0 to NumFermentables - 1 do
    tot := tot + Fermentable[i].Amount.Value;
  if tot > 0 then
    for i := 0 to NumFermentables - 1 do
      Fermentable[i].Percentage.Value := 100 * Fermentable[i].Amount.Value / tot;
end;

function TRecipe.GetTotalFermentableMass: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to NumFermentables - 1 do
    Result := Result + Fermentable[i].Amount.Value;
end;

function TRecipe.GetPercFermentable(i: integer): double;
var
  tot: double;
  F: TFermentable;
begin
  Tot := GetTotalFermentableMass;
  F := Fermentable[i];
  if F <> nil then
    if (Tot > 0) and (i >= 0) and (i < NumFermentables) then
    begin
      Result := 100 * F.Amount.Value / Tot;
      if F.Percentage.Value = 0 then
        F.Percentage.Value := Result;
    end;
end;

function TRecipe.GetGrainMassMash: double;
var
  i: integer;
begin
  Result := 0;
  for i := 0 to NumFermentables - 1 do
    if Fermentable[i].AddedType = atMash then
      Result := Result + Fermentable[i].Amount.Value;
end;

procedure TRecipe.Scale(NewSize: double);
var
  i: integer;
  MS: TMashStep;
begin
  if FBatchSize.Value > 0 then
  begin
    for i := 0 to NumFermentables - 1 do
      Fermentable[i].Amount.Value :=
        NewSize / FBatchSize.Value * Fermentable[i].Amount.Value;
    for i := 0 to NumHops - 1 do
      Hop[i].Amount.Value := NewSize / FBatchSize.Value * Hop[i].Amount.Value;
    for i := 0 to NumMiscs - 1 do
      Misc[i].Amount.Value := NewSize / FBatchSize.Value * Misc[i].Amount.Value;
    for i := 0 to NumWaters - 1 do
      Water[i].Amount.Value := NewSize / FBatchSize.Value * Water[i].Amount.Value;
    FBoilSize.Value := FBoilSize.Value * NewSize / FBatchSize.Value;
    if (FMash <> nil) and (FMash.MashStep[0] <> nil) then
    begin
      MS := FMash.MashStep[0];
      MS.InfuseAmount.Value := NewSize / FBatchSize.Value * MS.InfuseAmount.Value;
      FMash.CalcMash;
    end;
    FAbsorbedByGrain := FAbsorbedByGrain * NewSize / FBatchSize.Value;
    FBatchSize.Value := NewSize;
  end;
end;

function TRecipe.GetTotalSugars: double;
begin
  Result := SGtoPlato(FOG.Value) * (FBatchSize.Value * 10); //total amount of sugars
end;

function TRecipe.GetPercSugarContent(i: integer): double;
var
  tot: double;
begin
  Result := 0;
  tot := GetTotalSugars;
  if (i >= 0) and (i < NumFermentables) and (tot > 0) then
    Result := 100 * Fermentable[i].Extract / tot;
end;

function TRecipe.GetPercBaseMalt: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FFermentables) to High(FFermentables) do
    if TFermentable(FFermentables[i]).GrainType = gtBase then
      Result := Result + TFermentable(FFermentables[i]).Percentage.Value;
end;

function TRecipe.GetPercCrystalMalt: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FFermentables) to High(FFermentables) do
    if TFermentable(FFermentables[i]).GrainType = gtCrystal then
      Result := Result + TFermentable(FFermentables[i]).Percentage.Value;
end;

function TRecipe.GetPercRoastMalt: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FFermentables) to High(FFermentables) do
    if (TFermentable(FFermentables[i]).GrainType = gtKilned) or
      (TFermentable(FFermentables[i]).GrainType = gtRoast) then
      Result := Result + TFermentable(FFermentables[i]).Percentage.Value;
end;

function TRecipe.GetPercSugar: double;
var
  i: integer;
begin
  Result := 0;
  for i := Low(FFermentables) to High(FFermentables) do
    if (TFermentable(FFermentables[i]).FermentableType = ftSugar) then
      Result := Result + TFermentable(FFermentables[i]).Percentage.Value;
end;

function TRecipe.GetMashThickness: double;
var
  vol, mass: double;
begin
  vol := 0;
  mass := 0;
  Result := 0;
  if FMash <> nil then
    vol := FMash.MashWaterVolume;
  mass := GrainMassMash;
  if (mass > 0) then
    Result := vol / mass;
end;

function TRecipe.GetBUGU: double;
var
  gu: double;
begin
  Result := 0.5;
  gu := (FEstOG.Value - 1) * 1000;
  if gu > 0 then
    Result := FIBU.Value / gu;
end;

function TRecipe.GetOptClSO4ratio: double;
begin
  Result := -1.2 * BUGU + 1.4;
end;

function TRecipe.GetNeededYeastCells: double;
  //number of yeast cells needed in billion cells
var plato, sg: double;
    f, volume: double;
begin
  Result := 0;
  sg:= 0;
  sg:= CalcOGFermenter;
  if (sg <= 1.0001) and (FOG.Value > 1.000) then
    sg:= FOG.Value
  else if (sg <= 1.0001) then
    sg:= FEstOG.Value;
  Plato := SGtoPlato(sg);

  if Yeast[0].YeastType = ytLager then
    f := 1.5
  else
    f := 0.75;

  if FVolumeFermenter.Value > 0 then
  begin
    Volume:= FVolumeFermenter.Value;
    if FEquipment.TopUpWaterBrewDay.Value > 0 then
      Volume:= Volume + FEquipment.TopUpWaterBrewDay.Value;
  end
  else if FVolumeAfterBoil.Value > 0 then Volume:= FVolumeAfterBoil.Value
  else Volume:= FBatchSize.Value;

  if FEquipment <> NIL then
    Volume:= Volume - FEquipment.TrubChillerLoss.Value + FEquipment.TopUpWater.Value;
  if FVolumeFermenter.Value > 0 then Volume:= FVolumeFermenter.Value + FEquipment.TopUpWater.Value;

  Result := f * plato * Volume; //benodigd aantal cellen in miljard cellen
end;

function TRecipe.GetAAEndPrimary: double;
var sg : double;
begin
  Result := 0;
  if FOGFermenter.Value > 1 then sg:= FOGFermenter.Value
  else if FOG.Value > 1 then sg:= FOG.Value
  else sg:= FEstOG.Value;
  if sg > 1 then
    Result := 100 * (sg - SGEndPrimary.Value) / (sg - 1);
end;

function TRecipe.GetApparentAttenuation: double;
var sg : double;
begin
  Result := 0;
  if FOGFermenter.Value > 1 then sg:= FOGFermenter.Value
  else if FOG.Value > 1 then sg:= FOG.Value
  else sg:= FEstOG.Value;
  if sg > 1 then
    Result := 100 * (sg - FFG.Value) / (sg - 1);
end;

function TRecipe.GetRealAttenuation: double;
var
  sg, oe, ae: double;
begin
  Result := 0;
  if FOGFermenter.Value > 1 then sg:= FOGFermenter.Value
  else if FOG.Value > 1 then sg:= FOG.Value
  else sg:= FEstOG.Value;
  oe := (sg - 1) * 1000;
  if oe > 0 then
  begin
    ae := (FFG.Value - 1) * 1000;
    Result := 100 * (1 - (0.1808 * OE + 0.8192 * AE) / OE);
  end;
end;

Function TRecipe.Filter(s : string) : boolean;
var F : TFermentable;
    H : THop;
    M : TMisc;
    Y : TYeast;
    s2 : string;
    i : integer;
begin
  Result:= false;
  s:= LowerCase(s);
  s2:= LowerCase(FName.Value);
  if NPos(s, s2, 1) > 0 then Result:= TRUE;
  s2:= LowerCase(FNrRecipe.Value);
  if NPos(s, s2, 1) > 0 then Result:= TRUE;
  for i:= 0 to NumFermentables - 1 do
  begin
    F:= TFermentable(FFermentables[i]);
    s2:= LowerCase(F.Name.Value);
    if NPos(s, s2, 1) > 0 then Result:= TRUE;
  end;
  for i:= 0 to NumHops - 1 do
  begin
    H:= THop(FHops[i]);
    s2:= LowerCase(H.Name.Value);
    if NPos(s, s2, 1) > 0 then Result:= TRUE;
  end;
  for i:= 0 to NumMiscs - 1 do
  begin
    M:= TMisc(FMiscs[i]);
    s2:= LowerCase(M.Name.Value);
    if NPos(s, s2, 1) > 0 then Result:= TRUE;
  end;
  for i:= 0 to NumYeasts - 1 do
  begin
    Y:= TYeast(FYeasts[i]);
    s2:= LowerCase(Y.Name.Value);
    if NPos(s, s2, 1) > 0 then Result:= TRUE;
    s2:= LowerCase(Y.FProductID.Value);
    if NPos(s, s2, 1) > 0 then Result:= TRUE;
  end;
end;

procedure SortByIndex(var Arr: array of TIngredient; Index: integer;
  Decending: boolean; Nstart, Nend: integer);

  procedure Selectionsort(var List : array of TIngredient;
                          min, max : integer);
  var
      i, j, best_j : integer;
      best_value   : variant;
      TB : TIngredient;
  begin
      for i := min to max - 1 do
      begin
          best_value := List[i].ValueByIndex[Index];
          best_j := i;
          TB:= List[i];
          for j := i + 1 to max do
          begin
              if (List[j].ValueByIndex[Index] < best_value) Then
              begin
                  best_value := List[j].ValueByIndex[Index];
                  TB:= List[j];
                  best_j := j;
              end;
          end;    // for j := i + 1 to max do
          List[best_j] := List[i];
          List[i] := TB;
      end;        // for i := min to max - 1 do
  end;

  procedure SelectionsortDec(var List : array of TIngredient;
                             min, max : integer);
  var
      i, j, best_j : integer;
      best_value   : variant;
      TB : TIngredient;
  begin
      for i := min to max - 1 do
      begin
          best_value := List[i].ValueByIndex[Index];
          best_j := i;
          TB:= List[i];
          for j := i + 1 to max do
          begin
              if (List[j].ValueByIndex[Index] > best_value) Then
              begin
                  best_value := List[j].ValueByIndex[Index];
                  TB:= List[j];
                  best_j := j;
              end;
          end;    // for j := i + 1 to max do
          List[best_j] := List[i];
          List[i] := TB;
      end;        // for i := min to max - 1 do
  end;

  procedure QuickSort(var A: array of TIngredient; iLo, iHi: integer);
  var
    Lo, Hi: integer;
    mid: variant;
    TB: TIngredient;
  begin
    Lo := iLo;
    Hi := iHi;
    mid := A[(Lo + Hi) div 2].ValueByIndex[Index];
    repeat
      while A[Lo].ValueByIndex[Index] < mid do Inc(Lo);
      while (A[Hi].ValueByIndex[Index] > mid) and (Hi > 0) do Dec(Hi);
      if Lo <= Hi then
      begin
        TB := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi > iLo then QuickSort(A, iLo, Hi);
    if Lo < iHi then QuickSort(A, Lo, iHi);
  end;

  procedure QuickSortDec(var A: array of TIngredient; iLo, iHi: integer);
  var
    Lo, Hi: integer;
    mid: variant;
    TB: TIngredient;
  begin
    Lo := iLo;
    Hi := iHi;
    mid := A[(Lo + Hi) div 2].ValueByIndex[Index];
    repeat
      while A[Lo].ValueByIndex[Index] > mid do Inc(Lo);
      while A[Hi].ValueByIndex[Index] < mid do Dec(Hi);
      if Lo <= Hi then
      begin
        TB := A[Lo];
        A[Lo] := A[Hi];
        A[Hi] := TB;
        Inc(Lo);
        Dec(Hi);
      end;
    until Lo > Hi;
    if Hi < iLo then QuickSortDec(A, iLo, Hi);
    if Lo > iHi then QuickSortDec(A, Lo, iHi);
  end;

  Function CheckSort(Arr : array of TIngredient; Decending : boolean; iLo, iHi: integer) : boolean;
  var i : integer;
      v, v2 : variant;
  begin
    Result:= TRUE;
    for i:= iLo + 1 to iHi do
    begin
      v:= Arr[i-1].ValueByIndex[Index];
      v2:= Arr[i].ValueByIndex[Index];
      if Decending then
      begin
        if (v < v2) then Result:= false;
      end
      else
      begin
        if (v > v2) then Result:= false;
      end;
    end;
  end;

var
  TB: TIngredient;
begin
  if (High(Arr) > 0) and (Index > -1) then
  begin
    if (NEnd = 0) or (NStart > NEnd) then
    begin
      NStart := Low(Arr);
      NEnd := High(Arr);
    end;
    if NStart = NEnd - 1 then
    begin
      if Decending then
      begin
        if Arr[NStart].ValueByIndex[Index] < Arr[NEnd].ValueByIndex[Index] then
        begin
          TB := Arr[NStart];
          Arr[NStart] := Arr[NEnd];
          Arr[NEnd] := TB;
        end;
      end
      else
      begin
        if Arr[NStart].ValueByIndex[Index] > Arr[NEnd].ValueByIndex[Index] then
        begin
          TB := Arr[NStart];
          Arr[NStart] := Arr[NEnd];
          Arr[NEnd] := TB;
        end;
      end;
    end
    else
    begin
      if (not CheckSort(Arr, Decending, NStart, NEnd)) then
      begin
        if Decending then
//          QuickSortDec(Arr, NStart, NEnd)
          SelectionsortDec(Arr, NStart, NEnd)
        else
//          QuickSort(Arr, NStart, NEnd);
          Selectionsort(Arr, NStart, NEnd)
      end;
    end;
  end;
end;

procedure TRecipe.SortFermentables(I1, I2: integer; Decending1, Decending2: boolean);
var
  a, b: integer;
  V1: variant;
begin
  SortByIndex(FFermentables, I1, Decending1, 0, High(FFermentables));
  if I2 > 0 then
  begin
    a := 0;
    b := 0;
    while b <= High(FFermentables) do
    begin
      V1 := FFermentables[a].ValueByIndex[I1];
      while (b <= High(FFermentables)) and (FFermentables[b].ValueByIndex[I1] = V1) do
        Inc(b);
      if (a < (b-1)) then
        SortByIndex(FFermentables, I2, Decending2, a, b-1);
      a := b;
    end;
  end;
end;

procedure TRecipe.SortHops(I1, I2: integer; Decending1, Decending2: boolean);
var
  a, b: integer;
  V1: variant;
begin
  SortByIndex(FHops, I1, Decending1, 0, High(FHops));
  a := 0;
  b := 1;
  while b <= High(FHops) do
  begin
    V1 := FHops[a].ValueByIndex[I1];
    while (b <= High(FHops)) and (FHops[b].ValueByIndex[I1] = V1) do
      Inc(b);
    if (a < (b - 1)) then
      SortByIndex(FHops, I2, Decending2, a, b - 1);
    a := b;
  end;
end;

procedure TRecipe.SortMiscs(I1, I2: integer; Decending1, Decending2: boolean);
var
  a, b: integer;
  V1: variant;
begin
  SortByIndex(FMiscs, I1, Decending1, 0, High(FMiscs));
  a := 0;
  b := 1;
  while b <= High(FMiscs) do
  begin
    V1 := FMiscs[a].ValueByIndex[I1];
    while (b <= High(FMiscs)) and (FMiscs[b].ValueByIndex[I1] = V1) do
      Inc(b);
    if (a < (b - 1)) then
      SortByIndex(FMiscs, I2, Decending2, a, b - 1);
    a := b;
  end;
end;

procedure TRecipe.SortYeasts(I1, I2: integer; Decending1, Decending2: boolean);
var
  a, b: integer;
  V1: variant;
begin
  SortByIndex(FYeasts, I1, Decending1, 0, High(FYeasts));
  a := 0;
  b := 1;
  while b <= High(FYeasts) do
  begin
    V1 := FYeasts[a].ValueByIndex[I1];
    while (b <= High(FYeasts)) and (FYeasts[b].ValueByIndex[I1] = V1) do
      Inc(b);
    if (a < (b - 1)) then
      SortByIndex(FYeasts, I2, Decending2, a, b - 1);
    a := b;
  end;
end;

procedure TRecipe.SortWaters(I1, I2: integer; Decending1, Decending2: boolean);
var
  a, b: integer;
  V1: variant;
begin
  SortByIndex(FWaters, I1, Decending1, 0, 0);
  a := 0;
  b := 1;
  while b <= High(FWaters) do
  begin
    V1 := FWaters[a].ValueByIndex[I1];
    while (b <= High(FWaters)) and (FWaters[b].ValueByIndex[I1] = V1) do
      Inc(b);
    if (a < (b - 1)) then
      SortByIndex(FWaters, I2, Decending2, a, b - 1);
    a := b;
  end;
end;

function TRecipe.FindFermentable(n, s: string): TFermentable;
var
  i: integer;
  found: boolean;
  F: TFermentable;
begin
  Result := nil;
  i := Low(FFermentables);
  found := False;
  while (i <= High(FFermentables)) and (not found) do
  begin
    F := TFermentable(FFermentables[i]);
    found := (Lowercase(F.Name.Value) = Lowercase(n)) and
      (Lowercase(F.Supplier.Value) = Lowercase(s));
    Inc(i);
  end;
  if Found then
    Result := F;
end;

function TRecipe.FindHop(n: string): THop;
var
  i: integer;
  found: boolean;
  F: TIngredient;
begin
  Result := nil;
  i := Low(FHops);
  found := False;
  while (i <= High(FHops)) and (not found) do
  begin
    F := FHops[i];
    found := (Lowercase(F.Name.Value) = Lowercase(n));
    Inc(i);
  end;
  if Found then
    Result := THop(F);
end;

function TRecipe.FindMisc(n: string): TMisc;
var
  i: integer;
  found: boolean;
  F: TIngredient;
begin
  Result := nil;
  i := Low(FMiscs);
  found := False;
  while (i <= High(FMiscs)) and (not found) do
  begin
    F := FMiscs[i];
    found := (Lowercase(F.Name.Value) = Lowercase(n));
    Inc(i);
  end;
  if Found then
    Result := TMisc(F);
end;

function TRecipe.FindYeast(n, l: string): TYeast;
var
  i: integer;
  found: boolean;
  F: TYeast;
begin
  Result := nil;
  i := Low(FYeasts);
  found := False;
  while (i <= High(FYeasts)) and (not found) do
  begin
    F := TYeast(FYeasts[i]);
    found := (Lowercase(F.Name.Value) = Lowercase(n)) and
      (Lowercase(F.Laboratory.Value) = Lowercase(l));
    Inc(i);
  end;
  if Found then
    Result := TYeast(F);
end;

function TRecipe.FindWater(n: string): TWater;
var
  i: integer;
  found: boolean;
  F: TIngredient;
begin
  Result := nil;
  i := Low(FWaters);
  found := False;
  while (i <= High(FWaters)) and (not found) do
  begin
    F := FWaters[i];
    found := (Lowercase(F.Name.Value) = Lowercase(n));
    Inc(i);
  end;
  if Found then
    Result := TWater(F);
end;

function TRecipe.GetpHdemi: double;
var W : TWater;
begin
  W:= TWater.Create(self);
  Result:= W.MashpH;
  W.Free;
{  Result := 5.25;
  bd := MashThickness;
  c := PercCrystalMalt;
  r := PercRoastMalt;

  if bd > 0 then
  begin
    m1 := 0.024 * ln(bd) - 0.052;
    m2 := 0.0073 * ln(bd) - 0.016;
    if (r + c) > 0 then
      m := (1 - r / (r + c)) * m1 + r / (r + c) * m2
    else
      m := m2;
    b1 := -0.083 * ln(bd) + 5.75;
    b2 := -0.045 * ln(bd) + 5.66;
    if (r + c) > 0 then
      b := (1 - r / (r + c)) * b1 + r / (r + c) * b2
    else
      b := b2;
    srm := CalcColorMash;
    Result := m * srm + b;
  end;}
end;

function TRecipe.GetRAmin: double;
var
  pHd, S: double;
begin
  Result:= 0;
  pHd := pHdemi;
  S := 0.013 * MashThickness + 0.013;
  if S > 0 then
    //Result := 2.81 * (5.2 - pHd) / S;
    Result := 50 * (5.2 - pHd) / S;
end;

function TRecipe.GetRAopt: double;
var
  pHd, S: double;
begin
  Result:= 0;
  pHd := pHdemi;
  S := 0.013 * MashThickness + 0.013;
  if S > 0 then
//    Result := 2.81 * (5.4 - pHd) / S;
    Result := 50 * (5.4 - pHd) / S;
end;

function TRecipe.GetRAmax: double;
var
  pHd, S: double;
begin
  Result:= 0;
  pHd := pHdemi;
  S := 0.013 * MashThickness + 0.013;
  if S > 0 then
//    Result := 2.81 * (5.6 - pHd) / S;
    Result := 50 * (5.6 - pHd) / S;
end;

procedure TRecipe.CalcMashWater;
var
  i: integer;
  M: TMisc;
  vol, acid, MolWt, AcidSG, Acidmg, pK1, pK2, pK3, frac, TpH, ProtonDeficit: double;
  //AcidPrc: double;
begin
  FMashWater.Bicarbonate.Value:= 0;
  FMashWater.Calcium.Value:= 0;
  FMashWater.Chloride.Value:= 0;
  FMashWater.Magnesium.Value:= 0;
  FMashWater.Sodium.Value:= 0;
  FMashWater.Sulfate.Value:= 0;
  FMashWater.Amount.Value:= 0;
  acid:= 0;
  frac:= 0;
  vol:= 0;
  MolWt:= 0;
  AcidSG:= 0;
  //AcidPrc:= 0;
  Acidmg:= 0;
  pK1:= 0;
  pK2:= 0;
  pK3:= 0;
  TpH:= 0;
  ProtonDeficit:= 0;

  if NumWaters = 1 then
    FMashWater.Assign(Water[0])
  else if NumWaters = 2 then
    MixWater(Water[0], Water[1], FMashWater);

  vol:= FMashWater.Amount.Value;
  if vol > 0 then
  begin
    for i := 0 to NumMiscs - 1 do
    begin
      M := Misc[i];
      if M.Name.Value = 'CaCl2' then
      begin
        FMashWater.Calcium.Add(1000000 * MMCa / MMCaCl2 * M.Amount.Value / vol);
        FMashWater.Chloride.Add(1000000 * MMCl / MMCaCl2 * M.Amount.Value / vol);
      end;
      if M.Name.Value = 'CaSO4' then
      begin
        FMashWater.Calcium.Add(1000000 * MMCa / MMCaSO4 * M.Amount.Value / vol);
        FMashWater.Sulfate.Add(1000000 * MMSO4 / MMCaSO4 * M.Amount.Value / vol);
      end;
      if M.Name.Value = 'MgSO4' then
      begin
        FMashWater.Magnesium.Add(1000000 * MMMg / MMMgSO4 * M.Amount.Value / vol);
        FMashWater.Sulfate.Add(1000000 * MMSO4 / MMMgSO4 * M.Amount.Value / vol);
      end;
      if M.Name.Value = 'NaCl' then
      begin
        FMashWater.Sodium.Add(1000000 * MMNa / MMNaCl * M.Amount.Value / vol);
        FMashWater.Chloride.Add(1000000 * MMCl / MMNaCl * M.Amount.Value / vol);
      end;

      if Between(TargetpH.Value, 5.0, 6.0) then TpH:= TargetpH.Value
      else
      begin
        TpH:= 5.4;
        FTargetpH.Value:= 5.4;
      end;
      if M.Name.Value = AcidTypeDisplayNames[atLactic] then
      begin
        pK1:= 3.08;
        pK2:= 20;
        pK3:= 20;
        MolWt:= 90.08;
        AcidSG:= 1214; //@88%
        //AcidPrc:= 0.88;
        frac:= CalcFrac(TpH, pK1, pK2, pK3);
        acid:= acid + M.Amount.Value * M.FreeField.Value / 100 * AcidSG / MolWt * Frac / vol; //mEq/l
      end;
      if M.Name.Value = AcidTypeDisplayNames[atHydroChloric] then
      begin
        pK1:= -10;
        pK2:=  20;
        pK3:=  20;
        MolWt:= 36.46;
        AcidSG:= 1142; //@28%
        //AcidPrc:= 0.28;
        frac:= CalcFrac(TpH, pK1, pK2, pK3);
        Acidmg:= M.Amount.Value * M.FreeField.Value / 100 * AcidSG / vol;
        acid:= acid + Acidmg / MolWt * Frac; //mEq/l
        FMashWater.Chloride.Add(Acidmg / 1000 * MMCl / (MMCL + 1));
      end;
      if M.Name.Value = AcidTypeDisplayNames[atPhosphoric] then
      begin
        pK1:= 2.12;
        pK2:= 7.20;
        pK3:=  12.44;
        MolWt:= 98.00;
        AcidSG:= 1170; //@25%
        //AcidPrc:= 0.25;
        frac:= CalcFrac(TpH, pK1, pK2, pK3);
        Acidmg:= M.Amount.Value * M.FreeField.Value / 100 * AcidSG / vol;
        acid:= acid + Acidmg / MolWt * Frac; //mEq/l
      end;
      if M.Name.Value = AcidTypeDisplayNames[atSulfuric] then
      begin
        pK1:= -10;
        pK2:= 1.92;
        pK3:= 20;
        MolWt:= 98.07;
        AcidSG:= 1700; //@93%
        //AcidPrc:= 0.93;
        frac:= CalcFrac(TpH, pK1, pK2, pK3);
        Acidmg:= M.Amount.Value * M.FreeField.Value / 100 * AcidSG / vol;
        acid:= acid + Acidmg / MolWt * Frac; //mEq/l
        FMashWater.Sulfate.Add(Acidmg / 1000 * MMSO4 / (MMSO4 + 2));
      end;
      ProtonDeficit:= FMashWater.ProtonDeficit(TpH);
      FMashWater.Bicarbonate.Subtract(ProtonDeficit * frac / vol);
      FMashWater.TotalAlkalinity.Subtract(50 / 61 * ProtonDeficit * frac / vol);

      if M.Name.Value = BaseTypeDisplayNames[btCaCO3] then
      begin
        FMashWater.Calcium.Add(1000000 * MMCa / MMCaCO3 * M.Amount.Value / vol);
        FMashWater.Bicarbonate.Add(1000000 * 0.3 * MMHCO3 / MMCaCO3 * M.Amount.Value / vol);
        FMashWater.TotalAlkalinity.Add(1000000 *  0.3 * MMHCO3 / MMCaCO3 * M.Amount.Value / vol * 50 / 61);
      end;
      if M.Name.Value = BaseTypeDisplayNames[btNaHCO3] then
      begin
        FMashWater.Sodium.Add(1000000 * MMNa / MMNaHCO3 * M.Amount.Value / vol);
        FMashWater.Bicarbonate.Add(1000000 * MMHCO3 / MMNaHCO3 * M.Amount.Value / vol);
        FMashWater.TotalAlkalinity.Add(1000000 * MMHCO3 / MMNaHCO3 * M.Amount.Value / vol * 50 / 61);
      end;
      if M.Name.Value = BaseTypeDisplayNames[btNa2CO3] then
      begin
        FMashWater.Sodium.Add(1000000 * 2 * MMNa / MMNa2CO3 * M.Amount.Value / vol);
        FMashWater.Bicarbonate.Add(1000000 * MMCO3 / MMNa2CO3 * M.Amount.Value / vol);
        FMashWater.TotalAlkalinity.Add(1000000 * MMCO3 / MMNa2CO3 * M.Amount.Value / vol * 50 / 61);
      end;
    end;
  end;

end;

function TRecipe.GetCa: double;
begin
  CalcMashWater;
  Result:= FMashWater.Calcium.Value;
end;

function TRecipe.GetMg: double;
begin
  CalcMashWater;
  Result:= FMashWater.Magnesium.Value;
end;

function TRecipe.GetNa: double;
begin
  CalcMashWater;
  Result:= FMashWater.Sodium.Value;
end;

function TRecipe.GetHCO3: double;
begin
  CalcMashWater;
  Result := FMashWater.Bicarbonate.Value;
end;

Function TRecipe.GetTotalAlkalinity : double;
begin
  CalcMashWater;
  Result:= GetHCO3 * 50 / 61;
end;

function TRecipe.GetCl: double;
begin
  CalcMashWater;
  Result := FMashWater.Chloride.Value;
end;

function TRecipe.GetSO4: double;
begin
  CalcMashWater;
  Result := FMashWater.Sulfate.Value;
end;

function TRecipe.GetRA: double;
begin
  CalcMashWater;
  Result:= FMashWater.ResidualAlkalinity;
end;

function TRecipe.GetEfficiency: double;
//var Eq: TEquipment;
//  OGr, WtGR: double;
begin
  Result := FEfficiency.Value;
  {if (not FLockEfficiency) and (FEquipment <> NIL) then
  begin
    Eq:= TEquipment(Equipments.FindByName(FEquipment.Name.Value));
    OGr:= SGStartBoil;
    if OGr = 1 then OGr:= 1.05;
    if (Mash <> NIL) and (Mash.MashStep[0] <> NIL) then
      WtGR:= Mash.MashStep[0].WaterToGrainRatio
    else
      WtGR:= 3;
    if WtGR < 1 then WtGR:= 3;
    if (Eq <> NIL) and (OGr > 1.0) and (WtGR > 0) then
      FEfficiency.Value:= Eq.CalcEfficiency(OGr, WtGR);
  end;}
end;

procedure TRecipe.SetEfficiency(d: double);
begin
  if FEfficiency.Value <> d then
  begin
    FLockEfficiency := True;
    FEfficiency.Value := d;
  end;
end;

procedure TRecipe.RemoveNonBrewsData;
begin
  Age.Value := 0;
  TasteNotes.Value := '';
  TastingRate.Value := 0;
  OG.Value := 1.000;
  FG.Value := 1.000;
  PrimaryAge.Value := 0;
  SecondaryAge.Value := 0;
  TertiaryAge.Value := 0;
  Age.Value := 0;
  AgeTemp.Value := 0;
  Date.Value := 0;
  ForcedCarbonation.Value := False;
  PrimingSugarName.Value := '';
  CarbonationTemp.Value := 0;
  EstABV.Value := 0;
  ActualEfficiency.Value := 0;
  NrRecipe.Value := '';
  pHAdjustmentWith.Value := '';
  pHAdjusted.Value := 0;
  TargetpH.Value:= 5.4;
  OGBeforeBoil.Value := 1.000;
  pHBeforeBoil.Value := 0;
  pHAfterBoil.Value := 0;
  VolumeBeforeBoil.Value := 0;
  VolumeAfterBoil.Value := 0;
  VolumeFermenter.Value := 0;
  WhirlpoolTime.Value:= 0;
  CoolingMethod := cmEmpty;
  CoolingTime.Value:= 0;
  TimeAeration.Value := 0;
  AerationType:= atNone;
  AerationFlowRate.Value:= 0;
  SGEndPrimary.Value := 1.000;
  DateBottling.Value := 0;
  VolumeBottles.Value := 0;
  VolumeKegs.Value := 0;
  CarbonationKegs.Value := 0;
  CarbonationTempKegs.Value := 0;
  ForcedCarbonationKegs.Value := True;
  AmountPrimingBottles.Value := 0;
  AmountPrimingKegs.Value := 0;
  PressureKegs.Value := 0;
  TasteDate.Value := 0;
  TasteColor.Value := '';
  TasteTransparency.Value := '';
  TasteHead.Value := '';
  TasteAroma.Value := '';
  TasteTaste.Value := '';
  TasteMouthfeel.Value := '';
  TasteAftertaste.Value := '';
  TimeStarted.Value := 0;
  TimeEnded.Value := 0;
  CoolingTime.Value := 0;
  WhirlpoolTime.Value := 0;
  InventoryReduced.Value := False;
  Locked.Value := False;
  FermMeasurements.Clear;
  CheckList.Clear;
end;

procedure TRecipe.DivideBrew(R: TRecipe; DiType: integer; NumBatches: word;
  VNr: integer);
var
  Vol: double;
  Nr, SNr: string;
begin
  if (R <> nil) and (DiType > -1) and (NumBatches > 1) and (VNr > 0) then
  begin
    Vol := FBatchSize.Value / NumBatches;
    Nr := FNrRecipe.Value;
    //    SNr:= Chr(96+VNr);
    SNr := '-' + IntToStr(VNr);
    R.Assign(self);
    R.DivisionType.Value := DiType;
    FDividedType.Value := DiType;
    R.NrRecipe.Value := Nr + SNr;
    R.DivisionFrom.Value := FAutoNr.Value;

    R.Scale(Vol);
    case DiType of
      0: //after mash
      begin
        R.OG.Value := 1.000;
        R.PrimaryAge.Value := 0;
        R.EstABV.Value := 0;
        R.ActualEfficiency.Value := 0;
        R.CoolingMethod := cmEmpty;
        R.pHAfterBoil.Value := 5.4;
        R.VolumeAfterBoil.Value := 0;
        R.VolumeFermenter.Value := 0;
        R.CoolingTime.Value := 0;
        R.WhirlpoolTime.Value := 0;
        R.TimeAeration.Value := 0;
        R.TimeEnded.Value := 0;
        R.SGEndPrimary.Value := 1.000;
      end;
      1: //after boil
      begin
        R.PrimaryAge.Value := 0;
        R.VolumeFermenter.Value := 0;
        R.TimeAeration.Value := 0;
        R.SGEndPrimary.Value := 1.000;
        R.TimeEnded.Value := 0;
      end;
{    2: //after primary
    begin
    end;}
    end;
    R.FG.Value := 1.000;
    R.SecondaryAge.Value := 0;
    R.TertiaryAge.Value := 0;
    R.Age.Value := 0;
    R.AgeTemp.Value := 0;
    R.ForcedCarbonation.Value := False;
    R.PrimingSugarName.Value := '';
    R.CarbonationTemp.Value := 0;
    R.DateBottling.Value := 0;
    R.VolumeBottles.Value := 0;
    R.VolumeKegs.Value := 0;
    R.CarbonationKegs.Value := 0;
    R.CarbonationTempKegs.Value := 0;
    R.ForcedCarbonationKegs.Value := True;
    R.AmountPrimingBottles.Value := 0;
    R.AmountPrimingKegs.Value := 0;
    R.PressureKegs.Value := 0;
    R.Age.Value := 0;
    R.TasteNotes.Value := '';
    R.TastingRate.Value := 0;
    R.TasteDate.Value := 0;
    R.TasteColor.Value := '';
    R.TasteTransparency.Value := '';
    R.TasteHead.Value := '';
    R.TasteAroma.Value := '';
    R.TasteTaste.Value := '';
    R.TasteMouthfeel.Value := '';
    R.TasteAftertaste.Value := '';
    R.InventoryReduced.Value := False;
    R.Locked.Value := False;
    R.FermMeasurements.Clear;
  end;
end;

function TRecipe.CopyToClipboardForumFormat: boolean;
const
  tabus = '[tabular type=4]';
  tabue = '[/tabular]';
  heads = '[head]';
  heade = '[/head]';
  rows = '[row]';
  rowe = '[/row]';
  datas = '[data]';
  datae = '[/data]';
var
  Memo: TMemo;
//  lf: char;
  s, s1, s2: string;
  i, n: integer;
  x, top : double;
//  volmalt, spdspc, evap, mashvol, vol: double;
  F: TFermentable;
  H: THop;
  M: TMisc;
  Y: TYeast;
  W: TWater;
  MS: TMashStep;
begin
  Result := False;
  try
    Memo := TMemo.Create(FrmMain);
    Memo.Parent := FrmMain;
    Memo.Visible := False;
    Memo.Lines.Clear;

//    lf := Chr(10);

    with Memo.Lines do
    begin
      Add('[u][b]BrouwHulp Recept uitdraai[/b][/u]');
      Add('');
      Add('');
      Add('[u][b]Basis[/b][/u]');
      Add(tabus);
      Add(heads + 'Omschrijving' + heade + heads + 'Waarde' + heade);
      Add(rows + datas + 'Kenmerk' + datae + datas + FNrRecipe.Value + datae + rowe);
      Add(rows + datas + 'Naam recept' + datae + datas + FName.Value + datae + rowe);
      Add(rows + datas + 'Brouwdatum' + datae + datas + FDate.DisplayString +
        datae + rowe);
      Add(rows + datas + 'Bierstijl' + datae + datas + FStyle.Name.Value + datae + rowe);

      if FVolumeFermenter.Value > 0 then
      begin
        x:= FVolumeFermenter.DisplayValue;
        if FEquipment <> NIL then
        begin
          if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
          else top:= FEquipment.TopUpWater.Value;
          x:= x + top;
        end;
        s1:= RealToStrDec(x, FVolumeFermenter.Decimals);
      end
      else if FVolumeAfterBoil.Value > 0 then s1:= FVolumeAfterBoil.DisplayString
      else s1:= FBatchSize.DisplayString;
      Add(rows + datas + 'Volume' + datae + datas + s1 + datae + rowe);

      if FOGFermenter.Value > 1.001 then
      begin
        s1:= FOGFermenter.DisplayString;
        x:= FOGFermenter.Value;
      end
      else if FOG.Value > 1.001 then
      begin
        s1 := FOG.DisplayString;
        x:= FOG.Value;
      end
      else
      begin
        s1 := FEstOG.DisplayString;
        x:= FEstOG.Value;
      end;
      Add(rows + datas + 'Begin SG' + datae + datas + s1 + datae + rowe);
      if (FFG.Value > 1.000) and (FOG.Value > 1.000) then
      begin
        Add(rows + datas + 'Eind SG' + datae + datas + FFG.DisplayString + datae + rowe);
        s1 := RealToStrDec(100 * (x - FFG.Value) / (x - 1), 1) + '%';
        Add(rows + datas + 'Schijnbare vergistingsgraad' + datae + datas + s1 + datae + rowe);
        Add(rows + datas + 'Alcoholgehalte' + datae + datas +
          FABV.DisplayString + datae + rowe);
      end;

      x:= Convert(srm, FEstColor.DisplayUnit, CalcColorFermenter);
      if x > 0 then s1:= RealToStrDec(x, 0) + ' ' + FEstColor.DisplayUnitString
      else s1:= FEstColor.DisplayString;
      Add(rows + datas + 'Berekende kleur (' + Settings.ColorMethod.Value + ')' + datae
          + datas + s1 + datae + rowe);

      x:= CalcIBUFermenter;
      if x > 0 then
        s1:= RealToStrDec(x, 0) + ' ' + FIBU.DisplayUnitString
      else s1:= FIBU.DisplayString;
      s:= Settings.IBUMethod.Value;
      Add(rows + datas + 'Berekende bitterheid (' + s + ')' + datae
          + datas + s1 + datae + rowe);

      if FActualEfficiency.Value > 30 then
        s1 := FActualEfficiency.DisplayString
      else
        s1 := FEfficiency.DisplayString;
      Add(rows + datas + 'Brouwzaalrendement' + datae + datas + s1 + datae + rowe);
      Add(rows + datas + 'Kooktijd' + datae + datas + FBoilTime.DisplayString +
        datae + rowe);
      Add(tabue);
      Add('');

      if NumWaters > 0 then
      begin
        Add('[u][b]Water en brouwzouten[/b][/u]');
        Add(tabus);
        Add(heads + 'Hoeveelheid' + heade + heads + 'Ingrediënt' + heade);
        for i := 0 to NumWaters - 1 do
        begin
          W := Water[i];
          S1 := rows + datas + W.Amount.Displaystring + datae;
          S2 := W.Name.Value;
          if NPos('water', S2, 1) < 1 then
            S2 := 'Water uit ' + S2;
          S1 := S1 + datas + S2 + datae + rowe;
          Add(S1);
        end;
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.FMiscType = mtWaterAgent then
          begin
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae + rowe;
            Add(S1);
          end;
        end;
        if (FMash <> nil) and (FEquipment <> nil) then
        begin
          {volMalt := GrainMassMash * Settings.GrainAbsorption.Value;
          spdspc := FEquipment.LauterDeadSpace.Value;
          evap := FEquipment.EvapRate.Value / 100 * FBoilSize.Value;
          mashvol := FMash.MashWaterVolume;
          vol := ExpansionFactor * FBatchSize.Value - mashvol + volmalt + spdspc + evap;
          s1 := RealToStrDec(Convert(FBatchSize.vUnit, liter, mashvol), 2) +
            ' ' + FBatchSize.DisplayUnitString;
          s2 := RealToStrDec(Convert(FBatchSize.vUnit, liter, vol), 2) +
            ' ' + FBatchSize.DisplayUnitString;}
          s2:= RealToStrDec(Convert(FBatchSize.vUnit, liter, FMash.SpargeVolume), 2);
          Add(rows + datas + s2 + ' ' + UnitNames[FBatchSize.vUnit]+ datae
              + datas + 'Spoelwater' + datae + rowe);
        end;
        Add(tabue);
        Add('');
        Add('[u][b]Waterprofiel behandeld water[/b][/u]');
        Add(tabus);
        Add(heads + 'Ca' + heade + heads + 'Mg' + heade + heads +
          'Na' + heade + heads + 'HCO3' + heade + heads + 'Cl' +
          heade + heads + 'SO4' + heade);
        S1 := rows + datas + RealToStrDec(Ca, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Mg, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Na, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(HCO3, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Cl, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(SO4, 0) + ' mg/l' + datae + rowe;
        Add(S1);
        Add(tabue);
        Add('');
      end;

      if NumFermentables > 0 then
      begin
        //SortFermentables(2, 7, TRUE);
        Add('[u][b]Vergistbare ingrediënten[/b][/u]');
        Add(tabus);
        Add(heads + 'Hoeveelheid' + heade + heads + 'Naam' + heade +
          heads + 'Mouterij' + heade + heads + 'Kleur' + heade + heads + '%' + heade);
        for i := 0 to NumFermentables - 1 do
        begin
          F := Fermentable[i];
          S1 := rows + datas + F.Amount.DisplayString + datae;
          S1 := S1 + datas + F.Name.Value + datae;
          S1 := S1 + datas + F.Supplier.Value + datae;
          S1 := S1 + datas + F.Color.DisplayString + datae;
          S1 := S1 + datas + F.Percentage.DisplayString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FMash <> nil then
      begin
        Add('[u][b]Maischschema[/b][/u]');
        Add(tabus);
        Add(heads + 'Omschrijving' + heade + heads + 'Temperatuur' +
          heade + heads + 'Stap tijd' + heade + heads + 'Rust tijd' +
          heade + heads + 'Beslagdikte' + heade);
        for i := 0 to FMash.NumMashSteps - 1 do
        begin
          MS := FMash.MashStep[i];
          S1 := rows + datas + MS.Name.Value + datae;
          S1 := S1 + datas + MS.StepTemp.DisplayString + datae;
          S1 := S1 + datas + MS.RampTime.DisplayString + datae;
          S1 := S1 + datas + MS.StepTime.DisplayString + datae;
          S1 := S1 + datas + RealToStrDec(MS.WaterToGrainRatio, 1) +
            ' ' + FBatchSize.DisplayUnitString + '/' +
            Fermentable[0].Amount.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if NumHops > 0 then
      begin
        //SortHops(9, 0, true);
        Add('[u][b]Hop[/b][/u]');
        Add(tabus);
        Add(heads + 'Hoeveelheid' + heade + heads + 'Naam' + heade +
            heads + 'Type' + heade +
            heads + '% alfazuur' + heade + heads + 'Kooktijd/toevoeging' +
            heade + heads + 'IBU' + heade);
        for i := 0 to NumHops - 1 do
        begin
          H := Hop[i];
          S1 := rows + datas + H.Amount.DisplayString + datae;
          S1 := S1 + datas + H.Name.Value + datae;
          S1 := S1 + datas + H.FormDisplayName + datae;
          S1 := S1 + datas + RealToStrDec(H.AlfaAdjusted, 1) + '%'+ datae;
          case H.Use of
            huBoil, huAroma: S2 := H.Time.DisplayString;
            huDryhop, huMash, huFirstwort, huWhirlpool: S2 := HopUseDisplayNames[H.Use];
          end;
          S1 := S1 + datas + S2 + datae;
          S1 := S1 + datas + RealToStrDec(H.BitternessContribution, 1) +
            ' ' + FIBU.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;


      n:= 0;
      for i:= 0 to NumMiscs - 1 do
        if Misc[i].MiscType <> mtWaterAgent then Inc(n);
      if n > 0 then
      begin
        //SortMiscs(7, 0, true);
        Add('[u][b]Overige ingrediënten[/b][/u]');
        Add(tabus);
        Add(heads + 'Hoeveelheid' + heade + heads + 'Naam' + heade +
          heads + 'Type' + heade + heads + 'Gebruik' + heade);
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.MiscType <> mtWaterAgent then
          begin
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae;
            S1 := S1 + datas + MiscTypeDisplayNames[M.MiscType] + datae;
            S1 := S1 + datas + MiscUseDisplayNames[M.Use] + datae + rowe;
            Add(S1);
          end;
        end;
        Add(tabue);
        Add('');
      end;

      if NumYeasts > 0 then
      begin
        Add('[u][b]Gist[/b][/u]');
        Add(tabus);
        Add(heads + 'Hoeveelheid' + heade + heads + 'Naam' + heade +
          heads + 'Type' + heade);
        for i := 0 to NumYeasts - 1 do
        begin
          Y := Yeast[i];
          if Y.StarterMade.Value then
          begin
            if Y.StarterVolume1.Value > 0 then
              s1 := Y.StarterVolume1.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume2.DisplayString;
            if Y.StarterVolume3.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume3.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' getrapte starter'
            else
              s1:= s1 + ' starter';
          end
          else
            s1 := Y.AmountYeast.DisplayString;
          S1 := rows + datas + s1 + datae;
          S1 := S1 + datas + Y.Name.Value + ' (' + Y.ProductID.Value + ')' + datae;
          S1 := S1 + datas + YeastTypeDisplayNames[Y.YeastType] + datae + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FStartTempPrimary.Value > 0 then
      begin
        Add('[u][b]Vergisting[/b][/u]');
        Add(tabus);
        Add(heads + 'Kenmerk' + heade + heads + 'Waarde' + heade);
        Add(rows + datas + 'Starttemp. vergisting' + datae + datas +
          FStartTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Max. temp. hoofdvergisting' + datae +
          datas + FMaxTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Eind temp. hoofdvergisting' + datae +
          datas + FEndTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Eind SG hoofdvergisting' + datae + datas +
          FSGEndPrimary.DisplayString + datae + rowe);
        if FOG.Value > 1 then
          Add(rows + datas + 'Schijnbare vergistingsgraad' + datae +
            datas + RealToStrDec(100 * (FOG.Value - FSGEndPrimary.Value) / (FOG.Value - 1), 1) +
            '%' + datae + rowe);
        if FPrimaryAge.Value > 0 then
          Add(rows + datas + 'Start nagisting' + datae + datas +
            DateToStr(FDate.Value + FPrimaryAge.Value) + datae + rowe);
        Add(rows + datas + 'Temp. nagisting' + datae + datas +
          FSecondaryTemp.DisplayString + datae + rowe);
        if FSecondaryAge.Value > 0 then
          Add(rows + datas + 'Start lagering' + datae + datas +
            DateToStr(FDate.Value + FSecondaryAge.Value) + datae + rowe);
        Add(rows + datas + 'Temp. lagering' + datae + datas +
          FTertiaryTemp.DisplayString + datae + rowe);
        Add(tabue);
        Add('');
      end;
    end;

    Memo.SelectAll;
    Memo.CopyToClipboard;

    Result := True;
  finally
    Memo.Free;
  end;
end;

function TRecipe.CopyToClipboardHTML: boolean;
const
  Donkergeel = '#f9d705';
  Lichtgeel = '#fbfea3';
var
  tabus, tabue, heads, heade, rowse, rowso, rowe, datas, datae, rows: string;
  qm: char;
  Memo: TMemo;
  s1, s2: string;
  i, n, rownr: integer;
  //volmalt, spdspc, evap, mashvol, vol: double;
  x, top: double;
  F: TFermentable;
  H: THop;
  M: TMisc;
  Y: TYeast;
  W: TWater;
  MS: TMashStep;

  function Rowclr: string;
  begin
    if (RowNr mod 2 = 0) then
      Result := rowse
    else
      Result := rowso;
    Inc(RowNr);
  end;

begin
  qm := CHR(34);
  tabus := '<table border=' + qm + '0' + qm + '><tbody>';
  tabue := '</tbody></table>';
  heads := '<td style=' + qm + 'width: 200px;' + qm + '><p align=' +
    qm + 'center' + qm + '><span style=' + qm + 'color: #000000;' + qm + '><strong>';
  heade := '</strong></span></p></td>';
  rowse := '<tr style=' + qm + 'background-color: ' + Lichtgeel + ';' +
    qm + ' valign=' + qm + 'top' + qm + '>';
  rowso := '<tr style=' + qm + 'background-color: ' + Donkergeel + ';' +
    qm + ' valign=' + qm + 'top' + qm + '>';
  rowe := '</tr>';
  datas := '<td style=' + qm + 'width: 200px;' + qm + '><p align=' +
    qm + 'center' + qm + '><span style=' + qm + 'color: #000000;' + qm + '>';
  datae := '</span></p></td>';
  Result := False;
  try
    Memo := TMemo.Create(FrmMain);
    Memo.Parent := FrmMain;
    Memo.Visible := False;
    Memo.Lines.Clear;
    with Memo.Lines do
    begin
      Add('<h1>BrouwHulp Recept uitdraai</h1>');
      Add('');
      Add('');
      Add('<p><strong>Basis</strong></p>');
      Add(tabus);
      RowNr := 0;
      rows := RowClr;
      Add(rows + heads + 'Omschrijving' + heade + heads + 'Waarde' + heade + rowe);
      rows := RowClr;
      Add(rows + datas + 'Kenmerk' + datae + datas + FNrRecipe.Value + datae + rowe);
      rows := RowClr;
      Add(rows + datas + 'Naam recept' + datae + datas + FName.Value + datae + rowe);
      rows := RowClr;
      Add(rows + datas + 'Brouwdatum' + datae + datas + FDate.DisplayString +
        datae + rowe);
      rows := RowClr;
      Add(rows + datas + 'Bierstijl' + datae + datas + FStyle.Name.Value + datae + rowe);
      rows := RowClr;
      if FVolumeFermenter.Value > 0 then
      begin
        x:= FVolumeFermenter.DisplayValue;
        if FEquipment <> NIL then
        begin
          if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
          else top:= FEquipment.TopUpWater.Value;
          x:= x + top;
        end;
        s1:= RealToStrDec(x, FVolumeFermenter.Decimals);
      end
      else if FVolumeAfterBoil.Value > 0 then s1:= FVolumeAfterBoil.DisplayString
      else s1:= FBatchSize.DisplayString;
      Add(rows + datas + 'Volume' + datae + datas + s1 + datae + rowe);
      rows := RowClr;
      if FOGFermenter.Value > 1.001 then
      begin
        s1:= FOGFermenter.DisplayString;
        x:= FOGFermenter.Value;
      end
      else if FOG.Value > 1.001 then
      begin
        s1 := FOG.DisplayString;
        x:= FOG.Value;
      end
      else
      begin
        s1 := FEstOG.DisplayString;
        x:= FEstOG.Value;
      end;
      Add(rows + datas + 'Begin SG' + datae + datas + s1 + datae + rowe);
      if (FFG.Value > 1.000) and (FOG.Value > 1.000) then
      begin
        rows := RowClr;
        Add(rows + datas + 'Eind SG' + datae + datas + FFG.DisplayString + datae + rowe);
        rows := RowClr;
        s1 := RealToStrDec(100 * (FOG.Value - FFG.Value) / (FOG.Value - 1), 1) + '%';
        Add(rows + datas + 'Schijnbare vergistingsgraad' + datae + datas + s1 + datae + rowe);
        rows := RowClr;
        Add(rows + datas + 'Alcoholgehalte' + datae + datas +
          FABV.DisplayString + datae + rowe);
      end;
      rows := RowClr;
      x:= Convert(srm, FEstColor.DisplayUnit, CalcColorFermenter);
      if x > 0 then s1:= RealToStrDec(x, 0) + ' ' + FEstColor.DisplayUnitString
      else s1:= FEstColor.DisplayString;
      Add(rows + datas + 'Berekende kleur (' + Settings.ColorMethod.Value + ')' + datae
          + datas + s1 + datae + rowe);
      rows := RowClr;
      x:= CalcIBUFermenter;
      if x > 0 then
        s1:= RealToStrDec(x, 0) + ' ' + FIBU.DisplayUnitString
      else s1:= FIBU.DisplayString;
      Add(rows + datas + 'Berekende bitterheid (' + Settings.IBUMethod.Value + ')' + datae
          + datas + s1 + datae + rowe);
      rows := RowClr;
      if FActualEfficiency.Value > 30 then
        s1 := FActualEfficiency.DisplayString
      else
        s1 := FEfficiency.DisplayString;
      Add(rows + datas + 'Brouwzaalrendement' + datae + datas + s1 + datae + rowe);
      rows := RowClr;
      Add(rows + datas + 'Kooktijd' + datae + datas + FBoilTime.DisplayString +
        datae + rowe);
      Add(tabue);
      Add('');

      if NumWaters > 0 then
      begin
        Add('<p><strong>Water en brouwzouten</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Hoeveelheid' + heade + heads + 'Ingrediënt' + heade + rowe);
        n := 0;
        for i := 0 to NumWaters - 1 do
        begin
          W := Water[i];
          Inc(n);
          if (n mod 2 = 0) then
            rows := rowso
          else
            rows := rowse;
          S1 := rows + datas + W.Amount.Displaystring + datae;
          S2 := W.Name.Value;
          if NPos('water', S2, 1) < 1 then
            S2 := 'Water uit ' + S2;
          S1 := S1 + datas + S2 + datae + rowe;
          Add(S1);
        end;
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.FMiscType = mtWaterAgent then
          begin
            Inc(n);
            if (n mod 2 = 0) then
              rows := rowso
            else
              rows := rowse;
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae + rowe;
            Add(S1);
          end;
        end;
        if (FMash <> nil) and (FEquipment <> nil) then
        begin
         { volMalt := GrainMassMash * Settings.GrainAbsorption.Value;
          spdspc := FEquipment.LauterDeadSpace.Value;
          evap := FEquipment.EvapRate.Value / 100 * FBoilSize.Value;
          mashvol := FMash.MashWaterVolume;
          vol := ExpansionFactor * FBatchSize.Value - mashvol + volmalt + spdspc + evap;
          s1 := RealToStrDec(Convert(FBatchSize.vUnit, liter, mashvol), 2) +
            ' ' + FBatchSize.DisplayUnitString;
          s2 := RealToStrDec(Convert(FBatchSize.vUnit, liter, vol), 2) +
            ' ' + FBatchSize.DisplayUnitString;}
          s2:= RealToStrDec(Convert(FBatchSize.vUnit, liter, FMash.SpargeVolume), 2);
          Inc(n);
          if (n mod 2 = 0) then
            rows := rowse
          else
            rows := rowso;
          Add(rows + datas + S2 + ' ' + UnitNames[FBatchSize.vUnit] + datae
              + datas + 'Spoelwater' + datae + rowe);
        end;
        Add(tabue);
        Add('');

        Add('<p><strong>Waterprofiel behandeld water</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Ca' + heade + heads + 'Mg' + heade +
          heads + 'Na' + heade + heads + 'HCO3' + heade + heads +
          'Cl' + heade + heads + 'SO4' + heade + rowe);
        S1 := rowse + datas + RealToStrDec(Ca, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Mg, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Na, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(HCO3, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Cl, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(SO4, 0) + ' mg/l' + datae + rowe;
        Add(S1);
        Add(tabue);
        Add('');
      end;

      if NumFermentables > 0 then
      begin
        //SortFermentables(2, 7, TRUE);
        Add('<p><strong>Vergistbare ingrediënten</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Hoeveelheid' + heade + heads + 'Naam' +
          heade + heads + 'Mouterij' + heade + heads + 'Kleur' +
          heade + heads + '%' + heade + rowe);
        for i := 0 to NumFermentables - 1 do
        begin
          F := Fermentable[i];
          if (i mod 2 = 0) then
            rows := rowse
          else
            rows := rowso;
          S1 := rows + datas + F.Amount.DisplayString + datae;
          S1 := S1 + datas + F.Name.Value + datae;
          S1 := S1 + datas + F.Supplier.Value + datae;
          S1 := S1 + datas + F.Color.DisplayString + datae;
          S1 := S1 + datas + F.Percentage.DisplayString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FMash <> nil then
      begin
        Add('<p><strong>Maischschema</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Omschrijving' + heade + heads + 'Temperatuur' +
          heade + heads + 'Stap tijd' + heade + heads + 'Rust tijd' +
          heade + heads + 'Beslagdikte' + heade + rowe);
        for i := 0 to FMash.NumMashSteps - 1 do
        begin
          MS := FMash.MashStep[i];
          if (i mod 2 = 0) then
            rows := rowse
          else
            rows := rowso;
          S1 := rows + datas + MS.Name.Value + datae;
          S1 := S1 + datas + MS.StepTemp.DisplayString + datae;
          S1 := S1 + datas + MS.RampTime.DisplayString + datae;
          S1 := S1 + datas + MS.StepTime.DisplayString + datae;
          S1 := S1 + datas + RealToStrDec(MS.WaterToGrainRatio, 1) +
            ' ' + FBatchSize.DisplayUnitString + '/' +
            Fermentable[0].Amount.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if NumHops > 0 then
      begin
        //SortHops(9, 0, true);
        Add('<p><strong>Hop</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Hoeveelheid' + heade + heads + 'Naam' + heade +
            heads + 'Type' + heade +
            heads + '% alfazuur' + heade + heads + 'Kooktijd/toevoeging' + heade +
            heads + 'IBU' + heade + rowe);
        for i := 0 to NumHops - 1 do
        begin
          H := Hop[i];
          if (i mod 2 = 0) then
            rows := rowse
          else
            rows := rowso;
          S1 := rows + datas + H.Amount.DisplayString + datae;
          S1 := S1 + datas + H.Name.Value + datae;
          S1 := S1 + datas + H.FormDisplayName + datae;
          S1 := S1 + datas + RealToStrDec(H.AlfaAdjusted, 1) + '%'+ datae;
          case H.Use of
            huBoil, huAroma: S2 := H.Time.DisplayString;
            huDryhop, huMash, huFirstwort, huWhirlpool: S2 := HopUseDisplayNames[H.Use];
          end;
          S1 := S1 + datas + S2 + datae;
          S1 := S1 + datas + RealToStrDec(H.BitternessContribution, 1) +
            ' ' + FIBU.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;


      n:= 0;
      for i:= 0 to NumMiscs - 1 do
        if Misc[i].MiscType <> mtWaterAgent then Inc(n);
      if NumMiscs > 0 then
      begin
        //SortMiscs(7, 0, true);
        Add('<p><strong>Overige ingrediënten</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Hoeveelheid' + heade + heads + 'Naam' +
          heade + heads + 'Type' + heade + heads + 'Gebruik' + heade + rowe);
        n := 0;
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.MiscType <> mtWaterAgent then
          begin
            Inc(n);
            if (n mod 2 = 0) then
              rows := rowso
            else
              rows := rowse;
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae;
            S1 := S1 + datas + MiscTypeDisplayNames[M.MiscType] + datae;
            S1 := S1 + datas + MiscUseDisplayNames[M.Use] + datae + rowe;
            Add(S1);
          end;
        end;
        Add(tabue);
        Add('');
      end;

      if NumYeasts > 0 then
      begin
        Add('<p><strong>Gist</strong></p>');
        Add(tabus);
        Add(rowso + heads + 'Hoeveelheid' + heade + heads + 'Naam' +
          heade + heads + 'Type' + heade + rowe);
        for i := 0 to NumYeasts - 1 do
        begin
          Y := Yeast[i];
          if (i mod 2 = 0) then
            rows := rowse
          else
            rows := rowso;

          if Y.StarterMade.Value and (Y.StarterVolume1.Value > 0) then
          begin
            if Y.StarterVolume1.Value > 0 then
              s1 := Y.StarterVolume1.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume2.DisplayString;
            if Y.StarterVolume3.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume3.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' getrapte starter'
            else
              s1:= s1 + ' starter';
          end
          else
            s1 := Y.AmountYeast.DisplayString;
          S1 := rows + datas + s1 + datae;
          S1 := S1 + datas + Y.Name.Value + ' (' + Y.ProductID.Value + ')' + datae;
          S1 := S1 + datas + YeastTypeDisplayNames[Y.YeastType] + datae + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FStartTempPrimary.Value > 0 then
      begin
        Add('<p><strong>Vergisting</strong></p>');
        Add(tabus);
        RowNr := 0;
        rows := RowClr;
        Add(rows + heads + 'Kenmerk' + heade + heads + 'Waarde' + heade + rowe);
        rows := RowClr;
        Add(rows + datas + 'Starttemp. vergisting' + datae + datas +
          FStartTempPrimary.DisplayString + datae + rowe);
        rows := RowClr;
        Add(rows + datas + 'Max. temp. hoofdvergisting' + datae +
          datas + FMaxTempPrimary.DisplayString + datae + rowe);
        rows := RowClr;
        Add(rows + datas + 'Eind temp. hoofdvergisting' + datae +
          datas + FEndTempPrimary.DisplayString + datae + rowe);
        rows := RowClr;
        Add(rows + datas + 'Eind SG hoofdvergisting' + datae + datas +
          FSGEndPrimary.DisplayString + datae + rowe);
        rows := RowClr;
        if FOG.Value > 1 then
          Add(rows + datas + 'Schijnbare vergistingsgraad' + datae +
              datas + RealToStrDec(100 * (FOG.Value - FSGEndPrimary.Value) / (FOG.Value - 1), 1) +
              '%' + datae + rowe);
        if FPrimaryAge.Value > 0 then
        begin
          rows := RowClr;
          Add(rows + datas + 'Start nagisting' + datae + datas +
            DateToStr(FDate.Value + FPrimaryAge.Value) + datae + rowe);
        end;
        rows := RowClr;
        Add(rows + datas + 'Temp. nagisting' + datae + datas +
          FSecondaryTemp.DisplayString + datae + rowe);
        if FSecondaryAge.Value > 0 then
        begin
          rows := RowClr;
          Add(rows + datas + 'Start lagering' + datae + datas +
            DateToStr(FDate.Value + FSecondaryAge.Value) + datae + rowe);
        end;
        rows := RowClr;
        Add(rows + datas + 'Temp. lagering' + datae + datas +
          FTertiaryTemp.DisplayString + datae + rowe);
        Add(tabue);
        Add('');
      end;
    end;

    Memo.SelectAll;
    Memo.CopyToClipboard;

    Result := True;
  finally
    Memo.Free;
  end;
end;

function TRecipe.SaveHTML(s : string) : boolean;
var L : TStringList;
  tabus, tabue, heads, heade, firsts, firste, rows, rowe, datas, datae: string;
  lf: char;
  s1, s2: string;
  i: integer;
  //volmalt, spdspc, evap, mashvol, vol: double;
  x, top: double;
  F: TFermentable;
  H: THop;
  M: TMisc;
  Y: TYeast;
  W: TWater;
  MS: TMashStep;
begin
  lf := CHR(10);
  tabus := '<p>'+lf+'<table id="bier">';
  tabue := '</table></p>';
  heads := '	<caption>';
  heade := '</caption>';
  rows := '	<tr>';
  rowe := '</tr>';
  firsts := '<th>';
  firste := '</th>';
  datas := '<td>';
  datae := '</td>';
  Result := False;
  try
    l:= TStringList.Create;

    with l do
    begin
      Add('<head>');
      Add('<meta charset="utf-8">');
      Add('<style type="text/css">');
      Add('	#bier {');
      Add('		border-collapse: collapse;');
      Add('		border: 2px solid #fff4bf;');
      Add('	}');
      Add('	#bier CAPTION {');
      Add('		font-weight: bold;');
      Add('		text-align: left;');
      Add('		background-color: #fff4bf;');
      Add('		padding:8px;');
      Add('		margin-bottom: 1px;');
      Add('	}');
      Add('	#bier TR:nth-child(even) {');
      Add('		background-color: #ffffe5;');
      Add('	}');
      Add('	#bier TR:nth-child(odd) {');
      Add('		background-color: #fffad1;');
      Add('	}');
      Add('	#bier TH {');
      Add('		width: 200px;');
      Add('		background-color: #fff4bf;');
      Add('		font-size: 80%;');
      Add('		border: 2px solid #ffffe5;');
      Add('		padding:5px;');
      Add('		text-align: left;');
      Add('	}');
      Add('	#bier TD {');
      Add('		border: 1px solid #fff4bf;');
      Add('		width: 200px;');
      Add('		padding:3px;');
      Add('		font-size: 80%;');
      Add('	}');
      Add('</style>');
      Add('</head>');
      Add('<body>');

{      Add('<h1>BrouwHulp Recept uitdraai</h1>');
      Add('');
      Add('');}
      Add(tabus);
      Add(heads + 'Basis' + heade);
      Add(rows + firsts + 'Omschrijving' + firste + firsts + 'Waarde' + firste + rowe);
      Add(rows + datas + 'Kenmerk' + datae + datas + FNrRecipe.Value + datae + rowe);
      Add(rows + datas + 'Naam recept' + datae + datas + FName.Value + datae + rowe);
      Add(rows + datas + 'Brouwdatum' + datae + datas + FDate.DisplayString +
        datae + rowe);
      Add(rows + datas + 'Bierstijl' + datae + datas + FStyle.Name.Value + datae + rowe);
      if FVolumeFermenter.Value > 0 then
      begin
        x:= FVolumeFermenter.DisplayValue;
        if FEquipment <> NIL then
        begin
          if FEquipment.TopUpWaterBrewday.Value > 0 then top:= FEquipment.TopUpWaterBrewDay.Value
          else top:= FEquipment.TopUpWater.Value;
          x:= x + top;
        end;
        s1:= RealToStrDec(x, FVolumeFermenter.Decimals);
      end
      else if FVolumeAfterBoil.Value > 0 then s1:= FVolumeAfterBoil.DisplayString
      else s1:= FBatchSize.DisplayString;
      Add(rows + datas + 'Volume' + datae + datas + s1 + datae + rowe);
      if FOGFermenter.Value > 1.001 then
      begin
        s1:= FOGFermenter.DisplayString;
        x:= FOGFermenter.Value;
      end
      else if FOG.Value > 1.001 then
      begin
        s1 := FOG.DisplayString;
        x:= FOG.Value;
      end
      else
      begin
        s1 := FEstOG.DisplayString;
        x:= FEstOG.Value;
      end;
      Add(rows + datas + 'Begin SG' + datae + datas + s1 + datae + rowe);
      if (FFG.Value > 1.000) and (FOG.Value > 1.000) then
      begin
        Add(rows + datas + 'Eind SG' + datae + datas + FFG.DisplayString + datae + rowe);
        s1 := RealToStrDec(100 * (FOG.Value - FFG.Value) / (FOG.Value - 1), 1) + '%';
        Add(rows + datas + 'Schijnbare vergistingsgraad' + datae + datas + s1 + datae + rowe);
      end;
      x:= Convert(srm, FEstColor.DisplayUnit, CalcColorFermenter);
      if x > 0 then s1:= RealToStrDec(x, 0) + ' ' + FEstColor.DisplayUnitString
      else s1:= FEstColor.DisplayString;
      Add(rows + datas + 'Berekende kleur (' + Settings.ColorMethod.Value + ')' + datae
          + datas + s1 + datae + rowe);
      x:= CalcIBUFermenter;
      if x > 0 then
        s1:= RealToStrDec(x, 0) + ' ' + FIBU.DisplayUnitString
      else s1:= FIBU.DisplayString;
      Add(rows + datas + 'Berekende bitterheid (' + Settings.IBUMethod.Value + ')' + datae
          + datas + s1 + datae + rowe);
      if FActualEfficiency.Value > 30 then
        s1 := FActualEfficiency.DisplayString
      else
        s1 := FEfficiency.DisplayString;
      Add(rows + datas + 'Brouwzaalrendement' + datae + datas + s1 + datae + rowe);
      Add(rows + datas + 'Kooktijd' + datae + datas + FBoilTime.DisplayString +
        datae + rowe);
      Add(tabue);
      Add('');

      if NumWaters > 0 then
      begin
        Add(tabus);
        Add(heads + 'Water en brouwzouten' + heade);
        Add(rows + firsts + 'Hoeveelheid' + firste + firsts + 'Ingrediënt' + firste + rowe);
        for i := 0 to NumWaters - 1 do
        begin
          W := Water[i];
          S1 := rows + datas + W.Amount.Displaystring + datae;
          S2 := W.Name.Value;
          if NPos('water', S2, 1) < 1 then
            S2 := 'Water uit ' + S2;
          S1 := S1 + datas + S2 + datae + rowe;
          Add(S1);
        end;
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.FMiscType = mtWaterAgent then
          begin
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae + rowe;
            Add(S1);
          end;
        end;
        if (FMash <> nil) and (FEquipment <> nil) then
        begin
         { volMalt := GrainMassMash * Settings.GrainAbsorption.Value;
          spdspc := FEquipment.LauterDeadSpace.Value;
          evap := FEquipment.EvapRate.Value / 100 * FBoilSize.Value;
          mashvol := FMash.MashWaterVolume;
          vol := ExpansionFactor * FBatchSize.Value - mashvol + volmalt + spdspc + evap;
          s1 := RealToStrDec(Convert(FBatchSize.vUnit, liter, mashvol), 2) +
            ' ' + FBatchSize.DisplayUnitString;
          s2 := RealToStrDec(Convert(FBatchSize.vUnit, liter, vol), 2) +
            ' ' + FBatchSize.DisplayUnitString;}
          s2:= RealToStrDec(Convert(FBatchSize.vUnit, liter, FMash.SpargeVolume), 2);
          Add(rows + datas + S2 + ' ' + UnitNames[FBatchSize.vUnit] + datae
              + datas + 'Spoelwater'  + datae + rowe);
        end;
        Add(tabue);
        Add('');

        Add(tabus);
        Add(heads + 'Waterprofiel behandeld water' + heade);
        Add(rows + firsts + 'Ca' + firste + firsts + 'Mg' + firste +
          firsts + 'Na' + firste + firsts + 'HCO3' + firste + firsts +
          'Cl' + firste + firsts + 'SO4' + firste + rowe);
        S1 := rows + datas + RealToStrDec(Ca, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Mg, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Na, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(HCO3, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(Cl, 0) + ' mg/l' + datae;
        S1 := S1 + datas + RealToStrDec(SO4, 0) + ' mg/l' + datae + rowe;
        Add(S1);
        Add(tabue);
        Add('');
      end;

      if NumFermentables > 0 then
      begin
        //SortFermentables(2, 7, TRUE);
        Add(tabus);
        Add(heads + 'Vergistbare ingrediënten' + heade);
        Add(rows + firsts + 'Hoeveelheid' + firste + firsts + 'Naam' +
          firste + firsts + 'Mouterij' + firste + firsts + 'Kleur' +
          firste + firsts + '%' + firste + rowe);
        for i := 0 to NumFermentables - 1 do
        begin
          F := Fermentable[i];
          S1 := rows + datas + F.Amount.DisplayString + datae;
          S1 := S1 + datas + F.Name.Value + datae;
          S1 := S1 + datas + F.Supplier.Value + datae;
          S1 := S1 + datas + F.Color.DisplayString + datae;
          S1 := S1 + datas + F.Percentage.DisplayString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FMash <> nil then
      begin
        Add(tabus);
        Add(heads + 'Maischschema' + heade);
        Add(rows + firsts + 'Omschrijving' + firste + firsts + 'Temperatuur' +
          firste + firsts + 'Stap tijd' + firste + firsts + 'Rust tijd' +
          firste + firsts + 'Beslagdikte' + firste + rowe);
        for i := 0 to FMash.NumMashSteps - 1 do
        begin
          MS := FMash.MashStep[i];
          S1 := rows + datas + MS.Name.Value + datae;
          S1 := S1 + datas + MS.StepTemp.DisplayString + datae;
          S1 := S1 + datas + MS.RampTime.DisplayString + datae;
          S1 := S1 + datas + MS.StepTime.DisplayString + datae;
          S1 := S1 + datas + RealToStrDec(MS.WaterToGrainRatio, 1) +
            ' ' + FBatchSize.DisplayUnitString + '/' +
            Fermentable[0].Amount.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if NumHops > 0 then
      begin
        //SortHops(9, 0, true);
        Add(tabus);
        Add(Heads + 'Hop' + heade);
        Add(rows + firsts + 'Hoeveelheid' + firste + firsts + 'Naam' + firste +
            firsts + 'Type' + firste + firsts + '% alfazuur' + firste +
            firsts + 'Kooktijd/toevoeging' + firste + firsts + 'IBU' + firste + rowe);
        for i := 0 to NumHops - 1 do
        begin
          H := Hop[i];
          S1 := rows + datas + H.Amount.DisplayString + datae;
          S1 := S1 + datas + H.Name.Value + datae;
          S1 := S1 + datas + H.FormDisplayName + datae;
          S1 := S1 + datas + RealToStrDec(H.AlfaAdjusted, 1) + '%' + datae;
          case H.Use of
            huBoil, huAroma: S2 := H.Time.DisplayString;
            huDryhop, huMash, huFirstwort, huWhirlpool: S2 := HopUseDisplayNames[H.Use];
          end;
          S1 := S1 + datas + S2 + datae;
          S1 := S1 + datas + RealToStrDec(H.BitternessContribution, 1) +
            ' ' + FIBU.DisplayUnitString + datae;
          S1 := S1 + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;


      if NumMiscs > 0 then
      begin
        //SortMiscs(7, 0, true);
        Add(tabus);
        Add(heads + 'Overige ingrediënten' + heade);
        Add(rows + firsts + 'Hoeveelheid' + firste + firsts + 'Naam' +
          firste + firsts + 'Type' + firste + firsts + 'Gebruik' + firste + rowe);
        for i := 0 to NumMiscs - 1 do
        begin
          M := Misc[i];
          if M.MiscType <> mtWaterAgent then
          begin
            S1 := rows + datas + M.Amount.DisplayString + datae;
            S1 := S1 + datas + M.Name.Value + datae;
            S1 := S1 + datas + MiscTypeDisplayNames[M.MiscType] + datae;
            S1 := S1 + datas + MiscUseDisplayNames[M.Use] + datae + rowe;
            Add(S1);
          end;
        end;
        Add(tabue);
        Add('');
      end;

      if NumYeasts > 0 then
      begin
        Add(tabus);
        Add(heads + 'Gist' + heade);
        Add(rows + firsts + 'Hoeveelheid' + firste + firsts + 'Naam' +
          firste + firsts + 'Type' + firste + rowe);
        for i := 0 to NumYeasts - 1 do
        begin
          Y := Yeast[i];
          if (Y.StarterMade.Value) and (Y.StarterVolume1.Value > 0) then
          begin
            if Y.StarterVolume1.Value > 0 then
              s1 := Y.StarterVolume1.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume2.DisplayString;
            if Y.StarterVolume3.Value > 0 then
              s1:= s1 + ' + ' + Y.StarterVolume3.DisplayString;
            if Y.StarterVolume2.Value > 0 then
              s1:= s1 + ' getrapte starter'
            else
              s1:= s1 + ' starter';
          end
          else
            s1 := Y.AmountYeast.DisplayString;
          S1 := rows + datas + s1 + datae;
          S1 := S1 + datas + Y.Name.Value + ' (' + Y.ProductID.Value + ')' + datae;
          S1 := S1 + datas + YeastTypeDisplayNames[Y.YeastType] + datae + rowe;
          Add(S1);
        end;
        Add(tabue);
        Add('');
      end;

      if FStartTempPrimary.Value > 0 then
      begin
        Add(tabus);
        Add(heads + 'Vergisting' + heade);
        Add(rows + firsts + 'Kenmerk' + firste + firsts + 'Waarde' + firste + rowe);
        Add(rows + datas + 'Starttemp. vergisting' + datae + datas +
          FStartTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Max. temp. hoofdvergisting' + datae +
          datas + FMaxTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Eind temp. hoofdvergisting' + datae +
          datas + FEndTempPrimary.DisplayString + datae + rowe);
        Add(rows + datas + 'Eind SG hoofdvergisting' + datae + datas +
          FSGEndPrimary.DisplayString + datae + rowe);
        if FOG.Value > 1 then
          Add(rows + datas + 'Schijnbare vergistingsgraad' + datae +
              datas + RealToStrDec(100 * (FOG.Value - FSGEndPrimary.Value) / (FOG.Value - 1), 1) +
              '%' + datae + rowe);
        if FPrimaryAge.Value > 0 then
          Add(rows + datas + 'Start nagisting' + datae + datas +
              DateToStr(FDate.Value + FPrimaryAge.Value) + datae + rowe);
        Add(rows + datas + 'Temp. nagisting' + datae + datas +
            FSecondaryTemp.DisplayString + datae + rowe);
        if FSecondaryAge.Value > 0 then
          Add(rows + datas + 'Start lagering' + datae + datas +
              DateToStr(FDate.Value + FSecondaryAge.Value) + datae + rowe);
        Add(rows + datas + 'Temp. lagering' + datae + datas +
            FTertiaryTemp.DisplayString + datae + rowe);
        Add(rows + datas + 'Alcoholgehalte' + datae + datas +
          FABV.DisplayString + datae + rowe);
        Add(tabue);
        Add('');
      end;
      Add('</body>');
      Add('');

      SaveToFile(s);
    end;

    Result := True;
  finally
    FreeAndNIL(l);
  end;
end;

{============================ TBSettings ======================================}

constructor TBSettings.Create;
begin
  inherited;

  FFileName := BHFolder + 'settings.xml';

  FColorMethod := TBString.Create(NIL);
  FColorMethod.Value := 'Morey';
  FColorMethod.NodeLabel := 'COLOR_METHOD';

  FIBUMethod := TBString.Create(NIL);
  FIBUMethod.Value := 'Tinseth';
  FIBUMethod.NodeLabel := 'IBU_METHOD';

  FDataLocation := TBString.Create(NIL);
  FDataLocation.Value := BHFolder;
  FDataLocation.NodeLabel := 'DATA_LOCATION';

  FBrixCorrection := TBFloat.Create(NIL);
  FBrixCorrection.vUnit := none;
  FBrixCorrection.DisplayUnit := none;
  FBrixCorrection.MinValue := 1.0;
  FBrixCorrection.MaxValue := 1.05;
  FBrixCorrection.Value := 1.03;
  FBrixCorrection.Decimals := 3;
  FBrixCorrection.NodeLabel := 'BRIXCORRECTION';
  FBrixCorrection.DisplayLabel := '';

  FFWHFactor := TBFloat.Create(NIL);
  FFWHFactor.vUnit := none;
  FFWHFactor.DisplayUnit := none;
  FFWHFactor.MinValue := -50.0;
  FFWHFactor.MaxValue := 50.0;
  FFWHFactor.Value := 10;
  FFWHFactor.Decimals := 1;
  FFWHFactor.NodeLabel := 'FWH_FACTOR';
  FFWHFactor.DisplayLabel := '';

  FMashHopFactor := TBFloat.Create(NIL);
  FMashHopFactor.vUnit := none;
  FMashHopFactor.DisplayUnit := none;
  FMashHopFactor.MinValue := -50.0;
  FMashHopFactor.MaxValue := 50;
  FMashHopFactor.Value := -30;
  FMashHopFactor.Decimals := 1;
  FMashHopFactor.NodeLabel := 'MH_FACTOR';
  FMashHopFactor.DisplayLabel := '';

  FPelletFactor := TBFloat.Create(NIL);
  FPelletFactor.vUnit := none;
  FPelletFactor.DisplayUnit := none;
  FPelletFactor.MinValue := 0.0;
  FPelletFactor.MaxValue := 20;
  FPelletFactor.Value := 10;
  FPelletFactor.Decimals := 0;
  FPelletFactor.NodeLabel := 'PELLET_FACTOR';
  FPelletFactor.DisplayLabel := '';

  FPlugFactor := TBFloat.Create(NIL);
  FPlugFactor.vUnit := none;
  FPlugFactor.DisplayUnit := none;
  FPlugFactor.MinValue := 0.0;
  FPlugFactor.MaxValue := 20;
  FPlugFactor.Value := 2;
  FPlugFactor.Decimals := 0;
  FPlugFactor.NodeLabel := 'PLUG_FACTOR';
  FPlugFactor.DisplayLabel := '';

  FGrainAbsorption := TBFloat.Create(NIL);
  FGrainAbsorption.vUnit := none;
  FGrainAbsorption.DisplayUnit := none;
  FGrainAbsorption.MinValue := 0.5;
  FGrainAbsorption.MaxValue := 1.1;
  FGrainAbsorption.Value := 1.01;
  FGrainAbsorption.Decimals := 2;
  FGrainAbsorption.NodeLabel := 'GRAIN_ABSORPTION';
  FGrainAbsorption.DisplayLabel := '';

  FPlaySounds := TBBoolean.Create(NIL);
  FPlaySounds.Value := True;
  FPlaySounds.NodeLabel := 'PLAY_SOUNDS';

  FShowSplash := TBBoolean.Create(NIL);
  FShowSplash.Value := True;
  FShowSplash.NodeLabel := 'SHOW_SPLASH';

  FFTPSite := TBString.Create(NIL);
  FFTPSite.Value := '';
  FFTPSite.NodeLabel := 'FTP_SITE';

  FFTPDir := TBString.Create(NIL);
  FFTPDir.Value := '';
  FFTPDir.NodeLabel := 'FTP_DIR';

  FFTPUser := TBString.Create(NIL);
  FFTPUser.Value := '';
  FFTPUser.NodeLabel := 'FTP_USER';

  FFTPPasswd := TBString.Create(NIL);
  FFTPPasswd.Value := '';
  FFTPPasswd.NodeLabel := 'FTP_PASSWD';

  FRemoteLoc := TBString.Create(NIL);
  FRemoteLoc.Value := '';
  FRemoteLoc.NodeLabel := 'REMOTE_LOC';

  FUseCloud := TBBoolean.Create(NIL);
  FUseCloud.Value:= false;
  FUseCloud.NodeLabel:= 'USE_CLOUD';

  FCheckForNewVersion:= TBBoolean.Create(NIL);
  FCheckForNewVersion.Value:= TRUE;
  FCheckForNewVersion.NodeLabel:= 'CHECK_FOR_NEW_VERSION';

  FSGBitterness := TBInteger.Create(NIL);
  FSGBitterness.Value:= 0;
  FSGBitterness.MinValue:= 0;
  FSGBitterness.MaxValue:= 2;
  FSGBitterness.NodeLabel:= 'SG_BITTERNESS';

  FSGUnit:= TBString.Create(NIL);
  FSGUnit.Value:= UnitNames[SG];
  FSGUnit.NodeLabel:= 'SG_UNIT';

  FPercentages := TBBoolean.Create(NIL);
  FPercentages.Value := false;
  FPercentages.NodeLabel := 'PERCENTAGES';

  FScaleWithVolume := TBBoolean.Create(NIL);
  FScaleWithVolume.Value := false;
  FScaleWithVolume.NodeLabel := 'SCALE_WITH_VOLUME';

  FConfirmSave := TBBoolean.Create(NIL);
  FConfirmSave.Value:= TRUE;
  FConfirmSave.NodeLabel:= 'Confirm_SAVE';

  FShowOnlyInStock:= TBBoolean.Create(NIL);
  FShowOnlyInStock.Value:= false;
  FShowOnlyInStock.NodeLabel:= 'SHOW_ONLY_IN_STOCK';

  FAdjustAlfa:= TBBoolean.Create(NIL);
  FAdjustAlfa.Value:= false;
  FAdjustAlfa.NodeLabel:= 'ADJUST_ALFA';

  FHopStorageTemp := TBInteger.Create(NIL);
  FHopStorageTemp.Value:= 0;
  FHopStorageTemp.MinValue:= -30;
  FHopStorageTemp.MaxValue:= 30;
  FHopStorageTemp.NodeLabel:= 'HOP_STORAGE_TEMP';

  FHopStorageType := TBInteger.Create(NIL);
  FHopStorageType.Value:= 2;
  FHopStorageType.MinValue:= 0;
  FHopStorageType.MaxValue:= 2;
  FHopStorageType.NodeLabel:= 'HOP_STORAGE_TYPE';

  FShowPossibleWithStock:= TBBoolean.Create(NIL);
  FShowPossibleWithStock.Value:= false;
  FShowPossibleWithStock.NodeLabel:= 'SHOW_POSSIBLE_WITH_STOCK';

  FStyle:= TStyle.Create;

  FSortBrews:= TBInteger.Create(NIL);
  FSortBrews.Value:= 0;
  FSortBrews.MinValue:= 0;
  FSortBrews.MaxValue:= 2;
  FSortBrews.NodeLabel:= 'SORT_BREWS';

  FSortRecipes:= TBInteger.Create(NIL);
  FSortRecipes.Value:= 1;
  FSortRecipes.MinValue:= 0;
  FSortRecipes.MaxValue:= 2;
  FSortRecipes.NodeLabel:= 'SORT_RECIPES';

  FSortCloud:= TBInteger.Create(NIL);
  FSortCloud.Value:= 0;
  FSortCloud.MinValue:= 0;
  FSortCloud.MaxValue:= 2;
  FSortCloud.NodeLabel:= 'SORT_CLOUD';
end;

destructor TBSettings.Destroy;
begin
  FColorMethod.Free;
  FIBUMethod.Free;
  FDataLocation.Free;
  FBrixCorrection.Free;
  FFWHFactor.Free;
  FMashHopFactor.Free;
  FPelletFactor.Free;
  FPlugFactor.Free;
  FGrainAbsorption.Free;
  FPlaySounds.Free;
  FShowSplash.Free;
  FFTPDir.Free;
  FFTPUser.Free;
  FFTPPasswd.Free;
  FRemoteLoc.Free;
  FUseCloud.Free;
  FCheckForNewVersion.Free;
  FSGBitterness.Free;
  FSGUnit.Free;
  FPercentages.Free;
  FScaleWithVolume.Free;
  FConfirmSave.Free;
  FShowOnlyInStock.Free;
  FAdjustAlfa.Free;
  FHopStorageTemp.Free;
  FHopStorageType.Free;
  FShowPossibleWithStock.Free;
  FStyle.Free;
  FSortBrews.Free;
  FSortRecipes.Free;
  FSortCloud.Free;
  inherited;
end;

procedure TBSettings.Save;
var
  iDoc: TXMLDocument;
  iRootNode: TDOMNode;
begin
  try
    iDoc := TXMLDocument.Create;
    //    iDoc.Encoding:= 'ISO-8859-1';
    iRootNode := iDoc.CreateElement('SETTINGS');
    iDoc.Appendchild(iRootNode);
    FColorMethod.SaveXML(iDoc, iRootNode, false);
    FIBUMethod.SaveXML(iDoc, iRootNode, false);
    FDataLocation.SaveXML(iDoc, iRootNode, false);
    FBrixCorrection.SaveXML(iDoc, iRootNode, false);
    FFWHFactor.SaveXML(iDoc, iRootNode, false);
    FMashHopFactor.SaveXML(iDoc, iRootNode, false);
    FPelletFactor.SaveXML(iDoc, iRootNode, false);
    FPlugFactor.SaveXML(iDoc, iRootNode, false);
    FGrainAbsorption.SaveXML(iDoc, iRootNode, false);
    FPlaySounds.SaveXML(iDoc, iRootNode, false);
    FShowSplash.SaveXML(iDoc, iRootNode, false);
    FFTPSite.SaveXML(iDoc, iRootNode, false);
    FFTPDir.SaveXML(iDoc, iRootNode, false);
    FFTPUser.SaveXML(iDoc, iRootNode, false);
    FFTPPasswd.SaveXML(iDoc, iRootNode, false);
    FRemoteLoc.SaveXML(iDoc, iRootNode, false);
    FUseCloud.SaveXML(iDoc, iRootNode, false);
    FCheckForNewVersion.SaveXML(iDoc, iRootNode, false);
    FSGBitterness.SaveXML(iDoc, iRootNode, false);
    FSGUnit.SaveXML(iDoc, iRootNode, false);
    FPercentages.SaveXML(iDoc, iRootNode, false);
    FScaleWithVolume.SaveXML(iDoc, iRootNode, false);
    FConfirmSave.SaveXML(iDoc, iRootNode, false);
    FShowOnlyInStock.SaveXML(iDoc, iRootNode, false);
    FAdjustAlfa.SaveXML(iDoc, iRootNode, false);
    FHopStorageTemp.SaveXML(iDoc, iRootNode, false);
    FHopStorageType.SaveXML(iDoc, iRootNode, false);
    FShowPossibleWithStock.SaveXML(iDoc, iRootNode, false);
    FStyle.SaveXML(iDoc, iRootNode, false);
    FSortBrews.SaveXML(iDoc, iRootNode, false);
    FSortRecipes.SaveXML(iDoc, iRootNode, false);
    FSortCloud.SaveXML(iDoc, iRootNode, false);

    writeXMLFile(iDoc, FFileName);
  finally
    iDoc.Free;
  end;
end;

procedure TBSettings.Read;
var
  iDoc: TXMLDocument;
  iRootNode, iChildNode: TDOMNode;
  s : string;
begin
  iRootNode := nil;
  try
    if InitializeHD('settings.xml', BHFolder) then
    begin
      FFileName := BHFolder + 'settings.xml';
      ReadXMLFile(iDoc, FFileName);
      iRootNode := iDoc.FindNode('SETTINGS');
      if iRootNode <> nil then
      begin
        FColorMethod.ReadXML(iRootNode);
        FIBUMethod.ReadXML(iRootNode);
        FDataLocation.ReadXML(iRootNode);
        s:= FDataLocation.Value;
        if RightStr(s, 2) = '//' then
          Delete(s, Length(s)-1, 1);
        if RightStr(s, 2) = '\\' then
          Delete(s, Length(s)-1, 1);
        FDataLocation.Value:= s;
        FBrixCorrection.ReadXML(iRootNode);
        FFWHFactor.ReadXML(iRootNode);
        FMashHopFactor.ReadXML(iRootNode);
        FPelletFactor.ReadXML(iRootNode);
        FPlugFactor.ReadXML(iRootNode);
        FGrainAbsorption.ReadXML(iRootNode);
        FPlaySounds.ReadXML(iRootNode);
        FShowSplash.ReadXML(iRootNode);
        FFTPSite.ReadXML(iRootNode);
        FFTPDir.ReadXML(iRootNode);
        FFTPUser.ReadXML(iRootNode);
        FFTPPasswd.ReadXML(iRootNode);
        FRemoteLoc.ReadXML(iRootNode);
        FUseCloud.ReadXML(iRootNode);
        FCheckForNewVersion.ReadXML(iRootNode);
        FSGBitterness.ReadXML(iRootNode);
        FSGUnit.ReadXML(iRootNode);
        FPercentages.ReadXML(iRootNode);
        FScaleWithVolume.ReadXML(iRootNode);
        FConfirmSave.ReadXML(iRootNode);
        FShowOnlyInStock.ReadXML(iRootNode);
        FAdjustAlfa.ReadXML(iRootNode);
        FHopStorageTemp.ReadXML(iRootNode);
        FHopStorageType.ReadXML(iRootNode);
        FShowPossibleWithStock.ReadXML(iRootNode);
        iChildNode := iRootNode.FindNode('STYLE');
        if iChildNode <> nil then Style.ReadXML(iChildNode);
        FSortBrews.ReadXML(iRootNode);
        FSortRecipes.ReadXML(iRootNode);
        FSortCloud.ReadXML(iRootNode);
      end;
    end;
  finally
    iDoc.Free;
  end;
end;

{================================ STYLE =======================================}

constructor TStyle.Create;
begin
  Inherited;
  FFont := TFont.Create;
  FFont.Height:= DefaultFontHeight;
  FFont.Name:= 'default';
  FFont.Orientation:= 0;
  FFont.Pitch:= fpDefault;
  FFont.Quality:= fqDefault;
  FFont.Style:= [];
  FFont.Color:= clDefault;
  FControlColors := clDefault;
  FPanelColors := clDefault;
end;

destructor TStyle.Destroy;
begin
  FFont.Free;
  Inherited;
end;

procedure TStyle.Assign(St : TStyle);
begin
  FFont.Assign(St.Font);
  FFont.Height:= St.Font.Height;
  FControlColors:= St.ControlColors;
  FPanelColors:= St.PanelColors;
end;

procedure TStyle.SaveXML(Doc: TXMLDocument; iNode: TDomNode; bxml: boolean);
//the style is supposed to be stored as a separate field in the settings file
var iChild: TDOMNode;
    s : string;
    col : TColor;
    r, g, b : integer;
    rb, gb, bb : byte;
begin
  iChild := Doc.CreateElement('STYLE');
  iNode.AppendChild(iChild);
  s:= IntToStr(FFont.Height);
  AddNode(Doc, iChild, 'FONT_SIZE', s);
  s:= FFont.Name;
  AddNode(Doc, iChild, 'FONT_NAME', s);
  col:= FFont.Color;
  if FFont.Color = clDefault then
  begin
    r:= -1;
    b:= -1;
    g:= -1;
  end
  else
  begin
    RedGreenBlue(col, rb, gb, bb);
    r:= rb;
    g:= gb;
    b:= bb;
  end;
  s:= IntToStr(r);
  AddNode(Doc, iChild, 'FONT_RED', s);
  s:= IntToStr(g);
  AddNode(Doc, iChild, 'FONT_GREEN', s);
  s:= IntToStr(b);
  AddNode(Doc, iChild, 'FONT_BLUE', s);
  s := GetEnumName(TypeInfo(TFontPitch), integer(FFont.Pitch));
  AddNode(Doc, iChild, 'FONT_PITCH', s);
  s := GetEnumName(TypeInfo(TFontQuality), integer(FFont.Quality));
  AddNode(Doc, iChild, 'FONT_QUALITY', s);
  if fsBold in FFont.Style then s:= 'TRUE' else s:= 'FALSE';
  AddNode(doc, iChild, 'FONT_STYLE_BOLD', s);
  if fsItalic in FFont.Style then s:= 'TRUE' else s:= 'FALSE';
  AddNode(doc, iChild, 'FONT_STYLE_ITALIC', s);
  if fsStrikeOut in FFont.Style then s:= 'TRUE' else s:= 'FALSE';
  AddNode(doc, iChild, 'FONT_STYLE_STRIKEOUT', s);
  if fsUnderline in FFont.Style then s:= 'TRUE' else s:= 'FALSE';
  AddNode(doc, iChild, 'FONT_STYLE_UNDERLINE', s);

  if FControlColors = clDefault then
  begin
    r:= -1;
    b:= -1;
    g:= -1;
  end
  else
  begin
    RedGreenBlue(FControlColors, rb, gb, bb);
    r:= rb;
    g:= gb;
    b:= bb;
  end;
  s:= IntToStr(r);
  AddNode(Doc, iChild, 'CONTROL_RED', s);
  s:= IntToStr(g);
  AddNode(Doc, iChild, 'CONTROL_GREEN', s);
  s:= IntToStr(b);
  AddNode(Doc, iChild, 'CONTROL_BLUE', s);

  if FPanelColors = clDefault then
  begin
    r:= -1;
    b:= -1;
    g:= -1;
  end
  else
  begin
    RedGreenBlue(FPanelColors, rb, gb, bb);
    r:= rb;
    g:= gb;
    b:= bb;
  end;
  s:= IntToStr(r);
  AddNode(Doc, iChild, 'PANEL_RED', s);
  s:= IntToStr(g);
  AddNode(Doc, iChild, 'PANEL_GREEN', s);
  s:= IntToStr(b);
  AddNode(Doc, iChild, 'PANEL_BLUE', s);
end;

procedure TStyle.ReadXML(iNode: TDOMNode);
var s : string;
    i : integer;
    r, g, b : integer;
    rb, gb, bb : byte;
begin
  s := GetNodeString(iNode, 'FONT_SIZE');
  i:= StrToInt(s);
  FFont.Height:= i;
  s := GetNodeString(iNode, 'FONT_NAME');
  FFont.Name:= s;
  s:= GetNodeString(iNode, 'FONT_RED');
  r:= StrToInt(s);
  s:= GetNodeString(iNode, 'FONT_GREEN');
  g:= StrToInt(s);
  s:= GetNodeString(iNode, 'FONT_BLUE');
  b:= StrToInt(s);
  if r = -1 then FFont.Color:= clDefault
  else
  begin
    rb:= byte(r);
    gb:= byte(g);
    bb:= byte(b);
    FFont.Color:= RGBToColor(rb, gb, bb);
  end;
  s:= GetNodeString(iNode, 'FONT_PITCH');
  FFont.Pitch:= TFontPitch(GetEnumValue(TypeInfo(TFontPitch),s));
  s:= GetNodeString(iNode, 'FONT_QUALITY');
  FFont.Quality:= TFontQuality(GetEnumValue(TypeInfo(TFontQuality),s));
  FFont.Style:= [];
  s:= GetNodeString(iNode, 'FONT_STYLE_BOLD');
  if s = 'TRUE' then FFont.Style:= FFont.Style + [fsBold];
  s:= GetNodeString(iNode, 'FONT_STYLE_ITALIC');
  if s = 'TRUE' then FFont.Style:= FFont.Style + [fsItalic];
  s:= GetNodeString(iNode, 'FONT_STYLE_STRIKEOUT');
  if s = 'TRUE' then FFont.Style:= FFont.Style + [fsStrikeOut];
  s:= GetNodeString(iNode, 'FONT_STYLE_UNDERLINE');
  if s = 'TRUE' then FFont.Style:= FFont.Style + [fsUnderline];

  s:= GetNodeString(iNode, 'CONTROL_RED');
  r:= StrToInt(s);
  s:= GetNodeString(iNode, 'CONTROL_GREEN');
  g:= StrToInt(s);
  s:= GetNodeString(iNode, 'CONTROL_BLUE');
  b:= StrToInt(s);
  if r = -1 then FControlColors:= clDefault
  else
  begin
    rb:= byte(r);
    gb:= byte(g);
    bb:= byte(b);
    FControlColors:= RGBToColor(rb, gb, bb);
  end;

  s:= GetNodeString(iNode, 'PANEL_RED');
  r:= StrToInt(s);
  s:= GetNodeString(iNode, 'PANEL_GREEN');
  g:= StrToInt(s);
  s:= GetNodeString(iNode, 'PANEL_BLUE');
  b:= StrToInt(s);
  if r = -1 then FPanelColors:= clDefault
  else
  begin
    rb:= byte(r);
    gb:= byte(g);
    bb:= byte(b);
    FPanelColors:= RGBToColor(rb, gb, bb);
  end;
end;

procedure TStyle.SetStyle(Ctrl : TControl);
begin
  Ctrl.Font.Height:= FFont.Height;
  Ctrl.Font.Name:= FFont.Name;
  if FFont.Color = clDefault then Ctrl.Font.Color:= clDefault
  else Ctrl.Font.Color:= FFont.Color;
  if FPanelColors = clDefault then Ctrl.Color:= clDefault
  else Ctrl.Color:= FPanelColors;
  Ctrl.Font.Style:= FFont.Style;

  if Ctrl is TTreeView then TTreeView(Ctrl).BackgroundColor:= FPanelColors;
  if (Ctrl is TLabel) and (FPanelColors = clDefault) then
    TLabel(Ctrl).Color:= clNone;
end;

procedure TStyle.SetWinControlsStyle(WC : TWinControl);
var i : integer;
begin
  if WC <> NIL then
  begin
    WC.Font.Height:= FFont.Height;
    WC.Font.Color:= FFont.Color;
    WC.Font.Name:= FFont.Name;
    WC.Font.Style:= FFont.Style;
    WC.Color:= FPanelColors;
    for i:= 0 to WC.ControlCount - 1 do
    begin
      if WC.Controls[i] is TWinControl then
        SetWinControlsStyle(TWinControl(WC.Controls[i]))
      else
        SetStyle(WC.Controls[i]);
    end;
  end;
end;

procedure TStyle.SetControlsStyle(Frm : TForm);
var i : integer;
begin
  if Frm <> NIL then
  begin
    Frm.Font.Height:= FFont.Height;
    Frm.Font.Color:= FFont.Color;
    Frm.Font.Name:= FFont.Name;
    Frm.Font.Style:= FFont.Style;
    Frm.Color:= FPanelColors;
    for i:= 0 to Frm.ControlCount - 1 do
    begin
      if Frm.Controls[i] is TWinControl then
        SetWinControlsStyle(TWinControl(Frm.Controls[i]))
      else
        SetStyle(Frm.Controls[i]);
    end;
  end;
end;

end.

