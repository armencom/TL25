unit messagePanel;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Menus, StdCtrls,
  ComCtrls, cxButtons, ExtCtrls, RzCmboBx, RzLabel, RzPanel, dxSkinsCore, dxSkinHighContrast,
  dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TMessageType = (mtNegativeShares, mtInvalidTickers, mtCancelledTrades, mtMisMatchedTradeTypes,
    mtMisMatchedLS, mtZeroOrLessTrades);
  TMessageTypeSet = set of TMessageType;

  TpanelMsg = class(TForm)
    pnlMsg: TPanel;
    pnlBtns: TPanel;
    btnCancel: TcxButton;
    btnGetHelp: TcxButton;
    lblMsgLg: TLabel;
    lblMsg: TRichEdit;
    pnlSelectErrors: TPanel;
    cbErrors: TRzComboBox;
    lbSelectErrors: TRzLabel;

    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnGetHelpClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure cbErrorsChange(Sender: TObject);
    procedure cbErrorsClick(Sender: TObject);
  private
    FNegativeShares: Boolean;
    FMessageType: TMessageType;
    FIssues : Array[TMessageType] of Boolean;
    function GetIssueType(IssueType: TMessageType): Boolean;
    function GetTradeIssues: Boolean;
    function GetMessage(MsgType : TMessageType) : String;
    procedure ShowMessage(MsgType : TMessageType);
    { Private declarations }
  public
    { Public declarations }
    procedure ShowTradeIssuesError;
    procedure ShowTradeIssues;
    procedure ShowMsgPanel(Msg : TMessageTypeSet); overload;
    procedure ShowMsgPanel(Msg : TMessageType); overload;
    procedure ClearTradeIssues;
    procedure UpdateTradeIssues(IssueType : TMessageType; Active : Boolean = false);
    procedure JumpToMessageType(IssueType : TMessageType);
    property HasTradeIssue[IssueType : TMessageType] : Boolean read GetIssueType;
    property HasTradeIssues : Boolean read GetTradeIssues;
    property MessageType : TMessageType read FMessageType;


  end;

var
  PanelMsg: TpanelMsg;


implementation

{$R *.dfm}

uses
  TLCommonLib,
  Main, FuncProc, RecordClasses, TLSettings, TLRegister, TLFile;

var
  helpID : integer;

const
  CancelledTradesComboItem = 'Cancelled Trades Error';
  CancelledTradesTitle = 'Warning: Cancelled trades exist, but could not be matched automatically.';
  CancelledTradesMsg = '- The trades listed below with an "X" in the O/C column are cancellation records' + CRLF //
    + 'from your broker.' + CRLF //
    + '- There should be a corresponding trade that matches ticker, shares, price and' + CRLF //
    + 'sometimes L/S columns but TradeLog could not determine which trade matched.' + CRLF //
    + '- If no trades exist that correspond to the "X" trade then it is possible that' + CRLF //
    + 'the trade was previously cancelled.' + CRLF //
    + '- In this case you should delete the cancelled trade record marked with an "X".' + CRLF //
    + '- Otherwise you must manually determine which trade should have matched the "X"' + CRLF //
    + 'trade and delete it along with the "X" trade.' + CRLF //
    + 'Double-click on a trade below to isolate that ticker to find the problem';

  NegSharesComboItem = 'Negative Shares Error';
  NegSharesTitle = 'Warning: Some Trades Have Negative Shares';
  NegSharesMsg = '- The trades listed below have more shares closed than were opened.' + CRLF //
    + '- This needs to be fixed so a proper P&L can be calculated!' + CRLF //
    + 'Double-click on a record below to isolate that ticker to find the problem';

  InvalidTickersComboItem = 'Invalid Option Tickers Error';
  InvalidTickersTitle = 'Warning: Some Options have incorrectly formatted Tickers';
  InvalidTickersMsg = '- Option Tickers must be in the following Format:' + CRLF //
    + '  TICKER EXPDATE STRIKEPRICE TYPE' + CRLF //
    + CRLF //
    + 'Where:' + CRLF //
    + '  TICKER is the Stock Ticker for this option,' + CRLF //
    + '  EXPDATE is the expiration Date in DDMMMYY or MMMYYformat,' + CRLF //
    + '  STRIKEPRICE is the Strike Price for this option, and' + CRLF //
    + '  TYPE is CALL or PUT.'+ CRLF //
    + 'For example: MSFT 19JAN12 40 CALL' + CRLF //
    + CRLF //
    + '- Look for and correct any of the following issues:' + CRLF //
    + '  1) Any one of the above fields missing, or too many fields.' + CRLF //
    + '  2) No Space between fields or more than one space between fields.' + CRLF //
    + '  3) Spaces within fields, like Expiration date of 21 JAN 2011 instead of 21JAN11' + CRLF //
    + '  4) A Strike Price that is not numeric and will not convert to a REAL number.' + CRLF //
    + '  5) Invalid Date Format. Expiration dates must be in the MMMyy or ddMMMyy format' + CRLF //
    + ' (Example: FEB11 is the 3rd Friday in Feburary 2011; 21JAN11 is January 21, 2011).';

  MisMatchedTypesComboItem = 'Dis-similar Trade Types ';
  MisMatchedTypesTitle = 'Warning: Some Trades have Dis-Similar Type/Multipliers.';
  MisMatchedTypesMsg = 'All Trades for a trade number must have the same Type/Multiplier.' + CRLF //
    + '- Edit the trades in error, working from the last error to the first, and' + CRLF //
    + '  change the Type/Mult field so it matches other trades in a trade number.' + CRLF //
    + 'Double-click on a record below to isolate that ticker to find the problem.';

  MisMatchedLSComboItem = 'Dis-similar Long/Short entries ';
  MisMatchedLSTitle = 'Warning: Some Trades have Dis-Similar Long/Short entries.';
  MisMatchedLSMsg = 'All Trades for a trade number must have the same Long/Short column entries.' + CRLF //
    + 'Double-click on a record below to isolate that ticker to find the problem';

  ZeroOrLessTradesComboItem = 'Invalid Shares/Contracts/Price Error';
  ZeroOrLessTradesTitle = 'Warning: Some Individual Trades Have Zero or Negative Shares/Contracts or Negative Price';
  ZeroOrLessTradesMsg = '- Edit the trades in error and make sure all shares/contracts are positive values' + CRLF //
    + '- Edit the trades in error and make sure all prices are positive values.';


