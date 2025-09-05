#Allow optionally using the remote script

# Intricate argument dance to determine if the script is to be pulled from remote or used locally
ARG SCRIPT_REF
ARG SCRIPT_BRANCH
ARG SCRIPT_TAG
ARG SCRIPT_REMOTE_REF=${SCRIPT_REF:-${SCRIPT_BRANCH:-${SCRIPT_TAG}}}
ARG SCRIPT_REMOTE=${SCRIPT_REMOTE_REF:+remote}
# Set SCRIPT_LOCATION to remote directly in the build args to use the default remote file (master branch).
ARG SCRIPT_LOCATION=${SCRIPT_REMOTE:-local}

FROM python:3-alpine AS local
COPY rtl_433_mqtt_hass.py /rtl_433_mqtt_hass.py

FROM python:3-alpine AS remote
# Specific commit
ARG SCRIPT_REF

# Specific branch
ARG SCRIPT_BRANCH
ARG SCRIPT_BRANCH_PATH=${SCRIPT_BRANCH:+'refs/heads/'}

# Specific tag
ARG SCRIPT_TAG
ARG SCRIPT_TAG_PATH=${SCRIPT_TAG:+'refs/tags/'}

ARG SCRIPT_TARGET_PATH=${SCRIPT_TAG_PATH:-${SCRIPT_BRANCH_PATH}}
ARG SCRIPT_TARGET=${SCRIPT_TAG:-${SCRIPT_BRANCH:-${SCRIPT_REF:-'refs/heads/master'}}}

RUN echo SCRIPT_REF=${SCRIPT_REF} SCRIPT_BRANCH=${SCRIPT_BRANCH} SCRIPT_BRANCH_PATH=${SCRIPT_BRANCH_PATH} SCRIPT_TAG=${SCRIPT_TAG} SCRIPT_TAG_PATH=${SCRIPT_TAG_PATH} SCRIPT_TARGET_PATH=${SCRIPT_TARGET_PATH} SCRIPT_TARGET=${SCRIPT_TARGET} 
ADD https://raw.githubusercontent.com/merbanan/rtl_433/${SCRIPT_TARGET_PATH}${SCRIPT_TARGET}/examples/rtl_433_mqtt_hass.py /rtl_433_mqtt_hass.py

FROM ${SCRIPT_LOCATION}
LABEL maintainer="Zac Schellhardt <zac@z12t.com>"
# Copy run from root folder
COPY run.sh /run.sh

RUN  pip install \
    --no-cache-dir \
    --prefer-binary \
    paho-mqtt

RUN chmod a+x /rtl_433_mqtt_hass.py
RUN chmod a+x /run.sh

ENTRYPOINT [ "/run.sh" ]
