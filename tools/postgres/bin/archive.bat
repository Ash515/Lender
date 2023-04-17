@echo off 
     
SET enable_backup=false
SET enable_ha_backup=false
IF EXIST "incremental_backup" SET enable_backup=true
IF EXIST "full_backup" SET enable_backup=true
IF EXIST "ha_configured" SET enable_ha_backup=true
     
IF "%enable_backup%"=="true" (
SET dir_name="wal_archive"
IF NOT EXIST wal_archive CALL :CREATE_AND_SET_PERMISSION
COPY "%1" "wal_archive\%2" >nul
)
     
IF "%enable_ha_backup%"=="true" (
SET dir_name="ha_wal_archive"
IF NOT EXIST ha_wal_archive CALL :CREATE_AND_SET_PERMISSION
COPY "%1" "ha_wal_archive\%2" >nul
)
     
GOTO END
     
:CREATE_AND_SET_PERMISSION
MKDIR %dir_name%
SET CACL_CMD="%SystemRoot%\system32\icacls.exe"
%CACL_CMD% %dir_name% /T /C /grant "%userdomain%\%username%":(OI)(CI)F /Q
%CACL_CMD% %dir_name% /grant "NT AUTHORITY\NetworkService":(OI)(CI)F /Q
%CACL_CMD% %dir_name% /grant *S-1-3-0:(OI)(CI)F /Q
%CACL_CMD% %dir_name% /grant *S-1-5-18:(OI)(CI)F /Q
%CACL_CMD% %dir_name% /grant *S-1-5-32-544:(OI)(CI)F /Q
%CACL_CMD% %dir_name% /inheritance:r /Q
     
:END