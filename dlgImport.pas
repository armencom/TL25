unit dlgImport;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, StdCtrls, extctrls, ComCtrls, cxRadioGroup,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit,
  cxCalendar, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, dxCore,
  cxDateUtils, RzButton, RzRadChk, Vcl.ExtDlgs, dxSkinsCore, dxSkinBlack,
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
  TdlgImport = class(TForm)
    Panel2: TPanel;
    Label3: TLabel;
    cxFrom: TcxDateEdit;
    cxTo: TcxDateEdit;
    rbMo: TcxRadioButton;
    rbMax: TcxRadioButton;
    Label4: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    ProgressBar1: TProgressBar;
    lblStatus: TLabel;
    procedure rbMoClick(Sender: TObject);
    procedure rbMaxClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cxFromPropertiesChange(Sender: TObject);
    procedure cxToPropertiesChange(Sender: TObject);
  private
  public
    dtImpFrom : TDate;
    dtImpTo : TDate;
  end;

var
  dlgImpDates: TdlgImport;

implementation

uses
  Main, funcProc, globalVariables, RecordClasses, import, frmOFX, msHTML, clipbrd, web, baseline1,
  dateUtils, TLregister, StrUtils, TLSettings, TLCommonLib, TLFile, TLWinInet, //
  webImport, importCSV, Winapi.WinInet;

{$R *.DFM}

var
  CurDispatch: IDispatch;
  apiID:string;   // used for optionsXpress API
  impBL, impBL2: boolean;
  bWebLoad : boolean;
  //dtOct16ny : TDatetime;
  MaxDays : integer;

// ----------------------------------------------
function LastDayofMon(d:Tdate):TDate;
begin
   result := EncodeDate(YearOf(d),MonthOf(d), DaysInMonth(d)) ;
end;

function inc3Months(sd:Tdate):Tdate;
begin
  try // fix for integer overflow error when last date imported 10/31 or greater
    result:= LastDayofMon(incMonth(sd,2));
  except
  end;
end;


function assignImpBackupFilename(dateStart,dateEnd:string;Fmt:TFormatSettings):string;
var
  f,ext,localFileName:string;
begin
  ext := TradeLogFile.CurrentAccount.ImportFilter.ImportFileExtension;
  //make sure dates are mm/dd/yyyy format
  if dateStart<>'' then
    dateStart:= dateToStr(xStrToDate(dateStart,Fmt),Settings.InternalFmt);
  if dateEnd<>'' then
    dateEnd:= dateToStr(xStrToDate(dateEnd,Fmt),Settings.InternalFmt);
  f:= TradeLogFile.CurrentAccount.FileImportFormat;
  delete(f,pos('*',f),1);
  delete(f,pos(',',f),1);
  try
    if (dateStart<>'') and (dateEnd='') then
      localFileName:= Settings.ImportDir+'\' + f + '_'+dateStart+ext
    else if (dateStart<>'') then
      localFileName:= Settings.ImportDir+'\' + f +'_' + YYYYMMDD_ex(dateStart,Settings.InternalFmt)
        + '_' + YYYYMMDD_ex(dateEnd,Settings.InternalFmt) + ext
    else
      localFileName:=Settings.ImportDir+'\' + f + ext;
  finally
    result:= localFileName;
  end;
end;


procedure saveImportAsFile(s, dateStart, dateEnd : string; Fmt: TFormatSettings);
var
  localFileName:string;
  localFile:textFile;
begin
  try
    // get a unique name for the import backup file
    localFileName:= assignImpBackupFilename(dateStart,dateEnd,Fmt);
    //sm( localFileName );
    AssignFile(localFile,localFileName);
    Rewrite(localFile);
    write(localFile,s);
    CloseFile(localFile);
  finally
    //
  end;
end;

procedure TdlgImport.btnCancelClick(Sender: TObject);
begin
  modalresult := mrCancel;
end;


// ----------------------------------------------
procedure TdlgImport.FormShow(Sender: TObject);
var
  t, d : string;
