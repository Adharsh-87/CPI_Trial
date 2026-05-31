#!/bin/bash
set -e

PACKAGE_ID="${CPI_PACKAGE_ID:-TestSample}"
ARTIFACT_ROOT="TestSample/IntegrationFlow"

echo "Getting OAuth token..."

TOKEN_RESPONSE=$(curl -s -X POST \
  -u "$CPI_CLIENT_ID:$CPI_CLIENT_SECRET" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=client_credentials" \
  "$CPI_TOKEN_URL")

TOKEN=$(echo "$TOKEN_RESPONSE" | jq -r '.access_token')

if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
  echo "Failed to get access token"
  echo "$TOKEN_RESPONSE"
  exit 1
fi

echo "Testing CPI API access..."

TEST_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
  "$CPI_HOST/api/v1/IntegrationPackages" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Accept: application/json")

echo "$TEST_RESPONSE"

TEST_STATUS=$(echo "$TEST_RESPONSE" | grep HTTP_STATUS | cut -d: -f2)

if [ "$TEST_STATUS" != "200" ]; then
  echo "CPI API access test failed"
  exit 1
fi

for ARTIFACT_DIR in "$ARTIFACT_ROOT"/*; do
  [ -d "$ARTIFACT_DIR" ] || continue

  ARTIFACT_ID=$(basename "$ARTIFACT_DIR")
  ZIP_FILE="/tmp/${ARTIFACT_ID}.zip"

  echo "Creating zip for artifact: $ARTIFACT_ID"

  rm -f "$ZIP_FILE"

  (
    cd "$ARTIFACT_DIR"
    zip -r "$ZIP_FILE" .
  )

  CONTENT=$(base64 -w 0 "$ZIP_FILE")

  echo "Checking whether artifact exists: $ARTIFACT_ID"

  CHECK_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" \
    "$CPI_HOST/api/v1/IntegrationDesigntimeArtifacts(Id='$ARTIFACT_ID',Version='active')" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Accept: application/json")

  CHECK_STATUS=$(echo "$CHECK_RESPONSE" | grep HTTP_STATUS | cut -d: -f2)

  if [ "$CHECK_STATUS" = "200" ]; then
    echo "Artifact exists. Updating artifact: $ARTIFACT_ID"

    RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X PUT \
      "$CPI_HOST/api/v1/IntegrationDesigntimeArtifacts(Id='$ARTIFACT_ID',Version='active')" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
        \"Name\": \"$ARTIFACT_ID\",
        \"PackageId\": \"$PACKAGE_ID\",
        \"ArtifactContent\": \"$CONTENT\"
      }")

  elif [ "$CHECK_STATUS" = "404" ]; then
    echo "Artifact does not exist. Creating artifact: $ARTIFACT_ID"

    RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST \
      "$CPI_HOST/api/v1/IntegrationDesigntimeArtifacts" \
      -H "Authorization: Bearer $TOKEN" \
      -H "Content-Type: application/json" \
      -d "{
        \"Id\": \"$ARTIFACT_ID\",
        \"Name\": \"$ARTIFACT_ID\",
        \"PackageId\": \"$PACKAGE_ID\",
        \"ArtifactContent\": \"$CONTENT\"
      }")

  else
    echo "Could not check artifact status: $ARTIFACT_ID"
    echo "$CHECK_RESPONSE"
    exit 1
  fi

  echo "$RESPONSE"

  STATUS=$(echo "$RESPONSE" | grep HTTP_STATUS | cut -d: -f2)

  if [ "$STATUS" != "200" ] && [ "$STATUS" != "201" ] && [ "$STATUS" != "202" ]; then
    echo "Create/update failed for $ARTIFACT_ID"
    exit 1
  fi

  echo "Deploying artifact: $ARTIFACT_ID"

  DEPLOY_RESPONSE=$(curl -s -w "\nHTTP_STATUS:%{http_code}" -X POST \
    "$CPI_HOST/api/v1/DeployIntegrationDesigntimeArtifact?Id='$ARTIFACT_ID'&Version='active'" \
    -H "Authorization: Bearer $TOKEN")

  echo "$DEPLOY_RESPONSE"

  DEPLOY_STATUS=$(echo "$DEPLOY_RESPONSE" | grep HTTP_STATUS | cut -d: -f2)

  if [ "$DEPLOY_STATUS" != "200" ] && [ "$DEPLOY_STATUS" != "202" ]; then
    echo "Deploy failed for $ARTIFACT_ID"
    exit 1
  fi

  echo "Done: $ARTIFACT_ID"
done