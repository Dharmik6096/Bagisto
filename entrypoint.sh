#!/bin/bash
set -e

echo "================================="
echo " Bagisto PHP-FPM Container Start"
echo "================================="

####################################
# Wait for MySQL
####################################

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

####################################
# Check Installation
####################################

TABLE_CHECK=$(mysql \
  -h"$DB_HOST" \
  -u"$DB_USERNAME" \
  -p"$DB_PASSWORD" \
  "$DB_DATABASE" \
  -sse "SHOW TABLES LIKE 'channels';")

####################################
#  Setup
####################################

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

####################################
#  Optimize
####################################

php artisan config:clear
php artisan cache:clear
php artisan route:clear 

####################################
# Start PHP-FPM 
####################################

echo "Starting web_app ..."
exec /opt/docker/bin/entrypoint.sh supervisord
