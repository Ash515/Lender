
#Usage : sh proto.sh ${accountsprotodir_dirname} ${accountsprotodir_dirname} ${protobuf_dir}/src ${prod_home}/lib/dd2proto-util.jar {NPERemovalNeeded}
main()
{	
	SCRIPTS_DIR=`dirname $0`
	OUTPUT_DIR=$1
	INPUT_DIR=$2
	UTILITY_DIR=$3
	CLASSPATH=$4
	NPE_REMOVAL_NEEDED=$5

    JAVA_EXEC="$JAVA_HOME/jre/bin/java"
    if [ ! -a $JAVA_EXEC ]
    then
        JAVA_EXEC="$JAVA_HOME/bin/java"
    fi


	if [ -f $UTILITY_DIR/protoc ]
	then
		echo "$UTILITY_DIR/protoc present"
        else
         echo "$UTILITY_DIR/protoc is not present"
         exit 1
	fi
	if [ ! -d $OUTPUT_DIR ]
	then
		mkdir -p $OUTPUT_DIR
	fi
        if [ -d $INPUT_DIR ]
	then
		${UTILITY_DIR}/protoc --java_out=${OUTPUT_DIR} --proto_path=${INPUT_DIR} `find ${INPUT_DIR} -iname "*.proto"`
		${UTILITY_DIR}/protoc --cpp_out=${OUTPUT_DIR} --proto_path=${INPUT_DIR} `find ${INPUT_DIR} -iname "*.proto"`
		${UTILITY_DIR}/protoc --python_out=${OUTPUT_DIR} --proto_path=${INPUT_DIR} `find ${INPUT_DIR} -iname "*.proto"`

		for file in `find ${OUTPUT_DIR} -iname *Proto.java`; do
			"$JAVA_EXEC" -cp $CLASSPATH com.zoho.resource.metadata.internal.ProtoClassRenamingTool $file ${file}_modified
			cp ${file}_modified ${file}_temp1
			mv ${file}_modified ${file}
		done

		if [ "x$NPE_REMOVAL_NEEDED" != "x" ];
		then		
			for file in `find ${OUTPUT_DIR} -iname *Proto.java`; do
				sh $SCRIPTS_DIR/find-npe-lines.sh $file ${file}_npelines
				"$JAVA_EXEC" -cp $CLASSPATH com.zoho.resource.metadata.internal.ProtoSettersNPERemover $file ${file}_npelines ${file}_modified
				rm -f ${file}_npelines
				mv ${file}_modified ${file}
			done
		fi
	else
	echo "$INPUT_DIR is not found"
	exit 1
	fi
}
main $*
