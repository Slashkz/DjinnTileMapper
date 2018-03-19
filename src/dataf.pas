unit dataf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, Buttons,
  ComCtrls,
  ToolWin,
  ImgList, System.ImageList, System.Actions, Vcl.ActnList, Clipbrd,
  Vcl.StdActns;

type
  Tdataform = class(TForm)
    otherpan: TPanel;
    dRightBtn: TSpeedButton;
    dLeftBtn: TSpeedButton;
    WLab: TLabel;
    hlab: TLabel;
    Label1: TLabel;
    Panel1: TPanel;
    DataScroll: TScrollBar;
    WidthEdit: TSpinEdit;
    HeightEdit: TSpinEdit;
    hexed: TEdit;
    DataMap: TImage;
    spl1: TSplitter;
    scrlbx1: TScrollBox;
    SwapXY: TSpeedButton;
    stat1: TStatusBar;
    databox: TComboBox;
    DataMapGrid: TSpeedButton;
    FlipX: TSpeedButton;
    FlipY: TSpeedButton;
    tlb1: TToolBar;
    tlb2: TToolBar;
    Prt: TSpeedButton;
    PalBox: TComboBox;
    sbType: TSpeedButton;
    Draw: TSpeedButton;
    Step: TSpeedButton;
    cbNone: TSpeedButton;
    cbMapFormat: TComboBox;
    btn1: TToolButton;
    ToolButton1: TToolButton;
    tbGoTo: TToolButton;
    sbUp: TSpeedButton;
    sbDown: TSpeedButton;
    btn2: TToolButton;
    tbOpenMap: TToolButton;
    tbSaveMap: TToolButton;
    tbShowHexNums: TToolButton;
    tbShowGameMode: TToolButton;
    ActionList1: TActionList;
    BlockPaste: TAction;
    tbSelectTiles: TToolButton;
    Grid: TImage;
    TileSelection: TShape;
    Block: TImage;
    BlockSelection: TShape;
    BlockCopy: TAction;
    BlockSelectAll: TAction;
    procedure dLeftBtnClick(Sender: TObject);
    procedure dRightBtnClick(Sender: TObject);
    procedure WidthEditChange(Sender: TObject);
    procedure WidthEditKeyPress(Sender: TObject; var Key: Char);
    procedure HeightEditChange(Sender: TObject);
    procedure hexedChange(Sender: TObject);
    procedure hexedClick(Sender: TObject);
    procedure hexedKeyPress(Sender: TObject; var Key: Char);
    procedure DataScrollChange(Sender: TObject);
    procedure DataMapClick(Sender: TObject);
    procedure DataMapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure SwapXYClick(Sender: TObject);
    procedure databoxChange(Sender: TObject);
    procedure DataMapGridClick(Sender: TObject);
    procedure DataMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DataMapMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PrtClick(Sender: TObject);
    procedure FlipYClick(Sender: TObject);
    procedure FlipXClick(Sender: TObject);
    procedure PalBoxChange(Sender: TObject);
    procedure DrawClick(Sender: TObject);
    procedure StepClick(Sender: TObject);
    procedure sbTypeClick(Sender: TObject);
    procedure cbNoneClick(Sender: TObject);
    procedure cbMapFormatChange(Sender: TObject);
    procedure tbGoToClick(Sender: TObject);
    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
    procedure tbOpenMapClick(Sender: TObject);
    procedure tbSaveMapClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure tbShowHexNumsClick(Sender: TObject);
    procedure tbShowGameModeClick(Sender: TObject);
    procedure BlockPasteExecute(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tbSelectTilesClick(Sender: TObject);
    procedure TileSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure TileSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BlockSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BlockSelectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure EditPasteExecute(Sender: TObject);
    procedure BlockCopyExecute(Sender: TObject);
    procedure BlockSelectAllExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dataform: Tdataform;
  bMouseDown: Boolean;
  iMouseX, iMouseY: Integer;
  MouseLocation: TPoint;
  BlockLocation: TPoint;
  bBlockMouseDown: Boolean;
  B: TBitmap;
  X0, X1, Y0, Y1: Integer;
  BlockSelected: Integer;
  W, H: Integer;
  MT: array[0..15, 0..15] of Word;//Metatile
implementation

uses DTMmain, tmform, WorkSpace, palf, BitmapUtils, Math;

{$R *.dfm}

procedure Tdataform.dLeftBtnClick(Sender: TObject);
begin
 DataScroll.position := ROMdatapos - 1;
end;

procedure Tdataform.dRightBtnClick(Sender: TObject);
begin
 DataScroll.position := ROMdatapos + 1;
end;



procedure Tdataform.EditPasteExecute(Sender: TObject);
var
  Bitmap : TBitmap;
begin
 Bitmap := TBitMap.Create;
 try
   Block.Visible:= True;
   BlockSelection.Visible:= True;
   Block.Picture.RegisterClipboardFormat(cf_BitMap,TBitmap);
   Bitmap.LoadFromClipBoardFormat(cf_BitMap, ClipBoard.GetAsHandle(cf_Bitmap),0);
   Canvas.draw(0,0,Bitmap);
 finally
   Bitmap.free;
   Clipboard.Clear;
 end;
end;

procedure Tdataform.WidthEditChange(Sender: TObject);
begin
  if WidthEdit.Value > WidthEdit.MaxValue then
  begin
    WidthEdit.Value:= DTM.dWidth;
  end;
  if WidthEdit.Value < dewidth then
  begin
    WidthEdit.Value:= dewidth;
  end;
  if WidthEdit.Value * HeightEdit.Value * PatternSize > (OldRomSize - romDataPos) then
  begin
    Dec(romDataPos, DTM.dWidth * PatternSize);
  end;
 DTM.dWidth := Widthedit.Value
end;

procedure Tdataform.WidthEditKeyPress(Sender: TObject; var Key: Char);
begin
 If Key in ['-', ',', '.', '+', '='] then Key := #0;
end;

procedure Tdataform.HeightEditChange(Sender: TObject);
begin
  if HeightEdit.Value > HeightEdit.MaxValue then
  begin
    HeightEdit.Value:= DTM.dHeight;
  end;
  if HeightEdit.Value < deheight then
  begin
    HeightEdit.Value:= deheight;
  end;
  if WidthEdit.Value * HeightEdit.Value * PatternSize > (OldRomSize - romDataPos) then
  begin
  Dec(romDataPos, DTM.dHeight * PatternSize);
  end;
  DTM.dHeight := Heightedit.Value
end;

procedure Tdataform.hexedChange(Sender: TObject);
var
  i: Word; s: String; err: Boolean;
begin
 If HexEd.Tag = 1 then
 begin
  s := HexEd.Text;
  If Length(s) > 2 * PatternSize then SetLength(s, 2 * PatternSize);
  For i := 1 to Length(s) do
   If not (s[i] in ['0'..'9', 'A'..'F']) then s[i] := '0';
  HexEd.Text := s;
  If Length(s) = 2 * PatternSize then
  begin
    I := HexVal(s, err);
    Data[CDPos].Value:= I;
    BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
    BitWriter.Write(Data[CDPos].Value, 8 * PatternSize);
    Inc(CDpos);
    if romDataPos + (CDpos * PatternSize) = ROMsize then
    begin
      Dec(CDPos)
    end;

    If (CDPos >= DTM.dWidth * DTM.dHeight) then
    begin
      Dec(CDpos);
      DataScroll.Position := DataScroll.Position + 1;
      if not tTblOpened then
      begin
        DTM.Bank := Data[CDPos].Index;
      end
      else
      begin
        DTM.Bank := TileTable[Data[CDPos].Index and $FF];
      end;
    end
   else
   begin
    if not tTblOpened then
      begin
        if not tTblOpened then
        begin
          DTM.Bank := Data[CDPos].Index;
        end
        else
        begin
          DTM.Bank := TileTable[Data[CDPos].Index and $FF];
        end;
      end
    else
    begin
      DTM.Bank := TileTable[Data[CDPos].Index and $FF];
    end;
   end;
   HexEd.SelectAll;
   stat1.Panels.Items[2].Text:= IntToHex(Data[CDPos].Address, 6) + ' : ' + IntToHex(DTM.Bank, 4);
  end;
 end;
end;


procedure Tdataform.hexedClick(Sender: TObject);
begin
 If HexEd.Enabled then HexEd.SelectAll;
end;

procedure Tdataform.hexedKeyPress(Sender: TObject; var Key: Char);
begin
 Key := UpCase(Key);
 If not (Key in ['0'..'9', 'A'..'F', #8]) then Key := #0;
end;

procedure Tdataform.DataScrollChange(Sender: TObject);
begin
 DTM.RDatapos := LongInt(DataScroll.position);
 DTM.Bank := Data[CDPos].Index;
 stat1.Panels.Items[0].Text:= 'Адрес : ' + IntToHex(Data[0].Address, 6) + ' / ' + IntToHex(ROMSize, 6);
 stat1.Panels.Items[2].Text:= IntToHex(Data[CDPos].Address, 6) + ' : ' + IntToHex(DTM.Bank, 4);
end;

procedure Tdataform.DataMapClick(Sender: TObject);
var
  I: Integer;
  X, Y, XX: Integer;
begin
 If ROMopened then
 begin
  if bMouseDown then
  begin
    Exit;
  end;
  if (dmMouseX + dewidth * TileWx2) > DataMap.Width then
    dmMouseX:= DataMap.Width - dewidth * TileWx2;
  if (dmMouseY + deheight * TileHx2) > DataMap.Height then
    dmMouseY:= DataMap.Height - deheight * TileHx2;
  if bSwapXY then
    CDpos := DTM.dWidth * (dmMouseY div TileHx2) + (dmMousex div TileWx2)
  else
    CDPos := DTM.dHeight * (dmMousex div TileWx2) + (dmMouseY div TileHx2);
  stat1.Panels.Items[2].Text:= IntToHex(Data[CDPos].Address, 6) + ' : ' + IntToHex(Data[CDPos].Index, 4);
  if bDraw then
  begin
    stat1.Panels.Items[2].Text:= IntToHex(Data[CDPos].Address, 6) + ' : ' + IntToHex(DTM.Bank, 4);
    Data[CDPos].Index:= DTM.Bank;
    DTM.DataMapDraw();
  end
  else
  if bEdit then
  begin
    If not tTblOpened then
    begin
      DTM.Bank := Data[CDPos].Index;
    end
    else
    begin
      DTM.Bank := TileTable[Data[CDPos].Index and $FF];
    end;

    X:= MapXY[DTM.Bank].X * TileWx2;
    Y:= MapXY[DTM.Bank].Y * TileHx2;
    MoveTileSelection(tilemapform.TileSelection, tilemapform.TileMap.BoundsRect, X, Y, TileWx2 * TEWidth, TileHx2 * TEHeight);

    if ((DTM.Bank * TileHx2) > (tilemapform.scrlbx.VertScrollBar.Position + 256)) or ((DTM.Bank * TileHx2) < tilemapform.scrlbx.VertScrollBar.Position) then
    begin
      tilemapform.scrlbx.VertScrollBar.Position:= (DTM.Bank div TileHx2) * TileHx2;
    end;
    case dewidth of
      1:
        begin
          TileMap[0, 0]:= Data[CDPos].Index;
        end;
      2, 4, 8, 16:
        begin
          XX:= CDPos;
          if bSwapXY then
          begin
            for Y:= 0 to deheight - 1 do
            begin
              for X:= 0 to dewidth - 1 do
              begin
                TileMap[Y, X]:=  Data[XX].Index;
                Inc(xx);
              end;
              Dec(xx, dewidth);
              Inc(xx, DTM.dWidth);
            end;
          end
          else
          begin
            for Y:= 0 to deheight - 1 do
            begin
              for X:= 0 to dewidth - 1 do
              begin
                TileMap[Y, X]:=  Data[XX].Index;
                Inc(XX, DTM.dHeight);
              end;
              Dec(XX, DTM.dHeight * dewidth);
              Inc(XX);
            end;
          end;
        end;
    end;
    DTM.DrawTile(dewidth, deheight);
  end
  else
  begin
    DTM.DataMapDraw();
  end;
  dataform.hexed.Tag := 0;
  dataform.hexed.Text := IntToHex(Data[CDPos].Value, 4);
  dataform.HexEd.Tag := 1;
  FlipX.Down:= Data[CDPos].H;
  FlipY.Down:= Data[CDPos].V;
  Prt.Down:= Data[CDPos].P;
  PalBox.ItemIndex:= Data[CDPos].Pal;
  TileSelection.Left:= (DataMap.Left div TileWx2) * TileWx2 + (DataMap.Left mod TileWx2) + Data[CDPos].X * TileWx2;
  TileSelection.Top:= (DataMap.Top div TileHx2) * TileHx2 + (DataMap.Top mod TileHx2) +    Data[CDPos].Y * TileHx2;
 end;
end;


procedure Tdataform.DataMapMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
 dmMouseX := Min(X, DataMap.Width - 1);
 dmMouseY := Min(Y, DataMap.Height - 1);
 If ROMopened then
 begin
  if bMouseDown then
  begin
    X1:= dmMouseX; Y1:= dmMouseY;
    if X0 > X1 then
    begin
      Block.Left:= (DataMap.Left + X) div TileWx2 * TileWx2 + (DataMap.Left mod TileWx2);;
      BlockSelection.Left:= Block.Left;
    end;
    if Y0 > Y1 then
    begin
      Block.Top:=  (DataMap.Top + Y) div TileHx2 * TileHx2 + (DataMap.Top mod  TileHx2);;
      BlockSelection.Top:= Block.Top;
    end;
    W:=  1 + Abs(X1 - X0) div TileWx2;
    H:=  1 + Abs(Y1 - Y0) div TileHx2;
    stat1.Panels.Items[3].Text:= IntToStr(W) + ',' + IntToStr(H);
    if W = 1 then
    begin
      Block.Visible:= True;
      BlockSelection.Visible:= True;
    end;

    BlockSelected:= W * H;
    Block.Width:= W * TileWx2;
    Block.Height:= H * TileHx2;
    BlockSelection.Width:= Block.Width;
    BlockSelection.Height:= Block.Height;
    Block.Picture.Bitmap.Width:= W * TileWx2;
    Block.Picture.Bitmap.Height:= H * TileHx2;
    if (X0 > X1) or (Y0 > Y1) then
      Block.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, Block.Width, Block.Height), DataMap.Canvas, Bounds((X1 div TileWx2) * TileWx2, (Y1 div TileHx2) * TileHx2, W *TileWx2, H * TileHx2))
    else
      Block.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, Block.Width, Block.Height), DataMap.Canvas, Bounds((X0 div TileWx2) * TileWx2, (Y0 div TileHx2) * TileHx2, W *TileWx2, H * TileHx2));
  end;
   if bSwapXY then
    I  := DTM.dWidth * (dmMouseY div TileHx2)  + (dmMousex div TileWx2 )
  else
    I := (dmMouseY div TileHx2)  +   DTM.dHeight * (dmMousex div TileWx2);
  stat1.Panels.Items[2].Text:= IntToHex(Data[I].Address, 6) + ' : ' + IntToHex(Data[I].Index, 4);
  stat1.Panels.Items[1].Text:= 'X, Y : ' + IntToHex(dmMouseX div TileWx2, 3) + ' / ' + IntToHex(dmMouseY div TileWx2, 3);
 end;
