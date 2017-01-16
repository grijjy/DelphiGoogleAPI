object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'FormMain'
  ClientHeight = 516
  ClientWidth = 836
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBoxRequest: TGroupBox
    Left = 8
    Top = 19
    Width = 370
    Height = 489
    Caption = 'Request'
    TabOrder = 0
    object LabelOAuthScope: TLabel
      Left = 16
      Top = 126
      Width = 63
      Height = 13
      Caption = 'OAuth Scope'
    end
    object LabelUrl: TLabel
      Left = 16
      Top = 174
      Width = 13
      Height = 13
      Caption = 'Url'
    end
    object LabelRequest: TLabel
      Left = 16
      Top = 229
      Width = 39
      Height = 13
      Caption = 'Content'
    end
    object LabelServiceAccount: TLabel
      Left = 16
      Top = 29
      Width = 102
      Height = 13
      Caption = 'Your Service Account'
    end
    object LabelPEM: TLabel
      Left = 16
      Top = 74
      Width = 85
      Height = 13
      Caption = 'Your PEM Key File'
    end
    object ButtonPost: TButton
      Left = 286
      Top = 446
      Width = 75
      Height = 25
      Caption = 'Post'
      TabOrder = 6
      OnClick = ButtonPostClick
    end
    object EditOAuthScope: TEdit
      Left = 16
      Top = 142
      Width = 345
      Height = 21
      TabOrder = 2
      Text = 'https://www.googleapis.com/auth/cloud-platform'
    end
    object EditUrl: TEdit
      Left = 16
      Top = 190
      Width = 345
      Height = 21
      TabOrder = 3
      Text = 'https://speech.googleapis.com/v1beta1/speech:syncrecognize'
    end
    object MemoRequestContent: TMemo
      Left = 16
      Top = 248
      Width = 345
      Height = 184
      Lines.Strings = (
        '{'
        '  '#39'config'#39': {'
        '      '#39'encoding'#39':'#39'FLAC'#39','
        '      '#39'sampleRate'#39': 16000,'
        '      '#39'languageCode'#39': '#39'en-US'#39
        '  },'
        '  '#39'audio'#39': {'
        '      '#39'uri'#39':'#39'gs://cloud-samples-tests/speech/brooklyn.flac'#39
        '  }'
        '}')
      TabOrder = 4
    end
    object EditServiceAccount: TEdit
      Left = 16
      Top = 45
      Width = 345
      Height = 21
      TabOrder = 0
    end
    object ButtonBrowse: TButton
      Left = 286
      Top = 88
      Width = 75
      Height = 25
      Caption = 'Browse'
      TabOrder = 5
      OnClick = ButtonBrowseClick
    end
    object EditPEM: TEdit
      Left = 16
      Top = 90
      Width = 257
      Height = 21
      TabOrder = 1
    end
  end
  object GroupBoxResponse: TGroupBox
    Left = 392
    Top = 16
    Width = 432
    Height = 489
    Caption = 'Response'
    TabOrder = 1
    object LabelResponseContent: TLabel
      Left = 16
      Top = 151
      Width = 39
      Height = 13
      Caption = 'Content'
    end
    object LabelResponseHeaders: TLabel
      Left = 16
      Top = 18
      Width = 40
      Height = 13
      Caption = 'Headers'
    end
    object MemoResponseHeaders: TMemo
      Left = 16
      Top = 37
      Width = 401
      Height = 105
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object MemoResponseContent: TMemo
      Left = 16
      Top = 170
      Width = 401
      Height = 293
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'pem'
    Left = 328
    Top = 8
  end
end
