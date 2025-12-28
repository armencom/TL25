unit ImportSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, //
  Forms, StrUtils, StdCtrls, Menus, Dialogs, ExtCtrls, BaseDialog, //
  TLImportFilters, TLFile, //
  RzButton, RzRadChk, RzLabel, RzPanel, RzRadGrp, RzCmboBx, //
  cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit, cxLabel, //
  cxListBox, cxMaskEdit, cxDropDownEdit, cxButtons, cxLookAndFeels, //
  cxCurrencyEdit, cxLookAndFeelPainters, //
  dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, //
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TdlgImportSetup = class(TBaseDlg)
    pnlBroker: TPanel;
    pnlButtons: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    edBroker: TcxTextEdit;
    lblBroker: TcxLabel;
    edAcctName: TcxTextEdit;
    lblAcctName: TcxLabel;
    pnlPlaid: TPanel;
    cboAcctName: TcxComboBox;
    lblInstructions: TLabel;
    btnFastLink: TcxButton;
    pnlCredentials: TPanel;
    lblPwd: TcxLabel;
    edPwd: TcxTextEdit;
    edUser: TcxTextEdit;
    lblUser: TcxLabel;
    cboAcctId: TcxComboBox;
    Label2: TLabel;
    btnUnlink: TcxButton;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SetupCboPlaid;
    procedure btnFastLinkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnUnlinkClick(Sender: TObject);
    procedure cboAcctNamePropertiesChange(Sender: TObject);
    procedure edUserExit(Sender: TObject);
    procedure cboAcctIdClick(Sender: TObject);
  private
    FFileHeader : TTLFileHeader;
    FLoading : Boolean;
    FChangingImpFilter : Boolean;
    procedure SaveData;
    procedure setupImpFilter;
  public
    { Public declarations }
    class function Execute(TheHeader : TTLFileHeader; ACaption : String = '') : TModalResult; overload;
  end;

implementation

{$R *.dfm}

uses
  Main, TLSettings, TLCommonLib, FuncProc, TLWinInet, //
  TL_API, TL_Passiv, //
  globalVariables, clipbrd;

var
  bIsLinked : Boolean; // does this tab have a valid AccountId?
  // --------------
  sPassivAcctId : string; // TDF[2] = Account Id (stored in TDF)
  sBrokerName : string; // TDF[7] = FileImportFormat in TDF header
  sClientName : string; // TDF[13].[2] = OFXUserName => TL:<v2CustomerId>
  sTabCaption : string; // TDF[17] = caption of account tab (in TDF)
  // --------------
  sPassivBrokerId : string; // = GetPassivBrokerId()
  // ------------------------
  sAccts, sAcct : TStrings;
  iNDX : integer;


// --------------------------------------------------------
// Get user's accounts from API, load into combobox
// Assumes we already have: v2ClientToken, sClientName,
//   sPassivAcctId, sBrokerName, sPassivBrokerId
// --------------------------------------------------------
procedure TdlgImportSetup.SetupCboPlaid;
var
  s, t, sAcct1 : string;
  i, j, k, nClientState : integer;
  sTmp, sLine : string;
  BrokerLst, AcctLst, lineLst : TStrings;
