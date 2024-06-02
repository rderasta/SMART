{
  Unified Script: Uncapp Encounter Zones, Boost RACE's Starting Values, Re-calculate NPC Level
  By Rasta
}
unit DLS_Modify_Records;

uses
  mteFunctions,
  DLS_Uncapp_ECZN,
  DLS_Boost_RACE,
  DLS_NPC_Scaling;

function Process(e: IInterface): integer;
var
  rec: string;
begin
  Result := 0;
  rec := Signature(e);

  if rec = 'ECZN' then begin
    ProcessEncounterZones(e);
  end;

  if rec = 'RACE' then begin
    ProcessRaceValues(e);
  end;

  if rec = 'NPC_' then begin
    ProcessNPCScaling(e);
  end;
end;

function Finalize: integer;
begin
  Result := 1;
end;

end. // end script