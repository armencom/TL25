unit fm1099more;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxLookAndFeels,
  cxLookAndFeelPainters, Vcl.Menus, Vcl.StdCtrls, cxButtons, Vcl.ExtCtrls, fm1099Info;

type
  Tfrm1099more = class(TForm)
    pnlHelpProceeds: TPanel;
    lblProceedsNote1: TLabel;
    lblHelpProceeds: TLabel;
    pnlHelpCost: TPanel;
    notesTotals: TLabel;
    lblCostNote1a: TLabel;
    lblCostNote1b: TLabel;
    lnk8949Category: TLabel;
    pnlHelpDetails: TPanel;
    notesDet2: TLabel;
    Label2: TLabel;
    lblOptPrem: TLabel;
    lblCostNote1: TLabel;
    pnlUGtut: TPanel;
    lnkTutorial: TLabel;
    lnkUG1099: TLabel;
    lblProceedsNote2: TLabel;
    lblCostNote2: TLabel;
    lblCostNote3: TLabel;
    pnlPre2014cb: TPanel;
    lblOptions: TLabel;
    notesDet1: TLabel;
    lblMutFunds: TLabel;
    notesMut: TLabel;
    lblETF: TLabel;
    notesETF: TLabel;
    lnk8949Code: TLabel;
    lblDrips: TLabel;
    notesDrip: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lnk8949CategoryClick(Sender: TObject);
    procedure lnk8949CodeClick(Sender: TObject);
    procedure lnkTutorialClick(Sender: TObject);
    procedure lnkUG1099Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure getHelp(helpStr:string);
  end;

var
  frm1099more: Tfrm1099more;

implementation

{$R *.dfm}

uses
  TLfile, Main, funcProc, TLSettings;

const
  MSG_DRIPS_2011 = 'For 2011 most brokers report DRIPs as non-covered securities on 1099-B. However a few brokers opt to not report at all. If your broker did not report DRIPs on the 1099-B then uncheck this box.';
  MSG_ETF_2011 = 'Brokers vary in their reporting of ETF/ETNs. Most brokers are including these as covered securities on 1099-B. If your broker reported these as non-covered securities then uncheck this box.';
  MSG_MUT_2011 = 'For 2011 most brokers report mutual funds as non-covered securities on the 1099-B. However a few brokers opt to not report at all. If your broker did not report Mutual Funds on the 1099-B then uncheck this box.';

  MSG_START_2012 = 'Starting with tax year 2012 ';
  MSG_REPORTED_2012 = ' should be reported by your broker as covered securities. ';
  MSG_UNCHECK_2012 = 'Only uncheck this box if your broker did not report ';
  MSG_MOVE_2012 = ' as covered securities. This will move all securities in TradeLog marked with the ';
  MSG_8949_2012 = ' type to the non-covered section of Form 8949.';


  MSG_MUT_DESC = 'Mutual Funds';
  MSG_MUT_TYPE = 'MUT-1';
  MSG_MUT_2012 =
    MSG_START_2012 + MSG_MUT_DESC +
    MSG_REPORTED_2012 +
    MSG_UNCHECK_2012 + MSG_MUT_DESC +
    MSG_MOVE_2012 + MSG_MUT_TYPE +
    MSG_8949_2012;

  MSG_ETF_2012 = 'Starting with tax year 2012 most ETF/ETNs should be reported by your broker as covered securities. ' +
                 'Only uncheck this box if your broker did not report ALL ETF/ETNs as covered securities. '+
                 'This will move all securities in TradeLog marked with the ETF-1 type to the non-covered section of Form 8949. ' +
                 'If your broker reported some ETF/ETNs as noncovered and most as covered, ' +
                 'then you will need to adjust for this using the "Change 8949 Code function".';

  MSG_DRIPS_DESC = 'DRIPs';
    MSG_DRIPS_TYPE = 'DRP-1';
    MSG_DRIPS_2012 =
    MSG_START_2012 +  MSG_DRIPS_DESC +
    MSG_REPORTED_2012 +
    MSG_UNCHECK_2012 + MSG_DRIPS_DESC +
    MSG_MOVE_2012 + MSG_DRIPS_TYPE +
    MSG_8949_2012;

  MSG_COST_2011 = '- For 2011 there usually will not be any long-term cost basis reported on 1099-B, in which case you should leave the amount blank.';

procedure Tfrm1099more.getHelp(helpStr:string);
begin
  if (helpStr = 'proceeds') then
  begin
    pnlHelpProceeds.Show;
    pnlHelpProceeds.Align := alTop;
    Height := pnlUGtut.Height + pnlHelpProceeds.Height + 20
  end else
  if (helpStr = 'cost') then
  begin
    pnlHelpCost.Show;
    pnlHelpCost.Align := alTop;
    Height := pnlUGtut.Height + pnlHelpCost.Height + 20
  end else
  if (helpStr = 'details') then
  begin
    pnlHelpDetails.Show;
    pnlHelpDetails.Align := alTop;
    Height := pnlUGtut.Height + pnlHelpDetails.Height + 20;
  end;
  top := frm1099info.top + trunc(frm1099info.Height/2) - trunc(frm1099more.Height/2);
  left := frm1099info.left  + trunc(frm1099info.Width/2) - trunc(frm1099more.Width/2);
end;

procedure Tfrm1099more.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Tfrm1099more.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = 27 then close;
end;

procedure Tfrm1099more.FormShow(Sender: TObject);
begin
  if TradeLogFile.TaxYear = 2011 then
  begin
    lblCostNote1b.Caption := MSG_COST_2011;
    notesDrip.Caption := MSG_DRIPS_2011;
    notesETF.Caption := MSG_ETF_2011;
    notesMUT.Caption := MSG_MUT_2011;
  end else
  if TradeLogFile.TaxYear > 2011 then
  begin
    notesDrip.Caption := MSG_DRIPS_2012;
    notesETF.Caption := MSG_ETF_2012;
    notesMUT.Caption := MSG_MUT_2012;
  end;
  if TradeLogFile.TaxYear >= 2014 then
  begin
    notesDet2.Caption := 'Brokers are required to adjust gross sales for premiums from option exercises if the option was opened or acquired in 2014. Uncheck this box only if your broker failed to make these adjustments.'+cr+cr
    + 'Note: If you had options opened in 2013 that exercised in 2014 and your broker did NOT adjust proceeds for those, then you may have a reconciliation difference as a result.'+cr+cr;
    pnlPre2014cb.Hide;
  end;
end;

procedure Tfrm1099more.lnk8949CategoryClick(Sender: TObject);
begin
  webURL(SiteURL + 'resources/definitive-guide-schedule-d-form-8949#form-8949-categories')
end;

procedure Tfrm1099more.lnk8949CodeClick(Sender: TObject);
begin
  HtmlHelp(GetDesktopWindow, Pchar(Settings.HelpFileName), HH_HELP_CONTEXT, 348);
end;

procedure Tfrm1099more.lnkTutorialClick(Sender: TObject);
begin
  webURL('https://www.youtube.com/embed/UX9iPvksJz4?rel=0&autoplay=1');
  close;
end;

procedure Tfrm1099more.lnkUG1099Click(Sender: TObject);
begin
  HtmlHelp(GetDesktopWindow, Pchar(Settings.HelpFileName), HH_HELP_CONTEXT, 2150);
  close;
end;

end.
