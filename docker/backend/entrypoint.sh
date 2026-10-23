#!/usr/bin/env bash
set -e
cd /var/www/html

# 1. Primer arranque: si la carpeta backend/ está vacía, crea un proyecto Laravel
if [ ! -f artisan ]; then
    echo ">> No hay proyecto Laravel en backend/. Creando uno nuevo..."
    composer create-project laravel/laravel /tmp/laravel --prefer-dist --no-interaction
    cp -a /tmp/laravel/. /var/www/html/
    rm -rf /tmp/laravel
fi

# 2. Dependencias de Composer (por ejemplo, después de clonar el repositorio)
if [ ! -f vendor/autoload.php ]; then
    echo ">> Instalando dependencias de Composer..."
    composer install --no-interaction --prefer-dist
fi

# 3. Archivo .env de Laravel y APP_KEY
#    (DB_*, MAIL_* y APP_* llegan como variables de entorno desde compose.yml
#     y tienen prioridad sobre los valores de backend/.env)
if [ ! -f .env ]; then
    cp .env.example .env
fi
if ! grep -q '^APP_KEY=base64:' .env; then
    php artisan key:generate --force
fi

# 4. Permisos de escritura para Apache
chown -R www-data:www-data storage bootstrap/cache 2>/dev/null || true
chmod -R ug+rwX storage bootstrap/cache 2>/dev/null || true

# 5. Migraciones en MariaDB
php artisan migrate --force || echo ">> Aviso: no se pudieron ejecutar las migraciones."

exec "$@"
