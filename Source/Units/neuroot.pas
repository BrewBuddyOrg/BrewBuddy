unit neuroot;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Data, DOM, XMLRead, XMLWrite, fann, fannnetwork, stdctrls;

type
  TOnTrainRound = procedure(ASender : TObject; Error, Progress : single) of object;
  TOnTrainReady = procedure(ASender : TObject; Error : single) of object;

  TBHNN = class(TObject)
   private
     Fnn : tfannnetwork;
     FFileName : string;
     FName : string;
     FInputIndexs : array of string; //Names of variables of recipe for input of the NN
     FOutputIndexs : array of string;//Names of variables of recipe for output of the NN
     FInMin, FInMax : array of double;
     FOutMin, FOutMax : array of double;
     FIsTrained : boolean;
     FOnTrainRound : TOnTrainRound;
     FOnTrainReady : TOnTrainReady;
     FEquipment : string;
     FAutoNr : longint;
     FIsBuilt : boolean;
     FMSE : double;
     Procedure SetEquipment(s : string);
   protected
     Procedure SetAutoNr(i : longint);
     Function CheckValidData(R : TRecipe) : boolean;
     Procedure FindInputMinMax(s : string; i : integer);
     Procedure FindOutputMinMax(s : string; i : integer);
     Procedure FindMinMax;
     Function ValueToInput(i : integer; x : double) : double;
     Function ValueToOutput(i : integer; x : double) : double;
     Function OutputToValue(i : integer; x : double) : double;
     Function GetMSE : single;
     Procedure SetActivationFunction(af : TActivationFunction);
     Function GetActivationFunction : TActivationFunction;
   public
     Constructor Create;
     Destructor Destroy; override;
     Procedure AddInputIndex(s : string);
     Procedure AddOutputIndex(s : string);
     Procedure ClearInputIndexs;
     Procedure ClearOutputIndexs;
     Function GetInputCount : integer;
     Function GetOutputCount : integer;
     Function GetInputIndex(i : integer) : string;
     Function GetOutputIndex(i : integer) : string;
     Function GetInputMin(i : integer) : double;
     Function GetInputMax(i : integer) : double;
     Function GetOutputMin(i : integer) : double;
     Function GetOutputMax(i : integer) : double;
     Function IndexOfInput(s : string) : integer;
     Function IndexOfOutput(s : string) : integer;
     Function Build : boolean;
     Function UnBuild : boolean;
     Function CheckNumValidData(var nvalid : longint) : boolean;
     Function Train(Perc, NumRounds : integer; error : double) : boolean;
     Function Save : boolean;
     Function Load : boolean;
     Procedure SaveXML(Doc: TXMLDocument; iNode: TDOMNode);
     Procedure ReadXML(iNode: TDOMNode);
     Procedure Remove;
     Function Run(Inputs : array of double; var Outputs : array of double) : boolean;
     Function RunFromBrew(R : TRecipe; var Outputs : array of double) : boolean;
     Function GetPrediction(R : TRecipe; m : TMemo) : boolean;
     property InputIndex[i : integer] : string read GetInputIndex;
     property OutputIndex[i : integer] : string read GetOutputIndex;
     property InputMin[i : integer] : double read GetInputMin;
     property InputMax[i : integer] : double read GetInputMax;
     property OutputMin[i : integer] : double read GetOutputMin;
     property OutputMax[i : integer] : double read GetOutputMax;
   published
     property AutoNr : longint read FAutoNr write SetAutoNr;
     property FileName : string read FFileName write FFileName;
     property Name : string read FName write FName;
     property Equipment : string read FEquipment write SetEquipment;
     property IsTrained : boolean read FIsTrained write FIsTrained;
     property InputCount : integer read GetInputCount;
     property OutputCount : integer read GetOutputCount;
     property IsBuilt : boolean read FIsBuilt;
     property MSE : single read GetMSE;
     property ActivationFunction : TActivationFunction read GetActivationFunction write SetActivationFunction;
     property OnTrainRound : TOnTrainRound read FOnTrainRound write FOnTrainRound;
     property OnTrainReady : TOnTrainReady read FOnTrainReady write FOnTrainReady;
  end;

  TBHNNs = class(TObject)
   private
     FArrNN : array of TBHNN;
     FFileName : string;
   protected
     Function GetBHNN(i : longint) : TBHNN;
     Function GetCount : longint;
   public
     Constructor Create; virtual;
     Destructor Destroy; override;
     Procedure Clear;
     Procedure SaveXML;
     Procedure ReadXML;
     Function AddBHNN : TBHNN;
     Procedure RemoveBHNN(i : longint);
     Procedure RemoveByReference(NN : TBHNN);
     Procedure GetPrediction(R : TRecipe; m : TMemo);
     property BHNN[i : longint] : TBHNN read GetBHNN;
   published
     property Count : longint read GetCount;
     property FileName : string read FFileName write FFileName;
  end;

var BHNNs : TBHNNs;

    ActivationFunctionNames : array[TActivationFunction] of string;

    Function GetActivationFunctionFromName(s : string) : TActivationFunction;

implementation
uses Containers, Hulpfuncties, lconvencoding;

const iMarge = 0.05;

