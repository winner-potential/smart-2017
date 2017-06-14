#!/bin/bash

export JAVA_HOME=/mnt/jdk-7u80
/usr/local/bin/cpu "java" &
/usr/local/bin/mem "Bootstrap" &
/mnt/wso2cep-4.2.0/bin/wso2server.sh
