unit GCP.API;

{ Google Cloud Platform APIs for Google Compute Engine instances }

interface

uses
  SysUtils, SyncObjs, Classes,

  Grijjy.Http,

  GCP.API.Interfaces;

type
  TGCPAPI = class(TInterfacedObject, IGoogleAPI)
  private
    { Google Cloud Account }
    FOAuthScope: String;
    FServiceAccount: String;
    FPrivateKey: String;
    FAccessTokenCS: TCriticalSection;
    FLastTokenTicks: Cardinal;
    FTokenExpiresTicks: Cardinal;
    FAccessToken: String;

    FLogger: ILogger;
    FAuthenticationService: IAuthenticationService;
  protected
    function GetAccessToken: String;
    procedure SetOAuthScope(const AValue: String);
    procedure SetPrivateKey(const AValue: String);
    procedure SetServiceAccount(const AValue: String);

    function RequestInternal(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
      const ARecvTimeout: Integer = DEFAULT_TIMEOUT_RECV): Integer;

    { Post a request to the Google Cloud APIs }
    function Post(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
      const ARecvTimeout: Integer = DEFAULT_TIMEOUT_RECV): Integer;

    function Logger: ILogger;
    function AuthenticationService: IAuthenticationService;
  public
    constructor Create(Logger: ILogger; AuthenticationService: IAuthenticationService);
    destructor Destroy; override;

    { Returns the current access token }
    property AccessToken: String read GetAccessToken;

    { Get or set the current engine scope }
    property OAuthScope: String read FOAuthScope write SetOAuthScope;

    { Get or set the current service account }
    property ServiceAccount: String read FServiceAccount write SetServiceAccount;

    { Get or set the current private key }
    property PrivateKey: String read FPrivateKey write SetPrivateKey;
  end;

implementation

const
  DefaultTokenExpireSeconds = 3600;

{ TGoogle }

constructor TGCPAPI.Create(Logger: ILogger;
  AuthenticationService: IAuthenticationService);
begin
  FAccessTokenCS := TCriticalSection.Create;
  FTokenExpiresTicks := 0;

  FLogger := Logger;
  FAuthenticationService := AuthenticationService;
end;

destructor TGCPAPI.Destroy;
begin
  FreeAndNil(FAccessTokenCS);

  inherited;
end;

procedure TGCPAPI.SetOAuthScope(const AValue: String);
begin
  if FOAuthScope <> AValue then
  begin
    FOAuthScope := AValue;

    FLastTokenTicks := 0;
  end;
end;

procedure TGCPAPI.SetServiceAccount(const AValue: String);
begin
  if FServiceAccount <> AValue then
  begin
    FServiceAccount := AValue;

    FLastTokenTicks := 0;
  end;
end;

procedure TGCPAPI.SetPrivateKey(const AValue: String);
begin
  if FPrivateKey <> AValue then
  begin
    FPrivateKey := AValue;

    FLastTokenTicks := 0;
  end;
end;

{ See: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests for more details }
function TGCPAPI.AuthenticationService: IAuthenticationService;
begin
  Result :=  FAuthenticationService;
end;

function TGCPAPI.GetAccessToken: String;
begin
  FAccessTokenCS.Enter;
  try
    if (FLastTokenTicks = 0) or
       (TThread.GetTickCount >= FLastTokenTicks) then
    begin
      FLastTokenTicks := TThread.GetTickCount;

      FAccessToken := AuthenticationService.Authenticate(
        FServiceAccount,
        FOAuthScope,
        FPrivateKey,
        DefaultTokenExpireSeconds);
    end
    else
    begin
      Result := FAccessToken;
    end;
  finally
    FAccessTokenCS.Leave;
  end;
end;

function TGCPAPI.Logger: ILogger;
begin
  Result := FLogger;
end;

function TGCPAPI.Post(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
  const ARecvTimeout: Integer): Integer;
var
  HTTP: TgoHTTPClient;
begin
  HTTP := TgoHTTPClient.Create;
  try
    HTTP.RequestBody := ARequest;
    HTTP.Authorization := 'Bearer ' + AccessToken;
    AResponseContent := HTTP.Post(AUrl, ARecvTimeout);
    AResponseHeaders := HTTP.ResponseHeaders.Text;
    Result := HTTP.ResponseStatusCode;
  finally
    HTTP.Free;
  end;
end;

function TGCPAPI.RequestInternal(const AUrl, ARequest: String;
  out AResponseHeaders, AResponseContent: String;
  const ARecvTimeout: Integer): Integer;
begin

end;

end.
