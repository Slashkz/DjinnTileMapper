unit crtrd;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, Dialogs;

type
  Tcrtransform = class(TForm)
    Button1: TButton;
    Button2: TButton;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    CheckBox1: TCheckBox;
    LabeledEdit1: TLabeledEdit;
    Edit1: TEdit;
    Label1: TLabel;
    rr: TOpenDialog;
    dd: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
    public
     ok: boolean;
     dmp: boolean;
  end;

var
  crtransform: Tcrtransform;

var num1, num2: longint; rzero: boolean; rall: boolean;

implementation

{$R *.DFM}

uses dtmmain;

procedure Tcrtransform.Button1Click(Sender: TObject);
Var s: String; v: LongInt; err: boolean; 
begin
 ok := true;
 s := uppercase(labelededit1.Text);
 if s = '' then num1 := 0 Else
 If (s[1] = 'H') then
 begin
  If length(s) >= 2 then
  begin
   Delete(s, 1, 1);
   v := HexVal(s, err);
  end Else err := true;
  If not err then num1 := v Else ShowMessage(errs);
 end Else
 begin
  Try v := StrToint(s) Except on eConvertError do
  begin
   ShowMessage(errs);
   exit;
  end end;
  num1 := v;
 end;
 s := uppercase(edit1.Text);
 if s = '' then num2 := 0 Else
 If (s[1] = 'H') then
 begin
  If length(s) >= 2 then
  begin
   Delete(s, 1, 1);
   v := HexVal(s, err);
  end Else err := true;
  If not err then num2 := v Else ShowMessage(errs);
 end Else
 begin
  Try v := StrToint(s) Except on eConvertError do
  begin
   ShowMessage(errs);
   exit;
  end end;
  num2 := v;
 end;
 rzero := checkbox1.checked;
 rall := radiobutton1.Checked;
 dd.filename := 'dump_' + labelededit1.Text + '.txt';
 if dmp then if dd.Execute then close;
 if not dmp then if rr.Execute then close;
end;

procedure Tcrtransform.Button2Click(Sender: TObject);
begin
 ok := false;
 close;
end;

procedure Tcrtransform.FormShow(Sender: TObject);
begin
 ok := false;
 labelededit1.SetFocus;
 labelededit1.Text := '';
 edit1.Text := 'h' + inttohex(DTM.rdatapos + DTM.Databank, 8);
 labelededit1.Text := edit1.Text;
end;

procedure Tcrtransform.LabeledEdit1KeyPress(Sender: TObject;
  var Key: Char);
begin
 If not (key in hChS) then key := #0;
end;

end.
