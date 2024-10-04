# Monitoring & Observability Demo

This repository shows different scenarios about monitoring and observability diveded into four different branches
- Initialize of the web app infrastructure
- 

## Pre requisites
- AWS account and AWS credentials configured in your local environment
- Terraform installed version 1.8 or higher

# Build Backend
The backend is a lambda python code that requires

# Build Frontend
The web app is a React application inside the /frontend directory and you need to install the dependencies with yarn
```
yarn install
```
Create a new .env file based on .env.example and the build the application
```
yarn build
```

Once you deploy all the infrastructure with terraform replace the value of the assigned Cloudfront URL, rebuild the project and apply again the changes in terraform

## Infrastructure with Terraform
To initialize this project you need first to create a bucket and a dynamodb table to manage the terraform state
