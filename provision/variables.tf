variable "project_name" {
  type        = string
  description = "Name of the project"
}

variable "owner" {
  type        = string
  description = "Owner of the project"
}

variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}
