unit Google.Cloud;

{ Google Cloud Platform APIs for Google Compute Engine instances }

interface

uses
  SysUtils, SyncObjs, Classes, IOUtils,

  XSuperObject,

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
    FPubSubService: IGoogleCloudPubSub;

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
    function PubSub: IGoogleCloudPubSub;
  public
    constructor Create(Logger: ILogger; AuthenticationService: IGoogleCloudAuthentication;
      SpeechService: IGoogleCloudSpeech; PubSubService: IGoogleCloudPubSub);
    destructor Destroy; override;
  end;

implementation

uses
  Google.Cloud.Classes;

const
  DefaultTokenExpireSeconds = 3600;

{ TGoogle }

constructor TGoogleCloud.Create(Logger: ILogger; AuthenticationService: IGoogleCloudAuthentication;
  SpeechService: IGoogleCloudSpeech; PubSubService: IGoogleCloudPubSub);
begin
  FLogger := Logger;
  FAuthenticationService := AuthenticationService;
  FSpeechService := SpeechService;
  FPubSubService := PubSubService;
end;

destructor TGoogleCloud.Destroy;
begin

  inherited;
end;

procedure TGoogleCloud.SaveSettings(const Filename: String);
var
  X: ISuperObject;
begin
  ForceDirectories(ExtractFileDir(Filename));

  X := SO;

  X.S['serviceAccount'] := FServiceAccount;
  X.S['oAuthScope'] := FOAuthScope;
  X.S['privateKeyFilename'] := FPrivateKeyFilename;

  X.SaveTo(Filename, True);
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
  X: ISuperObject;
begin
  X := SO(TFile.ReadAllText(Filename));

  InitializeGoogleCloud(
    X.S['serviceAccount'],
    X.S['oAuthScope'],
    X.S['privateKeyFilename']
  );
end;

function TGoogleCloud.PubSub: IGoogleCloudPubSub;
begin
  Result := FPubSubService;
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
