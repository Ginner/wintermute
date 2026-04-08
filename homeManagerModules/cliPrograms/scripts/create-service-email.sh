#!/usr/bin/env bash

cmd=$(basename "${0}")

helptext=$(cat <<-EOH
Usage: ${cmd} <service-name> <domain.tld>
Generates an email alias for use with online services and accounts.
Useful for services like addy.io, where you own the domain name and want
to create unique, trackable email aliases for different services.

Arguments:
  service-name   Name of the service (e.g., spotify, netflix, github)
  domain.tld     Your domain name (e.g., example.com)

Format:
  The generated email will be in the format: service-name_xxxxx@domain.tld
  where 'xxxxx' is a random 5-character string using [a-z0-9]

Examples:
  ${cmd} spotify example.com    → spotify_ab12c@example.com
  ${cmd} github mydomain.org    → github_x7y9z@mydomain.org

Notes:
  - The random string provides an additional security layer (don't rely on it)
    preventing Mallory from guessing your email for other services.
  - Email address is automatically copied to clipboard
  - Only lowercase letters and numbers are used in the random string
EOH
)

generate_random() {
  chars="abcdefghijklmnopqrstuvwxyz0123456789"
  for ((i=0; i<5; i++)); do
    echo -n "${chars:$((RANDOM % 36)):1}"
  done
}

if [ $# -ne 2 ]; then
  echo "$helptext"
  exit 0
fi

service_name="${1}"
domain="${2}"

random_chars=$(generate_random)

final_address="${service_name}_${random_chars}@${domain}"

echo "Generated email: ${final_address}"
echo -n "${final_address}" | nohup wl-copy > /dev/null 2>&1 &
echo "Address copied to clipboard!"
