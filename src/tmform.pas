unit tmform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Buttons,
  ImgList,
  ComCtrls, ToolWin, System.ImageList;

type
  Ttilemapform = class(TForm)
    TileMap: TImage;
    TMapScroll: TScrollBar;
    Codecbox: TComboBox;
    tlwidth: TSpinEdit;
    tlheight: TSpinEdit;
    twidth: TSpinEdit;
    theight: TSpinEdit;
    scrlbx: TScrollBox;
    pnl1: TPanel;
    grp1: TGroupBox;
    grp2: TGroupBox;
    pnl2: TPanel;
    TileMapGrid: TSpeedButton;
    TileEditSize: TComboBox;
    tlb1: TToolBar;
    cbHV: TComboBox;
    stat1: TStatusBar;
    tlb2: TToolBar;
    tbBOF: TToolButton;
    tbBlockMinus100: TToolButton;
    tbBlockMinus10: TToolButton;
    tbMinus1: TToolButton;
    tbBlockMinus1: TToolButton;
    tbPlus1: TToolButton;
    tbBlockPlus1: TToolButton;
    tbBlockPlus10: TToolButton;
    tbBlockPlus100: TToolButton;
    tbEOF: TToolButton;
    tbGoTo: TToolButton;
    tbShowHex: TToolButton;
    ToolButton1: TToolButton;
    TileSelection: TShape;
    HexNums: TImage;
    Grid: TImage;
    procedure CodecboxChange(Sender: TObject);
    procedure CodecboxKeyPress(Sender: TObject; var Key: Char);
    procedure TileMapClick(Sender: TObject);
    procedure TileMapDblClick(Sender: TObject);
    procedure TileMapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tlheightChange(Sender: TObject);
    procedure tlwidthChange(Sender: TObject);
    procedure TMapScrollChange(Sender: TObject);
    procedure twidthChange(Sender: TObject);
    procedure theightChange(Sender: TObject);
    procedure ChangeMap(WW, HH: Integer);
    procedure TileEditSizeChange(Sender: TObject);
    procedure TileMapGridClick(Sender: TObject);
    procedure tbGoToClick(Sender: TObject);
    procedure cbHVChange(Sender: TObject);
    procedure tbMinus1Click(Sender: TObject);
    procedure tbPlus1Click(Sender: TObject);
    procedure tbBlockMinus1Click(Sender: TObject);
    procedure tbBlockPlus1Click(Sender: TObject);
    procedure tbBlockPlus10Click(Sender: TObject);
    procedure tbBlockMinus10Click(Sender: TObject);
    procedure tbBlockMinus100Click(Sender: TObject);
    procedure tbBlockPlus100Click(Sender: TObject);
    procedure tbBOFClick(Sender: TObject);
    procedure tbEOFClick(Sender: TObject);
    procedure tbShowHexClick(Sender: TObject);
    procedure TileMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SetSize(Width, Height: Integer);
    procedure ChangeSize();
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  procedure MoveTileSelection(TileSelection: TShape; ImageBounds: TRect; X, Y, W, H: Integer);

var
  tilemapform: Ttilemapform;

implementation

{$R *.dfm}

uses dtmmain, teditf, dataf, BitmapUtils, WorkSpace;

procedure TTileMapForm.SetSize(Width, Height: Integer);
begin
  btile.Width := TileW;
  btile.Height := TileH;
  bmap.Width := TileW * Width;
  bmap.Height := TileH * Height;
  TileWx2:= TileW * 2;
  TileHx2:= TileH * 2;
  TileMap.Width := TileWx2 * Width;
  TileMap.Height := TileHx2 * Height;
  TileMap.Picture.Bitmap.Width:= TileMap.Width;
  TileMap.Picture.Bitmap.Height:= TileMap.Height;
  HexNums.Width:= TileMap.Width;
  HexNums.Height:= TileMap.Height;
  HexNums.Picture.Bitmap.Width:= TileMap.Width;
  HexNums.Picture.Bitmap.Height:= TileMap.Height;
  Grid.Width:= TileMap.Width;
  Grid.Height:= TileMap.Height;
  Grid.Picture.Bitmap.Width:= TileMap.Width;
  Grid.Picture.Bitmap.Height:= TileMap.Height;
  TileSelection.Width:= TileWx2 * TEHeight;
  TileSelection.Height:= TileHx2 * TEWidth;
  DataForm.TileSelection.Width:= TileWx2 * deWidth;
  DataForm.TileSelection.Height:= TileHx2 * deHeight;
  WSForm.TileSelection.Width:= TileWx2 * WSWidth;
  WSForm.TileSelection.Height:= TileHx2 * WSHeight;
  if DataForm.Grid.Visible then
  begin
    DTM.DataScrollEnable;
  end;
  if WSForm.Grid.Visible then
  begin
    WSForm.seWidthChange(self);
  end;
