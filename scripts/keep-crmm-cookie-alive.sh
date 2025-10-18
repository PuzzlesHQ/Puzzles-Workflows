
echo "keeping CRMM alive"

response=$(
curl -X GET "https://api.crmm.tech/api/auth/me" \
  -H "Cookie: auth-token=$API_COOKIE"
)

success=$(echo "$response" | jq -r '.success')

if [ "$success" = "false" ]; then
  echo "$response"
  exit 1
fi
