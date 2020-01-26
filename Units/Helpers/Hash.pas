unit Hash;

interface

// Get String SHA256 hash in hexadecimal string format
function getsha256(strToEncrypt: String): String;

implementation

uses DCPsha256, ArrayUtils;

function getsha256(strToEncrypt: String): String;
var
  hashCalculator : TDCP_sha256;
  digest : array[0..31] of byte;  // sha256 produces a 256bit digest (32bytes)
  source : string;
begin
  Source:= strToEncrypt;  // here your string for get sha256

  Result := '';

  if Source <> '' then
  begin
    hashCalculator := TDCP_sha256.Create(nil);  // create the hash
    hashCalculator.Init;                        // initialize it
    hashCalculator.UpdateStr(Source);
    hashCalculator.Final(Digest);               // produce the digest  (output)
    Result := GetHexadecimalString(digest);
  end;
end;

end.
