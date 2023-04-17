#!/bin/sh
### ====================================================================== ###
##                                                                          ##
## stopDB.sh
##                                                                          ##
### ====================================================================== ###

DIRNAME=`dirname $0`
. $DIRNAME/setCommonEnv.sh


JAVA_OPTS=" -Xmx512m -Dcatalina.home=$SERVER_HOME -Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Duser.language=en -Dfile.encoding=utf8 -Ddb.home=$DB_HOME"

CLASS_PATH=$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/tomcat/tomcat-juli.jar:$SERVER_HOME/lib/tomcat/commons-logging-api.jar:$SERVER_HOME/lib/conf.jar

echo "Stoping DB server using stopDB script..."

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.StopDB 

