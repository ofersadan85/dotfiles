# This container is only for testing the installation of dotfiles
# Build with `docker build -t dotfiles .`
# Run with `docker run --rm -it dotfiles`

FROM debian:12-slim

RUN apt update && apt install -y curl gcc git python3-pip sudo unzip zsh

WORKDIR /root/.config
COPY . .
RUN /root/.config/install.sh

