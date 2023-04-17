#rem $Id$
#!/bin/sh
### ====================================================================== ###
##                                                                          ##
## initPgsql.sh                                                             ##
##                                                                          ##
## Usage : initPgsql.sh <password> to initialize data directory             ##
## Usage : initPgsql.sh to reset permissions for data directory             ##
##                                                                          ##
### ====================================================================== ###

# PostgreSQL cluster init script for Linux

DIRNAME=$(dirname $0)
uname -a
. $DIRNAME/setCommonEnv.sh

DB_HOME=$(
    cd $DB_HOME
    pwd -P
)

DB_SUPERUSER=postgres
USER_GROUP=postgres
PASSWORD=$1
DATADIR=$DB_HOME/data/
EXTCONFDIR=${DB_HOME}/ext_conf
IS_DATADIR_EXISTS=false
WARN=0
USER_ID=$(id -g)
PWDFILE="$DB_HOME/tmp/.pwd"
PGSQL_VERSION=$(${DB_HOME}/bin/postgres -V)
MACHINE_TYPE=$(uname -m)
AUTH_MODE=$2

warn() {
		echo $1
		WARN=2
}

_die() {
		echo $1
		_cleanup
		exit 1
}

_diedata() {
    rmdir "$DATDIR" || _die "Failed to delete the data directory ($DATADIR)"
    _die $1
}

_die2() {
		echo "The service user account '$1' could not be created."
		exit 1
}

_cleanup() {
    if [ -f "$PWDFILE" ]; then
		rm -rf "$PWDFILE"
    fi
}

_validateError() {
    if [ $? -ne 0 -a $? -ne 1 ]; then
        _die "Failed to set timezone"
    fi
}

_createDataDir() {
    echo "** Setting up Data Directory"
    echo "* Creating data directory"
    mkdir -p "$DATADIR" || _die "Failed to create the data directory ($DATADIR)"
    if [ ! -z "$1" ]; then
        chown -R $DB_SUPERUSER:$USER_GROUP "$DATADIR" || _die "Failed to set the ownership of the data directory ($DATADIR)"
        chmod -R 700 "$DATADIR"
    fi
    echo
}

_setupConfDir() {
    echo "** Setting up Configuration Directory"
    if [ ! -d "$EXTCONFDIR" ]; then
        echo "Creating Configuration Directory"
        mkdir -p "${EXTCONFDIR}"
    else
        echo "Configuration Directory already exists. Skipping directory creation."
fi

    if [ ! -f "$EXTCONFDIR/00framework_ext.conf" ]; then
        echo "Copying Framework Configuration"
        cp $DB_HOME/share/postgresql/00framework_ext.conf $EXTCONFDIR/
	else
        echo "Framework Configuration already exists"
    fi
    if [ ! -z "$1" ]; then
        chown -R $DB_SUPERUSER:$USER_GROUP "$EXTCONFDIR" || _die "Failed to set the ownership of the ext_conf directory ($EXTCONFDIR)"
        chmod -R 700 "$EXTCONFDIR"
	fi
    echo
}

_generateAuthFile() {
	  if [ ! "$AUTH_MODE" = "md5" ] && [ ! "$AUTH_MODE" = "scram-sha-256" ] && [ ! "$AUTH_MODE" = "" ]; then
		    echo "Usage : initPgsql.sh <password> <AuthMode(optional)>(md5/scram-sha-256)"
        _die " Invalid AuthMode \"$AUTH_MODE\" supplied. Only md5 or scram-sha-256 is allowed. md5 will be considered if no parameter is supplied."
      fi
      if [ "$AUTH_MODE" = "scram-sha-256" ]; then
    	  AUTH_MODE=scram-sha-256
	  else
    	  AUTH_MODE=md5
	  fi
    echo "* Authentication mode set to $AUTH_MODE"
    touch $PWDFILE || _die "Failed to create the initdb password file (/tmp/initdbpw.$$)"
    chmod 0600 $PWDFILE || _die "Failed to set the permissions on the initdb password file (/tmp/initdbpw.$$)"
    echo "$PASSWORD" > $PWDFILE || _die "Failed to write the initdb password file (/tmp/initdbpw.$$)"
    if [ "$USER_ID" != "0" ]; then
        AUTHMODE="-A $AUTH_MODE --pwfile $PWDFILE"
    else
        AUTHMODE="-A \"$AUTH_MODE\" --pwfile \"$PWDFILE\""
    fi
    if [ ! -z "$1" ]; then
        chown -R $DB_SUPERUSER:$USER_GROUP "$DB_HOME/tmp" || _die "Failed to set the ownership of the tmp directory ($DB_HOME/tmp)"
        chmod -R 700 "$DB_HOME/tmp"
    fi
}

