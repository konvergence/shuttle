#!/bin/bash

[ ! -z $DEBUG  ] && set -x

DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then

# create user and databases
export PGPASSWORD=${DB_SYSTEM_PASSWORD}
psql --host=${DB_HOST} -P pager=off --port=${DB_PORT} --username=${DB_SYSTEM_USER}  <<-EOF
	CREATE ROLE   "${DB_SHUTTLE_USER}" WITH PASSWORD '${DB_SHUTTLE_PASSWORD}' VALID UNTIL 'infinity';
         ALTER ROLE  "${DB_SHUTTLE_USER}" WITH LOGIN;


         CREATE DATABASE "${DB_SHUTTLE_REPO}"
		WITH OWNER="${DB_SHUTTLE_USER}"
		ENCODING='UTF8'
		TEMPLATE=template0
		LC_COLLATE='C'
		LC_CTYPE='C' ;


     GRANT ALL PRIVILEGES ON DATABASE "${DB_SHUTTLE_REPO}" TO    "${DB_SHUTTLE_USER}";

EOF

fi

