#!/bin/bash
WD=`pwd`
DIR=`dirname $0`
cd $DIR
cd ../lib
/usr/bin/chmod +x UniqueIDSolaris
./UniqueIDSolaris $1
cd $WD 