begin
  try // --- only Fastlinkable ----------------
    screen.Cursor := crHourglass;
    try
    // Basic logic for TradeLog:
    // If the client exists but is not "TL",
    // - warn the user about relinking
    // - delete any brokers attached to the old client
    // - delete the old client
    // - change it to "TL"
    // If the client = "TL" but doesn't exist, create it
    t := CheckPassivClient(v2ClientToken, sClientName); // is it in Passiv?
    if (pos('"status":"success","message":"Client exists."', t) > 0) then begin
      if sClientName <> 'TL' then begin
        s := 'To continue using BrokerConnect, we need you' + CRLF //
           + 'to update your connection. This will require' + CRLF //
           + 'you to re-link this broker. Are you ready to' + CRLF //
           + 'do that now?';
        if mdlg(s, mtWarning, mbYesNo, 0) <> mrYes then exit;
        DeleteBrokerLink(v2ClientToken, sClientName, sPassivBrokerId); //
        bIsLinked := false;
        DeletePassivClient(v2ClientToken, sClientName);
      end;
    end;
    // ----- force all Client Names to be TL:<cusomerId> -----
    if sClientName <> 'TL' then sClientName := 'TL'; // set all to 'TL'
    t := CheckPassivClient(v2ClientToken, sClientName); // is it in Passiv?
    // ----------------------------------------------------
    // ----- if TL:<customerId> exists, load combo box ----
    // ----------------------------------------------------
    if (pos('"status":"success","message":"Client exists."', t) > 0) then begin
      s := GetListPassivAccts(v2ClientToken, sClientName);
      if (s = '') then begin
        if sClientName = '' then
          sPassivAcctId := 'need username to link accounts to.'
        else
          sPassivAcctId := 'no accounts setup.';
        cboAcctName.Properties.Items.AddObject(sPassivAcctId, sAcct);
        cboAcctName.Text := sPassivAcctId;
        cboAcctName.Enabled := false;
      end
      else if (POS('ERROR', uppercase(s)) > 0) //
      or (POS('"STATUS":"FAIL"', uppercase(s)) > 0) then begin
        sPassivAcctId := 'no accounts setup yet.';
        cboAcctName.Properties.Items.AddObject(sPassivAcctId, sAcct);
        cboAcctName.Text := sPassivAcctId;
        cboAcctName.Enabled := false;
      end
      else begin // good data, we think
        cboAcctName.Enabled := true;
        // This is how accounts JSON comes from Passiv:
        // [{ "id":"939267b6-22c3-4a45-8e97-1dc6f56a56d8",
        //    "name":"Robinhood Individual",
        //    "number":"417582921",
        //    "broker":"9bc5bdd4-4944-468e-ba1e-628bd7d6ad44"
        // },...]
        if leftstr(s,1) = '[' then
          s := parseBetween(s, '[', ']');
        AcctLst := ParseJSON(s); // , '[', ']');
        j := 0;
        bIsLinked := false;
        for i := 0 to AcctLst.count - 1 do begin
          t := AcctLst[i];
          lineLst := ParseV2APIResponse(t);
          if lineLst.Count < 7 then continue;
          if lineLst[7] = sPassivBrokerId then begin
            if (lineLst[5] <> '') then begin
              if isnumber(lineLst[5]) then begin
                TradeLogFile.CurrentAccount.OFXAccount := lineLst[5];
                sAcct1 := lineLst[3] + ' ' + lineLst[5];
              end else begin
                sAcct1 := lineLst[3];
              end;
            end;
            cboAcctName.Properties.Items.AddObject(sAcct1, lineLst);
            cboAcctId.Properties.Items.Add(lineLst[1]); // AcctId
            if lineLst[1] = sPassivAcctId then begin
              k := j; // account_id (before inc j)
              bIsLinked := true;
              iNDX := k;
              cboAcctId.Text := sPassivAcctId; // jump to it!
              cboAcctName.Text := lineLst[3];
              cboAcctId.ItemIndex := k;
              cboAcctName.ItemIndex := k;
            end;
          end;
          inc(j);
        end; // for i loop
        if (cboAcctName.properties.items.Count < 1 ) then begin // not found
          sPassivAcctId := 'no accounts setup yet.';
          cboAcctName.Properties.Items.AddObject(sPassivAcctId, sAcct);
          cboAcctName.Text := sPassivAcctId;
          cboAcctName.Enabled := false;
        end;
        btnUnlink.Enabled := true; // (bIsLinked or bBrokerDisabled or Developer);
      end;
    end; // end if no broker/client
    // --------------------------------
    except
      on E : Exception do begin
        sm('ERROR setting up data ' + CRLF //
          + E.ClassName + ': ' + E.Message);
      end;
    end;
  finally //
    screen.Cursor := crDefault; // release mouse
  end;
end; // TdlgImportSetup.SetupCboPlaid;


// ----------------------------------------------
// Load data from TDF headers (unchanging)
// ----------------------------------------------
procedure TdlgImportSetup.setupImpFilter;
var
  Locale : TTLLocInfo;
  bPnlVisible : boolean;
  s : string;
  ht : long;
