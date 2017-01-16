unit GCP.API.Factory;

interface

uses
  GCP.API.Interfaces;

type
  TGoogleAPIFactory = class
  strict private
    class var FGoogleAPI: IGoogleAPI;
    class var FLogger: ILogger;
    class var FAuthenticationService: IAuthenticationService;
  private
    class procedure CheckAPINotRegistered;

    class procedure SetAuthenticationService(const Value: IAuthenticationService); static;
    class procedure SetLogger(const Value: ILogger); static;
  public
    class constructor Create;

    class function GoogleAPI: IGoogleAPI;

    class property AuthenticationService: IAuthenticationService write SetAuthenticationService;
    class property Logger: ILogger write SetLogger;
  end;

implementation

uses
  GCP.API,
  GCP.API.Classes,
  GCP.API.Logger,
  GCP.API.Service.Authentication;

resourcestring
  StrPleaseDefineTheGPC = 'Please define the GPC API Interfaces before calling GoogleAPI';

{ TGoogleAPIFactory }

class procedure TGoogleAPIFactory.CheckAPINotRegistered;
begin
  if FGoogleAPI <> nil then
  begin
    raise EGCPAPIAlreadyRegistered.Create(StrPleaseDefineTheGPC);
  end;
end;

class constructor TGoogleAPIFactory.Create;
begin
  FLogger := TGCPLogger.Create;
  FAuthenticationService := TAuthenticationService.Create;
end;

class function TGoogleAPIFactory.GoogleAPI: IGoogleAPI;
begin
  if FGoogleAPI = nil then
  begin
    FGoogleAPI := TGCPAPI.Create(
      FLogger,
      FAuthenticationService
    );
  end;

  Result := FGoogleAPI;
end;

class procedure TGoogleAPIFactory.SetAuthenticationService(
  const Value: IAuthenticationService);
begin
  CheckAPINotRegistered;

  FAuthenticationService := Value;
end;

class procedure TGoogleAPIFactory.SetLogger(const Value: ILogger);
begin
  CheckAPINotRegistered;

  FLogger := Value;
end;

end.
