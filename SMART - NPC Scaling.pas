{
  Flag NPCs with Level Mult and calculate mult based on its race, size, level and health.
  SMART - By Rasta
 }
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

 iMult, iHealth, iHealthPlus, iStam, iStamPlus, iMgk, iMgkPlus, iRaceHP, iSize, iClassW, iHP, iHPOff, iNewHP, iLevel, iNewLevel, iShiftLvl, iShiftMult, iLvlCheck, iMaxMult : integer;
 	
begin

 Result := 0;

	
	// Start NPCs.


	if Signature(e) = 'NPC_' then
	
	// Grabbing stuff to calculate
	iLevel := GetElementNativeValues(e, 'ACBS\Calc max level');
	iHP := GetElementNativeValues(e, 'DNAM\Health');
	iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');	
	iRaceHP := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Starting Health');
	iSize := GetElementNativeValues(LinksTo(ElementBySignature(e, 'RNAM')), 'DATA - DATA\Size');
	iClassW := GetElementNativeValues(LinksTo(ElementBySignature(e, 'CNAM')), 'DATA - DATA\Attribute Weights\Weight #0 (Health)\');
	iShiftLvl := 10;
	
		
	SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 16);
 	SetElementNativeValues(e, 'ACBS\Flags', GetElementNativeValues(e, 'ACBS\Flags') or 128);
	
		
	// Super scientificly accurate calculation of the stuff, and setting npc's mult accordingly
		if (iSize = '0') then
			iNewLevel := ((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW));
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));
				
		if (iSize = '1') then
			iNewLevel := ((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * (iClassW + iSize)));
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));
				
		if (iSize = '2') then
			iNewLevel := ((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW) * iSize);
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));	  
		
		if (iSize = '3') then
			iNewLevel := ((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW) * iSize);
				SetElementNativeValues(e, 'ACBS\Level Mult',(iNewLevel));	
	
	
	// Sets min/max
	SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  	SetElementNativeValues(e, 'ACBS\Calc max level', 0);
	
	
	// VERY questionable fix for Unique NPCs with 55k health
	iMaxMult := 32700;
	iLvlCheck := GetElementNativeValues(e, 'ACBS\Level Mult');
		if (iLvlCheck < '0') then
			SetElementNativeValues(e, 'ACBS\Level Mult',(iMaxMult));
	
	if Signature(e) = 'NPC_' then exit;

	
	// End NPCs.
	
		
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script

