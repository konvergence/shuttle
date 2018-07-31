#!/bin/sh

export DEBUG=${DEBUG:-}



[ -z "${CATALINA_OPTS}" ] && export  CATALINA_OPTS="-Xms512m -Xmx8192m -XX:MaxPermSize=256m -Dfile.encoding=UTF-8 -Djava.awt.headless=true"

export TZ=${TZ:-Europe/Paris}

export DATA_FOLDER=${DATA_FOLDER:-/data}
export CATALINA_BASE=${CATALINA_BASE:-/data/shuttle/instance}

export DB_MAX_WAIT=${DB_MAX_WAIT:-30}
export DB_HOST=${DB_HOST:-db}
export DB_PORT=${DB_PORT:-5432}
export DB_TYPE=${DB_TYPE:-postgres}
export DB_CREATE_USER=${DB_CREATE_USER:-true}
export DB_SYSTEM_USER=${DB_SYSTEM_USER:-postgres}
export DB_SYSTEM_PASSWORD=${DB_SYSTEM_PASSWORD:-mysecretpassword}
export DB_SHUTTLE_REPO=${DB_SHUTTLE_REPO:-SHUT_REPO}
export DB_SHUTTLE_USER=${DB_SHUTTLE_USER:-shuttle}
export DB_SHUTTLE_PASSWORD=${DB_SHUTTLE_PASSWORD:-password}
export DB_INSTANCE=${DB_INSTANCE:-ORCLCDB}
export WEBAPP_NAME=${WEBAPP_NAME:-Shuttles}
export EXTERNAL_URL_PROTOCOL=${EXTERNAL_URL_PROTOCOL:-http}
export EXTERNAL_URL_PORT=${EXTERNAL_URL_PORT:-8080}
export EXTERNAL_URL_SERVER=${EXTERNAL_URL_SERVER:-localhost}
export KERBEROS_ENABLE=${KERBEROS_ENABLE:-false}
export PROXY_ENABLE=${PROXY_ENABLE:-true}
export PROXY_HOST=${PROXY_HOST:-}
export PROXY_PORT=${PROXY_PORT:-0}
export PROXY_USER=${PROXY_USER:-}
export PROXY_PASSWORD=${PROXY_PASSWORD:-}


export CLIENT_USESSL=${CLIENT_USESSL:-false}
[ "${EXTERNAL_URL_PROTOCOL}" == "https" ] && export CLIENT_USESSL=true

export PROXY_USE_SHUTTLE_CREDENTIALS=${PROXY_USE_SHUTTLE_CREDENTIALS:-false}
#[ -z "${PROXY_USER}" ] && [ -z "${PROXY_PASSWORD}" ] && export PROXY_USE_SHUTTLE_CREDENTIALS=true


export PROXY_USE_DEFAULT_CONFIG=${PROXY_USE_DEFAULT_CONFIG:-false}
[ -z "${PROXY_HOST}" ] && [ -z "${PROXY_PORT}" ] && export PROXY_USE_DEFAULT_CONFIG=true


## update for 4.7
export SAML_ENABLE=${SAML_ENABLE:-false}
export SSO_ENABLE=${SSO_ENABLE:-false}
export SSO_TYPE=${SSO_TYPE:-kerb}
([ "${SAML_ENABLE}" ==  "true" ] || [ "${KERBEROS_ENABLE}" ==  "true" ]) && export SSO_ENABLE=true
[ "${SAML_ENABLE}" ==  "true" ] && export SSO_TYPE=saml


export FORCE_INSTALL=${FORCE_INSTALL:-false}
export ALTERNATE_CONNEXION=${ALTERNATE_CONNEXION:-true}
export DEFAULT_CONNEXION_NAME=${DEFAULT_CONNEXION_NAME:-Default}
export ALTERNATE_CONNEXION_NAME=${ALTERNATE_CONNEXION_NAME:-standard}

export JAXWS_ENABLE_MTOM=${JAXWS_ENABLE_MTOM:-true}

## update for 4.8
export FORCE_SUPERUSER=${FORCE_SUPERUSER:-false}
export FORCE_ADMIN=${FORCE_ADMIN:-false}
export ADMIN_PASSWORD=${ADMIN_PASSWORD:-}
export SUPERUSER_PASSWORD=${SUPERUSER_PASSWORD:-}

# allow JMX and/or Jolokia connection
export JMX_ENABLE=${JMX_ENABLE:-false}
export JMX_REGISTRYPORT=${JMX_REGISTRYPORT:-8086}
export JMX_SERVERPORT=${JMX_SERVERPORT:-8087}
export JOLOKIA_ENABLE=${JOLOKIA_ENABLE:-false}

export DISABLE_CONNEXIONS=${DISABLE_CONNEXIONS:-false}
export ALTERNATE_TRANSLATE=${ALTERNATE_TRANSLATE:-false}

