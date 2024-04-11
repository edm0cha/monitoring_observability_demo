provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project    = var.project_name
      owner      = var.owner
      created_by = "terraform"
    }
  }
}