begin
  // get startDate and endDate
  // assumes dtBegTaxYr already set
  if glbBLWizOpen then begin
    cxFrom.Date := blFromDate;
    cxTo.Date := blToDate;
  end;
  if (dtBegTaxYr = 0) then begin
    sm('Error: beginning of tax year date not set.');
    dtBegTaxYr := xStrToDate('01/01/' + taxyear, Settings.InternalFmt);
  end;
  if (glbBLWizOpen = false) then begin // 2024-02-22 MB
    if (TradeLogFile.Count = 0) then begin
      cxFrom.date := dtBegTaxYr;
    end
    else begin
      clearFilter;
      if TradeLogFile.LastDateImported + 1 < dtBegTaxYr then
        cxFrom.date := dtBegTaxYr
      else
        cxFrom.date := TradeLogFile.LastDateImported + 1;
    end;
    // do not import past OCT 16 of next tax year (former limit was 01/31)
    dtOct16ny := xStrToDate('10/16/' +NextTaxYear, Settings.InternalFmt);
    if cxTo.date > dtOct16ny then begin
      cxTo.date := dtOct16ny;
    end
    else begin
      cxTo.date := dateOf(date-2); // or not past the day before yesterday
    end; // if cxTo.date
    // make sure from/to dates are not greater than the day before yesterday
    if cxFrom.date >= now()-2 then begin //
      cxFrom.date := dateOf(now()-2);
      if (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation')
      or (TradeLogFile.CurrentAccount.FileImportFormat = 'IB') then begin
        // set start date to Mon thru Fri
        if dayOfWeek(cxFrom.date)=1 then
          cxFrom.date := cxFrom.date+1 // change Sun to Mon
        else if dayOfWeek(cxFrom.date)=7 then
          cxFrom.date := dateOf(cxFrom.date+2); // change Sat to Mon
      end;
    end;
    if cxTo.date >= now()-2 then begin // the day before yesterday
      cxTo.date := dateOf(now()-2); //
    end;
  end;
  // do not import OFX if cxFrom is less than OFXMonths
  if (TradeLogFile.CurrentAccount.FileImportFormat = 'E-Trade')
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'TradeStation')
  then
    MaxDays := 90
  else if (TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity')
  or (TradeLogFile.CurrentAccount.FileImportFormat = 'Schwab')
  then
    MaxDays := 365
  else if TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths > 0
  then
    MaxDays := TradeLogFile.CurrentAccount.ImportFilter.OFXMaxMonths*30
  else
    MaxDays := 0; // not specified
  screen.Cursor := crDefault;
end;


// -----------
//     OK    |
// -----------
procedure TdlgImport.btnOKClick(Sender: TObject);
begin
  OFXDateStart := cxFrom.date;
  OFXDateEnd := cxTo.date;
  modalresult := mrOK;
end;



procedure TdlgImport.cxFromPropertiesChange(Sender: TObject);
begin
  dtJan31NY := xStrToDate('01/31/' + nextTaxyear, Settings.InternalFmt);
  // do not allow importing past Jan 31
  if (TradeLogFile.NextTaxYear <> currentYear) //
  and (cxFrom.Date > dtJan31NY) then begin
    cxFrom.Date:= TradeLogFile.LastDateImported + 1;
    sm('Cannot import trades past ' + dateToStr(dtJan31NY, Settings.InternalFmt)
      +' in a '+taxyear+' data file');
    exit;
  end;
  if rbMo.checked then
    cxTo.Date:= dateOf(endOfTheMonth(cxFrom.Date))
  else if TradeLogFile.CurrentAccount.FileImportFormat='Fidelity' then begin
    if cxFrom.Date+90 <= dtJan31NY then
      cxTo.Date:= dateOf(cxFrom.Date+90);
  end;
  if TradeLogFile.CurrentAccount.FileImportFormat='TradeStation' then begin
    if cxFrom.Date < xStrToDate('11/01/'+Taxyear,Settings.InternalFmt)then
      cxTo.Date:= inc3months(cxFrom.Date)
    else
      cxTo.Date:= dtJan31NY;
  end;
  if cxTo.date>now() then cxTo.date:= dateOf(now()-1);
  // do not import OFX if cxFrom is less than OFXMonths
//  if (TradeLogFile.CurrentAccount.ImportFilter.OFXMonths > 0)
//  and TradeLogFile.CurrentAccount.ImportFilter.OFXConnect
//  and (now - TradeLogFile.CurrentAccount.ImportFilter.OFXMonths*30 > cxFrom.date)
//  and (TradeLogFile.CurrentAccount.ImportFilter.FilterName <> 'Fidelity')
//  then begin
//    bWebLoad := true;
//  end;
  if impBaseline and ImpBL2 then begin
    blFromDate:= cxFrom.Date;
    cxTo.Date:= blToDate;
  end;
  if impBaseline then begin
    impBL2:= true;
  end;
end;


procedure TdlgImport.cxToPropertiesChange(Sender: TObject);
begin
  dtJan31NY := xStrToDate('01/31/' + nextTaxyear, Settings.InternalFmt);
  if impBaseline and impBL and (cxTo.Date <> blToDate) then begin
    cxTo.Date := blToDate;
    exit;
  end;
  if glbBLWizOpen then begin
    cxTo.Date := blToDate;
    exit;
  end
  else if bWebLoad then begin // means we are going to try to download data
    // limit imports to 12 months at a time
//    if (TradeLogFile.CurrentAccount.FileImportFormat='TDAmeritrade') then begin
//      if  (cxTo.Date > xStrToDate('12/31/' + taxyear, Settings.InternalFmt))
//      and (cxFrom.Date < xStrToDate('02/01/' + taxyear, Settings.InternalFmt))
//      then begin
//        sm('TDAmeritrade limits trade history downloads to 12 months at a time!');
//        cxTo.Date := xStrToDate('12/31/' + taxyear, Settings.InternalFmt);
//      end;
//    end;
    // do not allow importing past Jan 31
    if (TradeLogFile.NextTaxYear <> currentYear)
    and (cxTo.date > dtJan31NY)
    then begin
      sm('Cannot import trades past ' + dateToStr(dtJan31NY, Settings.InternalFmt) //
        +' in a ' + taxyear + ' data file.' + CR //
        + 'Adjusting end date.');
      cxTo.date:= dtJan31NY;
    end;
    // cannot import past day before yesterday
    if cxTo.date >= dateOf(now()-2) then begin
      cxTo.Date:= dateOf(now()-2);
    end;
    // Fidelity does not allow downloads of more than 90 days, otherwise no data returned
    if  (TradeLogFile.CurrentAccount.FileImportFormat='Fidelity')
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if cxTo.Date > cxFrom.Date +90 then begin
//        cxFrom.Date := cxTo.Date - 90;
        cxTo.Date:= cxFrom.Date + 90;
        mDlg('Fidelity recommends downloads of 90 days or less',
          mtWarning,[mbOK],1);
      end;
    end
    // Tradestation and ETrade do not allow downloads of more than 3 months, otherwise get IE error
    else if bWebLoad
    and ( (TradeLogFile.CurrentAccount.FileImportFormat='TradeStation')
       or (TradeLogFile.CurrentAccount.FileImportFormat='E-Trade') )
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if (cxTo.Date > inc3months(cxFrom.Date))then begin
//        cxFrom.Date := cxTo.Date - 90;
        cxTo.Date:= inc3months(cxFrom.Date);
        mDlg(TradeLogFile.CurrentAccount.FileImportFormat //
          + ' recommends downloads of 3 months or less.', mtWarning,[mbOK],1);
      end;
    end
    // set start date to Mon thru Fri for IB
    else if  (TradeLogFile.CurrentAccount.FileImportFormat='IB')
    and ( cxTo.IsFocused or rbMo.Checked ) then begin
      if dayOfWeek(cxTo.date)=1 then begin
        cxTo.date:= cxTo.Date-2;
      end
      else if dayOfWeek(cxTo.date)=7 then begin
        cxTo.date:= cxTo.Date-2; // day before yesterday
      end;
    end;
    // open this up for To date beyond 12/31/taxyear
    if (cxTo.Date > xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt))
    and TradeLogFile.CurrentAccount.MTM then
      cxTo.Date := xStrToDate('10/16/' + NextTaxYear, Settings.InternalFmt);
    // end if
  end
  else begin
    // cannot import past day before yesterday
    if cxTo.date >= dateOf(now()-2) then begin
      cxTo.Date:= dateOf(now()-2);
    end;
  end;
