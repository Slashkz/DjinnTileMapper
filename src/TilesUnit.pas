unit TilesUnit;

interface

uses SysUtils, Classes, NodeLst, HexUnit, MyClasses;

type
 TTile2bit = Array[0..7, 0..1] of Byte;
 TTile2bit_NES = Array[0..1, 0..7] of Byte;
 TTile4bit = Array[0..7, 0..3] of Byte;
 TTile8bit = Array[0..7, 0..7] of Byte;

 TCustomTile = class(TStreamedNode)
  private
    FTileIndex: Integer;
    FFirstColor: Byte;
  protected
    function GetTileSize: Integer; virtual;
    function GetTileData: Pointer; virtual;
    function GetWidth: Integer; virtual;
    function GetHeight: Integer; virtual;
    procedure Initialize; override;
  public
    property TileIndex: Integer read FTileIndex write FTileIndex;
    property TileSize: Integer read GetTileSize;
    property TileData: Pointer read GetTileData;
    property FirstColor: Byte read FFirstColor write FFirstColor;
    property Width: Integer read GetWidth;
    property Height: Integer read GetHeight;

    procedure Flip(X, Y: Boolean; var Dest); virtual; abstract;
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); virtual;
    procedure BufLoad(const Source; RowStride: Integer); virtual;

    procedure LoadFromStream(const Stream: TStream); override;
    procedure SaveToStream(const Stream: TStream); override;
    procedure Assign(Source: TNode); override;
 end;

 TTileItems = array of TCustomTile;
 TTileClass = class of TCustomTile;

 TTile2BPP_NES = class(TCustomTile)
  private
    FData: TTile2bit_NES;
  protected
    function GetTileSize: Integer; override;
    function GetTileData: Pointer; override;
  public
    property Data: TTile2bit_NES read FData write FData;
    procedure Flip(X, Y: Boolean; var Dest); override;
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
 end;

 TTile4BPP = class(TCustomTile)
  private
    FData: TTile4bit;
  protected
    function GetTileSize: Integer; override;
    function GetTileData: Pointer; override;
  public
    property Data: TTile4bit read FData write FData;
    procedure Flip(X, Y: Boolean; var Dest); override;
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
 end;

 TTile4BPP_MSX = class(TTile4BPP)
  public
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
 end;

 TTile4BPP_SNES = class(TTile4BPP) // Added by Marat
  public
    procedure Flip(X, Y: Boolean; var Dest); override;
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
 end;


 TTile8BPP = class(TCustomTile)
  private
    FData: TTile8bit;
  protected
    function GetTileSize: Integer; override;
    function GetTileData: Pointer; override;
  public
    property Data: TTile8bit read FData write FData;
    procedure Flip(X, Y: Boolean; var Dest); override;
    procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
 end;

  TTile8BPP_SNES = class(TTile8BPP)  // Added by Marat
    public
      procedure Flip(X, Y: Boolean; var Dest); override;
      procedure BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False); override;
    procedure BufLoad(const Source; RowStride: Integer); override;
  end;

 PEmptyBlock = ^TEmptyBlock;
 TEmptyBlock = packed record
  ebStart: Integer;
  ebEnd: Integer;
 end;

 TEmptyBlocks = array of TEmptyBlock;

 TTileList = class(TStreamedList)
  private
    FOptimization: Boolean;
    FLastIndex: Integer;
    FMaxIndex: Integer;
    FEmptyBlocks: TEmptyBlocks;
    FCurrentBlock: PEmptyBlock;
    FEmptyTile: TCustomTile;
    FFastTiles: TTileItems;
    FTileSize,
    FTileWidth,
    FTileHeight: Integer;
    FTileClassAssign: Boolean;
    function GetTileItem(Index: Integer): TCustomTile;
    function GetTilesCount: Integer;
  protected
    procedure Initialize; override;
    procedure ClearData; override;
    procedure SetNodeClass(Value: TNodeClass); override;
    procedure AssignAdd(Source: TNode); override;
    procedure AssignNodeClass(Source: TNodeList); override;
  public
    property Optimization: Boolean read FOptimization write FOptimization;
    property EmptyBlocks: TEmptyBlocks read FEmptyBLocks write FEmptyBLocks;
    property TileSize: Integer read FTileSize;
    property TileWidth: Integer read FTileWidth;
    property TileHeight: Integer read FTileHeight;
    property Tiles[Index: Integer]: TCustomTile read GetTileItem;
    property FastTiles: TTileItems read FFastTiles;
    property TilesCount: Integer read GetTilesCount;
    property TileClassAssign: Boolean read FTileClassAssign
                                     write FTileClassAssign;

    function AddFixed(Index: Integer): TCustomTile;
    function AddOrGet(const Source; var XFlip, YFlip: Boolean): TCustomTile;
    constructor Create; overload;
    constructor Create(TileClass: TTileClass; Optimization: Boolean); overload;
    procedure ResetEmptyBlock;
    procedure AddEmptyBlock(StartIndex, EndIndex: Integer);
    procedure LoadFromStream(const Stream: TStream); override;
    procedure SaveToStream(const Stream: TStream); override;
    procedure AppendFromStream(const Stream: TStream; Count: Integer);
    procedure MakeArray;
    destructor Destroy; override;
    procedure Assign(Source: TNode); override;
    function FindEmptyIndex(Value: Integer): Integer;
    procedure DeleteEmptyBlock(Index: Integer);
    procedure SetEmptyBlocksLen(Len: Integer);
 end;

 ETileListError = class(Exception);

