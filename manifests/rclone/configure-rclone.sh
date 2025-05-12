#!/bin/bash

# Variables
RCLONE_CONFIG_PATH="/config/rclone/rclone.conf"

# Create/Ensure that directory exists
mkdir -p "$(dirname "$RCLONE_CONFIG_PATH")"

# Generate config file
cat > "$RCLONE_CONFIG_PATH" <<EOL
[BitwardenBackup]
type = s3
provider = Cloudflare
env_auth = false
region = auto
access_key_id = ${ACCESS_KEY_ID}
secret_access_key = ${SECRET_ACCESS_KEY}
endpoint = ${ENDPOINT_URI}
EOL

# Call original entrypoint
exec /app/entrypoint.sh "$@"