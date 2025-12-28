unit frmNewBBIFU;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, Main, ComCtrls, ExtCtrls, FuncProc, recordClasses;

type
  TNewBBIFU = class(TForm)
    btnAddToFutures: TButton;
    btnAddToBBIndex: TButton;
    pnlMessage: TPanel;
    lstBBIFU: TListView;
    lblMsg1: TLabel;
    lblMsg2: TLabel;
    btnCancel: TButton;
    btnSelectAll: TButton;
    btnChgMult: TButton;
    Label1: TLabel;
    procedure btnAddToBBIndexClick(Sender: TObject);
    procedure btnAddToFuturesClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnSelectAllClick(Sender: TObject);
    procedure btnChgMultClick(Sender: TObject);
  private
    { Private declarations }
    procedure AddToList(index: integer);
  public
    { Public declarations }
    function newBBFUCount():integer;
  end;

var
  NewBBIFU: TNewBBIFU;

implementation

uses TLSettings, TLCommonLib, TLFile;

{$R *.dfm}


procedure TNewBBIFU.btnAddToBBIndexClick(Sender: TObject);
var
  pBBIO : PBBIOItem;
  i : integer;
  item : TListItem;
  BBIOsList : TLBBIOList;
begin
  with frmMain do begin
    if lstBBIFU.Items.Count > 0 then begin
      if lstBBIFU.SelCount > 0 then begin
        BBIOsList := Settings.BBIOList; // 2018-04-05 MB
        for i := 0 to lstBBIFU.Items.Count - 1 do begin
          if lstBBIFU.Items.Item[i].Selected then begin
            item := lstBBIFU.Items[i];
            new(pBBIO);
            FillChar(pBBIO^, SizeOf(pBBIO^), 0);
          { if (item.SubItems[1] = 'Globex') or (item.SubItems[1] = 'Cyber')
            or (item.SubItems[1] = 'Penson') or (item.SubItems[1] = 'TOS') then
              syItem.Symbol := trim(item.Caption)
            else
              syItem.Symbol := trim(item.Caption) + ' ';  }
            pBBIO.Symbol := trim(item.Caption);
            pBBIO.Mult := trim(item.SubItems[0]);
            BBIOsList.Add(pBBIO);
          end;
        end;
        Settings.BBIOList := BBIOsList; // 2018-04-05 MB
        lstBBIFU.DeleteSelected;
        if lstBBIFU.Items.Count = 0 then self.Close;
      end
      else
        ShowMessage('Please select the symbol(s) to add to the BBIndex options list.');
    end;
  end;
end;


procedure TNewBBIFU.btnAddToFuturesClick(Sender: TObject);
var
  fuItem : PFutureItem;
  i : integer;
  item : TListItem;
  FutureList : TList;
begin
  with frmMain do begin
    if lstBBIFU.Items.Count > 0 then begin
      if lstBBIFU.SelCount > 0 then begin
        FutureList := Settings.FutureList;
        for i := 0 to lstBBIFU.Items.Count - 1 do begin
          if lstBBIFU.Items.Item[i].Selected then begin
            item := lstBBIFU.Items[i];
            new(fuItem);
            FillChar(fuItem^, SizeOf(fuItem^), 0);
          { if (item.SubItems[1] = 'Globex') or (item.SubItems[1] = 'Cyber')
            or (item.SubItems[1] = 'Penson') or (item.SubItems[1] = 'TOS') then
              fuItem.Name := trim(item.Caption)
            else
              fuItem.Name := trim(item.Caption) + ' ';   }
            fuItem.Name := trim(item.Caption);
            fuItem.Value := StrToFloat(trim(item.SubItems[0]));
            FutureList.Add(fuItem);
          end;
        end;
        Settings.FutureList := FutureList;
        lstBBIFU.DeleteSelected;
        if lstBBIFU.Items.Count = 0 then self.Close;
      end
      else
        ShowMessage('Please select the symbol(s) to add to the Futures list.');
    end;
  end;
end;


procedure TNewBBIFU.btnCancelClick(Sender: TObject);
begin
  Close;
end;


procedure TNewBBIFU.btnChgMultClick(Sender: TObject);
var
  fuItem : PFutureItem;
  i : integer;
  item : TListItem;
  mult:string;
