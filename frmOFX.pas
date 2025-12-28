unit frmOFX;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  OleCtrls, SHDocVw, HTTPApp, MSHTML, ExtCtrls, activex, clipbrd,
  funcProc, import, StdCtrls, Variants, StrUtils;

type
  TfrmOFX1 = class(TForm)
    WebBrowser1: TWebBrowser;
    Timer2: TTimer;
    Timer3: TTimer;
    Panel1: TPanel;
    btnClose: TButton;
    txtAccount: TEdit;
    Label1: TLabel;
    txtUsername: TEdit;
    Label2: TLabel;
    txtPassword: TEdit;
    Label4: TLabel;
    btnOK: TButton;
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
//    procedure WebBrowser1DocumentComplete(Sender: TObject;
//      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOFX1: TfrmOFX1;
  FidelityResponse,importingOFX:boolean;
  stkAssignsPriceZero : boolean;

//  function  a_ReadOFX(R:Integer):Integer;
  procedure b_RequestOFX;
  procedure c_GetOFXdata;
  function  e_ParseOFXreply(reply:string):integer;
  function  parseQFX(reply:string):integer;

//  procedure xLoadHtml(browser: TWebBrowser; const html: String);

implementation

uses Main, TLRegister, webGet, 
  TLSettings, TLFile, TLCommonLib;

{$R *.DFM}

var
  startDt,endDt: string;
  ofxDebug:boolean;

procedure TfrmOFX1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  WebBrowser1.stop;
  timer2.enabled:= false;
  timer3.enabled:= false;
  statBar('off');
end;


procedure TfrmOFX1.FormShow(Sender: TObject);
begin
  if not ofxDebug then begin
    width:= 375;
    height:=600;
  end;
  txtAccount.text:= TradeLogFile.CurrentAccount.OFXAccount;
  txtUsername.text:= TradeLogFile.CurrentAccount.OFXUserName;
  txtPassword.text:= TradeLogFile.CurrentAccount.OFXPassword;
end;


procedure c_GetOFXdata;
var
  ofxBroker,ofxURL,userID,userPW,acctID,clientDt,
  xmlReq,xmlReqPage,xmlTRNUID:string;
  ofxHTMLFile:textFile;
begin
  with frmMain do
  if TradeLogFile.CurrentAccount.FileImportFormat = 'Fidelity' then begin
    ofxBroker:= 'fidelity.com';
    ofxURL:= 'https://ofx.fidelity.com/ftgw/OFX/clients/download';
  end
  else if TradeLogFile.CurrentAccount.FileImportFormat = 'Charles Schwab' then begin
    ofxBroker:= 'Schwab.com';
    ofxURL:= 'https://ofx.schwab.com/cgi_dev/ofx_server';
  end;
  {
  FID 5104
  ORG Schwab.com
  Broker Id SCHWAB.COM
  Server URL https://ofx.schwab.com/cgi_dev/ofx_server
  }
  acctID:= TradeLogFile.CurrentAccount.OFXAccount;
  userID:= TradeLogFile.CurrentAccount.OFXUserName;
  userPW:= TradeLogFile.CurrentAccount.OFXPassword;
  xmlTRNUID:= dateTimeToStr(now,Settings.InternalFmt);
  clientDt:= YYYYMMDD_Ex(dateToStr(date,Settings.UserFmt),Settings.UserFmt) + '120000';
  xmlReq:='\n\'+cr
  +'<?OFX OFXHEADER='+''''+'200'+''''+' VERSION='+''''+'200'+''''+' SECURITY='+''''+'NONE'+''''+' OLDFILEUID='+''''+'NONE'+''''+' NEWFILEUID='+''''+'NONE'+''''+'?>\n\'+cr
	+'	<OFX>\n\'+cr
	+'	  <SIGNONMSGSRQV1>\n\'+cr
	+'	    <SONRQ>\n\'+cr
	+'	      <DTCLIENT>'+clientDt+'</DTCLIENT>\n\'+cr
	+'	      <USERID>'+userID+'</USERID>\n\'+cr
	+'	      <USERPASS>'+userPW+'</USERPASS>\n\'+cr
	+'	      <GENUSERKEY>N</GENUSERKEY>\n\'+cr
	+'	      <LANGUAGE>ENG</LANGUAGE>\n\'+cr
	+'	      <FI>\n\'+cr
	+'	        <ORG>'+ofxBroker+'</ORG>\n\'+cr
	+'	        <FID>5104</FID>\n\'+cr
	+'	      </FI>\n\'+cr
	+'	      <APPID>PSOFX</APPID>\n\'+cr
	+'	      <APPVER>0200</APPVER>\n\'+cr
	+'	    </SONRQ>\n\'+cr
	+'	  </SIGNONMSGSRQV1>\n\'+cr
	+'	  <INVSTMTMSGSRQV1>\n\'+cr
	+'	    <INVSTMTTRNRQ>\n\'+cr
	+'	      <TRNUID>050812</TRNUID>\n\'+cr
	+'	      <INVSTMTRQ>\n\'+cr
	+'	        <INVACCTFROM>\n\'+cr
	+'	          <BROKERID>'+uppercase(ofxBroker)+'</BROKERID>\n\'+cr
	+'	          <ACCTID>'+acctID+'</ACCTID>\n\'+cr
	+'	        </INVACCTFROM>\n\'+cr
	+'	  			<INCTRAN>\n\'+cr
	+'		  			<DTSTART>'+startDt+'</DTSTART>\n\'+cr
	+'			  		<DTEND>'+endDt+'</DTEND>\n\'+cr
	+'				  	<INCLUDE>Y</INCLUDE>\n\'+cr
	+'				  </INCTRAN>\n\'+cr
	+'	        <INCOO>N</INCOO>\n\'+cr
	+'	        <INCPOS>\n\'+cr
	+'	          <INCLUDE>N</INCLUDE>\n\'+cr
	+'	        </INCPOS>\n\'+cr
	+'	        <INCBAL>N</INCBAL>\n\'+cr
	+'	      </INVSTMTRQ>\n\'+cr
	+'	    </INVSTMTTRNRQ>\n\'+cr
	+'	  </INVSTMTMSGSRQV1>\n\'+cr
	+'	</OFX>';
  if ofxDebug then begin
    clipBoard.asText:= xmlReq;
    sm(xmlReq);
  end;
  xmlReqPage:= '<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">'+cr
  +'<html lang="en"><head><meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">'+cr
  +'<title>Test OFX Post</title>'+cr
  +'<script type="text/javascript">'+cr
  +'function output (text) {'+cr
    +'var p, layer;'+cr
    +'if (document.createElement && (p = document.createElement("p"))) {'+cr
    +'p.appendChild(document.createTextNode(text));'+cr
    +'document.body.appendChild(p);}'+cr
    +'else if (typeof Layer != "undefined" && (layer = newLayer(window.innerWidth))) {'+cr
    +'layer.top = document.height;'+cr
    +'layer.left = 0;'+cr
    +'layer.document.open();'+cr
    +'layer.document.write("<p>" + text + "<\/p>");'+cr
    +'layer.document.close();'+cr
    +'layer.visibility = "show";'+cr
    +'document.height += layer.clip.height; }'+cr
  +'}'+cr
  +'function postXML (url, xmlDocument) {'+cr
    +'var httpRequest;'+cr
    +'try {'+cr
  	+'var sXml = xmlDocument;'+cr
	  +'var sLength = sXml.length;'+cr
    +'httpRequest = new ActiveXObject("Microsoft.XMLHTTP");'+cr
    +'httpRequest.open("POST", url, false);'+cr
    +'httpRequest.setRequestHeader("Content-Type", "application/x-ofx");'+cr
    +'httpRequest.setRequestHeader("Content-length", sLength);'+cr
    +'httpRequest.send(xmlDocument);'+cr
    +'return httpRequest;'+cr
  +'}'+cr
  +'catch (e) {'+cr
    +'output("Cannot post XML document.");'+cr
    +'return null;'+cr
  +'}'+cr
  +'}'+cr
  +'function testXMLPosting() {'+cr
	  +'var xmlDocument = "'+xmlReq+'";'+cr
    +'if (xmlDocument) {'+cr
    +'var httpRequest = postXML("'+ofxURL+'", xmlDocument);'+cr
    +'if (httpRequest) {'+cr
      +'output("HTTP response status: " + httpRequest.status);'+cr
      +'output("RESPONSE : ");'+cr
      +'output(httpRequest.responseText);'+cr
    +'}'+cr
  +'}'+cr
  +'}'+cr
  +'</script></head>'+cr
  +'<body onLoad="testXMLPosting()">Getting OFX Data</body></html>';
  AssignFile(ofxHTMLFile, Settings.InstallDir + '\ofx.html');
  Rewrite(ofxHTMLFile);
  write(ofxHTMLFile,xmlReqPage);
  closeFile(ofxHTMLFile);
  //load from file
  frmOFX1.WebBrowser1.Navigate(Settings.InstallDir + '\ofx.html');
  //optional load from stream   CAN THIS BE USED??
  //loadHTML(frmOFX1.WebBrowser1,xmlReqPage);
