unit TLImportReadMethods;

interface

{$M+}

uses Classes, SysUtils, Import, importCSV;

type
  TFunctionType = function() : Integer of object;
  EImportReadMethodsException = class(Exception);

  TImportReadMethods = class(TObject)
  public
    function Call(MethodName : String) : Integer;
  published
    {Test method for Unit Test. Just allows us to verify that the Call method is working correctly.
     also allows us to test the Import method of the TLImportFilter object}
    function ReadTestMethod() : Integer;
    {End of Read Test Method DO NOT DELETE}

    function ReadAllyInvest():Integer;
    function ReadAmeritrade():Integer;
    function ReadAssent():Integer;
    function ReadBOA():Integer;

    function ReadCenterpoint():Integer;
    function ReadAxos():Integer;
    function ReadCobra():Integer;
    function ReadCurvature():Integer;

    function ReadeRegal():Integer;
    function ReadETC():Integer;
    function ReadETrade():Integer;
    function ReadExcel():Integer;

    function ReadFidelity():Integer;

    function ReadFolioFN():Integer;
    function ReadGlobex():Integer;
    function ReadGoldmanSachs():Integer;

    function ReadHarris():Integer;
    function ReadHilltop():Integer;

    function ReadIB():Integer;
    function ReadInvestrade():Integer;

    function readJPMorganChase(): integer;
    function ReadJPR():Integer;

    function ReadLightspeed():Integer;
    function ReadMorganStanley(): integer;
    function ReadNinja(): integer;

    function ReadOpenECry():Integer;

    function ReadPenson():Integer;
    function ReadPershing():Integer;
    function ReadPreferred():Integer;
    function ReadProTrader():Integer;

    function ReadQIF():Integer;
    function ReadQFX():Integer;

    function ReadRydexRFS():Integer;

    function ReadRobinhood():Integer;

    function ReadSchwab():Integer;
    function ReadScottrade():Integer;

    function ReadSWS():Integer;
    function ReadSLK():Integer;

    function ReadTerra():Integer;

    function ReadTOS():Integer;

    function Readtastyworks():Integer;
    function ReadTradeStation():Integer;

    function ReadTRowe():Integer;
    function ReadTradeMonster():Integer;
    function ReadTradeZero():Integer;

    function ReadUNX():Integer;

    function ReadVanguard():Integer;
    function ReadVision():Integer;

//    function ReadPlaid():Integer;

    function ReadPaste():Integer;
  end;


implementation

{ TFilterReadMethods }

function TImportReadMethods.Call(MethodName: String): Integer;
var
  ReadFunc : TFunctionType;
begin
  try
    TMethod(ReadFunc).Code := Self.MethodAddress(MethodName);
    TMethod(ReadFunc).Data := pointer(Self);
    if Not Assigned(TMethod(ReadFunc).Code) then
      raise EImportReadMethodsException.Create('Method does not exist: ' + MethodName);
    Result := ReadFunc;
  finally
    // TImportReadMethods.Call
  end;
end;


function TImportReadMethods.ReadAmeritrade: Integer;
begin
   Result := Import.ReadAmeritrade;
end;

function TImportReadMethods.ReadAssent: Integer;
begin
  Result := Import.ReadAssent;
end;

function TImportReadMethods.ReadBOA: Integer;
begin
  Result := Import.ReadBOA;
end;


function TImportReadMethods.ReadCenterpoint():Integer;
begin
  Result := Import.ReadCenterpoint();
end;

function TImportReadMethods.ReadAxos: Integer;
begin
  Result := ImportCSV.ReadAxos();
end;

function TImportReadMethods.ReadCobra: Integer;
begin
  Result := Import.ReadCobra;
end;

function TImportReadMethods.ReadCurvature():Integer;
begin
  Result := Import.ReadCurvature();
end;


function TImportReadMethods.ReadeRegal: Integer;
begin
  Result := Import.ReadeRegal;
end;

function TImportReadMethods.ReadETC: Integer;
begin
  Result := ImportCSV.ReadETC;
end;

function TImportReadMethods.ReadETrade: Integer;
begin
  Result := Import.ReadETrade;
end;

function TImportReadMethods.ReadExcel: Integer;
begin
  Result := Import.ReadExcel;
end;

function TImportReadMethods.ReadFidelity: Integer;
begin
  Result := Import.ReadFidelity;
end;