begin
  with frmMain do begin
    if lstBBIFU.SelCount > 0 then begin
      for i := 0 to lstBBIFU.Items.Count - 1 do begin
        if lstBBIFU.Items.Item[i].Selected then begin
          mult:='';
          item := lstBBIFU.Items[i];
          new(fuItem);
          FillChar(fuItem^, SizeOf(fuItem^), 0);
          fuItem.Name := trim(item.Caption);
          while not isFloat(mult) do begin
            mult:= myInputBox('Multiplier:',
              'Enter Multiplier for Future contract: '+fuItem.name ,
              '', frmMain.Handle);
            if (mult = '') then break;
            if not isFloat(mult)
              then sm('Multiplier must be a decimal number.');
          end;
          if mult<>'' then
            lstBBIFU.Items[i].SubItems[0]:= mult;
        end;
      end;
    end;
  end;
end;


procedure TNewBBIFU.btnSelectAllClick(Sender: TObject);
begin
  lstBBIFU.SelectAll;
  lstBBIFU.SetFocus;
end;


function TNewBBIFU.newBBFUCount():integer;
var
  i, j, tickerLength, spacePosition : integer;
  symbol, sTick : string;
  fuItem : PFutureItem;
  pBBIO : PBBIOItem;
  found : boolean;
begin
  lstBBIFU.Items.Clear;
  with frmMain do begin
    for i := 0 to TradeLogFile.Count - 1 do begin
      sTick := trim(TradeLogFile[I].Ticker);
      tickerLength := Length(sTick);
      if (pos('FUT-', TradeLogFile[I].TypeMult) = 1) //
      and ( (Copy(TradeLogFile[I].Ticker, tickerLength - 4, tickerLength) = ' CALL') //
        or (Copy(TradeLogFile[I].Ticker, tickerLength - 3, tickerLength) = ' PUT') ) //
      then begin
        found := false;
        // ----------------------------
        // check for BB Index options
        // ----------------------------
        for j := 0 to Settings.BBIOList.Count - 1 do begin // 2018-04-05 MB
          pBBIO := Settings.BBIOList[j];
          if (POS(' CALL', TradeLogFile[i].Ticker) > 0) //
          or (POS(' PUT', TradeLogFile[i].Ticker) > 0) then
            sTick := trim(TradeLogFile[i].Ticker) + ' ';
          if (pos(trim(pBBIO.Symbol) + ' ', sTick) = 1) then begin
            found := true;
            break;
          end;
        end;
        // ----------------------------
        // check for Futures
        // ----------------------------
        if not found then begin
          // 2018-05-16 MB - moved this outside j loop for speed
          spacePosition := Pos(' ', TradeLogFile[i].Ticker);
          if spacePosition = 0 then
            symbol := TradeLogFile[i].Ticker
          else
            symbol := Copy(TradeLogFile[i].Ticker, 1, spacePosition-1);
          // 2018-05-16 MB - END speed optimization
          for j := 0 to Settings.FutureList.Count - 1 do begin
            fuItem := Settings.FutureList[j];
            if (fuItem.Name = symbol) or (fuItem.Name = symbol + ' ') then begin
              found := true;
              break;
            end;
          end;
        end;
        // ----------------------------
        if not found then
          AddToList(i);
      end;
    end;
  end;
  result := lstBBIFU.Items.Count;
end;


procedure TNewBBIFU.AddToList(index: integer);
var
  k : integer;
  alreadyExist : boolean;
  list : TListItem;
  symbol, multiplier : string;
begin
  alreadyExist := false;
  symbol := trim(Copy(TradeLogFile[index].Ticker, 1, Pos(' ', TradeLogFile[index].Ticker)));
  if symbol = EmptyStr then
    symbol := Copy(TradeLogFile[index].Ticker, 1, Length(TradeLogFile[index].Ticker));
  // ------------------------
  if symbol <> EmptyStr then begin
    for k := 0 to lstBBIFU.Items.Count - 1 do begin
      if lstBBIFU.Items[k].Caption = symbol then begin
        alreadyExist := true;
        break;
      end;
    end;
    // ----------------------
    if not alreadyExist then begin
      list := lstBBIFU.Items.Add;
      list.Caption := symbol;
      multiplier := trim(Copy(TradeLogFile[index].TypeMult, Pos('-', TradeLogFile[index].TypeMult) + 1, Length(TradeLogFile[index].TypeMult)));
      list.SubItems.Add(multiplier);
    end;
  end;
end;


procedure TNewBBIFU.FormActivate(Sender: TObject);
begin
  Position := poMainFormCenter;
end;


end.
