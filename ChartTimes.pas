unit ChartTimes;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxSpinEdit, cxTimeEdit, cxGraphics,
  cxDropDownEdit, StrUtils, Menus, cxLookAndFeels, cxLookAndFeelPainters, BaseDialog, dxSkinsCore,
  dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue, dxSkinOffice2010Silver;

type
  TfrmChartTimes = class(TBaseDlg)
    cxTimeEdit1 : TcxTimeEdit;
    lblStart1 : TLabel;
    lblStart2 : TLabel;
    cxTimeEdit2 : TcxTimeEdit;
    lblStart3 : TLabel;
    cxTimeEdit3 : TcxTimeEdit;
    lblStart4 : TLabel;
    cxTimeEdit4 : TcxTimeEdit;
    lblStart5 : TLabel;
    cxTimeEdit5 : TcxTimeEdit;
    cxTimeEdit6 : TcxTimeEdit;
    lblStart6 : TLabel;
    lblStart7 : TLabel;
    cxTimeEdit7 : TcxTimeEdit;
    lblStart8 : TLabel;
    cxTimeEdit8 : TcxTimeEdit;
    lblStart9 : TLabel;
    cxTimeEdit9 : TcxTimeEdit;
    lblStart10 : TLabel;
    cxTimeEdit10 : TcxTimeEdit;
    cxTimeEdit0 : TcxTimeEdit;
    lblEndAt : TLabel;
    btnApply : TButton;
    btnCancel : TButton;
    chkDefault : TCheckBox;
    cboxSections : TcxComboBox;
    lblSections : TLabel;
    btnSave : TButton;
    cboxCount : TcxComboBox;
    lblCount : TLabel;
    btnDeleteSettings : TButton;
    procedure FormActivate(Sender : TObject);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure cxTimeEditPropertiesValidate(Sender : TObject; var DisplayValue : Variant;
      var ErrorText : TCaption; var Error : Boolean);
    procedure cxTimeEditPropertiesEditValueChanged(Sender : TObject);
    procedure cboxSectionsPropertiesEditValueChanged(Sender : TObject);
    procedure btnSaveClick(Sender : TObject);
    procedure cboxCountPropertiesEditValueChanged(Sender : TObject);
    procedure btnDeleteSettingsClick(Sender : TObject);
    procedure btnApplyClick(Sender : TObject);
    procedure LoadSection(Section : string);
    procedure FormCreate(Sender : TObject);
    protected
      procedure SaveData; override;
      procedure SetupForm; override;
    private
      function CheckValidity : Boolean;
      procedure DoSaveData;
      procedure SetupButtons;
    public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses
  Main, FuncProc, TLSettings;

var
  { Internal Reference to the Active Chart Data Object }
  ChartData : TChartData;
  Loading : Boolean;
  NumOfIntervals : integer;
  FinalText, NextText, PrevText, thisKey, thisText : string;
  EndTime, NextTime, PrevTime, StartTime : TTime;


function TfrmChartTimes.CheckValidity : Boolean;
var
  i : integer;