Function GetActivationFunctionFromName(s : string) : TActivationFunction;
var af : tActivationFunction;
begin
  Result:= afFANN_LINEAR;
  for af:= Low(ActivationFunctionNames) to High(ActivationFunctionNames) do
    if TLC(ActivationFunctionNames[af]) = TLC(s) then
    begin
      Result:= af;
      exit;
    end;
end;

Constructor TBHNN.Create;
begin
  Inherited Create;
  FNN:= TFannNetwork.Create(NIL);
  FNN.LearningRate := 0.7;
  FNN.ConnectionRate := 1.0;
  FNN.TrainingAlgorithm := taFANN_TRAIN_RPROP;

{                             afFANN_LINEAR,                      -inf - inf
                              afFANN_THRESHOLD,                   nvt
	                      afFANN_THRESHOLD_SYMMETRIC,         nvt
                              afFANN_SIGMOID ,                    0 - 1
                              afFANN_SIGMOID_STEPWISE,            0 - 1
                              afFANN_SIGMOID_SYMMETRIC ,          -1 - 1
                              afFANN_SIGMOID_SYMMETRIC_STEPWISE,  -1 - 1
                              afFANN_GAUSSIAN ,                   0 - 1
                              afFANN_GAUSSIAN_SYMMETRIC,          -1 - 1
                              afFANN_GAUSSIAN_STEPWISE,
                              afFANN_ELLIOT ,                     0 - 1
                              afFANN_ELLIOT_SYMMETRIC,            -1 - 1
                              afFANN_LINEAR_PIECE,                0 - 1
                              afFANN_LINEAR_PIECE_SYMMETRIC,      -1 - 1
                              afFANN_SIN_SYMMETRIC,               -1 - 1
                              afFANN_COS_SYMMETRIC,               -1 - 1
                              afFANN_SIN,                         0 - 1
                              afFANN_COS                         0 - 1}

  FNN.ActivationFunctionHidden := afFANN_ELLIOT;
  FNN.ActivationFunctionOutput := FNN.ActivationFunctionHidden;
  FIsTrained:= false;
  FAutoNr:= -1;
  FFileName:= IntToStr(FAutoNr) + '.nn';
  FFileName:= '';
  FName:= '';
  FEquipment:= '';
  FIsBuilt:= false;
  FMSE:= 1;
end;

Destructor TBHNN.Destroy;
begin
  FreeAndNIL(FNN);
  SetLength(FInputIndexs, 0);
  SetLength(FOutputIndexs, 0);
  SetLength(FInMin, 0);
  SetLength(FInMax, 0);
  SetLength(FOutMin, 0);
  SetLength(FOutMax, 0);
  Inherited Destroy;
end;

Procedure TBHNN.SaveXML(Doc: TXMLDocument; iNode: TDOMNode);
var j, n : integer;
    iNN, iChild, iChild2 : TDOMNode;
begin
  iNN:= Doc.CreateElement('NN');
  iNode.AppendChild(iNN);

  n:= InputCount;
  AddNode(Doc, iNN, 'NUMINPUTS', IntToStr(n));
  iChild:= Doc.CreateElement('INPUTS');
  iNN.AppendChild(iChild);
  for j:= 1 to n do
  begin
    iChild2:= Doc.CreateElement('INPUT');
    iChild.AppendChild(iChild2);
    AddNode(Doc, iChild2, 'INDEX', InputIndex[j-1]);
    AddNode(Doc, iChild2, 'MIN', RealToStrDec(FInMin[j-1], 5));
    AddNode(Doc, iChild2, 'MAX', RealToStrDec(FInMax[j-1], 5));
  end;

  n:= OutputCount;
  AddNode(Doc, iNN, 'NUMOUTPUTS', IntToStr(n));
  iChild:= Doc.CreateElement('OUTPUTS');
  iNN.AppendChild(iChild);
  for j:= 1 to n do
  begin
    iChild2:= Doc.CreateElement('OUTPUT');
    iChild.AppendChild(iChild2);
    AddNode(Doc, iChild2, 'INDEX', OutputIndex[j-1]);
    AddNode(Doc, iChild2, 'MIN', RealToStrDec(FOutMin[j-1], 5));
    AddNode(Doc, iChild2, 'MAX', RealToStrDec(FOutMax[j-1], 5));
  end;

  AddNode(Doc, iNN, 'NAME', Name);
  AddNode(Doc, iNN, 'FILENAME', FileName);
  AddNode(Doc, iNN, 'IS_TRAINED', BoolToStr(IsTrained));
  AddNode(Doc, iNN, 'EQUIPMENT', FEquipment);
  AddNode(Doc, iNN, 'MSE', RealToStrDec(FMSE, 6));
  AddNode(Doc, iNN, 'ACT_FUNC', ActivationFunctionNames[GetActivationFunction]);

  if FIsTrained then Save;
end;

Function ReadNode(iNode : TDomNode; FLabel : string) : string;
var
  v: string;
  {$ifdef WINDOWS}
  encs, encto: string;
  {$endif}
begin
  Result:= '';
  if FLabel <> '' then
  begin
    v := GetNodeString(iNode, FLabel);
    if v <> '' then
    begin
      {$ifdef WINDOWS}
      encs := GetDefaultTextEncoding;
      encto := 'utf8';
      Result := ConvertEncoding(v, encs, encto);
      //  FValue:= ANSItoUTF8(v);
      {$else}
      Result := v;
      {$endif}
    end;
  end;
