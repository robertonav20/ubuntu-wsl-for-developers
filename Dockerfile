FROM ubuntu:jammy
RUN apt update && apt upgrade -y && \
    apt install -y sudo ca-certificates curl wget nano vim unzip fontconfig && \
    apt clean

WORKDIR /tmp

# Install CLI utilities
# COPY cli.sh ./
# RUN chmod 755 cli.sh
# RUN ./cli.sh

# Install Components
COPY components.sh ./
RUN chmod 755 components.sh
RUN ./components.sh

# Install User configuration
COPY user.sh ./
RUN chmod 755 user.sh
RUN ./user.sh

RUN apt clean
RUN echo "Clean tmp folder because contains useless files of installation"
RUN rm -rf ./*

WORKDIR /