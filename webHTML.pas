unit webHTML;

interface

uses

  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  funcProc, Dialogs, OleCtrls, SHDocVw, ExtCtrls, StdCtrls;

type
  TfrmWebHTML = class(TForm)
    webBrowser1: TWebBrowser;
    timerWebHTML: TTimer;
    btnCancel: TButton;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure webBrowser1NavigateComplete2(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure webBrowser1DocumentComplete(ASender: TObject;
      const pDisp: IDispatch; var URL: OleVariant);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure timerWebHTMLTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure webBrowser1BeforeNavigate2(ASender: TObject;
      const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
      Headers: OleVariant; var Cancel: WordBool);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWebHTML: TfrmWebHTML;
  replyHTML:string;
  frmWebHTMLclosing:boolean;

function getWebHTML(url:string;timeout:integer;formShow:boolean):string;

implementation

{$R *.dfm}

uses
  Main, msHTML;

var
  CurDispatch: IDispatch;


function getWebHTML(url:string;timeout:integer;formShow:boolean):string;
begin
  if frmWebHTMLclosing then exit;

  if timeout<1000 then timeout:= 1000; //causes problems
  frmWebHTML:=TfrmWebHTML.create(frmMain);

  with frmWebHTML do begin
    position:=poOwnerFormCenter;
    webBrowser1.navigate(url);
    if not formShow then begin
      borderStyle:= bsNone;
      height:=0;
      width:=0;
    end;
    with timerWebHTML do begin
      interval:= timeout;
      Enabled:= true;
    end;
    showModal;
    result:= replyHTML;
  end;
end;


procedure TfrmWebHTML.btnCancelClick(Sender: TObject);
begin
  frmWebHTMLclosing:= true;
  close;
end;

procedure TfrmWebHTML.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  frmMain.enabled:=true;
  timerWebHTML.Enabled:= false;
  webbrowser1.stop;
  modalresult:= mrOK;
  release;
end;

procedure TfrmWebHTML.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
exit;
  if frmWebHTMLclosing then exit;
  if key=27 then begin
    frmWebHTMLclosing:= true;
    replyHTML:='';
    frmWebHTML.close;
  end;
end;

procedure TfrmWebHTML.timerWebHTMLTimer(Sender: TObject);
begin
  timerWebHTML.enabled:= false;
  frmWebHTML.webBrowser1.Stop;
  replyHTML:='';
  frmWebHTML.close;
end;

procedure TfrmWebHTML.webBrowser1BeforeNavigate2(ASender: TObject;
  const pDisp: IDispatch; var URL, Flags, TargetFrameName, PostData,
  Headers: OleVariant; var Cancel: WordBool);
begin
  if frmWebHTMLclosing then cancel:= true;
end;

procedure TfrmWebHTML.webBrowser1DocumentComplete(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
var
  iall: IHTMLElement;
begin
  if (pDisp <> CurDispatch) then exit;
  CurDispatch := nil;
  if Assigned(WebBrowser1.Document) then begin
    iall := (WebBrowser1.Document AS IHTMLDocument2).body;
    while iall.parentElement <> nil do
      iall := iall.parentElement;

    replyHTML:= iall.outerHTML;
    close;
  end;
end;

procedure TfrmWebHTML.webBrowser1NavigateComplete2(ASender: TObject;
  const pDisp: IDispatch; var URL: OleVariant);
begin
  if CurDispatch = nil then CurDispatch := pDisp; //save for comparison
end;

end.
