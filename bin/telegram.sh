#/bin/sh

TELEGRAM_BOT_TOKEN="${1}"
TELEGRAM_CHAT_ID="${2}"
TEXT="$(cat)"

TELEGRAM_HEADERS="Content-Type: application/json"
TELEGRAM_DATA=$(jq --null-input --arg TELEGRAM_CHAT_ID "${TELEGRAM_CHAT_ID}" --arg TEXT "${TEXT}" '{"chat_id": $TELEGRAM_CHAT_ID, "text": $TEXT}')
TELEGRAM_ENDPOINT="https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage"
echo "${TELEGRAM_ENDPOINT}"
echo "Sending data: ${TELEGRAM_DATA}"
curl -X POST -H "${TELEGRAM_HEADERS}" -d "${TELEGRAM_DATA}" "${TELEGRAM_ENDPOINT}"
