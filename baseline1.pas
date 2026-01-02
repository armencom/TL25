unit baseline1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, RzCmboBx, RzEdit,
  Vcl.ExtCtrls, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxStyles, cxCustomData, cxFilter, cxData,
  cxDataStorage, cxEdit, cxNavigator, Data.DB, cxDBData, cxGridLevel,
  cxClasses, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGrid, Vcl.Mask, RzButton, cxTextEdit,
  cxCurrencyEdit, cxMaskEdit, cxDropDownEdit, Vcl.Buttons, RzPanel, RzLabel,
  Vcl.OleCtrls, SHDocVw, cxCalendar, cxContainer, Vcl.ComCtrls, dxCore,
  cxDateUtils, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinscxPCPainter;

type
  //TMsgDlgBtn = (mbYes, mbNo, mbOK, mbCancel, mbAbort, mbRetry, mbIgnore, mbAll, mbNoToAll, mbYesToAll, mbHelp, mbClose);
  TpnlBaseline1 = class(TForm)
    pnlTitle: TPanel;
    pnlTitleLeft: TPanel;
    lblTitle: TLabel;
    pnlClose: TPanel;
    btnClose: TRzButton;
    pnlLastNext: TPanel;
    pnlStep4right: TPanel;
    btnNext: TRzButton;
    btnLast: TRzButton;
    pnlStep1: TPanel;
    pnlStep1btns: TPanel;
    pnlHoldings: TPanel;
    pnlBtnHoldings: TPanel;
    btnHoldings: TRzButton;
    pnlUnsettled: TPanel;
    pnlBtnUnsettled: TPanel;
    btnUnsettled: TRzButton;
    pnlMain: TPanel;
    pnlType: TPanel;
    lblInstrType: TLabel;
    lblTick: TLabel;
    lblShares: TLabel;
    lblContrMult: TLabel;
    lblLS: TLabel;
    edShares: TEdit;
    cboTypeMult: TRzComboBox;
    cboContrMult: TRzComboBox;
    cboLS: TRzComboBox;
    pnlAdd: TPanel;
    pnlOption: TPanel;
    lblStrike: TLabel;
    lblCallPut: TLabel;
    cboCallPut: TRzComboBox;
    edStrike: TEdit;
    btnAdd: TRzButton;
    pnlGrid: TPanel;
    cxGrid1: TcxGrid;
    cxGrid1TableView1: TcxGridTableView;
    colOC: TcxGridColumn;
    colLS: TcxGridColumn;
    colTicker: TcxGridColumn;
    colShares: TcxGridColumn;
    colTypeMult: TcxGridColumn;
    cxGrid1Level1: TcxGridLevel;
    pnlStep2: TPanel;
    pnlStep3: TPanel;
    pnlImport: TPanel;
    btnImport: TRzButton;
    btnImpUG: TRzButton;
    pnlStep4: TPanel;
    pnlFinish: TPanel;
    btnFind: TRzButton;
    pnlStepx: TPanel;
    lblStepa: TRzLabel;
    lblStep: TRzLabel;
    lblLastYear: TRzLabel;
    pnl2Instr2: TRzPanel;
    RzLabel1: TRzLabel;
    RzLabel9: TRzLabel;
    pnl2Instr3: TRzPanel;
    RzLabel10: TRzLabel;
    pnl2Instr1: TRzPanel;
    RzLabel11: TRzLabel;
    RzLabel13: TRzLabel;
    Panel2: TPanel;
    pnl4Instr3: TRzPanel;
    RzLabel18: TRzLabel;
    pnl4Instr2: TRzPanel;
    RzLabel20: TRzLabel;
    RzLabel21: TRzLabel;
    pnl4Instr1: TRzPanel;
    RzLabel22: TRzLabel;
    RzLabel23: TRzLabel;
    tmrTickFocus: TTimer;
    edTick: TRzEdit;
    pnlStep5: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    RzPanel2: TRzPanel;
    RzLabel19: TRzLabel;
    RzPanel4: TRzPanel;
    RzLabel24: TRzLabel;
    RzLabel25: TRzLabel;
    btnContinueImporting: TRzButton;
    wbStep3: TWebBrowser;
    wbStep1: TWebBrowser;
    wbStep1a: TWebBrowser;
    colDate: TcxGridColumn;
    colComm: TcxGridColumn;
    colAmt: TcxGridColumn;
    colPrice: TcxGridColumn;
    btnFinish: TRzButton;
    RzPanel1: TRzPanel;
    RzLabel2: TRzLabel;
    RzLabel3: TRzLabel;
    bntRemove: TRzButton;
    lblExpdate: TLabel;
    cboDay: TRzComboBox;
    cboMonth: TRzComboBox;
    cboYear: TRzComboBox;
    cboDayOfWeek: TRzComboBox;
    btnGetOpenPos: TRzButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cboTypeMultChange(Sender: TObject);
    procedure edSharesExit(Sender: TObject);
    procedure edStrikeExit(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnLastClick(Sender: TObject);
//    procedure btnEditRecClick(Sender: TObject);
//    procedure btnDelRecClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure doStep;
    procedure btnFindClick(Sender: TObject);
    procedure btnImpUGClick(Sender: TObject);
    procedure EnterRemainingPositions(zero:boolean=false);
    procedure pnlStep1Resize(Sender: TObject);
    procedure resizeStep1Btns;
//    procedure btnNothingClick(Sender: TObject);
    procedure btnHoldingsClick(Sender: TObject);
    procedure btnUnsettledClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormResize(Sender: TObject);
    procedure tmrTickFocusTimer(Sender: TObject);
    procedure btnContinueImportingClick(Sender: TObject);
    procedure loadHTML(wb : TWebBrowser; HTMLCode: string);
    procedure wbStep3DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure wbStep1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure wbStep1aDocumentComplete(ASender: TObject;
      const pDisp: IDispatch; const URL: OleVariant);
    procedure colCommPropertiesEditValueChanged(Sender: TObject);
    procedure colCommPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure colAmtPropertiesEditValueChanged(Sender: TObject);
    procedure colAmtPropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure colPricePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure colPricePropertiesEditValueChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnFinishClick(Sender: TObject);
    function checkDate(myDate:variant; option:boolean=false):boolean;
    procedure colDatePropertiesInitPopup(Sender: TObject);
    procedure colDatePropertiesValidate(Sender: TObject;
      var DisplayValue: Variant; var ErrorText: TCaption;
      var Error: Boolean);
    procedure bntRemoveClick(Sender: TObject);
    procedure cboDayChange(Sender: TObject);
    procedure cboDayOfWeekChange(Sender: TObject);
    procedure cboMonthChange(Sender: TObject);
    procedure cboYearChange(Sender: TObject);
    procedure btnGetOpenPosClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  pnlBaseline1: TpnlBaseline1;
  impBaseline, impCancelled : boolean;
  blFromDate, blToDate : TDate;
  blPositionsCnt : Integer;

implementation

{$R *.dfm}

uses
  TLCommonLib, TLSettings, funcProc, Main, TLregister, import, TLFile,
  TLEndYear, selImpMethod, TLDateUtils,
  globalVariables, recordClasses, baseline, activex, MSHTML, dateUtils, StrUtils;

const
  pnlStepHeight = 140;

var
  moreOpens, noTradesImported: boolean;
  blStep: integer;
  fromDateTxt, toDateTxt, openPosFileName : string;
  lastDayOfYear, blLastBizDate : TDate;

// ------------------------------------
function cDlg(CONST Msg: string; DlgTypt: TmsgDlgType; button: TMsgDlgButtons;
  Caption: ARRAY OF string; defbutton: TMsgDlgBtn): Integer;
var
  aMsgdlg: TForm;
  i: Integer;
  Dlgbutton: Tbutton;
  Captionindex: Integer;
begin
  aMsgdlg := createMessageDialog(Msg, DlgTypt, button, defbutton);
  //aMsgdlg.BiDiMode := bdRightToLeft;
  Captionindex := 0;
  for i := 0 to aMsgdlg.componentcount - 1 do begin
    if (aMsgdlg.components[i] is Tbutton) then begin
      Dlgbutton := Tbutton(aMsgdlg.components[i]);
      Dlgbutton.Cancel := false;
    { if (Dlgbutton.Caption='Cancel') then begin
        Dlgbutton.ModalResult := mrCancel;
      end
      else if (Dlgbutton.Caption='OK') then begin
        Dlgbutton.ModalResult := mrOK;
      end
      else if (Dlgbutton.Caption='Abort') then begin
        Dlgbutton.ModalResult := mrAbort;
      end;
    }
      if Captionindex <= High(Caption) then
        Dlgbutton.Caption := Caption[Captionindex];
      inc(Captionindex);
    end;
  end;
  Result := aMsgdlg.Showmodal;
end;

// ------------------------------------
// Save Baseline OpenPos for later
// ------------------------------------
procedure SaveOpenPos;
var
  openPosStr: string;
  openPOsFile: TextFile;
  i: Integer;
begin
  // save to open positions text file
  with pnlBaseline1.cxGrid1TableView1.DataController do begin
    openPosStr := '';
    if ( RecordCount> 0) then begin
      try
        blPositionsCnt := RecordCount;
        try
          AssignFile(openPosFile, openPosFileName);
          ReWrite(openPOsFile);
        except
          mDlg('Could not create ' + openPosFileName, mtError, [mbOK], 0);
        end;
        for i := 0 to RecordCount - 1 do begin
          openPosStr := values[i, 1] + tab + values[i, 2] + tab + values[i, 3] +
            tab + values[i, 4] + tab + values[i, 6];
          WriteLn(openPOsFile, openPosStr);
        end;
      finally
        CloseFile(openPOsFile);
      end;
    end;
  end;
end;


//function thirdSat(mon,year:string):string;
//var
//  i:integer;
//  day:string;
//begin
//  for i:= 1 to 31 do begin
//    day := IntToStr(i);
//    if i < 10 then day:= '0'+day;
//    if (dayOfWeek(strToDate(day+'/'+mon+'/'+year)) = 7) then exit;
//  end;
//  result:= day;
//end;


function TpnlBaseline1.checkDate(myDate: Variant; option: boolean = false): boolean;
begin
  with cxGrid1 do begin
    if myDate <> null then begin
      if option then begin
        if xStrToDate(myDate,Settings.InternalFmt) >= settlementStartDate(lastDayOfYear)+2 then
          result := false
        else
          result := true;
      end
      else begin
        if xStrToDate(myDate,Settings.InternalFmt) >= settlementStartDate(lastDayOfYear) then
          result := false
        else
          result := true;
      end; // if option
    end; // if myDate
  end; // with cxGrid1
end;


function dec2Months(myDate:Tdate):TDate;
var
  year, month, day : word;
begin
  decodeDate(myDate,year,month,day);
  if month > 2 then
    month := month - 2
  else begin
    month := Month + 12 - 2;
    dec(year);
  end;
  result:= encodeDate(year,month,day);
end;


procedure TpnlBaseline1.resizeStep1Btns;
begin
  btnHoldings.left := (pnlBtnHoldings.Width - btnHoldings.width) div 2;
  btnUnsettled.left := (pnlBtnUnsettled.Width - btnUnsettled.width) div 2;
end;


procedure TpnlBaseline1.btnContinueImportingClick(Sender: TObject);
var
  i : integer;
begin
  blToDate := blFromDate -1;
  blFromDate := dec2Months(blFromDate);
  blStep := 3;
  doStep;
end;


procedure TpnlBaseline1.tmrTickFocusTimer(Sender: TObject);
begin
  edTick.SetFocus;
  tmrTickFocus.Enabled := false;
end;


function checkNumber(s:string):string;
begin
  if not isFloat(s) then begin
    mDlg('Must be a decimal number', mtError, [mbOK], 1);
    result := '';
  end
  else if (strToFloat(s) < 0) then begin
    mDlg('Shares cannot be negative', mtError, [mbOK], 1);
    result := '';
  end
  else
    result := s;
end;


procedure TpnlBaseline1.FormCreate(Sender: TObject);
begin
  parent := frmMain;
  align := alClient;
  blStep := 0;
end;


procedure TpnlBaseline1.FormResize(Sender: TObject);
begin
  {if width < 600 then font.Size := 8 else
  if width < 1020 then font.Size := 10 else
  font.Size := 12;  }
end;


procedure TpnlBaseline1.btnCloseClick(Sender: TObject);
var
  R : integer;
  msgTxt : String;
begin
  if (cxGrid1TableView1.DataController.RecordCount = 0) then begin
    blPositionsCnt := -1;
    close;
    exit;
  end;
  if frmMain.cxGrid1TableView1.DataController.RowCount = 0 then begin
    msgTxt := '- Click "Exit" to close the wizard.' +cr
      + '  You can restart later and restore your entries in Step 2.' +cr +cr;
  end;
  msgTxt := msgTxt
    + '- Click "Finish" to close the wizard and save baseline positions found.' + cr
    + '  Positions not found will have a Date of 01/01/'+Taxyear+' and Price of 0.' + cr
    + '  You will need to look these up and enter manually.' + cr + cr
    + '- Click "Cancel" to return to the wizard.' + cr;
  if (pos('Exit',msgTxt)>0) then
    R := cDlg(msgTxt,mtInformation,[mbCancel,mbOK,mbAbort],['Cancel','Finish','Exit'],mbOK)
  else
    R := cDlg(msgTxt,mtInformation,[mbCancel,mbOk],['Cancel','Finish'],mbOK);
  //sm('R: '+intToStr(R));
  if (R = 2) then begin //Finish
    EnterRemainingPositions(true);
  end
  else if (R = 3) then begin //exit
    saveOpenPos;
    blPositionsCnt := -1;
    close;
  end;
end;


procedure TpnlBaseline1.FormShow(Sender: TObject);
var
  i : integer;
  expDate : TDate;
  opFolder, ext : string;
begin
  impBaseline := false;
  impCancelled := false;
  blPositionsCnt := 0;
  //create Baseline folder
  if not directoryExists(Settings.DataDir + '\Baseline') then
    createDir(Settings.DataDir + '\Baseline');
  //create file folder under Baseline
  opFolder := TrFileName;
  //remove file extension
  ext := parseLast(opFolder,'.tdf');
  if not directoryExists(Settings.DataDir + '\Baseline\'+opFolder) then
    createDir(Settings.DataDir + '\Baseline\'+opFolder);
  openPosFileName := Settings.DataDir + '\Baseline\'+opFolder+'\'+TradeLogFile.CurrentAcctName+'.txt';
  btnImport.Caption := frmMain.btnImport.Caption;
  cboTypeMult.Items.Add('Stock');
  cboTypeMult.Items.Add('Bond');
  cboTypeMult.Items.Add('Option');
  cboTypeMult.Items.Add('Mutual Fund');
  cboTypeMult.Items.Add('ETF/ETN');
  cboTypeMult.Items.Add('Drip');
  cboTypeMult.Items.Add('Future Contract');
  cboTypeMult.Items.Add('Future Option');
  cboTypeMult.Items.Add('Currency');
  cboTypeMult.ItemIndex:=0;

  cboCallPut.Items.Add('CALL');
  cboCallPut.Items.Add('PUT');
  cboCallPut.ItemIndex:= -1;

  cboDay.Text:= '31';
  cboMonth.Text:= 'DEC';
  cbOYear.Text:= taxYear;

  pnlLastNext.Show;
  pnlLastNext.Top := 40;
  pnlMain.Top:= 120;

  btnLast.Enabled := false;
  moreOpens := false;

  if blStep < 1  then blStep := 1;
  doStep;

  lblLastyear.Caption := intToStr(TradeLogFile.LastTaxYear);

  resizeStep1Btns;

  lastDayOfYear := xStrToDate('12/31/'+lastTaxYear,Settings.InternalFmt);

  cboDay.ClearItems;
  for i:= 1 to 9 do
    cboDay.Add('0'+intToStr(i));
  for i:= 10 to 31 do
    cboDay.Add(intToStr(i));
  cboDay.ItemIndex:= cboDay.Count-1;

  cboMonth.ClearItems;
  cboMonth.Add('JAN');
  cboMonth.Add('FEB');
  cboMonth.Add('MAR');
  cboMonth.Add('APR');
  cboMonth.Add('MAY');
  cboMonth.Add('JUN');
  cboMonth.Add('JUL');
  cboMonth.Add('AUG');
  cboMonth.Add('SEP');
  cboMonth.Add('OCT');
  cboMonth.Add('NOV');
  cboMonth.Add('DEC');
  cboYear.ClearItems;

  for i := 1 to 5 do
    cboYear.Add(intToStr(strToInt(TaxYear)-i));
  for i := 1 to 5 do
    cboYear.Add(intToStr(strToInt(TaxYear)+i-1));

  cboDayOfWeek.ClearItems;
  cboDayOfWeek.add('SUN');
  cboDayOfWeek.add('MON');
  cboDayOfWeek.add('TUE');
  cboDayOfWeek.add('WED');
  cboDayOfWeek.add('THU');
  cboDayOfWeek.add('FRI');
  cboDayOfWeek.add('SAT');

  //get Saturday after 3rd Fri
  expDate:= getOptExpDate('DEC', TaxYear) + 1;  //add 1 to get Sat
  //sm(dateToStr(expDate));
  cboDay.ItemIndex:= DayOfTheMonth(expDate)-1;
  cboDayOfWeek.ItemIndex := DayOfWeek(expDate)-1;
  cboMonth.ItemIndex := cboMonth.IndexOf('DEC');
  cboYear.ItemIndex := cboYear.IndexOf(TaxYear);
end;


procedure TpnlBaseline1.wbStep1aDocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  wbStep1a.OleObject.document.body.style.overflowX := 'hidden';
  wbStep1a.OleObject.document.body.style.overflowY := 'auto';
  wbStep1a.OleObject.document.body.style.borderstyle := 'none';
end;


procedure TpnlBaseline1.wbStep1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  wbStep1.OleObject.document.body.style.overflowX := 'hidden';
  wbStep1.OleObject.document.body.style.overflowY := 'auto';
  wbStep1.OleObject.document.body.style.borderstyle := 'none';
end;


procedure TpnlBaseline1.wbStep3DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; const URL: OleVariant);
begin
  wbStep3.OleObject.document.body.style.overflowX := 'hidden';
  wbStep3.OleObject.document.body.style.overflowY := 'auto';
  wbStep3.OleObject.document.body.style.borderstyle := 'none';
end;


procedure TpnlBaseline1.pnlStep1Resize(Sender: TObject);
begin
  resizeStep1Btns
end;


//procedure TpnlBaseline1.btnEditRecClick(Sender: TObject);
//begin
//  if cxGrid1TableView1.DataController.FocusedDataRowIndex = -1 then begin
//    sm('Please select a record to edit.');
//    exit;
//  end;
//  with cxGrid1TableView1 do begin
//    OptionsData.Editing:= true;
//    OptionsSelection.CellSelect:= true;
//    OptionsView.ShowEditButtons:= gsebForFocusedRecord;
//    with controller do begin
//      editingItem:= focusedItem;
//    end;
//  end;
//end;


//procedure TpnlBaseline1.btnDelRecClick(Sender: TObject);
//begin
//  if cxGrid1TableView1.DataController.FocusedDataRowIndex = -1 then begin
//    sm('Please select a record to delete.');
//    exit;
//  end;
//  cxGrid1TableView1.DataController.DeleteFocused;
//end;


procedure TpnlBaseline1.cboDayChange(Sender: TObject);
var
  expDate:TDate;
  mon:string;
begin
  //make sure Day is 2 digits  //2014-09-17
  if (length(cboDay.Text) < 2) then cboDay.Text := '0' + cboDay.Text;
  mon:= intToStr(cboMonth.ItemIndex+1);
  if (length(mon) < 2) then mon:= '0' + mon;
  expDate:= strToDate(mon+'/'+cboDay.Text+'/'+cboYear.Text,Settings.InternalFmt);
    //sm(dateToStr(expDate));
  cboDayOfWeek.ItemIndex:= DayOfWeek(expDate)-1;
end;


procedure TpnlBaseline1.cboDayOfWeekChange(Sender: TObject);
var
  expDate:TDate;
  mon:string;
  DOWprev, DOWchng: integer;
begin
  //change Day
  mon:= intToStr(cboMonth.ItemIndex+1);
  if length(mon)=1 then mon:= '0' + mon;
  expDate:= strToDate(mon+'/'+cboDay.Text+'/'+cboYear.Text,Settings.InternalFmt);
  //sm(dateToStr(expDate));
  DOWchng:= cboDayOfWeek.ItemIndex;
  DOWprev := DayOfWeek(expDate)-1;
  //sm(intToStr(DOWchng-DOWprev));
  cboDay.ItemIndex:= DayOfTheMonth(expDate)-1 +DOWchng-DOWprev;
end;


procedure TpnlBaseline1.cboMonthChange(Sender: TObject);
var
  expDate:TDate;
  day,mon,yr:string;
begin
  mon:= intToStr(cboMonth.ItemIndex+1);
  if length(mon)=1 then mon:= '0' + mon;
  day := intToStr(cboDay.ItemIndex+1);
  if length(day)=1 then day:= '0' + day;
  yr := cboYear.Text;
{ if mDlg('Do want to change the exiration day to the Saturday'+cr
    + 'following the 3rd Friday of the month?',
    mtInformation,[mbYes,mbNo],0) = mrNo
  then exit;
  //get 3rd Saturday
  expDate:= getOptExpDate(mon, cboYear.Text)+1;  //getOptExpDate gets 3rd Fri
    //sm(dateToStr(expDate));
  cboDay.ItemIndex:= DayOfTheMonth(expDate)-1;
}
  expDate := xStrToDate(mon+'/'+day+'/'+yr,settings.InternalFmt);
  //change DayOfWeek
  cboDayOfWeek.ItemIndex:= DayOfWeek(expDate)-1;
end;


procedure TpnlBaseline1.cboYearChange(Sender: TObject);
var
  expDate:TDate;
  day,mon,yr:string;
begin
  mon:= intToStr(cboMonth.ItemIndex+1);
  if length(mon)=1 then mon:= '0' + mon;
  day := intToStr(cboDay.ItemIndex+1);
  if length(day)=1 then day:= '0' + day;
  yr := cboYear.Text;
{ if mDlg('Do want to change the exiration day to the Saturday'+cr
    + 'following the 3rd Friday of the month?',
    mtInformation,[mbYes,mbNo],0) = mrNo
  then exit;
  //get 3rd Saturday
  expDate:= getOptExpDate(mon, cboYear.Text)+1;  //getOptExpDate gets 3rd Fri
    //sm(dateToStr(expDate));
  cboDay.ItemIndex:= DayOfTheMonth(expDate)-1;
}
  expDate := xStrToDate(mon+'/'+day+'/'+yr,settings.InternalFmt);
  //change DayOfWeek
  cboDayOfWeek.ItemIndex:= DayOfWeek(expDate)-1;
end;


procedure TpnlBaseline1.cboTypeMultChange(Sender: TObject);
begin
  lblTick.enabled := true;
  lblShares.enabled := true;
  lblShares.Caption := '# Shares:';
  edShares.enabled := true;
  edTick.enabled := true;
  lblContrMult.Visible := false;
  cboContrMult.Visible := false;
  cboContrMult.ItemIndex := 0;
  pnlOption.Visible := false;
  lblStrike.Visible := true;
  edStrike.Visible := true;
  lblCallPut.Visible := true;
  cboCallPut.Visible := true;
  cboCallPut.ItemIndex := 0;
  cboDay.show;
  cboDayOfWeek.Show;
  case cboTypeMult.ItemIndex of
    0 : lblTick.caption := 'Stock Ticker:';
    1 : lblTick.caption := 'Bond Description:';
    2 : begin              //option
          lblTick.caption := 'Stock Ticker:';
          lblShares.Caption := '# Contracts:';
          lblContrMult.Visible := true;
          cboContrMult.Visible := true;
          pnlOption.Visible := true;
        end;
    3 : lblTick.caption := 'Mutual Fund Ticker:';
    4 : lblTick.caption := 'ETF/ETN Ticker:';
    5 : lblTick.caption := 'Stock Ticker:';  //Drip
    6 : begin
          lblTick.caption := 'Future Symbol:';
          lblShares.Caption := '# Contracts:';
          lblContrMult.Visible := true;
          cboContrMult.Visible := true;
          pnlOption.Visible := true;
          lblStrike.Visible := false;
          edStrike.Visible := false;
          lblCallPut.Visible := false;
          cboCallPut.Visible := false;
          cboDay.Hide;
          cboDayOfWeek.hide;
        end;
    7 : begin              //future option
          lblTick.caption := 'Future Symbol:';
          lblShares.Caption := '# Contracts:';
          pnlOption.Visible := true;
          lblContrMult.Visible := true;
          cboContrMult.Visible := true;
          cboDay.Hide;
          cboDayOfWeek.hide;
        end;
    8 : begin              //Currency
          lblTick.caption := 'Currency Symbol:';
          lblShares.Caption := '# Contracts:';
//          lblContrMult.Visible := true;
//          lblContrMult.caption := '???';
//          cboContrMult.Visible := true;
        end;
  end;
end;


procedure TpnlBaseline1.colAmtPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  // sm('onEditValueChanged');
  if colPrice.EditValue = null then exit;
  OC := colOC.EditValue;
  ls := colLS.EditValue;
  Shares := colShares.EditValue;
  Price := colPrice.EditValue;
  ctype := colTypeMult.EditValue;
  if colComm.EditValue = null then
    Comm := 0
  else
    Comm := colComm.EditValue;
  amount := (TcxMaskEdit(Sender).EditValue);
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.InternalFmt)
  else
    mult := 1;
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then begin
    if amount > 0 then begin
      amount := -amount;
      colAmt.EditValue := amount;
    end;
    Comm := -amount - (Shares * Price * mult);
  end
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then begin
    if amount < 0 then begin
      amount := -amount;
      colAmt.EditValue := amount;
    end;
    Comm := (Shares * Price * mult) - amount;
  end;
  colComm.EditValue := Comm;
  colAmt.EditValue := amount;
  if Comm < 0 then sm('That Amount makes the commission negative.');
end;


procedure TpnlBaseline1.colAmtPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  if VarIsNull(DisplayValue) or (DisplayValue = '') then begin
    ErrorText := 'The Amount cannot be empty!';
    Error := true;
  end;
end;


procedure TpnlBaseline1.colCommPropertiesEditValueChanged(Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  if colPrice.EditValue = null then exit;
  OC := colOC.EditValue;
  ls := colLS.EditValue;
  Shares := colShares.EditValue;
  Price := colPrice.EditValue;
  ctype := colTypeMult.EditValue;
  Comm := (TcxMaskEdit(Sender).EditValue);
  if Comm < 0 then begin
    sm('WARNING:' + CR //
      + 'Commission should be entered as a positive number' + CR //
      + 'unless you are getting a commission credit or rebate.');
  end;
  colComm.EditValue := Comm;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.InternalFmt)
  else
    mult := 1;
  //
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  colAmt.EditValue := amount;
end;


procedure TpnlBaseline1.colCommPropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  Comm: double;
begin
  if (DisplayValue = '') then DisplayValue := '0';
end;


procedure TpnlBaseline1.colDatePropertiesInitPopup(Sender: TObject);
begin
  colDate.EditValue := dateToStr(settlementStartDate(lastDayOfYear)-1,Settings.InternalFmt);
end;


procedure TpnlBaseline1.colDatePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
var
  option : boolean;
begin
  if (pos('OPT',colTypeMult.EditValue) = 1) then
    option := true else option := false;
  if not checkDate(DisplayValue,option) then begin
    if option then begin
      mDlg('Date must be less than: ' + dateToStr(settlementStartDate(lastDayOfYear) + 2, Settings.UserFmt),
        mtWarning,[mbOK],1);
      DisplayValue := dateToStr(settlementStartDate(lastDayOfYear) + 1, Settings.UserFmt);
    end
    else begin
      mDlg('Date must be less than: ' + dateToStr(settlementStartDate(lastDayOfYear), Settings.UserFmt),
        mtWarning,[mbOK],1);
      DisplayValue := dateToStr(settlementStartDate(lastDayOfYear) - 1, Settings.UserFmt);
    end;
  end;
end;


procedure TpnlBaseline1.colPricePropertiesEditValueChanged(
  Sender: TObject);
var
  OC, ls, ctype: string;
  Shares, Price, Comm, amount, mult: double;
begin
  OC := colOC.EditValue;
  ls := colLS.EditValue;
  Shares := colShares.EditValue;
  Price := (TcxMaskEdit(Sender).EditValue);
  colPrice.EditValue := Price;
  ctype := colTypeMult.EditValue;
  if colComm.EditValue = null then
    Comm := 0
  else
    Comm := colComm.EditValue;
  delete(ctype, 1, pos('-', ctype));
  if ctype <> '' then
    mult := StrToFloat(ctype, Settings.UserFmt)
  else
    mult := 1;
  //
  if ((OC = 'O') and (ls = 'L'))
  or (((OC = 'C') or (OC = 'M')) and (ls = 'S')) then
    amount := -(Shares * Price * mult) - Comm
  else if (((OC = 'C') or (OC = 'M')) and (ls = 'L'))
  or ((OC = 'O') and (ls = 'S')) then
    amount := (Shares * Price * mult) - Comm
  else
    amount := 0;
  colAmt.EditValue := amount;
end;


procedure TpnlBaseline1.colPricePropertiesValidate(Sender: TObject;
  var DisplayValue: Variant; var ErrorText: TCaption; var Error: Boolean);
begin
  if VarIsNull(DisplayValue) or (DisplayValue = '') or (DisplayValue = '0') then begin
    ErrorText := 'Price cannot be zero or empty!';
    Error := true;
  end;
end;


procedure TpnlBaseline1.edSharesExit(Sender: TObject);
begin
  if edShares.Text = '' then exit;
  edShares.Text := checkNumber(edShares.Text);
  if edShares.Text = '' then edShares.SetFocus;
end;


procedure TpnlBaseline1.edStrikeExit(Sender: TObject);
begin
  if edStrike.Text = '' then exit;
  edStrike.text := checkNumber(edStrike.Text);
  if edStrike.Text = '' then edStrike.SetFocus;
  // remove trailing zeros
  edStrike.Text := delTrailingZeros(edStrike.Text);
end;


procedure TpnlBaseline1.doStep;
var
  sTmp : string;
begin
  // --- last biz date ------
  blLastBizDate := xStrToDate('12/31/' + lastTaxyear, Settings.InternalFmt);
  while (DayOfWeek(blLastBizDate) in [1, 7]) //
  or TTLDateUtils.IsHoliday(blLastBizDate) do begin
    blLastBizDate := IncDay(blLastBizDate, -1);
  end; // while
  // ------------------------
  if (blStep = 0) then begin
    if (blPositionsCnt > 0)
    or (cxGrid1TableView1.DataController.RecordCount > 0) then begin
      if mDlg('If you go back you will lose all your Baseline Position entries.' + cr //
        + cr //
        + 'Is that what you want to do?' + cr, mtWarning,[mbYes,mbNo],1) = mrNo
      then begin
        blStep := 1;
        exit;
      end;
    end;
    pnlBaseline1.Hide;
    pnlBaseline.Show;
    exit;
  end;
  //
  if (blStep > 0) then
    btnLast.Enabled := true
  else
    btnLast.Enabled := false;
  //
  if (blStep = 1) then begin
    lblStep.Caption := 'Step 1: Check for ';
    lblStepa.Caption := 'Holdings as of December 31, ';
    lblLastYear.Caption := lastTaxYear;
    btnLast.Enabled := true;
    btnNext.Enabled := true;
    pnlStep2.Hide;
    pnlStep3.Hide;
    pnlStep4.Hide;
    pnlStep5.Hide;
    pnlMain.Hide;
    pnlStep1.Show;
    pnlStep1.Align := alClient;
    pnlType.show;
    pnlAdd.show;
    pnlType.Left := 0;
    blFromDate := xStrToDate('11/01/'+lastTaxYear,Settings.InternalFmt);
    blToDate := xStrToDate('12/31/'+lastTaxYear,Settings.InternalFmt);
    wbStep1.Height := 200;
    loadHTML(wbStep1,'<ul><li>Retrieve your December of last year statement for this brokerage account.</li>'+
      '<li>Find the section that reports "Holdings as of December 31." Please note that'+
      ' each broker may name this section differently.  This section is where your broker'+
      ' reports trades that were held open and carried forward to next year.</li>'+
      '<li>Trades Pending Settlement are listed later in your statement and are NOT'+
      ' accounted for in the Holdings section.</li>'+
      '<li>Any trades not listed in the holdings but that are pending settlement will'+
      ' be accounted for later, in Step 3.</li></ul>'+
      '<p><b>Choose the option that applies to you:</b></p>');
    wbStep1a.Height := 70;
    wbStep1a.Top := pnlStep1.top +10;
    loadHTML(wbStep1a,'<div style="margin-right:20px">My statement <b>DOES LIST</b> positions<br>'+
      ' in the "Holdings as of December 31" section<br>'+
      ' <b>continue to Step 2</b>:</div>'+
      '<div>My statement <b>DOES NOT LIST</b> positions<br>'+
      ' in the "Holdings as of December 31" section<br>'+
      ' <b>continue to Step 3</b>:</div>'
      );
    btnHoldings.left := (pnlBtnHoldings.Width - btnHoldings.width) div 2;
    btnUnsettled.left := (pnlBtnUnsettled.Width - btnUnsettled.width) div 2;
  end
  else if (blStep = 2) then begin
    lblStep.Caption := 'Step 2: Enter ';
    lblStepa.Caption := 'Holdings as of December 31, ';
    btnLast.Enabled := true;
    btnNext.Enabled := (blPositionsCnt > 0); // 2025-10-24 MB Allow Next if positions exist
    // false; // disable until Add click - 2016-04-14 MB
    lblLastYear.Caption := lastTaxYear;
    pnlStep1.Hide;
    pnlStep3.Hide;
    pnlStep4.Hide;
    pnlStep5.Hide;
    pnlStep2.Show;
    pnlStep2.Align := alTop;
    pnlStep2.Top := 95;
    pnlType.show;
    pnlAdd.show;
    pnlType.Left := 0;
    pnlMain.Top:= 110;
    pnlMain.align := alClient;
    pnlMain.Show;
    tmrTickFocus.Interval := 300;
    tmrTickFocus.Enabled := true;
    edTick.setFocus;
    //check if openPosFileName exists
    if (blPositionsCnt = 0)
    and fileExists(openPosFileName) then
      btnGetOpenPos.Show
    else
      btnGetOpenPos.Hide;
  end
  else if (blStep = 3) then begin
    lblStepa.Caption := '';
    lblLastYear.Caption := '';
    btnLast.Enabled := true;
    btnNext.Enabled := (high(impTrades)>0) or noTradesImported;
    pnlStep1.Hide;
    pnlStep2.Hide;
    pnlStep4.Hide;
    pnlStep5.Hide;
    pnlStep3.Show;
    pnlStep3.Align := alTop;
    pnlStep3.Top := 95;
    pnlStep3.AutoSize := false;
    pnlStep3.Height := 130;
    pnlMain.Show;
    pnlMain.align := alClient;
    pnlMain.Top:= 220;
    pnlType.hide;
    pnlAdd.hide;
    wbStep3.Height := 180;
    pnlStep3.Height := 180;
    fromDateTxt := dateToStr(blFromDate,Settings.UserFmt);
    toDateTxt := dateToStr(blToDate,Settings.UserFmt);
    // ----------------------
    if (blToDate = blLastBizDate) //
    or (blToDate = xStrToDate('12/31/'+lastTaxyear, Settings.InternalFmt)) //
    or noTradesImported then begin
      sTmp := 'two trading days';
      if StrToInt(TaxYear) < 2018 then
        sTmp := 'three trading days'
      else if StrToInt(TaxYear) > 2024 then
        sTmp := 'trading day';
      lblStep.Caption := 'Step 3: Accounting for Trades Pending Settlement';
      loadHTML(wbStep3,'<ul><li>TradeLog will automatically adjust the list of open positions for "Trades Pending Settlement"' +
        ' - those made on the last ' + sTmp + ' of the year.</li>' +
        '<li>Click the Import button at the right to download and import trades using the following date range:</li></ul>' +
        '<p style="width:220px;Text-align:right">From Date = <b>' + fromDateTxt + '</b><br>' + cr +
        '  To Date = <b>' + toDateTxt + '</b></p>');
      SaveOpenPos;
    end
    else begin
      lblStep.Caption := 'Step 3: Continue Importing to Find Open Positions Date Acquired and Pricing.';
      loadHTML(wbStep3,'<ul><li>Click the Import button at the right to continue importing several months at a time using the'+
        ' suggested date range:</li></ul>'+
        '<p style="width:220px;Text-align:right">From Date = <b>'+fromDateTxt+'</b><br>'+cr+
        '  To Date = <b>'+toDateTxt+'</b></p>');
    end;
  end
  else if (blStep = 4) then begin
    lblStep.Caption := 'Step 4: Automatically find and enter open positions from trade history';
    lblStepa.Caption := '';
    lblLastYear.Caption := '';
    btnLast.Enabled := false;
    btnNext.Enabled := false;
    pnlStep1.Hide;
    pnlStep2.Hide;
    pnlStep3.Hide;
    pnlStep5.Hide;
    pnlStep4.Show;
    pnlStep4.Align := alTop;
    pnlStep4.Top := 95;
    pnlMain.Show;
    pnlMain.align := alClient;
    pnlMain.Top:= 120;
    pnlType.hide;
    pnlAdd.hide;
    if moreOpens then btnFind.Click;
    if (blPositionsCnt = 0)
    and (cxGrid1TableView1.DataController.RecordCount = 0)
    and (blToDate = xStrToDate('12/31/'+lastTaxyear,Settings.InternalFmt))
    then begin
      sm('You have no open positions as of 12/31/' + lastTaxyear + '.');
      close;
    end;
  end
  else if (blStep = 5) then begin
    lblStep.Caption := 'Not all baseline positions have been found!';
    lblStepa.Caption := '';
    lblLastYear.Caption := '';
    btnLast.Enabled := false;
    btnNext.Enabled := false;
    pnlStep1.Hide;
    pnlStep2.Hide;
    pnlStep3.Hide;
    pnlStep4.Hide;
    pnlStep5.Show;
    pnlStep5.Align := alTop;
    pnlStep5.Top := 95;
    pnlMain.Show;
    pnlMain.align := alClient;
    pnlMain.Top:= 120;
    pnlType.hide;
    pnlAdd.hide;
    with cxGrid1TableView1 do begin
      OptionsData.Editing:= true;
      OptionsSelection.CellSelect:= true;
      OptionsView.ShowEditButtons:= gsebForFocusedRecord;
      with controller do begin
        editingItem:= focusedItem;
      end;
    end;
  end;
  //
  if blStep <> 5 then begin
    colDate.Visible := false;
    colPrice.Visible := false;
    colComm.Visible := false;
    colAmt.Visible := false;
  end
  else begin
    colDate.Visible := true;
    colPrice.Visible := true;
    colComm.Visible := true;
    colAmt.Visible := true;
  end;
end;


procedure TpnlBaseline1.btnHoldingsClick(Sender: TObject);
begin
  blStep := 2;
  doStep;
end;


procedure TpnlBaseline1.btnUnsettledClick(Sender: TObject);
begin
  blStep := 3;
  doStep;
end;


procedure TpnlBaseline1.bntRemoveClick(Sender: TObject);
begin
  with cxGrid1TableView1.DataController do begin
    if GetSelectedCount = 0 then begin
      sm('Please select the records you want to remove.');
      exit;
    end;
    DeleteSelection;
  end;
end;


procedure TpnlBaseline1.btnAddClick(Sender: TObject);
var
  instr : string;
begin
  if (edTick.Text = '') or (edShares.Text = '') then begin
    mDlg('Please make sure all required data has been entered.', mtError, [mbOK], 0);
    exit;
  end;
  edShares.Text := checkNumber(edShares.Text);
  if edShares.Text = '' then begin
    edShares.SetFocus;
    exit;
  end;
  //remove trailing zeros from strike price
  edStrike.Text := delTrailingZeros(edStrike.Text);
  instr := cboTypeMult.Text;
  cxGrid1TableView1.DataController.Append;
  colOC.EditValue := 'O';
  if cboLS.Text = 'Long' then
    colLS.EditValue := 'L'
  else
    colLS.EditValue := 'S';
  colShares.EditValue := edShares.text;
  if (instr = 'Stock')
  or (instr = 'Bond')
  or (instr = 'Mutual Fund')
  or (instr = 'ETF/ETN')
  or (instr = 'Drip') then begin
    colTicker.EditValue := edTick.Text;
    colTypeMult.EditValue := 'STK-1';
  end
  else if (instr = 'Option') then begin
    colTicker.EditValue := edTick.Text + ' ' //
      + cboDay.Text + cboMonth.Text + rightStr(cboYear.Text,2) + ' ' //
      + edStrike.Text + ' ' + cboCallPut.text;
    colTypeMult.EditValue := 'OPT-' + cboContrMult.Text;
  end
  else if (instr = 'Future Contract') then begin
    colTicker.EditValue := edTick.Text + ' ' + cboMonth.Text + rightStr(cboYear.Text,2);
    colTypeMult.EditValue := 'FUT-' + cboContrMult.Text;
  end
  else if (instr = 'Future Option') then begin
    colTicker.EditValue := edTick.Text +' '
      + cboMonth.Text+rightStr(cboYear.Text,2) + ' ' + edStrike.Text + ' '
      + cboCallPut.text;
    colTypeMult.EditValue := 'FUT-' + cboContrMult.Text;
  end
  else if (instr = 'Currency') then begin
    colTicker.EditValue := edTick.Text;
    colTypeMult.EditValue := 'CUR-' + cboContrMult.Text;
  end;
  // enable NEXT button
  btnNext.Enabled := true;
  //reset input boxes
  edTick.text := '';
  edShares.Text := '';
  cboLS.Text := 'Long';
  cxGrid1TableView1.DataController.FocusedRowIndex := -1;
  edTick.setFocus;
end;


procedure TpnlBaseline1.btnImportClick(Sender: TObject);
var
  i, j : Integer;
  Shares : double;
  dtPending : TDate;
begin
  if OneYrLocked //
  or isAllBrokersSelected //
  or not CheckRecordLimit then
    exit;
  impBaseline := true;
  impCancelled := false;
  if btnImport.Caption = 'Import' then begin
    sm('No import filter selected.');
    exit;
  end;
  // ----------------------------------
  // Load the impTrades array
  // ----------------------------------
  statBar('Importing Trade History - Please Wait...');
  bImporting := true;
  sImpMethod := '';
  with frmSelImpMethod do begin
    if showmodal = mrCancel then
      btnCloseClick(Sender)
    else begin
      if (sImpMethod = 'Excel') then
        frmMain.btnFromExcelClick(Sender)
      else if (sImpMethod = 'File') then
        frmMain.btnFromFileClick(Sender)
      else if (sImpMethod = 'BC') then
        BCImportDateRange(blFromDate, blToDate);
        // frmMain.dxBrokerConnect_Click(Sender);
    end;
  end;
  // ------------------------
  bImporting := false;
  sImpMethod := '';
  if impCancelled then exit;
  // sm(dateToStr(settlementStartDate(lastDayOfYear))+cr+dateToStr(lastDayOfYear));
  // adjust the open positions list for unsettled trades
  dtPending := settlementStartDate(lastDayOfYear);
  // ----------------------------------
  // Find the price paid for open pos.
  // ----------------------------------
  for i := 1 to High(impTrades) do begin
    // continue if trade date not last 3 trading days of year,
    // or last day of year for options
    if (impTrades[i].dt = '') // 2014-04-14 fixed crash when no date
    then continue;
    //
    if ((pos('OPT', impTrades[i].prf)= 0)
    and (xStrToDate(impTrades[i].dt, Settings.UserFmt) < dtPending))
    then begin
//      sm('before settlement start date');
      continue;
    end;
    //
    if ((pos('OPT', impTrades[i].prf)= 1)
    and (xStrToDate(impTrades[i].dt, Settings.UserFmt) < blLastBizDate)) // 2025-10-28 MB
    then begin
//      sm('before last business day of year');
      continue;
    end;
    //
    if (xStrToDate(impTrades[i].dt, Settings.UserFmt) > lastDayOfYear)
    then begin
//      sm('after last day of year');
      continue;
    end;
    // add or subtract from shares open
    j := 0;
    if pnlBaseline1.cxGrid1TableView1.DataController.RecordCount > 0 then begin
      with pnlBaseline1.cxGrid1TableView1.DataController do
        while j < RecordCount do begin
          // AutoAssignShorts
          if TradeLogFile.CurrentAccount.AutoAssignShorts
          and (values[j, 3] = impTrades[i].tk) then begin
            // if open pos is short
            if (values[j, 2] = 'S') then begin
              // is a sell, add to position
              if (impTrades[i].OC = 'C') then
                values[j, 4] := values[j, 4] + impTrades[i].sh
              else // is a buy
                values[j, 4] := values[j, 4] - impTrades[i].sh;
              // delete open position if zero shares
              if (values[j, 4] <= 0) then deleteRecord(j);
              break;
            end
            // open pos is long
            else if (values[j, 2] = 'L') then begin
              if (impTrades[i].OC = 'O') then
                values[j, 4] := values[j, 4] + impTrades[i].sh
              else
                values[j, 4] := values[j, 4] - impTrades[i].sh;
              // delete open position if zero shares
              if (values[j, 4] <= 0) then deleteRecord(j);
              break;
            end;
          end
          else begin
          // long/short matches
            if (values[j, 2] = impTrades[i].ls)
            and (values[j, 3] = impTrades[i].tk) then begin
              if (impTrades[i].OC = 'O') then
                values[j, 4] := values[j, 4] + impTrades[i].sh
              else if (impTrades[i].OC = 'C') then
                values[j, 4] := values[j, 4] - impTrades[i].sh;
              // delete open position if zero shares
              if (values[j, 4] <= 0) then deleteRecord(j);
              break;
            end;
          end;
          // 2014-07-15  crap hack for Schwab
          if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab')
          and (values[j, 3] = impTrades[i].tk) and (impTrades[i].ls = 'L')
          and (values[j, 2] = 'S') then begin
            if (impTrades[i].OC = 'C') then
              values[j, 4] := values[j, 4] + impTrades[i].sh
            else if (impTrades[i].OC = 'O') then
              values[j, 4] := values[j, 4] - impTrades[i].sh;
            // delete open position if zero shares
            if (values[j, 4] <= 0) then deleteRecord(j);
            break;
          end
          // unsettled trade is not in list, so we need to add it
          else if (j = RecordCount - 1) then begin
            appendRecord;
            values[RecordCount - 1, 1] := 'O';
            if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab')
            and (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') then
              values[RecordCount - 1, 2] := 'S'
            else if TradeLogFile.CurrentAccount.AutoAssignShorts then begin
              if (impTrades[i].OC = 'C') then
                values[RecordCount - 1, 2] := 'S'
              else
                values[RecordCount - 1, 2] := impTrades[i].ls
            end
            else begin
              values[RecordCount - 1, 2] := impTrades[i].ls;
            end;
            values[RecordCount - 1, 3] := impTrades[i].tk;
            values[RecordCount - 1, 4] := impTrades[i].sh;
            values[RecordCount - 1, 6] := impTrades[i].prf;
            // sm(intToStr(recordCount)+cr+impTrades[i].tk+cr+floatToSTr(impTrades[i].sh));
            break;
          end;
          inc(j);
        end;
    end
    else
    // no open positions from Dec statement, but there are unsettled trades
      with pnlBaseline1.cxGrid1TableView1.DataController do begin
        appendRecord;
        values[RecordCount - 1, 1] := 'O';
        // 2014-07-15  crap hack for Schwab
        if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab')
        and (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') then
          values[RecordCount - 1, 2] := 'S'
        else
          values[RecordCount - 1, 2] := impTrades[i].ls;
        values[RecordCount - 1, 3] := impTrades[i].tk;
        values[RecordCount - 1, 4] := impTrades[i].sh;
        values[RecordCount - 1, 6] := impTrades[i].prf;
        // sm(intToStr(recordCount)+cr+impTrades[i].tk+cr+floatToSTr(impTrades[i].sh));
      end;
  end; // for i := 1 to High(impTrades)
  if (high(impTrades)> 0) then
    blStep := 4
  else begin
    blStep := 3;
    noTradesImported := true;
  end;
  doStep;
end;


// Import Help
procedure TpnlBaseline1.btnImpUGClick(Sender: TObject);
var
  ugID : integer;
  InstrPage :string;
begin
  InstrPage := TradeLogFile.CurrentAccount.importFilter.InstructPage; // 2019-01-26 MB
  if (pos('tradelogsoftware.com', InstrPage) > 0) //
  or  (pos('tradelog.com', InstrPage) > 0) then
    webURL(InstrPage)
  else
    webURL(SiteURL + 'support/broker-imports/'); // 2019-01-25 MB
end;


procedure TpnlBaseline1.btnFindClick(Sender: TObject);
var
  i, j, RecCnt: Integer;
  tickList: TStringList;
  Trade: TTLTrade;
  undoTxt: string;
  mbExit: TMsgDlgBtn;
begin
  RecCnt := 0;
  try
    // get list of open position tickers
    tickList := TStringList.Create;
    for i := 0 to cxGrid1TableView1.DataController.RecordCount - 1 do
      tickList.Add(trim(cxGrid1TableView1.DataController.values[i, 3]));
    tickList.Sort;
    // cycle backwards thru each trade record and find open records
    for i := high(impTrades) downto 1 do begin
      // sm(tickList.Text+cr+impTrades[i].tk+cr+impTrades[i].oc);
      if impTrades[i].dt = '' then begin
        // sm('invalid date');
        continue; // skip records with blank trade date.
      end;
      Trade := TTLTrade.Create(impTrades[i]);
      // skip if ticker does not match OR price = 0;
      if (tickList.IndexOf(impTrades[i].tk) = -1) //
      or (impTrades[i].pr = 0) then begin
        continue;
      end;
      //
      if (impTrades[i].OC = 'O') //
      or ( TradeLogFile.CurrentAccount.AutoAssignShorts //
       and (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L')) //
      or ( (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab')
       and (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L')) //
      then begin
        j := 0;
        with cxGrid1TableView1.DataController do
          while j < cxGrid1TableView1.DataController.RecordCount do begin
            // skip if shares = 0
            if (values[j, 4] = 0) then begin
              inc(j);
              continue;
            end;
            // skip if ticker or typ/mult does not match
            if (values[j, 3] <> impTrades[i].tk) or
              (values[j, 6] <> impTrades[i].prf) then begin
              inc(j);
              continue;
            end;
            // updated 2014-09-22 from crap Schwab short buys
            if ( (values[j, 2] = impTrades[i].ls) and (impTrades[i].OC = 'O') )  //
            or ( (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab') //
             and (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') //
             and (values[j, 2] = 'S') ) // AutoAssignShorts //
            or (TradeLogFile.CurrentAccount.AutoAssignShorts //
             and (values[j, 2] = 'S') and (impTrades[i].OC = 'C') //
             and (impTrades[i].ls = 'L') ) //
            then begin
              if (values[j, 4] = impTrades[i].sh) then begin
                if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab') //
                and (impTrades[i].OC = 'C') //
                and (impTrades[i].ls = 'L') //
                and (values[j, 2] = 'S') //
                or ( (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') //
                and TradeLogFile.CurrentAccount.AutoAssignShorts ) //
                then begin
                  Trade.OC := 'O';
                  Trade.ls := 'S';
                end;
                TradeLogFile.AddTrade(Trade);
                inc(RecCnt);
                values[j, 4] := 0;
                cxGrid1TableView1.DataController.FocusedRowIndex := j;
                cxGrid1TableView1.DataController.DeleteFocused;
                break;
              end
              else if (values[j, 4] > impTrades[i].sh) then begin
                // Trade := TTLTrade.Create(ImpTrades[i]);
                if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab') //
                and (impTrades[i].OC = 'C') //
                and (impTrades[i].ls = 'L') //
                and (values[j, 2] = 'S') //
                or ( (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') //
                and TradeLogFile.CurrentAccount.AutoAssignShorts ) //
                then begin
                  Trade.OC := 'O';
                  Trade.ls := 'S';
                end;
                TradeLogFile.AddTrade(Trade);
                inc(RecCnt);
                values[j, 4] := values[j, 4] - impTrades[i].sh;
                break;
              end
              else if (values[j, 4] < impTrades[i].sh) then begin
                // Trade := TTLTrade.Create(ImpTrades[i]);
                if (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab') //
                and (impTrades[i].OC = 'C') //
                and (impTrades[i].ls = 'L') //
                and (values[j, 2] = 'S') //
                or ( (impTrades[i].OC = 'C') and (impTrades[i].ls = 'L') //
                and TradeLogFile.CurrentAccount.AutoAssignShorts) //
                then begin
                  Trade.OC := 'O';
                  Trade.ls := 'S';
                end;
                // adjust trade
                Trade.Shares := values[j, 4];
                TradeLogFile.AddTrade(Trade);
                inc(RecCnt);
                values[j, 4] := 0;
                cxGrid1TableView1.DataController.FocusedRowIndex := j;
                cxGrid1TableView1.DataController.DeleteFocused;
                break;
              end;
            end;
            inc(j);
          end;
      end; // end if open loop
    end;
  finally tickList.Free;
  end;
  cxGrid1TableView1.DataController.FocusedRowIndex := -1;
  blPositionsCnt := blPositionsCnt + RecCnt;
  if (RecCnt > 0) then begin
    TradeLogFile.MatchAndReorganize(false, true);
    if frmMain.cxGrid1TableView1.DataController.RecordCount = 0 then
      undoTxt := 'Baseline Wizard'
    else
      undoTxt := '';
    SaveTradeLogFile(undoTxt, true, false);
  end;
  if pnlBaseline1.cxGrid1TableView1.DataController.RecordCount = 0 then begin
//    blStep := 0;
//    panelQS.doQuickStart(3, 1);
//    panelQS.Show;
    close;
  end
  else begin
    moreOpens := true;
    blStep := 5;
    doStep;
  end;
end;


procedure TpnlBaseline1.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
//    frmMain.menu := frmMain.MainMenu; // 2021-05-10 MB - no longer used
    frmMain.EnableMenuToolsAll;
    frmMain.EnableTabItems('enableEdits'); // 2021-06-28 MB - enable all
    frmMain.pnlToolbar.show;
    frmMain.pnlBlue.show;
    pnlBaseline1.Hide;
    if (blPositionsCnt > 0)
    and TradeLogFile.CurrentAccount.MTM
    and not TradeLogFile.CurrentAccount.MTMLastYear
    then begin
      ProcessBeginYearDone; // we have to add TLEndYear to uses just for this!
    end
    else begin
      loadRecords;
      statBar('off');
    end;
    if (blPositionsCnt = -1) then
      sm('Baseline Wizard was not completed.' + cr //
        + cr //
        + '  You must complete the wizard or manually enter your baseline positions' + cr //
        + '  before you begin importing your trade history for ' + taxYear + '.')
    else if (blPositionsCnt > 0) then
      sm('Baseline positions are complete.' + cr //
        + cr //
        + '  You are now ready to import your' + cr //
        + '  trade history for ' + taxYear + '.')
    else
      sm('No baseline positions were found.' + cr //
        + cr //
        + '  If you are sure you have no baseline positions,' + cr //
        + '  then you are can proceed to import your' + cr //
        + '  trade history for ' + taxYear + '.');
//    if Settings.DispQS then begin
//      panelQS.show;
//      panelQS.doQuickStart(3, 1);
//    end;
  finally
    freeAndNil(pnlBaseline1);
    freeAndNil(pnlBaseline);
    impBaseline := false;   // 2014-10-09 fix for x Recs Saved bug
  end;
end;


procedure TpnlBaseline1.FormCloseQuery(Sender: TObject;  var CanClose: Boolean);
begin
  CanClose := true;
end;


procedure TpnlBaseline1.btnFinishClick(Sender: TObject);
begin
  EnterRemainingPositions;
end;


procedure TpnlBaseline1.EnterRemainingPositions(zero : boolean = false);
var
  Trade : TTLTrade;
  RecCnt : Integer;
  undoTxt, ls, msgTxt : string;
  i : Integer;
  msgReply : Integer;
begin
  RecCnt := 0;
  msgReply := 0;
  // enter baseline positions without price and clear the grid
  if cxGrid1TableView1.DataController.RecordCount > 0 then begin
    // SaveOpenPos;
    // check for all valid entries
    msgTxt := '';
    if not zero then begin
      for i := 0 to cxGrid1TableView1.DataController.RecordCount - 1 do begin
        with cxGrid1TableView1.DataController do begin
          if (values[i, 0] = null) then
            if (pos('Date ', msgTxt)= 0) then
              msgTxt := msgTxt + '- Date cannot be blank.' + cr
            else if not checkDate(values[i, 0]) and (pos('Date ', msgTxt)= 0) then
              msgTxt := '- Date must be less than: ' //
              + dateToStr(settlementStartDate(lastDayOfYear), Settings.InternalFmt)+ cr;
          //
          if ((values[i, 5] = '0') or (values[i, 5] = null)) and (pos('Price ', msgTxt)= 0) then
            if (pos('Price ', msgTxt)= 0) then
              msgTxt := msgTxt + '- Price cannot be zero or blank.' + cr;
          //
          if ((values[i, 8] = '0') or (values[i, 8] = null)) and (pos('Amount ', msgTxt)= 0) then
            if (pos('Amount ', msgTxt)= 0) then
              msgTxt := msgTxt + '- Amount cannot be zero or blank.' + cr;
          //
        end; // with cxGrid1TableView1.DataController
      end; // for i
    end; // if not zero
    if msgTxt <> '' then begin
      mDlg(msgTxt, mtWarning,[mbOK], 1);
      exit;
    end;
    //
    while pnlBaseline1.cxGrid1TableView1.DataController.RecordCount > 0 do begin
      Trade := TTLTrade.Create;
      inc(RecCnt);
      if (zero) then
        Trade.Date := xStrToDate('01/01/' + LastTaxYear, Settings.InternalFmt)
      else
        Trade.Date := xStrToDate(cxGrid1TableView1.DataController.values[0, 0],
          Settings.InternalFmt);
      Trade.OC := 'O';
      // crap char typecast!!! de
      ls := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 2];
      Trade.ls := ls[1];
      Trade.Ticker := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 3];
      Trade.Shares := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 4];
      if (zero) then
        Trade.Price := 0
      else
        Trade.Price := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 5];
      Trade.TypeMult := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 6];
      if pnlBaseline1.cxGrid1TableView1.DataController.values[0, 7] = null then
        Trade.Commission := 0
      else
        Trade.Commission := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 7];
      if (zero) then
        Trade.amount := 0
      else
        Trade.amount := pnlBaseline1.cxGrid1TableView1.DataController.values[0, 8];
      Trade.Broker := TradeLogFile.CurrentBrokerID;
      TradeLogFile.AddTrade(Trade);
      pnlBaseline1.cxGrid1TableView1.DataController.deleteRecord(0);
    end;
  end;
  blPositionsCnt := blPositionsCnt + RecCnt;
  if RecCnt > 0 then begin
    if frmMain.cxGrid1TableView1.DataController.RecordCount = 0 then
      undoTxt := 'Baseline Wizard'
    else
      undoTxt := '';
    changeFutMult(TradeLogFile.TradeList);
    TradeLogFile.MatchAndReorganize(false, true);
    TradeRecordsSource.DataChanged;
    SaveTradeLogFile(undoTxt, true, false);
  end;
  close;
end;


procedure TpnlBaseline1.btnGetOpenPosClick(Sender: TObject);
var
  openPosFile : textFile;
  openPosStr : string;
begin
  //load open positions from text file
  try
    try
      AssignFile(openPosFile, openPosFileName);
      reset(openPosFile);
    except
      mDlg('Could not create ' + openPosFileName, mtError, [mbOK], 0);
    end;
    while not Eof(openPosFile) do begin
      ReadLn(openPosFile, openPosStr);
      //load grid
      with cxGrid1TableView1.DataController do begin
        appendRecord;
        values[recordCount-1,1] := trim(parseFirst(openPosStr,tab));
        values[recordCount-1,2] := trim(parseFirst(openPosStr,tab));
        values[recordCount-1,3] := trim(parseFirst(openPosStr,tab));
        values[recordCount-1,4] := trim(parseFirst(openPosStr,tab));
        values[recordCount-1,6] := trim(openPosStr);
      end;
    end;
  finally
    CloseFile(openPosFile);
    blPositionsCnt := cxGrid1TableView1.DataController.RecordCount;
    btnNext.Enabled := (blPositionsCnt > 0); // 2025-10-24 MB - enable NEXT if RESTORE successful.
    btnGetOpenPos.Hide; // ...and then hide the RESTORE button.
  end;
end;


procedure TpnlBaseline1.btnLastClick(Sender: TObject);
begin
  blStep := blStep -1;
  doStep;
end;

procedure TpnlBaseline1.btnNextClick(Sender: TObject);
begin
  blStep := blStep + 1;
  doStep;
end;


procedure TpnlBaseline1.loadHTML(wb : TWebBrowser; HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
  Document : IHTMLDocument2;
  Element : IHTMLElement;
begin
  wb.Navigate('about:blank') ;

  while wb.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  HTMLcode:='<html><head>'+
    '<style>'+
    'body{margin:0;padding:0;font:11pt Tahoma}'+
    'p{margin:0;padding:10px 0 10px 0;}'+
    'ul{padding:0; margin:-4px 0 8px 20px;} '+
    'li{padding:0; margin:10p 0 0 0;}'+
    'div{float:left;text-align:center;width:320px;}'+
    'blockquote{padding:0 0 0 10px;margin:0;}'+
    'hr{line-height:1px;}'+
    '</style>'+
    '<head>'+
    '<body>'+
    HTMLcode+'</body></html>';

  if Assigned(wb.Document) then
  begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (wb.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
  end;

end;

end.
