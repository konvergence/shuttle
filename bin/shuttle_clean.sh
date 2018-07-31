#!/usr/bin/env bash

# stop on first error
##set -e

source colorecho



[ -z "$DB_TYPE" ] && echo_red please define DB_TYPE && exit 1
[ -z "$DB_SYSTEM_USER" ] && echo_red please define DB_SYSTEM_USER &&  exit 1
[ -z "$DB_SYSTEM_PASSWORD" ] && echo_red please define DB_SYSTEM_PASSWORD &&  exit 1
[ -z "$DB_HOST" ] && echo_red please define DB_HOST && exit 1
[ -z "$DB_PORT" ] && echo_red please define DB_PORT && exit 1


[ -z "$DB_SHUTTLE_REPO" ] && echo_red please define DB_SHUTTLE_REPO && exit 1
[ -z "$DB_SHUTTLE_USER" ] && echo_red please define DB_SHUTTLE_USER && exit 1
[ -z "$DB_SHUTTLE_PASSWORD" ] && echo_red please define DB_SHUTTLE_PASSWORD && exit 1





#--------------------------------------------------------------------------------------------
usage() {
       echo "Usage: $0 [-f]" 1>&2;
       exit 1;
}



# monitor $logfile
monitor() {
    tail -F -n 0 $1 | while read line; do echo -e "$2: $line"; done
}




#--------------------------------------------------------------------------------------------
cleanup() {


echo_yellow "start cleanup  ... $1"

	if [ -d $DATA_FOLDER/shuttle  ] ; then

			rm -rf $DATA_FOLDER/shuttle
		
	    # create schema / user for DB_TYPE
		${DB_TYPE}_clean.sh
		
	fi


}


#--------------------------------------------------------------------------------------------
# main
#--------------------------------------------------------------------------------------------
force=0
while getopts "f" opt; do
         case $opt in
             f)
                force=1
                ;;
             *)
               usage
               ;;
         esac
done

shift $((OPTIND-1))


#if [ $# -eq 0 ]; then
#   usage
#   exit 1
#fi



cleanup
