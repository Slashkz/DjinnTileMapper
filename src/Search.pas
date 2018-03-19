unit Search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin;

type
  TSearchForm = class(TForm)
    hexfed: TEdit;
    f1: TRadioButton;
    tfed: TEdit;
    f2: TRadioButton;
    FindBtn: TButton;
    CnBtn: TButton;
    hexfl: TLabel;
    tfl: TLabel;
    ntsed: TEdit;
    f3: TRadioButton;
    rsl: TLabel;
    intervalspin: TSpinEdit;
    intLab: TLabel;
    procedure CnBtnClick(Sender: TObject);
    procedure hexfedKeyPress(Sender: TObject; var Key: Char);
    procedure FormShow(Sender: TObject);
    procedure hexfedChange(Sender: TObject);
    procedure FindBtnClick(Sender: TObject);
    procedure f1Click(Sender: TObject);
    procedure f2Click(Sender: TObject);
    procedure f3Click(Sender: TObject);
    procedure hexfedClick(Sender: TObject);
    procedure tfedClick(Sender: TObject);
    procedure ntsedClick(Sender: TObject);
    procedure tfedKeyPress(Sender: TObject; var Key: Char);
    procedure ntsedKeyPress(Sender: TObject; var Key: Char);
    procedure ntsedChange(Sender: TObject);
    procedure hexfedEnter(Sender: TObject);
    procedure tfedEnter(Sender: TObject);
    procedure ntsedEnter(Sender: TObject);
    procedure intervalspinKeyPress(Sender: TObject; var Key: Char);
    procedure intervalspinChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SearchForm: TSearchForm;
  FindQ: Boolean;

implementation

{$R *.dfm}

Uses DTMmain;

procedure TSearchForm.CnBtnClick(Sender: TObject);
begin
 Close;
end;

Const HexSet: Set of Char = ['0'..'9', 'A'..'F', #8, #13];

procedure TSearchForm.hexfedKeyPress(Sender: TObject; var Key: Char);
begin
 Key := UpCase(Key);
 If not (Key in HexSet) then Key := #0;
 If Key = #13 then
 begin
  FindQ := True;
  Close;
 end;
end;

procedure TSearchForm.FormShow(Sender: TObject);
begin
 If f1.Checked then HexfEd.SetFocus Else
 If f2.Checked then TfEd.SetFocus;
 FindQ := False;
end;

procedure TSearchForm.hexfedChange(Sender: TObject);
Var i: Integer; s: String;
begin
 s := HexfEd.Text;
 For i := 1 to Length(s) do
  If not (s[i] in ['0'..'9', 'A'..'F']) then s[i] := '0';
 HexfEd.Text := s;
end;

procedure TSearchForm.FindBtnClick(Sender: TObject);
begin
 FindQ := True;
 Close;
end;

procedure TSearchForm.f1Click(Sender: TObject);
begin
 HexfEd.SetFocus;
end;

procedure TSearchForm.f2Click(Sender: TObject);
begin
 tfed.setfocus;
end;

procedure TSearchForm.f3Click(Sender: TObject);
begin
 ntsed.SetFocus;
end;

procedure TSearchForm.hexfedClick(Sender: TObject);
begin
 f1.Checked := True;
end;

procedure TSearchForm.tfedClick(Sender: TObject);
begin
 f2.Checked := True;
end;

procedure TSearchForm.ntsedClick(Sender: TObject);
begin
 If ntsed.Enabled then f3.Checked := True;
end;

procedure TSearchForm.tfedKeyPress(Sender: TObject; var Key: Char);
begin
{ If not (Key in ['A'..'Z', 'a'..'z', #8, #13]) then Key := #0;}
 If Key = #13 then
 begin
  FindQ := True;
  Close;
 end;
end;

procedure TSearchForm.ntsedKeyPress(Sender: TObject; var Key: Char);
begin
 If not (Key in DEditSet) then Key := #0;
 If Key = #13 then
 begin
  FindQ := True;
  Close;
 end;
end;

procedure TSearchForm.ntsedChange(Sender: TObject);
Var i: Integer; s: String;
begin
 s := nTsEd.Text;
 For i := 1 to Length(s) do
  If not (s[i] in DEditSet) then s[i] := 'A';
 nTsEd.Text := s;
end;

procedure TSearchForm.hexfedEnter(Sender: TObject);
begin
 F1.Checked := true;
end;

procedure TSearchForm.tfedEnter(Sender: TObject);
begin
 F2.Checked := true;
end;

procedure TSearchForm.ntsedEnter(Sender: TObject);
begin
 F3.Checked := true;
end;

procedure TSearchForm.intervalspinKeyPress(Sender: TObject; var Key: Char);
begin
 if key = '-' then key := #0;
end;

procedure TSearchForm.intervalspinChange(Sender: TObject);
begin
 If intervalspin.Value > 16 then intervalspin.Value := 15;
end;

end.
