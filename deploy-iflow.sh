#!/bin/bash
set -e

IFLOW_ID="My_Integration_Flow"
IFLOW_NAME="My Integration Flow"
ZIP_FILE="cpi-artifacts/My_Integration_Flow/My_Integration_Flow.zip"

TOKEN=$(curl -s \
  -u "$CPI_CLIENT_ID:$CPI_CLIENT_SECRET" \
  "$CPI_TOKEN_URL?grant_type=client_credentials" \
  | jq -r '.access_token')

CONTENT=$(base64 -w 0 "$ZIP_FILE")

curl -X PUT \
  "$CPI_HOST/api/v1/IntegrationDesigntimeArtifacts(Id='$IFLOW_ID',Version='active')" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d "{
    \"Name\": \"$IFLOW_NAME\",
    \"ArtifactContent\": \"$CONTENT\"
  }"

curl -X POST \
  "$CPI_HOST/api/v1/DeployIntegrationDesigntimeArtifact?Id='$IFLOW_ID'&Version='active'" \
  -H "Authorization: Bearer $TOKEN"
