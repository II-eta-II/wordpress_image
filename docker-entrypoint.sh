#!/bin/sh

# 等待 wp-config.php 存在（如果是首次安裝）
# WordPress 會在首次訪問時自動建立

# 如果 wp-config.php 存在且設定了 SITE_URL，則添加動態 URL 設定
if [ -f /var/www/html/wp-config.php ] && [ -n "$SITE_URL" ]; then
    # 檢查是否已經添加過動態 URL 設定
    if ! grep -q "WP_HOME" /var/www/html/wp-config.php; then
        # 在 wp-config.php 開頭添加動態 URL 設定
        sed -i "/<?php/a\\
/** 動態設定網站 URL - 解決 ALB 後的重定向問題 */\\
if (isset(\\\$_SERVER['HTTP_X_FORWARDED_PROTO']) \&\& \\\$_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https') {\\
    \\\$_SERVER['HTTPS'] = 'on';\\
}\\
if (isset(\\\$_SERVER['HTTP_HOST'])) {\\
    \\\$protocol = (isset(\\\$_SERVER['HTTPS']) \&\& \\\$_SERVER['HTTPS'] === 'on') ? 'https://' : 'http://';\\
    define('WP_HOME', \\\$protocol . \\\$_SERVER['HTTP_HOST']);\\
    define('WP_SITEURL', \\\$protocol . \\\$_SERVER['HTTP_HOST']);\\
}
" /var/www/html/wp-config.php
        echo "WordPress URL 設定已更新"
    fi
fi

# 啟動 PHP-FPM 並放在背景執行
php-fpm -D

# 啟動 Nginx 並放在前景執行（這會保持容器運作）
nginx -g "daemon off;"
