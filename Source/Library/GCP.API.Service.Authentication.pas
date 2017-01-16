unit GCP.API.Service.Authentication;

interface

uses
  SysUtils, Classes, System.SysUtils,  System.DateUtils, System.NetEncoding,

  Grijjy.Http,
  Grijjy.JWT,
  Grijjy.Bson,

  GCP.API.Service,
  GCP.API.Interfaces;

type
  TGCPAuthenticationService = class(TgoGoogleService)
  private
    FAccessToken: String;
    FLastToken: TDateTime;
    FTokenExpiresInSec: Int64;
  public
    constructor Create(const GoogleAPI: TgoGoogle); override;

    procedure Authenticate;
  end;

implementation


procedure TGCPAuthenticationService.Authenticate;
begin
    if (FLastToken = -1) or
       (Now >= IncSecond(FLastToken, FTokenExpiresInSec - 5)) then { padding of 5 seconds }
    begin
      { new token }
      FLastToken := Now;
      FAccessToken := '';

      if JavaWebToken(
        BytesOf(FPrivateKey),
        JWT_RS256,
        ClaimSet(FOAuthScope, FLastToken),
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
            FAccessToken := Doc['access_token'];
          end;
        finally
          HTTP.Free;
        end;
      end;
    end;
end;

end.
