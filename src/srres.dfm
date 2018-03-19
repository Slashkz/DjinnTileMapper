object searchresform: Tsearchresform
  Left = 235
  Top = 336
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099' '#1087#1086#1080#1089#1082#1072
  ClientHeight = 153
  ClientWidth = 386
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poDesktopCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object searchlist: TListBox
    Left = 0
    Top = 0
    Width = 393
    Height = 177
    ItemHeight = 13
    PopupMenu = PopupMenu1
    TabOrder = 0
    OnDblClick = searchlistDblClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = '.rss'
    Filter = '*.rss|*.rss'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Left = 136
    Top = 104
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '.rss'
    Filter = '*.rss|*.rss'
    Left = 168
    Top = 104
  end
  object MainMenu1: TMainMenu
    Left = 200
    Top = 104
    object N1: TMenuItem
      Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099
      object N2: TMenuItem
        Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'...'
        ShortCut = 16463
        OnClick = N2Click
      end
      object N3: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
        ShortCut = 16467
        OnClick = N3Click
      end
      object N10: TMenuItem
        Caption = #1054#1095#1080#1089#1090#1080#1090#1100
        ShortCut = 16430
        OnClick = N10Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N6: TMenuItem
        Caption = #1055#1077#1088#1077#1081#1090#1080
        OnClick = N6Click
      end
      object N9: TMenuItem
        Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091'..'
        ShortCut = 16461
        OnClick = N9Click
      end
    end
    object N4: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = N4Click
    end
  end
  object PopupMenu1: TPopupMenu
    Left = 104
    Top = 104
    object N7: TMenuItem
      Caption = #1055#1077#1088#1077#1081#1090#1080
      OnClick = N7Click
    end
    object N8: TMenuItem
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1090#1072#1073#1083#1080#1094#1091
      OnClick = N8Click
    end
  end
end
