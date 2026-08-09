#/bin/sh

set -e

SCRIPT_DIR=$(dirname "${0}")
GITHUB_USERNAME=ofersadan85

file_link() {
    SRC_FILE="$(realpath ${1})"
    DST_FILE="${2}/$(basename ${SRC_FILE})"
    if [ -f "${SRC_FILE}" ]; then
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

    for FILE in ${SRC_DIR}/.*; do
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
curl -s "https://github.com/${GITHUB_USERNAME}.gpg" | gpg --import

# ~/.ssh
SSH_FOLDER="${HOME}/.ssh"
SSH_KEY_FILE="${SSH_FOLDER}/id_ed25519"
if [ -f "${SSH_KEY_FILE}" ]; then
    echo "${SSH_KEY_FILE} already exists"
else
    ssh-keygen -t ed25519 -N '' -f "${SSH_KEY_FILE}"
fi
