program TestReadWriteProject;

uses
  ExceptionLog,
  Forms,
  TestReadWrite in 'TestReadWrite.pas' {Form1},
  ReadWriteLock in 'ReadWriteLock.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
