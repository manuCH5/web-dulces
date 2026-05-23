# 1. Node stage
FROM node:20 AS node

WORKDIR /app
COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build


# 2. PHP stage
FROM php:8.2-cli

WORKDIR /app

RUN apt-get update && apt-get install -y \
    git unzip curl libzip-dev \
    && docker-php-ext-install pdo pdo_mysql zip

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

COPY . .

# copiar build de Vite desde node stage
COPY --from=node /app/public/build /app/public/build

RUN composer install --no-dev --optimize-autoloader

EXPOSE 10000

CMD php artisan serve --host=0.0.0.0 --port=10000