end;

//procedure loadWebfromString(s:string);
//var
//  v: Variant;
//  HTMLDocument: IHTMLDocument2;
//begin
//  HTMLDocument := frmOFX1.WebBrowser1.Document as IHTMLDocument2;
//  v := VarArrayCreate([0, 0], varVariant);
//  v[0] := s;
//  HTMLDocument.Write(PSafeArray(TVarData(v).VArray));
//  HTMLDocument.Close;
//end;

procedure TfrmOFX1.Timer3Timer(Sender: TObject);
begin
  timer2.enabled:= false;
  timer3.enabled:= false;
  modalResult:= -1;
  sm('OFX Server Timed Out!');
end;

//function a_ReadOFX(R:Integer):Integer;
//begin
//  ofxDebug:= false;
//  importingOFX:= true;
//  R:= frmOFX1.showModal;
//  result:= R;
//end;

//function x_CopyFidelityResponse:string;
//var
//  //p:integer;
//  document: IHTMLDocument2;
//  selectionObj: IHTMLSelectionObject;
//  selectionRange: IHtmlTxtRange;
//  reply:string;
//begin
//  frmOFX1.WebBrowser1.ExecWB(OLECMDID_SELECTALL,0);
//  document := frmOFX1.WebBrowser1.Document as IHTMLDocument2;
//  selectionObj := document.selection;
//  selectionRange := selectionObj.CreateRange as IHtmlTxtRange;
//  reply := selectionRange.Text;
//  result:= reply;
//end;


// ------------------------------------
function d_CopyOFXResponse:string;
var
  document: IHTMLDocument2;
  selectionObj: IHTMLSelectionObject;
  selectionRange: IHtmlTxtRange;
  reply:string;
begin
  frmOFX1.WebBrowser1.ExecWB(OLECMDID_SELECTALL,0);
  document := frmOFX1.WebBrowser1.Document as IHTMLDocument2;
  selectionObj := document.selection;
  selectionRange := selectionObj.CreateRange as IHtmlTxtRange;
  reply := selectionRange.Text;
  if pos('</OFX>',reply)>0 then
    result:= reply
  else
    result:='busy';
end;


// ------------------------------------
procedure TfrmOFX1.Timer2Timer(Sender: TObject);
var
  reply:string;
begin
  timer2.enabled:= false;
  reply:= d_copyOFXResponse;
  if reply='busy' then begin
    timer2.enabled:= true;
  end
  else begin
    if ofxDebug then begin
      clipboard.clear;
      clipboard.astext:= reply;
    end;
    timer3.enabled:= false;
    if pos('Cannot post',reply)>0 then begin
      modalResult:= -1;
      sm('ERROR: Cannot Post to OFX Server');
    end
    else if pos('ERROR',reply)>0 then begin
      modalResult:= -1;
      sm('OFX SERVER ERROR: Please try again later'+cr+cr+reply);
    end
    else begin
      modalResult:= e_parseOFXreply(reply);
    end;
  end;
end;


// ------------------------------------
function delXML(xml,s:string):string;
var
  F,T:integer;
begin
  try
    F:= pos('<'+xml+'>',s);
    T:= pos('</'+xml+'>',s)+length(xml)+3;
    delete(s,F,T-F);
    result:= trim(s);
  except
    sm('ERROR: OFX delXML');
  end;
end;


