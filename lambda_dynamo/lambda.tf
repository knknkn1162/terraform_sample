locals {
    function_name = "lambda-23432926"
}

resource "aws_lambda_function" "example" {
    function_name = local.function_name
    role = module.role_lambda.iam_role_arn

    source_code_hash = module.function.base64sha256
    filename = module.function.zip_path
    handler = "main.lambda_handler"
    runtime = "python3.11"

    timeout = 10
    environment {
        variables = {
            TABLENAME = module.dynamo.table_name
        }
    }
}

# log group explicitly with retention days
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 7
}

# test
resource "aws_lambda_invocation" "example" {
  function_name = aws_lambda_function.example.function_name

  input = file("src/test.json")
}

output "result_entry" {
  value = jsondecode(aws_lambda_invocation.example.result)
}