end;

Function ReadNodeInteger(iNode : TDomNode; FLabel : string) : integer;
var s : string;
begin
  Result:= 0;
  s:= ReadNode(iNode, FLabel);
  if s <> '' then Result:= StrToInt(s);
end;

Function ReadNodeFloat(iNode : TDomNode; FLabel : string) : double;
var s: string;
begin
  Result:= 0;
  s:= ReadNode(iNode, FLabel);
  if s <> '' then
    try
      s := SetDecimalSeparator(s);
      Result := StrToFloat(s);
    except
      Result := 0.0;
    end;
end;

Procedure TBHNN.ReadXML(iNode: TDOMNode);
var i, n : integer;
    s : string;
    iChild, iChild2 : TDOMNode;
    x : double;
    b : boolean;
begin
  //iNode is the NN node
  n:= ReadNodeInteger(iNode, 'NUMINPUTS');
  if n > 0 then
  begin
    SetLength(FInputIndexs, n);
    SetLength(FInMin, n);
    SetLength(FInMax, n);
    iChild:= iNode.FindNode('INPUTS');
    if iChild <> NIL then
    begin
      i:= 0;
      iChild2:= iChild.FirstChild;
      while iChild2 <> NIL do
      begin
        s:= ReadNode(iChild2, 'INDEX');
        FInputIndexs[i]:= s;
        x:= ReadNodeFloat(iChild2, 'MIN');
        FInMin[i]:= x;
        x:= ReadNodeFloat(iChild2, 'MAX');
        FInMax[i]:= x;
        inc(i);
        iChild2:= iChild2.NextSibling;
      end;
    end;
  end;

  n:= ReadNodeInteger(iNode, 'NUMOUTPUTS');
  if n > 0 then
  begin
    SetLength(FOutputIndexs, n);
    SetLength(FOutMin, n);
    SetLength(FOutMax, n);
    iChild:= iNode.FindNode('OUTPUTS');
    if iChild <> NIL then
    begin
      i:= 0;
      iChild2:= iChild.FirstChild;
      while iChild2 <> NIL do
      begin
        s:= ReadNode(iChild2, 'INDEX');
        FOutputIndexs[i]:= s;
        x:= ReadNodeFloat(iChild2, 'MIN');
        FOutMin[i]:= x;
        x:= ReadNodeFloat(iChild2, 'MAX');
        FOutMax[i]:= x;
        iChild2:= iChild2.NextSibling;
        inc(i);
      end;
    end;
  end;

  Name:= ReadNode(iNode, 'NAME');
  FileName:= ReadNode(iNode, 'FILENAME');
  FIsTrained:= StrToBool(ReadNode(iNode, 'IS_TRAINED'));
  FEquipment:= ReadNode(iNode, 'EQUIPMENT');
  FMSE:= ReadNodeFloat(iNode, 'MSE');
  s:= ReadNode(iNode, 'ACT_FUNC');
  b:= FIsTrained;
  if s <> '' then SetActivationFunction(GetActivationFunctionFromName(s));
  FIsTrained:= b;
  if FIsTrained then Load else Build;
  FIsBuilt:= TRUE;
end;

Function TBHNN.Save : boolean;
begin
  Result:= false;
  if FFileName <> '' then
  begin
    Result:= TRUE;
    try
      FNN.savetofile(Settings.DataLocation.Value + FFileName);
    except
      Result:= false;
    end;
  end;
end;

Function TBHNN.Load : boolean;
begin
  Result:= false;
  if FileExists(Settings.DataLocation.Value + FFileName) then
  begin
    Result:= TRUE;
    try
      FNN.loadfromfile(Settings.DataLocation.Value + FFileName);
      //FIsTrained:= TRUE;
    except
      Result:= false;
    end;
  end;
end;

Procedure TBHNN.Remove;
begin
  if FileExists(Settings.DataLocation.Value + FFileName) then
    DeleteFile(Settings.DataLocation.Value + FFileName);
end;

Procedure TBHNN.SetActivationFunction(af : TActivationFunction);
begin
  if FNN.ActivationFunctionHidden <> af then
  begin
    FNN.ActivationFunctionHidden := af;
    FNN.ActivationFunctionOutput := FNN.ActivationFunctionHidden;
//    FNN.UnBuild;
//    FNN.Build;
    FIsTrained:= false;
  end;
end;

Function TBHNN.GetActivationFunction : TActivationFunction;
begin
  Result:= FNN.ActivationFunctionHidden;
end;

Procedure TBHNN.SetAutoNr(i : longint);
begin
  if i <> FAutoNr then
  begin
    FAutoNr:= i;
    FFileName:= IntToStr(FAutoNr) + '.nn';
  end;
end;

Procedure TBHNN.SetEquipment(s : string);
begin
  FEquipment:= s;
end;

Function TBHNN.GetInputCount : integer;
begin
  Result:= High(FInputIndexs) + 1;
end;

Function TBHNN.GetOutputCount : integer;
begin
  Result:= High(FOutputIndexs) + 1;
end;

Function TBHNN.GetInputIndex(i : integer) : string;
begin
  Result:= '';
  if (i >= Low(FInputIndexs)) and (i <= High(FInputIndexs)) then
    Result:= FInputIndexs[i];
