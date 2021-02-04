FROM alpine:3.12
LABEL Maintainer="Dipak Parmar <hi@dipak.tech>" \
      Description="Lightweight WordPress container with Nginx 1.14 & PHP-FPM 7.2 based on Alpine Linux."

# Install packages from testing repo's
RUN apk --no-cache add php7 php7-fpm php7-mysqli php7-json php7-openssl php7-calendar \
    php7-curl php7-zlib php7-xml php7-phar php7-intl php7-dom php7-xmlreader \
    php7-xmlwriter php7-simplexml php7-ctype php7-mbstring php7-gd php7-session \
    php7-bcmath php7-ftp php7-fileinfo php7-gd php7-json php7-iconv php7-mcrypt php7-opcache \
    php7-redis php7-soap php7-tokenizer php7-zip nginx supervisor curl bash less rsync nano git

# Configure nginx
COPY config/nginx3.conf /etc/nginx/nginx.conf
#COPY config/php-fpm.conf /etc/nginx/php-fpm.conf

# Configure PHP-FPM
COPY config/fpm-pool.conf /etc/php7/php-fpm.d/zzz_custom.conf
COPY config/php.ini /etc/php7/conf.d/zzz_custom.ini

# Configure supervisord
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# WordPress
ENV WORDPRESS_VERSION 5.5.3
ENV WORDPRESS_SHA1 9d3319790c73c4b22077e7ecd604ce66

# wp-content volume
VOLUME /var/www/html/wp-content
WORKDIR /var/www/html/wp-content

# Upstream tarballs include ./wordpress/ so this gives us /usr/src/wordpress
RUN curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /var/www/ \
	&& rm wordpress.tar.gz \
	&& rsync -a /var/www/wordpress/* /var/www/html/ \
	&& rm -rf /var/www/html/wp-content/* \
	&& chown -R nobody:nobody /var/www/html

# Add WP CLI
RUN curl -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# WP config
COPY wp-config.php /var/www/html
RUN chown nobody:nobody /var/www/html/wp-config.php && chmod 640 /var/www/html/wp-config.php

# Append WP secrets
COPY wp-secrets.php /var/www/html
RUN chown nobody:nobody /var/www/html/wp-secrets.php && chmod 640 /var/www/html/wp-secrets.php

COPY config/default.conf /etc/nginx/conf.d/default.conf
COPY config/wordpress.conf /etc/nginx/global/wordpress.conf
COPY config/restrictions.conf /etc/nginx/global/restrictions.conf
COPY config/proxy.conf /etc/nginx/global/proxy.conf

# Entrypoint to copy wp-content
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
