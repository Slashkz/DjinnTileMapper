unit palf;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ImgList, ComCtrls, ToolWin, System.ImageList, Vcl.ExtCtrls{, System.ImageList};

type
  TPalForm = class(TForm)
    tlb1: TToolBar;
    tbOpenaPal: TToolButton;
    tbSavePal: TToolButton;
    tbHot: TImageList;
    tbCold: TImageList;
    tbDisabled: TImageList;
    scrlbx1: TScrollBox;
    PalImage: TImage;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbSavePalClick(Sender: TObject);
    procedure tbOpenaPalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  PalForm: TPalForm;

implementation

{$R *.dfm}

uses dtmmain, teditf;

procedure TPalForm.FormCreate(Sender: TObject);
begin
  PalForm.PalImage.Width:= PALETTE_WIDTH;
  PalForm.PalImage.Height:= PALETTE_HEIGHT;
  PalForm.PalImage.Picture.Bitmap.Width:= PALETTE_WIDTH;
  PalForm.PalImage.Picture.Bitmap.Height:= PALETTE_HEIGHT;
end;

procedure TPalForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX, YY, I, NewColor: Integer;
  UpdateTileSet: Boolean;
begin
  if not ROMopened then
    Exit;
  UpdateTileSet:= False;
  DTM.BigPalSet:= Y div COLOR_HEIGHT + (PalImage.Top mod COLOR_HEIGHT);
  NewColor:= DTM.BigPalSet * 16 + (X div COLOR_WIDTH);
 If button = mbleft then
 begin
  if ssdouble in shift then
  begin
   DTM.colordialog.Color := DTM.Palette[NewColor];
   If DTM.Colordialog.Execute then
   begin
    DTM.Palette[PalSet * 16 + (X div 16)] := DTM.colordialog.Color;
    if ROMopened then DTM.DrawTileMap;
   end;
  end;
  if (DTM.Foreground div 16) <> (NewColor div 16) then
  begin
    UpdateTileSet:= True;
  end;
  DTM.Foreground := NewColor mod CLR_CNT[DTM.TileType];
 end
 Else
 begin
  if (DTM.Background div 16) <>  (NewColor div 16) then
  begin
    UpdateTileSet:= True;
  end;
  DTM.Background := NewColor mod CLR_CNT[DTM.TileType];
 end;

  if UpdateTileSet then
  begin
    DTM.DrawTileMap();
    DTM.DrawTile(btile.Width div tilew, btile.Height div tileh);
  end;
end;

procedure TPalForm.tbSavePalClick(Sender: TObject);
begin
  DTM.N1.Click();
end;

procedure TPalForm.tbOpenaPalClick(Sender: TObject);
begin
  DTM.N2.Click();
end;

end.
