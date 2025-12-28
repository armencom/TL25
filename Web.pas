unit Web;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, WebDelay,
  OleCtrls, SHDocVw, msHTML, ComCtrls, StdCtrls, Buttons, ExtCtrls, ToolWin,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMemo, cxRichEdit, Menus,
  cxLookAndFeelPainters, cxButtons, cxGraphics, cxLookAndFeels, RzButton,
  dxSkinsCore, dxSkinBlack, dxSkinBlue, dxSkinBlueprint, dxSkinCaramel,
  dxSkinCoffee, dxSkinDarkRoom, dxSkinDarkSide, dxSkinDevExpressDarkStyle,
  dxSkinDevExpressStyle, dxSkinFoggy, dxSkinGlassOceans, dxSkinHighContrast,
  dxSkiniMaginary, dxSkinLilian, dxSkinLiquidSky, dxSkinLondonLiquidSky,
  dxSkinMcSkin, dxSkinMoneyTwins, dxSkinOffice2007Black, dxSkinOffice2007Blue,
  dxSkinOffice2007Green, dxSkinOffice2007Pink, dxSkinOffice2007Silver,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver,
  dxSkinPumpkin, dxSkinSeven, dxSkinSevenClassic, dxSkinSharp, dxSkinSharpPlus,
  dxSkinSilver, dxSkinSpringTime, dxSkinStardust, dxSkinSummer2008,
  dxSkinTheAsphaltWorld, dxSkinsDefaultPainters, dxSkinValentine, dxSkinVS2010,
  dxSkinWhiteprint, dxSkinXmas2008Blue;

type
  TfrmWeb = class(TForm)
    WebBrowser1: TWebBrowser;
    statusBar1: TPanel;
    lblStat: TLabel;
    cxRichEdit: TcxRichEdit;
    Panel2: TPanel;
    Panel3: TPanel;
    btnClose: TcxButton;
    tmrIB: TTimer;
    edURL: TLabel;
    tmrWebTimeout: TTimer;
    procedure btnCloseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnPrintClick(Sender: TObject);
    procedure spdCloseClick(Sender: TObject);
    procedure edURLClick(Sender: TObject);
    procedure spdBackClick(Sender: TObject);
    procedure WebBrowser1NewWindow2(ASender: TObject; var ppDisp: IDispatch;
      var Cancel: WordBool);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure WebBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure WebBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
    procedure WebAutoLogin;
    function ExecJavaScript(var HTMLWindow: IHTMLWindow2; const sJava : string): boolean; //
    procedure WebBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure tmrIBTimer(Sender: TObject);
    procedure tmrWebTimeoutTimer(Sender: TObject);
  private
    CurDispatch: IDispatch;
    FDocLoaded: Boolean;
  public
    { Public declarations }
  end;

const
  WM_REDIRECT = WM_USER + 100;

