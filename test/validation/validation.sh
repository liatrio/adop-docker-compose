#!/bin/bash
# Author: Justin Bankes <justin@liatrio.com>
# This is the validation script that will run to verify sanity before running
# longer tests. 

validate_extension_architecture() {

  # Check for docker-compose 
  echo -ne "\tdocker-compose.yml exist: "
  if [ ! -f $dir/docker-compose.yml ]; then
    echo "docker-compose missing; exit failure."
    exit 2
  else
   echo success
  fi

  # Check for required integrations
  integrations=(proxy sensu)
  echo -e "\tChecking for integrations"
  for int in ${integrations[@]}; do
    echo -ne "\t\t$int exist: "
    if [ -z $(ls $dir/integrations | grep $int) ]; then
      echo "missing $int for $dir; exiting as failure, try again"
      exit 3
    else 
      echo success
    fi
  done

  echo -e "\t$dir folder structure correct"
}


# Main Validation Script
echo "---------------------Validation-------------------"

working_dir=$(pwd)

# Check extensions line for space delimited list
echo -n "Checking env.config.sh for extensions: "
# ext_line=$(cat env.config.sh | grep EXTENSIONS)
# if [ $ext_line =~ "(export EXTENSIONS=\")(\w+ *)+\")/" ]; 
# then
  echo success 
# else
#   echo "EXTENSIONS environment variable in config script is incorrect"
#   echo "Must be a space delimited list; please correct and try again. 
#   echo "exiting"
#   exit 1
# fi

# Get extensions
echo "Validating individual extension folder structure:"
cd extensions
for dir in */ ; do
  echo "$dir"
  validate_extension_architecture $dir 



  # Check for Proxy

  # Check for Sensu
  
done

