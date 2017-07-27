#!/bin/bash -e

# ./source.env.sh

export STACK_NAME=ldop

# The sed expression here replaces all backslashes by forward slashes.
# This helps our Windows users, while not bothering our Unix users.
export CLI_DIR=$(dirname "$(echo "$1" | sed -e 's,\\,/,g')")
export CONF_DIR="${CLI_DIR}"
export CONF_PROVIDER_DIR="${CLI_DIR}/conf/provider"
CLI_CMD_DIR="${CLI_DIR}/cmd"

export TARGET_HOST=localhost

#credentials
source ${CLI_DIR}/credentials.generate.sh

#compose variables
# Defaults
DEFAULT_MACHINE_NAME="default"
export MACHINE_NAME=${DOCKER_MACHINE_NAME:-${DEFAULT_MACHINE_NAME}}

export VOLUME_DRIVER=local
export LOGGING_DRIVER=syslog
export CUSTOM_NETWORK_NAME=swarm_network
export OVERRIDES=""
export TOTAL_OVERRIDES=""
export PULL="YES"
export MACHINE_NAME=""
export PROJECT_NAME="ldop"

#provider specific environment files
source ${CLI_DIR}/env.config.sh
source ${CLI_DIR}/conf/env.provider.sh

export EXTENSIONS="nexus"

docker volume create $REGISTRY_CERT_VOL

docker network create --attachable -d overlay ${CUSTOM_NETWORK_NAME}
