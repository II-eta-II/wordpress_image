FROM wordpress:6.4-php8.2-fpm

# 安裝 Nginx、Supervisor 與 envsubst (gettext)
RUN apt-get update && apt-get install -y nginx supervisor gettext-base && rm -rf /var/lib/apt/lists/*

# 複製設定檔
COPY nginx.conf.template /etc/nginx/nginx.conf.template
RUN rm -f /etc/nginx/sites-enabled/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# 設定 PHPFPM_HOST 預設值
ENV PHPFPM_HOST=127.0.0.1

# 設定目錄權限
WORKDIR /var/www/html
COPY wp-content /var/www/html/wp-content
RUN chown -R www-data:www-data /var/www/html && \
    chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 80
ENTRYPOINT []
CMD ["/bin/sh", "-c", "/usr/local/bin/docker-entrypoint.sh php-fpm --version && /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf"]
