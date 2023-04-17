#!/bin/bash

. ./setCommonEnv.sh

usage() {
	echo "USAGE: mirror.sh [Remote_ip/name] [USER/DEFAULT/AUTHENTICATE {USER}][Remote_Installation_Folder/DEFAULT] [MIRROR/COPY] [LOG FILE] [ISFOLDER?] [File/Folder PATH] [Opts]";
    exit 1;
}

trim() {
  local s="$1" LC_CTYPE=C
  s=${s#"${s%%[![:space:]]*}"}
  s=${s%"${s##*[![:space:]]}"}
  echo "$s"
}

makeDir() {
  echo mkdir :: "mkdir -p $1"
  if ! mkdir -p "$1" ; then 
  	echo "Could not create local directory $1"
  	exit 100
  fi
}

if [ $# -lt 6 ]; then
    usage
fi

PEM_FILE="../conf/ha/auth.pem"

REMOTE_MACHINE=$(trim "$1")
shift

USER="$1"
if [ "$USER" = "DEFAULT" ]; then
	USER=""
	elif [ "$USER" = "AUTHENTICATE" ]
	then
	    AUTH=PEM
	    if [ ! -f "$PEM_FILE" ]; then
	      echo "PEM file does not exist"
	      exit 1 
	    fi
	    shift
	    USER="$1@"
	else
		USER="$USER@"
fi
shift

REMOTE_LOCATION=$(trim "$1")
if [ "$REMOTE_LOCATION" = "DEFAULT" ]; then
	REMOTE_LOCATION = "$SERVER_HOME"
fi
shift

if [ "$1" = "MIRROR" ]; then
	TYPE="--delete"
	elif [ "$1" = "COPY" ] || [ "$1" = "REPLICATE" ]
	then
		TYPE=""
	else
		echo "transfer type provided is wrong. Please provide COPY/MIRROR/REPLICATE"
		usage
fi
shift

LOG=$(trim "$1")
if [ "$LOG" = "DEFAULT" ]; then
	LOG_FILE="$SERVER_HOME"/logs/mirror.txt
	else
		LOG_FILE="$SERVER_HOME"/logs/"$LOG"
fi
shift

ISFOLDER="$1"
shift

DATA=$(trim "$1")
shift

if [ ! "$ISFOLDER" = true ]; then
	#dir till last / will be removed. EX:
  	#abc/def -> abc
  	#abc/ -> abc
	DIR=${DATA%/*}
  	if [ "${DIR}" != "${DATA}" ]; then
    	makeDir "${SERVER_HOME}/$DIR"
  	fi
	else
		DIR="${DATA}"
		DATA="${DATA}/"
    	makeDir "${SERVER_HOME}/$DIR"
fi

options="-aHAXxv --numeric-ids $TYPE --progress --log-file=$LOG_FILE "
if [ "$AUTH" = "PEM" ]; then
    ssh_cmd="ssh -i '$PEM_FILE' -T -c aes128-ctr -o Compression=no -x"    
    else
        ssh_cmd="ssh -T -c aes128-ctr -o Compression=no -x"
fi    
credentials="$USER$REMOTE_MACHINE:"
source="$REMOTE_LOCATION/$DATA"
target="$SERVER_HOME/$DIR"

rsync $options -e "$ssh_cmd" "$@" "$credentials'$source'" "$target"