const
  MSX_Shifts: array[0..7] of Byte =
 (1 shl 2, 0 shl 2, 3 shl 2, 2 shl 2,
  5 shl 2, 4 shl 2, 7 shl 2, 6 shl 2);
  
  FlipTable: array[Byte] of Byte = (
	$00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0,
	$01,$11,$21,$31,$41,$51,$61,$71,$81,$91,$a1,$b1,$c1,$d1,$e1,$f1,
	$02,$12,$22,$32,$42,$52,$62,$72,$82,$92,$a2,$b2,$c2,$d2,$e2,$f2,
	$03,$13,$23,$33,$43,$53,$63,$73,$83,$93,$a3,$b3,$c3,$d3,$e3,$f3,
	$04,$14,$24,$34,$44,$54,$64,$74,$84,$94,$a4,$b4,$c4,$d4,$e4,$f4,
	$05,$15,$25,$35,$45,$55,$65,$75,$85,$95,$a5,$b5,$c5,$d5,$e5,$f5,
	$06,$16,$26,$36,$46,$56,$66,$76,$86,$96,$a6,$b6,$c6,$d6,$e6,$f6,
	$07,$17,$27,$37,$47,$57,$67,$77,$87,$97,$a7,$b7,$c7,$d7,$e7,$f7,
	$08,$18,$28,$38,$48,$58,$68,$78,$88,$98,$a8,$b8,$c8,$d8,$e8,$f8,
	$09,$19,$29,$39,$49,$59,$69,$79,$89,$99,$a9,$b9,$c9,$d9,$e9,$f9,
	$0a,$1a,$2a,$3a,$4a,$5a,$6a,$7a,$8a,$9a,$aa,$ba,$ca,$da,$ea,$fa,
	$0b,$1b,$2b,$3b,$4b,$5b,$6b,$7b,$8b,$9b,$ab,$bb,$cb,$db,$eb,$fb,
	$0c,$1c,$2c,$3c,$4c,$5c,$6c,$7c,$8c,$9c,$ac,$bc,$cc,$dc,$ec,$fc,
	$0d,$1d,$2d,$3d,$4d,$5d,$6d,$7d,$8d,$9d,$ad,$bd,$cd,$dd,$ed,$fd,
	$0e,$1e,$2e,$3e,$4e,$5e,$6e,$7e,$8e,$9e,$ae,$be,$ce,$de,$ee,$fe,
	$0f,$1f,$2f,$3f,$4f,$5f,$6f,$7f,$8f,$9f,$af,$bf,$cf,$df,$ef,$ff
);

 SNESFlipTable: array[Byte] of Byte = (
	$00,$80,$40,$c0,$20,$a0,$60,$e0,$10,$90,$50,$d0,$30,$b0,$70,$f0,
	$08,$88,$48,$c8,$28,$a8,$68,$e8,$18,$98,$58,$d8,$38,$b8,$78,$f8,
	$04,$84,$44,$c4,$24,$a4,$64,$e4,$14,$94,$54,$d4,$34,$b4,$74,$f4,
	$0c,$8c,$4c,$cc,$2c,$ac,$6c,$ec,$1c,$9c,$5c,$dc,$3c,$bc,$7c,$fc,
	$02,$82,$42,$c2,$22,$a2,$62,$e2,$12,$92,$52,$d2,$32,$b2,$72,$f2,
	$0a,$8a,$4a,$ca,$2a,$aa,$6a,$ea,$1a,$9a,$5a,$da,$3a,$ba,$7a,$fa,
	$06,$86,$46,$c6,$26,$a6,$66,$e6,$16,$96,$56,$d6,$36,$b6,$76,$f6,
	$0e,$8e,$4e,$ce,$2e,$ae,$6e,$ee,$1e,$9e,$5e,$de,$3e,$be,$7e,$fe,
	$01,$81,$41,$c1,$21,$a1,$61,$e1,$11,$91,$51,$d1,$31,$b1,$71,$f1,
	$09,$89,$49,$c9,$29,$a9,$69,$e9,$19,$99,$59,$d9,$39,$b9,$79,$f9,
	$05,$85,$45,$c5,$25,$a5,$65,$e5,$15,$95,$55,$d5,$35,$b5,$75,$f5,
	$0d,$8d,$4d,$cd,$2d,$ad,$6d,$ed,$1d,$9d,$5d,$dd,$3d,$bd,$7d,$fd,
	$03,$83,$43,$c3,$23,$a3,$63,$e3,$13,$93,$53,$d3,$33,$b3,$73,$f3,
	$0b,$8b,$4b,$cb,$2b,$ab,$6b,$eb,$1b,$9b,$5b,$db,$3b,$bb,$7b,$fb,
	$07,$87,$47,$c7,$27,$a7,$67,$e7,$17,$97,$57,$d7,$37,$b7,$77,$f7,
	$0f,$8f,$4f,$cf,$2f,$af,$6f,$ef,$1f,$9f,$5f,$df,$3f,$bf,$7f,$ff
);

