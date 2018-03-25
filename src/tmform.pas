unit tmform;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Buttons,
  ImgList,
  ComCtrls, ToolWin, System.ImageList, System.Actions, Vcl.ActnList, Vcl.Menus, GdiPlus;

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
    tbAddBookmark: TToolButton;
    pmJumpList: TPopupMenu;
    AddBookmark: TMenuItem;
    actlst1: TActionList;
    ActionAddressJumpList: TAction;
    Block: TImage;
    BlockCopy: TAction;
    BlockPaste: TAction;
    BlockSelectAll: TAction;
    tbSelectTiles: TToolButton;
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
    procedure ActionAddressJumpListExecute(Sender: TObject);
    procedure AddBookmarkClick(Sender: TObject);
    procedure BlockPasteExecute(Sender: TObject);
    procedure BlockSelectAllExecute(Sender: TObject);
    procedure tbSelectTilesClick(Sender: TObject);
    procedure TileMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BlockMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockCopyExecute(Sender: TObject);
    procedure FormPaint(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitJumpList;
  end;
  procedure MoveTileSelection(TileSelection: TShape; ImageBounds: TRect; X, Y, W, H: Integer);

var
  tilemapform: Ttilemapform;
  bBlockMouseDown: Boolean;
  X0, X1, Y0, Y1: Integer;
  MouseLocation: TPoint;
  BlockLocation: TPoint;
  BlockSelected, W, H: Integer;

implementation

{$R *.dfm}

uses dtmmain, teditf, dataf, BitmapUtils, WorkSpace, BookmarkInputForm, Math, Vcl.Clipbrd;

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



procedure Ttilemapform.FormPaint(Sender: TObject);
var
  Graphics: IGPGraphics;
begin
  if Block.Visible then
  begin
    Graphics:= TGPGraphics.Create(Block.Canvas.Handle);
    Graphics.DrawRectangle(WhitePen, 0, 0, Block.Width-1, Block.Height-1);
    Graphics.DrawRectangle(BorderPen, 0, 0, Block.Width-1, Block.Height-1);
    Block.Repaint;
  end;
end;

procedure MoveTileSelection(TileSelection: TShape; ImageBounds: TRect; X, Y, W, H: Integer);
begin
  if (X + W) >= ImageBounds.Width then
    X:= ImageBounds.Width - W;
  if (Y + H) >= ImageBounds.Height then
    Y:= ImageBounds.Height - H;
  SetEffectivePosition(TileSelection, ImageBounds, X, Y);
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
    if bWorkSpace then
      WSMap[iWSPos].Index:= DTM.Bank
    else
    begin
      Data[CDpos].Index:= DTM.Bank;
      BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
      case DTM.MapFormat of
        mfSingleByte, mfGBC: BitWriter.Write(Data[CDpos].Value, 8);
        mfGBA, mfSNES, mfPCE: BitWriter.Write(Swap(Data[CDpos].Value), 16);
        mfMSX, mfSMS: BitWriter.Write(Data[CDpos].Value, 16);
      end;
    end;
    DTM.DataMapDraw;
  end
  else
  if bType then
  begin
    if bWorkSpace then
      WSMap[iWSPos].Index:= DTM.Bank
    else
    begin
      Data[CDpos].Index:= DTM.Bank;
      BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
      case DTM.MapFormat of
        mfSingleByte, mfGBC: BitWriter.Write(Data[CDpos].Value, 8);
        mfGBA, mfSNES, mfPCE: BitWriter.Write(Swap(Data[CDpos].Value), 16);
        mfMSX, mfSMS: BitWriter.Write(Data[CDpos].Value, 16);
      end;
    end;

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
        if bSwapXY then
          Dec(iWSPos)
        else
          Dec(iWSPos, iWSHeight);
      end;  
    end
    else
    If romDataPos + CDpos = ROMsize then
    begin
      if bSwapXY then
        Dec(CDPos)
      else
        Dec(CDPos, DTM.dHeight)
    end;

    If (CDPos >= DTM.dWidth * DTM.dHeight) and not bWorkSpace then
    begin
      if bSwapXY then
        Dec(CDpos)
      else
        Dec(CDpos, DTM.dHeight * PatternSize);

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
    DTM.DataMapDraw;
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
    begin
      Data[CDpos].Index:= DTM.Bank;
      BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
      case DTM.MapFormat of
        mfSingleByte, mfGBC: BitWriter.Write(Data[CDpos].Value, 8);
        mfGBA, mfSNES, mfPCE: BitWriter.Write(Swap(Data[CDpos].Value), 16);
        mfMSX, mfSMS: BitWriter.Write(Data[CDpos].Value, 16);
      end;
    end;
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
  DTM.DataMapDraw;
 end;
end;


procedure Ttilemapform.TileMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and (ssCtrl in Shift) and (bTMMouseDown = False) then
  begin
    bTMMouseDown:= True;
    TileCaptured:= Map[Y div TileHx2, X div TileWx2];
  end
  else
  if (Button = mbLeft) and tbSelectTiles.Down  then
  begin
    X0:= (X div TileWx2) * TileWx2;
    Y0:= (Y div TileHx2) * TileHx2;
    X1:= X0;
    Y1:= Y0;
    Block.Visible:= False;
    bTMMouseDown:= True;
    with TileMap.Canvas do
    begin
      Brush.Style:= bsFDiagonal;
      Brush.Color:= clBlack;
      Pen.Style:= psDashDot;
      Pen.Mode:= pmNotXor;
      Pen.Color:= clBlack;
    end;
  end;
end;


procedure Ttilemapform.TileMapMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  B: Word;
begin
  tmMouseX := Min(X, TileMap.Width - 1);
  tmMouseY := Min(Y, TileMap.Height - 1);
  if ROMopened then
  begin
    if bTMMouseDown then
    begin
      TileMap.Canvas.Rectangle(X0, Y0, X1, Y1);//Стираем прямоугольник
      X1:= Succ(tmMouseX div TileWx2) * TileWx2; Y1:= Succ(tmMouseY div TileHx2) * TileHx2;
      TileMap.Canvas.Rectangle(X0, Y0, X1, Y1); //Рисуем на новом месте
      //Stat1.Panels.Items[3].Text:= IntToStr(W) + ',' + IntToStr(H);
    end;
  end;
  B:= Map[Y div TileHx2, X div TileWx2];
  stat1.Panels.Items[0].Text:= 'Адрес : ' + IntToHex(DataPos + B * TileW * TileH div (8 div bsz[DTM.TileType]), 6)+ ' / ' + IntToHex(ROMSize, 6);
  stat1.Panels.Items[1].Text:= 'Тайл : ' + IntToHex(b, 4) + ' = ' + IntToStr(b);
end;

procedure Ttilemapform.TileMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, J, Nums, XX, YY, W, H, Temp: Integer;
begin
  if ROMopened and bTMMouseDown then
  begin
    if (X0 = X1) or (Y0 = Y1) then
    begin
      bMouseDown:= False;
    end;
    if X0 > X1 then
    begin
      Temp:= X0;
      X0:= X1;
      X1:= Temp;
    end;
    if Y0 > Y1 then
    begin
      Temp:= Y0;
      Y0:= Y1;
      Y1:= Temp;
    end;

    //Block.Left:= (TileMap.Left + X0) div TileWx2 * TileWx2 + (TileMap.Left mod TileWx2);
    //Block.Top:=  (TileMap.Top + Y0) div TileHx2 * TileHx2 +  (TileMap.Top mod  TileHx2);
    SetEffectivePosition(Block, TileMap.BoundsRect, X0, Y0);
    W:= Abs(X1 - X0) div TileWx2;
    H:= Abs(Y1 - Y0) div TileHx2;
    Block.Width:= W * TileWx2;
    Block.Height:= H * TileHx2;
    Block.Picture.Bitmap.Width:= W * TileWx2;
    Block.Picture.Bitmap.Height:= H * TileHx2;
    Block.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, Block.Width, Block.Height), TileMap.Canvas, Bounds((X0 div TileWx2) * TileWx2, (Y0 div TileHx2) * TileHx2, W *TileWx2, H * TileHx2));
    TileMap.Canvas.Rectangle(X0, Y0, X1, Y1);//Стираем прямоугольник
    TileMap.Canvas.Pen.Mode:= pmCopy; //Восстанавливаем режим карандаша
    Block.Visible:= True;
    XX:= (Block.Left - TileMap.Left -  (TileMap.Left mod TileWx2)) div TileWx2;
    YY:= (Block.Top - TileMap.Top   -  (TileMap.Top mod  TileHx2)) div TileHx2;
    Nums:= W * H; // Определяем кол-во выделенных тайлов
    dtmmain.SetSize(SelectTiles, Nums);
    for I := 0 to H - 1 do
    begin
      for J := 0 to W - 1 do
        begin
          SelectTiles[I * W + J].Index:= Map[YY + I,XX + J];
        end;
    end;
    bTMMouseDown:= False;
  end;

