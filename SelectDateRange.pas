unit SelectDateRange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, //
  StdCtrls, ExtCtrls, ComCtrls, //
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, //
  cxLookupEdit, cxDBLookupEdit, cxDBLookupComboBox, cxListBox, cxCalendar, //
  cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, cxDateUtils, //
  dxCore, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, //
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TfrmRangeSelect = class(TForm)
    pnlCalendar: TPanel;
    pnlOK: TPanel;
    Button2: TButton;
    pnlYear: TPanel;
    btnOKYear: TButton;
    cboYear: TcxComboBox;
    Label7: TLabel;
    btnOKStartEnd: TButton;
    calTo: TcxDateEdit;
    Label17: TLabel;
    Label16: TLabel;
    calFrom: TcxDateEdit;
    progrBar: TProgressBar;
    Label3: TLabel;
    Label11: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    btnQ1: TButton;
    btnQ2: TButton;
    btnQ3: TButton;
    btnQ4: TButton;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure calFromPropertiesEditValueChanged(Sender: TObject);
    procedure calToPropertiesEditValueChanged(Sender: TObject);
    procedure calFromPropertiesChange(Sender: TObject);
    procedure calToPropertiesChange(Sender: TObject);
    procedure btnOKStartEndClick(Sender: TObject);
    procedure btnOKYearClick(Sender: TObject);
    procedure btnQ1Click(Sender: TObject);
    procedure btnQ2Click(Sender: TObject);
    procedure btnQ3Click(Sender: TObject);
    procedure btnQ4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRangeSelect: TfrmRangeSelect;

implementation

{$R *.DFM}

uses
  RecordClasses, FuncProc, Main, TLSettings, TLCommonLib, TLFile;

procedure TfrmRangeSelect.btnCancelClick(Sender: TObject);
begin
  frmRangeSelect.hide;
  ModalResult := mrCancel;
  frmMain.GridFilter := gfNone;
  RangeStart := xStrToDate('1/1/1900');
  RangeEnd:= xStrToDate('1/1/1900');
end;


procedure TfrmRangeSelect.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  //repaintGrid;
end;

procedure TfrmRangeSelect.CalFromPropertiesEditValueChanged(
  Sender: TObject);
begin
  if LoadingRecs then exit;
  if calFrom.date > calTo.date then
  begin
    mDlg('From Date Error:' + cr //
      + 'Start Date MUST be less than or equal to End Date', //
      mtError, [mbOK], 0);
    CalFrom.date := CalTo.Date;
  end;
end;

procedure TfrmRangeSelect.calToPropertiesEditValueChanged(Sender: TObject);
begin
  if LoadingRecs then exit;
  if calFrom.date>calTo.date then begin
    sm(
    'END DATE ERROR:'+cr+
    'END Date MUST be greater than or equal to START Date');
    calTo.date:= TradeLogFile.LastDateImported;
  end;
end;

procedure TfrmRangeSelect.calFromPropertiesChange(Sender: TObject);
begin
  if LoadingRecs then exit;
  with calFrom do begin
    if date < properties.minDate then begin
      sm('Minimum START date is: ' //
        + dateToStr(properties.minDate,Settings.UserFmt));
      date:= properties.minDate;
    end
    else if date > properties.maxDate then begin
      sm('Maximum START date is: ' //
        + dateToStr(properties.maxDate,Settings.UserFmt));
      date:= properties.minDate;
    end;
  end;
end;

procedure TfrmRangeSelect.calToPropertiesChange(Sender: TObject);
begin
  if LoadingRecs then exit;
  with calTo do begin
    if date < properties.minDate then begin
      sm('Minimum END date is: '+dateToStr(properties.minDate,Settings.UserFmt));
      date:= properties.maxDate;
    end
    else if date > properties.maxDate then begin
      sm('Maximum END date is: '+dateToStr(properties.maxDate,Settings.UserFmt));
      date:= properties.maxDate;
    end;
  end;
end;

procedure TfrmRangeSelect.btnOKStartEndClick(Sender: TObject);
var
  StartDt,EndDt:TDate;
begin
  StartDt:= xStrToDate(calFrom.text,Settings.UserFmt);
  EndDt:= xStrToDate(calTo.text,Settings.UserFmt);
  frmMain.GridFilter := gfRange;
  frmRangeSelect.hide;
  ModalResult := mrOK;
  filterByDateRange(StartDt,EndDt);
  dispProfit(true,0,0,0,0);
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    //spdShowRange.down:= true;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

