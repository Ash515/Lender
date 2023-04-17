#!/bin/sh
### ====================================================================== ###
##                                                                          ##
## stopDB.sh  MYSQL_HOME HOST MYSQL_PORT USERNAME [root] <PASSWORD>         ##
##                                                                          ##
### ====================================================================== ###

#DB_HOME=$1
DIRNAME=`dirname $0`
DB_PORT=$1
USER_NAME=$2
TMP_HOME=$3
PASSWORD=$4

. $DIRNAME/setCommonEnv.sh
if [ -z "$DB_PORT" ]
then
    DB_PORT=33306
fi
if [ -z "$TMP_HOME" ]
then
    TMP_HOME=$DB_HOME/tmp
fi
if [ -z "$USER_NAME" ]
then
    USER_NAME=root
fi

commandArgs="-S $TMP_HOME/mysql.sock -P $DB_PORT -u $USER_NAME"

if [ -n "$PASSWORD" ]
then
     commandArgs="$commandArgs --password=$PASSWORD"
fi

$DB_HOME/bin/mysqladmin $commandArgs shutdown
