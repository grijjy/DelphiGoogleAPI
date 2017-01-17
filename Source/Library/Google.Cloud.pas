unit Google.Cloud;

{ Google Cloud Platform APIs for Google Compute Engine instances }

interface

uses
  SysUtils, SyncObjs, Classes, IOUtils,

  Grijjy.Http,

  Google.Cloud.Interfaces;

type
  TGoogleCloud = class(TInterfacedObject, IGoogleCloud, ILogger)
  private
    FOAuthScope: String;
    FServiceAccount: String;
    FPrivateKeyFilename: String;
    FAccessTokenCS: TCriticalSection;
    FLastTokenTicks: Cardinal;
    FTokenExpiresTicks: Cardinal;
    FAccessToken: String;

    // Internal Services
    FLogger: ILogger;

    // Authentication
    FAuthenticationService: IGoogleCloudAuthentication;

    // Google Cloud Services
    FSpeechService: IGoogleCloudSpeech;

    function GetAccessToken: String;
  protected
    property AccessToken: String read GetAccessToken;
  protected
    // ILogger
    property Logger: ILogger read Flogger implements ILogger;
  protected
    // IGoogleCloud
    function Authentication: IGoogleCloudAuthentication;
    function Speech: IGoogleCloudSpeech;
  public
    constructor Create(
      Logger: ILogger;
      AuthenticationService: IGoogleCloudAuthentication;
      SpeechService: IGoogleCloudSpeech);
    destructor Destroy; override;

    procedure SetAccountProperties(const ServiceAccount, OAuthScope, PrivateKeyFilename: String);
  end;

implementation

uses
  Google.Cloud.Classes;

const
  DefaultTokenExpireSeconds = 3600;

{ TGoogle }

constructor TGoogleCloud.Create(
  Logger: ILogger;
  AuthenticationService: IGoogleCloudAuthentication;
  SpeechService: IGoogleCloudSpeech);
begin
  FAccessTokenCS := TCriticalSection.Create;
  FTokenExpiresTicks := 0;

  FLogger := Logger;
  FAuthenticationService := AuthenticationService;
  FSpeechService := SpeechService;
end;

destructor TGoogleCloud.Destroy;
begin
  FreeAndNil(FAccessTokenCS);

  inherited;
end;

procedure TGoogleCloud.SetAccountProperties(const ServiceAccount, OAuthScope,
  PrivateKeyFilename: String);
begin
  if (ServiceAccount <> FServiceAccount) or
     (OAuthScope <> FOAuthScope) or
     (PrivateKeyFilename <> FPrivateKeyFilename) then
  begin
    FServiceAccount := ServiceAccount;
    FOAuthScope := OAuthScope;
    FPrivateKeyFilename := PrivateKeyFilename;

    FLastTokenTicks := 0;
  end;
end;

function TGoogleCloud.Speech: IGoogleCloudSpeech;
begin
  Result := FSpeechService;
end;

{ See: https://developers.google.com/identity/protocols/OAuth2ServiceAccount#authorizingrequests for more details }
function TGoogleCloud.Authentication: IGoogleCloudAuthentication;
begin
  Result :=  FAuthenticationService;
end;

function TGoogleCloud.GetAccessToken: String;
begin
  FAccessTokenCS.Enter;
  try
    if (FLastTokenTicks = 0) or
       (TThread.GetTickCount >= FLastTokenTicks) then
    begin
      FLastTokenTicks := TThread.GetTickCount;

      FAccessToken := Authentication.Authenticate(
        FServiceAccount,
        FOAuthScope,
        TFile.ReadAllText(FPrivateKeyFilename),
        DefaultTokenExpireSeconds);

      FLastTokenTicks := TThread.GetTickCount + (DefaultTokenExpireSeconds * 1000) - 5000;
    end;

    Result := FAccessToken;
  finally
    FAccessTokenCS.Leave;
  end;
end;

end.