end;

procedure Tdataform.SwapXYClick(Sender: TObject);
var
  X, Y, I: Integer;
begin
  bSwapXY:= not bSwapXY;
  I:= 0;
  if bSwapXY then
  begin
    for Y := 0 to DTM.dHeight - 1 do
      for X := 0 to DTM.dWidth - 1 do
      begin
        Data[I].X:= X;
        Data[I].Y:= Y;
        Inc(I);
      end;
  end
  else
  begin
    for Y := 0 to DTM.dWidth - 1 do
      for X := 0 to DTM.dHeight - 1 do
      begin
        Data[I].X:= Y;
        Data[I].Y:= X;
        Inc(I);
      end;
  end;
  DTM.DataMapDraw();
end;

procedure Tdataform.databoxChange(Sender: TObject);
begin
  case databox.ItemIndex of
    0:
      begin
        deheight:= 16;
        dewidth:= 16;
      end;
    1:
      begin
        deheight:= 8;
        dewidth:= 8;
      end;
    2:
      begin
        deheight:= 4;
        dewidth:= 4;
      end;
    3:
      begin
        deheight:= 2;
        dewidth:= 2;
      end;
    4:
      begin
        deheight:= 1;
        dewidth:= 1;
      end;
  end;
  if (dewidth > DTM.dWidth) or (deheight > DTM.dHeight) then
  begin
    dewidth:= dewidth div 2;
    deheight:= deheight div 2;
    databox.ItemIndex:= databox.ItemIndex + 1;
  end;

  TileSelection.Width:= TileWx2 * dewidth;
  TileSelection.Height:= TileHx2 * deheight;
