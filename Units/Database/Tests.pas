unit Tests;

interface

uses SimpleDS, SqliteConnection;

type
  // Record to model user data
  TUser = record
    id : string[36];
    firstName   : string[40];
    lastName    : string[150];
    birtDate    : TDateTime;
    active      : Boolean;
    phoneNumber : string[12];
  end;

  // Class responsible to test the database connection
  TDatabaseConnectionTester = class
    dbConnection : TSqliteConnection;
    usersToTest : Array of TUser;
    private
      // Connects to database
      function ConnectToDatabase : Boolean;
      // Disconnects from database
      procedure DisconnectDatabase;
      // Fills the list of users to use during the tests
      procedure FillUsersList;
      // Creates the users table in database
      function CreateUsersTable : Boolean;
      // Inserts all users to database
      function InsertUsers : Boolean;
      // Selects all users from database
      function SelectAllUsers : TSimpleDataSet;
      // Check if users received from database are equals to inserted ones
      function CheckInsertedUsers : Boolean;
    public
      constructor Create;
      destructor Destroy; override;
      function ExecuteTest : Boolean;
  end;

implementation

uses SysUtils, GuidHelper, DatabaseConnection;

const DatabaseFileName = 'testdb.sqlite';

{ TDatabaseConnectionTester }

function TDatabaseConnectionTester.CheckInsertedUsers: Boolean;
var
  usersDataSet : TSimpleDataSet;
begin
  usersDataSet := SelectAllUsers;

  Result := False;

  if not Assigned(usersDataSet) then
    Exit;

  Result := usersDataSet.RecordCount = Length(self.usersToTest);

  FreeAndNil(usersDataSet);
end;

function TDatabaseConnectionTester.ConnectToDatabase: Boolean;
begin
  Result := self.dbConnection.Connect;
end;

constructor TDatabaseConnectionTester.Create;
begin
  self.dbConnection := TSqliteConnection.Create(nil, ':memory:');
  SetLength(self.usersToTest, 2);
  self.FillUsersList;
end;

function TDatabaseConnectionTester.CreateUsersTable: Boolean;
const
  CreateUsersTableComand = 'CREATE TABLE users ' +
                           '( ' +
                              'id text not null primary key, ' +
                              'firstname text not null, ' +
                              'lastname text not null, ' +
                              'birthdate date not null, ' +
                              'active int default 1 not null, ' +
                              'phonenumber text not null ' +
                           ')';
begin
  Result := self.dbConnection.Execute(CreateUsersTableComand);
end;

destructor TDatabaseConnectionTester.Destroy;
begin
  self.DisconnectDatabase;
  FreeAndNil(self.dbConnection);
  FreeAndNil(self.usersToTest);
  inherited;
end;

procedure TDatabaseConnectionTester.DisconnectDatabase;
begin
  if Assigned(self.dbConnection) and self.dbConnection.Connected then
    self.dbConnection.Disconnect;
end;

function TDatabaseConnectionTester.ExecuteTest : Boolean;
begin
  Result := False;

  if not self.ConnectToDatabase then
    Exit;

  if not self.CreateUsersTable then
  begin
    self.DisconnectDatabase;
    Exit;
  end;

  if not self.InsertUsers then
  begin
    self.DisconnectDatabase;
    Exit;
  end;

  if not self.CheckInsertedUsers then
  begin
    self.DisconnectDatabase;
    Exit;
  end;

  self.DisconnectDatabase;

  Result := True;
end;

function TDatabaseConnectionTester.InsertUsers: Boolean;
var
  i : Integer;
  insertParameters : TSqlParams;
const
  InsertStatement = 'insert into users (id, firstname, lastname, birthdate, active, phonenumber) '+
                    'values (:id, :firstname, :lastname, :birthdate, :active, :phonenumber)';
begin
  insertParameters := TSqlParams.Create;

  Result := False;

  for i := 0 to Length(self.usersToTest) - 1 do
  begin
    insertParameters.Clear;
    
    with self.usersToTest[i] do
    begin
      insertParameters.AddString('id', id);
      insertParameters.AddString('firstname', firstName);
      insertParameters.AddString('lastname', lastName);
      insertParameters.AddDateTime('birthdate', birtDate);
      insertParameters.AddBoolean('active', active);
      insertParameters.AddString('phonenumber', phoneNumber);
    end;

    if not self.dbConnection.Execute(InsertStatement, insertParameters) then
    begin
      // TODO Write Log
      Exit;
    end;
  end;

  Result := True;
end;

procedure TDatabaseConnectionTester.FillUsersList;
var
  i : Integer;
begin
  for i := 0 to Length(self.usersToTest) - 1 do
  begin
    with self.usersToTest[i] do
    begin
      id := NewGuid;
      firstName := format('User %d first name', [i + 1]);
      lastName := format('User %d last name', [i + 1]);
      birtDate := EncodeDate(1987, 10, 1 + Random(31));
      active := (i mod 2) = 0;
      phoneNumber := '123456789874';
    end;
  end;
end;

function TDatabaseConnectionTester.SelectAllUsers: TSimpleDataSet;
const
  SelectStatement = 'SELECT * FROM users';
begin
  Result := self.dbConnection.ExecuteSelect(SelectStatement);
end;

end.