end;

procedure TTileMapForm.ChangeSize();
begin
//
end;

procedure Ttilemapform.CodecboxChange(Sender: TObject);
var
  cdt: TTileType;
begin
 If (CodecBox.ItemIndex >= 0) then
 begin
  Byte(cdt) := CodecBox.ItemIndex;
  case cdt of
    tt1bit, tt2bitNES, tt4bitMSX:
      begin
        twidth.Enabled:= True;
        theight.Enabled:= True;
      end
      else
      begin
        twidth.Value:= 8;
        theight.Value:= 8;
        twidth.Enabled:= False;
        theight.Enabled:= False;
      end;
  end;
  If cdt <> DTM.TileType then DTM.TileType := cdt;
  If codecbox.Text <> codecbox.Items.Strings[codecbox.ItemIndex]  then
   codecbox.Text := codecbox.Items.Strings[codecbox.ItemIndex];
 end;
end;

procedure Ttilemapform.CodecboxKeyPress(Sender: TObject; var Key: Char);
begin
 Key := #0;
end;

procedure Ttilemapform.FormCreate(Sender: TObject);
begin
  HexNums.Picture.Bitmap.Transparent:= True;
  HexNums.Picture.Bitmap.TransparentMode:= tmFixed;
  HexNums.Picture.Bitmap.TransparentColor:= clWhite;
  Grid.Picture.Bitmap.Transparent:= True;
  Grid.Picture.Bitmap.TransparentMode:= tmFixed;
  Grid.Picture.Bitmap.TransparentColor:= clWhite;
end;

procedure MoveTileSelection(TileSelection: TShape; ImageBounds: TRect; X, Y, W, H: Integer);
begin
  if (X + W) >= ImageBounds.Width then
    X:= ImageBounds.Width - W;
  if (Y + H) >= ImageBounds.Height then
    Y:= ImageBounds.Height - H;
  TileSelection.Left:= (ImageBounds.Left div TileWx2) * TileWx2 + (ImageBounds.Left mod TileWx2) + X;
  TileSelection.Top:=  (ImageBounds.Top div TileHx2) * TileHx2 +  (ImageBounds.Top mod TileHx2)  + Y;
end;

procedure Ttilemapform.TileMapClick(Sender: TObject);
var
  X, Y, I, J, Bank: Integer;
begin
  if bTMMouseDown then
    Exit;
  I:= tmMouseX div TileWx2;
  J:= tmMouseY div TileHx2;
  Bank:= Map[J, I];
  DTM.Bank:= Bank;
  if not bType then
  begin
    X:= MapXY[Bank].X * TileWx2;
    Y:= MapXY[Bank].Y * TileHx2;
  end
  else
  begin
    X:= I * TileWx2;
    Y:= J * TileHx2;
  end;

  MoveTileSelection(TileSelection, TileMap.BoundsRect, X, Y, TileWx2 * TEWidth, TileHx2 * TEHeight);

  for Y:= 0 to teheight - 1 do
  begin
    for X:= 0 to tewidth - 1 do
    begin
      dtmmain.TileMap[Y, X]:= Map[J + Y, I + X];
    end;
  end;
  DTM.DrawTile(tewidth, teheight);
  If tmapscroll.enabled then
    TMapScroll.SetFocus;
  if bStep then
  begin
    TileMapDblClick(Self);
  end
  else
  if bType then
  begin
    TileMapDblClick(Self);
    if bSwapXY then
    begin
      if bWorkSpace then
        Inc(iWSPos)
      else
        Inc(CDpos);
    end
    else
    begin
      if bWorkSpace then
        Inc(iWSPos, iWSHeight)
      else
        Inc(CDpos, DTM.dHeight);
    end;

    if bWorkSpace then
    begin
      if iWSPos = iWSWidth * iWSHeight then
      begin
//        if bSwapXY then
          Dec(iWSPos);
//        else
//          Dec(iWSPos, iWSHeight);
      end;  
    end
    else
    If romDataPos + CDpos = ROMsize then
    begin
//      if bSwapXY then
        Dec(CDPos);
//      else
//        Dec(CDPos, DjinnTileMapper.dHeight)
    end;

    If (CDPos >= DTM.dWidth * DTM.dHeight) and not bWorkSpace then
    begin
//      if bSwapXY then
        Dec(CDpos);
