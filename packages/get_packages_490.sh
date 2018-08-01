#!/bin/bash

RELEASE_MAJOR="4.9"
RELEASE_MINOR="0"
SERVER_BUILD="29404"

SHUTTLE_REPO=https://constellium.konvergence.com/projects/shuttle-packages/repository/raw/${RELEASE_MAJOR}

rm -rf installer/*
rm -rf patches/module/*
rm -rf patches/server/*
rm -rf patches/client/*
rm -rf patches/class/*

read -p "CONSTELLIUM_USER:" CONSTELLIUM_USER
read -s -p "CONSTELLIUM_PASSWORD:" CONSTELLIUM_PASSWORD

bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD} ${SHUTTLE_REPO}/ShuttleInstaller-4.9.0.29404.jar                                       installer/ShuttleInstaller-4.9.0.29404.jar
bash constellium_download_cred.sh ${CONSTELLIUM_USER} ${CONSTELLIUM_PASSWORD} ${SHUTTLE_REPO}/documentation/ShuttleDocumentation-4.9.zip                             documentation/ShuttleDocumentation-4.9.zip
