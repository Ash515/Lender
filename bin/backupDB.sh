#$Id$
#!/bin/sh
. ./setCommonEnv.sh

CLASS_PATH=$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/conf.jar

JAVA_OPTS=" -Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Dfile.encoding=utf8 -Dgen.db.password=false" 

LD_LIBRARY_PATH=$SERVER_HOME/lib/native:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

JAVA_OPTS="$JAVA_OPTS -Djava.library.path=$SERVER_HOME/lib/native"

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.BackupDB "$@"
