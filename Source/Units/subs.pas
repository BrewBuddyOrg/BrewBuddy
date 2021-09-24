unit subs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, data;

type
  TSubRecord = record
    Original : TBString;
    Original2 : TBString;
    Substitute : TBString;
    Substitute2 : TBString;
  end;

  TSubstitutions = class(TObject)
    private
      FFileName : string;
      FSubs : array of TSubRecord;
      Procedure SortByOriginal;
      Procedure SortBySubstitute;
      Function LocateSubstitute(s : string) : longint;
      Function LocateOriginal(s : string) : longint;
      Procedure Clear; virtual;
      Function GetNumItems : longint;
    protected
    public
      Constructor Create; virtual;
      Destructor Destroy; override;
      Function SaveXML : boolean; virtual;
      Function ReadXML : boolean; virtual;
      Function FindSubstitute(o : string) : string;
      Function FindOriginal(s : string) : string;
      Function OriginalExists(o : string) : boolean;
      Function SubstituteExists(s : string) : boolean;
      Procedure RemoveOriginal(s : string);
      Procedure Add(o, s : string);
    published
      property FileName : string read FFileName write FFileName;
      property NumItems : longint read GetNumItems;
  end;

  TFermSubstitutions = class(TSubstitutions)
    private
      Function LocateSubstitute2(s, s2 : string) : longint;
      Function LocateOriginal2(s, s2 : string) : longint;
      Procedure Clear; override;
    protected
    public
      Constructor Create; override;
      Destructor Destroy; override;
      Function SaveXML : boolean; override;
      Function ReadXML : boolean; override;
      Procedure FindSubstitute(o, o2 : string; var s, s2 : string);
      Procedure FindOriginal(s, s2 : string; var o, o2 : string);
      Function OriginalExists(o, o2 : string) : boolean;
      Function SubstituteExists(s, s2 : string) : boolean;
      Procedure RemoveOriginal(s, s2 : string);
      Procedure Add(o, o2, s, s2 : string);
    published
   end;

var StyleSubs : TSubstitutions;
    FermentableSubs, YeastSubs : TFermSubstitutions;

implementation

uses DOM, XMLRead, XMLWrite, XMLUtils, hulpfuncties;

Constructor TSubstitutions.Create;
begin
  Inherited Create;
  FFileName:= '';
end;

Destructor TSubstitutions.Destroy;
begin
  Clear;
  Inherited Destroy;
end;

Function TSubstitutions.SaveXML : boolean;
var FN : string;
    RootNode, iChild : TDOMNode;
    Doc : TXMLDocument;
    i : longint;
begin
  Result:= True;
  if NumItems > 0 then
  begin
    try
      Doc := TXMLDocument.Create;
    //  FDoc.Encoding:= 'ISO-8859-1';
      RootNode := Doc.CreateElement('SUBS');
      Doc.AppendChild(RootNode);
      FN:= Settings.DataLocation.Value + FFileName;
      for i:= Low(FSubs) to High(FSubs) do
      begin
        iChild := Doc.CreateElement('SUB');
        RootNode.AppendChild(iChild);

        FSubs[i].Original.SaveXML(Doc, iChild, false);
        FSubs[i].Substitute.SaveXML(Doc, iChild, false);
      end;
      writeXMLFile(Doc, FN);
     finally
      Doc.Free;
    end;
  end;
end;

Function TSubstitutions.ReadXML : boolean;
var FN : string;
    i : longint;
    RootNode, Child : TDOMNode;
    Doc : TXMLDocument;
begin
  Result:= True;
  RootNode:= NIL;
  Doc:= NIL;
  try
    FN:= Settings.DataLocation.Value + FFileName;
    if FileExists(FN) then
    begin
      ReadXMLFile(Doc, FN);
      Clear;
      RootNode:= Doc.FindNode('SUBS');
      if RootNode <> NIL then
      begin
        i:= 0;
        Child:= RootNode.FirstChild;
        while Child <> NIL do
        begin
          inc(i);
          SetLength(FSubs, i);
          FSubs[i-1].Original:= TBString.Create(NIL);
          FSubs[i-1].Original.NodeLabel:= 'ORIGINAL';
          FSubs[i-1].Substitute:= TBString.Create(NIL);
          FSubs[i-1].Substitute.NodeLabel:= 'SUBSTITUTE';
          FSubs[i-1].Original.ReadXML(Child);
          FSubs[i-1].Substitute.ReadXML(Child);
          Child:= Child.NextSibling;
        end;
      end;
    end;
  finally
    if Doc <> NIL then Doc.Free;
  end;
end;

Function TSubstitutions.LocateSubstitute(s : string) : longint;
var first: Longint;
    last: Longint;
    middle: Longint;
    st : string;
begin
  SortByOriginal;
  first:= Low(FSubs);
  last:= High(FSubs);
  s:= LowerCase(s);

  // assume searches failed
  Result:= -1;
  if (FSubs <> NIL) and (High(FSubs) > -1) then
    Repeat
      middle:= roundup((first + last) / 2);
      st:= FSubs[middle].Substitute.Value;
      if (st = s) then
      begin
        Result:= middle;
        exit;
      end
      else if (st < s) then
        first:= middle + 1
      else
        last:= middle - 1;
    until first > last;
end;

Function TSubstitutions.LocateOriginal(s : string) : longint;
var first: Longint;
    last: Longint;
    middle: Longint;
    st : string;
begin
  SortBySubstitute;
  first:= Low(FSubs);
  last:= High(FSubs);
  s:= LowerCase(s);

  // assume searches failed
  Result:= -1;
  if (FSubs <> NIL) and (High(FSubs) > -1) then
    Repeat
      middle:= roundup((first + last) / 2);
      if middle > High(FSubs) then middle:= High(FSubs);
      st:= FSubs[middle].Original.Value;
      if (st = s) then
      begin
        Result:= middle;
        exit;
      end
      else if (st < s) then
        first:= middle + 1
      else
        last:= middle - 1;
    until first > last;
end;

Function TSubstitutions.FindSubstitute(o : string) : string;
var i: Longint;
begin
  Result:= '';
  i:= LocateOriginal(o);
  if i > -1 then
    Result:= FSubs[i].Substitute.Value;
end;

Function TSubstitutions.FindOriginal(s : string) : string;
var i: Longint;
begin
  Result:= '';
  i:= LocateSubstitute(s);
  if i > -1 then
    Result:= FSubs[i].Original.Value;
end;

Procedure TSubstitutions.Add(o, s : string);
var i : longint;
begin
  i:= High(FSubs);
  SetLength(FSubs, i + 2);
  Inc(i);
  FSubs[i].Original:= TBString.Create(NIL);
  FSubs[i].Original.Value:= LowerCase(o);
  FSubs[i].Original.NodeLabel:= 'ORIGINAL';
  FSubs[i].Substitute:= TBString.Create(NIL);
  FSubs[i].Substitute.Value:= LowerCase(s);
  FSubs[i].Substitute.NodeLabel:= 'SUBSTITUTE';
end;

Procedure TSubstitutions.SortByOriginal;
  procedure QuickSort(var A: array of TSubRecord; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : string;
      TB : TSubRecord;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].Original.Value;
    repeat
      while A[Lo].Original.Value < v do Inc(Lo);
      while A[Hi].Original.Value > v do Dec(Hi);
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
begin
  if High(FSubs) > 1 then
    QuickSort(FSubs, Low(FSubs), High(FSubs));
end;

Procedure TSubstitutions.SortBySubstitute;
  procedure QuickSort(var A: array of TSubRecord; iLo, iHi: Integer);
  var Lo, Hi: Integer;
      v : string;
      TB : TSubRecord;
  begin
    Lo := iLo;
    Hi := iHi;
    v:= A[(Lo + Hi) div 2].Substitute.Value;
    repeat
      while A[Lo].Substitute.Value < v do Inc(Lo);
      while A[Hi].Substitute.Value > v do Dec(Hi);
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
begin
  if High(FSubs) > 1 then
    QuickSort(FSubs, Low(FSubs), High(FSubs));
end;

Function TSubstitutions.OriginalExists(o : string) : boolean;
begin
  Result:= (LocateOriginal(o) > -1);
end;

Function TSubstitutions.SubstituteExists(s : string) : boolean;
begin
  Result:= (LocateSubstitute(s) > -1);
end;

Procedure TSubstitutions.Clear;
var i : longint;
begin
  for i:= Low(FSubs) to High(FSubs) do
  begin
    FSubs[i].Original.Free;
    FSubs[i].Substitute.Free;
  end;
  SetLength(FSubs, 0);
end;

Procedure TSubstitutions.RemoveOriginal(s : string);
var i, j : longint;
begin
  i:= LocateOriginal(s);
  if i > -1 then
  begin
    FSubs[i].Original.Free;
    FSubs[i].Substitute.Free;
    for j:= i to High(FSubs) - 1 do
      FSubs[j]:= FSubs[j+1];
    SetLength(FSubs, High(FSubs));
  end;
end;

Function TSubstitutions.GetNumItems : longint;
begin
  Result:= High(FSubs) + 1;
end;


Constructor TFermSubstitutions.Create;
begin
  Inherited Create;
end;

Destructor TFermSubstitutions.Destroy;
begin
  Inherited Destroy;
end;

Function TFermSubstitutions.SaveXML : boolean;
var FN : string;
    RootNode, iChild : TDOMNode;
    Doc : TXMLDocument;
    i : longint;
begin
  Result:= True;
  if NumItems > 0 then
  begin
    try
      Doc := TXMLDocument.Create;
    //  FDoc.Encoding:= 'ISO-8859-1';
      RootNode := Doc.CreateElement('SUBS');
      Doc.AppendChild(RootNode);
      FN:= Settings.DataLocation.Value + FFileName;
      for i:= Low(FSubs) to High(FSubs) do
      begin
        iChild := Doc.CreateElement('SUB');
        RootNode.AppendChild(iChild);

        FSubs[i].Original.SaveXML(Doc, iChild, false);
        FSubs[i].Original2.SaveXML(Doc, iChild, false);
        FSubs[i].Substitute.SaveXML(Doc, iChild, false);
        FSubs[i].Substitute2.SaveXML(Doc, iChild, false);
      end;
      writeXMLFile(Doc, FN);
     finally
      Doc.Free;
    end;
  end;
end;

Function TFermSubstitutions.ReadXML : boolean;
var FN : string;
    i : longint;
    RootNode, Child : TDOMNode;
    Doc : TXMLDocument;
begin
  Result:= True;
  RootNode:= NIL;
  Doc:= NIL;
  try
    FN:= Settings.DataLocation.Value + FFileName;
    if FileExists(FN) then
    begin
      ReadXMLFile(Doc, FN);
      Clear;
      RootNode:= Doc.FindNode('SUBS');
      if RootNode <> NIL then
      begin
        i:= 0;
        Child:= RootNode.FirstChild;
        while Child <> NIL do
        begin
          inc(i);
          SetLength(FSubs, i);
          FSubs[i-1].Original:= TBString.Create(NIL);
          FSubs[i-1].Original.NodeLabel:= 'ORIGINAL';
          FSubs[i-1].Original2:= TBString.Create(NIL);
          FSubs[i-1].Original2.NodeLabel:= 'ORIGINAL_2';
          FSubs[i-1].Substitute:= TBString.Create(NIL);
          FSubs[i-1].Substitute.NodeLabel:= 'SUBSTITUTE';
          FSubs[i-1].Substitute2:= TBString.Create(NIL);
          FSubs[i-1].Substitute2.NodeLabel:= 'SUBSTITUTE_2';
          FSubs[i-1].Original.ReadXML(Child);
          FSubs[i-1].Original2.ReadXML(Child);
          FSubs[i-1].Substitute.ReadXML(Child);
          FSubs[i-1].Substitute2.ReadXML(Child);
          Child:= Child.NextSibling;
        end;
      end;
    end;
  finally
    if Doc <> NIL then Doc.Free;
  end;
end;

Procedure TFermSubstitutions.FindSubstitute(o, o2 : string; var s, s2 : string);
var i : longint;
begin
  s:= ''; s2:= '';
  o:= LowerCase(o);
  o2:= LowerCase(o2);
  for i:= Low(FSubs) to High(FSubs) do
  begin
    if (FSubs[i].Original.Value = o) and (FSubs[i].Original2.Value = o2) then
    begin
      s:= FSubs[i].Substitute.Value;
      s2:= FSubs[i].Substitute2.Value;
      Exit;
    end;
  end;
end;

Procedure TFermSubstitutions.FindOriginal(s, s2 : string; var o, o2 : string);
var i : longint;
begin
  o:= ''; o2:= '';
  s:= LowerCase(s);
  s2:= LowerCase(s2);
  for i:= Low(FSubs) to High(FSubs) do
  begin
    if (FSubs[i].Substitute.Value = s) and (FSubs[i].Substitute2.Value = s2) then
    begin
      o:= FSubs[i].Original.Value;
      o2:= FSubs[i].Original2.Value;
      Exit;
    end;
  end;
end;

Function TFermSubstitutions.OriginalExists(o, o2 : string) : boolean;
var i : longint;
begin
  Result:= false;
  o:= LowerCase(o);
  o2:= LowerCase(o2);
  for i:= Low(FSubs) to High(FSubs) do
  begin
    if (FSubs[i].Original.Value = o) and (FSubs[i].Original2.Value = o2) then
    begin
      Result:= TRUE;
      Exit;
    end;
  end;
end;

Function TFermSubstitutions.SubstituteExists(s, s2 : string) : boolean;
var i : longint;
begin
  Result:= false;
  s:= LowerCase(s);
  s2:= LowerCase(s2);
  for i:= Low(FSubs) to High(FSubs) do
  begin
    if (FSubs[i].Substitute.Value = s) and (FSubs[i].Substitute2.Value = s2) then
    begin
      Result:= TRUE;
      Exit;
    end;
  end;
end;

Procedure TFermSubstitutions.RemoveOriginal(s, s2 : string);
var i, j : longint;
begin
  i:= LocateOriginal2(s, s2);
  if i > -1 then
  begin
    FSubs[i].Original.Free;
    FSubs[i].Original2.Free;
    FSubs[i].Substitute.Free;
    FSubs[i].Substitute2.Free;
    for j:= i to High(FSubs) - 1 do
      FSubs[j]:= FSubs[j+1];
    SetLength(FSubs, High(FSubs));
  end;
end;

Procedure TFermSubstitutions.Add(o, o2, s, s2 : string);
var i : longint;
begin
  i:= High(FSubs);
  SetLength(FSubs, i + 2);
  Inc(i);
  FSubs[i].Original:= TBString.Create(NIL);
  FSubs[i].Original.Value:= LowerCase(o);
  FSubs[i].Original.NodeLabel:= 'ORIGINAL';
  FSubs[i].Original2:= TBString.Create(NIL);
  FSubs[i].Original2.Value:= LowerCase(o2);
  FSubs[i].Original2.NodeLabel:= 'ORIGINAL_2';
  FSubs[i].Substitute:= TBString.Create(NIL);
  FSubs[i].Substitute.Value:= LowerCase(s);
  FSubs[i].Substitute.NodeLabel:= 'SUBSTITUTE';
  FSubs[i].Substitute2:= TBString.Create(NIL);
  FSubs[i].Substitute2.Value:= LowerCase(s2);
  FSubs[i].Substitute2.NodeLabel:= 'SUBSTITUTE_2';
end;

Function TFermSubstitutions.LocateSubstitute2(s, s2 : string) : longint;
var i : longint;
begin
  Result:= -1;
  for i:= Low(FSubs) to High(FSubs) do
    if (LowerCase(s) = FSubs[i].Substitute.Value) and (LowerCase(s2) = FSubs[i].Substitute2.Value) then
    begin
      Result:= i;
      Exit;
    end;
end;

Function TFermSubstitutions.LocateOriginal2(s, s2 : string) : longint;
var i : longint;
begin
  Result:= -1;
  for i:= Low(FSubs) to High(FSubs) do
    if (LowerCase(s) = FSubs[i].Original.Value) and (LowerCase(s2) = FSubs[i].Original2.Value) then
    begin
      Result:= i;
      Exit;
    end;
end;

Procedure TFermSubstitutions.Clear;
var i : longint;
begin
  for i:= Low(FSubs) to High(FSubs) do
  begin
    FSubs[i].Original.Free;
    FSubs[i].Substitute.Free;
    FSubs[i].Original2.Free;
    FSubs[i].Substitute2.Free;
  end;
  SetLength(FSubs, 0);
end;

Initialization
  StyleSubs:= TSubstitutions.Create;
  StyleSubs.FileName:= 'stylesubs.xml';
  FermentableSubs:= TFermSubstitutions.Create;
  FermentableSubs.FileName:= 'fermentablesubs.xml';
  YeastSubs:= TFermSubstitutions.Create;
  YeastSubs.FileName:= 'yeastsubs.xml';

Finalization
  StyleSubs.Free;
  FermentableSubs.Free;
  YeastSubs.Free;
end.

