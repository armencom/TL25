unit frmOpTick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, ExtCtrls, StdCtrls,
  cxControls, cxContainer, cxEdit, cxTextEdit, cxGrid, cxCustomData, cxGridCustomTableView,
  StrUtils, cxGraphics, cxLookAndFeels, cxLookAndFeelPainters, Generics.Collections,
  Generics.Defaults, dxSkinsCore, dxSkinHighContrast, dxSkinOffice2010Black, dxSkinOffice2010Blue,
  dxSkinOffice2010Silver;

type
  TfrmOptTick = class(TForm)
    Panel1 : TPanel;
    Label8 : TLabel;
    pnlOpt : TPanel;
    lblOptTick : TcxTextEdit;
    Panel2 : TPanel;
    Label9 : TLabel;
    lblOptDescr : TcxTextEdit;
    Panel3 : TPanel;
    Label2 : TLabel;
    Label3 : TLabel;
    Label4 : TLabel;
    Label5 : TLabel;
    Label6 : TLabel;
    Label7 : TLabel;
    btnOK : TButton;
    btnCancel : TButton;
    edTick : TcxTextEdit;
    edMo : TcxTextEdit;
    edYr : TcxTextEdit;
    edStrike : TcxTextEdit;
    edPutCall : TcxTextEdit;
    procedure btnOKClick(Sender : TObject);
    procedure btnCancelClick(Sender : TObject);
    procedure FormActivate(Sender : TObject);
    procedure FormShow(Sender : TObject);
    private
    { Private declarations }
    public
    { Public declarations }
  end;

  PTick = ^TTick;

  TTick = packed record
    descr : string[100];
    tk :string[10];
  end;

{ save this code which shows how to sort a class
  TImpRec = class
    dt: String[20];
    tm: string[15];
    oc: string[1];
    ls: string[6];
    tk: string[40];
    sh: double;
    pr: double;
    prf: string[20];
    cm: double;
    am: double;
  end;
  TImpRecComparer = TComparer<TImpRec>;

  TImpRecList = class(TObjectList<TImpRec>)
  private
    function CompareTickers(const Item1, Item2: TImpRec): Integer;
  public
    procedure SortByTick;
  end;
 }
var
  frmOptTick : TfrmOptTick;
  myNewOptTicker :string;

function descrToSymbol(var TickList : TStringList): boolean;

//function LastPos(SubStr, S : string) : Integer;
//function getOptExpDayNum(S : string) : string;
//function getoptMonStr(S : string) : string;
//function getOptExpYearNum(S : string) : string;
//function getOptDescr(t : string) : string;
//function getRestOfOpt(t : string) : string;


implementation

uses
  Main, funcProc, import, recordClasses, underlying, cxDataStorage, //
  clipbrd, TLCommonLib, TLFile, cxFilter;

{$R *.DFM}

{ save this code which shows how to sort a class

function TImpRecList.CompareTickers(const Item1, Item2: TImpRec): Integer;
begin
  Result := 0;
  if Item1.tk < Item2.tk then Result := -1
  else
  if Item1.tk > Item2.tk then Result := 1
end;

procedure TImpRecList.SortByTick;
begin
  Sort(TImpRecComparer.Construct(
    function(const Item1, Item2: TImpRec): Integer
    begin
      result := CompareTickers(Item1, Item2);
    end)
  );
end;
}

procedure TfrmOptTick.btnOKClick(Sender : TObject);
begin
  myNewOptTicker := edTick.text + ' ' + edMo.text + edYr.text + ' ' + edStrike.text + ' ' +
    edPutCall.text;
  hide;
  modalResult := mrCancel;
end;


procedure TfrmOptTick.FormActivate(Sender : TObject);
begin
  Position := poMainFormCenter;
end;


procedure TfrmOptTick.FormShow(Sender : TObject);
var
  MyHeight : Integer;
