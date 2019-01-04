unit Google.Cloud.Speech;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding, JSON,

  XSuperObject,

  Google.Cloud.Types,
  Google.Cloud.Service,
  Google.Cloud.Interfaces;

type
  TSpeechService = class(TGoogleCloudService, IGoogleCloudSpeech)
  protected
    function SyncRecognize(
      const SpeechEncoding: String;
      const SampleRate: TSpeechSampleRate;
      const AudioURI: String;
      const LanguageCode: String = TLanguageCode.en_US;
      const MaxAlternatives: Integer = 1;
      const ProfanityFilter: Boolean = False): ISpeechRecognizeResponse; overload; virtual;
    function SyncRecognize(
      const SpeechEncoding: String;
      const SampleRate: TSpeechSampleRate;
      const AudioURI: String;
      const LanguageCode: String;
      const MaxAlternatives: Integer;
      const ProfanityFilter: Boolean;
      const SpeechContext: String): ISpeechRecognizeResponse; overload; virtual;
  public
    constructor Create; override;
  end;

implementation

uses
  Google.Cloud.Classes;

type
  TSpeechRecognizeResponse = class(THTTPResponse, ISpeechRecognizeResponse);

{ TSpeechService }

constructor TSpeechService.Create;
begin
  inherited;

  ServiceName := 'speech';
  ServiceVersion := 'v1beta1';
end;

function TSpeechService.SyncRecognize(const SpeechEncoding: String;
  const SampleRate: TSpeechSampleRate; const AudioURI, LanguageCode: String;
  const MaxAlternatives: Integer; const ProfanityFilter: Boolean): ISpeechRecognizeResponse;
begin
  Result := SyncRecognize(
    SpeechEncoding,
    SampleRate,
    AudioURI,
    LanguageCode,
    MaxAlternatives,
    ProfanityFilter,
    '');
end;

function TSpeechService.SyncRecognize(const SpeechEncoding: String;
  const SampleRate: TSpeechSampleRate; const AudioURI, LanguageCode: String;
  const MaxAlternatives: Integer; const ProfanityFilter: Boolean;
  const SpeechContext: String): ISpeechRecognizeResponse;
var
  X: ISuperObject;
begin
  Result := TSpeechRecognizeResponse.Create;

  X := SO;

  X.O['config'].S['encoding'] := SpeechEncoding;
  X.O['config'].I['sampleRate'] := SampleRate;
  X.O['config'].S['languageCode'] := LanguageCode;
  X.O['config'].I['maxAlternatives'] := MaxAlternatives;
  X.O['config'].B['profanityFilter'] := ProfanityFilter;
  X.O['config'].O['speechContext'];
  X.O['audio'].S['uri'] := AudioURI;

  POST(
    'speech:syncrecognize',
    X.AsJSON,
    Result);
(*
  POST(
    'speech:syncrecognize',
    TgoBsonDocument.Create.
      Add('config', TgoBsonDocument.Create.
        Add('encoding', SpeechEncoding).
        Add('sampleRate', SampleRate).
        Add('languageCode', LanguageCode).
        Add('maxAlternatives', MaxAlternatives).
        Add('profanityFilter', ProfanityFilter).
        Add('speechContext', SpeechContext)).
      Add('audio', TgoBsonDocument.Create.
        Add('uri', AudioURI)).ToJSON,
    Result);  *)
end;

end.
