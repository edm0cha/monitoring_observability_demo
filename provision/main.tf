module "items" {
  source = "./modules/dynamodb"
  name   = "${var.project_name}-items"
}

module "lambda" {
  source           = "./modules/lambda"
  function_name    = "${var.project_name}-items"
  source_file      = "${path.root}/../backend/lambda.py"
  handler          = "lambda.lambda_handler"
  items_table_name = module.items.name
  items_table_arn  = module.items.arn
}

module "static" {
  source       = "./modules/static"
  name         = "${var.project_name}-static-content"
  function_url = module.lambda.function_url
}
