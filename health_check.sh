#!/bin/bash

URL="https://bitter-wood-9241.fly.dev/health"

response=$(curl -sb -H "Accept: application/text" $URL)

if [[ "$response" -ne "ok" ]] ; then
  exit 1
else
  echo "Pokemon site healthy"
fi