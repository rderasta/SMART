{
  Boost RACE's Starting values by race SIZE.
  SMART - By Rasta
}
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

iM, iL, iEL, iCalc, iHealth, iStam, iMgk, iSize : integer;

begin
 Result := 0;

	if Signature(e) = 'RACE' then
	// Grab stuff to calculate
	iSize := GetElementNativeValues(e, 'DATA - DATA\Size');
	iHealth := GetElementNativeValues(e, 'DATA - DATA\Starting Health');
	iStam := GetElementNativeValues(e, 'DATA - DATA\Starting Stamina');   	
	iMgk := GetElementNativeValues(e, 'DATA - DATA\Starting Magicka');	
	iM := 2;
	iL := 3;
	iEL := 4;
	// Calculate the stuff and then apply to each by size
		if (iSize = '0') then
			exit;
		if (iSize = '1') then
			iCalc := ((iHealth + iStam + iMgk) / iEL);
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iCalc + iHealth));
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iCalc + iStam));
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iCalc + iMgk));
		if (iSize = '2') then
			iCalc := ((iHealth + iStam + iMgk) / iL);
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iCalc + iHealth));
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iCalc + iStam));
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iCalc + iMgk));
		if (iSize = '3') then
			iCalc := ((iHealth + iStam + iMgk) / iM);
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iCalc + iHealth));
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iCalc + iStam));
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iCalc + iMgk));

	if Signature(e) = 'RACE' then exit;

end;

// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end;

end.