// ------------------------------------
function parseXML(xml,s:string):string;
var
  F,T:integer;
begin
  try
    F:= pos('<'+xml+'>',s)+length(xml)+2;
    T:= pos('</'+xml+'>',s);
    result:= copy(s,F,T-F);
  except
    sm('ERROR: OFX ParseXML');
  end;
end;


// ------------------------------------
function delXML2(xml,s:string):string;
var
  F,T:integer;
begin
  try
    F := pos('<'+xml+'>',s);
    if F = 0 then begin
      result := s;
      exit;
    end
    else
      F:= F+length(xml)+2;
    delete(s,1,F-1);
    T:= pos('<',s);
    delete(s,1,T-1);
    result:= trim(s);
  except
    sm('ERROR: OFX delXML');
  end;
end;


// ------------------------------------
function parseXML2(xml, s:string):string;
var
  F, T: Integer;
begin
  try
    F := pos('<' + xml + '>', s);
    if F = 0 then begin
      result := '';
      exit;
    end
    else
      F := F + length(xml)+ 2;
    delete(s, 1, F - 1);
    T := pos('<', s);
    if T > 1 then begin
      s := copy(s, 1, T - 1);
      // delete cr
      delete(s, pos(cr, s), 1);
      // delete lf
      delete(s, pos(lf, s), 1);
      result := trim(s);
    end
    else
      result := s;
  except
    sm('ERROR: OFX ParseXML');
  end;
end;


// ------------------------------------
function parseQFX(reply:string): Integer;
type
  Psec = ^Tsec;
  Tsec = packed record
    dt: string[14];
    tm: string[6];
    oc: string[20];
    ls: string[20];
    tk: string[50];
    sh: string[20];
    pr: string[20];
    prf: string[20];
    cm: string[20];
    fee: string[20];
    amt: string[20];
    desc: string[50];
    name: string[20];
    id: string[24];
    optk: string[10];
    strike: string[10];
    expMonYr: string[8];
    putCall:string[4];
    FITID: string[20];
    OptAction: string[10];
  end;
var
  i, j, k, R, x: Integer;
  transListStr, trListStr, SecListStr, secStr, s, putCall, expDay, expMon, expYr, strike,
    stkName, multStr, sTemp, sTmp: string;
  Optid: string[24]; // 2017-04-17 MB - for matching assigned stocks
  secList: Tlist;
  sec: Psec;
  noFees, closeOpt: boolean;
  mult: double;
  // --------------------------
  function GetUniqueIDfromFITID(FITID: string): string;
  var
    s1: string;
    i1, i2 : integer;
  begin
    result := ''; // assume not found until found
    i1 := POS('<FITID>'+sec.FITID, transListStr);
    if i1 < 1 then exit;
    //i3 := POS('</CLOSUREOPT>', transListStr, i1);
    while (i2 > 0) do begin
      i2 := 10 + POS('<UNIQUEID>', transListStr, i1);
      if (i2 < 1) then exit;
      i1 := POS(CR, transListStr, i2);
      if (i1 < i2) then exit; // not found
      s1 := copy(transListStr, i2, (i1-i2));
      if length(s1) = length(sec.id) then
        i1 := POS('<FITID>'+sec.FITID, transListStr, i2)
      else begin
        result := s1;
        exit;
      end;
    end;
  end;
  // --------------------------
