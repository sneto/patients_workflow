unit CustomList;

interface

uses Classes;

type
  TBaseList = class
    internalList : TList;

    protected
      procedure Add(index: Integer; item : Variant); overload;
      //procedure Remove(item : Variant); overload;
      function GetCount : Integer;
      function First : Variant;
      function Last : Variant;
      procedure Add(item : Variant); overload; virtual;
      function Get(Index: Integer): Variant;
      property Items[Index: Integer]: Variant read Get;// write Put; default;
      //procedure Put(Index: Integer; Item: Variant);
    public
      constructor Create;
      destructor Destroy; override;

      property Count : Integer read GetCount;

      procedure Remove(index : Integer); overload;
      procedure Clear;
  end;

implementation

uses SysUtils, Variants;

type
  TInternalValue = class
    private
      fvalue : Variant;
    public
      constructor Create(value : Variant);
      property Value : Variant read fValue;
  end;

{ List }

procedure TBaseList.Add(item: Variant);
begin
  //self.internalList.Add(PVariant(@item));
  self.internalList.Add(TInternalValue.Create(item));
end;

procedure TBaseList.Add(index: Integer; item: Variant);
begin
  self.internalList.Insert(index, TInternalValue.Create(item));
end;

procedure TBaseList.Clear;
begin
  self.internalList.Clear;
end;

constructor TBaseList.Create;
begin
  self.internalList := TList.Create;
end;

destructor TBaseList.Destroy;
begin
  FreeAndNil(self.internalList);
  inherited;
end;

function TBaseList.Get(Index: Integer): Variant;
begin
  Result := TInternalValue(self.internalList[Index]).Value;
end;

function TBaseList.GetCount: Integer;
begin
  Result := self.internalList.Count;
end;

{procedure TBaseList.Remove(item: Variant);
begin
  self.internalList.Remove(@item);
end;}

function TBaseList.Last: Variant;
var
  pointerToLast : Pointer;
begin
  pointerToLast := self.internalList.Last;

  Result := Null;

  if pointerToLast <> nil then
    Result := TInternalValue(pointerToLast).Value;
end;

procedure TBaseList.Remove(index: Integer);
begin
  if (index < 0) or (index > self.Count - 1) then
    Exit;

  self.internalList.Delete(index);
end;

function TBaseList.First: Variant;
var
  pointerToFirst : Pointer;
begin
  pointerToFirst := self.internalList.First;

  Result := Null;

  if pointerToFirst <> nil then
    Result := TInternalValue(pointerToFirst).Value;
end;

{ TInternalValue }

constructor TInternalValue.Create(value: Variant);
begin
  self.fvalue := value;
end;

end.
