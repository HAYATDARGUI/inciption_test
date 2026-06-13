FROM debian:bullseye

# 1. Update package lists o install-iy Redis server standard tools
RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

# 2. Config d l-Mastro: Force-iy Redis y-b9a khddam f l-foreground (PID 1) 
# o y-tsme3 l ga3 l-networks interfaces (machi ghir localhost)
RUN sed -i "s/bind 127.0.0.1/bind 0.0.0.0/g" /etc/redis/redis.conf \
    && sed -i "s/protected-mode yes/protected-mode no/g" /etc/redis/redis.conf

EXPOSE 6379

# 3. Start-iy daemon in foreground kima requested f instructions subject metrics
CMD ["redis-server", "/etc/redis/redis.conf", "--daemonize", "no"]