procedure TpanelMsg.btnCancelClick(Sender: TObject);
begin
  frmMain.GridFilter := gfAll;
  clearFilter;
  dispProfit(true, 0, 0, 0, 0);
  screen.Cursor := crDefault;
  hide;
end;


procedure TpanelMsg.btnGetHelpClick(Sender: TObject);
begin
  // NOTE: as of 1/25/19 the only way this happens is for a negative shares error
  webURL(supportSiteURL + 'hc/en-us/articles/115004849053-ERROR-Negative-shares');
end;


procedure TpanelMsg.cbErrorsChange(Sender: TObject);
begin
  FMessageType := TMessageType(StrToInt(cbErrors.Value));
  ShowMessage(FMessageType);
  cbErrors.SelLength := 0;
end;


procedure TpanelMsg.cbErrorsClick(Sender: TObject);
begin
  cbErrors.SelLength := 0;
end;


procedure TpanelMsg.ClearTradeIssues;
var
  T : TMessageType;
begin
  for T := Low(TMessageType) to High(TMessageType) do
    FIssues[T] := False;
end;


procedure TpanelMsg.FormCreate(Sender: TObject);
var
  T : TMessageType;
begin
  try // except
    parent:= frmMain.pnlMain;
    BorderStyle := bsNone;
    ClearTradeIssues;
  except
    if SuperUser then begin
      sm('error creating Message Panel form');
    end;
  end;
end;


procedure TpanelMsg.FormHide(Sender: TObject);
begin
  with frmMain do
  begin
    mnuAcct_Add.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    btnAddRec.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    btnInsRec.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    btnDelRec.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    addRecord1.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    insertRecord1.Enabled:= not (OneYrLocked or isAllBrokersSelected);
    enterOpenPositions1.Enabled:= not (OneYrLocked or isAllBrokersSelected);
  end;
end;


function TpanelMsg.GetIssueType(IssueType: TMessageType): Boolean;
begin
  Result := FIssues[IssueType]
end;


function TpanelMsg.GetMessage(MsgType: TMessageType): String;
begin
  Result := '';
  case MsgType of
    mtNegativeShares: Result := NegSharesMsg;
    mtInvalidTickers: Result := InvalidTickersMsg;
    mtCancelledTrades: Result := CancelledTradesMsg;
    mtMisMatchedTradeTypes: Result := MisMatchedTypesMsg;
    mtMisMatchedLS: Result := MisMatchedLSMsg;
    mtZeroOrLessTrades : Result := ZeroOrLessTradesMsg;
  end;
end;


function TpanelMsg.GetTradeIssues: Boolean;
var
  T : TMessageType;