begin
  Width := edPutCall.Left + edPutCall.Width + 20;
  MyHeight := btnCancel.Top + btnCancel.Height + 50;
  if Panel2.Visible then
    MyHeight := MyHeight + Panel2.Top + Panel2.Height
  else
    MyHeight := MyHeight + Panel3.Top;
  Height := MyHeight; // Ensures all buttons seen even for large fonts
end;


procedure TfrmOptTick.btnCancelClick(Sender : TObject);
begin
  myNewOptTicker := '';
  hide;
  modalResult := mrCancel;
  saveGridData(true);
  frmMain.cxGrid1TableView1.DataController.endUpdate;
  frmMain.btnShowAll.click;
end;


//function LastPos(SubStr, S : string): Integer;
//var
//  Found, Len, Pos : Integer;
//begin
//  Pos := Length(S);
//  Len := Length(SubStr);
//  Found := 0;
//  while (Pos > 0) and (Found = 0) do begin
//    if Copy(S, Pos, Len) = SubStr then
//      Found := Pos;
//    Dec(Pos);
//  end;
//  // make sure two digit year is next
//  if (Found > 0) and isInt(Copy(S, Found + 4, 2)) then
//    result := Found
//  else
//    result := 0;
//end;


function findOptMonStr(S :string): Integer;
var
  I, p, x : Integer;
  months : TStringList;
