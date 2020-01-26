unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TMainForm = class(TForm)
    Label1: TLabel;
    lblLoggedUser: TLabel;
    procedure btnCryptClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses Hash, GlobalObjects;

{$R *.dfm}

procedure TMainForm.btnCryptClick(Sender: TObject);
begin
  InputBox('', '', getsha256('123456'));
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  self.lblLoggedUser.Caption := LoggedUser.FirstName;
end;

end.
