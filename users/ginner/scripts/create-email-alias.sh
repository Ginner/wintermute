#!/usr/bin/env bash

cmd=$(basename "${0}")

helptext=$(cat <<-EOH
Usage: ${cmd} <from_alias> <to_address>
Allows for sending emails from an email alias.
Useful for addy.io (maybe more?), where you want to send emails 
from one of your aliases while keeping your actual email private.

Arguments:
  from_alias    The alias email address (e.g., from@myalias.com)
  to_address    The receiving email address (e.g., to@receiver.net)

Format:
  The generated receiving address will be in the format:
  from+to=receiver.net@myalias.com

Examples:
  ${cmd} contact@mydomain.com personal@gmail.com    
    → contact+personal=gmail.com@mydomain.com
  ${cmd} jobs@company.com work@outlook.com          
    → jobs+work=outlook.com@company.com

Notes:
  - Keeps the receiving address private while maintaining forwarding
  - Email address is automatically copied to clipboard
EOH
)

# Check if we have the correct number of arguments
if [ $# -ne 2 ]; then
  echo "$helptext"
  exit 0
fi

from_alias="${1}"
to_address="${2}"

from_user=$(echo "${from_alias}" | cut -d@ -f1)
from_domain=$(echo "${from_alias}" | cut -d@ -f2)

formatted_to="${to_address//@/=}"

final_address="${from_user}+${formatted_to}@${from_domain}"

echo "Generated 'to' address: ${final_address}"
echo -n "${final_address}" | nohup wl-copy > /dev/null 2>&1 &
echo "Address copied to clipboard!"