end;

procedure Ttilemapform.TileSelectionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  tmMouseX:= TileSelection.Left;
  tmMouseY:= TileSelection.Top;
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
end;

procedure Ttilemapform.TileMapGridClick(Sender: TObject);
begin
  bTileMapGrid:= not bTileMapGrid;
  Grid.Visible:= bTileMapGrid;
  GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clSkyBlue);
  GridDraw(Grid.Picture.Bitmap, TileWx2 * 8, TileHx2 * 8, clYellow);
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

procedure Ttilemapform.InitJumpList;
var
  I, J: Byte;
  BookmarkName: string;
begin
  pmJumpList.Items.Clear;
  pmJumpList.Items.Add(NewItem('Добавить закладку', 0, False, True, AddBookmarkClick, 0, 'MenuItem0'));
  pmJumpList.Items.Add(NewLine);
  if JumpList.Count = 0 then
    Exit;
  for I := 0 to JumpList.Count - 1 do
  begin
    with pmJumpList.Items do
    begin
      BookmarkName:= JumpList.Strings[I];
      J:= LastDelimiter(':', BookmarkName);
      BookmarkName:= Copy(BookmarkName, 1, J - 1);
      Add(NewItem(BookmarkName, 0, False, True, ActionAddressJumpListExecute, 0, 'MenuItem' + IntToStr(I+1)));
      Items[I + 2].Tag:= I;
    end;
  end;
