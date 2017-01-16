unit GCP.API.Interfaces;

interface

uses
  GCP.API.Types;

type
  IGCPService = interface
    ['{475452AE-F7D8-4816-A84B-6FEBB8AC5095}']
  end;

  ILogger = interface
    ['{B92CD011-B050-4814-A35A-5C564DD701AA}']
    procedure Log(const Text: String; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;
    procedure Log(const Text: String; const Args: Array of const; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload;
  end;

  IAuthenticationService = interface(IGCPService)
    ['{760AA9A7-3590-4BCB-BE6D-643374321E31}']
    function Authenticate(const ServiceAccount, OAuthScope, PrivateKey: String; const ExpireSeconds: Cardinal): String;
  end;

  IGoogleAPI = interface
    ['{7782625C-5964-48EE-B96E-28E7D6061B11}']

  end;

implementation

end.
