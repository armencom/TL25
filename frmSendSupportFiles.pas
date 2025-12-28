unit frmSendSupportFiles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls,  Main, FuncProc, dxGDIPlusClasses;

type
  TSendSupport = class(TForm)
    btnSendSupport: TButton;
    Panel1: TPanel;
    lblMessage: TLabel;
    btnCancel: TButton;
    lblText: TLabel;
    ckbImport: TCheckBox;
    lblOption: TLabel;
    lblCurrentFile: TLabel;
    Label1: TLabel;
    edName: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    edEmail: TEdit;
    Label4: TLabel;
    txtVer: TLabel;
    edDetails: TMemo;
    ckbInclude1099: TCheckBox;
    lbl1099File: TLabel;
    edFile1: TEdit;
    btnFind1: TButton;
    Open1099File: TOpenDialog;
    Image1: TImage;
    Label5: TLabel;
    Image2: TImage;
    edFile2: TEdit;
    btnFind2: TButton;
    Label6: TLabel;
    Image3: TImage;
    edFile3: TEdit;
    btnFind3: TButton;
    procedure SendSupportFiles;
    procedure btnSendSupportClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure edDetailsExit(Sender: TObject);
    procedure edDetailsEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ckbInclude1099Click(Sender: TObject);
    procedure btnFind1Click(Sender: TObject);
    procedure btnFind2Click(Sender: TObject);
    procedure btnFind3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure SaveUserDataText;
  public
    { Public declarations }
  end;


var
  SendSupport: TSendSupport;

  procedure Help_SendFilestoSupport(FileMustBeOpen : Boolean = True);


implementation

{$R *.dfm}

uses
  TL_API, globalVariables, Web, TLRegister, TLSettings, TLFile, pngimage, TLSupport,
  StrUtils, WinAPI.ShellAPI,
  TLCommonLib, TLWinInet;


procedure Help_SendFilestoSupport(FileMustBeOpen : Boolean = True);
begin
  // 2017-03-16 MB - make sure there is actually a TradeLogFile open.
  if (TradeLogFile <> NIL) and (TrFileName = '') then
    TrFileName := TradeLogFile.FileName;
  if (FileMustBeOpen) and (TrFileName='') then begin
    sm('Please open the data file that you want to send to support.' + cr //
      + cr //
      + 'Then click the Help, Send Files to Support menu item.');
    exit;
  end else
    SendSupport.ShowModal;
end;

// --------------------------
procedure TSendSupport.SaveUserDataText;
var
  Line : string;
  txtFile: textFile;
begin
  //add the selected TDF file
  if FileExists(Settings.DataDir + '\CustomerComment.txt') then
    deletefile(Settings.DataDir + '\CustomerComment.txt');
  // save file as plain text
  try
    AssignFile(txtFile, Settings.DataDir + '\CustomerComment.txt');
    Rewrite(txtFile);
    Line := edDetails.Text;
    writeln(txtFile, Line);
  finally
    CloseFile(txtFile);
  end;
end;


//---------------------------------------------------------
// Build email msg from user input
//---------------------------------------------------------

procedure TSendSupport.btnFind1Click(Sender: TObject);
var
  StartName : String;
begin
  Open1099File.InitialDir := Settings.DataDir;
  Open1099File.DefaultExt := '.pdf';
  // 2017-02-23 MB - old filter only included 'Broker 1099 File|*.pdf'
  Open1099File.Filter := 'Broker PDF File|*.pdf'
    + '|Excel XLS File|*.xls'
    + '|CSV data file|*.csv'
    + '|Text file|*.txt';
  // 2017-02-23 MB - new filter
  Open1099File.FileName := '*' + Open1099File.DefaultExt;
  // use Open File Dialog
  if Open1099File.Execute(self.Handle) then begin
    edFile1.Text := Open1099File.FileName;
    sFileSpec1 := edFile1.Text;
  end;
end;


procedure TSendSupport.btnFind2Click(Sender: TObject);
var
  StartName : String;
begin
  Open1099File.InitialDir := Settings.DataDir;
  Open1099File.DefaultExt := '.pdf';
  // 2017-02-23 MB - old filter only included 'Broker 1099 File|*.pdf'
  Open1099File.Filter := 'Broker 1099 File|*.pdf'
    + '|Excel XLS File|*.xls'
    + '|CSV data file|*.csv'
    + '|Text file|*.txt';
  // 2017-02-23 MB - new filter
  Open1099File.FileName := '*' + Open1099File.DefaultExt;
  // use Open File Dialog
  if Open1099File.Execute(self.Handle) then begin
    edFile2.Text := Open1099File.FileName;
    sFileSpec2 := edFile2.Text;
  end;
end;


