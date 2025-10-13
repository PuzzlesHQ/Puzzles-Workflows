ls -a

echo "keeping CRMM alive"

curl -X GET "https://api.crmm.tech/api/auth/me" \
  -H "Cookie: auth-token=$API_COOKIE"
