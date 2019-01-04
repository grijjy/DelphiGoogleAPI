unit Google.Cloud.Factory;

interface

uses
  Google.Cloud.Interfaces;

type
  TGoogleCloudFactory = class
  strict private
    class var FGoogleCloud: IGoogleCloud;
    class var FLogger: ILogger;
    class var FAuthenticationService: IGoogleCloudAuthentication;
    class var FSpeechService: IGoogleCloudSpeech;
    class var FPubSubService: IGoogleCloudPubSub;
  private
    class procedure CheckAPINotRegistered;

    class procedure SetAuthenticationService(const Value: IGoogleCloudAuthentication); static;
    class procedure SetLogger(const Value: ILogger); static;
    class procedure SetSpeechService(const Value: IGoogleCloudSpeech); static;
  public
    class constructor Create;

    class function GoogleCloud: IGoogleCloud;

    class property AuthenticationService: IGoogleCloudAuthentication write SetAuthenticationService;
    class property Logger: ILogger write SetLogger;
    class property SpeechService: IGoogleCloudSpeech write SetSpeechService;
  end;

implementation

uses
  Google.Cloud,
  Google.Cloud.Classes,
  Google.Cloud.Logger,
  Google.Cloud.Authentication,
  Google.Cloud.Speech,
  Google.Cloud.PubSub;

resourcestring
  StrPleaseDefineTheGPC = 'Please define the GPC API Interfaces before calling GoogleCloud';

{ TGoogleCloudFactory }

class procedure TGoogleCloudFactory.CheckAPINotRegistered;
begin
  if FGoogleCloud <> nil then
  begin
    raise EGoogleCloudAlreadyRegistered.Create(StrPleaseDefineTheGPC);
  end;
end;

class constructor TGoogleCloudFactory.Create;
begin
  FLogger := TLogger.Create;
  FAuthenticationService := TAuthenticationService.Create;
  FSpeechService := TSpeechService.Create;
  FPubSubService := TPubSubService.Create;
end;

class function TGoogleCloudFactory.GoogleCloud: IGoogleCloud;
begin
  if FGoogleCloud = nil then
  begin
    FGoogleCloud := TGoogleCloud.Create(
      FLogger,
      FAuthenticationService,
      FSpeechService,
      FPubSubService
    );
  end;

  Result := FGoogleCloud;
end;

class procedure TGoogleCloudFactory.SetAuthenticationService(
  const Value: IGoogleCloudAuthentication);
begin
  CheckAPINotRegistered;

  FAuthenticationService := Value;
end;

class procedure TGoogleCloudFactory.SetLogger(const Value: ILogger);
begin
  CheckAPINotRegistered;

  FLogger := Value;
end;

class procedure TGoogleCloudFactory.SetSpeechService(
  const Value: IGoogleCloudSpeech);
begin
  CheckAPINotRegistered;

  FSpeechService := Value;
end;

end.
