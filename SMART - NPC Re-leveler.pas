{
  Re-calculate NPC Lvl based on its race, size, max level and health.
  SMART - By Rasta
 }
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

 iRaceHP, iSize, iClassW, iHP, iHPOff, iNewHP, iLevel, iNewLevel, iShiftLvl, iSmash : integer;
 	
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
	iSmash := 100;
	
	SetElementNativeValues(e, 'ACBS\Flags\PC Level Mult', '0');
		
	// Super scientificly accurate calculation of the stuff, and setting npc's level accordingly
		if (iSize = '0') then
			iNewLevel := (((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW)) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));
				
		if (iSize = '1') then
			iNewLevel := (((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * (iClassW + iSize))) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));
				
		if (iSize = '2') then
			iNewLevel := (((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW) * iSize) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));	  
		
		if (iSize = '3') then
			iNewLevel := (((iLevel * iShiftLvl) + ((iHP + iHPOff + iRaceHP) * iClassW) * iSize) / iSmash);
				SetElementNativeValues(e, 'ACBS\Level',(iNewLevel));	
	
	

	if Signature(e) = 'NPC_' then exit;

	
	// End NPCs.
	
		
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script

