#!/bin/bash

BOT_URL="https://api.telegram.org/bot${BOT_TOKEN}"
curl -s -X POST $BOT_URL/sendDocument -F chat_id=$CHAT_ID \
        -F document=@$1