procedure TSendSupport.btnFind3Click(Sender: TObject);
var
  StartName : String;
begin
  Open1099File.InitialDir := Settings.DataDir;
  Open1099File.DefaultExt := '.pdf';
  // 2017-02-23 MB - old filter only included 'Broker 1099 File|*.pdf'
  Open1099File.Filter := 'Broker 1099 File|*.pdf'
    + '|Excel XLS File|*.xls'
    + '|CSV data file|*.csv'
    + '|Text file|*.txt';
  // 2017-02-23 MB - new filter
  Open1099File.FileName := '*' + Open1099File.DefaultExt;
  // use Open File Dialog
  if Open1099File.Execute(self.Handle) then begin
    edFile3.Text := Open1099File.FileName;
    sFileSpec3 := edFile3.Text;
  end;
end;


// ----------+
//   SEND    |
// ==========+
procedure TSendSupport.SendSupportFiles;
var
  suptFileName, suptName, reply, myDetails, s, t, sSSNEIN : String;
  sFile, sPath, sUploadFile, sVer : string;
  i, p, iTaxYear : Integer;
  bZD : boolean;
begin
  myDetails := '';
  msgTxt := '';
  // required fields
  if (edName.Text = '') then begin
    msgTxt := 'Please provide your name.' + cr + cr;
  end;
  if (length(edEmail.Text) < 3) //
  or (POS('@', edEmail.Text) < 2) //
  then begin
    msgTxt := msgTxt + 'Please provide a valid email address which we can use' + cr
      + 'when replying.' + cr + cr;
  end;
  if (OccurrencesOfChar(edDetails.Text, ' ') < 5) then begin
    msgTxt := msgTxt
      + 'We need a more detailed description of what led up to' + cr
      + 'the error, or a reason why your are sending these files.' + cr + cr
      + '(Must be at least 6 words - try to explain clearly.)';
  end;
  // any error -> abort
  if msgTxt <> '' then begin
    sm('IMPORTANT:' + cr + cr + msgTxt);
    exit; // don't allow send until it's right!
  end;
  //-----------------------------------
  // process detail message
  myDetails := '';
  for i := 0 to edDetails.lines.count - 1 do
    myDetails := myDetails + edDetails.lines[i] + crlf;
  myDetails := StringReplace(myDetails, '&', '+', [rfReplaceAll]);
  t := CRLF;
  s := StringReplace(myDetails, ';', ',', [rfReplaceAll]);
  s := StringReplace(s, t, '<br />', [rfReplaceAll]);
  t := CR;
  myDetails := StringReplace(s, t, '<br />', [rfReplaceAll]);
  // visual cues to the user
  SendSupport.hide;
  statBar('Sending Support Request. Please Wait...');
  screen.Cursor := crHourglass;
  // --------------------------------------------
  sSSNEIN := ProHeader.taxpayer; // keep a copy
  ProHeader.taxpayer := ''; // erase SSNEIN
  sFile := TradeLogFile.FileName; // look these up just once
  sPath := Settings.DataDir;
  iTaxYear := TradeLogFile.TaxYear;
  TradeLogFile.SaveFileAs(sFile, sPath, iTaxYear, true);
  // --------------------------------------------
  // 0. Create screen shot (already done)
  // 1. Create Zip file (here)
  suptFileName := TLSupportLib.CreateSupportFile(TrFileName, ckbImport.Checked);
  // --------------------------------------------
  ProHeader.taxpayer := sSSNEIN; // restore SSN
  TradeLogFile.SaveFileAs(sFile, sPath, iTaxYear, true);
  // --------------------------------------------
  if FileExists(suptFileName) then begin
    suptName := edName.Text;
    p := pos(' ', suptName);
    while p > 0 do begin
      delete(suptName, p, 1);
      insert('_', suptName, p);
      p := pos(' ', suptName);
    end;
    SendSupport.close;
    sVer := GetVersionInfo('FileVersion');
    try
      screen.Cursor := crHourglass; // really, no function should fool with this
      // it should only be changed in form events - keep user interface together
      // ----------------------------------------
      // Upload the Zip file to the server
      // ----------------------------------------
      sUploadFile := suptName + FormatDateTime('-yyyyMMdd-hhnnss', now);
      // ----------------
      bZD := TLSupportLib.PSCP_Send(suptFileName, sUploadFile); // via PSCP
      if bZD = false then begin
        s := Settings.DataDir + '\MySupportFile.zip';
        if fileexists(s)=false then exit;
        // offer option to upload/email before deleting zip
        if messagedlg('Automatic upload failed for file' + CRLF //
          + 'Would you like to submit a request on our website?',
          mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        begin
          ShellExecute(Application.Handle, 'OPEN',
          pchar('explorer.exe'),
          pchar('/select, "' + s + '"'),
          nil,
          SW_NORMAL);
          webURL('https://support.tradelogsoftware.com/hc/en-us/requests/new');
        end;
        exit; // abort
      end;
      // ------------------------------
      // then send the email to gmail
      screen.Cursor := crHourglass;
      // ------------------------------
      // move the file to Zendesk
      // ------------------------------
      reply := ZendeskPullFile(v2UserToken, sUploadFile+'.zip');
      sleep(2000);
      // check to see if the file is in the download page
      reply := ReadURL('https://zendesk.brokerconnect.live/?file='+sUploadFile+'.zip');
      if pos('The file name doesn&#39;t exist. Click the link again from Zendesk.', reply) > 0 then begin
        sm('It appears there was a problem uploading your files.');
      end
      else if SuperUser and (pos('Download your files', reply) > 0) then begin
        sm('Confirmed: files have been received by Support.');
      end;
      // ------------------------------
      // Create Support Ticket
      // ------------------------------
      if (superuser = true) then begin
        if (messagedlg('SuperUser: Do you want to'  + CRLF //
          + 'create a ZenDesk ticket?', mtInformation, [mbYes,mbNo], 0) = mrYes)
        then
          bZD := true
        else
          bZD := false;
      end;
      if bZD then begin
        reply := ZendeskTicket(v2UserToken, sVer, sUploadFile+'.zip', myDetails, edEmail.Text, edName.text);
        if SuperUser then sm('Zendesk reply:' + CRLF + reply);
        // did it go through?
        if (pos('OK', reply)> 0) //
        or (pos('submitted successfully', reply)> 0) then begin
          sm('Your help request has been received by our Support team.' + cr //
            + cr //
            + 'We will contact you shortly.');
        end
        else begin
          sm('TradeLog successfully uploaded your file, but there was a problem' + cr //
            + 'creating your support ticket. This could be caused by a user name' + cr //
            + 'or email address which does not match our records.' + cr //
            + cr //
            + 'Please check the name and email and try again.');
        end;
      end; // if bZD
      statBar('off');
      close;
      exit;
    except
      on E: Exception do begin
        if messagedlg('TradeLog was unable to automatically submit a support' + CRLF //
          + 'ticket. Would you like to submit it manually on our website?',
          mtConfirmation, [mbYes,mbNo], 0) = mrYes then
        begin
          ShellExecute(Application.Handle, 'OPEN',
          pchar('explorer.exe'),
          pchar('/select, "' + s + '"'),
          nil,
          SW_NORMAL);
          webURL('https://support.tradelogsoftware.com/hc/en-us/requests/new');
        end;
        SendSupport.close;
      end;
    end; // try...except
  end
  else begin
    // no support file
  end; // if fileexists
  statBar('off');
end;


procedure TSendSupport.btnSendSupportClick(Sender : TObject);
var
  suptFileName, suptName, reply, myDetails, S, sSSNEIN : String;
  sFile, sPath : String;
  i, p, iTaxYear : Integer;
begin
  SendSupportFiles;
end;


// [X] Include Import Folder?
procedure TSendSupport.ckbInclude1099Click(Sender: TObject);
begin
  edFile1.Enabled := (ckbInclude1099.Checked);
  btnFind1.Enabled := (ckbInclude1099.Checked);
  edFile2.Enabled := (ckbInclude1099.Checked);
  btnFind2.Enabled := (ckbInclude1099.Checked);
  edFile3.Enabled := (ckbInclude1099.Checked);
  btnFind3.Enabled := (ckbInclude1099.Checked);
  if not ckbInclude1099.Checked then edFile1.Text := '';
end;


procedure TSendSupport.edDetailsEnter(Sender: TObject);
begin
  btnSendSupport.Default:=false;
end;


procedure TSendSupport.edDetailsExit(Sender: TObject);
begin
  btnSendSupport.Default:=true;
end;


procedure TSendSupport.FormShow(Sender: TObject);
var
  webData:string;
begin
  statBar('Getting registered user name and email');
//  webData := readURL(SiteURL + 'support/get-email-addr/?regcode=' + Settings.Regcode);
//  edEmail.text := parseHTML(webData,'<email>','</email>');
//  edName.text := parseHTML(webData,'<name>','</name>');
  edEmail.Text := v2UserEmail;
  edName.Text := v2UserName;
  txtVer.Caption := Ver+' - '+createDate;
  edDetails.Text := '';
  statBar('off');
end;


procedure TSendSupport.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TSendSupport.FormActivate(Sender: TObject);
begin
  screen.cursor := crDefault;
  edDetails.SetFocus;
end;


procedure TSendSupport.FormCreate(Sender: TObject);
begin
  //
end;

procedure TSendSupport.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if key = 27 then close;
end;


end.
