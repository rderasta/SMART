{
  Uncapp Encounter Zones
  By Rasta
}
unit UncappEncounterZones;

uses mteFunctions;

function ProcessEncounterZones(e: IInterface): integer;
begin
  Result := 0;

  // This uncaps all encounter zones
  if Signature(e) = 'ECZN' then begin
    SetElementNativeValues(e, 'DATA - DATA\Min level', 1);
    SetElementNativeValues(e, 'DATA - DATA\Max level', 0);
    SetElementNativeValues(e, 'DATA - DATA\Flags\Never Resets', 0);
  end;
end;

end. // end script
