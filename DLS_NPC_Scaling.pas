{
  Script Name: ReScaleNPCLevel
  Description: Recalculates the level of NPC based on their race, size, and stats. NPCs levels will scale dynamically.
  Author: Rasta
  Version: 1.0
}
unit DLS_NPC_Scaling;

uses mteFunctions;

const
  MAX_LEVEL_MULTIPLIER = 2500; // 2500 = 2.5 -> Max multiplier: PlayerLvl x 2.5
  CALC_MAX_LEVEL = 5000; // Max LVL an NPC can actually have. 0 might be uncapped.
  HEALTH_THRESHOLD = 35000; // Threshold for SKIPPING absurdly OP NPCs

var
  ProcessedCount: Integer;
  SkippedCount: Integer;

function Initialize: Integer;
begin
  ProcessedCount := 0;
  SkippedCount := 0;
  Result := 0;
end;

function Process(e: IInterface): Integer;
var
  Flags, TemplateFlags: Cardinal;
  iSize, iStats, iHPOff, iMOff, iSOff, iHP, iM, iS, iRaceH, iRaceM, iRaceS, iRace, iClassW, iOldLevel, iOldMult, iLevel, iMinLevel, iMaxLevel, iNewLevel: Integer;
begin
  Result := 0;

  if Signature(e) <> 'NPC_' then
    Exit;

  iOldMult := GetElementNativeValues(e, 'ACBS\Level Mult');

  if iOldMult > 0 then
  begin
    SetElementNativeValues(e, 'ACBS\Calc min level', 1);
    SetElementNativeValues(e, 'ACBS\Calc max level', CALC_MAX_LEVEL);
    AddMessage('INFO: ' + EditorID(e) + ' already has mult. Applied uncap.');
    Inc(ProcessedCount);
    Exit;
  end;

  iHP := GetElementNativeValues(e, 'DNAM\Health');
  iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
  iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
  iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
  iM := GetElementNativeValues(e, 'DNAM\Magicka');
  iS := GetElementNativeValues(e, 'DNAM\Stamina');
  iStats := iHPOff + iMOff + iSOff + iHP + iM + iS;

  if iStats < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', sum of Stats is Negative = ' + IntToStr(iStats));
    AddMessage('If you want to include this NPC try running DLS_Remove_Offsets first.');
    AddMessage('SKIPPING: ' + EditorID(e) + '...');
    Inc(SkippedCount);
    Exit;
  end;

  iOldLevel := GetElementNativeValues(e, 'ACBS\Level');

  iSize := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Size');
  iRaceH := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Health');
  iRaceM := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Magicka');
  iRaceS := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Stamina');
  iRace := iRaceH + iRaceM + iRaceS;
  iClassW := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)');

  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 16);
  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 128);

  // Calculate new level based on formula and apply flags
  case iSize of
    0: iNewLevel := (iLevel * iClassW) + iRace + iStats;
    1: iNewLevel := (iLevel * iClassW) + iRace + iRace + iStats;
    else iNewLevel := (iLevel * iClassW * iSize) + iRace + iStats;
  end;

  if iNewLevel > MAX_LEVEL_MULTIPLIER then
    iNewLevel := MAX_LEVEL_MULTIPLIER;
  
  if iNewLevel < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', HP = ' + IntToStr(iHP));
    AddMessage('The calculated mult would be ' + IntToStr(iNewLevel));
    AddMessage('Try lowering the HEALTH_THRESHOLD below ' + IntToStr(iHP));
    AddMessage('SKIPPING: ' + EditorID(e) + '...');
    Inc(SkippedCount);
    Exit;
  end;

  SetElementNativeValues(e, 'ACBS\Level Mult', iNewLevel);
  SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  SetElementNativeValues(e, 'ACBS\Calc max level', CALC_MAX_LEVEL);

  AddMessage('INFO: ' + EditorID(e) + ' Old Level: ' + IntToStr(iOldLevel));
  AddMessage('INFO: ' + EditorID(e) + ' New Level Mult: ' + IntToStr(iNewLevel));
  Inc(ProcessedCount);
end;

function Finalize: Integer;
begin
  AddMessage('Skipped ' + IntToStr(SkippedCount) + ' NPC records.');
  AddMessage('Processed ' + IntToStr(ProcessedCount) + ' NPC records.');
  Result := 0;
end;

end.
