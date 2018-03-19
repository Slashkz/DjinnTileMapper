unit teditf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, BitmapUtils,
  StdCtrls, Math, Vcl.ComCtrls, Vcl.ToolWin;

type

  TToolType = (ttPen, ttFiller, ttDropper, ttClearRectangle, ttSolidRectangle, ttClearCircle, ttSolidCircle, ttLine);

  Tteditform = class(TForm)
    geditpan: TPanel;
    Tile: TImage;
    ClearBtn: TSpeedButton;
    RotRightBtn: TSpeedButton;
    RotLeftBtn: TSpeedButton;
    Flip2Btn: TSpeedButton;
    FlipBtn: TSpeedButton;
    MvUpBtn: TSpeedButton;
    MvRightBtn: TSpeedButton;
    MvLeftBtn: TSpeedButton;
    MvDownBtn: TSpeedButton;
    c16im: TImage;
    zoomx: TComboBox;
    pnl1: TPanel;
    spl1: TSplitter;
    spl2: TSplitter;
    tlb1: TToolBar;
    tbOpenBitmap: TToolButton;
    tbSaveBitmap: TToolButton;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    tbFiller: TToolButton;
    tbPen: TToolButton;
    tbEditDropper: TToolButton;
    Selector: TShape;
    tbClearRectangle: TToolButton;
    tbShowGrid: TToolButton;
    procedure MvLeftBtnClick(Sender: TObject);
    procedure MvRightBtnClick(Sender: TObject);
    procedure MvUpBtnClick(Sender: TObject);
    procedure MvDownBtnClick(Sender: TObject);
    procedure FlipBtnClick(Sender: TObject);
    procedure Flip2BtnClick(Sender: TObject);
    procedure RotLeftBtnClick(Sender: TObject);
    procedure RotRightBtnClick(Sender: TObject);
    procedure ClearBtnClick(Sender: TObject);
    procedure c16imMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TileMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure zoomxChange(Sender: TObject);
    procedure tbOpenBitmapClick(Sender: TObject);
    procedure tbSaveBitmapClick(Sender: TObject);
    procedure tbPenClick(Sender: TObject);
    procedure tbEditDropperClick(Sender: TObject);
    procedure tbFillerClick(Sender: TObject);
    procedure tbClearRectangleClick(Sender: TObject);
    procedure tbShowGridClick(Sender: TObject);
  private
    { Private declarations }
  public

    { Public declarations }
  end;

var
  teditform: Tteditform;
  txx, tyy: integer;
  Used: array[0..255] of Boolean;
  Tool: TToolType = ttPen;
  X0, Y0, X1, Y1: Integer;
  CellSize: Byte;

implementation

{$R *.dfm}

uses dtmmain, tmform, dataf;

procedure UpdateTile;
var
  w, h: Word;
begin
  w:= btile.Width;
  h:= btile.Height;
  For Tyy := 0 to h - 1 do
    For Txx := 0 to w - 1 do
    begin
     ty := tyy; tx := txx;
     UpdatePixel();
    end;
  DTM.DrawTileMap();
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;

procedure Tteditform.MvLeftBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  Shift(bTile, stLeft);
  UpdateTile();
  DTM.DrawTileMap();
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  Saved := False;
 end;
end;


procedure Tteditform.MvRightBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  Shift(bTile, stRight);
  UpdateTile();
  DTM.DrawTileMap();
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  Saved := False;
 end;
end;


procedure Tteditform.MvUpBtnClick(Sender: TObject);
begin
  if ROMOpened then
  begin
   Shift(bTile, stUp);
   UpdateTile();
   DTM.DrawTileMap();
   DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
   Saved := False;
 end;
end;


procedure Tteditform.MvDownBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  Shift(bTile, stDown);
  UpdateTile();
  DTM.DrawTileMap();
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  Saved := False;
 end;
end;

procedure Tteditform.FlipBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  Flip(btile, True, False);
  UpdateTile();
  Saved := False;
 end;
end;

procedure Tteditform.Flip2BtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  Flip(btile, False, True);
  UpdateTile();
  Saved := False;
 end;
end;


procedure Tteditform.RotLeftBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  RotateBitmap(btile, 270, False);
  UpdateTile;
  Saved := False;
 end;
end;


procedure Tteditform.RotRightBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  RotateBitmap(btile, 90, False);
  UpdateTile;
  Saved := False
 end;
end;


procedure Tteditform.tbOpenBitmapClick(Sender: TObject);
var
  Bitmap: TBitmap;