end;

procedure Tdataform.DataMapGridClick(Sender: TObject);
begin
  bDataMapGrid:= not bDataMapGrid;
  Grid.Visible:= bDataMapGrid;
  with Grid.Picture.Bitmap do
  begin
    Canvas.Brush.Color:= clWhite;
    Canvas.FillRect(Canvas.ClipRect);
    GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clHotLight);
    GridDraw(Grid.Picture.Bitmap, 8 * TileWx2, 8 * TileHx2, clSkyBlue);
  end;
end;

procedure Tdataform.DataMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, XX, YY: Integer;
begin
  if (Button = mbLeft) and tbSelectTiles.Down  then
  begin
    X0:= X;
    Y0:= Y;
    Block.Visible:= False;
    BlockSelection.Visible:= False;
    Block.Left:= (DataMap.Left + X) div TileWx2 * TileWx2 + (DataMap.Left mod TileWx2);
    Block.Top:=  (DataMap.Top + Y) div TileHx2 * TileHx2 +  (DataMap.Top mod  TileHx2);
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
    bMouseDown:= True;
  end;
//  if ROMopened and (ssCtrl in Shift) and not bMouseDown then
//  begin
//    bMouseDown:= True;
//    iMouseX:= X div TileWx2;
//    iMouseY:= Y div TileHx2;
//    I := romDataPos + djinntilemapper.dWidth * iMouseY + iMouseX;
//    case dewidth of
//      1:
//        begin
//          MT[0, 0]:= Data[I].Index;
//          TileMap[0, 0]:= MT[0, 0];
//        end;
//      2, 4, 8, 16:
//        begin
//          for YY:= 0 to deheight - 1 do
//          begin
//            for XX:= 0 to dewidth - 1 do
//            begin
//              MT[YY, XX]:=  Data[I].Index;
//              TileMap[YY, XX]:= MT[YY, XX];
//              Inc(I);
//            end;
//            Dec(I, dewidth);
//            Inc(I, DjinnTileMapper.dWidth);
//          end;
//        end;
//    end;
//  end;
end;

