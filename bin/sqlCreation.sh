#$Id$

if [ -z "$1" ] | [ -z "$2" ]
then
    echo "Usage :: sh sqlCreation.sh     <<old_product_home_dir>>   <<new_product_home_dir>>"
    exit
fi

echo 'This is start of the sql generation:::'

echo $1
echo $2

export CLASSPATH=$1/lib/AdvMicroFramework.jar:$1/lib/mickey3.jar:$1/lib/AdventNetUpdateManagerInstaller.jar:../lib/update.jar:$1/lib/AdvPersistence.jar:$1/lib/jboss-common-jdbc-wrapper.jar:$1/lib/jboss-compressed.jar:$1/lib/jboss-j2ee.jar:$1/lib/jboss-jca.jar:$1/lib/concurrent.jar:$1/lib/jboss-transaction.jar:$1/lib/mysql_connector.jar:../lib/AdvSqlCreator.jar:$1/lib/tomcat/commons-collections-3.1.jar:$1/bin/run.jar:$1/lib/SwisSQLAPI.jar:$1/lib/sas.jar:$1/lib/AdvMickeyLiteLogging.jar:$1/lib/AdvAuthentication.jar:$1/lib/AdvAuthorization.jar:$1/lib/AdvAudit.jar:$1/lib/AdvTaskEngine.jar:$1/lib/AdvCoreLogging.jar:$1/lib/AdvCustomView.jar:$1/lib/AdvI18n.jar

#export JAVA_HOME=/home/sas/dad/jdk
$JAVA_HOME/bin/java -Xmx100m  $JAVA_OPTS -Dgenerate.destructive.changes=true -Dserver.home=.. -Dthrow.exceptions=false -Dgenerate.cleanupsql.for.install.failure=true -Dserver.dir=.. -Dtier-type=BE -Djava.library.path=./lib/native -Dtier-id=BE1 com.adventnet.persistence.MigrationSqlGenerator com.adventnet.db.adapter.mysql.MysqlSQLGenerator $*

echo
echo
echo
echo "The Diff SQL is generated in isu directory."
