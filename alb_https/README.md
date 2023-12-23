# README

## demo

```sh
% curl http://cstmize.site
<html>
<head><title>301 Moved Permanently</title></head>
<body>
<center><h1>301 Moved Permanently</h1></center>
</body>
</html>
% curl -L http://cstmize.site
default action
% curl -L http://cstmize.site/dummy/999
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body>
<center><h1>503 Service Temporarily Unavailable</h1></center>
</body>
</html>
% curl https://cstmize.site           
default action
% curl https://cstmize.site/dummy/999
<html>
<head><title>503 Service Temporarily Unavailable</title></head>
<body>
<center><h1>503 Service Temporarily Unavailable</h1></center>
</body>
</html>
```

### redirect behavior

1. GET cstmize.site:80
2. domain-name -> alias: aws_lb.default.dns_name -> IPv4 in ALB (through A record in DNS)
3. redirect to cstmize.site:443 (through "redirect_http2https")
4. same as 2
5. aws_lb_listener.https
6. fixed_response -> default action

```sh
% curl -vvv -L http://cstmize.site
*   Trying [64:ff9b::de6:3e82]:80...
* Connected to cstmize.site (64:ff9b::de6:3e82) port 80 (#0)
> GET / HTTP/1.1
> Host: cstmize.site
...
< HTTP/1.1 301 Moved Permanently
...
< Location: https://cstmize.site:443/
...
* Clear auth, redirects to port from 80 to 443
* Issue another request to this URL: 'https://cstmize.site:443/'
*   Trying [64:ff9b::de6:3e82]:443...
* Connected to cstmize.site (64:ff9b::de6:3e82) port 443 (#1)
...
default action%
```