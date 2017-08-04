#!/bin/bash
# Author: Justin Bankes <justin@liatrio.com>
# Last modified: Aug 4, 2017
# This is the validation script that will run to verify sanity before running
# longer tests. For every extension in the directory this test for:
# - Extension file structure
# - Extension declaration in env.config.sh

main() {
  echo "-------------------------------Validation------------------------------"
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
  echo -ne "\nChecking env.config.sh for extensions: "
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
  if [ -f $dir/docker-compose.yml ]; then
    echo success
  else
    echo "docker-compose missing; exit failure."
    exit 1
  fi

  # Check for required integrations
  integrations=(proxy sensu)
  echo "  integrations structure"
  for inte in ${integrations[@]}; do
    echo -ne "    $inte: "
    if [ -d ${dir}integrations/${inte} ]; then
      echo exists
    else 
      echo "missing $inte for $dir; exiting failure"
      exit 1
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
  proxy_path="${dir}integrations/proxy"
  proxy_dirs=(release-note sites-enabled)
  ext_name=${dir%/}

  # Check release-note
  echo -ne "      release-note/: "
  if [ -d $proxy_path/release-note ]; then
    echo "exist"
  else
    echo "failed: release-note/ doesn't exist. exiting failure"
    exit 1
  fi

  #Check release-note contents
  # release-note/img directory for nginx home page picture
  echo -ne "        img/: "
  if [ -d $proxy_path/release-note/img ]; then
    echo exist
  else
    echo "failed: img/ doesn't exist. exiting failure"
    exit 1
  fi

  # img contains at least on image
  img_name="${ext_name}.png"
  echo -ne "          $img_name: "
  if [ -f $proxy_path/release-note/img/$img_name ]; then
    echo exist
  else
    echo "failed: $img_name doesn't exist. exiting failure"
    exit 1
  fi

  # check for release-note/plugins.json
  echo -ne "        plugins.json: "
  if [ -f $proxy_path/release-note/plugins.json ]; then
    echo exists
  else 
    echo "failed: plugins.json doesn't exist. exiting failure"
    exit 1
  fi

  # Check for sites-enabled 
  echo -ne "      sites-enabled/: "
  if [ -d $proxy_path/sites-enabled ]; then
    echo "exists"
  else
    echo "failed: sites-enabled/ doesn't exist; exiting failure"
    exit 1
  fi

  # Check for service-extension/ 
  echo -n "        service-extensions/: "
  if [ -d $proxy_path/sites-enabled/service-extension ]; then
    echo exists 
  else
    echo "failed: service-extensions/ doesn't exist; exiting failure"
    exit 1
  fi

  # check for extension nginx config
  conf_name="${ext_name}.conf"
  echo -n "          $conf_name: "
  if [[ -f $proxy_path/sites-enabled/service-extension/$conf_name ]]; then
    echo exists
  else
    echo "failed: $conf_name doesn't exist; exiting failure"
    exit 1
  fi
}


# Run the script - this effectively allows forward declaration
main "$@"