implementation


{******************************Added by Marat**********************}
procedure CopyMem(P1, P2: Pointer; Length: Integer); assembler;
asm
        PUSH    ESI
        PUSH    EDI
        MOV     ESI,P1
        MOV     EDI,P2
        MOV     EDX,ECX
        XOR     EAX,EAX
        AND     EDX,3
        SHR     ECX,1
        SHR     ECX,1
        REPE    MOVSD
        MOV     ECX,EDX
        REPE    MOVSB
        POP     EDI
        POP     ESI
end;


{********************************************************************}



(* TCustomTile *)

procedure TCustomTile.Assign(Source: TNode);
var
 Tile: Pointer;
 W, H, X: Integer;
begin
 inherited;
 W := Width;
 H := Height;
 with TCustomTile(Source) do
 begin
  Self.FFirstColor := FFirstColor;
  X := Width;
  if W < X then W := X;
  X := Height;
  if H < X then H := X;
  GetMem(Tile, W * H);
  BufDraw(Tile^, W);
  X := FTileIndex;
 end;
 FTileIndex := X;
 BufLoad(Tile^, W);
 FreeMem(Tile);
end;

procedure TCustomTile.BufDraw(const Dest; RowStride: Integer;
           XFlip: Boolean = False; YFlip: Boolean = False);
begin
//do nothing
end;

procedure TCustomTile.BufLoad(const Source; RowStride: Integer);
begin
//do nothing
end;

function TCustomTile.GetHeight: Integer;
begin
 Result := 8;
end;

function TCustomTile.GetTileData: Pointer;
begin
 Result := NIL;
end;

function TCustomTile.GetTileSize: Integer;
begin
 Result := 0;
end;

function TCustomTile.GetWidth: Integer;
begin
 Result := 8;
end;

procedure TCustomTile.Initialize;
begin
 FAssignableClass := TCustomTile;
end;

procedure TCustomTile.LoadFromStream(const Stream: TStream);
begin
 Stream.Read(TileData^, TileSize);
end;

procedure TCustomTile.SaveToStream(const Stream: TStream);
begin
 Stream.Write(TileData^, TileSize);
end;

(* TTile2BPP_NES *)

procedure TTile2BPP_NES.BufDraw(const Dest; RowStride: Integer;
      XFlip, YFlip: Boolean);
var
 XX, YY: Integer;
 Src1, Src2: Byte;
 Dst, P: PByte;
begin
 Dst := @Dest;
 if not XFlip then Inc(Dst, 7);
 for YY := 0 to 7 do
 begin
  P := Dst;
  if YFlip then
  begin
   Src1 := FData[0, 7 - YY];
   Src2 := FData[1, 7 - YY];
  end else
  begin
   Src1 := FData[0, YY];
   Src2 := FData[1, YY];
  end;
  if not XFlip then for XX := 0 to 7 do
  begin
   P^ := FFirstColor + ((Src1 and 1) or ((Src2 and 1) shl 1));
   Src1 := Src1 shr 1;
   Src2 := Src2 shr 1;
   Dec(P);
  end else for XX := 0 to 7 do
  begin
   P^ := FFirstColor + ((Src1 and 1) or ((Src2 and 1) shl 1));
   Src1 := Src1 shr 1;
   Src2 := Src2 shr 1;
   Inc(P);
  end;
  Inc(Dst, RowStride);
 end;
end;

procedure TTile2BPP_NES.BufLoad(const Source; RowStride: Integer);
var
 XX, YY: Integer;
 Clr: Byte;
 Dst1, Dst2: PByte;
 Src, P: PByte;
begin
 Src := @Source;
 Dst1 := Addr(FData[0, 0]);
 Dst2 := Addr(FData[1, 0]);
 for YY := 0 to 7 do
 begin
  P := Src;
  Dst1^ := 0;
  Dst2^ := 0;
  for XX := 7 downto 0 do
  begin
   Clr := P^ - FFirstColor;
   Dst1^ := Dst1^ or ((Clr and 1) shl XX);
   Dst2^ := Dst2^ or (((Clr shr 1) and 1) shl XX);
   Inc(P);
  end;
  Inc(Dst1);
  Inc(Dst2);
  Inc(Src, RowStride);
 end;
end;

