#!/bin/bash


DB_CREATE_USER=${DB_CREATE_USER:-true}

if [ "$DB_CREATE_USER" == "true" ]; then

# create user and databases
export PGPASSWORD=${DB_SYSTEM_PASSWORD}
psql --host=${DB_HOST} -P pager=off --port=${DB_PORT} --username=${DB_SYSTEM_USER}  <<-EOF


    DROP DATABASE "${DB_SHUTTLE_REPO}";
	DROP ROLE  "${DB_SHUTTLE_USER}";



EOF


fi
