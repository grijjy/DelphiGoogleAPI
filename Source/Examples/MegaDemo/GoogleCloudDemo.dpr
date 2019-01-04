program GoogleCloudDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  Google.Cloud.Speech in '..\..\Library\Google.Cloud.Speech.pas',
  Google.Cloud in '..\..\Library\Google.Cloud.pas',
  Google.Cloud.Authentication in '..\..\Library\Google.Cloud.Authentication.pas',
  Google.Cloud.Interfaces in '..\..\Library\Google.Cloud.Interfaces.pas',
  Google.Cloud.Types in '..\..\Library\Google.Cloud.Types.pas',
  Google.Cloud.Service in '..\..\Library\Google.Cloud.Service.pas',
  Google.Cloud.Factory in '..\..\Library\Google.Cloud.Factory.pas',
  Google.Cloud.Logger in '..\..\Library\Google.Cloud.Logger.pas',
  Google.Cloud.Classes in '..\..\Library\Google.Cloud.Classes.pas',
  Google.Cloud.View.Main in 'Google.Cloud.View.Main.pas',
  Google.Cloud.PubSub in '..\..\Library\Google.Cloud.PubSub.pas',
  Google.Cloud.Network in '..\..\Library\Google.Cloud.Network.pas';

{$R *.res}

begin
  {$IFDEF DEBUG}
  ReportMemoryLeaksOnShutdown := True;
  {$ENDIF}

  Application.Initialize;
  Application.CreateForm(TfrmGCPMegaDemo, frmGCPMegaDemo);
  Application.Run;
end.