begin
  statBar('Importing from QFX file - PLEASE WAIT');
  // add carriage returns after each xml statement
  while (pos('><', reply)> 0) do begin
    insert(cr, reply, pos('><', reply) + 1);
  end;
  s := reply;
  saveImportAsFile(s, '', '', Settings.UserFmt);
  if (pos('<SEVERITY>ERROR</SEVERITY>', reply) > 0) then begin
    statBar('off');
    if (pos('Signon Invalid', reply)> 0) or (pos('USERPASS lockout', reply)> 0) then
        sm('User Name or Password not valid');
    result :=-1;
    exit;
  end;
  R := 0;
  noFees := false;
  secList := Tlist.create;
  secList.clear;
  closeOpt := false;
  // get Security List
  try
    SecListStr := parseXML('SECLIST', reply);
    while pos('SECINFO', SecListStr)> 0 do begin
      // secStr:= parseXML('SECINFO',secListStr); sm(secStr);
      secStr := parseHTML(SecListStr, '<SECID>', '<SECINFO>');
      if secStr = '' then secStr := SecListStr;
      sTEMP := secStr;
      SecListStr := delXML('SECINFO', SecListStr);
      // sm('secStr: '+secStr);
      new(sec);
      FillChar(sec^, SizeOf(sec^), 0);
      sec.id := parseXML2('UNIQUEID', secStr);
      // <SECNAME>QCOM Dec 22 2012 62.50 Call
      sec.desc := parseXML2('SECNAME', secStr);
      // messed up ticker = QCOM DEC 22 2012 62. DEC12 62.5 CALL
      // <TICKER>SKX   130316C00020000
      sec.tk := parseXML2('TICKER', secStr);
      sec.name := trim(leftStr(sec.tk, 6));
      if sec.name = '' then sec.name := parseXML2('MEMO', secStr);
      if pos('<STRIKEPRICE>', secStr)> 0 then begin
        sec.strike := parseXML2('STRIKEPRICE', secStr);
        sec.strike := delTrailingZeros(sec.strike);
        sec.expMonYr := parseXML2('DTEXPIRE', secStr);
        sec.putCall := parseXML2('OPTTYPE', secStr);
      end
      else begin
        sec.strike := '';
        sec.expMonYr := '';
      end;
      secList.add(sec);
      sec := nil;
      dispose(sec);
    end; // while
  except
    sm('ERROR: OFX Parse Security List');
  end;
  // --------------
  // get trades
  transListStr := parseXML('INVTRANLIST', reply);
  delete(transListStr, 1, pos('<DTEND>', transListStr) + 6);
  delete(transListStr, 1, pos('<', transListStr) - 1);
  transListStr := trim(transListStr);
  // --------------
  // loop thru transListStr
  while (pos('<BUYSTOCK', transListStr)= 1) or (pos('<SELLSTOCK', transListStr)= 1)
  or (pos('<BUYOPT', transListStr)= 1) or (pos('<SELLOPT', transListStr)= 1)
  or (pos('<BUYMF', transListStr)= 1) or (pos('<SELLMF', transListStr)= 1)
  or (pos('<CLOSUREOPT', transListStr)= 1) or (pos('<BUYDEBT', transListStr)= 1)
  or (pos('<SELLDEBT', transListStr)= 1) or (pos('<INCOME', transListStr)= 1)
  or (pos('<REINVEST', transListStr)= 1) or (pos('<SPLIT', transListStr)= 1)
  or (pos('<BUYOTHER', transListStr)= 1) or (pos('<SELLOTHER', transListStr)= 1)
  or (pos('<INVEXPENSE', transListStr)= 1) or (pos('<TRANSFER', transListStr)= 1)
  or (pos('<JRNLFUND', transListStr)= 1) or (pos('<JRNLSEC', transListStr)= 1)
  or (pos('<MARGININTEREST', transListStr)= 1) or (pos('<RETOFCAP', transListStr)= 1)
  do begin
    if (pos('<BUYSTOCK', transListStr)= 1) then begin
      trListStr := parseXML('BUYSTOCK', transListStr);
    end
    else if (pos('<SELLSTOCK', transListStr)= 1) then begin
      trListStr := parseXML('SELLSTOCK', transListStr);
    end
    else if (pos('<BUYOPT', transListStr)= 1) then begin
      trListStr := parseXML('BUYOPT', transListStr);
    end
    else if (pos('<SELLOPT', transListStr)= 1) then begin
      trListStr := parseXML('SELLOPT', transListStr);
    end
    else if (pos('<BUYMF', transListStr)= 1) then begin
      trListStr := parseXML('BUYMF', transListStr);
    end
    else if (pos('<SELLMF', transListStr)= 1) then begin
      trListStr := parseXML('SELLMF', transListStr);
    end
    else if (pos('<CLOSUREOPT', transListStr)= 1) then begin
      trListStr := parseXML('CLOSUREOPT', transListStr);
    end
    // ------ do not import these ------
    else if (pos('<INCOME', transListStr)= 1) then begin
      transListStr := delXML('INCOME', transListStr);
      continue;
    end
    else if (pos('<REINVEST', transListStr)= 1) then begin
      transListStr := delXML('REINVEST', transListStr);
      continue;
    end
    else if (pos('<SPLIT', transListStr)= 1) then begin
      transListStr := delXML('SPLIT', transListStr);
      continue;
    end
    else if (pos('<BUYDEBT', transListStr)= 1) then begin
      transListStr := delXML('BUYDEBT', transListStr);
      continue;
    end
    else if (pos('<SELLDEBT', transListStr)= 1) then begin
      transListStr := delXML('SELLDEBT', transListStr);
      continue;
    end
    else if (pos('<BUYOTHER', transListStr)= 1) then begin
      transListStr := delXML('BUYOTHER', transListStr);
      continue;
    end
    else if (pos('<SELLOTHER', transListStr)= 1) then begin
      transListStr := delXML('SELLOTHER', transListStr);
      continue;
    end
    else if (pos('<INVEXPENSE', transListStr)= 1) then begin
      transListStr := delXML('INVEXPENSE', transListStr);
      continue;
    end
    else if (pos('<TRANSFER', transListStr)= 1) then begin
      transListStr := delXML('TRANSFER', transListStr);
      continue;
    end
    else if (pos('<JRNLFUND', transListStr)= 1) then begin
      transListStr := delXML('JRNLFUND', transListStr);
      continue;
    end
    else if (pos('<JRNLSEC', transListStr)= 1) then begin
      transListStr := delXML('JRNLSEC', transListStr);
      continue;
    end
    else if (pos('<MARGININTEREST', transListStr)= 1) then begin
      transListStr := delXML('MARGININTEREST', transListStr);
      continue;
    end
    else if (pos('<RETOFCAP', transListStr)= 1) then begin
      transListStr := delXML('RETOFCAP', transListStr);
      continue;
    end;
    // --------------------------------
    while pos('DTTRADE', trListStr)> 0 do begin
      // sm(intToStr(R)+' 1 '+trListStr);
      new(sec);
      FillChar(sec^, SizeOf(sec^), 0);
      sec.optk := '';
      sec.dt := parseXML2('DTTRADE', trListStr);
      sec.tm := rightStr(sec.dt, 6);
      sec.dt := leftStr(sec.dt, 8);
      // sm(sec.dt+'  '+sec.tm);
      // 2017-04-17 MB - Added FITID for Ex/Assign
      sec.FITID := parseXML2('FITID', trListStr);
      sec.FITID := LeftStr(sec.FITID, 17);
      //
      sec.id := parseXML2('UNIQUEID', trListStr);
      sec.sh := parseXML2('UNITS', trListStr);
      multStr := parseXML2('SHPERCTRCT', trListStr);
      sec.pr := parseXML2('UNITPRICE', trListStr);
      if sec.pr = '' then sec.pr := '0';
      sec.cm := parseXML2('COMMISSION', trListStr);
      if sec.cm = '' then sec.cm := '0.00';
      sec.fee := parseXML2('FEES', trListStr);
      if sec.fee = '' then sec.fee := '0.00';
      sec.amt := parseXML2('TOTAL', trListStr);
      // 2017-04-17 MB
      sec.OptAction := parseXML2('OPTACTION', trListStr);
      trListStr := delXML2('DTTRADE', trListStr);
      trListStr := delXML2('UNIQUEID', trListStr);
      trListStr := delXML2('UNIQUEIDTYPE', trListStr);
      if (not closeOpt) then begin
        trListStr := delXML2('UNITS', trListStr);
        trListStr := delXML2('UNITPRICE', trListStr);
        trListStr := delXML2('COMMISSION', trListStr);
        trListStr := delXML2('FEES', trListStr);
        trListStr := delXML2('AMOUNT', trListStr);
        // get open/close long/short
        delete(trListStr, 1, pos('TYPE>', trListStr)+ 4);
      end // if not closeOpt
      else
        delete(trListStr, 1, pos('OPTACTION>', trListStr)+ 9);
      try
        if (pos('ASSIGN', trListStr)= 1) then begin
          if leftStr(sec.sh, 1) = '-' then begin
            sec.oc := 'C';
            sec.ls := 'L';
          end
          else begin
            sec.oc := 'C';
            sec.ls := 'S';
          end;
        end
        else if (pos('BUY', trListStr)= 1) or (pos('BUYTOOPEN', trListStr)= 1) then begin
          sec.oc := 'O';
          sec.ls := 'L';
        end
        else if (pos('SELL', trListStr)= 1) or (pos('SELLTOCLOSE', trListStr)= 1) or
          (pos('ASSIGN', trListStr)= 1) then begin
          sec.oc := 'C';
          sec.ls := 'L';
        end
        else if (pos('BUYTOCOVER', trListStr)= 1) or (pos('BUYTOCLOSE', trListStr)= 1)
        then begin
          sec.oc := 'C';
          sec.ls := 'S';
        end
        else if (pos('SELLSHORT', trListStr)= 1) or (pos('SELLTOOPEN', trListStr)= 1) then
        begin
          sec.oc := 'O';
          sec.ls := 'S';
        end;
      except
        sm('ERROR: OFX get Open/Close');
      end;
      // ----------------------------------------
      if (pos('BUYTOOPEN', trListStr)= 1) or (pos('SELLTOCLOSE', trListStr)= 1) or
        (pos('SELLTOOPEN', trListStr)= 1) or (pos('BUYTOCLOSE', trListStr)= 1) then begin
        // 2014-04-04 needed for mini options (but how do we know it's an option?)
        if isInt(multStr) then
          sec.prf := 'OPT-' + multStr
        else
          sec.prf := 'OPT-100';
      end
      else begin
        sec.prf := 'STK-1';
      end;
      // ----------------------------------------
      // added for TradeKing stock assigns - price is zero!
      if (pos('<CLOSUREOPT', transListStr)= 1)
      and (pos('<OPTACTION>ASSIGN', transListStr)> 0)
      and (length(sec.id) < 12) then begin
        if (pos('-', sec.sh) = 1) then begin
          sec.oc := 'O';
          sec.ls := 'S';
        end
        else begin
          sec.oc := 'O';
          sec.ls := 'L';
        end;
        sec.prf := 'STK-1';
        //stkAssignsPriceZero := true; // moved
      end;
      // ----------------------------------------
      delete(trListStr, 1, pos('TYPE>', trListStr)+ 5);
      delete(trListStr, 1, pos('FITID>', trListStr)+ 5);
      // ----------------------------------------
      // match cusip to ticker;
      try
        for j := 0 to secList.count - 1 do begin
          if (sec.id = Psec(secList[j])^.id) then begin
            if pos('OPT', sec.prf)= 1 then begin // options
              sec.optk := Psec(secList[j])^.tk;
              s := Psec(secList[j])^.desc;
              putCall := Psec(secList[j])^.putCall;
              // delete C/P
              delete(s, 1, pos(' ', s));
              s := trim(s);
              // delete tick
              delete(s, 1, pos(' ', s));
              s := trim(s);
              // get stock name
              if (sec.id = Psec(secList[j])^.tk) then
                stkName := s
              else
                stkName := Psec(secList[j])^.name;
              // get expDay
              expDay := copy(Psec(secList[j])^.expMonYr, 7, 2);
              // get expMon
              expMon := copy(Psec(secList[j])^.expMonYr, 5, 2);
              expMon := getExpMo(expMon);
              // get expYr
              expYr := copy(Psec(secList[j])^.expMonYr, 3, 2);
              // get strike
              strike := Psec(secList[j])^.strike;
              // get rid of extra zeros
              delete(strike, pos('.000', strike), 4);
              delete(strike, pos('.00', strike), 3);
              delete(strike, pos('.0', strike), 2);
              sec.tk := stkName + ' ' + expDay + expMon + expYr + ' ' + strike + ' ' + putCall;
            end
            else begin // stocks
              if sec.id = Psec(secList[j])^.tk then begin
                stkName := Psec(secList[j])^.desc; // get stock name
                sec.tk := stkName;
              end
              else
                sec.tk := Psec(secList[j])^.tk;
              // end if
              sec.optk := '';
              // was it a zero price assign?
              if (sec.pr = '0') and (sec.OptAction = 'ASSIGN') then begin
                // 1. get the FITID
                sTemp := sec.FITID;
                // 2. use that to get the UNIQUEID
                Optid := GetUniqueIDfromFITID(sTemp);
                // 3. lookup the Strike Price
                for i := 0 to secList.count - 1 do begin // look for matching Option
                  if Optid = Psec(secList[i])^.ID then begin // search for option with same FITID
                    sec.pr := Psec(secList[i])^.strike;
                    break;
                  end; // if option found
                end; // for j
                if (sec.pr = '0') then stkAssignsPriceZero := true; // truly zero price
              end; // if zero price
            end; // if opt or stk
            break; // found id match so exit loop
          end; // if id match
        end; // for id in sec.id loop
      except
        sm('ERROR: OFX matching cusip to symbol');
      end;
      // sm(sec.dt + ' ' + sec.oc + sec.ls + ' ' + sec.tk + ' ' + sec.sh + ' ' + sec.pr + ' ' + sec.fee);
      try
        if (sec.oc <> '') and (sec.ls <> '') then begin
          inc(R);
          setLength(impTrades, R + 1);
          with impTrades[R] do begin
            abc := '   '; // 2022-01-27 MB
            tr := 0;
            dt := MMDDYYYY(sec.dt);
            tm := copy(sec.tm, 1, 2)+ ':' + copy(sec.tm, 3, 2)+ ':' + copy(sec.tm, 5, 2);
            oc := sec.oc;
            ls := sec.ls;
            tk := sec.tk;
            // Shares
            sh := strToFloat(sec.sh, Settings.InternalFmt);
            if sh < 0 then sh := -sh;
            // Price
            pr := strToFloat(sec.pr, Settings.InternalFmt);
            if pr < 0 then pr := -pr;
            // Type+Mult
            prf := sec.prf;
            if pos('OPT', prf)= 1 then mult := 100 else mult := 1;
            // Amount
            if sec.amt = '' then sec.amt := '0.00';
            am := strToFloat(sec.amt, Settings.InternalFmt);
            if am < 0 then am := -am;
            // Commission
            if ((oc = 'C') and (ls = 'L'))
            or ((oc = 'O') and (ls = 'S'))
            and (am > 0) then // trade is a sale
              cm := (sh * pr * mult) - am
            else                                // trade is a buy
              cm := strToFloat(sec.cm, Settings.UserFmt) + strToFloat(sec.fee, Settings.UserFmt);
            if cm < 0 then cm := -cm;
            // Option Ticker
            optk := sec.optk;
            am := 0;
            no := '';
            m := '';
          end; // with
        end; // if OC / LS
      except
        sm('ERROR: adding trades to impTrades array' + cr + sec.dt + '  ' + sec.tk
          + '  ' + sec.sh + '  ' + sec.pr + '  ' + sec.cm + '  ' + sec.fee + '  ' + sec.amt);
      end;
      //
      try
        sec := nil;
        dispose(sec);
      except sm('ERROR: disposing sec');
      end;
      statBar('Importing records: ' + intToStr(R));
    end; // while trListStr
    // ------------------------
    if (pos('<BUYSTOCK', transListStr)= 1) then begin
      transListStr := delXML('BUYSTOCK', transListStr);
    end
    else if (pos('<SELLSTOCK', transListStr)= 1) then begin
      transListStr := delXML('SELLSTOCK', transListStr);
    end
    else if (pos('<BUYOPT', transListStr)= 1) then begin
      transListStr := delXML('BUYOPT', transListStr);
    end
    else if (pos('<SELLOPT', transListStr)= 1) then begin
      transListStr := delXML('SELLOPT', transListStr);
    end
    else if (pos('<BUYMF', transListStr)= 1) then begin
      transListStr := delXML('BUYMF', transListStr);
    end
    else if (pos('<SELLMF', transListStr)= 1) then begin
      transListStr := delXML('SELLMF', transListStr);
    end
    else if (pos('<CLOSUREOPT', transListStr)= 1) then begin
      transListStr := delXML('CLOSUREOPT', transListStr);
    end;
    transListStr := trim(transListStr);
  end; // while transListStr
  // ------------------------
  if secList <> nil then begin
    secList.clear;
    secList.Free;
  end;
  if R = 0 then begin
    result :=-1;
    exit;
  end;
  // remove trades with no price
  if YYYYMMDD_Ex(impTrades[1].dt, Settings.InternalFmt) >= YYYYMMDD_Ex(impTrades[R].dt, Settings.InternalFmt)
  then
    ReverseImpTradesDate(R);
  result := R;
