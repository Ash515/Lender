main()
{
	[ $4 ] || { echo "Usage : $0 <CLASSPATH CONF_DIR PROTOSRC_DIR>" ; exit 1 ; }
	if [ ! -d $4 ]
	then
		mkdir $4
	fi
        if [ -d $2 ]
	then
		# $1 - Classpath
		# $2 - Conf Dir
		# $3 - Module Name
		# $4 - Proto Out Directory
		# $5 - Proto Index File. To generate the proto index file for the first time, input the file path which has to startswith "_W_"
		# $6 - Sequence Generator class name
		# $7 - dtd path. by default data-dictionary.dtd
		JAVA_OPTS="-cp $1 -Dtier-type=BE -Dserver.dir=$2/../ -Dserver.home=$2/../ -Dconf.dir=$2 -Dcom.zoho.resource.modulename=$3 -Dproto.out.dir=$4 -Dseq.generator.classname=$6 -Ddtd.path=$7"
		PROTO_INDEX_FILE=$5
		if [ "x$PROTO_INDEX_FILE" != "x" ]; then
			if [ `echo | awk '{ print substr("'"$PROTO_INDEX_FILE"'", 1, 3) }'` = "_W_" ]; then
				PROTO_INDEX_FILE=`echo | awk '{ print substr("'"$PROTO_INDEX_FILE"'", 4) }'`
				JAVA_OPTS="$JAVA_OPTS -Dprotoindex.outfile=$PROTO_INDEX_FILE"
			else 
				JAVA_OPTS="$JAVA_OPTS -Dprotoindex.file=$PROTO_INDEX_FILE"
			fi
		fi
		if [ -z $JAVA7_HOME ]
		then
			 JAVA7_HOME="$JAVA_HOME"
		fi
		JAVA_EXEC="$JAVA7_HOME/jre/bin/java"
		if [ ! -a $JAVA_EXEC ]
		then
			JAVA_EXEC="$JAVA7_HOME/bin/java"
		fi
		"$JAVA_EXEC" $JAVA_OPTS com.zoho.resource.metadata.internal.ResourceMetaDataGenerator
	else
	echo "$2 is not found"
	exit 1
	fi
}
main $*
