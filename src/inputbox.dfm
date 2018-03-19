object InputForm: TInputForm
  Left = 448
  Top = 344
  BorderStyle = bsDialog
  Caption = 'Djinn Tile Mapper'
  ClientHeight = 76
  ClientWidth = 303
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
  object ifLabel: TLabel
    Left = 8
    Top = 8
    Width = 3
    Height = 13
  end
  object ifOKbtn: TButton
    Left = 8
    Top = 48
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 0
    OnClick = ifOKbtnClick
  end
  object ifCnclbtn: TButton
    Left = 88
    Top = 48
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 1
    OnClick = ifCnclbtnClick
  end
  object addrlist: TComboBox
    Left = 8
    Top = 20
    Width = 289
    Height = 21
    ItemHeight = 13
    TabOrder = 2
    OnChange = addrlistChange
    OnKeyPress = addrlistKeyPress
    OnSelect = addrlistSelect
  end
end
