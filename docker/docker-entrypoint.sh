#!/bin/sh
set -e

# This line is used to avoid apache2 warnng AH00558: 
# 'Could not reliably determine the server's fully qualified domain name'
echo "ServerName localhost" >> /etc/apache2/apache2.conf
exec docker-php-entrypoint "$@"
