{
  Re-calculate NPC Lvl based on its race, size, level and stats.
  Sets NPC level mult flag and sets the mult to the calculated value.
  Ignores: already has mult.
  By Rasta
}
unit DLS_NPC_Scaling;

uses mteFunctions;

const
  MAX_LEVEL_MULTIPLIER = 2500; // 2500 = 2.5 -> Max multiplier: PlayerLvl x 2.5
  CALC_MAX_LEVEL = 0; // Max LVL an NPC can actually have. 0 = uncapped.
  STATS_THRESHOLD = 25000; // Threshold for SKIPPING absurdly OP NPCs
  DEBUG = True; // Wanna see a bunch of numbers?
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
  Flags: Cardinal;
  size, sum_stats, healthOffset, magickaOff, staminaOffset, health, magicka, stamina, raceHealth, raceMagicka, raceStamina, sum_raceStats, classHealthWeight, oldLevel, oldMult, newLevel: Integer;
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

  health := GetElementNativeValues(e, 'DNAM\Health');
  magicka := GetElementNativeValues(e, 'DNAM\Magicka');
  stamina := GetElementNativeValues(e, 'DNAM\Stamina');
  healthOffset := GetElementNativeValues(e, 'ACBS\Health Offset');
  magickaOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
  staminaOffset := GetElementNativeValues(e, 'ACBS\Stamina Offset');
  sum_stats := healthOffset + magickaOff + staminaOffset + health + magicka + stamina;

  if sum_stats < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', sum of Stats is Negative = ' + IntToStr(sum_stats));
    AddMessage('INFO: If you want to include this NPC try running DLS_Remove_Offsets first.');
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
  classHealthWeight := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)');

  if DEBUG then
  begin
    AddMessage('DEBUG: ' + EditorID(e) + ' ------------------------------------------------------------------------------------------------------- ');
    AddMessage('DEBUG: Initial Stats -> Health: ' + IntToStr(health) + ' Magicka: ' + IntToStr(magicka) + ' Stamina: ' + IntToStr(stamina));
    AddMessage('DEBUG: Offsets -> Health Offset: ' + IntToStr(healthOffset) + ' Magicka Offset: ' + IntToStr(magickaOff) + ' Stamina Offset: ' + IntToStr(staminaOffset));
    AddMessage('DEBUG: Sum of Stats = ' + IntToStr(sum_stats));
    AddMessage('DEBUG: Race Stats -> Health: ' + IntToStr(raceHealth) + ' Magicka: ' + IntToStr(raceMagicka) + ' Stamina: ' + IntToStr(raceStamina));
    AddMessage('DEBUG: Race Size: ' + IntToStr(size));
    AddMessage('DEBUG: Class Health Weight: ' + IntToStr(classHealthWeight));
  end;

  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 16);
  SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 128);

  // Calculate new level based on formula and apply flags
  case size of
    0: newLevel := (oldLevel * classHealthWeight) + sum_raceStats + sum_stats;
    1: newLevel := (oldLevel * classHealthWeight) + sum_raceStats + sum_raceStats + sum_stats;
    else newLevel := (oldLevel * classHealthWeight * size) + sum_raceStats + sum_stats;
  end;

  AddMessage('DEBUG: Calculated New Level: ' + IntToStr(newLevel));

  if newLevel > MAX_LEVEL_MULTIPLIER then
  begin
    AddMessage('NOTICE: Capping ' + EditorID(e) + ' calculated above MAX ' + IntToStr(newLevel));
    newLevel := MAX_LEVEL_MULTIPLIER;
  end;

  if newLevel < 0 then
  begin
    AddMessage('WARNING: Found potential bug on NPC ' + EditorID(e) + ', HP=' + IntToStr(health) + ' MAG=' + IntToStr(magicka) + ' STA=' + IntToStr(stamina));
    AddMessage('INFO: The calculated mult would be ' + IntToStr(newLevel));
    AddMessage('INFO: Try lowering the STATS_THRESHOLD below ' + IntToStr(health));
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
