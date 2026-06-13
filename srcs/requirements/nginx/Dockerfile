FROM debian:bullseye

RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    procps \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=Tetuan/L=Martil/O=42Network/OU=hdargui/CN=hdargui.42.fr"


RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/nginx/sites-available/default


COPY conf/nginx.conf /etc/nginx/sites-available/default


RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]