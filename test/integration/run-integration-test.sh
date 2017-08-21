#!/bin/bash +e

script_dir=$(dirname $0)

# Generate test ssh key
rm -f $script_dir/terraform.key $script_dir/terraform.key.pub
ssh-keygen -t rsa -N "" -f $script_dir/terraform.key

terraform init $script_dir

timeout 30m terraform apply $script_dir
EXIT_STATUS=$?

terraform destroy -force $script_dir
DESTROY_STATUS=$?

if [ $DESTROY_STATUS -ne "0" ]; then
	echo "Test infrastructure was not properly destroyed!"
	# Notify slack
fi

exit $EXIT_STATUS
