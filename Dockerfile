# first step
FROM debian:bookworm

## create builder user
RUN groupadd --gid 2001 builder \
 && useradd --uid 2001 --gid 2001 builder

## install revision control system
RUN apt-get update \
 && apt-get install --yes git mercurial

## create sources directory
RUN install --directory --mode 0755 --owner builder --group builder /opt/sources

## switch to user builder
USER builder

## change working directory
WORKDIR /opt/sources

## download source code
RUN git clone --depth 1 --branch branches/stable-1.24 https://github.com/nginx/nginx.git
RUN git clone --depth 1 --branch master               https://github.com/openresty/headers-more-nginx-module.git
RUN git clone --depth 1 --branch master               https://github.com/google/ngx_brotli.git
RUN git clone --depth 1 --branch master               https://github.com/arut/nginx-rtmp-module.git
RUN git clone --depth 1 --branch master               https://github.com/leev/ngx_http_geoip2_module.git
RUN hg clone http://hg.nginx.org/njs

# second step
FROM debian:bookworm

## install development utilities and application dependencies
RUN apt-get update \
 && apt-get install --yes build-essential libpcre3-dev libssl-dev zlib1g-dev libgd-dev libgeoip-dev libmaxminddb-dev \
 && apt-get install --yes libedit-dev libxml2-dev libxslt-dev

## create builder user
RUN groupadd --gid 2001 builder \
 && useradd --uid 2001 --gid 2001 builder

## copy source code
COPY --from=0 /opt/sources /opt/sources

## create compiled directory
RUN install --directory --mode 0755 --owner builder --group builder /opt/compiled

## switch to user builder
USER builder

## change working directory
WORKDIR /opt/sources/nginx/

## copy configure script
RUN cp auto/configure .

## configure application
RUN ./configure \
                --with-cc-opt="-O2 -pipe -fstack-protector-strong --param=ssp-buffer-size=4 -fPIC" \
                --with-ld-opt="-Wl,-z,relro -Wl,-z,now --pie" \
                \
                --prefix=/etc/nginx \
                --sbin-path=/usr/sbin/nginx \
                --modules-path=/usr/lib64/nginx/modules \
                --conf-path=/etc/nginx/nginx.conf \
                \
                --error-log-path=/dev/stderr \
                --http-log-path=/dev/stdout \
                \
                --pid-path=/var/run/nginx/nginx.pid \
                --lock-path=/var/run/nginx/nginx.lock \
                \
                --http-client-body-temp-path=/var/cache/nginx/client_temp \
                --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
                --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
                --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
                --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
                \
                --user=nginx \
                --group=nginx \
                \
                --with-file-aio \
                --with-threads \
		--with-compat \
                \
                --with-http_ssl_module \
                --with-http_v2_module \
                --with-http_realip_module \
                --with-http_dav_module \
		--with-http_geoip_module=dynamic \
		--with-http_gunzip_module \
		--with-http_gzip_static_module \
		--with-http_image_filter_module=dynamic \
		--with-http_secure_link_module \
		--with-http_slice_module \
		--with-http_stub_status_module \
		--with-http_sub_module \
		\
		--with-http_addition_module \
	        --with-http_flv_module \
    		--with-http_mp4_module \
	        --with-http_auth_request_module \
    		--with-http_random_index_module \
		--with-http_degradation_module \
		\
		--with-mail=dynamic \
		--with-mail_ssl_module \
		\
		--with-stream=dynamic \
		--with-stream_geoip_module \
		--with-stream_realip_module \
		--with-stream_ssl_module \
		--with-stream_ssl_preread_module \
                \
                --add-dynamic-module=../headers-more-nginx-module \
		--add-dynamic-module=../ngx_brotli \
		--add-dynamic-module=../nginx-rtmp-module \
		--add-dynamic-module=../ngx_http_geoip2_module \
		--add-dynamic-module=../njs/nginx


## compile application
RUN make

## install application to temporary directory
RUN make install DESTDIR=/opt/compiled



# third step
FROM debian:bookworm

## create nginx user
RUN groupadd --gid 2001 nginx \
 && useradd --uid 2001 --gid 2001 --no-create-home --home-dir /etc/nginx/html nginx

## copy compiled application
COPY --from=1 --chown=root:root   /opt/compiled/usr /usr
COPY --from=1 --chown=nginx:nginx /opt/compiled/etc /etc

## create temp directories
RUN install --directory --mode 0750 --owner nginx --group nginx /var/cache/nginx/client_temp  \
 && install --directory --mode 0750 --owner nginx --group nginx /var/cache/nginx/proxy_temp   \
 && install --directory --mode 0750 --owner nginx --group nginx /var/cache/nginx/fastcgi_temp \
 && install --directory --mode 0750 --owner nginx --group nginx /var/cache/nginx/uwsgi_temp   \
 && install --directory --mode 0750 --owner nginx --group nginx /var/cache/nginx/scgi_temp

## create run-time directory
RUN install --directory --mode 0750 --owner nginx --group nginx /run/nginx

## install utility to set file capabilities
RUN apt-get update && apt-get install --yes libcap2-bin libpcre3 libssl3 libgd3 libgeoip1 libmaxminddb0 libxml2

## devel
RUN apt-get install --yes procps net-tools mc

RUN apt-get remove -y build-essential libpcre3-dev libssl-dev zlib1g-dev libgd-dev libgeoip-dev libmaxminddb-dev
RUN apt-get remove -y libedit-dev libxml2-dev libxslt-dev git mercurial
RUN apt-get -y autoremove
RUN apt-get -y purge
RUN rm -rf /var/lib/apt/lists/*
RUN rm -rf /tmp/*
RUN rm -rf /var/tmp/*

## allow to bind on port numbers less than 1024
#RUN setcap cap_net_bind_service=+ep /usr/sbin/nginx

## change working directory
WORKDIR /etc/nginx/html

STOPSIGNAL SIGQUIT

## switch to nginx user
#USER nginx 

CMD ["nginx", "-g", "daemon off;"]
