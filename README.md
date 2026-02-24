# Project Overview

This project is designed to deploy and manage AI services and infrastructure components using Azure and Terraform. The project includes configurations for different environments such as development, demo, and production. It leverages Azure API Management (APIM) to manage APIs and uses Terraform for infrastructure as code.

## Infrastructure

The infrastructure is defined using Terraform and includes various resources such as App Service Plans, Web Apps, Key Vaults, and more. The Terraform configurations are organized into different modules and environment-specific files.

### Key Components

- **App Service Plans**: Hosting plans for front-end and back-end web apps.
- **Web Apps**: Front-end and back-end applications.
- **Key Vaults**: Secure storage for secrets and keys.
- **Cognitive Services**: AI services for various functionalities.
- **Search Services**: Azure Search services for indexing and querying data.

## Features

- **Environment-Specific Configurations**: Separate configurations for development, demo, and production environments.
- **Automated Deployment**: Automated deployment scripts using Azure DevOps pipelines.
- **Role-Based Access Control (RBAC)**: Configurations for managing access permissions.
- **API Management**: Management of APIs using Azure API Management.

## APIM Folder

The `apim` folder contains configurations and scripts for managing APIs using Azure API Management. It includes definitions for various APIs, policies, and deployment scripts.

### Services

#### Translation Service

- **API Name**: AI Translator Service
- **Definition File**: `translation-openai.json`
- **Backend URI**: `https://chatdemo.trustage.com` (Demo), `https://chat.trustage.com` (Prod)
- **API Path**: `/aiservices`
- **Version**: v1
- **Description**: Team: AITeam; Contact email: DS-GenAI-Onshore@trustage.com
- **Policies**: 
  - `jwt-policy.xml`
- **Operations**:
  - `translation-policy.xml`

#### Commercial Service

- **API Name**: Commercial MailBox
- **Definition File**: `commercial-openai.json`
- **Backend URI**: `https://chatdemo.trustage.com` (Demo), `https://chat.trustage.com` (Prod)
- **API Path**: `/commercial`
- **Version**: v1
- **Description**: Team: AITeam; Contact email: DS-GenAI-Onshore@trustage.com
- **Policies**: 
  - `jwt-policy.xml`
- **Operations**:
  - `email-classify-policy.xml`

### Deployment Scripts

The deployment scripts are organized into various YAML files that define the steps for deploying APIs and managing policies. These scripts use Azure DevOps pipelines and Azure PowerShell tasks for automation.

- **Product Deployment**: `Product_Deployment.YAML`
- **Basic Policy Deployment**: `Basic_Policy_Deployment.YAML`
- **Subscribe Product to APIM**: `Subscribe_Product_To_APIM.YAML`

## How to Use

1. **Clone the Repository**: Clone the repository to your local machine.
2. **Configure Environment Variables**: Update the environment-specific YAML files with the appropriate values.
3. **Run Terraform**: Navigate to the `terraform` directory and run the Terraform scripts to deploy the infrastructure.
4. **Deploy APIs**: Use the Azure DevOps pipelines to deploy the APIs and manage policies.


## Terraform Folder

This folder contains the Terraform configurations for deploying and managing the infrastructure components of the project. The configurations are organized into various modules and environment-specific files to ensure modularity and reusability.

## High-Level Features

- **Modular Design**: The Terraform configurations are organized into reusable modules.
- **Environment-Specific Configurations**: Separate configurations for development, demo, and production environments.
- **Automated Deployment**: Integration with Azure DevOps pipelines for automated deployment.
- **State Management**: Remote state management using Azure Storage.
- **Role-Based Access Control (RBAC)**: Configurations for managing access permissions.

## Components

### App Service Plans

- **Description**: Hosting plans for front-end and back-end web apps.
- **Modules**: `app_service_plan`
- **Resources**: Azure App Service Plans

### Web Apps

- **Description**: Front-end and back-end applications.
- **Modules**: `web_app`
- **Resources**: Azure Web Apps

### Key Vaults

- **Description**: Secure storage for secrets and keys.
- **Modules**: `key_vault`
- **Resources**: Azure Key Vaults

### Cognitive Services

- **Description**: AI services for various functionalities.
- **Modules**: `cognitive_services`
- **Resources**: Azure Cognitive Services

### Search Services

- **Description**: Azure Search services for indexing and querying data.
- **Modules**: `search_service`
- **Resources**: Azure Search Services

### Networking

- **Description**: Virtual networks, subnets, and network security groups.
- **Modules**: `networking`
- **Resources**: Azure Virtual Networks, Subnets, Network Security Groups

### Storage Accounts

- **Description**: Storage accounts for storing data and managing state.
- **Modules**: `storage_account`
- **Resources**: Azure Storage Accounts

## How to Use

1. **Clone the Repository**: Clone the repository to your local machine.
2. **Navigate to the Terraform Folder**: Navigate to the `terraform` directory.
3. **Initialize Terraform**: Run `terraform init` to initialize the Terraform configuration.
4. **Plan and Apply**: Run `terraform plan` to review the changes and `terraform apply` to deploy the infrastructure.

## Conclusion

The Terraform folder provides a modular and reusable approach to managing infrastructure components. It includes environment-specific configurations, automated deployment scripts, and robust role-based access control.

For any questions or support, please contact the AITeam at DS-GenAI-Onshore@trustage.com.