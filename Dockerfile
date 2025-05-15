FROM ubuntu:jammy
RUN apt update && \
    apt upgrade -y && \
    apt install -y \
    ca-certificates \
    sudo \
    curl \
    wget \
    nano \
    htop \
    unzip \
    vim \
    fontconfig \
    git \
    zsh \
    gh && \
    apt clean

WORKDIR /tmp

ARG USER_NAME=developer
ENV USER_NAME=$USER_NAME

# Copy scripts and install
COPY cli.sh cli.sh
RUN ./cli.sh

COPY components.sh components.sh
RUN ./components.sh

COPY user.sh user.sh
RUN ./user.sh

RUN rm -rf /tmp/*

RUN echo "Clean tmp folder because contains useless files of installation"
RUN apt clean && rm -rf ./*

WORKDIR /

LABEL org.opencontainers.image.source=https://github.com/robertonav20/ubuntu-wsl-for-developers
LABEL org.opencontainers.image.description="Preconfigured Ubuntu WSL for developers"
LABEL org.opencontainers.image.licenses=MIT

USER developer