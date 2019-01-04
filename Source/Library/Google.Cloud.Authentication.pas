unit Google.Cloud.Authentication;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding, System.SyncObjs,

  XSuperObject,

  Google.Cloud.Types,
  Google.Cloud.Network,
  Google.Cloud.Service,
  Google.Cloud.Interfaces;

type
  TAuthenticationService = class(TGoogleCloudService, IGoogleCloudAuthentication)
  private
    FTokenExpiresInSec: Int64;
    FLastToken: String;
    FAccessTokenCS: TCriticalSection;
    FLastTokenTicks: Cardinal;
    FTokenExpiresTicks: Cardinal;
    FAccessToken: String;

    function GetAccessToken(const ServiceAccount, OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
    procedure ResetAccessToken;
  protected
    function Authenticate(const ServiceAccount, OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
  public
    constructor Create; override;
    destructor Destroy; override;
  end;

implementation

function TAuthenticationService.Authenticate(const ServiceAccount,
  OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
var
  Response: String;
  X: ISuperObject;
begin
  if TNetworkService.Authenticate(
    ServiceAccount,
    OAuthScope,
    PrivateKey,
    ExpireSeconds,
    Response) = 200 then
  begin
    X := SO(Response);
    FTokenExpiresInSec := X.I['expires_in'];
    Result := X.S['access_token'];
    FLastToken := Result;
  end
  else
  begin
    { TODO : Raise exception? }
    Result := '';
  end;
end;

function TAuthenticationService.GetAccessToken(const ServiceAccount,
  OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
begin
  FAccessTokenCS.Enter;
  try
    if (FLastTokenTicks = 0) or
       (TThread.GetTickCount >= FLastTokenTicks) then
    begin
      FLastTokenTicks := TThread.GetTickCount + (ExpireSeconds * 1000) - 5000;

      FAccessToken := Authenticate(
        ServiceAccount,
        OAuthScope,
        PrivateKey,
        ExpireSeconds);
    end;

    Result := FAccessToken;
  finally
    FAccessTokenCS.Leave;
  end;
end;

procedure TAuthenticationService.ResetAccessToken;
begin
  FLastTokenTicks := 0;
end;

constructor TAuthenticationService.Create;
begin
  inherited;

  FAccessTokenCS := TCriticalSection.Create;
  FTokenExpiresTicks := 0;
  FTokenExpiresInSec := 0;
end;

destructor TAuthenticationService.Destroy;
begin
  FreeAndNil(FAccessTokenCS);

  inherited;
end;

end.
