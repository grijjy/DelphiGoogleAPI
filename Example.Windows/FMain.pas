unit FMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  System.IOUtils,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Google.API;

type
  TFormMain = class(TForm)
    GroupBoxRequest: TGroupBox;
    LabelOAuthScope: TLabel;
    LabelUrl: TLabel;
    LabelRequest: TLabel;
    ButtonPost: TButton;
    EditOAuthScope: TEdit;
    EditUrl: TEdit;
    MemoRequestContent: TMemo;
    GroupBoxResponse: TGroupBox;
    MemoResponseHeaders: TMemo;
    MemoResponseContent: TMemo;
    LabelResponseContent: TLabel;
    LabelResponseHeaders: TLabel;
    EditServiceAccount: TEdit;
    LabelServiceAccount: TLabel;
    ButtonBrowse: TButton;
    LabelPEM: TLabel;
    EditPEM: TEdit;
    OpenDialog1: TOpenDialog;
    procedure ButtonPostClick(Sender: TObject);
    procedure ButtonBrowseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.ButtonBrowseClick(Sender: TObject);
begin
  if OpenDialog1.Execute then
    EditPEM.Text := OpenDialog1.FileName;
end;

procedure TFormMain.ButtonPostClick(Sender: TObject);
var
  Google: TgoGoogle;
  ResponseHeaders, ResponseContent: String;
begin
  Google := TgoGoogle.Create;
  try
    Google.OAuthScope := EditOAuthScope.Text;
    Google.ServiceAccount := EditServiceAccount.Text;
    Google.PrivateKey := TFile.ReadAllText(EditPEM.Text);
    if Google.Post(EditUrl.Text, MemoRequestContent.Text,
      ResponseHeaders, ResponseContent, 30000) = 200 then
    begin
      MemoResponseHeaders.Text := ResponseHeaders;
      MemoResponseContent.Text := ResponseContent;
    end;
  finally
    Google.Free;
  end;
end;

end.
