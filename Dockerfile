#
# Select Base Image ...
FROM php:7.3-apache-buster

#
# Update Repositoryes ...
RUN apt-get update

#
# Install Requirements ...
RUN apt-get install -y --no-install-recommends \
    git \
    mercurial \
    subversion \
    ca-certificates \
    python3-pkg-resources \
    python3-pygments \
    imagemagick \
    openssh-client \
    procps \
    #
    # My Favorites ...
    mc \
    nano \
    telnet \
    iputils-ping;

#
# Install Reuired PHP Extensions ...
RUN set -ex; \
    \
    if command -v a2enmod; then \
    a2enmod rewrite; \
    fi; \
    \
    savedAptMark="$(apt-mark showmanual)"; \
    \
    apt-get update; \
    apt-get install -y --no-install-recommends \
    libcurl4-gnutls-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libzip-dev \
    ; \
    \
    docker-php-ext-configure gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-freetype-dir=/usr \
    ; \
    \
    docker-php-ext-install -j "$(nproc)" \
    gd \
    opcache \
    mbstring \
    iconv \
    mysqli \
    curl \
    pcntl \
    zip \
    ; \
    \
    # reset apt-mark's "manual" list so that "purge --auto-remove" will remove all build dependencies
    apt-mark auto '.*' > /dev/null; \
    apt-mark manual $savedAptMark; \
    ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
    | awk '/=>/ { print $3 }' \
    | sort -u \
    | xargs -r dpkg-query -S \
    | cut -d: -f1 \
    | sort -u \
    | xargs -rt apt-mark manual; \
    \
    apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false;

#
# Configuring PHP Extensions ...
RUN pecl channel-update pecl.php.net \
    && pecl install apcu \
    && docker-php-ext-enable apcu
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=60'; \
    echo 'opcache.fast_shutdown=1'; \
    # From Phabricator
    echo 'opcache.validate_timestamps=0'; \
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini
RUN { \
    echo 'date.timezone="UTC"'; \
    } > /usr/local/etc/php/conf.d/timezone.ini
RUN { \
    echo 'post_max_size=32M'; \
    echo 'upload_max_filesize=32M'; \
    } > /usr/local/etc/php/conf.d/uploads.ini

#
# Configure Apache2 Global Server Name ...
WORKDIR /etc/apache2/
RUN rm apache2.conf
COPY ./apache2.conf .

#
# Configuring Apache WebServer ...
ENV APACHE_DOCUMENT_ROOT /var/www/phabricator/webroot
RUN { \
    echo '<VirtualHost *:80>'; \
    echo '  DocumentRoot ${APACHE_DOCUMENT_ROOT}'; \
    echo '  RewriteEngine on'; \
    echo '  RewriteRule ^(.*)$ /index.php?__path__=$1 [B,L,QSA]'; \
    echo '</VirtualHost>'; \
    } > /etc/apache2/sites-available/000-default.conf

#
# Cloning ...
WORKDIR /var/www
RUN rm -rf html
RUN git clone https://github.com/phacility/arcanist.git
RUN git clone https://github.com/phacility/phabricator.git

#
# Set Environment PATH Variable ...
ENV PATH "$PATH:/usr/lib/git-core:/var/www/phabricator/bin"

#
# Create Repo Folder ...
RUN mkdir /var/repo && chown www-data:www-data /var/repo

#
# Create File Storage Folder ...
RUN mkdir /var/files && chown www-data:www-data /var/files

#
# Volumes ...
VOLUME [ "/var/repo", "/var/files" ]

#
# Available Git Backend ...
RUN ln -s /usr/lib/git-core/git-http-backend /usr/bin/git-http-backend

#
# Installing Sudo ...
RUN apt install -y sudo 

#
# Configuring Phabricator DB Connection ...
ARG DB_HOST=""
ENV DB_HOST="${DB_HOST}"
ARG DB_PORT=""
ENV DB_PORT="${DB_PORT}"
ARG DB_USER=""
ENV DB_USER="${DB_USER}"
ARG DB_PASS=""
ENV DB_PASS="${DB_PASS}"

#
# Base URI ...
ARG BASE_URI=""
ENV BASE_URI="${BASE_URI}"

#
# add Startup File ...
WORKDIR /usr/local/bin
COPY startup.sh .
RUN chmod +x startup.sh

#
# Change Working Directory ...
WORKDIR /var/www/phabricator

#
# Startup ...
CMD ["startup.sh"]
