#!/usr/bin/env bash

# Copyright 2018 The KubeSphere Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )
K8S_HOME=$(dirname "${SCRIPTPATH}")

source "${K8S_HOME}/script/common.sh"

kubelet_ready="false"
docker_ready="false"
if systemctl is-active docker
then
  docker_ready="true"
fi
if systemctl is-active kubelet
then
    status=$(get_node_status)
    echo "ready:${status}"
    if [ "${status}" == "True" ]
    then
        kubelet_ready="true"
    fi
fi

if [ "${docker_ready}" == "true" ] && [ "${kubelet_ready}" == "true" ]
then
  exit 0
else
  exit 1
fi