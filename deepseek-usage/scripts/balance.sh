#!/bin/bash
set -e

DEEPSEEK_API_KEY="${DEEPSEEK_API_KEY:-sk-c3b6a22ab1084d90a3f847e284a339a3}"
API_URL="https://api.deepseek.com/user/balance"

response=$(curl -s -w "\n%{http_code}" "$API_URL" \
  -H "Authorization: Bearer $DEEPSEEK_API_KEY" \
  -H "Content-Type: application/json")

http_code=$(echo "$response" | tail -1)
body=$(echo "$response" | sed '$d')

if [ "$http_code" != "200" ]; then
  echo "请求失败 (HTTP $http_code)"
  echo "$body"
  exit 1
fi

echo "$body" | python3 -c "
import json, sys

data = json.load(sys.stdin)

if not data.get('is_available', False):
    print('账户无可用余额')
    sys.exit(0)

print('DeepSeek 账户余额')
print('=' * 40)

for info in data.get('balance_infos', []):
    currency = info.get('currency', 'UNKNOWN')
    symbol = '¥' if currency == 'CNY' else '\$'
    total = info.get('total_balance', '0')
    granted = info.get('granted_balance', '0')
    topped = info.get('topped_up_balance', '0')

    print(f'币种: {currency}')
    print(f'  总余额:     {symbol}{total}')
    print(f'  赠金余额:   {symbol}{granted}')
    print(f'  充值余额:   {symbol}{topped}')
    print()
"
