unit Alerts;

interface

// Shows an error message dialog with fixed title (Error)
procedure ShowErrorDialog(msg : String); overload;
// Shows an error message dialog
procedure ShowErrorDialog(title, msg : String); overload;

// Shows an information message dialog with fixed title (Information)
procedure ShowInfoDialog(msg : String); overload;
// Shows an information message dialog
procedure ShowInfoDialog(title, msg : String); overload;

// Shows an question message dialog with fixed title (Question) and returns a boolean value indicating whether the users clicked yes
function ShowQuestionDialog(msg : String) : Boolean; overload;
// Shows an question message dialog and returns a boolean value indicating whether the users clicked yes
function ShowQuestionDialog(title, msg : String) : Boolean; overload;

implementation

uses Dialogs, Forms;

function ShowDialog(title, msg : String; dialogType: TMSgDlgType; buttons: TMsgDlgButtons) : TMsgDlgBtn;
var
  dialog : TForm;
begin
  dialog := CreateMessageDialog(msg, dialogType, buttons);
  dialog.Caption := title;
  Result := TMsgDlgBtn(dialog.ShowModal);
end;

procedure ShowErrorDialog(msg : String);
begin
  ShowErrorDialog('Error', msg);
end;

procedure ShowErrorDialog(title, msg : String);
begin
  ShowDialog(title, msg,mtError, [mbOK]);
end;

procedure ShowInfoDialog(msg : String);
begin
  ShowInfoDialog('Information', msg);
end;

procedure ShowInfoDialog(title, msg : String);
begin
  ShowDialog(title, msg,mtInformation, [mbOK]);
end;

function ShowQuestionDialog(msg : String) : Boolean;
begin
  Result := ShowQuestionDialog('Error', msg);
end;

function ShowQuestionDialog(title, msg : String) : Boolean;
begin
  Result := ShowDialog(title, msg,mtInformation, [mbYes, mbNo]) = mbYes;
end;

end.