begin
  { This method used to search the Ticker for an option and find the beginning of the
   expiration date by looking for the 3 character month. But since the stock ticker
   can contain a similar string matching a month value it was necessary to delete
   the ticker from the incoming string before searcing for the month.

   So now once the ticker and the space after it are removed the X value below will
   contain the beginning of the date.

   Since this routine also does some checking to make sure the date portion of the string
   was in the expected format, that is what this routine now focuses on. It expects one of the
   three following formats MMMyy, dMMMyy, ddMMMyy.

   If it finds a valid Month String and finds any of the above formats it returns X as the beginning
   of the Expiration Date in the String. Otherwise it returns Zero, indicating an error with the
   Expiration Date format.
 }
  // load month stringList
  months := TStringList.Create;
  try
    months.Clear;
    months.Add('JAN');
    months.Add('FEB');
    months.Add('MAR');
    months.Add('APR');
    months.Add('MAY');
    months.Add('JUN');
    months.Add('JUL');
    months.Add('AUG');
    months.Add('SEP');
    months.Add('OCT');
    months.Add('NOV');
    months.Add('DEC');
    { Option Ticker Format TICKER DATE StrikePrice CALL/PUT, There should only
      be 3 spaces in a ticker symbol for an option, but if the Ticker portion
      is the company name and not the symbol then there may be more. So see how many
      there are first and remove all but two spaces. This should put us at the Date
 }
    I := CountOfChar(' ', Trim(S));
    if I < 3 then // If we don't have at least 3 spaces then this is not a valid Option Ticker
      Exit(0);
    I := I - 2;
    x := 0;
    while I > 0 do begin
      x := posex(' ', S, x + 1);
      Dec(I);
    end;
    delete(S, 1, x);
    { OK so now we have a string that should start with the expiration date,
      So let's verify the format of the date. }
    for I := 0 to months.Count - 1 do begin
      p := Pos(months[I], S);
      if (p > 0) then begin
           // Month and Year only
        if ((p = 1) and isInt(Copy(S, p + 3, 1))) or
           // One Digit day with Year On the End
          ((p = 2) and (isInt(Copy(S, p - 1, 1))) and (isInt(Copy(S, p + 3, 1)))) or
           // Two Digit Day with Year on the end
          ((p = 3) and (isInt(Copy(S, p - 2, 1)))and(isInt(Copy(S, p + 3, 1)))) then
          Exit(x)
        else // Invalid String.
          Exit(0);
      end;
    end;
  finally
    months.Free;
  end;
end;


//function getOptExpDayNum(S :string):string;
//var
//  I, p : Integer;
//  mon :string;
//begin
//  // return pos of JAN, FEB, MAR, etc. from option ticker
//  p := findOptMonStr(S);
//  if isInt(Copy(S, p, 2)) then
//    result := Copy(S, p, 2)
//  else if isInt(Copy(S, p, 1)) then
//    result := '0' + Copy(S, p, 1)
//  else
//    result := '';
//end;


//function getOptExpYearNum(S :string):string;
//var
//  I, p : Integer;
//  mon :string;
//begin
//  // return pos of JAN, FEB, MAR, etc. from option ticker
//  p := findOptMonStr(S);
//  if isInt(Copy(S, p, 1)) then begin
//    if isInt(Copy(S, p + 1, 1)) then
//     // has exp day with two digits
//      result := Copy(S, p + 5, 2)
//    else
//    // hasExpDay with One Digit
//      result := Copy(S, p + 4, 2);
//  end
//  else
//    // does not have exp day
//    result := Copy(S, p + 3, 2);
//end;


//function getoptMonStr(S :string):string;
//var
//  I, p : Integer;
//  mon :string;
//begin
//  // return pos of JAN, FEB, MAR, etc. from option ticker
//  p := findOptMonStr(S);
//
//  // find first occurance of alpha char
//  for I := 0 to Length(S) do begin
//    if Copy(S, p, 1)= ' ' then
//      continue;
//    if isInt(Copy(S, p + I, 1)) then
//      continue;
//    p := p + I;
//    break;
//  end;
//  result := Copy(S, p, 3);
//end;


//function getOptDescr(t :string):string;
//var
//  p : Integer;
//begin
//  p := findOptMonStr(t);
//  if p = 0 then
//    result := ''
//  else
//    result := Trim(Copy(t, 1, p - 1));
//end;


//function getRestOfOpt(t :string):string;
//var
//  p : Integer;
//begin
//  p := findOptMonStr(t);
//  if p = 0 then
//    result := ''
//  else
//    result := Trim(rightStr(t, Length(t)- p + 1));
//end;


function descrToSymbol(var TickList : TStringList): boolean;
var
  I, j : Integer;
  S, sDescr, sDescrOriginal, sTick : string;
  FoundTickList : TStringList;
begin
  result := false;
  if mDlg('Change Stock Description to Ticker Symbols?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then Exit;
  StopReport := false;
  sDescr := '';
  sDescrOriginal := '';
  sTick := '';
  try
    FoundTickList := TStringList.Create;
    for I := 0 to TickList.Count - 1 do begin
      FoundTickList.Clear;
      sDescrOriginal := TickList[I];
      sDescr := sDescrOriginal;
      // replace dashes with spaces
      sDescr := stringReplace(sDescr, '-', ' ', [rfReplaceAll]);
      Application.ProcessMessages;
      if GetKeyState(VK_ESCAPE) and 128 = 128 then
        StopReport := true;
      if StopReport then
        break;
      statbar('Getting Ticker Symbol for:  ' + sDescr);
      screen.cursor := crHourGlass;
      // loop to remove one word at a time
      repeat
        if not getStockTicker(sDescr, FoundTickList) then begin
          parseLastN(sDescr, ' ');
        end;
      until (FoundTickList.Count > 0) or (Pos(' ', sDescr) = 0);
      // if all the words failed, try first 6 chars
      if (FoundTickList.Count = 0) then begin
        if length(sDescr) > 0 then begin
          sDescr := Copy(sDescr, 1, 6);
          getStockTicker(sDescr, FoundTickList);
        end;
      end;
      if (FoundTickList.Count = 1) then begin
        sTick := Trim(Copy(FoundTickList[0], Pos('|', FoundTickList[0]) + 1));
      end
      else begin
        // returns the user selected stock Ticker symbol as sTick
        if TfrmUnderlying.Execute(FoundTickList, sDescrOriginal, sTick) = mrCancel then begin
          StopReport := true;
          break;
        end;
      end;
      // remove dash from ticker
      delete(sTick, Pos('-', sTick), 1);
      // add ticker symbol that was just found to list
      if (sTick <> '') then
        TickList[I] := TickList[I] + '|' + sTick;
      result := true;
    end; // <--for I := 0 to Trades.Count
  finally
    FreeAndNil(FoundTickList);
  end;
end;


end.
