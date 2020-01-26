unit GlobalObjects;

interface

uses UserModel, DatabaseConnection;

procedure WriteLog(logMessage : String); overload;
procedure WriteLog(logMessage : String; formatParams : array of Const); overload;
function InitializeApplication : Boolean;
procedure FinalizeApplication;

const
  LogsDirName = 'Logs';
  DataDirName = 'Data';
  SqliteDatabaseFileName = 'data.sqlite';

  // Directories to be created during system startup
  DirectoriesToCreate : array[0..1] of string =
    (
      LogsDirName,
      DataDirName
    );

var
  ApplicationDirectoryPath : String;
  DbConnection : TDatabaseConnection;
  LoggedUser : TUser;

implementation

uses
  SysUtils, FileSystemHelper, LogHelper, ComandLineHelpers, TypInfo,
  SqliteConnection;

procedure WriteLog(logMessage : String);
var
  logFileDir : String;
begin
  logFileDir := CombinePath([ApplicationDirectoryPath, LogsDirName]);

  WriteLogFileByDay(logFileDir, '', logMessage);
end;

procedure WriteLog(logMessage : String; formatParams : array of Const);
begin
  WriteLog(format(logMessage, formatParams));
end;

function CreateExtraDirectories : Boolean;
var
  directory : String;
  i : Integer;
begin
  Result := False;

  for i := 0 to Length(DirectoriesToCreate) - 1 do
  begin
    directory := DirectoriesToCreate[i];

    if not CreateDirectory(directory) then
    begin
      // TODO: Write log
      Exit;
    end;
  end;

  Result := True;
end;

function ConnectToDatabase : Boolean;
var
  databasePath : String;
begin
  databasePath := CombinePath([ApplicationDirectoryPath, DataDirName, SqliteDatabaseFileName]);
  DbConnection := TSqliteConnection.Create(nil, databasePath);
  Result := DbConnection.Connect;
end;

function InitializeApplication : Boolean;
begin
  ApplicationDirectoryPath := GetApplicationFullDirectoryPath;

  Result := False;

  if not CreateExtraDirectories then
  begin
    // TODO: Write log
    Exit;
  end;

  if not ConnectToDatabase then
  begin
    // TODO: Write log
    Exit;
  end;

  Result := True;
end;

procedure FinalizeApplication;
begin
  DbConnection.Disconnect;
  FreeAndNil(DbConnection);
  
  if Assigned(LoggedUser) then
    FreeAndNil(LoggedUser);
end;

end.
