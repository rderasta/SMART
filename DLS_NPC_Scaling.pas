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
  STATS_THRESHOLD = 35000; // Threshold for SKIPPING absurdly OP NPCs

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
  size, sum_stats, healthOffset, magickaOff, staminaOffset, health, magicka, stamina, raceHealth, raceMagicka, raceStamina, sum_raceStats, classWeight, oldLevel, oldMult, newLevel: Integer;
begin
  Result := 0;

  if Signature(e) <> 'NPC_' then
    Exit;

  oldMult := GetElementNativeValues(e, 'ACBS\Level Mult');

  if oldMult > 0 then
  begin
    SetElementNativeValues(e, 'ACBS\Calc min level', 1);
    SetElementNativeValues(e, 'ACBS\Calc max level', CALC_MAX_LEVEL);
    AddMessage('INFO: ' + EditorID(e) + ' already has mult. Applied uncap.');
    Inc(ProcessedCount);
    Exit;
  end;

  // Skip invulnerable NPCs
  // Flags := GetElementNativeValues(e, 'ACBS\Flags');
  // if Flags and 2147483648 <> 0 then
  // begin
  //   AddMessage('SKIPPING: invulnerable NPC: ' + EDID);
  //   Inc(SkippedCount);
  //   Exit;
  // end;

  health := GetElementNativeValues(e, 'DNAM\Health');
  magicka := GetElementNativeValues(e, 'DNAM\Magicka');
  stamina := GetElementNativeValues(e, 'DNAM\Stamina');

  // Skip NPCs with extremely high stats
  if (health >= STATS_THRESHOLD) or (magicka >= STATS_THRESHOLD) or (stamina >= STATS_THRESHOLD) then
  begin
    AddMessage('SKIPPING: ' + EDID + ' due to absurd stats: ' + 'HP=' + IntToStr(health) + ' MAG=' + IntToStr(magicka) + ' STA=' + IntToStr(stamina));
    Inc(SkippedCount);
    Exit;
  end;


  healthOffset := GetElementNativeValues(e, 'ACBS\Health Offset');
  magickaOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
  staminaOffset := GetElementNativeValues(e, 'ACBS\Stamina Offset');
  sum_stats := healthOffset + magickaOff + staminaOffset + health + magicka + stamina;

  if sum_stats < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', sum of Stats is Negative = ' + IntToStr(sum_stats));
    AddMessage('If you want to include this NPC try running DLS_Remove_Offsets first.');
    AddMessage('SKIPPING: ' + EditorID(e) + '...');
    Inc(SkippedCount);
    Exit;
  end;

  oldLevel := GetElementNativeValues(e, 'ACBS\Level');
  size := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Size');
  raceHealth := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Health');
  raceMagicka := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Magicka');
  raceStamina := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Stamina');
  sum_raceStats := raceHealth + raceMagicka + raceStamina;
  classWeight := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)');

  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 16);
  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 128);

  // Calculate new level based on formula and apply flags
  case size of
    0: newLevel := (oldLevel * classWeight) + sum_raceStats + sum_stats;
    1: newLevel := (oldLevel * classWeight) + sum_raceStats + sum_raceStats + sum_stats;
    else newLevel := (oldLevel * classWeight * size) + sum_raceStats + sum_stats;
  end;

  if newLevel > MAX_LEVEL_MULTIPLIER then
    newLevel := MAX_LEVEL_MULTIPLIER;
  
  if newLevel < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', HP = ' + IntToStr(health));
    AddMessage('The calculated mult would be ' + IntToStr(newLevel));
    AddMessage('Try lowering the STATS_THRESHOLD below ' + IntToStr(health));
    AddMessage('SKIPPING: ' + EditorID(e) + '...');
    Inc(SkippedCount);
    Exit;
  end;

  SetElementNativeValues(e, 'ACBS\Level Mult', newLevel);
  SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  SetElementNativeValues(e, 'ACBS\Calc max level', CALC_MAX_LEVEL);

  AddMessage('INFO: ' + EditorID(e) + ' Old Level: ' + IntToStr(oldLevel));
  AddMessage('INFO: ' + EditorID(e) + ' New Level Mult: ' + IntToStr(newLevel));
  Inc(ProcessedCount);
end;

function Finalize: Integer;
begin
  AddMessage('Skipped ' + IntToStr(SkippedCount) + ' NPC records.');
  AddMessage('Processed ' + IntToStr(ProcessedCount) + ' NPC records.');
  Result := 0;
end;

end.
