resource "aws_api_gateway_rest_api" "example" {
  name = "example"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "example"
  rest_api_id = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "example" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_integration" "example" {
    http_method = aws_api_gateway_method.example.http_method
    resource_id = aws_api_gateway_resource.example.id
    rest_api_id = aws_api_gateway_rest_api.example.id
    type        = "MOCK"
    # it's necessary
    request_templates = {
        "application/json" = <<EOF
{
    "statusCode": 200
}
EOF
  }
}

resource "aws_api_gateway_integration_response" "mock" {
    rest_api_id = aws_api_gateway_rest_api.example.id
    resource_id = aws_api_gateway_resource.example.id
    http_method = aws_api_gateway_method.example.http_method
    status_code = aws_api_gateway_method_response.response_200.status_code

  # Transforms the backend JSON response to XML
  response_templates = {
    "application/json" = <<EOF
{
    "body": "OK"
}
EOF
  }
}



resource "aws_api_gateway_method_response" "response_200" {
    rest_api_id = aws_api_gateway_rest_api.example.id
    resource_id = aws_api_gateway_resource.example.id
    http_method = aws_api_gateway_method.example.http_method
    status_code = "200"
}

resource "aws_api_gateway_deployment" "example" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.example.id,
      aws_api_gateway_method.example.id,
      aws_api_gateway_integration.example.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = "dev"
}

output "rest_api_id" {
    value = aws_api_gateway_rest_api.example.id
}

output "invoke_url" {
  value = "${aws_api_gateway_deployment.example.invoke_url}${aws_api_gateway_stage.example.stage_name}${aws_api_gateway_resource.example.path}"
}