end;

Function TBHNN.GetOutputIndex(i : integer) : string;
begin
  Result:= '';
  if (i >= Low(FOutputIndexs)) and (i <= High(FOutputIndexs)) then
    Result:= FOutputIndexs[i];
end;

Function TBHNN.GetInputMin(i : integer) : double;
var x : double;
begin
  Result:= -100;
  if (i >= Low(FInputIndexs)) and (i <= High(FInputIndexs)) then
  begin
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= FInMax[i] * (1 - 1 / (1 + iMarge));
    Result:= FInMin[i] +  x;
  end;
end;

Function TBHNN.GetInputMax(i : integer) : double;
var x : double;
begin
  Result:= -100;
  if (i >= Low(FInputIndexs)) and (i <= High(FInputIndexs)) then
  begin
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= FInMax[i] * (1 - 1 / (1 + iMarge));
    Result:= FInMax[i] -  x;
  end;
end;

Function TBHNN.GetOutputMin(i : integer) : double;
var x : double;
begin
  Result:= -100;
  if (i >= Low(FOutputIndexs)) and (i <= High(FOutputIndexs)) then
  begin
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= FOutMax[i] * (1 - 1 / (1 + iMarge));
    Result:= FOutMin[i] +  x;
  end;
end;

Function TBHNN.GetOutputMax(i : integer) : double;
var x : double;
begin
  Result:= -100;
  if (i >= Low(FOutputIndexs)) and (i <= High(FOutputIndexs)) then
  begin
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= FOutMax[i] * (1 - 1 / (1 + iMarge));
    Result:= FOutMax[i] -  x;
  end;
end;

Function TBHNN.IndexOfInput(s : string) : integer;
var j : integer;
begin
  Result:= -1;
  for j:= 0 to High(FInputIndexs) do
    if FInputIndexs[j] = s then
    begin
      Result:= j;
      Exit;
    end;
end;

Function TBHNN.IndexOfOutput(s : string) : integer;
var j : integer;
begin
  Result:= -1;
  for j:= 0 to High(FOutputIndexs) do
    if FOutputIndexs[j] = s then
    begin
      Result:= j;
      Exit;
    end;
end;

Procedure TBHNN.FindMinMax;
var s : string;
    i : integer;
begin
  for i:= 0 to High(FInputIndexs) do
  begin
    s:= FInputIndexs[i];
    FindInputMinMax(s, i);
  end;
  for i:= 0 to High(FOutputIndexs) do
  begin
    s:= FOutputIndexs[i];
    FindOutputMinMax(s, i);
  end;
end;

Procedure TBHNN.FindInputMinMax(s : string; i : integer);
var R : TRecipe;
    j : integer;
    x : double;
begin
  if s <> '' then
  begin
    FInMin[i]:= 1E10;
    FInMax[i]:= 0;
    for j:= 0 to Brews.NumItems - 1 do
    begin
      R:= TRecipe(Brews.Item[j]);
      if (R <> NIL) and (((R.Equipment <> NIL) and (TLC(R.Equipment.Name.Value) = TLC(FEquipment)))
         or (FEquipment = '')) then
      begin
        x:= R.GetNumberByName(s);
        if x > -99 then
        begin
          if x < FInMin[i] then FInMin[i]:= x;
          if x > FInMax[i] then FInMax[i]:= x;
        end;
      end;
    end;
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= iMarge * FInMax[i];
    FInMin[i]:= FInMin[i] - x;
    FInMax[i]:= FInMax[i] + x;
  end;
end;

Procedure TBHNN.AddInputIndex(s : string);
begin
  if s <> '' then
  begin
    SetLength(FInputIndexs, High(FInputIndexs) + 2);
    FInputIndexs[High(FInputIndexs)]:= s;
    SetLength(FInMin, High(FInMin) + 2);
    SetLength(FInMax, High(FInMax) + 2);
    FindInputMinMax(s, High(FInputIndexs));
  end;
end;

Procedure TBHNN.FindOutputMinMax(s : string; i : integer);
var R : TRecipe;
    j : integer;
    x : double;
begin
  if s <> '' then
  begin
    FOutMin[i]:= 1E10;
    FOutMax[i]:= 0;
    for j:= 0 to Brews.NumItems - 1 do
    begin
      R:= TRecipe(Brews.Item[j]);
      if (R <> NIL) and (((R.Equipment <> NIL) and (TLC(R.Equipment.Name.Value) = TLC(FEquipment)))
         or (FEquipment = '')) then
      begin
        x:= R.GetNumberByName(s);
        if x > -99 then
        begin
          if x < FOutMin[i] then FOutMin[i]:= x;
          if x > FOutMax[i] then FOutMax[i]:= x;
        end;
      end;
    end;
    x:= 0;
//    if (FNN.ActivationFunctionHidden = afFANN_SIGMOID) or (FNN.ActivationFunctionHidden = afFANN_SIGMOID_SYMMETRIC) then
      x:= iMarge * FOutMax[i];
    FOutMin[i]:= FOutMin[i] - x;
    FOutMax[i]:= FOutMax[i] + x;
  end;
end;

