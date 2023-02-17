FROM php:7.4-apache

# based on:
#   https://github.com/render-examples/open-web-analytics/blob/master/Dockerfile

COPY    --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN     install-php-extensions redis
RUN     mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY    backend-php/ /var/www/html/
COPY    frontend/    /var/www/html/

RUN     mkdir -p /etc/hauk
COPY    docker/config.php     /etc/hauk/
COPY    docker/users.htpasswd /etc/hauk/

RUN chown -R www-data:www-data /var/www/html/ && \
    chmod -R 0750              /var/www/html/

RUN chown -R www-data:www-data /etc/hauk/ && \
    chmod -R 0750              /etc/hauk/

COPY    docker/docker-entrypoint.sh /
RUN     chmod +x /docker-entrypoint.sh
ENTRYPOINT [ "/docker-entrypoint.sh" ]

CMD ["apache2-foreground"]
