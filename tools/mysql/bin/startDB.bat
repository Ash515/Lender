rem $Id$
@ echo off

call "%~dp0\setcommonenv.bat"

rem batch file for starting mysqld
set DB_PORT=%1

@start "MySQL" /B "%DB_HOME%\bin\mysqld-nt" --no-defaults --standalone --basedir="%DB_HOME%" --port=%DB_PORT% --datadir="%DB_HOME%\data" --default-character-set=utf8

