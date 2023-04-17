# $Id$
#!/bin/sh
. ./setCommonEnv.sh

JAVA_OPTS="-Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Djava.library.path=$SERVER_HOME/lib/native -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Duser.language=en -Dfile.encoding=utf8 "

CLASS_PATH=$SERVER_HOME/lib:$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/AdventNetNPrevalent.jar:$SERVER_HOME/lib/tomcat/tomcat-juli.jar:$SERVER_HOME/lib/tomcat/commons-logging-api.jar:$SERVER_HOME/lib/conf.jar

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.Starter SchemaAnalyzer $1 $2

