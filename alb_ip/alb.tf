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
        module.http_sg.security_group_id
    ]
}

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

resource "aws_lb_listener_rule" "fixed_response" {
    listener_arn = aws_lb_listener.http.arn
    priority = 98

    action {
        type = "fixed-response"

        fixed_response {
            content_type = "text/plain"
            message_body = "listener"
            status_code  = "200"
        }
    }

  condition {
    query_string {
      key   = "value"
      value = "OK"
    }
  }
}

resource "aws_lb_listener_rule" "error503" {
    listener_arn = aws_lb_listener.http.arn
    priority = 99

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.default.arn
    }

    condition {
        path_pattern {
        values = ["/dummy/*"]
    }
  }
}

resource "aws_lb_target_group" "default" {
    name = "example"
    # If the target type is ip, specify IP addresses from the subnets of the virtual private cloud (VPC) for the target group

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

# assign private ip address
module "ec2" {
    source = "./ec2"
}

resource "aws_lb_target_group_attachment" "example" {
    target_group_arn = aws_lb_target_group.default.arn
    target_id = module.ec2.private_ip
    port = 80
}

output "alb_dns_name" {
    value = aws_lb.default.dns_name
}