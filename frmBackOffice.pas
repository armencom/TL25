unit frmBackOffice;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, IdHTTP;

type
  TdlgBackOffice = class(TForm)
    lblEmailAddr: TLabel;
    edEmailAddr: TEdit;
    btnAddFileKey: TButton;
    Label2: TLabel;
    lblUserName: TLabel;
    edUserName: TEdit;
    lblDateCreated: TLabel;
    edDateCreated: TEdit;
    lblTrialExpires: TLabel;
    edTrialExpires: TEdit;
    pnlSubs: TPanel;
    lblSubscription: TLabel;
    lblProduct: TLabel;
    edProduct: TEdit;
    lblSubExpires: TLabel;
    edSubExpires: TEdit;
    lblFileKeyInfo: TLabel;
    lblNumTotal: TLabel;
    lblNumUsed: TLabel;
    lblAvail: TLabel;
    edTotal: TEdit;
    edUsed: TEdit;
    edAvail: TEdit;
    btnChangeSub: TButton;
    btnSearch: TButton;
    btnListFileKeys: TButton;
    btnAddFreeKey: TButton;
    procedure ClearForm;
    procedure FillOutForm(sToken: string);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnAddFileKeyClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure edEmailAddrChange(Sender: TObject);
    procedure btnListFileKeysClick(Sender: TObject);
    procedure btnChangeSubClick(Sender: TObject);
    procedure btnAddFreeKeyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgBackOffice: TdlgBackOffice;

implementation

uses
  Main, dlgTaxfilePicker, funcproc, globalVariables, TL_API, TLCommonLib;

var
  sUnitEmail, sUnitToken : string;

{$R *.dfm}

// GOAL: Add a Super User function that helps us check
// - if someone has an active subscription and
// - what level it is?
// If we enter email, it returns
// - sub level and
// - Exp date
// - File keys available

const
  FREE_FILE_KEY : string = 'TRUE';
  PAID_FILE_KEY : string = 'FALSE';


procedure TdlgBackOffice.btnAddFileKeyClick(Sender: TObject);
var
  s : string;
begin
  // confirm
  if messagedlg('You are about to add a File Key to this User.' + CRLF //
    + 'This is a Paid File Key (purchased separately).' + CRLF //
    + 'Are you sure you want to do that?', mtWarning, mbOKCancel, 0) = mrOK
  then begin
    s := SuperInsertFileKey(edEmailAddr.Text, PAID_FILE_KEY);
    if (pos('FileKeyId', s)>0) then
      sm('One File Key added. ')
    else
      sm('error: ' + s);
  end
  else begin
    sm('Add File Key canceled.');
  end;
  FillOutForm(sUnitToken);
end;


procedure TdlgBackOffice.btnAddFreeKeyClick(Sender: TObject);
var
  s : string;
begin
  // confirm
  if messagedlg('You are about to add a File Key to this User.' + CRLF //
    + 'This is Free File Key (included with subscription).' + CRLF //
    + 'Are you sure you want to do that?', mtWarning, mbOKCancel, 0) = mrOK
  then begin
    s := SuperInsertFileKey(edEmailAddr.Text, FREE_FILE_KEY);
    if (pos('FileKeyId', s)>0) then
      sm('One File Key added. ')
    else
      sm('error: ' + s);
  end
  else begin
    sm('Add File Key canceled.');
  end;
  FillOutForm(sUnitToken);
end;


procedure TdlgBackOffice.btnChangeSubClick(Sender: TObject);
begin
  //
end;


procedure TdlgBackOffice.btnListFileKeysClick(Sender: TObject);
var
  sResult, sEmail, sToken, sTmp, sLine, sFC : string;
  i, j, k, nFileKeys, nFKAvail, nRetCode : integer;
  FKeyLst, lineLst : TStrings;
  f: TdlgPickTaxFiles;
