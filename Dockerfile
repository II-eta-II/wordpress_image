FROM wordpress:6.4-php8.2-fpm

# 安裝 Nginx 與 Supervisor
RUN apt-get update && apt-get install -y nginx supervisor && rm -rf /var/lib/apt/lists/*

# 複製設定檔
COPY nginx.conf /etc/nginx/nginx.conf
RUN rm -f /etc/nginx/sites-enabled/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 設定目錄權限（確保掛載後的檔案 PHP 讀得到）

WORKDIR /var/www/html
COPY wp-content /var/www/html/wp-content
RUN chown -R www-data:www-data /var/www/html && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT []
CMD ["/bin/sh", "-c", "/usr/local/bin/docker-entrypoint.sh php-fpm --version && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
