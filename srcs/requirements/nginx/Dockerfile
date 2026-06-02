FROM debian:bullseye

RUN apt-get update && apt-get install -y nginx openssl

# 9ad SSL
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=MA/ST=Tetuan/L=Martil/O=42Network/OU=hdargui/CN=hdargui.42.fr"

# --- HAD L-PARTS DAROURIYYIN ---
# 1. Msa7 l-config d l-default li fiha port 80
RUN rm -f /etc/nginx/sites-enabled/default
RUN rm -f /etc/nginx/sites-available/default

# 2. Copier l-config dyalk l sites-available
COPY conf/nginx.conf /etc/nginx/sites-available/default

# 3. Dir liha link l sites-enabled bach t-koun active
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]