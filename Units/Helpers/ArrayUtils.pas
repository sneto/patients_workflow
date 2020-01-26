unit ArrayUtils;

interface

// Converts an input byte array to hexadecimal string representation
function GetHexadecimalString(inputArray : array of byte) : String;

implementation

uses SysUtils;

function GetHexadecimalString(inputArray : array of byte) : String;
var
  i : Integer;
  resultStr : String;
begin
  resultStr := '';

  for i:= 0 to Length(inputArray) - 1 do
  begin
    resultStr := resultStr + IntToHex(inputArray[i],2);
  end;

  Result := resultStr;
end;

end.
