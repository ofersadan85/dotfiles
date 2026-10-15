set shell := ["bash", "-c"]
set windows-shell := ["pwsh", "-Command"]

build:
  docker build -t dotfiles .

test:
  docker run --rm -it -v .:/root/.config dotfiles zsh

update:
  git submodule update --init --remote --merge

lint:
  prek run --all-files
