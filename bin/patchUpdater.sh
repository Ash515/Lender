#!/bin/bash

. ./setCommonEnv.sh

CLASS_PATH=$SERVER_HOME/lib/AdvPersistence.jar:$SERVER_HOME/lib/hotswapAgent.jar:$SERVER_HOME/bin/run.jar
if [ $# -lt 1 ]
then
$JAVA -Dserver.home=$SERVER_HOME -cp $CLASS_PATH com.zoho.mickey.tools.RuntimePatchUpdaterRequest "showUsage"
exit 1;
fi

$JAVA -Dserver.home=$SERVER_HOME -cp $CLASS_PATH com.zoho.mickey.tools.RuntimePatchUpdaterRequest "$@"
