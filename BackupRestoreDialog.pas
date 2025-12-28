unit BackupRestoreDialog;

interface

uses
  Winapi.Windows, Winapi.Messages,
  System.SysUtils, System.Variants, System.Classes,
  idglobal,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  BaseDialog,
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxButtons,
  RzEdit, RzRadChk, RzButton, RzPanel, RzLabel, dxSkinsCore, dxSkinBlack,
  dxSkinBlue, dxSkinBlueprint, dxSkinCaramel, dxSkinCoffee, dxSkinDarkRoom,
  dxSkinDarkSide, dxSkinDevExpressDarkStyle, dxSkinDevExpressStyle, dxSkinFoggy,
  dxSkinGlassOceans, dxSkinHighContrast, dxSkiniMaginary, dxSkinLilian,
  dxSkinLiquidSky, dxSkinLondonLiquidSky, dxSkinMcSkin, dxSkinMoneyTwins,
  dxSkinOffice2007Black, dxSkinOffice2007Blue, dxSkinOffice2007Green,
  dxSkinOffice2007Pink, dxSkinOffice2007Silver, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxSkinPumpkin, dxSkinSeven,
  dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus, dxSkinSilver,
  dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008, dxSkinTheAsphaltWorld,
  dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010, dxSkinWhiteprint,
  dxSkinXmas2008Blue;

type
  TBackupRestoreDlg = class(TBaseDlg)
    DeleteFileDialog: TOpenDialog;
    OpenRestoreFile: TOpenDialog;
    pnlMain: TPanel;
      pnlTop: TPanel;
        RzLabel1: TRzLabel;
      pnlClient: TRzPanel;
        RzLabel2: TRzLabel;
        lbCurrentDataFile: TRzLabel;
        RzLabel3: TRzLabel;
        lbBackupDataFile: TRzLabel;
        ckAddDate: TRzCheckBox;
        RzLabel4: TRzLabel;
        ckDefaultLocation: TRzCheckBox;
        rbBackup: TRzRadioButton;
        RzLabel5: TRzLabel;
        edBackupFile: TRzEdit;
        btnBackup: TcxButton;
        rbRestore: TRzRadioButton;
        RzLabel6: TRzLabel;
        edRestoreFile: TRzEdit;
        btnRestore: TcxButton;
      pnlButtons: TRzPanel;
        btnRemove: TcxButton;
        btnOK: TcxButton;
        btnCancel: TcxButton;
    procedure ckAddDateClick(Sender: TObject);
    procedure rbRestoreClick(Sender: TObject);
    procedure rbBackupClick(Sender: TObject);
    procedure btnRestoreClick(Sender: TObject);
    procedure btnBackupClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure ckDefaultLocationClick(Sender: TObject);
    procedure btnRemoveClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
    FBackupFileName : String;
    Function GetBackupFileName : String;
    Function GetTrFileName : String;
  protected
    procedure SetupForm; override;
    procedure SaveData; override;
  public
    { Public declarations }
  end;

implementation

uses
  TLFile, TLSettings, FileCtrl, FuncProc, StrUtils, TLCommonLib, Main, Splash;

{$R *.dfm}

const
  BACKUP_EXT = '-Backup';

{ TBackupRestoreDlg }

//-----------------
// (*) Backup
// ( ) Restore
//-----------------

procedure TBackupRestoreDlg.rbBackupClick(Sender: TObject);
begin
  btnBackup.Enabled := True;
  edBackupFile.Enabled := True;
  btnRestore.Enabled := False;
  edRestoreFile.Enabled := False;
  btnOK.Caption := 'Backup Now';
end;

//-----------------
// ( ) Backup
// (*) Restore
//-----------------
procedure TBackupRestoreDlg.rbRestoreClick(Sender: TObject);
begin
  btnBackup.Enabled := False;
  edBackupFile.Enabled := False;
  btnRestore.Enabled := True;
  edRestoreFile.Enabled := True;
  btnOK.Caption := 'Restore Now';
  btnOK.Enabled := false; // 2020-04-29 MB - must always select first!
end;

//-------------------------------------
// use default backup directory?
//-------------------------------------
procedure TBackupRestoreDlg.ckDefaultLocationClick(Sender: TObject);
begin
  if ckDefaultLocation.Checked then
  begin
    edBackupFile.Text := Settings.UserBackupDir + '\' + FBackupFileName;
  end else
    edBackupFile.Text := Settings.BackupDir + '\' + FBackupFileName;
end;

procedure TBackupRestoreDlg.FormActivate(Sender: TObject);
begin
  inherited;
  // Splash is open so setfocus on restore btn
  if (TrFileName = '') then
    btnRestore.SetFocus;
end;

//-----------------
// pick backup dir
//-----------------
procedure TBackupRestoreDlg.btnBackupClick(Sender: TObject);
var
  Directory : String;
