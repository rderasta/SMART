{
  Re-calculate NPC Lvl based on its race, size, level and stats.
  SMART - By Rasta
}
unit ReScaleNPCLevel;

uses mteFunctions;

function ProcessNPCLevel(e: IInterface): integer;

var

 iSize, iStats, iHPOff, iMOff, iSOff, iHP, iM, iS, iRaceH, iRaceM, iRaceS, iRace, iClassW, iOldLevel, iLevel, iMinLevel, iMaxLevel, iMaxMult, iLvlCheck, iNewLevel : integer;


begin

 Result := 0;

	// Start NPCs.
	if Signature(e) = 'NPC_' then

	if GetElementNativeValues(e, 'ACBS\Flags\Invulnerable') then exit;

	// Grabbing stuff to calculate
	iOldLevel := GetElementNativeValues(e, 'ACBS\Level');
	iMinLevel := GetElementNativeValues(e, 'ACBS\Calc min level');
	iMaxLevel := GetElementNativeValues(e, 'ACBS\Calc max level');
	iLevel := (iLevel + iMinLevel + iMaxLevel);
	iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
	iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
	iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
	iHP := GetElementNativeValues(e, 'DNAM\Health');
	iM := GetElementNativeValues(e, 'DNAM\Magicka');
	iS := GetElementNativeValues(e, 'DNAM\Stamina');
	iStats := (iHPOff + iMOff + iSOff + iHP + iM + iS);
	iSize := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Size');
	iRaceH := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Health');
	iRaceS := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Stamina');
	iRaceM := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Magicka');
	iRace := (iRaceH + iRaceS + iRaceM);
	iClassW := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)\');


	SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 16);
 	SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 128);


	// Super scientificly accurate calculation of the stuff, and setting npc's level accordingly
		if (iSize = '0') then
			iNewLevel := ((iLevel * iClassW) + iRace + iStats);
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));

		if (iSize = '1') then
			iNewLevel := ((iLevel * iClassW) + iRace + iRace + iStats);
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));

		if (iSize > '1') then
			iNewLevel := ((iLevel * iClassW * iSize) + iRace + iStats);
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));
							

	// Sets min/max
	SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  	SetElementNativeValues(e, 'ACBS\Calc max level', 500);


	// Mult Limiter, modify, comment or uncomment to opt in/out
	// Note: Must be in the thousands, e.g: 1000 will set the mult to 1.0, 2000 = 2.0, and so on.
	iMaxMult := 2500;
		iLvlCheck := GetElementNativeValues(e, 'ACBS\Level Mult');
			if (iLvlCheck > iMaxMult) then
				SetElementNativeValues(e, 'ACBS\Level Mult',(iMaxMult));


	// Fix for Unique NPCs with 55k h/m/s
	iMaxMult := 10000;
		iLvlCheck := GetElementNativeValues(e, 'ACBS\Level Mult');
			if (iLvlCheck < '0') then
				SetElementNativeValues(e, 'ACBS\Level Mult',(iMaxMult));

	if Signature(e) = 'NPC_' then exit;

end;

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end;

end.