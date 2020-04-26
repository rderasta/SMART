{
  Re-calculate NPC Lvl based on its race, size, max level and health.
  SMART - By Rasta
}
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

iSize, iStats, iHPOff, iMOff, iSOff, iHP, iM, iS, iRaceH, iRaceM, iRaceS, iRace, iClassW, iOldLevel, iLevel, iMinLevel, iMaxLevel, iLimitLvl, iLvlCheck, iNewLevel, iSmash : integer;

 
begin

 Result := 0;

	
	// Start NPCs.


	if Signature(e) = 'NPC_' then
	
	
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
	iSmash := 100;
		
	
	// Uncomment to remove Mult flags
	 SetElementNativeValues(e, 'ACBS\Flags\PC Level Mult', '0');
	// Comment to NOT skip them, must uncomment above.
	// if GetElementNativeValues(e, 'ACBS\Flags\PC Level Mult') then exit;
	
		
	// Super scientificly accurate calculation of the stuff, and setting npc's level accordingly
		if (iSize = '0') then
			iNewLevel := (((iLevel * iClassW) + iRace + iStats) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));
						
		if (iSize = '1') then
			iNewLevel := (((iLevel * iClassW) + iRace + iRace + iStats) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));
							
		if (iSize > '1') then
			iNewLevel := (((iLevel * iClassW) + (iRace * iSize) + iStats) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));
							
		
	// Fix for NPCs with 55k h/m/s
	iLimitLvl := 500;
	iLvlCheck := GetElementNativeValues(e, 'ACBS\Level');
		if (iLvlCheck > iLimitLvl) then
			SetElementNativeValues(e, 'ACBS\Level',(iLimitLvl));
			
	
	if Signature(e) = 'NPC_' then exit;

	
	// End NPCs.
	
		
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script

