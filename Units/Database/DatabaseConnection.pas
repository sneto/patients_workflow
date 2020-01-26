unit DatabaseConnection;

interface

uses SqlExpr, SimpleDs, DB, Classes;

type
  // Enumerator of suported comand types
  TSqlCommandType = (sqcSelect, sqcOther);

  // Class to implement a list of SQL parameters
  TSqlParams = class
    private
      paramCount : Integer;
      params : Array of TParam;

      // Sets the params list to a given size
      procedure SetParamsCount(newCount : Integer);
      // Adds a variant parameter
      procedure Add(name : String; value : Variant); overload;
      // Gets a parameter in the given index
      function Get(index : Integer) : TParam;
    public
      // Creates a new instance
      constructor Create;
      // Destroy the current instance
      destructor Destroy; override;

      // Cears the current list of parameters
      procedure Clear;
      // Adds an integer parameter
      procedure AddInteger(name : String; value : Integer); overload;
      // Adds a double parameter
      procedure AddDouble(name : String; value : Double); overload;
      // Adds a DateTime parameter
      procedure AddDateTime(name : String; value : TDateTime); overload;
      // Adds a string parameter
      procedure AddString(name : String; value : String); overload;
      // Adds a boolean parameter
      procedure AddBoolean(name : String; value : Boolean); overload;
      // Adds a null value parameter
      procedure AddNullValue(name : String); overload;

      // Gets the list of parameters in the current instance
      property Items[index: Integer]: TParam read Get; default;
      // Gets the parameters count
      property Count : Integer read paramCount;
  end;

  // Class to implement a connection to a SQL database
  TDatabaseConnection = class(TSQLConnection)
    private
      // Sets parameters from the list to a dataset
      procedure SetParameters(dataSet : TSimpleDataSet;
        sqlStatementParams : TSqlParams);
      // Executes a SQL command returning the dataset used to execute command
      function ExecuteCommand(sqlCommand : String; params : TSqlParams;
        comandType : TSqlCommandType) : TSimpleDataSet; overload; virtual;
    public
      // Executes a SQL Select command with no parameters
      function ExecuteSelect(sqlCommand : String)
        : TSimpleDataSet; overload; virtual;
      // Executes a SQL Select command with given parameters
      function ExecuteSelect(sqlCommand : String; params : TSqlParams)
        : TSimpleDataSet; overload; virtual;
      // Executes a SQL command without output (E.g.: Insert, update, delete)
      // with no parameters
      function Execute(sqlCommand : String) : Boolean; overload; virtual;
      // Executes a SQL command without output (E.g.: Insert, update, delete)
      // with given parameters
      function Execute(sqlCommand : String; params : TSqlParams)
        : Boolean; overload; virtual;
      // Connects the current instance to database
      function Connect : Boolean;
      // Disconnects the current instance from database
      function Disconnect : Boolean;
  end;

implementation

uses SysUtils, Variants;

{ TDatabaseConnection }

function TDatabaseConnection.Execute(sqlCommand: String): Boolean;
begin
  Result := self.Execute(sqlCommand, nil);
end;

function TDatabaseConnection.ExecuteSelect(sqlCommand: String): TSimpleDataSet;
begin
  Result := self.ExecuteSelect(sqlCommand, nil);
end;

function TDatabaseConnection.Execute(sqlCommand: String;
  params: TSqlParams): Boolean;
var
  commandResult : TSimpleDataSet;
begin
  Result := False;
  commandResult := self.ExecuteCommand(sqlCommand, params, sqcOther);

  if Assigned(commandResult) then
  begin
    commandResult.Close;
    FreeAndNil(commandResult);
    Result := True;
  end;
end;

function TDatabaseConnection.ExecuteSelect(sqlCommand: String;
  params: TSqlParams): TSimpleDataSet;
begin
  Result := self.ExecuteCommand(sqlCommand, params, sqcSelect);
end;

function TDatabaseConnection.Connect: Boolean;
begin
  Result := True;

  try
    self.Open;
  except on e : Exception do
    begin
      Result := False;
      // TODO: Write log
    end;
  end;
end;

function TDatabaseConnection.Disconnect : Boolean;
begin
  Result := False;

  if self.ConnectionState <> csStateOpen then
  begin
    // TODO: write log
    Exit;
  end;

  try
    self.Close;
  except on e : Exception do
    begin
      // TODO: Write log
      Exit;
    end;
  end;

  Result := True;
end;

procedure TDatabaseConnection.SetParameters(dataSet: TSimpleDataSet;
  sqlStatementParams: TSqlParams);
var
  i : Integer;
begin
  if not Assigned(sqlStatementParams) then
    Exit;
    
  for i := 0 to sqlStatementParams.Count - 1 do
  begin
    dataSet.Params.AddParam(sqlStatementParams[i]);
  end;
end;

function TDatabaseConnection.ExecuteCommand(sqlCommand: String;
  params: TSqlParams; comandType: TSqlCommandType): TSimpleDataSet;
var
  commandDataSet : TSimpleDataSet;
begin
  commandDataSet := TSimpleDataSet.Create(self);
  commandDataSet.Connection := self;
  commandDataSet.DataSet.CommandType := ctQuery;
  commandDataSet.DataSet.CommandText := sqlCommand;
  commandDataSet.Params.Clear;

  self.SetParameters(commandDataSet, params);

  try
    if comandType = sqcSelect then
      commandDataSet.Open
    else
      commandDataSet.Execute;
  except on e : Exception do
    begin
      FreeAndNil(commandDataSet);
      // TODO: Write log
    end;
  end;

  Result := commandDataSet;
end;

{ TSqlParams }

procedure TSqlParams.Add(name: String; value: Variant);
var
  newParam : TParam;
begin
  self.SetParamsCount(self.paramCount + 1);

  newParam := TParam.Create(nil);
  newParam.Name := name;
  newParam.Value := value;
  self.params[self.paramCount - 1] := newParam;
end;

procedure TSqlParams.AddDouble(name: String; value: Double);
begin
  self.Add(name, Variant(value));
end;

procedure TSqlParams.AddInteger(name: String; value: Integer);
begin
  self.Add(name, Variant(value));
end;

procedure TSqlParams.AddString(name, value: String);
begin
  self.Add(name, Variant(value));
end;

procedure TSqlParams.AddDateTime(name: String; value: TDateTime);
begin
  self.Add(name, Variant(value));
end;

procedure TSqlParams.AddBoolean(name: String; value: Boolean);
begin
  self.Add(name, Variant(value));
end;

procedure TSqlParams.AddNullValue(name: String);
begin
  self.Add(name, Null);
end;

procedure TSqlParams.Clear;
var
  i : Integer;
begin
  self.SetParamsCount(0);
end;

constructor TSqlParams.Create;
begin
  self.Clear;
end;

destructor TSqlParams.Destroy;
begin
  self.Clear;
  inherited;
end;

function TSqlParams.Get(index: Integer): TParam;
begin
  Result := self.params[index];
end;

procedure TSqlParams.SetParamsCount(newCount: Integer);
begin
  self.paramCount := newCount;
  SetLength(self.params, self.paramCount);
end;

end.
