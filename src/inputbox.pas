unit inputbox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;
type
  TCharset = set of Char;
type
  TInputForm = class(TForm)
    ifOKbtn: TButton;
    ifCnclbtn: TButton;
    ifLabel: TLabel;
    addrlist: TComboBox;
    procedure ifOKbtnClick(Sender: TObject);
    procedure ifCnclbtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure addrlistKeyPress(Sender: TObject; var Key: Char);
    procedure addrlistChange(Sender: TObject);
    procedure addrlistSelect(Sender: TObject);
  private
    { Private declarations }
  public
    Function InputBx(ttl, Labl: String; Charmap: tcharset; ml: Integer): String;
    function iokresult: boolean;
    { Public declarations }
  end;

var
  InputForm: TInputForm;

implementation

{$R *.dfm}

Var ok: boolean;

var chs: TCharset;

function TInputForm.InputBx(ttl, Labl: String; Charmap: tcharset;
  ml: Integer): String;
var
  I, J: Integer;
  temp: string;
begin
  chs := Charmap;
  inputform.Caption := ttl;
  inputform.ifLabel.Caption := Labl;
  //inputform.ifEdit.MaxLength := ml;
  inputform.ShowModal;
  If ok then
  begin
    if addrlist.Items.Count = 0 then
    begin
      addrlist.Items.Add(addrlist.Text);
      Result:= addrlist.Text;
      Exit;
    end;  
    for I:= 0 to addrlist.Items.Count - 1 do
    begin
      if addrlist.Items.Strings[I] = addrlist.Text then
      begin
        addrlist.Items.Exchange(0, I);
        addrlist.Text:= addrlist.Items.Strings[0];
        Break;
      end;
    end;
    if I = addrlist.Items.Count then
    begin
      addrlist.Items.Add(addrlist.Text);
      addrlist.Items.Exchange(0, I);
    end;
    Result:= addrlist.Items.Strings[0];
  end
  Else
    Result := '';
end;

function TInputForm.iokresult: boolean;
begin
  result := ok;
end;

procedure TInputForm.ifOKbtnClick(Sender: TObject);
begin
 ok := true;
 close;
end;

procedure TInputForm.ifCnclbtnClick(Sender: TObject);
begin
 close;
end;

procedure TInputForm.FormShow(Sender: TObject);
begin
 ok := false;
 addrlist.SetFocus;
 if addrlist.Text <> '' then
  ifOKbtn.Enabled:= True
 else
  ifOKbtn.Enabled:= False;
end;


procedure TInputForm.addrlistKeyPress(Sender: TObject; var Key: Char);
begin
 If Key = #13 then
 begin
  key := #0;
  If ifOkBtn.Enabled then
  begin
   Ok := True;
   Close;
  end;
 end;
 If not (key in ChS) then
  key := #0;
end;

procedure TInputForm.addrlistChange(Sender: TObject);
begin
  ifOkbtn.Enabled := (addrlist.Text <> '');
end;

procedure TInputForm.addrlistSelect(Sender: TObject);
begin
  ifOKbtn.Enabled:= True;
end;

end.
