#rem $Id$
#!/bin/sh
### ====================================================================== ###
##                                                                          ##
## change_datadir_perm.sh  <path-to-data-directory>
##                                                                          ##
### ====================================================================== ###

# Script file to change PostgreSQL datadirectory permission in Linux/Mac OS

DIRNAME=`dirname $0`
uname -a
. $DIRNAME/setCommonEnv.sh

DB_SUPERUSER=postgres
WARN=0

_die()
{
		echo $1
		echo "Failed."
		exit 1
}

# Setting default data-directory and DB_HOME if the data-dir argument is not given
if [ ! -z "$1" ];
then
	DATADIR=$1
	DB_HOME=$(cd $DATADIR/..; pwd -P)
else
	DB_HOME=$(cd ../../../bin/$DB_HOME; pwd -P) 
	DATADIR=$DB_HOME/data
fi

# Check if the data directory is exists, if not found then exit. 
if [ ! -d "$DATADIR" ];
then
    _die "Invalid argument :: Unknown data directory path [$DATADIR] specified"		
fi

# Creating tmp directory for sock file.
if [ ! -d "$DB_HOME/tmp" ];
then
    mkdir -p "$DB_HOME/tmp" || _die "Failed to create the data directory ($DATADIR)"
fi

# setting the appropriate permissions/ownership
USER_ID=`id -g`
if [ "$USER_ID" != "0" ];
then
    chmod -R 700 $DATADIR
    chmod -R 700 $DB_HOME/tmp
else
    # Check if the current OS is MAC or Linux
    if [ "$(uname)" = "Darwin" ];
    then
        echo "Current OS is MAC"
				# Create the group if required
        if [ "x`dscl . -list /users|cut -f2 -d' '|grep ^$DB_SUPERUSER\$`" != "x" ];
        then
            HOME_DIR=`su $DB_SUPERUSER -c "echo \\\$HOME"`
            if [ -e $HOME_DIR ]; then
                echo "WARNING : User account '$DB_SUPERUSER' already exists"
            else
                echo "WARNING : User account '$DB_SUPERUSER' already exists - fixing non-existent home directory to $2"
                dscl . create /users/$DB_SUPERUSER home $DATADIR
                # Waiting for home directory to be set.
                # Assuming it will get done in 30 sec.
                echo "Waiting for home directory to be set...."
                count=0
                while [ $count -le 15 ]
                do
                    HOME_DIR=`su $DB_SUPERUSER -c "echo \\\$HOME"`
                    if [ -e $HOME_DIR ]; then
                        exit 0
                    fi
                    sleep 2
                    count=`expr $count + 1`
                done
                exit 0
            fi
        else
						#Creating new user id for the new user
            NEWUID=`dscl . list /users uid | awk -F: '{FS=" "; print $2f}' | sort -n | tail -1`
            NEWUID=`expr $NEWUID + 1`
						echo "Creating User account postgres."
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
        chown -R $DB_SUPERUSER:daemon "$DATADIR" || _die "Failed to set the ownership of the data directory ($DATADIR)"
        chmod -R 700 "$DATADIR"
        chown -R $DB_SUPERUSER:daemon "$DB_HOME/tmp" || _die "Failed to set the ownership of the tmp directory ($DATADIR)"
        chmod -R 700 "$DB_HOME/tmp"
        if [ -f "$PWDFILE" ];
        then
            chown $DB_SUPERUSER:daemon $PWDFILE
        fi
    else
        # Create the group if required
        if ! getent group  $DB_SUPERUSER > /dev/null
        then
            groupadd  $DB_SUPERUSER || _die $DB_SUPERUSER
        fi

        # Create the user account if required
        USER_HOME_DIR=$DB_HOME
        if getent passwd  $DB_SUPERUSER > /dev/null
        then
            HOME_DIR=`su $DB_SUPERUSER -c "echo \\\$HOME"`
            if [ -e $HOME_DIR ]; then
                echo "WARNING : User account '$DB_SUPERUSER' already exists"
            else
                echo "WARNING : User account '$DB_SUPERUSER' already exists - fixing non-existent home directory to $USER_HOME_DIR"
                usermod -d "$USER_HOME_DIR"  $DB_SUPERUSER
                exit 0
            fi
        else
            useradd -m -c "PostgreSQL" -d "$USER_HOME_DIR" -g  $DB_SUPERUSER  $DB_SUPERUSER || _die $DB_SUPERUSER
            usermod -p "*"  $DB_SUPERUSER
        fi
        chown -R $DB_SUPERUSER:$DB_SUPERUSER "$DATADIR" || _die "Failed to set the ownership of the data directory ($DATADIR)"
        chmod -R 700 "$DATADIR"
        chown -R $DB_SUPERUSER:$DB_SUPERUSER "$DB_HOME/tmp" || _die "Failed to set the ownership of the tmp directory ($DATADIR)"
        chmod -R 700 "$DB_HOME/tmp"
    fi
fi
echo "$0 ran to completion. Done"
exit $WARN