procedure Tdataform.DataMapMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, J, Nums, XX, YY, W, H, PatternPos: Integer;
begin
  if RomOpened and bMouseDown and Block.Visible then
  begin
    XX:= Block.Left - DataMap.Left -  (DataMap.Left mod TileWx2);
    YY:= Block.Top - DataMap.Top   -  (DataMap.Top mod  TileHx2);
    W:= Block.Width div TileWx2;  //Количиестов тайлов по горизонтали
    H:= Block.Height div TileHx2; //Количество тайлов по вертикали
    Nums:= W * H; // Определяем кол-во выделенных тайлов
    for I := Low(SelectTiles) to High(SelectTiles) do
    begin
      SelectTiles[I].Free;
    end;
    SetLength(SelectTiles, Nums);
    if bSwapXY then
    begin
      PatternPos:= (YY div TileHx2) * DTM.dWidth + (XX div TileWx2);
      for I := 0 to H - 1 do
      begin
        for J := 0 to W - 1 do
          begin
            //Move(Data[PatternPos + J].Index, SelectTiles[I * W * PatternSize + J * PatternSize], PatternSize);
            SelectTiles[I * W + J]:= TBlock.Create;
            SelectTiles[I * W + J].Value:= Data[PatternPos + J].Value;
          end;
          Inc(PatternPos, DTM.dWidth);
      end;
    end
    else
    begin
      PatternPos:= (XX div TileWx2) * DTM.dHeight + (YY div TileHx2);
      for I := 0 to W - 1 do
      begin
        for J := 0 to H - 1 do
          begin
            SelectTiles[I * H + J]:= TBlock.Create;
            SelectTiles[I * H + J].Value:= Data[PatternPos + J].Value;
          end;
          Inc(PatternPos, DTM.dHeight);
      end;
    end;

  end;
  bMouseDown:= False;
