@rem Please set your Java path here.set
@echo off
rem set JAVA_HOME=C:\j2sdk1.4.2.03
cd ..
set SERVER_HOME=%~dp0%\.
cd bin
call .\setcommonenv.bat
cd ..
if NOT EXIST "%JAVA_HOME%\bin\java.exe" echo "Please set the JAVA_HOME parameter in" %0
if NOT EXIST "%JAVA_HOME%\bin\java.exe" goto FINISH
cd lib
if NOT EXIST AdventNetUpdateManagerInstaller.jar_new goto start
copy AdventNetUpdateManagerInstaller.jar_new AdventNetUpdateManagerInstaller.jar
del AdventNetUpdateManagerInstaller.jar_new
:start
cd ..
set PATH=%PATH%;".\lib\native"
set CLASSPATH=.\lib\AdventNetUpdateManagerInstaller.jar
set JAVA_COMPILER=NONE

set JAVA_OPTS=-Ddb.home="%DB_HOME%" -Dfile.encoding="utf8"

"%JAVA_HOME%\bin\java" -Xmx100m  %JAVA_OPTS% -Dtier-type=BE -Djava.library.path=.\lib\native -Dtier-id=BE1 com.adventnet.tools.update.installer.UpdateManager -u conf %*
cd bin
