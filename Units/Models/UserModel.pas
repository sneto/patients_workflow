unit UserModel;

interface

uses GlobalTypes;

type
  TUser = class
    private
      fId : StringGuid;
      fFirstName   : String40;
      fLastName    : String150;
      fBirtDate    : TDateTime;
      fActive      : Boolean;
      fPhoneNumber : String12;
      fUsername    : String20;
      fPassword    : String64;
    public
      property Id : StringGuid read fId write fId;
      property FirstName : String40 read fFirstName write fFirstName;
      property LastName : String150 read fLastName write fLastName;
      property BirtDate : TDateTime read fBirtDate write fBirtDate;
      property Active : Boolean read fActive write fActive;
      property PhoneNumber : String12 read fPhoneNumber write fPhoneNumber;
      property Username : String20 read fUsername write fUsername;
      property Password : String64 read fPassword write fPassword;
  end;

implementation

end.
