unit Google.Cloud.Types;

interface

type
  // General
  THTTPResponseCode = Integer;
  TJSONString = String;

  TLogSeverity = (
    Default,
    Debug,
    Info,
    Notice,
    Warning,
    Error,
    Critical,
    Alert,
    Emergency
  );

  TLanguageCode = class
  public const
    en_US = 'en-US';
  end;

  // Speech
  TSpeechEncoding = class
  public const
    ENCODING_UNSPECIFIED = 'ENCODING_UNSPECIFIED';
    LINEAR16 = 'LINEAR16';
    FLAC = 'FLAC';
    MULAW = 'MULAW';
    AMR = 'AMR';
    AMR_WB = 'AMR_WB';
  end;

  TSpeechSampleRate = Integer;

implementation

end.
