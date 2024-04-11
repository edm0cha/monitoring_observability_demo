resource "aws_cloudfront_origin_access_control" "default" {
  name                              = var.name
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.this.bucket_regional_domain_name
    origin_id                = "${var.name}-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.default.id
  }

  origin {
    domain_name = replace(replace(var.function_url, "https://", ""), "/", "")
    origin_id   = "${var.name}-lambda"
    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${var.name}-s3"
    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }
    compress               = true
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  ordered_cache_behavior {
    path_pattern             = "/items"
    allowed_methods          = ["GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"]
    cached_methods           = ["GET", "HEAD", "OPTIONS"]
    compress                 = true
    target_origin_id         = "${var.name}-lambda"
    viewer_protocol_policy   = "redirect-to-https"
    min_ttl                  = 0
    default_ttl              = 0
    max_ttl                  = 0
    origin_request_policy_id = data.aws_cloudfront_origin_request_policy.all_viewer_except_host_header.id
    cache_policy_id          = data.aws_cloudfront_cache_policy.managed_caching_disabled.id
  }

  price_class = "PriceClass_200"
  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }
  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
