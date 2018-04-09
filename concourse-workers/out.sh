#!/bin/bash

set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

source=$1

if [ -z "$source" ]; then
  echo "usage: $0 <path/to/source>" >&2
  exit 1
fi

PATH=/usr/local/bin:$PATH

payload=$(mktemp /tmp/resource-out.XXXXXX)

cat > $payload <&0

cd $source

jq -n "{
}" >&3
    