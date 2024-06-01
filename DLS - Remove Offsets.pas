{
  Remove NPC negative Offsets
  SMART - By Rasta
}
unit RemoveOffsets;

uses mteFunctions;

function ProcessNegativeOffsets(e: IInterface): integer;

var

iHPOff, iMOff, iSOff : integer;

 
begin

 Result := 0;

	
	// Start NPCs.


	if Signature(e) = 'NPC_' then
	
	
	iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
	iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
	iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
	
		if (iHPOff < '0') then
			SetElementNativeValues(e, 'ACBS\Health Offset', (0));
		if (iMOff < '0') then
			SetElementNativeValues(e, 'ACBS\Magicka Offset', (0));
		if (iSOff < '0') then
			SetElementNativeValues(e, 'ACBS\Stamina Offset', (0));
		

	if Signature(e) = 'NPC_' then exit;

	
	// End NPCs.
	
		
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script