begin
  if Loading then
    exit;
  // Note : Text compares necessary because Delphi does not see equality
  // of 2 exactly equal TTimes!
  FinalText := cxTimeEdit0.Text;
  PrevText := cxTimeEdit1.Text;
  PrevTime := cxTimeEdit1.Time;
  if (EndTime <= PrevTime) or (FinalText = PrevText) then begin
    Result := false;
    sm('End At must be later than Start #1 At.');
    exit;
  end;
  // ------------------------
  Result := true;
  for i := 2 to NumOfIntervals do begin
    case i of
    2 : begin
        thisText := cxTimeEdit2.Text;
        ThisTime := cxTimeEdit2.Time;
        NextText := cxTimeEdit3.Text;
        NextTime := cxTimeEdit3.Time;
      end;
    3 : begin
        NextText := cxTimeEdit4.Text;
        NextTime := cxTimeEdit4.Time;
      end;
    4 : begin
        NextText := cxTimeEdit5.Text;
        NextTime := cxTimeEdit5.Time;
      end;
    5 : begin
        NextText := cxTimeEdit6.Text;
        NextTime := cxTimeEdit6.Time;
      end;
    6 : begin
        NextText := cxTimeEdit7.Text;
        NextTime := cxTimeEdit7.Time;
      end;
    7 : begin
        NextText := cxTimeEdit8.Text;
        NextTime := cxTimeEdit8.Time;
      end;
    8 : begin
        NextText := cxTimeEdit9.Text;
        NextTime := cxTimeEdit9.Time;
      end;
    9 : begin
        NextText := cxTimeEdit10.Text;
        NextTime := cxTimeEdit10.Time;
      end;
    end;
    // -- Lower than preceding? --
    if (thisText = PrevText) or (thisText = FinalText) //
      or (ThisTime <= PrevTime) or (ThisTime >= EndTime) //
    then begin
      if i = NumOfIntervals then
        Result := ThisTime = NoTime
      else // If i < Intervals, next item must not be lower
        Result := (ThisTime >= NextTime) or (thisText = NextText);
    end;
    if not(Result) then begin
      sm('Start #' + IntToStr(i) + ' time invalid or out of sequence.');
      exit;
    end;
    PrevText := thisText;
    PrevTime := ThisTime;
    thisText := NextText;
    ThisTime := NextTime;
  end;
end;


procedure TfrmChartTimes.cxTimeEditPropertiesEditValueChanged(Sender : TObject);
begin
  with Sender as TcxTimeEdit do begin
    if Tag = 1 then begin // New Start Time
      if (Time >= EndTime) or (cxTimeEdit0.Text = Text) then begin
        sm('Start #1 At must be earlier than End At.');
        Time := StartTime;
        exit;
      end
      else
        StartTime := Time;
    end;
    if Tag = 0 then begin // New End Time
      if (Time <= StartTime)or (cxTimeEdit1.Text = Text) then begin
        sm('End At must be later than Start #1 At.');
        Time := StartTime;
        exit;
      end
      else
        EndTime := Time;
    end;
    if CheckValidity then
      btnSave.Enabled := true;
  end;
end;


procedure TfrmChartTimes.cxTimeEditPropertiesValidate(Sender : TObject; var DisplayValue : Variant;
  var ErrorText : TCaption; var Error : Boolean);
begin
  Error := false;
  with (Sender as TcxTimeEdit) do begin
    if (DisplayValue = '') then
      Time := NoTime
    else if not(TryStrToTime(DisplayValue, ThisTime, Settings.UserFmt)) then begin
      ErrorText := '      Improper Time Format' + UseEscapeStr //
        + '       Or Else Enter New Time.';
      Time := NoTime;
    end;
  end;
end;


procedure TfrmChartTimes.DoSaveData;
var
  Data : TChartData;
begin
  if btnSave.Enabled then begin
    ChartData.ChartIntervals := StrToInt(cboxCount.Text);
    ChartData.ChartTimes[0] := cxTimeEdit0.Time;
    ChartData.ChartTimes[1] := cxTimeEdit1.Time;
    ChartData.ChartTimes[2] := cxTimeEdit2.Time;
    ChartData.ChartTimes[3] := cxTimeEdit3.Time;
    ChartData.ChartTimes[4] := cxTimeEdit4.Time;
    ChartData.ChartTimes[5] := cxTimeEdit5.Time;
    ChartData.ChartTimes[6] := cxTimeEdit6.Time;
    ChartData.ChartTimes[7] := cxTimeEdit7.Time;
    ChartData.ChartTimes[8] := cxTimeEdit8.Time;
    ChartData.ChartTimes[9] := cxTimeEdit9.Time;
    ChartData.ChartTimes[10] := cxTimeEdit10.Time;
    Data := TChartData.Create;
    Data.Assign(ChartData);
    Settings.ChartDataList.AddOrSetValue(cboxSections.Text, Data);
  end;
end;


