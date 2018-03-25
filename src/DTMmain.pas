unit DTMmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, ColorGrd, StdCtrls, ComCtrls, Gauges, ToolWin,
  ImgList, Buttons, Spin, InputBox, ActnList, BitmapUtils, StdActns, Math,
  RTLConsts, System.ImageList, System.Actions, About, GdiPlus;

type
  TTile2bit = array[0..7, 0..1] of Byte;

  TTile2bit_NES = array[0..1, 0..7] of Byte;

  TTile2bit_MSX = array[0..1, 0..3, 0..7] of Byte;

  TTile3bit = array[0..5, 0..3] of Byte;

  TTile4bit = array[0..7, 0..3] of Byte;

  TTile8bit = array[0..7, 0..7] of Byte;

  TTileType = (tt1bit, tt2bitNES, tt2bitGBC, tt2bitNGP, tt2bitVB, tt2bitMSX, tt3bitSNES, tt3bit, tt4bit, tt4bitSNESM, tt4bitSNES, tt4bitMSX, tt4bitSMS, tt8bit, tt8bitSNES);

  TMapFormat = (mfSingleByte, mfGBC, mfGBA, mfSNES, mfMSX, mfPCE, mfSMS);
const

  DDGData = 'CF_DTM'; // constant for registering the clipboard format.

type
  TBlock = class
  private
    FH: Boolean;//eax + 4
    FPal: Byte; //eax + 5
    FIndex: Word; //eax + 6
    FValue: Word; //eax + 8
    FAddress: LongWord; //eax + $0C
    FP: Boolean;       //eax + $10
    FV: Boolean;       //eax + $11
    procedure SetAddress(const Value: LongWord);
    procedure SetH(const Value: Boolean);
    procedure SetIndex(const Value: Word);
    procedure SetP(const Value: Boolean);
    procedure SetPal(const Value: Byte);
    procedure SetV(const Value: Boolean);
    procedure SetValue(const Value: Word);
  public
    X: Integer; //eax + $14
    Y: Integer; //eax + $18
    property Value: Word read FValue write SetValue;
    property Index: Word read FIndex write SetIndex;
    property H: Boolean read FH write SetH;
    property V: Boolean read FV write SetV;
    property P: Boolean read FP write SetP;
    property Pal: Byte read FPal write SetPal;
    property Address: LongWord read FAddress write SetAddress;
  end;

  // Record data to be stored to the clipboard

  TDataRec = packed record
    Data: array of TBlock;
    Bitmap: TBitmap;
  end;

  TBitReader = class
  private
    FLength: Integer;
    FPosition: Integer;
    FSource: PByteArray;
    procedure SetLength(const Value: Integer);
    function GetLength: Integer;
    procedure SetPosition(const Value: Integer);
    procedure SetSource(const Value: PByteArray);
    function GetBit(Index: Integer): Byte;
    procedure SetBit(Index: Integer; const Value: Byte);
  public
    property Length: Integer read GetLength write SetLength;
    property Source: PByteArray read FSource write SetSource;
    property Position: Integer read FPosition write SetPosition;
    property Bits[Index: Integer]: Byte read GetBit write SetBit; default;
    function Read(BitCount: Integer): LongWord; overload;
    function Read(): Integer; overload;
    procedure Write(Value: Byte); overload;
    procedure Write(Value: LongWord; BitCount: Integer); overload;
    function Seek(Shift: Integer; Origin: TSeekOrigin): Boolean;
    constructor Create(const Src; Size: Integer);
  end;

  TBitWriter = class
  private
    FPosition: Integer;
    FLength: Integer;
    FDest: PByteArray;
    procedure SetDest(const Value: PByteArray);
    procedure SetLength(const Value: Integer);
    procedure SetPosition(const Value: Integer);
    function GetBit(Index: Integer): Byte;
    procedure SetBit(Index: Integer; const Value: Byte);
  public
    function GetLength: Integer;
  public
    property Position: Integer read FPosition write SetPosition;
    property Length: Integer read GetLength write SetLength;
    property Dest: PByteArray read FDest write SetDest;
    property Bits[Index: Integer]: Byte read GetBit write SetBit; default;
    procedure Write(Value: Byte); overload;
    procedure Write(Value: LongWord; BitCount: Integer); overload;
    function Seek(Shift: Integer; Origin: TSeekOrigin): Boolean;
    constructor Create(var Dst; Size: Integer);
  end;

  TDjinnTileMapper = class(TForm)
    OpenROM: TOpenDialog;
    SaveROM: TSaveDialog;
    MainMenu: TMainMenu;
    FileMenu: TMenuItem;
    TileMapMenu: TMenuItem;
    PaletteMenu: TMenuItem;
    HelpMenu: TMenuItem;
    mniFileOpen: TMenuItem;
    ReloadItem: TMenuItem;
    SaveItem: TMenuItem;
    SaveASitem: TMenuItem;
    ExitItem: TMenuItem;
    ColorDialog: TColorDialog;
    GoTo1: TMenuItem;
    DataMapMenu: TMenuItem;
    GoTo2: TMenuItem;
    Restore1: TMenuItem;
    TableMenu: TMenuItem;
    MkTmplItem: TMenuItem;
    OpenTblItem: TMenuItem;
    AboutItem: TMenuItem;
    MakeTBL: TSaveDialog;
    OpenTBL: TOpenDialog;
    TBLnamel: TLabel;
    Rldtblitem: TMenuItem;
    DataEdit: TEdit;
    LenLab: TLabel;
    MaxLenLab: TLabel;
    PasteBtn: TButton;
    GetBtn: TButton;
    Getstring1: TMenuItem;
    PutString1: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    SavePAL: TSaveDialog;
    OpenPAL: TOpenDialog;
    SearchItem: TMenuItem;
    SpinEdit1: TSpinEdit;
    ottnl: TMenuItem;
    rttbl: TMenuItem;
    cttbl: TMenuItem;
    Label4: TLabel;
    N3: TMenuItem;
    LCnt: TMenuItem;
    optItm: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    BMP1: TMenuItem;
    BMP2: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N27: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    OpenBMP: TOpenDialog;
    SaveBMP: TSaveDialog;
    ShowWorkSpace: TMenuItem;
    ToolBarCold: TImageList;
    ToolBarHot: TImageList;
    ToolbarDisabled: TImageList;
    ShowMetatilesMap: TMenuItem;
    HexNums: TImageList;
    tmr1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure ExitItemClick(Sender: TObject);
    procedure Fill(var Im: TImage; Clr: TColor);
    procedure OpenItemClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure GoTo1Click(Sender: TObject);
    procedure GoTo2Click(Sender: TObject);
    procedure ReloadItemClick(Sender: TObject);
    procedure SaveItemClick(Sender: TObject);
    procedure SaveASitemClick(Sender: TObject);
    procedure Restore1Click(Sender: TObject);
    procedure MkTmplItemClick(Sender: TObject);
    procedure OpenTblItemClick(Sender: TObject);
    procedure DataEditKeyPress(Sender: TObject; var Key: Char);
    procedure DataEditChange(Sender: TObject);
    procedure PasteBtnClick(Sender: TObject);
    procedure RldtblitemClick(Sender: TObject);
    procedure GetBtnClick(Sender: TObject);
    procedure Getstring1Click(Sender: TObject);
    procedure PutString1Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure SearchItemClick(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure ottnlClick(Sender: TObject);
    procedure cttblClick(Sender: TObject);
    procedure rttblClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure LCntClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure optItmClick(Sender: TObject);
    procedure ImportBitmap(Sender: TObject);
    procedure ExportBitmap(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N28Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure ShowWorkSpaceClick(Sender: TObject);
    procedure ShowMetatilesMapClick(Sender: TObject);
    procedure AboutItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tmr1Timer(Sender: TObject);
  private
    FMapFormat: TMapFormat;
    FPalette: array[Byte] of TColor;
    FBigPalSet: Byte;
    FSmallPalSet: Byte;
    function GetTileType: TTileType;
    procedure SetTileType(const Value: TTileType);
    procedure ReadTile(TilePos: Integer; X, Y: Integer); inline;
    procedure SetMapFormat(const Value: TMapFormat);
    procedure DataMapRedraw;
    procedure ShowHexNumbers();
    procedure SetColor(I: Integer; const Value: TColor);
    function GetColor(I: Integer): TColor;
    function GetBigPalSet: Byte;
    function GetSmallPalSet: Byte;
    procedure SetBigPalSet(const Value: Byte);
    procedure SetSmallPalSet(const Value: Byte);
    function GetCol(I: Integer): TColor;
    procedure SetCol(I: Integer; const Value: TColor);
  protected
    procedure SetForegroundColor(n: byte);
    function GetForegroundColor: byte;
    procedure SetBackGroundColor(n: byte);
    function GetBackGoundColor: byte;
    procedure SetPos(p: LongInt);
    function GetPos: LongInt;
    procedure SetROMPos(p: LongInt);
    function GetrPos: LongInt;
    procedure SetCurbank(n: integer);
    function GetCurbank: integer;
    procedure SetDataMapWidth(w: integer);
    function GetDataMapWidth: integer;
    procedure SetDataMapHeight(h: integer);
    function GetDataMapHeight: integer;
    procedure Setdbank(n: integer);
    function Getdbank: integer;
  public
    procedure RedrawPalette();
    procedure UpdateData(Pos: Integer);
    procedure InitPoses;
    function GetLength: Integer;
    procedure InitDataEdit;
    procedure ROMopen;
    procedure DrawTile(WW, HH: Integer);
    procedure DrawTileMap;
    procedure MapScrollEnable;
    procedure DataMapDraw;
    procedure DataScrollEnable;
    procedure srelative;
    property Palette[I: Integer]: TColor read GetColor write SetColor;
    property Color[I: Integer]: TColor read GetCol write SetCol;
    property Foreground: byte read GetForegroundColor write SetForegroundColor;
    property Background: byte read GetBackGoundColor write SetBackGroundColor;
    property BigPalSet: Byte read GetBigPalSet write SetBigPalSet;
    property SmallPalSet: Byte read GetSmallPalSet write SetSmallPalSet;
    property TileType: TTileType read GetTileType write SetTileType;
    property ROMpos: LongInt read getPos write SetPos;
    property rDatapos: LongInt read getrPos write SetROMPos;
    property Bank: integer read getcurbank write Setcurbank;
    property dWidth: Integer read GetDataMapWidth write SetDataMapWidth;
    property dHeight: Integer read GetDataMapHeight write SetDataMapHeight;
    property DataBank: Integer read getdbank write Setdbank;
    property MapFormat: TMapFormat read FMapFormat write SetMapFormat;
  end;

procedure UpdatePixel();

var
  DTM: TDjinnTileMapper;

type
  PromData = ^TromData;
  TRomData = array[0..10 * 1024 * 1024] of Byte;

  TTable = array[Byte] of string;

  TTileTable = array[Byte] of Byte;

  BlockArr = array of TBlock;

  function HexVal(s: string; var err: Boolean): LongInt;
  procedure IncPointer(var p: Pointer; increment: Integer);
  procedure SetSize(var P: BlockArr; Size: Integer);
  procedure InitAllJumpLists;

const
  Hchs: TCharset = ['H', 'h', '0'..'9', 'A'..'F', 'a'..'f', #8];
  errs: string = 'Неправильно введено число!!!';
  MSX_Shifts: array[0..7] of Byte = (1 shl 2, 0 shl 2, 3 shl 2, 2 shl 2, 5 shl 2, 4 shl 2, 7 shl 2, 6 shl 2);
  ResetBit: array[0..7] of Byte = ($FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F);
  SetBit: array[0..7] of Byte = ($1, $2, $4, $8, $10, $20, $40, $80);
  DefaultPal: array[0..191] of Byte = ($00, $00, $00, $A0, $30, $00, $D8, $49, $60, $FF, $C8, $B8, $90, $90, $B4, $90, $48, $00, $D8, $90, $00, $FC, $FC, $90, $FC, $D8, $00, $D8, $B4, $00, $B4, $90, $00, $90, $6C, $00, $6C, $48, $00, $00, $D8, $00, $00, $B4, $00, $00, $6C, $00, $90, $D8, $FC, $00, $00, $00, $90, $24, $00, $B4, $24, $00, $FC, $48, $00, $00, $00, $00, $FC, $FC, $00, $D8, $B4, $00, $00, $D8, $00, $FC, $FC, $FC, $24, $90, $D8, $00, $00, $D8, $6C, $B4, $D8, $FC, $00, $FC, $B4, $00, $B4, $90, $00,
    $90, $90, $D8, $FC, $24, $24, $48, $48, $48, $6C, $6C, $6C, $90, $B4, $B4, $D8, $00, $00, $00, $B4, $00, $00, $90, $00, $00, $D8, $D8, $B4, $B4, $B4, $90, $90, $90, $6C, $6C, $6C, $90, $6C, $B4, $D8, $00, $D8, $00, $00, $B4, $00, $00, $6C, $00, $90, $D8, $FC, $90, $6C, $00, $B4, $90, $00, $D8, $B4, $00, $FC, $FC, $00, $00, $00, $00, $FC, $FC, $00, $D8, $B4, $00, $00, $D8, $00, $FC, $FC, $FC, $24, $90, $D8, $00, $00, $D8, $6C, $B4, $D8, $FC, $00, $00, $B4, $00, $00, $90, $00, $00);
  DEFAULT_BACKGR_COLOR = clBlack;
  COLOR_WIDTH = 16;
  COLOR_HEIGHT = 16;
  PALETTE_WIDTH = COLOR_WIDTH * 16;
  PALETTE_HEIGHT = COLOR_HEIGHT * 16;
  COLOR_NUMBERS = 256;
  MAX_TILES_NUMS = 2048;
 //Capt: String; = Application.Title;//'Djinn Tile Mapper v1.4.9.9-beta';
  Ss: array[Boolean] of string[1] = ('*', '');
  BSZ: array[TTileType] of Byte = (1, 2, 2, 2, 2, 2, 3, 3, 4, 4, 4, 4, 4, 8, 8);
  CLR_CNT: array[TTileType] of Integer = (2, 4, 4, 4, 4, 4, 8, 8, 16, 16, 16, 16, 16, 256, 256);
var
  perenos, endt: byte;
  tblname: string;
  tblopened: boolean;
  ttblname: string;
  ttblopened: boolean;
  Table: TTable;
  TileTable: TTileTable;
  shiftprsd: boolean;
  DEditSet: set of Char;
  maxtlen: byte;
  maxSlen: iNTEGER;
  tlwidthv: integer;
  tlheightv: integer;
  tewidth, teheight: Integer;
  dewidth, deheight: Integer;
  OldRomSize: Integer;
  MapXY: array[0..2047] of TPoint;
  Map: array[0..127, 0..15] of Word;
  TileMap: array[0..15, 0..15] of Word;
  TileMapXY: array[0..15, 0..15] of TPoint;
  SelectTiles: BlockArr; //Времменный буфер для выделенных тайлов
  WSMap: BlockArr;
  Data: BlockArr; //Буфер для данных
  FCol, BCol: Byte;
  ROM: file;
  fname: string;
  ROMData: PROMdata = NIL;
  ROMSize: LongInt;
  ROMopened: Boolean = False;
  CDC: TTileType = tt2bitNES;
  BMap, BTile: tbitmap;
  DataPos, romDataPos: LongInt;
  CurBank: Integer;
  tmMouseX, tmMouseY: Integer;
  dataw, datah: Integer;
  dmMouseX, dmMouseY: Integer;
  CDPos: Integer;
  Saved: Boolean = False;
  Drawing: Boolean;
  col: Byte;
  tx, ty, mtx, mty: Integer;
  tilew: byte = 8;
  tileh: byte = 8;
  bSwapXY: Boolean = False;
  bDataMapGrid: Boolean = False;
  bTileMapGrid: Boolean = False;
  bTileEditGrid: Boolean = False;
  zw, zh: Word;
  bType: Boolean = False;
  bDraw: Boolean = False;
  bStep: Boolean = False;
  bEdit: Boolean = True;
  TileMask: Word;
  PatternSize: Byte;
  iTMWidth, iTMHeight: Byte; // Tile Map Sizes
  iWSWidth, iWSHeight: Byte; //Work Space Sizes
  bWorkSpace: Boolean = False;
  bWorkSpaceGrid: Boolean = False;
  iWSPos: Integer;
  TileWx2: Byte = 16;
  TileHx2: Byte = 16;
  BitReader: TBitReader;
  BitWriter: TBitWriter;
  wswidth: Byte;
  wsheight: Byte;
  bTMShowHex: Boolean = False;
  bGameMode: Boolean = False;
  bDMShowHex: Boolean = False;
  bTMMouseDown: Boolean = False;
  TileCaptured: Word;
  Bits: TBitReader;
  bTileMapChanged: Boolean = False;
  RBts: LongInt;
  CF_DTMDATA: Word; //Собственный формат для буфера обмена
  JumpList: TStringList;

  BorderPen, WhitePen: IGPPen;
implementation

uses
  Search, crtrd, srres, tmform, teditf, dataf, palf, WorkSpace, mi_MapImage, DIB,
  MetaTiles;

{$R *.dfm}

procedure IncPointer(var P: Pointer; Increment: Integer);
begin
  P := Pointer(LongWord(P) + Increment);
end;



{-------------------------------------------------------------------------------
  Процедура: SetSize
  Автор:    Marat
  Дата:  2018.03.21
  Входные параметры: P: array of TBlock; Size: Integer
  Результат:    Нет
  Процедура изменяет размер динамического массива и удаляет либо создаёт новые
  объекты
-------------------------------------------------------------------------------}
procedure SetSize(var P: BlockArr; Size: Integer);
var
  I: Integer;
  OldSize: Integer;
begin
  OldSize:= Length(P);
  if Size > OldSize then
  begin
    SetLength(P, Size);
    for I := OldSize to Size - 1 do
    begin
      P[I]:= TBlock.Create;
    end;
  end
  else
  if Size < OldSize then
  begin
    for I := Size to OldSize - 1 do
    begin
      P[I].Free;
    end;
    SetLength(P, Size);
  end;
end;



{-------------------------------------------------------------------------------
  Процедура: GameModeShow
  Автор:    Marat
  Дата:  2018.03.21
  Входные параметры: P: BlockArr; B: TBITMAP; Width, Height: Integer
  Результат:    Нет
  Отрисовывает изображение в полноцветном режиме
-------------------------------------------------------------------------------}
procedure GameModeShow(P: BlockArr; B: TBITMAP; Width, Height: Integer);
var
  MapImage: TMapImage;
  Stream: TStream;
  Pic: TDib;
  I, J: Integer;
  T: TBitmap;
  Value: Word;
  Color: TColor;
begin
  MapImage := TMapImage.Create;
  MapImage.MapFormat := mi_mapImage.TMapFormat(DTM.MapFormat);
  MapImage.TileType := mi_mapImage.TTileType(DTM.TileType);
  MapImage.Optimization := True;
  MapImage.Width := Width;
  MapImage.Height := Height;
  Stream := TMemoryStream.Create;
  if bSwapXY then
  begin
    for I := 0 to Height - 1 do
    begin
      begin
        for J := 0 to Width - 1 do
        begin
          case DTM.MapFormat of
            mfSingleByte,
            mfGBC:
              begin
                Stream.WriteBuffer(P[I * Width + J].Value, 1);
              end;
            mfGBA,
            mfSNES,
            mfPCE:
              begin
                Stream.WriteBuffer(P[I * Width + J].Value, 2);
              end;
            mfMSX:
              begin
                Value:= Swap(P[I * Width + J].Value);
                Stream.WriteBuffer(Value, 2);
              end;
          end;
        end;
      end;
    end;
  end
  else
  begin
    for I := 0 to Height - 1 do
    begin
      begin
        for J := 0 to Width - 1 do
        begin
          case DTM.MapFormat of
            mfSingleByte,
            mfGBC:
              begin
                Stream.WriteBuffer(P[J * Height + I].Value, 1);
              end;
            mfGBA,
            mfSNES,
            mfPCE:
              begin
                Stream.WriteBuffer(P[J * Height + I].Value, 2);
              end;
            mfMSX:
              begin
                Value:= Swap(P[J * Height + I].Value);
                Stream.WriteBuffer(Value, 2);
              end;
          end;
        end;
      end;
    end;
  end;
  Stream.Position := 0;
  MapImage.LoadMapFromStream(Stream, True);
  Stream.Position := 0;
  Stream.WriteBuffer(ROMData[DataPos], 2048 * 8 * bsz[DTM.TileType]);
  Stream.Position := 0;
  MapImage.LoadTilesFromStream(Stream);
  Stream.Position := 0;
  for I := 0 to 255 do
  begin
    Color:= DTM.Palette[I];
    Stream.WriteBuffer(Color, 3);
  end;
  Stream.Position := 0;
  MapImage.LoadPaletteFromStream(Stream);
  Stream.Free;
  Pic := TDIB.Create;
  Pic.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
  Pic.BitCount := 8;
  Pic.Width := MapImage.ImageWidth;
  Pic.Height := MapImage.ImageHeight;
  Pic.ColorTable := MapImage.Palette;
  Pic.UpdatePalette;
  MapImage.BufDraw(Pic.ScanLine[0]^, -Pic.WidthBytes);

  Pic.Canvas.Brush.Color := clWhite;
  Pic.Canvas.Brush.Style := bsClear;
  T := TBitmap.Create;
  T.Width := Pic.Width;
  T.Height := Pic.Height;
  T.Canvas.Draw(0, 0, Pic);
  B.Canvas.StretchDraw(Bounds(0, 0, B.Width, B.Height), T);
  T.Free;
  Pic.Free;
  MapImage.Free;
end;

procedure TDjinnTileMapper.DataMapDraw;
var
  P: BlockArr;
  xx, I, J, Index, yy: integer;
  Tile: Word;
  bbb, tilebmp: TBitmap;
  XFlip, YFlip: Boolean;
  PalSet: Byte;
  dest, src: TRect;
  w, h: Byte;
  x, y: Integer;
  BankPoint: TPoint;
  Width, Height, BlockCount, MetaTilesCount: Integer;
  StartTick: Integer;
begin
  tilebmp := TBitmap.Create;
  bbb := TBitmap.Create;
  if not bWorkSpace then
  begin
    bbb.width := dataform.datamap.Width;
    bbb.Height := dataform.datamap.Height;
    Width := dWidth;
    Height := dHeight;
    P:= Data;
  end
  else
  begin
    bbb.Width := WSForm.WorkSpace.Width;
    bbb.Height := WSForm.WorkSpace.Height;
    Width := iWSWidth;
    Height := iWSHeight;
    P:= WSMap;
  end;

  bbb.Canvas.Font.Color := $D0D0D0;
  bbb.Canvas.Font.style := [fsbold];
  bbb.Canvas.Brush.Color := 0;
  bbb.Canvas.FillRect(bounds(0, 0, bbb.width, bbb.height));

  if f_metatiles.Visible then
  begin
    h := Height div MTHeight;
    w := Width div MTWidth;
    BitReader.Seek(romDataPos * 8, soBeginning);
    for y := 0 to h - 1 do
    begin
      for x := 0 to w - 1 do
      begin
        Index := BitReader.Read(8 * PatternSize) * MTWidth * MTHeight;
        if Index < Length(MetaTiles.Map) then

        for yy := 0 to MTHeight - 1 do
        begin
          for xx := 0 to MTWidth - 1 do
          begin
            P[y * w * MTHeight * MTWidth + X * MTWidth + yy * MTWidth * w + xx].Value := MetaTiles.Map[Index + yy * MTWidth + xx].Value;
            P[y * w * MTHeight * MTWidth + X * MTWidth + yy * MTWidth * w + xx].Address := MetaTiles.Map[Index + yy * MTWidth + xx].Address;
          end;
        end;
      end;
    end;
  end;
  if bGameMode and (tilew = 8) and (tileh = 8) then
  begin
    GameModeShow(P, bbb, Width, Height);
  end
  else
  begin
    w := tilew;
    h := tileh;
    tilebmp.Width := w;
    tilebmp.Height := h;
    for I := Low(P) to High(P) do
    begin
      dest := bounds(P[I].x * TileWx2, P[I].y * TileHx2, TileWx2, TileHx2);
      src := Rect(0, 0, w, h);
      x := MapXY[P[I].Index].x * tilew;
      y := MapXY[P[I].Index].y * tileh;
      tilebmp.Canvas.CopyRect(Bounds(0, 0, w, h), bmap.Canvas, Bounds(x, y, w, h));
      Flip(tilebmp, P[I].H, P[I].V);
      bbb.Canvas.CopyRect(dest, tilebmp.Canvas, src);
    end; //end For..
  end;
  tilebmp.Free; //Уничтожение
  if not bWorkSpace then
  begin
    dataform.DataMap.Canvas.Draw(0, 0, bbb);
    bbb.free;  //Уничтожение
    if CDPos >= Width * Height then
      CDPos := Width * Height - 1;
    dataform.TileSelection.Left := (dataform.DataMap.Left div TileWx2) * TileWx2 + (dataform.DataMap.Left mod TileWx2) + Data[CDPos].x * TileWx2;
    dataform.TileSelection.Top := (dataform.DataMap.Top div TileHx2) * TileHx2 + (dataform.DataMap.Top mod TileHx2) + Data[CDPos].y * TileHx2;
    dataform.HexEd.Tag := 0;
    dataform.hexed.Text := IntToHex(Data[CDPos].Value, 4);
    dataform.HexEd.Tag := 1;
  end
  else
  begin
    WSForm.WorkSpace.Canvas.Draw(0, 0, bbb);
    bbb.free; //Уничтожение
    if iWSPos >= Width * Height then
      iWSPos := Width * Height - 1;
    WSForm.TileSelection.Left := (WSForm.WorkSpace.Left div TileWx2) * TileWx2 + (WSForm.WorkSpace.Left mod TileWx2) + WSMap[iWSPos].x * TileWx2;
    WSForm.TileSelection.Top := (WSForm.WorkSpace.Top div TileHx2) * TileHx2 + (WSForm.WorkSpace.Top mod TileHx2) + WSMap[iWSPos].y * TileHx2;
  end;
  if bDMShowHex then
  begin
    for I := Low(Data) to High(Data) do
    begin
      case DTM.MapFormat of
        mfSingleByte, mfGBC:
          begin
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2, Data[I].y * TileHx2, (Data[I].Index shr 4) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 5, Data[I].y * TileHx2, Data[I].Index and 15, True);

          end;
        mfSMS:
          begin
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2, Data[I].y * TileHx2, (Data[I].Index shr 8) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 5, Data[I].y * TileHx2, (Data[I].Index shr 4) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 10, Data[I].y * TileHx2, Data[I].Index and 15, True);
          end;
        mfGBA, mfSNES:
          begin
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2, Data[I].y * TileHx2, (Data[I].Index shr 8) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 5, Data[I].y * TileHx2, (Data[I].Index shr 4) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 10, Data[I].y * TileHx2, Data[I].Index and 15, True);

          end;
        mfMSX, mfPCE:
          begin
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2, Data[I].y * TileHx2, (Data[I].Index shr 8) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 5, Data[I].y * TileHx2, (Data[I].Index shr 4) and 15, True);
            HexNums.Draw(dataform.DataMap.Picture.Bitmap.Canvas, Data[I].x * TileWx2 + 10, Data[I].y * TileHx2, Data[I].Index and 15, True);

          end;
      end;

    end;
  end;
