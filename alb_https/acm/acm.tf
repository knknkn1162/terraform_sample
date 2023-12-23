variable "domain" {
    type = string
}

data "aws_route53_zone" "default" {
    name = var.domain
}

# 証明書の定義
resource "aws_acm_certificate" "default" {
    domain_name = data.aws_route53_zone.default.name
    # "*.cstmize.site"も登録される(別個に証明書を作る必要はない)
    subject_alternative_names = [
        format("*.%s",data.aws_route53_zone.default.name)
    ]

    validation_method = "DNS"

    lifecycle {
        create_before_destroy = true
    }
}

resource "aws_route53_record" "default" {
    for_each = {
      for dvo in aws_acm_certificate.default.domain_validation_options :
        dvo.domain_name => {
            record = dvo.resource_record_value
            type   = dvo.resource_record_type
            name = dvo.resource_record_name
        }
    }
    # to avoid InvalidChangeBatch: [Tried to create resource record set [name='_f4023081459bd8b259226355419bd38c.cstmize.site.', type='CNAME'] but it already exists]
    allow_overwrite = true
    zone_id = data.aws_route53_zone.default.id
    ttl = 60
    name = each.value.name
    type = each.value.type
    records = [each.value.record]
}

# wait for validation to complete.
resource "aws_acm_certificate_validation" "example" {
    certificate_arn = aws_acm_certificate.default.arn
    validation_record_fqdns = [for record in aws_route53_record.default : record.fqdn]
}

output "certificate_arn" {
    value = aws_acm_certificate.default.arn
}
output "fqdn" {
    value = [for record in aws_route53_record.default : record.fqdn]
}

output "zone_id" {
    value = data.aws_route53_zone.default.zone_id
}