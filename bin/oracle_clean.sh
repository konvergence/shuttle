#!/bin/bash

[ ! -z $DEBUG  ] && set -x



#--------------------------------------------------------------------------------------------
# Create tablespace function
drop_tablespace() {
        echo_yellow  drop tablespace for ${DB_SHUTTLE_REPO}
	sqlline_run.sh <<-EOF
	!connect "jdbc:oracle:thin:@//${DB_HOST}:${DB_PORT}/${DB_INSTANCE}" ${DB_SYSTEM_USER} ${DB_SYSTEM_PASSWORD}
	
	DROP TABLESPACE ${DB_SHUTTLE_REPO}  INCLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS;

	!quit
EOF

}

#--------------------------------------------------------------------------------------------
drop_user() {
        echo_yellow  drop user for ${DB_SHUTTLE_USER}
	sqlline_run.sh <<-EOF
	!connect "jdbc:oracle:thin:@//${DB_HOST}:${DB_PORT}/${DB_INSTANCE}" ${DB_SYSTEM_USER} ${DB_SYSTEM_PASSWORD}
	
	DROP USER ${DB_SHUTTLE_USER} CASCADE;

	!quit
EOF

}

DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then


drop_user
drop_tablespace

fi
