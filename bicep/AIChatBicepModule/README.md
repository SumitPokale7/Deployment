# AI Chat Application - Bicep Infrastructure Module

This Bicep module deploys the complete infrastructure for the TruStage AI Chat Application, migrated from Terraform.

## 📁 Module Structure

```
bicep/AIChatBicepModule/
├── main.bicep              # Main orchestration file
├── networking.bicep        # VNet, Subnets, NSGs, Public IP
├── monitoring.bicep        # Application Insights, Log Analytics
├── storage.bicep           # Storage Account, Blob Container
├── vault.bicep             # Azure Key Vault
├── identity.bicep          # User Assigned Managed Identity
├── cosmos.bicep            # Cosmos DB Account, Database, Private Endpoint
├── search.bicep            # Azure AI Search, Private Endpoint
├── cognitive.bicep         # OpenAI, Form Recognizer, Translator
├── containerapp.bicep      # Container Registry, Container App Environment, Container Apps
├── agwaf.bicep             # Application Gateway with WAF
├── README.md               # This file
└── vars/
    └── dev.bicepparam      # Dev environment parameters
```

## 🚀 Resources Deployed

| Resource Type | Description |
|---------------|-------------|
| **Virtual Network** | VNet with subnets for Container Apps, Private Endpoints, and Application Gateway |
| **Network Security Groups** | NSGs for Application Gateway, Private Endpoints, Frontend, Backend |
| **Application Insights** | Application monitoring and logging |
| **Log Analytics Workspace** | Centralized logging for Container Apps |
| **Storage Account** | Blob storage with CORS configuration |
| **Key Vault** | Secrets management with RBAC |
| **User Assigned Managed Identity** | Identity for resource authentication |
| **Cosmos DB** | NoSQL database with geo-replication and private endpoints |
| **Azure AI Search** | Search service with private endpoint |
| **Azure OpenAI** | Multiple OpenAI accounts with model deployments |
| **Form Recognizer** | Document Intelligence service |
| **Translator** | Text translation service |
| **Container Registry** | Private container registry |
| **Container App Environment** | Managed environment for Container Apps |
| **Container Apps** | 11 container apps for various services |
| **Application Gateway** | WAF-enabled gateway with URL-based routing |

## 📋 Prerequisites

- Azure CLI installed and configured
- Bicep CLI installed (or use Azure CLI with Bicep extension)
- Appropriate Azure subscription permissions
- Resource group created

## 🔧 Deployment

### Option 1: Using Azure CLI with Parameter File

```bash
# Login to Azure
az login

# Set subscription
az account set --subscription "059ed1ab-6824-4344-9a65-a0504248340f"

# Deploy using parameter file
az deployment group create \
  --resource-group rg-cmfg-d01-psa-cognitiveservices-tf \
  --template-file main.bicep \
  --parameters vars/dev.bicepparam
```

### Option 2: Using PowerShell

```powershell
# Login to Azure
Connect-AzAccount

# Set subscription context
Set-AzContext -SubscriptionId "059ed1ab-6824-4344-9a65-a0504248340f"

# Deploy
New-AzResourceGroupDeployment `
  -ResourceGroupName "rg-cmfg-d01-psa-cognitiveservices-tf" `
  -TemplateFile "main.bicep" `
  -TemplateParameterFile "vars/dev.bicepparam"
```

## 🏗️ Module Dependencies

The modules are deployed in the following order to respect dependencies:

1. **Networking** - No dependencies
2. **Monitoring** - No dependencies
3. **Storage** - No dependencies
4. **Key Vault** - No dependencies
5. **Identity** - No dependencies
6. **Cosmos DB** - Depends on Networking (for private endpoints)
7. **Search** - Depends on Networking (for private endpoints)
8. **Cognitive Services** - Depends on Networking (for private endpoints)
9. **Container Apps** - Depends on Networking, Monitoring
10. **Application Gateway** - Depends on Networking, Container Apps

## 🔑 Key Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| `location` | Azure region | `centralus` |
| `environment` | Environment name | `dev`, `demo`, `prod` |
| `containerApps` | Container apps configuration | See vars/dev.bicepparam |
| `openaiAccounts` | OpenAI accounts and models | See vars/dev.bicepparam |
| `blackListedCountries` | Geo-blocking countries | `['CN', 'RU']` |

## 📊 Container Apps

The module deploys 11 container apps:

| App Key | Container App Name | Port | Purpose |
|---------|-------------------|------|---------|
| `translation_api` | ca-d01-ai-translationapi-tf | 8001 | Translation API |
| `CommercialMailBox_API` | ca-d01-ai-mailboxapi-tf | 8001 | Mailbox API |
| `chat_app_frontend` | ca-d01-ai-chatapp-frontend-tf | 80 | Chat Frontend |
| `chat_app_backend` | ca-d01-ai-chatapp-backend-tf | 8001 | Chat Backend |
| `chatkmstrainingapi` | ca-d01-ai-chatkmstrainingapi-tf | 8001 | KMS Training API |
| `core_services_api` | ca-d01-ai-coreservicesapi-tf | 8001 | Core Services API |
| `inference_api` | ca-d01-ai-inferenceapi-tf | 8001 | Inference API |
| `document_ingestion_api` | ca-d01-ai-doc-ingestionapi-tf | 8001 | Document Ingestion |
| `translator_service_api` | ca-d01-ai-translatorservice-tf | 8001 | Translator Service |
| `chat_app_frontend_v3` | ca-d01-ai-chatapp-frontend-v3-tf | 80 | Chat Frontend v3 |
| `chat_app_backend_v3` | ca-d01-ai-chatapp-backend-v3-tf | 8001 | Chat Backend v3 |

## 🤖 OpenAI Model Deployments

Each OpenAI account can have multiple model deployments:

| Model | Deployment Name | SKU | Capacity |
|-------|-----------------|-----|----------|
| text-embedding-ada-002 | embedding | Standard | 175 |
| gpt-4.1 | gpt-4.1 | GlobalStandard | 200 |
| gpt-4.1 | gpt-4.1-excel-parser | GlobalStandard | 500 |
| model-router | model-router | GlobalStandard | 200 |

## 🔒 Security Features

- **Private Endpoints** - All services use private endpoints
- **WAF Protection** - Application Gateway with OWASP 3.2 ruleset
- **Geo-Blocking** - Configurable country blacklist
- **RBAC** - Key Vault uses RBAC authorization
- **TLS 1.2** - Minimum TLS version enforced
- **Managed Identities** - System-assigned identities for Container Apps

## 🔄 Migration from Terraform

This Bicep module was migrated from the Terraform module at `terraform/OpenAITFModule/`. The following mapping applies:

| Terraform File | Bicep Module |
|----------------|--------------|
| `main.tf` + `variables.tf` | `main.bicep` |
| `networking.tf` | `networking.bicep` |
| `monitoring.tf` | `monitoring.bicep` |
| `storage.tf` | `storage.bicep` |
| `vault.tf` | `vault.bicep` |
| `cosmos.tf` | `cosmos.bicep` |
| `search.tf` | `search.bicep` |
| `cognitive.tf` | `cognitive.bicep` |
| `containerapp.tf` | `containerapp.bicep` |
| `agwaf.tf` | `agwaf.bicep` |
| `vars/dev.tfvars` | `vars/dev.bicepparam` |

## 📝 Notes

- The module uses `targetScope = 'resourceGroup'` - deploy to an existing resource group
- ACR is only deployed in `dev` and `prod` environments
- Private DNS zones are created for private endpoint connectivity
- Container Apps use the Consumption workload profile
