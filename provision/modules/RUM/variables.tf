variable "name" {
  description = "The name of the proyect"
  type        = string
}

variable "domain_name" {
  description = "The domain of the Cloudfront distribution"
  type        = string
}

variable "aws_region" {
  description = "The AWS region"
  type        = string
}

variable "session_sample_rate" {
  description = "RUM session sample rate"
  type        = number
  default     = 1.0
}
