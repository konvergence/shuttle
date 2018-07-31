#!/bin/bash

[ ! -z $DEBUG  ] && set -x

DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then

sqlline_run.sh <<-EOF
	!connect "jdbc:mysql://$DB_HOST:$DB_PORT" $DB_SYSTEM_USER $DB_SYSTEM_PASSWORD
	
     DROP USER '${DB_SHUTTLE_USER}' ;

	DROP DATABASE ${DB_SHUTTLE_REPO};
	
	
	
	!quit
EOF


fi