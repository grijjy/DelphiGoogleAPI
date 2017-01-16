program GCPMegaDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  GCP.Demo.View.Main in 'GCP.Demo.View.Main.pas' {frmGCPMegaDemo},
  Grijjy.Http in '..\..\..\..\GrijjyFoundation\Grijjy.Http.pas',
  Grijjy.JWT in '..\..\..\..\GrijjyFoundation\Grijjy.JWT.pas',
  Grijjy.Bson in '..\..\..\..\GrijjyFoundation\Grijjy.Bson.pas',
  Grijjy.BinaryCoding in '..\..\..\..\GrijjyFoundation\Grijjy.BinaryCoding.pas',
  Grijjy.SocketPool.Win in '..\..\..\..\GrijjyFoundation\Grijjy.SocketPool.Win.pas',
  Grijjy.Uri in '..\..\..\..\GrijjyFoundation\Grijjy.Uri.pas',
  Grijjy.Collections in '..\..\..\..\GrijjyFoundation\Grijjy.Collections.pas',
  Grijjy.MemoryPool in '..\..\..\..\GrijjyFoundation\Grijjy.MemoryPool.pas',
  Grijjy.OpenSSL in '..\..\..\..\GrijjyFoundation\Grijjy.OpenSSL.pas',
  Grijjy.Winsock2 in '..\..\..\..\GrijjyFoundation\Grijjy.Winsock2.pas',
  Grijjy.OpenSSL.API in '..\..\..\..\GrijjyFoundation\Grijjy.OpenSSL.API.pas',
  Grijjy.Bson.IO in '..\..\..\..\GrijjyFoundation\Grijjy.Bson.IO.pas',
  Grijjy.DateUtils in '..\..\..\..\GrijjyFoundation\Grijjy.DateUtils.pas',
  Grijjy.SysUtils in '..\..\..\..\GrijjyFoundation\Grijjy.SysUtils.pas',
  GCP.API.Service.Speech in '..\..\Library\GCP.API.Service.Speech.pas',
  GCP.API in '..\..\Library\GCP.API.pas',
  GCP.API.Service.Authentication in '..\..\Library\GCP.API.Service.Authentication.pas',
  GCP.API.Interfaces in '..\..\Library\GCP.API.Interfaces.pas',
  GCP.API.Types in '..\..\Library\GCP.API.Types.pas',
  GCP.API.Service in '..\..\Library\GCP.API.Service.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGCPMegaDemo, frmGCPMegaDemo);
  Application.Run;
end.
