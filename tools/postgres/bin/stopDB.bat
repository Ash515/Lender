@echo off

rem $Id$

call .\setcommonenv.bat


set JAVA_OPTS= -Xmx512m -Dcatalina.home="%SERVER_HOME%" -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%"  -Dlog.dir="%SERVER_HOME%" -Duser.language="en" -Dfile.encoding="utf8" -Ddb.home="%DB_HOME%"

set CLASS_PATH=%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\tomcat\commons-logging-api.jar;%SERVER_HOME%\lib\tomcat\tomcat-juli.jar;%SERVER_HOME%\lib\conf.jar

"%JAVA%" %JAVA_OPTS%  -cp "%CLASS_PATH%" com.adventnet.mfw.StopDB