end;

procedure TDjinnTileMapper.DrawTile(WW, HH: Integer);
var
  X, Y, W, H, I, J: Integer;
  Src, Dest: TRect;
  TileNum: Word;
  CellSize: Byte;
begin
  bTile.Canvas.Brush.Color := 0;
  btile.Width := tilew * WW;
  btile.Height := tileh * HH;
  bTile.Canvas.FillRect(Bounds(0, 0, btile.Width, btile.Height));

  teditform.caption := 'Тайл #' + inttohex(curbank, 4) + ' - [' + inttohex(datapos + Bank * ((tilew * tileh) div (8 div bsz[TileType]) - 1 * byte((bank * tilew * tileh) mod (8 div bsz[TileType]) > 0)) * bsz[TileType], 8) + ']';

  for I := 0 to HH - 1 do
  begin
    for J := 0 to WW - 1 do
    begin
      TileNum := TileMap[I, J];
      X := MapXY[TileNum].X * tilew;
      Y := MapXY[TileNum].Y * tileh;
      W := tilew;
      H := tileh;
      if (X + W) >= bMap.Width then
        X := bMap.Width - W;
      if (Y + H) >= bMap.Height then
        Y := bMap.Height - H;
      Src := Rect(X, Y, X + W, Y + H);
      Dest := Bounds(J * tilew, I * tileh, W, H);
      btile.Canvas.CopyRect(Dest, bmap.Canvas, Src);
    end;
  end;
  fill(teditform.Tile, 0);

  CellSize := Min(zw div bTile.Width, zh div btile.Height);
  if (btile.width <= 8) and (btile.height <= 8) then
    teditform.Tile.Canvas.CopyRect(Bounds(0, 0, zw, zh), bTile.Canvas, Bounds(0, 0, tilew, tileh))
  else
    teditform.Tile.Canvas.CopyRect(Bounds(0, 0, (CellSize) * btile.Width, (CellSize) * btile.Height), bTile.Canvas, Bounds(0, 0, btile.Width, btile.Height));
  if bTileEditGrid then
  begin
    DrawGrid(teditform.Tile.Picture.Bitmap, CellSize, CellSize, tilew, tileh);
  end;
end;

procedure TDjinnTileMapper.SetDataMapWidth(W: Integer);
begin
  if W < 1 then
    W := 1;
  dataform.DataMap.Picture.Bitmap.Width := TileWx2 * W;
  dataform.Datamap.Width := TileWx2 * W;
  dataform.Grid.Width := TileWx2 * W;
  dataform.Grid.Picture.Bitmap.Width := TileWx2 * W;
  dataform.Datamap.Left := 0; //(dataform.Panel1.Width - (dataform.datamap.Width + dataform.DataScroll.Width)) div 2;
  dataform.Datamap.Top := 0; //(dataform.Panel1.Height - dataform.datamap.Height) div 2;
  dataform.DataScroll.Left := dataform.Datamap.Left + dataform.Datamap.Width;
  dataw := W;
  if ROMopened then
  begin
    UpdateData(romDataPos);
    DataMapRedraw;
  end;
end;

procedure TDjinnTileMapper.SetDataMapHeight(H: Integer);
begin
  if H < 1 then
    H := 1;
  dataform.DataMap.Picture.Bitmap.Height := TileHx2 * H;
  dataform.Datamap.Height := TileHx2 * H;
  dataform.Grid.Height := TileHx2 * H;
  dataform.Grid.Picture.Bitmap.Height := TileHx2 * H;
  dataform.Datamap.Left := 0; //(dataform.Panel1.Width - (dataform.datamap.Width + dataform.DataScroll.Width)) div 2;
  dataform.Datamap.Top := 0; //(dataform.Panel1.Height - dataform.datamap.Height) div 2;
  dataform.DataScroll.Top := dataform.Datamap.Top;
  dataform.dataScroll.Height := dataform.Datamap.Height;
  datah := H;

  if ROMopened then
  begin
    UpdateData(romDataPos);
    DataMapRedraw;
  end;
end;

function TDjinnTileMapper.GetDataMapWidth: Integer;
begin
  result := dataw;
end;

function TDjinnTileMapper.GetDataMapHeight: Integer;
begin
  result := datah;
end;

procedure TDjinnTileMapper.SetCol(I: Integer; const Value: TColor);
begin
  Palette[BigPalSet * 16 + SmallPalSet * CLR_CNT[TileType] + I]:= Value;
end;

