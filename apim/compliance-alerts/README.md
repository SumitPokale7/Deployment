# Compliance Alerts API

## Overview
The Compliance Alerts API is part of the Trustage Gen-AI Plugin, designed to facilitate web research and summarization tasks for compliance alerts. This API provides endpoints for checking the health of the service, executing web research, and scraping documents for summarization.

## Files in this Project
- **compliance-alerts-apim-metadata.json**: Contains metadata for the API Management endpoint, including API definitions, backend URIs, and associated policies.
- **compliance-alerts-openapi.json**: Defines the OpenAPI specification for the Compliance Alerts API, detailing available endpoints, request and response schemas.
- **deploy-apim-product.yml**: Deployment configuration for the API Management product, specifying how to deploy the Compliance Alerts API.
- **jwt-policy.xml**: Policy definitions for JWT validation, ensuring authenticated and authorized requests to the API.
- **variables/**: Contains environment-specific variable files:
  - **dev.yml**: Variables for the development environment.
  - **demo.yml**: Variables for the demo environment.
  - **prod.yml**: Variables for the production environment.

## Setup Instructions
1. Clone the repository to your local machine.
2. Navigate to the `compliance-alerts` directory.
3. Update the environment-specific variable files in the `variables` directory as needed.
4. Deploy the API using the `deploy-apim-product.yml` configuration.

## Usage Examples
- **Health Check**: Use the `/health` endpoint to check the status of the API.
- **Web Research**: Send a POST request to the `/research` endpoint with the required parameters to perform web research.
- **Document Summarization**: Use the `/scrape` endpoint to scrape and summarize specific URLs.

## Additional Information
For more detailed information on the API endpoints, refer to the `compliance-alerts-openapi.json` file.