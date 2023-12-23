resource "aws_lb" "default" {
    name = "example"
    load_balancer_type = "application"
    internal = false
    idle_timeout = 60
    # use true when production
    enable_deletion_protection = false

    subnets = module.default_subnets.subnet_ids
    access_logs {
        bucket = module.alb_log.id
        enabled = true
    }

    security_groups = [
        //module.http_sg.security_group_id,
        module.http_redirect_sg.security_group_id,
        module.https_sg.security_group_id
    ]
}

/*
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.default.arn
    port = 80
    protocol = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "default action"
        status_code = "200"
      }
    }
}
*/

resource "aws_lb_listener" "https" {
    load_balancer_arn = aws_lb.default.arn
    port = "443"
    protocol = "HTTPS"
    certificate_arn = module.acm.certificate_arn
    ssl_policy = "ELBSecurityPolicy-2016-08"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "default action"
        status_code = "200"
      }
    }
}

resource "aws_lb_listener" "redirect_http2https" {
    load_balancer_arn = aws_lb.default.arn
    port = "80"
    protocol = "HTTP"

    default_action {
      type = "redirect"
      redirect {
        port = "443"
        protocol = "HTTPS"
        status_code = "HTTP_301"
      }
    }
}

resource "aws_lb_listener_rule" "example" {
    listener_arn = aws_lb_listener.https.arn
    priority = 100

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.example.arn
    }

    condition {
        path_pattern {
            values = ["/dummy/*"]
        }
    }
}

resource "aws_lb_target_group" "example" {
    name = "example"
    target_type = "ip"
    vpc_id = module.default_vpc.id
    port = 80
    protocol = "HTTP"
    deregistration_delay = 300

    health_check {
        path = "/"
        healthy_threshold = 5
        unhealthy_threshold = 2
        timeout = 5
        interval = 30
        matcher = 200
        port = "traffic-port"
        protocol = "HTTP"
    }

    depends_on = [ aws_lb.default ]
}

output "alb_dns_name" {
    value = aws_lb.default.dns_name
}