_copyArchiveScript() {
    echo "** Copying Archive Script"
    ARCHIVE_SCRIPT="$SERVER_HOME/tools/postgres/bin/archive.sh"
    if [ ! -f "$ARCHIVE_SCRIPT" ]; then
        echo "Archive Script not found. Skipping copy task"
else
        cp "$SERVER_HOME/tools/postgres/bin/archive.sh" "$DATADIR"
        echo "Archive Script copied successfully"
        if [ ! -z "$1" ]; then
            chown $DB_SUPERUSER:$USER_GROUP "$DATADIR/archive.sh" || _die "Failed to set the ownership of the archive.sh ($DATADIR/archive.sh)"
        fi
        chmod 700 "$DATADIR/archive.sh"
fi
    echo
}

echo "DB Home :: $DB_HOME"
echo "PostgreSQL Version :: $PGSQL_VERSION"
echo "Machine Type :: $MACHINE_TYPE"
echo

if [ ! -d "$DB_HOME/tmp" ]; then
    mkdir -p "$DB_HOME/tmp" || _die "Failed to create the tmp directory ($DB_HOME/tmp)"
fi

if [ ! -d "$DATADIR" ]; then
    if [ -z "$1" ]; then
        echo "Usage : initPgsql.sh <password>"
        _die "Password not supplied"
    else
        PASSWORD=$1
    fi
else
    IS_DATADIR_EXISTS=true
fi

echo "** Setting up PostgreSQL Installation Directory"
chmod -R 755 $(
    cd $SERVER_HOME
    pwd -P
)/tools/postgres/bin/gettimezone*
GETTIMEZONE_BIN=gettimezone
echo

if [ "$USER_ID" != "0" ]; then
    LD_LIBRARY_PATH="/lib:$DB_HOME/extlib:$LD_LIBRARY_PATH"
    if [ "$IS_DATADIR_EXISTS" != "false" ]; then
        echo "** Granting privileges for Data Directory"
        echo "* Resetting Permissions"
        chmod -R 700 $DATADIR
        chmod -R 700 $EXTCONFDIR
        echo "Permission set successfully"
        echo
    else
_createDataDir
        _setupConfDir
        echo "** Initializing Data Directory"
        _generateAuthFile
        echo "* Running initdb"
        "$DB_HOME/bin/initdb" -U $DB_SUPERUSER -D "$DATADIR" --no-locale -E UTF8 $AUTHMODE || _diedata "Failed to initialise the database cluster with initdb"
        echo

        echo "** Granting privileges for Data Directory"
        echo "* Setting Permissions"
        chmod -R 700 $DATADIR
        chmod -R 700 $EXTCONFDIR
        echo
    fi
    echo "** Setting local time zone"
    "$SERVER_HOME/tools/postgres/bin/$GETTIMEZONE_BIN" "$DB_HOME/share/postgresql/" "$EXTCONFDIR/00framework_ext.conf" || _validateError
    echo
    _copyArchiveScript
