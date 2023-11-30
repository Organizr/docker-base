ARG BASE_IMAGE
FROM ${BASE_IMAGE:-library/alpine:3.16}

ENV S6_REL=2.2.0.3 S6_ARCH=armhf S6_BEHAVIOUR_IF_STAGE2_FAILS=2 TZ=Etc/UTC

LABEL base.maintainer="christronyxyocum,Roxedus"
LABEL base.s6.rel=${S6_REL} base.s6.arch=${S6_ARCH}

LABEL org.label-schema.name="organizr/base" \
  org.label-schema.description="Baseimage for Organizr" \
  org.label-schema.url="https://organizr.app/" \
  org.label-schema.vcs-url="https://github.com/organizr/docker-base" \
  org.label-schema.schema-version="1.0"

# environment variables
ENV PS1="$(whoami)@$(hostname):$(pwd)$ " \
  HOME="/root" \
  TERM="xterm"

RUN \
  apk update && \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    tar && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    apache2-utils \
    bash \
    ca-certificates \
    coreutils \
    curl \
    git \
    libressl3.7-libssl \
    logrotate \
    nano \
    nginx \
    openssl \
    php81 \
    php81-curl \
    php81-fileinfo \
    php81-fpm \
    php81-ftp \
    php81-ldap \
    php81-mbstring \
    php81-mysqli \
    php81-openssl \
    php81-pdo_sqlite \
    php81-session \
    php81-simplexml \
    php81-sqlite3 \
    php81-tokenizer \
    php81-xmlwriter \
    php81-xml \
    php81-zip \
    shadow \
    zlib \
    tzdata && \
  apk add --no-cache  --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing \
    php81-pecl-xmlrpc && \
  echo "**** add s6 overlay ****" && \
  curl -o /tmp/s6-overlay.tar.gz -L \
    "https://github.com/just-containers/s6-overlay/releases/download/v${S6_REL}/s6-overlay-${S6_ARCH}.tar.gz" && \
  tar xfz /tmp/s6-overlay.tar.gz -C / && \
  echo "**** create abc user and make folders ****" && \
  groupmod -g 1000 users && \
  useradd -u 911 -U -d /config -s /bin/false abc && \
  usermod -G users abc && \
  mkdir -p \
    /config \
    /defaults && \
  echo "**** configure nginx ****" && \
  echo 'fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;' >> \
  /etc/nginx/fastcgi_params && \
    rm -f /etc/nginx/conf.d/default.conf && \
  echo "**** fix logrotate ****" && \
  sed -i "s#/var/log/messages {}.*# #g" /etc/logrotate.conf && \
  sed -i 's#/usr/sbin/logrotate /etc/logrotate.conf#/usr/sbin/logrotate /etc/logrotate.conf -s /config/log/logrotate.status#g' /etc/periodic/daily/logrotate && \
  echo "**** enable PHP-FPM ****" && \
  sed -i "s#listen = 127.0.0.1:9000#listen = '/var/run/php8-fpm.sock'#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#;listen.owner = nobody#listen.owner = abc#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#;listen.group = abc#listen.group = abc#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#;listen.mode = nobody#listen.mode = 0660#g" /etc/php81/php-fpm.d/www.conf && \
  echo "**** set our recommended defaults ****" && \
  sed -i "s#pm = dynamic#pm = ondemand#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#pm.max_children = 5#pm.max_children = 4000#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#pm.start_servers = 2#;pm.start_servers = 2#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#;pm.process_idle_timeout = 10s;#pm.process_idle_timeout = 10s;#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#;pm.max_requests = 500#pm.max_requests = 0#g" /etc/php81/php-fpm.d/www.conf && \
  sed -i "s#zlib.output_compression = Off#zlib.output_compression = On#g" /etc/php81/php.ini && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /var/cache/apk/* \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 80 443
VOLUME /config

HEALTHCHECK --start-period=60s CMD curl -ILfSs http://localhost:8080/nginx_status > /dev/null && curl -ILfkSs http://localhost:8080/php_status > /dev/null || exit 1

ENTRYPOINT ["/init"]