end;
  {if ROMopened and (ssCtrl in Shift)  and bMouseDown and (X <> iMouseX) and (Y <> iMouseY)  then
  begin
    bMouseDown:= False;
    iMouseX:= X;
    iMouseY:= Y;
    if bSwapXY then
       I := romDataPos + djinntilemapper.dWidth * (iMouseY div TileHx2) * PatternSize + (iMouseX div TileWx2) * PatternSize
    else
       I := romDataPos + (iMouseY div TileHx2) * PatternSize   +   djinntilemapper.dHeight * (iMouseX div TileWx2) * PatternSize ;

    if DjinnTileMapper.MapFormat < mfGBA then
    begin
      case dewidth of
        1:
          begin
            ROMdata^[I]:= MT[0, 0];
          end;
        2, 4, 8, 16:
          begin
            if bSwapXY then
            begin
              for YY:= 0 to deheight - 1 do
              begin
                for XX:= 0 to dewidth - 1 do
                begin
                  ROMData^[I]:= MT[YY, XX];
                  Inc(I);
                end;
                Dec(I, dewidth);
                Inc(I, DjinnTileMapper.dWidth);
              end;
            end
            else
            begin
              for YY:= 0 to deheight - 1 do
              begin
                for XX:= 0 to dewidth - 1 do
                begin
                  ROMData^[I]:= MT[YY, XX];
                  Inc(I, DjinnTileMapper.dHeight);
                end;
                Dec(I, DjinnTileMapper.dHeight* dewidth);
                Inc(I);
              end;
            end;
          end;
      end;
    end
    else
    begin
      case dewidth of
      1:
        begin
          ROMdata^[I]:= MT[0, 0] shr 8;
          ROMdata^[I + 1]:= MT[0, 0];
        end;
      2, 4, 8, 16:
        begin
          if bSwapXY then
          begin
            for YY:= 0 to deheight - 1 do
            begin
              for XX:= 0 to dewidth - 1 do
              begin
                ROMData^[I]:= MT[YY, XX] shr 8;
                ROMData^[I]:= MT[YY, XX + 1];
                Inc(I, 2);
              end;
              Dec(I, dewidth * 2);
              Inc(I, DjinnTileMapper.dWidth * 2);
            end;
          end
          else
          begin
            for YY:= 0 to deheight - 1 do
            begin
              for XX:= 0 to dewidth - 1 do
              begin
                ROMData^[I]:= MT[YY, XX] shr 8;
                ROMData^[I]:= MT[YY, XX + 1];
                Inc(I, DjinnTileMapper.dHeight * 2);
              end;
              Dec(I, DjinnTileMapper.dHeight* dewidth * 2);
              Inc(I, 2);
            end;
          end;
        end;
    end;
    end;    
    DjinnTileMapper.DrawTile(dewidth, deheight);
    DjinnTileMapper.DataMapDraw();
  end;
end;  }

