#!/bin/bash
set -e

echo "Waiting for MySQL..."

until mysqladmin ping \
    -h"$DB_HOST" \
    -u"$DB_USERNAME" \
    -p"$DB_PASSWORD" \
    --silent
do
    sleep 3
done

echo "MySQL Ready "


# Check if Bagisto installed
TABLE_CHECK=$(mysql \
  -h"$DB_HOST" \
  -u"$DB_USERNAME" \
  -p"$DB_PASSWORD" \
  "$DB_DATABASE" \
  -sse "SHOW TABLES LIKE 'channels';")

if [ -z "$TABLE_CHECK" ]; then
    echo "Installing Bagisto..."

    php artisan key:generate --force
    php artisan migrate --force
    php artisan db:seed --force
    php artisan bagisto:install --no-interaction

    echo "Bagisto Installation Complete"
else
    echo "Bagisto already installed "
fi


php artisan config:clear
php artisan cache:clear

echo "Starting Web Stack..."
exec /opt/docker/bin/entrypoint.sh supervisord

