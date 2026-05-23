FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev nodejs npm \
    && docker-php-ext-install zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

# PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# 🔥 FRONTEND (esto es lo importante para tu CSS)
RUN npm install
RUN npm run build

# 🔥 limpiar caches Laravel (ok ponerlo aquí)
RUN php artisan config:clear \
 && php artisan cache:clear \
 && php artisan view:clear

# asegurar permisos
RUN chmod -R 775 storage bootstrap/cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000