# $Id$

#!/bin/bash

. ./setCommonEnv.sh

JAVA="$JAVA_HOME/bin/java"

JAVA_OPTS=" -Xmx512m -Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Duser.language=en -Dfile.encoding=utf8 -Dstandalone.logger.name=syncDB -Drun.standalone.class=com.zoho.mickey.ha.db.postgres.SyncDBWithMaster"

CLASS_PATH=$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/AdventNetNPrevalent.jar:$SERVER_HOME/lib/conf.jar

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.Starter runStandalone "$@"
	
