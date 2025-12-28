unit underlying;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, cxControls,
  cxContainer, cxListBox, cxGridCustomTableView, cxGridTableView, cxGridLevel, cxClasses, funcProc,
  cxGridCustomView, cxGrid, main, cxStyles, cxCustomData, cxGraphics, cxFilter, cxData,
  cxDataStorage, cxEdit, DB, cxDBData, ExtCtrls, cxLookAndFeels, cxLookAndFeelPainters, cxNavigator,
  cxTextEdit, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver, dxSkinscxPCPainter;

type
  TfrmUnderlying = class(TForm)
    cxTicksTable : TcxGridTableView;
    cxTicksLevel1 : TcxGridLevel;
    cxTicks : TcxGrid;
    cxDescr : TcxGridColumn;
    cxTick : TcxGridColumn;
    pnlInstr : TPanel;
    lblInstr : TLabel;
    pnlButtons : TPanel;
    btnCancel : TButton;
    btnOK : TButton;
    pnlDescTick : TPanel;
    lblDesc : TLabel;
    edTick : TEdit;
    Label1 : TLabel;
    lblInstr2 : TLabel;
    cxStyleRepository1 : TcxStyleRepository;
    procedure cxTicksTableCellClick(Sender : TcxCustomGridTableView;
      ACellViewInfo : TcxGridTableDataCellViewInfo; AButton : TMouseButton; AShift : TShiftState;
      var AHandled : Boolean);
    procedure FormShow(Sender : TObject);
    procedure FormActivate(Sender : TObject);
    procedure FormClose(Sender : TObject; var Action : TCloseAction);
    procedure FormCloseQuery(Sender : TObject; var CanClose : Boolean);
    procedure btnCancelClick(Sender : TObject);
    procedure edTickChange(Sender : TObject);
    procedure cxTicksTableCustomDrawCell(Sender : TcxCustomGridTableView; ACanvas : TcxCanvas;
      AViewInfo : TcxGridTableDataCellViewInfo; var ADone : Boolean);
    private
    { Private declarations }
      constructor Create(AOwner : TComponent); overload;
      procedure LoadGrid(foundTickList : TStringList);
      procedure CalcHeight(r : integer);
    public
    { Public declarations }
      constructor Create; reintroduce; overload;
      class function Execute(foundTickList : TStringList; sDescOriginal :string;
        var sTicker :string): TModalResult;
      class function Verify(var foundTickList : TStringList): TModalResult;
  end;

implementation

{$R *.DFM}

uses
  TLCommonLib;

var
  numGridRows : integer;

var
  bCancel, bVerify : Boolean;

procedure TfrmUnderlying.CalcHeight(r : integer);
var
  gridHeight : integer;
begin
  gridHeight := (r + 1) * cxTicksTable.OptionsView.DataRowHeight;
  if (cxTicks.height > gridHeight) then
    height := height - cxTicks.height - gridHeight + 4
  else if (cxTicks.height < gridHeight) then
    height := height + gridHeight - cxTicks.height + 4;
end;

procedure TfrmUnderlying.btnCancelClick(Sender : TObject);
begin
  bCancel := true;
end;

constructor TfrmUnderlying.Create(AOwner : TComponent);
begin
  inherited;
end;

constructor TfrmUnderlying.Create;
begin
  raise Exception.Create('Constructor Disabled, Use Execute Class Method Instead.')
end;

procedure TfrmUnderlying.cxTicksTableCellClick(Sender : TcxCustomGridTableView;
  ACellViewInfo : TcxGridTableDataCellViewInfo; AButton : TMouseButton; AShift : TShiftState;
  var AHandled : Boolean);
begin
  edTick.Text := cxTicksTable.DataController.values
    [cxTicksTable.DataController.FocusedRecordIndex, 1];
  edTick.SetFocus;
end;

procedure TfrmUnderlying.cxTicksTableCustomDrawCell(Sender : TcxCustomGridTableView;
  ACanvas : TcxCanvas; AViewInfo : TcxGridTableDataCellViewInfo; var ADone : Boolean);
begin
  if (AViewInfo.GridRecord.Selected) then begin
    ACanvas.Brush.color := clBtnFace;
    ACanvas.Font.Style := [fsBold];
  end;
end;

procedure TfrmUnderlying.edTickChange(Sender : TObject);
begin
  if (edTick.Text <> '') then
    btnOK.Enabled := true
  else
    btnOK.Enabled := false;

  if bVerify then
    cxTicksTable.DataController.values[cxTicksTable.DataController.FocusedRecordIndex, 1] :=
      edTick.Text;
end;

class function TfrmUnderlying.Execute(foundTickList : TStringList; sDescOriginal : string;
  var sTicker : string): TModalResult;
var
  sDesc : string;