Procedure TBHNN.AddOutputIndex(s : string);
begin
  if s <> '' then
  begin
    SetLength(FOutputIndexs, High(FOutputIndexs) + 2);
    FOutputIndexs[High(FOutputIndexs)]:= s;
    SetLength(FOutMin, High(FOutMin) + 2);
    SetLength(FOutMax, High(FOutMax) + 2);
    FindOutputMinMax(s, High(FOutputIndexs));
  end;
end;

Procedure TBHNN.ClearInputIndexs;
begin
  SetLength(FInputIndexs, 0);
  SetLength(FInMin, 0);
  SetLength(FInMax, 0);
end;

Procedure TBHNN.ClearOutputIndexs;
begin
  SetLength(FOutputIndexs, 0);
  SetLength(FOutMin, 0);
  SetLength(FOutMax, 0);
end;

Function TBHNN.GetMSE : single;
begin
  if FIsTrained then Result:= FMSE
  else Result:= 1;
end;

Function TBHNN.Build : boolean;
var s : tstringlist;
    n1, n2, n3 : integer;
begin
  Result:= TRUE;
  try
    n1:= High(FInputIndexs) + 1;
    n3:= High(FOutputIndexs) + 1;
    n2:= round((n1 + n3) / 2);
    s := tstringlist.create;
    s.add(IntToStr(n1)); //each line gives the number of nodes in the layer
    s.add(IntToStr(n2));
    s.add(IntToStr(n3));
    FNN.setlayers(s);
    s.free;
    FNN.Build;
    FindMinMax;
    FIsBuilt:= TRUE;
    FIsTrained:= false;
  except
    Result:= false;
  end;
end;

Function TBHNN.UnBuild : boolean;
begin
  Result:= TRUE;
  try
    FNN.UnBuild;
    FIsBuilt:= false;
    FIsTrained:= false;
  except
    Result:= false;
  end;
end;

Function TBHNN.CheckNumValidData(var nvalid : longint) : boolean;
var i, j, numvalid : longint;
    n, n1, n2, n3 : longint;
    R : TRecipe;
    valid : boolean;
    x, y : double;
begin
  numvalid:= 0;
  for i:= 0 to Brews.NumItems - 1 do
  begin
    R:= TRecipe(Brews.Item[i]);
    if (R <> NIL) and (((R.Equipment <> NIL) and (TLC(R.Equipment.Name.Value) = TLC(FEquipment)))
       or (FEquipment = '')) then
    begin
      Valid:= TRUE;
      for j:= Low(FInputIndexs) to High(FInputIndexs) do
      begin
        x:= R.GetNumberByName(FInputIndexs[j]);
        if x < -999 then valid:= false;
      end;
      Application.ProcessMessages;
      for j:= Low(FOutputIndexs) to High(FOutputIndexs) do
      begin
        y:= R.GetNumberByName(FOutputIndexs[j]);
        if y < -999 then valid:= false;
      end;
      Application.ProcessMessages;
      if valid then Inc(numvalid);
    end;
  end;

//  n:= fann_get_total_connections(FNN.FannObject);
  //calculate amount of connections
  n1:= High(FInputIndexs) + 1;
  n3:= High(FOutputIndexs) + 1;
  n2:= round((n1 + n3) / 2);
  n:= n1 * n2 + n2 * n3;

  //if the number of valid data >= 1.5 * the number of connections, then there
  //is enough data to train the network.
  Result:= (numvalid >= 1.5 * n);
  nvalid:= numvalid;
end;

Function TBHNN.CheckValidData(R : TRecipe) : boolean;
var j : longint;
    x, y : double;
begin
  Result:= TRUE;
  for j:= Low(FInputIndexs) to High(FInputIndexs) do
  begin
    x:= R.GetNumberByName(FInputIndexs[j]);
    if x < -99 then Result:= false;
  end;
  for j:= Low(FOutputIndexs) to High(FOutputIndexs) do
  begin
    y:= R.GetNumberByName(FOutputIndexs[j]);
    if y < -99 then Result:= false;
  end;
end;

{                             afFANN_LINEAR,                      -inf - inf
                              afFANN_THRESHOLD,                   nvt
	                      afFANN_THRESHOLD_SYMMETRIC,         nvt
                              afFANN_SIGMOID,                     0 - 1
                              afFANN_SIGMOID_STEPWISE,            0 - 1
                              afFANN_SIGMOID_SYMMETRIC,          -1 - 1
                              afFANN_SIGMOID_SYMMETRIC_STEPWISE,  -1 - 1
                              afFANN_GAUSSIAN,                    0 - 1
                              afFANN_GAUSSIAN_SYMMETRIC,          -1 - 1
                              afFANN_GAUSSIAN_STEPWISE,
                              afFANN_ELLIOT,                      0 - 1
                              afFANN_ELLIOT_SYMMETRIC,            -1 - 1
                              afFANN_LINEAR_PIECE,                0 - 1
                              afFANN_LINEAR_PIECE_SYMMETRIC,      -1 - 1
                              afFANN_SIN_SYMMETRIC,               -1 - 1
                              afFANN_COS_SYMMETRIC,               -1 - 1
                              afFANN_SIN,                         0 - 1
                              afFANN_COS                         0 - 1}
