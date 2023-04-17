@echo off
rem $Id$
call .\setCommonEnv.bat

set CLASS_PATH="%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\conf.jar"

if [%1] == [x] goto END_USAGE
if NOT [%2] == [] (
    if NOT [%2] == [-p] goto END_USAGE
)

"%JAVA%" -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%"  -Ddb.home="%DB_HOME%" -Djava.library.path="%SERVER_HOME%\lib\native" -Dfile.encoding="utf8" -cp %CLASS_PATH% com.adventnet.mfw.RestoreDB %1 %2 %3
goto END

:END_USAGE
echo Usage restoreDB.bat zipfilename -p password

:END

