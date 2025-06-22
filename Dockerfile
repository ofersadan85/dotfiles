# This container is only for testing the installation of dotfiles
# Build with `docker build -t dotfiles .`
# Run with `docker run --rm -it -v ~/.config:/root/.config dotfiles`

FROM debian

RUN apt update && apt install -y curl gcc git python3-pip sudo unzip zsh


