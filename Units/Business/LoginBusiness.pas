unit LoginBusiness;

interface

function LoginUser(username, password : String) : Boolean;

implementation

uses
  SimpleDS, Hash, DatabaseConnection, GlobalObjects, UserBusiness, TypInfo,
  SysUtils;

function QueryUser(username, password : string) : TSimpleDataset;
const
  FindUserQuery = 'SELECT id ' +
                  'FROM   users '+
                  'WHERE  username = :username AND '+
                         'password = :password';
var
  queryParams : TSqlParams;
begin
  queryParams := TSqlParams.Create;
  queryParams.AddString('username', username);
  queryParams.AddString('password', getsha256(password));

  Result := DbConnection.ExecuteSelect(FindUserQuery, queryParams);
  FreeAndNil(queryParams);
end;

function LoginUser(username, password : String) : Boolean;
var
  userQueryResult : TSimpleDataSet;
  userId : String;
begin
  userQueryResult := QueryUser(username, password);

  if not Assigned(userQueryResult) then
  begin
    WriteLog('System has failed to get user information during login');
    Result := False;
    Exit;
  end;

  Result := True;

  if userQueryResult.RecordCount = 0 then
  begin
    Result := False;
  end;

  userId := userQueryResult.FieldByName('id').AsString;

  LoggedUser := GetUser(userId);

  if not Assigned(LoggedUser) then
  begin
    WriteLog('The system has failed to load the logged user with id "%s"', [userId]);
    Result := False;
  end;

  FreeAndNil(userQueryResult);
end;

end.
