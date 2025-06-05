output "cloudfront_url" {
  value = module.static.domain_name
}


output "function_url" {
  value = module.lambda.function_url
}
