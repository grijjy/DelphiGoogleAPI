unit GCP.Demo.View.Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.ScrollBox, FMX.Memo, FMX.Objects, FMX.TabControl, FMX.Layouts,
  FMX.Controls.Presentation, System.Actions, FMX.ActnList;

type
  TfrmGCPMegaDemo = class(TForm)
    gpGCPProperties: TGroupBox;
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
    Text3: TText;
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
    procedure FormResize(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actOpenPEMFileExecute(Sender: TObject);
  private
    procedure ResizeControls;
    { Private declarations }
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

procedure TfrmGCPMegaDemo.FormCreate(Sender: TObject);
begin
  tcService.Index := 0;
  tcResults.TabPosition := TTabPosition.None;
  tcResults.Index := 0;
end;

procedure TfrmGCPMegaDemo.FormResize(Sender: TObject);
begin
  ResizeControls;
end;

procedure TfrmGCPMegaDemo.ResizeControls;
begin
  layProperitesServiceAccount.Width := gpGCPProperties.Width / 3;
  layProperitesOAuthScope.Width := gpGCPProperties.Width / 3;
  tcService.Width := Width / 2;
  layHeaders.Height := tcResults.Height / 2;
end;

end.
