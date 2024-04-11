data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.root}/../backend/lambda.py"
  output_path = "lambda.zip"
}

resource "aws_lambda_function" "this" {
  filename         = data.archive_file.lambda.output_path
  function_name    = var.function_name
  role             = aws_iam_role.lambda_execution_role.arn
  handler          = var.handler
  runtime          = var.runtime
  timeout          = var.timeout
  layers           = [aws_lambda_layer_version.requirements.arn]
  source_code_hash = data.archive_file.lambda.output_base64sha256
  memory_size      = var.memory_size
  environment {
    variables = {
      ITEMS_TABLE_NAME = var.items_table_name
    }
  }
}

resource "aws_lambda_function_url" "this" {
  function_name      = aws_lambda_function.this.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
    allow_methods = ["POST"]
    allow_headers = ["*"]
    max_age       = 86400
  }
}