Function TBHNN.ValueToInput(i : integer; x : double) : double;
begin
  Result:= 0;
  if (i >= 0) and (i <= High(FInMin)) then
  begin
    if (FInMax[i] - FInMin[i] > 0) then
      case FNN.ActivationFunctionHidden of
      afFANN_LINEAR, afFANN_SIGMOID, afFANN_SIGMOID_STEPWISE, afFANN_ELLIOT, afFANN_LINEAR_PIECE,
      afFANN_SIN, afFANN_COS:
        Result:= (x - FInMin[i]) / (FInMax[i] - FInMin[i]);
      afFANN_SIGMOID_SYMMETRIC, afFANN_SIGMOID_SYMMETRIC_STEPWISE,
      afFANN_ELLIOT_SYMMETRIC,afFANN_LINEAR_PIECE_SYMMETRIC, afFANN_SIN_SYMMETRIC,
      afFANN_COS_SYMMETRIC:
        Result:= 2 * (x - FInMin[i]) / (FInMax[i] - FInMin[i]) - 1;
      afFANN_GAUSSIAN_SYMMETRIC, afFANN_GAUSSIAN:
        Result:= x;
      else
        Result:= x
      end
    else
      Result:= 0.5;
  end;
end;

Function TBHNN.ValueToOutput(i : integer; x : double) : double;
begin
  Result:= 0;
  if (i >= 0) and (i <= High(FOutMin)) then
  begin
    if (FOutMax[i] - FOutMin[i] > 0) then
      case FNN.ActivationFunctionHidden of
      afFANN_LINEAR, afFANN_SIGMOID, afFANN_SIGMOID_STEPWISE, afFANN_ELLIOT, afFANN_LINEAR_PIECE,
      afFANN_SIN, afFANN_COS:
        Result:= (x - FOutMin[i]) / (FOutMax[i] - FOutMin[i]);
      afFANN_SIGMOID_SYMMETRIC, afFANN_SIGMOID_SYMMETRIC_STEPWISE,
      afFANN_ELLIOT_SYMMETRIC,afFANN_LINEAR_PIECE_SYMMETRIC, afFANN_SIN_SYMMETRIC,
      afFANN_COS_SYMMETRIC:
        Result:= 2 * (x - FOutMin[i]) / (FOutMax[i] - FOutMin[i]) - 1;
      afFANN_GAUSSIAN_SYMMETRIC, afFANN_GAUSSIAN:
        Result:= x;
      else
        Result:= x;
      end
    else
      Result:= 0.5;
  end;
end;

Function TBHNN.OutputToValue(i : integer; x : double) : double;
begin
  Result:= 0;
  if (i >= 0) and (i <= High(FOutMin)) then
  begin
    if (FOutMax[i] - FOutMin[i] > 0) then
      case FNN.ActivationFunctionHidden of
      afFANN_LINEAR, afFANN_SIGMOID, afFANN_SIGMOID_STEPWISE, afFANN_ELLIOT, afFANN_LINEAR_PIECE,
      afFANN_SIN, afFANN_COS:
        Result:= x * (FOutMax[i] - FOutMin[i]) + FOutMin[i];
      afFANN_SIGMOID_SYMMETRIC, afFANN_SIGMOID_SYMMETRIC_STEPWISE,
      afFANN_ELLIOT_SYMMETRIC,afFANN_LINEAR_PIECE_SYMMETRIC, afFANN_SIN_SYMMETRIC,
      afFANN_COS_SYMMETRIC:
        Result:= (x + 1) / 2 * (FOutMax[i] - FOutMin[i]) + FOutMin[i];
      afFANN_GAUSSIAN_SYMMETRIC, afFANN_GAUSSIAN:
        Result:= x;
      else
        Result:= x;
      end
    else
      Result:= FOutMin[i];
  end;
end;

Function TBHNN.Train(Perc, NumRounds : integer; error : double) : boolean;
var i, j, k, l, numvalid : longint;
    R : TRecipe;
    RA : array of TRecipe;
    Inputs : array of double;
    Outputs : array of double;
    x : double;
    progress, totmse : single;
    tot : longint;
begin
  Result:= false;
  Application.ProcessMessages;
  SetLength(RA, 0);
  try
    if Perc < 50 then Perc:= 50;
    if Perc > 100 then Perc:= 100;
    //train, using Perc% of all brews made in Equipment
    //first, count the amount of brews made in Equipment
    j:= 0;
    for i:= 0 to Brews.NumItems - 1 do
    begin
      R:= TRecipe(Brews.Item[i]);
      if (R <> NIL) and (((R.Equipment <> NIL) and (TLC(R.Equipment.Name.Value) = TLC(FEquipment)))
         or (FEquipment = '')) then
      begin
        //only add brews with valid data
        if CheckValidData(R) then
        begin
          SetLength(RA, High(RA) + 2);
          RA[High(RA)]:= R;
          Inc(j);
        end;
      end;
    end;
    j:= round(perc / 100 * j);

    //create input and output array's
    SetLength(Inputs, High(FInputIndexs) + 1);
    SetLength(Outputs, High(FOutputIndexs) + 1);

    //check if there is enough data to train the network
    if not CheckNumValidData(numvalid) then
      ShowNotification(Application, 'Niet genoeg brouwsels voor dit netwerk')
    else
    begin
      tot:= NumRounds * j;
      k:= 0;
      Fmse:= 1;
      while (k <= NumRounds-1) and (Fmse > error) do
      begin
        totmse:= 0;
        for i:= 0 to j-1 do //j = number of valid brews
        begin
          R:= RA[i];
          for l:= 0 to High(Inputs) do
          begin
            x:= R.GetNumberByName(FInputIndexs[l]);
            x:= ValueToInput(l, x);
            Inputs[l]:= x;
          end;
          for l:= 0 to High(Outputs) do
          begin
            x:= R.GetNumberByName(FOutputIndexs[l]);
            x:= ValueToOutput(l, x);
            Outputs[l]:= x;
          end;
          progress:= 100 * (k * j + i + 1) / tot;
          Fmse:= FNN.Train(Inputs, Outputs);
          totmse:= totmse + Fmse;
          Application.ProcessMessages;
        end;
        Fmse:= totmse / j;
        if Assigned(FOnTrainRound) then
          FOnTrainRound(self, Fmse, progress);
        Application.ProcessMessages;
        Inc(k);
      end;
    end;
  finally
    SetLength(Inputs, 0);
    SetLength(Outputs, 0);
    SetLength(RA, 0);
    Save;
    FIsTrained:= TRUE;
    if Assigned(FOnTrainReady) then FOnTrainReady(self, Fmse);
  end;
