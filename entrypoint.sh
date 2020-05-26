#!/bin/bash

# terminate on errors
set -e

mv /var/www/wordpress/wp-content /var/www/wp-content
rm -rf /var/www/wordpress

# Check if volume is empty
if [ ! -f /var/www/html/wp-secrets.php ]; then
    cat <<<"Setting up wp-secrets."
    echo "<?php\n" > /var/www/html/wp-secrets.php
    # Generate secrets
    curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-secrets.php
fi

if [ ! "$(ls -A "/var/www/html/wp-content" 2>/dev/null)" ]; then
    cat <<<"Setting up wp-content volume."
    # copy wp-content from Wordpress source to volume
    rsync -a /var/www/wp-content/ /var/www/html/wp-content/
fi

if [ "$LIVE" != "true" ]; then
    chown -R nobody:nobody /var/www/html/wp-content
fi

exec "$@"