#!/bin/bash
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
# This file was modifed to suit our needs.
# ------------------------------------------------------------------------

set -e

# JDK version
jdk_install_dir=/mnt/jdk-7u80
java_home_dir=/opt/java

# Add wso2user
pushd /mnt > /dev/null
addgroup wso2
adduser --system --shell /bin/bash --gecos 'WSO2User' --ingroup wso2 --disabled-login wso2user

# Setup
ln -s ${jdk_install_dir} ${java_home_dir}
echo "created symlink for java: ${java_home_dir} -> ${jdk_install_dir}"

# Cleanup
rm -rfv /var/lib/apt/lists/*
chown wso2user:wso2 /usr/local/bin/*
chown -R wso2user:wso2 /mnt

# Setup environment variables
cat > /etc/profile.d/set_java_home.sh << EOF
export JAVA_HOME="${jdk_install_dir}"
export PATH="${jdk_install_dir}/bin:\$PATH"
EOF
chmod +x /etc/profile.d/set_java_home.sh

popd > /dev/null
