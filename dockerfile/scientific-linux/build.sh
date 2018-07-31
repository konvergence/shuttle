#!/bin/bash


# Define BUILD_FOLDER
pushd $(dirname $0)
DOCKER_FILENAME=Dockerfile
BUILD_FOLDER=$PWD/../..
popd

DOCKER_REPO=konvergence/shuttle

# Release build is the last SVN release that include all previous build release for client or server
SHUTTLE_INSTALLER_RELEASE="4.8.1.28881"

RELEASE_MAJOR="4.8"
RELEASE_MINOR="1"
SERVER_BUILD="29276"

SHUTTLE_RELEASE=${RELEASE_MAJOR}.${RELEASE_MINOR}.${SERVER_BUILD}
IMAGE_BUILD=24


# Release Build of the Docker Image
# Final Docker Image Name
IMAGE_TAG=${SHUTTLE_RELEASE}.${IMAGE_BUILD}-sl




#-------------------------------------------------------------------------------------------------------
echo "Building image  ${DOCKER_REPO}:${IMAGE_TAG} ..."
#BUILD_OPTIONS="--force-rm=true --no-cache=true"
docker build $BUILD_OPTIONS -t ${DOCKER_REPO}:${IMAGE_TAG}  \
        --build-arg SHUTTLE_INSTALLER_RELEASE=${SHUTTLE_INSTALLER_RELEASE} \
        --build-arg RELEASE_MAJOR=${RELEASE_MAJOR} \
        --build-arg RELEASE_MINOR=${RELEASE_MINOR} \
        --build-arg SHUTTLE_RELEASE=${SHUTTLE_RELEASE} \
        --file ${DOCKER_FILENAME} \
        ${BUILD_FOLDER}

        if [ $? -eq 0 ]; then
			echo "Local Image created: ${DOCKER_REPO} "
			docker images ${DOCKER_REPO}
		else
		    echo docker builld return error code $?
        fi