procedure TDjinnTileMapper.SetColor(I: Integer; const Value: TColor);
begin
  FPalette[I]:= Value;
end;

procedure TDjinnTileMapper.SetCurBank(n: integer);
begin
  if ROMopened then
  begin
    CurBank := n;
  end;
end;

function TDjinnTileMapper.GetCol(I: Integer): TColor;
begin
  Result:= Palette[BigPalSet * 16 + SmallPalSet * CLR_CNT[TileType] + I];
end;

function TDjinnTileMapper.GetColor(I: Integer): TColor;
begin
  Result:= FPalette[I];
end;

function TDjinnTileMapper.GetCurBank: Integer;
begin
  Result := CurBank;
end;

procedure TDjinnTileMapper.SetdBank(n: integer);
begin
  if ROMopened then
  begin
    CdPos := n;
    DataMapDraw;
  end;
end;

function TDjinnTileMapper.Getdbank: integer;
begin
  Result := Cdpos;
end;

procedure TDjinnTileMapper.ReadTile(TilePos: Integer; X, Y: Integer);
var
  //X, Y координаты тайла в bmap
  XX, YY: Integer; // координаты пикселя в тайле bmap
  Tile4bit: TTile4bit;
  Tile2bitNES: TTile2bit_NES;
  Tile2bit: TTile2bit;
  Tile2bitMSX: TTile2bit_MSX;
  Tile3bit: TTile3bit;
  Tile8bit: TTile8bit;
  Col, Src1, Src2: Byte;
  B0, B1, B2, B3, B4, B5, B6, B7, B8: PByte;
begin
  case TileType of
    tt1bit:
      begin
        for YY := 0 to tileh - 1 do
        begin
          for XX := 0 to tilew - 1 do
          begin
            Col := BitReader.Read;
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
          end;
        end;
      end;
    tt2bitMSX:
      begin
        Move(ROMData^[TilePos], Tile2bitMSX, SizeOf(TTile2bit_MSX));
        for YY := 0 to 7 do
        begin
          Src1 := Tile2bitMSX[0, 0, YY]; //1 бит
          Src2 := Tile2bitMSX[1, 0, YY]; //2 бит
          for XX := 0 to 7 do
          begin
            Col := ((Src1 shr (7 - XX)) and 1) or ((Src2 shr (7 - XX) and 1) shl 1);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
          end;
        end;
      end;
    tt2bitVB:
      begin
        Move(ROMData^[TilePos], Tile2bit, SizeOf(TTile2bit));
        for YY := 0 to 7 do
        begin
          Src1 := Tile2bit[YY, 0]; //4 пикселя слева
          Src2 := Tile2bit[YY, 1]; //4 пикселя справа
          for XX := 0 to 3 do
          begin
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[((Src1 shr (XX * 2)) and 3)];
            bmap.Canvas.Pixels[X * tilew + XX + 4, Y * tileh + YY] := Color[((Src2 shr (XX * 2)) and 3)];
          end;
        end;
      end;
    tt2bitNGP:
      begin
        Move(ROMData^[TilePos], Tile2bit, SizeOf(TTile2bit));
        for YY := 0 to 7 do
        begin
          Src1 := Tile2bit[YY, 1]; //4 пикселя слева
          Src2 := Tile2bit[YY, 0]; //4 пикселя справа
          for XX := 0 to 3 do
          begin
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[((Src1 shr ((3 - XX) * 2)) and 3)];
            bmap.Canvas.Pixels[X * tilew + XX + 4, Y * tileh + YY] := Color[((Src2 shr ((3 - XX) * 2)) and 3)];
          end;
        end;
      end;
    tt2bitGBC:
      begin
        Move(ROMData^[TilePos], Tile2bit, SizeOf(TTile2bit));
        for YY := 0 to 7 do
        begin
          Src1 := Tile2bit[YY, 0];
          Src2 := Tile2bit[YY, 1];
          for XX := 0 to 7 do
          begin
            Col := ((Src1 and $80) shr 7) or (Src2 and $80) shr 6;
            Src1 := Src1 shl 1;
            Src2 := Src2 shl 1;
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
            ;
          end;
        end;
      end;
   { tt2bitNESKONAMI:
      begin
        for YY := 0 to tileh - 1 do
        begin
          for XX := 0 to tilew - 1 do
          begin
            Color:= Bits[TilePos + YY * tilew + XX] or (Bits[TilePos + tilew * tileh + YY * tilew + XX] shl 1);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY]:= Palette[Color];
          end;
        end;
      end; }
    tt2bitNES:
      begin
        for YY := 0 to tileh - 1 do
        begin
          for XX := 0 to tilew - 1 do
          begin
            Col := BitReader[TilePos + YY * tilew + XX] or (BitReader[TilePos + tilew * tileh + YY * tilew + XX] shl 1);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
          end;
        end;
      end;
    tt3bitSNES:
      begin
        Move(ROMData^[TilePos], Tile3bit, SizeOf(TTile3bit));
        B1 := @Tile3bit[0, 0];
        B2 := @Tile3bit[0, 1];
        B3 := @Tile3bit[4, 0];
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := ((B1^ and $80) shr 7) or ((B2^ and $80) shr 6) or ((B3^ and $80) shr 5);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
            B1^ := B1^ shl 1;
            B2^ := B2^ shl 1;
            B3^ := B3^ shl 1;
          end;
          Inc(B1, 2);
          Inc(B2, 2);
          Inc(B3);
        end;
      end;
    tt3bit:
      begin
        Move(ROMData^[TilePos], Tile3bit, SizeOf(TTile3bit));
        B1 := @Tile3bit[0, 0];
        B2 := @Tile3bit[2, 0];
        B3 := @Tile3bit[4, 0];
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := ((B1^ and $80) shr 7) or ((B2^ and $80) shr 6) or ((B3^ and $80) shr 5);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
            B1^ := B1^ shl 1;
            B2^ := B2^ shl 1;
            B3^ := B3^ shl 1;
          end;
          Inc(B1);
          Inc(B2);
          Inc(B3);
        end;
      end;
    tt4bitSNESM:
      begin
        Move(ROMData^[TilePos], Tile4bit, SizeOf(TTile4bit));
        B1 := @Tile4bit[0, 0];
        B2 := @Tile4bit[0, 1];
        B3 := @Tile4bit[4, 0];
        B4 := @Tile4bit[4, 1];
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := (B1^ and 1) or ((B2^ and 1) shl 1) or ((B3^ and 1) shl 2) or ((B4^ and 1) shl 3);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
            B1^ := B1^ shr 1;
            B2^ := B2^ shr 1;
            B3^ := B3^ shr 1;
            B4^ := B4^ shr 1;
          end;
          Inc(B1, 2);
          Inc(B2, 2);
          Inc(B3, 2);
          Inc(B4, 2);
        end;
      end;
    tt4bitSNES:
      begin
        Move(ROMData^[TilePos], Tile4bit, SizeOf(TTile4bit));
        B1 := @Tile4bit[0, 0];
        B2 := @Tile4bit[0, 1];
        B3 := @Tile4bit[4, 0];
        B4 := @Tile4bit[4, 1];
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := ((B1^ and $80) shr 7) or ((B2^ and $80) shr 6) or ((B3^ and $80) shr 5) or ((B4^ and $80) shr 4);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col];
            B1^ := B1^ shl 1;
            B2^ := B2^ shl 1;
            B3^ := B3^ shl 1;
            B4^ := B4^ shl 1;
          end;
          Inc(B1, 2);
          Inc(B2, 2);
          Inc(B3, 2);
          Inc(B4, 2);
        end;
      end;
    tt4bitSMS:
      begin
        Move(ROMData^[TilePos], Tile4bit, SizeOf(TTile4bit));
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := ((Tile4bit[YY, 3] shr (7 - XX) and 1) shl 3) or ((Tile4bit[YY, 2] shr (7 - XX) and 1) shl 2) or ((Tile4bit[YY, 1] shr (7 - XX) and 1) shl 1) or (Tile4bit[YY, 0] shr (7 - XX) and 1);
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[Col]; //Первый пиксел в байте
          end;
        end;
      end;
    tt4bit:
      begin
        Move(ROMData^[TilePos], Tile4bit, SizeOf(TTile4bit));
        for YY := 0 to 7 do
        begin
          for XX := 0 to 3 do
          begin
            bmap.Canvas.Pixels[X * tilew + XX * 2, Y * tileh + YY] := Color[Tile4bit[YY, XX] and $F]; //Первый пиксел в байте
            bmap.Canvas.Pixels[X * tilew + XX * 2 + 1, Y * tileh + YY] := Color[Tile4bit[YY, XX] shr 4]; //Второй пиксель в байте
          end;
        end;
      end;
    tt4bitMSX:
      begin
        for YY := 0 to tileh - 1 do
        begin
          for XX := 0 to tilew - 1 do
          begin
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Color[BitReader.Read(4)];
          end;
        end;
     end;
    tt8bitSNES:
      begin
        Move(ROMData^[TilePos], Tile8bit, SizeOf(TTile8bit));
        B0 := @Tile8bit[0, 0];
        B1 := @Tile8bit[0, 1];
        B2 := @Tile8bit[2, 0];
        B3 := @Tile8bit[2, 1];
        B4 := @Tile8bit[4, 0];
        B5 := @Tile8bit[4, 1];
        B6 := @Tile8bit[6, 0];
        B7 := @Tile8bit[6, 1];
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := ((B0^ and $80) shr 7) or ((B1^ and $80) shr 6) or ((B2^ and $80) shr 5) or ((B3^ and $80) shr 4) or
           ((B4^ and $80) shr 3) or ((B5^ and $80) shr 2) or ((B6^ and $80) shr 1) or (B7^ and $80);

            B0^:= B0^ shl 1; B1^:= B1^ shl 1; B2^:= B2^ shl 1; B3^:= B3^ shl 1;
            B4^:= B4^ shl 1; B5^:= B5^ shl 1; B6^:= B6^ shl 1; B7^:= B7^ shl 1;

            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Palette[Col];
          end;
          Inc(B0, 2); Inc(B1, 2); Inc(B2, 2); Inc(B3, 2);
          Inc(B4, 2); Inc(B5, 2); Inc(B6, 2); Inc(B7, 2);
        end;
      end;

    tt8bit:
      begin
        Move(ROMData^[TilePos], Tile8bit, SizeOf(TTile8bit));
        for YY := 0 to 7 do
        begin
          for XX := 0 to 7 do
          begin
            Col := Tile8bit[YY, XX];
            bmap.Canvas.Pixels[X * tilew + XX, Y * tileh + YY] := Palette[Col];
          end;
        end;
      end;
  end;
end;

procedure TDjinnTileMapper.DrawTileMap;
var
  TilePos, X, Y, I: Integer;
  PMap: PWORD;
  //TileSize: Word;
  RowCount: Byte;
  //Temp: PByteArray;
  //UnPackTiles: Integer;
begin
  PMap := @Map;
  bmap.Canvas.Brush.Style := bsSolid;
  bmap.Canvas.Brush.Color := clBlack;
  bmap.Canvas.FillRect(Rect(0, 0, bmap.Width, bmap.Height));
  bmap.Canvas.Brush.Style := bsClear;
  RowCount := MAX_TILES_NUMS div 16;
  if ((OldROMSize - DataPos) * 8) < (16 * 128 * bsz[TileType] * tilew * tileh) then
    RowCount := ((OldROMSize - DataPos) * 8) div (16 * tilew * tileh * bsz[TileType]);


  {  if TileType = tt2bitNESKONAMI then
  begin
        GetMem(Temp, RowCount * 16 * 8 * bsz[TileType]);
        Bits:= TBitReader.Create(Temp[0], 2048 * 8* bsz[TileType]);
        BitReader.Seek(DataPos * 8, soBeginning);
        UnPackTiles:= 0;
        while True do
        begin
          Length:= BitReader.Read(8);
          case Length of
            0..127:
              begin
                Value:= BitReader.Read(8);
                while Length > 0 do
                begin
                  Bits.Write(Value, 8);
                  Dec(Length);
                  Inc(UnPackTiles);
                  if UnPackTiles = (RowCount * 16 * 16) then
                    Break;
                end;
                if UnPackTiles = (RowCount * 16 * 16) then
                  Break;
              end;
            128..254:
              begin
                Length:= Length and $7F;
                while Length > 0 do
                begin
                  Bits.Write(BitReader.Read(8), 8);
                  Dec(Length);
                  Inc(UnPackTiles);
                  if UnPackTiles = (RowCount * 16 * 16) then
                    Break;
                end;
                if UnPackTiles = (RowCount * 16 * 16) then
                  Break;
              end;
          end;
        end;
    end;

 }
  for Y := 0 to RowCount - 1 do
    for X := 0 to 16 - 1 do
    begin
      case TileType of
        tt1bit:
          begin
            TilePos := DataPos + PMap^ * ((tilew * tileh) div 8);
            BitReader.Seek((DataPos * 8) + (PMap^ * tilew * tileh), soBeginning);
          end;
        tt2bitNES:
          TilePos := DataPos * 8 + PMap^ * tilew * tileh * bsz[TileType];
        tt2bitGBC, tt2bitNGP, tt2bitVB:
          TilePos := DataPos + PMap^ * 16;
        tt2bitMSX:
          TilePos := DataPos + (PMap^ div 4) * 64 + (PMap^ mod 4) * 8;
        tt3bitSNES, tt3bit:
          TilePos:= DataPos + PMap^ * 24;
        tt4bit,
        tt4bitSNESM,
        tt4bitSNES,
        tt4bitSMS:
          begin
            TilePos := DataPos + PMap^ * 32;
          end;
        tt4bitMSX:
          begin
            TilePos := DataPos + PMap^ * ((tilew * tileh) div 32);
            BitReader.Seek((DataPos * 8) + (PMap^ * tilew * tileh * bsz[TileType]), soBeginning);
          end;
        tt8bit,
        tt8bitSNES:
          begin
            TilePos := DataPos + PMap^ * 64;
          end;
      end;

      Inc(PMap);
      ReadTile(TilePos, X, Y);
    end;
{
  if TileType = tt2bitNESKONAMI then
  begin
    FreeMem(Temp, RowCount * 16 * 8 * bsz[TileType]);
    Bits.Free;
  end; }
  tilemapform.TileMap.Canvas.StretchDraw(Bounds(0, 0, tilewx2 * 16, TileHx2 * 128), bmap);
  I := 0;
  if RowCount <> 128 then
  begin
    I := RowCount * 16;
    for Y := RowCount to 128 - 1 do
      for X := 0 to 15 do
      begin
        ToolBarCold.Draw(TileMapForm.TileMap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, 59, True);
        Inc(I);
      end;
  end;

  ShowHexNumbers();
  bTileMapChanged := True;
  DataMapDraw;
end;

procedure TDjinnTileMapper.MapScrollEnable;
var
  LargeChange: Integer;
begin
  //$4000 - размер занимаемый 2048 тайлами * 32 / 4 bit per pixel
  //$800 - количество тайлов на экране тайл мэп форм
  //$10 - количество тайлов в строке tile map form
  //256 - количество тайлов видимых в один момент времени на форме

  tilemapform.tMapscroll.Max := OldROMsize - 16 * 8 * bsz[TileType];
  LargeChange := tileh * 256 * bsz[TileType];
  if LargeChange > 32767 then
    LargeChange := 32767;
  tilemapform.tMapscroll.LargeChange := LargeChange;
  tilemapform.tMapscroll.SmallChange := tileh * (tlwidthv * tlheightv) * $10 * bsz[TileType];
  with Tilemapform do
  begin
    tbBOF.Enabled := True;
    tbBlockMinus100.Enabled := True;
    tbBlockMinus10.Enabled := True;
    tbBlockMinus1.Enabled := True;
    tbMinus1.Enabled := True;
    tbPlus1.Enabled := True;
    tbBlockPlus1.Enabled := True;
    tbBlockPlus10.Enabled := True;
    tbBlockPlus100.Enabled := True;
    tbEOF.Enabled := True;
    tbGoTo.Enabled := True;
  end;
  DrawTile(tewidth, teheight);
