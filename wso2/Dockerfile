# The unmodified version of this file can be found on
# https://github.com/wso2-attic/dockerfiles/blob/master/wso2cep/Dockerfile.

# ------------------------------------------------------------------------
#
# Copyright 2016 WSO2, Inc. (http://wso2.com)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License

# ------------------------------------------------------------------------

FROM wso2/wso2base:latest
MAINTAINER dev@wso2.org

ENV DEBIAN_FRONTEND noninteractive

# Build time arguments
ARG WSO2_SERVER
ARG WSO2_SERVER_VERSION
ARG WSO2_SERVER_PROFILE
ARG WSO2_ENVIRONMENT
ARG HTTP_PACK_SERVER
ARG JDK_Server
ARG PLATFORM

# Carbon server information
ENV WSO2_SERVER=${WSO2_SERVER:-wso2cep} \
    WSO2_SERVER_VERSION=${WSO2_SERVER_VERSION:-4.2.0} \
    WSO2_SERVER_PROFILE=${WSO2_SERVER_PROFILE:-default} \
    WSO2_ENVIRONMENT=${WSO2_ENVIRONMENT:-dev} \
    HTTP_PACK_SERVER=${HTTP_PACK_SERVER} \
    PLATFORM=${PLATFORM:-default}

# measurement scripts
COPY cpu /usr/local/bin/cpu
COPY mem /usr/local/bin/mem
RUN chmod +x /usr/local/bin/cpu && chmod +x /usr/local/bin/mem

COPY wso2bin/*.sh /usr/local/bin/
COPY jdk-7u80 /mnt/jdk-7u80
COPY wso2cep-4.2.0 /mnt/wso2cep-4.2.0
COPY eventpublishers/*.xml /mnt/wso2cep-4.2.0/repository/deployment/server/eventpublishers/
COPY eventreceivers/*.xml /mnt/wso2cep-4.2.0/repository/deployment/server/eventreceivers/
COPY eventstreams/*.json /mnt/wso2cep-4.2.0/repository/deployment/server/eventstreams/
COPY executionplans/*.siddhiql /mnt/wso2cep-4.2.0/repository/deployment/server/executionplans/
RUN chmod +x /usr/local/bin/*.sh && /usr/local/bin/image-config.sh
RUN mkdir /measurements && chown wso2user:wso2 /measurements
VOLUME ["/measurements"]

USER wso2user
WORKDIR /mnt

# Expose transport ports
EXPOSE 7611 7711 9763 9443 9611 9711

ENTRYPOINT ["/usr/local/bin/startwso2.sh"]
