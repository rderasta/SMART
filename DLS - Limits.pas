{
  Checks for mult value and if its above desired limit it will change to custom value.
  Skyrim Scaled Uncapped - By Rasta
}
unit LimitLvl;

uses mteFunctions;

function ProcessLimits(e: IInterface): integer;

var

 iCheckMult, iLimit : integer;
	
begin
 Result := 0;

if Signature(e) = 'NPC_' then


	// Sets min/max, comment/uncomment this lines as needed
	// SetElementNativeValues(e, 'ACBS\Calc min level', 1);
  	// SetElementNativeValues(e, 'ACBS\Calc max level', 500);
	
		
	// Change limit to desired value, 10000 = 10
	// E.g: 1300 = 1.3
	iLimit := 2500;
		iCheckMult := GetElementNativeValues(e, 'ACBS\Level Mult');
			if iCheckMult > iLimit then
				SetElementNativeValues(e, 'ACBS\Level Mult',(iLimit));
		
	end;
	
	// Cleanup
function Finalize: integer;
	begin

		Result := 1;

	end; // end function

end. // end script
