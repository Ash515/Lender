#!/bin/sh
### ====================================================================== ###
##                                                                          ##
## startDB.sh  <DB_HOME> <DB_PORT>
##                                                                          ##
### ====================================================================== ###

DIRNAME=`dirname $0`
. $DIRNAME/setCommonEnv.sh
DB_PORT=$1
TMP_HOME=$2

if [ -z "$DB_PORT" ]
then
    DB_PORT=33306
fi
if [ -z "$TMP_HOME" ]
then
    TMP_HOME=$PWD/../mysql/tmp
fi
chmod -R u+x $DB_HOME
# "DB_HOME $DB_HOME   DB_PORT $DB_PORT   TMP_HOME $TMP_HOME"

$DB_HOME/bin/mysqld --no-defaults --basedir=$DB_HOME --tmpdir=$TMP_HOME --port=$DB_PORT --socket=$TMP_HOME/mysql.sock --user=root --default-character-set=utf8


