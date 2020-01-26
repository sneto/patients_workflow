unit UserBusiness;

interface

uses UserModel;

function GetUser(id : String) : TUser;

implementation

uses GlobalObjects, DatabaseConnection, SysUtils, SimpleDS, DB;

function IsoStrToDate(isoDateStr : String) : TDateTime;
var
  format : TFormatSettings;
begin
  format.ShortDateFormat := 'yyyy-mm-dd';
  format.DateSeparator := '/';
  format.LongTimeFormat := 'hh:nn:ss.zzz';
  format.TimeSeparator := ':';

  Result := StrToDate(isoDateStr, format);
end;

function GetUser(id : String) : TUser;
const
  UserQuery = 'SELECT id, firstname, lastname, birthdate, active, phonenumber, username, password '+
              'FROM   users WHERE id = :id';
var
  queryParams : TSqlParams;
  queryResult : TSimpleDataset;
begin
  queryParams := TSqlParams.Create;
  queryParams.AddString('id', id);

  queryResult := DbConnection.ExecuteSelect(UserQuery, queryParams);

  Result := nil;

  if Assigned(queryResult) then
  begin
    Result := TUser.Create;
    with Result do
    begin
      Id := queryResult.FieldByName('id').AsString;
      FirstName := queryResult.FieldByName('firstname').AsString;
      LastName := queryResult.FieldByName('lastname').AsString;
      BirtDate := queryResult.FieldByName('birthdate').AsDateTime;
      Active := queryResult.FieldByName('active').AsBoolean;
      PhoneNumber := queryResult.FieldByName('phonenumber').AsString;
      UserName := queryResult.FieldByName('username').AsString;
      Password := queryResult.FieldByName('password').AsString;
    end;
  end;

  FreeAndNil(queryParams);
end;

end.
