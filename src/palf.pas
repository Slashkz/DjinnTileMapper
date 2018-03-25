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
    scrlbx1: TScrollBox;
    PalImage: TImage;
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tbSavePalClick(Sender: TObject);
    procedure tbOpenaPalClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormHide(Sender: TObject);
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

procedure TPalForm.FormHide(Sender: TObject);
begin
  DTM.N29.Checked := False;
end;

procedure TPalForm.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XX, YY, I, NewColor: Integer;
  OldPalset: Byte;
begin
  if not ROMopened then
    Exit;
  OldPalset:= DTM.BigPalSet;
  DTM.BigPalSet:= Y div COLOR_HEIGHT + (PalImage.Top mod COLOR_HEIGHT);
  NewColor:= DTM.BigPalSet * 16 + (X div COLOR_WIDTH);
 If button = mbleft then
 begin
  if ssdouble in shift then
  begin
   DTM.colordialog.Color := DTM.Palette[NewColor];
   If DTM.Colordialog.Execute then
   begin
    DTM.Palette[DTM.BigPalSet * 16 + (X div 16)] := DTM.colordialog.Color;
    if ROMopened then DTM.DrawTileMap;
   end;
  end;
  DTM.Foreground := NewColor mod CLR_CNT[DTM.TileType];
 end
 Else
 begin
  DTM.Background := NewColor mod CLR_CNT[DTM.TileType];
 end;

  if DTM.BigPalSet <> OldPalset then
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
