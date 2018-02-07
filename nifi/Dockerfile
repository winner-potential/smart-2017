# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements. See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership. The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License. You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied. See the License for the
# specific language governing permissions and limitations
# under the License.
#

FROM openjdk:8-jdk
LABEL maintainer "Apache NiFi <dev@nifi.apache.org>"

ARG UID=1000
ARG GID=1000
ARG NIFI_VERSION=1.4.0
ARG MIRROR=https://archive.apache.org/dist

ENV NIFI_BASE_DIR /opt/nifi 
ENV NIFI_HOME=$NIFI_BASE_DIR/nifi-$NIFI_VERSION \
    NIFI_BINARY_URL=/nifi/$NIFI_VERSION/nifi-$NIFI_VERSION-bin.tar.gz

# Setup NiFi user
RUN groupadd -g $GID nifi || groupmod -n nifi `getent group $GID | cut -d: -f1` \
    && useradd --shell /bin/bash -u $UID -g $GID -m nifi \
    && mkdir -p $NIFI_HOME/conf/templates \
    && chown -R nifi:nifi $NIFI_BASE_DIR

USER nifi

# Download, validate, and expand Apache NiFi binary.
RUN curl -fSL $MIRROR/$NIFI_BINARY_URL -o $NIFI_BASE_DIR/nifi-$NIFI_VERSION-bin.tar.gz \
    && echo "$(curl https://archive.apache.org/dist/$NIFI_BINARY_URL.sha256) *$NIFI_BASE_DIR/nifi-$NIFI_VERSION-bin.tar.gz" | sha256sum -c - \
    && tar -xvzf $NIFI_BASE_DIR/nifi-$NIFI_VERSION-bin.tar.gz -C $NIFI_BASE_DIR \
    && rm $NIFI_BASE_DIR/nifi-$NIFI_VERSION-bin.tar.gz \
    && chown -R nifi:nifi $NIFI_HOME

USER root

#measurement needs
COPY start cpu mem /temp/
RUN chmod +x /temp/start /temp/cpu /temp/mem && mv /temp/* $NIFI_HOME/bin

RUN mkdir -p /measurements && chown -R nifi:nifi /measurements
VOLUME ["/measurements"]

#Copy the matching configuration from the local repository
COPY nifi.properties /opt/nifi/nifi-1.4.0/conf/nifi.properties
RUN chown nifi:nifi /opt/nifi/nifi-1.4.0/conf/nifi.properties

COPY processors/nars/* /opt/nifi/nifi-1.4.0/lib/
RUN chown nifi:nifi /opt/nifi/nifi-1.4.0/lib/nifi-customProcessor-nar-1.0.nar

USER nifi

# Web HTTP Port & Remote Site-to-Site Ports
EXPOSE 8080 8181

WORKDIR $NIFI_HOME

# Startup NiFi
ENTRYPOINT ["bin/start"]

#ENTRYPOINT ["bin/nifi.sh"]
#CMD ["run"]
#ENTRYPOINT ["bin/bash"]

# Within nifi.properties I put the configuration line
# nifi.flow.configuration.file=./conf/actualflow/flow.xml.gz
# so that Apache Nifi searches for the right elements.

# start with command sudo docker run -p 8000:8000 -p 8080:8080 -p 8181:8181 -v $(pwd)/flows/actualflow:/opt/nifi/nifi-1.4.0/conf/actualflow -v $(pwd)/flows/archive:/opt/nifi/nifi-1.4.0/conf/archive -v $(pwd)/javascript:/nifiscripts -v /home/flo/measurements:/measurements --name nifi <IMAGE_NAME_OR_ID>
#
# to get access via webbrowser on localhost:8080/nifi
