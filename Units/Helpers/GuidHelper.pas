unit GuidHelper;

interface

// Gets a new GUID string
function NewGuid : String;

implementation

uses Classes, SysUtils;

function NewGuid : String;
var
  guid: TGUID;
begin
  CreateGUID(guid);
  Result := GUIDToString(guid);
end;

end.
