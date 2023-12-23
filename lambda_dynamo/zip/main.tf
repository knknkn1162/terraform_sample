variable src_dir {
    type = string
}

data "archive_file" "lambda" {
    type = "zip"
    source_dir = var.src_dir
    output_path = "${var.src_dir}/main.zip"
}

output "base64sha256" {
    value = data.archive_file.lambda.output_base64sha256
}

output "zip_path" {
    value = data.archive_file.lambda.output_path
}