else
    # Check if the current OS is MAC or Linux
    if [ "$(uname)" = "Darwin" ]; then
        echo "Current OS is MAC"
        USER_GROUP=daemon
        # Create the group if required
        if [ "x$(dscl . -list /users | cut -f2 -d' ' | grep ^$DB_SUPERUSER$)" != "x" ]; then
            HOME_DIR=$(su $DB_SUPERUSER -c "echo \$HOME")
            if [ -e $HOME_DIR ]; then
                echo "User account '$DB_SUPERUSER' already exists"
            else
                echo "User account '$DB_SUPERUSER' already exists - fixing non-existent home directory to $2"
                dscl . create /users/$DB_SUPERUSER home $DATADIR
                # Waiting for home directory to be set.
                # Assuming it will get done in 30 sec.
                echo "Waiting for home directory to be set...."
                count=0
                while [ $count -le 15 ]; do
                    HOME_DIR=$(su $DB_SUPERUSER -c "echo \$HOME")
                    if [ -e $HOME_DIR ]; then
                        break
                    fi
                    sleep 2
                    count=$(expr $count + 1)
                done
            fi
        else
            #Creating new user id for the new user
            NEWUID=$(dscl . list /users uid | awk -F: '{FS=" "; print $2f}' | sort -n | tail -1)
            NEWUID=$(expr $NEWUID + 1)
            echo "** Creating User account $DB_SUPERUSER"
            dscl . create /users/$DB_SUPERUSER || _die $DB_SUPERUSER
            dscl . create /users/$DB_SUPERUSER name $DB_SUPERUSER
            dscl . create /users/$DB_SUPERUSER passwd "*"
            dscl . create /users/$DB_SUPERUSER uid $NEWUID
            dscl . create /users/$DB_SUPERUSER gid 1
            dscl . create /users/$DB_SUPERUSER home $DATADIR
            dscl . create /users/$DB_SUPERUSER shell /bin/bash
            dscl . create /users/$DB_SUPERUSER realname "postgres"
            #Hiding added user from logon screen
            defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add $DB_SUPERUSER
        fi
        echo
    else
        # Create the group if required
        if ! getent group $USER_GROUP >/dev/null; then
            groupadd $USER_GROUP || _die2 $USER_GROUP
        fi

        # Create the user account if required
        USER_HOME_DIR=$DB_HOME
        if getent passwd $DB_SUPERUSER >/dev/null; then
            HOME_DIR=$(su $DB_SUPERUSER -c "echo \$HOME")
            if [ -e $HOME_DIR ]; then
                echo "User account '$DB_SUPERUSER' already exists"
            else
                echo "User account '$DB_SUPERUSER' already exists - fixing non-existent home directory to $USER_HOME_DIR"
                usermod -d "$USER_HOME_DIR" $DB_SUPERUSER
            fi
        else
            echo "** Creating User account $DB_SUPERUSER"
            useradd -m -c "PostgreSQL" -d "$USER_HOME_DIR" -g $USER_GROUP $DB_SUPERUSER || _die $DB_SUPERUSER
            usermod -p "*" $DB_SUPERUSER
        fi
        echo
    fi
    if [ "$IS_DATADIR_EXISTS" != "false" -a -f "$DATADIR/postgresql.conf" ]; then
        echo "** Resetting Ownership"
        echo "* Data Directory"
        chown -R $DB_SUPERUSER:$USER_GROUP "$DATADIR" || _die "Failed to set the ownership of the data directory ($DATADIR)"
        chmod -R 700 "$DATADIR"

        echo "* Temp Directory"
        chown -R $DB_SUPERUSER:$USER_GROUP "$DB_HOME/tmp" || _die "Failed to set the ownership of the tmp directory ($DB_HOME/tmp)"
        chmod -R 700 "$DB_HOME/tmp"

        if [ -d "$EXTCONFDIR" ]; then
            echo "* Configuration Directory"
            chown -R $DB_SUPERUSER:$USER_GROUP "$EXTCONFDIR" || _die "Failed to set the ownership of the ext_conf directory ($EXTCONFDIR)"
            chmod -R 700 "$EXTCONFDIR"
        fi
        if [ -f "$PWDFILE" ]; then
            chown $DB_SUPERUSER:$USER_GROUP $PWDFILE
        fi
        echo
        echo
    else
        _createDataDir $DB_SUPERUSER
        _setupConfDir $DB_SUPERUSER
        echo "** Initializing Data Directory"
        _generateAuthFile $DB_SUPERUSER
        echo "* Running initdb"
        su - $DB_SUPERUSER -c "LD_LIBRARY_PATH=\"/lib:$DB_HOME/extlib:$LD_LIBRARY_PATH\" \"$DB_HOME/bin/initdb\" -U \"$DB_SUPERUSER\" -D \"$DATADIR\" --no-locale -E UTF8 $AUTHMODE" || _diedata "Failed to initialise the database cluster with initdb"
        echo
    fi

    echo "** Setting local time zone"
    su $DB_SUPERUSER -c "\"$SERVER_HOME/tools/postgres/bin/$GETTIMEZONE_BIN\" \"$DB_HOME/share/postgresql/\" \"$EXTCONFDIR/00framework_ext.conf\"" || _validateError
    echo
    _copyArchiveScript $DB_SUPERUSER
fi
_cleanup
echo "$0 ran to completion"
exit $WARN
