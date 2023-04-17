#!/bin/bash
WD=`pwd`
DIR=`dirname $0`
cd $DIR
cd ../lib
/bin/chmod +x UniqueIDLinux
./UniqueIDLinux $1
cd $WD
