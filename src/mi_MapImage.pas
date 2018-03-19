unit mi_MapImage;

interface

uses Windows, SysUtils, Classes, DIB, TilesUnit;

type
 //TTileType = (tt2bitNES, tt2bitGBC, tt4bit, tt4bitSNES, tt4bitMSX, tt8bit, tt8bitSNES);
 TTileType = (tt1bit, tt2bitNES, tt2bitGBC, tt2bitNGP, tt2bitVB, tt2bitMSX, tt3bitSNES, tt3bit, tt4bit, tt4bitSNESM, tt4bitSNES, tt4bitMSX, tt4bitSMS, tt8bit, tt8bitSNES);
 TMapFormat = (mfSingleByte, mfGBC, mfGBA, mfSNES, mfMSX, mfPCE);
 TMResType = (rtMap, rtMapNoHeader, rtTiles, rtPalette, rtBitmap);
 TRGB = packed record
  R: Byte;
  G: Byte;
  B: Byte;
 end;
 TRGBPal = array[Byte] of TRGB;
 TBlock = packed record
  Priority: boolean;
  PalIndex: byte;
  YFlip: boolean;
  XFlip: boolean;
  TileID: Word;
 end;

 TMapImage = class
  private
    FWidth, FLastWidth: Integer;
    FHeight, FLastHeight: Integer;
    FTileList: TTileList;
    FFixedTiles: TTileList;
    FMapFormat: TMapFormat;
    FPalette: TRGBQuads;
    FByteMap: array of Byte;
    FWordMap: array of Word;
    FPaletteIndex: Byte;
    FTileType: TTileType;    
    procedure SetMapFormat(Value: TMapFormat);
    function GetImageWidth: Integer;
    function GetImageHeight: Integer;
    function GetImageSize: Integer;
    function GetOptimization: Boolean;
    procedure SetWidth(Value: Integer);
    procedure SetHeight(Value: Integer);
    procedure SetImageWidth(Value: Integer);
    procedure SetImageHeight(Value: Integer);
    procedure SetSize(W, H: Integer);
    procedure SetTileType(Value: TTileType);
    procedure SetOptimization(Value: Boolean);
  public
    property Width: Integer read FWidth write SetWidth;
    property Height: Integer read FHeight write SetHeight;
    property ImageWidth: Integer read GetImageWidth write SetImageWidth;
    property ImageHeight: Integer read GetImageHeight write SetImageHeight;
    property ImageSize: Integer read GetImageSize;
    property TileType: TTileType read FTileType write SetTileType;
    property MapFormat: TMapFormat read FMapFormat write SetMapFormat;
    property Palette: TRGBQuads read FPalette write FPalette;
    property Optimization: Boolean read GetOptimization write SetOptimization;
    property TileList: TTileList read FTileList;
    property FixedTiles: TTileList read FFixedTiles;
    property PaletteIndex: Byte read FPaletteIndex write FPaletteIndex;

    constructor Create;
    destructor Destroy; override;
    procedure BufDraw(var Dest; RowStride: Integer);
    procedure BufLoad(var Source; RowStride: Integer);

    procedure LoadMapFromStream(const Stream: TStream; NoHeader: Boolean);
    procedure LoadTilesFromStream(const Stream: TStream);
    procedure LoadPaletteFromStream(const Stream: TStream);
    procedure LoadFromFile(const FileName: String; MResType: TMResType);
    procedure SaveMapToStream(const Stream: TStream; NoHeader: Boolean);
    procedure SaveTilesToStream(const Stream: TStream);
    procedure SavePaletteToStream(const Stream: TStream);
    procedure SaveToFile(const FileName: String; MResType: TMResType);

    procedure LoadFromBitmapStream(const Stream: TStream);
    procedure SaveToBitmapStream(const Stream: TStream);
 end;

const
 CLR_CNT: array[TTileType] of Integer = (2, 4, 4, 4, 4, 4, 8, 8, 16, 16, 16, 16, 16, 256, 256);


implementation

function SwapWord(Value: Word): Word;
asm
 xchg al,ah
end;

function ConvertSNEStoSMD(var Source): TTile4Bit;
var
  P0, P1, P2, P3: PByte;
  Y: Integer;
