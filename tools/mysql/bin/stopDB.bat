rem $Id$
@ echo off
rem batch file for stopping mysqld

call "%~dp0\setcommonenv.bat"
set PORT=%1
set USER_NAME=%2
set PASSWORD=%3
set commandArgs=--port %PORT% -u %USER_NAME%

if NOT "x%PASSWORD%"=="x" set commandArgs=%commandArgs% --password=%PASSWORD%

@start "mysql" /B "%DB_HOME%\bin\mysqladmin" %commandArgs% shutdown


