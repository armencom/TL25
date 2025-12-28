unit globalVariables;

interface

var
  // global flags
  glbAccountEdit : boolean;
  glbBLWizOpen : boolean;

  // do you want sm() debug messages to show?
  DEBUG_MODE: integer = 0;
  // levels of debugging info:
  // 0) None. (Always set to Zero in releases!)
  // 1) Minimal.
  // 2) Detailed.
  // 5) Diagnostics.
  // 9) Maximum.
  gBCImpStep : integer; // for BrokerConnect steps
  gsFilterText : string; // 2020-12-29 MB

  // --------- Session --------------------------
  bFileOpen : boolean; // is a file open?
  gsCustomerToken : string; // BC session ID, from file Email + RegCode
  gsRegCodes : string; // JSON containing all regcodes belonging to UId

  // --------- Software Version -----------------
  gsInstallVer, gsInstallDate, gsVersion, gsRelDate, gsRelDesc, gsBeta : string;
  giMajVer, giMinVer, giRelVer, giBldVer : integer;
  // ----- O/S information -----
  gsOSName, gsOSVer : string;
  gsMACaddr : array[1..5] of string;
  gbParallels : boolean;

  // --------- File vars ------------------------
  dtBegTaxYr, dtEndTaxYr, dtJan31NY, dtOct16NY : TDate; // current file

  // --------- WS Engine switches ---------------
  bWashShortAndLong : boolean = true; // wash long/short, short/long
  bWashUnderlying : boolean = true; // match option if underlying ticker matches
  bWashStock2Opt : boolean = true; // wash stock loss to an option
  bWashOpt2Stock : boolean = true; // wash option loss to a stock
  bWash2ClosedShr : boolean = true; // wash loss to trig which was opened/closed
    // prior to the loss trade date (currently not used but included for future)
  // ---- these are for compatibility/strict interpretations --------
  bWashTypePriority : boolean = true; // prioritize type before date
  bWashClosed1st : boolean = true; // try to find closed trigger 1st
  bAdjustForWS : boolean = true; // 2020-02-26 MB - NEW - adjust GL for WS?

  // --------- Authentication -------------------
  bCancelLogin : boolean; // should TradeLog shut down now?
  v2UserToken, v2UserEmail, v2UserPassword, v2UserId,
  v2UserName, v2Subscription, v2SKU, v2Product : string;
  v2RecLimit : integer; // max number of trades allowed
  v2StartDate, v2EndDate, v2CancelDate, v2CreateDate : TDate;
  s2StartDate, s2EndDate, s2CancelDate, s2CreateDate : string; // read string, then convert
  v2Manager : string;
  // ----- for Pro and Super Users ----
  v2ClientToken, v2ClientEmail, v2CustomerId : string;
  FileCodeToUse: string;
  gsErrorLog, gsErrorText : string;

  // ----- TradeLog Run States --------
  gbOffline, gbFreeTrial, gbExpired : boolean;

  // ----- Login Errors ---------------
  v2LoginPostData : string; // what was sent to login?
  v2LoginStatus : string; // what was returned by login?
  v2LoginPostMsg : string; // message to display if fail
  gbGetSupportNow : boolean;
  gbUpdateNow : boolean;

const
  baselineWizardOn = true;
  NewBCenabled = true; // true for test, false for release (for now)
  TRADELOG_SAMPLE_REGCODE : string = 'FFFF-FFFF-FFFF-FFFF-FFFF'; // for new feature
  TRADELOG_SAMPLE_RecLimit : integer = 400; // 2016-11-25 MB

  // uset to track BC import step
  imBC_beforeLogin    = 1;
  imBC_duringLogin    = 2;
  imBC_afterLogin     = 3;
  imBC_NavigateToData = 4;
  imBC_RequestTheData = 5;
  imBC_DownloadData   = 6;
  imBC_Logout         = 7;
  imBC_FailAbort      = 99;

  // decimal places
  NEARZERO = 0.000000001;
  DECIMALS02 : string = '%1.2f';
  DECIMALS05 : string = '%1.5f';
  DECIMALS06 : string = '%1.6f';
  DECIMALS08 : string = '%1.8f';
  DECIMALS10 : string = '%1.10f';

  DEBUG_EMAIL : string = 'mark@tradelogsoftware.com';

  API_KEYv2 : string = '8?xP*o&zdA&Qa16oU$F9TCk@45$mS*'; // v2 API until <date>
  API_KEY23 : string = '4d*T3S9kdhj#Ah87rQ&*&NJRe5!9#L'; // v2 API after <date>
  API_KEYdev : string = 'de835869ae0fb9413f207482f4b4d47a19810c2c7171f4a0351ca02fc7fc4eec';
  API_KEY25 : string = 'cf6cda8b7a8a0ccf24f3c23334490ce4a3b46b58d1e5523d6c0d35d12e72884d';
// actual API Key used
//  API_KEY : string = '8?xP*o&zdA&Qa16oU$F9TCk@45$mS*'; // live 2.0
  API_KEY : string = '4d*T3S9kdhj#Ah87rQ&*&NJRe5!9#L'; // live 2.5
//  API_KEY : string = '2iMaELcbP1GBK7pQQbKMLFIsdTwZkPkZH7R08q88m2FoiRvm4yNR8VyMp2cEwUpW'; // dev 2.51
//  API_KEY : string = '2iMaELcbP1GBK7pQQbKMLFIsdTwZkPkZH7R08q88m2FoiRvm4yNR8VyMp2cEwUpW'; // live 2.51

  SUPER_KEY : string = '19lu61bvl025k46p7mnsdn46pl639w'; // Super User API Key
  // 'UQ@5v28RyH3jG8505zr!M&o#$x*?#T'; // old Super User API Key had #'s
  UPLOADKEY : string = '3773ff136f9b8dd68ea9aad'; // used by ZenDesk pull file

// each URL will be BASE + Ver + Func
// EX: 'https://brokerconnect.live/api/v2.5/'
// API_v2 : string = 'https://brokerconnect.live/api/v2/'; // live v2
// WHERE BASE can be either
//    https://brokerconnect.live/api/
// OR https://dev.brokerconnect.live/api/
// AND Ver can be either v2 OR v2.5
// AND Func begins with /
  LIVE_BASE : string = 'https://brokerconnect.live/api/'; // live v2.5
  DEV_BASE : string = 'https://dev.brokerconnect.live/api/'; // dev v2.5
// actual base used:
  API_BASE : string = 'https://brokerconnect.live/api/'; // <-- USE THIS
//  API_BASE : string = 'https://dev.brokerconnect.live/api/'; // dev v2.5

  API_VER : string = 'v2.5/';
  BC_VER : string = 'v2.5/';

implementation

end.