procedure TTile2BPP_NES.Flip(X, Y: Boolean; var Dest);
var
 Tile: TTile2bit_NES absolute Dest;
 XX, YY, I: Integer;
 Src, Dst: Byte;
begin
 if X then
 begin
  for YY := 0 to 7 do
  begin
   for I := 0 to 1 do
   begin
    Src := FData[I, YY];
    Dst := 0;
    for XX := 0 to 7 do
    begin
     Dst := Dst or ((Src and 1) shl XX);
     Src := Src shr 1;
    end;
    if Y then
     Tile[I, 7 - YY] := Dst else
     Tile[I, YY] := Dst;
   end;
  end;
 end else if Y then
 begin
  for YY := 0 to 7 do
  begin
   PWord(Addr(Tile[0, YY]))^ :=
   PWord(Addr(FData[0, 7 - YY]))^;
  end;
 end;
end;

function TTile2BPP_NES.GetTileData: Pointer;
begin
 Result := @FData;
end;

function TTile2BPP_NES.GetTileSize: Integer;
begin
 Result := SizeOf(TTile2bit_NES);
end;

(* TTile4BPP *)

procedure TTile4BPP.BufDraw(const Dest; RowStride: Integer;
      XFlip, YFlip: Boolean);
var
 XX, YY: Integer;
 Src: Cardinal;
 Dst, P: PByte;
begin
 Dst := @Dest;
 if XFlip then Inc(Dst, 7);
 for YY := 0 to 7 do
 begin
  P := Dst;
  if YFlip then
   Src := PCardinal(Addr(FData[7 - YY, 0]))^ else
   Src := PCardinal(Addr(FData[YY, 0]))^;
  if XFlip then for XX := 0 to 7 do
  begin
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Dec(P);
  end else for XX := 0 to 7 do
  begin
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Inc(P);
  end;
  Inc(Dst, RowStride);
 end;
end;

procedure TTile4BPP.BufLoad(const Source; RowStride: Integer);
var
 XX, YY: Integer;
 Dst: PCardinal;
 Src, P: PByte;
begin
 Src := @Source;
 Dst := Addr(FData[0, 0]);
 for YY := 0 to 7 do
 begin
  P := Src;
  Dst^ := 0;
  for XX := 0 to 7 do
  begin
   Dst^ := Dst^ or ((Byte(P^ - FFirstColor) and 15) shl (XX shl 2));
   Inc(P);
  end;
  Inc(Dst);
  Inc(Src, RowStride);
 end;
end;

procedure TTile4BPP.Flip(X, Y: Boolean; var Dest);
var
 Tile: TTile4bit absolute Dest;
 XX, YY: Integer;
 Src, Dst: Cardinal;
begin
 if X then
 begin
  for YY := 0 to 7 do
  begin
   Src := PCardinal(Addr(FData[YY, 0]))^;
   Dst := 0;
   XX := 7 shl 2;
   while XX >= 0 do
   begin
    Dst := Dst or ((Src and 15) shl XX);
    Src := Src shr 4;
    Dec(XX, 4);
   end;
   if Y then
    PCardinal(Addr(Tile[7 - YY, 0]))^ := Dst else
    PCardinal(Addr(Tile[YY, 0]))^ := Dst;
  end;
 end else if Y then
 begin
  for YY := 0 to 7 do
  begin
   PCardinal(Addr(Tile[YY, 0]))^ :=
   PCardinal(Addr(FData[7 - YY, 0]))^;
  end;
 end;
end;

function TTile4BPP.GetTileData: Pointer;
begin
 Result := @FData;
end;

function TTile4BPP.GetTileSize: Integer;
begin
 Result := SizeOf(TTile4bit);
end;

(* TTile4BPP_MSX *)

procedure TTile4BPP_MSX.BufDraw(const Dest; RowStride: Integer;
      XFlip, YFlip: Boolean);
var
 XX, YY: Integer;
 Src: Cardinal;
 Dst, P: PByte;
begin
 Dst := @Dest;
 if XFlip then
  Inc(Dst, 6) else
  Inc(Dst);
 for YY := 0 to 7 do
 begin
  P := Dst;
  if YFlip then
   Src := PCardinal(Addr(FData[7 - YY, 0]))^ else
   Src := PCardinal(Addr(FData[YY, 0]))^;
  if XFlip then for XX := 0 to 3 do
  begin
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Inc(P);
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Dec(P, 3);
  end else for XX := 0 to 3 do
  begin
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Dec(P);
   P^ := FFirstColor + (Src and 15);
   Src := Src shr 4;
   Inc(P, 3);
  end;
  Inc(Dst, RowStride);
 end;
end;

procedure TTile4BPP_MSX.BufLoad(const Source; RowStride: Integer);
var
 XX, YY: Integer;
 Dst: PCardinal;
 Src, P: PByte;
