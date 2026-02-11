FROM webdevops/php-nginx:8.2

#Set Working directory
WORKDIR /app

# Install MySQL client
RUN apt-get update && apt-get install -y default-mysql-client

#Copy porject files
COPY . /app

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

#Set correct Permission
RUN chown -R application:application /app/storage /app/bootstrap/cache

# Set Environment 
ENV WEB_DOCUMENT_ROOT=/app/public


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]


