FROM alpine:latest
MAINTAINER Ben Wilber "https://github.com/benwilber"

EXPOSE 80 443
CMD ["nginx", "-g", "daemon off;"]
VOLUME ["/var/cache/nginx/www/live"]

ENV NGINX_VERSION 1.11.5
ENV NGINX_RTMP_VERSION 1.1.10

ENV NGINX_URL "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz"
ENV NGINX_RTMP_URL "https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz"

ENV BUILD_PACKAGES "build-base linux-headers openssl-dev pcre-dev wget zlib-dev"
ENV RUNTIME_PACKAGES "ca-certificates openssl pcre zlib"

RUN apk --update add ${BUILD_PACKAGES} ${RUNTIME_PACKAGES}
RUN wget -qO- ${NGINX_URL} | tar zx -C /tmp
RUN wget -qO- ${NGINX_RTMP_URL} | tar zx -C /tmp
RUN cd /tmp/nginx-${NGINX_VERSION} && \
    ./configure \
    --prefix=/etc/nginx \
    --sbin-path=/usr/sbin/nginx \
    --conf-path=/etc/nginx/nginx.conf \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --lock-path=/var/run/nginx.lock \
    --http-client-body-temp-path=/var/cache/nginx/client_temp \
    --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
    --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
    --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
    --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
    --user=nginx \
    --group=nginx \
    --with-http_ssl_module \
    --with-http_realip_module \
    --with-http_addition_module \
    --with-http_sub_module \
    --with-http_dav_module \
    --with-http_flv_module \
    --with-http_mp4_module \
    --with-http_gunzip_module \
    --with-http_gzip_static_module \
    --with-http_random_index_module \
    --with-http_secure_link_module \
    --with-http_stub_status_module \
    --with-http_auth_request_module \
    --with-threads \
    --with-stream \
    --with-stream_ssl_module \
    --with-http_slice_module \
    --with-file-aio \
    --with-http_v2_module \
    --add-module=../nginx-rtmp-module-${NGINX_RTMP_VERSION}

RUN cd /tmp/nginx-${NGINX_VERSION} && make && make install
RUN adduser -D nginx
RUN rm -rf /tmp/*
RUN apk del ${build_pkgs}
RUN rm -rf /var/cache/apk/*

COPY conf/nginx.conf /etc/nginx/nginx.conf