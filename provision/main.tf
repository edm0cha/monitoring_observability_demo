module "items" {
  source = "./modules/dynamodb"
  name   = "${var.proyect_name}-items"
}

module "store_item" {
  source           = "./modules/lambda"
  function_name    = "${var.proyect_name}-store-items"
  source_file      = "${path.root}/../backend/lambda.py"
  handler          = "lambda.lambda_handler"
  items_table_name = module.items.name
  items_table_arn  = module.items.arn
}

module "get_items" {
  source                   = "./modules/lambda"
  function_name            = "${var.proyect_name}-get-items"
  source_file              = "${path.root}/../backend/lambda_get.py"
  handler                  = "lambda_get.lambda_handler"
  items_table_name         = module.items.name
  items_table_arn          = module.items.arn
  endpoint_allowed_methods = ["GET"]
}