//      else
//        Dec(CDpos, DjinnTileMapper.dHeight * PatternSize);

      If not tTblOpened then
      begin
        DTM.Bank := Data[CDPos].Index
      end
      Else
        DTM.Bank := TileTable[Data[CDPos].Index and $FF];
    end
    else
    begin
      If not tTblOpened then
      begin
        if bWorkSpace then
          DTM.Bank:= WSMap[iWSPos].Index
        else
          DTM.Bank := Data[CDPos].Index
      end
      Else
        DTM.Bank := TileTable[Data[CDPos].Index and $FF];
    end;
  end;

end;


procedure Ttilemapform.TileMapDblClick(Sender: TObject);
var
  X, Y, I, J: Integer;
  b: boolean;
begin
 If ROMOpened then
 begin
  Saved := False;
  stat1.Panels.Items[0].Text:= 'Адрес : ' +  inttohex(DataPos, 6) +
            ' / ' + inttohex(ROMsize, 6);
  If not tTblOpened then
  begin
    if bWorkSpace then
      WSMap[iWSPos].Index:= DTM.Bank
    else
      Data[CDpos].Index:= DTM.Bank;
  end
  Else
  begin
   b := False;
   For i := 0 to 255 do
    If TileTable[i] = DTM.Bank then
     begin
      b := True;
      Break;
     end;
   If B then
   begin
    Data[CDpos].Index := i;
   end
   Else
   begin
    Data[CDpos].Index := 0;
   end;
  end;
  I:= tmMouseX div 16;
  J:= tmMouseY div 16;
  for Y:= 0 to teheight - 1 do
  begin
    for X:= 0 to tewidth - 1 do
    begin
      dtmmain.TileMap[Y, X]:= Map[J + Y, I + X];
    end;
  end;
  DTM.DataMapDraw;
 end;
end;


procedure Ttilemapform.TileMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (ssLeft in Shift) and (ssCtrl in Shift) and (bTMMouseDown = False) then
  begin
    bTMMouseDown:= True;
    TileCaptured:= Map[Y div TileHx2, X div TileWx2];
//    TileSelection.Left:= MapXY[TileCaptured].X * TileWx2;
//    TileSelection.Top:=  MapXY[TileCaptured].Y * TileHx2;
  end;
end;


procedure Ttilemapform.TileMapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
Var b: Word;
begin
  tmMouseX := X;
  tmMouseY := Y;
  b:= Map[Y div TileHx2, X div TileWx2];
  stat1.Panels.Items[0].Text:= 'Адрес : ' + IntToHex(DataPos + B * TileW * TileH div (8 div bsz[DTM.TileType]), 6)+ ' / ' + IntToHex(ROMSize, 6);
  stat1.Panels.Items[1].Text:= 'Тайл : ' + IntToHex(b, 4) + ' = ' + IntToStr(b);
end;

procedure Ttilemapform.TileSelectionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  TileMapClick(Self);
end;

procedure Ttilemapform.TileSelectionMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
begin
 TMMouseX := TileSelection.Left + X - TileMap.Left;
 TMMouseY := TileSelection.Top + Y - TileMap.Top;;
end;

procedure Ttilemapform.tlheightChange(Sender: TObject);
begin
 tlheightv := tlheight.Value;
 ChangeMap(tlwidthv, tlheightv);
 DTM.DrawTileMap;
 DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;


procedure Ttilemapform.tlwidthChange(Sender: TObject);
begin
 tlwidthv := tlwidth.Value;
 ChangeMap(tlwidthv, tlheightv);
 DTM.DrawTileMap;
 DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;


procedure Ttilemapform.TMapScrollChange(Sender: TObject);
begin
 DTM.Rompos := LongInt(TMapScroll.position);
 DTM.DrawTile(tewidth, teheight);
end;

procedure Ttilemapform.twidthChange(Sender: TObject);
begin
  if not romopened then
    exit;
  tilew := twidth.Value;
  SetSize(16, 128);
  tmapscroll.Left := tilemap.Left + tilemap.Width;
  tmapscroll.Height := tilemap.Height;
  TMapScroll.Max:= (OldRomSize * 8 - (16 * bsz[DTM.TileType] * tilew * tileh)) div 8;
  TMapScroll.SmallChange:= 16 * bsz[DTM.TileType] * tilew * tileh div 8;
  TMapScroll.LargeChange:= 16 * 16 * bsz[DTM.TileType] * tilew * tileh div 8;
  if TMapScroll.LargeChange = 0 then
    TMapScroll.LargeChange:= (32767 div TMapScroll.SmallChange) * TMapScroll.SmallChange;
  bmap.Canvas.Brush.Color := 0;
  bmap.Canvas.FillRect(bounds(0, 0, bmap.width, bmap.height));
  DTM.fill(tilemap, 0);
  if tilew <> tileh then
  begin
    teditform.RotRightBtn.Enabled:= False;
    teditform.RotLeftBtn.Enabled:= False;
  end
  else
  begin
    teditform.RotRightBtn.Enabled:= True;
    teditform.RotLeftBtn.Enabled:= True;
  end;
  DTM.dWidth:= DTM.dWidth;
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  DTM.drawtilemap;
end;

