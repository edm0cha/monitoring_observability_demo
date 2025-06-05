# Monitoring & Observability Demo

This repository shows different scenarios about monitoring and observability diveded into four different branches
- Initialize of the web app infrastructure
- 

## Pre requisites
- AWS account and AWS credentials configured in your local environment
- Terraform installed version 1.8 or higher

# Backend
The backend is a lambda python code that doesn't require any type of setup or configuration, terraform handles the deployment automatically so you don't need to build or install any kind of dependencies

# Frontend
The web app is a React application inside the /frontend directory and you need to install the dependencies with yarn
```
yarn install
```
Create a new .env file based on .env.example and the build the application
```
yarn build
```

Once you deploy all the infrastructure with terraform replace the value of the assigned Cloudfront URL, rebuild the project and apply again the changes with terraform

## Infrastructure with Terraform
To initialize this project you need first to create a bucket and a dynamodb table to manage the terraform state, rename the init.template.tf file to init.tf, uncomment the code and replace the bucket a table values with your resources

```
terraform {
  backend "s3" {
    region         = "us-east-1"
    bucket         = "your-bucket-tf-state"
    dynamodb_table = "your-table-tf-state"
    key            = "terraform-observability.tfstate"
    encrypt        = true
  }
}
```

Initialize, verify and apply the plan of terraform
```
terraform init
terraform plan
terraform apply
```

# Demo Scenarios
This demo is divided into 4 different scenarios, this repository has the following branches were the scenarios are defined and you can apply the changes with Terraform:
- (feat/1-add-session-id)[https://github.com/edm0cha/monitoring_observability_demo/tree/feat/1-add-session-id] Session ID added to the request from the frontend (needs to rebuild frontend) 
- (feat/2-structured-logs)[https://github.com/edm0cha/monitoring_observability_demo/tree/feat/2-structured-logs] Add Powertools to replace all prints with structured logs
- (feat/3-metrics)[https://github.com/edm0cha/monitoring_observability_demo/tree/feat/3-metrics] Add Powertools metrics to track all the fetch and store methods
- (feat/4-dashboard)[https://github.com/edm0cha/monitoring_observability_demo/tree/feat/4-dashboard] Create a Cloudwatch Dashboard