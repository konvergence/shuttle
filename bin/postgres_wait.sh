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


# create user and databases
export PGPASSWORD=${USER_PWD}

#!/bin/bash 
COUNTER=0
until [  $COUNTER -ge  ${DB_MAX_WAIT} ] || psql -P pager=off --host=${DB_HOST} --port=${DB_PORT} --username=${USER_DB} -c '\l' ; do
    echo "database is unavailable - sleeping"
  sleep 1
  let COUNTER=COUNTER+1 
done

if  [  $COUNTER -ge  ${DB_MAX_WAIT} ]; then
	 exit -1
else
	exit 0
fi
