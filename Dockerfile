#STAGE One: PHP Dependencies
FROM composer:1.7 as vendor

ENV TZ=Europe/Minsk

ENV DEBIAN_FRONTEND=noninteractive 

WORKDIR /app

#copy all of laravel folder into working directory
#copying the whole directory is a good option to make 
#sure the install doesnt break due to missing expected files
COPY . /app

RUN composer install \
    --ignore-platform-reqs \
    --no-interaction \
    --no-plugins \
    --no-scripts \
    --prefer-dist


#STAGE Two: Application code
#++++++++++++++++++++++++++++++++++++++
# Ubuntu 14.04 PHP-Nginx Docker container
#++++++++++++++++++++++++++++++++++++++

FROM webdevops/php:ubuntu-14.04

ENV WEB_DOCUMENT_ROOT  /var/www/html/
ENV WEB_DOCUMENT_INDEX index.php
ENV WEB_ALIAS_DOMAIN   *.vm

WORKDIR /var/www/html

#copy application code
COPY . .
COPY --from=vendor /app/vendor/ ./vendor/

# Install nginx
RUN /usr/local/bin/apt-install \
    nginx

RUN chown -R www-data:www-data \
    ./storage \
    ./bootstrap/cache

# Deploy scripts/configurations
#COPY conf/ /opt/docker/
RUN echo exit 0 > /usr/sbin/policy-rc.d
COPY ./laravel.conf /opt/docker/etc/nginx/conf.d
RUN bash /opt/docker/bin/control.sh provision.role webdevops-nginx \
    && bash /opt/docker/bin/control.sh provision.role webdevops-php-nginx \
    && bash /opt/docker/bin/bootstrap.sh

EXPOSE 80
EXPOSE 443

CMD ["supervisord"]




# FROM php:7.2-fpm
# WORKDIR /var/www/html
# # not working due to laravel closure bug --> RUN php artisan optimize