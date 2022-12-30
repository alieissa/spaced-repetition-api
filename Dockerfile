FROM php:7.4.33-zts-alpine3.16

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY ./ /app

WORKDIR app

RUN composer install

CMD ["composer", '-v']