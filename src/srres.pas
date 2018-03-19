unit srres;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus;

type
  Tsearchresform = class(TForm)
    searchlist: TListBox;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    N4: TMenuItem;
    PopupMenu1: TPopupMenu;
    N7: TMenuItem;
    N8: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    procedure N4Click(Sender: TObject);
    procedure searchlistDblClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  searchresform: Tsearchresform;

implementation

{$R *.dfm}

uses dtmmain, dataf;

procedure Tsearchresform.N4Click(Sender: TObject);
begin
 close;
end;

procedure Tsearchresform.searchlistDblClick(Sender: TObject);
var s: string; v: longword; err: boolean;
begin
 if searchlist.Itemindex =-1 then Exit;
 s := searchlist.Items.Strings[searchlist.ItemIndex];
 if s = '' then Exit;
 s := copy(s, 1, pos(' ', s) - 1);
 v := HexVal(s, err);
 dataform.Datascroll.Position := v;
end;

procedure Tsearchresform.N7Click(Sender: TObject);
begin
 searchlistDblClick(Sender);
end;

procedure Tsearchresform.N8Click(Sender: TObject);
var s, s2: string; c, cc: char; b, i, j, k: byte; err: boolean;
var f: textfile;
begin
 if searchlist.Itemindex =-1 then Exit;
 savedialog1.Filter := '*.tbl|*.tbl';
 savedialog1.DefaultExt := '.tbl';
 if savedialog1.Execute then
 begin
  s := searchlist.Items.Strings[searchlist.ItemIndex];
  delete(s, 1, pos(' ', s));
  s2 := copy(s, 1, pos('=', s) - 1);
  delete(s, 1, length(s2) + 1);
  s := copy(s, 1, 2);
  c := s2[1];
  b := hexval(s, err);
  Assignfile(f, savedialog1.filename);
  Rewrite(f);
  Writeln(f, 'H' + IntToHex(DTM.ROMpos, 8));
  if c in ['A'..'Z'] then
  begin
   cc := 'A';
   j := b - (byte(c) - byte('A'));
   k := j + (byte('Z') - byte('A'));
   For i := 0 to 255 do
    if (i >= j) and (i <= k)then
    begin
     Writeln(f, IntToHex(i, 2) + '='+cc);
     cc:= Char(Byte(cc) + 1);
    end Else
     Writeln(f, IntToHex(i, 2) + '=');
  end Else
  if c in ['a'..'z'] then
  begin
   cc := 'a';
   j := b - (byte(c) - byte('a'));
   k := j + (byte('z') - byte('a'));
   For i := 0 to 255 do
    if (i >= j) and (i <= k)then
    begin
     Writeln(f, IntToHex(i, 2) + '='+cc);
     cc:= Char(Byte(cc) + 1);
    end Else
     Writeln(f, IntToHex(i, 2) + '=');
  end Else
  if c in ['À'..'ß'] then
  begin
   cc := 'À';
   j := b - (byte(c) - byte('À'));
   k := j + (byte('ß') - byte('À'));
   For i := 0 to 255 do
    if (i >= j) and (i <= k)then
    begin
     Writeln(f, IntToHex(i, 2) + '='+cc);
     cc:= Char(Byte(cc) + 1);
    end Else
     Writeln(f, IntToHex(i, 2) + '=');
  end Else
  if c in ['à'..'ÿ'] then
  begin
   cc := 'à';
   j := b - (byte(c) - byte('à'));
   k := j + (byte('ÿ') - byte('à'));
   For i := 0 to 255 do
    if (i >= j) and (i <= k)then
    begin
     Writeln(f, IntToHex(i, 2) + '='+cc);
     cc:= Char(Byte(cc) + 1);
    end Else
     Writeln(f, IntToHex(i, 2) + '=');
  end;
  writeln(F, '*FF');
  writeln(F, '/00');
  Closefile(f);
 end;
 savedialog1.DefaultExt := '.rss';
 savedialog1.Filter := '*.rss|*.rss';
end;

procedure Tsearchresform.N6Click(Sender: TObject);
begin
 N7Click(Sender);
end;

procedure Tsearchresform.N9Click(Sender: TObject);
begin
 N8Click(Sender);
end;

procedure Tsearchresform.FormResize(Sender: TObject);
begin
 searchlist.Width := searchresform.Width - 8;
 searchlist.height := searchresform.height - 46;
end;

procedure Tsearchresform.N3Click(Sender: TObject);
begin
 if savedialog1.Execute then searchlist.Items.SaveToFile(savedialog1.FileName);
end;

procedure Tsearchresform.N2Click(Sender: TObject);
begin
 if opendialog1.Execute then searchlist.Items.LoadFromFile(opendialog1.FileName);
end;

procedure Tsearchresform.N10Click(Sender: TObject);
begin
 searchlist.Clear;
end;

end.
