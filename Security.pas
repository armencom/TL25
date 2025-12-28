unit Security;

interface

uses
  Winapi.Windows, System.SysUtils;

type
  TGUID = record
    D1: Cardinal;
    D2: Word;
    D3: Word;
    D4: array[0..7] of Byte;
  end;

  PWinTrustFileInfo = ^TWinTrustFileInfo;
  TWinTrustFileInfo = record
    cbStruct: Cardinal;
    pcwszFilePath: PWideChar;
    hFile: THandle;
    pgKnownSubject: ^TGUID;
  end;

  PWinTrustData = ^TWinTrustData;
  TWinTrustData = record
    cbStruct: Cardinal;
    pPolicyCallbackData: Pointer;
    pSIPClientData: Pointer;
    dwUIChoice: DWORD;
    fdwRevocationChecks: DWORD;
    dwUnionChoice: DWORD;
    pFile: PWinTrustFileInfo;
    dwStateAction: DWORD;
    hWVTStateData: THandle;
    pwszURLReference: PWideChar;
    dwProvFlags: DWORD;
    dwUIContext: DWORD;
  end;

const
  // WinTrust constants
  WTD_UI_NONE                     = $00000002;
  WTD_REVOKE_NONE                  = $00000000;
  WTD_CHOICE_FILE                  = $00000001;
  WTD_STATEACTION_IGNORE           = $00000000;
  WTD_PROV_FLAGS_REVOCATION_CHECK_NONE = $00000010;

  // Trust errors
  TRUST_E_NOSIGNATURE              = HRESULT($800B0100);
  TRUST_E_BAD_DIGEST                = HRESULT($80096010);
  CERT_E_UNTRUSTEDROOT              = HRESULT($800B0109);

function WinVerifyTrust(hWnd: HWND; const pgActionID: TGUID; pWVTData: Pointer): Longint; stdcall;
  external 'wintrust.dll';

function IsFileDigitallySigned(const FileName: string): Boolean;

implementation

function IsFileDigitallySigned(const FileName: string): Boolean;
var
  FileInfo: TWinTrustFileInfo;
  TrustData: TWinTrustData;
  WVTPolicyGUID: TGUID;
begin
  Result := False;

  // {00AAC56B-CD44-11d0-8CC2-00C04FC295EE} - standard WinTrust action GUID
  WVTPolicyGUID.D1 := $00AAC56B;
  WVTPolicyGUID.D2 := $CD44;
  WVTPolicyGUID.D3 := $11d0;
  WVTPolicyGUID.D4[0] := $8C;
  WVTPolicyGUID.D4[1] := $C2;
  WVTPolicyGUID.D4[2] := $00;
  WVTPolicyGUID.D4[3] := $C0;
  WVTPolicyGUID.D4[4] := $4F;
  WVTPolicyGUID.D4[5] := $C2;
  WVTPolicyGUID.D4[6] := $95;
  WVTPolicyGUID.D4[7] := $EE;

  // Setup file info
  FillChar(FileInfo, SizeOf(FileInfo), 0);
  FileInfo.cbStruct := SizeOf(FileInfo);
  FileInfo.pcwszFilePath := PWideChar(FileName);

  // Setup trust data
  FillChar(TrustData, SizeOf(TrustData), 0);
  TrustData.cbStruct := SizeOf(TrustData);
  TrustData.dwUIChoice := WTD_UI_NONE;
  TrustData.fdwRevocationChecks := WTD_REVOKE_NONE;
  TrustData.dwUnionChoice := WTD_CHOICE_FILE;
  TrustData.pFile := @FileInfo;
  TrustData.dwStateAction := WTD_STATEACTION_IGNORE;
  TrustData.dwProvFlags := WTD_PROV_FLAGS_REVOCATION_CHECK_NONE;

  // Call WinVerifyTrust
  Result := WinVerifyTrust(INVALID_HANDLE_VALUE, WVTPolicyGUID, @TrustData) = 0;
end;



end.
