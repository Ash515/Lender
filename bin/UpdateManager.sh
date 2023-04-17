#!/bin/sh

. ./setCommonEnv.sh

cd ../lib

	if [ -f AdventNetUpdateManagerInstaller.jar_new ]; 
	then
		cp AdventNetUpdateManagerInstaller.jar_new AdventNetUpdateManagerInstaller.jar
		rm -r AdventNetUpdateManagerInstaller.jar_new
	else
		echo ""		
	fi

cd ..	

LD_LIBRARY_PATH=$DB_HOME/lib/:./lib/native:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH

CLASSPATH=./lib/AdventNetUpdateManagerInstaller.jar
export CLASSPATH

JAVA_OPTS="-Ddb.home=$DB_HOME -Dfile.encoding=utf8"

$JAVA -Xmx100m  $JAVA_OPTS -Dtier-type=BE -Djava.library.path=./lib/native -Dtier-id=BE1 -cp $CLASSPATH com.adventnet.tools.update.installer.UpdateManager -u conf $*
cd bin