end;

procedure TDjinnTileMapper.DataScrollEnable;
begin
  //DWidth - ширина, DHeight - высота карты
  dataform.Datascroll.Max := ROMsize - DWidth * DHeight * PatternSize;
  dataform.Datascroll.LargeChange := DWidth * DHeight;
  dataform.Datascroll.SmallChange := DWidth;
  dataform.Datascroll.Enabled := True;
  dataform.dLeftBtn.Enabled := True;
  dataform.dRightBtn.Enabled := True;
  dataform.HexEd.Enabled := true;
  dataform.HexEd.Color := clWindow;
end;

procedure TDjinnTileMapper.SetPos(P: LongInt);
begin
  DataPos := P;
  Caption := Application.Title + ' - [' + ExtractFileName(fname) + ']' + SS[Saved];
  TileMapForm.Caption := 'Тайлы ' + IntToHex(DataPos, 6);
  TileMapForm.stat1.Panels.Items[0].Text := 'Адрес : ' + IntToHex(DataPos, 6) + ' / ' + IntToHex(ROMSize, 6);
  DrawTileMap;
end;

function TDjinnTileMapper.GetPos: LongInt;
begin
  Result := Datapos;
end;

procedure TDjinnTileMapper.SetROMPos(P: LongInt);
begin
  romDataPos := P;
  UpdateData(P);
  dataform.Caption := 'Карта тайлов - [' + IntToHex(P, 8) + ' / ' + inttohex(romsize, 8) + ']';
  DataScrollEnable;
  DataMapDraw;
end;

procedure TDjinnTileMapper.SetSmallPalSet(const Value: Byte);
begin
  FSmallPalSet:= Value;
  RedrawPalette();
  if ROMopened then
  begin
    DTM.DrawTileMap();
    DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  end;
end;

function TDjinnTileMapper.GetrPos: LongInt;
begin
  Result := romDatapos;
end;

function TDjinnTileMapper.GetSmallPalSet: Byte;
begin
  Result:= FSmallPalSet;
end;

procedure TDjinnTileMapper.Fill(var Im: TImage; Clr: TColor);
var
  c: tcolor;
  s: tbrushstyle;
begin
  with Im do
  begin
    c := Canvas.Brush.Color;
    s := Canvas.Brush.Style;
    canvas.Brush.Style := bssolid;
    Canvas.Brush.Color := Clr;
    Canvas.FillRect(Bounds(0, 0, Width, Height));
    Canvas.Brush.Color := c;
    canvas.brush.Style := s;
  end;
end;


procedure TDjinnTileMapper.SetForegroundColor(n: byte);
begin
  FCol := n;
  RedrawPalette();
end;

function TDjinnTileMapper.GetForegroundColor: byte;
begin
  Result := FCol;
end;

procedure TDjinnTileMapper.SetBackGroundColor(n: byte);
begin
  BCol := n;
  RedrawPalette();
end;

procedure TDjinnTileMapper.SetBigPalSet(const Value: Byte);
begin
  FBigPalSet:= Value;
  RedrawPalette();
end;

function TDjinnTileMapper.GetBackGoundColor: byte;
begin
  Result := BCol;
end;

function TDjinnTileMapper.GetBigPalSet: Byte;
begin
  Result:= FBigPalSet;
end;

procedure TDjinnTileMapper.FormShow(Sender: TObject);
var
  e: string;
  iHeight, I, N, X, Y: Integer;
begin
  PatternSize := 2;
  iWSWidth := 32;
  iWSHeight := 30;
  wswidth := 1;
  wsheight := 1;
  SetLength(WSMap, iWSWidth * iWSHeight);
  I:= 0;
  for Y := 0 to iWSHeight - 1 do
  begin
    for X := 0 to iWSWidth - 1 do
    begin
      WSMap[I] := TBlock.Create;
      WSMap[I].Value := 0;
      WSMap[I].X := X;
      WSMap[I].Y := Y;
      WSMap[I].Address := I * PatternSize;
      Inc(I);
    end;
  end;

  I:= 0;
  SetLength(MetaTiles.Map, MapWidth * MapHeight);
  for Y := 0 to MapHeight - 1 do
  begin
    for X := 0 to MapWidth - 1 do
    begin
      MetaTiles.Map[I] := TBlock.Create;
      MetaTiles.Map[I].Value := 0;
      MetaTiles.Map[I].X := X;
      MetaTiles.Map[I].Y := Y;
      MetaTiles.Map[I].Address := I * PatternSize;
      Inc(I);
    end;
  end;

  bWorkSpace := False;
  bWorkSpaceGrid := False;
  iWSPos := 0;
  iTMWidth := 16;
  iTMHeight := 128;
  bTMShowHex := False;
  MapFormat := mfMSX;
  tilew := 8;
  tileh := 8;
  TileWx2 := tilew * 3;
  TileHx2 := tileh * 3;
  bSwapXY := True;
  bDataMapGrid := False;
  bTileMapGrid := False;
  bTileEditGrid := False;
  bTileMapChanged := False;
  bEdit := True;
  bGameMode := False;
  bDMShowHex := False;
  zw := 256;
  zh := 256;
  teditform.DoubleBuffered := True;
  tilemapform.DoubleBuffered := True;
  dataform.DoubleBuffered := True;
  //WSForm.DoubleBuffered:= True;
  crtransform.caption := Application.Title;
  perenos := $ff;
  endt := 0;
  tlwidthv := 1;
  tlheightv := 1;
  tewidth := 1;
  teheight := 1;
  dewidth := 1;
  deheight := 1;
  btile := tbitmap.create;
  bmap := tbitmap.create;
  bmap.PixelFormat := pf24bit;
  btile.PixelFormat := pf24bit;
  TileMapForm.SetSize(iTMWidth, iTMHeight);
  InitPoses();
  dataform.show;
  tilemapform.show;
  teditform.show;
  PalForm.Show;
  shiftprsd := False;
  Drawing := False;
  ROMopened := false;
  TBLopened := false;
  TileType := tt2bitNES;
  Caption := Application.Title;
  Fill(tilemapform.TileMap, 0);
  Fill(teditform.Tile, 0);
  Fill(dataform.DataMap, 0);
  Fill(WSForm.WorkSpace, 0);
  tilemapform.ChangeMap(tlwidthv, tlheightv);
  TileMap[0, 0] := 0;

  for I := 0 to 63 do
  begin
    Palette[I] := RGB(DefaultPal[I * 3], DefaultPal[I * 3 + 1], DefaultPal[I * 3 + 2]);
  end;
  Foreground := 3;
  Background := 0;
  tilemapform.Tilemap.canvas.Pen.Color := clWhite;
  tilemapform.Tilemap.canvas.brush.Style := bsClear;
  dataform.datamap.canvas.Pen.Color := clWhite;
  dataform.datamap.canvas.brush.Style := bsClear;
  PalForm.Canvas.Pen.Color := clWhite;
  PalForm.Canvas.Brush.Style := bsClear;
  WSForm.WorkSpace.Canvas.Pen.Color := clWhite;
  WSForm.Canvas.Brush.Style := bsClear;
  WSForm.WorkSpace.Picture.Bitmap.Canvas.Brush.Style := bsClear;
  dWidth := 32;
  dHeight := 30;
  SetLength(Data, dWidth * dHeight);
  I:= 0;
  for Y := 0 to dHeight - 1 do
  begin
    for X := 0 to dWidth - 1 do
    begin
      Data[I] := TBlock.Create;
      Data[I].Value := 0;
      Data[I].X := X;
      Data[I].Y := Y;
      Data[I].Address := I * PatternSize;
      Inc(I);
    end;
  end;
  for I := 0 to 3 do
  begin
    dataform.PalBox.Items.Add('Палитра ' + IntToStr(I));
  end;


  //*******Установка кратности Зума***************//
  iHeight := GetSystemMetrics(SM_CXSCREEN);
  N := iHeight div 128;
  for I := 0 to N - 2 do
  begin
    teditform.zoomx.Items.Add('Zoom x' + IntToStr(I + 2));
  end;
  teditform.zoomx.ItemIndex := 0;
  //**********************************************//
  if ParamCount >= 1 then
  begin
    fname := ParamStr(1);
    e := UpperCase(ExtractFileExt(FName));
    if e = '.NES' then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNES)
    else
    if (e = '.GB') or (e = '.GBC') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitGBC)
    else
    if e = '.GBA' then
      tilemapform.codecBox.ItemIndex := Byte(tt4bit)
    else
    if (e = '.SMC') or (e = '.FIG') or (e = '.PCE') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitSNES)
    else
    if (e = '.BIN') or (e = '.GEN') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitMSX)
    else
    if (e = '.SMS') or (e = '.GG') or (e = '.WSC') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitSMS)
    else
    if (e = '.VB') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitVB)
    else
    if (e = '.NGC') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNGP)
    else
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNES);
    TileType := TTileType(tilemapform.codecBox.ItemIndex);
    ROMopen;
  end;
end;

procedure TDjinnTileMapper.ExitItemClick(Sender: TObject);
begin
  Close;
end;

procedure TDjinnTileMapper.ROMopen;
var
  MinSize, I: Integer;
  S: string;
begin
  AssignFile(ROM, fname);
  Reset(ROM, 1);
  if ROMopened then
  begin
    FreeMem(ROMdata, ROMsize);
    BitReader.Free;
    BitWriter.Free;
    JumpList.Free;
    InitAllJumpLists;
  end;
  JumpList:= TStringList.Create;
  ROMsize := FileSize(ROM);
  dataform.stat1.Panels.Items[0].Text := 'Адрес : 000000 / ' + IntToHex(ROMSize, 6);
  TileMapForm.stat1.Panels.Items[0].Text := 'Адрес : 000000 / ' + IntToHex(ROMSize, 6);
  OldRomSize := ROMSize;
  MinSize := 16 * 128 * 4 * 16;
  if ROMsize < MinSize then
    ROMsize := MinSize;
  GetMem(ROMData, ROMsize);
  BitReader := TBitReader.Create(ROMData[0], ROMSize);
  BitWriter := TBitWriter.Create(ROMData[0], ROMSize);
  BlockRead(ROM, ROMData^, ROMSize, RBts);
  UpdateData(0);
  S:= ExtractFileName(fname)  + '.jumplist';
  if FileExists(S) then
  begin
    JumpList.LoadFromFile(S);
    InitAllJumpLists;
  end;
  CloseFile(ROM);
  Saved := True;
  ROMopened := true;
  tilemapform.tMapscroll.position := 0;
  ROMpos := 0;
  MapScrollEnable;
  tilemapform.TMapScroll.position := 0;
  DataScrollEnable;
  dataform.DataScroll.position := 0;
  f_metatiles.MetaScrollEnable;
  f_metatiles.MetaScroll.Position:= 0;
  romdatApos := 0;
 // if tilemapform.visible then
 //   tilemapform.tMapscroll.SetFocus;
  TileMapMenu.Enabled := true;
  DataMapMenu.Enabled := true;
  ReloadItem.Enabled := True;
  SaveItem.Enabled := True;
  SaveAsItem.Enabled := True;

  with teditform do
  begin
    mVlEFTbTN.Enabled := true;
    mVRightbTN.Enabled := true;
    mVUpbTN.Enabled := true;
    mVDownbTN.Enabled := true;
    FlipbTN.Enabled := true;
    ClearBtn.Enabled := true;
    Flip2bTN.Enabled := true;
    RotLeftbTN.Enabled := true;
    RotRightbTN.Enabled := true;
    tbShowGrid.Enabled := True;
    tbOpenBitmap.Enabled:= True;
    tbSaveBitmap.Enabled:= True;
    tbPen.Enabled:= True;
    tbPen.Down:= True;
    tbEditDropper.Enabled:= True;
    tbFiller.Enabled:= True;
    zoomx.Enabled:= True;
  end;

  with dataform do
  begin
    SwapXY.Enabled := True;
    databox.Enabled := True;
    DataMapGrid.Enabled := True;
    FlipX.Enabled := True;
    FlipY.Enabled := True;
    Prt.Enabled := True;
    PalBox.Enabled := True;
    cbMapFormat.Enabled := True;
    tbGoTo.Enabled := True;
    sbUp.Enabled := True;
    sbDown.Enabled := True;
    tbSaveMap.Enabled := True;
    tbShowHexNums.Enabled := True;
    tbShowGameMode.Enabled := True;
    tbJumpList.Enabled:= True;
    tbSelectTiles.Enabled:= True;
  end;


  with tilemapform do
  begin
    cbHV.Enabled := True;
    TileEditSize.Enabled := True;
    TileMapGrid.Enabled := True;
    twidth.Enabled := True;
    theight.Enabled := True;
    tlwidth.Enabled := True;
    tlheight.Enabled := True;
    tbAddBookmark.Enabled:= True;
  end;

  with f_metatiles do
  begin
    tbGoTo.Enabled:= True;
    seMapWidth.Enabled:= True;
    seMapHeight.Enabled:= True;
    seWidth.Enabled:= True;
    seHeight.Enabled:= True;
    cbDirection.Enabled:= True;
    cbMapFormat.Enabled:= True;
    tbBookmark.Enabled:= True;
  end;
  if TBLopened then
    InitDataEdit;
end;

procedure TDjinnTileMapper.OpenItemClick(Sender: TObject);
var
  e: string;
begin
  if OpenRom.Execute then
  begin
    fname := OpenRom.FileName;
    e := UpperCase(ExtractFileExt(FName));
    if e = '.NES' then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNES)
    else
    if (e = '.GB') or (e = '.GBC') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitGBC)
    else
    if e = '.GBA' then
      tilemapform.codecBox.ItemIndex := Byte(tt4bit)
    else
    if (e = '.SMC') or (e = '.FIG') or (e = '.PCE') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitSNES)
    else
    if (e = '.BIN') or (e = '.GEN') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitMSX)
    else
    if (e = '.SMS') or (e = '.GG') or (e = '.WSC') then
      tilemapform.codecBox.ItemIndex := Byte(tt4bitSMS)
    else
    if (e = '.VB') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitVB)
    else
    if (e = '.NGC') then
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNGP)
    else
      tilemapform.codecBox.ItemIndex := Byte(tt2bitNES);
    TileType := TTileType(tilemapform.codecBox.ItemIndex);
    ROMOpen();
  end;
end;

procedure TDjinnTileMapper.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin

  if ROMopened then
  begin
    WSForm.Close;
    BitReader.Free;
    BitWriter.Free;
    FreeMem(ROMdata, ROMsize);
    JumpList.Free;
  end;

  SetSize(SelectTiles, 0);
  SetSize(Data, 0);
  SetSize(WSMap, 0);
  SetSize(MetaTiles.Map, 0);
  bmap.free;
  btile.free;
end;

procedure TDjinnTileMapper.FormCreate(Sender: TObject);
begin
  BorderPen:= TGPPen.Create($FF000000, 1);
  WhitePen:= TGPPen.Create($FFFFFFFF, 1);
  BorderPen.SetDashPattern([4, 4]);
  BorderPen.DashOffset:= 0;
end;

function HexVal(s: string; var err: Boolean): LongInt;

  function sign(h: Char): Byte;
  begin
    if h in ['0'..'9'] then
      Result := Byte(h) - 48
    else
      Result := Byte(h) - 55;
  end;

const
  hs: array[1..8] of LongInt = ($1, $10, $100, $1000, $10000, $100000, $1000000, $10000000);
var
  i: Byte;
begin
  if Length(s) <= 8 then
  begin
    for i := 1 to Length(s) do
    begin
      if not (s[i] in ['0'..'9', 'A'..'F', 'a'..'f']) then
      begin
        err := True;
        Exit;
      end;
    end;
    Result := 0;
    for i := 1 to Length(s) do
      Inc(Result, sign(s[i]) * hs[length(s) + 1 - i]);
  end
  else
  begin
    err := True;
  end;
end;