begin
  // --- set up dialog ------
  ht := 347; // starting  height
  lblInstructions.Caption := 'Select the linked broker account associated with this account tab (or link it):';
  if (SuperUser and (DEBUG_MODE > 3)) // only visible to SuperUsers who are actively debugging,
  or (SuperUser and (v2UserEmail = DEBUG_EMAIL)) // or MarkB
  or Developer then begin // or all Developers
    cboAcctId.Visible := true;
    pnlPlaid.Height := 125;
    pnlCredentials.Visible := true;
    edUser.Visible := true;
  end
  else begin
    cboAcctId.Visible := false;
    pnlPlaid.Height := 120;
    pnlCredentials.Visible := false;
    edUser.Visible := false;
  end;
  // --- Load from TDF ------
  sPassivAcctId := TradeLogFile.CurrentAccount.PlaidAcctId; // Broker Account Id
  sBrokerName := TradeLogFile.CurrentAccount.FileImportFormat;
  sClientName := TradeLogFile.CurrentAccount.OFXUserName;
  edUser.Text := sClientName; // 2024-11-12 MB
  if sClientName = '' then sClientName := 'TL'; // new default
  sTabCaption := TradeLogFile.CurrentAccount.AccountName;
  // --- Get from API -------
  try
    if (TradeLogFile.CurrentAccount.ImportFilter.FastLinkable) then begin
      sPassivBrokerId := GetPassivBrokerId(v2ClientToken, sClientName, sBrokerName);
    end;
  except
    sPassivBrokerId := '';
  end;
  // --- pnlBroker ----------
  edBroker.Text := sBrokerName;
  edAcctName.Text := sTabCaption;
  // --- pnlCredentials -----
  edUser.Text := sClientName;
  edPwd.Text := TradeLogFile.CurrentAccount.OFXPassword;
  // ------------------------
  // 1. Passiv; 2. IB; 3. Non-BC
  // ------------------------
  if (TradeLogFile.CurrentAccount.ImportFilter.FastLinkable) then begin
    pnlPlaid.Visible := true;
    if bBrokerDisabled then begin
      cboAcctName.Enabled := false;
      lblInstructions.Caption := 'Please re-link the broker account associated with this account tab:';
      sm('Connection disabled by provider.' + CRLF //
       + 'Please refresh link.');
    end
    else begin
      lblInstructions.Caption := 'Select the linked broker account associated with this account tab:';
      SetupCboPlaid;
    end;
    if not (SuperUser or Developer) then begin
      pnlCredentials.Visible := false; // don't need it
    end;
    edPwd.Visible := false; // password is not used for Passiv
    lblPwd.Visible := false; //
  end // --------------------
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'IB' then begin
    pnlPlaid.Visible := false;
    ht := ht - pnlPlaid.Height; //
    edPwd.Visible := true; // password is visible for IB
    lblPwd.Visible := true; //
    edPwd.Enabled := true; // password is enabled for IB
    pnlCredentials.Visible := true;
    edUser.Text := TradeLogFile.CurrentAccount.OFXUserName;
    edPwd.Text := TradeLogFile.CurrentAccount.OFXPassword;
  end // --------------------
  else begin // other
    pnlPlaid.Visible := false;
    pnlCredentials.Visible := false;
  end; // if FastLinkable/IB/Other
  self.Height := ht + 5;
end; // TdlgImportSetup.setupImpFilter;


// ------------------------------------
// Save JSON data
// ------------------------------------
//procedure SaveJSONdata(sData : string);
//var
//  sFile, sTmp, ext, localFileName : string;
//  localFile : textFile;
//begin
//  try
//    // get a unique name for the import backup file
//    sFile := TradeLogFile.CurrentAccount.FileImportFormat;
//    Delete(sFile, POS('*', sFile), 1);
//    Delete(sFile, POS(',', sFile), 1);
//    ext := TradeLogFile.CurrentAccount.ImportFilter.ImportFileExtension;
//    localFileName := Settings.ImportDir + '\' + sFile + '_' //
//      + formatdatetime('yyyymmdd-hhmmss', now)+ '.JSON.txt'; //
//    // --- Open the file ----
//    AssignFile(localFile, localFileName);
//    Rewrite(localFile);
//    // --- add appropriate line breaks for easy reading ---
//    sTmp := FormatV2APIResponse(sData);
//    // --- finish -----------
//    write(localFile, sTmp);
//    CloseFile(localFile);
//  except
//    On E : Exception do begin
//      if SuperUser then begin
//        mDlg('Unable to save JSON data to file' + CR //
//          + localFileName + CR //
//          + 'Error Message: ' + E.Message + CR //
//          + '(click OK to continue.)', mtError, [mbOK], 0);
//      end; // if
//    end; // on E
//  end; // try...except
//end; // SaveJSONdata


// ----------------------------------------------
// Form Events
// ----------------------------------------------
procedure TdlgImportSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TdlgImportSetup.FormCreate(Sender : TObject);
begin
  if Settings.TrialVersion then begin
    mDlg('Sorry, BrokerConnect is currently' + CR
     + 'not available for free trial users.'
     + CR
     + 'Please use another import method.',
     mtWarning, [mbOK], 0);
     exit;
  end;
  FLoading := True;
  FChangingImpFilter := False;
  setupImpFilter;
