unit WorkSpace;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ImgList, ComCtrls, ExtCtrls, ToolWin, DTMmain, Buttons,
  StdCtrls, Spin, Math, System.ImageList, Vcl.XPMan, clipbrd, Vcl.StdActns,
  System.Actions, Vcl.ActnList;

type
  TWSForm = class(TForm)
    tlb1: TToolBar;
    stat1: TStatusBar;
    WorkSpace: TImage;
    scrlbx1: TScrollBox;
    tbImport: TToolButton;
    tbExport: TToolButton;
    tbOpenMap: TToolButton;
    tbSaveMap: TToolButton;
    OpenMap: TOpenDialog;
    SaveMap: TSaveDialog;
    tbGrid: TToolButton;
    sbEdit: TSpeedButton;
    sbDraw: TSpeedButton;
    sbType: TSpeedButton;
    sbStep: TSpeedButton;
    btn1: TToolButton;
    tbSwap: TSpeedButton;
    sbInit: TSpeedButton;
    sbClear: TSpeedButton;
    seHeight: TSpinEdit;
    seWidth: TSpinEdit;
    tlb2: TToolBar;
    cbRectSize: TComboBox;
    SaveImage: TToolButton;
    SaveDialog2: TSaveDialog;
    TileSelection: TShape;
    Grid: TImage;
    Block: TImage;
    BlockSelection: TShape;
    tbSelectTiles: TToolButton;
    XPManifest1: TXPManifest;
    ActionList1: TActionList;
    BlockCopy: TAction;
    BlockPaste: TAction;
    BlockSelectAll: TAction;
    procedure FormResize(Sender: TObject);
    procedure WorkSpaceMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure WorkSpaceClick(Sender: TObject);
    procedure WorkSpaceMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure WorkSpaceMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbGridClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure sbEditClick(Sender: TObject);
    procedure sbDrawClick(Sender: TObject);
    procedure sbTypeClick(Sender: TObject);
    procedure sbStepClick(Sender: TObject);
    procedure tbSwapClick(Sender: TObject);
    procedure sbClearClick(Sender: TObject);
    procedure sbInitClick(Sender: TObject);
    procedure seWidthChange(Sender: TObject);
    procedure seWidthKeyPress(Sender: TObject; var Key: Char);
    procedure cbRectSizeChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SaveImageClick(Sender: TObject);
    procedure tbOpenMapClick(Sender: TObject);
    procedure tbImportClick(Sender: TObject);
    procedure tbExportClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TileSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure TileSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbSelectTilesClick(Sender: TObject);
    procedure BlockSelectionMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BlockSelectionMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BlockCopyExecute(Sender: TObject);
    procedure BlockPasteExecute(Sender: TObject);
    procedure BlockSelectAllExecute(Sender: TObject);
    procedure tbSaveMapClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WSForm: TWSForm;
  iMouseX: Integer;
  iMouseY: Integer;
  Index: Integer;
  bMouseDown: Boolean;
  bBlockMouseDown: Boolean;
  X0, X1, Y0, Y1: Integer;
  MouseLocation: TPoint;
  BlockLocation: TPoint;
  BlockSelected, W, H: Integer;
  MT: array[0..15, 0..15] of Word;//Metatile

implementation

uses tmform, BitmapUtils;

{$R *.dfm}

procedure TWSForm.FormResize(Sender: TObject);
begin
//
end;

