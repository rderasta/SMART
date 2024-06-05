{
  Copy NPCs, RACEs, and Encounter Zones to .esp
  Auto-accepts masters.
  Copies winning overrides.
  Ignores: Deleted flags, NoZoneZone, Player, NPCs with extremely high stats.
  By Rasta
}
unit DLS_Setup_ESL;

const
  FILE_NAME = 'DLS.esp';
  STATS_THRESHOLD = 25000; // Threshold for SKIPPING absurdly OP NPCs

var
  ToFile: IInterface;
  ProcessedCount: Integer;
  SkippedCount: Integer;
  CurrentPlugin: string;
  Flags, TemplateFlags: Cardinal;
  health, magicka, stamina: Integer;
  EDID: string;

function Initialize: Integer;
begin
  ProcessedCount := 0;
  SkippedCount := 0;
  ToFile := SelectFile('Select the target file or create a new one:');
  if not Assigned(ToFile) then
  begin
    AddMessage('Script cancelled or failed to create/select file.');
    Result := 1;
    Exit;
  end;
  AddMessage('Using file: ' + GetFileName(ToFile));
  Result := 0;
end;

function Process(e: IInterface): Integer;
var
  copiedRecord: IInterface;
begin
  Result := 0;
  try
    // Skip records with specific Editor IDs
    if GetElementEditValues(e, 'EDID') = 'NoZoneZone' then Exit;
    if GetElementEditValues(e, 'EDID') = 'Player' then Exit;

    EDID := EditorID(e);

    // Skip records marked as deleted
    if GetIsDeleted(e) then
    begin
      AddMessage('SKIPPING: ' + EDID + ' is marked as deleted.');
      Inc(SkippedCount);
      Exit;
    end;

    // Track current plugin
    if CurrentPlugin <> GetFileName(GetFile(e)) then
    begin
      if ProcessedCount > 0 then
        AddMessage('Processed ' + IntToStr(ProcessedCount) + ' records from ' + CurrentPlugin);
      CurrentPlugin := GetFileName(GetFile(e));
      ProcessedCount := 0;
    end;


    // Process NPC, ECZN, and RACE records
    if (Signature(e) = 'NPC_') or (Signature(e) = 'ECZN') or (Signature(e) = 'RACE') then

    // Only process winning overrides
    if not IsWinningOverride(e) then Exit;

    begin
      if (Signature(e) = 'NPC_') then
      begin
        // Skip invulnerable NPCs
        // Flags := GetElementNativeValues(e, 'ACBS\Flags');
        // if Flags and 2147483648 <> 0 then
        // begin
        //   AddMessage('SKIPPING: invulnerable NPC: ' + EDID);
        //   Inc(SkippedCount);
        //   Exit;
        // end;

        // Skip NPCs with extremely high stats
        health := GetElementNativeValues(e, 'DNAM\Health');
        magicka := GetElementNativeValues(e, 'DNAM\Magicka');
        stamina := GetElementNativeValues(e, 'DNAM\Stamina');
        if (health >= STATS_THRESHOLD) or (magicka >= STATS_THRESHOLD) or (stamina >= STATS_THRESHOLD) then
        begin
          AddMessage('SKIPPING: ' + EditorID(e) + ' due to absurd stats: ' + 'HP=' + IntToStr(health) + ' MAG=' + IntToStr(magicka) + ' STA=' + IntToStr(stamina));
          Inc(SkippedCount);
          Exit;
        end;

      end;
      if GetFile(e) <> ToFile then
      begin
        AddRequiredElementMasters(e, ToFile, False, True); // Add masters silently
        copiedRecord := wbCopyElementToFile(e, ToFile, False, True);
        if Assigned(copiedRecord) then
        begin
          Inc(ProcessedCount);
          AddMessage('Copied record: ' + EditorID(copiedRecord));
        end
        else
        begin
          AddMessage('Failed to copy record: ' + EDID);
        end;
      end;
    end;
  except
    on E: Exception do
    begin
      AddMessage('Error processing record: ' + EditorID(e) + ' - ' + E.Message);
      Result := 1;
    end;
  end;
end;

function Finalize: Integer;
begin
  if ProcessedCount > 0 then
  begin
    AddMessage('Skipped ' + IntToStr(SkippedCount) + ' NPC records.');
    AddMessage('Processed ' + IntToStr(ProcessedCount) + ' records from ' + CurrentPlugin);
  end;

  CleanMasters(ToFile);

  AddMessage('Masters cleaned and script completed.');
  Result := 0;
end;

function SelectFile(prompt: string): IInterface;
var
  frm: TForm;
  clb: TCheckListBox;
  i: Integer;
  newFile: IInterface;
begin
  frm := frmFileSelect;
  try
    frm.Caption := prompt;
    clb := TCheckListBox(frm.FindComponent('CheckListBox1'));
    clb.Items.Add('<Create a new file>');
    for i := 0 to Pred(FileCount) do
      clb.Items.Add(GetFileName(FileByIndex(i)));

    if frm.ShowModal = mrOk then
      for i := 0 to Pred(clb.Items.Count) do
        if clb.Checked[i] then
        begin
          if i = 0 then
          begin
            newFile := AddNewFileName(FILE_NAME, True);
            Result := newFile;
          end
          else
            Result := FileByIndex(i - 1);
          Break;
        end;
  finally
    frm.Free;
  end;
end;

end.