procedure TfrmChartTimes.FormActivate(Sender : TObject);
begin
  Position := poMainFormCenter;
end;


procedure TfrmChartTimes.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  Action := caFree;
end;


procedure TfrmChartTimes.FormCreate(Sender : TObject);
begin
  Loading := true;
  inherited;
end;


procedure TfrmChartTimes.SaveData;
var
  Data : TChartData;
begin
  DoSaveData;
  if chkDefault.Checked //
    and not(cboxSections.Text = DEFAULT_CHART_SECTION) //
  then begin
    Data := TChartData.Create;
    Data.Assign(ChartData);
    Settings.ChartDataList.AddOrSetValue(DEFAULT_CHART_SECTION, Data);
    if Length(cboxSections.Text) > 0 then
      Settings.ChartDataList.Remove(cboxSections.Text);
    Settings.ChartDataList.ActiveSection := DEFAULT_CHART_SECTION;
  end
  else
    Settings.ChartDataList.ActiveSection := cboxSections.Text;
  Settings.ChartDataList.SaveData;
end;


procedure TfrmChartTimes.SetupButtons;
begin
  chkDefault.Enabled := trim(cboxSections.Text) <> DEFAULT_CHART_SECTION;
  btnDeleteSettings.Enabled := chkDefault.Enabled;
  if not(chkDefault.Enabled) then
    chkDefault.Checked := false;
end;


procedure TfrmChartTimes.SetupForm;
var
  Key : string;
  i : integer;
begin
  { Setup Sections Combo Box }
  cboxSections.Properties.Items.Clear;
  for Key in Settings.ChartDataList.Keys do
    cboxSections.Properties.Items.Add(Key);
  cboxSections.Text := Settings.ChartDataList.ActiveSection;
end;


procedure TfrmChartTimes.btnApplyClick(Sender : TObject);
begin
  if not CheckValidity then begin
    ModalResult := mrNone;
    exit;
  end
  else
    ModalResult := mrOK;
end;


procedure TfrmChartTimes.btnDeleteSettingsClick(Sender : TObject);
var
  delName : string;
  i : integer;
begin
  delName := trim(cboxSections.Text);
  if (delName <> '') //
    and (delName <> DEFAULT_CHART_SECTION) then begin
    i := cboxSections.ActiveProperties.Items.IndexOf(delName);
    if not(sma('Delete ' + delName + '?', [mbAbort])) then begin
      Settings.ChartDataList.Remove(delName);
      Settings.ChartDataList.ActiveSection := DEFAULT_CHART_SECTION;
      SetupForm;
    end;
  end;
end;


procedure TfrmChartTimes.btnSaveClick(Sender : TObject);
begin
  if not CheckValidity then
    exit;
  SaveData;
  if chkDefault.Checked then begin
    cboxSections.ActiveProperties.Items.Delete(cboxSections.ItemIndex);
    LoadSection(Settings.ChartDataList.ActiveSection);
  end;
  SetupButtons;
  btnSave.Enabled := false;
end;

procedure TfrmChartTimes.cboxCountPropertiesEditValueChanged(Sender : TObject);
var
  i : integer;
