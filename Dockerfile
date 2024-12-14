FROM ubuntu:jammy
RUN apt update && \
    apt upgrade -y && \
    apt install -y ca-certificates curl fontconfig nano sudo unzip vim wget && \
    apt clean

WORKDIR /tmp

ARG USER_NAME=developer
ENV USER_NAME=$USER_NAME

# Copy scripts
COPY cli.sh cli.sh
COPY components.sh components.sh
COPY user.sh user.sh

# Install
RUN chmod 777 /tmp/cli.sh && /tmp/./cli.sh 
RUN chmod 777 /tmp/components.sh && /tmp/./components.sh
RUN chmod 777 /tmp/user.sh && /tmp/./user.sh

RUN rm -rf /tmp

RUN echo "Clean tmp folder because contains useless files of installation"
RUN apt clean && rm -rf ./*

WORKDIR /

LABEL org.opencontainers.image.source=https://github.com/robertonav20/customized-wsl-image
LABEL org.opencontainers.image.description="Customized Ubuntu WSL to speed up configuration"
LABEL org.opencontainers.image.licenses=MIT

USER developer