#!/bin/sh

. ./setCommonEnv.sh

# ------------------------------------------------------------------------------------------------------------------
WRAPPER_BASE=./wrapper
if [ "x$WRAPPER_CONF" = "x" ]; then
WRAPPER_CONF="$SERVER_HOME/conf/wrapper_linux.conf"
fi
# ------------------------------------------------------------------------------------------------------------------

chmod -R u+x .

######### START SERVER ################
START_SERVER="false"
SAFE_START="false"

if [ "$1" = "run" ]
then
	START_SERVER="true"
fi

if [ "$2" = "-s" ]; then
	SAFE_START="true"
fi

if [ $START_SERVER = "true" ]
then
	echo ""
	echo "JAVA_HOME   :" $JAVA_HOME
	echo "SERVER_HOME :" $SERVER_HOME
	echo "DATE        :" `date`
	echo ""
	$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000=$SAFE_START


############# BACKUP DB ##########################
elif [ "$1" = "backupDB" ]
then

    $WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="backupDB" wrapper.app.parameter.1001=$2 wrapper.app.parameter.1002=$3 wrapper.app.parameter.1003=$4 wrapper.app.parameter.1004=$5 wrapper.app.parameter.1005=$6 wrapper.app.parameter.1006=$7 wrapper.app.parameter.1007=$8 wrapper.app.parameter.1008=$9

########################## RESTORE DB ################################

elif [ "$1" = "restoreDB" ]
then

if [ $# -ge 2 ]; then
        RESTORE_FILE=$2
else
	 echo ""
    	echo "Usage: sh restoreDB.sh 'backUp Zip File' -p password"
    	echo ""
        exit 1
fi

if [ ! -z $3 ]; then
    if [ ! $3 = "-p" ]; then
	    echo "Usage: sh restoreDB.sh 'backUp Zip File' -p password"
	    exit 1
    fi
fi

$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="restoreDB" wrapper.app.parameter.1001=$RESTORE_FILE wrapper.app.parameter.1002=$3 wrapper.app.parameter.1003=$4



############################## START DB #####################################
elif [ "$1" = "startDB" ]
then
echo "Starting DB server using startDB script...."

if [ -z "${DB_HOME##*mysql*}" ]; then
	DB_PORT=$2
	TMP_HOME=$3

	if [ -z "$DB_PORT" ]
	then
    		DB_PORT=33306
	fi
	if [ -z "$TMP_HOME" ]
	then
    		TMP_HOME=$PWD/../mysql/tmp
	fi
	chmod -R u+x $DB_HOME

	if [ -f "./startDB.sh" ];
	then
		./startDB.sh $DB_PORT $TMP_HOME
	else
		$DB_HOME/bin/mysqld --no-defaults --basedir=$DB_HOME --tmpdir=$TMP_HOME --port=$DB_PORT --socket=$TMP_HOME/mysql.sock --user=root --default-character-set=utf8
	fi
	
fi
	if [ -z "${DB_HOME##*pgsql*}" ]
	then
			$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="startDB" 
	fi


############################## STOP DB ###########################################
elif [ "$1" = "stopDB" ]
then
echo "Stoping DB server using stopDB script..."

if [ -z "${DB_HOME##*pgsql*}" ]; then
	$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="stopDB"
fi

if [ -z "${DB_HOME##*mysql*}" ]; then
	DB_PORT=$2
	USER_NAME=$3
	TMP_HOME=$4
	PASSWORD=$5
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

	$DB_HOME/bin/mysqladmin "$commandArgs" shutdown
fi


################################### REINITIALIZE DB #################################
elif [ "$1" = "reinitDB" ]
then
FORCEFUL_REINIT="false"
if [ $# -gt 1 ]; then
        if [ $2 = "-A" ]; then
                rm -rf $SERVER_HOME/logs/* $SERVER_HOME/work
        fi
    if [ $2 = "-f" ]
    then
        FORCEFUL_REINIT="true"
    fi
fi

if [ $? -ne 0 ]
then
        exit 1
fi

$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="reinitDB"  wrapper.app.parameter.1001=$FORCEFUL_REINIT




##################################### SHUTDOWN DB ######################################
elif [ "$1" = "shutdown" ]
then
if [ $? -ne 0 ]
then
    exit 1
fi

$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="shutdown"  wrapper.app.parameter.1001="localhost" wrapper.app.parameter.1002=5
	

##################################### INFORMATION DUMP ######################################
elif [ "$1" = "infodump" ]
then
if [ $? -ne 0 ]
then
    exit 1
fi

$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="infodump" wrapper.app.parameter.1001="$2" wrapper.app.parameter.1002="$3" wrapper.app.parameter.1003="$4"


#################################### GETTING SERVER STATUS ###############################
elif [ "$1" = "serverstatus" ]
then
$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="serverStatus"


#################################### STANDALONE SERVER  ##################################
elif [ "$1" = "standalone" ]
then
$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="runStandalone"


#################################### DB Migration  #######################################
elif [ "$1" = "migrateDB" ]
then
$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="DBMigration" wrapper.app.parameter.1001="$2" wrapper.app.parameter.1002="$3"


#################################### Schema Analyzer  ####################################
elif [ "$1" = "compareSchema" ]
then
$WRAPPER_BASE -c "$WRAPPER_CONF" wrapper.app.parameter.1000="SchemaAnalyzer" wrapper.app.parameter.1001="$2" wrapper.app.parameter.1002="$3"


#################################### Help Usage  ####################################

else
$JAVA -cp $SERVER_HOME/bin/run.jar com.adventnet.mfw.AppCtlUsage "helpUsage"
fi