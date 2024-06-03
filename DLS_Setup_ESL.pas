{
  Copy NPCs, RACEs, and Encounter Zones to .esp
  DLS - By Rasta
}
unit DLS_Setup_ESL;

const
  FILE_NAME = 'DLS.esp';
  HEALTH_THRESHOLD = 35000; // Threshold for SKIPPING absurdly OP NPCs

var
  ToFile: IInterface;
  ProcessedCount: Integer;
  SkippedCount: Integer;
  CurrentPlugin: string;
  Flags, TemplateFlags: Cardinal;
  iHP: Integer;
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
  targetRecord, copiedRecord: IInterface;
begin
  // Skip records with specific Editor IDs
  if GetElementEditValues(e, 'EDID') = 'NoZoneZone' then Exit;
  if GetElementEditValues(e, 'EDID') = 'Player' then Exit;

  EDID := EditorID(e);

  // Skip invulnerable NPCs
  // Flags := GetElementNativeValues(e, 'ACBS\Flags');
  // if Flags and 2147483648 <> 0 then
  // begin
  //   AddMessage('SKIPPING: invulnerable NPC: ' + EDID);
  //   Inc(SkippedCount);
  //   Exit;
  // end;

  // Skip NPCs with extremely high health
  iHP := GetElementNativeValues(e, 'DNAM\Health');
  if iHP >= HEALTH_THRESHOLD then
  begin
    AddMessage('SKIPPING: ' + EDID + ' due to absurd stats: HP = ' + IntToStr(iHP));
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
  begin
    if GetFile(e) <> ToFile then
    begin
      AddRequiredElementMasters(e, ToFile, False, True); // Add masters silently
      // Check if the record already exists in the target file
      targetRecord := MainRecordByEditorID(GroupBySignature(ToFile, Signature(e)), EditorID(e));
      if Assigned(targetRecord) then
        RemoveElement(GroupBySignature(ToFile, Signature(e)), targetRecord); // Remove existing record if found
      copiedRecord := wbCopyElementToFile(e, ToFile, False, True);
      if Assigned(copiedRecord) then
      begin
        Inc(ProcessedCount);
      end;
    end;
  end;

  Result := 0;
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
