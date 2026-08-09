# This container is only for testing the installation of dotfiles
# Build with `docker build -t dotfiles .`
# Run with `docker run --rm -it dotfiles zsh`

FROM debian:13-slim

RUN apt update && apt install -y curl sudo dos2unix

COPY bootstrap.sh /bootstrap.sh
ENV DOTFILES_SKIP_CLONE=true
ENV DOTFILES_SKIP_INSTALL=true
RUN dos2unix /bootstrap.sh
RUN /bootstrap.sh
WORKDIR /root