begin
  Result := False;
  for T := Low(TMessageType) to High(TMessageType) do
    if FIssues[T] then
      Exit(True);
end;


procedure TpanelMsg.JumpToMessageType(IssueType : TMessageType);
var
  I : integer;
begin
  try
  if FIssues[IssueType] then begin
    if cbErrors.Items.Count > 0 then begin
      for I := 0 to cbErrors.Items.Count - 1 do begin
        if cbErrors.Values[I] = IntToStr(integer(IssueType)) then begin
          cbErrors.ItemIndex := I;
          cbErrorsChange(nil);
          Exit;
        end; // if cbErrors.Values
      end; // for I
    end
    else begin
      ShowMessage(IssueType);
    end; // if cbErrors.Count
  end; // if FIssues
  except
    if SuperUser then begin
      sm('error decoding MessageType' + CRLF + gsMainErrMsg);
    end;
  end;
end;


procedure TpanelMsg.showMsgPanel(Msg : TMessageTypeSet);
var
  T : TMessageType;
  I : Integer;
begin
  I := 0;
  for T in Msg do
    inc(I);
  // --- Set is empty -------
  if I = 0 then
    exit;
  // ------------------------
  pnlSelectErrors.Visible := (I > 1);
  lblMsgLg.Caption := '';
  cbErrors.Items.Clear;
  cbErrors.Text := '';
  lblMsg.Clear;
  helpID := 0;
  if mtCancelledTrades in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := CancelledTradesTitle;
      FMessageType := mtCancelledTrades;
      ShowMessage(mtCancelledTrades);
    end
    else
      cbErrors.AddItemValue(CancelledTradesComboItem, IntToStr(Integer(mtCancelledTrades)));
  end; // -------------------
  if mtMisMatchedTradeTypes in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := MisMatchedTypesTitle;
      FMessageType := mtMisMatchedTradeTypes;
      ShowMessage(mtMisMatchedTradeTypes);
    end
    else
      cbErrors.AddItemValue(MisMatchedTypesComboItem, IntToStr(Integer(mtMisMatchedTradeTypes)));
  end; // -------------------
  if mtMisMatchedLS in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := MisMatchedLSTitle;
      FMessageType := mtMisMatchedLS;
      ShowMessage(mtMisMatchedLS);
    end
    else
      cbErrors.AddItemValue(MisMatchedLSComboItem, IntToStr(Integer(mtMisMatchedLS)));
  end; // -------------------
  if mtZeroOrLessTrades in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := ZeroOrLessTradesTitle;
      FMessageType := mtZeroOrLessTrades;
      ShowMessage(mtZeroOrLessTrades);
    end
    else
      cbErrors.AddItemValue(ZeroOrLessTradesComboItem, IntToStr(Integer(mtZeroOrLessTrades)));
  end; // -------------------
  if mtInvalidTickers in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := InvalidTickersTitle;
      FMessageType := mtInvalidTickers;
      ShowMessage(mtInvalidTickers);
    end
    else
      cbErrors.AddItemValue(InvalidTickersComboItem, IntToStr(Integer(mtInvalidTickers)));
  end; // -------------------
  if mtNegativeShares in Msg then begin
    if (I = 1) then begin
      lblMsgLg.Caption := NegSharesTitle;
      FMessageType := mtNegativeShares;
      ShowMessage(mtNegativeShares);
    end
    else
      cbErrors.AddItemValue(NegSharesComboItem, IntToStr(Integer(mtNegativeShares)));
  end; // -------------------
  frmMain.GridFilter := gfTradeIssues;
  if pnlSelectErrors.Visible then begin
    cbErrors.ItemIndex := 0;
    cbErrorsChange(cbErrors);
  end;
end;


procedure TpanelMsg.ShowMessage(MsgType: TMessageType);
var
  Extent : TSize;
  Hgt : Integer;
  sErr : string;
