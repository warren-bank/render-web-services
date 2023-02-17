FROM alpine:3.14

# based on:
#   https://github.com/rsubr/php-apache-alpine/blob/master/Dockerfile

# Install apache and php8
RUN apk add --no-cache \
        php8 \
        php8-apache2 \
        php8-ctype \
        php8-curl \
        php8-fileinfo \
        php8-gettext \
        php8-intl \
        php8-json \
        php8-mbstring \
        php8-pecl-redis \
        php8-posix \
        php8-zip

RUN     mkdir -p              /var/www/html
COPY    backend-php/          /var/www/html/
COPY    frontend/             /var/www/html/
COPY    docker/apache2.conf   /etc/apache2/conf.d
COPY    docker/start.sh       .

VOLUME  /etc/hauk
COPY    docker/config.php     /etc/hauk
COPY    docker/users.htpasswd /etc/hauk

# Set file and directory permissions
RUN     chmod +x ./start.sh
RUN     chown apache /var/www/html ./start.sh /etc/hauk /run/apache2 /var/log/apache2

# Grant 'apache' non-root user the ability to bind to port 80
RUN apk add --no-cache libcap && \
        setcap 'cap_net_bind_service=+ep' /usr/sbin/httpd && \
        apk del libcap

EXPOSE  80/tcp
USER    apache

CMD     ["./start.sh"]
