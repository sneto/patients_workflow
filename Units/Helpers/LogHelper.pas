unit LogHelper;

interface

// Writes a log message to file
procedure WriteLogFile(logFilePath, logMessage: String);

// Writes a log message to file generating one file a day
procedure WriteLogFileByDay(directoryPath, logFilePrefix, logMessage : String);

implementation

uses FileSystemHelper, SysUtils;

procedure WriteLogFile(logFilePath, logMessage: String);
const
  logMessageFormat = '%s %s' + #13 + #10;
  logDateFormat = 'yyyymmddhhnnss.zzz';
var
  formatTedLogMessage : String;
begin
  formatTedLogMessage := format(logMessageFormat, [FormatDateTime(logDateFormat, now), logMessage]);
  WriteToFile(logFilePath, formatTedLogMessage);
end;

procedure WriteLogFileByDay(directoryPath, logFilePrefix, logMessage: String);
const
  LogFileNameMask = '%s%s.log';
var
  logFileName : String;
  filePath : String;
begin
  logFileName := format(LogFileNameMask, [logFilePrefix, FormatDateTime('yyyymmdd', now)]);

  filePath := CombinePath([directoryPath, logFileName]);

  WriteLogFile(filePath, logMessage); 
end;

end.
