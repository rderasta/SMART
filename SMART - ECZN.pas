{
  Uncapp Encounter Zones
   - By Rasta
}
unit userscript;

uses mteFunctions;

function Process(e: IInterface): integer;

var

 iOldLevel, iNewLevel, iShift, iBase, iHealth, iHealthPlus, iStam, iStamPlus, iMgk, iMgkPlus, iMult : integer;
	
begin
 Result := 0;

// This uncapps all encounter zones

		if Signature(e) = 'ECZN' then
		SetElementNativeValues(e, 'DATA - DATA\Min level', 1);
		SetElementNativeValues(e, 'DATA - DATA\Max level', 0);
		SetElementNativeValues(e, 'DATA - DATA\Flags\Never Resets', 0);
	
 end;



// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script