end;

procedure TdlgImportSetup.FormShow(Sender: TObject);
begin
  FLoading := False;
  if not glbAccountEdit then exit;
end;

// ----------------------------------------------
// button events
// ----------------------------------------------

// ---------------+
//     CANCEL     |
// ---------------+
procedure TdlgImportSetup.btnCancelClick(Sender: TObject);
begin
  inherited;
  ModalResult := mrCancel;
end;

// ---------------+
//      LINK      |
// ---------------+
procedure TdlgImportSetup.btnFastLinkClick(Sender: TObject);
var
  sLoginName, sURL, s, sData : string;
  ETZ : TDateTime;
begin
  inherited;
  ETZ := GetEasternTime; // e.g. 1/25/2022 10:58:35 AM
  // --------------
  if v2ClientToken = '' then begin
    mDlg('Customer not found in BrokerConnect database' + CR //
      + 'Please contact Customer Support.', mtWarning, [mbOK], 0);
    Exit;
  end;
  // --------------
  if Settings.TrialVersion then begin
    mDlg('Sorry, BrokerConnect is currently' + CR
     + 'not available for free trial users' + CR
     + 'with this financial institution.' + CR
     + CR
     + 'Please use another import method.',
     mtWarning, [mbOK], 0);
  end
  else begin
    // https://docs.snaptrade.com/docs/fix-broken-connections
    if not bIsLinked and not bBrokerDisabled then begin
      s := CreatePassivClient(v2ClientToken, sClientName); //
    end; // if bBrokerDisabled it just needs refreshing!
    sData := GetPassivBrokerLink(v2ClientToken, sClientName); //
    LaunchPassivLink(sData, sClientName);
  end;
  Close; // form close
end;


// ---------------+
//       OK       |
// ---------------+
procedure TdlgImportSetup.btnOKClick(Sender: TObject);
var
  s : string;
begin
  if modalResult = mrNone then exit;
  // Save changes to header record
  if (sClientName <> TradeLogFile.CurrentAccount.OFXUserName) then begin
    TradeLogFile.CurrentAccount.OFXUserName := sClientName;
    s := CreatePassivClient(v2ClientToken, sClientName); // try to create new client now!
  end;
  TradeLogFile.CurrentAccount.PlaidAcctId := sPassivAcctId;
  modalResult := mrOK;
end;

// ---------------+
//     UNLINK     |
// ---------------+
procedure TdlgImportSetup.btnUnlinkClick(Sender: TObject);
var
  s : string;
begin
  inherited;
  if TradeLogFile = nil then exit;
  if bIsLinked then begin
    DeleteBrokerLink(v2ClientToken, sClientName, sPassivBrokerId); //
    bIsLinked := false;
    btnUnlink.Enabled := false;
    SetupCboPlaid;
  end; // EX: <token>, 'zaronan', '3ca2249b-b246-40bf-bcc7-adef262fff0e'
end;


// ------------------------------------
procedure TdlgImportSetup.cboAcctIdClick(Sender: TObject);
begin
  inherited;
  iNDX := cboAcctId.ItemIndex; // update AcctId
end;

procedure TdlgImportSetup.cboAcctNamePropertiesChange(Sender: TObject);
begin
  inherited;
  cboAcctId.ItemIndex := cboAcctName.ItemIndex; // update AcctId
end;


// ------------------------------------
//  edUser text box events
// ------------------------------------
procedure TdlgImportSetup.edUserExit(Sender: TObject);
begin
  inherited;
  // same as clicking OK
  TradeLogFile.CurrentAccount.OFXUserName := edUser.Text;
  FLoading := True;
  FChangingImpFilter := False;
  setupImpFilter;
end;


// ------------------------------------
//
// ------------------------------------
class function TdlgImportSetup.Execute(
  TheHeader : TTLFileHeader;
  ACaption : String
  ): TModalResult;
begin
  with self.Create(nil) do begin
    FFileHeader := TheHeader;
    if Length(ACaption) > 0 then Caption := ACaption;
//    SetupForm;
    Result := ShowModal;
    if Result = mrOK then SaveData;
  end;
end;


procedure TdlgImportSetup.SaveData;
//var
//  Locale : TTLLocInfo;
begin
  FFileHeader.PlaidAcctId := cboAcctId.Text; //
end;


end.
