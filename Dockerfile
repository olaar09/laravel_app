FROM php:7-fpm

RUN apt-get update

RUN apt-get install composer

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