end;


// ------------------------------------
function e_ParseOFXreply(reply:string): Integer;
type
  Psec = ^Tsec;
  Tsec = packed record
    dt: string[14];
    tm: string[6];
    oc: string[20];
    ls: string[20];
    tk: string[40];
    sh: string[20];
    pr: string[20];
    prf: string[20];
    cm: string[20];
    fee: string[20];
    desc: string[50];
    id: string[10];
  end;
var
  j, R: Integer;
  transListStr, trListStr, SecListStr, secStr, s:string;
  secList: Tlist;
  sec: Psec;
  bStkAssign: boolean;
begin
  statBar('Importing from OFX file - PLEASE WAIT');
  // add carriage returns after each xml statement
  while (pos('><', reply)> 0) do begin
    insert(cr, reply, pos('><', reply)+ 1);
  end;
  s := reply;
  saveImportAsFile(s, '', '', Settings.InternalFmt);
  if (pos('<SEVERITY>ERROR</SEVERITY>', reply)> 0) then begin
    statBar('off');
    if (pos('Signon Invalid', reply)> 0)
    or (pos('USERPASS lockout', reply)> 0) then
      sm('User Name or Password not valid');
    result :=-1;
    exit;
  end;
  R := 0;
  secList := Tlist.create;
  secList.clear;
  // get Security List
  try
    SecListStr := parseXML('SECLIST', reply);
    while pos('SECINFO', SecListStr)> 0 do begin
      // if not frmOFX1.Visible then break;
      secStr := parseXML('SECINFO', SecListStr);
      SecListStr := delXML('SECINFO', SecListStr);
      // sm('secStr: '+secStr);
      new(sec);
      FillChar(sec^, SizeOf(sec^), 0);
      sec.id := parseXML('UNIQUEID', secStr);
      sec.desc := parseXML('SECNAME', secStr);
      sec.tk := parseXML('TICKER', secStr);
      secList.add(sec);
      sec := nil;
      dispose(sec);
    end;
  except sm('ERROR: OFX Parse Security List');
  end;
  // get trades
  transListStr := parseXML('INVTRANLIST', reply);
  delete(transListStr, 1, pos('</DTEND>', transListStr)+ 7);
  transListStr := trim(transListStr);
  // ------------------------------------------------------
  // 2019-01-29 MB - stop requiring transaction type to be
  // the very first field (POS = 1) in a given trade. BEGIN
  // ------------------------------------------------------
  while (pos('<BUYSTOCK', transListStr) > 0) or (pos('<SELLSTOCK', transListStr) > 0) //
  or (pos('<BUYOPT', transListStr) > 0) or (pos('<SELLOPT', transListStr) > 0) //
  or (pos('<BUYMF', transListStr) > 0) or (pos('<SELLMF', transListStr) > 0) //
  or (pos('<BUYDEBT', transListStr) > 0) or (pos('<SELLDEBT', transListStr) > 0) //
  or (pos('<INCOME', transListStr) > 0) or (pos('<REINVEST', transListStr) > 0) //
  or (pos('<SPLIT', transListStr) > 0) or (pos('<CLOSUREOPT', transListStr) > 0) //
  or (pos('<BUYOTHER', transListStr) > 0) or (pos('<SELLOTHER', transListStr) > 0) //
  or (pos('<INVEXPENSE', transListStr) > 0) or (pos('<TRANSFER', transListStr) > 0) //
  or (pos('<JRNLFUND', transListStr) > 0) or (pos('<JRNLSEC', transListStr) > 0) //
  or (pos('<MARGININTEREST', transListStr) > 0) or (pos('<RETOFCAP', transListStr) > 0) //
  do begin
    bStkAssign := false;
    // if not frmOFX1.Visible then break;
    if (pos('<BUYSTOCK', transListStr) > 0) then begin
      trListStr := parseXML('BUYSTOCK', transListStr);
    end
    else if (pos('<SELLSTOCK', transListStr) > 0) then begin
      trListStr := parseXML('SELLSTOCK', transListStr);
    end
    else if (pos('<BUYOPT', transListStr) > 0) then begin
      trListStr := parseXML('BUYOPT', transListStr);
    end
    else if (pos('<SELLOPT', transListStr) > 0) then begin
      trListStr := parseXML('SELLOPT', transListStr);
    end
    else if (pos('<BUYMF', transListStr) > 0) then begin
      trListStr := parseXML('BUYMF', transListStr);
    end
    else if (pos('<SELLMF', transListStr) > 0) then begin
      trListStr := parseXML('SELLMF', transListStr);
    end
    // do not import these
    else if (pos('<INCOME', transListStr) > 0) then begin
      transListStr := delXML('INCOME', transListStr);
      continue;
    end
    else if (pos('<REINVEST', transListStr) > 0) then begin
      transListStr := delXML('REINVEST', transListStr);
      continue;
    end
    else if (pos('<SPLIT', transListStr) > 0) then begin
      transListStr := delXML('SPLIT', transListStr);
      continue;
    end
    else if (pos('<BUYDEBT', transListStr) > 0) then begin
      transListStr := delXML('BUYDEBT', transListStr);
      continue;
    end
    else if (pos('<SELLDEBT', transListStr) > 0) then begin
      transListStr := delXML('SELLDEBT', transListStr);
      continue;
    end
    else if (pos('<CLOSUREOPT', transListStr) > 0) then begin
      transListStr := delXML('CLOSUREOPT', transListStr);
      continue;
    end
    else if (pos('<BUYOTHER', transListStr) > 0) then begin
      transListStr := delXML('BUYOTHER', transListStr);
      continue;
    end
    else if (pos('<SELLOTHER', transListStr) > 0) then begin
      transListStr := delXML('SELLOTHER', transListStr);
      continue;
    end
    else if (pos('<INVEXPENSE', transListStr) > 0) then begin
      transListStr := delXML('INVEXPENSE', transListStr);
      continue;
    end
    else if (pos('<TRANSFER', transListStr) > 0) then begin
      transListStr := delXML('TRANSFER', transListStr);
      continue;
    end
    else if (pos('<JRNLFUND', transListStr) > 0) then begin
      transListStr := delXML('JRNLFUND', transListStr);
      continue;
    end
    else if (pos('<JRNLSEC', transListStr) > 0) then begin
      transListStr := delXML('JRNLSEC', transListStr);
      continue;
    end
    else if (pos('<MARGININTEREST', transListStr) > 0) then begin
      transListStr := delXML('MARGININTEREST', transListStr);
      continue;
    end
    else if (pos('<RETOFCAP', transListStr) > 0) then begin
      transListStr := delXML('RETOFCAP', transListStr);
      continue;
    end;
    // ------------------------------------------
    while pos('DTTRADE', trListStr) > 0 do begin
      // if not frmOFX1.Visible then break;
      new(sec);
      FillChar(sec^, SizeOf(sec^), 0);
      sec.dt := parseXML2('DTTRADE', trListStr);
      sec.tm := rightStr(sec.dt, 6);
      sec.dt := leftStr(sec.dt, 8);
      // sm(sec.dt+'  '+sec.tm);
      sec.id := parseXML('UNIQUEID', trListStr);
      sec.sh := parseXML('UNITS', trListStr);
      sec.pr := parseXML('UNITPRICE', trListStr);
      sec.cm := parseXML('COMMISSION', trListStr);
      sec.fee := parseXML('FEES', trListStr);
      trListStr := delXML('DTTRADE', trListStr);
      trListStr := delXML('UNIQUEID', trListStr);
      trListStr := delXML('UNIQUEIDTYPE', trListStr);
      trListStr := delXML('UNITS', trListStr);
      trListStr := delXML('UNITPRICE', trListStr);
      trListStr := delXML('COMMISSION', trListStr);
      trListStr := delXML('FEES', trListStr);
      // ----------------------------------------
      // get open/close long/short
      delete(trListStr, 1, pos('TYPE>', trListStr)+ 4);
      try
        if (pos('BUY', trListStr) > 0) or (pos('BUYTOOPEN', trListStr) > 0) then begin
          sec.oc := 'O';
          sec.ls := 'L';
        end
        else if (pos('SELL', trListStr) > 0) or (pos('SELLTOCLOSE', trListStr) > 0) then
        begin
          sec.oc := 'C';
          sec.ls := 'L';
        end
        else if (pos('BUYTOCOVER', trListStr) > 0) or (pos('BUYTOCLOSE', trListStr) > 0)
        then begin
          sec.oc := 'C';
          sec.ls := 'S';
        end
        else if (pos('SELLSHORT', trListStr) > 0) or (pos('SELLTOOPEN', trListStr) > 0) then
        begin
          sec.oc := 'O';
          sec.ls := 'S';
        end
        else if (pos('ASSIGN', trListStr) > 0) then begin
          bStkAssign := false;
          sec.oc := 'O';
          sec.ls := 'L';
        end;
        // --------------------------------
        if (pos('BUYTOOPEN', trListStr) > 0)
        or (pos('SELLTOCLOSE', trListStr) > 0)
        or (pos('SELLTOOPEN', trListStr) > 0)
        or (pos('BUYTOCLOSE', trListStr) > 0) then
          sec.prf := 'OPT-100'
        else
          sec.prf := 'STK-1';
      except
        sm('ERROR: OFX get Open/Close');
      end;
      // ----------------------------------------
      delete(trListStr, 1, pos('TYPE>', trListStr)+ 5);
      delete(trListStr, 1, pos('/FITID>', trListStr)+ 6);
      // ----------------------------------------
      // match cusip to ticker;
      try
        for j := 0 to secList.count - 1 do begin
          if (sec.id = Psec(secList[j])^.id) then begin
            sec.tk := Psec(secList[j])^.tk;
            break;
          end;
        end;
      except sm('ERROR: OFX matching cusip to symbol');
      end;
      // ----------------------------------------
      try
        inc(R);
        setLength(impTrades, R + 1);
        with impTrades[R] do begin
          tr := 0;
          dt := MMDDYYYY(sec.dt);
          tm := '';
          oc := sec.oc;
          ls := sec.ls;
          tk := sec.tk;
          sh := strToFloat(sec.sh, Settings.UserFmt);
          if (sh < 0) then begin
            if bStkAssign then begin
              oc := 'C';
              ls := 'S';
            end;
            sh := -sh;
          end;
          pr := strToFloat(sec.pr, Settings.UserFmt);
          if pr < 0 then pr := -pr;
          prf := sec.prf;
          if (sec.cm = '') then // 2020-09-23 MB - added for Wealthfront QFX
            cm := 0
          else
            cm := strToFloat(sec.cm, Settings.UserFmt) +
              strToFloat(sec.fee, Settings.UserFmt);
          if cm < 0 then cm := -cm;
          am := 0;
          no := '';
          m := '';
        end;
      except
        sm('ERROR: adding trades to impTrades array');
      end;
      // ----------------------------------------
      try
        sec := nil;
        dispose(sec);
      except sm('ERROR: disposing sec');
      end;
    end; // while trListStr
    // ----------------------------------------------------
    if (pos('<BUYSTOCK', transListStr) > 0) then begin
      transListStr := delXML('BUYSTOCK', transListStr);
    end
    else if (pos('<SELLSTOCK', transListStr) > 0) then begin
      transListStr := delXML('SELLSTOCK', transListStr);
    end
    else if (pos('<BUYOPT', transListStr) > 0) then begin
      transListStr := delXML('BUYOPT', transListStr);
    end
    else if (pos('<SELLOPT', transListStr) > 0) then begin
      transListStr := delXML('SELLOPT', transListStr);
    end
    else if (pos('<BUYMF', transListStr) > 0) then begin
      transListStr := delXML('BUYMF', transListStr);
    end
    else if (pos('<SELLMF', transListStr) > 0) then begin
      transListStr := delXML('SELLMF', transListStr);
    end;
    transListStr := trim(transListStr);
  end; // while transListStr
  // ------------------------------------------------------
  // 2019-01-29 MB - END BLOCK of changes
  // ------------------------------------------------------
  if secList <> nil then begin
    secList.clear;
    secList.Free;
  end;
  if R = 0 then begin
    result :=-1;
    exit;
  end;
  if YYYYMMDD_Ex(impTrades[1].dt, Settings.UserFmt) >= YYYYMMDD_Ex(impTrades[R].dt,
    Settings.UserFmt) then ReverseImpTradesDate(R);
  result := R;
