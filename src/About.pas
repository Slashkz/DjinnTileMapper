unit About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Shellapi;

type
  TAboutForm = class(TForm)
    Label1: TLabel;
    DjinnImage: TImage;
    Button1: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Image1: TImage;
    MagicteamLink: TLinkLabel;
    ChiefnetLink: TLinkLabel;
    procedure Button1Click(Sender: TObject);
    procedure MagicteamLinkLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
    procedure ChiefnetLinkLinkClick(Sender: TObject; const Link: string;
      LinkType: TSysLinkType);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AboutForm: TAboutForm;

implementation

{$R *.dfm}

procedure TAboutForm.Button1Click(Sender: TObject);
begin
 Close;
end;

procedure TAboutForm.ChiefnetLinkLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

procedure TAboutForm.MagicteamLinkLinkClick(Sender: TObject; const Link: string;
  LinkType: TSysLinkType);
begin
  ShellExecute(0, 'Open', PChar(Link), nil, nil, SW_SHOWNORMAL);
end;

end.
