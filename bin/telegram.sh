#!/bin/sh

# Prefer explicit arguments, then exported values, then the user's local shell
# configuration where the Telegram secrets are normally defined.
if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
    [ -r "${HOME}/.zshrc.local" ] && . "${HOME}/.zshrc.local"
fi

TELEGRAM_BOT_TOKEN="${1:-${TELEGRAM_BOT_TOKEN:-}}"
TELEGRAM_CHAT_ID="${2:-${TELEGRAM_CHAT_ID:-}}"

if [ -z "${TELEGRAM_BOT_TOKEN:-}" ] || [ -z "${TELEGRAM_CHAT_ID:-}" ]; then
    echo "telegram.sh: missing TELEGRAM_BOT_TOKEN or TELEGRAM_CHAT_ID" >&2
    exit 1
fi

TEXT="$(cat)"

TELEGRAM_HEADERS="Content-Type: application/json"
if ! command -v jaq >/dev/null 2>&1; then
    echo "telegram.sh: jaq is required" >&2
    exit 1
fi

TELEGRAM_DATA=$(jaq -n --arg chat_id "${TELEGRAM_CHAT_ID}" --arg text "${TEXT}" '{chat_id: $chat_id, text: $text}')
TELEGRAM_ENDPOINT="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"

curl --silent --show-error --fail \
    -X POST \
    -H "${TELEGRAM_HEADERS}" \
    --data "${TELEGRAM_DATA}" \
    "${TELEGRAM_ENDPOINT}"
