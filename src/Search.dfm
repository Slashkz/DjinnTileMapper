object SearchForm: TSearchForm
  Left = 312
  Top = 353
  BorderStyle = bsDialog
  Caption = #1055#1086#1080#1089#1082
  ClientHeight = 169
  ClientWidth = 368
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
  object hexfl: TLabel
    Left = 40
    Top = 8
    Width = 52
    Height = 13
    Caption = 'Hex-'#1087#1086#1080#1089#1082
  end
  object tfl: TLabel
    Left = 40
    Top = 88
    Width = 69
    Height = 13
    Caption = #1055#1086#1080#1089#1082' '#1090#1077#1082#1089#1090#1072
  end
  object rsl: TLabel
    Left = 40
    Top = 48
    Width = 111
    Height = 13
    Caption = #1055#1086#1080#1089#1082' '#1090#1077#1082#1089#1090#1072' Relative'
  end
  object intLab: TLabel
    Left = 240
    Top = 144
    Width = 52
    Height = 13
    Caption = #1048#1085#1090#1077#1088#1074#1072#1083':'
  end
  object hexfed: TEdit
    Left = 37
    Top = 24
    Width = 305
    Height = 21
    TabOrder = 1
    OnChange = hexfedChange
    OnClick = hexfedClick
    OnEnter = hexfedEnter
    OnKeyPress = hexfedKeyPress
  end
  object f1: TRadioButton
    Left = 21
    Top = 25
    Width = 17
    Height = 17
    Checked = True
    TabOrder = 0
    TabStop = True
    OnClick = f1Click
  end
  object tfed: TEdit
    Left = 37
    Top = 64
    Width = 305
    Height = 21
    TabOrder = 3
    OnClick = tfedClick
    OnEnter = tfedEnter
    OnKeyPress = tfedKeyPress
  end
  object f2: TRadioButton
    Left = 21
    Top = 65
    Width = 17
    Height = 17
    TabOrder = 2
    OnClick = f2Click
  end
  object FindBtn: TButton
    Left = 21
    Top = 136
    Width = 75
    Height = 25
    Caption = #1053#1072#1081#1090#1080
    TabOrder = 6
    OnClick = FindBtnClick
  end
  object CnBtn: TButton
    Left = 100
    Top = 136
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 7
    OnClick = CnBtnClick
  end
  object ntsed: TEdit
    Left = 37
    Top = 104
    Width = 305
    Height = 21
    Color = clBtnFace
    Enabled = False
    TabOrder = 5
    OnChange = ntsedChange
    OnClick = ntsedClick
    OnEnter = ntsedEnter
    OnKeyPress = ntsedKeyPress
  end
  object f3: TRadioButton
    Left = 21
    Top = 105
    Width = 17
    Height = 17
    Enabled = False
    TabOrder = 4
    OnClick = f3Click
  end
  object intervalspin: TSpinEdit
    Left = 296
    Top = 140
    Width = 49
    Height = 22
    MaxLength = 2
    MaxValue = 15
    MinValue = 0
    TabOrder = 8
    Value = 0
    OnChange = intervalspinChange
    OnKeyPress = intervalspinKeyPress
  end
end
