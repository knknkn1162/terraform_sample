locals {
    domain = "cstmize.site"
}

module "acm" {
    source = "./acm"
    domain =local.domain
}

# add A record
resource "aws_route53_record" "default" {
    zone_id = module.acm.zone_id
    name = local.domain
    type = "A"

    alias {
        name = aws_lb.default.dns_name
        zone_id = aws_lb.default.zone_id
        evaluate_target_health = true
    }
}