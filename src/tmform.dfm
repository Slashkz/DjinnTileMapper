object tilemapform: Ttilemapform
  Left = 540
  Top = 212
  BorderIcons = [biSystemMenu, biMinimize]
  BorderWidth = 2
  Caption = #1058#1072#1081#1083#1099
  ClientHeight = 358
  ClientWidth = 319
  Color = clBtnFace
  UseDockManager = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  ScreenSnap = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object TMapScroll: TScrollBar
    Left = 302
    Top = 25
    Width = 17
    Height = 265
    Align = alRight
    Enabled = False
    Kind = sbVertical
    LargeChange = 10
    PageSize = 0
    ParentShowHint = False
    ShowHint = False
    TabOrder = 0
    OnChange = TMapScrollChange
  end
  object scrlbx: TScrollBox
    Left = 0
    Top = 25
    Width = 279
    Height = 265
    HorzScrollBar.Increment = 16
    VertScrollBar.Increment = 16
    VertScrollBar.Style = ssHotTrack
    Align = alClient
    TabOrder = 1
    object TileMap: TImage
      Left = 0
      Top = 0
      Width = 256
      Height = 256
      OnClick = TileMapClick
      OnDblClick = TileMapDblClick
      OnMouseDown = TileMapMouseDown
      OnMouseMove = TileMapMouseMove
    end
    object TileSelection: TShape
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Brush.Style = bsBDiagonal
      Pen.Color = clWhite
      Pen.Mode = pmMergePenNot
      OnMouseDown = TileSelectionMouseDown
      OnMouseMove = TileSelectionMouseMove
    end
    object HexNums: TImage
      Left = 0
      Top = 0
      Width = 256
      Height = 256
      Transparent = True
      Visible = False
      OnClick = TileMapClick
      OnDblClick = TileMapDblClick
      OnMouseDown = TileMapMouseDown
      OnMouseMove = TileMapMouseMove
    end
    object Grid: TImage
      Left = 0
      Top = 0
      Width = 256
      Height = 256
      Transparent = True
      OnClick = TileMapClick
      OnDblClick = TileMapDblClick
      OnMouseDown = TileMapMouseDown
      OnMouseMove = TileMapMouseMove
    end
    object Block: TImage
      Left = 72
      Top = 72
      Width = 105
      Height = 105
      Cursor = crSizeAll
      Visible = False
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 290
    Width = 319
    Height = 49
    Align = alBottom
    TabOrder = 2
    object grp1: TGroupBox
      Left = 183
      Top = -1
      Width = 105
      Height = 49
      Align = alCustom
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1090#1072#1081#1083#1072
      TabOrder = 0
      object twidth: TSpinEdit
        Left = 8
        Top = 14
        Width = 41
        Height = 22
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1096#1080#1088#1080#1085#1091' '#1090#1072#1081#1083#1072' '#1074' '#1087#1080#1082#1089#1077#1083#1103#1093
        Enabled = False
        MaxLength = 2
        MaxValue = 16
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 0
        Value = 8
        OnChange = twidthChange
      end
      object theight: TSpinEdit
        Left = 56
        Top = 14
        Width = 41
        Height = 22
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1074#1099#1089#1086#1090#1091' '#1090#1072#1081#1083#1072' '#1074' '#1087#1080#1082#1089#1077#1083#1103#1093
        Enabled = False
        MaxLength = 2
        MaxValue = 16
        MinValue = 1
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
        Value = 8
        OnChange = theightChange
      end
    end
    object grp2: TGroupBox
      Left = 0
      Top = -1
      Width = 153
      Height = 49
      Align = alCustom
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099'  '#1084#1077#1090#1072#1090#1072#1081#1083#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      object tlwidth: TSpinEdit
        Left = 15
        Top = 14
        Width = 41
        Height = 22
        Enabled = False
        MaxLength = 2
        MaxValue = 16
        MinValue = 1
        TabOrder = 0
        Value = 1
        OnChange = tlwidthChange
      end
      object tlheight: TSpinEdit
        Left = 63
        Top = 14
        Width = 41
        Height = 22
        Enabled = False
        MaxLength = 2
        MaxValue = 16
        MinValue = 1
        TabOrder = 1
        Value = 1
        OnChange = tlheightChange
      end
      object cbHV: TComboBox
        Left = 111
        Top = 14
        Width = 34
        Height = 21
        Enabled = False
        ItemIndex = 0
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        Text = 'H'
        OnChange = cbHVChange
        Items.Strings = (
          'H'
          'V')
      end
    end
  end
  object pnl2: TPanel
    Left = 0
    Top = 0
    Width = 319
    Height = 25
    Align = alTop
    TabOrder = 3
    object tlb1: TToolBar
      Left = 1
      Top = 1
      Width = 317
      Height = 29
      Caption = 'tlb1'
      DisabledImages = DjinnTileMapper.ToolbarDisabled
      HotImages = DjinnTileMapper.ToolBarHot
      Images = DjinnTileMapper.ToolBarCold
      TabOrder = 0
      object tbShowHex: TToolButton
        Left = 0
        Top = 0
        Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1091#1084#1077#1088#1072#1094#1080#1102
        Caption = 'tbShowHex'
        ImageIndex = 70
        ParentShowHint = False
        ShowHint = True
        Style = tbsCheck
        OnClick = tbShowHexClick
      end
      object TileMapGrid: TSpeedButton
        Left = 23
        Top = 0
        Width = 23
        Height = 22
        Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1077#1090#1082#1091
        AllowAllUp = True
        GroupIndex = 1
        Enabled = False
        Font.Charset = RUSSIAN_CHARSET
        Font.Color = clBlue
        Font.Height = -19
        Font.Name = 'Lucida Sans Unicode'
        Font.Style = []
        Glyph.Data = {
          36030000424D3603000000000000360000002800000010000000100000000100
          1800000000000003000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF000000000000
          0000000000000000000000000000000000000000000000000000000000000000
          00000000000000000000FF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FF00000000000000000000000000000000000000000000
          0000000000000000000000000000000000000000000000000000FF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF
          FF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00
          FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF
          00FFFF00FFFF00FFFF00FF000000FF00FFFF00FFFF00FFFF00FF}
        ParentFont = False
        ParentShowHint = False
        ShowHint = True
        OnClick = TileMapGridClick
      end
      object ToolButton1: TToolButton
        Left = 46
        Top = 0
        Width = 67
        Caption = 'ToolButton1'
        ImageIndex = 12
        Style = tbsDivider
      end
      object TileEditSize: TComboBox
        Left = 113
        Top = 0
        Width = 79
        Height = 21
        Enabled = False
        ItemIndex = 4
        TabOrder = 0
        Text = 'x32(8x8)'
        OnChange = TileEditSizeChange
        Items.Strings = (
          'x2(128x128)'
          'x4(64x64)'
          'x8(32x32)'
          'x16(16x16)'
          'x32(8x8)')
      end
      object Codecbox: TComboBox
        Left = 192
        Top = 0
        Width = 105
        Height = 21
        TabOrder = 1
        Text = '2BPP NES'
        OnChange = CodecboxChange
        OnKeyPress = CodecboxKeyPress
        Items.Strings = (
          '1BPP'
          '2BPP NES'
          '2BPP GBC'
          '2BPP NGP'
          '2BPP VB'
          '2BPP MSX'
          '3BPP SNES'
          '3BPP'
          '4BPP GBA'
          '4BPP SNESM'
          '4BPP SNES'
          '4BPP MSX '
          '4BPP SMS'
          '8BPP GBA'
          '8BPP SNES')
      end
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 339
    Width = 319
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = #1040#1076#1088#1077#1089' : 000000 / 000000'
        Width = 150
      end
      item
        Text = #1058#1072#1081#1083' : '
        Width = 50
      end>
  end
  object tlb2: TToolBar
    Left = 279
    Top = 25
    Width = 23
    Height = 265
    Align = alRight
    AutoSize = True
    Caption = 'tlb2'
    Color = clBtnFace
    DisabledImages = DjinnTileMapper.ToolbarDisabled
    HotImages = DjinnTileMapper.ToolBarHot
    Images = DjinnTileMapper.ToolBarCold
    List = True
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Transparent = False
    object tbBOF: TToolButton
      Left = 0
      Top = 0
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1085#1072#1095#1072#1083#1086' '#1092#1072#1081#1083#1072
      Caption = '|<<<'
      Enabled = False
      ImageIndex = 25
      Wrap = True
      OnClick = tbBOFClick
    end
    object tbBlockMinus100: TToolButton
      Left = 0
      Top = 22
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' 256 '#1090#1072#1081#1083#1086#1074' '#1085#1072#1079#1072#1076
      Caption = '<<<'
      Enabled = False
      ImageIndex = 26
      Wrap = True
      OnClick = tbBlockMinus100Click
    end
    object tbBlockMinus10: TToolButton
      Left = 0
      Top = 44
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' 16 '#1090#1072#1081#1083#1086#1074' '#1085#1072#1079#1072#1076
      Caption = '<<'
      Enabled = False
      ImageIndex = 27
      Wrap = True
      OnClick = tbBlockMinus10Click
    end
    object tbBlockMinus1: TToolButton
      Left = 0
      Top = 66
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1090#1072#1081#1083' '#1085#1072#1079#1072#1076
      Caption = '<'
      Enabled = False
      ImageIndex = 28
      Wrap = True
      OnClick = tbBlockMinus1Click
    end
    object tbMinus1: TToolButton
      Left = 0
      Top = 88
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1073#1072#1081#1090' '#1085#1072#1079#1072#1076
      Caption = '-'
      Enabled = False
      ImageIndex = 29
      Wrap = True
      OnClick = tbMinus1Click
    end
    object tbPlus1: TToolButton
      Left = 0
      Top = 110
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1073#1072#1081#1090' '#1074#1087#1077#1088#1105#1076
      Caption = '+'
      Enabled = False
      ImageIndex = 30
      Wrap = True
      OnClick = tbPlus1Click
    end
    object tbBlockPlus1: TToolButton
      Left = 0
      Top = 132
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1090#1072#1081#1083' '#1074#1087#1077#1088#1105#1076
      Caption = '>'
      Enabled = False
      ImageIndex = 31
      Wrap = True
      OnClick = tbBlockPlus1Click
    end
    object tbBlockPlus10: TToolButton
      Left = 0
      Top = 154
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' 16 '#1090#1072#1081#1083#1086#1074' '#1074#1087#1077#1088#1105#1076
      Caption = '>>'
      Enabled = False
      ImageIndex = 32
      Wrap = True
      OnClick = tbBlockPlus10Click
    end
    object tbBlockPlus100: TToolButton
      Left = 0
      Top = 176
      Hint = #1055#1077#1088#1077#1081' '#1085#1072' 256 '#1090#1072#1081#1083#1086#1074' '#1074#1087#1077#1088#1105#1076
      Caption = '>>>'
      Enabled = False
      ImageIndex = 33
      Wrap = True
      OnClick = tbBlockPlus100Click
    end
    object tbEOF: TToolButton
      Left = 0
      Top = 198
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1074' '#1082#1086#1085#1077#1094' '#1092#1072#1081#1083#1072
      Enabled = False
      ImageIndex = 34
      Wrap = True
      OnClick = tbEOFClick
    end
    object tbGoTo: TToolButton
      Left = 0
      Top = 220
      Hint = #1055#1077#1088#1077#1081#1090#1080' '#1085#1072' '#1091#1082#1072#1079#1072#1085#1085#1099#1081' '#1072#1076#1088#1077#1089
      Caption = '00'
      Enabled = False
      ImageIndex = 35
      Wrap = True
      OnClick = tbGoToClick
    end
    object tbAddBookmark: TToolButton
      Left = 0
      Top = 242
      Caption = 'tbAddBookmark'
      DropdownMenu = pmJumpList
      Enabled = False
      ImageIndex = 73
    end
  end
  object pmJumpList: TPopupMenu
    Left = 56
    Top = 33
    object AddBookmark: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1079#1072#1082#1083#1072#1076#1082#1091
      OnClick = AddBookmarkClick
    end
  end
  object actlst1: TActionList
    Left = 24
    Top = 33
    object ActionAddressJumpList: TAction
      Caption = 'ActionAddressJumpList'
      OnExecute = ActionAddressJumpListExecute
    end
    object BlockCopy: TAction
      Caption = 'BlockCopy'
    end
    object BlockPaste: TAction
      Caption = 'BlockPaste'
      OnExecute = BlockPasteExecute
    end
    object BlockSelectAll: TAction
      Caption = 'BlockSelectAll'
      OnExecute = BlockSelectAllExecute
    end
  end
end
