{
  Remove NPC negative Offsets
  Description: Sets any negative offsets for Health, Magicka, and Stamina to zero for NPCs in Skyrim.
  SMART - By Rasta
}
unit DLS_Remove_Offsets;

uses mteFunctions;

function ProcessNegativeOffsets(e: IInterface): integer;
var
  iHPOff, iMOff, iSOff: integer;
begin
  Result := 0;

  // Only process NPC records
  if Signature(e) = 'NPC_' then begin
    // Retrieve current offsets
    iHPOff := GetElementNativeValues(e, 'ACBS\Health Offset');
    iMOff := GetElementNativeValues(e, 'ACBS\Magicka Offset');
    iSOff := GetElementNativeValues(e, 'ACBS\Stamina Offset');
    
    // Reset negative offsets to zero
    if iHPOff < 0 then
      SetElementNativeValues(e, 'ACBS\Health Offset', 0);
    if iMOff < 0 then
      SetElementNativeValues(e, 'ACBS\Magicka Offset', 0);
    if iSOff < 0 then
      SetElementNativeValues(e, 'ACBS\Stamina Offset', 0);
  end;
end;

// Cleanup function
function Finalize: integer;
begin
  Result := 1; // Indicate successful completion
end;

end. // end script
