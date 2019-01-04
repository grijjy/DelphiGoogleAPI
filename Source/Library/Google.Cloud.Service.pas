unit Google.Cloud.Service;

interface

uses
  SysUtils, System.Diagnostics, System.Threading, System.Classes,
  System.Net.URLClient, System.Net.HttpClient, System.Net.HttpClientComponent,

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

    function Post(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse;
      const ReceiveTimeout: Integer = DEFAULT_TIMEOUT_RECV): THTTPResponseCode; overload;
    procedure Post(const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse;
      const ResponseCallback: THTTPResponseCallback; const ReceiveTimeout: Integer = DEFAULT_TIMEOUT_RECV); overload;
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
  Result := format('https://%s.googleapis.com/%s/%s',
    [FServiceName,
     FServiceVersion,
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
    THTTPRequestType.GET,
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

procedure TGoogleCloudService.Post(const ServiceMethod, Contents: String;
  HTTPResponse: IHTTPResponse; const ResponseCallback: THTTPResponseCallback;
  const ReceiveTimeout: Integer);
var
  ResponseCode: THTTPResponseCode;
begin
  TTask.Run(
    procedure
    begin
      try
        ResponseCode := Post(
          ServiceMethod,
          Contents,
          HTTPResponse,
          ReceiveTimeout);

        ResponseCallback(
          ServiceMethod,
          Contents,
          HTTPResponse,
          nil,
          ResponseCode);
      except
        on e: Exception do
        begin
          ResponseCallback(
            ServiceMethod,
            Contents,
            HTTPResponse,
            e,
            -1);
        end;
      end;
    end
  );
end;

function TGoogleCloudService.Put(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.PUT,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Delete(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.DELETE,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Options(const ServiceMethod,
  Contents: String; HTTPResponse: IHTTPResponse; const ReceiveTimeout: Integer): THTTPResponseCode;
begin
  Result := Request(
    THTTPRequestType.OPTIONS,
    ServiceMethod,
    Contents,
    HTTPResponse,
    ReceiveTimeout);
end;

function TGoogleCloudService.Request(const RequestType: THTTPRequestType;
  const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse;
  const ReceiveTimeout: Integer): THTTPResponseCode;
var
  //Stream: TStringStream;
  //Response: TMemoryStream;
  NetHTTPClient: TgoHTTPClient;
  URL: String;
  StopWatch: TStopwatch;
begin
  Stopwatch := TStopwatch.Create;
  StopWatch.Reset;
  Stopwatch.Start;

  NetHTTPClient := TgoHTTPClient.Create;
  try
    NetHTTPClient.RequestBody := Contents;
    NetHTTPClient.Authorization := 'Bearer ' + GoogleCloud.GetAccessToken;

    URL := BuildGoogleCloudURL(ServiceMethod);

    case RequestType of
      THTTPRequestType.GET: HTTPResponse.Content := NetHTTPClient.Get(URL, ReceiveTimeout);
      THTTPRequestType.POST: HTTPResponse.Content := NetHTTPClient.Post(URL, ReceiveTimeout);
      THTTPRequestType.PUT: HTTPResponse.Content := NetHTTPClient.Put(URL, ReceiveTimeout);
      THTTPRequestType.DELETE: HTTPResponse.Content := NetHTTPClient.Delete(URL, ReceiveTimeout);
      THTTPRequestType.OPTIONS: HTTPResponse.Content := NetHTTPClient.Options(URL, ReceiveTimeout);
    else
      Assert(False, 'Invalid HTTP Request Type');
    end;

    HTTPResponse.Headers := NetHTTPClient.ResponseHeaders.AsString;
    HTTPResponse.HTTPResponseCode := NetHTTPClient.ResponseStatusCode;

    Result := NetHTTPClient.ResponseStatusCode;

    HTTPResponse.ResponseTime := StopWatch.Elapsed;
  finally
    FreeAndNil(NetHTTPClient);
  end;
end;

end.
