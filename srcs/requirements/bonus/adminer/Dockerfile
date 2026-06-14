FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    php \
    php-mysqli \
    wget \
    && rm -rf /var/lib/apt/lists/*

RUN wget "https://www.adminer.org/latest.php" -O /var/www/html/index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]