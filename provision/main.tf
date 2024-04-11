module "lambda" {
  source        = "./modules/lambda"
  function_name = var.proyect_name
}
