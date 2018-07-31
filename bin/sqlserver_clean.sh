#!/bin/bash

[ ! -z $DEBUG  ] && set -x


sqlline_run.sh <<-EOF
	!connect "jdbc:sqlserver://${DB_HOST}:${DB_PORT};databaseName=master;" ${DB_SYSTEM_USER} ${DB_SYSTEM_PASSWORD}
		USE  ${DB_SHUTTLE_REPO};
		DROP USER ${DB_SHUTTLE_USER} ;
		
		USE master;
		DROP LOGIN ${DB_SHUTTLE_USER};
		
	!quit
	

EOF