begin
 Src := @Source;
 Dst := Addr(FData[0, 0]);
 for YY := 0 to 7 do
 begin
  P := Src;
  Dst^ := 0;
  for XX := 0 to 7 do
  begin
   Dst^ := Dst^ or ((Byte(P^ - FFirstColor) and 15) shl MSX_Shifts[XX]);
   Inc(P);
  end;
  Inc(Dst);
  Inc(Src, RowStride);
 end;
end;



{*************************** Added by Marat ******************************}
{ TTile4BPP_SNES }

procedure TTile4BPP_SNES.BufDraw(const Dest; RowStride: Integer; XFlip,
  YFlip: Boolean);
var
 XX, YY: Integer;
 Dst, P: PByte;
 Temp: TTile4Bit;
 B1, B2, B3, B4: PByte;
begin
 Dst := @Dest;
 Temp:= FData;
 if XFlip or YFlip then
  Flip(XFlip, YFlip, Temp);
 B1:= @Temp[0, 0];
 B2:= @Temp[0, 1];
 B3:= @Temp[4, 0];
 B4:= @Temp[4, 1];
 for YY:= 0 to 7 do
 begin
  P:= Dst;
  for XX:= 0 to 7 do
  begin
    P^:= FFirstColor + ((B1^ and $80) shr 7) or ((B2^ and $80) shr 6) or ((B3^ and $80) shr 5) or ((B4^ and $80) shr 4);
    inc(P);
    B1^:= B1^ shl 1;
    B2^:= B2^ shl 1;
    B3^:= B3^ shl 1;
    B4^:= B4^ shl 1;
  end;
  inc(B1, 2);
  inc(B2, 2);
  inc(B3, 2);
  inc(B4, 2);
  inc(Dst, RowStride);
 end;
end;

procedure TTile4BPP_SNES.BufLoad(const Source; RowStride: Integer);
var
 XX, YY: Integer;
 Src, P: PByte;
 B1, B2, B3, B4: PByte;
 Pix: Byte;
begin
 Src := @Source;
 B1 := Addr(FData[0, 0]);
 B2 := Addr(FData[0, 1]);
 B3 := Addr(FData[4, 0]);
 B4 := Addr(Fdata[4, 1]);
 FillChar(FData[0,0], SizeOf(TTile4Bit),0);
 for YY := 0 to 7 do
 begin
  P := Src;
  for XX := 0 to 7 do
  begin
   Pix := Byte(P^ - FFirstColor);
   B1^ := B1^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B2^ := B2^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B3^ := B3^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B4^ := B4^ or ((Pix and 1) shl (7 - XX));
   Inc(P);
  end;
  Inc(B1, 2);
  inc(B2, 2);
  inc(B3, 2);
  inc(B4, 2);

  Inc(Src, RowStride);
 end;

end;

procedure TTile4BPP_SNES.Flip(X, Y: Boolean; var Dest);
var
 Tile: TTile4bit absolute Dest;
 TileX: TTile4bit;
 XX, YY: Integer;
 SP12, SP34: PWord;
 DP12, DP34: PWord;
 I: Integer;
begin
   if X then
   begin
    for YY:= 0 to 7 do
      for XX:= 0 to 3 do
      TileX[YY,XX]:= SNESFlipTable[FData[YY,XX]];
      
    SP12:= Addr(TileX[3,2]);
    SP34:= Addr(TileX[7,2]);
    end else
   begin
    SP12:= Addr(FData[3,2]);
    SP34:= Addr(FData[7,2]);
   end;
   DP12:= Addr(Tile[0,0]);
   DP34:= Addr(Tile[4,0]);
  if Y then
  begin
    for I:= 0 to 7 do
    begin
      DP12^ := SP12^;
      DP34^ := SP34^;
      inc(DP12);
      inc(DP34);
      dec(SP12);
      dec(SP34);
    end;
  end else
    CopyMem(@TileX, @Tile, SizeOf(TTile4bit));
end;


{***********************************************************************}

(* TTile8BPP *)

procedure TTile8BPP.BufDraw(const Dest; RowStride: Integer;
      XFlip, YFlip: Boolean);
var
 XX, YY: Integer;
 Dst, P, Src: PByte;
 Src64: PInt64 absolute Src;
 Dst64: PInt64 absolute Dst;
begin
 Dst := @Dest;
 if XFlip then Inc(Dst, 7);
 for YY := 0 to 7 do
 begin
  if YFlip then
   Src := Addr(FData[7 - YY, 0]) else
   Src := Addr(FData[YY, 0]);
  if XFlip then
  begin
   P := Dst;
   for XX := 0 to 7 do
   begin
    P^ := Src^;
    Inc(Src);
    Dec(P);
   end;
  end else Dst64^ := Src64^;
  Inc(Dst, RowStride);
 end;
end;

procedure TTile8BPP.BufLoad(const Source; RowStride: Integer);
var
 YY: Integer;
 Dst: PInt64;
 Src: PByte;
 Src64: PInt64 absolute Src;
