#!/bin/bash

[ ! -z $DEBUG  ] && set -x

function urlencode() {
    # urlencode <string>
    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C
    
    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done
    
    LC_COLLATE=$old_lc_collate
}

function urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}


function download() {

	URL_LOGIN=https://constellium.konvergence.com/login
	CONSTELLIUM_USER=$1
	CONSTELLIUM_PASSWORD=$2
	URL_FILE=$3
	OUTPUT_FILE=$4

	echo get CONSTELLIUM_USER
	USER=${CONSTELLIUM_USER}
	echo get CONSTELLIUM_PASSWORD
	PASS=${CONSTELLIUM_PASSWORD}
	
	
	# https://constellium.konvergence.com/login
   [ -z "${URL_LOGIN}" ] && echo "URL_LOGIN No supplied" && return 1

	# https://constellium.konvergence.com/projects/base-de-connaissances-partners/repository/repo-partners-sources/raw/4.6/ShuttleInstaller-4.6.0.26304.jar   
   [ -z "${URL_FILE}" ] && echo "URL_FILE No supplied" && return 1
   
   [ -z "${USER}" ] && echo "USER No supplied" && return 1
   [ -z "${PASS}" ] && echo "PASS No supplied" && return 1
   [ -z "${OUTPUT_FILE}" ] && echo "OUTPUT_FILE No supplied" && return 1
   
   cookie_file=$(mktemp)


	CURL_CONFIGS="--silent --show-error --fail --insecure --location -b ${cookie_file} -c  ${cookie_file}"
	CURL_CONFIGS2="--show-error --fail --insecure --location  -b ${cookie_file} -c  ${cookie_file}"
	
	
	# Fetch CSRF authenticity token
	echo Fetch CSRF authenticity token
	CSRF1=$(curl $CURL_CONFIGS ${URL_LOGIN} | grep "name=\"authenticity_token" | sed 's/.*value="\(.*\)".*/\1/')

	if [[ $? -ne 0  ]]; then
		echo "Error getting csrf token"
		echo $CSRF1
    	rm -f $cookie_file
		return -1
	fi

	# Login
	echo Login to CONSTELLIUM
	HTML=$(curl $CURL_CONFIGS -d "login=Login&username=$(urlencode ${USER})&password=$(urlencode ${PASS})&authenticity_token=$(urlencode ${CSRF1})" ${URL_LOGIN})
	if [[ $? -ne 0  ]]; then
		echo "Error logging in"
    	rm -f $cookie_file
		return -1
	fi

	# Download file
	echo download $URL_FILE
	curl $CURL_CONFIGS2 $URL_FILE -o $OUTPUT_FILE
	if [[ $? -ne 0  ]]; then
		echo "Error downloading backup file" 
    	rm -f $cookie_file
		return -1
	fi

# clear cookie file
    rm -f $cookie_file
	return 0


}

download "$@" 

