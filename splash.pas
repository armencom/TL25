unit splash;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, dxGDIPlusClasses, ExtCtrls, StdCtrls, cxGraphics,
  cxLookAndFeels, cxLookAndFeelPainters, Menus, cxButtons, cxControls,
  cxContainer, cxEdit, cxProgressBar, cxSplitter, dxSkinsCore, dxSkinBlack,
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
  TpanelSplash = class(TForm)
    pnlFoot: TPanel;
    Line2: TPanel;
    pnlTLVer: TPanel;
    txtACL: TLabel;
    pnlVer: TPanel;
    txtCopyright: TLabel;
    txtEULA: TLabel;
    txtPublBy: TLabel;
    pnlFile: TPanel;
    pnlSupt: TPanel;
    pnlMain: TPanel;
    txtTLVer: TLabel;
    txtRelDate: TLabel;
    lnkGuide: TLabel;
    lnkWatch: TLabel;
    lnkTradeLogCom: TLabel;
    lnkSupport: TLabel;
    imgGuide: TImage;
    imgWatch: TImage;
    imgSupport: TImage;
    imgTradeLogCom: TImage;
    lblGuide: TLabel;
    lblWatch: TLabel;
    lblSupport: TLabel;
    lblTLVer: TLabel;
    lblRelDate: TLabel;
    imgLogo: TImage;
    txtWelcome: TLabel;
    imgFileNew: TImage;
    imgFileOpen: TImage;
    lnkFileNew: TLabel;
    lnkFileOpen: TLabel;
    imgFileRecent: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lnkFile1: TLabel;
    lnkFile2: TLabel;
    lnkFile3: TLabel;
    lnkFile4: TLabel;
    lnkFileRecent: TLabel;
    lnkRenew: TLabel;
    txtExp: TLabel;
    txtExpires: TLabel;
    txtReg: TLabel;
    lblEmail: TLabel;
    txtEmail: TLabel;
    txtRegUser: TLabel;
    lblTradeLogCom: TLabel;
    lnkPrivacy: TLabel;
    lblOffline: TLabel;
    procedure FormShow(Sender: TObject);
    procedure imgFileNewClick(Sender: TObject);
    procedure imgFileOpenClick(Sender: TObject);
    procedure txtEULAClick(Sender: TObject);
    procedure lnkRenewClick(Sender: TObject);
    procedure lnkSupportClick(Sender: TObject);
    procedure txtACLClick(Sender: TObject);
    procedure lnkWatchClick(Sender: TObject);
    procedure lnkTradeLogComClick(Sender: TObject);
    procedure lnkGuideClick(Sender: TObject);
    procedure lnkFile1Click(Sender: TObject);
    procedure lnkFile2Click(Sender: TObject);
    procedure lnkFile3Click(Sender: TObject);
    procedure lnkFile4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure txtEmailClick(Sender: TObject);
    procedure txtRegCodeMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure txtRegCodeMouseLeave(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure lnkPrivacyClick(Sender: TObject);
    procedure pnlFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetupForm;
    procedure DisableControls;
    procedure EnableControls;
  end;


var
  panelSplash: TpanelSplash;

implementation

{$R *.dfm}

uses
  main, funcProc, TLsettings, TLregister, StrUtils, import, trial, clipbrd,
  globalVariables, TLCommonLib, dateUtils;

procedure TpanelSplash.FormCreate(Sender: TObject);
begin
  parent:= frmMain;
  align:= alClient;
end;

procedure TpanelSplash.FormHide(Sender: TObject);
begin
  frmMain.Register1.enabled:= false;
  frmMain.Update1.enabled:= false;
end;

procedure TpanelSplash.FormResize(Sender: TObject);
begin
  //pnlMain.Left := (panelSplash.Width - pnlMain.Width) div 2;
end;

procedure TpanelSplash.FormShow(Sender: TObject);
begin
  SetupForm;
  with frmMain do begin
    pnlTools.Visible := False;
    disableMenuTools;
  end;
  frmMain.caption:= Settings.TLVer +' - '+ Settings.DataDir;
//  panelQS.doQuickStart(1,1);
  frmMain.PopupMenu:= nil;
  frmMain.Register1.enabled:= true;
  frmMain.Update1.enabled:= true;
  txtCopyright.Caption := 'Copyright (C) 1999-'+intToStr(yearOf(now))+' - All Rights Reserved';
end;


procedure TpanelSplash.SetupForm;
var
  relDateStr, instDateStr : string;
  f1, f2, f3, f4, s : string;
  n : double;
begin
  // fill in Settings.TLVer and subscription fields
  txtTLVer.Caption := Settings.TLVer;
  relDateStr := copy(createdate,6,2)+'/'+copy(createDate,9,2)+'/'+leftStr(createDate,4);
  relDateStr := DateToStr(strToDate(relDateStr,Settings.InternalFmt),Settings.UserFmt);
  txtRelDate.Caption := 'ver ' + Ver + ' - ' + relDateStr;
  lblOffline.Visible := gbOffline;
  if ((Settings.AcctName = 'Unregistered') //
   or (Settings.AcctName = '')) //
  and (gbOffline = true) then begin
    txtRegUser.Caption := 'OFFLINE';
  end
  else begin
    txtRegUser.Caption:= Settings.AcctName;
  end;
  // hide special RegCodes, but show normal ones
  s := replacestr(Settings.RegCode,'-','');
  txtEmail.Caption:= Settings.UserEmail;
  if Settings.TrialVersion then begin
    if isDate(Settings.DateInstalled) then
      instDateStr := StrDateAdd(Settings.DateInstalled, 30, Settings.InternalFmt)
    else
      instDateStr := DateToStr(now, Settings.UserFmt);
  end
  else begin
    instDateStr := LongDateStr(Settings.DateExpired); //converts dateExpired to user format
  end; // if
  txtExpires.Caption:= '12:00 AM on ' + DateToStr(v2EndDate); // instDateStr;
  if pos('Trial',Settings.TLVer)>0 then begin
    lnkRenew.Caption:= 'Purchase Now!';
    lnkRenew.hint:='Purchase a TradeLog Subscription Now!';
  end else begin
    lnkRenew.Caption:= 'Manage Your Subscription';
    lnkRenew.hint:='View your Subscription Renewal and Upgrade options';
  end; // if
  // get last 4 files opened
  if Settings.LastOpenFilesList.Count > 0 then
    f1 := '&1  ' + Settings.LastOpenFilesList[0]
  else
    f1 := '';
//  f1:= frmMain.LastFile1.Caption;
    delete(f1,1,3);
    lnkFile1.Hint:=f1;
    f1:=parseLast(f1,'\');
    if length(f1)>50 then f1:='...'+rightStr(f1,47);
  lnkFile1.Caption:=f1;
  if Settings.LastOpenFilesList.Count > 1 then
    f2 := '&1  ' + Settings.LastOpenFilesList[1]
  else
    f2 := '';
//  f2:= frmMain.LastFile2.Caption;
    delete(f2,1,3);
    lnkFile2.Hint:=f2;
    f2:=parseLast(f2,'\');
    if length(f2)>50 then f2:='...'+rightStr(f2,47);
  lnkFile2.Caption:=f2;
  if Settings.LastOpenFilesList.Count > 2 then
    f3 := '&1  ' + Settings.LastOpenFilesList[2]
  else
    f3 := '';
//  f3:= frmMain.LastFile3.Caption;
    delete(f3,1,3);
    lnkFile3.Hint:=f3;
    f3:=parseLast(f3,'\');
    if length(f3)>50 then f3:='...'+rightStr(f3,47);
  lnkFile3.Caption:=f3;
  if Settings.LastOpenFilesList.Count > 3 then
    f4 := '&1  ' + Settings.LastOpenFilesList[3]
  else
    f4 := '';
//  f4:= frmMain.LastFile4.Caption;
    delete(f4,1,3);
    lnkFile4.Hint:=f4;
    f4:=parseLast(f4,'\');
    if length(f4)>50 then f4:='...'+rightStr(f4,47);
  lnkFile4.Caption:=f4;
end;


procedure TpanelSplash.DisableControls;
begin
  pnlMain.Enabled := False;
end;

procedure TpanelSplash.EnableControls;
begin
  pnlMain.Enabled := True;
end;

procedure TpanelSplash.imgFileNewClick(Sender: TObject);
begin
  frmMain.mnuFileNew;
end;

procedure TpanelSplash.imgFileOpenClick(Sender: TObject);
begin
  frmMain.mnuFileOpen; // 2024.06.04 MB - fixed dead link
end;


// --------------------------
// lnksupport
// --------------------------
procedure TpanelSplash.lnkSupportClick(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us');
end;

// --------------------------
// lnkWatch
// --------------------------
procedure TpanelSplash.lnkWatchClick(Sender: TObject);
begin
  webURL('https://www.youtube.com/playlist?list=PLtQuM5EI9Lsw_BPk6LVgq6z5mKC8yXYdf');
end;


procedure TpanelSplash.pnlFileClick(Sender: TObject);
begin
//  sm('panel file click');
end;

// --------------------------
// lnkGuide
// --------------------------
procedure TpanelSplash.lnkGuideClick(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us/categories/115000347454');
end;

procedure TpanelSplash.lnkPrivacyClick(Sender: TObject);
begin
  webURL('https://support.tradelogsoftware.com/hc/en-us/articles/4403915562647');
end;


// --------------------------
// lnkTradeLogCom
// --------------------------
procedure TpanelSplash.lnkTradeLogComClick(Sender: TObject);
begin
  webURL('https://tradelog.com');
end;


// --------------------------
// Recent Files
// --------------------------
procedure TpanelSplash.lnkFile1Click(Sender: TObject);
begin
  frmMain.OpenRecentFile(0);
end;

procedure TpanelSplash.lnkFile2Click(Sender: TObject);
begin
  frmMain.OpenRecentFile(1);
end;

procedure TpanelSplash.lnkFile3Click(Sender: TObject);
begin
  frmMain.OpenRecentFile(2);
end;

procedure TpanelSplash.lnkFile4Click(Sender: TObject);
begin
  frmMain.OpenRecentFile(3);
end;


// --------------------------
procedure TpanelSplash.lnkRenewClick(Sender: TObject);
begin
  webURL('https://tradelog.com/account/');
end;

procedure TpanelSplash.txtACLClick(Sender: TObject);
begin
  webURL('https://tradelog.com/about-us/');
end;

procedure TpanelSplash.txtEULAClick(Sender: TObject);
begin
  AboutTL;
//  frmMain.About1.Click;
end;


procedure TpanelSplash.txtEmailClick(Sender: TObject);
begin
  clipboard.AsText := Settings.UserEmail;
  sm('Email address copied.');
end;

procedure TpanelSplash.txtRegCodeMouseLeave(Sender: TObject);
begin
 txtEmail.Font.style:=[fsBold];
end;

procedure TpanelSplash.txtRegCodeMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  txtEmail.Font.style:=[fsBold,fsUnderline];
end;


end.
