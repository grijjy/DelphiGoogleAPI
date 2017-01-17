unit Google.Cloud.Service;

interface

uses
  SysUtils,

  Grijjy.Http,

  Google.Cloud,
  Google.Cloud.Types,
  Google.Cloud.Interfaces;

type
  TGoogleCloudService = class(TInterfacedObject)
  strict private
    FServiceVersion: String;
    FServiceName: String;


  protected
    function GoogleCloud: IGoogleCloud;

    function BuildGoogleCloudURL(const ServiceMethod: String): String;

    procedure Log(const Text: String; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;
    procedure Log(const Text: String; const Args: Array of const; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;

    function POST(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer = DEFAULT_TIMEOUT_RECV): THTTPResponseCode;

    property ServiceName: String read FServiceName write FServiceName;
    property ServiceVersion: String read FServiceVersion write FServiceVersion;
  public
    constructor Create; virtual;
  end;

implementation

uses
  Google.Cloud.Classes,
  Google.Cloud.Factory;

{ TGoogleCloudService }

function TGoogleCloudService.BuildGoogleCloudURL(const ServiceMethod: String): String;
begin
  Result := format('https://%s.googleapis.com/%s/%s:%s',
    [FServiceName,
     FServiceVersion,
     FServiceName,
     ServiceMethod]);
end;

constructor TGoogleCloudService.Create;
begin
  FServiceVersion := 'V1';
end;

function TGoogleCloudService.GoogleCloud: IGoogleCloud;
begin
  Result := TGoogleCloudFactory.GoogleCloud;
end;

procedure TGoogleCloudService.Log(const Text: String;
  const Severity: TLogSeverity; const Timestamp: TDateTime);
var
  Logger: ILogger;
begin
  if Supports(GoogleCloud, ILogger, Logger) then
  begin
    Logger.Log(Text, Severity, Timestamp);
  end;
end;

procedure TGoogleCloudService.Log(const Text: String;
  const Args: array of const; const Severity: TLogSeverity;
  const Timestamp: TDateTime);
var
  Logger: ILogger;
begin
  if Supports(GoogleCloud, ILogger, Logger) then
  begin
    Logger.Log(Text, Args, Severity, Timestamp);
  end;
end;

function TGoogleCloudService.POST(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
var
  HTTP: TgoHTTPClient;
begin
  HTTP := TgoHTTPClient.Create;
  try
    HTTP.RequestBody := Contents;
    HTTP.Authorization := 'Bearer ' + GoogleCloud.GetAccessToken;
    HTTPResponse.Content :=
      HTTP.Post(
        BuildGoogleCloudURL(ServiceMethod),
        ReceiveTimeout);
    HTTPResponse.Headers := HTTP.ResponseHeaders.Text;
    HTTPResponse.HTTPResponseCode := HTTP.ResponseStatusCode;

    Result := HTTP.ResponseStatusCode;
  finally
    FreeAndNil(HTTP);
  end;
end;

end.