procedure TWSForm.WorkSpaceMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  I: Integer;
begin
 iMouseX := Min(X, WorkSpace.Width - 1);
 iMouseY := Min(Y, WorkSpace.Height - 1);
 If ROMopened then
 begin
   if bMouseDown then
    begin
      X1:= iMouseX; Y1:= iMouseY;
      if X0 > X1 then
      begin
        Block.Left:= (WorkSpace.Left + X) div TileWx2 * TileWx2 + (WorkSpace.Left mod TileWx2);;
        BlockSelection.Left:= Block.Left;
      end;
      if Y0 > Y1 then
      begin
        Block.Top:=  (WorkSpace.Top + Y) div TileHx2 * TileHx2 + (WorkSpace.Top mod  TileHx2);;
        BlockSelection.Top:= Block.Top;
      end;
      W:=  1 + Abs(X1 - X0) div TileWx2;
      H:=  1 + Abs(Y1 - Y0) div TileHx2;

      if W = 1 then
      begin
        Block.Visible:= True;
        BlockSelection.Visible:= True;
      end;
      Stat1.Panels.Items[3].Text:= IntToStr(W) + ',' + IntToStr(H);
      BlockSelected:= W * H;
      Block.Width:= W * TileWx2;
      Block.Height:= H * TileHx2;
      BlockSelection.Width:= Block.Width;
      BlockSelection.Height:= Block.Height;
      Block.Picture.Bitmap.Width:= W * TileWx2;
      Block.Picture.Bitmap.Height:= H * TileHx2;
      if (X0 > X1) or (Y0 > Y1) then
        Block.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, Block.Width, Block.Height), WorkSpace.Canvas, Bounds((X1 div TileWx2) * TileWx2, (Y1 div TileHx2) * TileHx2, W *TileWx2, H * TileHx2))
      else
        Block.Picture.Bitmap.Canvas.CopyRect(Bounds(0, 0, Block.Width, Block.Height), WorkSpace.Canvas, Bounds((X0 div TileWx2) * TileWx2, (Y0 div TileHx2) * TileHx2, W *TileWx2, H * TileHx2));
    end;

  stat1.Panels.Items[1].Text:= 'X, Y : ' + IntToHex(iMouseX div TileWx2, 3) + ' / ' + IntToHex(iMouseY div TileHx2, 3);

  if bSwapXY then
    I  := iWSWidth * (iMouseY div TileHx2)  + (iMousex div TileWx2 )
  else
     I := (iMouseY div TileHx2)  +   iWSHeight * (iMousex div TileWx2);
   stat1.Panels.Items[2].Text:= IntToHex(WSMap[I].Address, 6) + ' : ' + IntToHex(WSMap[I].Index, 4)
 end;
end;

procedure TWSForm.WorkSpaceClick(Sender: TObject);
var
  X, Y, XX: Integer;
begin
 If ROMopened then
 begin
  if (iMouseX + wswidth * TileWx2) > WorkSpace.Width then
    iMouseX:= WorkSpace.Width - wswidth * TileWx2;
  if (iMouseY + wsheight * TileHx2) > WorkSpace.Height then
    iMouseY:= WorkSpace.Height - wsheight * TileHx2;
  if bSwapXY then
    iWSPos := iWSWidth * (iMouseY div TileHx2) + (iMousex div TileWx2)
  else
    iWSPos := (iMouseY div TileHx2) + iWSHeight * (iMousex div TileWx2);
  stat1.Panels.Items[2].Text:= IntToHex(WSMap[iWSPos].Address, 6) + ' : ' + IntToHex(DTM.Bank, 4);
  if bDraw then
  begin
    WSMap[iWSPos].Index := DTM.Bank;
    DTM.DataMapDraw();
  end
  else
  if bEdit then  //bNone = bEdit
  begin
    If not tTblOpened then
    begin
      DTM.Bank := WSMap[iWSPos].Index;
    end
    else
      DTM.Bank := TileTable[WSMap[iWSPos].Index and $FF];

    X:= MapXY[DTM.Bank].X * TileWx2;
    Y:= MapXY[DTM.Bank].Y * TileHx2;
    MoveTileSelection(tilemapform.TileSelection, tilemapform.TileMap.BoundsRect, X, Y, TileWx2 * TEWidth, TileHx2 * TEHeight);

    if ((DTM.Bank * TileHx2) > (tilemapform.scrlbx.VertScrollBar.Position + 256)) or ((DTM.Bank * TileHx2) < tilemapform.scrlbx.VertScrollBar.Position) then
    begin
      tilemapform.scrlbx.VertScrollBar.Position:= (DTM.Bank div TileHx2) * TileHx2;
    end;
    case wswidth of
      1:
        begin
          TileMap[0, 0]:= WSMap[iWSPos].Index;
        end;
      2, 4, 8, 16:
        begin
          XX:= iWSPos;
          if bSwapXY then
          begin
            for Y:= 0 to wsheight - 1 do
            begin
              for X:= 0 to wswidth - 1 do
              begin
                TileMap[Y, X]:=  WSMap[XX].Index;
                Inc(XX);
              end;
              Dec(XX, wswidth);
              Inc(XX, iWSWidth);
            end;
          end
          else
          begin
            for Y:= 0 to wsheight - 1 do
            begin
              for X:= 0 to wswidth - 1 do
              begin
                TileMap[Y, X]:=  WSMap[XX].Index;
                Inc(XX, iWSHeight);
              end;
              Dec(XX, iWSHeight * wswidth);
              Inc(XX);
            end;
          end;
       end;
    end;
    DTM.DrawTile(wswidth, wsheight);
  end
  else
  begin
    DTM.DataMapDraw();
  end;
   TileSelection.Left:= (WorkSpace.Left div TileWx2) * TileWx2 + (WorkSpace.Left mod TileWx2) + WSMap[iWSPos].X * TileWx2;
   TileSelection.Top:= (WorkSpace.Top div TileHx2) * TileHx2 + (WorkSpace.Top mod TileHx2) + WSMap[iWSPos].Y * TileHx2;
 end;
