#!/bin/bash
DIRNAME=`dirname $0`

SERVER_HOME=$(cd $DIRNAME/..; pwd -P)


(
shopt -s nullglob
  files=($SERVER_HOME/patches/*.ppm)
if [[ "${#files[@]}" -gt 0 ]] ; then
  $SERVER_HOME/bin/UpdateManager.sh -c  -au -pcv com.zoho.autoupgrade.DefaultPatchCompatibilityVerifier
else
	echo "Proceeding to start as there is no patch to apply"
fi	
)

if [ ! -f $SERVER_HOME/jre.lock ]; then
    if [ -f $SERVER_HOME/clean_new_jre ]; then
        if test -d $SERVER_HOME/jre_new; then
            rm -rf $SERVER_HOME/jre_new
        fi
        rm -rf $SERVER_HOME/clean_new_jre
    elif [ -f $SERVER_HOME/use_old_jre ]; then
    	if test -d $SERVER_HOME/jre; then
            rm -rf $SERVER_HOME/jre
        fi
        if test -d $SERVER_HOME/jre_old; then
            mv $SERVER_HOME/jre_old $SERVER_HOME/jre
        fi
        if test -d $SERVER_HOME/jre_new; then
            rm -rf $SERVER_HOME/jre_new
        fi
        rm -rf $SERVER_HOME/use_old_jre
    else
        if test -d $SERVER_HOME/jre_new; then
            if test -d $SERVER_HOME/jre; then
                if test -d $SERVER_HOME/jre_old; then
                    rm -rf $SERVER_HOME/jre_old
                fi
                mv $SERVER_HOME/jre $SERVER_HOME/jre_old
            fi
            mv $SERVER_HOME/jre_new $SERVER_HOME/jre
        fi
    fi
fi

	