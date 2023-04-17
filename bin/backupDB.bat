@echo off
rem $Id$
call .\setCommonEnv.bat

set CLASS_PATH=%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\conf.jar

"%JAVA%" -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%"  -Ddb.home="%DB_HOME%" -Djava.library.path="%SERVER_HOME%\lib\native" -Dfile.encoding="utf8" -Dgen.db.password="false" -cp "%CLASS_PATH%" com.adventnet.mfw.BackupDB %*

exit /B %ERRORLEVEL%
