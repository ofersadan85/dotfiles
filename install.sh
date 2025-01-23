#/bin/sh

set -e

dir_link() {
    SRC_DIR="${1}"
    DST_DIR="${2:-${HOME}}"

    for FILE in ${SRC_DIR}/.*; do
        if [ -f "${FILE}" ]; then
            OLD_FILE="$(realpath ${FILE})"
            NEW_FILE="${DST_DIR}/$(basename ${FILE})"
            rm -f "${NEW_FILE}"
            ln -s "${OLD_FILE}" "${NEW_FILE}"
            echo "Linked: ${NEW_FILE} -> ${OLD_FILE}"
        fi
    done
}

dir_link "./zsh"
dir_link "./home"
