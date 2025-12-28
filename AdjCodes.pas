unit AdjCodes;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TdlgAdjCodes = class(TForm)
    GroupBox1: TGroupBox;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    GroupBox3: TGroupBox;
    RadioButton5: TRadioButton;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure Label1MouseLeave(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label3MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgAdjCodes: TdlgAdjCodes;

implementation

uses
  FuncProc;

{$R *.dfm}

procedure TdlgAdjCodes.Button1Click(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TdlgAdjCodes.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TdlgAdjCodes.Button3Click(Sender: TObject);
begin
  radiobutton4.Checked := true;
  checkbox1.checked := false;
  radiobutton7.Checked := true;
end;



// ------------------------------------
//        Label1 (hyperlink)
// ------------------------------------
procedure TdlgAdjCodes.Label1Click(Sender: TObject);
begin // display help
  webURL(supportSiteURL + 'hc/en-us/articles/115004475153');
end;

procedure TdlgAdjCodes.Label1MouseEnter(Sender: TObject);
begin // mouseover
  Label1.Font.Style := [fsUnderline];
end;

procedure TdlgAdjCodes.Label1MouseLeave(Sender: TObject);
begin
  Label1.Font.Style := [];
end;

// ------------------------------------
//        Label2 (hyperlink)
// ------------------------------------
procedure TdlgAdjCodes.Label2Click(Sender: TObject);
begin // display help
  webURL(supportSiteURL + 'hc/en-us/articles/4402704274327');
end;

procedure TdlgAdjCodes.Label2MouseEnter(Sender: TObject);
begin // mouseover
  Label2.Font.Style := [fsUnderline];
end;

procedure TdlgAdjCodes.Label2MouseLeave(Sender: TObject);
begin
  Label2.Font.Style := [];
end;

// ------------------------------------
//        Label3 (hyperlink)
// ------------------------------------
procedure TdlgAdjCodes.Label3Click(Sender: TObject);
begin // display help
  webURL(supportSiteURL + 'hc/en-us/articles/4403059122583');
end;

procedure TdlgAdjCodes.Label3MouseEnter(Sender: TObject);
begin // mouseover
  Label3.Font.Style := [fsUnderline];
end;

procedure TdlgAdjCodes.Label3MouseLeave(Sender: TObject);
begin
  Label3.Font.Style := [];
end;

end.
