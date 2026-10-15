#!/bin/sh

set -e

SCRIPT_DIR=$(dirname "${0}")
GITHUB_USERNAME=ofersadan85
GPG_KEY_ID=D3CC5A5FA79185DE32D6AD63A92DF6E22ACEDD4F

file_link() {
    [ -e "${1}" ] || return 0  # unmatched glob
    SRC_FILE="$(realpath ${1})"
    DST_FILE="${2}/$(basename ${SRC_FILE})"
    if [ -f "${SRC_FILE}" ]; then
        if [ -e "${DST_FILE}" ] && [ ! -L "${DST_FILE}" ]; then
            mv "${DST_FILE}" "${DST_FILE}.bak"
            echo "Backed up: ${DST_FILE} -> ${DST_FILE}.bak"
        fi
        rm -f "${DST_FILE}"
        ln -s "${SRC_FILE}" "${DST_FILE}"
        echo "Linked: ${DST_FILE} -> ${SRC_FILE}"
    fi
}

dir_link() {
    SRC_DIR="${SCRIPT_DIR}/${1}"
    DST_DIR="${2:-${HOME}}"
    [ -d "${DST_DIR}" ] || mkdir -p "${DST_DIR}"
    for FILE in ${SRC_DIR}/*; do
        file_link "${FILE}" "${DST_DIR}"
    done

    for FILE in ${SRC_DIR}/.[!.]*; do
        file_link "${FILE}" "${DST_DIR}"
    done
}

git -C "${SCRIPT_DIR}" submodule init
git -C "${SCRIPT_DIR}" submodule update
dir_link "./zsh"
dir_link "./cargo" "${HOME}/.cargo"

# ~/.local/bin
BIN_FOLDER="${HOME}/.local/bin"
mkdir -p "${BIN_FOLDER}"
dir_link "./bin" "${BIN_FOLDER}"

# ~/.gnupg
GPG_FOLDER="${HOME}/.gnupg"
mkdir -p "${GPG_FOLDER}"
chmod 700 "${GPG_FOLDER}"
dir_link "./gnupg" "${GPG_FOLDER}"
if gpg --list-keys "${GPG_KEY_ID}" > /dev/null 2>&1; then
    echo "GPG key ${GPG_KEY_ID} already imported"
else
    curl -fs "https://github.com/${GITHUB_USERNAME}.gpg" | gpg --import || echo "Could not import GPG key (offline?), skipping"
fi

# ~/.ssh
SSH_FOLDER="${HOME}/.ssh"
SSH_KEY_FILE="${SSH_FOLDER}/id_ed25519"
if [ -f "${SSH_KEY_FILE}" ]; then
    echo "${SSH_KEY_FILE} already exists"
else
    ssh-keygen -t ed25519 -N '' -f "${SSH_KEY_FILE}"
fi