end;

procedure TWSForm.WorkSpaceMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and tbSelectTiles.Down  then
  begin
    X0:= X;
    Y0:= Y;
    Block.Left:= (WorkSpace.Left + X) div TileWx2 * TileWx2 + (WorkSpace.Left mod TileWx2);
    Block.Top:=  (WorkSpace.Top + Y) div TileHx2 * TileHx2 +  (WorkSpace.Top mod  TileHx2);
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
    Block.Visible:= False;
    BlockSelection.Visible:= False;
    bMouseDown:= True;
  end;
end;

procedure TWSForm.WorkSpaceMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  I, J, Nums, XX, YY, W, H, PatternPos: Integer;
begin
  if RomOpened and bMouseDown and Block.Visible then
  begin
    XX:= Block.Left - WorkSpace.Left -  (WorkSpace.Left mod TileWx2);
    YY:= Block.Top - WorkSpace.Top   -  (WorkSpace.Top mod  TileHx2);
    W:= Block.Width div TileWx2;  //Количиестов тайлов по горизонтали
    H:= Block.Height div TileHx2; //Количество тайлов по вертикали
    Nums:= W * H; // Определяем кол-во выделенных тайлов
    SetSize(SelectTiles, Nums);
    if bSwapXY then
    begin
      PatternPos:= (YY div TileHx2) * iWSWidth + (XX div TileWx2);
      for I := 0 to H - 1 do
      begin
        for J := 0 to W - 1 do
          begin
            SelectTiles[I * W + J].Index:= WSMap[PatternPos + J].Index;
          end;
          Inc(PatternPos, iWSWidth);
      end;
    end
    else
    begin
      PatternPos:= (XX div TileWx2) * iWSHeight + (YY div TileHx2);
      for I := 0 to W - 1 do
      begin
        for J := 0 to H - 1 do
          begin
            SelectTiles[I * H + J].Value:= WSMap[PatternPos + J].Value;
          end;
          Inc(PatternPos, iWSHeight);
      end;
    end;

  end;
  bMouseDown:= False;
end;

procedure TWSForm.tbGridClick(Sender: TObject);
begin
  bWorkSpaceGrid:= not bWorkSpaceGrid;
  Grid.Visible:= bWorkSpaceGrid;
  with Grid.Picture.Bitmap do
  begin
    Canvas.Brush.Style:= bsSolid;
    Canvas.Brush.Color:= clWhite;
    Canvas.FillRect(Bounds(0, 0, Grid.Width, Grid.Height));
    GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clHotLight);
    GridDraw(Grid.Picture.Bitmap, 8 * TileWx2, 8 * TileHx2, clSkyBlue);
  end;
  //DjinnTileMapper.DataMapDraw();
