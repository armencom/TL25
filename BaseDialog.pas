unit BaseDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TBaseDlg = class(TForm)
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    constructor Create(AOwner: TComponent); overload;
  protected
    procedure SaveData; virtual;
    procedure SetupForm; virtual;
  public
    { Public declarations }
    constructor Create; reintroduce; overload;
    class function Execute(FormCaption : String = '') : TModalResult; virtual;
  end;

implementation

{$R *.dfm}

{ TdlgBase }

{By redeclaring this constructor as private we are effectively hiding it so that it cannot be called.
  It just needs to call the inherited constructor}
constructor TBaseDlg.Create(AOwner: TComponent);
begin
  inherited;
end;

constructor TBaseDlg.Create;
begin
  raise Exception.Create('Constructor is disabled for dialog boxes, Use the execute class method instead.')
end;


class function TBaseDlg.Execute(FormCaption : String = '') : TModalResult;
begin
  With create(nil) do begin
    if Length(FormCaption) > 0 then
      Caption := FormCaption;
    Screen.Cursor := crHourGlass;
    try
      SetupForm;
    finally
      Screen.Cursor := crDefault;
    end;
    Result := showModal;
    if Result = mrOk then begin
      SaveData;
    end
    else begin
      close;
    end;
  end;
  Screen.Cursor := crDefault;
end;

procedure TBaseDlg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TBaseDlg.SaveData;
begin
//Do Nothing here, this needs to be implemented in a sub class if they use the default execute nethod
end;

procedure TBaseDlg.SetupForm;
begin
//Do Nothing here, this needs to be implemented in a sub class if they use the default execute nethod
end;

end.
