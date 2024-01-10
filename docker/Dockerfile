ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME}

ARG REPO_URL_WITH_TOKEN
ARG REPO_NAME
ARG BRANCH
ARG DPS_MACHINE_TOKEN
ARG BUILD_CMD='$(echo "NO BUILD CMD SPECIFIFED")'
USER root

RUN apt-get update && apt-get install curl jq -y

RUN mkdir /app
WORKDIR /app

#RUN pip install --upgrade pip setuptools wheel
#RUN pip install -Iv urllib3==1.21.1 
#RUN pip install awscli awsebcli boto3==1.15.18 --upgrade
#RUN pip install awscli botocore==1.18.18 --upgrade

RUN git config --global http.sslverify false

# https://docs.anaconda.com/anaconda/install/multi-user/?highlight=chgrp#multi-user-anaconda-installation-on-linux
RUN groupadd -g 1003 ops && useradd --uid 1001 --gid 1003 --create-home ops && \
    chgrp -R ops /opt/conda && chmod -R 770 /opt/conda

COPY dps_wrapper.py /app/dps_wrapper.py
COPY dps_wrapper.sh /app/dps_wrapper.sh
COPY pre_dps_wrapper.py /app/pre_dps_wrapper.py
COPY get_param.py /app/get_param.py
COPY get_username.py /app/get_username.py

# copy over docker stats shim utility
COPY docker_stats/docker-stats-on-exit-shim /docker-stats-on-exit-shim

# copy over bash scripts for entrypoints
COPY docker_stats/entrypoint-common.sh /entrypoint-common.sh
COPY docker_stats/entrypoint-pge-common.sh /entrypoint-pge-common.sh
COPY docker_stats/entrypoint-pge-with-stats.sh /entrypoint-pge-with-stats.sh

RUN chmod 777 /docker-stats-on-exit-shim /entrypoint-pge-with-stats.sh

# set entrypoint
# ENTRYPOINT ["/entrypoint-pge-with-stats.sh"]
ARG CACHE_BUST
USER root
ENV CACHE_BUST=${CACHE_BUST}
ENV DPS_MACHINE_TOKEN=${DPS_MACHINE_TOKEN}
RUN git clone ${REPO_URL_WITH_TOKEN} && \
    cd ${REPO_NAME} && \
    git checkout ${BRANCH}
RUN chgrp -R ops /app && chmod -R 775 /app
RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

USER ops
ENV MAAP_CONF='/maap-py/'
RUN bash ${BUILD_CMD}
RUN find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy
CMD ["/bin/bash"]
