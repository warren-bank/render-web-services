#!/usr/bin/env bash

docker run --pull=never -d -p 1022:22 -p 25:25 -p 465:465 -p 587:587 -p 143:143 -p 993:993 -p 1080:80 'maddy-email'

echo 'Alps Webmail Server:'
echo '  http://localhost:1080'
echo ''
echo 'Dropbear SSH Server:'
echo '  ssh -p 1022 root@localhost'
echo '  (default password: root)'
