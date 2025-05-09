FROM golang:1.23-alpine AS build-env

RUN set -ex && \
    apk upgrade --no-cache --available && \
    apk add --no-cache build-base openssl git

RUN mkdir -p /pkg/data

# --------------------------------------------------------------------
# make: self-signed certificate

ARG MAIL_DOMAIN=""

COPY ./crt/ca.crt /pkg/data/ca.crt
COPY ./crt/ca.key /pkg/data/ca.key

COPY ./bin/sign_certificate.sh /tmp/sign_certificate.sh
RUN chmod 755 /tmp/sign_certificate.sh
RUN /tmp/sign_certificate.sh

# --------------------------------------------------------------------
# build: maddy.conf

ARG SQL_DRIVER=""
ARG SQL_DSN=""

ARG S3_ENDPOINT=""
ARG S3_SECURE="yes"
ARG S3_ACCESS_KEY=""
ARG S3_SECRET_KEY=""
ARG S3_BUCKET=""
ARG S3_OBJECT_PREFIX=""
ARG S3_REGION=""
ARG S3_CREDS=""

COPY ./bin/build_maddy_conf.sh /tmp/build_maddy_conf.sh
RUN chmod 755 /tmp/build_maddy_conf.sh
RUN /tmp/build_maddy_conf.sh >/pkg/data/maddy.conf

# --------------------------------------------------------------------
# build: maddy (Golang)

ARG MADDY_ADDITIONAL_BUILD_TAGS=""
ARG GOFLAGS=""

RUN git clone "https://github.com/foxcpp/maddy.git" /maddy
WORKDIR /maddy

RUN go mod download
RUN mkdir -p /tmp/build_maddy
RUN ./build.sh --builddir /tmp/build_maddy --destdir /pkg/ --tags "docker ${MADDY_ADDITIONAL_BUILD_TAGS}" build install

# --------------------------------------------------------------------
# build: alps (Golang)

ARG ALPS_ADDITIONAL_BUILD_TAGS=""
ARG ALPS_GOFLAGS="-trimpath"

RUN git clone "https://git.sr.ht/~migadu/alps" /alps
WORKDIR /alps

RUN go mod download
RUN mkdir -p /tmp/build_alps
RUN go build -tags "$ALPS_ADDITIONAL_BUILD_TAGS" -o /tmp/build_alps ${ALPS_GOFLAGS} ./cmd/alps
RUN command install -m 0755 /tmp/build_alps/alps /pkg/usr/local/bin

ARG ALPS_THEME=""

RUN <<EOF
  if [ -n "$ALPS_THEME" ] && [ -d "/alps/themes/${ALPS_THEME}" ]; then
    mkdir -p /pkg/data/themes
    mv "/alps/themes/${ALPS_THEME}" "/pkg/data/themes/${ALPS_THEME}"
  fi
EOF

# --------------------------------------------------------------------
# build: Docker image

FROM alpine:3.21.2

RUN set -ex && \
    apk upgrade --no-cache --available && \
    apk add --no-cache ca-certificates

ARG MAIL_HOSTNAME=""
ENV MADDY_HOSTNAME="$MAIL_HOSTNAME"

ARG MAIL_DOMAIN=""
ENV MADDY_DOMAIN="$MAIL_DOMAIN"

ARG ROOT_PASSWORD=""
ENV ENABLE_SSHD=${ROOT_PASSWORD:+true}

RUN <<EOF
  if [ "$ENABLE_SSHD" = "true" ]; then
    echo "root:${ROOT_PASSWORD}" | chpasswd

    apk add --no-cache --update dropbear
    mkdir -p /etc/dropbear
  fi
EOF

RUN mkdir -p /data/tls

COPY --from=build-env /pkg/data/fullchain.pem  /data/tls/fullchain.pem
COPY --from=build-env /pkg/data/privkey.pem    /data/tls/privkey.pem
COPY --from=build-env /pkg/data/maddy.conf     /data/maddy.conf
COPY --from=build-env /pkg/data/themes         /data/themes
COPY --from=build-env /pkg/usr/local/bin/maddy /bin/maddy
COPY --from=build-env /pkg/usr/local/bin/alps  /bin/alps

# ================== SSH:
EXPOSE 22
# ================== SMTP:
EXPOSE 25 465 587
# ================== IMAP:
EXPOSE 143 993
# ================== HTTP:
EXPOSE 80

ENTRYPOINT [ "/bin/entry_point.sh" ]

# --------------------------------------------------------------------
# build: entry point
# start: ssh server, maddy mail server, alps webmail http server

ARG ALPS_THEME=""

# default interval: 5 minutes
ENV FORCE_ACTIVITY=""
ENV FORCE_ACTIVITY_INTERVAL="300"

RUN <<EOF
  cat >'/bin/entry_point.sh' <<EOENTRY
#!/bin/sh

# alps looks for themes in ./themes
cd /data

if [ "\$ENABLE_SSHD" = "true" ] && [ -x /usr/sbin/dropbear ]; then
  echo 'starting SSH server'
  /usr/sbin/dropbear -R -a -p 0.0.0.0:22 &
fi

if [ -x /bin/maddy ]; then
  echo 'starting Maddy Mail server'
  /bin/maddy -config /data/maddy.conf run &
fi

# give Maddy a little time to start up, before Alps connects to its IMAP and SMTP servers
sleep 15

if [ -x /bin/alps ]; then
  echo 'starting Alps WebMail server'
  /bin/alps -theme "$ALPS_THEME" -addr ":80" "imap+insecure://127.0.0.1:143" "smtp+insecure://127.0.0.1:587" &
fi

# keep the container alive, while the servers run in the background
if [ -n "\$FORCE_ACTIVITY" ]; then
  echo "heartbeat: periodic network requests will occur at a \${FORCE_ACTIVITY_INTERVAL} second interval"
  while true; do
    sleep "\$FORCE_ACTIVITY_INTERVAL"
    echo 'heartbeat: making periodic network request to force activity'
    curl -s -k -L -H 'Origin: http://localhost:80' "\$FORCE_ACTIVITY" >/dev/null 2>&1
  done
else
  sleep infinity
fi

exit 0
EOENTRY
  chmod 755 /bin/entry_point.sh
EOF

# --------------------------------------------------------------------
# optional/final user-defined build commands

ENV INIT_COMMAND=""

if [ -n "$INIT_COMMAND" ]; then
  /bin/sh -c "$INIT_COMMAND"
fi
