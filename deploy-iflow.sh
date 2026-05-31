#!/bin/bash
set -e

PACKAGE_ID="TestSample"
ARTIFACT_ROOT="TestSample/IntegrationFlow"

TOKEN_RESPONSE=$(curl -s -X POST \
  -u "$CPI_CLIENT_ID:$CPI_CLIENT_SECRET" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  "$CPI_TOKEN_URL")

TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "Failed to get token"
  echo "$TOKEN_RESPONSE"
  exit 1
fi

for ARTIFACT_DIR in "$ARTIFACT_ROOT"/*; do
  [ -d "$ARTIFACT_DIR" ] || continue

  ARTIFACT_ID=$(basename "$ARTIFACT_DIR")
  ZIP_FILE="/tmp/${ARTIFACT_ID}.zip"

  echo "Creating zip for artifact: $ARTIFACT_ID"

  cd "$ARTIFACT_DIR"
  zip -r "$ZIP_FILE" .
  cd - >/dev/null

  CONTENT=$(base64 -w 0 "$ZIP_FILE")

  echo "Uploading artifact: $ARTIFACT_ID"

  curl -s -X PUT \
    "$CPI_HOST/api/v1/IntegrationDesigntimeArtifacts(Id='$ARTIFACT_ID',Version='active')" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    -d "{
      \"Name\": \"$ARTIFACT_ID\",
      \"PackageId\": \"$PACKAGE_ID\",
      \"ArtifactContent\": \"$CONTENT\"
    }"

  echo "Deploying artifact: $ARTIFACT_ID"

  curl -s -X POST \
    "$CPI_HOST/api/v1/DeployIntegrationDesigntimeArtifact?Id='$ARTIFACT_ID'&Version='active'" \
    -H "Authorization: Bearer $TOKEN"

  echo "Done: $ARTIFACT_ID"
done