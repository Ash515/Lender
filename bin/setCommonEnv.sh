DIRNAME=`dirname $0`
 
SERVER_HOME=$(cd $DIRNAME/..; pwd -P)
export SERVER_HOME
 
. $SERVER_HOME/bin/jreCorrector.sh
 
DB_HOME=$SERVER_HOME/pgsql
export DB_HOME
 
LD_LIBRARY_PATH=/lib:$DB_HOME/extlib:$LD_LIBRARY_PATH
 
export LD_LIBRARY_PATH
 
OS=`uname`
if test -d $SERVER_HOME/jre
then
    if [ "${OS}" = "Darwin" ] && [ -d $SERVER_HOME/jre/Contents/Home ]
    then ## Mac OS with Sun JRE ##
        JAVA_HOME=$SERVER_HOME/jre/Contents/Home
    else
        JAVA_HOME=$SERVER_HOME/jre
    fi
    export JAVA_HOME
fi

if [ "x$JAVA" = "x" ]; then
    if [ "x$JAVA_HOME" != "x" ]; then
        JAVA="$JAVA_HOME/bin/java"
    else
        JAVA=`which java`
    fi
fi