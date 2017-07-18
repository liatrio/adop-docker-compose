from docker.bintray.io/jfrog/artifactory-oss

RUN apt-get update && apt-get install -y gettext

COPY resources/artifactory/etc/artifactory.config.import.xml /artifactory.config.import.xml
COPY resources/entrypoint-ldop-artifactory.sh /entrypoint-ldop-artifactory.sh

RUN chmod +x /entrypoint-ldop-artifactory.sh

ENTRYPOINT ["/entrypoint-ldop-artifactory.sh"]

