# Monitoring & Observability Demo

This repository shows different scenarios about monitoring and observability diveded into four different branches
- 1. Initialize of the web app infrasttructure
- 2. 

## Pre requisites
- AWS account and AWS credentials configured in your local environment
- Terraform installed version 1.8 or higher

# Build Frontend
The web app is a React application inside the /frontend directory and you need to install the dependencies with yarn and build the application
´´´
yarn install

yarn build
´´´

# Build Backend

## Infrastructure with Terraform
To initialize this project you need first to create a bucket and a dynamodb table to manage the terraform state