begin
 Src := @Source;
 Dst := Addr(FData[0, 0]);
 for YY := 0 to 7 do
 begin
  Dst^ := Src64^;
  Inc(Dst);
  Inc(Src, RowStride);
 end;
end;

procedure TTile8BPP.Flip(X, Y: Boolean; var Dest);
var
 Tile: TTile8bit absolute Dest;
 YY: Integer;
 Src: Int64;
begin
 if X then
 begin
  for YY := 0 to 7 do
  begin
   Src := SwapInt64(PInt64(Addr(FData[YY, 0]))^);
   if Y then
    PInt64(Addr(Tile[7 - YY, 0]))^ := Src else
    PInt64(Addr(Tile[YY, 0]))^ := Src;
  end;
 end else if Y then
 begin
  for YY := 0 to 7 do
  begin
   PInt64(Addr(Tile[YY, 0]))^ :=
   PInt64(Addr(FData[7 - YY, 0]))^;
  end;
 end;
end;

function TTile8BPP.GetTileData: Pointer;
begin
 Result := @FData;
end;

function TTile8BPP.GetTileSize: Integer;
begin
 Result := SizeOf(TTile8bit);
end;


{*********************************Added by Marat*****************************}
{ TTile8BPP_SNES }

procedure TTile8BPP_SNES.BufDraw(const Dest; RowStride: Integer; XFlip,
  YFlip: Boolean);
var
 XX, YY: Integer;
 Dst, P, Src: PByte;
 Src64: PInt64 absolute Src;
 Dst64: PInt64 absolute Dst;
 Temp: TTile8bit;
 B0, B1, B2, B3, B4, B5, B6, B7: PByte;
begin
 Temp:= FData;
 if XFlip or YFlip then
  Flip(XFlip, YFlip, Temp);
 B0:= @Temp[0, 0];
 B1:= @Temp[0, 1];
 B2:= @Temp[2, 0];
 B3:= @Temp[2, 1];
 B4:= @Temp[4, 0];
 B5:= @Temp[4, 1];
 B6:= @Temp[6, 0];
 B7:= @Temp[6, 1];
 Dst:= @Dest;
 for YY:= 0 to 7 do
 begin
  P:= Dst;
  for XX:= 0 to 7 do
  begin
    P^:= ((B0^ and $80) shr 7) or ((B1^ and $80) shr 6) or ((B2^ and $80) shr 5) or ((B3^ and $80) shr 4) or
           ((B4^ and $80) shr 3) or ((B5^ and $80) shr 2) or ((B6^ and $80) shr 1) or (B7^ and $80);
    B0^:= B0^ shl 1; B1^:= B1^ shl 1; B2^:= B2^ shl 1; B3^:= B3^ shl 1;
    B4^:= B4^ shl 1; B5^:= B5^ shl 1; B6^:= B6^ shl 1; B7^:= B7^ shl 1;
    inc(P);
  end;
  inc(B0, 2); inc(B1, 2); inc(B2, 2); inc(B3, 2);
  inc(B4, 2); inc(B5, 2); inc(B6, 2); inc(B7, 2);
  inc(Dst, RowStride);
 end;

end;

procedure TTile8BPP_SNES.BufLoad(const Source; RowStride: Integer);
var
 XX, YY: Integer;
 Src, P: PByte;
 Src64: PInt64 absolute Src;
 B0, B1, B2, B3, B4, B5, B6, B7: PByte;
 Pix: Byte;
begin
 Src := @Source;
 B0 := Addr(FData[0, 0]);
 B1 := Addr(FData[0, 1]);
 B2 := Addr(FData[2, 0]);
 B3 := Addr(Fdata[2, 1]);
 B4 := Addr(FData[4, 0]);
 B5 := Addr(FData[4, 1]);
 B6 := Addr(Fdata[6, 0]);
 B7 := Addr(FData[6, 1]);
 FillChar(FData[0,0], SizeOf(TTile8Bit),0);
 for YY := 0 to 7 do
 begin
  P := Src;
  for XX := 0 to 7 do
  begin
   Pix:= P^;
   B0^ := B0^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B1^ := B1^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B2^ := B2^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;;
   B3^ := B3^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B4^ := B4^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B5^ := B5^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B6^ := B6^ or ((Pix and 1) shl (7 - XX));
   Pix := Pix shr 1;
   B7^ := B7^ or ((Pix and 1) shl (7 - XX));
   Inc(P);
  end;
  Inc(B0, 2);  inc(B1, 2);
  inc(B2, 2);  inc(B3, 2);
  Inc(B4, 2);  inc(B5, 2);
  inc(B6, 2);  inc(B7, 2);
  Inc(Src, RowStride);
 end;

end;



procedure TTile8BPP_SNES.Flip(X, Y: Boolean; var Dest);
var
  Tile: TTile8bit absolute Dest;
  TileX: TTile8bit;
  XX, YY: Integer;
  SP12, SP34, SP56, SP78: PWord;
  DP12, DP34, DP56, DP78: PWord;
  I: Integer;
