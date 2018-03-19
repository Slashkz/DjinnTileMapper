unit MetaTiles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Samples.Spin,
  Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.ToolWin, Math, DTMmain;

type
  Tf_metatiles = class(TForm)
    scrlbx1: TScrollBox;
    MapImage: TImage;
    tlb1: TToolBar;
    stat1: TStatusBar;
    Grid: TImage;
    TileSelection: TShape;
    Block: TImage;
    tbGoTo: TToolButton;
    tbShowGrid: TToolButton;
    tbShowHex: TToolButton;
    seWidth: TSpinEdit;
    seHeight: TSpinEdit;
    cbDirection: TComboBox;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    seMapWidth: TSpinEdit;
    seMapHeight: TSpinEdit;
    cbMapFormat: TComboBox;
    Timer1: TTimer;
    BlockSelection: TShape;
    procedure DrawMetaTiles();
    procedure FormCreate(Sender: TObject);
    procedure ChangeMap(WW, HH: Byte);
    procedure FormShow(Sender: TObject);
    procedure MapChange(Sender: TObject);
    procedure tbGoToClick(Sender: TObject);
    procedure scrlbx1Click(Sender: TObject);
    procedure cbDirectionChange(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure cbMapFormatChange(Sender: TObject);
    procedure tbShowGridClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tbShowHexClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  f_metatiles: Tf_metatiles;
  //Data: array of Byte;
  Map: array of TBlock;
  MapFormat: TMapFormat = mfMSX;
  MapWidth, MapHeight, MTWidth, MTHeight, DataPosition: Integer;



implementation

uses BitmapUtils, inputbox;

var
  iMouseX, iMouseY: Integer;
  iMTPos: Integer = 0;
  bShowHex: Boolean = False;
{$R *.dfm}

procedure Tf_metatiles.cbDirectionChange(Sender: TObject);
var
  I, X, XX, Y, YY: Integer;
begin
  I:= 0;
  if ROMOpened then
  begin
    if cbDirection.ItemIndex = 0 then
    begin
      for Y:= 0 to MapHeight - 1 do
      begin
        for X:= 0 to MapWidth - 1 do
        begin
          for YY:= 0 to MTHeight - 1 do
          begin
            for XX:= 0 to MTWidth - 1 do
            begin
              Map[I].X:= X * MTWidth  + XX;
              Map[I].Y:= Y * MTHeight + YY;
              Inc(I);
            end;
          end;
        end;
      end;
    end
    else
    begin
      for Y:= 0 to MapHeight -1 do
      begin
        for X:= 0 to MapWidth -1 do
        begin
          for XX:= 0 to MTWidth-1 do
          begin
            for YY:= 0 to MTHeight-1 do
            begin
              Map[I].X:= X * MTWidth  + XX;
              Map[I].Y:= Y * MTHeight + YY;
              Inc(I);
            end;
          end;
        end;
      end;
    end;
    DrawMetaTiles();
  end;
end;

procedure Tf_metatiles.cbMapFormatChange(Sender: TObject);
begin
  MapFormat:= TMapFormat(cbMapFormat.ItemIndex);
  if ROMopened then
  begin
    ChangeMap(MTWidth, MTHeight);
    DrawMetaTiles();
  end;
end;

procedure Tf_metatiles.ChangeMap(WW, HH: Byte);
var
  X, Y, I, XX, YY, W, H: Integer;
begin
  if ROMopened then
  begin
    W:= MapWidth;
    H:= MapHeight;
    for I := Low(Map) to High(Map) do
    begin
      Map[I].Free;
    end;
    SetLength(Map, MapWidth * MapHeight * MTWidth * MTHeight);
    BitReader.Seek(DataPosition * 8, soBeginning);
    I:= 0;
    if cbDirection.ItemIndex = 0 then
    begin
      for Y:= 0 to H - 1 do
      begin
        for X:= 0 to W - 1 do
        begin
          for YY:= 0 to HH - 1 do
          begin
            for XX:= 0 to WW - 1 do
            begin
              Map[I]:= TBlock.Create;
              Map[I].Address:= BitReader.Position div 8;
              case MapFormat of
                mfSingleByte, mfGBC:
                  Map[I].Value:= BitReader.Read(8);
                mfGBA, mfSNES, mfPCE:
                  Map[I].Value:= Swap(BitReader.Read(16));
                mfMSX, mfSMS:
                  Map[I].Value:= BitReader.Read(16);
              end;
              Map[I].X:= X * MTWidth  + XX;
              Map[I].Y:= Y * MTHeight + YY;
              Inc(I);
            end;
          end;
        end;
      end;
    end
    else
    begin
      for Y:= 0 to H-1 do
      begin
        for X:= 0 to W-1 do
        begin
          for XX:= 0 to WW-1 do
          begin
            for YY:= 0 to HH-1 do
            begin
              Map[I]:= TBlock.Create;
              Map[I].Address:= BitReader.Position div 8;
              case MapFormat of
                mfSingleByte, mfGBC:
                  Map[I].Value:= BitReader.Read(8);
                mfGBA, mfSNES, mfPCE:
                  Map[I].Value:= Swap(BitReader.Read(16));
                mfMSX, mfSMS:
                  Map[I].Value:= BitReader.Read(16);
              end;
              Map[I].X:= X * MTWidth  + XX;
              Map[I].Y:= Y * MTHeight + YY;
              Inc(I);
            end;
          end;
        end;
      end;
    end;
  end;
end;


procedure Tf_metatiles.DrawMetaTiles;
var
  XX, YY, XXX, YYY: Integer; BBB, TileBMP: TBitmap;
  Dest, Src: TRect;
  W, H: Byte;
  X, Y: Integer;
  I: Integer;
begin
   Tilebmp:= TBitmap.Create;
   BBB := TBitmap.Create;
   BBB.width := MapImage.Width;
   BBB.Height := MapImage.Height;
   bbb.Canvas.Font.Color := $D0D0D0;
   bbb.Canvas.Font.style := [fsbold];
   bbb.Canvas.Brush.Color := 0;
   bbb.Canvas.FillRect(bounds(0, 0, bbb.width, bbb.height));
   TileBMP.Width:= TileW;
   TileBMP.Height:= TileH;
   I:= 0;
    For YY := 0 to MapHeight - 1 do
    begin
      For XX := 0 to MapWidth - 1 do
      begin
        for YYY := 0 to MTHeight - 1 do
        begin
          for XXX := 0 to MTWidth - 1 do
          begin
             dest:=bounds(Map[I].X * TileWx2, Map[I].Y * TileHx2, TileWx2, TileHx2);
             src:= Rect(0, 0, TileW, TileH);
             X:= MapXY[Map[I].Index].X * tilew;
             Y:= MapXY[Map[I].Index].Y * tileh;
             Tilebmp.Canvas.CopyRect(Bounds(0, 0, TileW, TileH), bmap.Canvas, Bounds(X, Y, TileW, TileH));
             Flip(Tilebmp, Map[I].H, Map[I].V);
             Inc(I);
             bbb.Canvas.CopyRect(dest, tilebmp.Canvas, src);
          end;
        end;
      end;//end For..
    end;//For..
   Tilebmp.Free; //”ничтожение
   MapImage.Canvas.Draw(0, 0, bbb);
   bbb.free;  //”ничтожение
  if bShowHex then
  begin
    for I := Low(Map) to (Length(Map) div MTWidth div MTHeight) - 1 do
    begin
      DTM.hexnums3.Draw(MapImage.Picture.Bitmap.Canvas, Map[I * MTWidth * MTHeight].x * TileWx2, Map[I * MTWidth * MTHeight].y * TileHx2, I and $7FF, True);
    end;

  end;
end;

procedure Tf_metatiles.FormClose(Sender: TObject; var Action: TCloseAction);
var
  I: Integer;
begin

end;

procedure Tf_metatiles.FormCreate(Sender: TObject);
begin
  MTWidth:= 1;
  MTHeight:= 1;
  MapWidth:= 16;
  MapHeight:= 16;
  PatternSize:= 2;
  DataPosition:= 0;
  MapImage.Width:= MapWidth * MTWidth * TileWx2;
  MapImage.Height:= MapHeight * MTHeight * TileHx2;
  MapImage.Picture.Bitmap.Width:= MapImage.Width;
  MapImage.Picture.Bitmap.Height:= MapImage.Height;
  DTM.Fill(MapImage, clBlack);
  Grid.Picture.Bitmap.Transparent := TRUE;
  Grid.Picture.Bitmap.TransparentMode := tmFixed;
  Grid.Picture.Bitmap.TransparentColor := clWhite;
  Grid.Width:= MapImage.Width;
  Grid.Height:= MapImage.Height;
  Grid.Picture.Bitmap.Width:= MapImage.Width;
  Grid.Picture.Bitmap.Height:= MapImage.Height;
  //Grid.Picture.Bitmap.Canvas.FloodFill(0, 0, clBlack, fsSurface);
  GridDraw(Grid.Picture.Bitmap, MTWidth * tilewX2, MTHeight * tilehx2, clHotLight);
  GridDraw(Grid.Picture.Bitmap, 8 * MTWidth * tilew, 8 * MTHeight * tileh, clSkyBlue);
end;

procedure Tf_metatiles.FormShow(Sender: TObject);
begin
  if ROMopened then
    DrawMetaTiles();
end;

procedure Tf_metatiles.MapChange(Sender: TObject);
begin
  MapWidth:= seMapWidth.Value;
  MapHeight:= seMapHeight.Value;
  MTWidth:= seWidth.Value;
  MTHeight:= seHeight.Value;
  TileSelection.Width:= TileWx2 * MTWidth;
  TileSelection.Height:= TileHx2 * MTHeight;
  ChangeMap(MTWidth, MTHeight);
  MapImage.Width:= MapWidth * MTWidth * TileWx2;
  MapImage.Height:= MapHeight * MTHeight * TileHx2;
  MapImage.Picture.Bitmap.Width:= MapImage.Width;
  MapImage.Picture.Bitmap.Height:= MapImage.Height;
  Grid.Width:= MapImage.Width;
  Grid.Height:= MapImage.Height;
  Grid.Picture.Bitmap.Width:= MapImage.Width;
  Grid.Picture.Bitmap.Height:= MapImage.Height;
  if Grid.Visible then
  begin
    with Grid.Picture.Bitmap do
    begin
      Canvas.Brush.Color:= clWhite;
      Canvas.FillRect(Canvas.ClipRect);
      //DrawGrid(Grid.Picture.Bitmap, MTWidth * tilewX2, MTHeight * tilehx2,MTWidth * tilewX2 * 8, MTHeight * tilehx2 * 8);
      GridDraw(Grid.Picture.Bitmap, MTWidth * tilewX2, MTHeight * tilehx2, clHotLight);
      GridDraw(Grid.Picture.Bitmap, 8 * MTWidth * tilewx2, 8 * MTHeight * tilehx2, clSkyBlue);
    end;
  end;
  if ROMopened then
    DrawMetaTiles();
end;

procedure Tf_metatiles.MapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 iMouseX := Min(X, MapImage.Width - 1);
 iMouseY := Min(Y, MapImage.Height - 1);
end;

procedure Tf_metatiles.scrlbx1Click(Sender: TObject);
begin
  if ROMopened then
  begin
    if (iMouseX + MTWidth * TileWx2) > MapImage.Width then
      iMouseX:= MapImage.Width - MTWidth * TileWx2;
    if (iMouseY + MTHeight * TileHx2) > MapImage.Height then
      iMouseY:= MapImage.Height - MTHeight * TileHx2;

    iMTPos := (MapWidth * (iMouseY div TileHx2 div MTHeight) + (iMousex div TileWx2 div MTWidth)) * MTWidth * MTHeight;

    TileSelection.Left:= (MapImage.Left div TileWx2 div MTWidth) * TileWx2 * MTWidth + (MapImage.Left mod (TileWx2 * MTWidth)) + Map[iMTPos].X * TileWx2;
    TileSelection.Top:= (MapImage.Top div TileHx2 div MTHeight) * TileHx2 * MTHeight + (MapImage.Top mod (TileHx2 * MTHeight)) + Map[iMTPos].Y * TileHx2;
  end;
end;

procedure Tf_metatiles.tbGoToClick(Sender: TObject);
var
  s: String; v: LongInt;
begin
 s := UpperCase(InputForm.Inputbx(Application.Title, 'ѕерейти на позицию в файле:', hchs, 10));
 if s = '' then
  Exit;
  if S[1] = 'H' then
    S[1]:= '$';
  begin
    Try
      v := StrToint(s)
    Except
      on eConvertError do
      begin
       ShowMessage(errs);
       exit;
      end
    end;
    DataPosition := v;
    ChangeMap(MTWidth, MTHeight);
    DrawMetaTiles();
  end;
end;

procedure Tf_metatiles.tbShowGridClick(Sender: TObject);
begin
  Grid.Visible:= not Grid.Visible;
  with Grid.Picture.Bitmap do
  begin
    Canvas.Brush.Color:= clWhite;
    Canvas.FillRect(Canvas.ClipRect);
    //DrawGrid(Grid.Picture.Bitmap, MTWidth * tilewX2, MTHeight * tilehx2,MTWidth * tilewX2 * 8, MTHeight * tilehx2 * 8);
    GridDraw(Grid.Picture.Bitmap, MTWidth * tilewx2, MTHeight * tilehx2, clHotLight);
    GridDraw(Grid.Picture.Bitmap, 8 * MTWidth * tilewx2, 8 * MTHeight * tilehx2, clSkyBlue);
  end;
end;

procedure Tf_metatiles.tbShowHexClick(Sender: TObject);
begin
  bShowHex:= tbShowHex.Down;
  if ROMopened then
    DrawMetaTiles();
end;

procedure Tf_metatiles.Timer1Timer(Sender: TObject);
begin
  if bTileMapChanged and ROMopened then
  begin
    bTileMapChanged:= False;
    ChangeMap(MTWidth, MTHeight);
    DrawMetaTiles();
  end;
end;

end.
