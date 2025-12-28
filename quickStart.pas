unit quickStart;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, Menus, OleCtrls, SHDocVw, StdCtrls, cxButtons,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, ExtCtrls, StrUtils, ComCtrls,
  cxSpinEdit, cxSpinButton, cxSplitter, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black,
  dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TpanelQS = class(TForm)
    pnlTop: TPanel;
    pnlBtns: TPanel;
    btnViewTut: TcxButton;
    btnHelp: TcxButton;
    pnlStep: TPanel;
    qsTitle: TLabel;
    cboStep: TcxComboBox;
    btnNext: TcxButton;
    pnlMain: TPanel;
    pnlDetails: TPanel;
    wbDetails: TWebBrowser;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnViewTutClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure cboStepPropertiesChange(Sender: TObject);
    procedure reDetailsMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnNextClick(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure pnlDetailsResize(Sender: TObject);
    procedure FormResize(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure loadQSsteps;
    procedure doQuickStart(Step, SubStep : integer); overload;
    procedure doQuickStart(Step, SubStep : integer; ForceVisible : Boolean); overload;
  end;

var
  panelQS : TpanelQS;
  doingQS : boolean;
  BrokerMatrixDisplayed : boolean = false;

implementation

{$R *.dfm}

uses
  main,funcProc,TLregister,TLSettings,splash,activex,EditSplit, TLFile, TLCommonLib;

const
  ph = 26;     //QS panel height collapsed
  phE = 160;   //QS panel height expanded

var
  helpID : integer;
  tutStep : string;


procedure TpanelQS.FormCreate(Sender: TObject);
begin
  parent:= frmMain;
  BorderStyle := bsNone;
  panelQS.loadQSsteps;
end;

procedure TpanelQS.FormHide(Sender: TObject);
begin
  frmMain.Splitter1.Visible := False;
end;

procedure TpanelQS.FormResize(Sender: TObject);
begin
  if pnlMain.height<30 then
    pnlDetails.Hide
  else begin
    pnlDetails.Show;
    wbDetails.Show;
  end;
end;

procedure TpanelQS.FormShow(Sender: TObject);
var
  i:integer;
begin
  Height := phe;
  align:= alBottom;
  top:= 1;
  frmMain.Splitter1.Visible := True;
  frmMain.Splitter1.Top := 0;
  frmMain.Splitter1.MinSize := 1;
  if (TrFileName = '') then
    if Settings.DispQS then doQuickStart(1,1);
end;

procedure TpanelQS.btnViewTutClick(Sender: TObject);
begin
  webURL(SiteURL + 'support/online-tutorial/#'+tutStep);
end;

procedure TpanelQS.btnHelpClick(Sender: TObject);
begin
//  HtmlHelp(GetDesktopWindow, pchar(Settings.HelpFileName), HH_HELP_CONTEXT, helpID);
  case helpID of // 2019-01-18 MB
  2110 : webURL(supportSiteURL + 'hc/en-us/sections/115000954573');
  2120 : webURL(supportSiteURL + 'hc/en-us/sections/115000956834');
  2130 : webURL(supportSiteURL + 'hc/en-us/sections/115000956854');
  2140 : webURL(supportSiteURL + 'hc/en-us/sections/115000956874');
  2150 : webURL(supportSiteURL + 'hc/en-us/sections/115000954613');
  2160 : webURL(supportSiteURL + 'hc/en-us/sections/115000956894');
  2170 : webURL(supportSiteURL + 'hc/en-us/sections/115000956914');
  2180 : webURL(supportSiteURL + 'hc/en-us/sections/115000956934');
  end;
end;

procedure TpanelQS.btnNextClick(Sender: TObject);
begin
  if trFileName<>'' then
    doQuickStart(cboStep.itemIndex + 2, 1);
end;

procedure TpanelQS.cboStepPropertiesChange(Sender: TObject);
begin
  if doingQS
  or (cboStep.properties.Items.Count = 0)
  then exit;

  with frmMain.cxGrid1tableView1.OptionsData do
  if Editing then frmMain.GridEscape;

  if Settings.DispQS then
    doQuickStart(cboStep.itemIndex+1,1);

  try
    // test if file is open and grid is showing
    if TrFileName <> '' then
      frmMain.cxGrid1.SetFocus;
  except
  end;
end;

procedure TpanelQS.reDetailsMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  frmMain.cxGrid1.SetFocus;
end;

procedure WBLoadHTML(wbDetails:TwebBrowser; HTMLCode: string);
var
  sl: TStringList;
  ms: TMemoryStream;
begin
  wbDetails.Navigate('about:blank') ;

  while wbDetails.ReadyState < READYSTATE_INTERACTIVE do
    Application.ProcessMessages;

  HTMLcode:='<html><head>'+
    '<style>'+
    'body{margin:0;padding:6px 6px 10px 6px;}'+
    'p{margin:0 0 8px 0;padding:0;}'+
    'ul{padding:0; margin:-4px 0 8px 20px;} '+
    'li{padding:2px 0 0 0; margin:0 0 0 2px;}'+
    'blockquote{padding:0 0 0 10px;margin:0;}'+
    'hr{line-height:1px;}'+
    '</style>'+
    '<head>'+
    '<body style="font:9pt Arial, Helvetica, sans-serif;">'+
    HTMLcode+'</body></html>';

  if Assigned(wbDetails.Document) then
  begin
     sl := TStringList.Create;
     try
       ms := TMemoryStream.Create;
       try
         sl.Text := HTMLCode;
         sl.SaveToStream(ms) ;
         ms.Seek(0, 0) ;
         (wbDetails.Document as IPersistStreamInit).Load(TStreamAdapter.Create(ms)) ;
       finally
         ms.Free;
       end;
     finally
       sl.Free;
     end;
  end;
  {
  if QShid then
  with frmMain do begin
    qsTitle.Caption:='QS Step '+cboStep.text;
  end;
  }
end;


procedure TpanelQS.loadQSsteps;
begin
  with cboStep.properties.items do begin
    clear;
    //load steps
    add('Step 1:  Create a data file / Open a data file');
    add('Step 2: Enter Baseline Positions');
    add('Step 3: Import Trade History');
    add('Step 4: Verify Imported Data');
    add('Step 5: Reconcile 1099 Proceeds');
    add('Step 6: Process Year End');
    add('Step 7: Run Gains & Losses Report');
    add('Step 8: File Your Taxes');
  end;
end;


procedure TpanelQS.pnlDetailsResize(Sender: TObject);
begin
  if pnlDetails.Height > 0 then
    wbDetails.Height := pnlDetails.Height - 10;
end;

procedure TpanelQS.doQuickStart(Step, SubStep : integer);
begin
  doQuickStart(Step, SubStep, false);
end;


// ==============================================
//
// ==============================================
procedure TpanelQS.doQuickStart(Step, SubStep : Integer; ForceVisible : Boolean);
var
  instr, sHTML, irsRpt, instrLine, InstrPage :string;
  H, Ht, Hl, Hw, Hh : Integer;
begin
  // Only 8 steps for now so don't allow an invalid step number
  if Step > 8 then
    exit;
  doingQS := True;
  InstrPage := SiteURL + 'support/broker-imports';
  // ----------------------------------
  if (taxYear > '2010') then
    irsRpt := 'IRS Form 8949'
  else
    irsRpt := 'IRS Schedule D-1';
  // ----------------------------------
  case Step of
  // ----------------------------------
  1 : begin
      helpID := 2110;
      tutStep := 'step1';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := '<p><b>Create one TradeLog data file for all your brokerage accounts</b>' +
            ' - menu item: <b>File, New.</b></p>' +
            '<ul><li><b>If you used TradeLog last year</b>, open the next tax year data file created'
            + ' when you ended the previous year – menu item: <b>File, Open.</b></li></ul>' +
            '<p><span style="color:red"><b>You should maintain one tax year data file containing' +
            ' all brokerage accounts reported for the same taxpayer.</b></span></p>';
        end;
      // ------------------------------
      2 : begin
          instr := '<p><b>Name your TradeLog brokerage account data file appropriately.</b></p>' +
            '<ul><li>Enter the <b>Tax Year </b> for this file, and a <b>Descriptive Name </b>for your data file.</li>'
            + '<li>You may change the default folder to store your at this time.</li>';
          if Settings.MTMVersion then
            instr := instr +
              '<li>Answer the two Mark to Market accounting questions by checking the proper check boxes.</li>';
          instr := instr + '</ul> <p>Click the <b>OK </b>button to save your file.</p>';
        end;
      // ------------------------------
      3 : begin
          instr := '<p>Select an <b>Import Filter </b>from the drop down box and click the <b>OK </b>button.</p>';
          instr := instr +
            '<ul><li>If the <b>Import Filter</b> you choose has multiple import methods, then the <b>Default Import Method </b>drop down box will be enabled and appropriate methods will be shown for the filter chosen.'
            + '<br>You can leave it set to "<b>Select Each Time</b>" if you want to be given the option to select the import method each time you do an import. Otherwise you can select an Import method to use.'
            + '<li>If the <b>Import Filter</b> you choose supports a base currency other than US Dollars, then the <b>Base Currency</b> drop down will be enabled. '
            + '<br>Please select the currency that represents the data you will import for this broker.</li>'
            + '<li>If the <b>Import Filter</b> you choose supports round trip commission, then the <b>Commission per RT</b> field will be enabled. Please enter the round trip commission.</li></ul>';
        end;
      end;
    end;
  // ----------------------------------
  2 : begin
      helpID := 2120;
      tutStep := 'step2';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := '<p><span style="color:red"><b>' +
            'PLEASE DO NOT SKIP THIS IMPORTANT STEP THE FIRST YEAR USING TRADELOG.</b></span></p>' +
            '<ul><li><b>Use the Baseline Positions Wizard to help enter baseline positions at the end of YEAR</b>'
            + ' – menu item: <b>Add, Baseline Position Wizard (F8)</b></br>' +
            '<b>. . . Or, manually enter all baseline positions held open at the end of 2013</b>' +
            ' - menu item: <b>Add, Enter Open Positions (F7)</b></li>' +
            '<li><b>You will import your trades for the current tax year in step 3.</b></li></ul>' +
            '<p><span style="color:red"><b>PLEASE NOTE:' +
            ' It is only necessary to do this the first year you use TradeLog.</b></span></p>';
        end;
      end;
// InstrPage := SiteURL + 'support/broker-imports';
    end;
  // ----------------------------------
  3 : begin
      helpID := 2130;
      tutStep := 'step3';
      try
        if (TradeLogFile <> nil) and (TradeLogFile.CurrentBrokerID > 0) then
          InstrPage := TradeLogFile.CurrentAccount.ImportFilter.InstructPage;
//        if Settings.DispImport then begin // 2021-11-12 MB - deactivated
//          with frmMain do begin
//            Ht := top + panelQS.height + 120;
//            Hl := left + 40;
//            Hw := width;
//            Hh := height -(Ht - top)+ 10;
//          end;
//          // the next line displays import help specific to the Current Broker ID...
//          if (BrokerMatrixDisplayed = false) then begin
//            BrokerMatrixDisplayed := True;
//            webURL(InstrPage);
//          end;
//        end;
      except
        // failed
      end;
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := ' <p><b>Import trade history from your online brokerage.</b><br>' +
            '<span style="color:red"><b><b>Please read the specific import instructions for your brokerage before importing!</b></p></b></span>'
            + '<ul>' + '<li>Click the <b>' + frmMain.btnImport.caption +
            ' </b>button on the toolbar to begin the import process.</li>' +
            '<li>Use the <b>BrokerConnect </b>import method (if it is available for your broker) as this is the most efficient method of import.</li>'
            + '<li>Please import a full 13 months worth of data (ie: Jan 1 to Jan 31 of next tax year) - this is required for accurate wash sale calculations.</li>';
          if Settings.MTMVersion then
            instr := instr +
              '<li><b>If you elected MTM for the current tax year then only import up to Dec 31 of the current tax year!</b></li>';
          instr := instr + '</ul>';
        end;
      end;
    end;
  // ----------------------------------
  4 : begin
      helpID := 2140;
      tutStep := 'step4';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := ' <p><b>A) Check for Errors:</b> - ' +
            'If you have any errors such as "Neg Share Errors" these MUST be fixed before continuing!</p>'
            + '<p><b>B) Verify Open Positions:</b> - ' +
            'Click the <b>Open </b>button on the toolbar to verify that open positions in TradeLog match with what was really open in your account.</p>'
            + '<ul><li>You may do this after each import, or import all records up to the year end and then verify your open positions.</li>'
            + '<li>Import all of January of next year and verify your open positions again.</li>' +
            '<li>Imbalances in open positions are usually due to missing open positions from last year, or other adjustments such as mergers and other corporate actions.</li></ul></p>';
        end;
      end;
    end;
  // ----------------------------------
  5 : begin
      helpID := 2150;
      tutStep := 'step5';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := ' <p>After you get your 1099, run the <b>Reconcile 1099-B </b>report to make sure your Gross Proceeds (Sales Amount) balances with TradeLog.</p>'
            + '<ul><li>Use menu item <b>Reports, Gains & Losses; Tax Forms, </b>select the <b>Reconcile 1099-B </b>report type, and click the <b>Run Report </b>button.</li></ul>'
            + '<b><u>Note:</u> </b>You should run this report from each brokerage account tab!';
        end;
      end;
    end;
  // ----------------------------------
  6 : begin
      helpID := 2160;
      tutStep := 'step6';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := '<p><b>End the Current Tax Year</b> - make any necessary adjustments to get things ready for next year.</p>'
            + '<ul><li>Complete the <b>Year End Checklist</b> for each account tab – menu item: <b>Account, Year End Checklist.</b></li>'
            + '<li>Please include non-taxable files such as IRA account files, as this is necessary for wash sales.</li></ul>'
            + '<p><b>From the ALL tab</b> use menu item <b>File, End Tax Year.</b></p>' +
            '<p>This will create a new data file for your Next Tax Year data, and TradeLog will automatically name it accordingly.'
            + ' This new file will be used to continue the next tax year.</p>' +
            '<ul><li>Any disallowed wash sale losses (deferred losses) will be included in this file.</li>'
            + '<li>All year end open positions will be included in this file.</li>' +
            '<li>All January of Next Tax Year trades will be included in this file.</li>' +
            '<li>For MTM, all mark-to-market entries will be made in the current and next year files.</li></ul>';
        end;
      end;
    end;
  // ----------------------------------
  7 : begin
      helpID := 2170;
      tutStep := 'step7';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := ' <p><b>From the ALL tab</b> use menu item: <b>Reports,</b> select and run the appropriate reports for your tax circumstances and account types. </b> <br><br>';
        end;
      end;
    end;
  // ----------------------------------
  8 : begin
      helpID := 2180;
      tutStep := 'step8';
      // ------------------------------
      if (taxYear > '2010') then
        instrLine := 'Print the <b>' + irsRpt + ' </b>report. '
      else
        instrLine := 'Print either the <b>Gains & Losses </b>report or the <b>' + irsRpt +
          ' </b>report depending on your preference. ';
      // ------------------------------
      case SubStep of
      // ------------------------------
      1 : begin
          instr := ' <p><b>File By Mail:</b></p>' + '<ul><li>' + instrLine + '</li>' +
            '<li>Enter the totals on your Schedule D.</li>' +
            '<li>Complete the rest of your tax return and mail.</li></ul>';
          if (taxYear > '2010') then
            instrLine := ' - Run the <b>' + irsRpt + ' </b>report. </p>'
          else
            instrLine := ' - Run either the <b>Gains & Losses report </b>or the <b>' + irsRpt +
              ' </b>report depending on your preference. </p>';
          instr := instr + '<hr><p><b>Send to Accountant:</b></p>' + instrLine +
            '<li>From the Report Preview window <b>Save the report as a PDF file </b>by clicking the <b>PDF </b>button on the toolbar.</li>'
            + '<li>Email the PDF file to your accountant to include with the rest of your tax return.</li></ul>'
            + '</ul>' + '<hr><p><b>E-File:</b></p>';
          if taxYear < '2011' then
            instr := instr +
              '<ul><li>Run the <b>TXF File Export </b>or <b>TaxACT CSV Export </b>report and save the file to your hard drive.</li>'
              + '<li>Use your tax software to import the saved TXF or CSV file.</li></ul>'
          else
            instr := instr +
              '<ul><li>Run the <b>IRS Form 8949 report</b> (check the box <b>Create Form8949.pdf attachment for eFiling</b>'
              + ' on the report menu.)</<li>' +
              '<li>Save the Form8949.pdf then use this for eFiling.</li>' +
              '<li>Click the Help button on this guide to view more details and options.</li></ul>'
        end;
      // ------------------------------
      2 : begin // TaxAct
          helpID := 16014;
          instr := ' <p><b>E-File using TaxACT:</b></p>' +
            '<ul><li>Login to your TaxACT account to import the CSV file you just saved.</li></ul>';
        end;
      // ------------------------------
      3 : begin // TurboTax
          helpID := 16100;
          instr := ' <p><b>E-File using TurboTax:</b></p>' +
            '<ul><li>Login to your TurboTax account to import the TXF file you just saved.</li></ul>';
        end;
      // ------------------------------
      4 : begin // TaxAct D-1 Send
          helpID := 16040;
          instr := ' <p><b>E-File by entering your Gains and Loss totals into TaxACT:</b></p>' +
            '<ul><li>' + instrLine + '</li>' + '<li>Enter the totals into TaxACT and E-File.</li>' +
            '<li>Print the Form 8453 from TaxACT, attach the TradeLog report, and mail to the IRS.</li>'
            + '</ul>';
        end;
      // ------------------------------
      5 : begin // TurboTax D-1 Send
          helpID := 16040;
          instr := ' <p><b>File by mail by entering your Gains and Loss totals into TurboTax:</b></p>'
            + '<ul><li>' + instrLine + '</li>' +
            '<li>Enter the totals into TurboTax and print your return.</li>' +
            '<li>Attach the TradeLog report to your TurboTax return, and mail to the IRS.</li>'
            + '</ul>';
        end;
      end;
    end;
  end;
  // ------------------------
  if ((Step = 1)and(TrFileName = '')) or (Step = 8) then
    btnNext.enabled := false
  else
    btnNext.enabled := True;
  cboStep.itemIndex := Step - 1;
  // ------------------------
//  if Settings.DispQS or ForceVisible then panelQS.Show;
  WBLoadHTML(wbDetails, instr);
  doingQS := false;
end;


end.
