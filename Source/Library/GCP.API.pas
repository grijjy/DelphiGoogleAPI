unit GCP.API;

{ Google Cloud Platform APIs for Google Compute Engine instances }

interface

uses
  SysUtils, SyncObjs,

  Grijjy.Http,

  GCP.API.Interfaces;

type
  TgoGoogle = class
  private
    { Google Cloud Account }
    FOAuthScope: String;
    FServiceAccount: String;
    FPrivateKey: String;
    FAccessTokenCS: TCriticalSection;

    FGCPAuthenticationAPI: IGCPAuthenticationService;
  protected
    function ClaimSet(const AScope: String; const ADateTime: TDateTime): String;
    function GetAccessToken: String;
    procedure SetOAuthScope(const AValue: String);
    procedure SetPrivateKey(const AValue: String);
    procedure SetServiceAccount(const AValue: String);
  public
    constructor Create;
    destructor Destroy; override;
  public
    { Post a request to the Google Cloud APIs }
    function Post(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
      const ARecvTimeout: Integer = DEFAULT_TIMEOUT_RECV): Integer;
  public
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

{ TGoogle }

constructor TgoGoogle.Create;
begin
  FAccessTokenCS := TCriticalSection.Create;

  FLastToken := -1;
  FTokenExpiresInSec := 0;
end;

destructor TgoGoogle.Destroy;
begin
  FreeAndNil(FAccessTokenCS);

  inherited;
end;

procedure TgoGoogle.SetOAuthScope(const AValue: String);
begin
  FOAuthScope := AValue;
  FLastToken := -1; { create new access token on next request }
end;

procedure TgoGoogle.SetServiceAccount(const AValue: String);
begin
  FServiceAccount := AValue;
  FLastToken := -1; { create new access token on next request }
end;

procedure TgoGoogle.SetPrivateKey(const AValue: String);
begin
  FPrivateKey := AValue;
  FLastToken := -1; { create new access token on next request }
end;

{ See: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests for more details }
function TgoGoogle.ClaimSet(const AScope: String; const ADateTime: TDateTime): String;
var
  Doc: TgoBsonDocument;
begin
  Doc := TgoBsonDocument.Create;
  Doc['iss'] := FServiceAccount;
  Doc['scope'] := AScope;
  Doc['aud'] := 'https://www.googleapis.com/oauth2/v4/token';
  Doc['exp'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(IncSecond(ADateTime, 3600))); { expires in one hour }
  Doc['iat'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(ADateTime));
  Result := Doc.ToJson;
end;

function TgoGoogle.GetAccessToken: String;
var
  HTTP: TgoHTTPClient;
  Response: String;
  Doc: TgoBsonDocument;
  JWT: String;
begin
  FAccessTokenCS.Enter;
  try
    Result := FAccessToken;
  finally
    FAccessTokenCS.Leave;
  end;
end;

function TgoGoogle.Post(const AUrl, ARequest: String; out AResponseHeaders, AResponseContent: String;
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

end.
