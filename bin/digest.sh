#!/bin/bash

# Creates digest for given file in <file>.digest
# Author Srivathson KK.
### ====================================================================== ###
##                                                                          ##
## digest.sh <FILES>
##                                                                          ##
### ====================================================================== ###

. ./setCommonEnv.sh

if [ $# -lt 1 ]
then
    echo "syntax: $0 <p1> [p2 ...";
    exit 1;
fi

CLASS_PATH=$SERVER_HOME/lib/framework-tools.jar:$SERVER_HOME/lib/conf.jar

$JAVA  -cp $CLASS_PATH com.zoho.framework.utils.FileUtils digest "$@"