@echo off

rem $Id$

call .\setCommonEnv.bat

IF !%1 == ! (
 echo Usage: 
    echo ..........................................................
    echo  changeKey.bat  ^<new_ectag^>
    echo ..........................................................
    goto End
)

    set JAVA="%JAVA_HOME%\bin\java"
    set JAVA_OPTS= -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%"  -Ddb.home="%DB_HOME%" -Dfile.encoding="utf8" -Djava.library.path="%SERVER_HOME%\lib\native" -Djava.util.logging.manager="org.apache.juli.ClassLoaderLogManager" -Duser.language="en" -Dfile.encoding="utf8"

    set CLASS_PATH=%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\tomcat\tomcat-juli.jar;%SERVER_HOME%\lib\conf.jar;

    %JAVA% %JAVA_OPTS%  -cp "%CLASS_PATH%" com.adventnet.mfw.ChangeECTag %1

:END