begin
  bVerify := false;
  with Create(nil) do begin
    Screen.Cursor := crHourGlass;
    Caption := uppercase('Stock Ticker Symbol Lookup');
    lblDesc.Caption := sDescOriginal;
    if (foundTickList.Count > 0) then begin
      LoadGrid(foundTickList);
      lblInstr.Caption :=
        'Please select from the list below, or enter the correct ticker symbol in the box to the right.';
      // only one tciker found
      if (foundTickList.Count = 1) then begin
        lblInstr.Caption := 'Please VERIFY the stock symbol below:';
        sDesc := foundTickList[0];
        sDesc := trim(parseFirst(sDesc, '|'));
        if sDesc <> '' then
          edTick.Text := trim(Copy(foundTickList[0], Pos('|', foundTickList[0]) + 1));
      end;
    end
    else begin // <-- foundTickList.Count > 0
      lblInstr.Caption :=
        'No tickers found. Please enter the correct ticker symbol in the box below.';
    end;
    Screen.Cursor := crDefault;
    numGridRows := foundTickList.Count;
    Result := showModal;
    if (Result = mrOk) then
      sTicker := edTick.Text
    else
      sTicker := '';
  end;
end;


class function TfrmUnderlying.Verify(var foundTickList : TStringList): TModalResult;
var
  sDesc : string;
  i : integer;
begin
  bVerify := true;
  with Create(nil) do begin
    Screen.Cursor := crHourGlass;
    Caption := uppercase('Verify Stock Tickers');
    pnlInstr.Font.Style := [fsBold];
    pnlInstr.color := clYellow;
    lblInstr.Caption := 'Please VERIFY ALL tickers in the grid below.';
    lblInstr2.Caption := 'Click on a line to change the ticker.';
    lblInstr2.show;
    lblDesc.Hide;
    LoadGrid(foundTickList);
    numGridRows := cxTicksTable.DataController.RecordCount;
    Screen.Cursor := crDefault;
    beep;
    Result := showModal;
    // pass edited TickList back
    if (Result = mrOk) and bVerify then begin
      foundTickList.Clear;
      for i := 0 to cxTicksTable.DataController.RowCount - 1 do begin
        sDesc := cxTicksTable.DataController.values[i, 0] + '|' +
          cxTicksTable.DataController.values[i, 1];
        foundTickList.Add(sDesc);
      end
    end;
  end;
end;


procedure TfrmUnderlying.FormActivate(Sender : TObject);
begin
  CalcHeight(numGridRows);
  constraints.MinHeight := 300;
  constraints.maxHeight := frmMain.height - 100;
  Position := poMainFormCenter;
  if bVerify then begin
    btnOK.Enabled := true;
    btnCancel.Hide;
    exit;
  end;
  edTick.SetFocus;
  if (edTick.Text = '') then
    btnOK.Enabled := false
  else
    btnOK.Enabled := true;
end;


procedure TfrmUnderlying.FormClose(Sender : TObject; var Action : TCloseAction);
begin
  Action := caFree;
end;


procedure TfrmUnderlying.FormCloseQuery(Sender : TObject; var CanClose : Boolean);
begin
  if bCancel or bVerify then
    exit;
  if edTick.Text = '' then begin
    mDlg('You must enter a valid stock ticker', mtError, [mbOk], 1);
    CanClose := false;
  end
  else
    CanClose := true;
end;


procedure TfrmUnderlying.FormShow(Sender : TObject);
begin
  cxTicks.Align := alClient;
  cxTicksTable.Items[0].DataBinding.ValueTypeClass := TcxStringValueType; // Descr
  cxTicksTable.Items[1].DataBinding.ValueTypeClass := TcxStringValueType; // Tick
end;


procedure TfrmUnderlying.LoadGrid(foundTickList : TStringList);
var
  i : integer;
  Tick : string;
  Descr : string;
begin
  cxTicksTable.DataController.RecordCount := 0;
  if foundTickList.Count > 0 then begin
    cxTicksTable.DataController.RecordCount := foundTickList.Count;
    cxTicksTable.DataController.BeginUpdate;
    try
      for i := 0 to foundTickList.Count - 1 do begin
        Tick := foundTickList[i];
        Tick := trim(Copy(Tick, Pos('|', Tick) + 1));
        Descr := foundTickList[i];
        Descr := trim(Copy(Descr, 1, Pos('|', Descr)- 1));
        if Descr = '' then begin
          with cxTicksTable.DataController do
            RecordCount := RecordCount - 1;
          continue;
        end;
        cxTicksTable.DataController.values[i, 0] := Descr;
        cxTicksTable.DataController.values[i, 1] := Tick;
      end;
    finally
      cxTicksTable.DataController.EndUpdate;
    end;
    cxTicksTable.DataController.focusedRowIndex :=-1;
  end;
end;


end.
