# request-tracing/nginx

NGINX configuration for request IDs

This NGINX configuration will generate a request ID - if not already provided in a request header - and add it to the
access logs.

Note: this NGINX configuration is by no means production ready. It only serves to demonstrate how request tracing
can work.

# Installation

```shell
# build the docker container
docker build --tag nginx-with-request-id .

# run the docker container and publish the container's port to the Docker host's port 8000
docker run --rm --publish 8000:80 nginx-with-request-id
```

# Demo

NGINX will generate a request ID and expose it as a response header:

```shell
curl --head http://localhost:8000
HTTP/1.1 200 OK
Server: nginx/1.20.2
X-Request-Id: 67d2a477f2f2dd09a1810a98b16cc1d3
```

NGINX will generate a request ID and add it to the access logs:
```shell
172.17.0.1 - - [24/Apr/2022:11:56:20 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.79.1" request_id=67d2a477f2f2dd09a1810a98b16cc1d3
```

NGINX will reuse the request ID from the `X-Request-Id` header and expose it as a response header:

```shell
curl --head --header 'X-Request-Id: 1337' http://localhost:8000
HTTP/1.1 200 OK
Server: nginx/1.20.2
X-Request-Id: 1337
```

NGINX will reuse the request ID from the `X-Request-Id` header and add it to the access logs:
```shell
172.17.0.1 - - [24/Apr/2022:11:56:20 +0000] "HEAD / HTTP/1.1" 200 0 "-" "curl/7.79.1" request_id=1337
```

# Passing the request ID to your application

Of course, you want to pass the request ID to your application so you can propagate it to subsequent requests and logs.

When using FastCGI to reverse proxy your application (commonly used for PHP-FPM) you can pass the request ID as a
`fastcgi_param` in your `server` config:

```
fastcgi_param HTTP_X-Request-Id $x_request_id;
```
