#!/usr/bin/env bash

INDEX_PATH="$HOME/.notion_pages_index" 
TOKEN_PATH="$HOME/.notion_token"

token=$(cat $TOKEN_PATH)

echo $1

if [[ $1 == '--build-index' ]]; then
    curl 'https://www.notion.so/api/v3/searchBlocks' \
      -H 'content-type: application/json' \
      -H "cookie: token_v2=$token;" \
      --data-binary '{"query":"","table":"space","id":"34f6d97a-b3c2-4db4-a0a0-567bc806055c","limit":10000}' \
      --compressed \
      | jq -r '.recordMap.block[].value | "\(.id)   \(.properties.title[0][0])"' \
      > $INDEX_PATH
else
    cat $INDEX_PATH\
      | fzf \
      | cut -f 1 -d ' ' \
      | sed -e 's/-//g' \
      | awk '{print "https://notion.so/"$1}' \
      | xargs chromium-browser --new-window
      # Use xdg-open instead to open the default browser
      #| xargs xdg-open
fi
