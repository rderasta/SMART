{
  Boost RACE's Starting values by race SIZE.
  SMART - By Rasta

  Sizes:
    Small: 0
    Medium: 1
    Large: 2
    Extra large: 3
}

unit DLS_Boost_RACE;

uses mteFunctions;


var
  EDIDs: TStringList;
  NewSizes: TStringList;

function Initialize: Integer;
begin
  EDIDs := TStringList.Create;
  NewSizes := TStringList.Create;

  // Add EDIDs and corresponding sizes to the lists
  EDIDs.Add('BearBrownRace'); NewSizes.Add('2');
  EDIDs.Add('IceWraithRace'); NewSizes.Add('0');
  EDIDs.Add('SabreCatRace'); NewSizes.Add('2');
  EDIDs.Add('SabreCatSnowyRace'); NewSizes.Add('2');
  EDIDs.Add('SlaughterfishRace'); NewSizes.Add('0');
  EDIDs.Add('TrollRace'); NewSizes.Add('2');
  EDIDs.Add('TrollFrostRace'); NewSizes.Add('2');
  EDIDs.Add('WispRace'); NewSizes.Add('0');
  EDIDs.Add('FrostbiteSpiderRaceGiant'); NewSizes.Add('3');
  EDIDs.Add('FrostbiteSpiderRaceLarge'); NewSizes.Add('2');
  EDIDs.Add('ChaurusReaperRace'); NewSizes.Add('2');
  EDIDs.Add('WerewolfBeastRace'); NewSizes.Add('2');
  EDIDs.Add('HareRace'); NewSizes.Add('0');
  EDIDs.Add('ChickenRace'); NewSizes.Add('0');
  EDIDs.Add('WispShadeRace'); NewSizes.Add('0');
  EDIDs.Add('SprigganMatronRace'); NewSizes.Add('2');
  EDIDs.Add('FoxRace'); NewSizes.Add('0');
  EDIDs.Add('DLC1ChaurusHunterRace'); NewSizes.Add('2');
  EDIDs.Add('DLC1GargoyleRace'); NewSizes.Add('2');
  EDIDs.Add('DLC1SabreCatGlowRace'); NewSizes.Add('2');
  EDIDs.Add('DLC1TrollFrostRaceArmored'); NewSizes.Add('2');
  EDIDs.Add('DLC1TrollRaceArmored'); NewSizes.Add('2');
  EDIDs.Add('SprigganEarthMotherRace'); NewSizes.Add('2');
  EDIDs.Add('SprigganMatronRace'); NewSizes.Add('2');
  EDIDs.Add('SprigganRace'); NewSizes.Add('2');
  EDIDs.Add('DLC1WerebearBeastRace'); NewSizes.Add('1');
  EDIDs.Add('DLC1WerebearBeastRace'); NewSizes.Add('2');

  Result := 0;
end;

function FindNewSize(const EDID: string): Integer;
var
  idx: Integer;
begin
  Result := -1; // Default to -1 indicating no change if not found
  idx := EDIDs.IndexOf(EDID);
  if idx <> -1 then
    Result := StrToInt(NewSizes[idx]);
end;

function Process(e: IInterface): integer;
var
  iSize, iHealth, iStam, iMgk, iCalc, newSize: integer;
  EDID: string;
begin
  Result := 0;

  if Signature(e) <> 'RACE' then Exit;

  EDID := EditorID(e);
  newSize := FindNewSize(EDID);

  if newSize >= 0 then begin
    SetElementNativeValues(e, 'DATA - DATA\Size', newSize);
    AddMessage('Size changed to ' + IntToStr(newSize) + ' for: ' + EDID);
  end;

  iSize := IfThen(newSize >= 0, newSize, GetElementNativeValues(e, 'DATA - DATA\Size'));
  iHealth := GetElementNativeValues(e, 'DATA\Starting Health');
  iStam := GetElementNativeValues(e, 'DATA\Starting Stamina');
  iMgk := GetElementNativeValues(e, 'DATA\Starting Magicka');

  case iSize of
    1: iCalc := ((iHealth + iStam + iMgk) div 4);
    2: iCalc := ((iHealth + iStam + iMgk) div 3);
    3: iCalc := ((iHealth + iStam + iMgk) div 2);
  end;

  AddMessage('Applying Boost to: ' + EDID);
  SetElementNativeValues(e, 'DATA\Starting Health', iHealth + iCalc);
  SetElementNativeValues(e, 'DATA\Starting Stamina', iStam + iCalc);
  SetElementNativeValues(e, 'DATA\Starting Magicka', iMgk + iCalc);
end;

function Finalize: Integer;
begin
  EDIDs.Free;
  NewSizes.Free;
  Result := 0;
end;

end.
