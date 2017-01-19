unit Google.Cloud.Classes;

interface

uses
  SysUtils, System.TimeSpan,

  Google.Cloud.Types,
  Google.Cloud.Interfaces;

type
  EGoogleCloudException = class(Exception);
  EGoogleCloudInvalidCredentials = class(EGoogleCloudException);
  EGoogleCloudAlreadyRegistered = class(EGoogleCloudException);

  THTTPResponse = class(TInterfacedObject, IHTTPResponse)
  strict private
    FHeaders: String;
    FContent: String;
    FHTTPResponseCode: THTTPResponseCode;
    FResponseTime: TTimeSpan;
  private
    function GetContent: String;
    function GetHeaders: String;
    procedure SetContent(const Value: String);
    procedure SetHeaders(const Value: String);
    function GetHTTPResponseCode: THTTPResponseCode;
    procedure SetHTTPResponseCode(const Value: THTTPResponseCode);
    function GetResponseTime: TTimeSpan;
    procedure SetResponseTime(const Value: TTimeSpan);
  protected
    property Headers: String read GetHeaders write SetHeaders;
    property Content: String read GetContent write SetContent;
    property HTTPResponseCode: THTTPResponseCode read GetHTTPResponseCode write SetHTTPResponseCode;
    property ResponseTime: TTimeSpan read GetResponseTime write SetResponseTime;
  end;

  TSpeechSyncRecognizeResponse = class(THTTPResponse, ISpeechSyncRecognizeResponse)
  strict private

  end;

implementation

{ THTTPResponse }

function THTTPResponse.GetContent: String;
begin
  Result := FContent;
end;

function THTTPResponse.GetHeaders: String;
begin
  Result := FHeaders;
end;

function THTTPResponse.GetHTTPResponseCode: THTTPResponseCode;
begin
  Result := FHTTPResponseCode;
end;

function THTTPResponse.GetResponseTime: TTimeSpan;
begin
  Result := FResponseTime;
end;

procedure THTTPResponse.SetContent(const Value: String);
begin
  FContent := Value;
end;

procedure THTTPResponse.SetHeaders(const Value: String);
begin
  FHeaders := Value;
end;

procedure THTTPResponse.SetHTTPResponseCode(const Value: THTTPResponseCode);
begin
  FHTTPResponseCode := Value;
end;

procedure THTTPResponse.SetResponseTime(const Value: TTimeSpan);
begin
  FResponseTime := Value;
end;

end.
