# 使用輕量級 Alpine + PHP 8.3
FROM php:8.3-fpm-alpine

# 安裝 Nginx, Supervisor 和必要的 PHP 擴充
RUN apk add --no-cache nginx supervisor \
    && docker-php-ext-install mysqli pdo pdo_mysql opcache

# 複製設定檔
COPY nginx.conf /etc/nginx/http.d/default.conf
COPY supervisord.conf /etc/supervisord.conf
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini

# 複製程式碼 (排除 uploads，因為它在庫外)
# 注意：這裡會複製 wp-content/themes 和 plugins
WORKDIR /var/www/html
COPY src/ .

# 修正權限 (確保 Web Server 能讀寫)
RUN chown -R www-data:www-data /var/www/html

# 啟動 Supervisor (同時管理 Nginx 和 PHP)
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]