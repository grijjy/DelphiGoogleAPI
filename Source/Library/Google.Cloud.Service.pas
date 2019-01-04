unit Google.Cloud.Service;

interface

uses
  SysUtils, System.Diagnostics, System.Threading, System.Classes,

  Google.Cloud,
  Google.Cloud.Network,
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
    function Request(const RequestType: THTTPRequestType;
  const ServiceMethod, Contents: String; HTTPResponse: IHTTPResponse;
  const ReceiveTimeout: Integer): THTTPResponseCode; virtual;

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
  StopWatch: TStopwatch;
begin
  Stopwatch := TStopwatch.Create;
  StopWatch.Reset;
  Stopwatch.Start;

  Result := TNetworkService.Request(
    RequestType,
    BuildGoogleCloudURL(ServiceMethod),
    Contents,
    GoogleCloud.GetAccessToken,
    HTTPResponse,
    ReceiveTimeout);

  HTTPResponse.ResponseTime := StopWatch.Elapsed;
end;

end.
