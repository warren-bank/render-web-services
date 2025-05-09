#!/usr/bin/env bash

# https://github.com/warren-bank/render-web-services/tree/maddy-email

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

[ ! -d ~/tmp ] && mkdir ~/tmp
cd ~/tmp

if [ ! -d 'render-web-services-maddy-email' ];then
  wget -O 'render-web-services-maddy-email.zip' 'https://github.com/warren-bank/render-web-services/archive/refs/heads/maddy-email.zip'
  unzip 'render-web-services-maddy-email.zip'
fi
cd 'render-web-services-maddy-email'

opts=()
while IFS= read -r line; do
  if [ -n "$line" -a ! "${line:0:1}" == "#" ];then
    line=$(echo "$line" | sed -E 's/\s*=\s*/=/')
    opts+=(--build-arg "$line")
  fi
done < "${DIR}/build-args.txt"

docker buildx build --progress=plain "${opts[@]}" -t 'maddy-email' --load .