begin
   if X then
   begin
    for YY:= 0 to 7 do
      for XX:= 0 to 7 do
      TileX[YY,XX]:= SNESFlipTable[FData[YY,XX]];
      
    SP12:= Addr(TileX[1,6]);
    SP34:= Addr(TileX[3,6]);
    SP56:= Addr(TileX[5,6]);
    SP78:= Addr(TileX[7,6]);
    end else
   begin
    SP12:= Addr(FData[1,6]);
    SP34:= Addr(FData[3,6]);
    SP56:= Addr(FData[5,6]);
    SP78:= Addr(FData[7,6]);
   end;
   DP12:= Addr(Tile[0,0]);
   DP34:= Addr(Tile[2,0]);
   DP56:= Addr(Tile[4,0]);
   DP78:= Addr(Tile[6,0]);
  if Y then
  begin
    for I:= 0 to 7 do
    begin
      DP12^ := SP12^;
      DP34^ := SP34^;
      DP56^ := SP56^;
      DP78^ := SP78^;
      inc(DP12);
      inc(DP34);
      inc(DP56);
      inc(DP78);
      dec(SP12);
      dec(SP34);
      dec(SP56);
      dec(SP78);
    end;
  end else
    CopyMem(@TileX, @Tile, SizeOf(TTile8bit));

end;


{********************************************************************}


(* TTileList *)

procedure TTileList.AddEmptyBlock(StartIndex, EndIndex: Integer);
var
 L: Integer;
begin
 L := Length(FEmptyBlocks);
 SetLength(FEmptyBlocks, L + 1);
 with FEmptyBlocks[L] do
 begin
  ebStart := StartIndex;
  ebEnd := EndIndex;
 end;
 ResetEmptyBlock;
end;

function TTileList.AddFixed(Index: Integer): TCustomTile;
begin
 Result := Tiles[Index];
 if Result = NIL then
 begin
  Result := AddNode as TCustomTile;
  Result.FTileIndex := Index;
  if FMaxIndex < Index then FMaxIndex := Index;
 end;
end;

function TTileList.AddOrGet(const Source; var XFlip,YFlip: Boolean): TCustomTile;
var
 Buf: Pointer;
 SZ: Integer;
 Link: TNode;
begin
 Buf := NIL;
 Link := RootNode;
 while Link <> NIL do
 begin
  Result := Link as TCustomTile;
  with Result do
  begin
   SZ := TileSize;
   if CompareMem(@Source, TileData, SZ) then
   begin
    XFlip := False;
    YFlip := False;
    Exit;
   end;
   if FOptimization then
   begin
    ReallocMem(Buf, SZ);
    Flip(False, True, Buf^);
    if CompareMem(@Source, Buf, SZ) then
    begin
     XFlip := False;
     YFlip := True;
     Exit;
    end;
    Flip(True, False, Buf^);
    if CompareMem(@Source, Buf, SZ) then
    begin
     XFlip := True;
     YFlip := False;
     Exit;
    end;
    Flip(True, True, Buf^);
    if CompareMem(@Source, Buf, SZ) then
    begin
     XFlip := True;
     YFlip := True;
     Exit;
    end;
   end;
  end;
  Link := Link.Next;
 end;
 Result := AddNode as TCustomTile;
 Move(Source, Result.TileData^, FEmptyTile.TileSize);
 XFlip := False;
 YFlip := False;
 if FCurrentBlock = NIL then with Result do
 begin
  FTileIndex := Count - 1;
  if FMaxIndex < FTileIndex then FMaxIndex := FTileIndex;
 end else
 with FCurrentBlock^ do
 begin
  if FLastIndex < ebStart then FLastIndex := ebStart else
  if FLastIndex > ebEnd then
  begin
   Inc(FCurrentBlock);
   if Cardinal(FCurrentBlock) <=
      Cardinal(Addr(FEmptyBlocks[Length(FEmptyBlocks) - 1])) then
    FLastIndex := FCurrentBlock.ebStart else
   begin
    FLastIndex := Count - 1;
    FCurrentBlock := NIL;
   end;
  end;
  Result.FTileIndex := FLastIndex;
  if FMaxIndex < FLastIndex then FMaxIndex := FLastIndex;
  Inc(FLastIndex);
 end;
end;

procedure TTileList.AppendFromStream(const Stream: TStream; Count: Integer);
var
 I: Integer;
begin
 for I := 0 to Count - 1 do with AddNode as TCustomTile do
 begin
  Inc(FMaxIndex);
  FTileIndex := FMaxIndex;
  LoadFromStream(Stream);
 end;
end;

procedure TTileList.Assign(Source: TNode);
var
 Src: TTileList absolute Source;
 I: Integer;
 Block: PEmptyBlock;
