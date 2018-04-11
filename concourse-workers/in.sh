#!/bin/bash

set -e

exec 3>&1 # make stdout available as fd 3 for the result
exec 1>&2 # redirect all output to stderr for logging

destination=$1

if [ -z "$destination" ]; then
  echo "usage: $0 <path/to/destination>" >&2
  exit 1
fi

PATH=/usr/local/bin:$PATH

payload=$(mktemp /tmp/resource-in.XXXXXX)

cat > $payload <&0

mkdir -p $destination

jq -n "{
}" >&3
    