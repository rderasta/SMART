{
  Uncapp Encounter Zones
  By Rasta
}
unit DLS_Uncapp_ECZN;

uses mteFunctions;

var
  ProcessedCount: Integer;

function Initialize: Integer;
begin
  ProcessedCount := 0;
  Result := 0;
end;

function Process(e: IInterface): Integer;
var
  elem: IInterface;
begin
  Result := 0;

  // This uncaps all encounter zones
  if Signature(e) = 'ECZN' then begin
    // Set Min level to 1
    elem := ElementByPath(e, 'DATA - DATA\Min level');
    if Assigned(elem) then
      SetEditValue(elem, '1');

    // Set Max level to 0
    elem := ElementByPath(e, 'DATA - DATA\Max level');
    if Assigned(elem) then
      SetEditValue(elem, '0');

    // Set Flags - Never Resets to 0
    elem := ElementByPath(e, 'DATA - DATA\Flags');
    if Assigned(elem) then
      SetEditValue(ElementByPath(e, 'DATA - DATA\Flags\Never Resets'), '0');

    Inc(ProcessedCount);
  end;
end;

function Finalize: Integer;
begin
  AddMessage('Processed ' + IntToStr(ProcessedCount) + ' encounter zones.');
  Result := 0;
end;

end. // end script
