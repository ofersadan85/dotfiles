set shell := ["bash", "-c"]
set windows-shell := ["pwsh", "-Command"]

build:
  docker build -t dotfiles .

test:
  docker run --rm -it -v .:/root/.config dotfiles zsh