procedure TDjinnTileMapper.GoTo1Click(Sender: TObject);
var
  s: string;
  v: LongInt;
begin
  s := UpperCase(InputForm.Inputbx(Application.Title, 'Перейти на позицию:', hchs, 10));
  if s = '' then
    Exit;
  if s[1] = 'H' then
    s[1] := '$';
  begin
    try
      v := StrToint(s)
    except
      on eConvertError do
      begin
        ShowMessage(errs);
        exit;
      end
    end;
    tilemapform.tMapscroll.Position := v;
  end;
end;

procedure TDjinnTileMapper.GoTo2Click(Sender: TObject);
var
  s: string;
  v: LongInt;
begin
  s := UpperCase(InputForm.Inputbx(Application.Title, 'Перейти на позицию:', hchs, 10));
  if s = '' then
    Exit;
  if s[1] = 'H' then
    s[1] := '$';
  begin
    try
      v := StrToint(s)
    except
      on eConvertError do
      begin
        ShowMessage(errs);
        exit;
      end
    end;
    dataform.Datascroll.Position := v;
  end;
end;

procedure TDjinnTileMapper.ReloadItemClick(Sender: TObject);
var
  MinSize: Integer;
begin
  AssignFile(ROM, fname);
  Reset(ROM, 1);
  if not FileExists(fname) then
    Exit;
  if ROMopened then
  begin
    FreeMem(ROMdata, ROMsize);
    BitReader.Free;
    BitWriter.Free;
  end;
  ROMsize := FileSize(ROM);
  dataform.stat1.Panels.Items[0].Text := 'Адрес : 000000 / ' + IntToHex(ROMSize, 6);
  TileMapForm.stat1.Panels.Items[0].Text := 'Адрес : 000000 / ' + IntToHex(ROMSize, 6);
  OldRomSize := ROMSize;
  MinSize := 16 * 128 * 4 * 16;
  if ROMsize < MinSize then
    ROMsize := MinSize;
  GetMem(ROMData, ROMsize);
  BitReader := TBitReader.Create(ROMData[0], ROMSize);
  BitWriter := TBitWriter.Create(ROMData[0], ROMSize);
  BlockRead(ROM, ROMData^, ROMSize, RBts);
  UpdateData(RomDataPos);
  CloseFile(ROM);
  DrawTileMap;
  Saved := true;
  Caption := Application.Title + ' - [' + ExtractFileName(fname) + ']' + SS[Saved];
end;

procedure TDjinnTileMapper.SaveItemClick(Sender: TObject);
begin
  AssignFile(ROM, fname);
  Rewrite(ROM, 1);
  Blockwrite(ROM, ROMData^, OldRomSize, Rbts);
  CloseFile(ROM);
  Saved := True;
  Caption := Application.Title + ' - [' + ExtractFileName(fname) + ']' + SS[Saved];
end;

procedure TDjinnTileMapper.SaveASitemClick(Sender: TObject);
begin
  if SaveROM.Execute then
  begin
    fname := SaveROM.FileName;
    AssignFile(ROM, fname);
    Rewrite(ROM, 1);
    Blockwrite(ROM, ROMData^, OldRomSize, Rbts);
    CloseFile(ROM);
    Saved := True;
    Caption := Application.Title + ' - [' + ExtractFileName(fname) + ']' + SS[Saved];
  end;
end;

procedure TDjinnTileMapper.Restore1Click(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to 63 do
  begin
    Palette[I] := RGB(DefaultPal[I * 3], DefaultPal[I * 3 + 1], DefaultPal[I * 3 + 2]);
  end;
  if ROMopened then
    DrawTileMap;
end;



{-------------------------------------------------------------------------------
  Процедура: UpdatePixel
  Автор:    Djinn
  Дата:  2018.03.05
  Входные параметры: Нет
  Результат:    Нет
  Процедура записи измененного цвета пикселя в РОМ файл
-------------------------------------------------------------------------------}
procedure UpdatePixel() ;
var
  P: PROMData;
  a, b, c, d: Byte;
  xu, ox, oy, TilePos, TileIndex, PixelPos: Integer;
  f: Byte;
  cn: byte;

  {-------------------------------------------------------------------------------
  Процедура: getbitcol
  Автор:    Djinn
  Дата:  2018.03.05
  Входные параметры: Нет
  Результат:    Нет
  Вложенная процедура определения индекса цвета в палитре
-------------------------------------------------------------------------------}

  procedure getbitcol;
  var
    I: byte;
  begin
    cn := 0;
    for I := 0 to CLR_CNT[DTM.TileType] - 1 do
      if btile.canvas.Pixels[ox, oy] = DTM.Color[I] then
      begin
        cn := I;
        Break;
      end;
    a := (cn shr 3) and 1;
    b := (cn shr 2) and 1;
    c := (cn shr 1) and 1;
    d :=  cn and 1;
  end;

begin
  if (tx >= 0) and (ty >= 0) then
    with DTM do
    begin
      ox := tx;
      oy := ty;
      TileIndex := TileMap[ty div tileh, tx div tilew];
      TilePos := DataPos + (TileIndex * (tilew * tileh * bsz[TileType])) div 8 ;

      P := Addr(ROMData^[TilePos]);
      ty := oy mod 8;
      tx := ox mod 8;
      PixelPos := DataPos * 8 + TileIndex * tilew * tileh * bsz[TileType] + (oy mod tileh) * tilew * bsz[TileType] + (ox mod tilew) * bsz[TileType];
      BitWriter.Seek(PixelPos, soBeginning);
      case TileType of
        tt1bit:
          begin
            getbitcol();
            if cn = 0 then
              BitWriter.Write(0)
            else
              BitWriter.Write(1);
          end;
        tt2bitVB:
          begin
            f := tx div 4;
            tx := tx mod 4;
            getbitcol;
            if cn = 0 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] and not (3 shl (tx * 2));
            end
            else
            if cn = 1 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or (1 shl (tx * 2));
              P^[ty * 2 + f] := P^[ty * 2 + f] and not (2 shl (tx * 2));
            end
            else
            if cn = 3 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or ($3 shl (tx * 2));
            end
            else
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or (2 shl (tx * 2));
              P^[ty * 2 + f] := P^[ty * 2 + f] and not (1 shl (tx * 2));
            end;
          end;
        tt2bitNGP:
          begin
            f := (tx div 4) xor 1;
            tx := tx mod 4;
            getbitcol;
            if cn = 0 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] and not ($C0 shr (tx * 2));
            end
            else
            if cn = 1 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or ($40 shr (tx * 2));
              P^[ty * 2 + f] := P^[ty * 2 + f] and not ($80 shr (tx * 2));
            end
            else
            if cn = 3 then
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or ($C0 shr (tx * 2));
            end
            else
            begin
              P^[ty * 2 + f] := P^[ty * 2 + f] or ($80 shr (tx * 2));
              P^[ty * 2 + f] := P^[ty * 2 + f] and not ($40 shr (tx * 2));
            end;
          end;
        tt2bitNES:
          begin
            PixelPos := DataPos * 8 + TileIndex * tilew * tileh * bsz[TileType] + (oy mod tileh) * tilew + (ox mod tilew);
            getbitcol;
            if cn = 0 then
            begin
              BitWriter[PixelPos] := 0;
              BitWriter[PixelPos + tilew * tileh] := 0
            end
            else
            if cn = 1 then
            begin
              BitWriter[PixelPos] := 1;
              BitWriter[PixelPos + tilew * tileh] := 0;
            end
            else
            if cn = 2 then
            begin
              BitWriter[PixelPos] := 0;
              BitWriter[PixelPos + tilew * tileh] := 1;
            end
            else
            begin
              BitWriter[PixelPos] := 1;
              BitWriter[PixelPos + tilew * tileh] := 1;
            end;
          end;
        tt2bitGBC:
          begin
            getbitcol;
            if cn = 0 then
            begin
              P^[ty * 2] := P^[ty * 2] and ResetBit[7 - tx];
              P^[ty * 2 + 1] := P^[ty * 2 + 1] and ResetBit[7 - tx]
            end
            else
            if cn = 1 then
            begin
              P^[ty * 2] := P^[ty * 2] or SetBit[7 - tx];
              P^[ty * 2 + 1] := P^[ty * 2 + 1] and ResetBit[7 - tx]
            end
            else
            if cn = 3 then
            begin
              P^[ty * 2] := P^[ty * 2] or SetBit[7 - tx];
              P^[ty * 2 + 1] := P^[ty * 2 + 1] or SetBit[7 - tx]
            end
            else
            begin
              P^[ty * 2] := P^[ty * 2] and ResetBit[7 - tx];
              P^[ty * 2 + 1] := P^[ty * 2 + 1] or SetBit[7 - tx]
            end;
          end;
        tt3bitSNES:
          begin
            getbitcol;
            if d = 1 then
              P^[ty * 2] := P^[ty * 2] or (1 shl (7 - tx))
            else
            if d = 0 then
              P^[ty * 2] := P^[ty * 2] and not (1 shl (7 - tx));
            if c = 1 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] or (1 shl (7 - tx))
            else
            if c = 0 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] and not (1 shl (7 - tx));
            if b = 1 then
              P^[ty + 16] := P^[ty + 16] or (1 shl (7 - tx))
            else
            if b = 0 then
              P^[ty + 16] := P^[ty + 16] and not (1 shl (7 - tx));
          end;
        tt3bit:
          begin
            getbitcol;
            if d = 1 then
              P^[ty] := P^[ty] or (1 shl (7 - tx))
            else
            if d = 0 then
              P^[ty] := P^[ty] and not (1 shl (7 - tx));
            if c = 1 then
              P^[ty + 8] := P^[ty + 8] or (1 shl (7 - tx))
            else
            if c = 0 then
              P^[ty + 8] := P^[ty + 8] and not (1 shl (7 - tx));
            if b = 1 then
              P^[ty + 16] := P^[ty + 16] or (1 shl (7 - tx))
            else
            if b = 0 then
              P^[ty + 16] := P^[ty + 16] and not (1 shl (7 - tx));
          end;
        tt4bitSNES:
          begin
            getbitcol;
            if d = 1 then
              P^[ty * 2] := P^[ty * 2] or (1 shl (7 - tx))
            else
            if d = 0 then
              P^[ty * 2] := P^[ty * 2] and not (1 shl (7 - tx));
            if c = 1 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] or (1 shl (7 - tx))
            else
            if c = 0 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] and not (1 shl (7 - tx));
            if b = 1 then
              P^[ty * 2 + 16] := P^[ty * 2 + 16] or (1 shl (7 - tx))
            else
            if b = 0 then
              P^[ty * 2 + 16] := P^[ty * 2 + 16] and not (1 shl (7 - tx));
            if a = 1 then
              P^[ty * 2 + 17] := P^[ty * 2 + 17] or (1 shl (7 - tx))
            else
            if a = 0 then
              P^[ty * 2 + 17] := P^[ty * 2 + 17] and not (1 shl (7 - tx));
          end;
        tt4bitSNESM:
         begin
          getbitcol;
          If d = 1 then
           p^[ty * 2] := p^[ty * 2] or (1 shl (tx)) Else
          If d = 0 then
           p^[ty * 2] := p^[ty * 2] and not (1 shl (tx));
          If c = 1 then
           p^[ty * 2 + 1] := p^[ty * 2 + 1] or (1 shl (tx)) Else
          If c = 0 then
           p^[ty * 2 + 1] := p^[ty * 2 + 1] and not (1 shl (tx));
          If b = 1 then
           p^[ty * 2 + 16] := p^[ty * 2 + 16] or (1 shl (tx)) Else
          If b = 0 then
           p^[ty * 2 + 16] := p^[ty * 2 + 16] and not (1 shl (tx));
          If a = 1 then
           p^[ty * 2 + 17] := p^[ty * 2 + 17] or (1 shl (tx)) Else
          If a = 0 then
           p^[ty * 2 + 17] := p^[ty * 2 + 17] and not (1 shl (tx));
         end;
        tt4bitSMS:
          begin
            getbitcol;
            if d = 1 then
              P^[ty * 4] := P^[ty * 4] or (1 shl (7 - tx))
            else
            if d = 0 then
              P^[ty * 4] := P^[ty * 4] and not (1 shl (7 - tx));
            if c = 1 then
              P^[ty * 4 + 1] := P^[ty * 4 + 1] or (1 shl (7 - tx))
            else
            if c = 0 then
              P^[ty * 4 + 1] := P^[ty * 4 + 1] and not (1 shl (7 - tx));
            if b = 1 then
              P^[ty * 4 + 2] := P^[ty * 4 + 2] or (1 shl (7 - tx))
            else
            if b = 0 then
              P^[ty * 4 + 2] := P^[ty * 4 + 2] and not (1 shl (7 - tx));
            if a = 1 then
              P^[ty * 4 + 3] := P^[ty * 4 + 3] or (1 shl (7 - tx))
            else
            if a = 0 then
              P^[ty * 4 + 3] := P^[ty * 4 + 3] and not (1 shl (7 - tx));
          end;
        tt4bit:
          begin
            getbitcol;
            xu := (4 * ((7 - tx) mod 2));
            if d = 1 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] or (1 shl (7 - (xu + 3)))
            else
            if d = 0 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] and not (1 shl (7 - (xu + 3)));
            if c = 1 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] or (1 shl (7 - (xu + 2)))
            else
            if c = 0 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] and not (1 shl (7 - (xu + 2)));
            if b = 1 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] or (1 shl (7 - (xu + 1)))
            else
            if b = 0 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] and not (1 shl (7 - (xu + 1)));
            if a = 1 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] or (1 shl (7 - xu))
            else
            if a = 0 then
              P^[ty * 4 + tx div 2] := P^[ty * 4 + tx div 2] and not (1 shl (7 - xu));
          end;
        tt4bitMSX:
          begin
            getbitcol;
            BitWriter.Write(cn, 4);
          end;
        tt8bit:
          begin
            getbitcol;
            BitWriter.Write(cn, 8);
          end;
        tt8bitSNES:
          begin
            getbitcol;
            if d = 1 then
              P^[ty * 2] := P^[ty * 2] or (1 shl (7 - tx))
            else
            if d = 0 then
              P^[ty * 2] := P^[ty * 2] and not (1 shl (7 - tx));
            if c = 1 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] or (1 shl (7 - tx))
            else
            if c = 0 then
              P^[ty * 2 + 1] := P^[ty * 2 + 1] and not (1 shl (7 - tx));
            if b = 1 then
              P^[ty * 2 + 16] := P^[ty * 2 + 16] or (1 shl (7 - tx))
            else
            if b = 0 then
              P^[ty * 2 + 16] := P^[ty * 2 + 16] and not (1 shl (7 - tx));
            if a = 1 then
              P^[ty * 2 + 17] := P^[ty * 2 + 17] or (1 shl (7 - tx))
            else
            if a = 0 then
              P^[ty * 2 + 17] := P^[ty * 2 + 17] and not (1 shl (7 - tx));
          end;
      end;
      tx := ox;
      ty := oy;
    end;
end;

procedure TDjinnTileMapper.MkTmplItemClick(Sender: TObject);
var
  T: TextFile;
  i: Byte;
begin
  if MakeTBL.Execute then
  begin
    AssignFile(T, MakeTBL.FileName);
    Rewrite(T);
    Writeln(T, 'H' + IntToHex(DataPos, 6));
    for i := 0 to 255 do
      Writeln(T, IntToHex(i, 2) + '=');
    writeln(T, '*FF');
    writeln(T, '/00');
    CloseFile(T);
  end;
end;

procedure InitAllJumpLists;
begin
  tilemapform.InitJumpList;
  dataform.InitJumpList;
  f_metatiles.InitJumpList;
end;

procedure TDjinnTileMapper.InitDataEdit;
var
  n, l: Byte;
