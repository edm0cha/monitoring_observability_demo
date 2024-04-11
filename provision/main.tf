module "items" {
  source = "./modules/dynamodb"
  name   = "${var.proyect_name}-items"
}

module "lambda" {
  source           = "./modules/lambda"
  function_name    = var.proyect_name
  items_table_name = module.items.name
  items_table_arn  = module.items.arn
}