procedure Ttilemapform.theightChange(Sender: TObject);
begin
  if not romopened then
    exit;
  tileh := theight.Value;
  SetSize(16, 128);
  tmapscroll.Left := tilemap.Left + tilemap.Width;
  tmapscroll.Height := tilemap.Height;
  bmap.Canvas.Brush.Color := 0;
  bmap.Canvas.FillRect(bounds(0, 0, bmap.width, bmap.height));
  DTM.fill(tilemap, 0);
  TMapScroll.Max:= (OldRomSize * 8 - (16 * bsz[DTM.TileType] * tilew * tileh)) div 8;
  TMapScroll.SmallChange:= 16 * bsz[DTM.TileType] * tilew * tileh div 8;
  TMapScroll.LargeChange:= 16 * 16 * bsz[DTM.TileType] * tilew * tileh div 8;
  if TMapScroll.LargeChange = 0 then
    TMapScroll.LargeChange:= (32767 div TMapScroll.SmallChange) * TMapScroll.SmallChange;

  if tilew <> tileh then
  begin
    teditform.RotRightBtn.Enabled:= False;
    teditform.RotLeftBtn.Enabled:= False;
  end
  else
  begin
    teditform.RotRightBtn.Enabled:= True;
    teditform.RotLeftBtn.Enabled:= True;
  end;
  DTM.dHeight:= DTM.dHeight;
  DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  DTM.drawtilemap;
end;
procedure Ttilemapform.ChangeMap(WW, HH: Integer);
var
  X, Y, I, XX, YY, W, H: Integer;
begin
  I:= 0;
  W:= 16 div tlwidthv;
  H:= 128 div tlheightv;
  if cbHV.ItemIndex = 0 then
  begin
    for Y:= 0 to H-1 do
    begin
      for X:= 0 to W-1 do
      begin
        for YY:= 0 to HH-1 do
        begin
          for XX:= 0 to WW-1 do
          begin
            MapXY[I].X:= X * tlwidthv  + XX;
            MapXY[I].Y:= Y * tlheightv + YY;
            Map[MapXY[I].Y, MapXY[I].X]:= I;
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
            MapXY[I].X:= X * tlwidthv  + XX;
            MapXY[I].Y:= Y * tlheightv + YY;
            Map[MapXY[I].Y, MapXY[I].X]:= I;
            Inc(I);
          end;
        end;
      end;
    end;
  end;  
end;

procedure Ttilemapform.TileEditSizeChange(Sender: TObject);
begin

  case TileEditSize.ItemIndex of
    0:
      begin
        tewidth:= 16;
        teheight:= 16;
      end;
    1:
      begin
        tewidth:= 8;
        teheight:= 8;
      end;
    2:
      begin
        tewidth:= 4;
        teheight:= 4;
      end;
    3:
      begin
        tewidth:= 2;
        teheight:= 2;
      end;
    4:
      begin
        tewidth:= 1;
        teheight:= 1;
      end;
  end;
  TileSelection.Width:= tewidth * TileWx2;
  TileSelection.Height:= teheight * TileHx2;
  TileSelection.Left:= 0;
  TileSelection.Top:= 0;
  //DjinnTileMapper.DrawTileMap();
end;

procedure Ttilemapform.TileMapGridClick(Sender: TObject);
begin
  bTileMapGrid:= not bTileMapGrid;
  Grid.Visible:= bTileMapGrid;
  GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clSkyBlue);
  GridDraw(Grid.Picture.Bitmap, TileWx2 * 8, TileHx2 * 8, clYellow);
  //DjinnTileMapper.DrawTileMap();
end;



procedure Ttilemapform.tbBlockMinus100Click(Sender: TObject);
var
  Tile: Byte;
begin
  if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 0 then
      TMapScroll.Position:= DTM.ROMpos - 40 * 256
    else
      TMapScroll.Position:= DTM.ROMpos - 8 * 256;
  end
  else
    TMapScroll.position := DTM.ROMpos - 8 * bsz[DTM.TileType] * 256;
