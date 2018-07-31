#!/bin/bash

[ ! -z $DEBUG  ] && set -x


sqlline_run.sh <<-EOF

	!connect "jdbc:sqlserver://${DB_HOST}:${DB_PORT};databaseName=master;" ${DB_SYSTEM_USER} ${DB_SYSTEM_PASSWORD}

	CREATE DATABASE ${DB_SHUTTLE_REPO};

    ALTER DATABASE ${DB_SHUTTLE_REPO} MODIFY FILE ( NAME = '${DB_SHUTTLE_REPO}' , SIZE = 10240KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB );
    ALTER DATABASE ${DB_SHUTTLE_REPO} MODIFY FILE ( NAME = '${DB_SHUTTLE_REPO}_Log' , SIZE =  1536KB , MAXSIZE = 2048GB , FILEGROWTH = 10%);
	ALTER DATABASE ${DB_SHUTTLE_REPO}  SET RECOVERY SIMPLE WITH NO_WAIT;

	CREATE LOGIN ${DB_SHUTTLE_USER} WITH PASSWORD='${DB_SHUTTLE_PASSWORD}', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF ;
	
	USE  ${DB_SHUTTLE_REPO};
	CREATE USER  ${DB_SHUTTLE_USER} FOR LOGIN  ${DB_SHUTTLE_USER} WITH DEFAULT_SCHEMA=[dbo];
	EXECUTE sp_addrolemember N'db_owner', N'${DB_SHUTTLE_USER}';
	!quit
	
EOF


