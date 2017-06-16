This is the docker project to setup reloadable nginx based on content change and pre-defined nginx.conf.

Usage
----
Use following command to setup nginx docker with ldap and nginx configuration reloadable.
```shell
$ docker run -d --name nginx -p 80:80 -v /path/to/nginx-conf.d:/etc/nginx/conf.d fengzhou/nginx
```
