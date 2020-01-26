unit IntegerList;

interface

uses CustomList;

type
  // Custom list of integers
  TIntegerList = class(TBaseList)
    private
      function Get(Index: Integer): Integer;
    public
      procedure Add(item : Integer); overload;
      procedure Add(index: Integer; item : Integer); overload;
      //function Get(Index: Integer): Variant;
      function First : Integer;
      function Last : Integer;
      property Items[Index: Integer]: Integer read Get; default;
  end;

implementation

uses Variants, SysUtils;

{ TIntegerList }

procedure TIntegerList.Add(item: Integer);
begin
  inherited Add(item);
end;

procedure TIntegerList.Add(index, item: Integer);
begin
  inherited Add(index, item);
end;

function TIntegerList.First: Integer;
var
  variantValue : Variant;
begin
  variantValue := inherited First;

  if variantValue = Null then
  begin
    raise Exception.Create('Invalid index');
    Exit;
  end;

  Result := Integer(variantValue);
end;

function TIntegerList.Get(Index: Integer): Integer;
var
  variantValue : Variant;
begin
  variantValue := inherited Get(index);

  if variantValue = Null then
  begin
    raise Exception.Create('Invalid index');
    Exit;
  end;

  Result := Integer(variantValue);
end;

function TIntegerList.Last: Integer;
var
  variantValue : Variant;
begin
  variantValue := inherited Last;

  if variantValue = Null then
  begin
    raise Exception.Create('Invalid index');
    Exit;
  end;

  Result := Integer(variantValue);
end;


end.
