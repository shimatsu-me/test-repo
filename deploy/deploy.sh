#!/bin/bash

echo '<<<<<<ここです！<<<<<<<<'

# 環境変数の値を直接出力する場合
echo "${TABLE_CHECK_WEB_BOOKING_URL}"

# もし環境変数が base64 エンコードされている場合、デコードして出力する例
if [[ "${TABLE_CHECK_WEB_BOOKING_URL}" == *"="* ]]; then
  decoded_url=$(echo "${TABLE_CHECK_WEB_BOOKING_URL}" | base64 --decode)
  echo "${decoded_url}"
fi

echo '<<<<<<ここです！<<<<<<<<'
