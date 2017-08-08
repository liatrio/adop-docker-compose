#!/bin/bash -e

# ./source.env.sh

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

export EXTENSIONS="nexus"
