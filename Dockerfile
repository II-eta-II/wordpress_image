FROM php:8.3-fpm-alpine

# 安裝必要的套件與 PHP 擴展
RUN apk add --no-cache nginx libpng-dev libjpeg-turbo-dev freetype-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo_mysql zip opcache

# 設定工作目錄
WORKDIR /var/www/html

# 複製 Nginx 設定
COPY nginx.conf /etc/nginx/http.d/default.conf

# 下載 WordPress 官方檔案
ADD https://wordpress.org/latest.tar.gz /tmp/wordpress.tar.gz
RUN tar -xzf /tmp/wordpress.tar.gz --strip-components=1 -C /var/www/html \
    && rm /tmp/wordpress.tar.gz \
    && chown -R www-data:www-data /var/www/html

# 複製啟動腳本並給予權限
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT ["docker-entrypoint.sh"]
