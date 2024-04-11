data "archive_file" "requierements" {
  type        = "zip"
  source_dir  = "${path.root}/../backend/layers/requirements"
  output_path = "requirements.zip"
}

resource "aws_lambda_layer_version" "requirements" {
  filename            = data.archive_file.requierements.output_path
  layer_name          = var.function_name
  compatible_runtimes = ["python3.11", "python3.12"]
  source_code_hash    = data.archive_file.requierements.output_base64sha256
}
