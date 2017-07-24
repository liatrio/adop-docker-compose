pretty_sleep() {
    secs=${1:-60}
    tool=${2:-service}
    while [ $secs -gt 0 ]; do
        echo -ne "$tool unavailable, sleeping for: $secs\033[0Ks\r"
        sleep 1
        : $((secs--))
    done
    echo "$tool was unavailable, so slept for: ${1:-60} secs"
}

source swarm.env.sh

export CONTAINER_ID=$(docker run -v "${PROJECT_NAME}_nginx_config:/nginx" -v "${PROJECT_NAME}_nginx_releasenote:/nginx_release" -v "${PROJECT_NAME}_sensu_server_check:/sensu" busybox sh -c "mkdir -p /nginx/sites-enabled/service-extension; mkdir -p /nginx_release/img;" && docker ps -l -q)

for ext in ${EXTENSIONS}; do

integrations_dir="${CLI_DIR}/extensions/$ext/integrations"
proxy_integrations_dir="${CLI_DIR}/extensions/$ext/integrations/proxy"

if [ -d "${integrations_dir}" ]; then
		echo "* Integrating extension: $ext"

		# Add proxy pass integration
		if [ -d "${integrations_dir}/proxy" ]; then 
				echo "  * Adding proxy integration."
				docker cp ${integrations_dir}/proxy/sites-enabled/service-extension/. ${CONTAINER_ID}:/nginx/sites-enabled/service-extension
		fi

		# Add Sensu checks
		if [ -d "${integrations_dir}/sensu/check.d" ]; then
				echo "  * Adding sensu integration."
				docker cp ${integrations_dir}/sensu/check.d/. ${CONTAINER_ID}:/sensu/
		fi

		docker stack deploy -c ${CLI_DIR}/extensions/$ext/docker-compose.yml ${STACK_NAME}
fi
done

docker stack deploy -c swarm-compose.yml ${STACK_NAME}

# Wait for Nginx to come up before proceeding
echo "* Waiting for Nginx to become available"
until [[ $(curl -k -I -s -u ${INITIAL_ADMIN_USER}:${INITIAL_ADMIN_PASSWORD_PLAIN} ${PROTO}://${TARGET_HOST}/|head -n 1|cut -d$' ' -f2) == 200 ]]; do pretty_sleep 5 Nginx; done

for ext in ${EXTENSIONS}; do

integrations_dir="${CLI_DIR}/extensions/$ext/integrations"
proxy_integrations_dir="${CLI_DIR}/extensions/$ext/integrations/proxy"

if [ -d "${integrations_dir}" ]; then
		# Add dashboard image resources
		if [ -d "${integrations_dir}/proxy/release-note/img" ]; then
				echo "  * Adding dashboard image."
				docker cp ${integrations_dir}/proxy/release-note/img/. ${CONTAINER_ID}:/nginx_release/img
		fi

		# Add dashboard ui integrations
		if [ -f "${integrations_dir}/proxy/release-note/plugins.json" ]; then
				echo "  * Adding dashboard ui configuration."
				docker run --rm -v "${PROJECT_NAME}_nginx_releasenote:/release-note" -v "$(pwd)/extensions/$ext/integrations/proxy/release-note/plugins.json:/new-plugins.json" endeveit/docker-jq /bin/sh -c "jq -s '.[0].core[0].components = (.[0].core[0].components+.[1].core[0].components|unique_by(.id))|.[0]' /release-note/plugins.json /new-plugins.json >/release-note/tmp.json && mv /release-note/tmp.json /release-note/plugins.json"
		fi
fi
done

docker rm ${CONTAINER_ID}
