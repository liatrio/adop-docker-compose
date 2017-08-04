#!/bin/bash
# Author: Justin Bankes <justin@liatrio.com>
# Last modified: Aug 4, 2017
# This is the validation script that will run to verify sanity before running
# longer tests. For every extension in the directory this test for:
# - Extension file structure
# - Extension declaration in env.config.sh

main() {
  echo "---------------------Validation-------------------"
  env_config_validation

  # validate extension folder structure
  echo -e "\nValidating individual extension folder structure"
  cd extensions
  for dir in */ ; do
    echo "$dir"
    validate_extension_architecture $dir 
  done
}



env_config_validation() {
  # Check extensions line for space delimited list
  echo -n "Checking env.config.sh for extensions: "
  ext_line=$(cat env.config.sh | grep EXTENSIONS)
  if [[ "$ext_line" =~ ^(export EXTENSIONS=\")([A-Za-z]+ ?)*(\")$ ]]; then
    echo success 
  else
    echo "EXTENSIONS environment variable in config script is incorrect"
    echo "Must be a space delimited list or empty string." 
    echo "eg. \"export EXTENSIONS=\"nexus\""
    echo "please correct and try again; exiting"
    exit 1
  fi
}



validate_extension_architecture() {

  # Check for docker-compose 
  echo -n "  docker-compose.yml exist: "
  if [ ! -f $dir/docker-compose.yml ]; then
    echo "docker-compose missing; exit failure."
    exit 1
  else
   echo success
  fi

  # Check for required integrations
  integrations=(proxy sensu)
  echo "  integrations structure"
  for inte in ${integrations[@]}; do
    echo -ne "    $inte exist: "
    if [ -z $(ls $dir/integrations | grep $inte) ]; then
      echo "missing $inte for $dir; exiting as failure, try again"
      exit 1
    else 
      echo success
    fi
    
    # call specific integration validation
    if [ $inte == "proxy" ]; then
      proxy_inegration_validation
    fi
    if [ $inte == "sensu" ]; then
      sensu_inegration_verification
    fi
  done

  echo -e "  $dir folder structure correct\n"
}




# Checks the extension's proxy integration's file structure.
proxy_inegration_validation() {
  proxy_dirs=(release-note sites-enabled)
  echo -e "    proxy file structure validation"

  # Check release-note
  echo -ne "      release-note exists: "
  if [ -n $(ls $dir/integrations/proxy/ | grep release-note) ]; then
    echo "success"
  else
    echo "failed: release-note doesn't exist. fix and try again; exiting..."
    exit 1
  fi
  echo -e "      checking release-note:"
  
  # Check for sites-enabled 
  echo -ne "      sites-enabled exists: "
  if [ -n $(ls $dir/integrations/proxy/ | grep site-enabled)  ]; then
    echo "success"
  else
    echo "failed: sites-enabled doesn't exist. fix and try again; exiting..."
    exit 1
  fi

}


# Run the script - this effectively allows forward declaration
main "$@"
