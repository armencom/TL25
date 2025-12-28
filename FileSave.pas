unit FileSave;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ToolWin, ComCtrls, StdCtrls, ExtCtrls, cxButtons, cxControls,
  cxContainer, cxEdit, cxTextEdit, cxShellTreeView, cxShellBrowserDialog,
  cxShellListView, cxMaskEdit, cxDropDownEdit, cxShellComboBox, Grids,
  DirOutln, cxRadioGroup, cxGroupBox, cxGraphics, Menus,
  cxLookAndFeelPainters, BaseDialog,
  // For Shell Dialogs
  ShlObj, activeX, cxLookAndFeels, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver, dxGDIPlusClasses, cxImage,
  cxHyperLinkEdit;
type
  TdlgFileSave = class(TBaseDlg)
    pnlAMain: TPanel;
    pnlcFileName: TPanel;
    pnlxPassword: TPanel;
    pnlySelect: TPanel;
    pnlzButtons: TPanel;
    lblTaxReturn: TLabel;
    lblTaxYear: TLabel;
    cboProTaxYear: TcxComboBox;
    lblTaxpayer: TLabel;
    lblTaxpayerTip: TLabel;
    lblTaxpayerName: TLabel;
    txtTaxpayer: TcxTextEdit;
    btnSelFolder: TcxButton;
    txtFolderName: TLabel;
    lblFileFolderHdr: TLabel;
    lbFileLocation: TLabel;
    lbTaxYear: TLabel;
    lblMustBe: TLabel;
    cboTaxYear: TcxComboBox;
    lbAcctName: TLabel;
    txtFileName: TcxTextEdit;
    btnOK: TcxButton;
    btnCancel: TcxButton;
    btnHelp: TcxButton;
    txtEmail: TcxTextEdit;
    cxImage1: TcxImage;
    lblRegCustomer: TLabel;
    Label2: TLabel;
    lblHyperLink1: TLabel;
    btnEmail: TButton;
    // --------------------------------
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    // --------------------------------
    procedure btnSelFolderClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    // --------------------------------
    procedure txtTaxpayerEnter(Sender: TObject);
    procedure txtTaxpayerExit(Sender: TObject);
    // --------------------------------
    procedure cboProTaxYearPropertiesChange(Sender: TObject);
    // --------------------------------
    procedure lblHyperLink1Click(Sender: TObject);
    procedure lblHyperLink1MouseEnter(Sender: TObject);
    procedure lblHyperLink1MouseLeave(Sender: TObject);
    procedure btnEmailClick(Sender: TObject);
  private
    { Private declarations }
    FTaxYear : Integer;
    FFileName : String;
    FFolder : String;
    FPassword : String;
    //function SaveData : Boolean;
    procedure SetupForm(bNew:boolean=false);
  public
    { Public declarations }
   class function Execute(var iTaxYear:Integer; var sFileName:String; var sFolder:String; bNew:boolean=false): TModalResult; overload;
  end;

  function ShCallback(hWnd : THandle; uMsg : integer;
    lParam, lpData : DWord) : integer; stdcall;

const
  sDefaultTaxpayerName = 'John Q Public';
  sDefaultCorporateName = 'Corporation Name';
  sDefaultFileName = 'Descriptive Text';


implementation
{$R *.DFM}
uses
  FuncProc, TLSettings, TLCommonLib, TLFile, TLWinInet, //
  TLRegister, myInput, globalVariables;

var
  bFileNew : boolean;
  bSettingUpForm : boolean; // 2017-02-16 MB


procedure TdlgFileSave.btnEmailClick(Sender: TObject);
begin
  inherited;
    txtEmail.Text := inputbox('Update Email Address',
      'Please enter the correct email address:',
      txtEmail.Text);
end;


procedure TdlgFileSave.btnHelpClick(Sender: TObject);
begin
  if pos('Create New',caption)=1 then
    webURL(supportSiteURL + 'hc/en-us/articles/115004349254')
  else
    webURL(supportSiteURL + 'hc/en-us/articles/115004469113');
end;


procedure TdlgFileSave.btnOKClick(Sender: TObject);
var
  TaxYear, fname, s, sFileCode : String;
  bExit : boolean;
