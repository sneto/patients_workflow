unit ComandLineHelpers;

interface

// Gets the application executable full path from command line
function GetApplicationFullPath : String;
// Gets the full path to the directory containing the application executable
function GetApplicationFullDirectoryPath : String;

implementation

uses SysUtils;

function GetApplicationFullPath : String;
begin
  Result := ParamStr(0);
end;

function GetApplicationFullDirectoryPath : String;
begin
  Result := ExtractFileDir(GetApplicationFullPath);
end;

end.
