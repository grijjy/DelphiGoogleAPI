unit GCP.API.Service;

interface

uses
  GCP.API;

type
  TgoGoogleService = class(TInterfacedObject)
  strict private
    FGoogleAPI: TgoGoogle;
  protected
    property GoogleAPI: TgoGoogle read FGoogleAPI;
  public
    constructor Create(const GoogleAPI: TgoGoogle); virtual;
  end;

implementation

{ TgoGoogleService }

constructor TgoGoogleService.Create(const GoogleAPI: TgoGoogle);
begin
  FGoogleAPI := GoogleAPI;
end;

end.
