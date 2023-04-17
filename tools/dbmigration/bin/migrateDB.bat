@echo off

rem $Id$

call .\setCommonEnv.bat

IF !%2 == ! GOTO DISPLAY_USAGE
    set JAVA="%JAVA_HOME%\bin\java"
    set JAVA_OPTS= -Dserver.home="%SERVER_HOME%" -Dapp.home="%SERVER_HOME%"  -Ddb.home="%DB_HOME%" -Dfile.encoding="utf8" -Djava.library.path="%SERVER_HOME%\lib\native" -Djava.util.logging.manager="org.apache.juli.ClassLoaderLogManager" -Duser.language="en" -Dfile.encoding="utf8" 

    set CLASS_PATH=%SERVER_HOME%\bin\run.jar;%SERVER_HOME%\lib\AdventNetNPrevalent.jar;%SERVER_HOME%\lib\tomcat\tomcat-juli.jar;%SERVER_HOME%\lib\tomcat\commons-logging-api.jar;%SERVER_HOME%\lib\conf.jar;

    %JAVA% %JAVA_OPTS%  -cp "%CLASS_PATH%" com.adventnet.mfw.Starter DBMigration %1 "%2"
    goto END

:DISPLAY_USAGE
    echo Usage: 
    echo ..........................................................
    echo  sh migrateDB.bat ^<destinationDB^> ^<destinationDBPropertyPath^>
    echo ..........................................................
    @echo destinationDB -^> value should be either mysql/mssql/postgres/firebird & echo destinationDBPropertyPath -^> Path to database properties file^(database params file for destination DB^)
    goto End

:END
