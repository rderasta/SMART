{
  Remove NPC negative Offsets
  Sets any negative offsets for Health, Magicka, and Stamina to zero for NPCs in Skyrim.
  By Rasta
}
unit DLS_Remove_Offsets;

uses mteFunctions;

var
  ProcessedCount: Integer;

function Initialize: Integer;
begin
  ProcessedCount := 0;
  Result := 0; // Initialization successful
end;

function Process(e: IInterface): Integer;
var
  iHPOff, iMOff, iSOff: Integer;
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
      AddMessage('NPC: ' + EditorID(e) + ' Health Offset < 0');
      // SetElementNativeValues(e, 'ACBS\Health Offset', 0);
    if iMOff < 0 then
      AddMessage('NPC: ' + EditorID(e) + ' Magika Offset < 0');
      // SetElementNativeValues(e, 'ACBS\Magicka Offset', 0);
    if iSOff < 0 then
      AddMessage('NPC: ' + EditorID(e) + ' Stamina Offset < 0');
      // SetElementNativeValues(e, 'ACBS\Stamina Offset', 0);

    Inc(ProcessedCount);
  end;
end;

// Cleanup function
function Finalize: Integer;
begin
  AddMessage('Processed ' + IntToStr(ProcessedCount) + ' NPC records.');
  Result := 0; // Indicate successful completion
end;

end. // end script