begin
  // get available TaxFiles
  sEmail := edEmailAddr.Text;
  sToken := sUnitToken;
  nFileKeys := 0;
  nFKAvail := 0;
  // ----------------------------------
  try
    screen.Cursor := crHourglass;
    sTmp := ListFileKeys(sToken);
    if (sTmp = '') or (pos('no matching', lowercase(sTmp)) > 0) then begin
      sm('no File Keys found for email' + CR + sEmail);
      exit;
    end;
    // --------------------------------
    f := TdlgPickTaxFiles.Create(nil);
    f.Caption := 'File Keys for ' + sEmail;
    if not (SuperUser or Developer) then begin
      f.btnReset.Visible := false;
      f.btnDelete.Visible := false;
      f.btnClose.Caption := 'Close';
    end;
    j := 1;
    // --------------------------------
    FKeyLst := ParseJSON(sTmp); // {FileKey1},{FileKey2}...
    FileCodes := TStringList.Create;
    try
    for i := 0 to FKeyLst.Count-1 do begin
      sTmp := FKeyLst[i];
      nFileKeys := nFileKeys + 1;
      lineLst := ParseV2APIResponse(sTmp);
      if assigned(lineLst)=false then continue;
      if lineLst.Count > 13 then begin
        if ((lineLst[7] = 'null') or (lineLst[7] = '')) // FileName
        and ((lineLst[15] = 'null') or (lineLst[15] = '')) // CanceledDate
        then begin
          nFKAvail := nFKAvail + 1;
          f.lstTaxfiles.Add('<available>');
          sFC := lineLst[5];
          FileCodes.Add(sFC);
        end
        else begin
          sLine := lineLst[7]; // FileName
          f.lstTaxfiles.Add(sLine);
          sFC := lineLst[5];
          FileCodes.Add(sFC);
        end;
      end;
    end;
    except
      On E : Exception do begin
        sTmp := 'ERROR: ' + E.Message;
      end; // on E
    end;
  finally
    StatBar('off');
    screen.Cursor := crDefault;
  end;
  f.lblTaxFiles.Caption := intToStr(nFileKeys-nFKAvail);
  f.lblAvailable.Caption := intToStr(nFKAvail);
  nRetCode := f.ShowModal;
  // --------------------------------------------
  // Process return code from dlgTaxfilePicker
  // --------------------------------------------
  try
    if (nRetCode = mrOK) then begin
      if f.lstTaxfiles.SelCount < 1 then begin
        sm('Please select a File Key first.');
      end
      else if f.lstTaxFiles.SelCount > 1 then begin
        sTmp := 'Are you sure you want to completely reset' + CRLF
          + IntToStr(f.lstTaxfiles.SelCount) + ' File Keys from' + CRLF
          + 'eMail = ' + edEmailAddr.Text;
        if mdlg(sTmp, mtWarning, mbYesNo, 0) <> mrYes then exit;
      end;
      // -- delete selected taxfiles ----
      for i := 0 to f.lstTaxfiles.Items.Count-1 do begin
        if f.lstTaxfiles.Selected[i] then begin
          // delete it
          sTmp := f.lstTaxfiles.Items[i]; // this is the file key Name
          if (i >= FileCodes.Count) then
            sTmp := 'ERROR: not enough file codes for list box';
          sFC := FileCodes[i];
          // release a used file key
          sResult := UpdateFileKey(sToken, sEmail, sFC, '', '', '0');
        end;
      end;
    end // if nRetCode...
    else if (nRetCode = mrYes) then begin // DELETE
      if f.lstTaxfiles.SelCount < 1 then begin
        sm('Please select a File Key first.');
      end
      else if f.lstTaxFiles.SelCount > 1 then begin
        sTmp := 'Are you sure you want to completely delete' + CRLF
          + IntToStr(f.lstTaxfiles.SelCount) + ' File Keys from' + CRLF
          + 'eMail = ' + edEmailAddr.Text;
        if mdlg(sTmp, mtWarning, mbYesNo, 0) <> mrYes then exit;
      end;
      // -- delete selected taxfiles ----
      for i := 0 to f.lstTaxfiles.Items.Count-1 do begin
        if f.lstTaxfiles.Selected[i] then begin
          // delete it
          sTmp := f.lstTaxfiles.Items[i]; // this is the file key Name
          if (sTmp <> '<available>') then begin
            sm('Cannot delete used FileKey!' + CRLF //
              + 'You may reset it first, then delete it.');
          end
          else begin
            sFC := FileCodes[i];
            // delete an available file key
            sResult := SuperDeleteFileKey(v2UserToken, sEmail, sFC);
          end;
        end;
      end;
    end; // if nRetCode...
  finally
    f.free;
  end;
  FileCodes.Free;
  FillOutForm(sUnitToken);
end;



procedure TdlgBackOffice.ClearForm;
var
  s, sTmp : string;
  i, j, k, nFileKeys, nFKAvail : integer;
  FKeyLst, lineLst : TStrings;
  dt1 : TDate;
begin
  edUserName.Text := '';
  edDateCreated.Text := '';
  edTrialExpires.Text := '';
  edProduct.Text := '';
  edSubExpires.Text := '';
  edTotal.Text := '';
  edUsed.Text := '';
  edAvail.Text := '';
end;


procedure TdlgBackOffice.btnSearchClick(Sender: TObject);
var
  sEmail, s : string;
