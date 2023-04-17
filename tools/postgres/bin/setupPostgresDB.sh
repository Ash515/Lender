# $Id$
#!/bin/sh
. ./setCommonEnv.sh

JAVA="$JAVA_HOME/bin/java"

JAVA_OPTS="-Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Dfile.encoding=utf8 -Djava.library.path=$SERVER_HOME/lib/native -Dstandalone.logger.name=setuppostgresdb -Drun.standalone.class=com.zoho.mickey.tools.postgres.SetupPostgresDB"

CLASS_PATH=$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/AdventNetNPrevalent.jar:$SERVER_HOME/lib/conf.jar

$JAVA  -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.Starter runStandalone "$@"
