unit TLDateUtils;

interface

uses SysUtils, Classes, Windows, StrUtils, DateUtils;

type
  TTLDateUtils = class
  public
    {Increment can be positive or negative, if increment is Zero then the date will not be changed
     Count business days only in the increment, skip weekends and holidays.}
    class function IncBusinessDay(InDate : TDateTime; Increment : Integer = 1) : TDateTime;
    {Is the date passed in a holiday based on the holiday calculation methods below}
    class function IsHoliday(InDate : TDate) : Boolean;
    {Is the Date passed in Thanksgiving, 4th Thursday in November}
    class function IsThanksgiving(InDate : TDate) : Boolean;
    {Is the Date passed in Memorial Day, Last Monday of May}
    class function IsMemorialDay(InDate : TDate) : Boolean;
    {Is the Date passed in Labor Day, First Monday in September}
    class function IsLaborDay(InDAte : TDate) : Boolean;
    {Is the date passed in Christmas Day Observed, See ObservedOnDay for further explanation}
    class function IsChristmasDay(InDate : TDate) : Boolean;
    {Is the date passed in New Years Day Observed, See ObservedOnDay for further explanation}
    class function IsNewYearsDay(InDate : TDate) : Boolean;
    {Is the Date passed in Martin Luther King Day, 3rd Monday in January}
    class function IsMartinLutherKingDay(InDate : TDate) : Boolean;
    {Is the date President's Day, 3rd Monday in February}
    class function IsPresidentsDay(InDate : TDate) : Boolean;
    {Is the date passed in Independence Day Observed, See ObservedOnDay for further explanation}
    class function IsIndependenceDay(InDate : TDate) : Boolean;
    {Is the date passed in Good Friday, Based on First New Moon after Spring Equinox}
    class function IsGoodFriday(InDate : TDate) : Boolean;
    {Is the InDate in the Month, Week and DayOfWeek provided}
    class function IsOnAGivenDate(InDate : TDate; Month : Word; Week : Word; DayOfWeek : Word) : Boolean;
    {Is the InDate on the Last DayOfWeek of the given Month}
    class function isOnLastOfGivenDay(InDate : TDate; Month : Word; DayOfWeek : Word) : Boolean;
    {Holidays that fall on a specific date, such as Christmas, New Years, Independence Day, are observed
     on a weekday even if they fall on the weekend. The rule is if the holiday falls on a Sunday it is observed
     on the following Monday, if the holiday falls on a Saturday it is observed on the previous friday
     So this method returns the Observed on Day for these types of holidays}
    class function ObservedOnDay(InDate : TDate) : TDate;
    {Add One Year to FirstDate, taking into account leap year and
      if it is still less than second Date then more than one year between dates}
    class function MoreThanOneYearBetween(FirstDate, SecondDate : TDateTime) : Boolean;
  end;


implementation


class function TTLDateUtils.MoreThanOneYearBetween(FirstDate, SecondDate : TDateTime): Boolean;
var
  DaysToAdd : Integer;
begin
  DaysToAdd := 365;
  // If First Date is a leap year AND before Feb 29, add 366 days
  // OR If Second Date is a leap year AND after Feb 28th, add 366
  if (IsInLeapYear(FirstDate) and (FirstDate < EncodeDate(YearOf(FirstDate), 2, 29))) //
  or (IsInLeapYear(SecondDate) and (SecondDate > EncodeDate(YearOf(SecondDate), 2, 28))) //
  then
    DaysToAdd := 366;
  Result := SecondDate > FirstDate + DaysToAdd;
end;


// Increment date, but only count business days
class function TTLDateUtils.IncBusinessDay(InDate : TDateTime; Increment : Integer = 1) : TDateTime;
var
  OneDayIncrement : Integer;
  I : Integer;
begin
  if Increment = 0 then Exit(InDate);
  if Increment < 0 then
    OneDayIncrement := -1
  else
    OneDayIncrement := 1;
  Result := InDate;
  for I := 1 to Abs(Increment) do begin
    Result := IncDay(Result, OneDayIncrement);
    while (DayOfWeek(Result) in [1, 7]) or IsHoliday(Result) do begin
      Result := IncDay(Result, OneDayIncrement);
    end; // while
  end; // for i
end;


// identify stock market holidays
class function TTLDateUtils.IsHoliday(InDate : TDate) : Boolean;
begin
  Result := IsThanksgiving(InDate) //
         or IsMemorialDay(InDate) //
         or IsLaborDay(InDate) //
         or IsChristmasDay(InDate) //
         or IsNewYearsDay(InDate) //
         or IsPresidentsDay(InDate) //
         or IsMartinLutherKingDay(InDate) //
         or IsGoodFriday(InDate) //
         or IsIndependenceDay(InDate);
end;


class function TTLDateUtils.IsThanksgiving(InDate : TDate) : Boolean;
begin
  {Assumptions: Thanksgiving is always forth Thursday in November}
  Result := IsOnAGivenDate(InDate, 11, 4, 5);
end;


{If date falls on a weekend then increment to following monday
 as many holidays are observed on monday if they fall on the weekend,
 New Years, Chrismtas, July 4th}
class function TTLDateUtils.ObservedOnDay(InDate: TDate): TDate;
begin
  Result := InDate;
  if DayOfWeek(Result) = 1 then
    Result := IncDay(Result)
  else if DayOfWeek(Result) = 7 then
    Result := IncDay(Result, -1);
end;

class function TTLDateUtils.IsMemorialDay(InDate : TDate) : Boolean;
begin
  {Assumptions: Memorial day is always the last monday in May.}
  Result := isOnLastOfGivenDay(InDate, 5, 2);
end;

class function TTLDateUtils.IsLaborDay(InDAte : TDate) : Boolean;
begin
  {Assumptions: Labor Day is always first Monday of Sept}
  Result := IsOnAGivenDate(InDate, 9, 1, 2);
end;

class function TTLDateUtils.IsChristmasDay(InDate : TDate) : Boolean;
var
  M, D, Y : Word;
begin
  {Assumptions: Christmas is always on December 25th,
    But if Dec 25 falls on a weekend then we will check against Monday since
    it is observed officially on a weekday.}
  DecodeDate(InDate, Y, M, D);

  Result := (InDate = ObservedOnDay(EncodeDate(Y, 12, 25)));
end;

class function TTLDateUtils.IsNewYearsDay(InDate : TDate) : Boolean;
var
  M, D, Y : Word;
begin
  {Assumptions: New Years is always on January 1}
  DecodeDate(InDate, Y, M, D);
  Result := (InDate = ObservedOnDay(EncodeDate(Y, 1, 1)));
end;

class function TTLDateUtils.IsPresidentsDay(InDate : TDate) : Boolean;
begin
  {Assumptions: President's Day is always the 3rd Monday in February}
  Result := IsOnAGivenDate(InDate, 2, 3, 2);
end;

class function TTLDateUtils.IsMartinLutherKingDay(InDate : TDate) : Boolean;
begin
  {Assumptions: Martin Luther King ss always the 3rd Monday in January}
  Result := IsOnAGivenDate(InDate, 1, 3, 2);
end;

class function TTLDateUtils.IsIndependenceDay(InDate : TDate) : Boolean;
var
  M, D, Y : Word;
begin
  {Assumptions: Independence Day is always on July 4}
  DecodeDate(InDate, Y, M, D);
  Result := (InDate = ObservedOnDay(EncodeDate(Y, 7, 4)));
end;

class function TTLDateUtils.IsGoodFriday(InDate : TDate) : Boolean;
var
  Day, Month, Year, Century : Word;
  G, C, H, I : Integer;
begin
  {Since Easter Sunday is calculated based on the moon this is not a simple routine,
    I copied this from the internet and don't exactly know what it does or what
    principle it is based on but is seems to work}
  DecodeDate(InDate, Year, Day, Month);
  Day := 0;
  Month := 0;
  G := Year mod 19;
  Century := Trunc(Year / 100);
  H := (Century - Trunc(Century / 4) - Trunc((8 * Century + 13) / 25) + 19 * G + 15) mod 30;
  I := H - Trunc(h / 28) * (1 - Trunc(H / 28) * Trunc(29 / (H + 1)) * Trunc((21 - G) / 11));

  Day  := I - ((Year + Trunc(Year / 4) + I + 2 - Century + Trunc(Century / 4)) mod 7) + 28;
  Month := 3;

  if (day > 31) then
  begin
    Month := Month + 1;
    Day := Day - 31;
  end;

  {Subtract two days from Easter Sunday and compare}
  Result := (InDate = IncDay(EncodeDate(Year, Month, Day), - 2));
end;

class function TTLDateUtils.isOnLastOfGivenDay(InDate : TDate; Month : Word; DayOfWeek : Word) : Boolean;
var
  DT : TDate;
  M, D, Y : Word;
begin
  if not (Month in [1..12]) then
    raise Exception.Create('Month must be within 1 and 12');
  if not (DayOfWeek in [1..7]) then
    raise Exception.Create('Day Of Week must be within 1 and 7 where 1 is Sunday, 2 is Monday and so on.');

  DecodeDate(InDate, Y, M, D);
  if (M <> Month) then
    Exit(False);

  {Get the last day of the month and work backward until you get to the day of week}
  DT := EncodeDate(Y, M, DaysInMonth(InDate));

  while (SysUtils.DayOfWeek(DT) <>  DayOfWeek) do
    DT := IncDay(DT, -1);

  Result := (InDate = DT);

end;

class function TTLDateUtils.IsOnAGivenDate(InDate : TDate; Month : Word; Week : Word; DayOfWeek : Word) : Boolean;
var
  WeekIncrement : Integer;
  M, D, Y : Word;
  DT : TDate;
begin
  if not (Week in [1..4]) then
    raise Exception.Create('Week must be within 1 and 4');
  if not (Month in [1..12]) then
    raise Exception.Create('Month must be within 1 and 12');
  if not (DayOfWeek in [1..7]) then
    raise Exception.Create('Day Of Week must be within 1 and 7 where 1 is Sunday, 2 is Monday and so on.');

  DecodeDate(InDate, Y, M, D);
  if (M <> Month) then
    Exit(False);

  {Get First Day Of Month}
  DT := EncodeDate(Y, M, 1);

  {Drop one off of the week so we start at the beginning of the week}
  WeekIncrement := (Week - 1) * 7;

  {Increment so as to get to the start of the week
    This could be zero if they ask for Week 1. This routine
    does not look at physical weeks but just starts on the first and adds the minimum
    number of days to get to the first possible instance of the DayOfWeek in Week Number.
    Then it increments the date until it finds the appropriate day of week.
    the number of weeks into the month}
  if WeekIncrement > 0 then
     DT := IncDay(DT, WeekIncrement);
  while SysUtils.DayOfWeek(DT) <> DayOfWeek do
    DT := IncDay(DT);

  Result := (InDate = DT);

end;

end.
