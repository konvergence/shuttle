#!/bin/bash

[ ! -z $DEBUG  ] && set -x


#--------------------------------------------------------------------------------------------
# Create tablespace function
create_tablespace() {
        echo_yellow  create tablespace for ${DB_SHUTTLE_REPO}
	sqlline_run.sh <<-EOF
	!connect "jdbc:oracle:thin:@//${DB_HOST}:${DB_PORT}/${DB_INSTANCE}" ${DB_SYSTEM_USER} ${DB_SYSTEM_PASSWORD}
	 CREATE TABLESPACE  ${DB_SHUTTLE_REPO} 
                DATAFILE SIZE 268435456 
                  AUTOEXTEND ON NEXT 12800 
                MAXSIZE 34359721984 
                EXTENT MANAGEMENT LOCAL 
                AUTOALLOCATE 
                ONLINE;
	!quit
EOF

}

#--------------------------------------------------------------------------------------------
create_user() {
        echo_yellow  create user for ${DB_SHUTTLE_USER}
	sqlline_run.sh <<-EOF
	!connect "jdbc:oracle:thin:@//$DB_HOST:$DB_PORT/$DB_INSTANCE" $DB_SYSTEM_USER $DB_SYSTEM_PASSWORD
	ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
	
		create user ${DB_SHUTTLE_USER} identified by ${DB_SHUTTLE_PASSWORD}  default tablespace ${DB_SHUTTLE_REPO} temporary tablespace TEMP profile DEFAULT;
                grant RESOURCE to ${DB_SHUTTLE_USER};
                grant CONNECT to ${DB_SHUTTLE_USER};
                grant CREATE PROCEDURE to ${DB_SHUTTLE_USER};
                grant CREATE VIEW to ${DB_SHUTTLE_USER};
                grant CREATE DATABASE LINK to ${DB_SHUTTLE_USER};
                grant CREATE SEQUENCE to ${DB_SHUTTLE_USER};
                grant CREATE SYNONYM to ${DB_SHUTTLE_USER};
                grant CREATE TYPE to ${DB_SHUTTLE_USER};
                grant CREATE TABLE to ${DB_SHUTTLE_USER};
                grant CREATE SESSION to ${DB_SHUTTLE_USER};
                grant CREATE TRIGGER to ${DB_SHUTTLE_USER};
                alter user ${DB_SHUTTLE_USER} default role RESOURCE,CONNECT;
				alter user ${DB_SHUTTLE_USER} quota unlimited on ${DB_SHUTTLE_REPO};
	!quit
EOF

}

DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then

create_tablespace
create_user
fi