end;

Function TBHNN.Run(Inputs : array of double; var Outputs : array of double) : boolean;
var l : longint;
begin
  Result:= false;
  if FIsTrained then
    try
      for l:= 0 to High(Inputs) do
        Inputs[l]:= ValueToInput(l, Inputs[l]);
      FNN.Run(Inputs, Outputs);
      for l:= 0 to High(Outputs) do
        Outputs[l]:= OutputToValue(l, Outputs[l]);
      Result:= TRUE;
    finally
    end;
end;

Function TBHNN.RunFromBrew(R : TRecipe; var Outputs : array of double) : boolean;
var i : longint;
    Inp : array of double;
begin
  Result:= false;
  if (R <> NIL) and ((FEquipment = '') or (TLC(R.Equipment.Name.Value) = TLC(FEquipment))) then
  begin
    SetLength(Inp, High(FInputIndexs) + 1);
    try
      for i:= 0 to High(FInputIndexs) do
        Inp[i]:= R.GetNumberByName(FInputIndexs[i]);
      Result:= Run(Inp, Outputs);
    finally
      SetLength(Inp, 0);
    end;
  end;
end;

Function TBHNN.GetPrediction(R : TRecipe; m : TMemo) : boolean;
var i : Longint;
    outp : array of double;
    s, s2 : string;
begin
  Result:= false;
  if (R <> NIL) and ((FEquipment = '') or (TLC(R.Equipment.Name.Value) = TLC(FEquipment))) then
  begin
    try
      SetLength(outp, High(FoutputIndexs) + 1);
      Result:= RunFromBrew(R, Outp);
      if Result then
      begin
        for i:= 0 to High(FOutputIndexs) do
        begin
          s:= FOutputindexs[i] + ': ';
          s2:= RealToStrDec(Outp[i], R.GetNumberDecimalsByName(FOutputIndexs[i]))
               + ' ' + R.GetNumberDisplayUnitByName(FOutputIndexs[i]);
          m.Lines.Add(s + s2);
        end;
        m.Lines.Add('');
      end;
    finally
      SetLength(outp, 0);
    end;
  end;
end;

{==============================================================================}


Constructor TBHNNs.Create;
begin
  Inherited Create;
  FFileName := 'neuralnetworks.xml';
  ActivationFunctionNames[afFANN_LINEAR]:= 'Lineair';
  ActivationFunctionNames[afFANN_THRESHOLD]:= '';
  ActivationFunctionNames[afFANN_THRESHOLD_SYMMETRIC]:= '';
  ActivationFunctionNames[afFANN_SIGMOID]:= 'Sigmoide';
  ActivationFunctionNames[afFANN_SIGMOID_STEPWISE]:= 'Stapsgewijs sigmoide';
  ActivationFunctionNames[afFANN_SIGMOID_SYMMETRIC]:= 'Sigmoide symmetrisch';
  ActivationFunctionNames[afFANN_SIGMOID_SYMMETRIC_STEPWISE]:= 'Stapsgewijs sigmoide symmetersch';
  ActivationFunctionNames[afFANN_GAUSSIAN]:= 'Gaussiaans';
  ActivationFunctionNames[afFANN_GAUSSIAN_SYMMETRIC]:= 'Symetrisch gaussiaans';
  ActivationFunctionNames[afFANN_GAUSSIAN_STEPWISE]:= 'Stapsgewijs gaussiaans';
  ActivationFunctionNames[afFANN_ELLIOT]:= 'Elliot functie';
  ActivationFunctionNames[afFANN_ELLIOT_SYMMETRIC]:= 'Symetrische Elliot functie';
  ActivationFunctionNames[afFANN_LINEAR_PIECE]:= 'Afgekapt lineair';
  ActivationFunctionNames[afFANN_LINEAR_PIECE_SYMMETRIC]:= 'Afgekapt lineair symmetrisch';
  ActivationFunctionNames[afFANN_SIN_SYMMETRIC]:= 'Sinus symmetrisch';
  ActivationFunctionNames[afFANN_COS_SYMMETRIC]:= 'Cosinus symmetrisch';
  ActivationFunctionNames[afFANN_SIN]:= 'Sinus';
  ActivationFunctionNames[afFANN_COS]:= 'Cosinus';