end;

procedure Ttilemapform.tbGoToClick(Sender: TObject);
begin
  DTM.GoTo1.Click();
end;

procedure Ttilemapform.cbHVChange(Sender: TObject);
begin
 ChangeMap(tlwidthv, tlheightv);
 DTM.DrawTileMap;
 DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
end;

procedure Ttilemapform.tbMinus1Click(Sender: TObject);
begin
 TMapScroll.position := DTM.ROMpos - 1;
end;

procedure Ttilemapform.tbPlus1Click(Sender: TObject);
begin
 TMapScroll.position := DTM.ROMpos + 1;
end;

procedure Ttilemapform.tbShowHexClick(Sender: TObject);
var
  X, Y, I: Integer;
  RowCount: Integer;
begin
  bTMShowHex:= tbShowHex.Down;
  HexNums.Visible:= bTMShowHex;
  TileMap.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, TileMap.Width, TileMap.Height), bmap.Canvas, Bounds(0, 0, bmap.Width, bmap.Height));
  if RomOpened  and bTMShowHex then
  begin
    RowCount:= 128;
    if ((OldROMSize - DataPos) * 8) < (16 * 128 * bsz[DTM.TileType] * tilew * tileh) then
      RowCount:= ((OldROMSize - DataPos) * 8) div (16 * tilew * tileh * bsz[DTM.TileType]);
    I:= 0;
    For y := 0 to RowCount - 1 do
      For x := 0 to 16 - 1 do
      begin
        //HexNums.Picture.Bitmap.Canvas.TextOut(MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, IntToHex(I, 2));
        DTM.HexNumbers.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, I and $FF, True);
        //DjinnTileMapper.HexNumbers.Draw(Bitmap.Canvas, 0, 0, I and $FF, True);
        //HexNums.Picture.Bitmap.Canvas.Draw( MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, Bitmap);
        Inc(I);
      end;
  end;
end;

procedure Ttilemapform.tbBlockMinus10Click(Sender: TObject);
var
  Tile: Byte;
begin
  if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 0 then
      TMapScroll.Position:= DTM.ROMpos - 40 * 16
    else
      TMapScroll.Position:= DTM.ROMpos - 8 * 16;
  end
  else
    TMapScroll.position := DTM.ROMpos - 8 * bsz[DTM.TileType] * 16;
end;

procedure Ttilemapform.tbBlockMinus1Click(Sender: TObject);
var
  Tile: Byte;
begin
  if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 0 then
      TMapScroll.Position:= DTM.ROMpos - 40
    else
      TMapScroll.Position:= DTM.ROMpos - 8;
  end
  else
    TMapScroll.position := DTM.ROMpos - 8 * bsz[DTM.TileType];
end;

procedure Ttilemapform.tbBlockPlus100Click(Sender: TObject);
var
  Tile: Byte;
begin
 if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 3 then
      TMapScroll.Position:= DTM.ROMpos + 40 * 100
    else
      TMapScroll.Position:= DTM.ROMpos + 8 * 100;
  end
  else
    TMapScroll.position := DTM.ROMpos + 8 * bsz[DTM.TileType] * 100;
end;


procedure Ttilemapform.tbBlockPlus10Click(Sender: TObject);
var
  Tile: Byte;
begin
 if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 3 then
      TMapScroll.Position:= DTM.ROMpos + 40 * 16
    else
      TMapScroll.Position:= DTM.ROMpos + 8 * 16;
  end
  else
    TMapScroll.position := DTM.ROMpos + 8 * bsz[DTM.TileType] * 16;
end;

procedure Ttilemapform.tbBlockPlus1Click(Sender: TObject);
var
  Tile: Byte;
begin
  if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 3 then
      TMapScroll.Position:= DTM.ROMpos + 40
    else
      TMapScroll.Position:= DTM.ROMpos + 8;
  end
  else
    TMapScroll.position := DTM.ROMpos + 8 * bsz[DTM.TileType];
end;

procedure Ttilemapform.tbBOFClick(Sender: TObject);
begin
  TMapScroll.Position:= 0;
end;

procedure Ttilemapform.tbEOFClick(Sender: TObject);
var
  Tile: Byte;
begin
 if DTM.TileType = tt2bitMSX then
  begin
    Tile:= (DTM.ROMpos div 8) and 3;
    if Tile = 3 then
      TMapScroll.Position:= OldRomSize - 40 * 16
    else
      TMapScroll.Position:= OldRomSize - 8 * 16;
  end
  else
    TMapScroll.position := OldRomSize - 8 * bsz[DTM.TileType] * 16;
end;

end.