procedure TfrmRangeSelect.btnOKYearClick(Sender: TObject);
var
  StartDt, EndDt, MinDate : TDate;
begin
  StartDt:= xStrToDate('01/01/' + cboYear.properties.items[cboYear.itemIndex]);
  EndDt:= xStrToDate('12/31/ ' + cboYear.properties.items[cboYear.itemIndex]);
  frmRangeSelect.hide;
  ModalResult := mrOK;
  // ------------------------
  filterByDateRange(StartDt, EndDt);
  dispProfit(true,0,0,0,0);
  if TradeLogFile.Count > 0 then
    minDate:= TradeLogFile[0].Date
  else
    minDate := StartDt;
  if startDt > minDate then
    calFrom.date:= startDt
  else
    calFrom.date:= minDate;
  // ------------------------
  calTo.Date:= endDt;
  frmMain.GridFilter := gfRange;
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

// Q1 1/1-3/31
// Q2 4/1-6/30
// Q3 7/1-9/30
// Q4 10/1-12/31
// -------------
procedure TfrmRangeSelect.btnQ1Click(Sender: TObject);
var
  StartDt, EndDt: TDate;
  nYear : integer;
  sDt1, sDt2 : string;
begin
  nYear := TradeLogFile.TaxYear;
  sDt1 := '1/1/' + IntToStr(nYear);
  StartDt:= xStrToDate(sDt1, Settings.UserFmt);
  sDt2 := '3/31/' + IntToStr(nYear);
  EndDt:= xStrToDate(sDt2,Settings.UserFmt);
  frmMain.GridFilter := gfRange;
  frmRangeSelect.hide;
  ModalResult := mrOK;
  filterByDateRange(StartDt,EndDt);
  dispProfit(true,0,0,0,0);
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    //spdShowRange.down:= true;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

procedure TfrmRangeSelect.btnQ2Click(Sender: TObject);
var
  StartDt, EndDt: TDate;
  nYear : integer;
  sDt1, sDt2 : string;
begin
  nYear := TradeLogFile.TaxYear;
  sDt1 := '4/1/' + IntToStr(nYear);
  StartDt:= xStrToDate(sDt1, Settings.UserFmt);
  sDt2 := '6/30/' + IntToStr(nYear);
  EndDt:= xStrToDate(sDt2,Settings.UserFmt);
  frmMain.GridFilter := gfRange;
  frmRangeSelect.hide;
  ModalResult := mrOK;
  filterByDateRange(StartDt,EndDt);
  dispProfit(true,0,0,0,0);
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    //spdShowRange.down:= true;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

procedure TfrmRangeSelect.btnQ3Click(Sender: TObject);
var
  StartDt, EndDt: TDate;
  nYear : integer;
  sDt1, sDt2 : string;
begin
  nYear := TradeLogFile.TaxYear;
  sDt1 := '7/1/' + IntToStr(nYear);
  StartDt:= xStrToDate(sDt1, Settings.UserFmt);
  sDt2 := '9/30/' + IntToStr(nYear);
  EndDt:= xStrToDate(sDt2,Settings.UserFmt);
  frmMain.GridFilter := gfRange;
  frmRangeSelect.hide;
  ModalResult := mrOK;
  filterByDateRange(StartDt,EndDt);
  dispProfit(true,0,0,0,0);
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    //spdShowRange.down:= true;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

procedure TfrmRangeSelect.btnQ4Click(Sender: TObject);
var
  StartDt, EndDt: TDate;
  nYear : integer;
  sDt1, sDt2 : string;
begin
  nYear := TradeLogFile.TaxYear;
  sDt1 := '10/1/' + IntToStr(nYear);
  StartDt:= xStrToDate(sDt1, Settings.UserFmt);
  sDt2 := '12/31/' + IntToStr(nYear);
  EndDt:= xStrToDate(sDt2,Settings.UserFmt);
  frmMain.GridFilter := gfRange;
  frmRangeSelect.hide;
  ModalResult := mrOK;
  filterByDateRange(StartDt,EndDt);
  dispProfit(true,0,0,0,0);
  With frmMain do
    begin
    RangeStart := StartDt;
    RangeEnd := EndDt;
    //spdShowRange.down:= true;
    tradesSummary.enabled:= false;
  end;
  ModalResult := mrOK
end;

end.