begin
  NumOfIntervals := StrToInt(trim(cboxCount.Text));
  for i := 10 downto 2 do begin
    case i of
    2 : begin
        cxTimeEdit2.Enabled := NumOfIntervals >= 2;
        lblStart2.Enabled := cxTimeEdit2.Enabled;
        if not(cxTimeEdit2.Enabled) then
          cxTimeEdit2.Time := NoTime;
      end;
    3 : begin
        cxTimeEdit3.Enabled := NumOfIntervals >= 3;
        lblStart3.Enabled := cxTimeEdit3.Enabled;
        if not(cxTimeEdit3.Enabled) then
          cxTimeEdit3.Time := NoTime;
      end;
    4 : begin
        cxTimeEdit4.Enabled := NumOfIntervals >= 4;
        lblStart4.Enabled := cxTimeEdit4.Enabled;
        if not(cxTimeEdit4.Enabled) then
          cxTimeEdit4.Time := NoTime;
      end;
    5 : begin
        cxTimeEdit5.Enabled := NumOfIntervals >= 5;
        lblStart5.Enabled := cxTimeEdit5.Enabled;
        if not(cxTimeEdit5.Enabled) then
          cxTimeEdit5.Time := NoTime;
      end;
    6 : begin
        cxTimeEdit6.Enabled := NumOfIntervals >= 6;
        lblStart6.Enabled := cxTimeEdit6.Enabled;
        if not(cxTimeEdit6.Enabled) then
          cxTimeEdit6.Time := NoTime;
      end;
    7 : begin
        cxTimeEdit7.Enabled := NumOfIntervals >= 7;
        lblStart7.Enabled := cxTimeEdit7.Enabled;
        if not(cxTimeEdit7.Enabled) then
          cxTimeEdit7.Time := NoTime;
      end;
    8 : begin
        cxTimeEdit8.Enabled := NumOfIntervals >= 8;
        lblStart8.Enabled := cxTimeEdit8.Enabled;
        if not(cxTimeEdit8.Enabled) then
          cxTimeEdit8.Time := NoTime;
      end;
    9 : begin
        cxTimeEdit9.Enabled := NumOfIntervals >= 9;
        lblStart9.Enabled := cxTimeEdit9.Enabled;
        if not(cxTimeEdit9.Enabled) then
          cxTimeEdit9.Time := NoTime;
      end;
    10 : begin
        cxTimeEdit10.Enabled := NumOfIntervals >= 10;
        lblStart10.Enabled := cxTimeEdit10.Enabled;
        if not(cxTimeEdit10.Enabled) then
          cxTimeEdit10.Time := NoTime;
      end;
    end;
    Application.ProcessMessages;
  end;
  btnSave.Enabled := true;
end;


procedure TfrmChartTimes.cboxSectionsPropertiesEditValueChanged(Sender : TObject);
var
  i : integer;
  thisStr : string;
begin
  thisStr := trim(cboxSections.Text);
  if thisStr = '' then begin
    { Can't be null so if they try to make it null then set it back to default }
    cboxSections.Text := DEFAULT_CHART_SECTION;
  end
  else if cboxSections.ActiveProperties.Items.IndexOf(thisStr) = -1 then begin
    { If it is not in the list then lets add it }
    cboxSections.ItemIndex := cboxSections.ActiveProperties.Items.Add(thisStr);
    btnSave.Enabled := true;
  end
  else begin
    LoadSection(thisStr);
    SetupButtons;
  end;
end;


procedure TfrmChartTimes.LoadSection(Section : string);
begin
  Loading := true;
  try
    Settings.ChartDataList.ActiveSection := Section;
    ChartData.Free;
    ChartData := TChartData.Create;
    ChartData.Assign(Settings.ChartDataList.ActiveChartData);
    { Setup Intervals Combo item index }
    cboxCount.ItemIndex := ChartData.ChartIntervals - 1;
    cxTimeEdit0.Time := ChartData.ChartTimes[0];
    cxTimeEdit1.Time := ChartData.ChartTimes[1];
    cxTimeEdit2.Time := ChartData.ChartTimes[2];
    cxTimeEdit3.Time := ChartData.ChartTimes[3];
    cxTimeEdit4.Time := ChartData.ChartTimes[4];
    cxTimeEdit5.Time := ChartData.ChartTimes[5];
    cxTimeEdit6.Time := ChartData.ChartTimes[6];
    cxTimeEdit7.Time := ChartData.ChartTimes[7];
    cxTimeEdit8.Time := ChartData.ChartTimes[8];
    cxTimeEdit9.Time := ChartData.ChartTimes[9];
    cxTimeEdit10.Time := ChartData.ChartTimes[10];
    EndTime := cxTimeEdit0.Time;
    StartTime := cxTimeEdit1.Time;
  finally
    Loading := false;
    btnSave.Enabled := false;
  end;
end;


end.
