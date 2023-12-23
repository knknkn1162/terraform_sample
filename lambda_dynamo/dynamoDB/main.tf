variable "table_name" {
    type = string
}

resource "aws_dynamodb_table" "example" {
    name = var.table_name
    billing_mode = "PROVISIONED"
    # deletion_protection_enabled = false
    read_capacity = 1
    write_capacity = 1
    hash_key = "timestamp"
    attribute {
        name = "timestamp"
        type = "S"
    }

    # error: all attributes must be indexed. Unused attributes: ["inputText" "outputText"]
    # attribute {
    #     name = "inputText"
    #     type = "S"
    # }

    # attribute {
    #     name = "outputText"
    #     type = "S"
    # }

    tags = {
        Name = "dynamoDB-1"
    }
}

resource "aws_dynamodb_table_item" "example" {
  table_name = aws_dynamodb_table.example.name
  hash_key   = aws_dynamodb_table.example.hash_key

  item = <<EOF
{
  "timestamp": {"S": "20191024183000"},
  "inputText": {"S": "⭐️こんにちは"},
  "outputText": {"S": "⭐️Hello"}
}
EOF
}
output "table_name" {
    value = var.table_name
}