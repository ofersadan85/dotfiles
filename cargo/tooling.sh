#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(dirname $(realpath "${0}"))

if ! [ -f "${HOME}/.cargo/bin/cargo-binstall" ]; then
  # See: https://github.com/cargo-bins/cargo-binstall#quickly
  BINSTALL_URL=https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh
  curl -L --proto '=https' --tlsv1.2 -sSf "${BINSTALL_URL}" | bash
  INSTALLED_BINSTALL=1
fi

CARGO_PACKAGES=$(tr '\n' ' ' < "${SCRIPT_DIR}/packages.txt")
if [ -n "${CARGO_PACKAGES}" ]; then
  cargo binstall --no-confirm $CARGO_PACKAGES
fi