procedure Tdataform.PrtClick(Sender: TObject);
begin
  Data[CDPos].P:= Prt.Down;
  BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
  BitWriter.Write(Data[CDPos].Value, 8 * PatternSize);
  bTileMapChanged:= True;
  DTM.DataMapDraw();
end;

procedure Tdataform.FlipYClick(Sender: TObject);
begin
  Data[CDpos].V:= FlipY.Down;
  BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
  BitWriter.Write(Data[CDPos].Value, 8 * PatternSize);
  bTileMapChanged:= True;
  DTM.DataMapDraw();
end;

procedure Tdataform.FlipXClick(Sender: TObject);
begin
  Data[CDpos].H:= FlipX.Down;
  BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
  BitWriter.Write(Data[CDPos].Value, 8 * PatternSize);
  bTileMapChanged:= True;
  DTM.DataMapDraw();
end;

procedure Tdataform.PalBoxChange(Sender: TObject);
begin
  Data[CDpos].Pal:= PalBox.ItemIndex;
  BitWriter.Seek(Data[CDPos].Address * 8, soBeginning);
  BitWriter.Write(Data[CDPos].Value, 8 * PatternSize);
  bTileMapChanged:= True;
  DTM.DataMapDraw();
end;

procedure Tdataform.DrawClick(Sender: TObject);
begin
  bEdit:= cbNone.Down;
  bDraw:= Draw.Down;
  bStep:= Step.Down;
  bType:= sbType.Down;
end;

procedure Tdataform.StepClick(Sender: TObject);
begin
  bEdit:= cbNone.Down;
  bDraw:= Draw.Down;
  bStep:= Step.Down;
  bType:= sbType.Down;
end;

procedure Tdataform.sbTypeClick(Sender: TObject);
begin
  bEdit:= cbNone.Down;
  bDraw:= Draw.Down;
  bStep:= Step.Down;
  bType:= sbType.Down;
end;

procedure Tdataform.cbNoneClick(Sender: TObject);
begin
  bEdit:= cbNone.Down;
  bDraw:= Draw.Down;
  bStep:= Step.Down;
  bType:= sbType.Down;
end;


procedure Tdataform.BlockCopyExecute(Sender: TObject);
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
        //Bitmap.SaveToClipboardFormat(MyFormat, AData, APalette);
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
    BlockSelection.Visible:= False;
  end;
end;

procedure Tdataform.BlockPasteExecute(Sender: TObject);
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
   BlockSelection.Visible:= True;
   Block.Left:= DataMap.Left;
   Block.Top:= DataMap.Top;
   BlockSelection.Left:= Block.Left;
   BlockSelection.Top:= Block.Top;

   Clipboard.Open;
   Block.Picture.RegisterClipboardFormat(cf_BitMap,TBitmap);
   Bitmap.LoadFromClipBoardFormat(cf_BitMap,ClipBoard.GetAsHandle(cf_Bitmap),0);
   Block.Picture.Bitmap.Assign(Bitmap);
   Block.Width:= Bitmap.Width;
   Block.Height:= Bitmap.Height;
   BlockSelection.Width:= Bitmap.Width;
   BlockSelection.Height:= Bitmap.Height;

    if Clipboard.HasFormat(CF_DTMDATA) then
    begin
      Data:= Clipboard.GetAsHandle(CF_DTMDATA);
      DataPtr:= GlobalLock(Data);
      try
        // Obtain the size of the data to retrieve
        BlockCounts:= GlobalSize(Data) div SizeOf(Word);
        // Copy the data to the TDataRec field
        for I := Low(SelectTiles) to High(SelectTiles) do
        begin
          SelectTiles[I].Free;
        end;
        SetLength(SelectTiles, BlockCounts);
        for I := Low(SelectTiles) to High(SelectTiles) do
        begin
          SelectTiles[I]:= TBlock.Create;
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

procedure Tdataform.BlockSelectAllExecute(Sender: TObject);
begin
  if tbSelectTiles.Down then
  begin
    DataMapMouseDown(Self, mbLeft, [ssLeft], 0, 0);
    Block.Left:= 0;
    Block.Top:= 0;
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
    DataMapMouseMove(Self, [ssLeft], DataMap.Width - 1, DataMap.Height - 1);
    DataMapMouseUp(Self, mbLeft, [ssLeft], DataMap.Width div 2, DataMap.Height div 2);
    Block.Visible:= True;
    BlockSelection.Visible:= True;
  end;
end;

procedure Tdataform.BlockSelectionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  XX, YY, W, H, I, J, PatternPos, BankSave: Integer;
  B: TBitmap;