end;

procedure TWSForm.FormActivate(Sender: TObject);
begin
  bWorkSpace:= True;
  bEdit:= sbEdit.Down;
  bDraw:= sbDraw.Down;
  bStep:= sbStep.Down;
  bType:= sbType.Down;
  bSwapXY:= not tbSwap.Down;

  case cbRectSize.ItemIndex of
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
  if (dewidth > iWSWidth) or (deheight > iWSHeight) then
  begin
    dewidth:= dewidth div 2;
    deheight:= deheight div 2;
    cbRectSize.ItemIndex:= cbRectSize.ItemIndex + 1;
  end;
  wsheight:= deheight;
  wswidth:= dewidth;
end;

procedure TWSForm.sbEditClick(Sender: TObject);
begin
  bEdit:= sbEdit.Down;
  bDraw:= sbDraw.Down;
  bStep:= sbStep.Down;
  bType:= sbType.Down;
end;

procedure TWSForm.sbDrawClick(Sender: TObject);
begin
  bEdit:= sbEdit.Down;
  bDraw:= sbDraw.Down;
  bStep:= sbStep.Down;
  bType:= sbType.Down;
end;

procedure TWSForm.sbTypeClick(Sender: TObject);
begin
  bEdit:= sbEdit.Down;
  bDraw:= sbDraw.Down;
  bStep:= sbStep.Down;
  bType:= sbType.Down;
end;

procedure TWSForm.sbStepClick(Sender: TObject);
begin
  bEdit:= sbEdit.Down;
  bDraw:= sbDraw.Down;
  bStep:= sbStep.Down;
  bType:= sbType.Down;
end;

procedure TWSForm.tbSaveMapClick(Sender: TObject);
begin
//
end;

procedure TWSForm.tbSelectTilesClick(Sender: TObject);
begin
  TileSelection.Visible:= not tbSelectTiles.Down;
  if tbSelectTiles.Down = false then
  begin
    Block.Visible:= False;
    BlockSelection.Visible:= False;
  end;
end;

procedure TWSForm.tbSwapClick(Sender: TObject);
var
  X, Y, I: Integer;
begin
  bSwapXY:= not bSwapXY;
  I:= 0;
  if bSwapXY then
  begin
    for Y := 0 to iWSHeight - 1 do
      for X := 0 to iWSWidth - 1 do
      begin
        WSMap[I].X:= X;
        WSMap[I].Y:= Y;
        Inc(I);
      end;
  end
  else
  begin
    for Y := 0 to iWSWidth - 1 do
      for X := 0 to iWSHeight - 1 do
      begin
        WSMap[I].X:= Y;
        WSMap[I].Y:= X;
        Inc(I);
      end;
  end;
  DTM.DataMapDraw();
end;

procedure TWSForm.TileSelectionMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  WorkSpaceClick(Self);
end;

procedure TWSForm.TileSelectionMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  iMouseX := TileSelection.Left + X;
  iMouseY := TileSelection.Top + Y;
end;

procedure TWSForm.sbClearClick(Sender: TObject);
var
  I: Integer;
begin
  if ROMopened then
  begin
    for I := Low(WSMap) to High(WSMap) do
    begin
      WSMap[I].Value:= 0;
    end;
    DTM.DataMapDraw();
  end;
end;

procedure TWSForm.sbInitClick(Sender: TObject);
var
  I: Integer;
begin
  if ROMopened then
  begin
    for I := Low(WSMap) to High(WSMap) do
    begin
      WSMap[I].Value:= I;
    end;
    DTM.DataMapDraw();
  end;
end;

procedure TWSForm.seWidthChange(Sender: TObject);
var
  W, H, I, X, Y: Integer;
  Temp: array of Word;
