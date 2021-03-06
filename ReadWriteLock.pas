unit ReadWriteLock;

interface

uses
  SyncObjs, Windows, SysUtils;

type
  TReadWriteLock = class(TObject)
  private
    FReadCount: Integer;
    FReadCountLock: TCriticalSection;
    FDataLock: THandle;
  public
    constructor Create;
    destructor Destroy; override;
    function AcquireReadLock: Boolean;
    function ReleaseReadLock: Boolean;
    function AcquireWriteLock: Boolean;
    function ReleaseWriteLock: Boolean;

  //this propery is used for test
    function GetReadCount: Integer;
    property ReadCount: Integer read GetReadCount;

  end;

implementation


{ TReadWriteLock }

function TReadWriteLock.AcquireWriteLock: Boolean;
begin
  if WAIT_OBJECT_0 = WaitForSingleObject(FDataLock, INFINITE)  then  Result := True
  else Result := False;
end;

constructor TReadWriteLock.Create;
begin
  FReadCountLock := TCriticalSection.Create;
  FDataLock := CreateSemaphore(nil, 1, 1, '');
end;

destructor TReadWriteLock.Destroy;
begin
  FreeAndNil(FReadCountLock);
  CloseHandle(FDataLock);
  inherited;
end;

function TReadWriteLock.GetReadCount: Integer;
begin
  Result := FReadCount;
end;

function TReadWriteLock.ReleaseReadLock: Boolean;
begin
  Result := False;
  FReadCountLock.Acquire;
  try
    Dec(FReadCount);
    if FReadCount = 0 then Result := ReleaseSemaphore(FDataLock, 1, nil);
  finally
    FReadCountLock.Release;
  end;
end;

function TReadWriteLock.AcquireReadLock: Boolean;
begin
  Result := False;
  FReadCountLock.Acquire;
  try
    if FReadCount = 0 then
      if WAIT_OBJECT_0 = WaitForSingleObject(FDataLock, INFINITE)  then  Result := True;
    Inc(FReadCount);  
  finally
    FReadCountLock.Release;
  end;
end;

function TReadWriteLock.ReleaseWriteLock: Boolean;
begin
  Result := ReleaseSemaphore(FDataLock, 1, nil);
end;

end.
 