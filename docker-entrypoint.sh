#!/bin/sh
# 啟動 PHP-FPM 並放在背景執行
php-fpm -D

# 啟動 Nginx 並放在前景執行（這會保持容器運作）
nginx -g "daemon off;"
