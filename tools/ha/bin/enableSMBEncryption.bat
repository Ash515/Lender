@echo off

rem $Id$

call .\setCommonEnv.bat

set JAVA="%JAVA_HOME%\bin\java"

set JAVA_OPTS= -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%" -Ddb.home="%DB_HOME%" -Dfile.encoding="utf8" -Djava.library.path="%SERVER_HOME%\lib\native" -Dstandalone.logger.name="smbEncryption" -Drun.standalone.class="com.zoho.mickey.ha.EnableSMBEncryption"

set CLASS_PATH=%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\AdventNetNPrevalent.jar;%SERVER_HOME%\lib\conf.jar

%JAVA% %JAVA_OPTS%  -cp "%CLASS_PATH%" com.adventnet.mfw.Starter runStandalone %*
