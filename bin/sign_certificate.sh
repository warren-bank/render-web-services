#!/bin/sh

# https://stackoverflow.com/a/74473673

cd /pkg/data

# ---------------------------------------------------------- [interplate]
cat <<EOF >ext.conf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = some_dn

[some_dn]
C = US
ST = Nevada
L = Las Vegas
O = MaddyMail
emailAddress = maddy@example.com
CN = $MAIL_DOMAIN

EOF
# ---------------------------------------------------------- [/interplate]

openssl req -new -nodes -sha256 -newkey rsa:2048 -keyout domain.key -config ext.conf -out domain.csr
openssl x509 -req -in domain.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out domain.crt -days 500 -sha256 -extfile ext.conf

cp domain.key privkey.pem
cat domain.crt ca.crt >fullchain.pem
