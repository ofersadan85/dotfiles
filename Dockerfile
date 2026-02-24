# This container is only for testing the installation of dotfiles
# Build with `docker build -t dotfiles .`
# Run with `docker run --rm -it dotfiles zsh`

FROM debian:12-slim

RUN apt update && apt install -y curl sudo

COPY bootstrap.sh /bootstrap.sh 
RUN /bootstrap.sh
WORKDIR /root

