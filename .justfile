build:
  docker build -t dotfiles .

test:
  docker run --rm -it dotfiles zsh

