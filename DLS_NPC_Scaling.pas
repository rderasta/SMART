{
  Script Name: ReScaleNPCLevel
  Description: Recalculates the level of NPC based on their race, size, and stats. NPCs levels will scale dynamically.
  Author: Rasta
  Version: 1.0
}
unit DLS_NPC_Scaling;

uses mteFunctions;

const
  MAX_LEVEL_MULTIPLIER = 2500;
  OP_NPC = 10000;
  INVULNERABLE_FLAG = 2147483648; // Decimal representation of the invulnerability flag

function Initialize: Integer;
begin
  Result := 0; // Initialize the script to allow processing
end;

function Process(e: IInterface): Integer;
var
  Flags: Cardinal;
  iSize, iStats, iHPOff, iMOff, iSOff, iHP, iM, iS, iRaceH, iRaceM, iRaceS, iRace, iClassW, iOldLevel, iLevel, iMinLevel, iMaxLevel, iNewLevel: Integer;
begin
  Result := 0;

  if Signature(e) <> 'NPC_' then
    Exit; // Only process NPC records

  // Retrieve and check flags for invulnerability
  Flags := GetElementNativeValues(e, 'ACBS\Flags');
  if Flags and INVULNERABLE_FLAG <> 0 then
    Exit; // Exit if the NPC is flagged as invulnerable

  iOldLevel := GetElementNativeValues(e, 'ACBS\Level');
  iMinLevel := GetElementNativeValues(e, 'ACBS\Calc min level');
  iMaxLevel := GetElementNativeValues(e, 'ACBS\Calc max level');
  iLevel := (iMinLevel + iMaxLevel) div 2;
  iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
  iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
  iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
  iHP := GetElementNativeValues(e, 'DNAM\Health');
  iM := GetElementNativeValues(e, 'DNAM\Magicka');
  iS := GetElementNativeValues(e, 'DNAM\Stamina');
  iStats := iHPOff + iMOff + iSOff + iHP + iM + iS;
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
    iNewLevel := MAX_LEVEL_MULTIPLIER
  else if iNewLevel < 0 then
    iNewLevel := OP_NPC;

  SetElementNativeValues(e, 'ACBS\Level Mult', iNewLevel);
  SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  SetElementNativeValues(e, 'ACBS\Calc max level', 500);
end;

function Finalize: Integer;
begin
  Result := 0; // Successful completion
end;

end.
