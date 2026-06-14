FROM alpine:3.18

RUN apk add --no-cache vsftpd openssl shadow busybox-extras

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY create_ftp_user.sh /usr/local/bin/create_ftp_user.sh
RUN chmod +x /usr/local/bin/create_ftp_user.sh

EXPOSE 20 21 21100-21110

VOLUME ["/home/ftpuser"]

CMD ["/usr/local/bin/create_ftp_user.sh"]