begin
  if OpenDialog1.Execute then
  begin
    Bitmap:= TBitmap.Create;
    Bitmap.LoadFromFile(OpenDialog1.FileName);
    if (Bitmap.Width > btile.Width) or (Bitmap.Height > btile.Height) then
    begin
      MessageDlg('Импортируемое изображение превышает допустимые пределы!', mtError, [mbOk], 0);
      Exit;
    end;
    bTile.Canvas.Draw(0, 0, Bitmap);
    UpdateTile;
    Saved := False ;
    Bitmap.Free;
  end;
end;

procedure Tteditform.tbPenClick(Sender: TObject);
begin
  Tool:= ttPen;
end;

procedure Tteditform.tbClearRectangleClick(Sender: TObject);
begin
  Tool:= ttClearRectangle;
end;

procedure Tteditform.tbEditDropperClick(Sender: TObject);
begin
  Tool:= ttDropper;
end;

procedure Tteditform.tbFillerClick(Sender: TObject);
begin
  Tool:= ttFiller;
end;

procedure Tteditform.tbSaveBitmapClick(Sender: TObject);
begin
  if SaveDialog1.Execute() then
  begin
    btile.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure Tteditform.tbShowGridClick(Sender: TObject);
begin
  bTileEditGrid:= not bTileEditGrid;
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;

procedure Tteditform.ClearBtnClick(Sender: TObject);
begin
 If RomOpened then
 begin
  For Tyy := 0 to 7 do
    For Txx := 0 to 7 do
    begin
     ty := tyy; tx := txx;
     bTile.Canvas.Pixels[Tx, Ty] := DTM.Color[BCol];
     UpdatePixel();
    end;
  DTM.DrawTileMap();
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  Saved := False;
 end;
end;

procedure Tteditform.c16imMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ColorNum: Byte;
begin
  ColorNum:= Y div COLOR_HEIGHT mod CLR_CNT[DTM.TileType] ;
  DTM.SmallPalSet:= Y div COLOR_HEIGHT div CLR_CNT[DTM.TileType];
  If Button = mbLeft then
  begin
    if ssDouble in Shift then
    begin
      DTM.colordialog.Color := DTM.Color[ColorNum];
      If DTM.Colordialog.Execute then
      begin
        DTM.Color[ColorNum] := DTM.colordialog.Color;
        if ROMopened then
          DTM.DrawTileMap;
      end;
    end;
    DTM.Foreground := ColorNum;
  end
  Else
    DTM.Background := ColorNum;
end;


procedure Tteditform.TileMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX, YY, I: Integer;
  PatternPos: Integer;
  Color: TColor;
begin
   if bTMMouseDown then
   begin
    XX:= TX div TileW;
    YY:= TY div TileH;
    PatternPos:=RomDataPos + CDPos;
    if bSwapXY then
      PatternPos:= PatternPos + YY * DTM.dWidth * PatternSize + XX * PatternSize
    else
      PatternPos:= PatternPos + XX * DTM.dHeight * PatternSize + YY * PatternSize;
    BitWriter.Seek(PatternPos * 8, soBeginning);
    BitWriter.Write(TileCaptured, 8 * PatternSize);
    tilemapform.TileMap.Repaint;
    DTM.DataMapDraw;
    if bSwapXY then
    begin
      dmMouseX:= (CDPos div PatternSize mod DTM.dWidth) * TileWx2;
      dmMouseY:= (CDPos div PatternSize div DTM.dHeight) * TileHx2;
    end
    else
    begin
      dmMouseX:= (CDPos div PatternSize div DTM.dHeight) * TileHx2;
      dmMouseY:= (CDPos div PatternSize mod DTM.dHeight) * TileWx2;
    end;
    dataform.DataMapClick(Sender);
    Exit;
   end;


 if (tx >= btile.Width) or (ty >= btile.Height) then
    Exit;
   If ROMOpened then
   begin
    X0:= tx; Y0:= ty;
    case Tool of
      ttFiller:
        begin
          Color:= DTM.Color[FCol];
          btile.Canvas.Brush.Color:= Color;
          btile.Canvas.FloodFill(tx, ty, bTile.Canvas.Pixels[tx, ty], fsSurface);
          UpdateTile();
        end;
      ttDropper:
        begin
          Color:= btile.Canvas.Pixels[tx, ty];
          for I := 0 to 255 do
          begin
            if Color = DTM.Color[I] then
              FCol:= I;
          end;
          DTM.Foreground:= FCol;
        end;
      ttPen:
        begin
          Drawing := True;
          If Button = mbRight then
            Col := BCol
          Else
            Col := FCol;
          bTile.Canvas.Pixels[tx, ty] := DTM.Color[Col];
          UpdatePixel();
        end;
      ttClearRectangle:
        begin
