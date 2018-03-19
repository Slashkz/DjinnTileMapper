object edtextform: Tedtextform
  Left = 248
  Top = 154
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1056#1077#1076#1072#1082#1090#1086#1088' '#1090#1077#1082#1089#1090#1072
  ClientHeight = 330
  ClientWidth = 528
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object ListBox1: TListBox
    Left = 8
    Top = 32
    Width = 513
    Height = 289
    ItemHeight = 13
    MultiSelect = True
    TabOrder = 0
  end
  object MainMenu: TMainMenu
    Left = 8
    object textmenu: TMenuItem
      Caption = #1058#1077#1082#1089#1090
      object crti: TMenuItem
        Caption = #1057#1086#1079#1076#1072#1090#1100'...'
        ShortCut = 16462
        OnClick = crtiClick
      end
      object oti: TMenuItem
        Caption = #1054#1090#1082#1088#1099#1090#1100'..'
        ShortCut = 114
      end
      object ssti: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
        ShortCut = 113
      end
      object sati: TMenuItem
        Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100' '#1082#1072#1082'...'
        ShortCut = 16467
      end
      object N6: TMenuItem
        Caption = '-'
      end
      object closei: TMenuItem
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ShortCut = 16472
        OnClick = closeiClick
      end
    end
  end
end
