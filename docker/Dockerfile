ARG BASE_IMAGE_NAME
FROM ${BASE_IMAGE_NAME}

ARG REPO_URL_WITH_TOKEN
ARG REPO_NAME
ARG BRANCH
RUN mkdir /app
WORKDIR /app
RUN git clone ${REPO_URL_WITH_TOKEN} && \
    cd ${REPO_NAME} && \
    git checkout ${BRANCH}

COPY dps_wrapper.py /app/dps_wrapper.py
COPY dps_wrapper.sh /app/dps_wrapper.sh
COPY pre_dps_wrapper.py /app/pre_dps_wrapper.py

RUN chmod -R 775 /app
# copy over docker stats shim utility
COPY docker_stats/docker-stats-on-exit-shim /docker-stats-on-exit-shim

# copy over bash scripts for entrypoints
COPY docker_stats/entrypoint-common.sh /entrypoint-common.sh
COPY docker_stats/entrypoint-pge-common.sh /entrypoint-pge-common.sh
COPY docker_stats/entrypoint-pge-with-stats.sh /entrypoint-pge-with-stats.sh

RUN chmod a+x /docker-stats-on-exit-shim /entrypoint-pge-with-stats.sh

# set entrypoint
ENTRYPOINT ["/entrypoint-pge-with-stats.sh"]

CMD ["/bin/bash", "--login"]
