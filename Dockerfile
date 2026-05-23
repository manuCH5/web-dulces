FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git curl unzip libzip-dev nodejs npm \
    && docker-php-ext-install zip pdo pdo_mysql

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

RUN composer install --no-dev --optimize-autoloader

# 👇 IMPORTANTE: Tailwind/Vite
RUN npm install
RUN npm run build

RUN chmod -R 775 storage bootstrap/cache

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000