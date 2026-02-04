#!/bin/bash
set -e

echo " Starting Bagisto container..."

echo " Waiting for database..."

until php -r "
new PDO(
  'mysql:host=${DB_HOST};port=${DB_PORT};dbname=${DB_DATABASE}',
  '${DB_USERNAME}',
  '${DB_PASSWORD}'
);
" > /dev/null 2>&1; do
  sleep 3
done

echo " Database is ready"

# Generate app key if missing
if ! grep -q "^APP_KEY=base64" .env; then
    echo "Generating APP_KEY"
    php artisan key:generate
fi

# Clear cache
php artisan config:clear
php artisan cache:clear

# Run migrations & seed only once
if [ ! -f storage/installed ]; then
    echo " Running migrations & seed"
    php artisan migrate --force
    php artisan db:seed --force
    php artisan bagisto:install --no-interaction
    touch storage/installed
    echo " Bagisto installed"
fi

exec php-fpm

