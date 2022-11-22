# vscode-remote-elixir

A generic setup for running Elixir in VSCode using the Dev Containers extension.

My need for this arose out of a desire to have:
* a base Elixir/Erlang install, without additional dependencies included by default (most others seem to default to installing Phoenix as well, for example);
* to have a dockerfile that works with podman instead of docker:
    - For example, podman appears to require a container to be rootful in order for networking to work correctly... the change for this, as compared to running the container with docker, is to remove the `remoteUser` setting in the ***devcontainer.json*** file; this setup already includes these changes.


## Structure / Configuration

This section describes the basic layout of the application and where to make an customization changes:

`docker/`
    - contains docker related configuration.
    - files:
        * `elixir.Dockerfile`
            - Defines the image used to create the Elixir container.
            - Allows for optional installation of NVM and NodeJS, whether to install hex package manager, as well as optionally which version of Elixir to install (the optional aspects can be configured in the `docker-compose.yml` file).
        * `docker-compose.yml`
            - The services to be started up.
            - Defaults to starting up a "backend" service (the elixir container). Included, but commented out, is a postgres database "db" service. Additional services can be defined and added here, simlar to the (commented out) "db" service, as needed.
            - ARGS specified in the image (the dockerfile) can be set per service here.
        * `config-*.env`
            - Contains any container specific environment configuration. These can be included/referenced in the docker-compose.yml file for sharing configuration; see for example the "backend" service defined in `docker-compose.yml` for inclusion of the environment variables for the database. Environment can be shared using alternative docker-compose functionality, this is just one mechanism.

`.devcontainer`
    - VSCode definitions for setting up the container-based environment.
    - files:
        * `devcontainer.json`
            - Contains the configuration for how the Dev Containers extension will start the container(s).

`source`
    - Contains the application source code.
    - By default this is mounted into the container as `/app/` (see the docker-compose.yml definition for the "backend" service).
    - This is typically automatically created if it does not exist.


## Setup

### Pre-requisites:

##### 1. Install and set up VSCode

While typically VSCodium would be preferred over VSCode, the Dev Containers extension is not licensed for use with VSCodium, and may encounter problems running. It is possible to (sort of) get it set up, but thats outside of the current intention.

VSCode: https://code.visualstudio.com/Download
VSCodium: https://vscodium.com/

##### 2. Ensure either Docker and Docker Compose, or preferably podman and podman-compose, is installed and available.

To quote the [podman](https://podman.io/) site: """Podman is a daemonless container engine for developing, managing, and running OCI Containers on your Linux System. Containers can either be run as root or in rootless mode."""

Docker setup: https://docs.docker.com/get-docker/
Podman setup: https://podman.io/getting-started/installation
Podman Compose setup: https://github.com/containers/podman-compose#installation

Due to various issues, it might be necessary to ensure that for podman-compose a version greater than v1.0.3 is installed. At this time, this means installing the development branch (installation instructions for this are mentioned in the above link).

##### 3. Install the Dev Containers extension in VSCode.

Can be found on the VSCode extensions marketplace. See https://code.visualstudio.com/docs/devcontainers/containers for more details.

##### 4. Optional: Set up Remote Containers to use podman/podman-compose instead of docker

ITo use podman and podman-compose instead of docker, and both are installed, then update the following VSCode settings:
    * Settings > Extensions > Dev Containers > Docker Path : replace `docker` with `podman`
    * Settings > Extensions > Dev Containers > Docker Compose Path : set this to the value `podman-compose`


### Setup

Clone this repo, make any configuration changes as needed, and build/start using Remote Containers.