begin
  ClearForm;
  sEmail := trim(edEmailAddr.Text);
  s := Impersonate(sEmail); // save for later
  sUnitToken := s;
  if (pos('ERROR', sUnitToken) > 0) //
  or (pos('message', sUnitToken) > 0) //
  then begin
    sm(sUnitToken); // only SuperUsers see this
  end;
  FillOutForm(sUnitToken);
end;

procedure TdlgBackOffice.edEmailAddrChange(Sender: TObject);
begin
  sUnitEmail := edEmailAddr.Text;
  btnAddFileKey.Enabled := false; // must be sure!
end;


procedure TdlgBackOffice.FillOutForm(sToken: string);
var
  s, sTmp : string;
  i, j, k, nFileKeys, nFKAvail : integer;
  FKeyLst, lineLst : TStrings;
  dt1 : TDate;
begin
  screen.Cursor := crHourglass;
  try
    // --- ListAllUsers ---------------------------------------
    // [{"UserId":8244,                   // not used
    //   "CustomerId":20050,              // unknown to TL
    //   "Name":"Virender Mann",          // display name
    //   "Email":"virender@mannrei.com",  // TL's user ID
    //   "Manager":0,                     // reg/pro/super user
    //   "DateCreated":1670104500953}]    // 30 days free trial
    s := ListAllUsers(sToken);
    s := ParseHtml(s, '{', '}');
    lineLst := ParseV2APIResponse(s);
    for i := 0 to lineLst.Count-1 do begin
      if uppercase(lineLst[i]) = 'NAME' then
        edUserName.Text := lineLst[i+1]
      else if uppercase(lineLst[i]) = 'DATECREATED' then begin
        s := lineLst[i+1]; //
        dt1 := FastSpringToDate(s);
        edDateCreated.Text := DateToStr(dt1);
        edTrialExpires.Text := DateToStr(dt1+30);
      end;
    end;
    // --- GetSubscriptions -----------------------------------
    // [{"UserToken":"201a28b8-9c26-11ed-929d-f23c938e66e4",
    //   "CustomerId":20050,
    //   "OrderId":"rg97Yu6MQGuXujcrSaWGhQ",
    //   "Product":"investor",                // display
    //   "Sku":"1005",                        //
    //   "StartDate":1670104499397,           // display
    //   "EndDate":1701561600000,             // display
    //   "DateCreated":1670104501079}]
    s := GetSubscriptions(sToken);
    s := ParseHtml(s, '{', '}');
    lineLst := ParseV2APIResponse(s);
    for i := 0 to lineLst.Count-1 do begin
      if uppercase(lineLst[i]) = 'PRODUCT' then
        edProduct.Text := lineLst[i+1]
      else if uppercase(lineLst[i]) = 'ENDDATE' then begin
        s := lineLst[i+1]; //
        dt1 := FastSpringToDate(s);
        edSubExpires.Text := DateToStr(dt1);
      end;
    end;
    // --- ListFileKeys -----------------------------------------
    nFileKeys := 0;
    nFileKeys := 0;
    s := ListFileKeys(sToken);
    j := 1;
    if pos('FileCode', s) > 0 then begin
      FKeyLst := ParseJSON(s); // {FileKey1},{FileKey2}...
      for i := 0 to FKeyLst.Count-1 do begin
        sTmp := FKeyLst[i];
        nFileKeys := nFileKeys + 1;
        lineLst := ParseV2APIResponse(sTmp);
        if assigned(lineLst)=false then continue;
        if lineLst.Count > 13 then begin
          if ((lineLst[7] = 'null') //
          or (lineLst[7] = '')) // FileName
          then
            nFKAvail := nFKAvail + 1
        end;
      end;
    end;
    edTotal.Text := IntToStr(nFileKeys);
    edUsed.Text := IntToStr(nFileKeys-nFKAvail);
    edAvail.Text := IntToStr(nFKAvail);
    btnAddFileKey.Enabled := true;
  finally
    screen.Cursor := crDefault;
  end;
end;


procedure TdlgBackOffice.FormActivate(Sender: TObject);
var
  s : string;
  lineLst : TStrings;
  i : Integer;
  dt1 : TDate;
begin
  if frmMain.btnGetBeta.Enabled then begin
    // no file open
    btnSearch.Enabled := true;
    edEmailAddr.ReadOnly := false;
    edEmailAddr.Color := clWindow;
  end
  else begin // a file is already open
    btnSearch.Enabled := false;
    edEmailAddr.ReadOnly := true;
    edEmailAddr.Text := v2ClientEmail;
    edEmailAddr.Color := clGradientInactiveCaption;
    sUnitToken := v2ClientToken;
    FillOutForm(sUnitToken);
  end;
end;


procedure TdlgBackOffice.FormCreate(Sender: TObject);
begin
  //
end;

end.
