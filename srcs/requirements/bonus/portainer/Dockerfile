FROM debian:bullseye

RUN apt-get update && apt-get install -y wget tar && \
    wget https://github.com/portainer/portainer/releases/download/2.19.4/portainer-2.19.4-linux-amd64.tar.gz && \
    tar -xvzf portainer-2.19.4-linux-amd64.tar.gz && \
    rm -rf portainer-2.19.4-linux-amd64.tar.gz

WORKDIR /portainer
EXPOSE 9443

ENTRYPOINT ["./portainer"]
