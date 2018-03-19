object f_metatiles: Tf_metatiles
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #1050#1072#1088#1090#1072' '#1084#1077#1090#1072#1090#1072#1081#1083#1086#1074
  ClientHeight = 400
  ClientWidth = 465
  Color = clBackground
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object scrlbx1: TScrollBox
    Left = 0
    Top = 29
    Width = 465
    Height = 352
    Align = alClient
    TabOrder = 0
    OnClick = scrlbx1Click
    object MapImage: TImage
      Left = 0
      Top = 0
      Width = 516
      Height = 344
      OnClick = scrlbx1Click
      OnMouseMove = MapImageMouseMove
    end
    object Grid: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      Transparent = True
      Visible = False
      OnClick = scrlbx1Click
      OnMouseMove = MapImageMouseMove
    end
    object TileSelection: TShape
      Left = 0
      Top = 0
      Width = 16
      Height = 16
      Brush.Style = bsClear
      Pen.Color = clWhite
      Pen.Mode = pmMergePenNot
    end
    object Block: TImage
      Left = 232
      Top = 72
      Width = 105
      Height = 105
      Visible = False
    end
    object BlockSelection: TShape
      Left = 208
      Top = 120
      Width = 32
      Height = 32
      Brush.Style = bsFDiagonal
      Pen.Color = clWhite
      Pen.Mode = pmMergePenNot
      Visible = False
    end
  end
  object tlb1: TToolBar
    Left = 0
    Top = 0
    Width = 465
    Height = 29
    Caption = 'tlb1'
    DisabledImages = DjinnTileMapper.ToolbarDisabled
    HotImages = DjinnTileMapper.ToolBarHot
    Images = DjinnTileMapper.ToolBarHot
    TabOrder = 1
    Transparent = False
    object tbGoTo: TToolButton
      Left = 0
      Top = 0
      Caption = 'tbGoTo'
      Enabled = False
      ImageIndex = 35
      OnClick = tbGoToClick
    end
    object tbShowGrid: TToolButton
      Left = 23
      Top = 0
      Caption = 'tbShowGrid'
      ImageIndex = 60
      Style = tbsCheck
      OnClick = tbShowGridClick
    end
    object tbShowHex: TToolButton
      Left = 46
      Top = 0
      Caption = 'tbShowHex'
      ImageIndex = 70
      Style = tbsCheck
      OnClick = tbShowHexClick
    end
    object seMapWidth: TSpinEdit
      Left = 69
      Top = 0
      Width = 40
      Height = 22
      Enabled = False
      MaxLength = 3
      MaxValue = 100
      MinValue = 1
      TabOrder = 3
      Value = 16
      OnChange = MapChange
    end
    object seMapHeight: TSpinEdit
      Left = 109
      Top = 0
      Width = 40
      Height = 22
      Enabled = False
      MaxLength = 3
      MaxValue = 100
      MinValue = 1
      TabOrder = 4
      Value = 16
      OnChange = MapChange
    end
    object seWidth: TSpinEdit
      Left = 149
      Top = 0
      Width = 40
      Height = 22
      Enabled = False
      MaxLength = 1
      MaxValue = 32
      MinValue = 1
      TabOrder = 0
      Value = 1
      OnChange = MapChange
    end
    object seHeight: TSpinEdit
      Left = 189
      Top = 0
      Width = 40
      Height = 22
      Enabled = False
      MaxLength = 1
      MaxValue = 32
      MinValue = 1
      TabOrder = 1
      Value = 1
      OnChange = MapChange
    end
    object cbDirection: TComboBox
      Left = 229
      Top = 0
      Width = 78
      Height = 21
      Enabled = False
      ItemIndex = 0
      TabOrder = 2
      Text = 'Horizontal'
      OnChange = cbDirectionChange
      Items.Strings = (
        'Horizontal'
        'Vertical')
    end
    object cbMapFormat: TComboBox
      Left = 307
      Top = 0
      Width = 134
      Height = 21
      Enabled = False
      ItemIndex = 4
      TabOrder = 5
      Text = 'Sega Genesis Map'
      OnChange = cbMapFormatChange
      Items.Strings = (
        'Single Byte Map'
        'GameBoy Color Map'
        'GameBoy Advance Map'
        'Super Nintendo Map'
        'Sega Genesis Map'
        'PC Engine Map'
        'Sega Master System Map')
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 381
    Width = 465
    Height = 19
    Panels = <>
  end
  object OpenDialog1: TOpenDialog
    Left = 360
    Top = 80
  end
  object SaveDialog1: TSaveDialog
    Left = 392
    Top = 80
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer1Timer
    Left = 400
    Top = 133
  end
end