begin
  P0:= Addr(TTile4Bit(Source)[0,0]);
  P1:= Addr(TTile4Bit(Source)[0,1]);
  P2:= Addr(TTile4Bit(Source)[4,0]);
  P3:= Addr(TTile4Bit(Source)[4,2]);
  For Y:= 0 to 7 do
  begin
    Result[Y,0]:= ((P0^ and $80) shr 3) or
                  ((P1^ and $80) shr 2) or
                  ((P2^ and $80) shr 1) or
                  ((P3^ and $80)      ) or
                  ((P0^ and $40) shr 7) or
                  ((P1^ and $40) shr 6) or
                  ((P2^ and $40) shr 5) or
                  ((P3^ and $40) shr 4);

    Result[Y,1]:= ((P0^ and $20) shr 3) or
                  ((P1^ and $20) shr 2) or
                  ((P2^ and $20) shr 1) or
                  ((P3^ and $20)      ) or
                  ((P0^ and $10) shr 7) or
                  ((P1^ and $10) shr 6) or
                  ((P2^ and $10) shr 5) or
                  ((P3^ and $10) shr 4);

    Result[Y,2]:= ((P0^ and $8) shr 3) or
                  ((P1^ and $8) shr 2) or
                  ((P2^ and $8) shr 1) or
                  ((P3^ and $8)      ) or
                  ((P0^ and $4) shr 7) or
                  ((P1^ and $4) shr 6) or
                  ((P2^ and $4) shr 5) or
                  ((P3^ and $4) shr 4);

    Result[Y,3]:= ((P0^ and $2) shr 3) or
                  ((P1^ and $2) shr 2) or
                  ((P2^ and $2) shr 1) or
                  ((P3^ and $2)      ) or
                  ((P0^ and $1) shr 7) or
                  ((P1^ and $1) shr 6) or
                  ((P2^ and $1) shr 5) or
                  ((P3^ and $1) shr 4);

    inc(P0);
    inc(P1);
    inc(P2);
    inc(P3);
  end;  //For Y:= 0 to 7 do
end;

procedure TMapImage.BufDraw(var Dest; RowStride: Integer);
var
 Y, X, BigStride, TW: Integer;
 MB: PByte; Dst, P: PByte;
 MW: PWord absolute MB; W: Word;
