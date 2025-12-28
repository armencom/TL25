unit WBform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, OleCtrls, SHDocVw;

type
  TfrmWB = class(TForm)
    WB: TWebBrowser;
    procedure WBDocumentComplete(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
      var URL: OleVariant);
    procedure WBNavigateError(ASender: TObject; const pDisp: IDispatch; var URL,
      Frame, StatusCode: OleVariant; var Cancel: WordBool);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWB: TfrmWB;
  WBhtml:string;

implementation

uses Main,funcproc,msHTML;

var
  CurDispatch: IDispatch; //save the interface globally


{$R *.dfm}

procedure TfrmWB.FormShow(Sender: TObject);
begin
  width:=1;
  height:=1;
end;

procedure TfrmWB.WBDocumentComplete(ASender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
var
  Document:  IHTMLDocument2;
  iall: IHTMLElement;
  reply:string;
begin
  reply:='';
  sleep(200);
  if (pDisp <> CurDispatch) then exit;

  iall := (wb.Document AS IHTMLDocument2).body;

  while iall.parentElement <> nil do
    iall := iall.parentElement;

  reply:= iall.outerHTML;

  WBhtml:= reply; 

  modalResult:=mrOK;

end;

procedure TfrmWB.WBNavigateComplete2(ASender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
begin
  //if CurDispatch = nil then
  CurDispatch := pDisp;     //keeps navComplete from firing more than once
end;

procedure TfrmWB.WBNavigateError(ASender: TObject; const pDisp: IDispatch;
  var URL, Frame, StatusCode: OleVariant; var Cancel: WordBool);
begin
  with WB do begin
    stop;
  end;
  CurDispatch:= nil;
  WBhtml:='WBnavErr';
  with frmWB do begin
    modalResult:=mrOK;
  end;

  frmMain.Enabled:= true;
  statBar('off');

end;


end.
