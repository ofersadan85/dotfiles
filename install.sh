#/bin/sh

set -e

SCRIPT_DIR=$(dirname "${0}")

git_clone_if_needed() {
    TARGET_FOLDER="${1}"
    GIT_REPO="${2}"
    if [ -d "${TARGET_FOLDER}" ]; then
        echo "Folder already exists ${TARGET_FOLDER}"
    else
        echo "Cloning to ${TARGET_FOLDER}"
        git clone --depth=1 "${GIT_REPO}" "${TARGET_FOLDER}"
    fi
}

install_ohmyzsh() {
    ZSH="${HOME}/.oh-my-zsh"
    ZSH_CUSTOM="${ZSH}/custom"
    ZSH_PLUGINS="${ZSH_CUSTOM}/plugins"
    ZSH_THEMES="${ZSH_CUSTOM}/themes"

    if [ -d "${ZSH}" ]; then
        echo "oh-my-zsh already installed at ${ZSH}"
    else
        echo "Installing oh-my-zsh at ${ZSH}"
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh) --unattended"
        git_clone_if_needed "${ZSH_THEMES}/powerlevel10k" https://github.com/romkatv/powerlevel10k.git
        git_clone_if_needed "${ZSH_PLUGINS}/zsh-completions" https://github.com/zsh-users/zsh-completions.git
        git_clone_if_needed "${ZSH_PLUGINS}/zsh-autosuggestions" https://github.com/zsh-users/zsh-autosuggestions.git
        git_clone_if_needed "${ZSH_PLUGINS}/zsh-syntax-highlighting" https://github.com/zsh-users/zsh-syntax-highlighting.git
    fi
}

dir_link() {
    SRC_DIR="${SCRIPT_DIR}/${1}"
    DST_DIR="${2:-${HOME}}"

    for FILE in ${SRC_DIR}/*; do
        if [ -f "${FILE}" ]; then
            OLD_FILE="$(realpath ${FILE})"
            NEW_FILE="${DST_DIR}/$(basename ${FILE})"
            rm -f "${NEW_FILE}"
            ln -s "${OLD_FILE}" "${NEW_FILE}"
            echo "Linked: ${NEW_FILE} -> ${OLD_FILE}"
        fi
    done

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

install_ohmyzsh
dir_link "./zsh"
dir_link "./home"
dir_link "./gnupg" "${HOME}/.gnupg"