end;

procedure Ttilemapform.ActionAddressJumpListExecute(Sender: TObject);
var
  S: string;
  I: Byte;
  Item: TMenuItem;
begin
  Item:= TMenuItem(Sender);
  S:= JumpList.Strings[Item.Tag];
  I:= FindDelimiter(':', S); Inc(I);
  S:= Copy(S, I, 6);
  TMapScroll.Position:= StrToInt('$' + S);
end;

procedure Ttilemapform.AddBookmarkClick(Sender: TObject);
var
  BookmarkName: string;
  Address: string;
  FileName: string;
begin
  Address:= IntToHex(DataPos, 6);
  FileName:= ExtractFileName(fname);
  BookmarkName:= f_bookmark.GetBookmark(FileName + ' [' +  Address + ']');
  if IsBookmarkAccepted then
  begin
    JumpList.Add(BookmarkName + ' :' + Address);
    JumpList.SaveToFile(FileName + '.jumplist');
    InitAllJumpLists;
  end;
end;



procedure Ttilemapform.BlockCopyExecute(Sender: TObject);
var
  I: Integer;
  Data: THandle;
  DataPtr: Pointer;
begin
  if Block.Visible then
  begin
    // Allocate SizeOf(TBlock) * Length(Buffer) bytes from the heap
    Data :=  GlobalAlloc(GMEM_FIXED or GMEM_ZEROINIT, (SizeOf(Word) * Length(SelectTiles)));
    try
      // Obtain a pointer to the first byte of the allocated memory
      DataPtr := GlobalLock(Data);
      try
        // Move the data in Rec to the memory block
        for I := Low(SelectTiles) to High(SelectTiles) do
        begin
          PWORD(DataPtr)^:= SelectTiles[I].Value;
          IncPointer(DataPtr, SizeOf(Word));
        end;
        { Clipboard.Open must be called if multiple clipboard formats are
          being copied to the clipboard at once. Otherwise, if only one
          format is being copied the call isn't necessary }
        ClipBoard.Open;
        Clipboard.Clear;
        try
          // First copy the data as its custom format
          ClipBoard.SetAsHandle(CF_DTMDATA, Data);
          Clipboard.Assign(Block.Picture.Bitmap);
          { If a call to Clipboard.Open is made you must match it
            with a call to Clipboard.Close }
        finally
          Clipboard.Close
        end;
      finally
        // Unlock the globally allocated memory
        GlobalUnlock(Data);
      end;
  except
    { A call to GlobalFree is required only if an exception occurs.
      Otherwise, the clipboard takes over managing any allocated
      memory to it.}
    //Bitmap.Free;
    GlobalFree(Data);
    raise;
  end;
    Block.Visible:= False;
  end;
end;

procedure Ttilemapform.BlockMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX, YY, XXX, YYY, W, H, I, J: Integer;
begin
  if Button = mbLeft then
  begin
    BlockLocation.X:= X;
    BlockLocation.Y:= Y;
    bBlockMouseDown:= True;
  end;
  if Button = mbRight then
  begin
    TileMap.Canvas.CopyRect(Bounds(Block.Left - TileMap.Left - (TileMap.Left mod TileWx2), Block.Top - TileMap.Top - (TileMap.Top mod  TileHx2), Block.Width, Block.Height), Block.Canvas, Bounds(0, 0, Block.Width, Block.Height));
    XXX:= (Block.Left - TileMap.Left -  (TileMap.Left mod TileWx2)) div TileWx2;
    YYY:= (Block.Top - TileMap.Top   -  (TileMap.Top mod  TileHx2)) div TileHx2;
    W:= Block.Width div TileWx2;  //Количиестов тайлов по горизонтали
    H:= Block.Height div TileHx2; //Количество тайлов по вертикали

    if Length(SelectTiles) = W * H then
    begin
      for I := 0 to H - 1 do
      begin
        for J := 0 to W - 1 do
          begin
            bTile.Canvas.CopyRect(Bounds(0, 0, tilew, tileh), BMap.Canvas, Bounds(MapXY[SelectTiles[I * W + J].Index].X * tilew, MapXY[SelectTiles[I * W + J].Index].Y * tileh, tilew, tileh));
            dtmmain.TileMap[0, 0]:= Map[YYY + I, XXX + J];
            for yy := 0 to tileh - 1 do
              for xx := 0 to tilew - 1 do
              begin
                tx := xx;
                ty := yy;
                UpdatePixel;
              end;
          end;
      end;
    end;
    Block.Visible:= False;
    DTM.DrawTileMap;
  end;
end;


procedure Ttilemapform.BlockMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  NewBlockPos: TPoint;
begin
  if bBlockMouseDown then
  begin
    NewBlockPos.X:= (Block.Left + X - BlockLocation.X) div TileWx2 * TileWx2 + (TileMap.Left mod  TileWx2);
    NewBlockPos.Y:= (Block.Top + Y - BlockLocation.Y) div TileHx2 * TileHx2 + (TileMap.Top mod  TileHx2);;
    if ((NewBlockPos.X + Block.Width) <= TileMap.Width) and (NewBlockPos.X >= TileMap.Left) then
    begin
      Block.Left:= NewBlockPos.X;
    end;
    if ((NewBlockPos.Y + Block.Height) <= TileMap.Height) and (NewBlockPos.Y >= TileMap.Top) then
    begin
      Block.Top:= NewBlockPos.Y;
    end;
  end;
end;

procedure Ttilemapform.BlockMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bBlockMouseDown:= False;
end;


procedure Ttilemapform.BlockSelectAllExecute(Sender: TObject);
begin
  if tbSelectTiles.Down then
  begin
    TileMapMouseDown(Self, mbLeft, [ssLeft], 0, 0);
    Block.Left:= 0;
    Block.Top:= 0;
    TileMapMouseMove(Self, [ssLeft], TileMap.Width - 1, TileMap.Height - 1);
    TileMapMouseUp(Self, mbLeft, [ssLeft], TileMap.Width div 2, TileMap.Height div 2);
    Block.Visible:= True;
  end;
end;


procedure Ttilemapform.BlockPasteExecute(Sender: TObject);
var
  Bitmap : TBitmap;
  BlockCounts, I: Integer;
  Data: THandle;
  DataPtr: Pointer;
begin
 Bitmap := TBitMap.Create;
 try
   TileSelection.Visible:= False;
   tbSelectTiles.Down := True;
   Block.Visible:= True;
   SetEffectivePosition(Block, TileMap.BoundsRect, scrlbx.HorzScrollBar.Position, scrlbx.VertScrollBar.Position);
   Clipboard.Open;
   if Clipboard.HasFormat(CF_BITMAP) then
   begin
      Block.Picture.RegisterClipboardFormat(cf_BitMap,TBitmap);
      Bitmap.LoadFromClipBoardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
      Block.Picture.Bitmap.Assign(Bitmap);
      Block.Width:= Bitmap.Width;
      Block.Height:= Bitmap.Height;
   end else
    Exit;
    if Clipboard.HasFormat(CF_DTMDATA) then
    begin
      Data:= Clipboard.GetAsHandle(CF_DTMDATA);
      DataPtr:= GlobalLock(Data);
      try
        // Obtain the size of the data to retrieve
        BlockCounts:= GlobalSize(Data) div SizeOf(Word);
        dtmmain.SetSize(SelectTiles, BlockCounts);
        for I := Low(SelectTiles) to High(SelectTiles) do
        begin
          //SelectTiles[I]:= TBlock.Create;
          SelectTiles[I].Value:= PWord(DataPtr)^;
          IncPointer(DataPtr, SizeOf(Word));
        end;
      finally
        // Free the pointer to the memory block.
        GlobalUnlock(Data);
      end;
   end;
 finally
   Bitmap.free;
   Clipboard.Close;
 end;
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

procedure Ttilemapform.tbSelectTilesClick(Sender: TObject);
begin
  TileSelection.Visible:= not tbSelectTiles.Down;
  if tbSelectTiles.Down = false then
  begin
    Block.Visible:= False;
    TileMap.Cursor:= crDefault;
    Grid.Cursor:= crDefault;
  end
  else
  begin
    TileMap.Cursor:= crCross;
    Grid.Cursor:= crCross;
  end;
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
        case DTM.MapFormat of
          mfSingleByte, mfGBC:
            begin
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $FF;
            end;
          mfSMS:
            begin
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $1FF;
            end;
          mfGBA, mfSNES:
            begin
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $3FF;
            end;
          mfMSX, mfPCE:
            begin
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2, MapXY[I].Y * TileHx2, (I shr 8) and 15, True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 5, MapXY[I].Y * TileHx2, ((I shr 4) and 15), True);
              DTM.HexNums.Draw(TileMap.Picture.Bitmap.Canvas, MapXY[I].X * TileWx2 + 10, MapXY[I].Y * TileHx2, (I and 15), True);
              I:= Succ(I) and $7FF;
            end;
        end;
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
