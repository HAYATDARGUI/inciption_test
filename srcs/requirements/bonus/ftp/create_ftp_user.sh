#!/bin/sh
set -e

FTP_USER=${FTP_USER:-ftpuser}

if [ -f "/run/secrets/ftp_password" ]; then
    FTP_PASS=$(tr -d '\r\n' < /run/secrets/ftp_password)
else
    FTP_PASS="ftp_user_password_2026"
fi

mkdir -p /var/run/vsftpd/empty
mkdir -p /etc/vsftpd

mkdir -p /etc/pam.d
echo "auth required pam_unix.so" > /etc/pam.d/vsftpd
echo "account required pam_unix.so" >> /etc/pam.d/vsftpd

if ! grep -q "^/bin/false$" /etc/shells; then
    echo "/bin/false" >> /etc/shells
fi

if ! id "$FTP_USER" >/dev/null 2>&1; then
    useradd -m -s /bin/false "$FTP_USER"
fi

echo "$FTP_USER:$FTP_PASS" | chpasswd

chown root:root /home/$FTP_USER
chmod 555 /home/$FTP_USER

mkdir -p /home/$FTP_USER/ftp
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER/ftp
chmod 755 /home/$FTP_USER/ftp

exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf