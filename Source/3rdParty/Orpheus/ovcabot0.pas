{*********************************************************}
{*                    OVCABOT0.PAS 4.06                  *}
{*********************************************************}

{* ***** BEGIN LICENSE BLOCK *****                                            *}
{* Version: MPL 1.1                                                           *}
{*                                                                            *}
{* The contents of this file are subject to the Mozilla Public License        *}
{* Version 1.1 (the "License"); you may not use this file except in           *}
{* compliance with the License. You may obtain a copy of the License at       *}
{* http://www.mozilla.org/MPL/                                                *}
{*                                                                            *}
{* Software distributed under the License is distributed on an "AS IS" basis, *}
{* WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License   *}
{* for the specific language governing rights and limitations under the       *}
{* License.                                                                   *}
{*                                                                            *}
{* The Original Code is TurboPower Orpheus                                    *}
{*                                                                            *}
{* The Initial Developer of the Original Code is TurboPower Software          *}
{*                                                                            *}
{* Portions created by TurboPower Software Inc. are Copyright (C)1995-2002    *}
{* TurboPower Software Inc. All Rights Reserved.                              *}
{*                                                                            *}
{* Contributor(s):                                                            *}
{*                                                                            *}
{* ***** END LICENSE BLOCK *****                                              *}

{$I OVC.INC}

{$B-} {Complete Boolean Evaluation}
{$I+} {Input/Output-Checking}
{$P+} {Open Parameters}
{$T-} {Typed @ Operator}
{.W-} {Windows Stack Frame}
{$X+} {Extended Syntax}

unit Ovcabot0;

interface

uses
  {$IFNDEF LCL} Windows, Messages, {$ELSE} LclIntf, LMessages, LclType, LResources, MyMisc, Buttons, {$ENDIF}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  {$IFNDEF LCL} {$IFDEF VERSION6} DesignIntf, DesignEditors, {$ELSE} DsgnIntf, {$ENDIF} {$ELSE} PropEdits, {$ENDIF}
  ExtCtrls, OvcVer, OvcURL, {$IFDEF MSWINDOWS} ShellAPI; {$ELSE} Unix; {$ENDIF}

type
  TOvcfrmAboutForm = class(TForm)
    Panel1: TPanel;
    Image1: TImage;
    btnOK: TButton;
    Label1: TLabel;
    VisitUsLabel: TLabel;
    lblTurboLink: TLabel;
    Bevel3: TBevel;
    GeneralNewsgroupsLabel: TLabel;
    lblHelp: TLabel;
    lblGeneralDiscussion: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lblTurboLinkClick(Sender: TObject);
    procedure lblHelpClick(Sender: TObject);
    procedure lblGeneralDiscussionClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TOvcAboutProperty = class(TStringProperty)
  public
    function GetAttributes: TPropertyAttributes;
      override;
    procedure Edit;
      override;
  end;

implementation
{$IFNDEF LCL}
{$R *.DFM}
{$ENDIF}


{*** TOrAboutProperty ***}

function TOvcAboutProperty.GetAttributes: TPropertyAttributes;
begin
  Result := [paDialog, paReadOnly];
end;

procedure TOvcAboutProperty.Edit;
begin
  with TOvcfrmAboutForm.Create(Application) do begin
    try
      ShowModal;
    finally
      Free;
    end;
  end;
end;

{*** TEsAboutForm ***}

procedure TOvcfrmAboutForm.btnOKClick(Sender: TObject);
begin
  Close;
end;

procedure TOvcfrmAboutForm.FormCreate(Sender: TObject);
begin
  Top := (Screen.Height - Height) div 3;
  Left := (Screen.Width - Width) div 2;

  lblTurboLink.Cursor := crHandPoint;
  lblHelp.Cursor := crHandPoint;
  lblGeneralDiscussion.Cursor := crHandPoint;

{$IFDEF LCL}
  Image1.Transparent := False;  //Default is True with Laz, False with Delphi
{$ENDIF}
end;

procedure TOvcfrmAboutForm.lblTurboLinkClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
 {$IFNDEF LCL}
  if ShellExecute(0, 'open', 'http://sourceforge.net/projects/tporpheus/',
 {$ELSE}
  if ShellExecute(0, 'open', PChar('http://sourceforge.net/projects/tporpheus/'),
 {$ENDIF}
    '', '', SW_SHOWNORMAL) <= 32
{$ELSE}
 {$IFDEF DARWIN}
  if fpSystem('Open http://sourceforge.net/projects/tporpheus/') = 127
 {$ELSE}
  if (GetBrowserPath = '') or
     (fpSystem(GetBrowserPath + ' http://sourceforge.net/projects/tporpheus/') = 127)
 {$ENDIF}
{$ENDIF}
  then
    ShowMessage('Error launching browser.');
end;

procedure TOvcfrmAboutForm.lblHelpClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  if ShellExecute(0, 'open',
 {$IFNDEF LCL}
  'http://sourceforge.net/forum/forum.php?forum_id=241874', '', '',
 {$ELSE}
  PChar('http://sourceforge.net/forum/forum.php?forum_id=241874'), '', '',
 {$ENDIF}
  SW_SHOWNORMAL) <= 32
{$ELSE}
 {$IFDEF DARWIN}
  if fpSystem('Open http://sourceforge.net/forum/forum.php?forum_id=241874') = 127 
 {$ELSE}
  if (GetBrowserPath = '') or
     (fpSystem(GetBrowserPath + ' http://sourceforge.net/forum/forum.php?forum_id=241874') = 127) 
 {$ENDIF}
{$ENDIF}
  then
    ShowMessage('Error launching browser.');
end;

procedure TOvcfrmAboutForm.lblGeneralDiscussionClick(Sender: TObject);
begin
{$IFDEF MSWINDOWS}
  if ShellExecute(0, 'open',
 {$IFNDEF LCL}
  'http://sourceforge.net/forum/forum.php?forum_id=241873', '', '',
 {$ELSE}
  PChar('http://sourceforge.net/forum/forum.php?forum_id=241873'), '', '',
 {$ENDIF}
  SW_SHOWNORMAL) <= 32
{$ELSE}
 {$IFDEF DARWIN}
  if fpSystem('Open http://sourceforge.net/forum/forum.php?forum_id=241873') = 127 
 {$ELSE}
  if (GetBrowserPath = '') or
     (fpSystem(GetBrowserPath + ' http://sourceforge.net/forum/forum.php?forum_id=241873') = 127) 
 {$ENDIF}
{$ENDIF}
  then
    ShowMessage('Error launching browser.');
end;

initialization
{$IFDEF LCL}
{$I Ovcabot0.lrs}  {Include form's resource file}
{$ENDIF}

end.