begin
    if seWidth.Value < wswidth then
    begin
      seWidth.Value:= wswidth;
    end;
    if seHeight.Value < wsheight then
    begin
      seHeight.Value:= wsheight;
    end;
    W:= seWidth.Value;
    H:= seHeight.Value;

    if Length(WSMap) <> W * H then
    begin
      //SetLength(Temp, Length(WSMap));
//      for I := Low(WSMap) to High(WSMap) do
//      begin
//        Temp[I]:=  WSMap[I].Value;
//        WSMap[I].Free;
//      end;
      SetSize(WSMap, W * H);
      I:= 0;
      if bSwapXY then
      begin
        for Y:= 0 to H - 1 do
        begin
          for X := 0 to W - 1 do
          begin
 //           WSmap[I].Value:= Temp[I];
            WSMap[I].X:= X;
            WSMap[I].Y:= Y;
            WSMap[I].Address:= Y * W * PatternSize + X * PatternSize;
            Inc(I);
          end;
        end;
      end
      else
      begin
        for Y:= 0 to H - 1 do
        begin
          for X := 0 to W - 1 do
          begin
//            WSmap[I].Value:= Temp[I];
            WSMap[I].X:= Y;
            WSMap[I].Y:= X;
            WSMap[I].Address:= X * H * PatternSize + Y * PatternSize;
            Inc(I);
          end;
        end;
      end;
      iWSWidth:= W;
      iWSHeight:= H;
      stat1.Panels.Items[0].Text:= 'Адрес : 000000 / ' + IntToHex(iWSWidth * iWSHeight * PatternSize, 6);
      WorkSpace.Picture.Bitmap.Width:= W * TileWx2;
      WorkSpace.Picture.Bitmap.Height:= H * TileHx2;
      WorkSpace.Width:= W * TileWx2 ;
      WorkSpace.Height:= H * TileHx2;
      Grid.Width:= WorkSpace.Width;
      Grid.Height:= WorkSpace.Height;
      Grid.Picture.Bitmap.Width:= WorkSpace.Width;
      Grid.Picture.Bitmap.Height:= WorkSpace.Height;
      with Grid.Picture.Bitmap do
      begin
        Canvas.Brush.Color:= clWhite;
        Canvas.FillRect(Canvas.ClipRect);
      end;
      GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clHotLight);
      GridDraw(Grid.Picture.Bitmap, TileWx2 * 8, TileHx2 * 8, clSkyBlue);
      DTM.DataMapDraw();
    end;
end;

procedure TWSForm.seWidthKeyPress(Sender: TObject; var Key: Char);
begin
  If not (Key in ['0'..'9']) then Key := #0;
end;


procedure TWSForm.BlockCopyExecute(Sender: TObject);
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
    BlockSelection.Visible:= False;
  end;
end;

procedure TWSForm.BlockPasteExecute(Sender: TObject);
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
   Block.Left:= WorkSpace.Left;
   Block.Top:= WorkSpace.Top;
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
//        for I := Low(SelectTiles) to High(SelectTiles) do
//        begin
//          SelectTiles[I].Free;
//        end;
        SetSize(SelectTiles, BlockCounts);
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

procedure TWSForm.BlockSelectAllExecute(Sender: TObject);
begin
  if tbSelectTiles.Down then
  begin
    WorkSpaceMouseDown(Self, mbLeft, [ssLeft], 0, 0);
    Block.Left:= 0;
    Block.Top:= 0;
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
    WorkSpaceMouseMove(Self, [ssLeft], WorkSpace.Width - 1, Workspace.Height - 1);
    WorkSpaceMouseUp(Self, mbLeft, [ssLeft], WorkSpace.Width div 2, Workspace.Height div 2);
    Block.Visible:= True;
    BlockSelection.Visible:= True;
  end;

end;

procedure TWSForm.BlockSelectionMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX, YY, W, H, I, J, PatternPos: Integer;
begin
  if Button = mbLeft then
  begin
    BlockLocation.X:= X;
    BlockLocation.Y:= Y;
    bBlockMouseDown:= True;
  end;
  if Button = mbRight then
  begin
    WorkSpace.Canvas.CopyRect(Bounds(Block.Left - WorkSpace.Left - (WorkSpace.Left mod TileWx2), Block.Top - WorkSpace.Top - (WorkSpace.Top mod  TileHx2), Block.Width, Block.Height), Block.Canvas, Bounds(0, 0, Block.Width, Block.Height));
    XX:= Block.Left - WorkSpace.Left -  (WorkSpace.Left mod TileWx2);
    YY:= Block.Top - WorkSpace.Top   -  (WorkSpace.Top mod  TileHx2);
    W:= Block.Width div TileWx2;  //Количиестов тайлов по горизонтали
    H:= Block.Height div TileHx2; //Количество тайлов по вертикали

    if Length(SelectTiles) = W * H then
    begin
      if bSwapXY then
      begin
        PatternPos:= (YY div TileHx2) * iWSWidth + (XX div TileWx2);
        for I := 0 to H - 1 do
        begin
          for J := 0 to W - 1 do
            begin
              WSMap[PatternPos + J ].Value:= SelectTiles[I * W + J].Value;
              //Move(SelectTiles[I * W * PatternSize + J * PatternSize], WSMap[PatternPos + J * PatternSize], PatternSize);
            end;
            Inc(PatternPos, iWSWidth);
        end;
      end
      else
      begin
        PatternPos:= (XX div TileWx2) * iWSHeight + (YY div TileHx2);
        for I := 0 to W - 1 do
        begin
          for J := 0 to H - 1 do
            begin
              //Move(SelectTiles[I * H + J], WSMap[PatternPos + J],  PatternSize);
              WSMap[PatternPos + J].Value:= SelectTiles[I * H + J].Value;
            end;
            Inc(PatternPos, iWSHeight);
        end;
      end;
    end;
    Block.Visible:= False;
    BlockSelection.Visible:= False;
    WorkSpaceClick(Self);
  end;
end;

procedure TWSForm.BlockSelectionMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  NewBlockPos: TPoint;
begin
  if bBlockMouseDown then
  begin
    NewBlockPos.X:= (Block.Left + X - BlockLocation.X) div TileWx2 * TileWx2 + (WorkSpace.Left mod  TileWx2);
    NewBlockPos.Y:= (Block.Top + Y - BlockLocation.Y) div TileHx2 * TileHx2 + (WorkSpace.Top mod  TileHx2);;
    if ((NewBlockPos.X + Block.Width) <= WorkSpace.Width) and (NewBlockPos.X >= WorkSpace.Left) then
    begin
      Block.Left:= NewBlockPos.X;
    end;
    if ((NewBlockPos.Y + Block.Height) <= WorkSpace.Height) and (NewBlockPos.Y >= WorkSpace.Top) then
    begin
      Block.Top:= NewBlockPos.Y;
    end;
    BlockSelection.Left:= Block.Left;
    BlockSelection.Top:= Block.Top;
  end;
end;

procedure TWSForm.BlockSelectionMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  bBlockMouseDown:= False;
end;

procedure TWSForm.cbRectSizeChange(Sender: TObject);
begin
  case cbRectSize.ItemIndex of
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
  if (dewidth > iWSWidth) or (deheight > iWSHeight) then
  begin
    dewidth:= dewidth div 2;
    deheight:= deheight div 2;
    wswidth:= dewidth;
    wsheight:= deheight;
    cbRectSize.ItemIndex:= cbRectSize.ItemIndex + 1;
  end;
  wsheight:= deheight;
  wswidth:= dewidth;
  TileSelection.Width:= TileWx2 * wswidth;
  TileSelection.Height:= TileHx2 * wsheight;
  WorkSpaceClick(Self);
end;

procedure TWSForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DTM.ShowWorkSpace.Checked:= False;
end;

