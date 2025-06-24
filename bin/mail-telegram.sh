#/bin/sh
#
# This script will redirect the first mail from the `mail` command to telegram
# It will also delete the message (!) currently regardless of success or fail
#
# Requires `mailutils` (`sudo apt install mailutils`) and will automatically capture cron output
#
# To silence this output redirect for a specific cron job, redirect it to `> /dev/null 2>&1`, for example:
#
# * * * * * echo "WILL SEND MAIL"
# * * * * * echo "WILL NOT SEND MAIL" > /dev/null 2>&1
#
# To capture all mails automatically, add this line to your crontab (redirect to /dev/null to avoid recursion)
# * * * * * /path/to/this/script > /dev/null 2>&1
#
# To capture cron / mail output from the root user add this script to the root's crontab, or:
# 1. Add `root: <YOUR-USERNAME>` to /etc/aliases
# 2. Run `sudo newaliases` to take effect

SCRIPT_DIR=$(dirname "$0")
MAIL_BODY=$(echo "1\nd\nq" | mail)
NO_MAIL="No mail for $(whoami)"
if [ "${MAIL_BODY}" = "${NO_MAIL}" ]; then
	echo "${NO_MAIL}"
else
	echo "${MAIL_BODY}" | "${SCRIPT_DIR}/telegram-private"
fi