//          Tile.Canvas.Brush.Style:= bsClear;
//          Tile.Canvas.Pen.Width:= CellSize;
//          If djinntilemapper.TileType < tt3bitSNES then
//          begin
//            Tile.Canvas.Brush.Color:= Colors[FCol];
//            Tile.Canvas.Pen.Color:= Colors[FCol];
//          end
//          else
//          begin
//            Tile.Canvas.Brush.Color:= Col16[FCol];
//            Tile.Canvas.Pen.Color:= Col16[FCol];
//          end;
          Selector.Width:= CellSize;
          Selector.Height:= CellSize;
          Selector.Left:= tx * CellSize;
          Selector.Top:= geditpan.Height + ty * CellSize;
          Selector.Brush.Style:= bsClear;
          Selector.Shape:= stRectangle;
          Selector.Pen.Color:= DTM.Color[FCol];
          Selector.Visible:= True;
        end;
    end;
   end;
end;

procedure Tteditform.TileMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  TileIndex: Integer;
begin
  CellSize:= Min(zw div bTile.Width, zh div btile.Height);
  tx :=  x div CellSize;
  ty :=  y div CellSize;
  mtx := tx  *  CellSize;
  mty := ty  *  CellSize;

 If ROMOpened and ((ssRight in Shift) or (ssLeft in Shift)) then
 begin
    case Tool of
      ttClearRectangle:
        begin
          Tile.Canvas.StretchDraw(Bounds(0, 0,CellSize * btile.Width,CellSize * btile.Height), bTile);
          if bTileEditGrid then
          begin
            if bTileEditGrid then
            begin
              DrawGrid(teditform.Tile.Picture.Bitmap, CellSize, CellSize, tilew, tileh);
            end;
          end;

          Exit;
        end;
    end;


  if bTMMouseDown then
  begin
    bTMMouseDown:= False;
    Exit;
  end;
  Drawing := True;
  If ssRight in Shift then
    Col := BCol
  Else
  if ssLeft in shift then
    Col := FCol;
  bTile.Canvas.Pixels[tx, ty] := DTM.Color[Col];
  UpdatePixel();

  Tile.Canvas.StretchDraw(Bounds(0, 0, (CellSize) * btile.Width, (CellSize)* btile.Height), bTile);
  if bTileEditGrid then
  begin
    if bTileEditGrid then
    begin
      DrawGrid(teditform.Tile.Picture.Bitmap, CellSize, CellSize, tilew, tileh);
    end;
  end;
 end;
end;

procedure Tteditform.TileMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 Drawing := False;
 If ROmopened then
 begin
  CellSize:= Min(zw div bTile.Width, zh div btile.Height);
  X1 :=  X div CellSize;
  Y1 :=  Y div CellSize;
  case Tool of
    ttClearRectangle:
      begin
//        Selector.Visible:= False;
//        btile.Canvas.Brush.Color:= Selector.Brush.Color;
//        btile.Canvas.Brush.Style:= Selector.Brush.Style;
//        btile.Canvas.Pen.Color:=
//        btile.Canvas.StretchDraw(Rect(X0, Y0, X1, Y1), Selector.Brush.Bitmap);
//        UpdateTile;
      end;
  end;
  Saved := False;
  DTM.DrawTileMap();

  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  CellSize:= Min(zw div bTile.Width, zh div btile.Height);
  Tile.Canvas.StretchDraw(Bounds(0, 0, (CellSize) * btile.Width , (CellSize) * btile.Height), bTile);
  if bTileEditGrid then
  begin
    DrawGrid(teditform.Tile.Picture.Bitmap, CellSize, CellSize, tilew, tileh);
  end;
 end;
end;


procedure Tteditform.zoomxChange(Sender: TObject);
begin
  zw:= (zoomx.ItemIndex + 2) * 128;
  zh:= zw;
  teditform.Tile.Width:= zw;
  teditform.Tile.Height:= zh;
  teditform.Tile.Picture.Bitmap.Width:= zw;
  teditform.Tile.Picture.Bitmap.Height:= zh;
  teditform.ClientWidth:= zw + teditform.pnl1.Width + teditform.spl2.Width + tlb1.Width;
  teditform.ClientHeight:= zh + teditform.geditpan.Height + teditform.spl1.Height;
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;

end.
