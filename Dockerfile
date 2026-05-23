FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev nodejs npm \
    && docker-php-ext-install zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

# 🔥 IMPORTANTE: primero instalar PHP
RUN composer install --no-dev --optimize-autoloader

# 🔥 limpiar por si acaso
RUN rm -rf node_modules package-lock.json

# 🔥 instalar frontend BIEN
RUN npm install

# 🔥 build con debug visible
RUN npm run build || (echo "VITE ERROR" && exit 1)

RUN chmod -R 775 storage bootstrap/cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000