object crtransform: Tcrtransform
  Left = 359
  Top = 334
  BorderStyle = bsDialog
  ClientHeight = 164
  ClientWidth = 211
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 64
    Width = 140
    Height = 13
    Caption = #1055#1086#1079#1080#1094#1080#1103' '#1086#1082#1086#1085#1095#1072#1085#1080#1103' '#1090#1077#1082#1089#1090#1072':'
  end
  object Button1: TButton
    Left = 28
    Top = 129
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 108
    Top = 129
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
    OnClick = Button2Click
  end
  object RadioButton1: TRadioButton
    Left = 8
    Top = 48
    Width = 145
    Height = 17
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1074#1077#1089#1100' '#1090#1077#1082#1089#1090
    Checked = True
    TabOrder = 2
    TabStop = True
  end
  object RadioButton2: TRadioButton
    Left = 8
    Top = 64
    Width = 209
    Height = 17
    Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1090#1077#1082#1089#1090' '#1076#1086' '#1101#1090#1086#1081' '#1087#1086#1079#1080#1094#1080#1080':'
    TabOrder = 3
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 104
    Width = 193
    Height = 17
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -9
    Font.Name = 'Small Fonts'
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    Visible = False
  end
  object LabeledEdit1: TLabeledEdit
    Left = 8
    Top = 24
    Width = 193
    Height = 21
    EditLabel.Width = 122
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1079#1080#1094#1080#1103' '#1085#1072#1095#1072#1083#1072' '#1090#1077#1082#1089#1090#1072':'
    TabOrder = 5
    OnKeyPress = LabeledEdit1KeyPress
  end
  object Edit1: TEdit
    Left = 8
    Top = 80
    Width = 193
    Height = 21
    TabOrder = 6
    OnKeyPress = LabeledEdit1KeyPress
  end
  object rr: TOpenDialog
    DefaultExt = '.txt'
    Filter = 'Text|*.txt'
    Top = 128
  end
  object dd: TSaveDialog
    DefaultExt = '.txt'
    Filter = 'Text|*.txt'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 184
    Top = 128
  end
end