begin
  try
    lblMsg.Lines.Clear;
    case MsgType of
      mtNegativeShares:
      begin
        sErr := 'Negative shares';
        lblMsg.Lines.Add(NegSharesMsg);
        lblMsgLg.Caption := NegSharesTitle;
        lblMsg.Font.Color := clBlack;
        // show neg share records
        RecordClasses.DispTradesNegShares;
        helpID:=19200;
      end;
      mtInvalidTickers:
      begin
        sErr := 'Invalid Tickers';
        lblMsg.Lines.Add(InvalidTickersMsg);
        lblMsgLg.Caption := InvalidTickersTitle;
        lblMsg.Font.Color := clBlack;
        RecordClasses.filterbyItemNumber(TradeLogFile.GetInvalidOptionTickers);
        helpID:=0;
      end;
      mtCancelledTrades:
      begin
        sErr := 'Cancelled Trades';
        lblMsg.Lines.Add(CancelledTradesMsg);
        lblMsgLg.Caption := CancelledTradesTitle;
        lblMsg.Font.Color := clBlack;
        RecordClasses.DispTradesCancelled;
        helpID:=0;
      end;
      mtMisMatchedTradeTypes:
      begin
        sErr := 'MisMatched Types';
        lblMsg.Lines.Add(MisMatchedTypesMsg);
        lblMsgLg.Caption := MisMatchedTypesTitle;
        lblMsg.Font.Color := clBlack;
        RecordClasses.DispTradesMisMatched;
        helpID:=0;
      end;
      mtMisMatchedLS:
      begin
        sErr := 'MisMatched L/S';
        lblMsg.Lines.Add(MisMatchedLSMsg);
        lblMsgLg.Caption := MisMatchedLSTitle;
        lblMsg.Font.Color := clBlack;
        RecordClasses.DispTradesMisMatchedLS;
        helpID:=0;
      end;
      mtZeroOrLessTrades:
      begin
        sErr := 'Zero of Less Trades';
        lblMsg.Lines.Add(ZeroOrLessTradesMsg);
        lblMsgLg.Caption := ZeroOrLessTradesTitle;
        lblMsg.Font.Color := clBlack;
        RecordClasses.DispZeroOrLessTrades;
        helpID:=0;
      end;
    end; // -----------------
  except
    On E : Exception Do
    gsMainErrMsg := 'MessagePanel error in' + sErr + ': ' + E.Message;
  end;
  // ------------------------
  try
    sErr := 'Height';
    Hgt := lblMsgLg.Height;
    if pnlSelectErrors.Visible then
      Hgt := Hgt + pnlSelectErrors.Height;
    // ----------------------
    sErr := 'panelMsg';
    GetTextExtentPoint(Canvas.Handle, 'Test', 4, Extent);
    if Extent.cy = 0 then
      Extent.cy := 16;
    panelMsg.AutoSize := False;
    panelMsg.height:= 20 + Hgt + (lblMsg.lines.Count * (Extent.cy));
    panelMsg.AutoSize:= true;
    btnGetHelp.Visible := HelpID <> 0;
    // ----------------------
    sErr := 'Grid filter text';
    with frmMain do begin
      if (pos('Ticker',cxGrid1TableView1.dataController.Filter.filterText) = 0) then
      begin
        mnuAcct_Add.Enabled:= false;
        btnAddRec.Enabled:= false;
        btnInsRec.Enabled:= false;
        btnDelRec.Enabled:= false;
        addRecord1.Enabled:= false;
        insertRecord1.Enabled:= false;
        enterOpenPositions1.Enabled:= false;
      end; // if ticker
//      // make sure Edit menu is disabled if on All Accounts tab
//      if (TradeLogFile.FileHeaders.Count > 1) //
//      and (frmMain.TabAccounts.TabIndex = 0) //
//      then begin
//        mnuFile_Edit.Enabled := false;
//      end; // if all accounts
    end; // with
    sErr := 'Show';
    Show;
    Align:= alTop;
    Top:= - 1;
  except
    On E : Exception Do
    gsMainErrMsg := 'MessagePanel error in' + sErr + ': ' + E.Message;
  end;
end;


procedure TpanelMsg.ShowMsgPanel(Msg: TMessageType);
begin
  ShowMsgPanel([Msg]);
end;


procedure TpanelMsg.ShowTradeIssues;
var
  T : TMessageType;
  MsgSet : TMessageTypeSet;
begin
  MsgSet := [];
  for T := Low(TMessageType) to High(TMessageType) do begin
    if FIssues[T] then begin
      MsgSet := MsgSet + [T];
    end; // if
  end; // for
  ShowMsgPanel(MsgSet);
end;


procedure TpanelMsg.ShowTradeIssuesError;
var
  Msg : String;
begin
  Msg := '';
  if HasTradeIssues then begin
    Msg := 'You MUST FIX ALL ERRORS before you can run G&&L reports accurately!';
  end; // if HasTradeIssues
  if Length(Msg) > 0 then begin
    mDlg(Msg,mtError,[mbOK],0);
  end; // if Length(Msg)>0
end;


procedure TpanelMsg.UpdateTradeIssues(IssueType: TMessageType; Active: Boolean);
begin
  FIssues[IssueType] := Active;
end;

end.
