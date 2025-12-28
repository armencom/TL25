unit AccountSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, //
  Forms, Dialogs, StdCtrls, Menus, ExtCtrls, BaseDialog, //
  TLImportFilters, TLFile, //
  RzButton, RzRadChk, RzLabel, RzPanel, RzRadGrp,  RzCmboBx, //
  cxGraphics, cxControls, cxContainer, cxEdit, cxTextEdit, //
  cxMaskEdit, cxDropDownEdit, cxButtons, cxLookAndFeels, //
  cxCurrencyEdit, cxLookAndFeelPainters, //
  dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TdlgAccountSetup = class(TBaseDlg)
    pnlButtons: TPanel;
    btnCancel: TcxButton;
    btnOK: TcxButton;
    pnlName: TPanel;
    lbAccountName: TStaticText;
    edAccountName: TcxTextEdit;
    pnlAcctType: TPanel;
    pnlBroker: TPanel;
    lbImportFilter: TStaticText;
    cboImpFilt: TcxComboBox;
    StaticText1: TStaticText;
    lbAccountInformation: TStaticText;
    ckAutoAssignShorts: TRzCheckBox;
    ckSLConvert: TRzCheckBox;
    lbReadOnly: TRzLabel;
    rbGrpAccountType: TRzRadioGroup;
    ckMTMLastYear: TRzCheckBox;
    lblMTMPlug: TRzLabel;
    ckMTMForFutures: TRzCheckBox;
    pnlImpMethod: TPanel;
    stBase: TStaticText;
    cboBaseCurrency: TcxComboBox;
    txtComm: TStaticText;
    edComm: TcxCurrencyEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure cboImpFiltPropertiesEditValueChanged(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure cboImpFiltPropertiesChange(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edAccountNameExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure rbGrpAccountTypeChanging(Sender: TObject; NewIndex: Integer;
      var AllowChange: Boolean);
    procedure rbGrpAccountTypeClick(Sender: TObject);
    procedure ckSLConvertClick(Sender: TObject);
    procedure ckAutoAssignShortsClick(Sender: TObject);
    procedure edAccountNameKeyPress(Sender: TObject; var Key: Char);
    procedure lbImportFilterClick(Sender: TObject);
  private
    FAcctHasNoRecords : Boolean;
    FFileHasMTMLastYear : Boolean;
    FFileHasMTMThisYear : Boolean;
    FFileHeader : TTLFileHeader;
    FLoading : Boolean;
    FChangingImpFilter : Boolean;
    procedure SetupForm;
    procedure SaveData;
    procedure setupImpFilter;
  public
    { Public declarations }
    class function Execute(TheHeader : TTLFileHeader;
      NoRecords : Boolean = true;
      HasMTMThisYear : Boolean = false;
      HasMTMLastYear : Boolean = false;
      ACaption : String = ''
    ) : TModalResult; overload;
  end;

implementation

{$R *.dfm}

uses Main, TLSettings, TLCommonLib, FuncProc, globalVariables;

var
  SLConvClicked, doOnce : Boolean;


procedure TdlgAccountSetup.setupImpFilter;
var
  ImportFilter : TTLImportFilter;
  Locale : TTLLocInfo;
  formHeight : integer;
  bPnlVisible : boolean;
begin
  formHeight := height;
  bPnlVisible := (pnlImpMethod.Visible); // 2017-02-03 MB - replaced IF THEN ELSE with :=
  if cboImpFilt.ItemIndex > -1 then begin
    ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
    //Setup Base Currency Symbol
    stBase.Visible := ImportFilter.SupportsFlexibleCurrency;
    cboBaseCurrency.Visible := ImportFilter.SupportsFlexibleCurrency;
    stBase.Enabled := ImportFilter.SupportsFlexibleCurrency and FAcctHasNoRecords;
    cboBaseCurrency.Enabled := ImportFilter.SupportsFlexibleCurrency and FAcctHasNoRecords;
    if cboBaseCurrency.Visible and LocaleInfoList.TryGetValue('1033', Locale) then
      cboBaseCurrency.EditText := Locale.Country + ' (' + Locale.CurrencySymbol + ')'
    else
      cboBaseCurrency.Text := 'United States ($)';
    pnlImpMethod.Visible := cboBaseCurrency.Visible or edComm.Visible;
    //Setup Commission.
    txtComm.Visible := ImportFilter.SupportsCommission;
    edComm.Visible := ImportFilter.SupportsCommission;
    edComm.EditValue := 0.00;
  end;
end;


procedure TdlgAccountSetup.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
  cboImpFilt.SetFocus;
end;


procedure TdlgAccountSetup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TdlgAccountSetup.FormCreate(Sender: TObject);
var
  ImportFilter : TTLImportFilter;
  Locale : TTLLocInfo;
  myFile : textfile;
  text : string;
begin
  FLoading := True;
  FChangingImpFilter := False;
  // ----------------------------------
  for ImportFilter in ImportFilters.Values do begin
    cboImpFilt.Properties.Items.AddObject(ImportFilter.ListText, ImportFilter);
  end;
  // ----------------------------------
  for Locale in LocaleInfoList.Values do
  if True then
    if cboBaseCurrency.Properties.Items.IndexOf(
      Locale.Country + ' (' + Locale.CurrencySymbol + ')') = -1
    then
      cboBaseCurrency.Properties.Items.AddObject(
        Locale.Country + ' (' + Locale.CurrencySymbol + ')', Locale);
  stBase.Visible := False;
  cboBaseCurrency.Visible := False;
  cboBaseCurrency.ItemIndex := -1;
  edComm.Visible := False;
  txtComm.Visible := False;
  edComm.Text := '0.00';
  edAccountName.Text := '';
  rbGrpAccountType.Buttons[2].Enabled := Settings.MTMVersion;
  ckMTMLastYear.Visible := Settings.MTMVersion;
  ckMTMForFutures.Visible := Settings.MTMVersion;
  ckMTMLastYear.Enabled := False;
  if not Settings.MTMVersion then begin
    lblMTMPlug.Visible := True;
    lblMTMPlug.Left := ckMTMLastYear.Left;
    lblMTMPlug.Top := ckMTMLastYear.Top;
  end;
end;


procedure TdlgAccountSetup.FormShow(Sender: TObject);
var
  ImportFilter : TTLImportFilter;
begin
  doOnce:= false;
  ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
  FLoading := False;
  if not glbAccountEdit then exit;
  // use account tab text
  if (TradeLogFile.CurrentAccount.AccountName <> '')
  or (bImportingAccounts and (edAccountName.Text <> '')) then
    edAccountName.Text := TradeLogFile.CurrentAccount.AccountName
  else if (cboImpFilt.text <> '') then
    edAccountName.Text := ImportFilter.FilterName
  else
    edAccountName.Text := '';
end;


procedure TdlgAccountSetup.lbImportFilterClick(Sender: TObject);
var
  ImportFilter : TTLImportFilter;
  Locale : TTLLocInfo;
  myFile : textfile;
  text : string;
begin
  inherited;
  // ------------------------
  if SuperUser then begin
    assignfile(myFile, Settings.SettingsDir + '\ImpFilters.txt');
    try
      rewrite(myFile);
      text := 'BrokerCode'
       + tab + 'FilterName'
       + tab + 'ListText'
       + tab + 'ImportFunction'
       + tab + 'ImportMethod'
       + tab + 'InstructPage'
       + tab + 'ImportFileExtension'
       + tab + 'BaseCurrLCID'
       //
       + tab + 'AssignShortBuy'
       + tab + 'AutoAssignShorts'
       + tab + 'AutoAssignShortsOptions'
       + tab + 'BrokerHasTimeOfDay'
       + tab + 'SLConvert'
       + tab + 'SupportsFlexibleAssignment'
       + tab + 'SupportsCommission'
       + tab + 'SupportsFlexibleCurrency'
       //
       + tab + 'FixShortsOOOrder'
       + tab + 'ForceMatchStocks'
       + tab + 'ForceMatchOptions'
       + tab + 'ForceMatchFutures'
       + tab + 'ForceMatchCurrencies';
      writeln(myFile, text);
      // --------------------------------
      for ImportFilter in ImportFilters.Values do begin
        text := ImportFilter.BrokerCode
         + tab + ImportFilter.FilterName
         + tab + ImportFilter.ListText
         + tab + ImportFilter.ImportFunction
         + tab + inttostr(ImportFilter.ImportMethod)
         + tab + ImportFilter.InstructPage
         + tab + ImportFilter.ImportFileExtension
         + tab + inttostr(ImportFilter.BaseCurrLCID)
         //
         + tab + booltostr(ImportFilter.AssignShortBuy)
         + tab + booltostr(ImportFilter.AutoAssignShorts)
         + tab + booltostr(ImportFilter.AutoAssignShortsOptions)
         + tab + booltostr(ImportFilter.BrokerHasTimeOfDay)
         + tab + booltostr(ImportFilter.SLConvert)
         + tab + booltostr(ImportFilter.SupportsFlexibleAssignment)
         + tab + booltostr(ImportFilter.SupportsCommission)
         + tab + booltostr(ImportFilter.SupportsFlexibleCurrency)
         //
         + tab + booltostr(ImportFilter.FixShortsOOOrder)
         + tab + booltostr(ImportFilter.ForceMatchStocks)
         + tab + booltostr(ImportFilter.ForceMatchOptions)
         + tab + booltostr(ImportFilter.ForceMatchFutures)
         + tab + booltostr(ImportFilter.ForceMatchCurrencies);
        writeln(myFile, text);
      end; // for ImportFilter
    finally
      closefile(myFile);
    end;
  end; // if SuperUser
end;

procedure TdlgAccountSetup.btnOKClick(Sender: TObject);
var
  s: string;
begin
  // Make sure the account name onExit code runs to verify the account names
  // uniqueness; if they hit ENTER while on the account name field the onExit
  // will not get called for some reason - so let's call it here.
  // If the name is not unique then modalResult will have been set to none,
  // so if that is the case then exit the OK button as there is no further
  // need for checking until they resolve the unique name issue. - David Eich
  edAccountNameExit(Sender);
  if modalResult = mrNone then exit;
  // strip out Parenthesis from Account Name
  s := edAccountName.Text;
  while (pos('(',s)>0) do delete(s,pos('(',s),1);
  while (pos(')',s)>0) do delete(s,pos(')',s),1);
  edAccountName.Text := s;
  // Verify all Required fields have been filled in correctly.
  if Length(edAccountName.Text) = 0 then begin
    mDlg('You must provide an account name for this account.', mtError, [mbOK], 0);
    modalResult := mrNone;
    exit;
  end;
  if cboImpFilt.ItemIndex = -1 then begin
    mDlg('You must select an Import Filter before continuing.', mtError, [mbOK], 0);
    modalResult := mrNone;
    exit;
  end;
  if cboBaseCurrency.Visible and (cboBaseCurrency.ItemIndex = -1) then begin
    mDlg('You must select a Base Currency before continuing.', mtError, [mbOK], 0);
    modalResult := mrNone;
    exit;
  end;
end;


procedure TdlgAccountSetup.cboImpFiltPropertiesChange(Sender: TObject);
var
  ImportFilter : TTLImportFilter;
begin
  FChangingImpFilter := True;
  try
    cboImpFiltPropertiesEditValueChanged(Sender);
    ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
    // 2015-09-10 fix for crappy brokers
    if not doOnce then begin
      if  (FFileHeader.TaxYear > '2011') and (ImportFilter.FilterName = 'TOS') then begin
        doOnce := true;
        webURL(supportSiteURL + 'hc/en-us/sections/115001078413'); // 2019-01-25 MB
        mDlg('For tax years greater than 2011 you must use the TDAmeritrade import filter.'
          ,mtWarning, [mbOK], 0);
        cboImpFilt.ItemIndex := cboImpFilt.Properties.Items.IndexOf('TDAmeritrade');
        ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
      end;
      if (ImportFilter.FilterName = 'optionsHouse') then begin
        doOnce := true;
        mDlg('optionsHouse users must now use the E*Trade import filter.', mtWarning, [mbOK], 0);
        cboImpFilt.ItemIndex := cboImpFilt.Properties.Items.IndexOf('E*Trade Financial (ETrade)');
        ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
      end;
    end;
    ckSLConvert.Checked := ImportFilter.SLConvert;
    ckAutoAssignShorts.ReadOnly := not ImportFilter.SupportsFlexibleAssignment;
    lbReadOnly.Visible := ckAutoAssignShorts.ReadOnly;
    ckAutoAssignShorts.Checked := ImportFilter.AutoAssignShorts;
    if not bImportingAccounts then begin
      if (edAccountName.Text = '') then
        edAccountName.Text := ImportFilter.FilterName;
    end;
  finally
    FChangingImpFilter := False;
    doOnce:= false;
  end;
end;


procedure TdlgAccountSetup.cboImpFiltPropertiesEditValueChanged(Sender: TObject);
begin
  setupImpFilter;
end;


procedure TdlgAccountSetup.ckAutoAssignShortsClick(Sender: TObject);
begin
  if Not FLoading and not FChangingImpFilter and not slConvClicked
  and ckAutoAssignShorts.Checked then
    if mDlg('If no long trades are open, sales will import as "open, short"' + cr
          + 'and if short trades are open, buys will import as "close, short." ' + CR + CR
          + 'Are you sure you want to do this?', mtConfirmation, [mbYes, mbNo], 0) = mrNo
    then
      ckAutoAssignShorts.Checked := False;
  if not ckAutoAssignShorts.Checked then ckSLConvert.Checked := false;
end;


procedure TdlgAccountSetup.ckSLConvertClick(Sender: TObject);
begin
  inherited;
  if FLoading or FChangingImpFilter then exit;
  SLConvClicked := true;
  if ckSLConvert.Checked then begin
    if mDlg('A single buy transaction will close' + cr
      + 'a short trade and open a new long trade,' + cr + cr + 'and' + cr + cr
      + 'a single sell transaction will close' + cr
      + 'a long trade and open a new short trade.' + cr + cr
      + 'Are you sure you want to do this?', mtConfirmation, [mbYes, mbNo], 0) = mrNo
    then
      ckSLConvert.Checked := false;
  end
  else begin
    ckSLConvert.Checked := false;
  end;
  SLConvClicked := false;
end;


procedure TdlgAccountSetup.edAccountNameExit(Sender: TObject);
var
  s : string;
begin
  if ModalResult = mrCancel then exit;
  if Not FLoading then begin
    s := edAccountName.Text;
    if (Length(s) = 0) and (TradeLogFile <> Nil) then exit;
    // ---------------------------------- TradeLog doesn't allow ( )
    while (pos('(',s)>0) do delete(s,pos('(',s),1); // chars not allowed
    while (pos(')',s)>0) do delete(s,pos(')',s),1); // in Acct Tab Name!
    // ---------------------------------- Windows illegal characters:
    //                                    \ / : * ? " < > |
    while (pos('\',s)>0) do delete(s,pos('\',s),1); // chars not allowed
    while (pos('/',s)>0) do delete(s,pos('/',s),1); // in Acct Tab Name!
    while (pos(':',s)>0) do delete(s,pos(':',s),1); // in Acct Tab Name!
    while (pos('*',s)>0) do delete(s,pos('*',s),1); // in Acct Tab Name!
    while (pos('?',s)>0) do delete(s,pos('?',s),1); // chars not allowed
    while (pos('"',s)>0) do delete(s,pos('"',s),1); // in Acct Tab Name!
    while (pos('<',s)>0) do delete(s,pos('<',s),1); // chars not allowed
    while (pos('>',s)>0) do delete(s,pos('>',s),1); // in Acct Tab Name!
    while (pos('|',s)>0) do delete(s,pos('|',s),1); // chars not allowed
    // ----------------------------------
    edAccountName.Text := s;
    if (Length(s) > 0) and (TradeLogFile <> Nil) //
    and (not TradeLogFile.VerifyUniqueAccountName(s, FFileHeader.BrokerID)) //
    then begin
      mDlg('Broker Name must be unique!' + CR //
        + 'Please try again.', mtError, [mbOK], 0);
      edAccountName.Text := FFileHeader.AccountName + '-' + IntToStr(FFileHeader.BrokerID);
      modalResult := mrNone;
      edAccountName.SetFocus;
      edAccountName.SelectAll;
    end;
  end;
end;


procedure TdlgAccountSetup.edAccountNameKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key = ')') or (Key = '(') then Key := #0;
end;


class function TdlgAccountSetup.Execute(
  TheHeader : TTLFileHeader;
  NoRecords : Boolean;
  HasMTMThisYear : Boolean;
  HasMTMLastYear : Boolean;
  ACaption : String
  ): TModalResult;
begin
  with self.Create(nil) do begin
    if Length(ACaption) > 0 then Caption := ACaption;
    FAcctHasNoRecords := NoRecords;
    FFileHasMTMLastYear := HasMTMLastYear;
    FFileHasMTMThisYear := HasMTMThisYear;
    FFileHeader := TheHeader;
    SetupForm;
    Result := ShowModal;
    if Result = mrOK then SaveData;
  end;
end;


procedure TdlgAccountSetup.rbGrpAccountTypeChanging(Sender: TObject; NewIndex: Integer;
  var AllowChange: Boolean);
var
  Msg : String;
begin
  AllowChange := True;
  if Not FAcctHasNoRecords then begin
    Msg := '';
    if (rbGrpAccountType.ItemIndex in [0..1]) and (NewIndex = 2) then begin //Going To MTM
      if (Date > StrToDate('04/17/' + TaxYear)) then
        Msg := 'In order to switch an account to MTM after April 17th' + CR +
          'you must have made an election with your current year taxes, also' + CR;
      // end if
      Msg := Msg + 'Changing from Cash or IRA to MTM will require that we create MTM Data!' + CR
        + CR + 'Are you sure you want to do this?';
      AllowChange := mDlg(msg, mtWarning, [mbYes, mbNo], 0) = mrYes;
    end
    else if (rbGrpAccountType.ItemIndex = 2) and Not (ckMTMLastYear.Checked) then
      //Coming From MTM with M Records
      AllowChange := mDlg('Changing from MTM to another account type will'
        + ' require that we delete all MTM Data!' + CR + CR
        + 'Are you sure you want to do this?', mtWarning, [mbYes, mbNo], 0) = mrYes
  end;
end;


procedure TdlgAccountSetup.rbGrpAccountTypeClick(Sender: TObject);
begin
  ckMTMLastYear.Enabled := (rbGrpAccountType.ItemIndex = 2) and (FAcctHasNoRecords or (FFileHeader.MTM));
  ckMTMForFutures.Enabled := (rbGrpAccountType.ItemIndex = 2);
  if not ckMTMLastYear.Enabled then begin
    ckMTMLastYear.Checked := False;
    ckMTMForFutures.Checked := False;
  end;
end;


procedure TdlgAccountSetup.SaveData;
var
  ImportFilter : TTLImportFilter;
  Locale : TTLLocInfo;
begin
  FFileHeader.AccountName := edAccountName.Text;
  if rbGrpAccountType.Buttons[0].Checked then begin        //Cash
    FFileHeader.MTM := False;
    FFileHeader.Ira := False;
    FFileHeader.MTMLastYear := False;
    FFileHeader.MTMForFutures := False;
  end
  else if rbGrpAccountType.Buttons[1].Checked then begin   //IRA
    FFileHeader.MTM := False;
    FFileHeader.Ira := True;
    FFileHeader.MTMLastYear := False;
    FFileHeader.MTMForFutures := False;
  end
  else if rbGrpAccountType.Buttons[2].Checked then begin   //MTM
    FFileHeader.MTM := True;
    FFileHeader.Ira := False;
    FFileHeader.MTMLastYear := ckMTMLastYear.Checked;
    FFileHeader.MTMForFutures := ckMTMForFutures.Checked;
  end;
  ImportFilter := TTLImportFilter(cboImpFilt.ItemObject);
  FFileHeader.FileImportFormat := ImportFilter.FilterName;
  // --------------
  if ImportFilter.SupportsFlexibleCurrency then begin
    Locale := TTLLocInfo(cboBaseCurrency.ItemObject);
    FFileHeader.BaseCurrencyLocale := Locale.LCID;
  end
  else
    FFileHeader.BaseCurrencyLocale := EnglishUS;
  // end if
  if ImportFilter.SupportsCommission then
    FFileHeader.Commission := StrToFloat(edComm.Text)
  else
    FFileHeader.Commission := 0;
  // end if
  FFileHeader.SLConvert := ckSLConvert.Checked;
  FFileHeader.AutoAssignShorts := ckAutoAssignShorts.Checked;
end;


procedure TdlgAccountSetup.SetupForm;
var
  ImportFilter: TTLImportFilter;
  Locale: TTLLocInfo;
  I: Integer;
begin
  edAccountName.Text := RemoveParens(FFileHeader.AccountName);
  rbGrpAccountType.Buttons[2].Enabled := Settings.MTMVersion;
  ckMTMLastYear.Visible := Settings.MTMVersion;
  ckMTMLastYear.Enabled := false;
  ckMTMForFutures.Visible := Settings.MTMVersion;
  ckMTMForFutures.Enabled := false;
  rbGrpAccountType.Buttons[1].Enabled := not FFileHasMTMThisYear;
  rbGrpAccountType.Buttons[0].Enabled := not FFileHasMTMThisYear;
  if FFileHasMTMThisYear then
    rbGrpAccountType.Buttons[2].Hint :=
      'You must reverse end of year processing in order to change the account type'
  else if FFileHasMTMLastYear then
    rbGrpAccountType.Buttons[2].Hint :=
      'Changing from MTM to another account type will require that we delete all MTM Data!';
  rbGrpAccountType.Buttons[1].Checked := FFileHeader.Ira;
  if Settings.MTMVersion then rbGrpAccountType.Buttons[2].Checked := FFileHeader.MTM;
  if ckMTMLastYear.Visible then
    ckMTMLastYear.Checked := FFileHeader.MTM and FFileHeader.MTMLastYear;
  if ckMTMForFutures.Visible then
    ckMTMForFutures.Checked := FFileHeader.MTM and FFileHeader.MTMForFutures;
  rbGrpAccountType.Buttons[0].Checked := not FFileHeader.Ira and not FFileHeader.MTM;
  // If the import Filter is valid then we are good.
  if ImportFilters.TryGetValue(FFileHeader.FileImportFormat, ImportFilter) then begin
    for I := 0 to cboImpFilt.Properties.Items.Count - 1 do begin
      if cboImpFilt.Properties.Items[I] = ImportFilter.ListText then begin
        cboImpFilt.ItemIndex := I;
        break;
      end;
    end;
    // ------------
    if ImportFilter.SupportsFlexibleCurrency
    and LocaleInfoList.TryGetValue(IntToStr(FFileHeader.BaseCurrencyLocale), Locale) then
      cboBaseCurrency.EditText := Locale.Country + ' (' + Locale.CurrencySymbol + ')'
    else
      cboBaseCurrency.Text := 'United States ($)';
    // end if
    if ImportFilter.SupportsCommission then
      edComm.EditValue := FloatToStr(FFileHeader.Commission)
    else
      edComm.EditValue := '0.00'
    // end if
  end
  else
    cboImpFilt.ItemIndex := -1;
  // end if
  // Assign these last since assigning the Import Filter above will change the values
  ckAutoAssignShorts.Checked := FFileHeader.AutoAssignShorts;
  ckSLConvert.Checked := FFileHeader.SLConvert;
end;


end.
