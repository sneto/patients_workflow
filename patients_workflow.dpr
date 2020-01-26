program patients_workflow;

uses
  Forms,
  Controls,
  Main in 'Forms\Main\Main.pas' {MainForm},
  DCPbase64 in 'Units\DPCrypt\dcpbase64.pas',
  DCPconst in 'Units\DPCrypt\dcpconst.pas',
  DCPcrypt2 in 'Units\DPCrypt\dcpcrypt2.pas',
  DCPsha256 in 'Units\DPCrypt\dcpsha256.pas',
  Hash in 'Units\Helpers\Hash.pas',
  ArrayUtils in 'Units\Helpers\ArrayUtils.pas',
  DatabaseConnection in 'Units\Database\DatabaseConnection.pas',
  SqliteConnection in 'Units\Database\SqliteConnection.pas',
  Tests in 'Units\Database\Tests.pas',
  GuidHelper in 'Units\Helpers\GuidHelper.pas',
  CustomList in 'Units\Helpers\CustomList.pas',
  IntegerList in 'Units\Helpers\IntegerList.pas',
  LogHelper in 'Units\Helpers\LogHelper.pas',
  Alerts in 'Units\Helpers\Alerts.pas',
  LoginBusiness in 'Units\Business\LoginBusiness.pas',
  GlobalTypes in 'Units\Models\GlobalTypes.pas',
  UserModel in 'Units\Models\UserModel.pas',
  GlobalObjects in 'Units\Business\GlobalObjects.pas',
  ComandLineHelpers in 'Units\Helpers\ComandLineHelpers.pas',
  FileSystemHelper in 'Units\Helpers\FileSystemHelper.pas',
  FoLogin in 'Forms\Login\FoLogin.pas' {FrmLogin},
  UserBusiness in 'Units\Business\UserBusiness.pas';

{$R *.res}

begin
  Application.Initialize;

  {if TDatabaseConnectionTester.Create.ExecuteTest then
    ShowInfoDialog('Tests finalized successfully')
  else
    ShowErrorDialog('Tests failed');}

  if not InitializeApplication then
  begin
    ShowErrorDialog('The system initialization has failed.');
    Halt(1);
  end;

  WriteLog('Application started');

  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TFrmLogin, FrmLogin);
  if FrmLogin.ShowModal = mrOk then
  begin
    Application.Run;
  end;
  
  FinalizeApplication;
  WriteLog('Application finished');
end.
