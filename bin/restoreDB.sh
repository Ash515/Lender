#$Id$
#!/bin/sh
. ./setCommonEnv.sh

usage()
{
    echo ""
    echo "Usage: sh restoreDB.sh 'backUp Zip File' -p password"
    echo ""
}

if [ $# -ne 0 ]; then
	RESTORE_FILE=$1
else
	usage
	exit 1
fi

if [ ! -z $2 ]; then
    if [ ! $2 = "-p" ]; then
        usage
	    exit 1
    fi
fi

JAVA_OPTS=" -Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Dfile.encoding=utf8"

CLASS_PATH=$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/conf.jar

LD_LIBRARY_PATH=$SERVER_HOME/lib/native:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

JAVA_OPTS="$JAVA_OPTS -Djava.library.path=$SERVER_HOME/lib/native"

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.RestoreDB $RESTORE_FILE $2 $3