begin
  DataEdit.Enabled := True;
  DataEdit.Color := clWindow;
  DataEdit.Text := '';
  DEditset := [#8, #13];
  for n := 0 to 255 do
    if Table[n] = '' then
      Table[n] := '{' + IntToHex(n, 2) + '}';
  table[perenos] := '{^}';
  table[endt] := '{END}';
  maxtlen := 0;
  for n := 0 to 255 do
  begin
    for l := 1 to Length(Table[n]) do
      if not (Table[n][l] in DEditSet) then
        DEditSet := DEditSet + [Table[n][l]];
    if maxTlen < Length(Table[n]) then
      maxTlen := Length(Table[n]);
  end;
  PasteBtn.Enabled := True;
  GetBtn.Enabled := True;
  GetString1.Enabled := True;
  PutString1.Enabled := True;
end;

procedure TDjinnTileMapper.OpenTblItemClick(Sender: TObject);
label
  Error, EndProc;
var
  T: TextFile;
  s: string;
  err: Boolean;
  n: Byte;
  backup: TTable;
  p: LongInt;
begin
  if OpenTBL.Execute then
  begin
    TBLname := openTBL.FileName;
    AssignFile(T, TBLname);
    Reset(T);
    Readln(T, s);
    if UpCase(s[1]) = 'H' then
    begin
      p := HexVal(Copy(s, 2, Length(s) - 1), err);
      if err then
        p := 0;
    end
    else
    begin
      p := StrToInt(s);
      if p < 0 then
        p := 0;
    end;
    while not EOF(T) do
    begin
      Readln(T, s);
      if (length(s) = 3) and (s[1] = '*') then
        perenos := HexVal(copy(s, 2, 2), err)
      else if (length(s) = 3) and (s[1] = '/') then
        endt := HexVal(copy(s, 2, 2), err)
      else
      begin
        n := HexVal(copy(s, 1, 2), err);
        if not err and (length(s) > 3) and (s[3] = '=') then
          backup[n] := copy(s, 4, Length(s) - 3);
      end;
    end;
    CloseFile(T);
    TBLopened := True;
    Table := backup;
    TBLnameL.Caption := 'Таблица: ' + TBLname;
    RldTBLitem.Enabled := True;
    Searchform.f3.Enabled := True;
    Searchform.ntsed.Enabled := True;
    Searchform.ntsed.Color := clWindow;
    if ROMopened then
    begin
      tilemapform.TMapScroll.Position := p;
      InitDataEdit;
      n20.Enabled := true;
      n24.Enabled := true;
    end;
  end;
  goto EndProc;
Error:
  CloseFile(T);
EndProc:

end;

procedure Paste;
var
  s: string;

  function cfind(p: Integer): Integer;
  var
    g: Integer;
    n: Byte;
  begin
    Result := -1;
    for g := maxtlen downto 1 do
      for n := 0 to 255 do
        if Copy(s, p, g) = Table[n] then
        begin
          Result := n;
          Exit;
        end;
  end;

var
  n, i, l: Integer;
begin
  with DTM do
  begin
    s := DataEdit.Text;
    if LCnt.Checked then
    begin
      l := length(s);
      if l > MaxSlen then
        l := maxslen;
      for i := 0 to l - 1 do
      begin
        for n := 0 to 255 do
          if Table[n] = s[i + 1] then
          begin
            ROMData^[romDataPos + CDpos + i] := n;
            break;
          end;
      end;
    end
    else
    begin
      i := 1;
      l := 0;
      while i <= Length(s) do
      begin
        n := cfind(i);
        if n >= 0 then
        begin
          inc(i, Length(Table[n]) - 1);
          ROMData^[romDataPos + CDpos + l] := n;
          Inc(l);
          if l >= MaxSLen then
            break;
        end;
        Inc(i);
      end;
    end;
    DrawTileMap;
  end;
end;

procedure TDjinnTileMapper.DataEditKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in DEditSet) then
    Key := #0;
  if Key = #13 then
    Paste;
end;

function TDjinnTileMapper.GetLength: Integer;
var
  i: Integer;
  n: Integer;
  s: string;

  function cfind(p: Integer): Integer;
  var
    g: Integer;
    n: Byte;
  begin
    Result := -1;
    for g := maxtlen downto 1 do
      for n := 0 to 255 do
        if Copy(s, p, g) = Table[n] then
        begin
          Result := n;
          Exit;
        end;
  end;

begin
  s := DataEdit.Text;
  Result := 0;
  i := 1;
  while i <= Length(s) do
  begin
    n := cfind(i);
    if n >= 0 then
    begin
      inc(i, Length(Table[n]) - 1);
      Inc(Result);
    end;
    Inc(i);
  end;
end;

procedure TDjinnTileMapper.DataEditChange(Sender: TObject);
var
  n: Integer;
begin
  if LCnt.Checked then
    n := length(DataEdit.Text)
  else
    n := GetLength;
  LenLab.Caption := 'Длина: ' + IntToStr(n) + ' = h0' + IntToHex(n, 3);
end;

procedure TDjinnTileMapper.PasteBtnClick(Sender: TObject);
begin
  Paste;
end;

procedure TDjinnTileMapper.RldtblitemClick(Sender: TObject);
label
  Error, EndProc;
var
  T: TextFile;
  s: string;
  err: Boolean;
  n: Byte;
  backup: TTable;
  p: LongInt;
begin
  if not FileExists(TBLname) then
  begin
    AssignFile(T, TBLname);
    Rewrite(T);
    for n := 0 to 255 do
      Writeln(T, IntToHex(n, 2) + '=' + Table[n]);
    CloseFile(T);
  end;
  AssignFile(T, TBLname);
  Reset(T);
  Readln(T, s);
  if UpCase(s[1]) = 'H' then
  begin
    p := HexVal(Copy(s, 2, Length(s) - 1), err);
    if err then
      p := 0;
  end
  else
  begin
    p := StrToInt(s);
    if p < 0 then
      p := 0;
  end;
  while not EOF(T) do
  begin
    Readln(T, s);
    if (length(s) = 3) and (s[1] = '*') then
      perenos := HexVal(copy(s, 2, 2), err)
    else if (length(s) = 3) and (s[1] = '/') then
      endt := HexVal(copy(s, 2, 2), err)
    else
    begin
      n := HexVal(copy(s, 1, 2), err);
      if not err and (length(s) > 3) and (s[3] = '=') then
        backup[n] := copy(s, 4, Length(s) - 3);
    end;
  end;
  CloseFile(T);
  TBLopened := True;
  Table := backup;
  TBLnameL.Caption := 'Таблица: ' + TBLname;
  if ROMopened then
  begin
    tilemapform.TMapScroll.Position := p;
    InitDataEdit;
  end;
  goto EndProc;
Error:
  CloseFile(T);
EndProc:

end;

