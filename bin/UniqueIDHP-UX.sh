#!/bin/bash
WD=`pwd`
DIR=`dirname $0`
cd $DIR
cd ../lib
/bin/chmod +x UniqueIDHP-UX
./UniqueIDHP-UX $1
cd $WD
