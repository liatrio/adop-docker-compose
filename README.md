# The DevOps Platform: Overview

The DevOps Platform is a tools environment for continuously testing, releasing and maintaining applications. This platform is capable of performing CICD on a variety of projects; each of the projects listed below have specific traits that are common in the industry, such as a RESTful api or a unique set of Maven build steps.

* [Spring PetClinic](https://github.com/liatrio/spring-petclinic)
* [REST Countries](https://github.com/liatrio/restcountries)
* [Game of Life](https://github.com/liatrio/game-of-life)
* [Dromedary](https://github.com/liatrio/dromedary)
* [Joda-time](https://github.com/liatrio/joda-time)
* [Hygieia](https://github.com/liatrio/Hygieia)

The platform runs anywhere that [docker engine runs](https://docs.docker.com/engine/installation/binaries/), allowing for local evaluation using local storage. The platform is also capable of being stood up on a Docker swarm cluster; built in commands will toss the entire LDOP stack (including extensions) onto a swarm.

The [Liatrio DevOps Platform](https://github.com/liatrio/ldop-docker-compose) is [Liatrio](https://liatrio.com/)'s adaptation of Accenture's platform, [ADOP](https://github.com/Accenture/adop-docker-compose), for use with our customers.

## Why We Forked

* Version Upgrades
  * Numerous updates to Docker capabilities since ADOP's inception have allowed LDOP to support different use cases, such as: 
    * Native Docker engine on OS X, Linux and Windows machines
    * The original fork of this platform utilized version 1 docker-compose. Since becoming LDOP, the platform has been upgraded to version 3 docker-compose. This upgrade in versioning provides [many benefits](https://docs.docker.com/compose/compose-file/compose-versioning/#versioning), one of which is cross-compatability with Docker engine and Docker swarm. 
  * Upgraded to Jenkins release version 2.0 to support use of Jenkinsfiles for custom pipelines. 

* Platform Differences
  * LDOP expanded ADOP's implementation of extensions to broaden the horizon of the platform. Extensions are services that are used to fill certain roles within LDOP, and can typically be used interchangeably. An example of this feature is the ability to switch between Nexus and Artifactory at launch as the employed artifact repository.
  * Expanded CLI commands to supporting CI testing for the platform as well Jenkins jobs.
  * Streamlined CLI for launching LDOP across different environments.

* Expanded AMPRS Characteristics for Enterprise Use Cases
  * AMPRS (availability, manageability, performance, recoverability, scalability) have been key points of focus during the development of this platform. While LDOP can be run on a single machine to perform local CI with software projects, its architecture combined with compatability with container orchestration technologies enables high performance and scalability. 

### LDOP Stack

###### **Primary Services**

* **ElasticSearch** - GitHub - [DockerHub](https://hub.docker.com/_/elasticsearch/)
* **Gerrit** - [GitHub](https://github.com/liatrio/ldop-gerrit) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-gerrit/)
* **Jenkins** - [GitHub](https://github.com/liatrio/ldop-jenkins) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-jenkins/)
* **Jenkins Slave** - [GitHub](https://github.com/liatrio/ldop-jenkins-slave) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-jenkins-slave/)
* **Kibana** - GitHub - [DockerHub](https://hub.docker.com/_/kibana/)
* **LDAP** - [GitHub](https://github.com/liatrio/ldop-ldap) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-ldap/)
* **LDAP LTB** - [GitHub](https://github.com/liatrio/ldop-ldap-ltb) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-ldap-ltb/)
* **LDAP PHP Admin** - [GitHub](https://github.com/liatrio/ldop-ldap-phpadmin) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-ldap-phpadmin/)
* **Logstash** - [GitHub](https://github.com/liatrio/ldop-logstash) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-logstash/)
* **MySQL** - GitHub - [DockerHub](https://hub.docker.com/_/mysql/)
* **Nginx** - [GitHub](https://github.com/liatrio/ldop-nginx) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-nginx/)
* **Registry** - GitHub - [DockerHub](https://hub.docker.com/_/registry/)
* **Selenium Chrome** - GitHub - [DockerHub](https://hub.docker.com/r/selenium/node-chrome/)
* **Selenium Firefox** - GitHub - [DockerHub](https://hub.docker.com/r/selenium/node-firefox/)
* **Selenium Hub** - GitHub - [DockerHub](https://hub.docker.com/r/selenium/hub/)
* **Sensu API** - [GitHub](https://github.com/liatrio/ldop-sensu) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-sensu/)
* **Sensu Client** - [GitHub](https://github.com/liatrio/ldop-sensu) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-sensu/)
* **Sensu Rabbitmq** - GitHub - [DockerHub](https://hub.docker.com/_/rabbitmq/)
* **Sensu Redis** - GitHub - [DockerHub](https://hub.docker.com/_/redis/)
* **Sensu Server** - [GitHub](https://github.com/liatrio/ldop-sensu) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-sensu/)
* **Sensu Uchiwa** - GitHub - [DockerHub](https://hub.docker.com/r/sstarcher/sensu/)
* **Sonar** - [GitHub](https://github.com/liatrio/ldop-sonar) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-sonar/)
* **Sonar MySQL** - GitHub - [DockerHub](https://hub.docker.com/_/mysql/)

###### **Extension Services**

* **Artifactory** - GitHub - [DockerHub](https://hub.docker.com/r/liatrio/ldop-artifactory/)
* **Nexus** - [GitHub](https://github.com/liatrio/ldop-nexus) - [DockerHub](https://hub.docker.com/r/liatrio/ldop-nexus/)

### LDOP Dashboard

![HomePage](https://github.com/liatrio/ldop-docker-compose/blob/master/img/home.png)

Once you have a stack up and running, you can log in with the username and password created upon start-up. If you no longer remember your login credentials, you can find them in the project root directory file called *platform.secrets.sh*.

An example job that creates a pipeline to build [Spring PetClinic](https://github.com/liatrio/spring-petclinic) is included in the base version of LDOP. This job will look into the specified repository for a Jenkinsfile. This file will be used to create a pipeline job on Jenkins, and run the project through each of its phases.

![HomePage](https://github.com/liatrio/ldop-docker-compose/blob/master/img/exampleproj.png)

## General Getting Started Instructions

This platform can be run anywhere that a Docker engine is installed, and can also be deployed to a swarm. To begin, we will go over the steps to run LDOP locally.

Ensure that you have [docker-compose](https://docs.docker.com/compose/install/) installed before attempting to run LDOP locally.

### To Run Locally

Running LDOP locally can be done on a Docker engine, or using docker-machine; there are only a couple extra steps required to run the platform on a machine. If you want to deploy the stack directly onto the Docker engine skip the next two steps. Otherwise,

- Create a local Docker VM
```
docker-machine create <MACHINE_NAME>
```
- And source the machine environment variables
```
eval $(docker-machine env <YOUR_MACHINE_NAME>)
```

If this is the first time you are launching LDOP or you deleted the registry volume,
```
sudo ldop compose init
```
otherwise
```
ldop compose init
```

**Warning:** you will need to run both commands for docker-machine and aws due to certbot and environment variable issues

### To Run In AWS (Single Instance) Manually

- In order to run LDOP in an AWS instance using the following steps, an [IAM role needs to be configured](http://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create.html). This role needs access to EC2 so that it can launch the instance that will run LDOP.

- [An AWS VPC](http://docs.aws.amazon.com/AmazonVPC/latest/GettingStartedGuide/ExerciseOverview.html) is required to have LDOP run on AWS. The default can be used or another can be created. Either way, retrieve the VPC id for use in the next command.

- Create an AWS instance and have it provisioned with Docker engine:
```
docker-machine create \
  --driver amazonec2 \
  --amazonec2-access-key <YOUR_ACCESS_KEY> \
  --amazonec2-secret-key <YOUR_SECRET_KEY> \
  --amazonec2-vpc-id <YOUR_VPC_ID> \
  --amazonec2-instance-type m4.xlarge \
  --amazonec2-region <YOUR_AWS_REGION, e.g. eu-west-1> \
  --engine-install-url=https://web.archive.org/web/20170623081500/https://get.docker.com <YOUR_MACHINE_NAME>
```

**Warning:** The option *--engine-install-url=https://web.archive.org/web/20170623081500/https://get.docker.com* is necessary for the above command to work due to an issue with Docker updates. This option provides an alternate Docker engine install that works.

- Update the AWS security group to permit:
  - Inbound http traffic on port 80 from anywhere, TCP.
  - Inbound/outbound on 25826 and 12201 from 127.0.0.1/32, UDP.

- Set your local environment variables to point docker-machine to your new instance:
```
eval $(docker-machine env <YOUR_MACHINE_NAME>)
```

Any Docker commands you run will now be ran on the AWS instance.


### To Run With Docker Swarm

To extend availability and scalability, Docker swarm functionality was added into LDOP. The platform can be run on any swarm, regardless of the underlying nodes. If the swarm nodes have any network restrictions, such as AWS security groups, there are a few port requirements.

**LDOP Specific**

* 80/443 TCP - used for HTTP/HTTPS communication with LDOP.
* 389 TCP/UDP - used in unsecured LDAP communication.

**Docker Swarm Specific**

* 2376 TCP - used for secure Docker client communication.
* 2377 TCP - used for communication between nodes in the swarm.
* 4789 UDP - used in the overlay for the container network.
* 7946 TCP/UDP - used for container network discovery.

Once the above requirements are met, deploying to a swarm is similar to deploying locally. Simply run the following command on a manager node.

```
ldop swarm init
```

## Using The Platform

###### Fresh Start

Sometimes you will want to get a *fresh start* with LDOP; i.e. removing volumes, credentials, etc. Regardless of whether or not LDOP is currently running, the following commands will get you a clean slate.

To bring the platform down, as well as ensure that volumes are destroyed.
```
ldop compose down --volumes
```
**Warning:** This does not delete the registry volume. If you also want to delete this volume, which is not typically required, run *docker volume rm registry_certs*.

Next, you will want to regenerate your login credentials. If you are using *ldop compose*, you can skip this command.
```
rm platform.secrets.sh
./credentials.generate.sh
```

You are now ready to run LDOP with a fresh start.

###### Regenerate SSL certificates

To regenerate SSL certificates to allow the Jenkins service to access the Docker engine, run the following commands.

```
source ./conf/env.provider.sh
source credentials.generate.sh
source env.config.sh
ldop compose gen-certs ${DOCKER_CLIENT_CERT_PATH}
```

Note: For Windows run this command from a terminal (Git Bash) as administrator.

###### Define Default Elastic Search Index Pattern

Kibana 4 does not provide a configuration property that allow to define the default index pattern so the following manual procedure should be adopted in order to define an index pattern:

- Navidate to Settings > Indices using Kibana dashboard
- Set index name or pattern as "logstash-\*"
- For the below drop-down select @timestamp for the Time-field name
- Click on create button

## User Feedback

### Documentation
Documentation can be found on our [GitHub page](https://github.com/liatrio/ldop-docker-compose).

### Issues
If you have any problems with or questions about this project, please contact us through [Gitter](https://gitter.im/liatrio/LDOP) or a [GitHub issue](https://github.com/liatrio/ldop-docker-compose/issues).

### Contribute
You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can. You can find more information in our [documentation](https://github.com/liatrio/ldop-docker-compose/wiki).

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/liatrio/ldop-docker-compose/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.