begin
  if Button = mbLeft then
  begin
    BlockLocation.X:= X;
    BlockLocation.Y:= Y;
    bBlockMouseDown:= True;
  end;
  if Button = mbRight then
  begin
    DataMap.Canvas.CopyRect(Bounds(Block.Left - DataMap.Left - (DataMap.Left mod TileWx2), Block.Top - DataMap.Top - (DataMap.Top mod  TileHx2), Block.Width, Block.Height), Block.Canvas, Bounds(0, 0, Block.Width, Block.Height));
    XX:= Block.Left - DataMap.Left -  (DataMap.Left mod TileWx2);
    YY:= Block.Top - DataMap.Top   -  (DataMap.Top mod  TileHx2);
    W:= Block.Width div TileWx2;  //Количиестов тайлов по горизонтали
    H:= Block.Height div TileHx2; //Количество тайлов по вертикали
    if (Length(SelectTiles) = W*H) and (Clipboard.HasFormat(CF_DTMDATA)) then
    begin
      if bSwapXY then
      begin
        PatternPos:= (YY div TileHx2) * DTM.dWidth + (XX div TileWx2);
        for I := 0 to H - 1 do
        begin
          for J := 0 to W - 1 do
          begin
            Data[PatternPos + J].Value:= SelectTiles[I * W  + J].Value;
            BitWriter.Seek(Data[PatternPos + J].Address * 8, soBeginning);
            BitWriter.Write(Data[PatternPos + J].Value, 8 * PatternSize);
          end;
          Inc(PatternPos, DTM.dWidth);
        end;
      end
      else
      begin
        PatternPos:= (XX div TileWx2) * DTM.dHeight + (YY div TileHx2);
        for I := 0 to W - 1 do
        begin
          for J := 0 to H - 1 do
            begin
              //Move(SelectTiles[I * H + J], WSMap[PatternPos + J],  PatternSize);
              Data[PatternPos + J].Value:= SelectTiles[I * H + J].Value;
              BitWriter.Seek(Data[PatternPos + J].Address * 8, soBeginning);
              BitWriter.Write(Data[PatternPos + J].Value, 8 * PatternSize);
            end;
            Inc(PatternPos, DTM.dHeight);
        end;
      end;
    end
    else
    begin
      BankSave:= Curbank;
      if bSwapXY then
      begin
        PatternPos:= (YY div TileHx2) * DTM.dWidth + (XX div TileWx2);
        for I := 0 to H - 1 do
        begin
          for J := 0 to W - 1 do
          begin
            TileMap[0, 0] := Data[PatternPos + J].Index;
            for yy := 0 to tileh - 1 do
              for xx := 0 to tilew - 1 do
              begin
                btile.Canvas.Pixels[XX, YY]:= Block.Canvas.Pixels[J * TileWx2 + XX * 2, I * TileHx2 + YY * 2];
                tx := xx;
                ty := yy;
                UpdatePixel;
              end;
          end;
          Inc(PatternPos, DTM.dWidth);
        end;
      end
      else
      begin
        PatternPos:= (XX div TileWx2) * DTM.dHeight + (YY div TileHx2);
        for I := 0 to W - 1 do
        begin
          for J := 0 to H - 1 do
          begin
            TileMap[0, 0] := Data[PatternPos + J].Index;
            for yy := 0 to tileh - 1 do
              for xx := 0 to tilew - 1 do
              begin
                btile.Canvas.Pixels[XX, YY]:= Block.Canvas.Pixels[I * TileWx2 + XX * 2, J * TileHx2 + YY * 2];
                tx := xx;
                ty := yy;
                UpdatePixel;
              end;
          end;
          Inc(PatternPos, DTM.dHeight);
        end;
      end;
      Curbank := BankSave;
      DTM.DrawTileMap();
    end;
    Block.Visible:= False;
    BlockSelection.Visible:= False;
    bTileMapChanged:= True;
    DataMapClick(Self);
  end;
end;

procedure Tdataform.BlockSelectionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  NewBlockPos: TPoint;
begin
  if bBlockMouseDown then
  begin
    NewBlockPos.X:= (Block.Left + X - BlockLocation.X) div TileWx2 * TileWx2 + (DataMap.Left mod  TileWx2);
    NewBlockPos.Y:= (Block.Top + Y - BlockLocation.Y) div TileHx2 * TileHx2 + (DataMap.Top mod  TileHx2);;
    if ((NewBlockPos.X + Block.Width) <= DataMap.Width) and (NewBlockPos.X >= DataMap.Left) then
    begin
      Block.Left:= NewBlockPos.X;
    end;
    if ((NewBlockPos.Y + Block.Height) <= DataMap.Height) and (NewBlockPos.Y >= DataMap.Top) then
    begin
      Block.Top:= NewBlockPos.Y;
    end;
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
  end;
end;

procedure Tdataform.cbMapFormatChange(Sender: TObject);
var
  I: Integer;
