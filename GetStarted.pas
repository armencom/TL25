unit GetStarted;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, dxGDIPlusClasses;

type
  TfrmGetStarted = class(TForm)
    Image1: TImage;
    Panel1: TPanel;
    btnPlay: TButton;
    btnClose: TButton;
    ckDoNotDisplay: TCheckBox;
    Label1: TLabel;
    Label2: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure ckDoNotDisplayClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGetStarted: TfrmGetStarted;

implementation

uses
  funcproc, TLSettings;

{$R *.dfm}

procedure TfrmGetStarted.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmGetStarted.btnPlayClick(Sender: TObject);
begin
  webURL('https://youtu.be/nm8k3ZPXEv4');
  close;
end;

procedure TfrmGetStarted.ckDoNotDisplayClick(Sender: TObject);
var
  s : string;
begin
  if ckDoNotDisplay.Checked = true then
    s := 'F'
  else
    s := 'T';
  // save to registry
  Settings.WriteGetStarted(s);
  close;
end;

procedure TfrmGetStarted.Image1Click(Sender: TObject);
begin
  webURL('https://youtu.be/nm8k3ZPXEv4');
  close;
end;

end.
