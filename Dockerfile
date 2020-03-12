FROM php:7-fpm

RUN apt install composer

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
