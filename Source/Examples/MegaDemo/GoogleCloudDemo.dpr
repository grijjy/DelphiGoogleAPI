program GoogleCloudDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
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
  Google.Cloud.Speech in '..\..\Library\Google.Cloud.Speech.pas',
  Google.Cloud in '..\..\Library\Google.Cloud.pas',
  Google.Cloud.Authentication in '..\..\Library\Google.Cloud.Authentication.pas',
  Google.Cloud.Interfaces in '..\..\Library\Google.Cloud.Interfaces.pas',
  Google.Cloud.Types in '..\..\Library\Google.Cloud.Types.pas',
  Google.Cloud.Service in '..\..\Library\Google.Cloud.Service.pas',
  Google.Cloud.Factory in '..\..\Library\Google.Cloud.Factory.pas',
  Google.Cloud.Logger in '..\..\Library\Google.Cloud.Logger.pas',
  Google.Cloud.Classes in '..\..\Library\Google.Cloud.Classes.pas',
  Google.Cloud.View.Main in 'Google.Cloud.View.Main.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmGCPMegaDemo, frmGCPMegaDemo);
  Application.Run;
end.
