#!/bin/bash
set -e

if [ ! -e '/var/www/html/piwik.php' ]; then
        echo >&2 "Piwik not found in $(pwd) - copying now..."
        		if [ "$(ls -A)" ]; then
			         echo >&2 "WARNING: $(pwd) is not empty - press Ctrl+C now if this is an error!"
			     ( set -x; ls -A; sleep 10 )
                fi
	tar cf - --one-file-system -C /usr/src/piwik . | tar xf -
	chown -R www-data /var/www/html
    echo >&2 "Complete! Piwik has been successfully copied to $(pwd)"
fi

chfn -f 'Piwik Admin' www-data

cat > /etc/ssmtp/ssmtp.conf << EOF
UseTLS=Yes
UseSTARTTLS=Yes
root=${MAIL_USER}
mailhub=${MAIL_HOST}:${MAIL_PORT}
hostname=${MAIL_USER}
AuthUser=${MAIL_USER}
AuthPass=${MAIL_PASS}
EOF

echo "www-data:${MAIL_USER}:${MAIL_HOST}:${MAIL_PORT}" >> /etc/ssmtp/revaliases

exec "$@"
