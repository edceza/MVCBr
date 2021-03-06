unit eMVC.FileCreator;
{ ********************************************************************** }
{ Copyright 2005 Reserved by Eazisoft.com }
{ File Name: FileCreator.pas }
{ Author: Larry Le }
{ Description: Implements the IOTAFile for TViewCreator, TModelCreator, }
{ and the TControllerCreator }
{ }
{ History: }
{ - 1.0, 19 May 2006 }
{ First version }
{ }
{ Email: linfengle@gmail.com }
{ }
{ The contents of this file are subject to the Mozilla Public License }
{ Version 1.1 (the "License"); you may not use this file except in }
{ compliance with the License. You may obtain a copy of the License at }
{ http://www.mozilla.org/MPL/ }
{ }
{ Software distributed under the License is distributed on an "AS IS" }
{ basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See }
{ the License for the specific language governing rights and }
{ limitations under the License. }
{ }
{ The Original Code is written in Delphi. }
{ }
{ The Initial Developer of the Original Code is Larry Le. }
{ Copyright (C) eazisoft.com. All Rights Reserved. }
{ }
{ ********************************************************************** }

interface

uses
  Windows, Classes, SysUtils, ToolsApi, eMVC.Toolbox;

const
  cNORMAL = 0;
  cVIEW = 1;
  cMODEL = 2;
  cCONTROLLER = 3;
  cPROJECT = 4;
  cCLASS = 5;
  CVIEWMODEL = 6;
  cPersistentMODEL = 7;
  cModelInterf = 8;
  cProjectGroup = 9;
  cInclude = 10;
  cDataModule = 11;

{$I .\inc\project.inc}
{$I .\inc\viewcode.inc}
{$I .\inc\modelcode.inc}
{$I .\inc\controllercode.inc}
{$I .\inc\classcode.inc}
{$I .\inc\viewmodel.inc}
{$I .\inc\persistentmodel.inc}
{$I .\inc\datamodule.inc}

type

  TBaseProjectType = (bptVCL, bptFMX, bptPrompt);

  TFileCreator = class(TInterfacedObject, IOTAFile)
  private
    FBaseProjectType: TBaseProjectType;
    procedure SetBaseProjectType(const Value: TBaseProjectType);
  protected
    FAge: TDateTime;
    FCreateType: smallint;
    FModelIdent: string;
    FFormIdent: string;
    FAncestorIdent: string;
    FCreateModel, FCreateView: boolean;
    FModelAlone, FViewAlone: boolean;
    FViewIsForm: boolean;
    FViewModel: boolean;
    FTemplates: TStringList;
    FIsFMX: boolean;
    procedure SetTemplates(const Value: TStringList);
    procedure SetisFMX(const Value: boolean);
  public
    FFuncSource: TFunc<string>;
    constructor Create(const ModelIdent, FormIdent, AncestorIdent: string;
      ACreateType: smallint = cNORMAL; ACreateModel: boolean = false;
      ACreateView: boolean = false; AModelAlone: boolean = true;
      AViewAlone: boolean = true; ViewIsForm: boolean = true;
      AViewModel: boolean = true; AIsFMX: boolean = false); overload;
    class function New(const ModelIdent, FormIdent, AncestorIdent: string;
      AFuncSource: TFunc<string>): TFileCreator; overload;

    destructor destroy; override;
    function GetSource: string;
    function GetAge: TDateTime;
    property Templates: TStringList read FTemplates write SetTemplates;
    property BaseProjectType: TBaseProjectType read FBaseProjectType
      write SetBaseProjectType;
  end;

implementation

uses eMVC.OTAUtilities;
{ TFileCreator }

constructor TFileCreator.Create(const ModelIdent, FormIdent,
  AncestorIdent: string; ACreateType: smallint = cNORMAL;
  ACreateModel: boolean = false; ACreateView: boolean = false;
  AModelAlone: boolean = true; AViewAlone: boolean = true;
  ViewIsForm: boolean = true; AViewModel: boolean = true;
  AIsFMX: boolean = false);
begin
  self.FCreateType := ACreateType;
  FTemplates := TStringList.Create;
  FAge := -1; // Flag age as New File
  FTemplates.Values['%UnitIdent'] := ModelIdent; // sem remove os pontos
  FModelIdent := (ModelIdent); // remove os pontos;
  FFormIdent := (FormIdent);
  FAncestorIdent := (AncestorIdent);
  FCreateModel := ACreateModel;
  FCreateView := ACreateView;
  FModelAlone := AModelAlone;
  FViewAlone := AViewAlone;
  FViewIsForm := ViewIsForm;
  FViewModel := AViewModel;
  FIsFMX := AIsFMX;
  Debug('Modulo: ' + ModelIdent);
end;

class function TFileCreator.New(const ModelIdent, FormIdent,
  AncestorIdent: string; AFuncSource: TFunc<string>): TFileCreator;
begin
  result := TFileCreator.Create(ModelIdent, FormIdent, AncestorIdent);
  result.FFuncSource := AFuncSource;
end;

destructor TFileCreator.destroy;
begin
  FTemplates.Free;
  inherited;
end;

function TFileCreator.GetAge: TDateTime;
begin
  result := FAge;
end;

function TFileCreator.GetSource: string;
var
  i: integer;
  c: integer;
  str: TStringList;
begin
  case BaseProjectType of
    bptVCL: Debug('bptVCL');
    bptFMX: Debug('bptFMX');
    bptPrompt: Debug('bptPROMPT');
  end;

  if Assigned(FFuncSource) then
    result := FFuncSource
  else
    case self.FCreateType of
      cNORMAL:
        result := classCode;
      cVIEW:
        begin
          result := ViewCode;
          if not FCreateModel then
            result := ViewCodeNoViewModel;

          if FIsFMX then
            result := stringReplace(result, '*.DFM', '*.FMX', []);

          if SameText(FAncestorIdent, dataModuleAncestorName) then
          begin
            result := dataModuleCode;
          end;
        end;
      cCLASS:
        result := ViewCode2;
      cMODEL:
        if BaseProjectType = bptFMX then
          result := ModelCodeFMX
        else
          result := ModelCode;
      cModelInterf:
        begin
          result := ModelInterf;
          if SameText(FAncestorIdent, 'viewmodel') then
            result := viewmodecodeInterf;
          if SameText(FAncestorIdent, 'PersistentModel') then
            result := ModelCodeBaseInterf;
          if SameText(FAncestorIdent, dataModuleAncestorName) then
            result := dataModuleCodeInterf;
          if SameText(FAncestorIdent, 'Controller') then
            result := ControllerCodeInterf;
        end;
      CVIEWMODEL:
        begin
          result := viewmodecode;
          if FViewModel then
            result := stringReplace(result, '%ViewModelInit', '',
              [rfReplaceAll, rfIgnoreCase]);
        end;
      cPersistentMODEL:
        begin
          result := ModelCodeBase;
        end;
      cCONTROLLER:
        begin
          if BaseProjectType = bptPrompt then
            result := PromptControllerCode
          else if (not self.FCreateModel) and (not self.FCreateView) then
            result := ControllerCodeOnly
          else if (self.FCreateModel) and (not self.FCreateView) then
            result := ControllerCodeWithoutView
          else if (not self.FCreateModel) and (self.FCreateView) then
            result := ControllerCodeWithoutViewModel
          else
          begin
            if (not FModelAlone and not FViewAlone) then
              result := ControllerCode2
            else if (not self.FModelAlone and self.FViewAlone) then
              result := ControllerCodeWithoutViewModel
            else if (self.FModelAlone and not self.FViewAlone) then
              result := ControllerCodeWithoutView
            else
              result := ControllerCode;
          end;

        end;
      cPROJECT:
        case BaseProjectType of
          bptVCL: result := ProjectCode;
          bptFMX: result := ProjectCodeFMX;
          bptPrompt: result := promptProject;
        end;
    end;

  result := ClassHeader + #10#13 + result;

  // usa os templates - Primeira passada;
  for i := 0 to FTemplates.Count - 1 do
  begin
    result := stringReplace(result, FTemplates.Names[i],
      FTemplates.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
  end;

  if self.FCreateModel and not self.FModelAlone then
  begin
    result := stringReplace(result, '%ModelDef', (ModelDef),
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%ModelImpl', (ModelImpl),
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    result := stringReplace(result, '%ModelDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%ModelImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if self.FCreateView and not self.FViewAlone then
  begin
    result := stringReplace(result, '%ViewDef', (ViewDef),
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%ViewImpl', (ViewImpl),
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    result := stringReplace(result, '%ViewDef', '',
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%ViewImpl', '',
      [rfReplaceAll, rfIgnoreCase]);
  end;

  // Parameterize the code with the current Identifiers
  if FViewIsForm then
  begin
    result := stringReplace(result, '%ViewCreation', FormViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%FreeView', '',
      [rfReplaceAll, rfIgnoreCase]);
  end
  else
  begin
    result := stringReplace(result, '%ViewCreation', NormalViewCreate,
      [rfReplaceAll, rfIgnoreCase]);
    result := stringReplace(result, '%FreeView', NormalViewDestory,
      [rfReplaceAll, rfIgnoreCase]);
  end;

  if FModelIdent <> '' then
    result := stringReplace(result, '%ModelIdent', FModelIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FFormIdent <> '' then
    result := stringReplace(result, '%FormIdent', FFormIdent,
      [rfReplaceAll, rfIgnoreCase]);
  if FAncestorIdent <> '' then
    result := stringReplace(result, '%AncestorIdent', FAncestorIdent,
      [rfReplaceAll, rfIgnoreCase]);

  result := stringReplace(result, '%guid2', GuidToString(TGuid.NewGuid),
    [rfReplaceAll, rfIgnoreCase]);

  result := stringReplace(result, '%guid1', GuidToString(TGuid.NewGuid),
    [rfReplaceAll, rfIgnoreCase]);

  result := stringReplace(result, '%guid', GuidToString(TGuid.NewGuid),
    [rfReplaceAll, rfIgnoreCase]);

  result := stringReplace(result, '%date', DateTimeToStr(now),
    [rfReplaceAll, rfIgnoreCase]);

  if FTemplates.Values['//%include'] = '' then
    FTemplates.Values['//%include'] := '{.$I ..\inc\mvcbr.inc}';

  if BaseProjectType = bptFMX then
    FTemplates.Add('*.dfm=' + '*.fmx');

  // usa os templates - segudna passada;
  for i := 0 to FTemplates.Count - 1 do
  begin
    result := stringReplace(result, FTemplates.Names[i],
      FTemplates.ValueFromIndex[i], [rfReplaceAll, rfIgnoreCase]);
  end;

  str := TStringList.Create;
  with str do
    try
      text := result;
      c := 0;
      for i := str.Count - 1 downto 0 do
      begin
        str[i] := str[i].TrimRight;
        if str[i] = '' then
        begin
          inc(c);
          //if c > 0 then
          //  str.Delete(i);
        end
        else
          c := 0;
      end;
      result := text;
    finally
      Free;
    end;

end;

procedure TFileCreator.SetBaseProjectType(const Value: TBaseProjectType);
begin
  FBaseProjectType := Value;
end;

procedure TFileCreator.SetisFMX(const Value: boolean);
begin
  FIsFMX := Value;
end;

procedure TFileCreator.SetTemplates(const Value: TStringList);
begin
  FTemplates := Value;
end;

end.
