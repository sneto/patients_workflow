unit SqliteConnection;

interface

uses classes, DatabaseConnection;


type
  // SQLite database connection
  TSqliteConnection = class(TDatabaseConnection)
    public
      // Creates a new instance with default database name
      constructor Create(AOwner: TComponent); reintroduce; overload;
      // Creates a new instance
      constructor Create(AOwner: TComponent; dbFileName : String); reintroduce; overload;
  end;

implementation

uses SysUtils;

{ TSqliteConnection }

constructor TSqliteConnection.Create(AOwner: TComponent);
const
  DatabasFileName = 'Data.sqlite';
begin
  self.Create(AOwner, DatabasFileName);
end;

constructor TSqliteConnection.Create(AOwner: TComponent;
  dbFileName: String);
begin
  inherited Create(AOWner);

  self.ConnectionName := 'Devart SQLite';
  self.DriverName := 'DevartSQLite';
  self.GetDriverFunc := 'getSQLDriverSQLite';
  self.LibraryName := 'dbexpsqlite.dll';
  self.VendorLib := 'sqlite3.dll';
  Self.LoginPrompt := False;

  self.Params.Add('BlobSize=-1');
  self.Params.Add(format('DataBase=%s', [dbFileName]));
  self.Params.Add('ASCIIDataBase=False');
  self.Params.Add('DriverName=dbexpsqlite.dll');
  self.Params.Add('BusyTimeout=0');
  self.Params.Add('EnableSharedCache=False');
  self.Params.Add('EncryptionKey=');
  self.Params.Add('FetchAll=True');
  self.Params.Add('ForceCreateDatabase=true');
  self.Params.Add('ForeignKeys=True');
  self.Params.Add('UseUnicode=True');
  self.Params.Add('EnableLoadExtension=False');
  self.Params.Add('UnknownAsString=False');
  self.Params.Add('DateFormat=');
  self.Params.Add('TimeFormat=');
end;

end.
