# $Id$
#!/bin/sh
. ./setCommonEnv.sh
NOOFARGS=$#

displayUsage()
{
	echo "Usage:" 
	echo ".........................................................."
	echo " sh migrateDB.sh <destinationDB> <destinationDBPropertyPath>"
	echo ".........................................................."
	echo "[OPTIONS] \n \tdestinationDB -> value should be either mysql/mssql/postgres/firebird \n \tdestinationDBPropertyPath -> Path to database properties file(database params file for destination DB)\n \t"
	exit 1
}

if [ ${NOOFARGS} -ne 3 -a ${NOOFARGS} -ne 2 ]; then
	echo "Invaild arguments"
	displayUsage
fi

JAVA_OPTS="-Dserver.home=$SERVER_HOME -Dapp.home=$SERVER_HOME -Ddb.home=$DB_HOME -Djava.library.path=$SERVER_HOME/lib/native -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Duser.language=en -Dfile.encoding=utf8 "

CLASS_PATH=$SERVER_HOME/lib:$SERVER_HOME/bin/run.jar:$SERVER_HOME/lib/AdventNetNPrevalent.jar:$SERVER_HOME/lib/tomcat/tomcat-juli.jar:$SERVER_HOME/lib/tomcat/commons-logging-api.jar:$SERVER_HOME/lib/conf.jar 

$JAVA -cp $CLASS_PATH $JAVA_OPTS com.adventnet.mfw.Starter DBMigration $1 "$2"
