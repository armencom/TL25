unit dateErr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmDateErr = class(TForm)
    Panel1: TPanel;
    btnHelp: TButton;
    btnOK: TButton;
    lblMsg: TMemo;
    procedure btnHelpClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  procedure showDateErr(capTxt,msgStr:string);

var
  frmDateErr: TfrmDateErr;
  windowsDateErr: boolean;

implementation

{$R *.dfm}

uses
  Main,funcProc,ShellAPI, TLSettings;

procedure showDateErr(capTxt,msgStr:string);
begin
  frmDateErr:=TfrmDateErr.Create(frmMain);

  with frmDateErr do begin

    caption:= capTxt;

    lblMsg.lines.clear;
    while pos(cr,msgStr)>0 do begin
      if copy(msgStr,1,pos(cr,msgStr)-1)='' then
        lblMsg.lines.add('')
      else
        lblMsg.lines.add(copy(msgStr,1,pos(cr,msgStr)-1));
      delete(msgStr,1,pos(cr,msgStr));
    end;

    lblMsg.height:= lblMsg.lines.count * 20;
    if lblMsg.height > frmMain.height-135 then begin
      lblMsg.height:= frmMain.height-135;
      lblMsg.scrollbars:=ssVertical;
    end;
    height:= lblMsg.height+115;

    showModal;
  end;
end;

procedure TfrmDateErr.btnHelpClick(Sender: TObject);
var
  zFileName, zParams, zDir: array[0..79] of Char;
begin
  ShellExecute(Handle, nil,
    StrPCopy(zFileName, 'iexplore.exe'),
    StrPCopy(zParams, SiteURL + 'support/user-guide/common-problems.php'),
    StrPCopy(zDir, Settings.InstallDir), SW_SHOW);
end;

procedure TfrmDateErr.btnOKClick(Sender: TObject);
begin
  windowsDateErr:= true;
  release;
  close;
end;

end.
