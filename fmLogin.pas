unit fmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, //
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, dxGDIPlusClasses, //
  Vcl.ExtCtrls, Vcl.Clipbrd, WinAPI.ShellAPI, winInet;

type
  TdlgLogIn = class(TForm)
    lblEmail: TLabel;
    lblPassword: TLabel;
    edEmail: TEdit;
    edPassword: TEdit;
    btnLogin: TButton;
    chkPassword: TCheckBox;
    lblForgotPwd: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    lblManageSub: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblGetSupport: TLabel;
    btnExit: TButton;
    imgLogo: TImage;
    lblBadlogin: TLabel;
    lblUpdate: TLabel;
    lblAppVer: TLabel;
//
    procedure UpdateTradeLogNow(Sender: TObject);
    procedure btnLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure lblManageSubClick(Sender: TObject);
    procedure lblForgotPwdClick(Sender: TObject);
    procedure lblGetSupportClick(Sender: TObject);
    procedure imgLogoClick(Sender: TObject);
    procedure Label2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgLogIn: TdlgLogIn;
  iRetryCount : integer;
  sUserFolder : string;

const
  nRetryLimit : integer = 3;

implementation

uses
  funcProc, globalVariables, TL_API, TLSettings, Ping2, TLUpdate, TLCommonLib;

// for Delphi, color codes are:
// TradeLog Orange: $0066FF = #ff6600
// TradeLog Blue:   $d3852f = #2f85d3
// TradeLog Black:  $424242 = #424242

{$R *.dfm}


// click event for "Update Now" link
procedure TdlgLogIn.UpdateTradeLogNow(Sender: TObject);
var
  j : integer;
  x : string;
  zFileName, zParams, zDir: array [0 .. 127] of Char;
begin
  if lblUpdate.Caption = 'OFFLINE' then begin
    imgLogoClick(Sender); // ping
  end
  else begin
    UpdateTradeLogExe(false);
    close;
  end;
end;


procedure TdlgLogIn.btnExitClick(Sender: TObject);
begin
  bCancelLogin := true;
  close;
end;


procedure TdlgLogIn.btnLoginClick(Sender: TObject);
var
  s : string;
begin
  try
    lblBadlogin.Visible := false;
    Refresh;
    screen.Cursor := crHourglass; // wait
    v2UserEmail := edEmail.Text;
    if pos('@', v2UserEmail) < 2 then begin
      if mDlg('This does not appear to be a valid email address.' + CR //
        + 'Please cancel and enter your email address now.', //
        mtCustom, [mbOK,mbCancel], 0) = mrCancel then exit;
    end;
    if chkPassword.Checked then
      v2UserPassword := edPassword.Text;
    s := GetLogin(edEmail.Text, edPassword.Text);
    // possibilities: offline, goodlogin, badlogin
    if bCancelLogin = false then begin // set by GetLogin function
      close;
    end
    else begin
      beep;
      lblBadlogin.Visible := true;
//      if (pos('401 Unauthorized', s) > 0) then begin
//        if messagedlg('It looks like you need to update your software' + CRLF + 'Want to do that now?',
//      end;
      inc(iRetryCount);
      if (iRetryCount >= nRetryLimit) then begin
        clipboard.AsText := v2LoginPostMsg; // for debugging
        sm('Incorrect Password,' + CRLF //
          + 'too many attempts.');
        clipboard.astext := ''; // clear it
        close;
      end;
    end;
  finally
    screen.Cursor := crDefault;
  end;
end;


procedure TdlgLogIn.FormCreate(Sender : TObject);
var
  sTmp, reply, Version, sDate, s1, s2, s3, s4 : string;
  Fmt : TFormatSettings;
  FFileDate : TDateTime;
  // ------------------------
  function checkInternet() : boolean;
  var
    hInet : HINTERNET;
    hFile: HINTERNET;
    Buffer : array[1 .. 8000] of AnsiChar;
    OpBuffer, errCount : Integer;
    iMaj, iMin, iRel, iBld : integer;
    tURL : string;
  begin
    tURL := 'https://tradelog.com/';
    try
      hInet := InternetOpen(PChar(Application.title), INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);
      if hInet = nil then exit(False);
      OpBuffer := 2000; // in milliseconds
      fillChar(Buffer, 0, sizeOf(Buffer));
      InternetSetOption(hInet, INTERNET_OPTION_RECEIVE_TIMEOUT, @OpBuffer, sizeOf(OpBuffer));
      try
        hFile := InternetOpenUrl(hInet, PChar(tURL), '', 0, INTERNET_FLAG_RELOAD, 0);
        if hFile = nil then
          exit(False)
        else
          exit(True);
      finally
        InternetCloseHandle(hFile);
      end;
    finally
      InternetCloseHandle(hInet);
    end;
  end; // checkInternet function
begin
  // get/show current version/release date
  DetermineInstalledVersion;
  lblAppVer.Caption := 'Version ' + gsInstallVer + ' - ' + gsInstallDate;
  // populate email, password boxes before calling
  lblBadlogin.Visible := False;
  if checkInternet = False then begin
    lblUpdate.Caption := 'OFFLINE';
    lblUpdate.Font.Color := clRed;
  end
  else begin
    reply := DetermineDownloadableVersion;
    s1 := gsVersion;
    sTmp := parselast(s1, '.'); // remove last segment
    s2 := gsInstallVer;
    sTmp := parselast(s2, '.'); // remove last segment
    if (gsVersion > gsInstallVer) then begin
      if (s1 > s2) then begin
        s3 := parsefirst(s1, '.'); // major ver#
        s4 := parsefirst(s2, '.'); // major ver#
        if (s3 > s4) then
          lblUpdate.Caption:= 'MANDATORY update required.'
        else
          lblUpdate.Caption:= 'Important update available!';
      end // if s1 > s2
      else begin
        lblUpdate.Caption:= 'Minor update available.';
      end;
    end // if newer version
    else begin
      if (gsInstalldate >= gsRelDate) then
        lblUpdate.Caption := 'Already up to date.'
      else
        lblUpdate.Caption := 'Minor update available.';
    end;
//    if (gsVersion = gsInstallVer) //
//    and (gsInstalldate <> gsRelDate) then begin
    lblAppVer.Caption := 'Version ' + gsInstallVer + gsBeta + ' - ' + gsInstallDate;
//    end;
  end;
end;


// --------------------------
//  secret troubleshooting
// --------------------------
procedure TdlgLogIn.imgLogoClick(Sender: TObject);
Var
  s : string;
  i, n : integer;
begin
  n := 0;
  s := 'brokerconnect.live';
  for i := 1 to 4 do
    if PingHost(s) then inc(n);
  if n = 4 then
    sm('PASS: 100% able to ping the website.')
  else if n = 0 then
    sm('FAIL: unable to ping the website at all.')
  else
    sm('Ping website succeeded ' + IntToStr(n) + ' of 4 tries.');
end;


procedure TdlgLogIn.Label2Click(Sender: TObject);
begin
  //
end;

// --------------------------
//  online help web links
// --------------------------
procedure TdlgLogIn.lblForgotPwdClick(Sender: TObject);
begin
  webURL('https://tradelog.com/wp-login.php?action=lostpassword');
end;

procedure TdlgLogIn.lblGetSupportClick(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/');
end;

procedure TdlgLogIn.lblManageSubClick(Sender: TObject);
begin
  webURL('https://tradelog.com/');
end;


end.

