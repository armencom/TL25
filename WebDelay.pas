unit WebDelay;

interface

uses
  Windows, Forms, VCL.dialogs;

type
  TDelayResult = (drNone, drTimeout, drDocumentComplete);
  TBrowserDelayEvent = (deNoEvent, deOtherEvent, deBeforeNavigate,
    deDocumentComplete, deDownloadBegin, deDownloadComplete, deProgressChange,
    deNewWindow2, deNewWindow3, deProtocolEvent);

  TBrowserLoadDelay = class(TObject)
  private
    FLastEvent: TBrowserDelayEvent;
    FTickStart, FTimeout, FWaitedMS: Integer;
  public
    procedure UpdateEvent(const AEvent: TBrowserDelayEvent);
    function WaitForLoad(): TDelayResult;

    constructor Create(const ATimeoutInMS: Integer);
    destructor Destroy();

    property Timeout: Integer read FTimeout write FTimeout;
    property WaitedMS: Integer read FWaitedMS;
  end;

//var
  //FBrowserDelay : TBrowserLoadDelay;

implementation

constructor TBrowserLoadDelay.Create(const ATimeoutInMS: Integer);
begin
  inherited Create();

  //set default timeout to passed value
  FTimeout   := ATimeoutInMS;

  //configured to a "No event" value
  FLastEvent := deNoEvent;

  //tick start will get updated when WaitForLoad() is called, but it just
  //feels better to initialize everything. ;)
  FTickStart := 0;
end;

destructor TBrowserLoadDelay.Destroy();
begin
  inherited Destroy();
end;

procedure TBrowserLoadDelay.UpdateEvent(const AEvent: TBrowserDelayEvent);
begin
  //when updating event, update the "start" timer so we can restart the
  //entry point of the delay
  if (AEvent <> FLastEvent) then
  begin
    FTickStart := GetTickCount();
    FWaitedMS  := 0;
  end;

  //update the event now
  FLastEvent := AEvent;
end;

function TBrowserLoadDelay.WaitForLoad(): TDelayResult;
begin
  //start the TickStart timer to when we started waiting.
  FWaitedMS  := 1;
  FTickStart := GetTickCount();

  //repeat until we've hit a time-out, then from that point figure out what
  //to do from there
  while (FWaitedMS < FTimeout) do
  begin
    //prevent application hangs
    Application.ProcessMessages();

    //waited time in milliseconds is current tick minus the tick start.
    //this tick start can be updated real-time via UpdateEvent().
    FWaitedMS := GetTickCount() - FTickStart;
  end;

  //if we timed out, then set the result accordingly. If we timed out and the
  //last event is a NavComplete, then we can assume that the navigation
  //finished properly
  if (FLastEvent = deDocumentComplete) then
    Result := drDocumentComplete
  else
    Result := drTimeout;

  //update to 0 for property-sake.. when we return from this function, we have
  //always waited FTimeout milliseconds, so we do not need to use FWaitedMS to
  //find out how long we've been waiting.
  FWaitedMS := 0;
end;

end.
