FROM    php:apache
COPY    backend-php/ /var/www/html/
COPY    frontend/ /var/www/html/
COPY    docker/start.sh .

RUN     pecl install redis && \
        docker-php-ext-enable redis

EXPOSE  80/tcp
VOLUME  /etc/hauk
COPY    docker/config.php     /etc/hauk
COPY    docker/users.htpasswd /etc/hauk

STOPSIGNAL SIGINT
RUN     chmod +x ./start.sh
CMD     ["./start.sh"]
