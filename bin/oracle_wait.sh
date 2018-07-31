#!/bin/bash
# wait-for-postgres.sh

[ ! -z $DEBUG  ] && set -x


DB_MAX_WAIT=${DB_MAX_WAIT:-30}
DB_CREATE_USER=${DB_CREATE_USER:-true}

USER_DB=${DB_SHUTTLE_USER}
USER_PWD=${DB_SHUTTLE_PASSWORD}


if [ "$DB_CREATE_USER" == "true" ]; then
    USER_DB=${DB_SYSTEM_USER}
    USER_PWD=${DB_SYSTEM_PASSWORD}
fi


COUNTER=0
until [  $COUNTER -ge  ${DB_MAX_WAIT} ] || sqlline_run.sh <<-EOF
	!connect "jdbc:oracle:thin:@//${DB_HOST}:${DB_PORT}/${DB_INSTANCE}" ${USER_DB} ${USER_PWD}
	!quit
EOF
do
   echo "database is unavailable - sleeping"
  sleep 1
  let COUNTER=COUNTER+1 
done

if  [  $COUNTER -ge  ${DB_MAX_WAIT} ]; then
	 exit -1
else
	exit 0
fi