procedure TDjinnTileMapper.GetBtnClick(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  s := '';
  for i := 0 to maxSlen - 1 do
    s := s + Table[ROMdata^[romDataPos + CDpos + i]];
  DataEdit.Text := s;
end;

procedure TDjinnTileMapper.Getstring1Click(Sender: TObject);
var
  i: Integer;
  s: string;
begin
  DataEdit.SetFocus;
  s := '';
  for i := 0 to maxSlen - 1 do
    s := s + Table[ROMdata^[romDataPos + CDpos + i]];
  DataEdit.Text := s;
end;

procedure TDjinnTileMapper.PutString1Click(Sender: TObject);
begin
  Paste;
end;

type
  RGBZ = record
    R, g, b, Z: Byte
  end;

procedure TDjinnTileMapper.N1Click(Sender: TObject);
type
  TSimpleRGB = packed record
    Red: Byte;
    Green: Byte;
    Blue: Byte;
  end;
type
  TColorRGB = packed record
    rgbRed: Byte;
    rgbGreen: Byte;
    rgbBlue: Byte;
    rgbReserved: Byte;
  end;
var
  t: TextFile;
  s, c1, c2: string;
  c: TColor;
  i: integer;
  F: file;
  Col: TSimpleRGB;
  Size, Count: Integer;
  ext: string;
begin
  if OpenPAL.Execute then
  begin
    ext := LowerCase(ExtractFileExt(OpenPAL.FileName));
    if (ext = '.act') or (ext = '.pal') then
    begin
      AssignFile(F, OpenPAL.FileName);
      Reset(F, 1);
      Size := FileSize(F);
      Count := Size div 3;
      if Count > 256 then
        Count := 256;
      for I := 0 to Count - 1 do
      begin
        BlockRead(F, Col, 3);
        with Col, TColorRGB(c) do
        begin
          rgbRed := Red;
          rgbGreen := Green;
          rgbBlue := Blue;
          rgbReserved := 0;
        end;
        Palette[I] := c;
      end;

      CloseFile(F);
      RedrawPalette;
      if ROMopened then
        DrawTilemap;
      Exit;
    end;

    AssignFile(t, OpenPAL.FileName);
    Reset(t);
    RGBZ(c).z := 0;

    for I := 0 to 15 do
    begin
      Readln(t, s);
      c1 := copy(s, 1, Pos(' ', s) - 1);
      Delete(s, 1, Pos(' ', s));
      c2 := copy(s, 1, Pos(' ', s) - 1);
      Delete(s, 1, Pos(' ', s));
      RGBZ(c).R := StrToInt(c1);
      RGBZ(c).g := StrToInt(c2);
      RGBZ(c).b := StrToInt(s);
      Palette[I] := c;
    end;
    CloseFile(t);
    RedrawPalette;
    if ROMopened then
      DrawTilemap;
  end;
end;

procedure TDjinnTileMapper.N2Click(Sender: TObject);
var
  t: TextFile;
  i: Byte;
begin
  if SavePAL.Execute then
  begin
    AssignFile(t, SavePAL.FileName);
    Rewrite(t);
    for I := 0 to 15 do
        Writeln(t, IntToStr(RGBZ(Palette[I]).R) + ' ' + IntToStr(RGBZ(Palette[I]).g) + ' ' + IntToStr(RGBZ(Palette[I]).b));
    CloseFile(t);
  end;
end;

procedure TDjinnTileMapper.SearchItemClick(Sender: TObject);
label
  1, 2;
var
  s: string;
var
  i, j, l, n: LongInt;
  p, fdata: PROMdata;
  err, nf: Boolean;

  function cfind(p: Integer): Integer;
  var
    g: Integer;
    n: Byte;
  begin
    Result := -1;
    for g := maxtlen downto 1 do
      for n := 0 to 255 do
        if Copy(s, p, g) = Table[n] then
        begin
          Result := n;
          Exit;
        end;
  end;

var
  bu: Boolean;
  sfi: Integer;

  procedure Find;
  var
    ku, ju: LongInt;
  begin
    for ku := romDataPos to ROMsize - l do
    begin
      p := Addr(ROMdata^[ku]);
      nf := False;
      sfi := searchform.intervalspin.Value + 1;
      for ju := 0 to l - 1 do
        if p^[ju * sfi] <> fdata^[ju] then
        begin
          nf := True;
          Break;
        end;
      if ku = romDataPos then
      begin
        nf := True;
        bu := True;
      end;
      if not nf then
        Break;
    end;
    i := ku;
    j := ju;
  end;

  procedure fResult;
  begin
    if not nf then
    begin
      dataform.DataScroll.SetFocus;
      dataform.DataScroll.Position := i;
      DataBank := i - romDataPos;
      dataform.Label1.Caption := 'Позиция: ' + IntToHex(romDataPos + CDPos, 6);
      if not tTblOpened then
        Bank := RomData^[romDatapos + CDPos]
      else
        Bank := TileTable[RomData^[romDatapos + CDPos]];
    end
    else if not bu then
      ShowMessage('Не нашёл!!!');
  end;

begin
  bu := False;
  SearchForm.ShowModal;
  if FindQ then
  begin
    with SearchForm do
      if f1.Checked and (Length(HexfEd.Text) > 0) then
      begin
        s := HexfEd.Text;
        if Length(s) mod 2 = 1 then
          s := '0' + s;
        l := Length(s) shr 1;
        GetMem(fdata, l);
        for i := 0 to Length(s) - 1 do
          if i mod 2 = 0 then
            fdata^[i shr 1] := HexVal(Copy(s, i + 1, 2), err);
        Find;
        FreeMem(fdata, l);
        fResult;
      end
      else if f2.Checked and (Length(TfEd.Text) > 1) then
      begin
        srelative;
      end
      else if f3.Checked and (Length(ntsed.Text) > 0) then
      begin
        s := nTsEd.Text;
        i := 1;
        l := 0;
        GetMem(fdata, lENGTH(s));
        if lCnt.Checked then
        begin
          for i := 1 to Length(s) do
            for l := 0 to 255 do
              if Table[l] = s[i] then
                fdata^[i - 1] := l;
          l := Length(s);
        end
        else
          while i <= Length(s) do
          begin
            n := cfind(i);
            if n >= 0 then
            begin
              inc(i, Length(Table[n]) - 1);
              fdata^[l] := n;
              Inc(l);
            end;
            Inc(i);
          end;
        Find;
        FreeMem(fdata, lENGTH(s));
        fResult;
      end;
  end;
end;

procedure TDjinnTileMapper.srelative;

  function rgethex(pos: longword; size: integer): string;
  var
    i: integer;
  begin
    result := '';
    for i := 0 to size - 1 do
      result := result + inttohex(romdata^[pos + i], 2);
  end;

label
  l1;
var
  msize: byte;
  tp: longword;
  i: longword;
  s1: string;
  f: boolean;
  k1, k2: integer;
begin
{ SearchForm.ShowModal;}
  if FindQ then
    with SearchForm do
      if f2.Checked and (Length(TfEd.Text) > 1) then
      begin
        s1 := TfEd.Text;
        tp := 0;
        msize := length(s1);
        searchresform.searchlist.Clear;
l1:
        f := true;
        if msize + tp <= romsize then
        begin
          for i := 1 to msize - 1 do
          begin
            k1 := ord(s1[i]) - RomData^[i + tp];
            k2 := ord(s1[i + 1]) - RomData^[i + tp + 1];
            if k1 <> k2 then
              f := false;
          end;
          tp := tp + 1;
          if f then
            searchresform.searchlist.Items.Add(inttohex(tp, 8) + ' ' + s1 + '=' + rgethex(tp, msize));
          goto l1;
        end;
        searchresform.Show;
      end;
end;

procedure TDjinnTileMapper.RedrawPalette();
var
  I: Integer;
  X: Integer;
  Y: Integer;
begin
  for I := 0 to 15 do
  begin
    teditform.c16im.canvas.Brush.Color := Palette[BigPalSet * COLOR_HEIGHT + I];
    teditform.c16im.canvas.FillRect(Bounds(0, I * COLOR_HEIGHT, 30, COLOR_HEIGHT));
  end;

  for I := 0 to 255 do
  begin
    X := I mod 16;
    Y := I div 16;
    PalForm.PalImage.Picture.Bitmap.Canvas.Brush.Color := Palette[I];
    PalForm.PalImage.Picture.Bitmap.Canvas.FillRect(Bounds(X * COLOR_WIDTH, Y * COLOR_HEIGHT, COLOR_WIDTH, COLOR_HEIGHT));
  end;

  PalForm.PalImage.Picture.Bitmap.Canvas.Brush.Color := clWhite;
  teditform.c16im.canvas.Brush.Color := clWhite;

  if Fcol = BCol then
  begin
    X:= SmallPalSet * COLOR_WIDTH + FCol * COLOR_WIDTH;
    Y:= BigPalSet * COLOR_HEIGHT;
    PalForm.PalImage.Picture.Bitmap.Canvas.TextOut(X , Y, 'BF');
    Y:= SmallPalSet * COLOR_HEIGHT * CLR_CNT[TileType] + FCol * COLOR_HEIGHT;
    teditform.c16im.canvas.TextOut(8, Y, 'BF');
  end
  else
  begin
    //*************SET BACKGROUND COLOR MARK********************//
    X:= SmallPalSet * COLOR_WIDTH * CLR_CNT[DTM.TileType] + BCol * COLOR_WIDTH;
    Y:= BigPalSet * COLOR_HEIGHT;
    PalForm.PalImage.Picture.Bitmap.Canvas.TextOut(X + 2, Y, 'B');
    //*************SET FOREGROUND COLOR MARK********************//
    X:= SmallPalSet * COLOR_WIDTH * CLR_CNT[DTM.TileType] + FCol * COLOR_WIDTH;
    PalForm.PalImage.Picture.Bitmap.Canvas.TextOut(X + 2, Y, 'F');
    //*************SET BACKGROUND COLOR MARK********************//
    Y:= SmallPalSet * COLOR_HEIGHT * CLR_CNT[TileType] + BCol * COLOR_HEIGHT;
    teditform.c16im.canvas.TextOut(10, Y, 'B');
    //*************SET FOREGROUND COLOR MARK********************//
    Y:= SmallPalSet * COLOR_HEIGHT * CLR_CNT[TileType] + FCol * COLOR_HEIGHT;
    teditform.c16im.canvas.TextOut(10, Y, 'F');
  end;

  with teditform.c16im.Picture.Bitmap.Canvas do
  begin
    Brush.Style:= bsClear;
    Pen.Mode:= pmWhite;
    Y:= SmallPalSet * COLOR_HEIGHT * CLR_CNT[DTM.TileType];
    Rectangle(Bounds(0, Y, 30, COLOR_HEIGHT * CLR_CNT[DTM.TileType]));
  end;

  with PalForm.PalImage.Picture.Bitmap.Canvas do
  begin
    Y:= BigPalSet * COLOR_HEIGHT;
    Pen.Mode:= pmWhite;
    Brush.Style := bsClear;
    Rectangle(Bounds(0, Y, PALETTE_WIDTH, COLOR_HEIGHT));
  end;
end;

procedure TDjinnTileMapper.UpdateData(Pos: Integer);
var
  I: Integer;
  J: Integer;
begin
  BitReader.Seek(Pos * 8, soBeginning);
  SetSize(Data, DataH * DataW);
  if bSwapXY then
  begin
    for I := 0 to DataH - 1 do
      for J := 0 to DataW - 1 do
      begin
        with Data[I * DataW + J] do
        begin
          Address := BitReader.Position div 8;
          case MapFormat of
            mfSingleByte, mfGBC: Value := BitReader.Read(8);
            mfGBA, mfSNES, mfPCE: Value := Swap(BitReader.Read(16));
            mfMSX, mfSMS: Value := BitReader.Read(16);
          end;
          x := J;
          y := I;
        end;
      end;
  end
  else
  begin
    for I := 0 to DataW - 1 do
      for J := 0 to DataH - 1 do
      begin
        with Data[I * DataH + J] do
        begin
          Address := BitReader.Position div 8;
          case MapFormat of
            mfSingleByte, mfGBC: Value := BitReader.Read(8);
            mfGBA, mfSNES, mfPCE: Value := Swap(BitReader.Read(16));
            mfMSX, mfSMS: Value := BitReader.Read(16);
          end;
          x := I;
          y := J;
        end;
      end;
  end;
end;

procedure TDjinnTileMapper.ShowHexNumbers();
var
  Local_Y: Integer;
  Local_X: Integer;
  RowCount, I: Integer;
begin
  if bTMShowHex then
  begin
    RowCount := 128;
    if ((OldROMSize - DataPos) * 8) < (16 * 128 * bsz[DTM.TileType] * tilew * tileh) then
      RowCount := ((OldROMSize - DataPos) * 8) div (16 * tilew * tileh * bsz[DTM.TileType]);
    I := 0;
    for Local_Y := 0 to RowCount - 1 do
      for Local_X := 0 to 16 - 1 do
      begin
        case DTM.MapFormat of
          mfSingleByte, mfGBC:
            begin
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $FF;
            end;
          mfSMS:
            begin
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $1FF;
            end;
          mfGBA, mfSNES:
            begin
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $3FF;
            end;
          mfMSX, mfPCE:
            begin
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(tilemapform.TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $7FF;
            end;
        end;
      end;
  end;
end;

procedure TDjinnTileMapper.DataMapRedraw;
begin
  begin
    DataScrollEnable;
    DataMapDraw;
  end;
end;

procedure TDjinnTileMapper.SpinEdit1Change(Sender: TObject);
begin
  maxSLen := SpinEdit1.Value;
  MaxLenLab.Caption := 'Максимальная длина: ' + IntToStr(MaxSlen) + ' = h0' + IntToHex(maxSlen, 3);
end;

procedure TDjinnTileMapper.ottnlClick(Sender: TObject);
label
  Error, EndProc;
var
  T: TextFile;
  s: string;
  err: Boolean;
  n: Byte;
  backup: TTileTable;
  p: LongInt;
begin
  if OpenTBL.Execute then
  begin
    tTBLname := openTBL.FileName;
    AssignFile(T, tTBLname);
    Reset(T);
    Readln(T, s);
    if UpCase(s[1]) = 'H' then
    begin
      p := HexVal(Copy(s, 2, Length(s) - 1), err);
{   If Err then Goto Error;}
      if err then
        p := 0;
    end
    else
    begin
      p := StrToInt(s);
      if p < 0 then {Goto Error}
        p := 0;
    end;
    for n := 0 to 255 do
      backup[n] := 0;
    while not EOF(T) do
    begin
      Readln(T, s);
      n := HexVal(copy(s, 1, 2), err);
{   If Err or (s[3] <> '=') then Goto Error;}
      backup[n] := HexVal(copy(s, 4, 2), err);
      if not err and (length(s) > 3) and (s[3] = '=') then
        backup[n] := HexVal(copy(s, 4, 2), err);
      if copy(s, 4, 2) = '' then
      begin
        backup[n] := 0;
        err := False;
      end;
{   If Err then Goto Error;}
    end;
    CloseFile(T);
    tTBLopened := True;
    TileTable := backup;
    Label4.Caption := 'Таблица тайлов: ' + tTBLname;
    RtTBL.Enabled := True;
    CtTBL.Enabled := True;
    if ROMopened then
    begin
      tilemapform.TMapScroll.Position := p;
      DataMapDraw;
      Bank := TileTable[RomData^[romDatapos + CDPos]];
    end;
  end;
  goto EndProc;
Error:
  CloseFile(T);
{ ShowMessage('Неверный формат файла!!!');}
EndProc:

end;

procedure TDjinnTileMapper.AboutItemClick(Sender: TObject);
begin
  AboutForm.Show;
end;

procedure TDjinnTileMapper.cttblClick(Sender: TObject);
begin
  tTblopened := False;
  Label4.Caption := 'Таблица тайлов:';
  cttbl.Enabled := False;
  rttbl.Enabled := False;
  if ROMopened then
  begin
    DataMapDraw;
    Bank := RomData^[romDatapos + CDPos];
  end;
end;

procedure TDjinnTileMapper.rttblClick(Sender: TObject);
label
  Error, EndProc;
var
  T: TextFile;
  s: string;
  err: Boolean;
  n: Byte;
  backup: TTileTable;
  p: LongInt;
begin
  if not FileExists(tTBLname) then
  begin
    AssignFile(T, tTBLname);
    Rewrite(T);
    for n := 0 to 255 do
      Writeln(T, IntToHex(n, 2) + '=' + IntToHex(TileTable[n], 2));
    CloseFile(T);
    Exit;
  end;
  AssignFile(T, tTBLname);
  Reset(T);
  Readln(T, s);
  if UpCase(s[1]) = 'H' then
  begin
    p := HexVal(Copy(s, 2, Length(s) - 1), err);
    if err then
      goto Error;
  end
  else
  begin
    p := StrToInt(s);
    if p < 0 then
      goto Error;
  end;
  for n := 0 to 255 do
    backup[n] := 0;
  while not EOF(T) do
  begin
    Readln(T, s);
    n := HexVal(copy(s, 1, 2), err);
    if err or (s[3] <> '=') then
      goto Error;
    backup[n] := HexVal(copy(s, 4, 2), err);
    if copy(s, 4, 2) = '' then
    begin
      backup[n] := 0;
      err := False;
    end;
    if err then
      goto Error;
  end;
  CloseFile(T);
  tTBLopened := True;
  TileTable := backup;
  Label4.Caption := 'Таблица тайлов: ' + tTBLname;
  if ROMopened then
  begin
    tilemapform.TMapScroll.Position := p;
    DataMapDraw;
    Bank := TileTable[RomData^[romDatapos + CDPos]];
  end;
  goto EndProc;
Error:
  CloseFile(T);
  ShowMessage('Неверный формат файла!!!');
EndProc:

end;

procedure TDjinnTileMapper.ShowMetatilesMapClick(Sender: TObject);
begin
  if f_metatiles.Visible then
  begin
    f_metatiles.Hide;
    f_metatiles.Timer1.Enabled:= False;
    ShowMetatilesMap.Checked:= False;
  end
  else
  begin
    f_metatiles.Show;
    f_metatiles.Timer1.Enabled:= True;
    ShowMetatilesMap.Checked:= True;
  end;
end;

procedure TDjinnTileMapper.N3Click(Sender: TObject);
begin
  ShowMessage('Форматы таблиц' + #10#13#10#13 + 'Таблица символов:' + #10#13#9 + 'первая строка - позиция карты тайлов в ROM''е;' + #10#13#9 + 'остальные строки - символьные обозначения каждого элемента.' + #10#13 + 'Пример:'#13#10#9'H020010'#10#13#9'0B=shi'#10#13#9'0C=su'#10#13#10#13 + 'Таблица тайлов:' + #10#13#9 + 'первая строка - позиция карты тайлов в ROM''е;' + #10#13#9 + 'остальные строки - номера тайлов для каждого элемента.' + #10#13 + 'Пример:'#13#10#9'H027510'#10#13#9'19=3F'#10#13#9'1A=40');
end;

procedure TDjinnTileMapper.LCntClick(Sender: TObject);
var
  n: Integer;
begin
  lCNt.checked := not LCnt.checked;
  if LCnt.Checked then
    n := length(DataEdit.Text)
  else
    n := GetLength;
  LenLab.Caption := 'Длина: ' + IntToStr(n) + ' = h0' + IntToHex(n, 3);
end;

procedure TDjinnTileMapper.N4Click(Sender: TObject);
begin
 tilemapform.tbBlockMinus1.Click;
end;

procedure TDjinnTileMapper.N5Click(Sender: TObject);
begin
  tilemapform.tbBlockPlus1.Click;
end;

procedure TDjinnTileMapper.N6Click(Sender: TObject);
begin
  tilemapform.tbMinus1.Click;
end;

procedure TDjinnTileMapper.N7Click(Sender: TObject);
begin
  tilemapform.tbPlus1.Click;
end;

procedure TDjinnTileMapper.N8Click(Sender: TObject);
begin
  teditform.clearbtnclick(teditform.clearbtn);
end;

procedure TDjinnTileMapper.N9Click(Sender: TObject);
begin
  dataform.dleftbtnclick(dataform.dleftbtn);
end;

procedure TDjinnTileMapper.N10Click(Sender: TObject);
begin
  dataform.drightbtnclick(dataform.drightbtn);
end;

procedure TDjinnTileMapper.N11Click(Sender: TObject);
begin
  n11.checked := not n11.checked;
  tilemapform.Visible := n11.checked;
end;

procedure TDjinnTileMapper.N12Click(Sender: TObject);
begin
  n12.checked := not n12.checked;
  teditform.Visible := n12.checked;
end;

procedure TDjinnTileMapper.N13Click(Sender: TObject);
begin
  n13.checked := not n13.checked;
  dataform.Visible := n13.checked;
end;

procedure TDjinnTileMapper.optItmClick(Sender: TObject);
begin
  if not tilemapform.Visible then
    n11.Checked := false;
  if not teditform.Visible then
    n12.Checked := false;
  if not dataform.otherpan.Visible then
    n13.Checked := false;
end;


//*************************Import from Bitmap*********************************//
//****************************************************************************//
procedure TDjinnTileMapper.ImportBitmap(Sender: TObject);
var
  v: tbitmap;
  bb, I, xx, yy: integer;
  RowCount, TileNums, W: Integer;
  TileIndex: Integer;
begin
  if OpenBMP.Execute then
  begin
    v := tbitmap.Create;
    v.LoadFromFile(OpenBMP.FileName);
    TileNums := (v.Width div 8) * (v.Height div 8);
    if TileNums > MAX_TILES_NUMS then
      TileNums := MAX_TILES_NUMS;

    if (ROMSize - DataPos) < (16 * 128 * bsz[TileType] * 8) then
    begin
      RowCount := (ROMSize - DataPos) div (16 * 8 * bsz[TileType]);
      if (16 * RowCount) < TileNums then
        TileNums := 16 * RowCount;
    end;
    I := curbank;
    W := v.Width div 128;

    for bb := 0 to TileNums - 1 do
    begin
      bTile.Canvas.CopyRect(Bounds(0, 0, tilew, tileh), v.Canvas, Bounds((bb mod 16) * tilew + ((bb div 16) and 1) * 128, (bb div (16 * W)) * tileh, tilew, tileh));
      TileMap[0, 0] := Map[bb div 16][bb mod 16];
      for yy := 0 to tileh - 1 do
        for xx := 0 to tilew - 1 do
        begin
          tx := xx;
          ty := yy;
          UpdatePixel;
        end;
    end;
    Curbank := I;
    v.Free;
    bank := I;
    Saved := false;
    Caption := Application.Title + ' - [' + ExtractFileName(fname) + ']' + SS[Saved];
    DrawTileMap;
  end;
end;


//*********************Save to Bitmap******************************//
//*****************************************************************//
procedure TDjinnTileMapper.ExportBitmap(Sender: TObject);
begin
  if SaveBMP.Execute then
  begin
    bmap.PixelFormat := pf24bit;
    bmap.SaveToFile(SaveBMP.FileName);
  end;
end;



//***************************DUMP SCRIPT************************************////
procedure TDjinnTileMapper.N20Click(Sender: TObject);
var
  script: textfile;
  line: string;
  i: integer;
  ps: byte;
begin
  crtransform.dmp := true;
  crtransform.Caption := 'Извлечь текст';
  crtransform.radiobutton1.Visible := false;
  crtransform.radiobutton1.checked := true;
  crtransform.radiobutton2.Visible := false;
  crtransform.CheckBox1.Checked := false;
  crtransform.CheckBox1.Caption := 'Писать смещение каждого диалога';
  crtransform.Label1.Visible := true;
  crtransform.showmodal;
  if crtransform.ok then
  begin
    assignfile(script, crtransform.dd.FileName);
    rewrite(script);
    if (num2 < num1) then
    begin
      closefile(script);
      showmessage('Ошибка!!!')
    end;
    line := '';
    if num2 >= romsize then
      num2 := romsize - 1;
{  if rzero then writeln(script, '!!!');
  writeln(script, Inttohex(num1, 8));}
    for i := num1 to num2 do
    begin
      ps := romdata^[i];
      if ps = perenos then
      begin
        writeln(script, line);
        line := '';
        if i = num2 then
        begin
          writeln(script, '{END}');
          writeln(script);
        end;
      end
      else if ps = endt then
      begin
        line := line + '{END}';
        writeln(script, line);
        writeln(script);
{    if rzero and (i < num2) then writeln(script, Inttohex(i + 1, 8));}
        line := '';
      end
      else
      begin
        line := line + table[ps];
        if i = num2 then
        begin
          writeln(script, line);
          line := '';
        end;
      end;
    end;
    closefile(script);
    showmessage('Извлечено ' + inttostr(num2 - num1 + 1) + ' байт.');
  end;
end;

//REPLACE SCRIPT
procedure TDjinnTileMapper.N24Click(Sender: TObject);
var
  script: textfile;
  line: string;
  i: integer;
  scrt: tstrings;
  n, l, j, k: Integer;
  s: string;

  function cfind(p: Integer): Integer;
  var
    g: Integer;
    n: Byte;
  begin
    Result := -1;
    for g := maxtlen downto 1 do
      for n := 0 to 255 do
        if Copy(s, p, g) = Table[n] then
        begin
          Result := n;
          Exit;
        end;
  end;

label
  laba;
begin
  crtransform.dmp := false;
  crtransform.Caption := 'Заменить текст';
  crtransform.radiobutton1.Visible := true;
  crtransform.radiobutton1.checked := true;
  crtransform.radiobutton2.Visible := {true}false;
  crtransform.CheckBox1.Checked := false;
  crtransform.CheckBox1.Caption := 'Остальное заполнить нулями';
  crtransform.Label1.Visible := false;
  crtransform.showmodal;
  if crtransform.ok then
  begin
    assignfile(script, crtransform.rr.FileName);
    reset(script);
    scrt := tstringlist.Create;
    while not eof(script) do
    begin
      readln(script, line);
      scrt.Add(line);
    end;
    s := scrt.GetText;
    k := 0;
    for j := 1 to scrt.Count do
    begin
      s := scrt.Strings[j - 1];
      i := 1;
      l := 0;
      while i <= Length(s) do
      begin
        n := cfind(i);
        if n >= 0 then
        begin
          inc(i, Length(Table[n]) - 1);
          ROMData^[num1 + k + l] := n;
          Inc(l);
        end;
        Inc(i);
      end;
      inc(k, l);
      if (ROMData^[num1 + k - 1] <> endt) or ((s = '') and ((j = 1) or ((ROMData^[num1 + k - 1] = ENDT) and (scrt.Strings[j - 2] = '')))) then
      begin
        ROMData^[num1 + k] := PERENOS;
        inc(k);
      end;
    end;
    scrt.Free;
    drawtilemap;
    closefile(script);
  end;
end;

procedure TDjinnTileMapper.N25Click(Sender: TObject);
begin
  searchresform.show;
end;

procedure TDjinnTileMapper.InitPoses;
var
  iBorderWidth: Integer;
begin
  Width := dataform.Width;
  Top := 10;
  Left := 10;
  iBorderWidth := (Width - ClientWidth) div 2;
  tilemapform.Top := 10;
  tilemapform.Left := Left + Width + iBorderWidth;
  dataform.Top := Top + Height + iBorderWidth;
  dataform.Left := 10;
  teditform.Top := tilemapform.Top + tilemapform.Height + iBorderWidth;
  teditform.left := dataform.Left + dataform.Width + iBorderWidth;
  PalForm.Top := teditform.Top;
  PalForm.Left := teditform.Left + teditform.Width + iBorderWidth;
end;

procedure TDjinnTileMapper.N27Click(Sender: TObject);
begin
  initposes;
end;

procedure TDjinnTileMapper.N28Click(Sender: TObject);
var
  b: byte;
  I: longword;
begin
  b := strtoint(InputForm.InputBx(Application.Title, 'Введите заполняющий байт', ['0'..'9', #13, #8], 3));
  if not InputForm.iokresult then
    exit;
  for i := romdatapos + cdpos to romdatapos + cdpos + maxSlen - 1 do
    romdata^[i] := b;
  drawtilemap;
end;

function TDjinnTileMapper.GetTileType: TTileType;
begin
  Result := Cdc;
end;

procedure TDjinnTileMapper.SetTileType(const Value: TTileType);
begin
  cdc := Value;
  SmallPalSet:= BigPalSet div CLR_CNT[CDC];
  case cdc of
    tt1bit:
      begin
        foreground := 2;
        background := 1;
      end;
    tt2bitNES, tt2bitGBC, tt2bitNGP, tt2bitVB, tt2bitMSX:
      begin
        foreground := 4;
        background := 1;
      end;
    tt3bitSNES:
      begin
      Foreground := 7;
      Background := 0;
      end
  else
    begin
      Foreground := 15;
      Background := 0;
    end;
  end;
  if ROMOpened then
  begin
    MapScrollEnable;
    DrawTileMap;
    DrawTile(tlwidthv, tlheightv);
  end;
end;

procedure TDjinnTileMapper.N29Click(Sender: TObject);
begin
  N29.Checked := not N29.Checked;
  PalForm.Visible := N29.Checked;
end;

procedure TDjinnTileMapper.SetMapFormat(const Value: TMapFormat);
begin
  FMapFormat := Value;
end;

procedure TDjinnTileMapper.ShowWorkSpaceClick(Sender: TObject);
begin
  if WSForm.Visible then
  begin
    WSForm.Hide();
    bWorkSpace := False;
    ShowWorkSpace.Checked := False;
  end
  else
  begin
    WSForm.Show();
    bWorkSpace := True;
    ShowWorkSpace.Checked := True;
  end;

end;

{ TBitReader }

constructor TBitReader.Create(const Src; Size: Integer);
begin
  Source := Addr(Src);
  Length := Size;
  Position := 0;
end;

function TBitReader.Read(BitCount: Integer): LongWord;
var
  I, Bit: Integer;
begin
  Result := 0;
  for I := 0 to BitCount - 1 do
  begin
    Bit := Read();
    if Bit < 0 then
    begin
      MessageDlg('Can not read needed count of the bits', mtError, [mbOk], 0);
    end
    else
    begin
      Result := Result shl 1;
      Inc(Result, Bit);
    end;
  end;
end;

function TBitReader.GetBit(Index: Integer): Byte;
var
  I, J: Integer;
begin
  if Index >= Length then
  begin
    raise EbitsError.CreateRes(@SbitsIndexError);
  end;
  I := Index div 8;
  J := Index mod 8;
  Result := (Source[I] shr (7 - J)) and 1;
end;

function TBitReader.GetLength: Integer;
begin
  Result := FLength * 8;
end;

function TBitReader.Read(): Integer;
var
  I, J: Integer;
begin
  if Position >= Length then
  begin
    raise EBitsError.CreateRes(@SBitsIndexError);
  end;
  I := Position div 8;
  J := Position mod 8;
  Position := Position + 1;
  Result := (Source[I] shr (7 - J)) and 1;
end;

function TBitReader.Seek(Shift: Integer; Origin: TSeekOrigin): Boolean;
begin
  case Origin of
    soBeginning:
      Position := Shift;
    soCurrent:
      Position := Position + Shift;
    soEnd:
      Position := Length - Shift - 1;
  end;
  if Position < 0 then
  begin
    Position := 0;
    Result := False;
  end
  else
  if Position >= Length then
  begin
    Position := Length - 1;
    Result := False;
  end
  else
    Result := True;
end;

procedure TBitReader.SetBit(Index: Integer; const Value: Byte);
var
  I, J: Integer;
begin
  if Index >= Length then
  begin
    raise EbitsError.CreateRes(@SbitsIndexError);
  end;
  I := Index div 8;
  J := Index mod 8;
  Source[I] := Source[I] and not (1 shl (7 - J));
  Source[I] := Source[I] or (Value shl (7 - J));
end;

procedure TBitReader.SetLength(const Value: Integer);
begin
  FLength := Value;
end;

procedure TBitReader.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TBitReader.SetSource(const Value: PByteArray);
begin
  FSource := Value;
end;

procedure TBitReader.Write(Value: LongWord; BitCount: Integer);
var
  I: Integer;
begin
  for I := 0 to BitCount - 1 do
  begin
    Write((Value shr (BitCount - I - 1) and 1));
  end;
end;

procedure TBitReader.Write(Value: Byte);
const
  ResetBit: array[0..7] of Byte = ($FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F);
  SetBit: array[0..7] of Byte = ($1, $2, $4, $8, $10, $20, $40, $80);
var
  I, J: Integer;
begin
  I := Position div 8;
  J := Position mod 8;
  Position := Position + 1;
  if Value = 1 then
    Source[I] := Source[I] or SetBit[7 - J]
  else
    Source[I] := Source[I] and ResetBit[7 - J];
end;

{ TBitWriter }

constructor TBitWriter.Create(var Dst; Size: Integer);
begin
  Length := Size;
  dest := @Dst;
end;

function TBitWriter.GetBit(Index: Integer): Byte;
var
  I, J: Integer;
begin
  if Index >= Length then
  begin
    raise EbitsError.CreateRes(@SbitsIndexError);
  end;
  I := Index div 8;
  J := Index mod 8;
  Result := (dest[I] shr (7 - J)) and 1;
end;

function TBitWriter.GetLength: Integer;
begin
  Result := FLength * 8;
end;

function TBitWriter.Seek(Shift: Integer; Origin: TSeekOrigin): Boolean;
begin
  case Origin of
    soBeginning:
      Position := Shift;
    soCurrent:
      Position := Position + Shift;
    soEnd:
      Position := Length - Shift - 1;
  end;
  if Position < 0 then
  begin
    Position := 0;
    Result := False;
  end
  else
  if Position >= Length then
  begin
    Position := Length - 1;
    Result := False;
  end
  else
    Result := True;
end;

procedure TBitWriter.SetBit(Index: Integer; const Value: Byte);
var
  I, J: Integer;
begin
  if Index >= Length then
  begin
    raise EbitsError.CreateRes(@SbitsIndexError);
  end;
  I := Index div 8;
  J := Index mod 8;
  dest[I] := dest[I] and not (1 shl (7 - J));
  dest[I] := dest[I] or (Value shl (7 - J));
end;

procedure TBitWriter.SetDest(const Value: PByteArray);
begin
  FDest := Value;
end;

procedure TBitWriter.SetLength(const Value: Integer);
begin
  FLength := Value;
end;

procedure TBitWriter.SetPosition(const Value: Integer);
begin
  FPosition := Value;
end;

procedure TBitWriter.Write(Value: LongWord; BitCount: Integer);
var
  I: Integer;
begin
  for I := 0 to BitCount - 1 do
  begin
    Write((Value shr (BitCount - I - 1) and 1));
  end;
end;

procedure TBitWriter.Write(Value: Byte);
const
  ResetBit: array[0..7] of Byte = ($FE, $FD, $FB, $F7, $EF, $DF, $BF, $7F);
  SetBit: array[0..7] of Byte = ($1, $2, $4, $8, $10, $20, $40, $80);
var
  I, J: Integer;
begin
  I := Position div 8;
  J := Position mod 8;
  Position := Position + 1;
  if Value = 1 then
    dest[I] := dest[I] or SetBit[7 - J]
  else
    dest[I] := dest[I] and ResetBit[7 - J];
end;

{ TBlock }

procedure TBlock.SetAddress(const Value: LongWord);
begin
  FAddress := Value;
end;

procedure TBlock.SetH(const Value: Boolean);
begin
  FH:= Value;
  case DTM.MapFormat of
    mfGBA:
      FValue := (FValue and $FBFF) or (Byte(Value) shl 10);
    mfSNES:
      FValue := (FValue and $BFFF) or (Byte(Value) shl 14);
    mfMSX:
      FValue := (FValue and $F7FF) or (Byte(Value) shl 11);
    mfSMS:
      FValue := (FValue and $FDFF) or (Byte(Value) shl 9);
  end;
end;

//procedure TBlock.SetH(const Value: Boolean);
//begin
//  FH:= Value;
//  case DTM.MapFormat of
//    mfGBA:
//      FValue := (FValue and $FBFF) or (Byte(Value) shl 10);
//    mfSNES:
//      FValue := (FValue and $BFFF) or (Byte(Value) shl 14);
//    mfMSX:
//      FValue := (FValue and $F7FF) or (Byte(Value) shl 11);
//    mfSMS:
//      FValue := (FValue and $FDFF) or (Byte(Value) shl 9);
//  end;
//end;

procedure TBlock.SetIndex(const Value: Word);
begin
  case DTM.MapFormat of
    mfSingleByte, mfGBC:
      begin
        FIndex := Value and $FF;
        FValue := FIndex;
      end;
    mfGBA, mfSNES:
      begin
        FIndex := Value and $3FF;
        FValue := (FValue and $FC00) or FIndex;
      end;
    mfMSX, mfPCE:
      begin
        FIndex := Value and $7FF;
        FValue := (FValue and $F800) or FIndex;
      end;
    mfSMS:
      begin
        FIndex := Value and $1FF;
        FValue := (FValue and $FE00) or FIndex;
      end;
  end;
end;

procedure TBlock.SetP(const Value: Boolean);
begin
  FP := Value;
  case DTM.MapFormat of
    mfSNES:
      FValue := (FValue and $DFFF) or (Byte(Value) shl 13);
    mfMSX:
      FValue := (FValue and $7FFF) or (Byte(Value) shl 15);
    mfSMS:
      FValue := (FValue and $EFFF) or (Byte(Value) shl 12);
  end;
end;

procedure TBlock.SetPal(const Value: Byte);
begin
  FPal := Value;
  case DTM.MapFormat of
    mfGBA:
      FValue := (FValue and $F0FF) or (Value shl 8);
    mfSNES:
      FValue := (FValue and $E3FF) or (Value shl 10);
    mfMSX:
      FValue := (FValue and $9FFF) or (Value shl 13);
    mfPCE:
      FValue := (FValue and $FFF)  or (Value shl 12);
    mfSMS:
      FValue := (FValue and $F7FF) or (Value shl 11);
  end;
end;

procedure TBlock.SetV(const Value: Boolean);
begin
  FV := Value;
  case DTM.MapFormat of
    mfGBA:
      FValue := (FValue and $F7FF) or (Byte(Value) shl 11);
    mfSNES:
      FValue:=  (FValue and $7FFF) or (Byte(Value) shl 15);
    mfMSX:
      FValue:=  (FValue and $EFFF) or (Byte(Value) shl 12);
    mfSMS:
      FValue := (FValue and $FBFF) or (Byte(Value) shl 10);
  end;
end;

procedure TBlock.SetValue(const Value: Word);
begin
  FValue := Value;
  case DTM.MapFormat of
    mfSingleByte:
//      asm
//        mov [eax].FH, 0;
//        mov [eax].FV, 0;
//        mov [eax].FP, 0;
//        mov [eax].FPal, 0;
//        and dx, $FF;
//        mov [eax].FIndex, dx;
//      end;
      begin
        FH := False;
        FV := False;
        FP := False;
        FPal := 0;
        FIndex := Value and $FF;
      end;
    mfGBC:
      begin
        //
        FH := False;
        FV := False;
        FP := False;
        FPal := 0;
        FIndex := Value and $FF;
      end;
    mfGBA:
      begin
        FH := Boolean((Value shr 10) and 1);
        FV := Boolean((Value shr 11) and 1);
        FPal := (Value shr 12) and $F;
        FIndex := Value and $3FF;
      end;
    mfSNES:
      begin
        //snes           vhpc ccnn nnnn nnnn
        FP := Boolean((Value shr 13) and 1);
        FH := Boolean((Value shr 14) and 1);
        FV := Boolean((Value shr 15) and 1);
        FPal := (Value shr 10) and 7;
        FIndex := Value and $3FF;
      end;
    mfMSX:
      begin
        FP := Boolean((Value shr 15) and 1);//(Value and $8000) = $8000;
        FH := Boolean((Value shr 11) and 1);//(Value and $800) = $800;//
        FV := Boolean((Value shr 12) and 1);//(Value and $1000) = $1000;//
        FPal := (Value shr 13) and 3;//(Value and $6000) shr 13;
        FIndex := Value and $7FF;
      end;
    mfPCE:
      begin
        //pc engine      cccc nnnn nnnn nnnn
        FH := False;
        FV := False;
        FPal := (Value shr 12) and $F;
        FIndex := Value and $7FF;
      end;
    mfSMS:
      begin
        //master system  ???p cvhn nnnn nnnn
        FH := Boolean((Value shr 9) and 1);
        FV := Boolean((Value shr 10) and 1);
        FPal := (Value shr 11) and 1;
        FIndex := Value and $1FF;
      end;
  end;
end;
{ TBlock }
procedure TDjinnTileMapper.tmr1Timer(Sender: TObject);
begin
  BorderPen.DashOffset:= (Round(BorderPen.DashOffset) + 1) mod 8;
  if dataform.Block.Visible then
    dataform.Repaint;
  if WSForm.Block.Visible then
    WSForm.FormPaint(Self);
end;

initialization
  // Register the custom clipboard format
  CF_DTMDATA := RegisterClipBoardFormat(DDGData);
end.

