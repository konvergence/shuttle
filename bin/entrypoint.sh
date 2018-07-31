#!/usr/bin/env bash
#set -e
source colorecho


# load default env if not defined
source env-defaults.sh


#--------------------------------------------------------------------------------------------


[ ! -z $DEBUG  ] && set -x

# update timezone if TZ is define
timezone_update.sh


if [ "$1" = '--run' ]; then


# wait database available
   echo_yellow "wait database ..."
	${DB_TYPE}_wait.sh
    if [ $? -ne 0 ]; then
		echo_red "database is not running " 
	    exit -1
	fi
	echo_green "database is up - executing command"


# Create license key file
	echo $LICENSEKEY > /tmp/license.lic

# If $DATA_FOLDER/shuttle does not exist then install for the 1st time
    if [ ! -d $DATA_FOLDER/shuttle ]; then
        echo_yellow "First time install, please wait ...."
      	shuttle_install.sh
    fi
	
# If $DATA_FOLDER/shuttle exist but licence key change 
    if [ -d $DATA_FOLDER/shuttle ]; then
		diff /tmp/license.lic /data/shuttle/home/config/license.lic >/dev/null
		if [ $? -ne 0 ]; then
		   echo_yellow "Update licence file with given LICENSEKEY"
			cat  /tmp/license.lic > /data/shuttle/home/config/license.lic
		fi
	fi
		
# Force reinstall if there is any update in variables or if $SHUTTLE_RELEASE != $DATA_FOLDER/shuttle/RELEASE
     if [ -d $DATA_FOLDER/shuttle ]; then


		envsubst < /usr/local/shuttle/autoinstall/${DB_TYPE}_autoinstall.xml > /tmp/autoinstall.xml
		
		if [ ! -f $DATA_FOLDER/shuttle/.autoinstall.xml ]; then
			cp /tmp/autoinstall.xml $DATA_FOLDER/shuttle/.autoinstall.xml
		fi
		
		# if any update in variables, fore reinstall
		diff /tmp/autoinstall.xml $DATA_FOLDER/shuttle/.autoinstall.xml >/dev/null
		if [ $? -ne 0 ]; then
			echo_yellow "Force reinstall cause of updates on variables ..."
			shuttle_install.sh -f
		# if currenrly release not equal to SHUTTLE_RELEASE, force reinstall
		elif [ ! -f $DATA_FOLDER/shuttle/RELEASE ] || [ "${SHUTTLE_RELEASE}" != "$(</data/shuttle/RELEASE)" ] || [ "${FORCE_INSTALL}" == "true" ]; then
			echo_yellow "Force reinstall cause of updates of release ..."
			shuttle_install.sh -f
	    fi
	fi


# Run Tomcat
    # clear catalina temp folder
    rm -rf $CATALINA_BASE/temp/*

    # clear shuttle cache folder
    rm -rf $DATA_FOLDER/shuttle/home/caches/*
	
	# launch tomcat
	exec  $CATALINA_HOME/bin/catalina.sh run


elif [ "$1" = '--install' ]; then
        shift 1

    # Create license key file
		echo $LICENSEKEY > /tmp/license.lic
		
        shuttle_install.sh "$@"
elif [ "$1" = '--cleanup' ]; then
        shift 1
        shuttle_clean.sh "$@"

elif [ "$1" = '--cleanup-database' ]; then
        shift 1
	    echo_red "delete database and user  ..."
        ${DB_TYPE}_clean.sh
	    echo_green "create database and user if needed ..."
		${DB_TYPE}_init.sh
		
elif [ "$1" = '--help' ]; then
	shift 1
    envsubst < /usr/local/shuttle/USAGE.md
else
        exec "$@"

fi