end;


// ------------------------------------
procedure TfrmOFX1.btnCloseClick(Sender: TObject);
begin
  frmOFX1.webbrowser1.stop;
  frmOFX1.modalResult:= -1;
  repaintGrid;
end;


procedure TfrmOFX1.btnOKClick(Sender: TObject);
begin
  b_RequestOFX;
  repaintGrid;
end;


procedure b_RequestOFX;
var
  i:integer;
  lastDt:TDate;
  line:string;
  txtFile: textFile;
begin
  with frmOFX1 do begin
    if (txtAccount.text='')
    or (txtUsername.text='')
    or (txtPassword.text='') then begin
      sm('Please enter data');
      exit;
    end;
    if not ofxDebug then Hide;
  end;
  //save OFX settings to file
  TradeLogFile.SetOFXCredentials(1, frmOFX1.txtAccount.text, frmOFX1.txtUserName.Text, frmOFX1.txtPassword.Text);
  TradelogFile.SaveFile(true);
  SaveTradesBack('OFX import');
  lastDt:= TradeLogFile.LastDateImported;
  //check for 90 day brokers
  if (TradeLogFile.CurrentAccount.FileImportFormat='Fidelity') then
  if lastDt+90<date then
    startDt:= YYYYMMDD_Ex(dateToStr(date-90,Settings.UserFmt),Settings.UserFmt)
  else
    startDt:= YYYYMMDD_Ex(dateToStr(lastDt+1,Settings.UserFmt),Settings.UserFmt);

  if (startDt < TaxYear+'0101') then startDt := TaxYear+'0101';
  if (startDt>nextTaxYear+'0131') then begin
    sm('Data cannot be imported past '+'01/31/'+nexttaxyear+cr+cr
    +'for this tax year data file');
    frmOFX1.modalResult:= -1;
  end;
  endDt:= YYYYMMDD_Ex(dateToStr(date-1,Settings.UserFmt),Settings.UserFmt);
  if (endDt>nextTaxYear+'0131') then endDt:= nextTaxYear+'0131';
  statBar('Getting OFX data from: '+MMDDYYYY(startDt)+' to: '
   +MMDDYYYY(endDt)+' - Hit the ESC key to Cancel');
  //start processing
  c_GetOFXdata;
  //
  frmOFX1.timer2.enabled:=true;
  frmOFX1.timer3.enabled:=true;
