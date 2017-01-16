unit GCP.API.Logger;

interface

uses
  GCP.API.Interfaces,
  GCP.API.Types;

type
  TGCPLogger = class(TInterfacedObject, ILogger)
  protected
    procedure Log(const Text: String; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload; virtual;
    procedure Log(const Text: String; const Args: Array of const; const Severity: TLogSeverity = TLogSeverity.Info; const Timestamp: TDateTime = 0); overload; virtual;
  end;

implementation

{ TGCPLogger }

procedure TGCPLogger.Log(const Text: String; const Severity: TLogSeverity;
  const Timestamp: TDateTime);
begin
  // Implement in descendant class
end;

procedure TGCPLogger.Log(const Text: String; const Args: array of const;
  const Severity: TLogSeverity; const Timestamp: TDateTime);
begin
  // Implement in descendant class
end;

end.