begin
 if (Source <> NIL) and (Source is TTileList) then
 begin
  SetLength(FEmptyBlocks, Length(Src.FEmptyBlocks));
  Move(Src.FEmptyBlocks[0], FEmptyBlocks[0],
       Length(FEmptyBlocks) * SizeOf(TEmptyBlock));
  inherited;
  FOptimization := Src.FOptimization;
  FLastIndex := Src.FLastIndex;
  FMaxIndex := Src.FMaxIndex;
  Block := Pointer(FEmptyBlocks);
  with Src do if FCurrentBlock <> NIL then
  begin
   for I := 0 to Length(FEmptyBlocks) - 1 do
   begin
    if CompareMem(FCurrentBlock, Block, SizeOf(TEmptyBlock)) then
    with Self do
    begin
     FCurrentBlock := Block;
     Break;
    end;
    Inc(Block);
   end;
  end else Self.FCurrentBlock := NIL;
  MakeArray;
 end else AssignError(Source);
end;

procedure TTileList.AssignAdd(Source: TNode);
begin
 if FindEmptyIndex((Source as TCustomTile).FTileIndex) < 0 then
  AddNode.Assign(Source);
end;

procedure TTileList.AssignNodeClass(Source: TNodeList);
begin
 if FTileClassAssign then
  inherited;
end;

procedure TTileList.ClearData;
begin
 FLastIndex := -1;
 FMaxIndex := -1;
 FCurrentBlock := Pointer(FEmptyBlocks);
 Finalize(FFastTiles);
end;

constructor TTileList.Create;
begin
 inherited Create;
 NodeClass := TCustomTile;
 FTileClassAssign := True;
end;

constructor TTileList.Create(TileClass: TTileClass; Optimization: Boolean);
begin
 inherited Create;
 NodeClass := TileClass;
 FOptimization := Optimization;
 FTileClassAssign := True;
end;

procedure TTileList.DeleteEmptyBlock(Index: Integer);
var L: Integer;
begin
 if Index >= 0 then
 begin
  L := Length(FEmptyBlocks);
  if Index = L - 1 then SetLength(FEmptyBlocks, L - 1) else
  if Index < L - 1 then
  begin
   Move(FEmptyBlocks[Index + 1], FEmptyBlocks[Index],
      ((L - Index) - 1) * SizeOf(TEmptyBlock));
   SetLength(FEmptyBlocks, L - 1);
  end else Exit;
  ResetEmptyBlock;
 end;
end;

destructor TTileList.Destroy;
begin
 FEmptyTile.Free;
 inherited;
end;

function TTileList.FindEmptyIndex(Value: Integer): Integer;
var I: Integer;
begin
 for I := 0 to Length(FEmptyBlocks) - 1 do with FEmptyBlocks[I] do
 if (Value >= ebStart) and (Value <= ebEnd) then
 begin
  Result := I;
  Exit;
 end;
 Result := -1;
end;

function TTileList.GetTileItem(Index: Integer): TCustomTile;
var Link: ^TCustomTile; I: Integer;
begin
 Link := RootLink;
 for I := 0 to Count - 1 do
 begin
  Result := Link^;
  if Index = Result.FTileIndex then Exit;
  Inc(Link);
 end;
 Result := NIL;
end;

function TTileList.GetTilesCount: Integer;
begin
 Result := Length(FFastTiles);
end;

procedure TTileList.Initialize;
begin
 NodeClass := TCustomTile;
 FAssignableClass := TTileList;
 FMaxIndex := -1;
end;

procedure TTileList.LoadFromStream(const Stream: TStream);
begin
 Clear;
 AppendFromStream(Stream, Stream.Size div FTileSize);
 MakeArray;
end;

procedure TTileList.MakeArray;
var
 Tile: TCustomTile; I: Integer;
begin
 SetLength(FFastTiles, FMaxIndex + 1);
 for I := 0 to FMaxIndex do
 begin
  Tile := Tiles[I];
  if Tile = NIL then
   FFastTiles[I] := FEmptyTile else
   FFastTiles[I] := Tile;
 end;
end;

procedure TTileList.ResetEmptyBlock;
begin
 FLastIndex := -1;
 FCurrentBlock := Pointer(FEmptyBlocks);
end;

procedure TTileList.SaveToStream(const Stream: TStream);
var
 Tile: TCustomTile; I: Integer;
begin
 for I := 0 to FMaxIndex do
 begin
  Tile := Tiles[I];
  if Tile = NIL then
  begin
   Tile := FEmptyTile;
   Tile.FTileIndex := I;
  end;
  Tile.SaveToStream(Stream);
 end;
end;

procedure TTileList.SetEmptyBlocksLen(Len: Integer);
begin
 SetLength(FEmptyBlocks, Len);
 ResetEmptyBlock;
end;

procedure TTileList.SetNodeClass(Value: TNodeClass);
begin
 FEmptyTile.Free;
 FEmptyTile := TCustomTile(Value.Create);
 FTileSize := FEmptyTile.TileSize;
 FTileWidth := FEmptyTile.Width;
 FTileHeight := FEmptyTile.Height;
 inherited;
end;

end.
