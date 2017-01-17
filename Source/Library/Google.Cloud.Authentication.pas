unit Google.Cloud.Authentication;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding,

  Grijjy.Http,
  Grijjy.JWT,
  Grijjy.Bson,

  Google.Cloud.Service,
  Google.Cloud.Interfaces;

type
  TAuthenticationService = class(TGoogleCloudService, IGoogleCloudAuthentication)
  private
    FTokenExpiresInSec: Int64;
    FLastToken: String;

    function ClaimSet(const ServiceAccount, AScope: String; const ExpireSeconds: Cardinal): String;
  protected
    function Authenticate(const ServiceAccount, OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
  public
    constructor Create; override;
  end;

implementation

function TAuthenticationService.ClaimSet(const ServiceAccount, AScope: String; const ExpireSeconds: Cardinal): String;
var
  Doc: TgoBsonDocument;
begin
  Doc := TgoBsonDocument.Create;
  Doc['iss'] := ServiceAccount;
  Doc['scope'] := AScope;
  Doc['aud'] := 'https://www.googleapis.com/oauth2/v4/token';
  Doc['exp'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(IncSecond(now, ExpireSeconds)));
  Doc['iat'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(now));
  Result := Doc.ToJson;
end;

function TAuthenticationService.Authenticate(const ServiceAccount,
  OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
var
  HTTP: TgoHTTPClient;
  Response: String;
  Doc: TgoBsonDocument;
  JWT: String;
begin
  if JavaWebToken(
    BytesOf(PrivateKey),
    JWT_RS256,
    ClaimSet(
      ServiceAccount,
      OAuthScope,
      ExpireSeconds),
    JWT) then
  begin
    HTTP := TgoHTTPClient.Create;
    try
      HTTP.ContentType := 'application/x-www-form-urlencoded';
      HTTP.RequestBody :=
        'grant_type=' + TNetEncoding.URL.Encode('urn:ietf:params:oauth:grant-type:jwt-bearer') + '&' +
        'assertion=' + TNetEncoding.URL.Encode(JWT);

      Response := HTTP.Post('https://www.googleapis.com/oauth2/v4/token');

      if HTTP.ResponseStatusCode = 200 then
      begin
        Doc := TgoBsonDocument.Parse(Response);
        FTokenExpiresInSec := Doc['expires_in'];
        Result := Doc['access_token'];
        FLastToken := Result;
      end;
    finally
      HTTP.Free;
    end;
  end;
end;

constructor TAuthenticationService.Create;
begin
  inherited;

  FTokenExpiresInSec := 0;
end;

end.
