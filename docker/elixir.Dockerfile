# Update the ELIXIR_VERSION arg in docker-compose.yml to pick an Elixir version: 1.9, 1.10, 1.10.4
ARG ELIXIR_VERSION="1.14.2"

FROM docker.io/elixir:${ELIXIR_VERSION}

LABEL org.opencontainers.image.description="Elixir development container for VSCode running (non-root) podman instead of docker"

# Replace sh with bash (useful for later installation of nodejs, etc)
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# ARG USERNAME=user

# RUN useradd -u 1000 -m -g 1000 ${USERNAME}

# Create Windows user in the container
# RUN net user /add user

# USER ${USERNAME}

RUN apt-get update \
  && export DEBIAN_FRONTEND=noninteractive \
  && apt-get update \
  # Install necessary system tools
  && apt-get install -y --no-install-recommends apt-utils \
  && apt-get install -y build-essential inotify-tools

ENV NVM_DIR=/usr/local/share/nvm

ARG NVM_VERSION=0
ARG NODE_VERSION=0
ARG INSTALL_HEX=1

# Optionally Install NVM and NodeJS
RUN echo NODE_VERSION $NODE_VERSION && echo NVM_VERSION $NVM_VERSION && if [[ "$NODE_VERSION" != "0" && "${NVM_VERSION}" != "0"  ]];  then \
    apt-get install -y curl libssl-dev \
    && mkdir -p $NVM_DIR \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | NVM_DIR="${NVM_DIR}" bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install ${NODE_VERSION}; \
    fi;

# Install hex package manager
RUN if [[ "$INSTALL_HEX" == "1"  ]]; then mix local.hex --force; fi;

# Cleanup
RUN apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*
