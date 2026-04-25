#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash download_and_upload_osm.sh [REMOTE_PATH] [DOWNLOAD_DIR]
# Example:
#   bash download_and_upload_osm.sh gdrive:/backup/osm /home/user/app/data/osm

REMOTE_PATH="${1:-gdrive:/backup/osm}"
DOWNLOAD_DIR="${2:-$HOME/app/data/osm}"

FILES=(
  "https://download.geofabrik.de/north-america/us/california-latest.osm.pbf|california.osm.pbf"
  "https://download.geofabrik.de/europe/spain-latest.osm.pbf|spain.osm.pbf"
  "https://download.geofabrik.de/asia/india-latest.osm.pbf|india.osm.pbf"
  "https://download.geofabrik.de/south-america/brazil-latest.osm.pbf|brazil.osm.pbf"
)

need_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing command: $1"
    exit 1
  fi
}

need_cmd wget
need_cmd rclone

REMOTE_NAME="${REMOTE_PATH%%:*}:"
if ! rclone listremotes | grep -Fxq "$REMOTE_NAME"; then
  echo "rclone remote not found: $REMOTE_NAME"
  echo "Run: rclone config"
  exit 1
fi

mkdir -p "$DOWNLOAD_DIR"

echo "Download dir : $DOWNLOAD_DIR"
echo "Upload target: $REMOTE_PATH"
echo

for item in "${FILES[@]}"; do
  url="${item%%|*}"
  filename="${item##*|}"
  local_path="$DOWNLOAD_DIR/$filename"
  remote_file="${REMOTE_PATH%/}/$filename"

  echo "==> Downloading $filename"
  wget -c \
    --tries=20 \
    --waitretry=5 \
    --timeout=30 \
    --read-timeout=30 \
    -O "$local_path" \
    "$url"

  echo "==> Uploading $filename to $remote_file"
  rclone copyto \
    "$local_path" \
    "$remote_file" \
    --progress \
    --retries=10 \
    --low-level-retries=20 \
    --checkers=4 \
    --transfers=1

  echo "==> Done: $filename"
  echo
done

echo "All downloads and uploads completed successfully."
