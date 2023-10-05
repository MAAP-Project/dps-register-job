#!/bin/bash

# Wraps the user script to create the correct DPS output dir
# for staging and publish to S3

POSITIONAL_ARGS=${@:2}
USER_SCRIPT=$1
source /home/ops/.bashrc
mkdir input
python /app/pre_dps_wrapper.py

# For plant image we need to activate base conda env as we run as user ops and not root
# Allowed to fail
export PROJ_LIB=/opt/conda/share/proj
export GDAL_DATA=/opt/conda/share/gdal

set -ex

USERNAME=$(python /app/get_username.py)
export MAAP_PGT=$(curl -sb -H "Accept: application/json" -H "Content-Type: application/json" -H "dps-token: $DPS_MACHINE_TOKEN" https://api.maap-project.org/api/members/$USERNAME | jq -r '.session_key')
unset DPS_MACHINE_TOKEN

${USER_SCRIPT} "${@:2}" || (cp _stderr.txt _alt_traceback.txt && exit 1)

USER_OUTPUT_DIR="output"

DIRNAME=$(date +"%Y-%m-%dT%H:%M:%S.%6N")
DATASET_NAME="output-$DIRNAME"

if [ ! -d ${USER_OUTPUT_DIR} ]; then
    mkdir -p ${USER_OUTPUT_DIR}
fi

cp -v _std* ${USER_OUTPUT_DIR}/

mv ${USER_OUTPUT_DIR} ${DATASET_NAME}

python /app/dps_wrapper.py ${DATASET_NAME}


