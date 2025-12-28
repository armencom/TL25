unit dlgTaxfilePicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzLstBox, RzButton,
  Vcl.ExtCtrls;

type
  TdlgPickTaxFiles = class(TForm)
    pnlMain: TPanel;
    pnlButtons: TPanel;
    // ----------------------
    btnCopy: TRzButton;
    btnReset: TRzButton;
    btnDelete: TRzButton;
    btnClose: TRzButton;
    btnTracking: TRzButton;
    // ----------------------
    lstTaxfiles: TRzListBox;
    pnlTop: TPanel;
    lblTaxFiles: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    lblAvailable: TLabel;
    // ----------------------
    procedure LoadFileKeys(sEmail, sToken : string);
    procedure btnCopyClick(Sender: TObject);
    procedure btnResetClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnTrackingClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure lstTaxfilesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgPickTaxFiles : TdlgPickTaxFiles;
  FileCodes : TStrings;

implementation

{$R *.dfm}

uses
  clipBrd, funcproc, TL_API, globalVariables, TLCommonLib;


// ------------------------------------
// ------------------------------------
procedure TdlgPickTaxFiles.LoadFileKeys(sEmail, sToken : string);
var
  sTmp, sLine, sFC : string;
  i, j, k, nFileKeys, nFKAvail, nRetCode : integer;
  FKeyLst, lineLst : TStrings;
begin
  nFileKeys := 0;
  nFKAvail := 0;
  // ----------------------------------
  try
    screen.Cursor := crHourglass;
    sTmp := ListFileKeys(sToken);
    if (pos('no matching', lowercase(sTmp)) > 0) //
    or (sTmp = '') then begin
      exit;
    end;
    // --------------------------------
    dlgPickTaxFiles.Caption := 'File Keys for ' + sEmail;
    if not (SuperUser or Developer) then begin
      btnReset.Visible := false;
      btnDelete.Visible := false;
      btnClose.Caption := 'Close';
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
      if lineLst.Count > 15 then begin // first field is 0th
        if ((lineLst[7] = 'null') //
        or (lineLst[7] = '')) // FileName
        then begin
          nFKAvail := nFKAvail + 1;
          if (SuperUser or Developer) then begin
            lstTaxfiles.Add('<available>');
            sFC := lineLst[5];
            FileCodes.Add(sFC);
          end;
        end
        else begin
          sLine := lineLst[7]; // FileName
          lstTaxfiles.Add(sLine);
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
    screen.Cursor := crDefault;
  end;
  lblTaxFiles.Caption := intToStr(nFileKeys-nFKAvail);
  lblAvailable.Caption := intToStr(nFKAvail);
end;


// ------------------------------------
// These buttons all close the form
// ------------------------------------
procedure TdlgPickTaxFiles.btnCloseClick(Sender: TObject);
begin
  // close - returns mrCancel
end;

procedure TdlgPickTaxFiles.btnCopyClick(Sender: TObject);
begin
  // copy - returns mrNone
  clipboard.asText := StringReplace(lstTaxFiles.Items.text, #$A, '', [rfReplaceAll]);
  sm(intToStr(lstTaxFiles.Count) //
    + ' File Key linked FileNames' + CRLF //
    + 'were copied to the Windows Clipboard.');
end;

procedure TdlgPickTaxFiles.btnResetClick(Sender: TObject);
var
  i : integer;
  s : string;
begin
  // reset - returns mrOK
  for i := 0 to lstTaxFiles.Count-1 do begin
    if lstTaxFiles.Selected[i] then begin
      s := lstTaxFiles.Items[i];
      if s = '<available>' then
        ModalResult := mrNone;
    end;
  end;
  // triggers reset portion of calling routine
end;

procedure TdlgPickTaxFiles.btnDeleteClick(Sender: TObject);
begin
  // delete - returns mrYes
  // triggers delete portion of calling routine
end;


// ------------------------------------
// This button displays Tracking info
// for selected item(s).
// ------------------------------------
procedure TdlgPickTaxFiles.btnTrackingClick(Sender: TObject);
var
  i, j : integer;
  sFKC, sFKL, sTmp, s : string;
  lineLst : TStrings;
  bFKOnce, bFKLast : boolean;
begin
  bFKOnce := false;
  bFKLast := false;
  try
    for i := 0 to lstTaxFiles.Count-1 do begin
      if lstTaxFiles.Selected[i] then begin
        sFKC := lstTaxFiles.Items[i];
        sFKL := FileCodes[i];
        s :=  GetFileKeyLog(v2ClientToken, sFKL);
        if pos('ERROR', s) > 0 then break;
        sTmp := ParseHTML(s,'[',']');
        if sTmp = '' then break;
        lineLst := ParseV2APIResponse(sTmp);
        sTmp := 'Tracking info for selected items:';
        for j := 0 to lineLst.Count-1 do begin
          s := trim(lineLst[j]);
          if s = '' then continue;
          if (pos('FileKeyId', s) > 0) then begin
            if bFKOnce then begin
              sTmp := sTmp + CRLF;
              bFKLast := true;
            end
            else begin
              sTmp := sTmp + CRLF + 'FileKey: ';
              bFKOnce := true; // just once!
            end;
          end
          else if s[1] = '{' then
            continue
          else if s[1] = '}' then
            continue
          else if s[1] = '"' then
            sTmp := sTmp + CRLF + parseHTML(s,'"','"') + ': '
          else if bFKLast then
            bFKLast := false // but don't include in sTmp
          else
            sTmp := sTmp + s;
        end; // for j
        break; // exit for i loop
      end; // if selected
    end; // for i
  except
    On E : Exception do begin
      sTmp := 'ERROR: ' + E.Message;
    end; // on E
  end; // try...except
  sm(sTmp);
end;

procedure TdlgPickTaxFiles.FormCreate(Sender: TObject);
begin
  //
end;

procedure TdlgPickTaxFiles.lstTaxfilesClick(Sender: TObject);
begin
  // de-select with ctrl+click
end;


end.
