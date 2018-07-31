#!/bin/bash

[ ! -z $DEBUG  ] && set -x

DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then


sqlline_run.sh <<-EOF
	!connect "jdbc:mysql://$DB_HOST:$DB_PORT" $DB_SYSTEM_USER $DB_SYSTEM_PASSWORD
	
     CREATE USER '${DB_SHUTTLE_USER}' IDENTIFIED BY '${DB_SHUTTLE_PASSWORD}';

	CREATE DATABASE ${DB_SHUTTLE_REPO};
	
	GRANT ALL PRIVILEGES ON ${DB_SHUTTLE_REPO}.* TO '${DB_SHUTTLE_USER}';
	
	
	!quit
EOF


fi
