unit Google.Cloud;

{ Google Cloud Platform APIs for Google Compute Engine instances }

interface

uses
  SysUtils, SyncObjs, Classes, IOUtils,

  Grijjy.Http,
  Grijjy.Bson,

  Google.Cloud.Interfaces;

type
  TGoogleCloud = class(TInterfacedObject, IGoogleCloud, ILogger)
  private
    FOAuthScope: String;
    FServiceAccount: String;
    FPrivateKeyFilename: String;
    FPrivateKey: String;

    // Internal Services
    FLogger: ILogger;

    // Authentication
    FAuthenticationService: IGoogleCloudAuthentication;

    // Google Cloud Services
    FSpeechService: IGoogleCloudSpeech;

    procedure SaveSettings(const Filename: String);
    procedure LoadSettings(const Filename: String);
    function GetServiceAccount: String;
    function GetOAuthScope: String;
    function GetPrivateKeyFilename: String;
    function GetAccessToken: String;
  protected
    procedure InitializeGoogleCloud(const ServiceAccount, OAuthScope, PrivateKeyFilename: String);

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
  FLogger := Logger;
  FAuthenticationService := AuthenticationService;
  FSpeechService := SpeechService;
end;

destructor TGoogleCloud.Destroy;
begin

  inherited;
end;

procedure TGoogleCloud.SaveSettings(const Filename: String);
begin
  ForceDirectories(ExtractFileDir(Filename));

  TgoBsonDocument.Create.
    Add('serviceAccount', FServiceAccount).
    Add('oAuthScope', FOAuthScope).
    Add('privateKeyFilename', FPrivateKeyFilename).
    SaveToJsonFile(Filename);
end;

function TGoogleCloud.GetServiceAccount: String;
begin
  Result := FServiceAccount;
end;

procedure TGoogleCloud.InitializeGoogleCloud(const ServiceAccount, OAuthScope,
  PrivateKeyFilename: String);
begin
  if (ServiceAccount <> FServiceAccount) or
     (OAuthScope <> FOAuthScope) or
     (PrivateKeyFilename <> FPrivateKeyFilename) then
  begin
    FServiceAccount := ServiceAccount;
    FOAuthScope := OAuthScope;
    FPrivateKeyFilename := PrivateKeyFilename;
    FPrivateKey := TFile.ReadAllText(FPrivateKeyFilename);

    Authentication.ResetAccessToken;
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
  Result := Authentication.GetAccessToken(
    FServiceAccount,
    FOAuthScope,
    FPrivateKey,
    DefaultTokenExpireSeconds);
end;

procedure TGoogleCloud.LoadSettings(const Filename: String);
var
  Doc: TgoBsonDocument;
begin
  Doc := TgoBsonDocument.Create.LoadFromJsonFile(Filename);

  InitializeGoogleCloud(
    Doc['serviceAccount'],
    Doc['oAuthScope'],
    Doc['privateKeyFilename']
  );
end;

function TGoogleCloud.GetOAuthScope: String;
begin
  Result := FOAuthScope;
end;

function TGoogleCloud.GetPrivateKeyFilename: String;
begin
  Result := FPrivateKeyFilename;
end;

end.