type
  TWebSelfPopup = class(TWinControl)
  private
     // Private declarations
     FBrowser:      TWebBrowser;
     FPopup:        TWebBrowser;
     FURL:          OleVariant;
     FFlags:        OleVariant;
     FTarget:       OleVariant;
     FPostData:     OleVariant;
     FHeaders:      OleVariant;
  protected
     // Protected declarations
     procedure      OnRedirect(var Message: TMessage); message WM_REDIRECT;
     procedure      OnBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
     procedure      OnNewWindow2(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
  public
     // Public declarations
     constructor    CreateHook(WebBrowser: TWebBrowser);
     destructor     Destroy; override;
  end;

var
  frmWeb,frmWebPopup: TfrmWeb;
  ETradeLoggedIn : boolean;
  WebSelfPopup: TWebSelfPopup;
  nextDateStart:TDate;
  dateStart, dateEnd: string;

procedure supportExpired;
procedure getWebPage(url:string);
procedure setupBrokerConnect(url,dtStart,dtEnd:string);
procedure getWebBrowserWindows;


implementation

uses Main, FuncProc, TLRegister, frmOFX, activeX, bcFunctions, strUtils, DateUtils, import,
  WebGet, clipbrd, variants, ShellApi, Httpapp, comObj, Tlhelp32, frmSendSupportFiles, TLSettings,
  TLCommonLib, TLFile, TLWinInet,
  TLLogging, securityQues,
  globalVariables;

const
  CODE_SITE_CATEGORY = 'WebForm';

var
  url, htmlTxt: string;
  viewstate, viewstate2, eventvalidation, URLpopup: string;
  brokerConnectRunning, transPageDone, doOnce, webStop, schwabSummary, exportDisclaimer: boolean;
  bLoggedIn : boolean;

{$R *.DFM}

          // ==============================================
          // Brokerage Screen Scrape Routines
          // note: use TWebbrowser to login,
          // then use WinInet to get csv data (if possible)
          // ==============================================

procedure scrapeTradestation(url, htmlTxt : string; wb : TWebBrowser);
var
  newDateStart, newDateEnd : string;
  i : integer;
  doc : IHTMLDocument2;
  cookies : tstringlist;
  sCookies : string;
  procedure getCookies;
  begin
    cookies := tstringlist.Create;
    doc := wb.Document as IHTMLDocument2;
    cookies.Add(doc.cookie);
    //do stuff with them
  end;
begin
  doc := wb.Document as IHTMLDocument2;
  sCookies := doc.cookie;
  // updated 2017-03-15
  if (DEBUG_MODE > 2) and SuperUser then begin
    clipboard.astext := url + cr + cr + sCookies; // htmlTxt;
    sm('SuperUser (ready to paste):' + CR + url);
  end;
  if webStop then exit;
  if (pos('Invalid username', htmlTxt)> 0) then begin
    webStop := true;
    sm ('Invalid user name and/or password.');
    frmWeb.hide;
    frmWeb.close;
    exit;
  end;
  // security question
  if (pos('Please provide the answer to the following security question', htmlTxt) > 0)
  or (pos('SecondFactor/SecurityQuestion?', URL)>0)  // added 2016-10-04
  or (pos('Enter your security code', URL)>0) // added 2016-11-15 MB
  then begin
    exit;
  end
  // 1. NEW login 2016-10-04
  else if  (pos('Login?response_type=',URL)>0) then begin
    if (DEBUG_MODE > 3) and SuperUser then begin
      clipboard.astext := htmlTxt;
      sm('SuperUser (ready to paste):' + CR + 'Login (web.pas 140).');
    end;
    if (pos('password not found', htmlTxt)> 0) then exit;
    doOnce := false;
    wb.OleObject.Document.All.Item ('UserName').value := TradeLogFile.CurrentAccount.OFXusername;
    wb.OleObject.Document.All.Item ('Password').value := TradeLogFile.CurrentAccount.OFXpassword;
    wb.OleObject.Document.Forms.item(0).submit();
  end
  // 2. If we got here we have a successful login - go to Account page
  else if not doOnce then begin
    if (DEBUG_MODE > 2) and SuperUser then begin
      clipboard.astext := htmlTxt;
      sm('SuperUser (ready to paste):' + CR //
        + 'successful login (web.pas 170)' + CR + url);
    end;
    doOnce := true;
    frmWeb.lblStat.Caption := 'Successfully logged in';
    wb.Navigate('https://clientcenter.tradestation.com/support/myaccount/Equities/TaxCenter.aspx');
  end
  // 3. submit request for csv file
  else if (pos('https://clientcenter.tradestation.com/support/myaccount/Equities/TaxCenter.aspx', URL)= 1)
  then begin
    // check for correct account number
    webgetdata := readURL ('https://clientcenter.tradestation.com/support/myaccount/EACS.aspx');
    if (pos('>' + TradeLogFile.CurrentAccount.OFXAccount + '<', webgetdata) = 0) then begin
      webStop := true;
      sm ('Invalid account number.');
      frmWeb.hide; frmWeb.close; exit;
    end;
    // reformat from-to dates
    newDateStart := rightStr (dateStart, 4)+ '-' + leftStr (dateStart, 2)+ '-' + midStr (dateStart, 4, 2);
    newDateEnd := rightStr (dateEnd, 4)+ '-' + leftStr (dateEnd, 2)+ '-' + midStr (dateEnd, 4, 2);
    // sm(newDateStart+cr+newdateEnd);
    // get Trade History cvsv file
    webgetdata := readURL (
      'https://clientcenter.tradestation.com/api/v1/Equities/TaxCenterDownload/'
      + TradeLogFile.CurrentAccount.OFXAccount
      + '/TradeLogCsv/'
      + newDateStart + '/' + newDateEnd
      + '/false/All/All');
    // test for correct file format
    if pos ('Account Number,Type', webgetdata) > 0 then begin
      saveImportAsFile (webgetdata, dateStart, dateEnd, Settings.InternalFmt);
      repaintGrid;
      frmWeb.close;
    end
    // --
    else begin
      webgetdata := '';
      frmWeb.close;
    end;
    exit;
  end;
end;

          // ==============================================
          // <-- End - brokerage screen scrape routines
          // ==============================================

procedure WebPause(const ADelay : LongWord);
var
  StartTC : DWORD;
  CurrentTC : Int64;
begin
  StartTC := GetTickCount;
  repeat
    Application.ProcessMessages;
    CurrentTC := GetTickCount;
    if CurrentTC < StartTC then
      // tick count has wrapped around: adjust it
      CurrentTC := CurrentTC + High(DWORD);
  until CurrentTC - StartTC >= ADelay;
end;


function GetFormByName(document: IHTMLDocument2; const formName: string): IHTMLFormElement;
var
  forms: IHTMLElementCollection;
begin
  forms := document.Forms as IHTMLElementCollection;
  result := forms.Item(formName,'') as IHTMLFormElement
end;


procedure TWebSelfPopup.OnRedirect(var Message: TMessage);
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab')
  then exit;
  //
  // this redirects all popup windows to the current web browser
  //
  // Perform the navigation
  FBrowser.Navigate2(FURL, FFlags, FTarget, FPostData, FHeaders);
end;


procedure TWebSelfPopup.OnBeforeNavigate2(ASender: TObject; const pDisp: IDispatch; const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab')
  then exit;
  // Capture the values
  FURL:=URL;
  FFlags:=FLags;
  FTarget:=NULL;
  FPostData:=PostData;
  FHeaders:=Headers;
  // Cancel
  Cancel:=True;
  // Post a message to ourselves
  PostMessage(Handle, WM_REDIRECT, 0, 0);
end;


procedure TWebSelfPopup.OnNewWindow2(Sender: TObject; var ppDisp: IDispatch; var Cancel: WordBool);
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then exit;
  // Direct the new window to our proxy
  ppDisp:=FPopup.ControlInterface;
end;


constructor TWebSelfPopup.CreateHook(WebBrowser: TWebBrowser);
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then exit;
  // Perform inherited
  inherited CreateParented(WebBrowser.Handle);
  // Set defaults
  FBrowser:=WebBrowser;
  FBrowser.OnNewWindow2:=OnNewWindow2;
  FPopup:=TWebBrowser.Create(FBrowser);
  FPopup.OnBeforeNavigate2:=OnBeforeNavigate2;
end;


destructor TWebSelfPopup.Destroy;
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then exit;
  // Clear the web browser interfaces
  FBrowser:=nil;
  FreeAndNil(FPopup);
  // Perform inherited
  inherited Destroy;
end;


procedure TfrmWeb.btnCloseClick(Sender: TObject);
begin
  cancelURL:=true;
  close;
end;

          // ==============================================
          // Form event handler routines
          // ==============================================

procedure TfrmWeb.FormActivate(Sender: TObject);
begin
  frmMain.enabled:=true;
  if (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then exit;
  WebSelfPopup:=TWebSelfPopup.CreateHook(WebBrowser1);
end;


procedure TfrmWeb.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.tmrFileDL.Enabled:=false;
  // make sure we are logged out
  if (TradeLogFile.CurrentAccount.FileImportFormat='Fidelity') and bLoggedIn then
    readURL('https://login.fidelity.com/ftgw/Fidelity/RtlCust/Logout/Init?AuthRedUrl=https://www.fidelity.com/tpv/logout_webxpress.shtml');
    bLoggedIn := false;
  statBar('off');
  try
    webbrowser1.stop;
  except
    // Just trying to clean up here and sometimes we have seen an Access
    // Violation by this component. So let's just capture this exception
    // and ignore it since it is meaningless.
  end;
  if not (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then WebSelfPopup.free;
  regCheck:=false;
  if TrFileName='' then disableMenuTools;
  repaintGrid;
  frmMain.BorderIcons:=[biSystemMenu,biMinimize,biMaximize];
  frmMain.SetMenuBarVisibility(true);
  frmMain.enabled:= true;
//  if settings.DispQS then panelQS.Show;
  action := caFree;
end;


procedure TfrmWeb.FormCreate(Sender: TObject);
begin
  parent:=frmMain;
end;


procedure TfrmWeb.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key=#13) then begin
    Keybd_Event(VK_LCONTROL, 0, 0, 0);    //Ctrl key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0), 0, 0); // 'M' key down
    Keybd_Event(Ord('M'), MapVirtualKey(Ord('M'), 0), KEYEVENTF_KEYUP, 0); // 'M' Key up
    Keybd_Event(VK_LCONTROL, 0, KEYEVENTF_KEYUP, 0); // Ctrl key up
  end
  else if (key=#27) then begin
    btnClose.click;
  end;
end;


procedure TfrmWeb.FormShow(Sender: TObject);
begin
  webBrowser1.Align := alClient;
  align:=alClient;
  frmMain.SetMenuBarVisibility(false);
  statusBar1.Color := tlYellow;
  frmMain.BorderIcons:=[];
  borderStyle:= bsNone;
  btnClose.Visible:=true;
  btnClose.Enabled:=true;
end;

          // ==============================================
          // Web Browser event handler routines
          // ==============================================

procedure TfrmWeb.WebBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  d: OleVariant;
begin
  d := WebBrowser1.Document;
    //if pos('Invalid',d.documentElement.outerHTML)>0 then sm('here');
  if CurDispatch = nil then CurDispatch := pDisp;
  frmWeb.edURL.caption:='  '+url+'  ';
end;


procedure TfrmWeb.WebBrowser1NewWindow2(ASender: TObject; var ppDisp: IDispatch;
  var Cancel: WordBool);
var
  Doc:  IHTMLDocument2;
  HTMLWindow: IHTMLWindow2;
  Document: IHTMLDocument2;
  iall: IHTMLElement;
begin
  if not (TradeLogFile.CurrentAccount.FileImportFormat='Charles Schwab') then exit;
  // a new instance of TfrmWeb will be created
  frmWebPopup := TfrmWeb.Create(self);
  ppDisp := frmWebPopup.WebBrowser1.application;
end;


procedure postScottrade(url,s1,s2,s3:string);
var
  EncodedDataString: string;
  PostData: OleVariant;
  Headers: OleVariant;
  i: integer;
begin
  // First, create a URL encoded string of the data
  EncodedDataString := HTTPEncode(s1)+'&'+
                       HTTPEncode(s2)+'&'+
                       HTTPEncode(s3);
  // The PostData OleVariant needs to be an array of bytes
  // as large as the string (minus the 0 terminator)
  PostData := VarArrayCreate([0, length(EncodedDataString)-1], varByte);
  // Now, move the Ordinal value of the character into the PostData array
  for i := 1 to length(EncodedDataString) do
    PostData[i-1] := ord(EncodedDataString[i]);
  Headers := 'Content-type: application/x-www-form-urlencoded'#10#13;
  // Parameters 2 and 3 are not used, thus EmptyParam is passed.
  frmWeb.WebBrowser1.Navigate(url, EmptyParam, EmptyParam, PostData, Headers);
end;


function GetFrameByName(ABrowser:TWebBrowser;aFrameName: string): IHTMLDocument2;
var
  searchdoc : IHTMLDocument2; // temporarily holds the resulting page
  FoundIt : boolean; // Flag if we found the right Frame
  // This is the inner recursive portion of the function
  function Enum (AHTMLDocument : IHTMLDocument2; aFrameName :string): Boolean;
  var
    OleContainer : IOleContainer;
    EnumUnknown : IEnumUnknown;
    Unknown : IUnknown;
    Fetched : LongInt;
    WebBrowser : IWebBrowser;
    FBase : IHTMLFrameBase;
  begin
    Result:=True;
   if not Assigned(AHtmlDocument) then exit;
   if not Supports(AHtmlDocument, IOleContainer, OleContainer) then exit;
   if Failed(OleContainer.EnumObjects(OLECONTF_EMBEDDINGS, EnumUnknown)) then exit;
   while (EnumUnknown.Next(1, Unknown, @Fetched)=S_OK) do begin
     if Supports(Unknown, IHTMLFrameBase,FBase) then begin
       // Here we ask if we have the right Frame
       if LowerCase(FBase.name) = LowerCase(aFrameName) then begin
         if Supports(Unknown, IWebBrowser, WebBrowser) then begin
           searchdoc := (WebBrowser.Document as IHTMLDocument2);
           FoundIt:=true;
           exit;
         end;
       end;
     end;
     if NOT (FoundIt) then begin
       if Supports(Unknown, IWebBrowser, WebBrowser) then begin
         Result:=Enum((WebBrowser.Document as IHtmlDocument2),aFrameName);
         if not Result then exit;
       end;
     end
     else
      exit;
   end;
  end;
begin
  FoundIt := false;
  result := nil; // just in case
  Enum((ABrowser.Document as IHTMLDocument2),aFrameName);
  if FoundIt then
    result := searchdoc
  else
    result := nil;
end;


function URLEncode(const S: string; const InQueryString: Boolean): string;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;


procedure webPost(URL:WideString; postData:string);
var
  Flags: OleVariant;
  TargetFrameName: OleVariant;
  PostDataOLE,headersOLE: OleVariant;
  Headers: string;
  i: Integer;
begin
  Flags := 12;           // Do not use the cache
  TargetFrameName := ''; // Not '' to open a new browser window
  //sm(urL+cr+postData);
  PostDataOLE := VarArrayCreate([0, Length(postData) - 1], varByte);
  // copy the ordinal value of the character into the PostData array
  for i := 1 to Length(PostData) do
    PostDataOLE[i-1] := Ord(PostData[i]);
  Headers := 'Content-Type: application/x-www-form-urlencoded' + #10#13;
  headersOLE := VarArrayCreate([0, Length(headers) - 1], varByte);
  // copy the ordinal value of the character into the headers array
  for i := 1 to Length(headers) do
    headersOLE[i-1] := Ord(headers[i]);
  frmWeb.WebBrowser1.Navigate(URL, Flags, TargetFrameName, PostDataOLE, headersOLE);
end;


function LoadFile(const FileName: TFileName): string;
begin
  with TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite) do begin
    try
      SetLength(Result, Size);
      Read(Pointer(Result)^, Size);
    except
      Result := '';  // Deallocates memory
      Free;
      raise;
    end;
    Free;
  end;
end;


procedure TfrmWeb.WebBrowser1BeforeNavigate2(ASender: TObject; const pDisp: IDispatch;
  const URL, Flags, TargetFrameName, PostData, Headers: OleVariant; var Cancel: WordBool);
begin
  if (TradeLogFile.CurrentAccount.FileImportFormat = 'Vanguard')
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity')
  then
    CurDispatch := nil;
  FDocLoaded := false;
end;


procedure TfrmWeb.WebAutoLogin; // need Username, Password
var
  Doc: IHTMLDocument2;
  i, j: Integer;
  Element: OleVariant;
  Elements: IHTMLElementCollection;
begin
  Doc := WebBrowser1.Document as IHTMLDocument2;
  Elements := Doc.All;
  J := 0;
  for i := 0 to Elements.length - 1 do begin
    Element := Elements.item(i, varEmpty);
    if (lowercase(Element.tagname) = 'input') then begin
      // You should check with the input name or id, in this case login
      if (Element.name = 'SSN') then begin // sUN) then // 'login') then
        Element.value := TradeLogFile.CurrentAccount.OFXUserName;
        j := j + 1;
      end;
      // You should check with the input name or id, in this case password
      if (Element.name = 'PIN') then begin
        Element.value := TradeLogFile.CurrentAccount.OFXpassword;
        j := j + 1;
      end;
      if j = 2 then begin
        WebBrowser1.OleObject.Document.Forms.item(0).submit();
        gBCImpStep := imBC_afterLogin;
        break;
      end;
    end; // if 'input'
  end; // for I
  bLoggedIn := true;
end;

function TfrmWeb.ExecJavaScript(var HTMLWindow: IHTMLWindow2; const sJava : string): boolean; //
var
  JSFn : string;
begin
  if not Assigned(HTMLWindow) then Exit;
  // Run JavaScript
  try
    HTMLWindow.execScript(sJava, 'JavaScript'); // execute function
    exit(true);
  except
    // handle exception in case JavaScript fails to run
    exit(false);
  end;
end;

procedure saveFidelityCSV(dateStart, dateEnd : string);
var
  sFileName : string;
  csvFile: TextFile;
begin
  sFileName := assignImpBackupFilename(dateStart, dateEnd, Settings.InternalFmt);
  if FileExists(sFileName) then deleteFile(sFileName);
  // write webGatData to file
  AssignFile(csvFile, sFileName);
  Rewrite(csvFile);
  write(csvFile, webGetData);
  closeFile(csvFile);
end;


// ========================================================
// Browser Event Handler: Document Complete
// fires when current web document is done loading
// ========================================================
procedure TfrmWeb.WebBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
var
  // **** NEED TO DELET UNUSED VARs
  Doc: IHTMLDocument2;
  docArray, loadingBox, inputFromLst, inputToLst, btnSetTimeLst, linkDownload: variant;
  HTMLWindow: IHTMLWindow2; // parent window of current HTML document
  theForm: IHTMLFormElement;
  Document: IHTMLDocument2;
  rbTestList: IHTMLElementCollection;
  rbTest: IHTMLOptionButtonElement;
  iall: IHTMLElement;
  S, e, htmlTxt, IBurl, TextStr, ETAcct, myViewState, myValidation, myActivityId, myPrintBuffer,
    monStr, dateEndOrig, fidAMC, newDateStart, newDateEnd, sJava, sCookies: string;
  i, j, k, x, numMonths, numDays: integer;
  yr, mon, day: word;
  formElements: OleVariant;
  isLessThanOneMon, loopOnce: Boolean;
  ole_index: OleVariant;
  doc_all: IHTMLElementCollection;
  frame_dispatch: IDispatch;
  frame_win: IHTMLWindow2;
  frame_doc: IHTMLDocument2;
  acctNum, strOfx, acct, CSRF_TOKEN: String;
  sGetURL, sAMC : string; // for Fidelity
  // ------------------------
  procedure twoDigityear;
  begin
    newDateStart := dateStart;
    newDateEnd := dateEnd;
    delete(newDateStart, 7, 2);
    delete(newDateEnd, 7, 2);
    // sm(newDateStart+cr+newDateEnd);
  end;
// --------------------------------------------------------
begin
//  if (DEBUG_MODE > 2) and SuperUser then sm('WebBrowser1DocumentComplete.' + CR + VarToStr(URL));
  try
    /// //these lines make sure all frames are loaded
    if (pDisp <> CurDispatch) then exit; // pDisp from NavigateComplete2
    CurDispatch := nil;
    FDocLoaded := true;
    // FBrowserDelay.UpdateEvent(deOtherEvent);
    // ----------------------
    with frmWeb do begin
      if Assigned(WebBrowser1.Document) then begin
        iall := (WebBrowser1.Document AS IHTMLDocument2).body;
        while iall.parentElement <> nil do
          iall := iall.parentElement;
        // needed to execute javascript
        Doc := WebBrowser1.Document as IHTMLDocument2;
//        sCookies := doc.cookie;
        HTMLWindow := Doc.parentWindow;
        htmlTxt := iall.outerHTML;
        TextStr := iall.outerText;
//        if (DEBUG_MODE > 3) and SuperUser then begin
//          clipboard.astext := htmlTxt;
//          sm('paste html text now');
//        end;
        if (pos('>No page to display<', htmlTxt)> 0) then exit;
        if (pos('The page cannot be displayed', htmlTxt)> 0) then begin
          mDlg('The page cannot be displayed' + cr
            + ' - Please try again later.', mtError,[mbOK], 1);
          webgetdata := 'cancel';
          exit;
        end
        else if (pos('Navigation to the webpage was cancel', htmlTxt)> 0) then begin
          mDlg('Navigation to the webpage was canceled' + cr
            + ' - Please try again later.', mtError,[mbOK],1);
          webgetdata := 'cancel';
          exit;
        end;
        ////// BrokerConnect code ///////
        if brokerConnectRunning then begin
          // added 2011-03-26 to trap EAccessViolation when no internet connection found.
          if pos('Internet Explorer cannot display the webpage', htmlTxt)> 0 then begin
            sm('TradeLog could not connect to '
              + TradeLogFile.CurrentAccount.FileImportFormat + cr //
              + cr //
              + 'Please see the message in the web browser window behind this popup message.');
            webgetdata := '';
            close;
            exit;
          end;
          frmWeb.edURL.Caption := '  ' + URL + '  ';
          // ***** NEED TO MAKE SCRAPE PROCEDURES FOR EACH BROKERAGE
          // (eg: scrapeTradestation)
          // ==============================================
          ////// Thinkorswim BrokerConnect code ///////
          // ==============================================
          if TradeLogFile.CurrentAccount.FileImportFormat = 'TOS' then begin
            if (pos('Unable to authorize access',htmlTxt)> 0) then begin
              mDlg('Unable to authorize access - Please call TDAmeritrade',
                mtError,[mbOK], 0);
              webgetdata := '';
              close;
              exit;
            end;
          // security question
            if (pos('https://wwws.ameritrade.com/cgi-bin/apps/SecurityChallenge',URL)= 1)
            then begin
              webgetdata := '';
              exit;
            end
          // add'l info
            else if (pos('Request for Additional Information',htmlTxt)> 1) then begin
              webgetdata := '';
              exit;
            end
          // wrong account #
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/LogIn?action=timeout',URL)=1)
            then begin
              mDlg('Invalid Account Number', mtError,[mbOK], 0);
              webgetdata := '';
              close;
              exit;
            end
          // login
            else if (pos('https://wwws.ameritrade.com/apps/LogIn',URL)=1) then begin
              WebBrowser1.OleObject.Document.All.Item('USERID').value := TradeLogFile.CurrentAccount.OFXusername;
              WebBrowser1.OleObject.Document.All.Item('PASSWORD').value := TradeLogFile.CurrentAccount.OFXpassword;
              WebBrowser1.OleObject.Document.All.Item('StartPage').value := 'LOGIN_BALANCES';
              WebBrowser1.OleObject.Document.All.Item('li').submit;
            end
          // logged in to different account - log out
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/LogInDup', URL)= 1) then begin
              if (pos(TradeLogFile.CurrentAccount.OFXusername + '</',htmlTxt)=0)
              then begin
                WebBrowser1.Navigate('https://wwws.ameritrade.com/cgi-bin/apps/LogOut');
                exit;
              end;
            end
          // logged out - log back in
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/LogOut',URL)= 1)
            then begin
              if (pos(TradeLogFile.CurrentAccount.OFXusername + '</',htmlTxt)=0)
              then begin
                WebBrowser1.Navigate('https://wwws.ameritrade.com/apps/LogIn');
              end;
            end
          // logged in - switch account
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/Main',URL)=1)
            then begin
              // clipboard.astext:=url+cr+cr+htmlTxt+cr+cr; sm(url);
              doOnce := true;
            // switch account
              WebBrowser1.Navigate('https://wwws.ameritrade.com/cgi-bin/apps/u/Home?switch_uid='+TradeLogFile.CurrentAccount.OFXAccount);
            end
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/u/Main', URL) = 1)
            and not doOnce then begin
              WebBrowser1.Navigate('https://wwws.ameritrade.com/cgi-bin/apps/Main');
            end
          // logged in - go to Penson Reports
            else if (pos('https://wwws.ameritrade.com/cgi-bin/apps/Main',URL)= 1)
            then begin
              lblStat.Caption := 'PLEASE WAIT - Getting Trade History CSV file from: ' + dateStart + ' to: ' + dateEnd;
              WebBrowser1.Navigate('https://wwws.ameritrade.com/cgi-bin/apps/u/DisplayPensonDocs?activeTab=REPORTS');
              exit;
            end
            else if (pos('https://online.penson.com', URL)= 1)
            and (pos('Trade Detail', htmlTxt)= 0)
            and (pos('<TITLE>ExportData', htmlTxt)= 0) then begin
              if (pos('query did not return', htmlTxt)> 1) then begin
                sm('The date range you selected did not return any records.');
                close;
                exit;
              end;
              acct := TradeLogFile.CurrentAccount.OFXAccount;
              if pos('-', acct) > 0 then
                acct := parseLast(acct, '-');
              while length(acct) < 12 do
                acct := acct + ' ';
              WebBrowser1.OleObject.Document.All.Item('_ctl0_ctlUserAccounts_ddlAccount_ddl').value := acct;
              WebBrowser1.OleObject.Document.All.Item('_ctl0_ctlFromToDates_txtStartDate_txt').value := dateStart;
              WebBrowser1.OleObject.Document.All.Item('_ctl0_ctlFromToDates_txtEndDate_txt').value := dateEnd;
              WebBrowser1.OleObject.Document.All.Item('_ctl0_btnGo_btn').click;
            end
            else if (pos('https://online.penson.com', URL)= 1)
            and (pos('Trade Detail', htmlTxt)> 1)
            and (pos('<TITLE>ExportData', htmlTxt)= 0) then begin
              WebBrowser1.OleObject.Document.All.Item('_ctl0_ctlTitlebar_imgSave').click;
            end
            else if (pos('<TITLE>ExportData', htmlTxt)> 1) and not doOnce then
            begin
              doOnce := true;
              WebBrowser1.OleObject.Document.All.Item('btnDL_btn').click;
              frmMain.tmrFileDL.enabled := true;
              lblStat.Caption := sMsgGetCSV;
              exit;
            end;
          end
          // ==============================================
          // E*Trade
          // ==============================================
          else if (TradeLogFile.CurrentAccount.FileImportFormat = 'E-Trade') then begin
           //clipboard.asText:= url+cr+cr+ htmlTxt;  sm(url);
            Application.ProcessMessages;
            edURL.Caption := URL;
            // set focus on the web page
            if Document <> nil then
              with Application as IOleobject do
                DoVerb(OLEIVERB_UIACTIVATE, nil, WebBrowser1, 0, Handle, GetClientRect);
            if (pos('SmErrorPage', URL)> 0) then begin
              if (pos('You have exceeded the maximum number of invalid login attempts', htmlTxt)> 0)
              then begin
                mDlg('You have exceeded the maximum number of invalid login attempts.'
                  + cr + 'To log in again, you must exit TradeLog and ask E*trade to reset your login.',
                  mtError, [mbCancel], 0);
              end;
              doOnce := false;
              webgetdata := '';
              close;
              exit;
            end
            else if not doOnce
            and ((pos('insight.ads', URL)> 0)
             or (pos('wsod', URL)> 0)
             or (pos('adsrvr', URL)> 0)
             or (pos('livelook.com', URL)> 0))
             then begin
              // crap adware pages - don't do anything
            end
            else if not doOnce
            and (pos('https://us.etrade.com/e/t/user/login', URL)= 1)
            then begin
            // check for login errors
              msgTxt := '';
              //if (pos('The Password or Security Code you entered is invalid.', htmlTxt)> 0)
              if (pos('password or security code you entered is invalid', lowercase(htmlTxt))> 0)
              then begin
                msgTxt := 'The Password or Security Code you entered is invalid.'
                  + cr + cr + 'Please call Etrade to reset.';
              end
              else if (pos('Invalid Password', htmlTxt)> 0)
              or (pos('The user ID or password you entered does not match our records.', htmlTxt)> 0)
              then begin
                msgTxt := 'The user ID or password you entered does not match our records..'
                  + cr + cr + 'Please call Etrade to reset.';
              end;
              // show error message and exit
              if msgTxt <> '' then begin
                mDlg(msgTxt, mtError,[mbOK], 0);
                doOnce := true;
                webgetdata := '';
                close;
                exit;
              end;
              ETradeLoggedIn := true;
              // fill in and submit logon form via DOM
              WebBrowser1.OleObject.Document.All.Item('USER').value := TradeLogFile.CurrentAccount.OFXusername;
              WebBrowser1.OleObject.Document.All.Item('txtPassword').value := TradeLogFile.CurrentAccount.OFXpassword;
              WebBrowser1.OleObject.Document.All.Item('PASSWORD').value := TradeLogFile.CurrentAccount.OFXpassword;
              // 2015-01-15 Let's try 4 times to get it to submit
              for i := 1 to 4 do begin
                WebPause(500); // <-- this pause is key to submitting the form
                WebBrowser1.OleObject.Document.All.Item('log-on-form').submit;
              end;
            end
            else if ETradeLoggedIn and not doOnce then begin
              doOnce := true;
              sleep(500);
              lblStat.Caption := 'PLEASE WAIT - Navigating to Trade History Download Page';
              WebBrowser1.Navigate('https://us.etrade.com/e/t/invest/downloadofxtransactions?fp=TH');
            end
            else if (pos('https://us.etrade.com/e/t/invest/downloadofxtransactions?fp=TH',URL)= 1)
            then begin
              lblStat.Caption := URL;
              if (pos('Scheduled System Maintenance', htmlTxt)> 0)
              or (pos('SCHEDULED SYSTEM MAINTENANCE', htmlTxt)> 0)
              then begin
                WebBrowser1.OleObject.Document.All.Item('continueButton').click;
                exit;
              end;
            // check for valid account number
              strOfx := rightStr(TradeLogFile.CurrentAccount.OFXAccount, 4);
              if (pos('-' + strOfx, htmlTxt) = 0) and not ETradeLoggedIn then begin
                mDlg(TradeLogFile.CurrentAccount.OFXAccount + cr + 'is an invalid account number', mtError,[mbOK], 0);
                close;
              end;
              // remove dash from acct number
              ETAcct := TradeLogFile.CurrentAccount.OFXAccount;
              while pos('-', ETAcct)> 0 do
                delete(ETAcct, pos('-', ETAcct), 1);
              sleep(1000);
              lblStat.Caption := sMsgGetCSV;
              twoDigityear; // change start and end dates to 2 digit year
              myURL := 'https://us.etrade.com/e/t/invest/ExcelDownloadTxnHistoryComponent?'
                + 'skinname=none&'
                + '&?DownloadFormat=msexcel'
                + '&AcctNum=' + ETAcct
                + '&FromDate=' + newDateStart
                + '&ToDate=' + newDateEnd;
              S := readURL(myURL);
              if S = '' then begin
                webgetdata := '';
                close;
                exit;
              end;
              // clipboard.astext:= s; sm(s);
              loopOnce := false;
              dateEndOrig := dateEnd;
              // Excel file too large to d/l in one chunk
              if pos('<form name="autoprint"',s)>0 then begin
                // test is import is more 1 month or more
                numDays := DaysInMonth(xStrToDate(dateStart, Settings.InternalFmt));
                if trunc(xStrToDate(dateEnd, Settings.InternalFmt)
                  - xStrToDate(dateStart, Settings.InternalFmt))>= numDays
                then begin
                  numMonths := yearOf(xStrToDate(dateEnd, Settings.InternalFmt))
                    - yearOf(xStrToDate(dateStart, Settings.InternalFmt));
                  numMonths := numMonths * 12;
                  numMonths := numMonths
                    + monthOf(xStrToDate(dateEnd, Settings.InternalFmt))
                    - monthOf(xStrToDate(dateStart, Settings.InternalFmt)) + 1;
                end
                else begin
                  numMonths := 1;
                  isLessThanOneMon := true;
                end;
                for i := 1 to numMonths do begin
                  decodeDate(xStrToDate(dateStart, Settings.InternalFmt), yr, mon, day);
                // get number of days in month
                  numDays := DaysInMonth(xStrToDate(dateStart));
                  if numDays <= day then begin
                  // increment month
                    mon := mon + 1;
                    if mon > 12 then begin
                      mon := 1;
                      yr := yr + 1;
                    end;
                  end;
                  if mon < 10 then
                    monStr := '0' + intToStr(mon)
                  else
                    monStr := intToStr(mon);
                  if numMonths > 1 then begin
                    numDays := DaysInMonth(xStrToDate(monStr + '/01/' + intToStr(yr)));
                    dateEnd := monStr + '/' + intToStr(numDays)+ '/' + intToStr(yr);
                  // limit to original end date
                    if xStrToDate(dateEnd) > xStrToDate(dateEndOrig) then
                      dateEnd := dateEndOrig;
                    lblStat.Caption := sMsgGetCSV;
                    twoDigityear; // change start and end dates to 2 digit year
                    myURL := 'https://us.etrade.com/e/t/invest/ExcelDownloadTxnHistoryComponent?'
                      + 'skinname=none&'
                      + '&DownloadFormat=msexcel'
                      + '&AcctNum=' + ETAcct
                      + '&FromDate=' + newDateStart
                      + '&ToDate=' + newDateEnd;
                    S := readURL(myURL);
                    if S = '' then begin
                      webgetdata := '';
                      close;
                      exit;
                    end;
                  end;
                // Excel file STILL too large to d/l download 5 days at a time
                  if pos('<form name="autoprint"', S)> 0 then begin
                    for j := 1 to 6 do begin
                    // do not go past last day of month
                      if strToInt(copy(dateStart, 4, 2))> numDays then break;
                      dateEnd := dateToStr(xStrToDate(dateStart)+ 4, Settings.InternalFmt);
                    // limit to original end date
                      if xStrToDate(dateEnd) > xStrToDate(dateEndOrig) then begin
                        dateEnd := dateEndOrig;
                        loopOnce := true;
                      end;
                    // limit dateEnd to last day of month
                      if strToInt(copy(dateEnd, 4, 2))> numDays then begin
                        dateEnd := monStr + '/' + intToStr(numDays)+ '/' + intToStr(yr);
                        loopOnce := true;
                      end;
                      lblStat.Caption := sMsgGetCSV;
                      twoDigityear;
                      // change start and end dates to 2 digit year
                      myURL := 'https://us.etrade.com/e/t/invest/ExcelDownloadTxnHistoryComponent?'
                        + 'skinname=none&'
                        + '&DownloadFormat=msexcel'
                        + '&AcctNum=' + ETAcct
                        + '&FromDate=' + newDateStart
                        + '&ToDate=' + newDateEnd;
                      S := readURL(myURL);
                      if S = '' then begin
                        webgetdata := '';
                        close;
                        exit;
                      end;
                      webgetdata := S + webgetdata;
                      if pos('<form name="autoprint"', S)> 0 then
                        for k := 0 to 4 do begin // get 1 day at a time
                          if k > 0 then
                            dateStart := dateToStr(xStrToDate(dateStart)+ 1, Settings.InternalFmt);
                      // limit to original end date
                          if xStrToDate(dateStart) > xStrToDate(dateEndOrig) then break;
                      // limit to last day of month
                          if strToInt(copy(dateStart, 4, 2))> numDays then break;
                          dateEnd := dateStart;
                          lblStat.Caption := sMsgGetCSV;
                      // make year 2 digits
                          newDateStart := dateStart;
                          newDateEnd := dateEnd;
                          delete(dateStart, 7, 2);
                          delete(dateEnd, 7, 2);
                          myURL := 'https://us.etrade.com/e/t/invest/ExcelDownloadTxnHistoryComponent?'
                            + 'skinname=none&'
                            + '&DownloadFormat=msexcel'
                            + '&AcctNum=' + ETAcct
                            + '&FromDate=' + dateStart
                            + '&ToDate=' + dateEnd;
                          S := readURL(myURL);
                          if S = '' then begin
                            webgetdata := '';
                            close;
                            exit;
                          end;
                          if pos('<form name="autoprint"', S)> 0 then begin
                            sm('You have over 500 trade records on ' + dateStart + cr //
                              + cr //
                              + 'Please call ETRADE and ask them to send you a csv file of your trades.' + cr);
                            lblStat.Caption := 'PLEASE WAIT - Finalizing import.';
                            close;
                            exit;
                          end;
                          webgetdata := S + webgetdata;
                        end;
                      if loopOnce then break;
                    // get next start day
                      nextDateStart := xStrToDate(dateEnd)+ 1;
                      dateStart := dateToStr(nextDateStart, Settings.InternalFmt);
                    end;
                  end
                  else begin
                    webgetdata := S + webgetdata;
                  end;
                // get next months
                  nextDateStart := xStrToDate(dateEnd)+ 1;
                  dateStart := dateToStr(nextDateStart, Settings.InternalFmt);
                end;
              end
              else
                webgetdata := S; // got it all at once
              nextDateStart := xStrToDate(dateEnd)+ 1;
              if pos('TransactionDate,TransactionType,SecurityType', webgetdata) > 0 then
                saveImportAsFile(webgetdata, dateStart, dateEnd, Settings.InternalFmt)
              else
                webgetdata := '';
              close;
            end;
          end
          // ==============================================
          // Charles Schwab
          // ==============================================
          else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab')
          then begin
          // updated 2011-10-26
            if (pos('?ErrorCode', URL)> 0) then begin
              sm('Broker returned ERROR.' + CR //
                + 'Please call Charles Schwab for assistance.');
              webgetdata := '';
              close;
            end;
            if (pos('id=loginErrorMsg>', htmlTxt)> 0) then begin
              msgTxt := parseHTML(htmlTxt, 'id=loginErrorMsg>', '<');
              if msgTxt <> '' then begin
                sm(msgTxt + cr //
                  + cr //
                  + 'Please call Charles Schwab for assistance.');
                webgetdata := '';
                close;
              end;
            end;
            if (pos('Passcode Authentication', htmlTxt)> 0) then exit;
            if (pos('For your protection', htmlTxt)> 0)
            and (pos('verify your identity', htmlTxt)> 0) then begin
              mDlg('Please close TradeLog, login to your Charles Schwab account' + cr //
                + 'from your web browser, and answer the security questions.' + cr //
                + cr //
                + 'Then run TradeLog and try importing again.', mtWarning,[mbOK], 0);
              close;
              exit;
            end;
            if (pos('Password Change Reminder', htmlTxt)> 0) then begin
              mDlg('Please close TradeLog, login to your Charles Schwab account' + cr //
                + 'from your web browser, and answer the questions about' + CR //
                + 'changing your password.' + cr //
                + cr //
                + 'Then run TradeLog and try importing again.',
                mtWarning,[mbOK], 0);
              close;
              exit;
            end;
            // login
            if (pos('https://client.schwab.com/Login/SignOn/CustomerCenterLogin.aspx',URL)=1) //
            then begin
              WebBrowser1.OleObject.Document.All.Item('txtPassword').value := TradeLogFile.CurrentAccount.OFXpassword;
              WebBrowser1.OleObject.Document.All.Item('ctl00_WebPartManager1_CenterLogin_LoginUserControlId_txtLoginID').value := TradeLogFile.CurrentAccount.OFXusername;
              WebBrowser1.OleObject.Document.All.Item('ctl00_WebPartManager1_CenterLogin_LoginUserControlId_drpStartPage').value := 'CCBodyi';
              WebBrowser1.OleObject.Document.All.Item('btnLogin').click;
            end
            // pause to enter token
            else if (pos('https://investing.schwab.com/service/?request=SignonService',URL)=1) //
            or (pos('https://investing.schwab.com/service/?request=OtpValidationService',URL)=1) //
            then begin
              exit;
            end
            else if (pos('Password Change Reminder', htmlTxt)> 0) then begin
            // pause and let user select his option
              exit;
            end
            // account positions page - get History
            else if (pos('https://client.schwab.com/Accounts/Positions', URL)= 1) then begin
              lblStat.Caption := 'Getting Trade History';
              WebBrowser1.Navigate('https://client.schwab.com/Accounts/History/BrokerageHistory.aspx')
            end
            // account summary page - select account number
            else if (pos('https://client.schwab.com/Accounts/Summary/Summary.aspx?',URL)= 1) //
            then begin
              lblStat.Caption := 'Selecting Account';
              // check for valid account
              if (pos('>' + TradeLogFile.CurrentAccount.OFXAccount + '<',htmlTxt)= 0) then begin
                sm(TradeLogFile.CurrentAccount.OFXAccount+cr+' is not a valid account number');
                webgetdata := '';
                close;
              end;
              // select account
              for i := 0 to WebBrowser1.OleObject.Document.links.length - 1 do begin
                msgTxt := WebBrowser1.OleObject.Document.links.Item(i).href;
                if pos('lnkBrokerageAccountId', msgTxt)> 0 then begin
                  msgTxt := WebBrowser1.OleObject.Document.links.Item(i).innerText;
                  if msgTxt = TradeLogFile.CurrentAccount.OFXAccount then begin
                    WebBrowser1.OleObject.Document.links.Item(i).click;
                    break;
                  end;
                end;
              end;
              schwabSummary := true;
            end
            else if not schwabSummary then begin
              WebBrowser1.Navigate('https://client.schwab.com/Accounts/Summary/Summary.aspx');
              exit;
            end
            // account balances page - get History
            else if (pos('https://client.schwab.com/Accounts/BrokerageBalances/BrokerageBalances.aspx',URL)= 1)
            or (pos('/Accounts/Positions', URL)> 0) then begin
              lblStat.Caption := 'Getting Trade History - Please Wait...';
              WebBrowser1.Navigate('https://client.schwab.com/Accounts/History/BrokerageHistory.aspx')
            end
            else if (pos('https://client.schwab.com/Accounts/History/BrokerageHistory.aspx',URL)= 1)
            or (pos('https://client.schwab.com/Areas/Accounts/History/BrokerageHistory.aspx',URL)= 1)
            then begin
              //clipboard.astext := htmlTxt; sm('');
              if not exportDisclaimer then begin
                lblStat.Caption := sMsgGetCSV;
                WebBrowser1.OleObject.Document.All.Item('ctl00_wpm_WpBrH_BrH_drpTimeFrame').value := 6;
                WebBrowser1.OleObject.Document.All.Item('ctl00_wpm_WpBrH_BrH_txtFrom').value := dateStart;
                WebBrowser1.OleObject.Document.All.Item('ctl00_wpm_WpBrH_BrH_txtTo').value := dateEnd;
                WebBrowser1.OleObject.Document.All.Item('ctl00_wpm_WpBrH_BrH_btnSearch').click;
                exportDisclaimer := true;
              end
              else begin
                if (pos('sortDownArrow', htmlTxt)> 0) then
                  // click date to sort by date ascending
                  WebBrowser1.OleObject.Document.All.Item('ctl00_wpm_WpBrH_BrH_lnkDate').click
                else
                  WebBrowser1.OleObject.Document.All.Item('lnkExport').click;
              end;
            end
            else if(pos('https://client.schwab.com/ExportDisclaimer.aspx', URL)= 1)
            then begin
              frmWebPopup.WebBrowser1.OleObject.Document.All
                .Item('ctl00_WebPartManager1_wpExportDisclaimer_ExportDisclaimer_btnOk').click;
              frmMain.tmrFileDL.enabled := true;
              frmWebPopup.lblStat.Caption := 'PLEASE DO NOT HIT ANY KEYS!';
              exit;
            end;
          end
          // ==============================================
          // Fidelity
          //  imBC_duringLogin    = 2;
          //  imBC_afterLogin     = 3;
          //  imBC_NavigateToData = 4;
          //  imBC_RequestTheData = 5;
          //  imBC_DownloadData   = 6;
          // ==============================================
          else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') then begin
            if (gBCImpStep <= imBC_beforeLogin) then begin
              WebAutoLogin; // enter username and password, click Login button
              gBCImpStep := imBC_duringLogin;
              tmrIB.Interval := 2000;
              tmrIB.Enabled := true;
            end; // ----------------------------------------
            if (gBCImpStep = imBC_duringLogin) then begin
              if (POS('/ftgw/fbc/oftop/portfolio', URL) > 0) then
                gBCImpStep := imBC_afterLogin;
            end; // ----------------------------------------
            if (gBCImpStep = imBC_afterLogin) then begin
              if (POS('https://oltx.fidelity.com/ftgw/fbc/ofsummary/defaultPage', URL) > 0)
              then begin
                tmrIB.Enabled := false;
                gBCImpStep := imBC_NavigateToData; // ok
                WebBrowser1.OleObject.Document.getElementById('card-account-history').click;
                gBCImpStep := imBC_DownloadData;
                saveFidelityCSV(dateStart, dateEnd);
                gBCImpStep := imBC_DownloadData;
              end
              else begin
                sJava := 'toggleMap.DPCSActivityTabBrokerageHistoryEntitledFeature=false';
                if ExecJavaScript(HTMLWindow, sJava) then begin // 1st try
                  gBCImpStep := imBC_NavigateToData; // ok
                end
                else begin // 2nd try
                  SLEEP(2000); // wait 2 more seconds before retry
                  if ExecJavaScript(HTMLWindow, sJava) then begin
                    gBCImpStep := imBC_NavigateToData; // ok
                  end
                  else begin
                    gBCImpStep := imBC_FailAbort;
                    hide;
                    close;
                    exit; // failed!
                  end; // if ExecJavaScript
                end; // 2nd try
              end;
            end; // ----------------------------------------
            if (gBCImpStep = imBC_NavigateToData) then begin
              gBCImpStep := imBC_RequestTheData;
              //tmrWebTimeout.Interval := 20000; // 20 seconds
              //tmrWebTimeout.Enabled := true; // <-- don't reset tmr
              // get the hidden value sAMC
              webgetData := readURL('https://oltx.fidelity.com/ftgw/fbc/oftop/portfolio');
              sAMC := parseHTML(webGetData, '<input type="hidden" class="account-mini-context" value="', '"');
              gBCImpStep := imBC_RequestTheData;
              SLEEP(500); // wait half a second!
              sGetURL:= 'https://oltx.fidelity.com/ftgw/fbc/ofacda/snippet/brokerageAccountHistory' //
                + '?ACCOUNTS=' + TradeLogFile.CurrentAccount.OFXaccount //
                + '&VIEW_TYPE=NON_CORE' //
                + '&FROM_DATE=' + dateStart //
                + '&TO_DATE=' + dateEnd //
                + '&PERIOD=' //
                + '&ACCT_HIST_DAYS=RANGE' //
                + '&ACCT_HIST_SORT=DATE' //
                + '&SORT_TYPE=D' //
                + '&SECURITY_TYPE=S' //
                + '&SECURITY_VAL=' //
                + '&AMC=' + sAMC //
                + '&CSV=Y';
              webgetData := readURL(sGetURL);
              gBCImpStep := imBC_DownloadData;
              if POS('api has been decommissioned', webgetData) > 0 then begin
                mDlg('No trade records received from server.' + cr + cr
                  + ' Server Not Responding' + cr //
                  + ' Please try again later' + cr //
                  + ' or use CSV import method.' + cr, //
                  mtInformation, [mbOK], 0)
              end;
              saveFidelityCSV(dateStart, dateEnd);
              hide;
              close;
              exit;
            end; // ----------------------------------------
            if gBCImpStep >= imBC_DownloadData then begin
              hide;
              close;
              exit;
            end;
          end
          // ==============================================
          // Scottrade
          // ==============================================
          else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Scottrade') then begin
            if (DEBUG_MODE > 3) and SuperUser then begin
              clipboard.astext := htmlTxt;
              sm(copy(htmlTxt,1,900));
            end;
            try // catch any exceptions and die gracefully  2012-11-09
              // 4. transactions page
              if (pos('myaccount/Transactions.aspx', URL)> 0)
              and transPageDone then begin
                if (DEBUG_MODE > 2) and SuperUser then begin
                  clipboard.astext := '4. transactions page' + CR + htmlTxt;
                  sm('4. transactions page');
                end;
                //webBrowser1.OleObject.Document.All.Item('Transactions1_lnkExportToExcel').click;  2012-11-09
                WebBrowser1.OleObject.Document.All.Item('ExcelExportDiv').click;
                frmMain.tmrFileDL.enabled := true;
                exit;
              end
              // 3. transactions page - fill in form and begin download
              else if (pos('myaccount/Transactions.aspx', URL)> 0)
              and not transPageDone then begin
                if (DEBUG_MODE > 2) and SuperUser then begin
                  clipboard.astext := '3. transactions page' + CR + CR + url + CR + CR + htmlTxt;
                  sm('3. transactions page' + CR + url);
                end;
                // updated 2014-09-11
                lblStat.Caption := sMsgGetCSV;
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00$PageContent$Transactions1$ddlDate').value := '6';
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00$PageContent$Transactions1$ddlDate').focus;
                SimulateKeystroke(VK_UP, 0);
                SimulateKeystroke(VK_DOWN, 0);
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00$PageContent$Transactions1$txtStartDate').value :=
                  dateStart;
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00$PageContent$Transactions1$txtEndDate').value
                  := dateEnd;
                // select all transactions
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00$PageContent$Transactions1$ddlTransactions')
                  .value := '0';
                // click Go bbutton
                WebBrowser1.OleObject.Document.All.Item
                  ('ctl00_PageContent_Transactions1_lbtnGo').click;
                transPageDone := true;
              end
              // 2. successful login - got to transactions page
              else if (pos('Your last login was', htmlTxt)> 0)
              or (pos('home/default.aspx', URL)> 0) then begin
                // get csv file
                WebBrowser1.Navigate
                  ('https://trading.scottrade.com/myaccount/Transactions.aspx');
              end
              // security question
              else if (pos('https://trading.scottrade.com/Login/SecurityChallenge', URL) = 1)
              then begin
                webgetdata := '';
                exit;
              end
              // 1. login
              else if (pos('https://trading.scottrade.com/default.aspx', URL)= 1)
              then begin
                // updated for new site 2010-05-05
                if (DEBUG_MODE > 2) and SuperUser then begin
                  clipboard.astext := '1. login' + CR + htmlTxt;
                  sm('1. login' + CR + webbrowser1.LocationURL);
                end;
                if (pos('The Login Information provided does not match our current records', htmlTxt)> 0)
                then begin
                  mDlg('The Login Information provided does not match Scottrade current records.'
                    + cr + cr
                    + 'Please enter the correct Account # and Password.',
                    mtWarning,[mbOK], 0);
                  close;
                end;
                // 2015-08-24 updated for latest login page html; again on 2016-08-09
                // webBrowser1.OleObject.Document.All.Item('ctl00$body$Login1$txtAccountNumber').value:= TradeLogFile.CurrentAccount.OFXusername;
                // webBrowser1.OleObject.Document.All.Item('ctl00$body$Login1$txtPassword').value:= TradeLogFile.CurrentAccount.OFXpassword;
                WebBrowser1.OleObject.Document.All
                  .Item('ctl00$body$txtAccountNumber').value
                  := TradeLogFile.CurrentAccount.OFXusername;
                WebBrowser1.OleObject.Document.All
                  .Item('ctl00$body$txtPassword').value := TradeLogFile.CurrentAccount.OFXpassword;
                // ----- now click the LogOn/LogIn button ------
                if (pos('ctl00$body$btnLogin', htmlTxt)> 0) then
                  WebBrowser1.OleObject.Document.All.Item('ctl00$body$btnLogin').click
                else if (pos('ctl00$body$btnLogOn', htmlTxt)> 0) then
                  WebBrowser1.OleObject.Document.All.Item('ctl00$body$btnLogOn').click
                else if (pos('ctl00_body_sibLogOn', htmlTxt)> 0) then
                  WebBrowser1.OleObject.Document.getElementById('ctl00_body_sibLogOn').click
                else
                  sm('the login page has been changed by the broker.');
              end;
            except
              webgetdata := '';
              mDlg('Problem with Scottrade website' + cr + cr +
                  'Please click Help, Send Files to Support' + cr, mtError,
                [mbOK], 0);
              hide;
              close;
              exit;
            end;
          end
          // ==============================================
          // TradeStation
          // ==============================================
          else if TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation'
          then begin
            scrapeTradestation(URL, htmlTxt, WebBrowser1);
          end // FileImportFormat = 'TradeStation'
          // ==============================================
          // Vanguard
          // ==============================================
          else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Vanguard')
          then begin
            if pos('Holiday Closing', htmlTxt)> 0 then begin
              WebBrowser1.Navigate
                ('https://personalp.vanguard.com/us/OfxWelcome');
            end
          // security question
            else if (pos('PMLogin', URL)> 1)
            and (pos('Answer your security question', htmlTxt)>0) then begin
              sm('Please answer your security question');
            end
          // invalid password
            else if pos('password entered is incorrect', htmlTxt)>0 then begin
              sm('Invalid Password');
              close;
            end
          // invalid username
            else if pos('is an incorrect user name', htmlTxt)>0 then begin
              sm('Invalid User Name');
              close;
            end
          // login - username
            else if (pos('https://investor.vanguard.com/home/', URL)= 1)
            or ( (pos('doubleclick.net', URL)> 0)
            and ((pos('id="USER"', htmlTxt)> 0) or (pos('id=USER', htmlTxt)> 0)))
            then begin
              WebBrowser1.OleObject.Document.All.Item('USER').value :=
                TradeLogFile.CurrentAccount.OFXusername;
              WebBrowser1.OleObject.Document.All.Item('LoginForm').submit;
            end
          // login - password
            else if (pos('https://personal.vanguard.com/us/hnwnesc/PMLogin', URL)= 1)
            or (pos('https://personal.vanguard.com/us/PMLogin', URL)= 1)
            or ( (pos('doubleclick.net', URL)> 0)
             and ( (pos('id="LoginForm:PASSWORD"', htmlTxt)> 0)
                or (pos('id=LoginForm:PASSWORD', htmlTxt)> 0) ) )
            then begin
              WebBrowser1.OleObject.Document.All.Item('LoginForm:PASSWORD').value
               := TradeLogFile.CurrentAccount.OFXpassword;
              WebBrowser1.OleObject.Document.All.Item('LoginForm:submit').click;
            // SimulateKeystroke(VK_TAB, 0); SimulateKeystroke(VK_RETURN, 0);        }
            end
          // logged in - go to welcome page
            else if (pos('https://personal.vanguard.com/us/MyHomeExt', URL)= 1)
            or ( (pos('doubleclick.net', URL)> 0)
             and (pos('Welcome back', htmlTxt)> 0))
            then begin
              if pos(TradeLogFile.CurrentAccount.OFXAccount, htmlTxt)= 0 then begin
                lblStat.Caption := '';
                sm('ERROR: Invalid Account Number');
                webgetdata := '';
                close;
              end;
              WebBrowser1.Navigate('https://personal.vanguard.com/us/XHTML/com/vanguard/retail/web/ofx/view/OfxDownloadIndexPage.xhtml');
            end
            else if (pos('https://personalp.vanguard.com/us/OfxWelcome', URL) = 1)
            or (pos('https://personal.vanguard.com/us/XHTML/com/vanguard/retail/web/ofx/view/OfxDownloadIndexPage.xhtml', URL)= 1)
            // or  ( (pos('doubleclick.net',url)>0) and (pos('Download Account Information',htmlTxt)>0) )
            then begin
              lblStat.Caption := sMsgGetCSV;
              refresh;
            // grab CSRF token
            // <INPUT type=hidden value=23a6f64a-20b6-4dcf-b538-9f355d0c1c24 name=ANTI_CSRF_TOKEN system="true" TeaLeaf="true">
            // del everything from " name=ANTI_CSRF_TOKEN"
              htmlTxt := copy(htmlTxt, 1, pos(' name=ANTI_CSRF_TOKEN', htmlTxt));
            // get token text
              htmlTxt := trim(parseLast(htmlTxt, '='));
              CSRF_TOKEN := htmlTxt;
            // CSRF_TOKEN := parseHTML(htmlTxt,'ANTI_CSRF_TOKEN" type="hidden" value="','"');
              // sm('CSRF: '+CSRF_TOKEN);
            // find row of account number
              S := 'https://personal.vanguard.com/us/XHTML/com/vanguard/retail/web/ofx/view/OfxDownloadIndexPage.xhtml'
                + '?OfxDownloadForm:hiddenDownloadLink=OfxDownloadForm:hiddenDownloadLink'
                + '&cbd_ria=true' + '&OfxDownloadForm:downloadOption=CSVFile' +
                '&OfxDownloadForm:ofxDateFilterSelectOneMenu=CUSTOM' +
                '&OfxDownloadForm:fromDate=' + dateStart +
                '&OfxDownloadForm:toDate=' + dateEnd +
                '&OfxDownloadForm%3AdownloadTransDynamicRow%3A0%3AfundOrAcctNumber=0052-88101383648'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A1%3AfundOrAcctNumber=0030-88101383648'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A2%3AfundOrAcctNumber=66279805'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A3%3AfundOrAcctNumber=0040-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A4%3AfundOrAcctNumber=0057-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A5%3AfundOrAcctNumber=0026-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A6%3AfundOrAcctNumber=0030-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A7%3AfundOrAcctNumber=0085-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A8%3AfundOrAcctNumber=0027-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A9%3AfundOrAcctNumber=0021-88062312680'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A10%3AfundOrAcctNumber=0040-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A11%3AfundOrAcctNumber=0111-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A12%3AfundOrAcctNumber=0082-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A13%3AfundOrAcctNumber=0057-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A14%3AfundOrAcctNumber=1690-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A15%3AfundOrAcctNumber=0126-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A16%3AfundOrAcctNumber=0934-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A17%3AfundOrAcctNumber=1945-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A18%3AfundOrAcctNumber=0032-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A19%3AfundOrAcctNumber=0048-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A20%3AfundOrAcctNumber=0045-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A21%3AfundOrAcctNumber=0084-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A22%3AfundOrAcctNumber=1231-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A23%3AfundOrAcctNumber=0569-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A24%3AfundOrAcctNumber=0113-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A25%3AfundOrAcctNumber=0085-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A26%3AfundOrAcctNumber=0027-88071527000'
                + '&OfxDownloadForm%3AdownloadTransDynamicRow%3A27%3AfundOrAcctNumber=0022-88071527000'
                + '&OfxDownloadForm:downloadTransDynamicRow:28:chkboxId=on' +
                '&OfxDownloadForm:downloadTransDynamicRow:28:fundOrAcctNumber='
                + TradeLogFile.CurrentAccount.OFXAccount + '&ANTI_CSRF_TOKEN=' +
                CSRF_TOKEN + '&OfxDownloadForm=OfxDownloadForm';
              webgetdata := readURL(S);
              if (pos('trying to reach is currently unavailable.', webgetdata) > 0) then
                mDlg('The Vanguard page you are trying to reach is currently unavailable.'
                  + cr + 'This may be a temporary error, so please try again.',
                  mtInformation,[mbOK],1)
              else
                saveImportAsFile(webgetdata, dateStart, dateEnd, Settings.InternalFmt);
              close;
            end
            else begin
            end;
          end; // FileImportFormat = 'Vanguard'
        end; // if brokerConnectRunning
      end; // if Assigned(WebBrowser1.Document)
    end; // with frmWeb
  finally
    // WebBrowser1DocumentComplete
  end;
end;


// --------------------------------------------------------
procedure supportExpired;
begin
  getWebPage('https://www.tradelogsoftware/purchase/');
  mDlg('Your one year of free updates and support has expired!'+cr+cr+
    'Please order a one year renewal of updates and support '+cr+
    'from our Purchase page'+cr
    ,mtWarning, [mbOK], 0);
end;


procedure setupWeb;
begin
  frmWeb:=TfrmWeb.create(frmMain);
  with frmWeb do begin
    width:= 400; //clWidth;
    height:= 500; //clHeight;
    formStyle:= fsStayOnTop;
    showModal;
  end;
  frmMain.cxGrid1.LayoutChanged;
end;


procedure setupBrokerConnect(url,dtStart,dtEnd:string);
var
  sURL : string;
begin
  try
    exportDisclaimer := false;
    transPageDone := false;
    brokerConnectRunning := true;
    dateStart := dtStart;
    dateEnd := dtEnd;
    frmWeb := TfrmWeb.Create(frmMain);
    doOnce := false;
    webStop := false;
    ETradeLoggedIn := false;
    with frmWeb do begin
      caption:= TradeLogFile.CurrentAccount.FileImportFormat+' BrokerConnect';
      edUrl.Caption:=url;
      lblStat.caption:='PLEASE WAIT - Logging into '
        + TradeLogFile.CurrentAccount.FileImportFormat
        + ' Account - DO NOT PRESS ANY KEYS';
      webBrowser1.navigate(url, NavNoHistory + NavNoReadFromCache + NavNoWriteToCache);
      showModal;
    end;
    // ==============================================
    // IB (Interactive Brokers)
    // ==============================================
    if (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') then begin
      screen.Cursor := crHourglass;
      statBar('PLEASE WAIT - Getting IB Trade History from: ' + dateStart + '  to: ' + dateEnd);
      sURL := 'https://gdcdyn.interactivebrokers.com/Universal/servlet/ReportManagement.Process.ProcessTradelogReport?'
        + 'acctId=' + TradeLogFile.CurrentAccount.OFXAccount + '&fDate='
        + YYYYMMDD(dateStart) + '&tDate=' + YYYYMMDD(dateEnd);
      // get trade activity download
      webGetdata := readURL(sURL);
      if (pos('INVALID ACCOUNT', webGetdata) > 0) then begin
        mDlg(TradeLogFile.CurrentAccount.OFXAccount + ' is not a valid Account Number!' + cr + cr +
            'Please enter a valid account number in the TradeLog BrokerConnect dialog box.', mtError, [mbOK], 0);
        exit;
      end
      else if (pos('INVALID REQUEST', webGetdata) > 0) then begin
        mDlg('INVALID REQUEST ERROR - Please contact IB for details', mtError, [mbOK], 0);
        exit;
      end
      else if (pos('attention', webGetdata) > 0) then begin
        delete(webGetdata, 1, pos('<div class=', webGetdata) + 11);
        msgTxt := parseHTML(webGetdata, '>', '</');
        mDlg('Message from IB Web Site:' + cr + cr + msgTxt, mtWarning, [mbOK], 0);
        exit;
      end;
      saveImportAsFile(webGetdata, dateStart, dateEnd, settings.InternalFmt);
    end   // <-- if broker is IB
    // ==============================================
    // Fidelity
    // ==============================================
    else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity') then begin
      //if SuperUser and (DEBUG_MODE > 2) then sm('SetupBrokerConnect for Fidelity');
      with frmWeb do begin
        tmrWebTimeout.Interval := 15000; // 15 seconds
        tmrWebTimeout.Enabled := true;
      end;
    end;
  finally
    frmMain.cxGrid1.LayoutChanged;
  end;
end;


procedure getWebPage(url:string);
begin
  try
    if url = SiteURL + 'support/download-update/' then
    frmWeb.WebBrowser1.navigate(url);
    if pos('cgi-bin',url)=0 then
      if IsFormOpen('frmWeb') then
        frmWeb.edURL.caption:='  '+url+'  ';
  finally
    // GetWebPage
  end;
end;


procedure TfrmWeb.btnPrintClick(Sender: TObject);
begin
  WebBrowser1.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER);
end;


procedure TfrmWeb.edURLClick(Sender: TObject);
begin
  clipboard.AsText:= edURL.caption;
end;


procedure TfrmWeb.spdBackClick(Sender: TObject);
begin
  try
    webbrowser1.GoBack;
  except
  end;
end;


procedure TfrmWeb.spdCloseClick(Sender: TObject);
begin
  close;
end;


procedure TfrmWeb.tmrIBTimer(Sender: TObject);
var
  s : string;
begin
  s := WebBrowser1.LocationURL;
  if (POS('https://oltx.fidelity.com/ftgw/fbc/ofsummary/defaultPage', s) > 0) then begin
    tmrIB.Enabled := false;
    gBCImpStep := imBC_NavigateToData; // ok
  end
  else
    lblStat.caption:='Please enter your security code in the box above';
end;


procedure TfrmWeb.tmrWebTimeoutTimer(Sender: TObject);
begin
  sm('BrokerConnect timed out');
  frmWeb.close;
end;


procedure getWebBrowserWindows;
var
   ShellWindows: TShellWindows;
   ShellWindowDisp: IDispatch;
   WebBrowser: IWebbrowser2;
   Count: integer;
begin
   ShellWindows := TShellWindows.Create(nil) ;
   try
     for Count := 0 to ShellWindows.Count - 1 do begin
       ShellWindowDisp := ShellWindows.Item(Count) ;
       if ShellWindowDisp = nil then Continue;
       ShellWindowDisp.QueryInterface(iWebBrowser2, WebBrowser) ;
       if WebBrowser.LocationURL = '' then Continue;
       if Assigned(WebBrowser.Document) then
         sm(WebBrowser.LocationURL);
     end;
   finally
     ShellWindows.Free;
   end;
end;


initialization

end.
