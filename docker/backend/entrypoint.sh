#!/usr/bin/env bash
set -e
cd /var/www/html

# Creación del proyecto Laravel
if [ ! -f artisan ]; then
    echo ">> No hay proyecto Laravel en backend/. Creando uno nuevo..."
    composer create-project laravel/laravel /tmp/laravel --prefer-dist --no-interaction
    cp -a /tmp/laravel/. /var/www/html/
    rm -rf /tmp/laravel
fi

# Dependencias de Composer
if [ ! -f vendor/autoload.php ]; then
    echo ">> Instalando dependencias de Composer..."
    composer install --no-interaction --prefer-dist
fi

# Archivo .env y APP_KEY
if [ ! -f .env ]; then
    cp .env.example .env
fi
if ! grep -q '^APP_KEY=base64:' .env; then
    php artisan key:generate --force
fi

# Permisos de escritura
chown -R www-data:www-data storage bootstrap/cache 2>/dev/null || true
chmod -R ug+rwX storage bootstrap/cache 2>/dev/null || true

# Migraciones
php artisan migrate --force || echo ">> Aviso: no se pudieron ejecutar las migraciones."

exec "$@"
