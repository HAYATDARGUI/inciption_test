#!/bin/sh
set -e

# Simple entrypoint: create ftp user if it doesn't exist, set password from FTP_PASSWORD env,
# and run vsftpd with the provided config.

FTP_USER=${FTP_USER:-ftpuser}
FTP_PASS=${FTP_PASS:-ftppass}

# Create user if needed
if ! id "$FTP_USER" >/dev/null 2>&1; then
  adduser -D -h /home/$FTP_USER -s /bin/false $FTP_USER || exit 1
fi

# Set password
echo "$FTP_USER:$FTP_PASS" | chpasswd

# Ensure proper ownership
mkdir -p /home/$FTP_USER
chown -R $FTP_USER:$FTP_USER /home/$FTP_USER

# Start vsftpd in foreground
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf
