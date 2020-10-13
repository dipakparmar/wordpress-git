
# Production - WordPress Docker Container

Lightweight WordPress container with Nginx 1.16.1 & PHP-FPM 7.3.18 based on Alpine Linux.

WordPress version currently installed: _**5.5.1**_

* Used in production for my own sites, making it stable, tested and up-to-date
* Optimized for 100 concurrent users
* Optimized to only use resources when there's traffic (by using PHP-FPM's ondemand PM)
* Best to be used with Amazon Cloudfront as SSL terminator and CDN
* Built on the lightweight Alpine Linux distribution
* Uses PHP 7.2 for better performance, lower cpu usage & memory footprint
* Can safely be updated without losing data
* Fully configurable because wp-config.php uses the environment variables you can pass as a argument to the container

[![Docker Pulls](https://img.shields.io/docker/pulls/dipakparmar/wordpress-git.svg)](https://hub.docker.com/r/dipakparmar/wordpress-git)
[![Docker image layers](https://images.microbadger.com/badges/image/dipakparmar/wordpress-git.svg)](https://microbadger.com/images/dipakparmar/wordpress-git)
![nginx 1.16.1](https://img.shields.io/badge/nginx-1.16-brightgreen.svg)
![php 7.3](https://img.shields.io/badge/php-7.3-brightgreen.svg)
![License MIT](https://img.shields.io/badge/license-MIT-blue.svg)


## Usage
See [docker-compose.yml](https://github.com/dipakparmar/wordpress-git/blob/master/docker-compose.yml) how to use it in your own environment.

    docker-compose up

Or

    docker run -d -p 80:80 -v <volumename>:/var/www/html/wp-content \
    -e "DB_HOST=db" \
    -e "DB_NAME=wordpress" \
    -e "DB_USER=wp" \
    -e "DB_PASSWORD=secret" \
    -e "TABLE_PREFIX=only_if_not_wp_" \
    -e "FS_METHOD=direct" \
    atws/docker-wordpress:latest

### WP-CLI

This image includes [wp-cli](https://wp-cli.org/) which can be used like this:

    docker exec <your container name> /usr/local/bin/wp --path=/var/www/html <your command>


## Inspired by

* https://hub.docker.com/_/wordpress/
* https://codeable.io/wordpress-developers-intro-to-docker-part-two/
* https://github.com/TrafeX/docker-php-nginx/
* https://github.com/etopian/alpine-php-wordpress/
* https://github.com/Trafex/docker-wordpress/
* https://github.com/raulr/nginx-wordpress-docker/
