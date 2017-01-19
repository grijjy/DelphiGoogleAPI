unit Google.Cloud.Speech;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding, JSON,

  Grijjy.Bson,

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
      const ProfanityFilter: Boolean = False): ISpeechSyncRecognizeResponse; overload; virtual;
    function SyncRecognize(
      const SpeechEncoding: String;
      const SampleRate: TSpeechSampleRate;
      const AudioURI: String;
      const LanguageCode: String;
      const MaxAlternatives: Integer;
      const ProfanityFilter: Boolean;
      const SpeechContext: TgoBsonDocument): ISpeechSyncRecognizeResponse; overload; virtual;
  public
    constructor Create; override;
  end;

implementation

uses
  Google.Cloud.Classes;

{ TSpeechService }

constructor TSpeechService.Create;
begin
  inherited;

  ServiceName := 'speech';
  ServiceVersion := 'v1beta1';
end;

function TSpeechService.SyncRecognize(const SpeechEncoding: String;
  const SampleRate: TSpeechSampleRate; const AudioURI, LanguageCode: String;
  const MaxAlternatives: Integer;
  const ProfanityFilter: Boolean): ISpeechSyncRecognizeResponse;
begin
  Result := SyncRecognize(
    SpeechEncoding,
    SampleRate,
    AudioURI,
    LanguageCode,
    MaxAlternatives,
    ProfanityFilter,
    TgoBsonDocument.Create);
end;

function TSpeechService.SyncRecognize(const SpeechEncoding: String;
  const SampleRate: TSpeechSampleRate; const AudioURI, LanguageCode: String;
  const MaxAlternatives: Integer; const ProfanityFilter: Boolean;
  const SpeechContext: TgoBsonDocument): ISpeechSyncRecognizeResponse;
begin
  Result := TSpeechSyncRecognizeResponse.Create;

  POST(
    'syncrecognize',
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
    Result);
end;

end.