end;

Destructor TBHNNs.Destroy;
begin
  Clear;
  Inherited Destroy;
end;

Procedure TBHNNs.Clear;
var i : longint;
begin
  for i:= Low(FArrNN) to High(FArrNN) do
    FreeAndNIL(FArrNN[i]);
  SetLength(FArrNN, 0);
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

Procedure TBHNNs.SaveXML;
var
  iRootNode: TDOMNode;
  Doc : TXMLDocument;
  i: integer;
begin
  try
    Doc := TXMLDocument.Create;
  //  Doc.Encoding:= 'ISO-8859-1';
    iRootNode := Doc.CreateElement('NNS');
    Doc.Appendchild(iRootNode);

    for i:= Low(FArrNN) to High(FArrNN) do
      FArrNN[i].SaveXML(Doc, iRootNode);

    writeXMLFile(Doc, Settings.DataLocation.Value + FFileName);
  finally
    FreeAndNil(doc);
  end;
end;

Procedure TBHNNs.ReadXML;
var
  iRootNode, iChild: TDOMNode;
  Doc : TXMLDocument;
  i: integer;
  iBHNN : TBHNN;
begin
  Clear;
  iRootNode:= NIL;
  try
    if FileExists(Settings.DataLocation.Value + FFileName) then
    begin
      ReadXMLFile(Doc, Settings.DataLocation.Value + FFileName);
      Clear;
      iRootNode:= Doc.FindNode('NNS');
      if iRootNode <> NIL then
      begin
        i:= 0;
        iChild:= iRootNode.FirstChild;
        while iChild <> NIL do
        begin
          inc(i);
          iBHNN:= AddBHNN;
          iBHNN.ReadXML(iChild);
          iChild:= iChild.NextSibling;
        end;
      end;
    end;
  except
    Doc.Free;
  end;
end;

Function TBHNNs.GetBHNN(i : longint) : TBHNN;
begin
  Result:= NIL;
  if (i >= Low(FArrNN)) and (i <= High(FArrNN)) then
    Result:= FArrNN[i];
end;

Function TBHNNs.AddBHNN : TBHNN;
var i, n : longint;
begin
  Result:= NIL;
  try
    n:= -1;
    for i:= 0 to High(FArrNN) do
      if FArrNN[i].AutoNr > n then
        n:= FArrNN[i].AutoNr;
    inc(n);
    SetLength(FArrNN, High(FArrNN) + 2);
    FArrNN[High(FArrNN)]:= TBHNN.Create;
    FArrNN[High(FArrNN)].AutoNr:= n;
    Result:= FArrNN[High(FArrNN)];
  finally
  end;
end;

Procedure TBHNNs.RemoveBHNN(i : longint);
var j : integer;
begin
  if (i >= Low(FArrNN)) and (i <= High(FArrNN)) then
  begin
    FArrNN[i].Remove;
    FreeAndNIL(FArrNN[i]);
    for j:= i to High(FArrNN) - 1 do
      FArrNN[i]:= FArrNN[i+1];
    SetLength(FArrNN, High(FArrNN));
  end;
end;

Procedure TBHNNs.RemoveByReference(NN : TBHNN);
var i : integer;
begin
  for i:= Low(FArrNN) to High(FArrNN) do
    if FArrNN[i] = NN then
    begin
      RemoveBHNN(i);
      Exit;
    end;
end;

Function TBHNNs.GetCount : longint;
begin
  Result:= High(FArrNN) + 1;
end;

Procedure TBHNNs.GetPrediction(R : TRecipe; m : TMemo);
var i, n : integer;
    s, se : string;
begin
  se:= '';
  if (R <> NIL) and (R.Equipment <> NIL) then se:= R.Equipment.Name.Value;
  if se = '' then se:= 'Alle';
  //look for 'all equipments' networks first
  n:= 0;
  for i:= Low(FArrNN) to High(FArrNN) do
    if ((FArrNN[i].Equipment = '') or (TLC(FArrNN[i].Equipment) = 'alle'))
      and FArrNN[i].IsTrained then
      Inc(n);
  if n > 0 then
  begin
    s:= 'Alle';
    m.Lines.Add(s);
    for i:= Low(FArrNN) to High(FArrNN) do
      if ((FArrNN[i].Equipment = '') or (TLC(FArrNN[i].Equipment) = 'alle'))
        and FArrNN[i].IsTrained then
        FArrNN[i].GetPrediction(R, m);
  end;

  //look for 'all equipments' networks first
  n:= 0;
  for i:= Low(FArrNN) to High(FArrNN) do
    if (TLC(FArrNN[i].Equipment) = TLC(se)) and (se <> 'Alle') and
        FArrNN[i].IsTrained then
      Inc(n);
  if n > 0 then
  begin
    m.Lines.Add(se);
    for i:= Low(FArrNN) to High(FArrNN) do
      if (TLC(FArrNN[i].Equipment) = TLC(se)) and (se <> 'Alle') and
          FArrNN[i].IsTrained then
        FArrNN[i].GetPrediction(R, m);
  end;
end;

end.

