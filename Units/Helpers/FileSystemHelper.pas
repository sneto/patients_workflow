unit FileSystemHelper;

interface

// Writes a given text to a given file
function WriteToFile(filePath, text : String) : Boolean;
// Combines all given parts in a path
function CombinePath(pathParts : array of string) : String;
// Creates directory if it doesn't exist
function CreateDirectory(directoryPath : String) : Boolean;

implementation

uses SysUtils;

function WriteToFile(filePath, text : String) : Boolean;
var
  f : TextFile;
begin
  AssignFile(f, filePath);

  Result := False;

  try
    if FileExists(filePath) then
      Append(f)
    else
      Rewrite(f);
  except on e : Exception do
    begin
      // TODO: Write log?
      Exit;
    end;
  end;

  try
    Write(f, text);
  except on e : Exception do
    begin
      // TODO Write log?
      Close(f);
      Exit;
    end;
  end;

  Close(f);
  Result := True;
end;

function CombinePath(pathParts : array of string) : String;
var
  i : Integer;
begin
  Result := '';

  for i := 0 to Length(pathParts) - 1 do
  begin
    if pathParts[i] <> '' then
      Result := IncludeTrailingPathDelimiter(Result + pathParts[i]);
  end;

  if Result <> '' then
    Result := ExcludeTrailingPathDelimiter(Result);
end;

function CreateDirectory(directoryPath : String) : Boolean;
begin
  Result := False;

  try
    if not DirectoryExists(directoryPath) and not CreateDir(directoryPath) then
    begin
      // TODO: Write log
      Exit;
    end;

    Result := True;
  except on e : Exception do
    begin
      // TODO: Write log
    end;
  end;
end;

end.
