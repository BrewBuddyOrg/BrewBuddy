unit FrMain; 

//{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TAMultiSeries, TASeries, TATools,
  TAIntervalSources, TASources, TATransformations, {PrintersDlgs, }SpinEx, Forms,
  Controls, Graphics, Dialogs, Menus, ComCtrls, ExtCtrls, ActnList, StdCtrls,
  StrUtils, Buttons, Grids, Spin, ExtDlgs, EditBtn, Printers, Data,
  HulpFuncties, ExpandPanels, UniqueInstance,
  containers, rcstrngs, LCLIntF,
  {laz2_XMLRead, laz2_XMLwrite, }
  DOM, XMLWrite, {XMLRead, }PositieInterval
  , Types;{, PrintersDlgs, TAGraph, TASeries,
  TASources, TAChartUtils, TAChartAxis, TATransformations, TATools,
  TAMultiSeries, TAIntervalSources,
  , timeedit, DOM, XMLRead, XMLWrite, LCLIntf,
  DefaultTranslator;  }

type

  { TfrmMain }

  TIngrBoil = record
    Ingredient : TIngredient;
    Time1, Time2 : TTime;
    Warning1Shown, Warning2Shown : boolean;
  end;


  TfrmMain = class(TForm)
    aFullScreen: TAction;
    alMain: TActionList;
    bbAddGrain: TBitBtn;
    bbAddHop: TBitBtn;
    bbAddMisc: TBitBtn;
    bbAddYeast: TBitBtn;
    bbCookingMethod: TBitBtn;
    bbInventory: TBitBtn;
    bbNewBrew: TBitBtn;
    bbNewRecipe: TBitBtn;
    bbPostFermentation: TBitBtn;
    bbPropagation: TBitBtn;
    bbRemove: TBitBtn;
    bbRemoveBrew: TBitBtn;
    bbRemoveRecipe: TBitBtn;
    bbRemoveCloudRecipe: TBitBtn;
    bbSettings: TBitBtn;
    bbtnHopStorage: TBitBtn;
    bbWaterWizard: TBitBtn;
    cbBrewsSort: TComboBox;
    cbPercentage: TCheckBox;
    cbRecipesSort: TComboBox;
    cbColorMethod: TComboBox;
    cbIBUMethod: TComboBox;
    cbCloudSort: TComboBox;
    cbShowSplash: TCheckBox;
    cbPlaySounds: TCheckBox;
    cbAdjustAlpha: TCheckBox;
    eABV2: TEdit;
    eABVest: TEdit;
    eAmCellsNeeded: TEdit;
    eAmCells2: TEdit;
    eBUGU: TEdit;
    eCalories: TEdit;
    eColor2: TEdit;
    eCosts: TEdit;
    eEfficiencyMash: TEdit;
    eFGest: TEdit;
    epRight: TExpandPanels;
    eSearchBrews: TEdit;
    eSearchRecipes: TEdit;
    eSGCorr: TEdit;
    eSVG1: TEdit;
    fseBoilTime: TFloatSpinEdit;
    fseBrix: TFloatSpinEdit;
    fseBrix2: TFloatSpinEdit;
    fseEfficiency: TFloatSpinEdit;
    fseGrid: TFloatSpinEdit;
    fseIBU: TFloatSpinEdit;
    fseOG: TFloatSpinEdit;
    fseSGendmash: TFloatSpinEdit;
    fsePlato: TFloatSpinEdit;
    fsePlato2: TFloatSpinEdit;
    fseSG: TFloatSpinEdit;
    fseSG2: TFloatSpinEdit;
    fseSG3: TFloatSpinEdit;
    fseSG4: TFloatSpinEdit;
    fseSGAfter: TFloatSpinEdit;
    fseSGTemp: TFloatSpinEdit;
    fseStarterVolume2: TFloatSpinEdit;
    fseStarterVolume3: TFloatSpinEdit;
    fseSugar: TFloatSpinEdit;
    fseVolume: TFloatSpinEdit;
    fseVolumeAfter: TFloatSpinEdit;
    fseWater: TFloatSpinEdit;
    gbIngredients: TGroupBox;
    hcIngredients: THeaderControl;
    Label10: TLabel;
    Label11: TLabel;
    Label119: TLabel;
    Label12: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label13: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label14: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label150: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label30: TLabel;
    Label59: TLabel;
    Label62: TLabel;
    Label63: TLabel;
    Label9: TLabel;
    lABV: TLabel;
    lAfterBoil1: TLabel;
    lAfterBoil2: TLabel;
    lBoilTime: TLabel;
    lBUGU: TLabel;
    lEfficiency: TLabel;
    lEstOG: TLabel;
    lIBU: TLabel;
    lLastRunningSG: TLabel;
    Label140: TLabel;
    lSGendmash: TLabel;
    lMessage: TLabel;
    Label156: TLabel;
    Label19: TLabel;
    ilRecipes: TImageList;
    ilDefault: TImageList;
    Label1: TLabel;
    Label21: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    lStarterVolume2: TLabel;
    lStarterVolume3: TLabel;
    lSVG1: TLabel;
    lTemp: TLabel;
    lTopUpWater1: TLabel;
    miCheckPrint: TMenuItem;
    miCheckWindow: TMenuItem;
    miInventoryClipboard: TMenuItem;
    miInventoryExport: TMenuItem;
    miInventoryPrint: TMenuItem;
    mPredictions: TMemo;
    MenuItem10: TMenuItem;
    MenuItem9: TMenuItem;
    miFindParentBrew: TMenuItem;
    miCloudToRecipes: TMenuItem;
    miFindParentRecipe: TMenuItem;
    miRecipesCopyHTML1: TMenuItem;
    miRecipesCopyToClipboardForum1: TMenuItem;
    miCloudDelete: TMenuItem;
    miCloudToBrews: TMenuItem;
    mroExtra: TMyRollOut;
    mroHydrometerCorrection: TMyRollOut;
    mroPredictions: TMyRollOut;
    mroSG: TMyRollOut;
    mroWaterSugar: TMyRollOut;
    opdLogo: TOpenPictureDialog;
    pCloudButtons: TPanel;
    pbProgress: TProgressBar;
    pmCloud: TPopupMenu;
    pmStock: TPopupMenu;
    pmChecklist: TPopupMenu;
    pSearchBrews: TPanel;
    pSearchRecipes: TPanel;
    pSettings1: TPanel;
    pcMenubuttons: TPageControl;
    pcRecipes: TPageControl;
    pMain: TPanel;
    pRecipesButtons: TPanel;
    pRecipesButtons1: TPanel;
    pRight: TPanel;
    pRecipes: TPanel;
    SaveDialog1: TSaveDialog;
    sbGristWizard: TSpeedButton;
    sbHopWizard: TSpeedButton;
    sbSearchRecipesDelete: TSpeedButton;
    sddBackup: TSelectDirectoryDialog;
    sbSearchBrewsDelete: TSpeedButton;
    sgIngredients: TStringGrid;
    tbFermChart: TToolButton;
    tbHistogram: TToolButton;
    tbHopChart: TToolButton;
    tbWaterChart: TToolButton;
    tbYeastChart: TToolButton;
    ToolButton11: TToolButton;
    tbHelp: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    tvCloud: TTreeView;
    tsCloud: TTabSheet;
    tBoilTimer: TTimer;
    tCTimer: TTimer;
    tMashTimer: TTimer;
    tbRestore: TToolButton;
    tbRestoreOriginal: TToolButton;
    tbChecklist: TToolButton;
    ToolButton8: TToolButton;
    tbBackup: TToolButton;
    ToolButton9: TToolButton;
    tsOptions: TTabSheet;
    tbYeasts: TToolButton;
    tbMisc: TToolButton;
    tbWaters: TToolButton;
    ToolButton3: TToolButton;
    tbEquipment: TToolButton;
    ToolButton4: TToolButton;
    tbBeerstyles: TToolButton;
    ToolButton5: TToolButton;
    tbMash: TToolButton;
    tbFile: TToolBar;
    tbImport: TToolButton;
    tbExport: TToolButton;
    tbSep2: TToolButton;
    tbExit: TToolButton;
    ToolButton2: TToolButton;
    tbSave: TToolButton;
    tbPrintPreview: TToolButton;
    ToolButton6: TToolButton;
    tsFile: TTabSheet;
    tsDatabases: TTabSheet;
    tbFermentablesp: TToolButton;
    tbHops: TToolButton;
    tbDatabases: TToolBar;
    tvRecipes: TTreeView;
    tsRecipes: TTabSheet;
    tsBrews: TTabSheet;
    tvBrews: TTreeView;
    piGravity : TPosInterval;
    piBitterness : TPosInterval;
    piBUGU : TPosInterval;
    piABV : TPosInterval;
    piColor : TPosInterval;
    piABV2 : TPosInterval;
    piCarbBottles : TPosInterval;
    piCarbKegs : TPosInterval;
    rxteStartTime : TTimeEdit;
    rxteEndTime : TTimeEdit;
    tbCopyClipboard: TToolButton;
    tbCopyHTML: TToolButton;
    pmBrews: TPopupMenu;
    miBrewsImport: TMenuItem;
    miBrewsExport: TMenuItem;
    miBrewsToRecipe: TMenuItem;
    miBrewsNew: TMenuItem;
    miBrewsDelete: TMenuItem;
    miBrewsCopyToClipboardForum: TMenuItem;
    miBrewsCopyHTML: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    pmRecipes: TPopupMenu;
    miRecipesImport: TMenuItem;
    miRecipesExport: TMenuItem;
    MenuItem4: TMenuItem;
    miRecipesCopyToClipboardForum: TMenuItem;
    miRecipesCopyHTML: TMenuItem;
    MenuItem5: TMenuItem;
    miRecipesToBrews: TMenuItem;
    MenuItem6: TMenuItem;
    miRecipesNew: TMenuItem;
    miRecipesDelete: TMenuItem;
    dticsX: TDateTimeIntervalChartSource;
    pcAnalysis: TPageControl;
    tsFermentables: TTabSheet;
    chAFerm: TChart;
    dbawFermentables: TBoxAndWhiskerSeries;
    cbsFermentables: TBarSeries;
    lcsFermBars: TListChartSource;
    tsHops: TTabSheet;
    pAnalysisHops: TPanel;
    rgBitterhop: TRadioButton;
    rgAromahop: TRadioButton;
    rgDryhop: TRadioButton;
    chAnalyseHops: TChart;
    lcsHop: TListChartSource;
    bsHopsperc: TBarSeries;
    bwsHops: TBoxAndWhiskerSeries;
    lcsHopBW: TListChartSource;
    catHopLeft: TChartAxisTransformations;
    latHopLeft: TLinearAxisTransform;
    asatHopLeft: TAutoScaleAxisTransform;
    catHopRight: TChartAxisTransformations;
    latHopRight: TLinearAxisTransform;
    tsYeast: TTabSheet;
    chAnalyseYeast: TChart;
    lcsYeast: TListChartSource;
    bsYeast: TBarSeries;
    tsMiscs: TTabSheet;
    chAnalyseMiscs: TChart;
    lcsMisc: TListChartSource;
    lcsMiscBW: TListChartSource;
    catMiscLeft: TChartAxisTransformations;
    latMiscLeft: TLinearAxisTransform;
    asatMiscLeft: TAutoScaleAxisTransform;
    catMiscRight: TChartAxisTransformations;
    latMiscRight: TLinearAxisTransform;
    bsMisc: TBarSeries;
    bwsMisc: TBoxAndWhiskerSeries;
    tsAnalysisCommon: TTabSheet;
    chCommon: TChart;
    lcsCommon: TListChartSource;
    bwsCommon: TBoxAndWhiskerSeries;
    lcsSG: TListChartSource;
    Bevel1: TBevel;
    pSettings2: TPanel;
    Bevel2: TBevel;
    bbDatabaseLocation: TBitBtn;
    Panel1: TPanel;
    bbLogo: TBitBtn;
    iLogo: TImage;
    ToolButton7: TToolButton;
    tbInventoryList: TToolButton;
    MenuItem7: TMenuItem;
    miDivideBrew: TMenuItem;
    ToolButton1: TToolButton;
    tbInfo: TToolButton;
    tbSynchronize: TToolButton;
    tbBrewsList: TToolButton;
    catSG: TChartAxisTransformations;
    catSGLinearAxisTransform1: TLinearAxisTransform;
    pcRecipe: TPageControl;
    tsRecipe: TTabSheet;
    gbAlgemeen: TGroupBox;
    Label2: TLabel;
    eNrRecipe: TEdit;
    Label3: TLabel;
    eName: TEdit;
    Label5: TLabel;
    cbType: TComboBox;
    Label4: TLabel;
    cbBeerStyle: TComboBox;
    Label6: TLabel;
    cbEquipment: TComboBox;
    Label15: TLabel;
    fseBatchSize: TFloatSpinEdit;
    lBatchSize: TLabel;
    cbScaleVolume: TCheckBox;
    cbLocked: TCheckBox;
    gbVisual: TGroupBox;
    tsWater: TTabSheet;
    gbMashing: TGroupBox;
    sgMashSteps: TStringGrid;
    bbAddStep: TBitBtn;
    bbDeleteStep: TBitBtn;
    cbMash: TComboBox;
    Label22: TLabel;
    hcMash: THeaderControl;
    Label23: TLabel;
    seGrainTemp: TSpinEdit;
    seTunTemp: TSpinEdit;
    Label24: TLabel;
    lGrainTemp: TLabel;
    lTunTemp: TLabel;
    Label25: TLabel;
    fseInfuseAmount: TFloatSpinEdit;
    lInfuseAmount: TLabel;
    cbTunTemp: TCheckBox;
    bbWaterAdjustment: TBitBtn;
    gbWater: TGroupBox;
    Label26: TLabel;
    lMashWater: TLabel;
    Label27: TLabel;
    lSpargeWater: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    lGrainAbsorption: TLabel;
    Label32: TLabel;
    fseSpargeDeadspace: TFloatSpinEdit;
    lSpargeDeadSpace: TLabel;
    Label34: TLabel;
    lBoilSize: TLabel;
    Label37: TLabel;
    lEvap: TLabel;
    Label38: TLabel;
    lAfterBoil: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    fseChillerLoss: TFloatSpinEdit;
    lChillerLoss: TLabel;
    Label43: TLabel;
    fseTopUpWater: TFloatSpinEdit;
    Label44: TLabel;
    lTopUpWater: TLabel;
    eMashWater: TEdit;
    eGrainAbsorption: TEdit;
    eBoilSize: TEdit;
    eAfterBoil: TEdit;
    eSpMa: TEdit;
    eToFermenter: TEdit;
    eVolumeFermenter: TEdit;
    eSpargeWater: TEdit;
    Label151: TLabel;
    eAfterCooling: TEdit;
    fseEvaporation: TFloatSpinEdit;
    tsBrewday: TTabSheet;
    gbMeasMash: TGroupBox;
    Label50: TLabel;
    fseMashpH: TFloatSpinEdit;
    gbMeasBoil: TGroupBox;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    lSGb: TLabel;
    Label60: TLabel;
    fseBoilpHS: TFloatSpinEdit;
    fseBoilpHE: TFloatSpinEdit;
    fseBoilSGS: TFloatSpinEdit;
    fseBoilSGE: TFloatSpinEdit;
    eBoilSGSP: TEdit;
    fseBoilVolumeS: TFloatSpinEdit;
    fseBoilVolumeE: TFloatSpinEdit;
    eBoilVolumeSP: TEdit;
    Label61: TLabel;
    eBoilSGEP: TEdit;
    eBoilVolumeEP: TEdit;
    Label20: TLabel;
    eEfficiencyS: TEdit;
    eEfficiencyE: TEdit;
    eEfficiencyP: TEdit;
    gbMeasSparge: TGroupBox;
    Label51: TLabel;
    fseSpargepH: TFloatSpinEdit;
    Label52: TLabel;
    fseLastRunningpH: TFloatSpinEdit;
    Label53: TLabel;
    fseSpargeTemp: TFloatSpinEdit;
    Label54: TLabel;
    fseLastRunningSG: TFloatSpinEdit;
    lSpargeTemp: TLabel;
    gbVolumes: TGroupBox;
    Label157: TLabel;
    Label158: TLabel;
    fseTunCm: TFloatSpinEdit;
    fseLauterCm: TFloatSpinEdit;
    fseKettleCm: TFloatSpinEdit;
    Label159: TLabel;
    Label160: TLabel;
    Label161: TLabel;
    fseTunVolume: TFloatSpinEdit;
    fseLauterVolume: TFloatSpinEdit;
    fseKettleVolume: TFloatSpinEdit;
    gbCooling: TGroupBox;
    Label64: TLabel;
    seWhirlpoolTime: TSpinEdit;
    Label65: TLabel;
    Label66: TLabel;
    seCoolingTime: TSpinEdit;
    Label67: TLabel;
    Label69: TLabel;
    cbCoolingMethod: TComboBox;
    Label35: TLabel;
    fseVolToFermenter: TFloatSpinEdit;
    lVolToFermenter: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Label154: TLabel;
    fseTimeAeration: TFloatSpinEdit;
    fseAerationFlowRate: TFloatSpinEdit;
    cbAerationType: TComboBox;
    lAerationTime: TLabel;
    lAerationFlowRate: TLabel;
    Label155: TLabel;
    fseCoolingTo: TFloatSpinEdit;
    lCoolingTo: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label166: TLabel;
    eOGFermenter: TEdit;
    eIBUFermenter: TEdit;
    eColorFermenter: TEdit;
    Label167: TLabel;
    fseTopUpWater2: TFloatSpinEdit;
    lTopUpWater2: TLabel;
    gbTimers: TGroupBox;
    bbStartMash: TBitBtn;
    eMashTimer: TEdit;
    bbStartBoil: TBitBtn;
    eBoilTimer: TEdit;
    bbStartTimer: TBitBtn;
    bbResetTimers: TBitBtn;
    eTimer: TEdit;
    Label46: TLabel;
    deBrewDate: TDateEdit;
    Label68: TLabel;
    Label70: TLabel;
    tsFermentation: TTabSheet;
    gbYeast: TGroupBox;
    Label71: TLabel;
    cbYeastAddedAs: TComboBox;
    cbStarterMade: TCheckBox;
    Label72: TLabel;
    cbStarterType: TComboBox;
    lTimeAerated: TLabel;
    fseStarterTimeAerated: TFloatSpinEdit;
    lStarterTimeAerated: TLabel;
    Label74: TLabel;
    fseSGStarter: TFloatSpinEdit;
    fseTempStarter: TFloatSpinEdit;
    Label75: TLabel;
    lTempStarter: TLabel;
    Label77: TLabel;
    lStarterVolume1: TLabel;
    fseStarterVolume1: TFloatSpinEdit;
    Label78: TLabel;
    fseAmountYeast: TFloatSpinEdit;
    lAmountYeast: TLabel;
    Label79: TLabel;
    eAmCells: TEdit;
    gbTemperatures: TGroupBox;
    pcMeasurements: TPageControl;
    tsMeasSimple: TTabSheet;
    Label80: TLabel;
    Label81: TLabel;
    Label82: TLabel;
    Label83: TLabel;
    Label84: TLabel;
    Label85: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    fseStartTempPrimary: TFloatSpinEdit;
    lStartTempPrimary: TLabel;
    fseMaxTempPrimary: TFloatSpinEdit;
    lMaxTempPrimary: TLabel;
    fseEndTempPrimary: TFloatSpinEdit;
    lEndTempPrimary: TLabel;
    fseSGEndPrimary: TFloatSpinEdit;
    lSGEndPrimary: TLabel;
    fseSecondaryTemp: TFloatSpinEdit;
    lSecondaryTemp: TLabel;
    fseTertiaryTemp: TFloatSpinEdit;
    lTertiaryTemp: TLabel;
    fseFG: TFloatSpinEdit;
    lFG: TLabel;
    eABV: TEdit;
    Label88: TLabel;
    eFGpredicted: TEdit;
    Label116: TLabel;
    eAAEndPrimary: TEdit;
    Label117: TLabel;
    eAA: TEdit;
    Label118: TLabel;
    eRA: TEdit;
    Label47: TLabel;
    deTransferDate: TDateEdit;
    Label48: TLabel;
    deLagerDate: TDateEdit;
    tsMeasExt: TTabSheet;
    cbTemp1: TCheckBox;
    cbTemp2: TCheckBox;
    cbSetpoint: TCheckBox;
    cbCO2: TCheckBox;
    cbSG: TCheckBox;
    cbCooling: TCheckBox;
    cbHeating: TCheckBox;
    cbCoolPower: TCheckBox;
    bbMeasurements: TBitBtn;
    chTControl: TChart;
    lsEnvTemp: TLineSeries;
    lsBeerTemp: TLineSeries;
    lsSetTemp: TLineSeries;
    lsCO2: TLineSeries;
    lsCooling: TLineSeries;
    lsHeating: TLineSeries;
    lsCoolingPower: TLineSeries;
    lsSG: TLineSeries;
    tsPackaging: TTabSheet;
    gbBottleDates: TGroupBox;
    Label49: TLabel;
    deBottleDate: TDateEdit;
    Label89: TLabel;
    eCO2style: TEdit;
    gbBottles: TGroupBox;
    Label90: TLabel;
    fseVolumeBottles: TFloatSpinEdit;
    lVolumeBottles: TLabel;
    Label91: TLabel;
    fseCarbonation: TFloatSpinEdit;
    lCarbonation: TLabel;
    Label92: TLabel;
    fseAmountPrimingBottles: TFloatSpinEdit;
    lAmountPrimingBottles: TLabel;
    Label93: TLabel;
    lTotAmBottles: TLabel;
    Label94: TLabel;
    eABVBottles: TEdit;
    Label101: TLabel;
    fseCarbonationTemp: TFloatSpinEdit;
    lCarbonationTemp: TLabel;
    Label103: TLabel;
    cbPrimingSugarBottles: TComboBox;
    eTotAmBottles: TEdit;
    gbKegs: TGroupBox;
    Label95: TLabel;
    fseVolumeKegs: TFloatSpinEdit;
    lVolumeKegs: TLabel;
    lCarbonationKegs: TLabel;
    fseCarbonationKegs: TFloatSpinEdit;
    Label96: TLabel;
    Label97: TLabel;
    fseAmountPrimingKegs: TFloatSpinEdit;
    lAmountPrimingKegs: TLabel;
    lTotAmKegs: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    eABVKegs: TEdit;
    cbForcedCarbonation: TCheckBox;
    Label100: TLabel;
    fsePressureKegs: TFloatSpinEdit;
    lPressureKegs: TLabel;
    Label102: TLabel;
    fseCarbonationTempKegs: TFloatSpinEdit;
    lCarbonationTempKegs: TLabel;
    Label104: TLabel;
    cbPrimingSugarKegs: TComboBox;
    eTotAmKegs: TEdit;
    gbTasting: TGroupBox;
    Label105: TLabel;
    deTasteDate: TDateEdit;
    Label106: TLabel;
    eColor: TEdit;
    Label107: TLabel;
    eTransparency: TEdit;
    Label108: TLabel;
    eHead: TEdit;
    Label109: TLabel;
    eAroma: TEdit;
    Label110: TLabel;
    eTaste: TEdit;
    Label111: TLabel;
    eAftertaste: TEdit;
    Label112: TLabel;
    fseAgeTemp: TFloatSpinEdit;
    lAgeTemp: TLabel;
    Label113: TLabel;
    eMouthfeel: TEdit;
    Label114: TLabel;
    eTasteNotes: TEdit;
    Label115: TLabel;
    fseTastingRate: TFloatSpinEdit;
    tsNotes: TTabSheet;
    gbNotes: TGroupBox;
    mNotes: TMemo;
    gbBrewers: TGroupBox;
    Label45: TLabel;
    eBrewer: TEdit;
    Label162: TLabel;
    eAssistantBrewer: TEdit;
    bbHideTools: TBitBtn;
    bbShowTools: TBitBtn;
    tsAnalysis: TTabSheet;
    ToolBar1: TToolBar;
    tbTrainNN: TToolButton;
    ToolButton10: TToolButton;
    tbChart: TToolButton;
    uiBrouwHulp: TUniqueInstance;
    procedure aFullScreenExecute(Sender: TObject);
    procedure bbChecklistClick(Sender: TObject);
    procedure bbPropagationClick(Sender: TObject);
    //procedure bbRemoveCloudRecipeClick(Sender: TObject);
    procedure bbSettingsClick(Sender: TObject);
    procedure btnShowDirDialogClick(Sender: TObject);
    procedure bbtnHopStorageClick(Sender: TObject);
    procedure cbAdjustAlphaChange(Sender: TObject);
    //procedure cbCloudSortChange(Sender: TObject);
    procedure cbCoolingMethodChange(Sender: TObject);
    procedure cbPlaySoundsChange(Sender: TObject);
    procedure cbShowSplashChange(Sender: TObject);
    procedure cbStarterMadeChange(Sender: TObject);
    procedure cbStarterTypeChange(Sender: TObject);
    procedure cbYeastAddedAsChange(Sender: TObject);
    procedure eAssistantBrewerChange(Sender: TObject);
    procedure eBrewerChange(Sender: TObject);
    procedure eSearchBrewsChange(Sender: TObject);
    procedure eSearchRecipesChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure fseBrix2Change(Sender: TObject);
    procedure gbIngredientsClick(Sender: TObject);
    procedure bbAddGrainClick(Sender: TObject);
    procedure bbAddHopClick(Sender: TObject);
    procedure bbAddMiscClick(Sender: TObject);
    procedure bbAddStepClick(Sender: TObject);
    procedure bbAddYeastClick(Sender: TObject);
    procedure bbDeleteStepClick(Sender: TObject);
    procedure bbLogoClick(Sender: TObject);
    procedure bbNewBrewClick(Sender: TObject);
    procedure bbNewRecipeClick(Sender: TObject);
    procedure bbRemoveBrewClick(Sender: TObject);
    procedure bbRemoveClick(Sender: TObject);
    procedure bbRemoveRecipeClick(Sender: TObject);
    procedure bbStartBoilClick(Sender: TObject);
    procedure bbStartMashClick(Sender: TObject);
    procedure bbWaterAdjustmentClick(Sender: TObject);
    procedure bbInventoryClick(Sender: TObject);
    procedure cbBeerStyleChange(Sender: TObject);
    procedure cbBrewsSortChange(Sender: TObject);
    procedure cbColorMethodChange(Sender: TObject);
    procedure cbEquipmentChange(Sender: TObject);
    procedure cbIBUMethodChange(Sender: TObject);
    procedure cbMashChange(Sender: TObject);
    procedure cbPercentageChange(Sender: TObject);
    procedure cbScaleVolumeChange(Sender: TObject);
    procedure cbTunTempChange(Sender: TObject);
    procedure cbTypeChange(Sender: TObject);
    procedure deBottleDateChange(Sender: TObject);
    procedure deBrewDateChange(Sender: TObject);
    procedure deLagerDateChange(Sender: TObject);
    procedure deTransferDateChange(Sender: TObject);
    procedure eNameChange(Sender: TObject);
    procedure eNrRecipeChange(Sender: TObject);
    procedure fseAmountYeastChange(Sender: TObject);
    procedure fseBatchSizeChange(Sender: TObject);
    procedure fseBoilpHEChange(Sender: TObject);
    procedure fseBoilpHSChange(Sender: TObject);
    procedure fseBoilSGEChange(Sender: TObject);
    procedure fseBoilSGSChange(Sender: TObject);
    procedure fseBoilTimeChange(Sender: TObject);
    procedure fseBoilVolumeEChange(Sender: TObject);
    procedure fseBoilVolumeSChange(Sender: TObject);
    procedure fseChillerLossChange(Sender: TObject);
    procedure fseEfficiencyChange(Sender: TObject);
    procedure fseGridChange(Sender: TObject);
    procedure fseGridEditingDone(Sender: TObject);
    procedure fseIBUChange(Sender: TObject);
    procedure fseInfuseAmountChange(Sender: TObject);
    procedure fseKettleCmChange(Sender: TObject);
    procedure fseKettleVolumeChange(Sender: TObject);
    procedure fseLauterCmChange(Sender: TObject);
    procedure fseLauterVolumeChange(Sender: TObject);
    procedure fseOGChange(Sender: TObject);
    procedure fseSGendmashChange(Sender: TObject);
    procedure fseSGStarterChange(Sender: TObject);
    procedure fseSpargeDeadspaceChange(Sender: TObject);
    procedure fseSpargeTempChange(Sender: TObject);
    procedure fseStarterTimeAeratedChange(Sender: TObject);
    procedure fseStarterVolume1Change(Sender: TObject);
    procedure fseTempStarterChange(Sender: TObject);
    procedure fseTopUpWater2Change(Sender: TObject);
    procedure fseTopUpWaterChange(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure fseTunCmChange(Sender: TObject);
    procedure fseTunVolumeChange(Sender: TObject);
    procedure miCheckPrintClick(Sender: TObject);
    procedure miCheckWindowClick(Sender: TObject);
    //procedure miCloudToBrewsClick(Sender: TObject);
    procedure miCloudToRecipesClick(Sender: TObject);
    procedure miFindParentBrewClick(Sender: TObject);
    procedure miFindParentRecipeClick(Sender: TObject);
    procedure rxteStartTimeChange(Sender: TObject);
    procedure rxteEndTimeChange(Sender: TObject);
    procedure fseVolToFermenterChange(Sender: TObject);
    procedure hcIngredientsSectionClick(HeaderControl: TCustomHeaderControl);
    //  Section: THeaderSection);
    procedure hcIngredientsSectionResize(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure hcMashSectionResize(HeaderControl: TCustomHeaderControl;
      Section: THeaderSection);
    procedure pcRecipesChange(Sender: TObject);
    procedure sbGristWizardClick(Sender: TObject);
    procedure sbHopWizardClick(Sender: TObject);
    procedure sbSearchBrewsDeleteClick(Sender: TObject);
    procedure sbSearchRecipesDeleteClick(Sender: TObject);
    procedure bbWaterWizardClick(Sender: TObject);
    procedure seCoolingTimeChange(Sender: TObject);
    procedure seGrainTempChange(Sender: TObject);
    procedure seTunTempChange(Sender: TObject);
    procedure fseLastRunningpHChange(Sender: TObject);
    procedure fseLastRunningSGChange(Sender: TObject);
    procedure fseMashpHChange(Sender: TObject);
    procedure fseSpargepHChange(Sender: TObject);
    procedure seWhirlpoolTimeChange(Sender: TObject);
    procedure sgIngredientsDblClick(Sender: TObject);
    procedure sgIngredientsEditingDone(Sender: TObject);
    procedure sgIngredientsExit(Sender: TObject);
    procedure sgIngredientsSelectCell(Sender: TObject; aCol, aRow: Integer;
      var CanSelect: Boolean);
    procedure sgIngredientsSelectEditor(Sender: TObject; aCol, aRow: Integer;
      var Editor: TWinControl);
    procedure sgMashStepsDblClick(Sender: TObject);
    procedure sgMashStepsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure sgMashStepsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbBackupClick(Sender: TObject);
    procedure tbBeerstylesClick(Sender: TObject);
    procedure tbEquipmentClick(Sender: TObject);
    procedure tbExitClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure tbFermChartClick(Sender: TObject);
    procedure tbFermentablespClick(Sender: TObject);
    procedure tbHopsClick(Sender: TObject);
    procedure tbHistogramClick(Sender: TObject);
    procedure tbHopChartClick(Sender: TObject);
    //procedure tbHopsClick(Sender: TObject);
    procedure tbImportClick(Sender: TObject);
    procedure tbMashClick(Sender: TObject);
    procedure tbMiscClick(Sender: TObject);
    procedure tBoilTimerTimer(Sender: TObject);
    procedure tbRestoreClick(Sender: TObject);
    procedure tbRestoreOriginalClick(Sender: TObject);
    procedure tbSaveClick(Sender: TObject);
    procedure tbWaterChartClick(Sender: TObject);
    procedure tbWatersClick(Sender: TObject);
    procedure tbYeastChartClick(Sender: TObject);
    procedure tbYeastsClick(Sender: TObject);
    procedure tCTimerTimer(Sender: TObject);
    procedure tMashTimerTimer(Sender: TObject);
    procedure tbHelpClick(Sender: TObject);
    procedure tvBrewsChanging(Sender: TObject; Node: TTreeNode;
      var AllowChange: Boolean);
    procedure tvBrewsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
              );
    procedure tvBrewsSelectionChanged(Sender: TObject);
    //procedure tvCloudKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
    //  );
    //procedure tvCloudSelectionChanged(Sender: TObject);
    procedure tvRecipesKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tvRecipesSelectionChanged(Sender: TObject);
    procedure bbStartTimerClick(Sender: TObject);
    procedure bbResetTimersClick(Sender: TObject);
    procedure bbMeasurementsClick(Sender: TObject);
    procedure cbTemp1Change(Sender: TObject);
    procedure cbTemp2Change(Sender: TObject);
    procedure cbSetpointChange(Sender: TObject);
    procedure cbCO2Change(Sender: TObject);
    procedure cbSGChange(Sender: TObject);
    procedure cbCoolingChange(Sender: TObject);
    procedure cbHeatingChange(Sender: TObject);
    procedure cbCoolPowerChange(Sender: TObject);
    procedure fseStartTempPrimaryChange(Sender: TObject);
    procedure fseMaxTempPrimaryChange(Sender: TObject);
    procedure fseEndTempPrimaryChange(Sender: TObject);
    procedure fseSGEndPrimaryChange(Sender: TObject);
    procedure fseSecondaryTempChange(Sender: TObject);
    procedure fseTertiaryTempChange(Sender: TObject);
    procedure fseFGChange(Sender: TObject);
    procedure fseVolumeBottlesChange(Sender: TObject);
    procedure fseCarbonationChange(Sender: TObject);
    procedure fseAmountPrimingBottlesChange(Sender: TObject);
    procedure fseVolumeKegsChange(Sender: TObject);
    procedure fseCarbonationKegsChange(Sender: TObject);
    procedure cbForcedCarbonationChange(Sender: TObject);
    procedure fseAmountPrimingKegsChange(Sender: TObject);
    procedure fseCarbonationTempChange(Sender: TObject);
    procedure fseCarbonationTempKegsChange(Sender: TObject);
    procedure fsePressureKegsChange(Sender: TObject);
    procedure mNotesChange(Sender: TObject);
    procedure cbPrimingSugarBottlesChange(Sender: TObject);
    procedure cbPrimingSugarKegsChange(Sender: TObject);
    procedure eColorChange(Sender: TObject);
    procedure eHeadChange(Sender: TObject);
    procedure eAromaChange(Sender: TObject);
    procedure eTasteChange(Sender: TObject);
    procedure eAftertasteChange(Sender: TObject);
    procedure eMouthfeelChange(Sender: TObject);
    procedure eTasteNotesChange(Sender: TObject);
    procedure fseTastingRateChange(Sender: TObject);
    procedure fseAgeTempChange(Sender: TObject);
    procedure eTransparencyChange(Sender: TObject);
    procedure tbCopyClipboardClick(Sender: TObject);
    procedure tbCopyHTMLClick(Sender: TObject);
    procedure cbLockedClick(Sender: TObject);
    procedure sgIngredientsDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure miBrewsToRecipeClick(Sender: TObject);
    procedure miRecipesToBrewsClick(Sender: TObject);
    procedure fseSGChange(Sender: TObject);
    procedure fsePlatoChange(Sender: TObject);
    procedure fseBrixChange(Sender: TObject);
    procedure fseSG2Change(Sender: TObject);
    procedure fsePlato2Change(Sender: TObject);
    procedure tbPrintPreviewClick(Sender: TObject);
    //procedure tbPrintClick(Sender: TObject);
    procedure deTasteDateChange(Sender: TObject);
    //procedure bbLoadBackgroundClick(Sender: TObject);
    //procedure bbAddLabelClick(Sender: TObject);
    //procedure bbPrintClick(Sender: TObject);
    procedure rgBitterhopClick(Sender: TObject);
    procedure fseSG3Change(Sender: TObject);
    procedure fseSGAfterChange(Sender: TObject);
    procedure fseSG4Change(Sender: TObject);
    procedure bbPostFermentationClick(Sender: TObject);
    procedure bbCookingMethodClick(Sender: TObject);
    procedure bbDatabaseLocationClick(Sender: TObject);
    procedure tbInventoryListClick(Sender: TObject);
    procedure miDivideBrewClick(Sender: TObject);
    procedure fseEvaporationChange(Sender: TObject);
    procedure tbInfoClick(Sender: TObject);
    procedure tbSynchronizeClick(Sender: TObject);
    procedure tbBrewsListClick(Sender: TObject);
    procedure cbRecipesSortChange(Sender: TObject);
    procedure fseTimeAerationChange(Sender: TObject);
    procedure fseAerationFlowRateChange(Sender: TObject);
    procedure cbAerationTypeChange(Sender: TObject);
    procedure fseCoolingToChange(Sender: TObject);
    procedure cbLockedChange(Sender: TObject);
    //
    //Procedure CloudOnCloudReady(Sender: TObject; NumFiles : longint);
    //Procedure CloudOnFileRead(Sender : TObject; PercDone : single);
    //Procedure CloudOnCloudError(Sender : TObject; Msg : string);
    procedure sbHideToolsClick(Sender: TObject);
    procedure sbShowToolsClick(Sender: TObject);
    procedure tbTrainNNClick(Sender: TObject);
    procedure tbChartClick(Sender: TObject);
  private
    { private declarations }
    FSelRecipe : TRecipe;
    FSelBrew : TRecipe;
    FSelCloud : TRecipe;
    FSelected, FTemporary : TRecipe;
    FSelIngredient : TIngredient;
    FSort : integer;
    FSortDec : boolean;
    FSortGrid : boolean;
    FIGLastRow : integer;
    FChanged : boolean;
    FUserClicked : boolean; // Seems to indicate whether procedures are called by the code (FALSE) or by User-generated events (TRUE)
    FByCode : boolean;
    FColorCells : array of TCellCoord;
    FWarningColor : TColor;
    FMashTimeLeft : TTime;
    FMashT : TMash;
    FTimerMashStep : TMashStep;
    FMashStep : LongInt;
    FBoilTimeLeft : TTime;
    FBoilIngredients : array of TIngrBoil;
    FTimeTimer : TTime;
    FIngredientGridColors : array of TColor;
    FInventoryColors : array of TColor;
    FLabelFileName : string;
    FIGSCX, FIGSCY : integer;
    Function AskToSave : Boolean;
    Procedure SortByNumber(page : TTabSheet);
    Procedure SortByStyle(page : TTabSheet);
    Procedure SortByDate(page : TTabSheet);
    Procedure CheckTotal100;
    Procedure Store;
    Procedure UpdateIngredientsGrid;
    Procedure Update;
    Procedure UpdatePredictions;
    Procedure SetControls;
    Procedure SortIngredients(I1, I2 : integer);
    Procedure CalcMash;
    Procedure SetAmountCells;
    Procedure UpdateGraph;
    Procedure FillAnalyseCharts;
    Procedure SetIcon;
    Procedure SetControlsStrings;
    Procedure NameChange;
  public
    { public declarations }
    OriginalBounds: TRect;
    OriginalWindowState: TWindowState;
    ScreenBounds: TRect;
    procedure SwitchFullScreen;
    Procedure UpdateAndStoreCheckList(Rec : TRecipe);
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.lfm}

{ TfrmMain }
uses Crt, Math, FrFermentables, frfermentables3, fradjustto100,
     FrHop, FrHop3, fryeasts, fryeasts3, FrMiscs, FrWaters,
     FrMiscs3, FrEquipments, FrMashs, FrBeerstyles, frsettings,
     FrMashStep, FrWaterAdjustment, FrWaterWizard, FrChooseBrewsChars,
     FrChooseBrews, FrImport, BH_report, FrChecklist, BhPrintforms,
     FrRestoreDatabases, FrPropagation, FrRefractometer, FrBoilMethod,
     FrHopStorage, FrGristWizard, FrHopWizard, FrMeasurements, FrHopGraph,
     FrFermentables2, fryeasts2, FrHop2, FrMiscs2, FDatabaseLocation,
     FrRecipeToBrew, FrDivideBrew, FrInfo
     {, FrAnalysis, FrHistogram
    FrNotification,
     frsplash,  frsynchronize, ,
     cloud, frnn, neuroot
     , , , rcstrngs}
     // Possibly not used
     {

     }
     ;


var
   clBack : TColor;
   PreviousBrew : TTreeNode;



 Procedure SetReadOnly(c : TCustomEdit; ro : boolean);
 begin
   c.ReadOnly:= ro;
   if ro then c.Color:= clBack
   else c.Color:= clDefault;
   c.Invalidate;
 end;

 Procedure SetReadOnlyDE(c : TDateEdit; ro : boolean);
 begin
   c.ReadOnly:= ro;
   if ro then c.Color:= clBack
   else c.Color:= clDefault;
   c.Invalidate;
 end;

procedure TfrmMain.FormCreate(Sender: TObject);
var rt : TRecipeType;
    i, w : integer;
    s : string;
    cm : TColorMethod;
    im : TIBUMethod;
    ct : TCoolingMethod;
    at : TAerationType;
    yf : TYeastForm;
    st : TStarterType;
    ps : TPrimingSugar;
    R : TRecipe;
    b, bt : boolean;
    jr1,jr2 : string;
    jr4:TBase;
begin
  {$ifdef Windows}
  clBack:= RGBToColor(242, 242, 242);
  {$endif}
  {$ifdef Unix}
  clBack:= clBackground;
  {$endif}
  {$ifdef darwin}
  clBack:= clBackground;
  {$endif}

  FUserClicked:= false;
  FSortGrid:= TRUE;
  {if Settings.ShowSplash.Value then
  begin
    frmsplash:= TFrmSplash.Create(self);
    frmsplash.Execute;
  end;
  if Settings.PlaySounds.Value then
  begin
    Application.ProcessMessages;
    PlayStartProg;
    Application.ProcessMessages;
  end;
  }
  Screen.Cursor:= crHourglass;

  epRight.AddPanel(mroSG);
  epRight.AddPanel(mroWaterSugar);
  epRight.AddPanel(mroHydrometerCorrection);
  epRight.AddPanel(mroPredictions);
  epRight.AddPanel(mroExtra);

  sbSearchBrewsDelete.Top:= eSearchBrews.Top;
  sbSearchBrewsDelete.Height:= eSearchBrews.Height + 2;
  sbSearchBrewsDelete.Width:= sbSearchBrewsDelete.Height;
  sbSearchBrewsDelete.Left:= eSearchBrews.Left + eSearchBrews.Width;
  sbSearchRecipesDelete.Top:= eSearchRecipes.Top;
  sbSearchRecipesDelete.Width:= sbSearchRecipesDelete.Height;
  sbSearchRecipesDelete.Height:= sbSearchRecipesDelete.Height + 2;
  sbSearchRecipesDelete.Left:= eSearchRecipes.Left + eSearchRecipes.Width;

  FByCode:= TRUE;
  if FileExists(Settings.DataLocation.Value + 'logo.png') then
    iLogo.Picture.LoadFromFile(Settings.DataLocation.Value + 'logo.png');

  FUserClicked:= false;
  b:= Settings.ShowSplash.Value;
  cbShowSplash.Checked:= b;
  b:= Settings.PlaySounds.Value;
  cbPlaySounds.Checked:= b;
  cbAdjustAlpha.Checked:= Settings.AdjustAlfa.Value;

  FLabelFileName:= Settings.DataLocation.Value;

  FMashStep:= -1;
  FMashT:= NIL;
  FTimerMashStep:= NIL;

  fseOG.ReadOnly:= TRUE;
  fseOG.Color:= clBackground;

  rxteStartTime := TTimeEdit.Create(self);
  rxteStartTime.Parent:= tsBrewday;
  rxteStartTime.Top:= 13;
  rxteStartTime.Left:= 288;
  rxteStartTime.Width:= 80;
  rxteStartTime.Height:= 23;
  rxteStartTime.Font.Height:= Font.Height;
  rxteStartTime.Time:= 0;
  rxteStartTime.OnChange:= @rxteStartTimeChange;

  rxteEndTime := TTimeEdit.Create(self);
  rxteEndTime.Parent:= tsBrewday;
  rxteEndTime.Top:= 13;
  rxteEndTime.Left:= 474;
  rxteEndTime.Width:= 80;
  rxteEndTime.Height:= 23;
  rxteEndTime.Font.Height:= Font.Height;
  rxteEndTime.Time:= 0;
  rxteEndTime.OnChange:= @rxteEndTimeChange;

  FWarningColor:= clRed;
  piGravity:= TPosInterval.Create(gbVisual);
  piGravity.Parent:= gbVisual;
  piGravity.Left:= 3;
  piGravity.Top:= 0;
  piGravity.Width:= 280;
  piGravity.Height:= 40;
  piGravity.Font.Height:= Font.Height;
  piGravity.Caption:= pisg1;
  piGravity.ShowValues:= false;
  piGravity.Effect:= ePlain;
  piGravity.Decimals:= 0;
  piGravity.Min:= 30;
  piGravity.Max:= 100;
  piGravity.Value:= 50;

  piBitterness:= TPosInterval.Create(gbVisual);
  piBitterness.Parent:= gbVisual;
  piBitterness.Left:= 3;
  piBitterness.Top:= 35;
  piBitterness.Width:= 280;
  piBitterness.Height:= 40;
  piBitterness.Font.Height:= Font.Height;
  piBitterness.Caption:= pibitterness1;
  piBitterness.ShowValues:= piGravity.ShowValues;
  piBitterness.Effect:= piGravity.Effect;
  piBitterness.Decimals:= 0;
  piBitterness.Min:= 0;
  piBitterness.Max:= 100;
  piBitterness.Value:= 50;

  piBUGU:= TPosInterval.Create(gbVisual);
  piBUGU.Parent:= gbVisual;
  piBUGU.Left:= 3;
  piBUGU.Top:= 70;
  piBUGU.Width:= 280;
  piBUGU.Height:= 40;
  piBUGU.Font.Height:= Font.Height;
  piBUGU.Caption:= pibitternessindex1;
  piBUGU.ShowValues:= piGravity.ShowValues;
  piBUGU.Effect:= piGravity.Effect;
  piBUGU.ColorScale:= false;
  piBUGU.Decimals:= 0;
  piBUGU.Min:= 0;
  piBUGU.Max:= 1.5;
  piBUGU.Value:= 0.5;

  piColor:= TPosInterval.Create(gbVisual);
  piColor.Parent:= gbVisual;
  piColor.Left:= 300;
  piColor.Top:= 0;
  piColor.Width:= 280;
  piColor.Height:= 40;
  piColor.Font.Height:= Font.Height;
  piColor.Caption:= picolor1;
  piColor.ShowValues:= piGravity.ShowValues;
  piColor.Effect:= piGravity.Effect;
  piColor.ColorScale:= true;
  piColor.Decimals:= 0;
  piColor.Min:= 0;
  piColor.Max:= 75;
  piColor.Value:= 50;

  piABV:= TPosInterval.Create(gbVisual);
  piABV.Parent:= gbVisual;
  piABV.Left:= 300;
  piABV.Top:= 35;
  piABV.Width:= 280;
  piABV.Height:= 40;
  piABV.Font.Height:= Font.Height;
  piABV.Caption:= piabv1;
  piABV.ShowValues:= piGravity.ShowValues;
  piABV.Effect:= piGravity.Effect;
  piABV.ColorScale:= false;
  piABV.Decimals:= 1;
  piABV.Min:= 0;
  piABV.Max:= 12;
  piABV.Value:= 5;

  piABV2:= TPosInterval.Create(tsMeasSimple);
  piABV2.Parent:= tsMeasSimple;
  piABV2.Left:= 2;
  piABV2.Top:= 320;
  piABV2.Width:= 308;
  piABV2.Height:= 40;
  piABV2.Font.Height:= Font.Height;
  piABV2.Caption:= piabv1;
  piABV2.ShowValues:= piGravity.ShowValues;
  piABV2.Effect:= piGravity.Effect;
  piABV2.ColorScale:= false;
  piABV2.Decimals:= 1;
  piABV2.Min:= 0;
  piABV2.Max:= 15;
  piABV2.Value:= 5;

  piCarbBottles:= TPosInterval.Create(gbBottles);
  piCarbBottles.Parent:= gbBottles;
  piCarbBottles.Left:= 2;
  piCarbBottles.Top:= 200;
  piCarbBottles.Width:= 290;
  piCarbBottles.Height:= 40;
  piCarbBottles.Font.Height:= Font.Height;
  piCarbBottles.Caption:= pico21;
  piCarbBottles.ShowValues:= piGravity.ShowValues;
  piCarbBottles.Effect:= piGravity.Effect;
  piCarbBottles.ColorScale:= false;
  piCarbBottles.Decimals:= 1;
  piCarbBottles.Min:= 0;
  piCarbBottles.Max:= 5;
  piCarbBottles.Value:= 2.5;

  piCarbKegs:= TPosInterval.Create(gbKegs);
  piCarbKegs.Parent:= gbKegs;
  piCarbKegs.Left:= 2;
  piCarbKegs.Top:= 250;
  {$ifdef Linux}
  piCarbKegs.Top:= 250;
  {$endif}
  {$ifdef darwin}
  piCarbKegs.Top:= 250;
  {$endif}
  piCarbKegs.Width:= 290;
  piCarbKegs.Height:= 40;
  piCarbKegs.Font.Height:= Font.Height;
  piCarbKegs.Caption:= pico21;
  piCarbKegs.ShowValues:= piGravity.ShowValues;
  piCarbKegs.Effect:= piGravity.Effect;
  piCarbKegs.ColorScale:= false;
  piCarbKegs.Decimals:= 1;
  piCarbKegs.Min:= 0;
  piCarbKegs.Max:= 5;
  piCarbKegs.Value:= 2.5;

{  bhgMeasurements:= TBHGraph.Create(tsMeasExt);
  bhgMeasurements.Parent:= tsMeasExt;
  bhgMeasurements.SetBounds(3, 3, tsMeasExt.Width - 105, tsMeasExt.Height - 35);}

  with chTControl do
  begin
    //Toolset:= ctDefault;
    Align:= alCustom;
    AllowZoom:= false;
    ParentColor:= false;
    BackColor:= $00BDF4F5;
    Color:= clWhite;
    Top:= 2;
    Left:= 2;
    Width:= 502;
    Height:= 322;
  end;

  cbBrewsSort.ItemIndex:= 0;
  cbRecipesSort.ItemIndex:= 1;

  pcMenuButtons.ActivePage:= tsFile;
  pcRecipes.ActivePage:= tsBrews;
  pcRecipe.ActivePage:= tsRecipe;

  cbType.Items.Clear;
  for rt:= Low(RecipeTypeDisplayNames) to High(RecipeTypeDisplayNames) do
    cbType.Items.Add(RecipeTypeDisplayNames[rt]);
  cbType.ItemIndex:= 2;
  cbBeerStyle.Items.Clear;
  BeerStyles.SortByIndex2(5, 0, false);
  for i:= 0 to BeerStyles.NumItems - 1 do
  begin
    jr4 := BeerStyles.Item[i];
    jr1 := TBeerStyle(jr4).StyleLetter.Value;
    jr2 := TBeerStyle(jr4).Name.Value;
    cbBeerStyle.Items.Add(jr1 + ' - ' + jr2);
  end;
  cbBeerStyle.ItemIndex:= 0;
  Equipments.SortByName('Naam');
  cbEquipment.Items.Clear;
  for i:= 0 to Equipments.NumItems - 1 do
    cbEquipment.Items.Add(TEquipment(Equipments.Item[i]).Name.Value);
  cbEquipment.ItemIndex:= 0;
  cbColorMethod.Items.Clear;
  for cm:= Low(ColorMethodDisplayNames) to High(ColorMethodDisplayNames) do
    cbColorMethod.Items.Add(ColorMethodDisplayNames[cm]);
  cbColorMethod.ItemIndex:= 0;
  cbIBUMethod.Items.Clear;
  for im:= Low(IBUMethodDisplayNames) to High(IBUMethodDisplayNames) do
    cbIBUMethod.Items.Add(IBUMethodDisplayNames[im]);
  cbIBUMethod.ItemIndex:= 0;
  cbCoolingMethod.Items.Clear;
  for ct:= Low(CoolingMethodDisplayNames) to High(CoolingMethodDisplayNames) do
    cbCoolingMethod.Items.Add(CoolingMethodDisplayNames[ct]);
  cbCoolingMethod.ItemIndex:= 0;
  for at:= Low(AerationTypeDisplayNames) to High(AerationTypeDisplayNames) do
    cbAerationType.Items.Add(AerationTypeDisplayNames[at]);
  cbAerationType.ItemIndex:= 0;

  R:= TRecipe(Recipes.Item[0]);
  if R <> NIL then
  begin
    cbColorMethod.ItemIndex:= cbColorMethod.Items.IndexOf(R.ColorMethodDisplayName);
    s:= R.IBUMethodDisplayName;
    i:= cbIBUMethod.Items.IndexOf(s);
    cbIBUMethod.ItemIndex:= i;
    if Settings.IBUMethod.Value <> s then
    begin
      Settings.IBUMethod.Value:= s;
      Settings.Save;
    end;
    lMashWater.Caption:= R.BatchSize.DisplayUnitString;
    lGrainAbsorption.Caption:= R.BatchSize.DisplayUnitString;
    lSpargeDeadSpace.Caption:= lGrainAbsorption.Caption;
    lSpargeWater.Caption:= lGrainAbsorption.Caption;
    lBoilSize.Caption:= lGrainAbsorption.Caption;
    lEvap.Caption:= lGrainAbsorption.Caption;
    lAfterBoil.Caption:= lGrainAbsorption.Caption;
    lChillerLoss.Caption:= lGrainAbsorption.Caption;
    lTopUpWater.Caption:= lGrainAbsorption.Caption;
    lAerationTime.Caption:= R.TimeAeration.DisplayUnitString;
    lAerationFlowRate.Caption:= R.AerationFlowRate.DisplayUnitString;
    lCoolingTo.Caption:= R.CoolingTo.DisplayUnitString;
  end;

  for i:= 0 to 4 do
    sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;

  sgMashSteps.ColCount:= 10;
  sgMashSteps.AlternateColor:= RGBtoColor(243, 251, 158);
  sgMashSteps.FixedColor:= RGBtoColor(158, 226, 251);
  sgMashSteps.SelectedColor:= RGBtoColor(15, 196, 54);
  hcMash.Sections[0].Width:= 80;
  hcMash.Sections[1].Width:= 88;
  w:= round((hcMash.Width - hcMash.Sections[0].Width - hcMash.Sections[1].Width) / 8);
  for i:= 2 to 9 do hcMash.Sections[i].Width:= w;
  if sgMashSteps.RowCount > 0 then
    for i:= 0 to sgMashSteps.ColCount - 1 do
      sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;

  Mashs.SortByName('Naam');
  cbMash.Items.Clear;
  for i:= 0 to Mashs.NumItems - 1 do
    cbMash.Items.Add(Mashs.Item[i].Name.Value);
  cbMash.ItemIndex:= -1;

  cbYeastAddedAs.Items.Clear;
  for yf:= Low(YeastFormDisplayNames) to High(YeastFormDisplayNames) do
    cbYeastAddedAs.Items.Add(YeastFormDisplayNames[yf]);
  cbYeastAddedAs.ItemIndex:= 0;

  cbStarterType.Items.Clear;
  for st:= Low(StarterTypeDisplayNames) to High(StarterTypeDisplayNames) do
    cbStarterType.Items.Add(StarterTypeDisplayNames[st]);
  cbStarterType.ItemIndex:= 0;

  cbPrimingSugarBottles.Items.Clear;
  for ps:= Low(PrimingSugarDisplayNames) to High(PrimingSugarDisplayNames) do
    cbPrimingSugarBottles.Items.Add(PrimingSugarDisplayNames[ps]);
  cbPrimingSugarBottles.ItemIndex:= 0;
  cbPrimingSugarKegs.Items.Clear;
  for ps:= Low(PrimingSugarDisplayNames) to High(PrimingSugarDisplayNames) do
    cbPrimingSugarKegs.Items.Add(PrimingSugarDisplayNames[ps]);
  cbPrimingSugarKegs.ItemIndex:= 0;

  pcAnalysis.Visible:= false;

  FSelRecipe:= NIL;
  FSelBrew:= NIL;
  FSelCloud:= NIL;
  FSelected:= NIL;
  FTemporary:= TRecipe.Create(NIL);
  FChanged:= false;

  cbCloudSort.ItemIndex:= Settings.SortCloud.Value;
  //cbCloudSortChange(self);

  cbRecipesSort.ItemIndex:= Settings.SortRecipes.Value;
  cbRecipesSortChange(self);

  pcRecipes.ActivePage:= tsBrews;
  cbBrewsSort.ItemIndex:= Settings.SortBrews.Value;
  cbBrewsSortChange(self); // Fills BREWS-list with brews

  if tvBrews.Items.Count > 0 then
  begin
    FUserClicked := true;
    tvBrews.Items[tvBrews.Items.Count-1].Selected:= TRUE;
    tvBrews.Selected.MakeVisible;
    FUserClicked := false;
  end;

  SetControls;
  SetControlsStrings;
  Update;
  sgIngredients.Row:= 0;
  FIGSCX:= 0;
  FIGSCY:= 0;

  pcMeasurements.ActivePage:= tsMeasSimple;

  FSortDec:= false;
  FSort:= -1;
  FChanged:= false;

  FByCode:= false;
  FUserClicked:= TRUE;
  FIGLastRow:= 0;

  {BHCloud.OnCloudReady:= @CloudOnCloudReady;
  BHCloud.OnFileRead:= @CloudOnFileRead;
  BHCloud.OnCloudError:= @CloudOnCloudError;
  }
  tsAnalysis.TabVisible:= AnalysisActive;
  Toolbutton10.Visible:= FANNActive;
  tbTrainNN.Visible:= FANNActive;

  lMessage.Visible:= false;
  pbProgress.Visible:= false;
  b:= Settings.UseCloud.Value;
  //bt:= (BHCloud.PassWord <> '');
  //if Settings.UseCloud.Value then BHCloud.ReadCloud;
  //tsCloud.TabVisible:= Settings.UseCloud.Value and (BHCloud.PassWord <> '');
  bbShowTools.Visible:= false;

  FUserClicked:= false;
  cbPercentage.Checked:= Settings.Percentages.Value;
  SetReadOnly(fseOG, (not cbPercentage.Checked));
  cbScaleVolume.Checked:= Settings.ScaleWithVolume.Value;
  FUserClicked:= TRUE;

  Screen.Cursor:= crDefault;

  {if Settings.CheckForNewVersion.Value then
  begin
    if CheckNewVersion then
      if Question(self, newversion1) then
        OpenURL('http://wittepaard.roodetoren.nl');
  end;}

  w:= 0;
  while (Equipments.NumItems = 0) and (w < 1) do
  begin
    FrmEquipments:= TFrmEquipments.Create(self);
    FrmEquipments.Caption:= equipmentwarning1;
    FrmEquipments.bbAddClick(FrmEquipments);
    if FrmEquipments.ShowModal = mrOK then
    begin
      Equipments.SaveXML;
      cbEquipment.Items.Clear;
      for i:= 0 to Equipments.NumItems - 1 do
        cbEquipment.Items.Add(TEquipment(Equipments.Item[i]).Name.Value);
      if FSelected <> NIL then
        cbEquipment.ItemIndex:= Equipments.IndexByName(FTemporary.Equipment.Name.Value)
      else
        cbEquipment.ItemIndex:= 0;
    end
    else
    begin
      Equipments.Free;
      Equipments:= TEquipments.Create;
      Equipments.ReadXML;
    end;
    FrmEquipments.Free;
    inc(w);
  end;
  if Equipments.NumItems = 0 then
  begin
    PlayWarning;
    ShowNotification(self, equimpentwarning2);
  end;
  Settings.Style.SetControlsStyle(self);
  hcMash.Font.Height:= Settings.Style.Font.Height - 2;
//  tsOptions.Font.Height:= Settings.Style.Font.Height - 2;
  {$ifdef Linux}
  tbFile.Color:= clDefault;
  tbDatabases.Color:= clDefault;
  {$endif}
  {$ifdef darwin}
  tbFile.Color:= clDefault;
  tbDatabases.Color:= clDefault;
  {$endif}
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
//  Log('');
//  Log('MAINWINDOW');
  if Settings.PlaySounds.Value then
  begin
 //   PlayEndProg;
//    Log('Eindgeluid afgespeeld');
    Application.ProcessMessages;
//    {$ifdef Linux}
    Delay(2000);
//    {$endif}
  end;

  SetLength(FIngredientGridColors, 0);
  SetLength(FInventoryColors, 0);
//  Log('IngredientGridColors afgesloten');

  piGravity.Free;
//  Log('piGravity afgesloten');
  piBitterness.Free;
//  Log('piBitterness afgesloten');
  piBUGU.Free;
//  Log('piBUGU afgesloten');
  piColor.Free;
//  Log('piColor afgesloten');
  piABV.Free;
//  Log('piABV afgesloten');
  piABV2.Free;
//  Log('piABV2 afgesloten');
  piCarbBottles.Free;
//  Log('piCarbBottles afgesloten');
  piCarbKegs.Free;
//  Log('piCarbKegs afgesloten');
  FTemporary.Free;
//  Log('FTemporary afgesloten');
  rxteStartTime.Free;
//  Log('rxteStartTime afgesloten');
  rxteEndTime.Free;
//  Log('rxteEndTime afgesloten');
 { lsEnvTemp.Free;
  lsBeerTemp.Free;
  lsSetTemp.Free;
  lsCO2.Free;
  lsSG.Free;
  lsCooling.Free;
  lsHeating.Free;
  lsCoolingPower.Free;}
//  bhgMeasurements.Free;
 // FLabel.Free;
// Log('Hoofdscherm afgesloten');
end;


procedure TfrmMain.gbIngredientsClick(Sender: TObject);
begin

end;


procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if FChanged and Settings.ConfirmSave.Value then
  begin
    case (MessageDlg(savechanges1, mtConfirmation, [mbYes, mbNo, mbCancel], 0)) of
    mrYes : begin
      tbSaveClick(Self);
      CanClose := true;
      end;
    mrCancel: CanClose := False;
    mrNo: CanClose := true;
    end;
  end
  else if FChanged then
  begin
    tbSaveClick(self);
    CanClose:= TRUE;
  end;
end;

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  pcRecipe.Visible := true;
end;

{

 Procedure TfrmMain.CloudOnCloudReady(Sender: TObject; NumFiles : longint);
 begin
   lMessage.Caption:= fillcloud1;
   pbProgress.Position:= 0;

   //Fill cloud recipe tree
   cbCloudSortChange(self);
   tsCloud.TabVisible:= TRUE;

   lMessage.Visible:= false;
   pbProgress.Visible:= false;
 end;

 Procedure TfrmMain.CloudOnFileRead(Sender : TObject; PercDone : single);
 begin
   if (not lMessage.Visible) then
   begin
     lMessage.Visible:= TRUE;
     lMessage.Caption:= readcloud1;
   end;
   if (not pbProgress.Visible) then pbProgress.Visible:= TRUE;
   pbProgress.Position:= round(100 * PercDone);
 end;

 Procedure TfrmMain.CloudOnCloudError(Sender : TObject; Msg : string);
 begin
   lMessage.Visible:= false;
   pbProgress.Visible:= false;
   ShowNotification(self, Msg);
 end;
}
 procedure TfrmMain.sbHideToolsClick(Sender: TObject);
 begin
   bbShowTools.Visible:= TRUE;
   bbHideTools.Visible:= false;
   pRight.Visible:= false;
   Width:= 1027 - pRight.Width;
   pbProgress.Left:= pbProgress.Left - pRight.Width;
   lMessage.Left:= lMessage.Left - pRight.Width;
 end;

 procedure TfrmMain.sbShowToolsClick(Sender: TObject);
 begin
   bbShowTools.Visible:= false;
   bbHideTools.Visible:= TRUE;
   Width:= 1027;
   pRight.Visible:= TRUE;
   pbProgress.Left:= pbProgress.Left + pRight.Width;
   lMessage.Left:= lMessage.Left + pRight.Width;
 end;

 procedure TfrmMain.cbLockedClick(Sender: TObject);
 var b : boolean;
 begin
   if (FSelected <> NIL) then
   begin
     b:= cbLocked.Checked;
     FTemporary.Locked.Value:= b;
     if FUserClicked then
       Brews.SaveXML;
     SetReadOnly(eNrRecipe, b);
     SetReadOnly(eName, b);
     cbBeerstyle.Enabled:= not b;
     cbEquipment.Enabled:= not b;
     cbType.Enabled:= not b;
     SetReadOnly(fseBatchSize, b);
     SetReadOnly(fseBoilTime, b);
     cbScaleVolume.Enabled:= not b;
     SetReadOnly(fseOG, not(cbPercentage.Checked and (not b)));
     SetReadOnly(fseIBU, b);
     SetReadOnly(fseEfficiency, b);
     bbAddGrain.Enabled:= not b;
     sbGristWizard.Enabled:= not b;
     bbAddHop.Enabled:= not b;
     sbHopWizard.Enabled:= not b;
     bbAddMisc.Enabled:= not b;
     bbAddYeast.Enabled:= not b;
     bbRemove.Enabled:= not b;
     cbPercentage.Enabled:= not b;
     bbInventory.Enabled:= (not FTemporary.InventoryReduced.Value) and (not b)
                            and (pcRecipes.ActivePage = tsBrews);

     sgMashSteps.Enabled:= not b;
     bbAddStep.Enabled:= not b;
     bbDeletestep.Enabled:= not b;
     cbMash.Enabled:= not b;
     SetReadOnly(seGrainTemp, b);
     SetReadOnly(seTunTemp, not ((not b) and (FTemporary.Mash.EquipAdjust.Value)));
     SetReadOnly(fseInfuseAmount, b);
     cbTunTemp.Enabled:= not b;
     SetReadOnly(fseSpargeDeadSpace, b);
     SetReadOnly(fseEvaporation, b);
     SetReadOnly(fseChillerLoss, b);
     SetReadOnly(fseTopUpWater, b);
     bbWaterWizard.Enabled:= not b;
     bbWaterAdjustment.Enabled:= not b;

     SetReadOnlyDE(deBrewDate, b);
     tbCheckList.Enabled:= (pcRecipes.ActivePage = tsBrews) and (not b);
     SetReadOnly(fseSpargepH, b);
     SetReadOnly(fseSpargeTemp, b);
     SetReadOnly(fseMashpH, b);
     SetReadOnly(fseSGendmash, b);
     SetReadOnly(fseLastRunningpH, b);
     SetReadOnly(fseLastRunningSG, b);
     SetReadOnly(fseBoilpHS, b);
     SetReadOnly(fseBoilpHE, b);
     SetReadOnly(fseBoilSGS, b);
     SetReadOnly(fseBoilSGE, b);
     SetReadOnly(fseBoilVolumeS, b);
     SetReadOnly(fseBoilVolumeE, b);
     bbStartMash.Enabled:= (not b) or (tMashTimer.Enabled);
     bbStartBoil.Enabled:= (not b) or (tBoilTimer.Enabled);
     SetReadOnly(seWhirlPoolTime, b);
     SetReadOnly(seCoolingTime, b);
     SetReadOnly(fseCoolingTo, b);
     cbCoolingMethod.Enabled:= not b;
     SetReadOnly(fseTimeAeration, b);
     SetReadOnly(fseAerationFlowRate, b);
     cbAerationType.Enabled:= not b;
     SetReadOnly(fseVolToFermenter, b);
     SetReadOnly(fseTopUpWater2, b);
     //SetReadOnly(rxteStartTime, b);
     //SetReadOnly(rxteEndTime, b);
     gbVolumes.Enabled:= (not b) and (cbEquipment.ItemIndex > -1);

     cbYeastAddedAs.Enabled:= not b;
     cbStarterMade.Enabled:= not b;
     cbStarterType.Enabled:= (cbStarterMade.Checked) and (not b);
     SetReadOnly(fseStarterTimeAerated, not ((cbStarterMade.Checked) and (not b)));
     fseStarterTimeAerated.Enabled:= not fseStarterTimeAerated.ReadOnly;
     SetReadOnly(fseSGStarter, not ((cbStarterMade.Checked) and (not b)));
     fseSGStarter.Enabled:= not fseSGStarter.ReadOnly;
     SetReadOnly(fseTempStarter, not ((cbStarterMade.Checked) and (not b)));
     fseTempStarter.Enabled:= not fseTempStarter.ReadOnly;

     SetReadOnly(fseStarterVolume1, (not ((cbStarterMade.Checked) and (not b))));
     fseStarterVolume1.Enabled:= not fseStarterVolume1.ReadOnly;
     SetReadOnly(fseStarterVolume2, (not ((cbStarterMade.Checked) and (not b))));
     if ((not fseStarterVolume2.ReadOnly) and (not cbStarterMade.Checked) and b) then
       fseStarterVolume2.ReadOnly:= TRUE;
     if not fseStarterVolume2.ReadOnly and b then fseStarterVolume2.ReadOnly:= TRUE;
     SetReadOnly(fseStarterVolume3, (not ((cbStarterMade.Checked) and (not b))));
     if ((not fseStarterVolume3.ReadOnly) and (not cbStarterMade.Checked) and b) then
       fseStarterVolume3.ReadOnly:= TRUE;
     if not fseStarterVolume3.ReadOnly and b then fseStarterVolume3.ReadOnly:= TRUE;

     SetReadOnly(fseAmountYeast, b);
     SetAmountCells;
     bbMeasurements.Enabled:= not b;

     SetReadOnlyDE(deTransferDate, b);
     SetReadOnlyDE(deLagerDate, b);
     SetReadOnlyDE(deBottleDate, b);
     SetReadOnly(fseStartTempPrimary, b);
     SetReadOnly(fseMaxTempPrimary, b);
     SetReadOnly(fseEndTempPrimary, b);
     SetReadOnly(fseSGEndPrimary, b);
     SetReadOnly(fseSecondaryTemp, b);
     SetReadOnly(fseTertiaryTemp, b);
     SetReadOnly(fseFG, b);

     bbMeasurements.Enabled:= not b;
     cbTemp1.Enabled:= not b;
     cbTemp2.Enabled:= not b;
     cbSetpoint.Enabled:= not b;
     cbCO2.Enabled:= not b;
     cbSG.Enabled:= not b;
     cbCooling.Enabled:= not b;
     cbHeating.Enabled:= not b;
     cbCoolpower.Enabled:= not b;

     SetReadOnly(fseVolumeBottles, b);
     SetReadOnly(fseCarbonation, b);
     SetReadOnly(fseAmountPrimingBottles, b);
     SetReadOnly(fseCarbonationTemp, b);
     SetReadOnly(fseVolumeKegs, b);
     SetReadOnly(fseCarbonationKegs, b);
     SetReadOnly(fseAmountPrimingKegs, not ((not b) and (not cbForcedCarbonation.Checked)));
     cbForcedCarbonation.Enabled:= not b;
     SetReadOnly(fsePressureKegs, not ((not b) and cbForcedCarbonation.Checked));
     SetReadOnly(fseCarbonationTempKegs, b);
     cbPrimingSugarBottles.Enabled:= (not b);
     cbPrimingSugarKegs.Enabled:= (not b) and (not cbForcedCarbonation.Checked);

     SetReadOnlyDE(deTasteDate, b);
     SetReadOnly(eColor, b);
     SetReadOnly(eTransparency, b);
     SetReadOnly(eHead, b);
     SetReadOnly(eAroma, b);
     SetReadOnly(eTaste, b);
     SetReadOnly(eAftertaste, b);
     SetReadOnly(fseAgeTemp, b);
 //    lAgeTemp.Enabled:= not b;
     SetReadOnly(eMouthfeel, b);
     SetReadOnly(eTasteNotes, b);
     SetReadOnly(fseTastingRate, b);

     SetReadOnly(eBrewer, b);
     SetReadOnly(eAssistantBrewer, b);
     SetReadOnly(mNotes, b);

     FChanged:= TRUE;
     FTemporary.Locked.Value:= cbLocked.Checked;
   end;
 end;

 Procedure TfrmMain.SetControls;
 var //u : TUnit;
     v : double;
     bl : boolean;
     s : string;
 begin
   if FTemporary <> NIL then
   begin
     FUserClicked:= false;
     SetControl(fseOG, lEstOG, FTemporary.EstOG, TRUE);
     SetControl(fseBatchSize, lBatchSize, FTemporary.BatchSize, TRUE);
     SetControl(fseIBU, lIBU, FTemporary.IBUcalc, TRUE);
     SetControl(fseBoilTime, lBoilTime, FTemporary.BoilTime, TRUE);

     //Maischen en water
     SetControl(fseInfuseAmount, lInfuseAmount, FTemporary.BatchSize, false);
     if FTemporary.Mash <> NIL then
     begin
       if FTemporary.Mash.TunTemp.DisplayUnit = celcius then
         s:= '20°C'
       else if FTemporary.Mash.TunTemp.DisplayUnit = fahrenheit then
         s:= '68°F';
     end
     else s:= '20°C';
     lInfuseAmount.Caption:= lInfuseAmount.Caption + ' @ ' + s;
     if FTemporary.Mash <> NIL then
     begin
       SetUnitLabel(lTunTemp, FTemporary.Mash.TunTemp);
       SetUnitLabel(lMashWater, FTemporary.Mash.TunTemp);
     end;
     SetUnitLabel(lMashWater, FTemporary.BatchSize);
     SetUnitLabel(lGrainAbsorption, FTemporary.BatchSize);
     SetUnitLabel(lSpargeWater, FTemporary.BatchSize);
     if FTemporary.Equipment <> NIL then
     begin
       SetControl(fseSpargeDeadSpace, lSpargeDeadSpace, FTemporary.Equipment.LauterDeadSpace, TRUE);
     end;
     SetUnitLabel(lBoilSize, FTemporary.BatchSize);
     SetUnitLabel(lAfterBoil, FTemporary.BatchSize);

     SetControl(fseEvaporation, lEvap, FTemporary.BatchSize, false);
     SetControl(fseChillerLoss, lChillerLoss, FTemporary.BatchSize, false);
     SetControl(fseTopUpWater, lTopUpWater, FTemporary.BatchSize, false);

     //Brouwdag
     SetFloatSpinEdit(fseMashpH, FTemporary.pHAdjusted, TRUE);
     if FTemporary.Mash <> NIL then
     begin
       SetControl(fseSpargeTemp, lSpargeTemp, FTemporary.Mash.SpargeTemp, TRUE);
       SetFloatSpinEdit(fseSpargepH, FTemporary.Mash.pHsparge, TRUE);
       SetFloatSpinEdit(fseLastRunningpH, FTemporary.Mash.pHlastRunnings, TRUE);
       SetControl(fseLastRunningSG, lLastRunningSG, FTemporary.Mash.SGLastRunnings, TRUE);
     end;
     SetControl(fseSGendmash, lSGendmash, FTemporary.SGEndMash, TRUE);
     SetFloatSpinEdit(fseBoilpHS, FTemporary.pHBeforeBoil, TRUE);
     SetFloatSpinEdit(fseBoilpHE, FTemporary.pHAfterBoil, TRUE);
     SetControl(fseBoilSGS, lSGb, FTemporary.EstOG, false);
     SetFloatSpinEdit(fseBoilSGE, FTemporary.EstOG, false);
     SetFloatSpinEdit(fseBoilVolumeS, FTemporary.BatchSize, false);
     SetFloatSpinEdit(fseBoilVolumeE, FTemporary.BatchSize, false);
     SetControl(fseCoolingTo, lCoolingTo, FTemporary.CoolingTo, TRUE);
     SetControl(fseVolToFermenter, lVolToFermenter, FTemporary.VolumeFermenter, TRUE);
     if FTemporary.Equipment <> NIL then
       SetControl(fseTopUpWater, lTopUpWater, FTemporary.Equipment.TopUpWater, TRUE);
     SetControl(fseTimeAeration, lAerationTime, FTemporary.TimeAeration, TRUE);
     SetControl(fseAerationFlowRate, lAerationFlowRate, FTemporary.AerationFlowRate, TRUE);

     //Vergisting
     if FTemporary.Yeast[0] <> NIL then
     begin
       SetControl(fseAmountYeast, lAmountYeast, FTemporary.Yeast[0].AmountYeast, TRUE);
       SetControl(fseStarterVolume1, lStarterVolume1, FTemporary.Yeast[0].StarterVolume1, TRUE);

       SetControl(fseStarterVolume2, lStarterVolume2, FTemporary.Yeast[0].StarterVolume2, TRUE);
       v:= fseStarterVolume1.Value;
       bl:= (v > 0);
       if (not bl) then fseStarterVolume2.Value:= 0;
       fseStarterVolume2.ReadOnly:= not bl;
       fseStarterVolume2.Enabled:= bl;
       fseStarterVolume2.Visible:= bl;
       lStarterVolume2.Visible:= bl;
       Label142.Visible:= bl;

       SetControl(fseStarterVolume3, lStarterVolume3, FTemporary.Yeast[0].StarterVolume3, TRUE);
       v:= fseStarterVolume2.Value;
       bl:= (v > 0);
       if (not bl) then fseStarterVolume3.Value:= 0;
       fseStarterVolume3.ReadOnly:= not bl;
       fseStarterVolume3.Enabled:= bl;
       fseStarterVolume3.Visible:= bl;
       lStarterVolume3.Visible:= bl;
       Label143.Visible:= bl;

       bl:= cbLocked.Checked;
       SetReadOnly(fseStarterVolume1, (not ((cbStarterMade.Checked) and (not bl))));
       SetReadOnly(fseStarterVolume2, (not ((cbStarterMade.Checked) and (not bl))) or (fseStarterVolume1.Value <= 0));
       if ((not fseStarterVolume2.ReadOnly) and (not cbStarterMade.Checked) and bl) then
         fseStarterVolume2.ReadOnly:= TRUE;
       SetReadOnly(fseStarterVolume3, (not ((cbStarterMade.Checked) and (not bl))) or (fseStarterVolume2.Value <= 0));
       if ((not fseStarterVolume3.ReadOnly) and (not cbStarterMade.Checked) and bl) then
         fseStarterVolume3.ReadOnly:= TRUE;

       SetControl(fseTempStarter, lTempStarter, FTemporary.Yeast[0].Temperature, TRUE);
       SetControl(fseStarterTimeAerated, lStarterTimeAerated, FTemporary.Yeast[0].TimeAerated, TRUE);
     end;
     SetControl(fseStartTempPrimary, lStartTempPrimary, FTemporary.StartTempPrimary, TRUE);
     SetControl(fseMaxTempPrimary, lMaxTempPrimary, FTemporary.MaxTempPrimary, TRUE);
     SetControl(fseEndTempPrimary, lEndTempPrimary, FTemporary.EndTempPrimary, TRUE);
     SetControl(fseSGEndPrimary, lSGEndPrimary, FTemporary.SGEndPrimary, TRUE);
     SetControl(fseSecondaryTemp, lSecondaryTemp, FTemporary.SecondaryTemp, TRUE);
     SetControl(fseTertiaryTemp, lTertiaryTemp, FTemporary.TertiaryTemp, TRUE);
     SetControl(fseFG, lFG, FTemporary.FG, TRUE);

     //Afvullen, proeven
     SetControl(fseVolumeBottles, lVolumeBottles, FTemporary.VolumeBottles, TRUE);
     SetControl(fseCarbonation, lCarbonation, FTemporary.Carbonation, TRUE);
     SetControl(fseAmountPrimingBottles, lAmountPrimingBottles, FTemporary.AmountPrimingBottles, TRUE);
     SetControl(fseCarbonationTemp, lCarbonationTemp, FTemporary.CarbonationTemp, TRUE);
     SetControl(fseVolumeKegs, lVolumeKegs, FTemporary.VolumeKegs, TRUE);
     SetControl(fseCarbonationKegs, lCarbonationKegs, FTemporary.CarbonationKegs, TRUE);
     SetControl(fseAmountPrimingKegs, lAmountPrimingKegs, FTemporary.AmountPrimingKegs, TRUE);
     SetControl(fseCarbonationTempKegs, lCarbonationTempKegs, FTemporary.CarbonationTempKegs, TRUE);
     SetControl(fsePressureKegs, lPressureKegs, FTemporary.PressureKegs, TRUE);
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.CheckTotal100;
 var variableset : boolean;
     i : integer;
 begin
   variableset:= false;
   if (cbPercentage.Checked) and (FTemporary.NumFermentables > 0) and (FSelected <> FSelCloud)
       and (not FTemporary.Locked.Value) then
   begin
     variableset:= false;
     for i:= 0 to FTemporary.NumFermentables - 1 do
       if FTemporary.Fermentable[i].AdjustToTotal100.Value then variableset:= TRUE;
     if (not variableset) then
     begin
       frmAdjustTotalTo100:= TfrmAdjustTotalTo100.Create(self);
       if FrmAdjustTotalTo100.Execute(FTemporary) then
         FChanged:= TRUE;
       FreeAndNIL(FrmAdjustTotalTo100);
     end;
   end;
 end;

 procedure TfrmMain.Update;
 var s : string;
     St : TBeerStyle;
     i : integer;
     x : double;
     ouc, hch : boolean;
     E : TEquipment;
     yf : TYeastForm;
 begin
   if FSelected <> NIL then
   begin
     hch:= FChanged;
     Screen.Cursor:= crHourglass;
     ouc:= FUserClicked;
     FUserClicked:= false;
     pcRecipe.Visible:= true;
     cbLocked.Checked:= FTemporary.Locked.Value;
     bbInventory.Enabled:= (not FTemporary.InventoryReduced.Value)
                            and (not FTemporary.Locked.Value)
                            and (pcRecipes.ActivePage = tsBrews);
     eName.Text:= FTemporary.Name.Value;
     eNrRecipe.Text:= FTemporary.NrRecipe.Value;
     s:= FTemporary.TypeDisplayName;
     i:= cbType.Items.IndexOf(s);
     cbType.ItemIndex:= i;
     cbEquipment.ItemIndex:= Equipments.IndexByName(FTemporary.Equipment.Name.Value);
     cbBeerStyle.ItemIndex:= BeerStyles.IndexByName(FTemporary.Style.Name.Value);
     sgIngredients.RowCount:= FTemporary.NumIngredients;

     E:= FTemporary.Equipment;
     if cbEquipment.ItemIndex = -1 then
       E:= NIL;
     if (E <> NIL) and (E.KettleVolume.Value > 0) then
     begin
 //      fseBatchSize.MaxValue:= FTemporary.Equipment.KettleVolume.DisplayValue;
 //      FTemporary.BatchSize.MaxValue:= FTemporary.Equipment.KettleVolume.Value;
     end;
     fseTunCm.Value:= 0;
     fseLauterCm.Value:= 0;
     fseKettleCm.Value:= 0;
     gbVolumes.Enabled:= (FTemporary.Equipment <> NIL);
     if E <> NIL then
     begin
       fseTunCm.MaxValue:= FTemporary.Equipment.TunHeight.DisplayValue;
       fseLauterCm.MaxValue:= FTemporary.Equipment.LauterHeight.DisplayValue;
       fseKettleCm.MaxValue:= FTemporary.Equipment.KettleHeight.DisplayValue;
       fseTunVolume.MaxValue:= FTemporary.Equipment.TunVolume.DisplayValue;
       fseKettleVolume.MaxValue:= FTemporary.Equipment.KettleVolume.DisplayValue;
       fseLauterVolume.MaxValue:= FTemporary.Equipment.LauterVolume.DisplayValue;
     end
     else
     begin
       fseTunCm.MaxValue:= 0;
       fseLauterCm.MaxValue:= 0;
       fseKettleCm.MaxValue:= 0;
       fseTunVolume.MaxValue:= 0;
       fseKettleVolume.MaxValue:= 0;
       fseLauterVolume.MaxValue:= 0;
     end;

     fseBatchSize.Value:= FTemporary.BatchSize.DisplayValue;
     fseBoilTime.Value:= FTemporary.BoilTime.DisplayValue;
     fseEfficiency.Value:= FTemporary.Efficiency;
 //    fseBoilSize.Value:= FTemporary.BoilSize.Value;

     if cbPercentage.Checked then
     begin
 //      FTemporary.CalcFermentablesFromPerc(FTemporary.EstOGFermenter.Value);
       if FTemporary.EstOG.Value <= 1.0005 then FTemporary.EstOG.Value:= 1.050;
       FTemporary.CalcFermentablesFromPerc(FTemporary.EstOG.Value);
       fseOG.Value:= FTemporary.EstOG.DisplayValue;
     end
     else
     begin
       FTemporary.RecalcPercentages;
       FTemporary.CalcOG;
 //      fseOG.Value:= FTemporary.EstOGFermenter.Value;
       fseOG.Value:= FTemporary.EstOG.DisplayValue;
     end;
     if (FTemporary.Mash <> NIL) and (FTemporary.Mash.MashStep[0] = NIL)
         and (FTemporary.Equipment <> NIL) then
     begin
       x:= FTemporary.Equipment.MashVolume.DisplayValue;
       fseInfuseAmount.Value:= x;
     end;
     if (FTemporary.Mash <> NIL) and (FTemporary.Mash.MashStep[0] <> NIL) then
     begin
       x:= FTemporary.Mash.MashStep[0].InfuseAmount.DisplayValue;
       fseInfuseAmount.Value:= x;
     end
     else if FTemporary.Water[0] <> NIL then
     begin
       fseInfuseAmount.Value:= FTemporary.Water[0].Amount.DisplayValue;
       if FTemporary.Water[1] <> NIL then
         fseInfuseAmount.Value:= FTemporary.Water[0].Amount.DisplayValue +
                                 FTemporary.Water[1].Amount.DisplayValue;
     end;
     if fseInfuseAmount.Value = 0 then
       fseInfuseAmount.Value:= 0.8 * FTemporary.BatchSize.DisplayValue;

     s:= UnitNames[euro];
     x:= FTemporary.CalcCosts;
     eCosts.Text:= s + ' ' + RealToStrDec(x, 2);

     CalcMash;

     FTemporary.CalcBitterness;
     x:= FTemporary.IBUcalc.Value;
     FUserClicked:= false;
     fseIBU.value:= x;
     FUserClicked:= TRUE;
     eBUGU.Text:= RealToStrDec(FTemporary.BUGU, 2);
     if FTemporary.BUGU < 0.32 then lBUGU.Caption:= ibugu5
     else if FTemporary.BUGU < 0.43 then lBUGU.Caption:= ibugu4
     else if FTemporary.BUGU < 0.52 then lBUGU.Caption:= ibugu3
     else if FTemporary.BUGU < 0.63 then lBUGU.Caption:= ibugu2
     else lBUGU.Caption:= ibugu1;

     FTemporary.CalcColor;
     eColor2.Text:= FTemporary.EstColor.DisplayString;
     eColor2.Color:= SRMtoColor(FTemporary.EstColor.Value);
     if FTemporary.EstColor.Value < 15 then eColor2.Font.Color:= clBlack
     else eColor2.Font.Color:= clWhite;
     eColor2.Invalidate;

     UpdateIngredientsGrid;

     FTemporary.EstimateFG;
     eFGest.Caption:= FTemporary.EstFG.DisplayString;
     eABVest.Caption:= FTemporary.EstABV.DisplayString;

     eFGPredicted.Text:= FTemporary.EstFG2.DisplayString;

     St:= FTemporary.Style;
     if FTemporary.Style <> NIL then
     begin
       x:= FTemporary.EstOG.Value;
       piGravity.Low:= 1000 * (St.OGMin.Value - 1);
       piGravity.Min:= MaxA([0, MinD(800 * (x - 1), 800 * (St.OGMin.Value - 1))]); //0;
       piGravity.High:= 1000 * (St.OGMax.Value - 1);
       piGravity.Value:= 1000 * (x - 1);
       piGravity.Max:= MaxD(1.25 * piGravity.High, 1.1 * piGravity.Value);

       piBitterness.Low:= St.IBUMin.Value;
       piBitterness.Min:= MaxA([0, MinD(0.7 * FTemporary.IBUcalc.Value, 0.7 * St.IBUMin.Value)]);//0;
       piBitterness.High:= St.IBUMax.Value;
       piBitterness.Value:= FTemporary.IBUcalc.Value;
       piBitterness.Max:= MaxD(1.25 * piBitterness.High, 1.1 * piBitterness.Value);

       piBUGU.Low:= St.BUGUmin;
       piBUGU.Min:= 0;
       piBUGU.High:= St.BUGUmax;
       piBUGU.Value:= FTemporary.BUGU;
       piBUGU.Max:= MaxD(1.25 * piBUGU.High, 1.1 * piBUGU.Value);

       piABV.Low:= St.ABVMin.Value;
       piABV.Min:= MaxA([0, MinD(0.8 * St.ABVMin.Value, 0.8 * FTemporary.EstABV.Value)]);//0;
       piABV.High:= St.ABVMax.Value;
       piABV.Value:= FTemporary.EstABV.Value;
       piABV.Max:= MaxD(1.25 * piABV.High, 1.1 * piABV.Value);

       x:= St.ColorMin.Value;
       piColor.Low:= x;
       x:= St.ColorMax.Value;
       piColor.High:= x;
       x:= FTemporary.EstColor.Value;
       piColor.Min:= MaxA([0, MinD(x - 10, piColor.Low - 10)]);
       if piColor.Min < 0 then piColor.Min:= 0;
       piColor.Max:= MaxD(1.1 * piColor.High, 1.1 * x);
       piColor.Value:= x;
     end;

     if (not FTemporary.InventoryReduced.Value) and (FTemporary.Locked.Value) then
       bbInventory.Color:= clFuchsia
     else
       bbInventory.Color:= clDefault;

     FTemporary.Mash.TunWeight.Value:= FTemporary.Equipment.TunWeight.DisplayValue;
     FTemporary.Mash.TunSpecificHeat.Value:= FTemporary.Equipment.TunSpecificHeat.DisplayValue;
     seGrainTemp.Value:= round(FTemporary.Mash.GrainTemp.DisplayValue);
     seTunTemp.Value:= round(FTemporary.Mash.TunTemp.DisplayValue);
     cbTunTemp.Checked:= not FTemporary.Mash.EquipAdjust.Value;
     SetReadOnly(seTunTemp, cbTunTemp.Checked);
     FUserClicked:= false;
     fseTopUpWater.Value:= FTemporary.Equipment.TopUpWater.DisplayValue;
     fseTopUpWater2.Value:= FTemporary.Equipment.TopUpWaterBrewDay.Value;
     fseTopUpWaterChange(self);

     FTemporary.CalcOGFermenter;
     if FTemporary.OGFermenter.Value > 1 then x:= FTemporary.OGFermenter.DisplayValue
     else if FTemporary.OG.Value > 1 then x:= FTemporary.OG.DisplayValue
     else x:= FTemporary.EstOG.DisplayValue;
     eOGFermenter.Text:= RealToStrDec(FTemporary.OGFermenter.DisplayValue, FTemporary.OGFermenter.Decimals) + ' ' +
                                 FTemporary.OGFermenter.DisplayUnitString;
     x:= FTemporary.CalcIBUFermenter;
     eIBUFermenter.Text:= RealToStrDec(x, 0) + ' ' +
                                 FTemporary.IBUcalc.DisplayUnitString;
     x:= FTemporary.CalcColorFermenter;
     if FTemporary.EstColor.DisplayUnit = EBC then
       eColorFermenter.Text:= RealToStrDec(SRMtoEBC(x), 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString
     else
       eColorFermenter.Text:= RealToStrDec(x, 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString;
     eColorFermenter.Color:= SRMtoColor(x);
     if x < 15 then eColorFermenter.Font.Color:= clBlack
     else eColorFermenter.Font.Color:= clWhite;
     eColorFermenter.Invalidate;


     deBrewDate.Date:= FTemporary.Date.Value;
     if FTemporary.PrimaryAge.Value > 1 then
       deTransferDate.Date:= FTemporary.Date.Value + FTemporary.PrimaryAge.value
     else deTransferDate.Date:= 0;
     if FTemporary.SecondaryAge.Value > 1 then
       deLagerDate.Date:= FTemporary.Date.Value + FTemporary.SecondaryAge.value
     else deLagerDate.Date:= 0;
     if FTemporary.DateBottling.Value > 1 then
       deBottleDate.Date:= FTemporary.DateBottling.Value
     else deBottleDate.Date:= 0;

     x:= FTemporary.pHAdjusted.DisplayValue;
     fseMashpH.Value:= x;
     if x <= 2 then fseMashpH.Text:= '';
     x:= FTemporary.SGEndMash.DisplayValue;
     fseSGendmash.Value:= x;
     if x <= 1 then
     begin
       fseSGendMash.Text:= '';
       eEfficiencyMash.Text:= '';
     end
     else
     begin
       x:= FTemporary.CalcMashEfficiency;
       eEfficiencyMash.Text:= RealToStrDec(x, 1) + '%';
     end;

     x:= FTemporary.Mash.pHsparge.DisplayValue;
     fseSpargepH.Value:= x;
     if x <= 2 then fseSpargepH.Text:= '';

     x:= FTemporary.Mash.SpargeTemp.DisplayValue;
     fseSpargeTemp.Value:= x;
     if x < 40 then fseSpargeTemp.Text:= '';
     x:= FTemporary.Mash.pHLastRunnings.DisplayValue;
     fseLastRunningpH.Value:= x;
     if x < 2 then fseLastRunningpH.Text:= '';
     fseLastRunningSG.Value:= FTemporary.Mash.SGLastRunnings.DisplayValue;
     x:= FTemporary.pHBeforeBoil.Value;
     fseBoilpHS.Value:= x;
     if x <= 2 then fseBoilpHS.Text:= '';
     x:= FTemporary.pHAfterBoil.DisplayValue;
     fseBoilpHE.Value:= x;
     if x <= 2 then fseBoilpHE.Text:= '';
     fseBoilSGS.Value:= FTemporary.OGBeforeBoil.DisplayValue;
     fseBoilSGE.Value:= FTemporary.OG.DisplayValue;
     if FTemporary.OGFermenter.Value > 1.000 then
     begin
       fseSG.Value:= FTemporary.OGFermenter.DisplayValue;
       fsePlato.Value:= SGtoPlato(FTemporary.OGFermenter.Value);
       fseBrix.Value:= SGtoBrix(FTemporary.OGFermenter.Value);
     end
     else if FTemporary.OG.Value > 1.000 then
     begin
       fseSG.Value:= FTemporary.OG.DisplayValue;
       fsePlato.Value:= SGtoPlato(FTemporary.OG.Value);
       fseBrix.Value:= SGtoBrix(FTemporary.OG.Value);
     end
     else
     begin
       fseSG2.Value:= 1.000;
       FUserclicked:= TRUE;
       fseSG2Change(self);
       FUserclicked:= false;
       fseSG.Value:= 1;
       fsePlato.Value:= 0;
       fseBrix.Value:= 0;
     end;
     x:= FTemporary.VolumeBeforeBoil.DisplayValue;
     fseBoilVolumeS.Value:= ExpansionFactor * x;
     if x <= 1 then fseBoilVolumeS.Text:= '';
     x:= FTemporary.VolumeAfterBoil.DisplayValue;
     fseBoilVolumeE.Value:= ExpansionFactor * x;
     if x <= 1 then fseBoilVolumeE.Text:= '';
     x:= Convert(FTemporary.EstOG.vUnit, FTemporary.EstOG.DisplayUnit, FTemporary.SGStartBoil);
     eBoilSGSP.Text:= RealToStrDec(x, FTemporary.EstOG.Decimals)
                      + ' ' + FTemporary.EstOG.DisplayUnitString;
     FTemporary.BoilSize.Value:= ExpansionFactor * FTemporary.BoilSize.Value;
     eBoilVolumeSP.Text:= FTemporary.BoilSize.DisplayString;
     FTemporary.BoilSize.Value:= FTemporary.BoilSize.Value / ExpansionFactor;
     x:= FTemporary.CalcOGAfterBoil;
     x:= Convert(FTemporary.EstOG.vUnit, FTemporary.EstOG.DisplayUnit, x);
     eBoilSGEP.Text:= RealToStrDec(x, FTemporary.EstOG.Decimals) + ' ' + FTemporary.EstOG.DisplayUnitString;
     FTemporary.BatchSize.Value:= ExpansionFactor * FTemporary.BatchSize.Value;
     eBoilVolumeEP.Text:= FTemporary.BatchSize.DisplayString;
     FTemporary.BatchSize.Value:= FTemporary.BatchSize.Value / ExpansionFactor;

     x:= FTemporary.CalcEfficiencyBeforeBoil;
     if x > 40 then eEfficiencyS.Text:= RealToStrDec(x, 1) + '%'
     else eEfficiencyS.Text:= '';
     x:= FTemporary.CalcEfficiencyAfterBoil;
     if x > 40 then eEfficiencyE.Text:= RealToStrDec(x, 1) + '%'
     else eEfficiencyE.Text:= '';
     eEfficiencyP.Text:= RealToStrDec(FTemporary.Efficiency, 1) + '%';

     seWhirlPoolTime.Value:= Round(double(FTemporary.WhirlpoolTime.DisplayValue));
     seCoolingTime.Value:= Round(double(FTemporary.CoolingTime.DisplayValue));
     fseCoolingTo.Value:= FTemporary.CoolingTo.DisplayValue;
     cbCoolingMethod.ItemIndex:= cbCoolingMethod.Items.IndexOf(FTemporary.CoolingMethodDisplayName);
     fseTimeAeration.Value:= FTemporary.TimeAeration.DisplayValue;
     fseAerationFlowRate.Value:= FTemporary.AerationFlowRate.DisplayValue;
     cbAerationType.ItemIndex:= cbAerationType.Items.IndexOf(FTemporary.AerationTypeDisplayName);
     fseVolToFermenter.Value:= FTemporary.VolumeFermenter.DisplayValue;
     rxteStartTime.Time:= FTemporary.TimeStarted.Value;
     rxteEndTime.Time:= FTemporary.TimeEnded.Value;

     if FTemporary.Yeast[0] <> NIL then
     begin
       cbYeastAddedAs.Items.Clear;
       cbYeastAddedAs.ItemIndex:= -1;
       case FTemporary.Yeast[0].Form of
       yfDry:
       begin
         cbYeastAddedAs.Items.Add(YeastFormDisplayNames[yfDry]);
         cbYeastAddedAs.Items.Add(YeastFormDisplayNames[yfCulture]);
         s:= FTemporary.Yeast[0].FormDisplayName;
         i:= cbYeastAddedAs.Items.IndexOf(s);
         cbYeastAddedAs.ItemIndex:= i;
       end
       else
         for yf:= Low(YeastFormDisplayNames) to High(YeastFormDisplayNames) do
           if yf <> yfDry then
             cbYeastAddedAs.Items.Add(YeastFormDisplayNames[yf]);
         cbYeastAddedAs.ItemIndex:= cbYeastAddedAs.Items.IndexOf(FTemporary.Yeast[0].FormDisplayName);
       end;
       cbStarterMade.Checked:= FTemporary.Yeast[0].StarterMade.Value;
       cbStarterType.ItemIndex:= cbStarterType.Items.IndexOf(FTemporary.Yeast[0].StarterTypeDisplayName);
       case FTemporary.Yeast[0].StarterType of
       stSimple, stAerated: lTimeAerated.Caption:= starteraerationtime1;
       stStirred: lTimeAerated.Caption:= starteraerationtime2;
       end;
       fseStarterTimeAerated.Value:= FTemporary.Yeast[0].TimeAerated.DisplayValue;
       fseSGStarter.Value:= FTemporary.Yeast[0].OGStarter.DisplayValue;
       fseTempStarter.Value:= FTemporary.Yeast[0].Temperature.DisplayValue;
       fseStarterVolume1.Value:= FTemporary.Yeast[0].StarterVolume1.DisplayValue;
       if not cbStarterMade.Checked then
       begin
         fseStarterVolume1.Value:= 0;
         FTemporary.Yeast[0].StarterVolume1.Value:= 0;
       end;
       fseStarterVolume2.Value:= FTemporary.Yeast[0].StarterVolume2.DisplayValue;
       fseStarterVolume3.Value:= FTemporary.Yeast[0].StarterVolume3.DisplayValue;
       FUserClicked:= TRUE;
       fseStarterVolume1Change(self);
       FUserClicked:= false;
       SetControl(fseAmountYeast, lAmountYeast, FTemporary.Yeast[0].AmountYeast, TRUE);
     end
     else
     begin
       cbYeastAddedAs.ItemIndex:= -1;
       cbStarterMade.Checked:= false;
       cbStarterType.ItemIndex:= -1;
       fseStarterTimeAerated.Value:= 0;
       fseSGStarter.Value:= 1.04;
       fseTempStarter.Value:= 20;
       fseStarterVolume1.Value:= 0;
       fseAmountYeast.Value:= 0;
     end;
     SetAmountCells;

     fseStartTempPrimary.Value:= FTemporary.StartTempPrimary.DisplayValue;
     fseMaxTempPrimary.Value:= FTemporary.MaxTempPrimary.DisplayValue;
     fseEndTempPrimary.Value:= FTemporary.EndTempPrimary.DisplayValue;
     fseSGEndPrimary.Value:= FTemporary.SGEndPrimary.DisplayValue;
     eAAEndPrimary.Caption:= RealToStrDec(FTemporary.AAEndPrimary, 1) + '%';
     if FTemporary.SGEndPrimary.Value >= FTemporary.SGEndPrimary.MinValue then
     begin
       fseSG2.Value:= FTemporary.SGEndPrimary.DisplayValue;
       FUserclicked:= TRUE;
       fseSG2Change(self);
       FUserclicked:= false;
     end
     else
     begin
       fseSG2.Value:= 1.000;
       FUserclicked:= TRUE;
       fseSG2Change(self);
       FUserclicked:= false;
     end;
     eAAEndPrimary.Caption:= RealToStrDec(FTemporary.AAEndPrimary, 1) + '%';
     eAA.Caption:= RealToStrDec(FTemporary.ApparentAttenuation, 1) + '%';
     eRA.Caption:= RealToStrDec(FTemporary.RealAttenuation, 1) + '%';
     fseSecondaryTemp.Value:= FTemporary.SecondaryTemp.DisplayValue;
     fseTertiaryTemp.Value:= FTemporary.TertiaryTemp.DisplayValue;
     fseFG.Value:= FTemporary.FG.DisplayValue;
     FTemporary.ABVcalc.Value:= ABVol(FTemporary.CalcOGFermenter, FTemporary.FG.Value);
     eABV.Text:= FTemporary.ABVcalc.DisplayString;
     FTemporary.CalcCalories;
     eCalories.Text:= FTemporary.Calories.DisplayString;
     if FTemporary.FG.Value > FTemporary.FG.MinValue then
     begin
       fseSG2.Value:= FTemporary.FG.DisplayValue;
       FUserclicked:= TRUE;
       fseSG2Change(self);
       FUserclicked:= false;
     end;
     piABV2.Value:= FTemporary.EstFG.DisplayValue;
     piABV2.Low:= FTemporary.Style.ABVMin.DisplayValue;
     piABV2.High:= FTemporary.Style.ABVMax.DisplayValue;
     piABV2.Value:= FTemporary.ABVCalc.DisplayValue;
     piABV2.Max:= MaxD(FTemporary.Style.ABVMax.DisplayValue, FTemporary.ABVCalc.DisplayValue) + 2;

     eCO2Style.Text:= FTemporary.Style.CarbMin.DisplayString + ' - ' + FTemporary.Style.CarbMax.DisplayString;
     fseVolumeBottles.Value:= FTemporary.VolumeBottles.DisplayValue;
     fseCarbonation.Value:= FTemporary.Carbonation.DisplayValue;
     fseAmountPrimingBottles.Value:= FTemporary.AmountPrimingBottles.DisplayValue;
     eTotAmBottles.Text:= RealToStrDec(FTemporary.VolumeBottles.DisplayValue *  FTemporary.AmountPrimingBottles.DisplayValue, 1);
     eABVBottles.Text:= RealToStrDec(FTemporary.ABVcalc.Value +
                                     FTemporary.AmountPrimingBottles.Value * 0.47 / 7.907,
                                     1) + ' vol.%';
     fseCarbonationTemp.Value:= FTemporary.CarbonationTemp.DisplayValue;

     fseVolumeKegs.Value:= FTemporary.VolumeKegs.DisplayValue;
     fseCarbonationKegs.Value:= FTemporary.CarbonationKegs.DisplayValue;
     fseAmountPrimingKegs.Value:= FTemporary.AmountPrimingKegs.DisplayValue;
     eTotAmKegs.Text:= RealToStrDec(FTemporary.VolumeKegs.DisplayValue *  FTemporary.AmountPrimingKegs.DisplayValue, 1);
     lTotAmKegs.Caption:= 'g';
     if FTemporary.ForcedCarbonationKegs.Value then
       x:= 0
     else
       x:= FTemporary.AmountPrimingKegs.Value * 0.47 / 7.907;
     cbForcedCarbonation.Checked:= FTemporary.ForcedCarbonationKegs.Value;
     SetReadOnly(fseAmountPrimingKegs, cbForcedCarbonation.Checked);
     SetReadOnly(fsePressureKegs, not cbForcedCarbonation.Checked);
     fseCarbonationTempKegs.Value:= FTemporary.CarbonationTempKegs.DisplayValue;
     eABVKegs.Text:= RealToStrDec(FTemporary.ABVcalc.Value + x, 1) + ' vol.%';
     {piCarbBottles.Low:= FTemporary.Style.CarbMin.Value;
     piCarbBottles.Min:= 0;
     piCarbBottles.High:= FTemporary.Style.CarbMax.Value;
     piCarbBottles.Max:= 1.1 * piCarbBottles.High;
     piCarbBottles.Value:= FTemporary.Carbonation.Value;

     piCarbKegs.Low:= FTemporary.Style.CarbMin.Value;
     piCarbKegs.Min:= 0;
     piCarbKegs.High:= FTemporary.Style.CarbMax.Value;
     piCarbKegs.Max:= 1.1 * piCarbKegs.High;
     piCarbKegs.Value:= FTemporary.CarbonationKegs.Value;}

     cbPrimingSugarBottles.ItemIndex:= cbPrimingSugarBottles.Items.IndexOf(FTemporary.PrimingSugarBottlesDisplayName);
     cbPrimingSugarKegs.ItemIndex:= cbPrimingSugarKegs.Items.IndexOf(FTemporary.PrimingSugarKegsDisplayName);
     fseCarbonationChange(self);
     fseCarbonationKegsChange(self);
     deTasteDate.Date:= FTemporary.TasteDate.Value;
     eColor.Text:= FTemporary.TasteColor.Value;
     eTransparency.Text:= FTemporary.TasteTransparency.Value;
     eHead.Text:= FTemporary.TasteHead.Value;
     eAroma.Text:= FTemporary.TasteAroma.Value;
     eTaste.Text:= FTemporary.TasteTaste.Value;
     eAftertaste.Text:= FTemporary.TasteAftertaste.Value;
     fseAgeTemp.Value:= FTemporary.AgeTemp.DisplayValue;
     eMouthfeel.Text:= FTemporary.TasteMouthfeel.Value;
     eTasteNotes.Text:= FTemporary.TasteNotes.Value;
     fseTastingRate.Value:= FTemporary.TastingRate.Value;

     eBrewer.Text:= FTemporary.Brewer.Value;
     eAssistantBrewer.Text:= FTemporary.AsstBrewer.Value;
     mNotes.Text:= FTemporary.Notes.Value;

     s:= FSelected.ParentAutoNr.Value;
     if s <> '' then
     begin
       s:= RightStr(s, Length(s) - 1);
       i:= StrToInt(s);
     end
     else i:= 0;
     if pcRecipes.ActivePage = tsBrews then
     begin
       miFindParentRecipe.Enabled:= ((s <> '') and (Recipes.FindByAutoNr(i) <> NIL));
     end
     else
     begin
       miFindParentBrew.Enabled:= ((s <> '') and (Brews.FindByAutoNr(i) <> NIL));
     end;

     cbLocked.Checked:= FTemporary.Locked.Value;
     FChanged:= false;
     cbLockedClick(NIL);
     FChanged:= hch;
     FUserClicked:= ouc;
     Screen.Cursor:= crDefault;
   end
   else
   begin
//     pcRecipe.Visible:= false; // JR comment
     miFindParentRecipe.Enabled:= false;
     miFindParentBrew.Enabled:= false;
   end;
 end;

 Procedure TfrmMain.UpdatePredictions;
 begin
   mPredictions.Lines.Clear;
   if (FTemporary <> NIL) and (FSelBrew <> NIL) and (pcRecipes.ActivePage = tsBrews) then
   begin
     //BHNNs.GetPrediction(FTemporary, mPredictions);
     mroPredictions.Visible:= (mPredictions.Lines.Count > 0);
   end
   else
     mroPredictions.Visible:= false;
 end;

 procedure TfrmMain.Store;
 begin
   if (FSelected <> NIL) then
   begin
     FTemporary.Locked.Value:= cbLocked.Checked;
     if not FTemporary.Locked.Value then
     begin
       FTemporary.Name.Value:= eName.Text;
       FTemporary.NrRecipe.Value:= eNrRecipe.Text;
       if cbType.ItemIndex > -1 then
         FTemporary.TypeDisplayName:= cbType.Items[cbType.ItemIndex];
 {      if cbColorMethod.ItemIndex > -1 then
         FTemporary.ColorMethodDisplayName:= cbColorMethod.Items[cbColorMethod.ItemIndex];
       if cbIBUMethod.ItemIndex > -1 then
         FTemporary.IBUMethodDisplayName:= cbIBUMethod.Items[cbIBUMethod.ItemIndex];}
     end;
   end;
 end;

 procedure TfrmMain.hcIngredientsSectionResize(
   HeaderControl: TCustomHeaderControl; Section: THeaderSection);
 var i : integer;
 begin
   for i:= 0 to 4 do
     sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
 end;

{ AskToSave
  Will ask the user if their changes should be saved.

  Returns:
  TRUE - User answered YES or NO
  FALSE - User answered with CANCEL

}
 Function TfrmMain.AskToSave : Boolean;
 begin
   if (FChanged) and (not FTemporary.Locked.Value) then
   begin
     if Settings.ConfirmSave.Value then
     begin
       //if Question(self, savechanges2) then
       case (MessageDlg(savechanges2, mtConfirmation,
             [mbYes, mbNo, mbCancel], 0)) of
       mrYes:  // YES please save changes
         begin
           Screen.Cursor:= crHourglass;
           Cursor:= crHourglass;
           Application.ProcessMessages;

           if FSelected <> NIL then
           begin
             Store;
             FSelected.Assign(FTemporary);
           end;
           FChanged:= false;
          { if FLabel.Changed then
             FLabel.Save;}
           Brews.SaveXML;
           Recipes.SaveXML;
           Screen.Cursor:= crDefault;
           Cursor:= crDefault;
           result := true;
         end;
       mrNo: // NO, thanks, please continue
       begin
         FChanged:= false;
         result := true;
       end;
       mrCancel: // CANCEL, break off procedure
         result := false;
     end
     end
     else
     begin
       Screen.Cursor:= crHourglass;
       Cursor:= crHourglass;
       Application.ProcessMessages;

       if FSelected <> NIL then
       begin
         Store;
         FSelected.Assign(FTemporary);
       end;
       FChanged:= false;
      { if FLabel.Changed then
         FLabel.Save;}
       Brews.SaveXML;
       Recipes.SaveXML;
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
       result:=true;
     end;
   end else result := true;
 end;

 {======================== Full Screen mode ====================================}

 procedure TfrmMain.aFullScreenExecute(Sender: TObject);
 begin
   SwitchFullScreen;
 end;

 Procedure TfrmMain.SwitchFullScreen;
 begin
   if BorderStyle <> bsNone then begin
     // To full screen
     OriginalWindowState := WindowState;
     OriginalBounds := BoundsRect;

     BorderStyle := bsNone;
     ScreenBounds := Screen.MonitorFromWindow(Handle).BoundsRect;
     with ScreenBounds do
       SetBounds(Left, Top, Right - Left, Bottom - Top) ;
   end else begin
     // From full screen
     {$IFDEF MSWINDOWS}
     BorderStyle := bsSizeable;
     {$ENDIF}
     if OriginalWindowState = wsMaximized then
       WindowState := wsMaximized
     else
       with OriginalBounds do
         SetBounds(Left, Top, Right - Left, Bottom - Top) ;
     {$IFDEF LINUX}
     BorderStyle := bsSizeable;
     {$ENDIF}
   end;
 end;

 {==========================  File  ============================================}

 procedure TfrmMain.tbSaveClick(Sender: TObject);
 begin
   Screen.Cursor:= crHourglass;
   Cursor:= crHourglass;
   Application.ProcessMessages;
   if (FSelected <> NIL) then
   begin
     Store;
     FSelected.Assign(FTemporary);
     FChanged:= false;
   end;
  { if FLabel.Changed then
     FLabel.Save;}
   Brews.SaveXML;
   Application.ProcessMessages;
   Recipes.SaveXML;
   Screen.Cursor:= crDefault;
   Cursor:= crDefault;
 end;

 procedure TfrmMain.tbImportClick(Sender: TObject);
 begin
   FrmImport:= TFrmImport.Create(self);
   if FrmImport.Execute then
   begin
     FrmImport.Visible:= false;

     if FrmImport.Destination = dRecipes then
     begin
       if Recipes.ImportFiles(FrmImport.Files, FrmImport.DirName,
                             FrmImport.Equipment{, FrmImport.FileType}) then
         cbRecipesSortChange(self);
     end
     else
     begin
       if Brews.ImportFiles(FrmImport.Files, FrmImport.DirName,
                         FrmImport.Equipment{, FrmImport.FileType}) then
         cbBrewsSortChange(self);
     end;
   end;
   FrmImport.Free;
 end;

 procedure TfrmMain.tbExportClick(Sender: TObject);
 var dlg : TSaveDialog;
     Doc : TXMLDocument;
     RootNode : TDOMNode;
     s : string;
     tops : TOpenOptions;
 begin
   if FSelected <> NIL then
   begin
     try
       s:= FTemporary.NrRecipe.Value + ' ' + FTemporary.Name.Value;
       dlg:= TSaveDialog.Create(frmMain);
       Doc:= NIL;
       with dlg do
       begin
         tops:= Options;
         Include(tops, ofOverwritePrompt);
         Options:= tops;
         DefaultExt:= '.xml';
         FileName:= s + '.xml';
         Filter:= exportfilter1;
       end;
       if (dlg.Execute) and (dlg.FileName <> '') then
       begin
         s:= LowerCase(ExtractFileExt(dlg.fileName));
         if (dlg.FilterIndex = 1) then
         begin
           Doc := TXMLDocument.Create;
           RootNode := Doc.CreateElement('RECIPES');
           Doc.Appendchild(RootNode);
           FTemporary.SaveXML(Doc, RootNode, false);
           writeXMLFile(Doc, dlg.FileName);
         end
         else if (dlg.FilterIndex = 2) then
         begin
           Doc := TXMLDocument.Create;
           RootNode := Doc.CreateElement('RECIPES');
           Doc.Appendchild(RootNode);
           FTemporary.SaveXML(Doc, RootNode, TRUE);
           writeXMLFile(Doc, dlg.FileName);
         end
         else if (dlg.FilterIndex = 3) or (s = '.html') or (s = '.htm') then
         begin
           if FTemporary.SaveHTML(dlg.FileName) then
             ShowNotification(self, exportsucces1);
         end;
       end;
     finally
       dlg.Free;
       FreeAndNIL(Doc);
     end;
   end;
 end;

 procedure TfrmMain.tbCopyClipboardClick(Sender: TObject);
 begin
   if FSelected <> NIL then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if FTemporary.CopyToClipboardForumFormat then
       ShowNotification(self, copysucces1);
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
   end;
 end;

 procedure TfrmMain.tbCopyHTMLClick(Sender: TObject);
 begin
   if FSelected <> NIL then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if FTemporary.CopyToClipboardHTML then
       ShowNotification(self, copysucces1);
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
   end;
 end;

 procedure TfrmMain.tbBrewsListClick(Sender: TObject);
 var Doc : TBHRDocument;
 begin
   try
     frmChooseBrewsList:= TfrmChooseBrewsList.Create(self);
     if frmChooseBrewsList.Execute > -1 then
     begin
       Screen.Cursor:= crHourglass;
       Cursor:= crHourglass;
       Application.ProcessMessages;

       Doc:= TBHRDocument.Create;
       if CreateBrewsList(Doc, frmChooseBrewsList.StartDate, frmChooseBrewsList.EndDate,
                          frmChooseBrewsList.StartNR, frmChooseBrewsList.EndNR) then
       begin
         Screen.Cursor:= crDefault;
         Cursor:= crDefault;
         Doc.PrintPreview;
       end
       else Doc.Free;
       Doc:= NIL; //Doc is freed automatically after PrintPreview form closes;
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
     end;
   finally
     frmChooseBrewsList.Free;
   end;
 end;

 procedure TfrmMain.tbPrintPreviewClick(Sender: TObject);
 var Doc : TBHRDocument;
     RT : TRecType;
 begin
   Screen.Cursor:= crHourglass;
   Cursor:= crHourglass;
   Application.ProcessMessages;

   if pcRecipes.ActivePage = tsBrews then
     RT:= rtBrew
   else
     RT:= rtRecipe;

   Doc:= TBHRDocument.Create;
   if CreateLogbook(Doc, FTemporary, RT) then
   begin
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
     Doc.PrintPreview
   end
   else Doc.Free;
   Doc:= NIL; //Doc is freed automatically after PrintPreview form closes;
   Screen.Cursor:= crDefault;
   Cursor:= crDefault;
 end;

 //JR: Event not connected to anything, apparently never called.
 //procedure TfrmMain.tbPrintClick(Sender: TObject);
 //
 // var st, en, num : integer;
 //     Doc : TBHRDocument;
 //     RT : TRecType;
 //
 //begin
 //
 //   try
 //     if pcRecipes.ActivePage = tsBrews then
 //       RT:= rtBrew
 //     else
 //       RT:= rtRecipe;
 //
 //     Doc:= TBHRDocument.Create;
 //     if CreateLogbook(Doc, FTemporary, RT) then
 //     begin
 //       pdPrint.MinPage:= 1;
 //       pdPrint.MaxPage:= Doc.NumPages;
 //       pdPrint.FromPage:= 1;
 //       pdPrint.ToPage:= Doc.NumPages;
 //       if pdPrint.Execute then
 //       begin
 //         if pdPrint.PrintRange = prAllPages then
 //         begin
 //           st:= 1;
 //           en:= Doc.NumPages;
 //         end
 //         else if pdPrint.PrintRange = prCurrentPage then
 //         begin
 //           st:= 1;
 //           en:= 1;
 //         end
 //         else if pdPrint.PrintRange = prPageNums then
 //         begin
 //           st:= pdPrint.FromPage;
 //           en:= pdPrint.ToPage;
 //         end;
 //         num:= pdPrint.Copies;
 //         Doc.Repaginate;
 //         Doc.Print(st, en, num);
 //       end;
 //     end;
 //   finally
 //     Doc.Free;
 //   end;
 //
 //end;

 procedure TfrmMain.tbInfoClick(Sender: TObject);
 begin

    frmInfo:= TfrmInfo.Create(self);
    frmInfo.Execute;
    frmInfo.Free;

 end;

 procedure TfrmMain.tbHelpClick(Sender: TObject);
 var FN : string;
 begin
   FN:= Settings.DataLocation.Value + manualname1;
   OpenDocument(FN);
 end;

procedure TfrmMain.tvBrewsChanging(Sender: TObject; Node: TTreeNode;
  var AllowChange: Boolean);
    procedure UpdateTheList(selectedRecipe: TTreeNode);
     var i : integer;
     begin
         pcAnalysis.Visible:= false;
         sgIngredients.Editor:= NIL;
         FSelBrew:= NIL;
         FSelIngredient:= NIL;

         case cbBrewsSort.ItemIndex of
         0: bbRemoveBrew.Enabled:= ((selectedRecipe <> NIL) and (selectedRecipe.Level = 1));
         1, 2: bbRemoveBrew.Enabled:= ((selectedRecipe <> NIL) and (selectedRecipe.Level = 3));
         end;
         miBrewsDelete.Enabled:= bbRemoveBrew.Enabled;
         miDivideBrew.Enabled:= bbRemoveBrew.Enabled;

         if (selectedRecipe <> NIL) and (selectedRecipe.Data <> NIL) then
           FSelBrew:= TRecipe(selectedRecipe.Data);
         FSelected:= FSelBrew;
         if FSelected <> NIL then
         begin
           FTemporary.Assign(FSelected);
           FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
           pmBrews.Items[1].Enabled:= TRUE;
           pmBrews.Items[3].Enabled:= TRUE;
           pmBrews.Items[4].Enabled:= TRUE;
           pmBrews.Items[6].Enabled:= TRUE;
           pmBrews.Items[9].Enabled:= TRUE;
           pmBrews.Items[11].Enabled:= TRUE;
           pcAnalysis.Visible:= false;
           Self.Caption:=Application.Name + ' - ' + FTemporary.Name.Value;
         end else begin
           pmBrews.Items[1].Enabled:= false;
           pmBrews.Items[3].Enabled:= false;
           pmBrews.Items[4].Enabled:= false;
           pmBrews.Items[6].Enabled:= false;
           pmBrews.Items[9].Enabled:= false;
           pmBrews.Items[11].Enabled:= false;
           FillAnalyseCharts;
           Self.Caption:=Application.Name;
         end;
         pcRecipe.Visible:= (FSelBrew <> NIL);
         sgIngredients.Row:= 0;
         if cbPercentage.Checked then
         begin
       //    FTemporary.CalcOG;
       //    fseOG.Value:= FTemporary.EstOGFermenter.Value;
           fseOG.Value:= FTemporary.EstOG.Value;
         end;
         Update;
         UpdateGraph;
         UpdatePredictions;
         if FSelected <> NIL then
           if sgIngredients.RowCount > 0 then
           begin
             sgIngredients.Col:= 1;
             sgIngredients.Row:= 0;
           end;
         if sgMashSteps.RowCount > 0 then
           for i:= 0 to sgMashSteps.ColCount - 1 do
             sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
         cbMash.ItemIndex:= -1;
         FMashStep:= -1;
         bbStartMash.Caption:= startmash1;
         NameChange;
         PreviousBrew := tvBrews.Selected;
       end;
 begin
   AllowChange := true;
   FUserClicked := false;
   if FSelected <> NIL then
     Store;

   //JR: if (FChanged), ask user whether recipe should be saved
   if not FChanged or (AskToSave) then
   begin
     // User answered YES or NO, or recipe was not changed.
     // We can continue.
      UpdateTheList(Node);
   end else begin
     // User CANCELED, so we should not change the selection.
     // Recipe-screen doesn't need to be refreshed, since no new recipe
     // is selected.
     AllowChange := false;
   end;
   FUserClicked:= true; // Reset FUserClicked
end;

 procedure TfrmMain.tbSynchronizeClick(Sender: TObject);
 begin
   //AskToSave;
   ////frmFTPList:= TfrmFTPList.Create(self);
   ////frmFTPList.ShowModal;
   ////frmFTPList.Free;
   ////reload database files
   //Screen.Cursor:= crHourglass;
   //Settings.Save;
   //FUserClicked:= false;
   //Reload;
   ////refresh the data
   //FChanged:= false;
   //cbRecipesSortChange(self);
   //cbBrewsSortChange(self);
   //NameChange;
   //Screen.Cursor:= crDefault;
 end;

 procedure TfrmMain.tbExitClick(Sender: TObject);
 begin
   Close;
 end;

 {===========================  Databases  ======================================}

 procedure TfrmMain.tbFermentablespClick(Sender: TObject);
 begin

    FrmFermentables:= TFrmFermentables.Create(self);

    if FrmFermentables.ShowModal = mrOK then
    begin
      Fermentables.SaveXML;
      UpdateIngredientsgrid;
      if Settings.ShowPossibleWithStock.Value then
      begin
        cbBrewsSortChange(self);
        cbRecipesSortChange(self);
        pcRecipe.Visible:= ((pcRecipes.ActivePage = tsBrews) and (FSelBrew <> NIL)) or
                           ((pcRecipes.ActivePage = tsRecipes) and (FSelRecipe <> NIL));
      end;
    end
    else
    begin
      Fermentables.Free;
      Fermentables:= TFermentables.Create;
      Fermentables.ReadXML;
    end;
    FrmFermentables.Free;

 end;


 procedure TfrmMain.tbHopsClick(Sender: TObject);
 begin

    FrmHop:= TFrmHop.Create(self);

    if FrmHop.ShowModal = mrOK then
    begin
      Hops.SaveXML;
      UpdateIngredientsgrid;
      if Settings.ShowPossibleWithStock.Value then
      begin
        cbBrewsSortChange(self);
        cbRecipesSortChange(self);
        pcRecipe.Visible:= ((pcRecipes.ActivePage = tsBrews) and (FSelBrew <> NIL)) or
                           ((pcRecipes.ActivePage = tsRecipes) and (FSelRecipe <> NIL));
      end;
    end
    else
    begin
      Hops.Free;
      Hops:= THops.Create;
      Hops.ReadXML;
    end;
    FrmHop.Free;

 end;

 procedure TfrmMain.tbYeastsClick(Sender: TObject);
 begin
    FrmYeasts:= TFrmYeasts.Create(self);

    if FrmYeasts.ShowModal = mrOK then
    begin
      Yeasts.SaveXML;
      UpdateIngredientsgrid;
      if Settings.ShowPossibleWithStock.Value then
      begin
        cbBrewsSortChange(self);
        cbRecipesSortChange(self);
        pcRecipe.Visible:= ((pcRecipes.ActivePage = tsBrews) and (FSelBrew <> NIL)) or
                           ((pcRecipes.ActivePage = tsRecipes) and (FSelRecipe <> NIL));
      end;
    end
    else
    begin
      Yeasts.Free;
      Yeasts:= TYeasts.Create;
      Yeasts.ReadXML;
    end;
    FrmYeasts.Free;
 end;

 procedure TfrmMain.tbMiscClick(Sender: TObject);
 begin
    FrmMiscs:= TFrmMiscs.Create(self);

    if FrmMiscs.ShowModal = mrOK then
    begin
      Miscs.SaveXML;
      UpdateIngredientsgrid;
      if Settings.ShowPossibleWithStock.Value then
      begin
        cbBrewsSortChange(self);
        cbRecipesSortChange(self);
        pcRecipe.Visible:= ((pcRecipes.ActivePage = tsBrews) and (FSelBrew <> NIL)) or
                           ((pcRecipes.ActivePage = tsRecipes) and (FSelRecipe <> NIL));
      end;
    end
    else
    begin
      Miscs.Free;
      Miscs:= TMiscs.Create;
      Miscs.ReadXML;
    end;
    FrmMiscs.Free;
 end;

 procedure TfrmMain.tbWatersClick(Sender: TObject);
 begin
    FrmWaters:= TFrmWaters.Create(self);

    if FrmWaters.ShowModal = mrOK then
      Waters.SaveXML
    else
    begin
      Waters.Free;
      Waters:= TWaters.Create;
      Waters.ReadXML;
    end;
    FrmWaters.Free;
 end;
 procedure TfrmMain.tbMashClick(Sender: TObject);
 var i : integer;
 begin
    FrmMashs:= TFrmMashs.Create(self);

    if FrmMashs.ShowModal = mrOK then
    begin
      Mashs.SaveXML;
      Mashs.SortByName('Naam');
      cbMash.Items.Clear;
      for i:= 0 to Mashs.NumItems - 1 do
        cbMash.Items.Add(Mashs.Item[i].Name.Value);
      cbMash.ItemIndex:= -1;
    end
    else
    begin
      Mashs.Free;
      Mashs:= TMashs.Create;
      Mashs.ReadXML;
    end;
    FrmMashs.Free;
 end;

procedure TfrmMain.tbEquipmentClick(Sender: TObject);
 var i : integer;
 begin
    FrmEquipments:= TFrmEquipments.Create(self);

    if FrmEquipments.ShowModal = mrOK then
    begin
      Equipments.SaveXML;
      cbEquipment.Items.Clear;
      for i:= 0 to Equipments.NumItems - 1 do
        cbEquipment.Items.Add(TEquipment(Equipments.Item[i]).Name.Value);
      if FSelected <> NIL then
        cbEquipment.ItemIndex:= Equipments.IndexByName(FTemporary.Equipment.Name.Value)
      else
        cbEquipment.ItemIndex:= 0;
    end
    else
    begin
      Equipments.Free;
      Equipments:= TEquipments.Create;
      Equipments.ReadXML;
    end;
    FrmEquipments.Free;
 end;

procedure TfrmMain.tbBeerstylesClick(Sender: TObject);
 var i : integer;
 begin
    FrmBeerStyles:= TFrmBeerStyles.Create(self);

    if FrmBeerStyles.ShowModal = mrOK then
    begin
      BeerStyles.SortByIndex2(5, 0, false);
      BeerStyles.SaveXML;
      cbBeerStyle.Items.Clear;
      BeerStyles.SortByIndex2(5, 0, false);
      for i:= 0 to BeerStyles.NumItems - 1 do
         cbBeerStyle.Items.Add(TBeerStyle(BeerStyles.Item[i]).StyleLetter.Value + ' - ' +
                               TBeerStyle(BeerStyles.Item[i]).Name.Value);
      if FSelected <> NIL then
        cbBeerStyle.ItemIndex:= BeerStyles.IndexByName(FTemporary.Style.Name.Value)
      else
        cbBeerStyle.ItemIndex:= 0;
    end
    else
    begin
      BeerStyles.Free;
      BeerStyles:= TBeerStyles.Create;
      BeerStyles.ReadXML;
    end;
    FrmBeerStyles.Free;
 end;

 procedure TfrmMain.miCheckPrintClick(Sender: TObject);
 var Doc : TBHRDocument;
 begin

    Screen.Cursor:= crHourglass;
    Cursor:= crHourglass;
    Application.ProcessMessages;

    FTemporary.CheckList.CreateCheckList;
    Doc:= TBHRDocument.Create;
    if CreateCheckList(Doc, FTemporary) then
    begin
      Screen.Cursor:= crDefault;
      Cursor:= crDefault;
      Doc.PrintPreview;
    end
    else Doc.Free;
    Doc:= NIL; //Doc is freed automatically after PrintPreview form closes;

 end;

 procedure TfrmMain.miCheckWindowClick(Sender: TObject);
 begin
    if (FTemporary <> NIL) and (FTemporary.RecType = rtBrew) then
    begin
      FTemporary.CheckList.CreateCheckList;
      FrmCheckList:= TFrmChecklist.Create(self);
      FrmChecklist.Execute(FTemporary);

   end;
 end;

 procedure TfrmMain.tbInventoryListClick(Sender: TObject);
 var Doc : TBHRDocument;
 begin
   Screen.Cursor:= crHourglass;
   Cursor:= crHourglass;
   Application.ProcessMessages;


    Doc:= TBHRDocument.Create;
    if CreateStockList(Doc) then
    begin
      Screen.Cursor:= crDefault;
      Cursor:= crDefault;
      Doc.PrintPreview;
    end
    else Doc.Free;
    Doc:= NIL; //Doc is freed automatically after PrintPreview form closes;

 end;

 procedure TfrmMain.tbBackupClick(Sender: TObject);
 begin
   screen.Cursor:= crHourglass;
   Backup;
   screen.Cursor:= crDefault;
 end;

 procedure TfrmMain.tbRestoreClick(Sender: TObject);
// var DBlocation : string;
 begin
//   DBlocation:= BHFolder;
   sddBackup.InitialDir:= BHFolder;
   sddBackup.Title:= choosebackupfolder1;
   sddBackup.Filter:= 'backup-*';
   if sddBackup.Execute then
   begin
     screen.Cursor:= crHourglass;
     Restore(sddBackup.FileName + Slash);
     //refresh the data
     FChanged:= false;
     cbRecipesSortChange(self);
     cbBrewsSortChange(self);
     //cbCloudSortChange(self);
     screen.Cursor:= crDefault;
   end;
 end;

 procedure TfrmMain.tbRestoreOriginalClick(Sender: TObject);
 begin
    FrmRestoreDatabase:= TFrmRestoreDatabase.Create(self);
    if FrmRestoreDatabase.Execute then
    begin
      //refresh the data
      FChanged:= false;
      screen.Cursor:= crHourglass;
      cbRecipesSortChange(self);
      cbBrewsSortChange(self);
      screen.Cursor:= crDefault;
    end;
    FrmRestoreDatabase.Free;
 end;

 procedure TfrmMain.tbFermChartClick(Sender: TObject);
 begin

    FrmHopGraph:= TFrmHopGraph.Create(self);
    FrmHopGraph.Caption:= fermentableschart1;
    FrmHopGraph.Execute(0);
    FreeAndNIL(FrmHopGraph);

 end;

 procedure TfrmMain.tbHopChartClick(Sender: TObject);
 begin

    FrmHopGraph:= TFrmHopGraph.Create(self);
    FrmHopGraph.Caption:= hopchart1;
    FrmHopGraph.Execute(1);
    FreeAndNIL(FrmHopGraph);

 end;

 procedure TfrmMain.tbYeastChartClick(Sender: TObject);
 begin

    FrmHopGraph:= TFrmHopGraph.Create(self);
    FrmHopGraph.Caption:= yeastchart1;
    FrmHopGraph.Execute(2);
    FreeAndNIL(FrmHopGraph);

 end;

 procedure TfrmMain.tbWaterChartClick(Sender: TObject);
 begin

    FrmHopGraph:= TFrmHopGraph.Create(self);
    FrmHopGraph.Caption:= waterchart1;
    FrmHopGraph.Execute(3);

 end;

 procedure TfrmMain.tbChartClick(Sender: TObject);
 begin

    //FrmAnalysis:= TFrmAnalysis.Create(self);
    //FrmAnalysis.Execute;

 end;

 procedure TfrmMain.tbHistogramClick(Sender: TObject);
 begin

    //FrmHistogram:= TFrmHistogram.Create(self);
    //FrmHistogram.Execute;

 end;

 procedure TfrmMain.tbTrainNNClick(Sender: TObject);
 begin

    //FrmNN:= TFrmNN.Create(self);
    //FrmNN.Execute;
    //FrmNN.Free;

 end;

 {==========================  Settings  ========================================}

 procedure TfrmMain.cbColorMethodChange(Sender: TObject);
 var i : integer;
 begin
   FUserclicked:= false;
   Settings.ColorMethod.Value:= cbColorMethod.Items[cbColormethod.ItemIndex];
   Settings.Save;
   for i:= 0 to Brews.NumItems - 1 do
     TRecipe(Brews.Item[i]).ColormethodDisplayName:= Settings.ColorMethod.Value;
   for i:= 0 to Recipes.NumItems - 1 do
     TRecipe(Recipes.Item[i]).ColormethodDisplayName:= Settings.ColorMethod.Value;
   if FSelected <> NIL then
   begin
     FTemporary.ColorMethodDisplayName:= cbColorMethod.Items[cbColormethod.ItemIndex];
     FChanged:= TRUE;
     Update;
   end;
   FUserclicked:= TRUE;
 end;

 procedure TfrmMain.cbIBUMethodChange(Sender: TObject);
 var i : integer;
 begin
   FUserclicked:= false;
   Settings.IBUMethod.Value:= cbIBUMethod.Items[cbIBUmethod.ItemIndex];
   Settings.Save;
   for i:= 0 to Brews.NumItems - 1 do
     TRecipe(Brews.Item[i]).IBUmethodDisplayName:= Settings.IBUMethod.Value;
   for i:= 0 to Recipes.NumItems - 1 do
     TRecipe(Recipes.Item[i]).IBUmethodDisplayName:= Settings.IBUMethod.Value;
   if FSelected <> NIL then
   begin
     FTemporary.IBUmethodDisplayName:= cbIBUMethod.Items[cbIBUmethod.ItemIndex];
     FChanged:= TRUE;
     Update;
   end;
   FUserclicked:= TRUE;
 end;

 procedure TfrmMain.cbAdjustAlphaChange(Sender: TObject);
 begin
   if FUserClicked = TRUE then
   begin
     FUserclicked:= false;
     Settings.AdjustAlfa.Value:= cbAdjustAlpha.Checked;
     Settings.Save;
     if FSelected <> NIL then
     begin
       FTemporary.IBUmethodDisplayName:= cbIBUMethod.Items[cbIBUmethod.ItemIndex];
       FChanged:= TRUE;
       Update;
     end;
     FUserclicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbSettingsClick(Sender: TObject);
 var //OK : boolean;
     ts : TTabSheet;
 begin
   ts:= pcRecipes.ActivePage;
   frmsettings:= TFrmSettings.Create(self);
   if frmsettings.Execute then
   begin
 //    FChanged:= TRUE;
     SetControls;
     Settings.Style.SetControlsStyle(self);
     hcMash.Font.Height:= Settings.Style.Font.Height - 2;
     FUserClicked:= false;
     cbAdjustAlpha.Checked:= Settings.AdjustAlfa.Value;
     FUserClicked:= TRUE;
     cbBrewsSortChange(self);
     cbRecipesSortChange(self);
     Update;

     tsCloud.TabVisible:= Settings.UseCloud.Value;
     //if (not BHCloud.IsCloudRead) and (not BHCloud.IsBusy) and (tsCloud.TabVisible) then
     //begin
     //  OK:= BHCloud.ReadCloud;
     //  cbCloudSortChange(self);
     //  tsCloud.TabVisible:= OK;
     //end;
     pcRecipes.ActivePage:= ts;
     pcRecipesChange(self);
   end;
 end;

procedure TfrmMain.btnShowDirDialogClick(Sender: TObject);
var
   dlg : TSelectDirectoryDialog;
begin
  dlg := TSelectDirectoryDialog.Create(nil);
  dlg.Title:='Kies een folder';
  if dlg.Execute then
     ShowMessage('Het is gelukt ' + dlg.FileName)
  else
      ShowMessage('er ging iets mis');
  dlg.Free;
  dlg := nil;
end;


 procedure TfrmMain.bbDatabaseLocationClick(Sender: TObject);
 var i : integer;
 begin
   FrmDatabaseLocation:= TFrmDatabaseLocation.Create(self);
   if FrmDatabaseLocation.Execute then
   begin
     cbBeerStyle.Items.Clear;
     BeerStyles.SortByIndex2(5, 0, false);
     for i:= 0 to BeerStyles.NumItems - 1 do
        cbBeerStyle.Items.Add(TBeerStyle(BeerStyles.Item[i]).StyleLetter.Value + ' - ' +
                              TBeerStyle(BeerStyles.Item[i]).Name.Value);
     cbBeerStyle.ItemIndex:= 0;
     Equipments.SortByName('Naam');
     cbEquipment.Items.Clear;
     for i:= 0 to Equipments.NumItems - 1 do
       cbEquipment.Items.Add(TEquipment(Equipments.Item[i]).Name.Value);
     cbEquipment.ItemIndex:= 0;

     cbMash.Clear;
     Mashs.SortByName('Naam');
     for i:= 0 to Mashs.NumItems - 1 do
       cbMash.Items.Add(TMash(Mashs.Item[i]).Name.Value);
     cbMash.ItemIndex:= -1;

     cbBrewsSortChange(self);
     cbRecipesSortChange(self);
     Update;
     UpdatePredictions;
     ShowNotification(self, databaselocationset1);
   end;
   FrmDatabaseLocation.Free;
 end;

 procedure TfrmMain.cbShowSplashChange(Sender: TObject);
 begin
   if FUSerClicked then
   begin
     Settings.ShowSplash.Value:= cbShowSplash.Checked;
     Settings.Save;
   end;
 end;

 procedure TfrmMain.cbPlaySoundsChange(Sender: TObject);
 begin
   if FUserClicked then
   begin
     Settings.PlaySounds.Value:= cbPlaySounds.Checked;
     Settings.Save;
   end;
 end;

 {===========================  Popupmenu brews and recipes  ====================}

 procedure TfrmMain.miBrewsToRecipeClick(Sender: TObject);
 var R : TRecipe;
     s : string;
     IBU : double;
 begin
   if FSelected <> NIL then
   begin
     R:= Recipes.AddItem;
     R.Assign(FTemporary);
     s:= IntToStr(FSelected.AutoNr.Value);
     s:= 'B' + s;
     R.ParentAutoNr.Value:= s;
     R.AutoNr.Value:= Recipes.MaxAutoNr + 1;
     R.RemoveNonBrewsData;
     ibu:= R.IBUcalc.Value;
     R.RecType:= rtRecipe;
     R.AdjustBitterness(ibu);
     case cbRecipesSort.ItemIndex of
     0: SortByNumber(tsRecipes);
     1: SortByStyle(tsRecipes);
     2: SortByDate(tsRecipes);
     end;
     tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(R);
     pcRecipes.ActivePage:= tsRecipes;
     Recipes.SaveXML;
   end;
 end;

 procedure TfrmMain.miRecipesToBrewsClick(Sender: TObject);
 var R : TRecipe;
     s : string;
     ibu : double;
 begin
   if FSelected <> NIL then
   begin
     R:= Brews.AddItem;
     R.Assign(FTemporary);
     FrmRecipeToBrew:= TFrmRecipeToBrew.Create(self);
     if FrmRecipeToBrew.Execute(R) then
     begin
       s:= IntToStr(FSelected.AutoNr.Value);
       s:= 'R' + s;
       R.ParentAutoNr.Value:= s;
       R.AutoNr.Value:= Brews.MaxAutoNr + 1;
       R.InventoryReduced.Value:= false;
       case cbBrewsSort.ItemIndex of
       0: SortByNumber(tsBrews);
       1: SortByStyle(tsBrews);
       2: SortByDate(tsBrews);
       end;
       ibu:= R.IBUcalc.Value;
       R.RecType:= rtBrew;
       R.AdjustBitterness(ibu);
       tvBrews.Selected:= tvBrews.Items.FindNodeWithData(R);
       pcRecipes.ActivePage:= tsBrews;
       Brews.SaveXML;
     end
     else
     begin
       Brews.RemoveByReference(R);
     end;
   end;
 end;

 //procedure TfrmMain.miCloudToBrewsClick(Sender: TObject);
 //var R : TRecipe;
 //    s : string;
 //    ibu : double;
 //begin
 ////  if FSelected <> NIL then
 ////  begin
 ////    R:= Brews.AddItem;
 ////    R.Assign(FTemporary);
 ////    FrmRecipeToBrew:= TFrmRecipeToBrew.Create(self);
 ////    if FrmRecipeToBrew.Execute(R) then
 ////    begin
 ////{      s:= IntToStr(FSelected.AutoNr.Value);
 ////      s:= 'R' + s;
 ////      R.ParentAutoNr.Value:= s;}
 ////      R.AutoNr.Value:= Brews.MaxAutoNr + 1;
 ////      R.InventoryReduced.Value:= false;
 ////
 ////      CheckBeerStyle(R);
 ////      CheckFermentables(R);
 ////      CheckYeasts(R);
 ////
 ////      case cbBrewsSort.ItemIndex of
 ////      0: SortByNumber(tsBrews);
 ////      1: SortByStyle(tsBrews);
 ////      2: SortByDate(tsBrews);
 ////      end;
 ////      ibu:= R.IBUcalc.Value;
 ////      R.RecType:= rtBrew;
 ////      R.AdjustBitterness(ibu);
 ////      tvBrews.Selected:= tvBrews.Items.FindNodeWithData(R);
 ////      pcRecipes.ActivePage:= tsBrews;
 ////      Brews.SaveXML;
 ////    end
 ////    else
 ////    begin
 ////      Brews.RemoveByReference(R);
 ////    end;
 ////  end;
 //end;

 procedure TfrmMain.miCloudToRecipesClick(Sender: TObject);
// var R : TRecipe;
//     s : string;
 begin
 //  if FSelected <> NIL then
 //  begin
 //    R:= Recipes.AddItem;
 //    R.Assign(FTemporary);
 //    CheckBeerStyle(R);
 //    CheckFermentables(R);
 //    CheckYeasts(R);
 //{    s:= IntToStr(FSelected.AutoNr.Value);
 //    s:= 'B' + s;
 //    R.ParentAutoNr.Value:= s;}
 //    R.AutoNr.Value:= Recipes.MaxAutoNr + 1;
 //    R.RemoveNonBrewsData;
 //    case cbRecipesSort.ItemIndex of
 //    0: SortByNumber(tsRecipes);
 //    1: SortByStyle(tsRecipes);
 //    2: SortByDate(tsRecipes);
 //    end;
 //    R.RecType:= rtRecipe;
 //    tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(R);
 //    pcRecipes.ActivePage:= tsRecipes;
 //    Recipes.SaveXML;
 //  end;
 end;

 procedure TfrmMain.miFindParentRecipeClick(Sender: TObject);
 var s : string;
     Nr : integer;
     R, B : TRecipe;
 begin
   B:= TRecipe(tvBrews.Selected.Data);
   if B <> NIL then
   begin
     s:= B.ParentAutoNr.Value;
     if s <> '' then
     begin
       s:= RightStr(s, Length(s) - 1);
       Nr:= StrToInt(s);
       R:= TRecipe(Recipes.FindByAutoNr(Nr));
       if R <> NIL then
       begin
         tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(R);
         pcRecipes.ActivePage:= tsRecipes;
       end;
     end;
   end;
 end;


 procedure TfrmMain.miFindParentBrewClick(Sender: TObject);
 var s : string;
     Nr : integer;
     R, B : TRecipe;
 begin
   R:= TRecipe(tvRecipes.Selected.Data);
   if R <> NIL then
   begin
     s:= R.ParentAutoNr.Value;
     if s <> '' then
     begin
       s:= RightStr(s, Length(s) - 1);
       Nr:= StrToInt(s);
       B:= TRecipe(Brews.FindByAutoNr(Nr));
       if B <> NIL then
       begin
         tvBrews.Selected:= tvBrews.Items.FindNodeWithData(B);
         pcRecipes.ActivePage:= tsBrews;
       end;
     end;
   end;
 end;

 procedure TfrmMain.miDivideBrewClick(Sender: TObject);
 var Num, i : integer;
     DiType : integer;
     Rec : TRecipe;
     Node : TTreeNode;
     Nr : string;
 begin
   ShowNotification(self, 'Nog niet geïmplementeerd');
   if FTemporary <> NIL then
   begin
     FrmDivideBrew:= TFrmDivideBrew.Create(self);
     DiType:= FrmDivideBrew.Execute;
     Num:= FrmDivideBrew.NumBatches;
     FrmDivideBrew.Free;
     if (DiType > -1) then
     begin
       for i:= 1 to Num do
       begin
         Rec:= Brews.AddItem;
         if Rec <> NIL then
           FTemporary.DivideBrew(Rec, DiType, Num, i);
       end;
       Nr:= FTemporary.NrRecipe.Value;
       FTemporary.NrRecipe.Value:= Nr + '-0';
     end;
     Node:= tvBrews.Selected;
     cbBrewsSortChange(self);
     Node.Selected:= TRUE;
   end;
 end;

 {============================ Recipes and brews Treeviews  ====================}

 procedure TfrmMain.cbBrewsSortChange(Sender: TObject);
 var r : TRecipe;
 begin
   R:= NIL;
   if (tvBrews.Selected <> NIL) then R:= TRecipe(tvBrews.Selected.Data);
   eSearchBrews.Text:= '';
   case cbBrewsSort.ItemIndex of
   0: SortByNumber(tsBrews);
   1: SortByStyle(tsBrews);
   2: SortByDate(tsBrews);
   end;
   Settings.SortBrews.Value:= cbBrewsSort.ItemIndex;
   Settings.Save;
   if r <> NIL then tvBrews.Selected:= tvBrews.Items.FindNodeWithData(R)
   else tvBrews.Selected:= tvBrews.Items.FindNodeWithData(TRecipe(Brews.Item[Brews.NumItems - 1]));
   tvBrewsSelectionChanged(self);
 end;

 procedure TfrmMain.cbRecipesSortChange(Sender: TObject);
 var r : TRecipe;
 begin
   R:= NIL;
   if (tvRecipes.Selected <> NIL) then R:= TRecipe(tvRecipes.Selected.Data);
   eSearchRecipes.Text:= '';
   case cbRecipesSort.ItemIndex of
   0: SortByNumber(tsRecipes);
   1: SortByStyle(tsRecipes);
   2: SortByDate(tsRecipes);
   end;
   Settings.SortRecipes.Value:= cbRecipesSort.ItemIndex;
   Settings.Save;
   if r <> NIL then tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(R)
   else tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(TRecipe(Recipes.Item[Recipes.NumItems - 1]));
   tvRecipesSelectionChanged(self);
 end;
 {
 procedure TfrmMain.cbCloudSortChange(Sender: TObject);
 //var BHC : TBHCloudFile;
 begin
 //  eSearchRecipes.Text:= '';
 //  if BHCloud.IsCloudRead then
 //  begin
 //    case cbCloudSort.ItemIndex of
 //    0: SortByNumber(tsCloud);
 //    1: SortByStyle(tsCloud);
 //    2: SortByDate(tsCloud);
 //    end;
 //    Settings.SortCloud.Value:= cbCloudSort.ItemIndex;
 //    Settings.Save;
 ////    BHCloud.LoadRecipeByIndex(0);
 //    BHC:= BHCloud.FileRec[0];
 //    tvCloud.Selected:= tvCloud.Items.FindNodeWithData(BHC);
 //  end;
 end;
}
 procedure TfrmMain.SortByNumber(page : TTabSheet);
 var i, n : integer;
     s : string;
     Node, ChildNode : TTreeNode;
     Rec : TRecipe;
     //CloudF : longint;
     //CloudFile : TBHCloudFile;
 begin
   Rec:= NIL;
   //CloudF:= -1;
   //CloudFile:= NIL;
   if page = tsBrews then
   begin
      //fill the treeview with Brews
     if (tvBrews.Selected <> NIL) and (tvBrews.Selected.Data <> NIL) then
       Rec:= TRecipe(tvBrews.Selected.Data);
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     tvBrews.Visible:= false;
     tvBrews.Items.Clear;
     Node:= tvBrews.Items.Add (nil,brews1);
     Node.StateIndex:= 11;
     Brews.Sort;
     for i:= 0 to Brews.NumItems - 1 do
     begin
       Rec:= TRecipe(Brews.Item[i]);
       s:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
       ChildNode:= tvBrews.Items.AddChild(Node, s);
       ChildNode.Data:= TRecipe(Brews.Item[i]);
 //      ChildNode.ImageIndex:= 0;

       Rec.CalcNumMissingIngredients;
       n:= Rec.NumMissingIngredients;
       if Settings.ShowPossibleWithStock.Value then
       begin
         if Rec.Locked.Value then
         begin
           if n = 0 then ChildNode.StateIndex:= 16
           else if n <= 2 then ChildNode.StateIndex:= 17
           else ChildNode.StateIndex:= 18;
         end
         else
         begin
           if n = 0 then ChildNode.StateIndex:= 13
           else if n <= 2 then ChildNode.StateIndex:= 14
           else ChildNode.StateIndex:= 15;
         end;
       end
       else
       begin
         if Rec.Locked.Value then ChildNode.StateIndex:= 12
         else ChildNode.StateIndex:= 0;
       end;
     end;
     tvBrews.SortType:= stNone;
     tvBrews.SortType:= stText;
     tvBrews.Visible:= TRUE;
     if rec <> NIL then
     begin
       tvBrews.Selected:= tvBrews.Items.FindNodeWithData(rec);
       if tvBrews.Selected <> NIL then
       begin
         tvBrews.Items[0].MakeVisible;
         tvBrews.MakeSelectionVisible;
         tvBrews.Selected.MakeVisible;
       end;
     end;
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
   end
   else if page = tsRecipes then
   begin
     if (tvRecipes.Selected <> NIL) and (tvRecipes.Selected.Data <> NIL) then
       Rec:= TRecipe(tvRecipes.Selected.Data);
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     tvRecipes.Visible:= false;
     tvRecipes.Items.Clear;
     Node:= tvRecipes.Items.Add (nil,recipes1);
     Node.StateIndex:= 11;
     Recipes.Sort;
     for i:= 0 to Recipes.NumItems - 1 do
     begin
       Rec:= TRecipe(Recipes.Item[i]);
       s:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
       ChildNode:= tvRecipes.Items.AddChild(Node, s);
       ChildNode.Data:= TRecipe(Recipes.Item[i]);
       Rec.CalcNumMissingIngredients;
       n:= Rec.NumMissingIngredients;
       if Settings.ShowPossibleWithStock.Value then
       begin
         if n = 0 then ChildNode.StateIndex:= 13
         else if n <= 2 then ChildNode.StateIndex:= 14
         else ChildNode.StateIndex:= 15;
       end
       else
       begin
         ChildNode.StateIndex:= 0;
       end;
     end;
     tvRecipes.SortType:= stNone;
     tvRecipes.SortType:= stText;
     tvRecipes.Visible:= TRUE;
     if rec <> NIL then
     begin
       tvRecipes.Items[0].MakeVisible;
       tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(rec);
       if tvRecipes.Selected <> NIL then
         tvRecipes.Selected.MakeVisible;
     end;
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
   end
   else if page = tsCloud then
   begin
     //if BHCloud.IsCloudRead then
     //begin
     //  if (tvCloud.Selected <> NIL) and (tvCloud.Selected.Data <> NIL) then
     //    CloudF:= BHCloud.Selected;
     //  Screen.Cursor:= crHourglass;
     //  Cursor:= crHourglass;
     //  Application.ProcessMessages;
     //  tvCloud.Visible:= false;
     //  tvCloud.Items.Clear;
     //  Node:= tvCloud.Items.Add (nil,cloudrecipes1);
     //  Node.StateIndex:= 11;
     //  BHCloud.Sort;
     //  for i:= 0 to BHCloud.NumFiles - 1 do
     //  begin
     //    CloudFile:= BHCloud.FileRec[i];
     //    if CloudFile.ShowRecipe.Value then
     //    begin
     //      s:= CloudFile.RecCode.Value + ' ' + CloudFile.RecName.Value;
     //      ChildNode:= tvCloud.Items.AddChild(Node, s);
     //      ChildNode.Data:= CloudFile;
     ////      ChildNode.ImageIndex:= 0;
     //      ChildNode.StateIndex:= 0;
     //    end;
     //  end;
     //  tvCloud.SortType:= stNone;
     //  tvCloud.SortType:= stText;
     //  tvCloud.Visible:= TRUE;
     //  if CloudF > -1 then
     //  begin
     //    tvCloud.Items[0].MakeVisible;
     //    tvCloud.Selected:= tvRecipes.Items.FindNodeWithData(BHCloud.FileRec[CloudF]);
     //    if tvCloud.Selected <> NIL then
     //      tvCloud.Selected.MakeVisible;
     //  end;
     //  Screen.Cursor:= crDefault;
     //  Cursor:= crDefault;
     //end
     //else if not BHCloud.IsBusy then
     //  tsCloud.TabVisible:= BHCloud.ReadCloud;
   end;
 end;

 procedure TfrmMain.SortByStyle(page : TTabSheet);
 var i, n : integer;
     st, le : string;
     RootNode, ClassNode, StyleNode, RecipeNode : TTreeNode;
     Rec, RecO : TRecipe;
     //CloudF : longint;
 //    CloudFile : TBHCloudFile;
 begin
   Rec:= NIL; RecO:= NIL;
   //CloudF:= -1;
   if Page = tsBrews then
   begin
     //fill the treeview with brews
     if (tvBrews.Selected <> NIL) and (tvBrews.Selected.Data <> NIL) then
       RecO:= TRecipe(tvBrews.Selected.Data);
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     tvBrews.Visible:= false;
     tvBrews.Items.Clear;
     tvBrews.SortType:= stNone;
     try
       RootNode:= tvBrews.Items.Add (nil,brews1);
       RootNode.StateIndex:= 11;
       for i:= 0 to Brews.NumItems - 1 do
       begin
         Rec:= TRecipe(Brews.Item[i]);
         le:= Rec.Style.StyleLetter.Value;
         ClassNode:= tvBrews.Items.FindNodeWithText(le);
         if ClassNode = NIL then //add new style letter node
         begin
           ClassNode:= tvBrews.Items.AddChild(RootNode, le);
           If LowerCase(le) = 'a' then ClassNode.StateIndex:= 1
           else if LowerCase(le) = 'b' then ClassNode.StateIndex:= 2
           else if LowerCase(le) = 'c' then ClassNode.StateIndex:= 3
           else if LowerCase(le) = 'd' then ClassNode.StateIndex:= 4
           else if LowerCase(le) = 'o' then ClassNode.StateIndex:= 5
           else ClassNode.StateIndex:= 3;
         end;
         st:= Rec.Style.Name.Value;
         StyleNode:= ClassNode.FindNode(st);
         if StyleNode = NIL then //add new style node
         begin
           StyleNode:= tvBrews.Items.AddChild(ClassNode, st);
           If LowerCase(le) = 'a' then StyleNode.StateIndex:= 1
           else if LowerCase(le) = 'b' then StyleNode.StateIndex:= 2
           else if LowerCase(le) = 'c' then StyleNode.StateIndex:= 3
           else if LowerCase(le) = 'd' then StyleNode.StateIndex:= 4
           else if LowerCase(le) = 'o' then StyleNode.StateIndex:= 5
           else StyleNode.StateIndex:= 3;
         end;
         st:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
         RecipeNode:= tvBrews.Items.AddChildObject(StyleNode, st, Rec);
         Rec.CalcNumMissingIngredients;
         n:= Rec.NumMissingIngredients;
         if Settings.ShowPossibleWithStock.Value then
         begin
           if Rec.Locked.Value then
           begin
             if n = 0 then REcipeNode.StateIndex:= 16
             else if n <= 2 then RecipeNode.StateIndex:= 17
             else RecipeNode.StateIndex:= 18;
           end
           else
           begin
             if n = 0 then RecipeNode.StateIndex:= 13
             else if n <= 2 then RecipeNode.StateIndex:= 14
             else RecipeNode.StateIndex:= 15;
           end;
         end
         else
         begin
           if Rec.Locked.Value then RecipeNode.StateIndex:= 12
           else RecipeNode.StateIndex:= 0;
         end;
       end;
       tvBrews.SortType:= stNone;
       tvBrews.SortType:= stText;
       tvBrews.Visible:= TRUE;
       if recO <> NIL then
       begin
         tvBrews.Items[0].MakeVisible;
         tvBrews.Selected:= tvBrews.Items.FindNodeWithData(recO);
         if tvBrews.Selected <> NIL then
           tvBrews.Selected.MakeVisible;
       end;
     finally
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
     end;
   end
   else if Page = tsRecipes then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if (tvRecipes.Selected <> NIL) and (tvRecipes.Selected.Data <> NIL) then
       RecO:= TRecipe(tvRecipes.Selected.Data);
     tvRecipes.Visible:= false;
     tvRecipes.Items.Clear;
     tvRecipes.SortType:= stNone;
     try
       RootNode:= tvRecipes.Items.Add (nil,recipes1);
       RootNode.StateIndex:= 11;
       for i:= 0 to Recipes.NumItems - 1 do
       begin
         Rec:= TRecipe(Recipes.Item[i]);
         le:= Rec.Style.StyleLetter.Value;
         ClassNode:= tvRecipes.Items.FindNodeWithText(le);
         if ClassNode = NIL then //add new style letter node
         begin
           ClassNode:= tvRecipes.Items.AddChild(RootNode, le);
           If LowerCase(le) = 'a' then ClassNode.StateIndex:= 1
           else if LowerCase(le) = 'b' then ClassNode.StateIndex:= 2
           else if LowerCase(le) = 'c' then ClassNode.StateIndex:= 3
           else if LowerCase(le) = 'd' then ClassNode.StateIndex:= 4
           else if LowerCase(le) = 'o' then ClassNode.StateIndex:= 5
           else ClassNode.StateIndex:= 3;
         end;
         st:= Rec.Style.Name.Value;
         StyleNode:= ClassNode.FindNode(st);
         if StyleNode = NIL then //add new style node
         begin
           StyleNode:= tvRecipes.Items.AddChild(ClassNode, st);
           If LowerCase(le) = 'a' then StyleNode.StateIndex:= 1
           else if LowerCase(le) = 'b' then StyleNode.StateIndex:= 2
           else if LowerCase(le) = 'c' then StyleNode.StateIndex:= 3
           else if LowerCase(le) = 'd' then StyleNode.StateIndex:= 4
           else if LowerCase(le) = 'o' then StyleNode.StateIndex:= 5
           else StyleNode.StateIndex:= 3;
         end;
         st:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
         RecipeNode:= tvRecipes.Items.AddChildObject(StyleNode, st, Rec);
         Rec.CalcNumMissingIngredients;
         n:= Rec.NumMissingIngredients;
         if Settings.ShowPossibleWithStock.Value then
         begin
           if n = 0 then RecipeNode.StateIndex:= 13
           else if n <= 2 then RecipeNode.StateIndex:= 14
           else RecipeNode.StateIndex:= 15;
         end
         else RecipeNode.StateIndex:= 0;
       end;
       tvRecipes.SortType:= stNone;
       tvRecipes.SortType:= stText;
       tvRecipes.Visible:= TRUE;
       if recO <> NIL then
       begin
         tvRecipes.Items[0].MakeVisible;
         tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(recO);
         if tvRecipes.Selected <> NIL then
           tvRecipes.Selected.MakeVisible;
       end;
     finally
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
     end;
   end
   else if Page = tsCloud then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if (tvCloud.Selected <> NIL) and (tvCloud.Selected.Data <> NIL) then
       RecO:= TRecipe(tvCloud.Selected.Data);
     tvCloud.Visible:= false;
     tvCloud.Items.Clear;
     tvCloud.SortType:= stNone;
     //try
     //  if BHCloud.IsCloudRead then
     //  begin
     //    RootNode:= tvCloud.Items.Add (nil,cloudrecipes1);
     //    RootNode.StateIndex:= 11;
     //    for i:= 0 to BHCloud.NumFiles - 1 do
     //    begin
     //      CloudF:= BHCloud.Selected;
     //      CloudFile:= BHCloud.FileRec[i];
     //      if CloudFile.ShowRecipe.Value then
     //      begin
     //        le:= CloudFile.RecStyleLetter.Value;
     //        if le = '' then le:= unknown1;
     //        ClassNode:= tvCloud.Items.FindNodeWithText(le);
     //        if ClassNode = NIL then //add new style letter node
     //        begin
     //          ClassNode:= tvCloud.Items.AddChild(RootNode, le);
     //          If LowerCase(le) = 'a' then ClassNode.StateIndex:= 1
     //          else if LowerCase(le) = 'b' then ClassNode.StateIndex:= 2
     //          else if LowerCase(le) = 'c' then ClassNode.StateIndex:= 3
     //          else if LowerCase(le) = 'd' then ClassNode.StateIndex:= 4
     //          else if LowerCase(le) = 'o' then ClassNode.StateIndex:= 5
     //          else ClassNode.StateIndex:= 3;
     //        end;
     //        st:= CloudFile.RecBeerStyle.Value;
     //        if st = '' then st:= unknown2;
     //        StyleNode:= ClassNode.FindNode(st);
     //        if StyleNode = NIL then //add new style node
     //        begin
     //          StyleNode:= tvCloud.Items.AddChild(ClassNode, st);
     //          If LowerCase(le) = 'a' then StyleNode.StateIndex:= 1
     //          else if LowerCase(le) = 'b' then StyleNode.StateIndex:= 2
     //          else if LowerCase(le) = 'c' then StyleNode.StateIndex:= 3
     //          else if LowerCase(le) = 'd' then StyleNode.StateIndex:= 4
     //          else if LowerCase(le) = 'o' then StyleNode.StateIndex:= 5
     //          else StyleNode.StateIndex:= 3;
     //        end;
     //        st:= CloudFile.RecCode.Value + ' ' + CloudFile.RecName.Value;
     //        RecipeNode:= tvCloud.Items.AddChildObject(StyleNode, st, CloudFile);
     ////        RecipeNode.ImageIndex:= 0;
     //        RecipeNode.StateIndex:= 0;
     //      end;
     //    end;
     //    tvCloud.SortType:= stNone;
     //    tvCloud.SortType:= stText;
     //    tvCloud.Visible:= TRUE;
     //    if recO <> NIL then
     //    begin
     //      tvCloud.Items[0].MakeVisible;
     //      tvCloud.Selected:= tvCloud.Items.FindNodeWithData(recO);
     //      if tvCloud.Selected <> NIL then
     //        tvCloud.Selected.MakeVisible;
     //    end;
     //  end
     //  else if not BHCloud.IsBusy then
     //    tsCloud.TabVisible:= BHCloud.ReadCloud;
     //finally
     //  Screen.Cursor:= crDefault;
     //  Cursor:= crDefault;
     //  tvCloud.Visible:= TRUE;
     //end;
   end;
 end;

 procedure TfrmMain.SortByDate(page : TTabSheet);
 var y, m, d, i, n : word;
     Dat : TDateTime;
     st : string;
     RootNode, YearNode, MonthNode, RecipeNode : TTreeNode;
     Rec, RecO : TRecipe;
     //CloudF : longint;
 //    CloudFile : TBHCloudFile;
 begin
   Rec:= NIL; RecO:= NIL;
   //CloudF:= -1;
   //CloudFile:= NIL;
   if Page = tsBrews then
   begin
     //fill the treeview with brews
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if (tvBrews.Selected <> NIL) and (tvBrews.Selected.Data <> NIL) then
       RecO:= TRecipe(tvBrews.Selected.Data);
     tvBrews.Visible:= false;
     tvBrews.Items.Clear;
     tvBrews.SortType:= stNone;
     try
       RootNode:= tvBrews.Items.Add (nil,brews1);
       RootNode.StateIndex:= 11;
       for i:= 0 to Brews.NumItems - 1 do
       begin
         Rec:= TRecipe(Brews.Item[i]);
         Dat:= Rec.Date.Value;
         DecodeDate(Dat, y, m, d);
         YearNode:= tvBrews.Items.FindNodeWithText(IntToStr(y));
         if YearNode = NIL then //add new style letter node
         begin
           YearNode:= tvBrews.Items.AddChild(RootNode, IntToStr(y));
           YearNode.StateIndex:= 10;
         end;
         st:= IntToStr(m);
         if Length(st) = 1 then st:= '0' + st;
         MonthNode:= YearNode.FindNode(st);
         if MonthNode = NIL then //add new style node
         begin
           MonthNode:= tvBrews.Items.AddChild(YearNode, st);
           case m of
           1, 2, 12: MonthNode.StateIndex:= 6;
           3, 4, 5: MonthNode.StateIndex:= 7;
           6, 7, 8: MonthNode.StateIndex:= 8;
           9, 10, 11: MonthNode.StateIndex:= 9;
           end;
         end;
         st:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
         RecipeNode:= tvBrews.Items.AddChildObject(MonthNode, st, Rec);
         Rec.CalcNumMissingIngredients;
         n:= Rec.NumMissingIngredients;
         if Settings.ShowPossibleWithStock.Value then
         begin
           if Rec.Locked.Value then
           begin
             if n = 0 then RecipeNode.StateIndex:= 16
             else if n <= 2 then RecipeNode.StateIndex:= 17
             else RecipeNode.StateIndex:= 18;
           end
           else
           begin
             if n = 0 then RecipeNode.StateIndex:= 13
             else if n <= 2 then RecipeNode.StateIndex:= 14
             else RecipeNode.StateIndex:= 15;
           end;
         end
         else
         begin
           if Rec.Locked.Value then RecipeNode.StateIndex:= 12
           else RecipeNode.StateIndex:= 0;
         end;
       end;
       tvBrews.SortType:= stNone;
       tvBrews.SortType:= stText;
       tvBrews.Visible:= TRUE;
       if recO <> NIL then
       begin
         tvBrews.Items[0].MakeVisible;
         tvBrews.Selected:= tvBrews.Items.FindNodeWithData(recO);
         if tvBrews.Selected <> NIL then
           tvBrews.Selected.MakeVisible;
       end;
     finally
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
     end;
   end
   else if Page = tsRecipes then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if (tvRecipes.Selected <> NIL) and (tvRecipes.Selected.Data <> NIL) then
       RecO:= TRecipe(tvRecipes.Selected.Data);
     tvRecipes.Visible:= false;
     tvRecipes.Items.Clear;
     tvRecipes.SortType:= stNone;
     try
       RootNode:= tvRecipes.Items.Add (nil,recipes1);
       RootNode.StateIndex:= 11;
       for i:= 0 to Recipes.NumItems - 1 do
       begin
         Rec:= TRecipe(Recipes.Item[i]);
         Dat:= Rec.Date.Value;
         DecodeDate(Dat, y, m, d);
         YearNode:= tvRecipes.Items.FindNodeWithText(IntToStr(y));
         if YearNode = NIL then //add new style letter node
         begin
           YearNode:= tvRecipes.Items.AddChild(RootNode, IntToStr(y));
           YearNode.StateIndex:= 10;
         end;
         st:= IntToStr(m);
         if Length(st) = 1 then st:= '0' + st;
         MonthNode:= YearNode.FindNode(st);
         if MonthNode = NIL then //add new style node
         begin
           MonthNode:= tvRecipes.Items.AddChild(YearNode, st);
           case m of
           1, 2, 12: MonthNode.StateIndex:= 6;
           3, 4, 5: MonthNode.StateIndex:= 7;
           6, 7, 8: MonthNode.StateIndex:= 8;
           9, 10, 11: MonthNode.StateIndex:= 9;
           end;
         end;
         st:= Rec.NrRecipe.Value + ' ' + Rec.Name.Value;
         RecipeNode:= tvRecipes.Items.AddChildObject(MonthNode, st, Rec);
         Rec.CalcNumMissingIngredients;
         n:= Rec.NumMissingIngredients;
         if Settings.ShowPossibleWithStock.Value then
         begin
           if n = 0 then RecipeNode.StateIndex:= 13
           else if n <= 2 then RecipeNode.StateIndex:= 14
           else RecipeNode.StateIndex:= 15;
         end
         else RecipeNode.StateIndex:= 0;
       end;
       tvRecipes.SortType:= stNone;
       tvRecipes.SortType:= stText;
       tvRecipes.Visible:= TRUE;
       if recO <> NIL then
       begin
         tvRecipes.Items[0].MakeVisible;
         tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(recO);
         if tvRecipes.Selected <> NIL then
           tvRecipes.Selected.MakeVisible;
       end;
     finally
       Screen.Cursor:= crDefault;
       Cursor:= crDefault;
     end;
   end
   else if Page = tsCloud then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     if (tvCloud.Selected <> NIL) and (tvCloud.Selected.Data <> NIL) then
       RecO:= TRecipe(tvCloud.Selected.Data);
     tvCloud.Visible:= false;
     tvCloud.Items.Clear;
     tvCloud.SortType:= stNone;
     //try
     //  if BHCloud.IsCloudRead then
     //  begin
     //    RootNode:= tvCloud.Items.Add (nil,cloudrecipes1);
     //    RootNode.StateIndex:= 11;
     //    for i:= 0 to BHCloud.NumFiles - 1 do
     //    begin
     //      CloudFile:= BHCloud.FileRec[i];
     //      if CloudFile.ShowRecipe.Value then
     //      begin
     //        Dat:= CloudFile.DateTimeRemote.Value;
     //        DecodeDate(Dat, y, m, d);
     //        YearNode:= tvCloud.Items.FindNodeWithText(IntToStr(y));
     //        if YearNode = NIL then //add new style letter node
     //        begin
     //          YearNode:= tvCloud.Items.AddChild(RootNode, IntToStr(y));
     //          YearNode.StateIndex:= 10;
     //        end;
     //        st:= IntToStr(m);
     //        if Length(st) = 1 then st:= '0' + st;
     //        MonthNode:= YearNode.FindNode(st);
     //        if MonthNode = NIL then //add new style node
     //        begin
     //          MonthNode:= tvCloud.Items.AddChild(YearNode, st);
     //          case m of
     //          1, 2, 12: MonthNode.StateIndex:= 6;
     //          3, 4, 5: MonthNode.StateIndex:= 7;
     //          6, 7, 8: MonthNode.StateIndex:= 8;
     //          9, 10, 11: MonthNode.StateIndex:= 9;
     //          end;
     //        end;
     //        st:= CloudFile.RecCode.Value + ' ' + CloudFile.RecName.Value;
     //        RecipeNode:= tvCloud.Items.AddChildObject(MonthNode, st, CloudFile);
     ////        RecipeNode.ImageIndex:= 0;
     //        RecipeNode.StateIndex:= 0;
     //      end;
     //    end;
     //    tvCloud.SortType:= stNone;
     //    tvCloud.SortType:= stText;
     //    tvCloud.Visible:= TRUE;
     //    if recO <> NIL then
     //    begin
     //      tvCloud.Items[0].MakeVisible;
     //      tvCloud.Selected:= tvCloud.Items.FindNodeWithData(recO);
     //      if tvCloud.Selected <> NIL then
     //        tvCloud.Selected.MakeVisible;
     //    end;
     //  end
     //  else if not BHCloud.IsBusy then
     //    tsCloud.TabVisible:= BHCloud.ReadCloud;
     //finally
     //  Screen.Cursor:= crDefault;
     //  Cursor:= crDefault;
     //  tvCloud.Visible:= TRUE;
     //end;
   end;
 end;

 procedure TfrmMain.pcRecipesChange(Sender: TObject);
 begin
   if FChanged then
     AskToSave;
   sgIngredients.Editor:= NIL;
   cbLocked.Visible:= (pcRecipes.ActivePage = tsBrews);
   if pcRecipes.ActivePage = tsBrews then
   begin
     FSelected:= FSelBrew;
     tvBrewsSelectionChanged(sender);
     pcRecipe.ActivePage:= tsRecipe;
   end
   else if pcRecipes.ActivePage = tsRecipes then
   begin
     FSelected:= FSelRecipe;
     tvRecipesSelectionChanged(sender);
     pcRecipe.ActivePage:= tsRecipe;
   end
   else if pcRecipes.ActivePage = tsCloud then
   begin
     //if (not BHCloud.IsCloudRead) and (not BHCloud.IsBusy) then
     //begin
     //   tsCloud.TabVisible:= BHCloud.ReadCloud; //read the cloud and populate the tree with recipes
     //   //Settings.UseCloud.Value:= tsCloud.TabVisible;
     //   //Settings.Save;
     //   if tsCloud.TabVisible then cbCloudSortChange(self);
     //end
     //else
     //begin
     //  FSelected:= FSelCloud;
     //  tvCloudSelectionChanged(sender);
     //  pcRecipe.ActivePage:= tsRecipe;
     //end;
   end;
   cbLocked.Enabled:= (not (pcRecipes.ActivePage = tsCloud));

   tsBrewday.TabVisible:= (pcRecipes.ActivePage = tsBrews);
   tsFermentation.TabVisible:= (pcRecipes.ActivePage = tsBrews);
   tsPackaging.TabVisible:= (pcRecipes.ActivePage = tsBrews);
   if FSelected <> NIL then
     tbCheckList.Enabled:= (pcRecipes.ActivePage = tsBrews) and (not FSelected.Locked.Value)
   else tbCheckList.Enabled:= false;
   cbMash.ItemIndex:= -1;
   mroPredictions.Visible:= (pcRecipes.ActivePage = tsBrews);

   if FSelected <> NIL then
   begin
     FTemporary.Assign(FSelected);
     FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
   end;
   if cbPercentage.Checked then
     fseOG.Value:= FTemporary.EstOG.Value;
 //    fseOG.Value:= FTemporary.EstOGFermenter.Value;
   Update;
   UpdateGraph;
   sgIngredients.Editor:= NIL;
   fseGrid.Visible:= false;
   if FSelected <> NIL then
     if sgIngredients.RowCount > 0 then
     begin
       sgIngredients.Col:= 1;
       sgIngredients.Row:= 0;
     end;
   FChanged:= false;
 end;

 procedure TfrmMain.FillAnalyseCharts;
 var lett, snm : string;
     //num : integer;
     mma : TMinMax;
     ylist: array [1..4] of Double;
     i : integer;
     maxl, maxr : double;
     RC : TRecipes;
     OK : boolean;
 begin
   if (FSelected = NIL) then
   begin
     dbawFermentables.Clear;
     lcsFermBars.Clear;
     lcsHop.Clear;
     lcsHopBW.Clear;
     lcsYeast.Clear;
     lcsMisc.Clear;
     lcsMiscBW.Clear;
     lcsCommon.Clear;
     maxl:= 0;
     maxr:= 0;
     OK:= false;
     if (pcRecipes.ActivePage = tsBrews) and (cbBrewsSort.ItemIndex = 1) and
        (tvBrews.Selected <> NIL) and (tvBrews.Selected.Level = 2) then //sorted by beerstyle
     begin
       OK:= TRUE;
       RC:= Brews;
       snm:= tvBrews.Selected.Text;
       lett:= tvBrews.Selected.Parent.Text;
     end
     else if (pcRecipes.ActivePage = tsRecipes) and (cbRecipesSort.ItemIndex = 1) and
        (tvRecipes.Selected <> NIL) and (tvRecipes.Selected.Level = 2) then //sorted by beerstyle
     begin
       OK:= TRUE;
       RC:= Recipes;
       snm:= tvRecipes.Selected.Text;
       lett:= tvRecipes.Selected.Parent.Text;
     end;
     if OK then
     begin
       //num:= RC.AnalyseFermentables(lett, snm);
       dbawFermentables.Source.Ycount:= 5;
       //create graph and show it
       for i:= 0 to High(RC.FermentablesMinMaxArray) do
       begin
         mma:= RC.FermentablesMinMaxArray[i];
         lcsFermBars.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
         dbawFermentables.AddXY(i+1, mma.MinUse, mma.Name, $00C20606);
         ylist[1]:= mma.MinUse;
         ylist[2]:= mma.AvUse;
         ylist[3]:= mma.MaxUse;
         ylist[4]:= mma.MaxUse;
         dbawFermentables.ListSource.SetYList(i, ylist);
       end;

       lcsHopBW.YCount:= 5;
       //num:= RC.AnalyseHops(lett, snm);
       if rgBitterhop.Checked then
       begin
         for i:= 0 to High(RC.BitterhopMinMaxArray) do
         begin
           mma:= RC.BitterhopMinMaxArray[i];
           lcsHop.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
           lcsHopBW.Add(i+1, mma.MinUse, mma.Name, $00C20606);
           ylist[1]:= mma.MinUse;
           ylist[2]:= mma.AvUse;
           ylist[3]:= mma.MaxUse;
           ylist[4]:= mma.MaxUse;
           lcsHopBW.SetYList(i, ylist);
           if mma.PercRecipes > maxl then maxl:= mma.PercRecipes;
           if mma.MaxUse > maxr then maxr:= mma.MaxUse;
         end;
         chAnalyseHops.AxisList[2].Title.Caption:= ibuattr1;
       end
       else if rgAromahop.Checked then
       begin
         for i:= 0 to High(RC.AromahopMinMaxArray) do
         begin
           mma:= RC.AromahopMinMaxArray[i];
           lcsHop.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
           lcsHopBW.Add(i+1, mma.MinUse, mma.Name, $00C20606);
           ylist[1]:= mma.MinUse;
           ylist[2]:= mma.AvUse;
           ylist[3]:= mma.MaxUse;
           ylist[4]:= mma.MaxUse;
           lcsHopBW.SetYList(i, ylist);
           if mma.PercRecipes > maxl then maxl:= mma.PercRecipes;
           if mma.MaxUse > maxr then maxr:= mma.MaxUse;
         end;
         chAnalyseHops.AxisList[2].Title.Caption:= concentration1;
       end
       else
       begin
         for i:= 0 to High(RC.DryhopMinMaxArray) do
         begin
           mma:= RC.DryhopMinMaxArray[i];
           lcsHop.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
           lcsHopBW.Add(i+1, mma.MinUse, mma.Name, $00C20606);
           ylist[1]:= mma.MinUse;
           ylist[2]:= mma.AvUse;
           ylist[3]:= mma.MaxUse;
           ylist[4]:= mma.MaxUse;
           lcsHopBW.SetYList(i, ylist);
           if mma.PercRecipes > maxl then maxl:= mma.PercRecipes;
           if mma.MaxUse > maxr then maxr:= mma.MaxUse;
         end;
         chAnalyseHops.AxisList[2].Title.Caption:= concentration1;
       end;
       if maxr > 0 then latHopright.Scale:= maxl / maxr;

       //num:= RC.AnalyseYeasts(lett, snm);
       //create graph and show it
       for i:= 0 to High(RC.YeastMinMaxArray) do
       begin
         mma:= RC.YeastMinMaxArray[i];
         lcsYeast.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
        { dbawFermentables.AddXY(i+1, mma.MinUse, mma.Name, $00C20606);
         ylist[1]:= mma.MinUse;
         ylist[2]:= mma.AvUse;
         ylist[3]:= mma.MaxUse;
         ylist[4]:= mma.MaxUse;
         dbawFermentables.ListSource.SetYList(i, ylist);}
       end;

       maxl:= 0;
       maxr:= 0;
       //num:= RC.AnalyseMiscs(lett, snm);
       for i:= 0 to High(RC.MiscMinMaxArray) do
       begin
         mma:= RC.MiscMinMaxArray[i];
         lcsMisc.Add(i+1, mma.PercRecipes, mma.Name, $005AC850);
         lcsMiscBW.Add(i+1, mma.MinUse, mma.Name, $00C20606);
         ylist[1]:= mma.MinUse;
         ylist[2]:= mma.AvUse;
         ylist[3]:= mma.MaxUse;
         ylist[4]:= mma.MaxUse;
         lcsMiscBW.SetYList(i, ylist);
         if mma.PercRecipes > maxl then maxl:= mma.PercRecipes;
         if mma.MaxUse > maxr then maxr:= mma.MaxUse;
       end;
       if maxr > 0 then latMiscRight.Scale:= maxl / maxr;

       //num:= RC.AnalyseRecipes(lett, snm);
       for i:= 0 to High(RC.CommonMinMaxArray) do
       begin
         mma:= RC.CommonMinMaxArray[i];
         lcsCommon.Add(i+1, mma.MinUse, mma.Name, $00C20606);
         ylist[1]:= mma.MinUse;
         ylist[2]:= mma.AvUse;
         ylist[3]:= mma.MaxUse;
         ylist[4]:= mma.MaxUse;
         lcsCommon.SetYList(i, ylist);
       end;
       pcAnalysis.Visible:= TRUE;
     end;
   end
   else
   begin
     //hide and empty graph
     pcAnalysis.Visible:= false;
     lcsFermBars.Clear;
     dbawFermentables.Clear;
     lcsHop.Clear;
     lcsHopBW.Clear;
     lcsYeast.Clear;
     lcsMisc.Clear;
     lcsMiscBW.Clear;
     lcsCommon.Clear;
   end;
 end;

 procedure TfrmMain.tvBrewsKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
 begin
   case key of
   45: bbNewBrewClick(self); //Ins
   46: if bbRemove.Enabled then bbRemoveBrewClick(self); //del
   end;
 end;


 Procedure TfrmMain.UpdateAndStoreCheckList(Rec : TRecipe);
 var R : TRecipe;
     i, n, g : longint;
 begin
   if Rec.RecType = rtBrew then
   begin
     FUserclicked:= false;
     R:= Brews.FindByAutoNr(Rec.AutoNr.Value);
     if R <> NIL then
     begin
       n:= Rec.CheckList.NumItemsChecked;
       R.CheckList.Assign(Rec.CheckList);
       i:= R.CheckList.NumItemsChecked;
       n:= Rec.CheckList.NumItemsChecked;
       g:= Rec.CheckList.NumGroups;
       if (FSelBrew = R) then
       begin
         if (FTemporary.RecType = rtBrew) and (FTemporary.AutoNr.Value = Rec.AutoNr.Value) then
         begin
           g:= Rec.CheckList.NumGroups;
           FTemporary.CheckList.Assign(Rec.CheckList);
           i:= FTemporary.CheckList.NumItemsChecked;
           n:= Rec.CheckList.NumItemsChecked;
           FSelBrew.Assign(FTemporary);
           i:= FSelBrew.CheckList.NumItemsChecked;
           n:= Rec.CheckList.NumItemsChecked;
         end;
       end;
       Brews.SaveXML;
       i:= R.CheckList.NumItemsChecked;
     end;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.tvBrewsSelectionChanged(Sender: TObject);
     procedure UpdateTheList();
     var i : integer;
     begin

         pcAnalysis.Visible:= false;
         sgIngredients.Editor:= NIL;
         FSelBrew:= NIL;
         FSelIngredient:= NIL;

         case cbBrewsSort.ItemIndex of
         0: bbRemoveBrew.Enabled:= ((tvBrews.Selected <> NIL) and (tvBrews.Selected.Level = 1));
         1, 2: bbRemoveBrew.Enabled:= ((tvBrews.Selected <> NIL) and (tvBrews.Selected.Level = 3));
         end;
         miBrewsDelete.Enabled:= bbRemoveBrew.Enabled;
         miDivideBrew.Enabled:= bbRemoveBrew.Enabled;

         if (tvBrews.Selected <> NIL) and (tvBrews.Selected.Data <> NIL) then
           FSelBrew:= TRecipe(tvBrews.Selected.Data);
         FSelected:= FSelBrew;
         if FSelected <> NIL then
         begin
           FTemporary.Assign(FSelected);
           FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
           pmBrews.Items[1].Enabled:= TRUE;
           pmBrews.Items[3].Enabled:= TRUE;
           pmBrews.Items[4].Enabled:= TRUE;
           pmBrews.Items[6].Enabled:= TRUE;
           pmBrews.Items[9].Enabled:= TRUE;
           pmBrews.Items[11].Enabled:= TRUE;
           pcAnalysis.Visible:= false;
           Self.Caption:=Application.Name + ' - ' + FTemporary.Name.Value;
         end
         else
         begin
           pmBrews.Items[1].Enabled:= false;
           pmBrews.Items[3].Enabled:= false;
           pmBrews.Items[4].Enabled:= false;
           pmBrews.Items[6].Enabled:= false;
           pmBrews.Items[9].Enabled:= false;
           pmBrews.Items[11].Enabled:= false;
           FillAnalyseCharts;
           Self.Caption:=Application.Name;
         end;
         pcRecipe.Visible:= (FSelBrew <> NIL);
         sgIngredients.Row:= 0;
         if cbPercentage.Checked then
         begin
       //    FTemporary.CalcOG;
       //    fseOG.Value:= FTemporary.EstOGFermenter.Value;
           fseOG.Value:= FTemporary.EstOG.Value;
         end;
         Update;
         UpdateGraph;
         UpdatePredictions;
         if FSelected <> NIL then
           if sgIngredients.RowCount > 0 then
           begin
             sgIngredients.Col:= 1;
             sgIngredients.Row:= 0;
           end;
         if sgMashSteps.RowCount > 0 then
           for i:= 0 to sgMashSteps.ColCount - 1 do
             sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
         cbMash.ItemIndex:= -1;
       //  FChanged:= false;
         FMashStep:= -1;
         bbStartMash.Caption:= startmash1;
         NameChange;
         FUserClicked:= TRUE;
         PreviousBrew := tvBrews.Selected;
       end;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     if FSelected <> NIL then
       Store;

     //JR: MISSING: if CANCEL is clicked, reselect previous recipe
     if not FChanged or (AskToSave) then  // User answered YES or NO, we can continue.
        UpdateTheList()
     else begin
       // User CANCELED, so we should select the previous brew.
       tvBrews.Select(PreviousBrew);
       UpdateTheList();
     end;
   end;// else
       //UpdateTheList();
 end;


 procedure TfrmMain.eSearchBrewsChange(Sender: TObject);
 var i : integer;
     R : TRecipe;
     N : TTreeNode;
 begin
   for i:= 0 to tvBrews.Items.Count - 1 do
   begin
     N:= tvBrews.Items.Item[i];
     if N.Data <> NIL then
     begin
       R:= TRecipe(N.Data);
       N.Visible:= (eSearchBrews.Text = '') or R.Filter(eSearchBrews.Text);
     end;
   end;
 end;

 procedure TfrmMain.sbSearchBrewsDeleteClick(Sender: TObject);
 begin
   eSearchBrews.Text:= '';
   eSearchBrewsChange(self);
 end;

 procedure TfrmMain.eSearchRecipesChange(Sender: TObject);
 var i : integer;
     R : TRecipe;
     N : TTreeNode;
 begin
   for i:= 0 to tvRecipes.Items.Count - 1 do
   begin
     N:= tvRecipes.Items.Item[i];
     if N.Data <> NIL then
     begin
       R:= TRecipe(N.Data);
       N.Visible:= (eSearchRecipes.Text = '') or R.Filter(eSearchRecipes.Text);
     end;
   end;
 end;

 procedure TfrmMain.sbSearchRecipesDeleteClick(Sender: TObject);
 begin
   eSearchRecipes.Text:= '';
   eSearchRecipesChange(self);
 end;

 procedure TfrmMain.rgBitterhopClick(Sender: TObject);
 begin
   FillAnalyseCharts;
 end;

procedure TfrmMain.tvRecipesKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
 begin
   case key of
   45: bbNewRecipeClick(self); //Ins
   46: if bbRemove.Enabled then bbRemoveRecipeClick(self); //del
   end;
 end;

 Procedure TfrmMain.NameChange;
 //var s : string;
 begin
   if FTemporary <> NIL then
     Caption:= 'BrewBuddy - ' + FTemporary.Name.Value
   else
     Caption:= 'BrewBuddy';
 end;

 procedure TfrmMain.tvRecipesSelectionChanged(Sender: TObject);
 var i : integer;
 begin
   FUserClicked:= false;
   if FSelected <> NIL then Store;
   if FChanged then
     AskToSave;

   pcAnalysis.Visible:= false;
   sgIngredients.Editor:= NIL;
   FSelRecipe:= NIL;
   FSelIngredient:= NIL;

   case cbRecipesSort.ItemIndex of
   0: bbRemoveRecipe.Enabled:= ((tvRecipes.Selected <> NIL) and
              ((tvRecipes.Selected.Level = 1) or (tvRecipes.Selected.Level = 0)));
   1: bbRemoveRecipe.Enabled:= ((tvRecipes.Selected <> NIL) and
              ((tvRecipes.Selected.Level = 3) or (tvRecipes.Selected.Level = 0)));
   end;
   miRecipesDelete.Enabled:= bbRemoveRecipe.Enabled;

   if (tvRecipes.Selected <> NIL) and (tvRecipes.Selected.Data <> NIL) then
     FSelRecipe:= TRecipe(tvRecipes.Selected.Data);
   FSelected:= FSelRecipe;
   if FSelected <> NIL then
   begin
     FTemporary.Assign(FSelected);
     FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
     pmRecipes.Items[1].Enabled:= TRUE;
     pmRecipes.Items[3].Enabled:= TRUE;
     pmRecipes.Items[4].Enabled:= TRUE;
     pmRecipes.Items[6].Enabled:= TRUE;
     pmRecipes.Items[9].Enabled:= TRUE;
   end
   else
   begin
     pmRecipes.Items[1].Enabled:= false;
     pmRecipes.Items[3].Enabled:= false;
     pmRecipes.Items[4].Enabled:= false;
     pmRecipes.Items[6].Enabled:= false;
     pmRecipes.Items[9].Enabled:= false;
     FillAnalyseCharts;
   end;
   pcRecipe.Visible:= (FSelRecipe <> NIL);
   if cbPercentage.Checked then
   begin
 //    FTemporary.CalcOG;
 //    fseOG.Value:= FTemporary.EstOGFermenter.Value;
     fseOG.Value:= FTemporary.EstOG.Value;
   end;
   Update;
   UpdateGraph;
   if sgIngredients.RowCount > 0 then
   begin
     sgIngredients.Col:= 1;
     sgIngredients.Row:= 0;
   end;
   if sgMashSteps.RowCount > 0 then
     for i:= 0 to sgMashSteps.ColCount - 1 do
       sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
   cbMash.ItemIndex:= -1;
   FMashStep:= -1;
   bbStartMash.Caption:= startmash1;
   NameChange;
  // FChanged:= false;
   FUserClicked:= TRUE;
 end;
{
 procedure TfrmMain.tvCloudSelectionChanged(Sender: TObject);
 var i : integer;
 begin
   FUserClicked:= false;
   if FChanged then
     AskToSave;

   pcAnalysis.Visible:= false;
   sgIngredients.Editor:= NIL;
   FSelRecipe:= NIL;
   FSelBrew:= NIL;
   FSelCloud:= NIL;
   FSelIngredient:= NIL;

   case cbCloudSort.ItemIndex of
   0: bbRemoveCloudRecipe.Enabled:= ((tvCloud.Selected <> NIL) and (tvCloud.Selected.Level = 1));
   1, 2: bbRemoveCloudRecipe.Enabled:= ((tvCloud.Selected <> NIL) and (tvCloud.Selected.Level = 3));
   end;
   miCloudDelete.Enabled:= bbRemoveCloudRecipe.Enabled;

   //if (tvCloud.Selected <> NIL) and (tvCloud.Selected.Data <> NIL) then
   //  if BHCloud.LoadRecipeByName(TBHCloudFile(tvCloud.Selected.Data).FileName.Value) then
   //    FSelCloud:= BHCloud.Recipe;

   FSelected:= FSelCloud;
   if FSelected <> NIL then
   begin
     FSelected.Locked.Value:= TRUE;
     FTemporary.Assign(FSelected);
     FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
     pmCloud.Items[0].Enabled:= TRUE;
     pmCloud.Items[1].Enabled:= TRUE;
     pmCloud.Items[3].Enabled:= TRUE;
     pmCloud.Items[4].Enabled:= TRUE;
     pmCloud.Items[6].Enabled:= TRUE;
     pcAnalysis.Visible:= false;
   end
   else
   begin
     pmCloud.Items[0].Enabled:= false;
     pmCloud.Items[1].Enabled:= false;
     pmCloud.Items[3].Enabled:= false;
     pmCloud.Items[4].Enabled:= false;
     pmCloud.Items[6].Enabled:= false;
     {FillAnalyseCharts;}
   end;
   pcRecipe.Visible:= (FSelCloud <> NIL);
   sgIngredients.Row:= 0;
   if cbPercentage.Checked then
     fseOG.Value:= FTemporary.EstOG.Value;
   if FSelCloud <> NIL then FSelCloud.RecalcPercentages;
   Update;
   UpdateGraph;
   if sgMashSteps.RowCount > 0 then
     for i:= 0 to sgMashSteps.ColCount - 1 do
       sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
   cbMash.ItemIndex:= -1;
   FChanged:= false;
   FMashStep:= -1;
   NameChange;
   FUserClicked:= TRUE;
 end;

 procedure TfrmMain.tvCloudKeyDown(Sender: TObject; var Key: Word;
   Shift: TShiftState);
 begin
   case key of
 //  45: bbNewRecipeClick(self); //Ins
   46: if bbRemoveCloudRecipe.Enabled then bbRemoveCloudRecipeClick(self); //del
   end;
 end;

 procedure TfrmMain.bbRemoveCloudRecipeClick(Sender: TObject);
 //var BHCF : TBHCloudFile;
 //    pn, tn, ns : TTreeNode;
 //    i : integer;
 begin
   //if (tvCloud.Selected <> NIL) then
   //begin
   //  BHCF:= TBHCloudFile(tvCloud.Selected.Data);
   //  if Question(self, cloudremove1 + BHCF.RecName.Value + cloudremove2) then
   //  begin
   //    BHCF.ShowRecipe.Value:= false;
   //    BHCloud.SaveXML;
   //    FUserClicked:= false;
   //
   //    tn:= tvCloud.Selected.GetNextSibling;
   //    if tn = NIL then tn:= tvCloud.Selected.GetPrevSibling;
   //    if tn = NIL then
   //    begin
   //      pn:= tvCloud.Selected.Parent;
   //      if pn <> NIL then
   //        ns:= pn.GetNextSibling;
   //        if ns <> NIL then
   //          tn:= ns.GetFirstChild;
   //    end;
   //    ns:= NIL;
   //    if (tn = NIL) and (pn <> NIL) then
   //      ns:= pn.GetPrevSibling;
   //    if ns <> NIL then
   //      tn:= ns.GetFirstChild;
   //
   //    tvCloud.Selected.Delete;
   //    for i:= 0 to sgIngredients.RowCount - 1 do sgIngredients.RowHeights[i]:= 20;
   //    if tn <> nil then tn.Selected:= TRUE;
   //    FSelCloud:= NIL;
   //    FSelected:= NIL;
   //    FChanged:= TRUE;
   //    FUserClicked:= TRUE;
   //  end;
   //end;
 end;
}
 procedure TfrmMain.bbLogoClick(Sender: TObject);
 begin
   if opdLogo.Execute then
   begin
     try
       iLogo.Picture.LoadFromFile(opdLogo.FileName);
       iLogo.Picture.SaveToFile(Settings.DataLocation.Value + 'logo.png', 'png');
     finally
     end;
   end;
 end;

 {==============================================================================}

 procedure TfrmMain.fseBatchSizeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     if cbScaleVolume.Checked then
     begin
       FTemporary.Scale(fseBatchSize.Value);
       if (FTemporary.Mash <> NIL) and (FTemporary.Mash.MashStep[0] <> NIL) then
         fseInfuseAmount.Value:= FTemporary.Mash.MashStep[0].InfuseAmount.DisplayValue
       else if FTemporary.Water[0] <> NIL then
       begin
         fseInfuseAmount.Value:= FTemporary.Water[0].Amount.DisplayValue;
         if FTemporary.Water[1] <> NIL then
           fseInfuseAmount.Value:= FTemporary.Water[0].Amount.DisplayValue +
                                   FTemporary.Water[1].Amount.DisplayValue;
       end;
     end
     else
     begin
       FTemporary.BatchSize.DisplayValue:= fseBatchSize.Value;
       FTemporary.CalcWaterBalance;
       if (cbPercentage.Checked) then
       begin //calculate fermentable amounts, OG does not change
         FTemporary.CalcFermentablesFromPerc(fseOG.Value);
       end
       else
       begin //calculate new OG
         FTemporary.CalcOG;
         fseOG.Value:= FTemporary.EstOG.Value;
 //        fseOG.Value:= FTemporary.EstOGFermenter.Value;
       end;
     end;
     Update;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 Procedure TFrmMain.SetIcon;
 var n : longint;
     Node : TTreeNode;
 begin
   Node:= NIL;
   if pcRecipes.ActivePage = tsBrews then Node:= tvBrews.Selected
   else if pcRecipes.ActivePage = tsRecipes then Node:= tvRecipes.Selected;
   if (FTemporary <> NIL) and (Node <> NIL) then
   begin
     FTemporary.CalcNumMissingIngredients;
     n:= FTemporary.NumMissingIngredients;
     if Settings.ShowPossibleWithStock.Value then
     begin
       if FTemporary.Locked.Value then
       begin
         if n = 0 then Node.StateIndex:= 16
         else if n <= 2 then Node.StateIndex:= 17
         else Node.StateIndex:= 18;
       end
       else
       begin
         if n = 0 then Node.StateIndex:= 13
         else if n <= 2 then Node.StateIndex:= 14
         else Node.StateIndex:= 15;
       end;
     end
     else
     begin
       if FTemporary.Locked.Value then Node.StateIndex:= 12
       else Node.StateIndex:= 0;
     end;
   end;
 end;

 procedure TfrmMain.cbLockedChange(Sender: TObject);
 //var n : TTreeNode;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     Screen.Cursor:= crHourglass;
     Cursor:= crHourglass;
     Application.ProcessMessages;
     FTemporary.Locked.Value:= cbLocked.Checked;
     Store;
     FSelected.Assign(FTemporary);
     Brews.SaveXML;

     if (not FTemporary.InventoryReduced.Value) and (FTemporary.Locked.Value) then
       bbInventory.Color:= clFuchsia
     else
       bbInventory.Color:= clDefault;

     //n:= tvBrews.Items.FindNodeWithData(FSelected);
     SetIcon;

     Application.ProcessMessages;
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
     FChanged:= false;
   end;
 end;

 procedure TfrmMain.cbScaleVolumeChange(Sender: TObject);
 begin
 //  FChanged:= TRUE;
   if FUserClicked then
   begin
     Settings.ScaleWithVolume.Value:= cbScaleVolume.Checked;
     Settings.Save;
   end;
 end;

 procedure TfrmMain.cbTypeChange(Sender: TObject);
 begin
   FChanged:= TRUE;
 end;

 procedure TfrmMain.cbPercentageChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     SetReadOnly(fseOG, (not cbPercentage.Checked));
     //    FChanged:= TRUE;
     //check if at least 1 (base) malt has AdjustToTotal100 on TRUE

     Update;
     Settings.Percentages.Value:= cbPercentage.Checked;
     Settings.Save;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseEfficiencyChange(Sender: TObject);
 var ibu, bindex : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Efficiency:= fseEfficiency.Value;
     if cbPercentage.Checked then
     begin //calculate fermentable amounts, OG does not change
       Update;
       FChanged:= TRUE;
     end
     else
     begin //calculate new OG
       ibu:= FTemporary.IBUcalc.Value;
       bindex:= -1;
       if FTemporary.EstOG.Value > 1 then
         bindex:= ibu / (1000 * (FTemporary.EstOG.Value - 1));
       FTemporary.CalcOG;
       fseOG.Value:= FTemporary.EstOG.Value;
       if ibu > 0 then
         if Settings.SGBitterness.Value = 0 then
           FTemporary.AdjustBitterness(ibu)
         else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
           FTemporary.AdjustBitterness(1000 * (FTemporary.EstOG.Value - 1) * bIndex);
       Update;
       FChanged:= TRUE;
     end;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseOGChange(Sender: TObject);
 var ibu, bindex : double;
 begin
   if (cbPercentage.Checked) and (FSelected <> NIL) and FUserClicked then
   begin
     ibu:= FTemporary.IBUcalc.Value;
     bindex:= -1;
     if FTemporary.EstOG.Value > 1 then
       bindex:= ibu / (1000 * (FTemporary.EstOG.Value - 1));
     FUserClicked:= false;
     FTemporary.EstOG.DisplayValue:= fseOG.Value;
     FTemporary.CalcFermentablesFromPerc(FTemporary.EstOG.Value);
     FChanged:= TRUE;
     if ibu > 0 then
       if Settings.SGBitterness.Value = 0 then
         FTemporary.AdjustBitterness(ibu)
       else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
         FTemporary.AdjustBitterness(1000 * (FTemporary.EstOG.Value - 1) * bIndex);
     Update;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseIBUChange(Sender: TObject);
 var x, a : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     a:= FTemporary.GetAromaBitterness;
     x:= fseIBU.Value;
     if x < a then
     begin
       x:= a;
       fseIBU.Value:= a;
     end;
     FTemporary.AdjustBitterness(x);
     FChanged:= TRUE;
     UpdateIngredientsGrid;
     eBUGU.Text:= RealToStrDec(FTemporary.BUGU, 2);
     if FTemporary.BUGU < 0.32 then lBUGU.Caption:= ibugu5
     else if FTemporary.BUGU < 0.43 then lBUGU.Caption:= ibugu4
     else if FTemporary.BUGU < 0.52 then lBUGU.Caption:= ibugu3
     else if FTemporary.BUGU < 0.63 then lBUGU.Caption:= ibugu2
     else lBUGU.Caption:= ibugu1;
     x:= FTemporary.IBUcalc.Value;
     piBitterness.Value:= x;
     piBUGU.Value:= FTemporary.BUGU;
     FUserClicked:= TRUE;
     fseTopupwaterchange(self);
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilTimeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (not FByCode) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.BoilTime.DisplayValue:= fseBoilTime.Value;
     FChanged:= TRUE;
     Update;
     CalcMash;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eNameChange(Sender: TObject);
 begin
   if FUserclicked then
   begin
     FUserClicked:= false;
     if pcRecipes.ActivePage = tsBrews then tvBrews.Selected.Text:= eNrRecipe.Text + ' ' + eName.Text
     else tvRecipes.Selected.Text:= eNrRecipe.Text + ' '+ eName.Text;
     if FSelected <> NIL then FTemporary.Name.Value:= eName.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eNrRecipeChange(Sender: TObject);
 begin
   if FUserclicked then
   begin
     FUserClicked:= false;
     if pcRecipes.ActivePage = tsBrews then tvBrews.Selected.Text:= eNrRecipe.Text + ' ' + eName.Text
     else tvRecipes.Selected.Text:= eNrRecipe.Text + ' '+ eName.Text;
     if FSelected <> NIL then
     begin
       FTemporary.NrRecipe.Value:= eNrRecipe.Text;
       FChanged:= TRUE;
     end;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbBeerStyleChange(Sender: TObject);
 var sel : TRecipe;
 begin
   if (cbBeerStyle.ItemIndex > -1) and (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Style.Assign(TBeerStyle(BeerStyles.Item[cbBeerStyle.ItemIndex]));
     FSelected.Assign(FTemporary);
     sel:= FSelected;
     if pcRecipes.ActivePage = tsBrews then Brews.SaveXML
     else Recipes.SaveXML;
     FChanged:= false;
     if ((pcRecipes.ActivePage = tsBrews) and (cbBrewsSort.ItemIndex = 1)) or
        ((pcRecipes.ActivePage = tsRecipes) and (cbRecipesSort.ItemIndex = 1)) then
     begin
       SortByStyle(pcRecipes.ActivePage);
       FSelected:= sel;
       if pcRecipes.ActivePage = tsBrews then
         tvBrews.Selected:= tvBrews.Items.FindNodeWithData(FSelected)
       else
         tvRecipes.Selected:= tvRecipes.Items.FindNodeWithData(FSelected);
     end;
     Update;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbEquipmentChange(Sender: TObject);
 var L : boolean;
 begin
   if (cbEquipment.ItemIndex > -1) and (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Equipment.Assign(TEquipment(Equipments.Item[cbEquipment.ItemIndex]));
     if FTemporary.Equipment.KettleVolume.Value > 0 then
     begin
 //      fseBatchSize.MaxValue:= FTemporary.Equipment.KettleVolume.DisplayValue;
 //      FTemporary.BatchSize.MaxValue:= FTemporary.Equipment.KettleVolume.Value;
     end;
     FTemporary.Scale(FTemporary.Equipment.BatchSize.Value);
     FTemporary.BoilTime.Value:= FTemporary.Equipment.BoilTime.Value;
     if FTemporary.Mash <> NIL then
     begin
       FTemporary.Mash.MashWaterVolume:= FTemporary.Equipment.MashVolume.Value;
       FTemporary.Mash.TunSpecificHeat.Assign(FTemporary.Equipment.TunSpecificHeat);
       FTemporary.Mash.TunWeight.Assign(FTemporary.Equipment.TunWeight);
     end;
     L:= FTemporary.LockEfficiency;
     FTemporary.Efficiency:= FTemporary.Equipment.Efficiency.Value;
     fseEfficiency.Value:= FTemporary.Efficiency;
     FTemporary.LockEfficiency:= L;

    { if cbPercentage.Checked then //calculate fermentable amounts
       FTemporary.CalcFermentablesFromPerc(FTemporary.EstOGFermenter.Value)
     else //calculate OG
     begin
       FTemporary.CalcOG;
       fseOG.Value:= FTemporary.EstOGFermenter.Value;
     end;}
     Update;
     UpdatePredictions;

     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 Procedure TFrmMain.SortIngredients(I1, I2 : integer);
 begin
   if FSelected <> NIL then
   begin
     if FSort = I1 then FSortDec:= not FSortDec
     else FSortDec:= false;
     FSort:= I1;
     FTemporary.SortFermentables(I1, I2, FSortDec, FSortDec);
     FTemporary.SortHops(I1, I2, FSortDec, FSortDec);
     FTemporary.SortMiscs(I1, I2, FSortDec, FSortDec);
     FTemporary.SortYeasts(I1, I2, FSortDec, FSortDec);
     FTemporary.SortWaters(I1, I2, FSortDec, FSortDec);
     UpdateIngredientsgrid;
   end;
 end;

 procedure TfrmMain.hcIngredientsSectionClick(
   HeaderControl: TCustomHeaderControl; Section: THeaderSection);
 begin
    case Section.Index of
   0: SortIngredients(2, 0);
   1: SortIngredients(0, 2);
 //  3: SortIngredients(7, 0);
   4: SortIngredients(3, 0);
   end;
 end;

 procedure TfrmMain.sgIngredientsDrawCell(Sender: TObject; aCol, aRow: Integer;
   aRect: TRect; aState: TGridDrawState);
 var rect : TRect;
 begin
   if (aRow >= Low(FIngredientGridColors)) and (aRow <= High(FIngredientGridcolors)) then
   begin
     if aCol = 4 then sgIngredients.Canvas.Brush.Color:= FInventoryColors[aRow]
     else sgIngredients.Canvas.Brush.Color:= FIngredientGridColors[aRow];
   end;
   sgIngredients.canvas.fillrect(arect);
   if (gdSelected in aState) then
   begin
     sgIngredients.Canvas.Font.Style:= [fsBold, fsItalic];
     sgIngredients.Canvas.Font.Color:= clBlack;
   end
   else
   begin
     sgIngredients.Canvas.Font.Style:= [];
     sgIngredients.Canvas.Font.Color:= clBlack;
   end;

   sgIngredients.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2,
                                sgIngredients.Cells[ACol, ARow]);

   if (sgIngredients.Row = aRow) and (sgIngredients.Col = aCol) and (sgIngredients.Editor = fseGrid) then
   begin
     if (sgIngredients.TopRow <= aRow) and (sgIngredients.TopRow + round(sgIngredients.Height / sgIngredients.DefaultRowHeight) > aRow) then
     begin
       rect:= sgIngredients.CellRect(aCol, aRow);
       fseGrid.BoundsRect:= rect;
       fseGrid.Visible:= TRUE;
     end
     else
       fseGrid.Visible:= false;
   end;
   if (sgIngredients.TopRow > FIGSCY) or (sgIngredients.TopRow + round(sgIngredients.Height / sgIngredients.DefaultRowHeight) <= FIGSCY) then
     fseGrid.Visible:= false;
 end;

 Procedure TfrmMain.UpdateIngredientsGrid;
 var s : string;
     char : string[1];
     i, j, k : integer;
     it, it2 : TIngredientType;
     ing, ing3 : TIngredient;
     ing2 : TIngredient;
     F : TFermentable;
     H, H2 : THop;
     Y : TYeast;
     M : TMisc;
     perc, x, n, ni : double;
 begin
   SetLength(FIngredientGridColors, 0);
   SetLength(FInventoryColors, 0);

   if FSelected <> NIL then
   begin
     FTemporary.SortFermentables(2, 20, true, false);
     FSortGrid:= (sgIngredients.Editor = NIL);
     if FSortGrid then
     begin
       FTemporary.SortFermentables(20, 2, true, true);
       FTemporary.SortFermentables(2, -1, true, true);
       FTemporary.SortHops(9, 2, true, true);
       FTemporary.SortMiscs(6, 0, false, false);
     end;

     for i:= 0 to sgIngredients.RowCount - 1 do
       for j:= 0 to 4 do
         sgIngredients.Cells[j, i]:= '';

     sgIngredients.RowCount:= FTemporary.NumIngredients;

     if sgIngredients.RowCount > 0 then
       for i:= 0 to 4 do
         sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;

     SetLength(FIngredientGridColors, FTemporary.NumIngredients);
     SetLength(FInventoryColors, FTemporary.NumIngredients);
     for i:= 0 to FTemporary.NumIngredients - 1 do
     begin
       ing:= FTemporary.Ingredient[i];
       it:= ing.IngredientType;
       if it = itFermentable then
       begin
         F:= TFermentable(ing);
         sgIngredients.Cells[0, i]:= F.Amount.DisplayString;
         s:= ing.Name.Value;
         s:=s + ' (' + F.Color.DisplayString + ')';
         sgIngredients.Cells[1, i]:= s;
         FIngredientGridColors[i]:= FermentableColor;
       end
       else if it = itHop then
       begin
         H:= THop(ing);
         s:= H.Name.Value;
         case H.Use of
         huBoil:
         begin
           s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '% @ ' + H.Time.DisplayString + ')';
         end;
         huDryhop, huMash, huFirstwort, huAroma, huWhirlpool:
         begin
           s:= s + ' (' + RealToStrDec(H.AlfaAdjusted, 1) + '%, ' + HopUseDisplayNames[H.Use] + ')';
         end;
         end;
         sgIngredients.Cells[0, i]:= H.Amount.DisplayString;

         sgIngredients.Cells[1, i]:= s;
         FIngredientGridColors[i]:= HopColor;
       end
       else if it = itYeast then
       begin
         Y:= TYeast(ing);
         sgIngredients.Cells[0, i]:= Y.AmountYeast.DisplayString;
         sgIngredients.Cells[1, i]:= Y.Laboratory.Value + ' ' + Y.ProductID.Value + ' ' + Y.Name.Value;
         FIngredientGridColors[i]:= YeastColor;
       end
       else if it = itWater then
       begin
         s:= ing.Name.Value;
         j:= FindPart(water1, LowerCase(s));
         if j = 0 then
         begin
           char:= rightstr(s, 1);
           if (char = 'a') or (char = 'e') or (char = 'i') or (char = 'o') or (char = 'u')
               or (char = 's') then
             s:= s + '''';
           if char = 's' then
             s:= s + water2
           else
             s:= s + water3;
         end;
         sgIngredients.Cells[0, i]:= ing.Amount.DisplayString;
         FIngredientGridColors[i]:= WaterColor;
         sgIngredients.Cells[1, i]:= s;
       end
       else if it = itMisc then
       begin
         M:= TMisc(ing);
         sgIngredients.Cells[0, i]:= M.Amount.DisplayString;
         if M.Use = muBoil then
           sgIngredients.Cells[1, i]:= ing.Name.Value + ' @ ' + M.Time.DisplayString
         else
           sgIngredients.Cells[1, i]:= ing.Name.Value;
         if TMisc(ing).MiscType = mtWaterAgent then
           FIngredientGridColors[i]:= WaterAgentColor
         else if TMisc(ing).MiscType = mtFining then
           FIngredientGridColors[i]:= FiningColor
         else
           FIngredientGridColors[i]:= MiscColor;
       end;

       sgIngredients.Cells[2, i]:= IngredientTypeDisplayNames[it];

       case it of
       itFermentable:
       begin
         if cbPercentage.Checked then
           perc:= TFermentable(ing).Percentage.Value
         else
           Perc:= FTemporary.GetPercFermentable(i);
         sgIngredients.Cells[3, i]:= RealToStrDec(Perc, 1) + '%';
         ing2:= Fermentables.FindByNameAndSupplier(ing.Name.Value, TFermentable(ing).Supplier.Value);
         if ing2 <> NIL then sgIngredients.Cells[4, i]:= TFermentable(ing2).Inventory.DisplayString
         else sgIngredients.Cells[4, i]:= RealToStrDec(0, ing.Amount.Decimals) + ' ' + ing.Amount.DisplayUnitString;
       end;
       itHop:
       begin
         x:= THop(ing).BitternessContribution;
         s:= RealToStrDec(x, 1) + ' IBU';
         sgIngredients.Cells[3, i]:= s;
         ing2:= Hops.FindByNameAndOriginAndAlfa(ing.Name.Value, THop(ing).Origin.Value, THop(ing).Alfa.Value);
         if ing2 <> NIL then sgIngredients.Cells[4, i]:= THop(ing2).Inventory.DisplayString
         else sgIngredients.Cells[4, i]:= RealToStrDec(0, ing.Amount.Decimals) + ' ' + ing.Amount.DisplayUnitString;
       end;
       itMisc:
       begin
         ing2:= TMisc(Miscs.FindByName(ing.Name.Value));
         if ing2 <> NIL then sgIngredients.Cells[4, i]:= TMisc(ing2).Inventory.DisplayString
         else sgIngredients.Cells[4, i]:= RealToStrDec(0, ing.Amount.Decimals) + ' ' + ing.Amount.DisplayUnitString;
       end;
       itYeast:
       begin
         ing2:= Yeasts.FindByNameAndLaboratory(ing.Name.Value, TYeast(ing).Laboratory.Value);
         if (ing2 <> NIL) and (ing2.Inventory.vUnit = ing.Inventory.vUnit) then sgIngredients.Cells[4, i]:= TYeast(ing2).Inventory.DisplayString
         else sgIngredients.Cells[4, i]:= RealToStrDec(0, ing.Amount.Decimals) + ' ' + TYeast(ing).AmountYeast.DisplayUnitString;
       end;
       end;

       FInventoryColors[i]:= FIngredientGridColors[i];
       if it <> itWater then
       begin
         s:= ing.Name.Value;
         n:= ing.Amount.Value;
         if ing2 <> NIL then ni:= ing2.Inventory.Value
         else ni:= 0;
         if (it <> itYeast) and (it <> itHop) then
         begin
           if n > ni then FInventoryColors[i]:= clRed;
         end
         else if (it = itHop) and (ing2 <> NIL) then
         begin
           for k:= 0 to FTemporary.NumIngredients - 1 do
             if i <> k then
             begin
               ing3:= FTemporary.Ingredient[k];
               it2:= ing3.IngredientType;
               if it2 = itHop then
               begin
                 H2:= THop(ing3);
                 if (H.Name.Value = H2.Name.Value) and (H.Alfa.Value = H2.Alfa.Value)
                    and (H.Origin.Value = H2.Origin.Value) then
                 begin
                   n:= n + H2.Amount.Value;
                 end;
               end;
             end;
           if ((ing2.Inventory.vUnit = THop(ing).Amount.vUnit) and (n > ni)) or
               (ing2.Inventory.vUnit <> THop(ing).Amount.vUnit) then
             FInventoryColors[i]:= clRed;
         end
         else if (ing2 <> NIL) then
         begin
           if ((ing2.Inventory.vUnit = TYeast(ing).AmountYeast.vUnit) and (n > ni)) or
               (ing2.Inventory.vUnit <> TYeast(ing).AmountYeast.vUnit) then
             FInventoryColors[i]:= clRed;
         end
         else FInventoryColors[i]:= clRed;
       end;

       sgIngredients.RowHeights[i]:= 20;
     end;
   end;
 end;

 procedure TfrmMain.bbNewBrewClick(Sender: TObject);
 var Node : TTreeNode;
     Rec : TRecipe;
     BS : TBeerstyle;
 begin
   AskToSave;

   FUserClicked:= false;
   eSearchBrews.Text:= '';
   FrmChooseBrewChars:= TFrmChooseBrewChars.Create(self);
   if cbBrewsSort.ItemIndex = 1 then
   begin
     Node:= tvBrews.Selected;
     if Node.Level = 3 then
       Node:= Node.Parent;
     if Node.Level = 2 then
     begin
       BS:= TBeerstyle(Beerstyles.FindByName(Node.Text));
       FrmChooseBrewChars.Beerstyle:= BS;
     end;
   end;
   if FrmChooseBrewChars.Execute(true) then
   begin
     FSelBrew:= Brews.AddItem;
     Rec:= FSelBrew;
     FSelBrew.NrRecipe.Value:= FrmChooseBrewChars.NrRecipe;
     FSelBrew.Name.Value:= FrmChooseBrewChars.Name;
     FSelBrew.Style.Assign(FrmChooseBrewChars.Beerstyle);
     FSelBrew.Equipment.Assign(FrmChooseBrewChars.Equipment);
     FSelBrew.Date.Value:= FrmChooseBrewChars.BrewDate;
     FSelBrew.RecType:= rtBrew;

     cbBrewsSortChange(self);
     Node:= tvBrews.Items.FindNodeWithData(Rec);
     if Node <> NIL then Node.Selected:= TRUE;

     FSelected:= FSelBrew;
     if FSelected <> NIL then
     begin
       FTemporary.Assign(FSelected);
       FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
     end;
     FTemporary.ColormethodDisplayName:= cbColorMethod.Items[cbColormethod.ItemIndex];
     FTemporary.IBUmethodDisplayName:= cbIBUMethod.Items[cbIBUmethod.ItemIndex];
     if FSelBrew <> NIL then
     begin
       FTemporary.AutoNr.Value:= Brews.MaxAutoNr + 1;
       FTemporary.Efficiency:= 75;
       FTemporary.BoilTime.Value:= 90;
       if FTemporary.Equipment <> NIL then
       begin
         FTemporary.Efficiency:= FTemporary.Equipment.Efficiency.Value;
         FTemporary.BoilTime.Value:= FTemporary.Equipment.BoilTime.Value;
         FTemporary.BatchSize.Value:= FTemporary.Equipment.BatchSize.Value;
       end;
       if FTemporary.Mash <> NIL then
         FTemporary.Mash.MashWaterVolume:= FTemporary.Equipment.MashVolume.Value;

       if cbPercentage.Checked then FTemporary.EstOG.Value:= 1.050;

       Update;
       UpdatePredictions;
       cbLocked.Checked:= false;
       FUserClicked:= false;
       cbLockedClick(NIL);
       FUserClicked:= TRUE;
       SetIcon;
       FChanged:= TRUE;
     end;
   end;
   FrmChooseBrewChars.Free;
   FUserClicked:= TRUE;
 end;

 procedure TfrmMain.bbNewRecipeClick(Sender: TObject);
 var Node : TTreeNode;
     Rec: TRecipe;
     BS : TBeerstyle;
 begin
   AskToSave;

   FUserClicked:= false;
   eSearchRecipes.Text:= '';
   FrmChooseBrewChars:= TFrmChooseBrewChars.Create(self);
   if cbRecipesSort.ItemIndex = 1 then
   begin
     Node:= tvRecipes.Selected;
     if (Node <> NIL) and (Node.Level = 3) then
       Node:= Node.Parent;
     if (Node <> NIL) and (Node.Level = 2) then
     begin
       BS:= TBeerstyle(Beerstyles.FindByName(Node.Text));
       FrmChooseBrewChars.Beerstyle:= BS;
     end;
   end;
   if FrmChooseBrewChars.Execute(false) then
   begin
     FSelRecipe:= Recipes.AddItem;

     FSelRecipe.Name.Value:= FrmChooseBrewChars.Name;
     FSelRecipe.Style.Assign(FrmChooseBrewChars.Beerstyle);
     FSelRecipe.Equipment.Assign(FrmChooseBrewChars.Equipment);
     FSelRecipe.RecType:= rtRecipe;
     Rec:= FSelRecipe;

     cbRecipesSortChange(self);
     Node:= tvRecipes.Items.FindNodeWithData(Rec);
     Node.Selected:= TRUE;

     FSelected:= FSelRecipe;
     if FSelected <> NIL then
     begin
       FTemporary.Assign(FSelected);
       FTemporary.AutoNr.Value:= FSelected.AutoNr.Value;
     end;
     FTemporary.ColormethodDisplayName:= cbColorMethod.Items[cbColormethod.ItemIndex];
     FTemporary.IBUmethodDisplayName:= cbIBUMethod.Items[cbIBUmethod.ItemIndex];
     if FSelRecipe <> NIL then
     begin
       FTemporary.AutoNr.Value:= Recipes.MaxAutoNr + 1;
       FTemporary.Efficiency:= 75;
       FTemporary.BoilTime.Value:= 90;
       FTemporary.BatchSize.Value:= 25;
       if FTemporary.Equipment <> NIL then
       begin
         FTemporary.Efficiency:= FTemporary.Equipment.Efficiency.Value;
         FTemporary.BoilTime.Value:= FTemporary.Equipment.BoilTime.Value;
         FTemporary.BatchSize.Value:= FTemporary.Equipment.BatchSize.Value;
       end;
       if FTemporary.Mash <> NIL then
         FTemporary.Mash.MashWaterVolume:= FTemporary.Equipment.MashVolume.Value;

       if cbPercentage.Checked then FTemporary.EstOG.Value:= 1.050;

       Update;
       cbLocked.Checked:= false;
       FUserClicked:= false;
       cbLockedClick(NIL);
       FChanged:= TRUE;
     end;
   end;
   FrmChooseBrewChars.Free;
   FUserClicked:= TRUE;
 end;

 procedure TfrmMain.bbRemoveBrewClick(Sender: TObject);
 var i : integer;
     pn, tn, ns : TTreeNode;
 begin
   if Question(self, remove1a + FSelBrew.Name.Value + remove2) then
   begin
     eSearchBrews.Text:= '';
     FUserClicked:= false;
     if FSelBrew <> NIL then Brews.RemoveByReference(FSelBrew);
     FChanged:= false;

     tn:= tvBrews.Selected.GetNextSibling;
     if tn = NIL then tn:= tvBrews.Selected.GetPrevSibling;
     if tn = NIL then
     begin
       pn:= tvBrews.Selected.Parent;
       if pn <> NIL then
         ns:= pn.GetNextSibling;
         if ns <> NIL then
           tn:= ns.GetFirstChild;
     end;
     ns:= NIL;
     if (tn = NIL) and (pn <> NIL) then
       ns:= pn.GetPrevSibling;
     if ns <> NIL then
       tn:= ns.GetFirstChild;

     tvBrews.Selected.Delete;
     for i:= 0 to sgIngredients.RowCount - 1 do sgIngredients.RowHeights[i]:= 20;
     if tn <> nil then tn.Selected:= TRUE;
     FSelBrew:= NIL;
     UpdatePredictions;
     FSelected:= NIL;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbRemoveRecipeClick(Sender: TObject);
 var i : integer;
     pn, tn, ns : TTreeNode;
 begin
   tn:= tvRecipes.Selected;
   if tn.Level = 0 then
   begin
     if Question(self, remove3) and
        Question(self, remove4) then
     begin
       Recipes.FreeCollection;
       cbRecipesSortChange(self);
       Recipes.SaveXML;
     end;
   end
   else
     if Question(self, remove1a + FSelRecipe.Name.Value + remove2) then
     begin
       if FSelRecipe <> NIL then Recipes.RemoveByReference(FSelRecipe);
       FChanged:= false;
       tn:= tvRecipes.Selected.GetNextSibling;
       if tn = NIL then tn:= tvRecipes.Selected.GetPrevSibling;
       if tn = NIL then
       begin
         pn:= tvRecipes.Selected.Parent;
         if pn <> NIL then
           ns:= pn.GetNextSibling;
           if ns <> NIL then
             tn:= ns.GetFirstChild;
       end;
       ns:= NIL;
       if (tn = NIL) and (pn <> NIL) then
         ns:= pn.GetPrevSibling;
       if ns <> NIL then
         tn:= ns.GetFirstChild;
       tvRecipes.Selected.Delete;
       for i:= 0 to sgIngredients.RowCount - 1 do sgIngredients.RowHeights[i]:= 20;
       if tn <> nil then tn.Selected:= TRUE;
      { FSelRecipe:= NIL;
       FSelected:= NIL;}
       FChanged:= TRUE;
     end;
 end;

 procedure TfrmMain.bbAddGrainClick(Sender: TObject);
 var F : TFermentable;
     i, j : integer;
     prca : array of double;
     v, vr : double;
     OK : boolean;
 begin
   try
     OK:= TRUE;
     if FTemporary.Efficiency <= 0 then
     begin
       ShowNotification(self, missingefficiency1);
       OK:= false;
     end;
     if (cbPercentage.Checked) and (FTemporary.EstOG.Value <= 1.000) then
     begin
       ShowNotification(self, missingog1);
       OK:= false;
     end;
     if OK then
     begin
       CheckTotal100;
       if sgIngredients.Editor = fseGrid then
       begin
         sgIngredientsEditingDone(self);
         sgIngredients.Editor:= NIL;
       end;
       if cbPercentage.Checked then
       begin
         Setlength(prca, FTemporary.NumFermentables);
         j:= High(prca);
         for i:= 0 to j do
           prca[i]:= FTemporary.Fermentable[i].Percentage.Value;
       end;
       FrmFermentables3:= TFrmFermentables3.Create(self);
       if FrmFermentables3.Execute(FTemporary.AddFermentable, cbPercentage.Checked) then
       begin
         F:= FTemporary.Fermentable[FTemporary.NumFermentables-1];
         v:= F.Percentage.Value;
         if cbPercentage.Checked then
         begin
           for i:= 0 to j do
             FTemporary.Fermentable[i].Percentage.Value:= prca[i];
           FTemporary.CheckPercentage;
           v:= F.Percentage.Value;
           fseGrid.Value:= v;
           sgIngredients.Editor:= NIL;
         end
         else
         begin
           FTemporary.RecalcPercentages;
           v:= F.Amount.DisplayValue;
           fseGrid.Value:= v;
           sgIngredients.Editor:= NIL;
         end;
         Update;
         UpdatePredictions;
         v:= F.Percentage.Value;
         vr:= F.MaxInBatch.Value;
         if (vr > 0) and (v > vr) then
           ShowNotificationModal(self, perctoohigh1 + F.Name.Value + perctoohigh2);
         CheckTotal100;
         FChanged:= TRUE;
       end
       else
         FTemporary.RemoveFermentable(FTemporary.NumFermentables-1);
       if cbPercentage.Checked then
         SetLength(prca, 0);
       SetIcon;
     end;
   finally

     FrmFermentables3.Free;
     if FTemporary.NumIngredients = 1 then
       for i:= 0 to 4 do
         sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
   end;
 end;

 procedure TfrmMain.sbGristWizardClick(Sender: TObject);
 begin
   CheckTotal100;
   FrmGristWizard:= TFrmGristWizard.Create(self);
   if FTemporary.EstOG.Value = 1 then FTemporary.EstOG.Value:= 1.050;
   if FrmGristWizard.Execute(FTemporary) then
   begin
     Update;
     UpdatePredictions;
     FChanged:= TRUE;
     SetIcon;
   end;
   FreeAndNIL(FrmGristWizard);
 end;

 procedure TfrmMain.sbHopWizardClick(Sender: TObject);
 begin
   FrmHopWizard:= TFrmHopWizard.Create(self);
   if FrmHopWizard.Execute(FTemporary) then
   begin
     Update;
     UpdatePredictions;
     FChanged:= TRUE;
     SetIcon;
   end;
   FreeAndNIL(FrmHopWizard);
 end;

 procedure TfrmMain.bbAddHopClick(Sender: TObject);
 var H : THop;
     i : integer;
 begin
   try
     FrmHop3:= TFrmHop3.Create(self);
     H:= FTemporary.AddHop;
     H.Time.Value:= FTemporary.BoilTime.Value;
     if FrmHop3.Execute(H) then
     begin
       if (H.Use = huBoil) and (H.Time.Value > FTemporary.BoilTime.Value) then
         H.Time.Value:= FTemporary.BoilTime.Value;
       Update;
       UpdatePredictions;
       FChanged:= TRUE;
     end
     else
       FTemporary.RemoveHop(FTemporary.NumHops-1);
     SetIcon;
   finally
     FrmHop3.Free;
     if FTemporary.NumIngredients = 1 then
       for i:= 0 to 4 do
         sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
   end;
 end;

 procedure TfrmMain.bbAddMiscClick(Sender: TObject);
 var Ing : TMisc;
     i : integer;
 begin
   try
     FrmMiscs3:= TFrmMiscs3.Create(self);
     Ing:= FTemporary.AddMisc;
     if FrmMiscs3.Execute(Ing) then
     begin
       if (Ing.Use = muBoil) and (Ing.Time.Value > FTemporary.BoilTime.Value) then
         Ing.Time.Value:= FTemporary.BoilTime.Value;
       Update;
       UpdatePredictions;
       if ing.MiscType = mtWaterAgent then FTemporary.CalcMashWater;
       FChanged:= TRUE;
     end
     else
       FTemporary.RemoveMisc(FTemporary.NumMiscs-1);
     SetIcon;
   finally
     FrmMiscs3.Free;
     if FTemporary.NumIngredients = 1 then
       for i:= 0 to 4 do
         sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
   end;
 end;

 procedure TfrmMain.bbAddYeastClick(Sender: TObject);
 var Ing : TYeast;
     i : integer;
 begin
   try
     FrmYeasts3:= TFrmYeasts3.Create(self);
     Ing:= FTemporary.AddYeast;
     if FrmYeasts3.Execute(Ing) then
     begin
       Update;
       UpdatePredictions;
       FChanged:= TRUE;
     end
     else
       FTemporary.RemoveYeast(FTemporary.NumYeasts-1);
     SetIcon;
   finally
     FrmYeasts3.Free;
     if FTemporary.NumIngredients = 1 then
       for i:= 0 to 4 do
         sgIngredients.ColWidths[i]:= hcIngredients.Sections[i].Width;
   end;
 end;

procedure TfrmMain.bbRemoveClick(Sender: TObject);
 var IsFermentable, IsMisc : boolean;
 begin
   if FSelected <> NIL then
   begin
     IsFermentable:= FTemporary.Ingredient[sgIngredients.Row] is TFermentable;
     IsMisc:= FTemporary.Ingredient[sgIngredients.Row] is TMisc;
     FTemporary.RemoveIngredient(sgIngredients.Row);
     if IsFermentable then
       if cbPercentage.Checked then FTemporary.CheckPercentage
       else FTemporary.RecalcPercentages;
     if IsMisc and (TMisc(FTemporary.Ingredient[sgIngredients.Row]).MiscType = mtWaterAgent) then
       FTemporary.CalcMashWater;
     FChanged:= TRUE;
     sgIngredients.Editor:= NIL;
     Update;
     UpdatePredictions;
     SetIcon;
   end;
 end;

 procedure TfrmMain.sgIngredientsDblClick(Sender: TObject);
 var ibu, bindex : double;
 begin
   if (not cbLocked.Checked) and (FSelIngredient <> NIL) then
   begin
     case FSelIngredient.IngredientType of
     itFermentable:
     begin
       ibu:= FTemporary.IBUcalc.Value;
       bindex:= -1;
       if FTemporary.EstOG.Value > 1 then
         bindex:= ibu / (1000 * (FTemporary.EstOG.Value - 1));
       FrmFermentables2:= TFrmFermentables2.Create(self);
       FChanged:= FrmFermentables2.Execute(TFermentable(FSelIngredient), cbPercentage.Checked,
                                FTemporary.TotalFermentableMass);
       FrmFermentables2.Free;
       if cbPercentage.Checked then FTemporary.CheckPercentage
       else FTemporary.CalcOG;
       if ibu > 0 then
         if Settings.SGBitterness.Value = 0 then
           FTemporary.AdjustBitterness(ibu)
         else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
           FTemporary.AdjustBitterness(1000 * (FTemporary.EstOG.Value - 1) * bIndex);
     end;
     itHop:
     begin
       FrmHop2:= TFrmHop2.Create(self);
       FChanged:= FrmHop2.Execute(THop(FSelIngredient));
       FrmHop2.Free;
     end;
     itMisc:
     begin
       FrmMiscs2:= TFrmMiscs2.Create(self);
       FChanged:= FrmMiscs2.Execute(TMisc(FSelIngredient));
       FrmMiscs2.Free;
     end;
     itYeast:
     begin
       FrmYeasts2:= TFrmYeasts2.Create(self);
       FChanged:= FrmYeasts2.Execute(TYeast(FSelIngredient));
       FrmYeasts2.Free;
     end;
    { itWater:
     begin
     end;}
     end;
     Update;
     UpdatePredictions;
     SetIcon;
   end;
 end;

 procedure TfrmMain.sgIngredientsSelectCell(Sender: TObject; aCol,
   aRow: Integer; var CanSelect: Boolean);
 begin
   sgIngredients.Editor:= NIL;
   if FTemporary <> NIL then
     FSelIngredient:= FTemporary.Ingredient[aRow];
 end;

 procedure TfrmMain.sgIngredientsSelectEditor(Sender: TObject; aCol,
   aRow: Integer; var Editor: TWinControl);
 var r : TRect;
     v : double;
     //s : string;
     Y : TYeast;
 begin
   Editor:= NIL;
   FSelIngredient:= FTemporary.Ingredient[sgIngredients.Row];
   FIGLastRow:= aRow;
   if (not cbLocked.Checked) and (FTemporary <> NIL) and (FSelIngredient <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     r:= sgIngredients.CellRect(aCol, aRow);
     if (Editor = NIL) and (aRow >= 0) and (aCol = 0) and (sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row] <> '') then
     begin
       if FSelIngredient.IngredientType = itYeast then
       begin
         Y:= TYeast(FSelIngredient);
         fseGrid.BoundsRect:= r;
         fseGrid.DecimalPlaces:= Y.AmountYeast.Decimals;
         fseGrid.MaxValue:= Y.AmountYeast.MaxValue;
         //s:= Y.Name.Value;
         v:= Y.AmountYeast.DisplayValue;
         fseGrid.Value:= v;
         Editor:= fseGrid;
       end
       else if not ((FSelIngredient.IngredientType = itFermentable) and (cbPercentage.Checked)) then
       begin
         fseGrid.BoundsRect:= r;
         fseGrid.DecimalPlaces:= FSelIngredient.Amount.Decimals;
         fseGrid.MaxValue:= FSelIngredient.Amount.MaxValue;
         //s:= FSelIngredient.Name.Value;
         v:= FSelIngredient.Amount.DisplayValue;
         fseGrid.Value:= v;
         Editor:= fseGrid;
       end
     end
     else if (Editor = NIL) and (aRow >= 0) and (aCol = 3) and (sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row] <> '') then
     begin
       if FSelIngredient.IngredientType = itFermentable then
       begin
         if (cbPercentage.Checked) and (not TFermentable(FSelIngredient).AdjustToTotal100.Value)  then
         begin
           fseGrid.BoundsRect:= r;
           fseGrid.DecimalPlaces:= TFermentable(FSelIngredient).Percentage.Decimals;
           fseGrid.MaxValue:= 100;
           fseGrid.Value:= TFermentable(FSelIngredient).Percentage.DisplayValue;
           Editor:= fseGrid;
         end
         else
         begin
           Editor:= NIL;
           fseGrid.Visible:= false;
           FSortGrid:= TRUE;
         end;
       end
       else if (FSelIngredient.IngredientType = itHop) and (THop(FSelIngredient).BitternessContribution > 0) then
       begin
         fseGrid.BoundsRect:= r;
         fseGrid.DecimalPlaces:= 1;
         fseGrid.MaxValue:= fseIBU.MaxValue;
         fseGrid.Value:= THop(FSelIngredient).BitternessContribution;
         Editor:= fseGrid;
       end;
     end
     else
     begin
       Editor:= NIL;
       fseGrid.Visible:= false;
       FSortGrid:= TRUE;
     end;
     FUSerClicked:= TRUE;
   end
   else
     Editor:= NIL;
   if Editor <> NIL then
   begin
     FIGSCX:= aCol;
     FIGSCY:= aRow;
   end
   else
   begin
     FIGSCX:= -1;
     FIGSCY:= 0;
   end;
 end;

 procedure TfrmMain.fseGridChange(Sender: TObject);
 var W1, W2 : TWater;
     tot, v, vr : double;
     ibu, bindex : double;
     F : TFermentable;
 begin
   if (FSelIngredient <> NIL) and (FUserClicked) and (fseGrid.Modified) then
   begin
     FUserClicked:= false;
     FSortGrid:= false;
     case sgIngredients.Col of
     0:
       begin
         if FSelIngredient.IngredientType = itYeast then
         begin
           TYeast(FSelIngredient).AmountYeast.DisplayValue:= fseGrid.Value;
           fseAmountYeast.Value:= fseGrid.Value;
         end
         else if FSelIngredient.IngredientType = itWater then
         begin
           if (FTemporary.Mash <> NIL) then
           begin
             FUserClicked:= false;
             fseInfuseAmount.Value:= fseGrid.Value;
             if FTemporary.Mash.MashStep[0] <> NIL then
               TMashStep(FTemporary.Mash.MashStep[0]).InfuseAmount.DisplayValue:= fseInfuseAmount.Value;
             FChanged:= TRUE;
             W1:= FTemporary.Water[0];
             W2:= FTemporary.Water[1];
             Tot:= 0;
             if W1 <> NIL then Tot:= W1.Amount.DisplayValue;
             if W2 <> NIL then Tot:= Tot + W2.Amount.DisplayValue;
             if (W1 = NIL) and (W2 = NIL) then
             begin
               W1:= FTemporary.AddWater;
               W1.Name.Value:= water4;
               W1.Amount.DisplayValue:= fseInfuseAmount.Value;
             end
             else if (W1 <> NIL) and (W2 = NIL) then
             begin
               W1.Amount.DisplayValue:= fseInfuseAmount.Value;
             end
             else if (W1 <> NIL) and (W2 <> NIL) and (Tot > 0) then
             begin
               W1.Amount.Value:= W1.Amount.Value * (fseInfuseAmount.Value / Tot);
               W2.Amount.Value:= W2.Amount.Value * (fseInfuseAmount.Value / Tot);
             end;
           end;
           CalcMash;
           UpdatePredictions;
         end
         else if FSelIngredient.IngredientType = itFermentable then
         begin
           ibu:= FTemporary.IBUcalc.Value;
           bindex:= -1;
           if FTemporary.EstOG.Value > 1 then
             bindex:= ibu / (1000 * (FTemporary.EstOG.Value - 1));
           FSelIngredient.Amount.DisplayValue:= fseGrid.Value;
           FTemporary.CalcOG;
           if ibu > 0 then
             if Settings.SGBitterness.Value = 0 then
               FTemporary.AdjustBitterness(ibu)
             else if (Settings.SGBitterness.Value = 1) and (bindex > -0.5) then
               FTemporary.AdjustBitterness(1000 * (FTemporary.EstOG.Value - 1) * bIndex);
           F:= TFermentable(FSelIngredient);
           v:= F.Percentage.Value;
           vr:= F.MaxInBatch.Value;
           if (vr > 0) and (v > vr) then
             ShowNotificationModal(self, perctoohigh1 + F.Name.Value + perctoohigh2);
         end
         else
           FSelIngredient.Amount.DisplayValue:= fseGrid.Value;
         Update;
         UpdatePredictions;
       end;
     3:
       begin
         if FSelIngredient.IngredientType = itFermentable then
         begin
           TFermentable(FSelIngredient).Percentage.Value:= fseGrid.Value;
           FTemporary.CheckPercentage;
           F:= TFermentable(FSelIngredient);
           v:= F.Percentage.Value;
           vr:= F.MaxInBatch.Value;
           if (vr > 0) and (v > vr) then
             ShowNotificationModal(self, perctoohigh1 + F.Name.Value + perctoohigh2);
         end
         else if FSelIngredient.IngredientType = itHop then
           THop(FSelIngredient).BitternessContribution:= fseGrid.Value;
         Update;
         UpdatePredictions;
       end;
     end;
     SetIcon;
     fseGrid.Enabled:= TRUE;
     FChanged:= TRUE;

     FUserClicked:= TRUE;
     FSortGrid:= TRUE;
   end;
 end;

 procedure TfrmMain.fseGridEditingDone(Sender: TObject);
 begin
  { FUserClicked:= false;
   if (sgIngredients.Row >= 0) and (sgIngredients.Col = 0) and
      (sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row] <> '') then
     sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row]:=
       FSelIngredient.Amount.DisplayString
   else if (sgIngredients.Row >= 0) and (sgIngredients.Col = 3) and
           (sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row] <> '') then
   begin
     if (FSelIngredient.IngredientType = itFermentable) and cbPercentage.Checked then
      sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row]:=
           TFermentable(FSelIngredient).Percentage.DisplayString
     else if (FSelIngredient.IngredientType = itHop) and (THop(FSelIngredient).BitternessContribution > 0) then
      sgIngredients.Cells[sgIngredients.Col, sgIngredients.Row]:=
           RealToStrDec(THop(FSelIngredient).BitternessContribution, 1);
   end;
   FUserClicked:= TRUE;}
 end;

 procedure TfrmMain.sgIngredientsEditingDone(Sender: TObject);
 begin
 end;

 procedure TfrmMain.sgIngredientsExit(Sender: TObject);
 begin
   sgIngredients.Editor:= NIL;
   FSortGrid:= TRUE;
 end;

 procedure TfrmMain.bbInventoryClick(Sender: TObject);
 var i : integer;
     Ing : TIngredient;
     H, H2 : THop;
 begin
   if not FTemporary.InventoryReduced.Value then
   begin
     for i:= 0 to FTemporary.NumFermentables - 1 do
     begin
       Ing:= Fermentables.FindByNameAndSupplier(FTemporary.Fermentable[i].Name.Value,
                                                FTemporary.Fermentable[i].Supplier.Value);
       if Ing <> NIL then
         Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Fermentable[i].Amount.Value;
     end;
     If FTemporary.NumFermentables > 0 then
       Fermentables.SaveXML;
     if FTemporary.NumHops > 0 then
     begin
       for i:= 0 to FTemporary.NumHops - 1 do
       begin
         H2:= FTemporary.Hop[i];
         H:= Hops.FindByNameAndOriginAndAlfa(H2.Name.Value, H2.Origin.Value, H2.Alfa.Value);
         if H <> NIL then
           H.Inventory.Value:= H.Inventory.Value - H2.Amount.Value;
       end;
       Hops.SaveXML;
     end;
     if FTemporary.NumMiscs > 0 then
     begin
       for i:= 0 to FTemporary.NumMiscs - 1 do
       begin
         Ing:= TIngredient(Miscs.FindByName(FTemporary.Misc[i].Name.Value));
         if Ing <> NIL then
           Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Misc[i].Amount.Value;
       end;
       Miscs.SaveXML;
     end;
     If FTemporary.NumYeasts > 0 then
     begin
       for i:= 0 to FTemporary.NumYeasts - 1 do
       begin
         Ing:= Yeasts.FindByNameAndLaboratory(FTemporary.Yeast[i].Name.Value,
                                              FTemporary.Yeast[i].Laboratory.Value);
         if (Ing <> NIL) and (TYeast(Ing).Form = FTemporary.Yeast[i].Form) then
         begin
           case FTemporary.Yeast[i].Form of
           yfLiquid: Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Yeast[i].AmountYeast.Value;
           yfDry: Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Yeast[i].AmountYeast.Value;
           yfSlant: Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Yeast[i].AmountYeast.Value;
           yfCulture: Ing.Inventory.Value:= Ing.Inventory.Value - FTemporary.Yeast[i].AmountYeast.Value;
           yfBottle: Ing.Inventory.Value:= Ing.Inventory.Value - 1;
           end;
         end;
       end;
       Yeasts.SaveXML;
     end;

     FTemporary.InventoryReduced.Value:= TRUE;
     Brews.SaveXML;
     UpdateIngredientsGrid;
     bbInventory.Enabled:= false;
     FChanged:= TRUE;
   end;
 end;

 {============================= Water and mash =================================}

 Procedure TfrmMain.CalcMash;
 var i : integer;
     Mash : tMash;
     MStep : TMashStep;
     s : string;
     GrM, Vwater, Vol, VolMalt, evap, spdspc, mashvol, x, Vk, Vcm : double;
     un, dsplun : TUnit;
 begin
   FByCode:= TRUE;
   FUserClicked:= false;
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) then
   begin
     Mash:= FTemporary.Mash;
     Mash.CalcMash;
    { if (cbMash.ItemIndex < 0) and (mash.NumMashSteps >= 1) then
       cbMash.ItemIndex:= 0;}

     sgMashSteps.RowCount:= Mash.NumMashSteps;
     GrM:= FTemporary.GrainMassMash;
     Vwater:= 0;
     VolMalt:= GrM * MaltVolume;
     SetLength(FColorCells, 0);
     if Mash.NumMashSteps > 0 then
     begin
       for i:= 0 to Mash.NumMashSteps - 1 do
       begin
         MStep:= FTemporary.Mash.MashStep[i];
         if (i = 0) and (MStep.MashStepType = mstInfusion) then
           MStep.InfuseAmount.DisplayValue:= fseInfuseAmount.Value;

         s:= MStep.Name.Value;
         if s = '' then s:= 'Stap ' + IntToStr(i+1);
         sgMashSteps.Cells[0, i]:= s;
         sgMashSteps.Cells[1, i]:= MStep.TypeDisplayName;
         sgMashSteps.Cells[2, i]:= MStep.StepTemp.DisplayString;
         sgMashSteps.Cells[3, i]:= MStep.EndTemp.DisplayString;
         sgMashSteps.Cells[4, i]:= MStep.RampTime.DisplayString;
         sgMashSteps.Cells[5, i]:= MStep.StepTime.DisplayString;
         sgMashSteps.Cells[6, i]:= MStep.InfuseTemp.DisplayString;
         sgMashSteps.Cells[7, i]:= MStep.InfuseAmount.DisplayString;
         if MStep.MashStepType = mstInfusion then
           VWater:= Vwater + MStep.InfuseAmount.Value;
         Vol:= VolMalt + Vwater;
         Vol:= Convert(MStep.InfuseAmount.vUnit, MStep.InfuseAmount.DisplayUnit, Vol);
         sgMashSteps.Cells[8, i]:= RealToStrDec(Vol, MStep.InfuseAmount.Decimals)
                                     + ' ' + MStep.InfuseAmount.DisplayUnitString;

         if FTemporary.Equipment <> NIL then
         begin
           x:= Convert(FTemporary.BatchSize.vUnit, FTemporary.BatchSize.DisplayUnit,
                       FTemporary.Equipment.VolumeInTun(0.01));
           if Vol > x then
           begin
             SetLength(FColorCells, High(FColorCells) + 2);
             FColorCells[High(FColorCells)].Col:= 8;
             FColorCells[High(FColorCells)].Row:= i;
           end;
         end;

         vol:= MStep.WaterToGrainRatio;
         sgMashSteps.Cells[9, i]:= RealToStrDec(vol, 2) + ' l/kg';
         if (i = 0) and (cbTunTemp.Checked) then
           seTunTemp.Value:= round(FTemporary.Mash.TunTemp.DisplayValue);
       end;
     end
     else
     begin
       VWater:= fseInfuseAmount.Value;
     end;

     //Calculate boilsize, sparge water
     volMalt:= FTemporary.GrainMassMash * Settings.GrainAbsorption.Value;
     if FTemporary.Equipment <> NIL then spdspc:= FTemporary.Equipment.LauterDeadSpace.Value
     else spdspc:= 0;

     evap:=  FTemporary.BoilSize.Value - FTemporary.BatchSize.Value;
     mashvol:= VWater;// / ExpansionFactor;
     vol:= FTemporary.BoilSize.Value - mashvol + volmalt + spdspc;

     un:= FTemporary.BatchSize.vUnit;
     dsplun:= FTemporary.BatchSize.DisplayUnit;

     FUserClicked:= false;
     eMashWater.Text:= RealToStrDec(Convert(un, dsplun, {ExpansionFactor *} VWater), 1);
     eGrainAbsorption.Text:= RealToStrDec(Convert(un, dsplun, {ExpansionFactor *} volMalt), 1);
     fseSpargeDeadSpace.Value:= Convert(un, dsplun, {ExpansionFactor *} spdspc);
     eSpargeWater.Caption:= RealToStrDec(Convert(un, dsplun, {ExpansionFactor *} vol), 1);
 //    x:= ExpansionFactor * FTemporary.BoilSize.Value;
     if FTemporary.Equipment <> NIL then
     begin
       Vk:= FTemporary.Equipment.KettleVolume.Value;
       if FTemporary.Equipment.KettleHeight.Value > 0 then
         Vcm:= FTemporary.Equipment.KettleVolume.Value / (100 * FTemporary.Equipment.KettleHeight.Value)
       else Vcm:= 1;
       if x >= Vk then eBoilSize.Color:= clRed
       else if x >= Vk - 3 * Vcm then eBoilSize.Color:= clYellow //3 cm of boilspace is required
       else eBoilSize.Color:= clScrollBar;
     end;
     x:= ExpansionFactor * FTemporary.BoilSize.DisplayValue;
     eBoilSize.Text:= RealToStrDec(x, 1);
     x:= Convert(un, dsplun, ExpansionFactor * evap);
     fseEvaporation.Value:= x;
     x:= ExpansionFactor * FTemporary.BatchSize.Value;
     if FTemporary.Equipment <> NIL then
     begin
       if x >= Vk then eAfterBoil.Color:= clRed
       else eAfterBoil.Color:= clScrollBar;
     end;
     x:= ExpansionFactor * FTemporary.BatchSize.DisplayValue;
     eAfterBoil.Text:= RealToStrDec(x, 1);
     eAfterCooling.Text:= RealToStrDec(FTemporary.BatchSize.DisplayValue, 1);
     fseChillerLoss.Value:= FTemporary.Equipment.TrubChillerLoss.DisplayValue;
     eToFermenter.Text:= RealToStrDec(FTemporary.BatchSize.DisplayValue - FTemporary.Equipment.TrubChillerLoss.DisplayValue, 1);
     fseTopUpWater.Value:= FTemporary.Equipment.TopUpWater.DisplayValue;
     eVolumeFermenter.Text:= RealToStrDec(FTemporary.BatchSize.DisplayValue -
                                          FTemporary.Equipment.TrubChillerLoss.DisplayValue
                                          + fseTopUpWater.Value, 1);

     FUserClicked:= TRUE;
     if Convert(un, dsplun, VWater) > 0 then
       eSpMa.Text:= RealToStrDec(Convert(un, dsplun, vol) / Convert(un, dsplun, VWater), 2)
     else eSpMa.Text:= '0';
   end;
   FByCode:= false;
   FUserClicked:= TRUE;
 end;

procedure TfrmMain.cbMashChange(Sender: TObject);
 var Mash : tMash;
     i : integer;
 begin
   if FUserclicked and (cbMash.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     Mash:= tMash(Mashs.Item[cbMash.ItemIndex]);
     if (Mash <> NIL)  and (not FByCode) then
     begin
       FTemporary.Mash.Assign(Mash);
       FTemporary.Mash.TunWeight.Value:= FTemporary.Equipment.TunWeight.Value;
       FTemporary.Mash.TunSpecificHeat.Value:= FTemporary.Equipment.TunSpecificHeat.Value;
       FUserClicked:= TRUE;
       fseInfuseAmountChange(sender);
 {      CalcMash;
       UpdatePredictions;}
       FUserClicked:= false;
       if sgMashSteps.RowCount > 0 then
         for i:= 0 to sgMashSteps.ColCount - 1 do
           sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
       FChanged:= TRUE;
     end;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.sgMashStepsDblClick(Sender: TObject);
 var MStep : TMashStep;
     FRM : TFrmMashStep;
     i : integer;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL)  then
   begin
     if FTemporary.Mash <> NIL then
     begin
       MStep:= FTemporary.Mash.MashStep[sgMashSteps.Row];
       if MStep <> NIL then
       begin
       //open mash step form
         FRM:= TFrmMashStep.Create(Self);
         FRM.Execute(MStep);
         FRM.Free;
       end;
       if (sgMashSteps.Row = 0) and (MStep.MashStepType = mstInfusion) then
         MStep.InfuseAmount.DisplayValue:= fseInfuseAmount.Value;
       CalcMash;
       UpdatePredictions;
     end;
     if sgMashSteps.RowCount > 0 then
       for i:= 0 to sgMashSteps.ColCount - 1 do
         sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
     FTemporary.CalcMashWater;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.sgMashStepsDrawCell(Sender: TObject; aCol, aRow: Integer;
   aRect: TRect; aState: TGridDrawState);
 var S: string;
     i : integer;
 begin
   for i:= Low(FColorCells) to High(FColorCells) do
     if (ACol = FColorCells[i].Col) and (ARow = FColorCells[i].Row) then
     begin
       sgMashSteps.Canvas.Brush.Color := FWarningColor;
       sgMashSteps.Canvas.FillRect(aRect);
       S := sgMashSteps.Cells[ACol, ARow];
       sgMashSteps.Canvas.TextOut(aRect.Left + 2, aRect.Top + 2, S);
     end;
 end;

 procedure TfrmMain.sgMashStepsMouseMove(Sender: TObject; Shift: TShiftState; X,
   Y: Integer);
 var aCol : LongInt = 0;
     aRow : LongInt = 0;
 begin
   sgMashSteps.MouseToCell(X, Y, aCol, aRow);
   if (aCol < 0) or (aRow < 0) then
   begin
     aCol:= 0;
     aRow:= 0;
   end;

   case aCol of
   0: sgMashSteps.Hint:= sgmashstepshint1;
   1: sgMashSteps.Hint:= sgmashstepshint2;
   2: sgMashSteps.Hint:= sgmashstepshint3;
   3: sgMashSteps.Hint:= sgmashstepshint4;
   4: sgMashSteps.Hint:= sgmashstepshint5;
   5: sgMashSteps.Hint:= sgmashstepshint6;
   6: sgMashSteps.Hint:= sgmashstepshint7;
   7: sgMashSteps.Hint:= sgmashstepshint8;
   8: sgMashSteps.Hint:= sgmashstepshint9;
   9: sgMashSteps.Hint:= sgmashstepshint10;
   end;
 end;

 procedure TfrmMain.bbAddStepClick(Sender: TObject);
 var i, Nr : integer;
     MStep : TMashStep;
     FRM : TFrmMashStep;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL)  then
   begin
     if FTemporary.Mash.NumMashSteps = 0 then
     begin
       sgMashSteps.RowCount:= 1;
       MStep:= FTemporary.Mash.AddMashStep;
       Nr:= 0;
       for i:= 0 to sgMashSteps.ColCount - 1 do
         sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
       i:= 0;
     end
     else if sgMashSteps.Row = 0 then
     begin
       sgMashSteps.InsertColRow(false, 1);
       MStep:= FTemporary.Mash.AddMashStep;
       Nr:= FTemporary.Mash.NumMashSteps - 1;
       i:= 0;
     end
     else if sgMashSteps.Row = sgMashSteps.RowCount - 1 then
     begin
       sgMashSteps.RowCount:= sgMashSteps.RowCount + 1;
       MStep:= FTemporary.Mash.AddMashStep;
       Nr:= FTemporary.Mash.NumMashSteps - 1;
       i:= sgMashSteps.RowCount - 1;
     end
     else
     begin
       sgMashSteps.InsertColRow(false, sgMashSteps.Row);
       MStep:= FTemporary.Mash.InsertMashStep(sgMashSteps.Row);
       Nr:= sgMashSteps.Row - 1;
       i:= sgMashSteps.Row;
     end;
     sgMashSteps.Row:= i;

     if MStep <> NIL then
     begin
     //open mash step form
       FRM:= TFrmMashStep.Create(self);
       if FRM.Execute(MStep) then
       begin
         FChanged:= TRUE;
       end
       else
       begin
         FTemporary.Mash.RemoveMashStep(Nr);
         sgMashSteps.DeleteRow(i);
       end;
       FTemporary.Mash.Sort;
       fseInfuseAmountChange(self);
       CalcMash;
       UpdatePredictions;
       FRM.Free;
     end;
     if sgMashSteps.RowCount > 0 then
       for i:= 0 to sgMashSteps.ColCount - 1 do
         sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
     FTemporary.CalcMashWater;
   end;
 end;

 procedure TfrmMain.bbDeleteStepClick(Sender: TObject);
 var i : integer;
     MStep : TMashstep;
     sn : string;
 begin
   if sgMashSteps.Row > sgMashSteps.FixedRows - 1 then
   begin
     if (FSelected <> NIL) and (FTemporary.Mash <> NIL) then
     begin
       FTemporary.Mash.RemoveMashStep(sgMashSteps.Row-sgMashSteps.FixedRows);
       sgMashSteps.DeleteRow(sgMashSteps.Row);
       for i:= 0 to FTemporary.Mash.NumMashSteps - 1 do
       begin
         MStep:= FTemporary.Mash.MashStep[i];
         sn:= MStep.Name.Value;
         if sn = '' then sn:= mashstep1 + IntToStr(i+1);
         sgMashSteps.Cells[0, i]:= sn;
       end;
       if sgMashSteps.RowCount > 0 then
         for i:= 0 to sgMashSteps.ColCount - 1 do
           sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
       FTemporary.Mash.Sort;
       CalcMash;
       UpdatePredictions;
       FTemporary.CalcMashWater;
       FChanged:= TRUE;
     end;
   end;
 end;

 procedure TfrmMain.hcMashSectionResize(HeaderControl: TCustomHeaderControl;
       Section: THeaderSection);
 var i : integer;
 begin
   if sgMashSteps.RowCount > 0 then
     for i:= 0 to sgMashSteps.ColCount - 1 do
       sgMashSteps.ColWidths[i]:= hcMash.Sections[i].Width;
 end;

 procedure TfrmMain.seGrainTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and (not FByCode) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.GrainTemp.DisplayValue:= seGrainTemp.Value;
     FChanged:= TRUE;
     CalcMash;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.seTunTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and (not FByCode) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.TunTemp.DisplayValue:= seTunTemp.Value;
     FChanged:= TRUE;
     CalcMash;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseInfuseAmountChange(Sender: TObject);
 var W1, W2, W3 : TWater;
     tot : double;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and (FUserClicked) then
   begin
     FUserClicked:= false;
     if FTemporary.Mash.MashStep[0] <> NIL then
       TMashStep(FTemporary.Mash.MashStep[0]).InfuseAmount.DisplayValue:= fseInfuseAmount.Value;
     FChanged:= TRUE;
     W1:= FTemporary.Water[0];
     W2:= FTemporary.Water[1];
     Tot:= 0;
     if W1 <> NIL then Tot:= W1.Amount.DisplayValue;
     if W2 <> NIL then Tot:= Tot + W2.Amount.DisplayValue;
     if (W1 = NIL) and (W2 = NIL) then
     begin
       W3:= Waters.GetDefaultWater;
       W1:= FTemporary.AddWater;
       if W3 <> NIL then W1.Assign(W3)
       else
       begin
         W1.Name.Value:= water4;
         W1.AddMinerals(57, 12, 61, 161, 96, 42);
         W1.pHwater.Value:= 8.2;
       end;
       W1.Amount.DisplayValue:= fseInfuseAmount.Value;
     end
     else if (W1 <> NIL) and (W2 = NIL) then
     begin
       W1.Amount.DisplayValue:= fseInfuseAmount.Value;
     end
     else if (W1 <> NIL) and (W2 <> NIL) and (Tot > 0) then
     begin
       W1.Amount.Value:= W1.Amount.Value * (fseInfuseAmount.Value / Tot);
       W2.Amount.Value:= W2.Amount.Value * (fseInfuseAmount.Value / Tot);
     end;
     FUserClicked:= TRUE;
     CalcMash;
     UpdateIngredientsGrid;
     FTemporary.CalcMashWater;
     UpdatePredictions;
   end;
 end;

 procedure TfrmMain.cbTunTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and (not FByCode) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.EquipAdjust.Value:= not cbTunTemp.Checked;
     SetReadOnly(seTunTemp, cbTunTemp.Checked);
     FChanged:= TRUE;
     CalcMash;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 //procedure TfrmMain.fseSpargeWaterChange(Sender: TObject);
 //var VolMalt, spdspc, evap, sparge, mashvol : double;
 //begin
 //  if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
 //  begin
 //    FUserClicked:= false;
 //    volMalt:= FTemporary.GrainMassMash * Settings.GrainAbsorption.Value;
 //    spdspc:= FTemporary.Equipment.LauterDeadSpace.Value;
 //    evap:=  FTemporary.Equipment.EvapRate.Value / 100 * FTemporary.BoilSize.Value;
 //    sparge:= fseSpargeWater.Value;
 //    mashvol:= ExpansionFactor * FTemporary.BatchSize.Value - sparge + volmalt + spdspc + evap;
 //    if mashvol > 0 then
 //    begin
 //      FTemporary.Mash.MashWaterVolume:= Mashvol;
 //      eMashWater.Text:= RealToStrDec(MashVol, 2);
 //      fseInfuseAmount.Value:= FTemporary.Mash.MashStep[0].InfuseAmount.DisplayValue;
 //    end
 //    else
 //      fseSpargeWater.Value:= Convert(liter, FTemporary.BatchSize.vUnit,
 //                               FTemporary.BatchSize.Value - FTemporary.Mash.MashWaterVolume
 //                               + volmalt + spdspc + evap);
 //    CalcMash;
 //    FChanged:= TRUE;
 //    FUserClicked:= TRUE;
 //  end;
 //end;

 procedure TfrmMain.fseSpargeDeadspaceChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Equipment.LauterDeadSpace.Value:= Convert(FTemporary.BatchSize.vUnit, liter, fseSpargeDeadSpace.Value / ExpansionFactor);
     CalcMash; //calculates right volume of sparge water
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseEvaporationChange(Sender: TObject);
 var evap, ebs : double;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked and (not FByCode) then
   begin
     FUserClicked:= false;
     evap:= Convert(FTemporary.BatchSize.vUnit, liter, fseEvaporation.Value / ExpansionFactor);
     FTemporary.BoilSize.Value:= FTemporary.BatchSize.Value + evap;

     if FTemporary.Equipment <> NIL then
       ebs:= FTemporary.Equipment.BoilSize.Value
     else
       ebs:= FTemporary.BoilSize.Value;
     evap:= 60 * 100 * (FTemporary.BoilSize.Value - FTemporary.BatchSize.Value)
            / (ebs * FTemporary.BoilTime.Value);
     if FTemporary.Equipment <> NIL then
       FTemporary.Equipment.EvapRate.Value:= evap
     else
       ShowNotification(self, missingequipment1);

     CalcMash; //calculates right volume of sparge water
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbWaterWizardClick(Sender: TObject);
 begin
   if (FTemporary.Mash = NIL) or (FTemporary.Mash.NumMashSteps = 0) then
     ShowNotification(self, missingmash1)
   else
   begin
     FrmWaterWizard:= TFrmWaterWizard.Create(self);
     if FrmWaterWizard.Execute(FTemporary) then
     begin
       Update;
       UpdatePredictions;
       FChanged:= TRUE;
       SetIcon;
     end;
     FreeAndNIL(FrmWaterWizard);
   end;
 end;

 procedure TfrmMain.fseChillerLossChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Equipment.TrubChillerLoss.DisplayValue:= fseChillerLoss.Value;
     eToFermenter.Text:= RealToStrDec(FTemporary.BatchSize.DisplayValue
                                - FTemporary.Equipment.TrubChillerLoss.DisplayValue
                                / ExpansionFactor, 2);
     Update;
 //    CalcMash;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTopUpWaterChange(Sender: TObject);
 //var V, V2, x : double;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Equipment.TopUpWater.DisplayValue:= fseTopUpWater.Value;
     fseTopUpWater2.Value:= fseTopUpWater.Value;
 {    V:= FTemporary.BatchSize.DisplayValue
                                - FTemporary.Equipment.TrubChillerLoss.DisplayValue;
     V2:= V + fseTopUpWater.Value;
     if V2 > 0 then
     begin
       eVolumeFermenter.Text:= RealToStrDec(V2, 2) + ' '
                               + FTemporary.BatchSize.DisplayUnitString;
       eSGPreFermentation.Text:= RealToStrDec(1 + (fseOG.Value - 1) *  V / V2, 3)
                                 + ' ' + FTemporary.EstOG.DisplayUnitString;
       x:= FTemporary.IBUcalc.DisplayValue * V / V2;
       eIBUPreFermentation.Text:= RealToStrDec(x, 0) + ' ' + FTemporary.IBUCalc.DisplayUnitString;
       x:= FTemporary.EstColor.DisplayValue * V / V2;
       eEBCPreFermentation.Text:= RealToStrDec(x, 0) + ' ' + FTemporary.EstColor.DisplayUnitString;

       x:= FTemporary.EstColor.Value * V / V2;
       eEBCPreFermentation.Color:= SRMtoColor(x);
       if x < 15 then eEBCPreFermentation.Font.Color:= clBlack
       else eEBCPreFermentation.Font.Color:= clWhite;
       eEBCPreFermentation.Invalidate;
     end;}
     FChanged:= TRUE;
     Update;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbWaterAdjustmentClick(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and (FTemporary.Mash.MashStep[0] <> NIL) then
   begin
     FrmWaterAdjustment:= TFrmWaterAdjustment.Create(self);
     if FrmWaterAdjustment.Execute(FTemporary) then
     begin
       FUserClicked:= false;
       FChanged:= TRUE;
       Update;
       UpdatePredictions;
       FUserClicked:= TRUE;
     end;
     FrmWaterAdjustment.Free;
   end
   else
     ShowNotification(self, missingmash1);
 end;

 {================================== Brewday ===================================}

 procedure TfrmMain.deBrewDateChange(Sender: TObject);
 var sel : TRecipe;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Date.Value:= deBrewDate.Date;
     sel:= FSelected;
   {  if pcRecipes.ActivePage = tsBrews then Brews.SaveXML
     else Recipes.SaveXML;}
     FChanged:= false;
     if ((pcRecipes.ActivePage = tsBrews) and (cbBrewsSort.ItemIndex = 2)) then
     begin
       SortByDate(pcRecipes.ActivePage);
       FSelected:= sel;
       if pcRecipes.ActivePage = tsBrews then
         tvBrews.Selected:= tvBrews.Items.FindNodeWithData(FSelected);
     end;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseMashpHChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.pHAdjusted.DisplayValue:= fseMashpH.Value;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSGendmashChange(Sender: TObject);
 var e : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.SGEndMash.DisplayValue:= fseSGendmash.Value;
     e:= FTemporary.SGEndMashCalc;
     if e > 1.001 then
     begin
       e:= FTemporary.CalcMashEfficiency;
       eEfficiencyMash.Text:= RealToStrDec(e, 1) + '%';
     end
     else eEfficiencyMash.Text:= '';
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSpargeTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.SpargeTemp.DisplayValue:= fseSpargeTemp.Value;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSpargepHChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.pHSparge.DisplayValue:= fseSpargepH.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseLastRunningpHChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.pHLastRunnings.DisplayValue:= fseLastRunningpH.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseLastRunningSGChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Mash.SGLastRunnings.DisplayValue:= fseLastRunningSG.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilpHSChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.pHBeforeBoil.DisplayValue:= fseBoilpHS.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilpHEChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.pHAfterBoil.DisplayValue:= fseBoilpHE.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilSGSChange(Sender: TObject);
 var e : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.OGBeforeBoil.DisplayValue:= fseBoilSGS.Value;
     e:= FTemporary.CalcEfficiencyBeforeBoil;
     if e > 40 then eEfficiencyS.Text:= RealToStrDec(e, 1) + '%'
     else eEfficiencyS.Text:= '';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilSGEChange(Sender: TObject);
 var e : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.OG.DisplayValue:= fseBoilSGE.Value;
     e:= FTemporary.CalcEfficiencyAfterBoil;
     if e > 40 then eEfficiencyE.Text:= RealToStrDec(e, 1) + '%'
     else eEfficiencyE.Text:= '';
     FTemporary.CalcOGFermenter;
     eOGFermenter.Text:= RealToStrDec(FTemporary.OGFermenter.DisplayValue, 3) +
                         ' ' + FTemporary.OGFermenter.DisplayUnitString;
     e:= FTemporary.CalcIBUFermenter;
     eIBUFermenter.Text:= RealToStrDec(e, 0) + ' ' + FTemporary.IBUcalc.DisplayUnitString;
     e:= FTemporary.CalcColorFermenter;
     if FTemporary.EstColor.DisplayUnit = EBC then
       eColorFermenter.Text:= RealToStrDec(SRMtoEBC(e), 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString
     else
       eColorFermenter.Text:= RealToStrDec(e, 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString;

     FTemporary.EstimateFG;
     eFGPredicted.Text:= FTemporary.EstFG2.DisplayString;

     eAAEndPrimary.Caption:= RealToStrDec(FTemporary.AAEndPrimary, 1) + '%';
     e:= FTemporary.OGFermenter.Value;
     e:= ABVol(e, FTemporary.FG.Value);
     FTemporary.ABVcalc.Value:= e;
     eABV.Text:= FTemporary.ABVCalc.DisplayString;
 //    piABV2.Value:= FTemporary.ABVCalc.DisplayValue;
     eAA.Caption:= RealToStrDec(FTemporary.ApparentAttenuation, 1) + '%';
     eRA.Caption:= RealToStrDec(FTemporary.RealAttenuation, 1) + '%';
     FTemporary.CalcCalories;
     eCalories.Text:= FTemporary.Calories.DisplayString;

     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilVolumeSChange(Sender: TObject);
 var e : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.VolumeBeforeBoil.DisplayValue:= fseBoilVolumeS.Value / ExpansionFactor;
     e:= FTemporary.CalcEfficiencyBeforeBoil;
     if e > 40 then eEfficiencyS.Text:= RealToStrDec(e, 1) + '%'
     else eEfficiencyS.Text:= '';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBoilVolumeEChange(Sender: TObject);
 var e : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.VolumeAfterBoil.DisplayValue:= fseBoilVolumeE.Value / ExpansionFactor;
     e:= FTemporary.CalcEfficiencyAfterBoil;
     if e > 40 then eEfficiencyE.Text:= RealToStrDec(e, 1) + '%'
     else eEfficiencyE.Text:= '';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTunCmChange(Sender: TObject);
 var cm : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     cm:= Convert(E.TunHeight.DisplayUnit, E.TunHeight.vUnit, fseTunCm.Value);
     cm:= E.VolumeInTun(cm);
     cm:= Convert(E.TunVolume.vUnit, E.TunVolume.DisplayUnit, cm);
     fseTunVolume.Value:= cm;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTunVolumeChange(Sender: TObject);
 var x : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     x:= fseTunVolume.Value;
     x:= Convert(E.TunVolume.DisplayUnit, E.TunVolume.vUnit, x);
     x:= E.CmInTun(x) / 100;
     x:= Convert(E.TunHeight.vUnit, E.TunHeight.DisplayUnit, x);
     fseTunCm.Value:= x;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseLauterCmChange(Sender: TObject);
 var cm : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     cm:= Convert(E.TunHeight.DisplayUnit, E.TunHeight.vUnit, fseLauterCm.Value);
     cm:= E.VolumeInLautertun(cm);
     cm:= Convert(E.TunVolume.vUnit, E.TunVolume.DisplayUnit, cm);
     fseLauterVolume.Value:= cm;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseLauterVolumeChange(Sender: TObject);
 var x : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     x:= fseLauterVolume.Value;
     x:= Convert(E.LauterVolume.DisplayUnit, E.LauterVolume.vUnit, x);
     x:= E.CmInLautertun(x) / 100;
     x:= Convert(E.LauterHeight.vUnit, E.LauterHeight.DisplayUnit, x);
     fseLauterCm.Value:= x;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseKettleCmChange(Sender: TObject);
 var cm : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     cm:= Convert(E.TunHeight.DisplayUnit, E.TunHeight.vUnit, fseKettleCm.Value);
     cm:= E.VolumeInKettle(cm);
     cm:= Convert(E.TunVolume.vUnit, E.TunVolume.DisplayUnit, cm);
     fseKettleVolume.Value:= cm;
   end;
   FUserClicked:= TRUE;
 end;

 procedure TfrmMain.fseKettleVolumeChange(Sender: TObject);
 var x : double;
     E : TEquipment;
 begin
   if (FSelected <> NIL) and FUserClicked and (cbEquipment.ItemIndex > -1) then
   begin
     FUserClicked:= false;
     E:= FTemporary.Equipment;
     x:= fseKettleVolume.Value;
     x:= Convert(E.KettleVolume.DisplayUnit, E.KettleVolume.vUnit, x);
     x:= E.CmInKettle(x) / 100;
     x:= Convert(E.KettleHeight.vUnit, E.KettleHeight.DisplayUnit, x);
     fseKettleCm.Value:= x;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbStartMashClick(Sender: TObject);
 var h, m, s, mi : word;
 begin
   if (FSelected <> NIL) and (FTemporary.Mash <> NIL) and
       ((FTemporary.Mash.NumMashSteps > 0) or (FMashT <> NIL)) and
      ((FTemporary.Mash.MashStep[0] <> NIL) or (FMashT.MashStep[0] <> NIL)) then
   begin
     eMashTimer.Color:= clWhite;
     eMashTimer.Font.Color:= clBlack;
     if (not tMashTimer.Enabled) and (FMashStep = -1) then //first step must start
     //mash timer is not active
     begin
       FMashStep:= 0;
       FMashT:= TMash.Create(FTemporary);
       FMashT.Assign(FTemporary.Mash);
 //      FMashT:= FTemporary.Mash;
       FTimerMashStep:= FMashT.MashStep[FMashStep];
       s:= round(double(FTimerMashStep.StepTime.Value * 60)); //seconds
       ConvertSeconds(h, m, s, mi);
       FMashTimeLeft:= EncodeTime(h, m, s, mi);
       bbStartMash.Caption:= FTimerMashStep.Name.Value + startmash2;
       tMashTimer.Enabled:= TRUE;
       FTimerMashStep:= FMashT.MashStep[FMashStep];
     end
     else if (tMashTimer.Enabled) and (FMashTimeLeft > 0) then //pause timer during step
     begin
       tMashTimer.Enabled:= false;
       bbStartMash.Caption:= pause1;
     end
     else if (not tMashTimer.Enabled) and (FMashStep > -1) then
     begin
       if FMashTimeLeft > 0 then //resume timer
         bbStartMash.Caption:= FTimerMashStep.Name.Value + startmash2
       else if (FMashStep <= FMashT.NumMashSteps-1) then //start new mash step
       begin
         s:= round(double(FTimerMashStep.StepTime.Value * 60)); //seconds
         ConvertSeconds(h, m, s, mi);
         FMashTimeLeft:= EncodeTime(h, m, s, mi);
         bbStartMash.Caption:= FTimerMashStep.Name.Value + startmash2;
       end;
       tMashTimer.Enabled:= TRUE;
     end;
   end;
 end;

 procedure TfrmMain.tMashTimerTimer(Sender: TObject);
 begin
   FMashTimeLeft:= FMashTimeLeft - tMashTimer.Interval / 86400000; //days
   eMashTimer.Text:= TimeToStr(FMashTimeLeft);
   if (FMashTimeLeft <= (1 / (60 * 24))) and (eMashTimer.Color <> clRed) then
   begin
     eMashTimer.Color:= clred;
     eMashTimer.Font.Color:= clWhite;
   end;
   if FMashTimeLeft <= 0.5 * tMashTimer.Interval / 86400000 then
   begin
     //Set off alarm and notification
     tMashTimer.Enabled:= false;
     PlayAlarm;
     FMashTimeLeft:= 0;
     eMashTimer.Color:= clWhite;
     ShowNotification(self, FTimerMashStep.Name.Value + readymash1);
     Inc(FMashStep);
     if FMashStep <= (FMashT.NumMashSteps - 1) then
     begin
       FTimerMashStep:= FMashT.MashStep[FMashStep];
       bbStartMash.Caption:= startmash3 + FTimerMashStep.Name.Value;
     end
     else
     begin
       FMashStep:= -1;
       bbStartMash.Caption:= startmash1;
       FMashT.Free;
       FMashT:= NIL;
     end;
   end;
 end;

 procedure TfrmMain.bbStartBoilClick(Sender: TObject);
 var h, m, s, mi, i : word;
 begin
   if (FSelected <> NIL) then
   begin
     eBoilTimer.Color:= clWhite;
     eBoilTimer.Font.Color:= clBlack;
     if (not tBoilTimer.Enabled) and (FBoilTimeLeft <= 0) then
     begin
       SetLength(FBoilIngredients, 0);
       for i:= 0 to FTemporary.NumFermentables - 1 do
       begin
         if FTemporary.Fermentable[i].AddedType = atBoil then
         begin
           SetLength(FBoilIngredients, High(FBoilIngredients) + 2);
           FBoilIngredients[High(FBoilIngredients)].Ingredient:= FTemporary.Fermentable[i];
           FBoilIngredients[High(FBoilIngredients)].Time1:= 15 / (24 * 60); //days
           FBoilIngredients[High(FBoilIngredients)].Time2:= 10 / (24 * 60); //days
           FBoilIngredients[High(FBoilIngredients)].Warning1Shown:= false;
           FBoilIngredients[High(FBoilIngredients)].Warning2Shown:= false;
         end;
       end;
       if FTemporary.NumHops > 0 then
         for i:= 0 to FTemporary.NumHops - 1 do
         begin
           if FTemporary.Hop[i].Use = huBoil then
           begin
             SetLength(FBoilIngredients, High(FBoilIngredients) + 2);
             FBoilIngredients[High(FBoilIngredients)].Ingredient:= FTemporary.Hop[i];
             FBoilIngredients[High(FBoilIngredients)].Time1:= (double(FTemporary.Hop[i].Time.Value) + 5) / (24 * 60); //days
             FBoilIngredients[High(FBoilIngredients)].Time2:= double(FTemporary.Hop[i].Time.Value) / (24 * 60); //days
             FBoilIngredients[High(FBoilIngredients)].Warning1Shown:= false;
             FBoilIngredients[High(FBoilIngredients)].Warning2Shown:= false;
           end;
         end;
       if FTemporary.NumMiscs > 0 then
         for i:= 0 to (FTemporary.NumMiscs - 1) do
         begin
           if FTemporary.Misc[i].Use = muBoil then
           begin
             SetLength(FBoilIngredients, High(FBoilIngredients) + 2);
             FBoilIngredients[High(FBoilIngredients)].Ingredient:= FTemporary.Misc[i];
             FBoilIngredients[High(FBoilIngredients)].Time1:= (double(FTemporary.Misc[i].Time.Value) + 5) / (24 * 60); //days
             FBoilIngredients[High(FBoilIngredients)].Time2:= double(FTemporary.Misc[i].Time.Value) / (24 * 60); //days
             FBoilIngredients[High(FBoilIngredients)].Warning1Shown:= false;
             FBoilIngredients[High(FBoilIngredients)].Warning2Shown:= false;
           end;
         end;

       s:= round(double(FTemporary.BoilTime.Value * 60));
       ConvertSeconds(h, m, s, mi);
       FBoilTimeLeft:= EncodeTime(h, m, s, mi);
       bbStartBoil.Caption:= startboil3;
       tBoilTimer.Enabled:= TRUE;
     end
     else if (tBoilTimer.Enabled) and (FBoilTimeLeft > 0) then
     begin
       bbStartBoil.Caption:= pause1;
       tBoilTimer.Enabled:= false;
     end
     else if (not tBoilTimer.Enabled) and (FBoilTimeLeft > 0) then
     begin
       bbStartBoil.Caption:= startboil3;
       tBoilTimer.Enabled:= TRUE;
     end;
   end;
 end;

 procedure TfrmMain.tBoilTimerTimer(Sender: TObject);
 var i : integer;
 begin
   FBoilTimeLeft:= FBoilTimeLeft - tBoilTimer.Interval / 86400000; //days
   eBoilTimer.Text:= TimeToStr(FBoilTimeLeft);
   if (FBoilTimeLeft <= (1 / (60 * 24))) and (eBoilTimer.Color <> clRed) then
   begin
     eBoilTimer.Color:= clred;
     eBoilTimer.Font.Color:= clWhite;
   end;
   for i:= Low(FBoilIngredients) to High(FBoilIngredients) do
   begin
     if (FBoilTimeLeft <= FBoilIngredients[i].Time1) and (not FBoilIngredients[i].Warning1Shown) then
     begin
       FBoilIngredients[i].Warning1Shown:= TRUE;
       ShowNotification(self, boiltimeto1 + FBoilIngredients[i].Ingredient.Amount.DisplayString + ' ' + FBoilIngredients[i].Ingredient.Name.Value + boiltimeto2);
       PlayAlarm;
     end;
     if (FBoilTimeLeft <= FBoilIngredients[i].Time2) and (not FBoilIngredients[i].Warning2Shown) then
     begin
       FBoilIngredients[i].Warning2Shown:= TRUE;
       ShowNotification(self, boiltimeto1 + FBoilIngredients[i].Ingredient.Amount.DisplayString + ' ' + FBoilIngredients[i].Ingredient.Name.Value + boiltimeto3);
       PlayAlarm;
     end;
   end;

   if FBoilTimeLeft <= (0.5 * tBoilTimer.Interval/86400000) then
   begin
     //Set off alarm and notification
     tBoilTimer.Enabled:= false;
     FBoilTimeLeft:= 0;

     PlayAlarm;
     ShowNotification(self, endboil2);
     bbStartBoil.Caption:= startboil2;
     eBoilTimer.Color:= clWhite;
     SetLength(FBoilIngredients, 0);
   end;
 end;

 procedure TfrmMain.bbStartTimerClick(Sender: TObject);
 begin
   if tCTimer.Enabled then
   begin
     tCTimer.Enabled:= false;
     bbStartTimer.Caption:= pause1;
   end
   else
   begin
     tCTimer.Enabled:= TRUE;
     bbStartTimer.Caption:= stopwatch2;
   end;
 end;

 procedure TfrmMain.tCTimerTimer(Sender: TObject);
 begin
   FTimeTimer:= FTimeTimer + tCTimer.Interval / 86400000; //days
   eTimer.Text:= TimeToStr(FTimeTimer);
 end;

 procedure TfrmMain.bbResetTimersClick(Sender: TObject);
 begin
   tCTimer.Enabled:= false;
   eTimer.Text:= '';
   eTimer.Color:= clWhite;
   FTimeTimer:= 0;
   bbStartTimer.Caption:= stopwatch1;
   FBoilTimeLeft:= 0;
   tBoilTimer.Enabled:= false;
   eBoilTimer.Text:= '';
   eBoilTimer.Color:= clWhite;
   SetLength(FBoilIngredients, 0);
   bbStartBoil.Caption:= startboil2;
   tMashTimer.Enabled:= false;
   FMashTimeLeft:= 0;
   eMashTimer.Text:= '';
   eMashTimer.Color:= clWhite;
   FMashStep:= -1;
   FMashT:= NIL;
   bbStartMash.Caption:= startmash1;
 end;

 procedure TfrmMain.seWhirlpoolTimeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.WhirlpoolTime.DisplayValue:= seWhirlpoolTime.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbCoolingMethodChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CoolingMethodDisplayName:= cbCoolingMethod.Items[cbCoolingMethod.ItemIndex];
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.seCoolingTimeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CoolingTime.DisplayValue:= seCoolingTime.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseCoolingToChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CoolingTo.DisplayValue:= fseCoolingTo.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTimeAerationChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TimeAeration.DisplayValue:= fseTimeAeration.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseAerationFlowRateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.AerationFlowRate.DisplayValue:= fseAerationFlowRate.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbAerationTypeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.AerationTypeDisplayName:= cbAerationType.Items[cbAerationType.ItemIndex];
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseVolToFermenterChange(Sender: TObject);
 var x : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.VolumeFermenter.DisplayValue:= fseVolToFermenter.Value;
     FChanged:= TRUE;
     FTemporary.CalcOGFermenter;
     eOGFermenter.Text:= RealToStrDec(FTemporary.OGFermenter.DisplayValue, 3) + ' ' +
                                 FTemporary.OGFermenter.DisplayUnitString;
     x:= FTemporary.CalcIBUFermenter;
     eIBUFermenter.Text:= RealToStrDec(x, 0) + ' ' +
                                 FTemporary.IBUcalc.DisplayUnitString;
     x:= FTemporary.CalcColorFermenter;
     if FTemporary.EstColor.DisplayUnit = EBC then
       eColorFermenter.Text:= RealToStrDec(SRMtoEBC(x), 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString
     else
       eColorFermenter.Text:= RealToStrDec(x, 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString;
     eColorFermenter.Color:= SRMtoColor(x);
     if x < 15 then eColorFermenter.Font.Color:= clBlack
     else eColorFermenter.Font.Color:= clWhite;
     eColorFermenter.Invalidate;

     FTemporary.EstimateFG;
     eFGPredicted.Text:= FTemporary.EstFG2.DisplayString;

     UpdatePredictions;
     FUserClicked:= TRUE;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTopUpWater2Change(Sender: TObject);
 var x : double;
 begin
 //  fseTopUpWater.Value:= fseTopUpWater2.Value;
 //  fseTopUpWaterChange(Sender);
   if (FSelected <> NIL) and (FTemporary.Equipment <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Equipment.TopUpWaterBrewDay.DisplayValue:= fseTopUpWater2.Value;
     FChanged:= TRUE;
     FTemporary.CalcOGFermenter;
     eOGFermenter.Text:= RealToStrDec(FTemporary.OGFermenter.DisplayValue, 3) + ' ' +
                                 FTemporary.OGFermenter.DisplayUnitString;
     x:= FTemporary.CalcIBUFermenter;
     eIBUFermenter.Text:= RealToStrDec(x, 0) + ' ' +
                                 FTemporary.IBUcalc.DisplayUnitString;
     x:= FTemporary.CalcColorFermenter;
     if FTemporary.EstColor.DisplayUnit = EBC then
       eColorFermenter.Text:= RealToStrDec(SRMtoEBC(x), 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString
     else
       eColorFermenter.Text:= RealToStrDec(x, 0) + ' '
                              + FTemporary.EstColor.DisplayUnitString;
     eColorFermenter.Color:= SRMtoColor(x);
     if x < 15 then eColorFermenter.Font.Color:= clBlack
     else eColorFermenter.Font.Color:= clWhite;
     eColorFermenter.Invalidate;

     FTemporary.EstimateFG;
     eFGPredicted.Text:= FTemporary.EstFG2.DisplayString;

     eAAEndPrimary.Caption:= RealToStrDec(FTemporary.AAEndPrimary, 1) + '%';
     x:= FTemporary.OGFermenter.Value;
     x:= ABVol(x, FTemporary.FG.Value);
     FTemporary.ABVcalc.Value:= x;
     eABV.Text:= FTemporary.ABVCalc.DisplayString;
 //    piABV2.Value:= FTemporary.ABVCalc.DisplayValue;
     eAA.Caption:= RealToStrDec(FTemporary.ApparentAttenuation, 1) + '%';
     eRA.Caption:= RealToStrDec(FTemporary.RealAttenuation, 1) + '%';

     UpdatePredictions;
     FUserClicked:= TRUE;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.rxteStartTimeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TimeStarted.Value:= rxteStartTime.Time;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.rxteEndTimeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TimeEnded.Value:= rxteEndTime.Time;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.hcIngredientsSectionClick(
   HeaderControl: TCustomHeaderControl);
 begin

 end;

 procedure TfrmMain.bbChecklistClick(Sender: TObject);
 var Doc : TBHRDocument;
 begin
   Screen.Cursor:= crHourglass;
   Cursor:= crHourglass;
   Application.ProcessMessages;

   Doc:= TBHRDocument.Create;
   if CreateCheckList(Doc, FTemporary) then
   begin
     Screen.Cursor:= crDefault;
     Cursor:= crDefault;
     Doc.PrintPreview
   end
   else Doc.Free;
   Doc:= NIL; //Doc is freed automatically after PrintPreview form closes;
 end;


 {========================== Fermentation =====================================}

 Procedure TfrmMain.SetAmountCells;
 var AmCells, AmCellsmlP, AmCellsNeeded, AmCellsmlPNeeded, vol, sg, Pl : double;
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) then
   begin
     AmCells:= FTemporary.Yeast[0].CalcAmountYeast; //in billion
     AmCellsNeeded:= FTemporary.NeededYeastCells; //in billion
     if FTemporary.VolumeFermenter.Value > 0 then
     begin
       vol:= FTemporary.VolumeFermenter.Value;
       if FTemporary.Equipment.TopUpWaterBrewDay.Value > 0 then
         vol:= vol + FTemporary.Equipment.TopUpWaterBrewDay.Value;
     end
     else if FTemporary.VolumeAfterBoil.Value > 0 then vol:= FTemporary.VolumeAfterBoil.Value
     else vol:= FTemporary.BatchSize.Value;

     sg:= FTemporary.CalcOGFermenter;
     if (sg <= 1.0001) and (FTemporary.OG.Value > 1.000) then
       sg:= FTemporary.OG.Value
     else if (sg <= 1.0001) then
       sg:= FTemporary.EstOG.Value;
     Pl:= SGtoPlato(sg);

     if (vol * Pl) > 0 then
     begin
       AmCellsmlP:= AmCells / (vol * Pl); //in million
       AmCellsmlPNeeded:= AmCellsNeeded / (vol * Pl); //in million
     end;

     eAmCellsNeeded.Text:= RealToStrDec(AmCellsNeeded, 1) + billion1;
     eAmCells.Text:= RealToStrDec(AmCells, 1) + billion1;
     if (AmCells > 0.8 * AmCellsNeeded) and (AmCells < 1.5 * AmCellsNeeded) then
     begin
       eAmCells.Color:= clGreen;
       eAmCells.Font.Color:= clWhite;
       eAmCells.Font.Bold:= TRUE;
       eAmCells.ParentFont:= false;
       eAmCells.Hint:= enoughcells1;
     end
     else
     begin
       eAmCells.Color:= clRed;
       eAmCells.Font.Color:= clWhite;
       eAmCells.Font.Bold:= TRUE;
       eAmCells.ParentFont:= false;
       if AmCells < 0.8 * AmCellsNeeded then
         eAmCells.Hint:= notenoughcells1
       else
         eAmCells.Hint:= toomanycells1;
     end;
     eAmCells2.Text:= RealToStrDec(AmCellsmlP, 2) + million1;
     //eAmCellsNeeded2.Text:= RealToStrDec(AmCellsmlPNeeded, 2) + million1;
     if (AmCellsmlP > 0.8 * AmCellsmlPNeeded) and (AmCellsmlP < 1.5 * AmCellsmlPNeeded) then
     begin
       eAmCells2.Color:= clGreen;
       eAmCells2.Font.Color:= clWhite;
       eAmCells2.Font.Bold:= TRUE;
       eAmCells2.ParentFont:= false;
       eAmCells2.Hint:= enoughcells1;
     end
     else
     begin
       eAmCells2.Color:= clRed;
       eAmCells2.Font.Color:= clWhite;
       eAmCells2.Font.Bold:= TRUE;
       eAmCells2.ParentFont:= false;
       if AmCellsmlP < 0.8 * AmCellsmlPNeeded then
         eAmCells2.Hint:= notenoughcells1
       else
         eAmCells2.Hint:= toomanycells1;
     end;
   end
   else
   begin
     eAmCells.Color:= clBackground;
     eAmCells.Font.Color:= clDefault;
     eAmCells.Font.Bold:= false;
     eAmCells.Text:= '';
     eAmCells.Hint:= '';
     eAmCells2.Color:= clBackground;
     eAmCells2.Font.Color:= clDefault;
     eAmCells2.Font.Bold:= false;
     eAmCells2.Text:= '';
     eAmCells2.Hint:= '';
   end;
 end;

 procedure TfrmMain.deTransferDateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.PrimaryAge.Value:= deTransferDate.Date - FTemporary.Date.Value;
     if deTransferDate.Date = deLagerDate.Date then FTemporary.FermentationStages.Value:= 2
     else if deTransferDate.Date < deLagerDate.Date then FTemporary.FermentationStages.Value:= 3;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.deLagerDateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.SecondaryAge.Value:= deLagerDate.Date - FTemporary.Date.Value;
     if deTransferDate.Date = deLagerDate.Date then FTemporary.FermentationStages.Value:= 2
     else if deTransferDate.Date < deLagerDate.Date then FTemporary.FermentationStages.Value:= 3;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbYeastAddedAsChange(Sender: TObject);
 var Y : TYeast;
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked
      and (cbYeastAddedAs.ItemIndex > -1) then
   begin
     Y:= FTemporary.Yeast[0];
     FUserClicked:= false;
     if Y.FormDisplayName <> cbYeastAddedAs.Items[cbYeastAddedAs.ItemIndex] then
     begin
       Y.FormDisplayName:= cbYeastAddedAs.Items[cbYeastAddedAs.ItemIndex];
       case Y.Form of
         yfDry:
         begin
           Y.AmountYeast.DisplayValue:= 11.5;
         end;
         yfLiquid:
         begin
           if AmCellspMlSlurry > 0 then
             Y.AmountYeast.DisplayValue:= 1;
         end;
         yfSlant: //amount of cells from slant (1 colony). assume 1 colony is 1/1000 of a ml.
         begin
           Y.AmountYeast.DisplayValue:= 0.01;
         end;
         yfCulture:
         begin
           Y.AmountYeast.DisplayValue:= 50;
         end;
         yfBottle: //sediment in a bottle holds 10 ml of yeast
         begin
           if AmCellspMlSlurry > 0 then
             Y.AmountYeast.DisplayValue:= 10;
         end;
         yfFrozen: //sediment in cup holds 1 ml of yeast
         begin
           if AmCellspMlSlurry > 0 then
             Y.AmountYeast.DisplayValue:= 1;
         end;
       end;
     end;

     SetControl(fseAmountYeast, lAmountYeast, Y.AmountYeast, TRUE);
     SetAmountCells;
     lAmountYeast.Caption:= FTemporary.Yeast[0].AmountYeast.DisplayUnitString;
     UpdateIngredientsGrid;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbStarterMadeChange(Sender: TObject);
 var v : double;
     bl : boolean;
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Yeast[0].StarterMade.Value:= cbStarterMade.Checked;
     FChanged:= TRUE;
     cbStarterType.Enabled:= cbStarterMade.Checked;
     SetReadOnly(fseStarterTimeAerated, not cbStarterMade.Checked);
     fseStarterTimeAerated.Enabled:= not fseStarterTimeAerated.ReadOnly;
     SetReadOnly(fseSGStarter, not cbStarterMade.Checked);
     fseSGStarter.Enabled:= not fseSGStarter.ReadOnly;
     SetReadOnly(fseTempStarter, not cbStarterMade.Checked);
     fseTempStarter.Enabled:= not fseTempStarter.ReadOnly;
     SetReadOnly(fseStarterVolume1, not cbStarterMade.Checked);
     fseStarterVolume1.Enabled:= not fseStarterVolume1.ReadOnly;
     if not cbStarterMade.Checked then
     begin
       fseStarterVolume1.Value:= 0;
       FTemporary.Yeast[0].StarterVolume1.Value:= 0;
     end;

     v:= fseStarterVolume1.Value;
     bl:= (v > 0);
     if (not bl) then fseStarterVolume2.Value:= 0;
     fseStarterVolume2.ReadOnly:= not bl;
     fseStarterVolume2.Enabled:= bl;
     fseStarterVolume2.Visible:= bl;
     lStarterVolume2.Visible:= bl;
     Label142.Visible:= bl;
     if fseStarterVolume1.ReadOnly then
       fseStarterVolume2.ReadOnly:= TRUE;

     v:= fseStarterVolume2.Value;
     bl:= (v > 0);
     if (not bl) then fseStarterVolume3.Value:= 0;
     fseStarterVolume3.ReadOnly:= not bl;
     fseStarterVolume3.Enabled:= bl;
     fseStarterVolume3.Visible:= bl;
     lStarterVolume3.Visible:= bl;
     Label143.Visible:= bl;
     if fseStarterVolume1.ReadOnly then
       fseStarterVolume2.ReadOnly:= TRUE;


     SetAmountCells;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbStarterTypeChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Yeast[0].StarterTypeDisplayName:= cbStarterType.Items[cbStartertype.ItemIndex];
     case FTemporary.Yeast[0].StarterType of
     stSimple, stAerated: lTimeAerated.Caption:= starteraerationtime1;
     stStirred: lTimeAerated.Caption:= starteraerationtime2;
     end;
     SetAmountCells;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseStarterTimeAeratedChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.yeast[0].TimeAerated.DisplayValue:= fseStarterTimeAerated.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSGStarterChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.yeast[0].OGStarter.DisplayValue:= fseSGstarter.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTempStarterChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.yeast[0].Temperature.DisplayValue:= fseTempStarter.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseStarterVolume1Change(Sender: TObject);
 var bl : boolean;
     v : double;
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;

     v:= fseStarterVolume1.Value;
     bl:= (v > 0);
     if (not bl) then fseStarterVolume2.Value:= 0;
     fseStarterVolume2.ReadOnly:= not bl;
     fseStarterVolume2.Enabled:= bl;
     fseStarterVolume2.Visible:= bl;
     lStarterVolume2.Visible:= bl;
     Label142.Visible:= bl;
     if ((not FTemporary.Locked.Value) and (not cbStarterMade.Checked)) then
       fseStarterVolume2.ReadOnly:= TRUE;

     v:= fseStarterVolume2.Value;
     bl:= (v > 0);
     if (not bl) then fseStarterVolume3.Value:= 0;
     fseStarterVolume3.ReadOnly:= not bl;
     fseStarterVolume3.Enabled:= bl;
     fseStarterVolume3.Visible:= bl;
     lStarterVolume3.Visible:= bl;
     Label143.Visible:= bl;
     if ((not FTemporary.Locked.Value) and (not cbStarterMade.Checked)) then
       fseStarterVolume2.ReadOnly:= TRUE;

     FTemporary.yeast[0].StarterVolume1.DisplayValue:= fseStarterVolume1.Value;
     FTemporary.yeast[0].StarterVolume2.DisplayValue:= fseStarterVolume2.Value;
     FTemporary.yeast[0].StarterVolume3.DisplayValue:= fseStarterVolume3.Value;
     SetAmountCells;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseAmountYeastChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and (FTemporary.Yeast[0] <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Yeast[0].AmountYeast.DisplayValue:= fseAmountYeast.Value;
     SetAmountCells;
     UpdateIngredientsgrid;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseStartTempPrimaryChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.StartTempPrimary.DisplayValue:= fseStartTempPrimary.Value;
     FTemporary.PrimaryTemp.Value:= (FTemporary.StartTempPrimary.Value +
                                     FTemporary.MaxTempPrimary.Value +
                                     FTemporary.EndTempPrimary.Value) / 3;
     UpdatePredictions;
     FChanged:= TRUE;
     FUSerClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseMaxTempPrimaryChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.MaxTempPrimary.DisplayValue:= fseMaxTempPrimary.Value;
     FTemporary.PrimaryTemp.Value:= (FTemporary.StartTempPrimary.Value +
                                     FTemporary.MaxTempPrimary.Value +
                                     FTemporary.EndTempPrimary.Value) / 3;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseEndTempPrimaryChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.EndTempPrimary.DisplayValue:= fseEndTempPrimary.Value;
     FTemporary.PrimaryTemp.Value:= (FTemporary.StartTempPrimary.Value +
                                     FTemporary.MaxTempPrimary.Value +
                                     FTemporary.EndTempPrimary.Value) / 3;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSGEndPrimaryChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.SGEndPrimary.DisplayValue:= fseSGEndPrimary.Value;
     eAAEndPrimary.Caption:= RealToStrDec(FTemporary.AAEndPrimary, 1) + '%';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSecondaryTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.SecondaryTemp.DisplayValue:= fseSecondaryTemp.Value;
     FUserClicked:= TRUE;
     fseCarbonationChange(self);
     fseCarbonationKegsChange(self);
     UpdatePredictions;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTertiaryTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TertiaryTemp.DisplayValue:= fseTertiaryTemp.Value;
     FChanged:= TRUE;
     UpdatePredictions;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseFGChange(Sender: TObject);
 var x : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.FG.DisplayValue:= fseFG.Value;
     x:= FTemporary.CalcOGFermenter;
     x:= ABVol(x, FTemporary.FG.Value);
     FTemporary.ABVcalc.Value:= x;
     eABV.Text:= FTemporary.ABVCalc.DisplayString;
 //    piABV2.Value:= FTemporary.ABVCalc.DisplayValue;
     eAA.Caption:= RealToStrDec(FTemporary.ApparentAttenuation, 1) + '%';
     eRA.Caption:= RealToStrDec(FTemporary.RealAttenuation, 1) + '%';
     FTemporary.CalcCalories;
     eCalories.Text:= FTemporary.Calories.DisplayString;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 Procedure TfrmMain.UpdateGraph;
 var M : TFermMeasurements;
     FM : TFermMeasurement;
     i : integer;
     DT, DMin, DMax : TDateTime;
     Mx, RMx : double;
 begin
   lcsSG.Clear;

   if (FSelected <> NIL) and (FSelected = FSelBrew) and (FTemporary.FermMeasurements <> NIL)
       and (FTemporary.FermMeasurements.Measurements <> NIL) then
     begin
       chTControl.Visible:= false;
       chTControl.BottomAxis.Range.UseMin:= false;
       chTControl.BottomAxis.Range.UseMax:= false;

       Mx:= 0; RMx:= 0;
       M:= FTemporary.FermMeasurements;
       for i:= 0 to M.NumMeasurements - 1 do
       begin
         FM:= M.Measurement[i];
         DT:= FM.DateTime.Value;
         if i = 0 then chTControl.BottomAxis.Range.Min:= DT;
         if i = M.NumMeasurements - 1 then
         begin
           chTControl.BottomAxis.Range.Max:= DT;
           chTControl.BottomAxis.Range.UseMin:= TRUE;
           chTControl.BottomAxis.Range.UseMax:= TRUE;
         end;
         if DT > 0 then
         begin
           if i = 0 then DMin:= DT;
           if i = M.NumMeasurements - 1 then DMax:= DT;
           //Temp 1 3
           if not M.IsEmpty(3) then
           begin
             lsEnvTemp.AddXY(DT, FM.TempS1.Value);
             if FM.TempS1.Value > Mx then Mx:= FM.TempS1.Value;
           end;
           //Temp 2  7
           if not M.IsEmpty(7) then
           begin
             lsBeerTemp.AddXY(DT, FM.TempS2.Value);
             if FM.TempS2.Value > Mx then Mx:= FM.TempS2.Value;
           end;
           //Setpoint 4
           if not M.IsEmpty(4) then
           begin
             lsSetTemp.AddXY(DT, FM.SetPoint.VAlue);
             if FM.SetPoint.Value > Mx then Mx:= FM.SetPoint.Value;
           end;
           //CO2 8
           if not M.IsEmpty(8) then
           begin
             lsCO2.AddXY(DT, FM.CO2.Value);
             if FM.CO2.Value > Mx then Mx:= FM.CO2.Value;
           end;
           //SG  9
           if not M.IsEmpty(9) then
           begin
             //lcsSG.Add(DT, FM.SGmeas.Value, '', $000A46FA);
             lsSG.AddXY(DT, FM.SGMeas.Value);
             if FM.SGMeas.Value > RMx then RMx:= FM.SGMeas.Value;
           end;
           //Cooling 6
           if not M.IsEmpty(6) then
           begin
             lsCooling.AddXY(DT, FM.Cooling.Value);
             if FM.Cooling.Value > Mx then Mx:= FM.Cooling.Value;
           end;
           //Heating 10
           if not M.IsEmpty(10) then
           begin
             lsHeating.AddXY(DT, FM.Heating.Value);
             if FM.Heating.Value > Mx then Mx:= FM.Heating.Value;
           end;
           //CoolingPower 5
           if not M.IsEmpty(5) then
           begin
             lsCoolingPower.AddXY(DT, FM.Coolpower.Value);
             if FM.CoolPower.Value > Mx then Mx:= FM.CoolPower.Value;
           end;
         end
         else
           DT:= 0;
       end;
 //      chTControl.BottomAxis.Range.Min:= DMin;
 //      chTControl.BottomAxis.Range.Max:= DMax;
       chTControl.Extent.XMin:= DMin;
       chTControl.Extent.XMax:= DMax;
       chTControl.Extent.UseXMin:= TRUE;
       chTControl.Extent.UseXMax:= TRUE;
       chTControl.Extent.YMin:= 0;
       chTControl.Extent.YMax:= Mx;
       chTControl.Extent.UseYMin:= TRUE;
       chTControl.Extent.UseYMax:= TRUE;
       chTControl.ExtentSizeLimit.XMin:= DMin;
       chTControl.ExtentSizeLimit.XMax:= DMax;
       chTControl.ExtentSizeLimit.UseXMin:= TRUE;
       chTControl.ExtentSizeLimit.UseXMax:= TRUE;
       chTControl.ExtentSizeLimit.YMin:= 0;
       chTControl.ExtentSizeLimit.YMax:= Mx;
       chTControl.ExtentSizeLimit.UseYMin:= TRUE;
       chTControl.ExtentSizeLimit.UseYMax:= TRUE;

       chTControl.BottomAxis.Range.UseMin:= TRUE;
       chTControl.BottomAxis.Range.UseMax:= TRUE;
       chTControl.LeftAxis.Range.Max:= Mx;
       chTControl.AxisList[2].Range.Max:= RMx;

       if RMx > 1 then catSGLinearAxisTransform1.Scale:= Mx / (RMx - 1)
       else catSGLinearAxisTransform1.Scale:= 1;
       catSGLinearAxisTransform1.Offset:= -catSGLinearAxisTransform1.Scale;

       chTControl.Visible:= TRUE;
       cbTemp1.Enabled:= (not M.IsEmpty(3));
       cbTemp1.Checked:= cbTemp1.Enabled;
       cbTemp1.Font.Color:= lsEnvTemp.LinePen.Color;
       cbTemp1.ParentFont:= false;
       cbTemp1.Invalidate;
       lsEnvTemp.Active:= cbTemp1.Enabled;
       cbTemp2.Enabled:= (not M.IsEmpty(7));
       cbTemp2.Checked:= cbTemp2.Enabled;
       cbTemp2.Font.Color:= lsBeerTemp.LinePen.Color;
       cbTemp2.ParentFont:= false;
       cbTemp2.Invalidate;
       lsBeerTemp.Active:= cbTemp2.Enabled;
       cbSetpoint.Enabled:= (not M.IsEmpty(4));
       cbSetpoint.Checked:= cbSetpoint.Enabled;
       cbSetPoint.Font.Color:= lsSetTemp.LinePen.Color;
       cbSetPoint.ParentFont:= false;
       cbSetpoint.Invalidate;
       lsSetTemp.Active:= cbSetPoint.Enabled;
       cbCO2.Enabled:= (not M.IsEmpty(8));
       cbCO2.Checked:= cbCO2.Enabled;
       cbCO2.Font.Color:= lsCO2.LinePen.Color;
       cbCO2.ParentFont:= false;
       cbCO2.Invalidate;
       lsCO2.Active:= cbCO2.Enabled;
       cbSG.Enabled:= (not M.IsEmpty(9));
       cbSG.Checked:= cbSG.Enabled;
       cbSG.Font.Color:= lsSG.LinePen.Color;
       cbSG.ParentFont:= false;
       cbSG.Invalidate;
       lsSG.Active:= cbSG.Enabled;
       cbCooling.Enabled:= (not M.IsEmpty(6));
       cbCooling.Checked:= cbCooling.Enabled;
       cbCooling.Font.Color:= lsCooling.LinePen.Color;
       cbCooling.ParentFont:= false;
       cbCooling.Invalidate;
       lsCooling.Active:= cbCooling.Enabled;
       cbHeating.Enabled:= (not M.IsEmpty(10));
       cbHeating.Checked:= cbHeating.Enabled;
       cbHeating.Font.Color:= lsHeating.LinePen.Color;
       cbHeating.ParentFont:= false;
       cbHeating.Invalidate;
       lsHeating.Active:= cbHeating.Enabled;
       cbCoolpower.Enabled:= (not M.IsEmpty(5));
       cbCoolpower.Checked:= cbCoolpower.Enabled;
       cbCoolpower.Font.Color:= lsCoolingPower.LinePen.Color;
       cbCoolpower.ParentFont:= false;
       cbCoolpower.Invalidate;
       lsCoolingpower.Active:= cbCoolpower.Enabled;
       chTControl.Width:= 593;
       chTControl.Height:= 322;
     end
     else
     begin
       chTControl.Visible:= false;
     end;
 end;

 procedure TfrmMain.bbMeasurementsClick(Sender: TObject);
 begin
   if (FSelected <> NIL) then
   begin
     frmMeasurements:= TFrmMeasurements.Create(self);
     if FrmMeasurements.Execute(FTemporary) then
     begin
       UpdateGraph;
       FChanged:= TRUE;
     end;
     frmMeasurements.Free;
   end;
 end;

 procedure TfrmMain.cbTemp1Change(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsEnvTemp.Active:= cbTemp1.Checked;
 //    bhgMeasurements.SetVisible(1, cbTemp1.Checked);
 end;

 procedure TfrmMain.cbTemp2Change(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsBeerTemp.Active:= cbTemp2.Checked;
 //    bhgMeasurements.SetVisible(2, cbTemp2.Checked);
 end;

 procedure TfrmMain.cbSetpointChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsSetTemp.Active:= cbSetPoint.Checked;
 //    bhgMeasurements.SetVisible(3, cbSetpoint.Checked);
 end;

 procedure TfrmMain.cbCO2Change(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsCO2.Active:= cbCO2.Checked;
 //    bhgMeasurements.SetVisible(4, cbCO2.Checked);
 end;

 procedure TfrmMain.cbSGChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsSG.Active:= cbSG.Checked;
 //    bhgMeasurements.SetVisible(5, cbSG.Checked);
 end;

 procedure TfrmMain.cbCoolingChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsCooling.Active:= cbCooling.Checked;
 //    bhgMeasurements.SetVisible(6, cbCooling.Checked);
 end;

 procedure TfrmMain.cbHeatingChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
    lsHeating.Active:= cbHeating.Checked;
 //    bhgMeasurements.SetVisible(7, cbHeating.Checked);
 end;

 procedure TfrmMain.cbCoolPowerChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
     lsCoolingpower.Active:= cbCoolpower.Checked;
 //    bhgMeasurements.SetVisible(8, cbCoolpower.Checked);
 end;

 {============================ Packaging =======================================}

 procedure TfrmMain.deBottleDateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.DateBottling.Value:= deBottleDate.Date;
     if FTemporary.SecondaryAge.Value = 0 then
       FTemporary.SecondaryAge.Value:= deBottleDate.Date - FTemporary.Date.Value - FTemporary.PrimaryAge.Value
     else
       FTemporary.TertiaryAge.Value:= deBottleDate.Date - FTemporary.Date.Value - FTemporary.PrimaryAge.Value - FTemporary.SecondaryAge.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseVolumeBottlesChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.VolumeBottles.DisplayValue:= fseVolumeBottles.Value;
     eTotAmBottles.Text:= RealToStrDec(FTemporary.VolumeBottles.Value *  FTemporary.AmountPrimingBottles.Value, 1);
    { if FTemporary.VolumeKegs.Value + FTemporary.VolumeBottles.Value > FTemporary.VolumeFermenter.Value then
     begin
       fseVolumeKegs.Value:= FTemporary.VolumeFermenter.DisplayValue - FTemporary.VolumeBottles.DisplayValue;
       fseVolumeKegsChange(self);
     end;}
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseCarbonationChange(Sender: TObject);
 var Tsec : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.Carbonation.DisplayValue:= fseCarbonation.Value;
     piCarbBottles.Value:= FTemporary.Carbonation.Value;
     Tsec:= FTemporary.SecondaryTemp.Value;
     if Tsec < 5 then Tsec:= FTemporary.EndTempPrimary.Value;
     if Tsec < 5 then TSec:= 15;
     FTemporary.AmountPrimingBottles.Value:= CarbCO2toS(FTemporary.Carbonation.Value,
                                                        Tsec, PrimingSugarFactors[FTemporary.PrimingSugarBottles]);
     fseAmountPrimingBottles.Value:= FTemporary.AmountPrimingBottles.DisplayValue;
     eTotAmBottles.Text:= RealToStrDec(FTemporary.VolumeBottles.Value *  FTemporary.AmountPrimingBottles.Value, 1);
     eABVBottles.Text:= RealToStrDec(FTemporary.ABVcalc.Value +
                                     FTemporary.AmountPrimingBottles.Value * 0.47 / 7.907,
                                     1) + ' vol.%';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbPrimingSugarBottlesChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.PrimingSugarBottlesDisplayName:= cbPrimingSugarBottles.Items[cbPrimingSugarBottles.ItemIndex];
     FUserClicked:= TRUE;
     fseCarbonationChange(Sender);
   end;
 end;

 procedure TfrmMain.fseAmountPrimingBottlesChange(Sender: TObject);
 var Tsec : double;
 begin
   Tsec:= 0;
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.AmountPrimingBottles.DisplayValue:= fseAmountPrimingBottles.Value;
     eTotAmBottles.Text:= RealToStrDec(FTemporary.VolumeBottles.Value *  FTemporary.AmountPrimingBottles.Value, 1);
     Tsec:= FTemporary.SecondaryTemp.Value;
     if Tsec < 5 then Tsec:= FTemporary.EndTempPrimary.Value;
     if Tsec < 5 then TSec:= 15;
     FTemporary.Carbonation.Value:= CarbStoCO2(FTemporary.AmountPrimingBottles.Value,
                                               Tsec, PrimingSugarFactors[FTemporary.PrimingSugarBottles]);
 //    piCarbBottles.Value:= FTemporary.Carbonation.Value;
     fseCarbonation.Value:= FTemporary.Carbonation.DisplayValue;
     eABVBottles.Text:= RealToStrDec(FTemporary.ABVcalc.Value +
                                     FTemporary.AmountPrimingBottles.Value * 0.47 / 7.907,
                                     1) + ' vol.%';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseCarbonationTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CarbonationTemp.DisplayValue:= fseCarbonationTemp.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseVolumeKegsChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.VolumeKegs.DisplayValue:= fseVolumeKegs.Value;
     eTotAmKegs.Text:= RealToStrDec(FTemporary.VolumeKegs.Value *  FTemporary.AmountPrimingKegs.Value, 1);
 {    if FTemporary.VolumeKegs.Value + FTemporary.VolumeBottles.Value > FTemporary.VolumeFermenter.Value then
     begin
       ShowNotification(self, 'Volume flessen en fusten is groter dan volume naar gistingsvat');
       fseVolumeBottles.Value:= FTemporary.VolumeFermenter.DisplayValue - FTemporary.VolumeKegs.DisplayValue;
       FUserClicked:= TRUE;
       fseVolumeBottlesChange(self);
     end;}
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseCarbonationKegsChange(Sender: TObject);
 var Tsec, Carb : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CarbonationKegs.DisplayValue:= fseCarbonationKegs.Value;
 //    piCarbKegs.Value:= FTemporary.CarbonationKegs.Value;
     eTotAmKegs.Text:= RealToStrDec(FTemporary.VolumeKegs.Value *  FTemporary.AmountPrimingKegs.Value, 1);
     Tsec:= FTemporary.SecondaryTemp.Value;
     if Tsec < 5 then Tsec:= FTemporary.EndTempPrimary.Value;
     if Tsec < 5 then TSec:= 15;
     FTemporary.AmountPrimingKegs.Value:= CarbCO2toS(FTemporary.CarbonationKegs.Value,
                                   Tsec, PrimingSugarFactors[FTemporary.PrimingSugarKegs]);
     fseAmountPrimingKegs.Value:= FTemporary.AmountPrimingKegs.DisplayValue;

     Carb:= FTemporary.CarbonationKegs.Value;
     Tsec:= FTemporary.CarbonationTempKegs.Value;
     FTemporary.PressureKegs.Value:= CarbCO2ToPressure(Carb, TSec);
     fsePressureKegs.Value:= FTemporary.PressureKegs.DisplayValue;

     if FTemporary.ForcedCarbonationKegs.Value then
       Tsec:= 0
     else
       Tsec:= FTemporary.AmountPrimingKegs.Value * 0.47 / 7.907;
     eABVKegs.Text:= RealToStrDec(FTemporary.ABVcalc.Value + Tsec, 1) + ' vol.%';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.cbPrimingSugarKegsChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FTemporary.PrimingSugarKegsDisplayName:= cbPrimingSugarKegs.Items[cbPrimingSugarKegs.ItemIndex];
     fseCarbonationKegsChange(Sender);
   end;
 end;

 procedure TfrmMain.cbForcedCarbonationChange(Sender: TObject);
 var Tsec : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     SetReadOnly(fseAmountPrimingKegs, cbForcedCarbonation.Checked);
     cbPrimingSugarKegs.Enabled:= not cbForcedCarbonation.Checked;
     SetReadOnly(eTotAmKegs, cbForcedCarbonation.Checked);
     SetReadOnly(fsePressureKegs, not cbForcedCarbonation.Checked);
     FTemporary.ForcedCarbonationKegs.Value:= cbForcedCarbonation.Checked;
     if FTemporary.ForcedCarbonationKegs.Value then
       Tsec:= 0
     else
       Tsec:= FTemporary.AmountPrimingKegs.Value * 0.47 / 7.907;
     eABVKegs.Text:= RealToStrDec(FTemporary.ABVcalc.Value + Tsec, 1) + ' vol.%';
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseAmountPrimingKegsChange(Sender: TObject);
 var Tsec, Carb : double;
 begin
   Tsec:= 0;
   if (FSelected <> NIL) and FUSerClicked then
   begin
     FUserClicked:= false;
     FTemporary.AmountPrimingKegs.DisplayValue:= fseAmountPrimingKegs.Value;
     eTotAmKegs.Text:= RealToStrDec(FTemporary.VolumeKegs.Value *  FTemporary.AmountPrimingKegs.Value, 1);
     Tsec:= FTemporary.SecondaryTemp.Value;
     if Tsec < 5 then Tsec:= FTemporary.EndTempPrimary.Value;
     if Tsec < 5 then TSec:= 15;
     FTemporary.CarbonationKegs.Value:= CarbStoCO2(FTemporary.AmountPrimingKegs.Value,
                                                   Tsec, PrimingSugarFactors[FTemporary.PrimingSugarKegs]);
 //    piCarbKegs.Value:= FTemporary.CarbonationKegs.Value;
     fseCarbonationKegs.Value:= FTemporary.CarbonationKegs.DisplayValue;

     Carb:= FTemporary.CarbonationKegs.Value;
     Tsec:= FTemporary.CarbonationTempKegs.Value;
     FTemporary.PressureKegs.Value:= CarbCO2ToPressure(Carb, TSec);

     if FTemporary.ForcedCarbonationKegs.Value then
       Tsec:= 0
     else
       Tsec:= FTemporary.AmountPrimingKegs.Value * 0.47 / 7.907;
     eABVKegs.Text:= RealToStrDec(FTemporary.ABVcalc.Value + Tsec, 1) + ' vol.%';

     fseCarbonationKegs.Value:= FTemporary.CarbonationKegs.DisplayValue;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseCarbonationTempKegsChange(Sender: TObject);
 var Tsec, Carb : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.CarbonationTempKegs.DisplayValue:= fseCarbonationTempKegs.Value;
     Carb:= FTemporary.CarbonationKegs.Value;
     Tsec:= FTemporary.CarbonationTempKegs.Value;
     FTemporary.PressureKegs.Value:= CarbCO2ToPressure(Carb, TSec);
     fsePressureKegs.Value:= FTemporary.PressureKegs.DisplayValue;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fsePressureKegsChange(Sender: TObject);
 var Carb, T, c : double;
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.PressureKegs.DisplayValue:= fsePressureKegs.Value;

     Carb:= FTemporary.PressureKegs.Value;
     T:= FTemporary.CarbonationTempKegs.Value;
     c:= CarbPressureToCO2(Carb, T);
     FTemporary.CarbonationKegs.Value:= c;
     fseCarbonationKegs.Value:= FTemporary.CarbonationKegs.DisplayValue;
 //    piCarbKegs.Value:= FTemporary.CarbonationKegs.Value;

     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.deTasteDateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteDate.Value:= deTasteDate.Date;
     FTemporary.Age.Value:= deTasteDate.Date - FTemporary.Date.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eColorChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteColor.Value:= eColor.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eHeadChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteHead.Value:= eHead.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eAromaChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteAroma.Value:= eAroma.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eTasteChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteTaste.Value:= eTaste.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eAftertasteChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteAftertaste.Value:= eAftertaste.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eMouthfeelChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteMouthfeel.Value:= eMouthfeel.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eTasteNotesChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteNotes.Value:= eTasteNotes.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseTastingRateChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TastingRate.Value:= fseTastingRate.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseAgeTempChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.AgeTemp.DisplayValue:= fseAgeTemp.Value;
     UpdatePredictions;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.eTransparencyChange(Sender: TObject);
 begin
   if (FSelected <> NIL) and FUserClicked then
   begin
     FUserClicked:= false;
     FTemporary.TasteTransparency.Value:= eTransparency.Text;
     FChanged:= TRUE;
     FUserClicked:= TRUE;
   end;
 end;

 {============================= Notes ==========================================}

 procedure TfrmMain.eBrewerChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
   begin
     FTemporary.Brewer.Value:= eBrewer.Text;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.eAssistantBrewerChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
   begin
     FTemporary.AsstBrewer.Value:= eAssistantBrewer.Text;
     FChanged:= TRUE;
   end;
 end;

 procedure TfrmMain.mNotesChange(Sender: TObject);
 begin
   if (FSelected <> NIL) then
   begin
     FTemporary.Notes.Value:= mNotes.Text;
     FChanged:= TRUE;
   end;
 end;

{
 {============================= Etiket =========================================}
 // JR: These components don't seem to exist (anymore). Code is useless.
 // 20190322
 procedure TfrmMain.bbLoadBackgroundClick(Sender: TObject);
 begin
 {  if opdBackground.Execute then
       FLabel.LoadBackGround(opdBackground.FileName);}
 end;

 procedure TfrmMain.bbAddLabelClick(Sender: TObject);
 begin
 //  FLabel.LabelCount:= FLabel.LabelCount + 1;
 end;

 procedure TfrmMain.bbPrintClick(Sender: TObject);
 begin
 //  FLabel.Print;
 end;
}
 {============================= Tools ==========================================}

 procedure TfrmMain.fseSGChange(Sender: TObject);
 var OBrix, FBrix, Alc, FG, Plato : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     fsePlato.Value:= SGtoPlato(fseSG.Value);
     fseBrix.Value:= SGtoBrix(fseSG.Value);
     OBrix:= fseBrix.Value;
     FBrix:= fseBrix2.Value;
     FG:= ((1.001843 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
            - 0.000000034 * Power(OBrix, 3) + 0.00574 * (FBrix)
            + 0.00003344 * (FBrix * FBrix) + 0.000000086 * Power(FBrix, 3))
            + (1.313454) * 0.001);
 //    RI:= 1.33302 + 0.001427193 * FBrix + 0.000005791157 * (FBrix * FBrix);
     Plato:= FBrix / Settings.BrixCorrection.Value;
     Alc:= (277.8851 - 277.4 * FG + 0.9956 * Plato + 0.00523 * (Plato * Plato)
           + 0.000015 * (Plato * Plato * Plato)) * (FG / 0.79);
     fsePlato2.Value:= SGtoPlato(fseSG2.Value);
     fseSG2.Value:= FG;
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     FUserClicked:= TRUE;
   end;
   fseSG2.MaxValue:= fseSG.Value;
   fsePlato2.MaxValue:= fsePlato.Value;
   fseBrix2.MaxValue:= fseBrix.Value;
 end;

 procedure TfrmMain.fsePlatoChange(Sender: TObject);
 var OBrix, FBrix, Alc, FG, Plato : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     fseSG.Value:= PlatoToSG(fsePlato.Value);
     fseBrix.Value:= fsePlato.Value * Settings.BrixCorrection.Value;
     OBrix:= fseBrix.Value;
     FBrix:= fseBrix2.Value;
     FG:= ((1.001843 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
            - 0.000000034 * Power(OBrix, 3) + 0.00574 * (FBrix)
            + 0.00003344 * (FBrix * FBrix) + 0.000000086 * Power(FBrix, 3))
            + (1.313454) * 0.001);
 //    RI:= 1.33302 + 0.001427193 * FBrix + 0.000005791157 * (FBrix * FBrix);
     Plato:= FBrix / Settings.BrixCorrection.Value;
     Alc:= (277.8851 - 277.4 * FG + 0.9956 * Plato + 0.00523 * (Plato * Plato)
           + 0.000015 * (Plato * Plato * Plato)) * (FG / 0.79);
     fsePlato2.Value:= SGtoPlato(fseSG2.Value);
     fseSG2.Value:= FG;
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     FUserClicked:= TRUE;
   end;
   fseSG2.MaxValue:= fseSG.Value;
   fsePlato2.MaxValue:= fsePlato.Value;
   fseBrix2.MaxValue:= fseBrix.Value;
 end;

 procedure TfrmMain.fseBrixChange(Sender: TObject);
 var OBrix, FBrix, Alc, FG, Plato : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     fseSG.Value:= BrixToSG(fseBrix.Value);
     fsePlato.Value:= fseBrix.Value / Settings.BrixCorrection.Value;
     OBrix:= fseBrix.Value;
     FBrix:= fseBrix2.Value;
     FG:= ((1.001843 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
            - 0.000000034 * Power(OBrix, 3) + 0.00574 * (FBrix)
            + 0.00003344 * (FBrix * FBrix) + 0.000000086 * Power(FBrix, 3))
            + (1.313454) * 0.001);
     Plato:= FBrix / Settings.BrixCorrection.Value;
     Alc:= (277.8851 - 277.4 * FG + 0.9956 * Plato + 0.00523 * (Plato * Plato)
           + 0.000015 * (Plato * Plato * Plato)) * (FG / 0.79);
     fsePlato2.Value:= SGtoPlato(fseSG2.Value);
     fseSG2.Value:= FG;
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     FUserClicked:= TRUE;
   end;
   fseSG2.MaxValue:= fseSG.Value;
   fsePlato2.MaxValue:= fsePlato.Value;
   fseBrix2.MaxValue:= fseBrix.Value;
 end;

 procedure TfrmMain.fseSG2Change(Sender: TObject);
 var FG, OBrix, FBrix, Alc, Plato, a, b, c, d, X2, X3 : double;
 begin
   if FUserClicked then
   begin
     FBrix:= 0;
     X2:= 0;
     X3:= 0;
     FUserClicked:= false;
     FG:= fseSG2.Value;
     Plato:= SGtoPlato(FG);
     OBrix:= fseBrix.Value;
     a:= 0.000000086;
     b:= 0.00003344;
     c:= 0.00574;
     d:= 1.003156454 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
            - 0.000000034 * Power(OBrix, 3) - FG;
     SolveCubic(a, b, c, d, FBrix, X2, X3);
     Alc:= AbVol(fseSG.Value, FG);

     fsePlato2.Value:= Plato;
     fseBrix2.Value:= FBrix;
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     if fseSG.Value > 1 then
       eSVG1.Text:= RealToStrDec(100 * (fseSG.Value - fseSG2.Value) / (fseSG.Value - 1), 1) + '%'
     else
       eSVG1.Text:= RealToStrDec(0, 1) + '%';
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fsePlato2Change(Sender: TObject);
 var OBrix, FBrix, Plato, FG, Alc, a, b, c, d, X2, X3 : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     OBrix:= fseBrix.Value;
     Plato:= fsePlato2.Value;
     FG:= PlatoToSG(Plato);

     a:= 0.000000086;
     b:= 0.00003344;
     c:= 0.00574;
     d:= 1.003156454 - 0.002318474 * OBrix - 0.000007775 * (OBrix * OBrix)
            - 0.000000034 * Power(OBrix, 3) - FG;
     SolveCubic(a, b, c, d, FBrix, X2, X3);

     Alc:= AbVol(fseSG.Value, FG);
     fseSG2.Value:= FG;
     fseBrix2.Value:= FBrix;
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     eSVG1.Text:= RealToStrDec(100 * (fseSG.Value - fseSG2.Value) / (fseSG.Value - 1), 1) + '%';
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseBrix2Change(Sender: TObject);
 var OBrix, FBrix, FG, Alc, Plato : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     OBrix:= fseBrix.Value;
     FBrix:= fseBrix2.Value;
     FG:= BrixToFG(OBrix, FBrix);
     Plato:= FBrix / Settings.BrixCorrection.Value;
     Alc:= (277.8851 - 277.4 * FG + 0.9956 * Plato + 0.00523 * (Plato * Plato)
           + 0.000015 * (Plato * Plato * Plato)) * (FG / 0.79);
     fseSG2.Value:= FG;
     fsePlato2.Value:= SGtoPlato(fseSG2.Value);
     eABV2.Text:= RealToStrDec(Alc, 1) + ' vol.%';
     if fseSG.Value > 1 then
       eSVG1.Text:= RealToStrDec(100 * (fseSG.Value - fseSG2.Value) / (fseSG.Value - 1), 1) + '%'
     else
       eSVG1.Text:= '0%';
     FUserClicked:= TRUE;
   end;
 end;


 procedure TfrmMain.bbPropagationClick(Sender: TObject);
 begin
   FrmPropagation:= TFrmPropagation.Create(self);
   FrmPropagation.Execute(FTemporary);
   FrmPropagation.Free;
 end;

 procedure TfrmMain.fseSG3Change(Sender: TObject);
 var SG1, Vol1, Water1, S1, WaterAdd, SugarAdd, Water2, Vol2, S2, SG2 : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     SG1:= fseSG3.Value;
     Vol1:= fseVolume.Value;
     fseWater.MinValue:= -Vol1;
     S1:= SGtoPlato(SG1) / 100 * Vol1 * SG1;
     Water1:= Vol1 * SG1 - S1;
     WaterAdd:= fseWater.Value;
     SugarAdd:= fseSugar.Value;

     Water2:= Water1 + WaterAdd;
     S2:= S1 + SugarAdd;
     Vol2:= Water2 + S2 / 1.611;
     if ((Water2 + S2) > 0) then
       SG2:= PlatoToSG(100 * S2 / (Water2 + S2))
     else
       SG2:= SG1;
     fseSGAfter.Value:= SG2;
     fseVolumeAfter.Value:= Vol2;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSGAfterChange(Sender: TObject);
 var SG1, Vol1, Water1, S1, WaterAdd, SugarAdd, Water2, Vol2, S2, SG2 : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     SG1:= fseSG3.Value;
     Vol1:= fseVolume.Value;
     S1:= SGtoPlato(SG1) / 100 * Vol1 * SG1;
     Water1:= Vol1 * SG1 - S1;

     SG2:= fseSGAfter.Value;
     Vol2:= fseVolumeAfter.Value;

     S2:= SGtoPlato(SG2) / 100 * Vol2 * SG2;
   //  Water2:= Vol2 - S2 / 1.611;
     Water2:= Vol2 * SG2 - S2;

     if S2 < S1 then //not possible
     begin
       fseWater.Value:= 0;
       fseSugar.Value:= 0;
       fseSGAfter.Value:= fseSG3.Value;
       fseVolumeAfter.Value:= fseVolume.Value;
     end
     else
     begin
       WaterAdd:= Water2 - Water1;
       SugarAdd:= S2 - S1;
       fseWater.Value:= WaterAdd;
       fseSugar.Value:= SugarAdd;
     end;
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.fseSG4Change(Sender: TObject);
 var SG, Temp, SGc : double;
 begin
   if FUserClicked then
   begin
     FUserClicked:= false;
     SG:= fseSG4.Value;
     Temp:= fseSGTemp.Value;
     SGc:= SG - 0.000000015324 * Power(Temp, 3) + 0.000005849949 * Power(Temp, 2)
           - 0.000016286059*Temp - 0.001811050552;
     eSGCorr.Caption:= RealToStrDec(SGc, 3);
     FUserClicked:= TRUE;
   end;
 end;

 procedure TfrmMain.bbPostFermentationClick(Sender: TObject);
 begin
   FrmRefractometer:= TFrmRefractometer.Create(self);
   FrmRefractometer.ShowModal;
   FrmRefractometer.Free;
 end;

 procedure TfrmMain.bbCookingMethodClick(Sender: TObject);
 begin
   FrmBoilMethod:= TFrmBoilMethod.Create(self);
   FrmBoilMethod.ShowModal;
   FrmBoilMethod.Free;
 end;

 procedure TfrmMain.bbtnHopStorageClick(Sender: TObject);
 var D, M, Y : word;
     HD, Dr : TDateTime;
 begin
   frmHopStorage:= TFrmHopStorage.Create(self);
   if (FSelIngredient <> NIL) and (FSelIngredient is THop) then
   begin
     frmHopStorage.HSI:= THop(FSelIngredient).HSI.Value;
     frmHopStorage.Alpha:= THop(FSelIngredient).Alfa.Value;
     if FSelected <> NIL then
     begin;
       Dr:= round(FSelected.Date.Value);
       if Dr <= 1 then Dr:= Now;
       HD:= THop(FSelIngredient).HarvestDate.Value;
       if HD <= 1 then //if harvestdate is not available, take the last harvest. This obviously does not work well for hops from the southern hemisphere.
       begin
         DecodeDate(Dr, Y, M, D);
         if M < 8 then Y:= Y - 1;
         HD:= EncodeDate(Y, 9, 1);
       end;
       if Dr > HD then frmHopStorage.Age:= round((Dr - HD) / (365/12));
     end;
   end;
   FrmHopStorage.ShowModal;
   FrmHopStorage.Free;
 end;

 Procedure TfrmMain.SetControlsStrings;
 begin
  tsFile.Caption:= file1;
  tsDatabases.Caption:= data1;
  tsAnalysis.Caption:= analysis1;
  tsOptions.Caption:= settings1;
  tbImport.Hint:= importhint1;
  tbExport.Hint:= exporthint1;
  tbExit.Hint:= exithint1;
  tbSave.Hint:= savehint1;
  tbPrintPreview.Hint:= printpreviewhint1;
  tbCopyClipboard.Hint:= copyclipboardhint1;
  tbCopyHTML.Hint:= copyHTMLhint1;
  tbInfo.Hint:= infohint1;
  tbSynchronize.Hint:= synchronizehint1;
  tbBrewsList.Hint:= brewslisthint1;
  tbChecklist.Hint:= checklisthint1;
  tbHelp.Hint:= helphint1;

  tbFermentablesp.Hint:= fermentableshint1;
  tbHops.Hint:= hopshint1;
  tbYeasts.Hint:= yeastshint1;
  tbMisc.Hint:= miscshint1;
  tbWaters.Hint:= watershint1;
  tbMash.Hint:= mashhint1;
  tbEquipment.Hint:= equipmenthint1;
  tbBeerstyles.Hint:= beerstyleshint1;
  tbInventoryList.Hint:= inventorylisthint1;
  tbBackup.Hint:= backuphint1;
  tbRestore.Hint:= restorehint1;
  tbRestoreOriginal.Hint:= restoreoriginalhint1;
  tbFermChart.Hint:= fermcharthint1;
  tbHopChart.Hint:= hopcharthint1;
  tbYeastChart.Hint:= yeastcharthint1;
  tbWaterChart.Hint:= watercharthint1;

  tbHistogram.Hint:= histogramhint1;
  tbChart.Hint:= charthint1;
  tbTrainNN.Hint:= trainnnhint1;
  //settings tab
  Label7.Caption:= color1;
  cbColorMethod.Hint:= colorhint1;
  Label8.Caption:= bitterness1;
  cbIBUMethod.Hint:= bitternesshint1;
  bbSettings.Caption:= settings2;
  bbSettings.Hint:= settingshint2;
  cbAdjustAlpha.Caption:= adjustalfa1;
  cbAdjustAlpha.Hint:= adjustalfahint1;
  bbDatabaseLocation.Caption:= databaselocation1;
  bbDatabaseLocation.Hint:= databaselocationhint1;
  cbShowSplash.Caption:= showsplash1;
  cbShowSplash.Hint:= showsplashhint1;
  cbPlaySounds.Caption:= playsounds1;
  cbPlaySounds.Hint:= playsoundshint1;
  bbLogo.Caption:= logo1;
  bbLogo.Hint:= logohint1;
  //pcrecipes
  tsBrews.Caption:= tsbrews1;
  tsBrews.Hint:= tsbrewshint1;
  tsRecipes.Caption:= tsrecipes1;
  tsRecipes.Hint:= tsrecipeshint1;
  tsCloud.Caption:= tscloud1;
  tsCloud.Hint:= tscloudhint1;
  Label19.Caption:= filter1;
  Label156.Caption:= filter1;
  sbSearchBrewsDelete.Hint:= filterdel1;
  sbSearchRecipesDelete.Hint:= filterdel1;
  eSearchBrews.Hint:= filterbrewshint1;
  eSearchRecipes.Hint:= filterrecipeshint1;
  Label1.Caption:= sort1;
  Label21.Caption:= sort1;
  Label140.Caption:= sort1;
  bbNewBrew.Caption:= newbrew1;
  bbNewBrew.Hint:= newbrewhint1;
  bbRemoveBrew.Caption:= removebrew1;
  bbRemoveBrew.Hint:= removebrewhint1;
  bbNewRecipe.Caption:= newrecipe1;
  bbNewRecipe.Hint:= newrecipehint1;
  bbRemoveRecipe.Caption:= removerecipe1;
  bbRemoveRecipe.Hint:= removerecipehint1;
  bbRemoveCloudRecipe.Caption:= removecloudrecipe1;
  bbRemoveCloudRecipe.Hint:= removecloudrecipehint1;

  //pcrecipe
    //tsrecipe
    tsRecipe.Caption:= tsrecipe1;
    tsRecipe.Hint:= tsrecipehint1;
    gbalgemeen.Caption:= gbalgemeen1;
    Label2.Caption:= code1;
    eNrRecipe.Hint:= codehint1;
    Label3.Caption:= naam1;
    eName.Hint:= naamhint1;
    cbLocked.Caption:= locked1;
    cbLocked.Hint:= lockedhint1;
    Label4.Caption:= beerstyle1;
    cbBeerStyle.Hint:= beerstylehint1;
    Label5.Caption:= recipetype1;
    cbType.Hint:= recipetypehint1;
    Label6.Caption:= equipment1;
    cbEquipment.Hint:= equipmenthint2;
    Label15.Caption:= volume1;
    fseBatchSize.Hint:= volumehint1;
    cbScaleVolume.Caption:= scalevolume1;
    cbScaleVolume.Hint:= scalevolumehint1;

    gbIngredients.Caption:= gbingredients1;
    hcIngredients.Sections[0].Text:= hcingredients1;
    hcIngredients.Sections[1].Text:= hcingredients2;
    hcIngredients.Sections[2].Text:= hcingredients3;
    hcIngredients.Sections[3].Text:= hcingredients4;
    hcIngredients.Sections[4].Text:= hcingredients5;
    cbPercentage.Caption:= cbpercentage1;
    cbPercentage.Hint:= cbpercentagehint1;
    Label9.Caption:= og1;
    fseOG.Hint:= oghint1;
    Label10.Caption:= efficiency1;
    fseEfficiency.Hint:= efficiencyhint1;
    Label12.Caption:= bitterness2;
    fseIBU.Hint:= bitternesshint2;
    Label13.Caption:= color2;
    eColor2.Hint:= colorhint2;
    bbAddGrain.Caption:= addgrain1;
    bbAddGrain.Hint:= addgrainhint1;
    bbAddHop.Caption:= addhop1;
    bbAddHop.Hint:= addhophint1;
    Label16.Caption:= add1;
    bbAddMisc.Caption:= addmisc1;
    bbAddMisc.Hint:= addmischint1;
    bbAddYeast.Caption:= addyeast1;
    bbAddYeast.Hint:= addyeasthint1;
    bbRemove.Caption:= remove1;
    bbRemove.Hint:= removehint1;
    Label17.Caption:= bitterindex1;
    eBUGU.Hint:= bitterindexhint1;
    lBUGU.Caption:= ibugu3;
 //   ibugu1 = 'Zeer bitter';
 //   ibugu2 = 'Bitter';
 //   ibugu3 = 'Evenwichtig';
 //   ibugu4 = 'Zoet';
 //   ibugu5 = 'Zeer zoet';
    Label18.Caption:= fg1;
    eFGest.Hint:= fghint1;
    bbInventory.Caption:= bbinventory1;
    bbInventory.Hint:= bbinventoryhint1;
    Label62.Caption:= boiltime1;
    fseBoilTime.Hint:= boiltimehint1;
    Label150.Caption:= alcohol1;
    eABVest.Hint:= alcoholhint1;
    Label11.Caption:= cost1;
    eCosts.Hint:= costhint1;
    sbGristWizard.Hint:= gristwizardhint1;
    sbHopWizard.Hint:= hopwizardhint1;
    gbVisual.Caption:= gbvisual1;
    //tswater
    gbMashing.Caption:= gbmashing1;
    bbAddStep.Caption:= addstep1;
    bbAddStep.Hint:= addstephint1;
    bbDeleteStep.Caption:= deletestep1;
    bbDeleteStep.Hint:= deletestephint1;
    Label22.Caption:= cbmash1;
    cbMash.Hint:= cbmashhint1;
    hcMash.Sections[0].Text:= hcmash1;
    hcMash.Sections[1].Text:= hcmash2;
    hcMash.Sections[2].Text:= hcmash3;
    hcMash.Sections[3].Text:= hcmash4;
    hcMash.Sections[4].Text:= hcmash5;
    hcMash.Sections[5].Text:= hcmash6;
    hcMash.Sections[6].Text:= hcmash7;
    hcMash.Sections[7].Text:= hcmash8;
    hcMash.Sections[8].Text:= hcmash9;
    hcMash.Sections[9].Text:= hcmash10;
    Label23.Caption:= malttemp1;
    seGrainTemp.Hint:= malttemphint1;
    Label24.Caption:= tuntemp1;
    seTunTemp.Hint:= tuntemphint1;
    Label25.Caption:= mashvolume1;
    fseInfuseAmount.Hint:= mashvolumehint1;
    cbTunTemp.Caption:= preheated1;
    cbTunTemp.Hint:= preheatedhint1;
    bbWaterAdjustment.Caption:= bbwatertreatment1;
    bbWaterAdjustment.Hint:= bbwatertreatmenthint1;
    gbWater.Caption:= gbwater1;
    Label26.Caption:= mashvolume2;
    eMashWater.Hint:= mashvolumehint2;
    Label29.Caption:= grainabsorption1;
    eGrainAbsorption.Hint:= grainabsorptionhint1;
    Label27.Caption:= spargevolume1;
    eSpargeWater.Hint:= spargevolumehint1;
    Label32.Caption:= filterloss1;
    fseSpargeDeadSpace.Hint:= filterlosshint1;
    Label34.Caption:= preboilvolume1;
    eBoilSize.Hint:= preboilvolumehint1;
    Label37.Caption:= evaporation1;
    fseEvaporation.Hint:= evaporationhint1;
    Label38.Caption:= endboilvolume1;
    eAfterBoil.Hint:= endboilvolumehint1;
    Label151.Caption:= endboilvolume2;
    eAfterCooling.Hint:= endboilvolumehint2;
    Label28.Caption:= spargemash1;
    eSpMa.Hint:= spargemashhint1;
    Label41.Caption:= kettleloss1;
    fseChillerLoss.Hint:= kettlelosshint1;
    Label42.Caption:= volumefermenter1;
    eToFermenter.Hint:= volumefermenterhint1;
    Label43.Caption:= topupwater1;
    fseTopUpWater.Hint:= topupwaterhint1;
    Label44.Caption:= prefermvolume1;
    eVolumeFermenter.Hint:= prefermvolumehint1;
    bbWaterWizard.Caption:= bbwaterwizard1;
    bbWaterWizard.Hint:= bbwaterwizardhint1;
    //tsbrewday
    tsBrewday.Caption:= tsbrewday1;
    tsBrewday.Hint:= tsbrewdayhint1;
    Label46.Caption:= brewdate1;
    deBrewDate.Hint:= brewdatehint1;
    Label68.Caption:= starttime1;
    rxteStartTime.Hint:= starttimehint1;
    rxteStartTime.ShowHint:= TRUE;
    Label70.Caption:= endtime1;
    rxteEndTime.Hint:= endtimehint1;
    rxteEndTime.ShowHint:= TRUE;

    gbMeasMash.Caption:= gbmeasmash1;
    Label50.Caption:= pH1;
    fseMashpH.Hint:= pHhint1;
    Label59.Caption:= sgendmash1;
    fseSGendmash.Hint:= sgendmashhint1;
    Label63.Caption:= mashefficiency1;
    eEfficiencyMash.Hint:= mashefficiencyhint1;

    gbMeasBoil.Caption:= gbmeasboil1;
    gbMeasBoil.Hint:= gbmeasboilhint1;
    Label55.Caption:= startboil1;
    Label57.Caption:= planned1;
    Label56.Caption:= endboil1;
    Label58.Caption:= pHboil1;
    fseBoilpHS.Hint:= pHboilstarthint1;
    fseBoilpHE.Hint:= pHboilendhint1;
    lSGb.Caption:= sgboil1;
    fseBoilSGS.Hint:= sgboilstarthint1;
    fseBoilSGE.Hint:= sgboilendhint1;
    Label60.Caption:= volumeboil1;
    fseBoilVolumeS.Hint:= volumeboilstarthint1;
    fseBoilVolumeE.Hint:= volumeboilendhint1;
    Label20.Caption:= efficiencyboil1;
    fseBoilVolumeS.Hint:= efficiencyboilstarthint1;
    fseBoilVolumeE.Hint:= efficiencyboilendhint1;
    eBoilSGSP.Hint:= sgboilstartplannedhint1;
    eBoilSGEP.Hint:= sgboilendplannedhint1;
    eBoilVolumeSP.Hint:= volumeboilstartplannedhint1;
    eBoilVolumeEP.Hint:= volumeboilendplannedhint1;
    eEfficiencyP.Hint:= efficiencyboilplannedhint1;

    gbMeasSparge.Caption:= gbmeassparge1;
    Label53.Caption:= tempsparge1;
    fseSpargeTemp.Hint:= tempspargehint1;
    Label51.Caption:= pHsparge1;
    fseSpargepH.Hint:= pHspargehint1;
    Label52.Caption:= pHspargelast1;
    fseLastRunningpH.Hint:= pHspargelasthint1;
    Label54.Caption:= sgspargelast1;
    fseLastRunningSG.Hint:= sgspargelasthint1;

    gbCooling.Caption:= gbcooling1;
    Label64.Caption:= whirlpooltime1;
    seWhirlpoolTime.Hint:= whirlpooltimehint1;
    Label69.Caption:= coolertype1;
    cbCoolingMethod.Hint:= coolertypehint1;
    Label66.Caption:= cooltime1;
    seCoolingTime.Hint:= cooltimehint1;
    Label155.Caption:= coolto1;
    fseCoolingTo.Hint:= cooltohint1;
    Label35.Caption:= volumetofermenter1;
    fseVolToFermenter.Hint:= volumetofermenterhint1;
    Label167.Caption:= topupwater2;
    fseTopUpWater2.Hint:= topupwaterhint2;
    Label152.Caption:= aerationtime1;
    fseTimeAeration.Hint:= aerationtimehint1;
    Label153.Caption:= aerationflowrate1;
    fseAerationFlowRate.Hint:= aerationflowratehint1;
    Label154.Caption:= aerationwith1;
    cbAerationType.Hint:= aerationwithhint1;
    Label164.Caption:= og2;
    eOGFermenter.Hint:= oghint2;
    Label165.Caption:= bitterness3;
    eIBUFermenter.Hint:= bitterness3hint3;
    Label166.Caption:= color3;
    eColorFermenter.Hint:= colorhint3;

    gbVolumes.Caption:= gbvolumes1;
    Label157.Caption:= cmfromtop1;
    Label158.Caption:= volumecalc1;
    Label159.Caption:= mashvol1;
    Label160.Caption:= filtervol1;
    Label161.Caption:= kettlevol1;

    gbTimers.Caption:= gbtimers1;
    bbStartMash.Caption:= startmash1;
    bbStartMash.Hint:= startmashhint1;
    //startmashhint2 = 'Tijd over voor lopende maischstap';
    //startmash2 = ' bezig';
    //pause1 = 'Pauze';
    //readymash1 = ' klaar';
    //startmash3 = 'Start ';
    bbStartBoil.Caption:= startboil2;
    bbStartBoil.Hint:= startboilhint1;
    //startboilhint2 = 'Tijd over bij koken';
    //startboil3 = 'Koken bezig';
    //boiltimeto1 = 'Tijd om ';
    //boiltimeto2 = ' af te wegen.';
    //boiltimeto3 = ' toe te voegen.';
    //endboil2 = 'Koken klaar';
    bbStartTimer.Caption:= stopwatch1;
    bbStartTimer.Hint:= stopwatch1;
    //stopwatch2 = 'Stopwatch loopt';
    //stopwatchhint1 = 'Tijd lopende stopwatch';
    //resettimers1 = 'Herstel';
    //resettimershint1 = 'Herstel de timers';

    //tsFermentation
    tsFermentation.Caption:= tsFermentation1;
    tsFermentation.Hint:= tsFermentationhint1;
    gbYeast.Caption:= gbyeast1;
    gbYeast.Hint:= gbyeasthint1;
    Label71.Caption:= yeasttype1;
    cbYeastAddedAs.Hint:= yeasttypehint1;
    cbStarterMade.Caption:= startermade1;
    cbStarterMade.Hint:= startermadehint1;
    Label72.Caption:= startertype1;
    cbStarterType.Hint:= startertypehint1;
 {   starteraerationtime1 = 'Tijd belucht:';
    starteraerationtime2 = 'Tijd geroerd:';
    starteraerationtimehint1 = 'Hoe lang heb je de starter belucht of geroerd?';
    yeastamount1 = 'Hoeveelheid:';
    yeastamounthint1 = 'Hoeveelheid gebruikte gist';
    starterstep1 = 'Starter stap 1:';
    starterstephint1 = 'Volume van de giststarter';
    starterstep2 = 'Starter stap 2:';
    starterstephint2 = 'Volume van de giststarter';
    starterstep3 = 'Starter stap 3:';
    starterstephint3 = 'Volume van de giststarter';
    numcells1 = 'Aantal cellen:';
    numcellshint1 = 'Aantal gebruikte cellen voor enten';
    cellswanted1 = 'Nodig:';
    cellswantedhint1 = 'Aantal benodigde cellen voor enten';
    sgstarter1 = 'SG starter:';
    sgstarterhint1 = 'SG van de starter';
    tempstarter1 = 'Temperatuur:';
    tempstarterhint1 = 'Temperatuur van de giststarter';
    //gbtemperatures
    gbtemperatures1 = 'Metingen';
    //tsmeassimple
    tsmeassimple1 = 'Eenvoudig';
    starttempferm1 = 'Starttemperatuur vergisting:';
    starttempfermhint1 = 'Temperatuur wort bij het enten van de gist';
    maxtempferm1 = 'Maximale temperatuur hoofdvergisting:';
    maxtempfermhint1 = 'Maximale temmperatuur van het gistende wort';
    endtempferm1 = 'Eindtemperatuur hoofdvergisting:';
    endtempfermhint1 = 'Eindtemperatuur hoofdvergisting van het gistende wort';
    sgendprimary1 = 'SG aan eind hoofdvergisting:';
    sgendprimaryhint1 = 'SG aan het einde van de hoofdvergisting';
    aaendprimary1 = 'Schijnbare vergistingsgraad:';
    aaendprimaryhint1 = 'Vergistingsgraad eind hoofdvergisting';
    startsecondary1 = 'Overhevelen/start nagisting:';
    startsecondaryhint1 = 'Datum van overhevelen of start nagisting';
    tempsecondary1 = 'Temperatuur nagisting';
    tempsecondaryhint1 = 'Temperatuur bij de nagisting';
    startlagering1 = 'Start (koud) lageren:';
    startlageringhint1 = 'Datum waarop de (koude) lagering begint';
    templagering1 = 'Temperatuur lageren:';
    templageringhint1 = 'Temperatuur bij het lageren';
    fgferm1 = 'Eind SG:';
    fgfermhint1 = 'SG bij bottelen';
    fgpredicted1 = 'Voorspeld:';
    fgpredictedhint1 = 'Voorspeld eind SG op basis van ingrediënten en brouwproces';
    alcferm1 = 'Alcoholgehalte voor hergisting:';
    alcfermhint1 = 'Alcoholgehalte van het bier voor bottelen';
    aaend1 = 'Schijnbare vergistingsgraad:';
    aaendhint1 = 'Schijnbare vergistingsgraad van het uitgegiste bier';
    energy1 = 'Energie-inhoud:';
    energyhint1 = 'Aantal calorieën in het uitgegiste bier';
    raend1 = 'Werkelijke vergistingsgraad:';
    raendhint1 = 'Werkelijke vergistingsgraad van het uitgegiste bier';
    //tsmeasext
    tsmeasext1 = 'Uitgebreid / TControl';
    changemeas1 = 'Wijzig metingen';
    changemeashint1 = 'Voeg metingen toe of wijzig deze';
    t1 = 'T sensor 1';
    t2 = 'T sensor 2';
    it1 = 'Inst. temp.';
    co2m1 = 'CO2';
    cooling1 = 'Koelen';
    heating1 = 'Verwarmen';
    coolpower1 = 'Koelverm.';
    sgmeasext1 = 'SG';      }

 end;

 Initialization

 //FrmNotification:= NIL;

 finalization

 {if FrmNotification <> NIL then
   FrmNotification.Free;}

end.


