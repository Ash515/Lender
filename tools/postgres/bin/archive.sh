enable_backup=false
enable_ha_backup=false
USER_ID=`id -g`
if [ -f incremental_backup ]
then
    enable_backup=true
fi
if [ -f full_backup ]
then
	enable_backup=true
fi
if [ -f ha_configured ]
then
	enable_ha_backup=true
fi
_die()
{
		echo $1
		exit 1
}

change_permission()
{
	DB_SUPERUSER=postgres
	DIR_NAME=$1
	# Check if the current OS is MAC or Linux
	if [ "$USER_ID" == "0" ];
	then
		chown -R $DB_SUPERUSER:daemon "$DIR_NAME" || _die "Failed to set the ownership of the data directory ($DIR_NAME)"
	fi
	chmod -R 700 $DIR_NAME
}

if $enable_backup
then
    mkdir -p wal_archive
	change_permission wal_archive
	cp -r $1 wal_archive/$2
	
	echo "$2 file has been copied to the archive folder - wal_archive/"
fi

if $enable_ha_backup
then
    mkdir -p ha_wal_archive
	change_permission ha_wal_archive
	cp -r $1 ha_wal_archive/$2
	
	echo "$2 file has been copied to the archive folder - ha_wal_archive/"
fi