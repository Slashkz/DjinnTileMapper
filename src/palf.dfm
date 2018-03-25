object PalForm: TPalForm
  Left = 1012
  Top = 347
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1055#1072#1083#1080#1090#1088#1072
  ClientHeight = 128
  ClientWidth = 301
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefault
  OnCreate = FormCreate
  OnHide = FormHide
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object tlb1: TToolBar
    Tag = 1
    Left = 277
    Top = 0
    Width = 24
    Height = 128
    Align = alRight
    ButtonHeight = 24
    ButtonWidth = 24
    Caption = 'tlb1'
    Color = clBtnFace
    DisabledImages = DjinnTileMapper.ToolbarDisabled
    EdgeBorders = [ebRight]
    HotImages = DjinnTileMapper.ToolBarHot
    Images = DjinnTileMapper.ToolBarCold
    List = True
    ParentColor = False
    TabOrder = 0
    Transparent = False
    object tbSavePal: TToolButton
      Left = 0
      Top = 0
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100'...'
      ImageIndex = 62
      Wrap = True
      OnClick = tbSavePalClick
    end
    object tbOpenaPal: TToolButton
      Left = 0
      Top = 24
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100'...'
      ImageIndex = 63
      OnClick = tbOpenaPalClick
    end
  end
  object scrlbx1: TScrollBox
    Left = 0
    Top = 0
    Width = 277
    Height = 128
    VertScrollBar.Increment = 16
    VertScrollBar.Range = 256
    Align = alClient
    AutoScroll = False
    TabOrder = 1
    object PalImage: TImage
      Left = 0
      Top = 0
      Width = 256
      Height = 256
      Align = alCustom
      OnMouseDown = FormMouseDown
    end
  end
end
