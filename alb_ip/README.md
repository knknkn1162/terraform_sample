# README

## demo

```sh
# aws_lb_listener_rule = default
% curl http://example-578367322.ap-northeast-1.elb.amazonaws.com            
default 
# aws_lb_listener_rule = fixed_response
% curl 'http://example-578367322.ap-northeast-1.elb.amazonaws.com?value=OK'
listener
# aws_lb_listener_rule = forward, ip = ec2.private_ip(aws_lb_target_group_attachmentで指定)
% curl http://example-321776521.ap-northeast-1.elb.amazonaws.com/dummy/0
<!DOCTYPE HTML PUBLIC "-//IETF//DTD HTML 2.0//EN">
<html><head>
<title>404 Not Found</title>
</head><body>
<h1>Not Found</h1>
<p>The requested URL was not found on this server.</p>
</body></html>
```