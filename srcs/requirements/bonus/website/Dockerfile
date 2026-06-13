FROM debian:bullseye

# 1. Update package lists o install-iy nginx server standard core package
RUN apt-get update && apt-get install -y \
    nginx \
    && rm -rf /var/lib/apt/lists/*

# 2. Copiy l-files d l-html d l-portfolio/resume dyalk inside standard web path
COPY ./html /var/www/html

# 3. Config default d nginx bash y-khdem standard lightweight server properties
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 80

# 4. Start-iy daemon in foreground directly smoothly (PID 1)
CMD ["nginx", "-g", "daemon off;"]