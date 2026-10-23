ARG PHP_VERSION=8.4
FROM php:${PHP_VERSION}-apache

# Paquetes del sistema y extensiones de PHP que necesita Laravel
RUN apt-get update \
    && apt-get install -y --no-install-recommends git unzip libzip-dev \
    && docker-php-ext-install pdo_mysql zip bcmath \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Apache: apuntar a la carpeta public/ de Laravel y activar mod_rewrite
COPY apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Script de arranque (crea el proyecto la primera vez, instala dependencias y migra)
COPY entrypoint.sh /usr/local/bin/laravel-entrypoint
RUN sed -i 's/\r$//' /usr/local/bin/laravel-entrypoint \
    && chmod +x /usr/local/bin/laravel-entrypoint

WORKDIR /var/www/html
EXPOSE 80

ENTRYPOINT ["laravel-entrypoint"]
CMD ["apache2-foreground"]
