resource "aws_apigatewayv2_api" "example" {
    name = "translate-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "example" {
    api_id    = aws_apigatewayv2_api.example.id
    route_key = "GET /sample"
    authorization_type = "NONE"
    target    = "integrations/${aws_apigatewayv2_integration.example.id}"
}

resource "aws_apigatewayv2_integration" "example" {
    api_id               = aws_apigatewayv2_api.example.id
    connection_type      = "INTERNET"
    integration_method   = "POST"
    integration_uri      = aws_lambda_function.example.invoke_arn
    integration_type     = "AWS_PROXY"
    # Note that default is 1.0
    # the payload is here: https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-develop-integrations-lambda.html
    payload_format_version = "2.0"
}

resource "aws_apigatewayv2_stage" "example" {
  api_id      = aws_apigatewayv2_api.example.id
  auto_deploy = true
  name        = "dev"
  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.gateway.arn
    # See also https://docs.aws.amazon.com/ja_jp/apigateway/latest/developerguide/http-api-logging-variables.html
    format = jsonencode(
        {
            "requestId" : "$context.requestId",
            "ip" : "$context.identity.sourceIp",
            "requestTime" : "$context.requestTime",
            "httpMethod" : "$context.httpMethod",
            "routeKey" : "$context.routeKey",
            "status" : "$context.status",
            "protocol" : "$context.protocol",
            "responseLength" : "$context.responseLength"
        }
    )
  }
}
resource "aws_cloudwatch_log_group" "gateway" {
  name = "/aws/apigateway/${aws_apigatewayv2_api.example.name}"
}

output "invoke_url" {
  value = aws_apigatewayv2_api.example.api_endpoint
}