rem $Id$
@echo off
 
set SERVER_HOME=%~dp0%~1\..
 
call "%SERVER_HOME%\bin\jreCorrector.bat"
 
set DB_HOME=%SERVER_HOME%\pgsql
 
 
if EXIST "%SERVER_HOME%\jre" set JAVA_HOME=%SERVER_HOME%\jre
 
if EXIST "%JAVA_HOME%" set JAVA=%JAVA_HOME%\bin\java