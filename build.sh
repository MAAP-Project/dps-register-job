#!/usr/bin/env bash

VERDI_HOME=/home/ops/verdi
source ${VERDI_HOME}/bin/activate
export SKIP_PUBLISH="noskip"
source ${PWD}/config.txt
set -ex
isSet=1
for var in S3_CODE_BUCKET MOZART_URL GRQ_REST_URL
do
    if [ -z "${!var}" ]; then
        echo "${var} not set"
        isSet=""
    fi
done
if [ -z "${isSet}" ]; then
    echo "One or more variable is not set"
    exit 1
fi
CONTAINER_REGISTRY=localhost5050
CACHE_BUST=$(date +%s)
${VERDI_HOME}/ops/container-builder/build-container.bash ${REPO_NAME} ${BRANCH} ${S3_CODE_BUCKET} ${MOZART_URL} ${GRQ_REST_URL} ${SKIP_PUBLISH} ${CONTAINER_REGISTRY} --build-arg BASE_IMAGE_NAME=${BASE_IMAGE_NAME} --build-arg REPO_URL_WITH_TOKEN=${REPO_URL_WITH_TOKEN} --build-arg REPO_NAME=${REPO_NAME} --build-arg BRANCH=${BRANCH} --build-arg BUILD_CMD="${BUILD_CMD}" --build-arg CACHE_BUST=${CACHE_BUST}

