@echo off

call .\setCommonEnv.bat

set CLASS_PATH="%SERVER_HOME%\lib\AdvPersistence.jar;%SERVER_HOME%\lib\hotswapAgent.jar;%SERVER_HOME%\bin\run.jar;"

IF "%1"=="" GOTO SHOW_SYNTAX

"%JAVA%"  -Dserver.home="%SERVER_HOME%" -cp %CLASS_PATH% com.zoho.mickey.tools.RuntimePatchUpdaterRequest %*
GOTO END_PATCHUPDATER

:SHOW_SYNTAX
"%JAVA%" -Dserver.home="%SERVER_HOME%" -cp %CLASS_PATH% com.zoho.mickey.tools.RuntimePatchUpdaterRequest "showUsage"

:END_PATCHUPDATER
