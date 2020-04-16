{
  Makes changes to RACE's Starting values.
  SMART - By Rasta
}
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

  , , iHealth, iHealthPlus, iStam, iStamPlus, iMgk, iMgkPlus, iMult, iSize : integer;
	
begin
 Result := 0;
 
	// This changes Starting Hp, Stamina, and Magicka value of races.	

		iMult := 2;
				
	if Signature(e) = 'RACE' then
	
	iSize := GetElementNativeValues(e, 'DATA - DATA\Size');
	
	   	iHealth := GetElementNativeValues(e, 'DATA - DATA\Starting Health');
			if (iSize = '0') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iHealth * iMult));
			if (iSize = '1') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iHealth * iMult));
			if (iSize = '2') then
				iHealthPlus := iHealth / iMult;
					SetElementNativeValues(e, 'DATA - DATA\Starting Health',((iHealthPlus + iHealth) * iMult));
			if (iSize = '3') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Health',(iHealth * iSize));
		
			
		iStam := GetElementNativeValues(e, 'DATA - DATA\Starting Stamina');
			if (iSize = '0') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iStam * iMult));
			if (iSize = '1') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iStam * iMult));
			if (iSize = '2') then
				iStamPlus := iStam / iMult;
					SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',((iStam + iStamPlus) * iMult));
			if (iSize = '3') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Stamina',(iStam * iSize));
		 
					
		iMgk := GetElementNativeValues(e, 'DATA - DATA\Starting Magicka');
			if (iSize = '0') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iMgk * iMult));
			if (iSize = '1') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iMgk * iMult));
			if (iSize = '2') then
				iMgkPlus := iMgk / iMult;
					SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',((iMgk + iMgkPlus) * iMult));
			if (iSize = '3') then
				SetElementNativeValues(e, 'DATA - DATA\Starting Magicka',(iMgk * iSize));
		
	if Signature(e) = 'RACE' then exit;
	
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script