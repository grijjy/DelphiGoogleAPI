unit Google.Cloud.View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  System.IOUtils,

  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl, FMX.Layouts,
  FMX.Controls.Presentation, System.Actions, FMX.ActnList,

  Google.Cloud.Types,
  Google.Cloud.Factory,
  Google.Cloud.Interfaces;

type
  TfrmGCPMegaDemo = class(TForm)
    gpAccountProperties: TGroupBox;
    Layout1: TLayout;
    tcService: TTabControl;
    tabSpeech: TTabItem;
    Layout2: TLayout;
    Text1: TText;
    Rectangle1: TRectangle;
    tcResults: TTabControl;
    tabNoResults: TTabItem;
    Text2: TText;
    tabError: TTabItem;
    lblErrorCode: TText;
    memError: TMemo;
    tabResults: TTabItem;
    layHeaders: TLayout;
    Text4: TText;
    memHeaders: TMemo;
    layContent: TLayout;
    Text5: TText;
    memContent: TMemo;
    layProperitesServiceAccount: TLayout;
    Text6: TText;
    edtServiceAccount: TEdit;
    layProperitesOAuthScope: TLayout;
    Text7: TText;
    edtOAuthScope: TEdit;
    layProperitesPEMFile: TLayout;
    Text8: TText;
    edtPEMFile: TEdit;
    Layout5: TLayout;
    btnPEMSelect: TButton;
    OpenDialog1: TOpenDialog;
    ActionList1: TActionList;
    actOpenPEMFile: TAction;
    Button1: TButton;
    lblStatus: TText;
    tabPubSub: TTabItem;
    Button2: TButton;
    edtPubSubTopic: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    edtPubSubData: TEdit;
    Button3: TButton;
    edtPubSubSubscription: TEdit;
    Label3: TLabel;
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenPEMFileExecute(Sender: TObject);
    procedure edtServiceAccountChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    FInitialized: Boolean;

    procedure ResizeControls;
    procedure UpdateGoogleCloudProperties;
    procedure ViewResponse(HTTPResponse: IHTTPResponse);
    function GetSettingsFilename: String;
  protected
    function GoogleCloud: IGoogleCloud;
  public
    { Public declarations }
  end;

var
  frmGCPMegaDemo: TfrmGCPMegaDemo;

implementation

{$R *.fmx}

procedure TfrmGCPMegaDemo.actOpenPEMFileExecute(Sender: TObject);
begin
  if OpenDialog1.Execute then
  begin
    edtPEMFile.Text := OpenDialog1.FileName;
  end;
end;

procedure TfrmGCPMegaDemo.Button1Click(Sender: TObject);
begin
  ViewResponse(GoogleCloud.Speech.SyncRecognize(
    TSpeechEncoding.FLAC,
    16000,
    'gs://cloud-samples-tests/speech/brooklyn.flac',
    'en-US')
  );
end;

procedure TfrmGCPMegaDemo.Button2Click(Sender: TObject);
var
  Attributes: Array of TKeyValue;
begin
  Setlength(Attributes, 2);

  Attributes[0].Name := 'test1';
  Attributes[0].Value := 'value1';
  Attributes[1].Name := 'test2';
  Attributes[1].Value := 'value2';

  ViewResponse(GoogleCloud.PubSub.Publish(
    edtPubSubTopic.Text,
    edtPubSubData.Text,
    Attributes)
  );
end;

procedure TfrmGCPMegaDemo.Button3Click(Sender: TObject);
var
  Response: IPubSubResponse;
begin
  Response := GoogleCloud.PubSub.Pull(edtPubSubSubscription.Text);

  ViewResponse(Response);

  GoogleCloud.PubSub.Acknowledge(edtPubSubSubscription.Text, Response);
end;

procedure TfrmGCPMegaDemo.ViewResponse(HTTPResponse: IHTTPResponse);
begin
  if HTTPResponse.HTTPResponseCode = 200 then
  begin
    tcResults.ActiveTab := tabResults;
    memHeaders.Text := HTTPResponse.Headers;
    memContent.Text := HTTPResponse.Content;
  end
  else
  begin
    tcResults.ActiveTab := tabError;
    lblErrorCode.Text := HTTPResponse.HTTPResponseCode.ToString;
    memError.Text := HTTPResponse.Headers;
  end;

  lblStatus.Text := 'Response time: ' + HTTPResponse.ResponseTime.ToString;
end;

procedure TfrmGCPMegaDemo.edtServiceAccountChange(Sender: TObject);
begin
  if FInitialized then
  begin
    UpdateGoogleCloudProperties;
  end;
end;

procedure TfrmGCPMegaDemo.UpdateGoogleCloudProperties;
begin
  GoogleCloud.InitializeGoogleCloud(
    edtServiceAccount.Text,
    edtOAuthScope.Text,
    edtPEMFile.Text);
end;

procedure TfrmGCPMegaDemo.FormCreate(Sender: TObject);
begin
  tcService.TabIndex := 0;
  tcResults.TabPosition := TTabPosition.None;
  tcResults.TabIndex := 0;

  if FileExists(GetSettingsFilename) then
  begin
    GoogleCloud.LoadSettings(GetSettingsFilename);

    edtServiceAccount.Text := GoogleCloud.GetServiceAccount;
    edtOAuthScope.Text := GoogleCloud.GetOAuthScope;
    edtPEMFile.Text := GoogleCloud.GetPrivateKeyFilename;
  end
  else
  begin
    UpdateGoogleCloudProperties;
  end;

  FInitialized := True;
end;

procedure TfrmGCPMegaDemo.FormDestroy(Sender: TObject);
begin
  GoogleCloud.SaveSettings(GetSettingsFilename);
end;

function TfrmGCPMegaDemo.GetSettingsFilename: String;
begin
  Result :=
    IncludeTrailingPathDelimiter(System.IOUtils.TPath.GetDocumentsPath) +
    IncludeTrailingPathDelimiter('DelphiGoogleCloud') +
    'config.json';
end;

procedure TfrmGCPMegaDemo.FormResize(Sender: TObject);
begin
  ResizeControls;
end;

function TfrmGCPMegaDemo.GoogleCloud: IGoogleCloud;
begin
  Result := TGoogleCloudFactory.GoogleCloud;
end;

procedure TfrmGCPMegaDemo.ResizeControls;
begin
  layProperitesServiceAccount.Width := gpAccountProperties.Width / 3;
  layProperitesOAuthScope.Width := gpAccountProperties.Width / 3;
  tcService.Width := Width / 2;
  layHeaders.Height := tcResults.Height / 2;
end;

end.
