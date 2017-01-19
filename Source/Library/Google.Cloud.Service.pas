unit Google.Cloud.Service;

interface

uses
  SysUtils, System.Diagnostics,

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

    function BuildGoogleCloudURL(const ServiceMethod: String): String; virtual;
    function Request(const RequestType: THTTPRequestType; const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode; virtual;

    procedure Log(const Text: String; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;
    procedure Log(const Text: String; const Args: Array of const; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;

    function Post(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer = DEFAULT_TIMEOUT_RECV): THTTPResponseCode;
    function Delete(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
    function Get(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
    function Options(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
    function Put(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;

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

function TGoogleCloudService.Get(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.POST,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Post(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.POST,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Put(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.POST,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Delete(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.POST,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Options(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.POST,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Request(const RequestType: THTTPRequestType;
  const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse;
  const ReceiveTimeout: Integer): THTTPResponseCode;
var
  HTTP: TgoHTTPClient;
  URL: String;
  StopWatch: TStopwatch;
begin
  Stopwatch := TStopwatch.Create;
  StopWatch.Reset;
  Stopwatch.Start;

  HTTP := TgoHTTPClient.Create;
  try
    HTTP.RequestBody := Contents;
    HTTP.Authorization := 'Bearer ' + GoogleCloud.GetAccessToken;

    URL := BuildGoogleCloudURL(ServiceMethod);

    case RequestType of
      THTTPRequestType.GET: HTTPResponse.Content := HTTP.Get(URL, ReceiveTimeout);
      THTTPRequestType.POST: HTTPResponse.Content := HTTP.Post(URL, ReceiveTimeout);
      THTTPRequestType.PUT: HTTPResponse.Content := HTTP.Put(URL, ReceiveTimeout);
      THTTPRequestType.DELETE: HTTPResponse.Content := HTTP.Delete(URL, ReceiveTimeout);
      THTTPRequestType.OPTIONS: HTTPResponse.Content := HTTP.Options(URL, ReceiveTimeout);
    else
      Assert(False, 'Invalid HTTP Request Type');
    end;

    HTTPResponse.Headers := HTTP.ResponseHeaders.Text;
    HTTPResponse.HTTPResponseCode := HTTP.ResponseStatusCode;

    Result := HTTP.ResponseStatusCode;

    HTTPResponse.ResponseTime := StopWatch.Elapsed;
  finally
    FreeAndNil(HTTP);
  end;
end;

end.