begin
 if (FWidth = 0) or (FHeight = 0) then Exit;
 Dst := @Dest;
 TW := FTileList.TileWidth;
 BigStride := RowStride * FTileList.TileHeight;
 case FMapFormat of
  mfSingleByte:
  begin
   MB := Pointer(FByteMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     with FTileList.FastTiles[MB^] do
     begin
      FirstColor := 0;
      BufDraw(P^, RowStride);
     end;
     Inc(P, TW);
     Inc(MB);
    end;
    Inc(Dst, BigStride);
   end;
  end;

  mfGBC:
  begin
   MW := Pointer(FWordMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     with FTileList.FastTiles[MW^ and $FF] do
     begin
      FirstColor := ((MW^ shr 8) and 15) * 16;
      BufDraw(P^, RowStride, Boolean((MW^ shr 13) and 1),
                             Boolean((MW^ shr 14) and 1));
     end;
     Inc(P, TW);
     Inc(MW);
    end;
    Inc(Dst, BigStride);
   end;
  end;

  mfGBA:
  begin
   MW := Pointer(FWordMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     with FTileList.FastTiles[MW^ and $3FF] do
     begin
      FirstColor := ((MW^ shr 12) and 15) * 16;
      BufDraw(P^, RowStride, Boolean((MW^ shr 10) and 1),
                             Boolean((MW^ shr 11) and 1));
     end;
     Inc(P, TW);
     Inc(MW);
    end;
    Inc(Dst, BigStride);
   end;
  end;
  mfSNES:
  begin
   MW := Pointer(FWordMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     with FTileList.FastTiles[MW^ and $3FF] do
     begin
      FirstColor := ((MW^ shr 10) and 7) * 16;
      BufDraw(P^, RowStride, Boolean((MW^ shr 14) and 1),
                             Boolean((MW^ shr 15) and 1));
     end;
     Inc(P, TW);
     Inc(MW);
    end;
    Inc(Dst, BigStride);
   end;
  end;
  mfMSX:
  begin
   MW := Pointer(FWordMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     W := SwapWord(MW^);
     with FTileList.FastTiles[W and $7FF] do
     begin
      FirstColor := ((W shr 13) and 3) * 16;
      BufDraw(P^, RowStride, Boolean((W shr 11) and 1),
                             Boolean((W shr 12) and 1));
     end;
     Inc(P, TW);
     Inc(MW);
    end;
    Inc(Dst, BigStride);
   end;
  end;
  mfPCE:
  begin
   MW := Pointer(FWordMap);
   for Y := 0 to FHeight - 1 do
   begin
    P := Dst;
    for X := 0 to FWidth - 1 do
    begin
     with FTileList.FastTiles[MW^ and $7FF] do
     begin
      FirstColor := ((MW^ shr 12) and 15) * 16;
      BufDraw(P^, RowStride, False,
                             False);
     end;
     Inc(P, TW);
     Inc(MW);
    end;
    Inc(Dst, BigStride);
   end;
  end;
 end;
end;



procedure TMapImage.BufLoad(var Source; RowStride: Integer);
var
 TempTile, Tile: TCustomTile;
 XFlip, YFlip, TempOptimize: Boolean;
 BigStride, TileWidth, X, Y: Integer;
 Src, MB, P: PByte; MW: PWord;
begin
 if (FWidth = 0) or (FHeight = 0) then Exit;

 FTileList.Assign(FFixedTiles);
 FTileList.ResetEmptyBlock;
 TempOptimize := FTileList.Optimization;

 if (FMapFormat = mfSingleByte) or (FMapFormat = mfPCE) then
  FTileList.Optimization := False;

 Src := @Source;
 TempTile := TTileClass(FTileList.NodeClass).Create;
 TileWidth := TempTile.Width;
 BigStride := RowStride * TempTile.Height;
 MB := Pointer(FByteMap);
 MW := Pointer(FWordMap);
 for Y := 0 to FHeight - 1 do
 begin
  P := Src;
  for X := 0 to FWidth - 1 do
  begin
   TempTile.BufLoad(P^, RowStride);
   case FMapFormat of
   mfGBA, mfPCE, mfGBC:         // Определяем номер палитры для GBA
    case P^ of
    0..15: FPaletteIndex:=0;
    16..31: FPaletteIndex:=1;
    32..47: FPaletteIndex:=2;
    48..63: FPaletteIndex:=3;
    64..79: FPaletteIndex:=4;
    80..95: FPaletteIndex:=5;
    96..111: FPaletteIndex:=6;
    112..127: FPaletteIndex:=7;
    128..143: FPaletteIndex:=8;
    144..159: FPaletteIndex:=9;
    160..175: FPaletteIndex:=10;
    176..191: FPaletteIndex:=11;
    192..207: FPaletteIndex:=12;
    208..223: FPaletteIndex:=13;
    224..239: FPaletteIndex:=14;
    240..255: FPaletteIndex:=15;
    end;
  mfSNES:
    case P^ of
    0..15: FPaletteIndex:=0;
    16..31: FPaletteIndex:=1;
    32..47: FPaletteIndex:=2;
    48..63: FPaletteIndex:=3;
    64..79: FPaletteIndex:=4;
    80..95: FPaletteIndex:=5;
    96..111: FPaletteIndex:=6;
    112..127: FPaletteIndex:=7;
    end;
    
  mfMSX:
    case P^ of     //// Определяем номер палитры для Sega Genesis
    0..15: FPaletteIndex:=0;
    16..31: FPaletteIndex:=1;
    32..47: FPaletteIndex:=2;
    48..63: FPaletteIndex:=3;
    end;
   end;

   Inc(P, TileWidth);
   Tile := FTileList.AddOrGet(TempTile.TileData^, XFlip, YFlip);

   case FMapFormat of
    mfSingleByte:
    begin
     MB^ := Tile.TileIndex;
     Inc(MB);
    end;
    mfGBC:
    begin
     MW^ := (Tile.TileIndex and $FF) or
            (Byte(XFlip) shl 13) or
            (Byte(YFlip) shl 14) or
            ((FPaletteIndex and 15) shl 8);
     Inc(MW);
    end;
    mfGBA:
    begin
     MW^ := (Tile.TileIndex and $3FF) or
            (Byte(XFlip) shl 10) or
            (Byte(YFlip) shl 11) or
            ((FPaletteIndex and 15) shl 12);
     Inc(MW);
    end;
    mfSNES:
    begin
     MW^ := (Tile.TileIndex and $3FF) or
            (Byte(XFlip) shl 14) or
            (Byte(YFlip) shl 15) or
            ((FPaletteIndex and 7) shl 10);
     Inc(MW);
    end;
    mfMSX:
    begin
     MW^ := SwapWord((Tile.TileIndex and $7FF) or
            (Byte(XFlip) shl 11) or
            (Byte(YFlip) shl 12) or
            ((FPaletteIndex and 3) shl 13));
     Inc(MW);
    end;

    mfPCE:
    begin
     MW^ := (Tile.TileIndex and $7FF) or
            ((FPaletteIndex and $F) shl 12);
     inc(MW);
    end;
   end;
  end;
  Inc(Src, BigStride);
 end;
 TempTile.Free;
 FTileList.SetEmptyBlocksLen(0);
 FTileList.MakeArray;
 FTileList.Optimization := TempOptimize;
end;

constructor TMapImage.Create;
begin
 FTileType := tt4bit;
 FMapFormat := mfSingleByte;
 FTileList := TTileList.Create(TTile4BPP, True);
 FTileList.TileClassAssign := False;
 FFixedTiles := TTileList.Create(TTile4BPP, True);
 FFixedTiles.TileClassAssign := False;
end;

destructor TMapImage.Destroy;
begin
 FFixedTiles.Free;
 FTileList.Free;
end;

function TMapImage.GetImageHeight: Integer;
begin
 Result := FHeight shl 3;
end;

function TMapImage.GetImageSize: Integer;
begin
 Result := (FWidth shl 3) * (FHeight shl 3);
end;

function TMapImage.GetImageWidth: Integer;
begin
 Result := FWidth shl 3;
end;

function TMapImage.GetOptimization: Boolean;
begin
 Result := FTileList.Optimization;
end;

procedure TMapImage.LoadFromBitmapStream(const Stream: TStream);
var Pic, Pic2: TDIB;
begin
 Pic := TDIB.Create;
 Pic.LoadFromStream(Stream);
 ImageWidth := Pic.Width;
 ImageHeight := Pic.Height;
 if Pic.BitCount < 8 then Pic.BitCount := 8;
 if Pic.BitCount > 8 then
 begin
  Pic2 := Pic;
  Pic := TDIB.Create;
  Pic.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
  Pic.BitCount := 8;
  Pic.Width := ImageWidth;
  Pic.Height := ImageHeight;
  Pic.ColorTable := FPalette;
  Pic.UpdatePalette;
  Pic.Fill8bit(0);
  Pic.Canvas.Draw(0, 0, Pic2);
  Pic2.Free;
 end else
 begin
  FPalette := Pic.ColorTable;
  Pic.Width := ImageWidth;
  Pic.Height := ImageHeight;
 end;
 try
  BufLoad(Pic.ScanLine[0]^, -Pic.WidthBytes);
 finally
  Pic.Free;
 end;
end;

procedure TMapImage.LoadFromFile(const FileName: String;
  MResType: TMResType);
var Stream: TFileStream;
begin
 Stream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
 try
  case MResType of
   rtMap: LoadMapFromStream(Stream, False);
   rtMapNoHeader: LoadMapFromStream(Stream, True);
   rtTiles: LoadTilesFromStream(Stream);
   rtPalette: LoadPaletteFromStream(Stream);
   rtBitmap: LoadFromBitmapStream(Stream);
  end;
 finally
  Stream.Free;
 end;
end;

procedure TMapImage.LoadMapFromStream(const Stream: TStream; NoHeader: Boolean);
var W, H: Integer;
begin
 if not NoHeader then
 case FMapFormat of
  mfSingleByte, mfGBC:
  begin
   Stream.Read(W, 1);
   Stream.Read(H, 1);
   Width := Byte(W);
   Height := Byte(H);
  end;
  mfGBA, mfSNES, mfPCE:
  begin
   Stream.Read(W, 2);
   Stream.Read(H, 2);
   Width := Word(W);
   Height := Word(H);
  end;
  mfMSX:
  begin
   Stream.Read(W, 2);
   Stream.Read(H, 2);
   Width := SwapWord(W);
   Height := SwapWord(H);
  end;
 end;
 if FMapFormat = mfSingleByte then
  Stream.Read(FByteMap[0], Length(FByteMap)) else
  Stream.Read(FWordMap[0], Length(FWordMap) shl 1);
end;

procedure TMapImage.LoadPaletteFromStream(const Stream: TStream);
var RGBPal: TRGBPal; I: Integer;
begin
 FillChar(RGBPal, SizeOf(TRGBPal), 0);
 Stream.Read(RGBPal, SizeOf(RGBPal));
 for I := 0 to 255 do with FPalette[I], RGBPal[I] do
 begin
  rgbRed := R;
  rgbGreen := G;
  rgbBlue := B;
  rgbReserved := 0;
 end;
end;

procedure TMapImage.LoadTilesFromStream(const Stream: TStream);
begin
 FTileList.LoadFromStream(Stream);
end;

procedure TMapImage.SaveMapToStream(const Stream: TStream;
  NoHeader: Boolean);
var W, H: Integer;
begin
 if not NoHeader then
 case FMapFormat of
  mfSingleByte, mfGBC:
  begin
   Stream.Write(FWidth, 1);
   Stream.Write(FHeight, 1);
  end;
  mfGBA, mfSNES, mfPCE:
  begin
   Stream.Write(FWidth, 2);
   Stream.Write(FHeight, 2);
  end;
  mfMSX:
  begin
   W := SwapWord(FWidth);
   Stream.Write(W, 2);
   H := SwapWord(FHeight);
   Stream.Write(H, 2);
  end;
 end;
 if FMapFormat = mfSingleByte then
  Stream.Write(FByteMap[0], Length(FByteMap)) else
  Stream.Write(FWordMap[0], Length(FWordMap) shl 1);
end;

procedure TMapImage.SavePaletteToStream(const Stream: TStream);
var RGBPal: TRGBPal; I: Integer;
begin
 for I := 0 to 255 do with FPalette[I], RGBPal[I] do
 begin
  R := rgbRed;
  G := rgbGreen;
  B := rgbBlue;
 end;
 Stream.Write(RGBPal, SizeOf(RGBPal));
end;

procedure TMapImage.SaveTilesToStream(const Stream: TStream);
var I: Integer;
begin
 with FTileList do
 for I := 0 to Length(FastTiles) - 1 do with FastTiles[I] do
 begin
  TileIndex := I;
  SaveToStream(Stream);
 end;
end;

procedure TMapImage.SaveToBitmapStream(const Stream: TStream);
var Pic: TDIB;
begin
 Pic := TDIB.Create;
 Pic.PixelFormat := MakeDIBPixelFormat(8, 8, 8);
 Pic.BitCount := 8;
 Pic.Width := ImageWidth;
 Pic.Height := ImageHeight;
 Pic.ColorTable := FPalette;
 Pic.UpdatePalette;
 try
  BufDraw(Pic.ScanLine[0]^, -Pic.WidthBytes);
  Pic.SaveToStream(Stream);
 finally
  Pic.Free;
 end;
end;

procedure TMapImage.SaveToFile(const FileName: String;
  MResType: TMResType);
var Stream: TFileStream;
begin
 Stream := TFileStream.Create(FileName, fmCreate);
 try
  case MResType of
   rtMap: SaveMapToStream(Stream, False);
   rtMapNoHeader: SaveMapToStream(Stream, True);
   rtTiles: SaveTilesToStream(Stream);
   rtPalette: SavePaletteToStream(Stream);
   rtBitmap: SaveToBitmapStream(Stream);
  end;
 finally
  Stream.Free;
 end;
end;

procedure TMapImage.SetHeight(Value: Integer);
begin
 if Value <> FHeight then
 begin
  SetSize(FWidth, Value);
  FHeight := Value;
 end;
end;

procedure TMapImage.SetImageHeight(Value: Integer);
begin
 if Value mod 8 <> 0 then Value := (Value shr 3) shl 3 + 8;
 SetHeight(Value div 8);
end;

procedure TMapImage.SetImageWidth(Value: Integer);
begin
 if Value mod 8 <> 0 then Value := (Value shr 3) shl 3 + 8;
 SetWidth(Value div 8);
end;

procedure TMapImage.SetMapFormat(Value: TMapFormat);
var
 I: Integer; WW: Word;
 B: PByte; W: PWord;
begin
//  //*************SMD***************//
//    pccvhnnn nnnnnnnn
//
//    p = Priority flag
//    c = Palette select
//    v = Vertical flip
//    h = Horizontal flip
//    n = Pattern name
//
//  //***********GBA***************//
//    ccccvhnn nnnnnnnn
//
//  //**********SNES**************//
//    vhpcccnn nnnnnnnn
//
//  //**********PC-Engine********//
//    ccccnnnn nnnnnnnn
//
//  //**********GBC*************//
//    pvh*cccc nnnnnnnn

 if Value <> FMapFormat then
 begin
  if (FWidth > 0) and (FHeight > 0) then
  Case FMapFormat of
   mfSingleByte:
   Case Value of
    mfGBA, mfSNES, mfPCE, mfGBC:
    begin
     SetLength(FWordMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := B^;
      Inc(B);
      Inc(W);
     end;
     Finalize(FByteMap);
    end;
    mfMSX:
    begin
     SetLength(FWordMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := SwapWord(B^);
      Inc(B);
      Inc(W);
     end;
     Finalize(FByteMap);
    end;
   end;

   mfGBA:
   Case Value of
    mfSingleByte:
    begin
     SetLength(FByteMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      B^ := W^;
      Inc(B);
      Inc(W);
     end;
     Finalize(FWordMap);
    end;

    mfGBC:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := (W^ and $FF) or
                    ((W^ and $0C00) shl 4) or ((W^ and $7000) shr 2);
      Inc(W);
     end;
    end;

    mfSNES:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := (W^ and $03FF) or
                    ((W^ and $0C00) shl 4) or ((W^ and $7000) shr 2);
      Inc(W);
     end;
    end;

    mfMSX:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := SwapWord((W^ and $03FF) or
                    ((W^ and $3C00) shl 1));
      Inc(W);
     end;
    end;

    mfPCE:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := W^ and $F3FF;
      Inc(W);
     end;
    end;

   end;

   mfMSX:
   Case Value of
    mfSingleByte:
    begin
     SetLength(FByteMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      B^ := SwapWord(W^);
      Inc(B);
      Inc(W);
     end;
     Finalize(FWordMap);
    end;
    mfGBA:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := SwapWord(W^);
      W^ := (WW and $3FF) or ((WW and $7800) shr 1);
      Inc(W);
     end;
    end;

    mfSNES:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := Swapword(W^);
      W^ := (WW and $3FF){Character} or ((WW and $8000) shr 2 {Priority}) or ((WW and $1800) shl 3{Flips}) or ((WW and $6000) shr 3{Palette});
      Inc(W);
     end;
    end;

    mfPCE:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := SwapWord(W^);
      W^ := (WW and $3FF) or ((WW and $6000) shr 1);
      Inc(W);
     end;
    end;

   end;

   mfSNES:
   case Value of

    mfSingleByte:
    begin
     SetLength(FByteMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      B^ := W^;
      Inc(B);
      Inc(W);
     end;
     Finalize(FWordMap);
    end;

    mfGBA:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := W^;
      W^ := (WW and $3FF) or ((WW and $C000) shr 4) or ((WW and $1C00) shl 2);
      Inc(W);
     end;
    end;

    mfMSX:
    begin
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := W^;
      W^ := SwapWord((WW and $3FF){Character} or ((WW and $2000) shl 2 {Priority}) or ((WW and $C000) shr 3{Flips}) or ((WW and $0C00) shl 3{Palette}));
      Inc(W);
     end;
    end;

    mfPCE:
    begin
      W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW := W^;
      W^ := (WW and $3FF) or ((WW and $1C00) shl 2);
      inc(W);
     end;
    end;

   end;

   mfPCE:
   case Value of
   mfSingleByte:
    begin
     SetLength(FByteMap, FWidth * FHeight);
     B := Pointer(FByteMap);
     W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      B^ := W^;
      Inc(B);
      Inc(W);
     end;
     Finalize(FWordMap);
    end;

    mfGBA:
    begin
      W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      W^ := W^ and $F3FF;
      inc(W);
     end;
    end;

    mfSNES:
    begin
      W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW:= W^;
      W^:= (WW and $3FF) or ((WW and $7000) shr 2);
      inc(W);
     end;
    end;

    mfMSX:
    begin
      W := Pointer(FWordMap);
     for I := 0 to FWidth * FHeight - 1 do
     begin
      WW:= W^;
      W^ := SwapWord((WW and $3FF) or ((WW and $3000) shl 1));
      inc(W);
     end;
    end;

   end;
  end;
  FMapFormat := Value;
 end;
end;

procedure TMapImage.SetOptimization(Value: Boolean);
begin
 FTileList.Optimization := Value;
 FFixedTiles.Optimization := Value;
end;

procedure TMapImage.SetSize(W, H: Integer);
var
 TempB: array of Byte;
 TempW: array of Word;
 YY, WW, HH: Integer;
 PB1, PB2: PByte;
 PW1, PW2: PWord;
begin
 if (W <= 0) or (H <= 0) then
 begin
  Finalize(FByteMap);
  Finalize(FWordMap);
 end else
 begin
  if FMapFormat = mfSingleByte then
  begin
   SetLength(TempB, W * H);
   PB1 := Pointer(FByteMap);
   PB2 := Pointer(TempB);
   HH := FLastHeight;
   if HH > H then HH := H;
   WW := FLastWidth;
   if WW > W then WW := W;
   for YY := 0 to HH - 1 do
   begin
    Move(PB1^, PB2^, WW);
    Inc(PB1, FLastWidth);
    Inc(PB2, W);
   end;
   SetLength(FByteMap, Length(TempB));
   Move(TempB[0], FByteMap[0], Length(TempB));
  end else
  begin
   SetLength(TempW, W * H);
   PW1 := Pointer(FWordMap);
   PW2 := Pointer(TempW);
   HH := FLastHeight;
   if HH > H then HH := H;
   WW := FLastWidth;
   if WW > W then WW := W;
   WW := WW shl 1;
   W := W;
   for YY := 0 to HH - 1 do
   begin
    Move(PW1^, PW2^, WW);
    Inc(PW1, FLastWidth);
    Inc(PW2, W);
   end;
   SetLength(FWordMap, Length(TempW));
   Move(TempW[0], FWordMap[0], Length(TempW) shl 1);
  end;
 end;
 FLastWidth := W;
 FLastHeight := H;
end;

procedure TMapImage.SetTileType(Value: TTileType);
var
 I: Integer; Error: Boolean;
 TLS: array[0..1] of TTileList;
begin
 if Value <> FTileType then
 begin
  TLS[0] := NIL;
  TLS[1] := NIL;
  Error := False;
  for I := 0 to 1 do
  begin
   TLS[I] := TTileList.Create;
   TLS[I].TileClassAssign := False;
   with TLS[I] do
   begin
    case Value of
     tt2bitNES: NodeClass := TTile2BPP_NES;
     tt4bit:    NodeClass := TTile4BPP;
     tt4bitMSX: NodeClass := TTile4BPP_MSX;
     tt4bitSNES: NodeClass := TTile4BPP_SNES;
     tt8bitSNES: NodeClass := TTile8BPP_SNES;
     tt8bit:    NodeClass := TTile8BPP;
    end;
    try
     if I = 0 then
      Assign(FTileList) else
      Assign(FFixedTiles);
    except
     Error := True;
    end;
   end;
   if Error then Break;
  end;
  if not Error then
  begin
   FTileList.Free;
   FTileList := TLS[0];
   FFixedTiles.Free;
   FFixedTiles := TLS[1];
   FTileType := Value;
  end else
  begin
   TLS[0].Free;
   TLS[1].Free;
   raise Exception.Create('Unexpected error.');
  end;
 end;
end;

procedure TMapImage.SetWidth(Value: Integer);
begin
 if Value <> FWidth then
 begin
  SetSize(Value, FHeight);
  FWidth := Value;
 end;
end;

end.
