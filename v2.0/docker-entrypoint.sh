#!/bin/sh
set -e

# Environment variables that are used if not empty:
#   SERVER_NAMES
#   LOCATION
#   AUTH_TYPE
#   REALM
#   USERNAME
#   PASSWORD
#   SSL_CERT

# Add password hash, unless "user.passwd" already exists (ie, bind mounted).
if [ ! -e "/user.passwd" ]; then
    touch "/user.passwd"
    # Only generate a password hash if both username and password given.
    if [ "x$USERNAME" != "x" ] && [ "x$PASSWORD" != "x" ]; then
        if [ "$AUTH_TYPE" = "Digest" ]; then
            # Can't run `htdigest` non-interactively, so use other tools.
            HASH="`printf '%s' "$USERNAME:$REALM:$PASSWORD" | md5sum | awk '{print $1}'`"
            printf '%s\n' "$USERNAME:$REALM:$HASH" > /user.passwd
        else
            htpasswd -B -b -c "/user.passwd" $USERNAME $PASSWORD
            chown www-data /user.passwd
            chmod 640 /user.passwd
        fi
    fi
fi

# If specified, generate a selfsigned certificate.
if [ "${SSL_CERT:-none}" = "selfsigned" ]; then
    # Generate self-signed SSL certificate.
    # If SERVER_NAMES is given, use the first domain as the Common Name.
    if [ ! -e /certs/web.key ] && [ ! -e /certs/web.crt ]; then
       openssl req -x509 -newkey rsa:2048 -days 3500 -nodes -keyout /certs/web.key -out /certs/web.crt -subj "/CN=${SERVER_NAME:-selfsigned}"
    fi
fi

# Create directories for Dav data and lock database.
[ ! -d "/dav/data" ] && mkdir -p "/dav/data"
[ ! -e "/dav/DavLock" ] && touch "/dav/DavLock"
chown -R www-data:www-data "/dav"

exec "$@"
