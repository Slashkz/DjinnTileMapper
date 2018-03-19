unit texted;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ValEdit, StdCtrls, Menus;

type
  Tedtextform = class(TForm)
    ListBox1: TListBox;
    MainMenu: TMainMenu;
    textmenu: TMenuItem;
    crti: TMenuItem;
    oti: TMenuItem;
    ssti: TMenuItem;
    sati: TMenuItem;
    N6: TMenuItem;
    closei: TMenuItem;
    procedure crtiClick(Sender: TObject);
    procedure closeiClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  edtextform: Tedtextform;

implementation

uses crtrd;

{$R *.dfm}

procedure Tedtextform.crtiClick(Sender: TObject);
begin
 crtransform.showmodal;
 if crtransform.ok then
 begin
  showmessage('ok');
 end;
end;

procedure Tedtextform.closeiClick(Sender: TObject);
begin
 close;
end;

end.