function TImportReadMethods.ReadFolioFN: Integer;
begin
  Result := Import.ReadFolioFN;
end;

function TImportReadMethods.ReadGlobex: Integer;
begin
  Result := Import.ReadGlobex;
end;

function TImportReadMethods.ReadGoldmanSachs: Integer;
begin
  Result := Import.ReadGoldmanSachs;
end;

function TImportReadMethods.ReadHarris: Integer;
begin
  Result := Import.ReadHarris;
end;

function TImportReadMethods.ReadHilltop: Integer;
begin
  Result := Import.ReadHilltop;
end;

function TImportReadMethods.ReadIB: Integer;
begin
  Result := Import.ReadIB;
end;

function TImportReadMethods.ReadInvestrade: Integer;
begin
  Result := Import.ReadInvestrade;
end;

function TImportReadMethods.readJPMorganChase: integer;
begin
  Result := Import.ReadJPMorganChase;
end;

function TImportReadMethods.ReadJPR: Integer;
begin
  Result := Import.ReadJPR;
end;

function TImportReadMethods.ReadLightspeed: integer;
begin
  Result := Import.ReadLightspeed;
end;

function TImportReadMethods.ReadMorganStanley;
begin
  Result := Import.ReadMorganStanley;
end;

function TImportReadMethods.readNinja: integer;
begin
  Result := Import.ReadNinja;
end;


function TImportReadMethods.ReadOpenECry: Integer;
begin
  Result := Import.ReadOpenECry;
end;

function TImportReadMethods.ReadPaste: Integer;
begin
  Result := Import.ReadPaste;
end;

function TImportReadMethods.ReadPenson: Integer;
begin
  Result := Import.ReadPenson;
end;

function TImportReadMethods.ReadPershing: Integer;
begin
  Result := Import.ReadPershing;
end;

function TImportReadMethods.ReadPreferred: Integer;
begin
  Result := Import.ReadPreferred;
end;

function TImportReadMethods.ReadProTrader: Integer;
begin
  Result := Import.ReadProTrader;
end;

function TImportReadMethods.ReadQFX: Integer;
begin
  Result := Import.ReadQFX;
end;

function TImportReadMethods.ReadQIF: Integer;
begin
  Result := Import.ReadQIF;
end;


function TImportReadMethods.ReadRydexRFS: Integer;
begin
  Result := Import.ReadRydexRFS;
end;

function TImportReadMethods.ReadRobinhood: Integer;
begin
  Result := Import.ReadRobinhood;
end;

function TImportReadMethods.ReadSchwab: Integer;
begin
  Result := Import.ReadSchwab;
end;

function TImportReadMethods.ReadScottrade: Integer;
begin
  Result := Import.ReadScottrade;
end;

function TImportReadMethods.ReadSLK: Integer;
begin
  Result := Import.ReadSLK;
end;

function TImportReadMethods.ReadSWS: Integer;
begin
  Result := Import.ReadSWS;
end;

function TImportReadMethods.Readtastyworks: Integer;
begin
  Result := Import.Readtastyworks;
end;

function TImportReadMethods.ReadAllyInvest: Integer;
begin
  Result := Import.ReadAllyInvest;
end;


function TImportReadMethods.ReadTerra: Integer;
begin
  Result := Import.ReadTerra;
end;

function TImportReadMethods.ReadTestMethod: Integer;
begin
  Result := 10;
end;

function TImportReadMethods.ReadTOS: Integer;
begin
  Result := Import.ReadTOS;
end;

function TImportReadMethods.ReadTradeMonster: Integer;
begin
  Result := Import.ReadTradeMonster;
end;

function TImportReadMethods.ReadTradeStation: Integer;
begin
  Result := Import.ReadTradeStation;
end;

function TImportReadMethods.ReadTradeZero: Integer;
begin
  Result := Import.ReadTradeZero;
end;

function TImportReadMethods.ReadTRowe: Integer;
begin
  Result := Import.ReadTRowe;
end;

function TImportReadMethods.ReadUNX: Integer;
begin
  Result := Import.ReadUNX;
end;

function TImportReadMethods.ReadVanguard: Integer;
begin
  Result := Import.ReadVanguard;
end;

function TImportReadMethods.ReadVision: Integer;
begin
  Result := Import.ReadVision;
end;

//function TImportReadMethods.ReadPlaid: Integer;
//begin
//  Result := Import.ReadPlaid;
//end;

end.
