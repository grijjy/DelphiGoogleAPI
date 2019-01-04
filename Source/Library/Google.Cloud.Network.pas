unit Google.Cloud.Network;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding, System.SyncObjs,
  System.Diagnostics,

  Grijjy.Http,
  Grijjy.JWT,

  XSuperObject,

  Google.Cloud.Interfaces,
  Google.Cloud.Types;

type
  TNetworkService = class
  private
    class function ClaimSet(const ServiceAccount, AScope: String;
      const ExpireSeconds: Cardinal): String; static;
  public
    class function Request(const RequestType: THTTPRequestType;
      const URL, Contents, AccessToken: String; HTTPResponse: IHTTPResponse;
      const ReceiveTimeout: Integer): THTTPResponseCode;
    class function Authenticate(const ServiceAccount,
  OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal; out Response: String): Integer;
  end;

implementation

class function TNetworkService.ClaimSet(const ServiceAccount, AScope: String; const ExpireSeconds: Cardinal): String;
var
  X: ISuperObject;
begin
  X := SO;

  X.S['iss'] := ServiceAccount;
  X.S['scope'] := AScope;
  X.S['aud'] := 'https://www.googleapis.com/oauth2/v4/token';
  X.I['exp'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(IncSecond(now, ExpireSeconds)));
  X.I['iat'] := DateTimeToUnix(TTimeZone.Local.ToUniversalTime(now));

  Result := X.AsJSON;
end;

class function TNetworkService.Authenticate(const ServiceAccount,
  OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal; out Response: String): Integer;
var
  HTTP: TgoHTTPClient;
  X: ISuperObject;
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
      Result := HTTP.ResponseStatusCode;
    finally
      HTTP.Free;
    end;
  end;
end;

class function TNetworkService.Request(const RequestType: THTTPRequestType;
  const URL, Contents, AccessToken: String; HTTPResponse: IHTTPResponse;
  const ReceiveTimeout: Integer): THTTPResponseCode;
var
  goHTTPClient: TgoHTTPClient;
begin
  goHTTPClient := TgoHTTPClient.Create;
  try
    goHTTPClient.RequestBody := Contents;
    goHTTPClient.Authorization := 'Bearer ' + AccessToken;

    case RequestType of
      THTTPRequestType.GET: HTTPResponse.Content := goHTTPClient.Get(URL, ReceiveTimeout);
      THTTPRequestType.POST: HTTPResponse.Content := goHTTPClient.Post(URL, ReceiveTimeout);
      THTTPRequestType.PUT: HTTPResponse.Content := goHTTPClient.Put(URL, ReceiveTimeout);
      THTTPRequestType.DELETE: HTTPResponse.Content := goHTTPClient.Delete(URL, ReceiveTimeout);
      THTTPRequestType.OPTIONS: HTTPResponse.Content := goHTTPClient.Options(URL, ReceiveTimeout);
    else
      Assert(False, 'Invalid HTTP Request Type');
    end;

    HTTPResponse.Headers := goHTTPClient.ResponseHeaders.AsString;
    HTTPResponse.HTTPResponseCode := goHTTPClient.ResponseStatusCode;

    Result := goHTTPClient.ResponseStatusCode;
  finally
    FreeAndNil(goHTTPClient);
  end;
end;

end.