end;

procedure TdlgImport.rbMaxClick(Sender: TObject);
var
 dtNov01, dtDec31 : TDateTime;
begin
  dtNov01 := xStrToDate('11/01/'+Taxyear,Settings.InternalFmt);
  dtDec31 := xStrToDate('12/31/'+Taxyear,Settings.InternalFmt);
  dtJan31NY := xStrToDate('01/31/'+nextTaxyear,Settings.InternalFmt);
  if rbMax.checked then begin
    // import up to day before yesterday
    cxTo.Date:= dateOf(date-2);
    if TradeLogFile.CurrentAccount.FileImportFormat='Fidelity' then
      cxTo.Date:= dateOf(cxFrom.Date+90)
    else if (TradeLogFile.CurrentAccount.FileImportFormat='TradeStation')
    or (TradeLogFile.CurrentAccount.FileImportFormat='E-Trade') then begin
      if cxFrom.Date < dtNov01 then
        cxTo.Date:= inc3months(cxFrom.Date)
      else
        cxTo.Date:= dtJan31NY;
    end
    else if TradeLogFile.CurrentAccount.MTM
    and (TradeLogFile.NextTaxYear <> currentYear)
    and (cxTo.Date > dtDec31) then
      cxTo.Date := dtDec31;
  end;
end;


procedure TdlgImport.rbMoClick(Sender: TObject);
begin
  if rbMo.checked then begin
    if DayOf(cxFrom.Date) = 1 then
      cxTo.date:= dateOf(endOfTheMonth(cxFrom.Date))
    else
      cxTo.Date := cxFrom.Date + 30;
  end;
end;


initialization

end.
