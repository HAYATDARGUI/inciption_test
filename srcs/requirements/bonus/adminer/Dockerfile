# 1. Kat-bda mn l-OS base image ghir hiya bohdha
FROM debian:bullseye

# 2. Kat-installer PHP w l-extensions li khadamin l Adminer
RUN apt-get update && apt-get install -y \
    php \
    php-mysqli \
    wget \
    && rm -rf /var/lib/apt/lists/*

# 3. Kat-telecharger l-fichier .php dyal Adminer b yeddik
RUN wget "https://www.adminer.org/latest.php" -O /var/www/html/index.php

# 4. Kat-lanchi l-built-in PHP server f l-port li bghiti
EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]