begin
  DTM.MapFormat:= TMapFormat(cbMapFormat.ItemIndex);
  DTM.UpdateData(romDataPos);
  case DTM.MapFormat of
    mfSingleByte, mfGBC:
      begin
        PatternSize:= 1;
        FlipX.Enabled:= False;
        FlipY.Enabled:= False;
        Prt.Enabled:=   False;
        PalBox.Enabled:= False;
      end;
    mfGBA, mfMSX, mfSNES, mfSMS:
      begin
        PalBox.Items.Clear();
        PatternSize:= 2;
        FlipX.Enabled:= True;
        FlipY.Enabled:= True;
        Prt.Enabled:= True;
        PalBox.Enabled:= True;
      end;
    mfPCE:
      begin
        PalBox.Items.Clear();
        FlipX.Enabled:= False;
        FlipY.Enabled:= False;
        Prt.Enabled:=   False;
        PalBox.Enabled:= True;
      end;
  end;
  case DTM.MapFormat of
    mfMSX:
      begin
        for I:= 0 to 3 do
        begin
          PalBox.Items.Add('Палитра ' + IntToStr(I));
        end;
        PalBox.ItemIndex:= 0;
      end;  
    mfSNES:
      begin
        for I:= 0 to 7 do
        begin
          PalBox.Items.Add('Палитра ' + IntToStr(I));
        end;
        PalBox.ItemIndex:= 0;
      end;
    mfSMS:
      begin
        for I:= 0 to 1 do
        begin
          PalBox.Items.Add('Палитра ' + IntToStr(I));
        end;
        PalBox.ItemIndex:= 0;
      end;
    mfGBA, mfPCE:
      begin
        for I:= 0 to 15 do
        begin
          PalBox.Items.Add('Палитра ' + IntToStr(I));
        end;
        PalBox.ItemIndex:= 0;
      end;
  end;
  DTM.DataMapDraw();
end;

procedure Tdataform.tbGoToClick(Sender: TObject);
begin
  DTM.GoTo2.Click();
end;

procedure Tdataform.sbUpClick(Sender: TObject);
begin
  DataScroll.position := ROMdatapos - DTM.dWidth * PatternSize;
end;

procedure Tdataform.sbDownClick(Sender: TObject);
begin
  DataScroll.position := ROMdatapos + DTM.dWidth * PatternSize;
end;

procedure Tdataform.tbOpenMapClick(Sender: TObject);
begin
  DTM.OpenItemClick(Sender);
end;

procedure Tdataform.tbSaveMapClick(Sender: TObject);
begin
  DTM.SaveItem.Click();
end;

procedure Tdataform.tbSelectTilesClick(Sender: TObject);
begin
  TileSelection.Visible:= not tbSelectTiles.Down;
  if tbSelectTiles.Down = false then
  begin
    Block.Visible:= False;
    BlockSelection.Visible:= False;
  end;
end;

procedure Tdataform.tbShowGameModeClick(Sender: TObject);
begin
  bGameMode:= not bGameMode;
  DTM.DataMapDraw();
end;

procedure Tdataform.tbShowHexNumsClick(Sender: TObject);
begin
  bDMShowHex:= not bDMShowHex;
  DTM.DataMapDraw();
end;

procedure Tdataform.TileSelectionMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  DataMapClick(Self);
end;

procedure Tdataform.TileSelectionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
 dmMouseX := TileSelection.Left + X;
 dmMouseY := TileSelection.Top + Y;
end;

procedure Tdataform.FormActivate(Sender: TObject);
begin
  bWorkSpace:= False;
  bEdit:= cbNone.Down;
  bDraw:= Draw.Down;
  bStep:= Step.Down;
  bType:= sbType.Down;
  bSwapXY:= not SwapXY.Down;
    case databox.ItemIndex of
    0:
      begin
        deheight:= 16;
        dewidth:= 16;
      end;
    1:
      begin
        deheight:= 8;
        dewidth:= 8;
      end;
    2:
      begin
        deheight:= 4;
        dewidth:= 4;
      end;
    3:
      begin
        deheight:= 2;
        dewidth:= 2;
      end;
    4:
      begin
        deheight:= 1;
        dewidth:= 1;
      end;
  end;
  if (dewidth > DTM.dWidth) or (deheight > DTM.dHeight) then
  begin
    dewidth:= dewidth div 2;
    deheight:= deheight div 2;
    databox.ItemIndex:= databox.ItemIndex + 1;
  end;
  if ROMopened then
    DTM.DataMapDraw();
end;



procedure Tdataform.FormShow(Sender: TObject);
begin
    Grid.Picture.Bitmap.Transparent := TRUE;
    Grid.Picture.Bitmap.TransparentMode := tmFixed;
    Grid.Picture.Bitmap.TransparentColor := clWhite;
end;

procedure Tdataform.BlockSelectionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bBlockMouseDown:= False;
end;

end.
