#!/usr/bin/env bash
set -euo pipefail

ls -a build/libs/

# Required environment variables:
# API_COOKIE - auth cookie
# PROJECT_SLUG - project slug or ID
# TITLE - version title
# CHANGELOG - changelog text
# VERSION - version number
# LOADERS - comma-separated loaders
# GAME_VERSIONS - comma-separated game versions
# PRIMARY_FILE - path to file to upload
# FEATURED - true/false
# RELEASE_CHANNEL - release/beta/alpha/dev

if [[ -z "${API_COOKIE:-}" || -z "${PROJECT_ID:-}" || -z "${TITLE:-}" || -z "${VERSION:-}" || -z "${PRIMARY_FILE:-}" ]]; then
  echo "Missing required environment variables!"
  exit 1
fi

# Convert comma-separated loaders and game versions to JSON arrays
loaders_json=$(echo "$LOADERS" | awk -v q='"' 'BEGIN{ORS=","} {split($0, a, ","); for(i in a) print q a[i] q}' | sed 's/,$//')
game_versions_json=$(echo "$GAME_VERSIONS" | awk -v q='"' 'BEGIN{ORS=","} {split($0, a, ","); for(i in a) print q a[i] q}' | sed 's/,$//')

echo "Uploading version $VERSION for project $PROJECT_ID..."

echo "title=$TITLE" \
  -F "changelog=$CHANGELOG" \
  -F "featured=${FEATURED:-true}" \
  -F "releaseChannel=${RELEASE_CHANNEL:-release}" \
  -F "versionNumber=$VERSION" \
  -F "loaders=[$loaders_json]" \
  -F "gameVersions=[$game_versions_json]" \
  -F "primaryFile=@$PRIMARY_FILE"

curl -X POST "https://api.crmm.tech/api/project/$PROJECT_ID/version" \
  -H "Cookie: auth-token=$API_COOKIE" \
  -F "title=$TITLE" \
  -F "changelog=$CHANGELOG" \
  -F "featured=${FEATURED:-true}" \
  -F "releaseChannel=${RELEASE_CHANNEL:-release}" \
  -F "versionNumber=$VERSION" \
  -F "loaders=[$loaders_json]" \
  -F "gameVersions=[$game_versions_json]" \
  -F "primaryFile=@$PRIMARY_FILE"
