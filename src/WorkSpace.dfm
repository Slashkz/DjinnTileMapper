object WSForm: TWSForm
  Left = 512
  Top = 107
  BorderIcons = [biSystemMenu, biMinimize]
  BorderWidth = 2
  Caption = #1056#1072#1073#1086#1095#1072#1103' '#1086#1073#1083#1072#1089#1090#1100
  ClientHeight = 538
  ClientWidth = 520
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnPaint = FormPaint
  OnResize = FormResize
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object tlb1: TToolBar
    Left = 0
    Top = 0
    Width = 520
    Height = 29
    Caption = 'tlb1'
    DisabledImages = DjinnTileMapper.ToolbarDisabled
    HotImages = DjinnTileMapper.ToolBarHot
    Images = DjinnTileMapper.ToolBarCold
    TabOrder = 0
    Wrapable = False
    object tbImport: TToolButton
      Left = 0
      Top = 0
      Caption = 'tbImport'
      ImageIndex = 7
      Visible = False
      OnClick = tbImportClick
    end
    object tbExport: TToolButton
      Left = 23
      Top = 0
      Caption = 'tbExport'
      ImageIndex = 8
      Visible = False
      OnClick = tbExportClick
    end
    object tbOpenMap: TToolButton
      Left = 46
      Top = 0
      Caption = 'tbOpenMap'
      ImageIndex = 62
      OnClick = tbOpenMapClick
    end
    object tbSaveMap: TToolButton
      Left = 69
      Top = 0
      Caption = 'tbSaveMap'
      ImageIndex = 63
      OnClick = tbSaveMapClick
    end
    object SaveImage: TToolButton
      Left = 92
      Top = 0
      Caption = 'SaveImage'
      ImageIndex = 78
      OnClick = SaveImageClick
    end
    object seWidth: TSpinEdit
      Left = 115
      Top = 0
      Width = 45
      Height = 22
      MaxLength = 3
      MaxValue = 100
      MinValue = 1
      TabOrder = 1
      Value = 32
      OnChange = seWidthChange
      OnKeyPress = seWidthKeyPress
    end
    object seHeight: TSpinEdit
      Left = 160
      Top = 0
      Width = 45
      Height = 22
      MaxLength = 3
      MaxValue = 100
      MinValue = 1
      TabOrder = 0
      Value = 30
      OnChange = seWidthChange
      OnKeyPress = seWidthKeyPress
    end
    object btn1: TToolButton
      Left = 205
      Top = 0
      Width = 8
      Caption = 'btn1'
      ImageIndex = 0
      Style = tbsSeparator
    end
    object sbInit: TSpeedButton
      Left = 213
      Top = 0
      Width = 40
      Height = 22
      Caption = 'INIT'
      Flat = True
      OnClick = sbInitClick
    end
    object sbClear: TSpeedButton
      Left = 253
      Top = 0
      Width = 40
      Height = 22
      Caption = 'CLEAR'
      Flat = True
      OnClick = sbClearClick
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 519
    Width = 520
    Height = 19
    Panels = <
      item
        Alignment = taCenter
        Text = #1040#1076#1088#1077#1089': 000000 / 001000'
        Width = 150
      end
      item
        Alignment = taCenter
        Text = 'X ,Y : 000 / 000 '
        Width = 100
      end
      item
        Text = '000000 : 0000'
        Width = 100
      end
      item
        Text = '0,0'
        Width = 100
      end
      item
        Width = 50
      end>
  end
  object scrlbx1: TScrollBox
    Left = 0
    Top = 58
    Width = 520
    Height = 461
    HorzScrollBar.Increment = 16
    VertScrollBar.Increment = 16
    Align = alClient
    TabOrder = 2
    object WorkSpace: TImage
      Left = 0
      Top = 0
      Width = 512
      Height = 480
      OnClick = WorkSpaceClick
      OnMouseDown = WorkSpaceMouseDown
      OnMouseMove = WorkSpaceMouseMove
      OnMouseUp = WorkSpaceMouseUp
    end
    object TileSelection: TShape
      Left = 128
      Top = 72
      Width = 16
      Height = 16
      Brush.Color = clSkyBlue
      Brush.Style = bsDiagCross
      OnMouseDown = TileSelectionMouseDown
      OnMouseMove = TileSelectionMouseMove
    end
    object Grid: TImage
      Left = 0
      Top = 0
      Width = 105
      Height = 105
      Transparent = True
      Visible = False
      OnClick = WorkSpaceClick
      OnMouseDown = WorkSpaceMouseDown
      OnMouseMove = WorkSpaceMouseMove
      OnMouseUp = WorkSpaceMouseUp
    end
    object Block: TImage
      Left = 88
      Top = 176
      Width = 105
      Height = 105
      Visible = False
    end
    object BlockSelection: TShape
      Left = 17
      Top = 200
      Width = 65
      Height = 65
      Cursor = crSizeAll
      Brush.Style = bsFDiagonal
      Visible = False
      OnMouseDown = BlockSelectionMouseDown
      OnMouseMove = BlockSelectionMouseMove
      OnMouseUp = BlockSelectionMouseUp
    end
  end
  object tlb2: TToolBar
    Left = 0
    Top = 29
    Width = 520
    Height = 29
    Caption = 'tlb2'
    DisabledImages = DjinnTileMapper.ToolbarDisabled
    HotImages = DjinnTileMapper.ToolBarHot
    Images = DjinnTileMapper.ToolBarCold
    TabOrder = 3
    object tbSwap: TSpeedButton
      Left = 0
      Top = 0
      Width = 45
      Height = 22
      AllowAllUp = True
      GroupIndex = 2
      Caption = 'X<>Y'
      Flat = True
      OnClick = tbSwapClick
    end
    object sbEdit: TSpeedButton
      Left = 45
      Top = 0
      Width = 40
      Height = 22
      GroupIndex = 1
      Down = True
      Caption = 'EDIT'
      Flat = True
      OnClick = sbEditClick
    end
    object sbDraw: TSpeedButton
      Left = 85
      Top = 0
      Width = 40
      Height = 22
      GroupIndex = 1
      Caption = 'DRAW'
      Flat = True
      OnClick = sbDrawClick
    end
    object sbStep: TSpeedButton
      Left = 125
      Top = 0
      Width = 40
      Height = 22
      GroupIndex = 1
      Caption = 'STEP'
      Flat = True
      OnClick = sbStepClick
    end
    object sbType: TSpeedButton
      Left = 165
      Top = 0
      Width = 40
      Height = 22
      GroupIndex = 1
      Caption = 'TYPE'
      Flat = True
      OnClick = sbTypeClick
    end
    object tbGrid: TToolButton
      Left = 205
      Top = 0
      AllowAllUp = True
      ImageIndex = 60
      OnClick = tbGridClick
    end
    object cbRectSize: TComboBox
      Left = 228
      Top = 0
      Width = 90
      Height = 21
      ItemIndex = 4
      TabOrder = 0
      Text = 'x32(8x8)'
      OnChange = cbRectSizeChange
      Items.Strings = (
        'x2(128x128)'
        'x4(64x64)'
        'x8(32x32)'
        'x16(16x16)'
        'x32(8x8)')
    end
    object tbSelectTiles: TToolButton
      Left = 318
      Top = 0
      Caption = 'SelectionBlock'
      ImageIndex = 79
      Style = tbsCheck
      OnClick = tbSelectTilesClick
    end
  end
  object OpenMap: TOpenDialog
    Filter = 'Open Djinn Tile Mapper Map (*.dtm)|*.dtm|All Files (*.*)|*.*'
    Left = 230
    Top = 255
  end
  object SaveMap: TSaveDialog
    Filter = 'Djinn Tile Mapper Map (*.dtm)|*.dtm|All Files (*.*)|*.*'
    Left = 294
    Top = 255
  end
  object SaveDialog2: TSaveDialog
    DefaultExt = '.bmp'
    Filter = 'Bitmap (*.bmp)|*.bmp'
    Title = #1057#1086#1093#1088#1072#1085#1080#1090#1100' Bitmap'
    Left = 262
    Top = 255
  end
  object XPManifest1: TXPManifest
    Left = 424
    Top = 162
  end
  object ActionList1: TActionList
    Left = 368
    Top = 98
    object BlockCopy: TAction
      Caption = 'BlockCopy'
      ShortCut = 16451
      OnExecute = BlockCopyExecute
    end
    object BlockPaste: TAction
      Caption = 'BlockPaste'
      ShortCut = 16470
      OnExecute = BlockPasteExecute
    end
    object BlockSelectAll: TAction
      Caption = 'BlockSelectAll'
      ShortCut = 16449
      OnExecute = BlockSelectAllExecute
    end
  end
end