begin
  bExit := false;
  msgTxt := '';
  // check for valid Tax Year
  if taxidVer then
    TaxYear:= trim(cboProTaxYear.text)
  else
    TaxYear:= trim(cboTaxYear.text);
  // --------------
  if (TaxYear = '') then begin
    msgTxt := 'Please select a Tax Year for this data file';
  end
  else if not IsInt(TaxYear) then begin
    msgTxt := 'Current Tax Year must be a valid 4 digit number!';
  end;
  if (msgTxt <> '') then begin
    mDlg(msgTxt, mtError, [mbOK, mbCancel], 0);
    ModalResult := mrNone;
    exit;
  end;
  FTaxYear := StrToInt(TaxYear);
  // get FileName or Taxpayer name
  if taxidVer then begin
    // make taxpayer name first char uppercase
    fName := trim(txtTaxpayer.Text);
    s := 'File';
  end
  else begin
    s := 'File';
    fName := trim(txtFileName.Text);
  end;
  // check if name is blank or default
  if (fname = '')
  or (fname = sDefaultTaxpayerName)
  or (fName = sDefaultCorporateName)
  or (fName = sDefaultFileName) then begin
    if taxidVer then begin
      msgTxt := 'Please enter your taxpayer name.' + cr + cr
        + 'This is the name you will be using on your Tax return';
    end
    else begin
      msgTxt := 'Please enter a descriptive name for your file.' + cr;
    end;
  end
  // check if using valid chars
  else if not IsValidFileName(fname) then begin
    msgTxt := 'Invalid ' + s + ' name:  ' + fname + cr + cr + 'A valid ' + s
      + ' name can only contain letters, numbers, spaces, apostrophes, and periods.';
  end;
  if (msgTxt <> '') then begin
    if taxidVer then begin
      // remove invalid chars
      s := txtTaxpayer.text;
      if (pos('Invalid', msgTxt) > 0) then
        txtTaxpayer.text := ReformatInvalidFileName(s);
      txtTaxpayer.SetFocus;
      txtTaxpayer.Text := '';
    end
    else begin
      s := txtFileName.text;
      txtFileName.text := DelNonAlpha(s);
      txtFileName.SetFocus;
    end;
    mDlg(msgTxt, mtError, [mbOK, mbCancel], 0);
    ModalResult := mrNone;
    exit;
  end;
  if mDlg('IMPORTANT!' +cr+cr+
    'You entered: "' + fname +'" as your Taxpayer name.' +cr+cr+
    'Is this the name you want to appear on your tax return?' +cr+cr+
    'If not, then click NO and enter the correct Taxpayer name.' +cr
    , mtWarning, [mbYes, mbNo], 0) <> mrYes
  then begin
    ModalResult := mrNone;
    exit;
  end;
  // ----- check/fix filename; fixed 2016-11-29 MB
  if not isInt(copy(fName,1,4)) then FFileName := TaxYear + ' ' + fName;
  if pos(FFileName,'.tdf')=0 then FFileName := FFileName + '.tdf';
  // ----- only concerned if they are changing the name -----
  if not (TradeLogFile=nil) then begin
  if (FFileName <> TradeLogFile.FileName) then begin // the name was changed
    sFileCode := TaxpayerExists(v2ClientToken, TaxYear + ' ' + fName);
    if (sFileCode <> '') then begin
      // option to overwrite or cancel
      if mDlg(FFileName + cr + 'has already been registered.'
        + cr + cr + 'You cannot have more than one file' + cr
        + ' for a given Taxpayer per tax year.' + cr + cr
        + 'Would you like to overwrite the existing file?',
        mtWarning, [mbYes, mbNo], 0) <> mrYes then
      begin
        // overwrite
      end
      else begin // cancel
        ModalResult := mrNone;
        exit;
      end;
    end;
  end;
  end;
  // --------------------------------------------------------
  FFolder := txtFolderName.Caption;
  // now that we know we aren't going to cancel, update ProHeader, Settings
  ProHeader.TDFpassword := '';
  // save pro header lines
  ProHeader.taxFile := txtTaxpayer.Text;
  Settings.NameOnReports := ProHeader.taxFile;
  ProHeader.taxpayer := '';
  ProHeader.email := txtEmail.Text; // update file header at next save
  v2ClientEmail := txtEmail.Text; // ...but update memory NOW!
//  Settings.SSN := txtSSNEIN.Text;
end;


