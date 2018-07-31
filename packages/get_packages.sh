#!/bin/bash

RELEASE_MAJOR="4.8"
RELEASE_MINOR="1"
SERVER_BUILD="29276"

SHUTTLE_REPO=https://constellium.konvergence.com/projects/base-de-connaissances-partners/repository/repo-partners-sources/raw/${RELEASE_MAJOR}.${RELEASE_MINOR}

rm -rf installer/*
rm -rf patches/module/*
rm -rf patches/server/*
rm -rf patches/client/*
rm -rf patches/class/*

read -p "CONSTELLIUM_USER:" CONSTELLIUM_USER
read -s -p "CONSTELLIUM_PASSWORD:" CONSTELLIUM_PASSWORD
	
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD} ${SHUTTLE_REPO}/ShuttleInstaller-4.8.1.28881.jar                                         installer/ShuttleInstaller-4.8.1.28881.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD} ${SHUTTLE_REPO}/documentation/ShuttleDocumentation-4.8.1.zip                             documentation/ShuttleDocumentation-4.8.1.zip


bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.28924/Plugin.ManageDatamartObjects-4.8.1.28924.jar  patches/module/Plugin.ManageDatamartObjects-4.8.1.28924.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.28924/shuttle-vdb-4.8.1.28924.jar                   patches/server/shuttle-vdb-4.8.1.28924.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.29092/shuttle-security-4.8.1.29092.jar              patches/server/shuttle-security-4.8.1.29092.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.29092/shuttle-sdk-4.8.1.29092.jar                   patches/server/shuttle-sdk-4.8.1.29092.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.29092/shuttle-commons-utils-4.8.1.29092.jar         patches/server/shuttle-commons-utils-4.8.1.29092.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD}  ${SHUTTLE_REPO}/Patches/Server/4.8.1.29276/shuttle-schema-4.8.1.29276.jar                patches/server/shuttle-schema-4.8.1.29276.jar