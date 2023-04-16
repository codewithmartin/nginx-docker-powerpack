# NGINX Docker PowerPack

This repo contains a Dockerfiles to create an NGINX Docker image that runs NGINX with many usefull plugins. 
This repo also contains docker compose yaml file and default folders with configuration files and initial index.html file. 

Notable differences with respect to the official NGINX Docker image include:

* This NGINX, when running with `docker run`, not exposed any port. It's usefull for running image for testing without port conflict. The port can be open in `docker run` command or in `nginx.yml` file.
* This NGINX is build with many `official` and `3rd party` plugins. Many plugins are build as 'dynamic', so you can just not load them if you no not need.
* The internal config directory `/etc/nginx` is remaped to `./conf` in `nginx.yml`. Yo can change it as needed.
* The internal document root is remaped to `./html` in `nginx.yml`. Yo can change it as needed.
* This NGINX is build on top of Debian 12 (Bookworm). Bookworm will be official stable repo soon, so I don't see the value of using old distro.

## Builds / Releases
New images are built and pushed as needed. 
**Note:** For backward compatibily between releases, read CHANGELOG!

## TODO
* Included config files are original Nginx default - need to customize.
* No modules confings are provided in actual version.
* conf/conf.d is not included from main config.
* Typos in this document are expected :)

## Included plugins
* ngx_http_ssl_module - static - <http://nginx.org/en/docs/http/ngx_http_ssl_module.html>
* ngx_http_v2_module - static - <http://nginx.org/en/docs/http/ngx_http_v2_module.html>
* ngx_http_realip_module - static - <http://nginx.org/en/docs/http/ngx_http_realip_module.html>
* ngx_http_dav_module - static - <http://nginx.org/en/docs/http/ngx_http_dav_module.html>
* ngx_http_geoip_module - dynamic - <http://nginx.org/en/docs/http/ngx_http_geoip_module.html>
* ngx_http_gzip_module - static - <http://nginx.org/en/docs/http/ngx_http_gzip_module.html>
* ngx_http_gunzip_module - static - <http://nginx.org/en/docs/http/ngx_http_gunzip_module.html>
* ngx_http_image_filter_module - dynamic - <http://nginx.org/en/docs/http/ngx_http_image_filter_module.html>
* ngx_http_secure_link_module - static - <http://nginx.org/en/docs/http/ngx_http_secure_link_module.html>
* ngx_http_slice_module - static - <http://nginx.org/en/docs/http/ngx_http_slice_module.html>
* ngx_http_stub_status_module - static - <http://nginx.org/en/docs/http/ngx_http_stub_status_module.html>
* ngx_http_sub_module - static - <http://nginx.org/en/docs/http/ngx_http_sub_module.html>
* ngx_http_addition_module - static - <http://nginx.org/en/docs/http/ngx_http_addition_module.html>
* ngx_http_flv_module - static - <http://nginx.org/en/docs/http/ngx_http_flv_module.html>
* ngx_http_mp4_module - static - <http://nginx.org/en/docs/http/ngx_http_mp4_module.html>
* ngx_http_auth_request_module - static - <http://nginx.org/en/docs/http/ngx_http_auth_request_module.html>
* ngx_http_random_index_module - static - <http://nginx.org/en/docs/http/ngx_http_random_index_module.html>
* ngx_http_degradation_module - static - undocumented, but interesting :)

## Mail plugins
* ngx_mail - dynamic - all modules
  <http://nginx.org/en/docs/mail/ngx_mail_core_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_auth_http_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_proxy_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_realip_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_ssl_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_imap_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_pop3_module.html>
  <http://nginx.org/en/docs/mail/ngx_mail_smtp_module.html>

## Stream plugins
* ngx_stream - dynamic - all (non Plus) modules
  <http://nginx.org/en/docs/>

## 3rd partt included plugins
* headers-more-nginx-module - dynamic - <https://www.nginx.com/resources/wiki/modules/headers_more/>
* ngx_brotli - dynamic - <https://github.com/google/ngx_brotli>
* nginx-rtmp-module - dynamic - <https://github.com/arut/nginx-rtmp-module>
* ngx_http_geoip2_module - dynamic - <https://github.com/leev/ngx_http_geoip2_module>
* nginx-module-njs - dynamic - <http://hg.nginx.org/njs>


## Supported Image Registries and Platforms

### Image Registries

You can find built images in the following registries:

* Docker Hub - <https://hub.docker.com/repository/docker/martinkuchar/nginx-docker-powerpack>

### Platforms

Images are built for the `amd64` (Debian, later also Alpine) architecture.

## Issues

* This is `work in progress`