procedure TdlgFileSave.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
  if taxidVer then begin
    if cboProTaxYear.Enabled then
      cboProTaxYear.SetFocus
    else
      txtTaxpayer.SetFocus;
  end
  else begin
    if cboTaxYear.Enabled then
      cbotaxYear.SetFocus
    else
      txtFileName.SetFocus;
  end;
end;


procedure TdlgFileSave.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TdlgFileSave.btnSelFolderClick(Sender: TObject);
var
  BrowseInfo : TBrowseInfo;
  IconIndex : integer;
  PtrIDL : PItemIdList;
  UsrMsg : string;
  TempPath : array[0..MAX_PATH] of char;
begin
  if bSettingUpForm then exit; // 2017-02-16 MB
  //Shell New-Style Dialog : User Resizable, limited modifications possible
  FillChar(BrowseInfo, SizeOf(TBrowseInfo), #0);
  IconIndex := 0;
  UsrMsg := crlf + crlf + 'New TradeLog data folder:';
  with BrowseInfo do begin
    hwndOwner := Self.Handle;
    PIDLRoot := nil;
    pszDisplayName := nil;
    lpszTitle := Pchar(UsrMsg);
    ulFlags := BIF_USENEWUI;
    lpfn := @ShCallback;
    lParam := integer(Self); // this object's reference
    iImage := IconIndex;
  end;
  CoInitialize(nil); //Initialize COM for Shell Browse function
  PtrIDL := ShBrowseForFolder(BrowseInfo); //Dialog Executes
  if PtrIDL <> nil then begin //User has returned a path
    TempPath := '';
    ShGetPathFromIDLIst(PtrIDL, TempPath);
    if DirectoryExists(TempPath) then begin
      Settings.DataDir := TempPath;
      txtFolderName.caption:= TempPath;
    end
    else
      sm('Selection not valid. Please retry.');
  end;
end;


procedure TdlgFileSave.cboProTaxYearPropertiesChange(Sender: TObject);
var
  s, t : string;
begin
  if bFileNew then exit; // disable for File\New
  if bSettingUpForm then exit; // 2017-02-16 MB
  // generates a reset code based on today's date
  s := generateFilePW;
  inherited;
  if not SuperUser and (cboProTaxYear.Text <> IntToStr(FTaxYear)) then begin
    t := 'Please enter the TaxYear code you received' + CR
      + 'from TradeLog Technical Support.' + CR;
    frmInput.display('Verify Tax Year Change', t, '', false);
    if (s <> frmInput.inputStr) then begin
      beep;
      cboProTaxYear.Text := IntToStr(FTaxYear);
    end;
  end;
end;


class function TdlgFileSave.Execute(var iTaxYear: Integer; var sFileName, sFolder: String; bNew:boolean=false): TModalResult;
begin
  with Create(nil) do begin
    bFileNew := bNew;
    FTaxYear := iTaxYear;
    FFileName := sFileName;
    FFolder := sFolder;
    if not bNew then FPassword := ProHeader.TDFpassword;
    SetupForm(bNew);
    Result := showModal;
    if Result = mrOK then begin
      iTaxYear := FTaxYear;
      sFileName := FFileName;
      sFolder := FFolder;
    end;
  end;
end;


function ShCallback(hWnd: THandle; uMsg: Integer; lParam, lpData: DWord)
  : Integer; stdcall;
var
  WorkArea, WindowSize: Trect;
  BFFWidth, BFFHeight, FLeft, FTop: Integer;
  TempStr: string;
begin
  Result := 0;
  case uMsg of
  BFFM_INITIALIZED:
    begin
      // Center Dialog on Screen}
      GetWindowRect(hWnd, WindowSize);
      with WindowSize do begin
        BFFWidth := Right - Left;
        BFFHeight := Bottom - Top;
      end;
      // Get Screen Size
      SystemParametersInfo(SPI_GETWORKAREA, 0, @WorkArea, 0);
      with WorkArea do begin
        FLeft := (Right - Left - BFFWidth) div 2;
        FTop := (Bottom - Top - BFFHeight) div 2;
      end;
      SetWindowPos(hWnd, HWND_TOP, FLeft, FTop, 0, 0, SWP_NOSIZE);
      // Change Caption & Set Initial Directory
      TempStr := 'Set default folder for your TradeLog data files';
      SendMessage(hWnd, WM_SETTEXT, 0, Integer(pchar(TempStr)));
      SendMessage(hWnd, BFFM_SETSELECTION, Integer(LongBool(true)),
        Integer(pchar(Settings.DataDir)));
    end;
  end;
end;


procedure TdlgFileSave.FormShow(Sender: TObject);
var
  MyHeight : integer;
begin
  if taxidVer then begin
    if (FFileName = '') then
      txtTaxpayer.Text := sDefaultTaxpayerName;
    pnlcFileName.Hide;
    pnlAMain.Show;
    height := 330;
  end
  else height := 226;
//  panelQS.doQuickStart(1,2);
end;


// ------------------------------------
//        lblHyperLink1
// ------------------------------------
procedure TdlgFileSave.lblHyperLink1Click(Sender: TObject);
begin
  inherited;
  webURL(supportSiteURL + 'hc/en-us/articles/4403915562647');
end;

procedure TdlgFileSave.lblHyperLink1MouseEnter(Sender: TObject);
begin
  inherited;
  lblHyperLink1.Font.Style := [fsUnderline];
end;

procedure TdlgFileSave.lblHyperLink1MouseLeave(Sender: TObject);
begin
  inherited;
  lblHyperLink1.Font.Style := [];
end;


// ------------------------------------------------------------------
// NOTE: An Employer Identification Number (EIN) is a 9-digit number
// that IRS assigns in the following format: XX-XXXXXXX.
// The Social Security number (SSN) is also a 9-digit number
// in the format "AAA-GG-SSSS".
// ------------------------------------------------------------------
procedure TdlgFileSave.SetupForm(bNew : boolean = false);
var
  Y, M, D : Word;
  i, L : Integer;
  S : string;
begin
  // 2017-02-16 MB special case of bSettingUpForm
  if bSettingUpForm then exit; // non-reentrant code!
  bSettingUpForm := true;
  // ----- TaxYear -----
  cboTaxYear.Text := IntToStr(FTaxYear);
  DecodeDate(Now, Y, M, D);
  if (FTaxYear > Y) then Y := FTaxYear;
  for i := Y downto Y-10 do begin
    cboTaxYear.properties.Items.Add(intToStr(i));
    cboProTaxYear.properties.Items.Add(intToStr(i));
  end;
  // ----- Taxpayer/IsEIN ---------------------------------
  // 2017-02-16 MB simplified logic:
  // 1) IF it's not a taxId file,      use Settings.IsEIN
  // 2) IF ProHeader.IsEIN = 1,        set rbEIN
  // 3) ELSE IF Length(taxpayer) > 6,  set rbSSN
  // 4) ELSE                           set rbNone
  // ------------------------------------------------------
  if (bNew)                                //              Special Case: New
  and ((SuperUser) or (ProVer)) then begin //              for another user
    txtEmail.text := '';
  end
  else if NOT isDBFile then begin //                       no ProHeader
    txtEmail.Text := v2UserEmail; // from API
  end
  // --- use ProHeader ----------------
  else begin
    txtEmail.Text := ProHeader.email; //                   email from file
  end; // if DBFile or not
  // ----- TaxFile -----
  if Length(FFileName) > 0 then begin
    Caption := 'Edit File';
    txtFileName.Text := FFileName;
    txtTaxpayer.Text := FFileName;
    cboProTaxYear.ItemIndex := cboProTaxYear.Properties.Items.IndexOf(intToStr(FTaxYear));
  end
  else begin
    Caption := 'Create New File';
    txtFileName.Text := '';
    i := 0;
    if (M < 10) then i := 1;
    cboTaxYear.itemIndex:= i;
    cboProTaxYear.itemIndex:= i;
  end;
  txtFolderName.Caption := FFolder;
  // ----- Password -----
  bSettingUpForm := false; // done
end;


procedure TdlgFileSave.txtTaxpayerEnter(Sender: TObject);
begin
  inherited;
  if bSettingUpForm then exit; // 2017-02-16 MB
  if (txtTaxpayer.Text = sDefaultTaxpayerName) then
    txtTaxpayer.Text := '';
end;


procedure TdlgFileSave.txtTaxpayerExit(Sender: TObject);
begin
  inherited;
  if bSettingUpForm then exit; // 2017-02-16 MB
  txtTaxpayer.Text := ReformatInvalidFileName(txtTaxpayer.Text);
end;


end.
