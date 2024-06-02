{
  Copy NPCs, RACEs, and Encounter Zones to .esp
  DLS - By Rasta
}
unit DLS_Setup_ESL;

const
  FILE_NAME = 'DLS.esp';

var
  ToFile: IInterface;
  ProcessedCount: Integer;
  CurrentPlugin: string;

function Initialize: Integer;
begin
  ProcessedCount := 0; // Initialize the processed count
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
begin
  // Skip records with specific Editor IDs
  if GetElementEditValues(e, 'EDID') = 'NoZoneZone' then Exit;
  if GetElementEditValues(e, 'EDID') = 'Player' then Exit;

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
      if Assigned(wbCopyElementToFile(e, ToFile, True, True)) then
        Inc(ProcessedCount);
    end;
  end;

  Result := 0;
end;

function Finalize: Integer;
begin
  if ProcessedCount > 0 then
    AddMessage('Processed ' + IntToStr(ProcessedCount) + ' records from ' + CurrentPlugin);

  CleanMasters(ToFile);

  try
    SetIsESL(ToFile, true);
    AddMessage('Set ESL flag on ' + GetFileName(ToFile));
  except
    on E: Exception do
      AddMessage('Failed to set ESL flag: ' + E.Message);
  end;

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
            newFile := AddNewFileName(FILE_NAME, False);
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
