unit BookmarkInputForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  Tf_bookmark = class(TForm)
    Edit1: TEdit;
    BtnOk: TButton;
    btnCancel: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
    function GetBookmark(S: String): string;
  end;

var
  f_bookmark: Tf_bookmark;
  IsBookmarkAccepted: Boolean = false;
implementation

{$R *.dfm}

{ Tf_bookmark }

function Tf_bookmark.GetBookmark(S: String): string;
begin
  Edit1.Text:= S;
  if f_bookmark.ShowModal() = mrOk then
  begin
    IsBookmarkAccepted:= True;
  end
  else
  begin
    IsBookmarkAccepted:= False;
  end;
  Result:= Edit1.Text;
end;

end.