begin
  Directory := Settings.UserBackupDir;
  if SelectDirectory('Select Backup Directory', '\', Directory, [sdNewUI], Self) then
  begin
    Settings.UserBackupDir := Directory;
    edBackupFile.Text := Settings.UserBackupDir + '\' + FBackupFileName;
  end;
end;

//-------------------------------------
// [OK] button (caption changes)
//-------------------------------------
procedure TBackupRestoreDlg.btnOKClick(Sender: TObject);
var
  bResult : Boolean;
begin
  if rbBackup.Checked then begin // Backup
    if FileExists(edBackupFile.Text) then begin
      if (mDlg('The Backup file exists; are you sure you want to overwrite it?', mtWarning, mbYesNo, 0) = mrNo)
      then begin
        ModalResult := mrNone;
        Exit;
      end
      else
        ModalResult := mrOK;
  // Restore
    end
    else // file does NOT exist
      ModalResult := mrOK;
  end
  else begin // Restore
    ModalResult := mrOK;
    if TrFileName = '' then TrFileName := GetTrFileName;
    if (Length(edRestoreFile.Text) = 0)
    or (not FileExists(edRestoreFile.Text))
    or (RightStr(edRestoreFile.Text, Length('.tdf' + BACKUP_EXT)) <> '.tdf' + BACKUP_EXT)
    then begin
      Hide;
      mDlg('You must select a valid Tradelog Backup file to restore from.', mtError, [mbOK], 0);
      ModalResult := mrNone;
      exit;
    end;
    Hide;
    if mDlg('Restore File: ' + TrFileName + CR //
      + CR //
      + 'Are you sure you want to restore this file?' //
     , mtWarning, mbYesNo, 0) = mrNo
    then begin
      Screen.Cursor := crDefault;
      ModalResult := mrNone;
      close;
      exit;
    end;
  end;
  if (ModalResult = mrOK) then begin
    if ckDefaultLocation.Checked then
      Settings.UserBackupDir := Settings.BackupDir;
  end;
end;

//-------------------------------------
// remove old backups; uses Open Dialog
//-------------------------------------
procedure TBackupRestoreDlg.btnRemoveClick(Sender: TObject);
var
  I: Integer;
  NotDeleted : String;
begin
  NotDeleted := '';
  DeleteFileDialog.InitialDir := Settings.UserBackupDir;
  DeleteFileDialog.Filter := 'TradeLog Backup File|*.tdf' + BACKUP_EXT;
  if DeleteFileDialog.Execute(self.Handle) then
   begin
    if mDlg('Are you sure you want to delete the following backup files?' + CR //
      + CR //
      + DeleteFileDialog.Files.Text, mtWarning, mbYesNo, 0) = mrYes then begin
      for I := 0 to DeleteFileDialog.Files.Count - 1 do
        if not DeleteFile(DeleteFileDialog.Files[I]) then
          NotDeleted := '  ' + DeleteFileDialog.Files[I];
      if Length(NotDeleted) > 0 then
        mDlg('The following file(s) could not be deleted!' + CR //
          + CR //
          + NotDeleted + CR //
          + CR //
          + 'Error: ' + GetLastErrorMessage(GetLastError), mtWarning, [mbOK], 0)
      else
        mDlg('Files Deleted Successfully!', mtInformation, [mbOK], 0);
    end;
  end;
end;

//-------------------------------------
// choose backup to restore from
//-------------------------------------
procedure TBackupRestoreDlg.btnRestoreClick(Sender: TObject);
var
  StartName : String;
  // ------------------------
  function AnySuchFileExists(const FileName : string): Boolean;
  // returns true if any file matching a standard DOS wildcard
  // specification exists on the specified path, false otherwise
  var
    SR : TSearchRec;
  begin
    Result := False;
   if FindFirst(FileName, faAnyFile, SR) = 0 then begin
      Result := True;
      FindClose(SR);
    end;
  end;
  // ------------------------
begin
  OpenRestoreFile.InitialDir := Settings.BackupDir;
  OpenRestoreFile.DefaultExt := '.tdf' + BACKUP_EXT;
  OpenRestoreFile.Filter := 'TradeLog Backup File|*.tdf' + BACKUP_EXT;
  if (TrFileName <> '') then begin
    StartName := TradeLogFile.FileName;
    StartName := ParseFirst(StartName, '.');
    if not AnySuchFileExists(Settings.BackupDir +'\'+ StartName + '*.tdf' + BACKUP_EXT)
    then begin
      mDlg('No backup file exists for this file', mtInformation, [mbOK], 0);
      close;
      exit;
    end;
  end;
  OpenRestoreFile.FileName := StartName + '*' + OpenRestoreFile.DefaultExt;
  // use Open File Dialog
  if OpenRestoreFile.Execute(self.Handle) then begin
    if not (StrUtils.StartsStr(StartName, ExtractFileName(OpenRestoreFile.FileName))) then
    begin
      mDlg('Sorry the file you choose must start with' + CR //
        + 'the name of the file your are restoring: ' + CR //
        + CR //
        + StartName + CR //
        + CR //
        + 'Please Try Again!', mtError, [mbOK], 0);
      exit;
    end;
    Settings.UserBackupDir := ExtractFilePath(OpenRestoreFile.FileName);
    if not VerifyV5OrGreaterData(OpenRestoreFile.FileName) then begin
      mDlg('Sorry this is not a valid TradeLog File' + CR //
        + CR //
        + 'Please Try Again!', mtError, [mbOK], 0);
      exit;
    end;
    edRestoreFile.Text := OpenRestoreFile.FileName;
    FBackupFileName := edRestoreFile.Text;
    if trim(edRestoreFile.Text) = '' then begin
      btnOk.Enabled := false;
    end
    else begin
      btnOk.Enabled := true;
      btnOK.Click;
    end;
  end;
end;

//-------------------------------------
// add date to backup filename?
//-------------------------------------
procedure TBackupRestoreDlg.ckAddDateClick(Sender: TObject);
begin
  Settings.UserBackupDate := ckAddDate.Checked;
  GetBackupFileName;
end;

//-------------------------------------
// compute BackupFileName from TrFileName
//-------------------------------------
function TBackupRestoreDlg.GetBackupFileName: String;
var
  DateStr : String;
  Y, M, D, H, Min, Sec, MSec : Word;
  Month, Day : String;
  function TwoDigits(Value : Integer) : String;
  begin
    Result := IntToStr(Value);
    if Length(Result) = 1  then
      Result := '0' + Result;
  end;
begin
  FBackupFileName := TrFileName;
  if Settings.UserBackupDate then
  begin
    DecodeDate(Now, Y, M, D);
    DecodeTime(Now, H, min, Sec, MSec);
    DateStr := '-' + IntToStr(Y) + '-' + TwoDigits(M) + '-' + TwoDigits(D) + '-' + IntToStr(H) + IntToStr(Min) + IntToStr(Sec);
    Insert(DateStr, FBackupFileName, Pos('.tdf', FBackupFileName));
  end;
  FBackupFileName := FBackupFileName + BACKUP_EXT;
  lbBackupDataFile.Caption := FBackupFileName;
  edBackupFile.Text := Settings.BackupDir + '\' + FBackupFileName;
end;

//-------------------------------------
// compute TrFileName from BackupFileName
//-------------------------------------
function TBackupRestoreDlg.GetTrFileName: String;
var
  s : String;
  i : integer;
begin
  if TrFileName = '' then
  begin
    // remove path
    FBackupFileName := ExtractFileName(FBackupFileName);
    // ex: 2014 Taxpayer Name-2015-01-24-171831.tdf-Backup
    s := FBackupFileName;
    s := ReverseString(s);
    // remove .td*-Backup
    delete(s,1,pos('dt.',s)+2);
    // remove date/time stamp if it exists
    if isNumeric(LeftStr(s,4)) then
    begin
      // delete time and date
      for i := 1 to 4 do
      if (pos('-',s)>0) then
        delete(s,1,pos('-',s));
    end;
    s := ReverseString(s);
    Result := s + '.tdf';    //sm(Result);
  end else
  begin
    result := TrFileName; // don't change it
  end;
end;

//-------------------------------------
// If OK was clicked, this happens as
// the form is closing (Execute code)
//-------------------------------------
procedure TBackupRestoreDlg.SaveData;
var
  BackupFile, RestoreFile : String;
begin
  Screen.Cursor := crHourGlass;
  try
    BackupFile := Settings.DataDir + '\' + TrFileName;
    if rbBackup.Checked then
    begin // Backup
      RestoreFile := edBackupFile.Text;
      if (CopyFile(PChar(BackupFile), PChar(RestoreFile), False)) then
        mDlg('Backup Complete!', mtInformation, [mbOK], 0)
      else
        mDlg('Error Occured: ' + GetLastErrorMessage(GetLastError), mtError, [mbOK], 0);
    end
    else
    begin // Restore
      RestoreFile := edRestoreFile.Text;
      if (CopyFile(PChar(RestoreFile), PChar(BackupFile), False)) then
      begin
        //mDlg('Restore Complete!', mtInformation, [mbOK], 0);
        if isDBfile or not taxidVer then
          OpenTradeLogFile(BackupFile);
      end
      else
        mDlg('Error Occured: ' + GetLastErrorMessage(GetLastError), mtError, [mbOK], 0);
    end;
  finally
    Screen.Cursor := crDefault;
  end;
end;

//-------------------------------------
// setup components from settings, etc.
//-------------------------------------
procedure TBackupRestoreDlg.SetupForm;
begin
  if (TradeLogFile = nil) then
    TrFileName := ''
  else
  try
    TrFileName := TradeLogFile.FileName;
  except
    TrFileName := '';
  end;
  if (TrFileName = '') then begin // Splash is open so only option is to restore
    btnBackup.Enabled := false;
    ckAddDate.Enabled := false;
    ckDefaultLocation.Enabled := false;
    edBackupFile.Text := '';
    lbBackupDataFile.Caption := '';
    lbCurrentDataFile.Caption := '';
    rbBackup.Enabled := false;
    rbRestore.Checked := true;
    btnOk.Enabled := false;
  end
  else begin // Splash is not open, so TrFile is selected
    lbCurrentDataFile.Caption := TradeLogFile.FileName;
    ckAddDate.Checked := Settings.UserBackupDate;
    GetBackupFileName;
    Caption := 'Data Dir: ' + Settings.DataDir;
   end;
end;

end.
