program DelphiGoogleAPIExample;

uses
  Vcl.Forms,
  FMain in 'FMain.pas' {FormMain},
  Google.API in '..\Google.API.pas',
  Grijjy.Http in '..\..\GrijjyFoundation\Grijjy.Http.pas',
  Grijjy.JWT in '..\..\GrijjyFoundation\Grijjy.JWT.pas',
  Grijjy.Bson in '..\..\GrijjyFoundation\Grijjy.Bson.pas',
  Grijjy.BinaryCoding in '..\..\GrijjyFoundation\Grijjy.BinaryCoding.pas',
  Grijjy.SocketPool.Win in '..\..\GrijjyFoundation\Grijjy.SocketPool.Win.pas',
  Grijjy.Uri in '..\..\GrijjyFoundation\Grijjy.Uri.pas',
  Grijjy.Collections in '..\..\GrijjyFoundation\Grijjy.Collections.pas',
  Grijjy.MemoryPool in '..\..\GrijjyFoundation\Grijjy.MemoryPool.pas',
  Grijjy.OpenSSL in '..\..\GrijjyFoundation\Grijjy.OpenSSL.pas',
  Grijjy.Winsock2 in '..\..\GrijjyFoundation\Grijjy.Winsock2.pas',
  Grijjy.OpenSSL.API in '..\..\GrijjyFoundation\Grijjy.OpenSSL.API.pas',
  Grijjy.Bson.IO in '..\..\GrijjyFoundation\Grijjy.Bson.IO.pas',
  Grijjy.DateUtils in '..\..\GrijjyFoundation\Grijjy.DateUtils.pas',
  Grijjy.SysUtils in '..\..\GrijjyFoundation\Grijjy.SysUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
