{
  Uncapp Encounter Zones
  By Rasta
}
unit DLS_Uncapp_ECZN;

uses mteFunctions;

function ProcessEncounterZones(e: IInterface): integer;
begin
  Result := 0;

  // This uncaps all encounter zones
  if Signature(e) = 'ECZN' then begin
    elem := ElementByPath(e, 'DATA - DATA\Min level');
    if Assigned(elem) then
      SetEditValue(elem, '1');
    elem := ElementByPath(e, 'DATA - DATA\Max level');
    if Assigned(elem) then
      SetEditValue(elem, '0');
    elem := ElementByPath(e, 'DATA - DATA\Flags');
    if Assigned(elem) then
      SetElementNativeValues(e, 'DATA - DATA\Flags\Never Resets', 0);
  end;
end;

end. // end script
