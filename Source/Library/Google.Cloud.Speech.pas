unit Google.Cloud.Speech;

interface

uses
  SysUtils, Classes, System.DateUtils, System.NetEncoding, JSON,

  Grijjy.Http,
  Grijjy.JWT,
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
      const ProfanityFilter: Boolean = False;
      const SpeechContext: TJSONString = ''): ISpeechSyncRecognizeResponse;
  public
    constructor Create; override;
  end;

implementation

uses
  Google.Cloud.Classes;

{ TSpeechService }

function TSpeechService.SyncRecognize(
      const SpeechEncoding: String;
      const SampleRate: TSpeechSampleRate;
      const AudioURI: String;
      const LanguageCode: String = TLanguageCode.en_US;
      const MaxAlternatives: Integer = 1;
      const ProfanityFilter: Boolean = False;
      const SpeechContext: TJSONString = ''): ISpeechSyncRecognizeResponse;
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
        Add('profanityFilter', ProfanityFilter)).
        //Add('speechContext', SpeechContext)).  { TODO : Fix }
      Add('audio', TgoBsonDocument.Create.
        Add('uri', AudioURI)).ToJSON,
    Result);
end;

constructor TSpeechService.Create;
begin
  inherited;

  ServiceName := 'speech';
  ServiceVersion := 'v1beta1';
end;

end.