procedure TWSForm.FormCreate(Sender: TObject);
begin
    Grid.Picture.Bitmap.Transparent := TRUE;
    Grid.Picture.Bitmap.TransparentMode := tmFixed;
    Grid.Picture.Bitmap.TransparentColor := clWhite;
end;

procedure TWSForm.SaveImageClick(Sender: TObject);
begin
  if SaveDialog2.Execute then
    WorkSpace.Picture.Bitmap.SaveToFile(SaveDialog2.FileName);
end;

procedure TWSForm.tbOpenMapClick(Sender: TObject);
var
  W, H, X, Y: Integer;
  F: TFileStream;
  E: string;
  FileSize: Integer;
  I: Integer;
  Value: Word;
begin
  if OpenMap.Execute then
  begin
    E:= ExtractFileExt(OpenMap.FileName);
    F:= TFileStream.Create(OpenMap.FileName, fmOpenRead);
    if LowerCase(E) = '.dtm' then
    begin
      PatternSize:= 1;
      DTM.MapFormat:= mfSingleByte;
      F.ReadBuffer(W, 1); Inc(W);
      F.ReadBuffer(H, 1); Inc(H);
      FileSize:= F.Size;
      Dec(FileSize, 2);
      if FileSize <> W * H then
      begin
        F.Free;
        MessageDlg('Неверный размер карты', mtError, [mbOK], 0);
        Exit;
      end;
      seWidth.Value:= W;
      seHeight.Value:= H;
      for I := Low(WSMap) to High(WSMap) do
      begin
        WSMap[I].Free;
      end;
      I:= 0;
      for Y := 0 to H - 1 do
      begin
        for X := 0 to W - 1 do
        begin
          F.Read(Value, 1);
          WSMap[I]:= TBlock.Create;
          WSMap[I].Value:= Value;
        end;
      end;
    end;
    F.Free;
    WorkSpace.OnClick(Self);
  end;  
end;

procedure TWSForm.tbImportClick(Sender: TObject);
begin
  if ROMopened then
  begin
    if (OldRomSize - romDataPos) >= Length(WSMap) then
    begin

      //DjinnTileMapper.DataMapDraw();
    end
    else
    begin
      MessageDlg('Невозможно извлечь данные за пределами ROM файла!', mtError, [mbOK], 0);
    end;
  end;
end;

procedure TWSForm.tbExportClick(Sender: TObject);
begin
  if ROMopened then
  begin
    if (OldRomSize - romDataPos) >= Length(WSMap) then
    begin
      //Move(WSMap[0], ROMData^[romDataPos], Length(WSMap));
      //bWorkSpace:= False;
      //DjinnTileMapper.DataMapDraw();
      //bWorkSpace:= True;
    end
    else
    begin
      MessageDlg('Невозможно вставить данные за пределы ROM файла!', mtError, [mbOK], 0);
    end;
  end;
end;



procedure TWSForm.FormShow(Sender: TObject);
begin
  if ((iWSWidth div tilew) <> 8) or ((iWSHeight div tileh) <> tileh) then
  begin
    WorkSpace.Width:= iWSWidth * TileWx2;
    WorkSpace.Height:= iWSHeight * TileHx2;
    WorkSpace.Picture.Bitmap.Width:= iWSWidth * TileWx2;
    WorkSpace.Picture.Bitmap.Height:= iWSHeight * TileHx2;
    Grid.Width:= WorkSpace.Width;
    Grid.Height:= WorkSpace.Height;
    Grid.Picture.Bitmap.Width:= WorkSpace.Width;
    Grid.Picture.Bitmap.Height:= WorkSpace.Height;
    GridDraw(Grid.Picture.Bitmap, TileWx2, TileHx2, clHotLight);
    GridDraw(Grid.Picture.Bitmap, TileWx2 * 8, TileHx2 * 8, clSkyBlue);
  end;    
end;

procedure TWSForm.FormPaint(Sender: TObject);
begin
if ROMopened then
  DTM.DataMapDraw();
end;

end.
