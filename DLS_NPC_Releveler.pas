{
  Re-calculate NPC Lvl based on its race, size, max level, and health.
  SMART - By Rasta
}
unit DLS_NPC_Releveler;

uses mteFunctions;

const
  MAX_NPC_LEVEL = 500; // Maximum allowable NPC level to avoid overflow issues
  HEALTH_DIVISOR = 100; // Constant for dividing the calculated health-based level

function Process(e: IInterface): integer;
var
  iSize, iStats, iHPOff, iMOff, iSOff, iHP, iM, iS, iRaceH, iRaceM, iRaceS, iRace,
  iClassW, iOldLevel, iLevel, iMinLevel, iMaxLevel, iNewLevel: integer;
begin
  Result := 0;

  // Process only NPC records
  if Signature(e) <> 'NPC_' then exit;
  if GetElementNativeValues(e, 'ACBS\Flags\Invulnerable') then exit;

  // Retrieve initial values for calculations
  iOldLevel := GetElementNativeValues(e, 'ACBS\Level');
  iMinLevel := GetElementNativeValues(e, 'ACBS\Calc min level');
  iMaxLevel := GetElementNativeValues(e, 'ACBS\Calc max level');
  iLevel := (iMinLevel + iMaxLevel) div 2; // Average between min and max level
  iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
  iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
  iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
  iHP := GetElementNativeValues(e, 'DNAM\Health');
  iM := GetElementNativeValues(e, 'DNAM\Magicka');
  iS := GetElementNativeValues(e, 'DNAM\Stamina');
  iStats := iHPOff + iMOff + iSOff + iHP + iM + iS;
  iSize := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Size');
  iRaceH := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Health');
  iRaceS := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Stamina');
  iRaceM := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Magicka');
  iRace := iRaceH + iRaceS + iRaceM;
  iClassW := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)');

  // Super scientifically accurate calculation of the NPC's level
  case iSize of
    0: iNewLevel := ((iLevel * iClassW) + iRace + iStats) div HEALTH_DIVISOR;
    1: iNewLevel := ((iLevel * iClassW) + iRace * 2 + iStats) div HEALTH_DIVISOR;
    else iNewLevel := ((iLevel * iClassW * iSize) + (iRace * iSize) + iStats) div HEALTH_DIVISOR;
  end;

  // Ensure level does not exceed defined limits
  iNewLevel := Min(iNewLevel, MAX_NPC_LEVEL);
  iNewLevel := Max(iNewLevel, 1); // Ensures that level does not drop below 1

  SetElementNativeValues(e, 'ACBS\Level', iNewLevel);

end;

function Finalize: integer;
begin
  Result := 1; // Indicate successful termination of the script
end;

end.
