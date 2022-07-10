This is the docker project to setup reloadable nginx based on content change and pre-defined nginx.conf.

Feature
----
This nginx docker repo can build nginx with dynamic module supports. It is based on extended build capacity from [Nginx Official Module Support](https://github.com/nginxinc/docker-nginx/tree/master/modules), and include [module authldap](https://github.com/kvspb/nginx-auth-ldap).

It also provides additional nginx docker startup functions:
- Auto load module from environment varibles
- Support legacy configuration from this repo
- Nginx error log level configuration
- Nginx configuration auto reloadable

Usage
----
Use following command to setup nginx docker.
```shell
$ docker run -d --name nginx -p 80:80 -v /path/to/nginx-conf.d:/etc/nginx/conf.d fengzhou/nginx
```

### Auto Watch (`NGINX_WATCH_INTERVAL`)
The default image has nginx configuration (/etc/nginx/conf.d) reloadable per 10 seconds.
- To disable auto watch function, use environment variable `NGINX_WATCH_INTERVAL=""`
- To adjust reloadable interval, update environment variable `NGINX_WATCH_INTERVAL="30s"`. The value can refer to shell [sleep(1)](https://man7.org/linux/man-pages/man1/sleep.1.html) command arguments.

### Auto Load Module (`NGINX_LOAD_MODULES`)
The default image has a few modules (authldap, headers-more) loaded in /etc/nginx/nginx.conf file.

To adjust auto load modules, follow steps below:
- Find the module name from image, use following command to find existing modules `docker run --rm fengzhou/nginx ls /etc/nginx/modules`
- Include pre-load modules into environment variable, such as `NGINX_LOAD_MODULES="ngx_http_auth_ldap_module ngx_http_headers_more_filter_module"`

### Adjust Error Log Level (`NGINX_LOG_LEVEL`)
The nginx default error log level is configured "warn" (comparing to offiical image setting "notice")

To adjust log level, update environment variable `NGINX_LOG_LEVEL=warn`.

### Legacy Nginx Configuration (`NGINX_CONFIG_MODE`)
To support original docker image [nginx configuration](https://github.com/feng-zh/docker-nginx/blob/1.0/nginx.conf), the default setting is enable legacy mode.
- To enable legacy mode, use `NGINX_CONFIG_MODE=legacy` environment variable
- To disable legacy mode, use `NGINX_CONFIG_MODE=none` environment variable

### LDAP Auth Configuration
The detailed use LDAP auth configuration, refer to https://github.com/kvspb/nginx-auth-ldap
