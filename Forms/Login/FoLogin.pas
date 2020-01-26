unit FoLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmLogin = class(TForm)
    Label1: TLabel;
    btnCancel: TButton;
    edtLogin: TEdit;
    Label2: TLabel;
    edtPassword: TEdit;
    btnConfirm: TButton;
    procedure btnConfirmClick(Sender: TObject);
  private
    function CheckRequiredFields : Boolean;
  public
    { Public declarations }
  end;

var
  FrmLogin: TFrmLogin;

implementation

uses Alerts, LoginBusiness;

{$R *.dfm}

function TFrmLogin.CheckRequiredFields: Boolean;
begin
  Result := False;

  if self.edtLogin.Text = '' then
  begin
    ShowErrorDialog('Empty field', 'Username field must not be empty');
    Exit;
  end;

  if self.edtPassword.Text = '' then
  begin
    ShowErrorDialog('Empty field', 'Password field must not be empty');
    Exit;
  end;

  Result := True;
end;

procedure TFrmLogin.btnConfirmClick(Sender: TObject);
begin
  if not self.CheckRequiredFields then
    Exit;

  if not LoginUser(self.edtLogin.Text, self.edtPassword.Text) then
  begin
    ShowErrorDialog('Invalid username/password');
  end
  else
  begin
    self.ModalResult := mrOk;
  end;
end;

end.