end;


//procedure TfrmOFX1.WebBrowser1DocumentComplete(Sender: TObject;
//  const pDisp: IDispatch; var URL: OleVariant);
//begin
//  if FidelityResponse then exit;
//  if frmOFX1.WebBrowser1.LocationURL<>'https://webxpress.fidelity.com/ftgw/webxpress/account_history_brokerage/c?ACCOUNT=133412643' then begin
//    frmOFX1.WebBrowser1.Navigate('https://webxpress.fidelity.com/ftgw/webxpress/account_history_brokerage/c?ACCOUNT=133412643');
//  end
//  else begin
//    FidelityResponse:= true;
//  end;
//end;


//procedure xLoadHtml(browser: TWebBrowser; const html: String);
//var
//  memStream: TMemoryStream;
//begin
//  //-------------------
//  // Load a blank page.
//  //-------------------
//  browser.Navigate('about:blank');
//  while browser.ReadyState <> READYSTATE_COMPLETE do
//  begin
//    Sleep(5);
//    Application.ProcessMessages;
//  end;
//  //---------------
//  // Load the html.
//  //---------------
//  memStream := TMemoryStream.Create;
//  memStream.Write(Pointer(html)^,Length(html));
//  memStream.Seek(0,0);
//  (browser.Document as IPersistStreamInit).Load(
//    TStreamAdapter.Create(memStream));
//  memStream.Free;
//end;


procedure TfrmOFX1.FormActivate(Sender: TObject);
begin
  frmMain.repaint;
  Position := poMainFormCenter;
end;


end.
