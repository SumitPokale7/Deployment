// ============================================================================
// Dev Environment Parameters - dev.bicepparam
// Migrated from Terraform: vars/dev.tfvars
// ============================================================================

using '../main.bicep'

// ============================================================================
// Common Parameters
// ============================================================================

param location = 'centralus'
param environment = 'dev'
param subscriptionId = '059ed1ab-6824-4344-9a65-a0504248340f'

// ============================================================================
// Tags
// ============================================================================

param cmdbAssetTag = '000091958'
param cmdbFriendlyName = 'Trustage AI Services'
param cmdbOwnedBy = 'Ramesh, Rajeev (rrf8031)'
param cmdbOwnedByEmail = 'Rajeev.Ramesh@trustage.com'
param cmdbPortfolio = ''

// ============================================================================
// Networking Parameters
// ============================================================================

param vnetName = 'vnet-d01-ai-cognitive-tf'
param agwafNsgName = 'nsg-d01-ai-cognitive-agwaf-tf'
param privateEndpointNsgName = 'nsg-d01-ai-cognitive-privateendpoint-tf'
param privateEndpointSubnetName = 'cdb-d01-ai-cognitive-pe-subnet-tf'
param acaSubnetName = 'ca-d01-ai-cognitive-pe-subnet-tf'
param agwafPublicIpName = 'pip-d01-ai-cognitive-agwaf-tf'
param frontendNsgName = 'nsg-d01-ai-cognitive-frontend-tf'
param backendNsgName = 'nsg-d01-ai-cognitive-backend-tf'

// ============================================================================
// Monitoring Parameters
// ============================================================================

param aisName = 'ais-d01-ai-cognitive-tf'
param acaLogAnalyticsWorkspaceName = 'law-d01-ai-cognitive-tf'

// ============================================================================
// Storage Parameters
// ============================================================================

param storageName = 'sad01aicognitivetf'
param blobContainer = 'email-classifier-data'
param backEndCorsTrustage = 'https://chatdev.trustage.com'
param investmentStorageName = ''

// ============================================================================
// Cosmos DB Parameters
// ============================================================================

param cosmosdbAccountName = 'cdbacct-d01-ai-cognitive-tf'
param cosmosdbName = 'cdb-d01-ai-cognitive-tf'
param secondaryDbLocation = 'westus'
param cosmosdbEndpointName = 'pe-d01-ai-cognitive-cdb-tf'
param cosmosPrivateServiceConnectionName = 'pe-d01-ai-cognitive-cdb-tf'
param cosmosOpenaiPrivateDnsZoneName = 'privatelink.documents.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkCosmos = 'pdnslink-d01-ai-cognitive-cosmos-tf'

// ============================================================================
// Search Parameters
// ============================================================================

param searchServiceName = 'ssvc-d01-ai-cognitive-tf'
param searchPrivateEndpointName = 'pe-d01-ai-cognitive-ssvc-tf'
param searchPrivateServiceConnectionName = 'pe-d01-ai-cognitive-ssvc-tf'
param searchPrivateDnsZoneName = 'privatelink-search-windows-net'
param azurermPrivateDnsZoneVirtualNetworkLinkSearch = 'pdnslink-d01-ai-cognitive-ssvc-tf'

// ============================================================================
// Cognitive Services - Form Recognizer Parameters
// ============================================================================

param formRecognizerName = 'fr-d01-ai-cognitive-westus2-tf'
param formRecognizerLocation = 'westus2'
param formRecognizerSubdomainName = 'fr-d01-westus2-truchat'
param documentIntelligenceOpenaiPrivateDnsZoneName = 'privatelink.cognitiveservices.azure.com'
param documentPrivateEndpointName = 'pe-d01-ai-cognitive-fr-tf'
param documentReaderServiceConnectionName = 'psc-d01-ai-cognitive-fr-tf'
param azurermPrivateFrDnsZoneVirtualNetworkLink = 'pdnslink-d01-ai-cognitive-fr-tf'
param embeddingQuota = '175'

// ============================================================================
// Cognitive Services - Translator Parameters
// ============================================================================

param translatorName = 'tr-d01-ai-cognitive-tf'
param translatorLocation = 'centralus'
param translatorSubdomainName = 'tr-d01-ai-cognitive-tf'
param translatorPrivateEndpointName = 'pe-d01-ai-cognitive-tr-tf'
param translatorPrivateServiceConnectionName = 'psc-d01-ai-cognitive-tr-tf'

// ============================================================================
// Cognitive Services - OpenAI Parameters
// ============================================================================

param openaiPrivateDnsZoneName = 'privatelink.openai.azure.com'
param azurermPrivateDnsZoneVirtualNetworkLinkOpenai = 'pdnslink-d01-ai-cognitive-oai-tf'

param openaiAccounts = {
  eastus2: {
    name: 'oai-d01-ai-cognitive-eastus2-tf'
    location: 'eastus2'
    sku_name: 'S0'
    subdomain_name: 'oai-d01-eastus2-truchat'
    private_endpoint_name: 'pe-d01-ai-cognitive-eastus2-oai-tf'
    private_service_connection_name: 'pe-d01-ai-cognitive-eastus2-oai-tf'
    models: {
      'text-embedding-ada-002': {
        deployment_name: 'embedding'
        model_name: 'text-embedding-ada-002'
        sku_name: 'Standard'
        capacity: 175
      }
      'gpt-4.1': {
        deployment_name: 'gpt-4.1'
        model_name: 'gpt-4.1'
        sku_name: 'GlobalStandard'
        capacity: 200
      }
      'gpt-4.1-excel-parser': {
        deployment_name: 'gpt-4.1-excel-parser'
        model_name: 'gpt-4.1'
        sku_name: 'GlobalStandard'
        capacity: 500
      }
      'model-router': {
        deployment_name: 'model-router'
        model_name: 'model-router'
        sku_name: 'GlobalStandard'
        capacity: 200
      }
    }
  }
}

// ============================================================================
// Key Vault Parameters
// ============================================================================

param keyVaultName = 'kv-d01-ai-cognitive-tf'
param frontEndCertKvName = 'kv-d01-ai-cognitive-tf'
param frontEndCertKvResourceGroupName = 'RG-CMFG-D01-PSA-CognitiveServices-TF'
param frontEndAzurermAppServiceCertificateName = 'chatdev-trustage-cert-secret'
param frontEndAzurermAppServiceCertificatePassword = 'chatdev-trustage-cert-password'
param frontEndHostName = 'chatdev.trustage.com'
param frontEndCertId = 'https://kv-atlas-itportfolio-np.vault.azure.net:443/certificates/truPilot-Trustagedev-cert/1ffcdfdb827846f5a59b6a11bfa62eae'

// ============================================================================
// Container Apps Parameters
// ============================================================================

param acaEnvName = 'managed-private-environment-tf'
param acaInfrastructureResourceGroupName = 'ME_managed-private-environment-tf_rg-cmfg-d01-psa-cognitiveservices-tf_centralus'
param acaEnvPrivateEndpointName = 'pe-d01-ai-cognitive-aca-env-tf'
param acaPrivateEndpointConnectionName = 'psc-d01-ai-cognitive-aca-env-tf'
param acaPrivateDnsZoneVirtualNetworkLinkName = 'pdnslink-d01-ai-cognitive-aca-tf'

param containerApps = {
  translation_api: {
    name: 'ca-d01-ai-translationapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/api/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_request_timeout: 120
    agw_path_patterns: ['/translationapi/*']
    agw_rewrite_enabled: true
    agw_rewrite_pattern: '/translationapi/(.*)'
    agw_rewrite_path: '/{var_uri_path_1}'
    agw_rewrite_sequence: 12
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8001'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '1'
      }
      {
        name: 'AZURE_OPENAI_CORE_CHAT_DEPLOYMENT_NAME'
        value: 'chat4o'
      }
      {
        name: 'AZURE_OPENAI_SUPPORT_CHAT_DEPLOYMENT_NAME'
        value: 'chat4o'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_CONTAINER_NAME'
        value: 'chats'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'AZURE_BLOB_TRANSLATOR_INPUT_CONTAINER_NAME'
        value: 'translator-input-data'
      }
      {
        name: 'AZURE_BLOB_TRANSLATOR_TEMP_CONTAINER_NAME'
        value: 'translator-temp-data'
      }
      {
        name: 'AZURE_BLOB_TRANSLATOR_OUTPUT_CONTAINER_NAME'
        value: 'translator-output-data'
      }
      {
        name: 'AZURE_BLOB_DOCUMENT_PROCESSING_LOGS_CONTAINER_NAME'
        value: 'document-processing-metadata'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_TRANSLATOR_QUEUE_NAME'
        value: 'translator-queue'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_TRANSLATOR_MSG_COUNT_PER_BATCH'
        value: '1'
      }
      {
        name: 'COSMOSDB_NOSQL_TRANSLATOR_AUDIT_CONTAINER_NAME'
        value: 'translator-audit-data'
      }
      {
        name: 'COSMOSDB_NOSQL_TRANSLATOR_AUDIT_SUMMARY_CONTAINER_NAME'
        value: 'translator-audit-status'
      }
      {
        name: 'AZURE_BLOB_FILE_DOWNLOAD_RETRY_TIME_LIMIT'
        value: '10'
      }
      {
        name: 'LANGUAGE_TRANSLATOR_QUEUE_LISTENER_INTERVAL_IN_SECONDS'
        value: '30'
      }
      {
        name: 'AZURE_DOC_TRANSLATOR_ENDPOINT'
        value: 'https://tr-d01-ai-cognitive-tf.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'AWS_S3_BUCKET_NAME'
        value: 'tempstorage-int-useast2-119724262116'
      }
      {
        name: 'AWS_S3_REGION_NAME'
        value: 'us-east-2'
      }
      {
        name: 'AZURE_OPENAI_MAX_HTML_TOKEN_LIMIT'
        value: '60000'
      }
      {
        name: 'AZURE_OPENAI_MODEL_NAME'
        value: '\'gpt-4.1\''
      }
      {
        name: 'INPUT_CONTAINER_URL'
        value: 'https://sad01aicognitivetf.blob.core.windows.net/translator-input-data'
      }
      {
        name: 'TEMP_CONTAINER_URL'
        value: 'https://sad01aicognitivetf.blob.core.windows.net/translator-temp-data'
      }
      {
        name: 'USE_MANAGED_IDENTITY'
        value: 'True'
      }
      {
        name: 'SAS_URL_INPUT_CONTAINER'
        value: '__SAS_URL_INPUT_CONTAINER__'
      }
      {
        name: 'SAS_URL_TEMP_CONTAINER'
        value: '__SAS_URL_TEMP_CONTAINER__'
      }
      {
        name: 'SAS_URL_OUTPUT_CONTAINER'
        value: '__SAS_URL_OUTPUT_CONTAINER__'
      }
      {
        name: 'SAS_TOKEN_TEMP_CONTAINER'
        value: '__SAS_TOKEN_TEMP_CONTAINER__'
      }
      {
        name: 'DISCLAIMER_MESSAGE_MIN_LENGTH'
        value: '5'
      }
      {
        name: 'DISCLAIMER_MESSAGE_MAX_LENGTH'
        value: '1000'
      }
      {
        name: 'DEFAULT_DISCLAIMER_MESSAGE'
        value: 'DISCLAIMER\\n - We will provide all documents to you in English. You should have someone you trust who is fluent in English review all documents with you.\\n - This Spanish version is for your reference only. If you need to sign a document, it will be in English.\\n - This content was translated using Artificial Intelligence.'
      }
      {
        name: 'MAX_WORKERS'
        value: '3'
      }
      {
        name: 'PURGE_JOB_CRON_EXPR'
        value: '0 0 1 */6 *'
      }
      {
        name: 'AZURE_OPENAI_INPUT_PRICING_PER_MILLION_TOKENS'
        value: '2.5'
      }
      {
        name: 'AZURE_OPENAI_OUTPUT_PRICING_PER_MILLION_TOKENS'
        value: '11'
      }
      {
        name: 'AZURE_DOC_TRANSLATION_SERVICE_PRICING_PER_MILLION_CHARACTERS'
        value: '15'
      }
      {
        name: 'AZURE_DOC_TRANSLATOR_PUBLIC_ENDPOINT'
        value: 'https://api.cognitive.microsofttranslator.com'
      }
      {
        name: 'AZURE_DOC_TRANSLATOR_ENDPOINT_REGIONAL'
        value: 'https://tr-d01-ai-cognitive-tf.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOC_TRANSLATOR_REGION'
        value: 'centralus'
      }
      {
        name: 'DOC_TRANSLATOR_SUPPORTED_LANGUAGES'
        value: 'af,am,ar,as,az,ba,be,bg,bho,bn,bo,brx,bs,ca,cs,cy,da,de,doi,dsb,dv,el,en,es,et,eu,fa,fi,fil,fj,fo,fr,fr-ca,ga,gl,gom,gu,ha,he,hi,hne,hr,hsb,ht,hu,hy,id,ig,ikt,is,it,iu,iu-latn,ja,ka,kk,km,kmr,kn,ko,ks,ku,ky,lb,ln,lo,lt,lug,lv,lzh,mai,mg,mi,mk,ml,mn-cyrl,mn-mong,mni,mr,ms,mt,mww,my,nb,ne,nl,nso,nya,or,otq,pa,pl,prs,ps,pt,pt-pt,ro,ru,run,rw,sd,si,sk,sl,sm,sn,so,sq,sr-cyrl,sr-latn,st,sv,sw,ta,te,th,ti,tk,tlh-latn,tlh-piqd,tn,to,tr,tt,ty,ug,uk,ur,uz,vi,xh,yo,yua,yue,zh-hans,zh-hant,zu'
      }
    ]
  }
  CommercialMailBox_API: {
    name: 'ca-d01-ai-mailboxapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '0.5'
    memory: '1Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/api/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/mailboxapi/*']
    agw_rewrite_enabled: true
    agw_rewrite_pattern: '/mailboxapi/(.*)'
    agw_rewrite_path: '/{var_uri_path_1}'
    agw_rewrite_sequence: 12
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-north-centralus-truchat.openai.azure.com'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-north-centralus-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '1'
      }
      {
        name: 'AZURE_OPENAI_CORE_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_SUPPORT_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'AZURE_BLOB_EMAIL_CONTAINER_NAME'
        value: 'email-classifier-data'
      }
      {
        name: 'RPA_SERVICE_URL'
        value: 'https://demo-apimanager.trustage.com/EntRPA/V1/workqueues/5fb16040-5fe5-4129-af98-156205e20e21/items/batch/'
      }
      {
        name: 'BLUE_PRISM_CLIENTID'
        value: 'API_COMSERV_DEMO'
      }
      {
        name: 'IDP_APIM_ENDPOINT'
        value: 'https://dev-apimanager.trustage.com/openid-connect-authorization/token/V1/as/token.oauth2'
      }
      {
        name: 'EMAIL_TOKEN_SA_UN'
        value: 'SA-aichat-apim-M'
      }
      {
        name: 'COSMOSDB_NOSQL_EMAIL_APEX_CONTAINER_NAME'
        value: 'email-category-apex-mappings'
      }
      {
        name: 'COSMOSDB_NOSQL_EMAIL_TER_ASIGN_CONTAINER_NAME'
        value: 'email-apex-territory-assignments'
      }
      {
        name: 'COSMOSDB_NOSQL_EMAIL_CATEGORY_CONTAINER_NAME'
        value: 'email-category-data'
      }
      {
        name: 'COSMOSDB_NOSQL_EMAIL_AUDIT_CONTAINER_NAME'
        value: 'email-audit-data'
      }
      {
        name: 'COSMOSDB_NOSQL_APP_CONFIG_CONTAINER_NAME'
        value: 'app-config-data'
      }
      {
        name: 'EMAIL_BLUE_PRISM_CLIENT_SECRET'
        value: 'email-blue-prism-client-secret'
      }
      {
        name: 'EMAIL_TOKEN_SA_PWD'
        value: 'sa-aichat-secret'
      }
      {
        name: 'EMAIL_RPA_OCP_APIM_SUBSCRIPTION_KEY'
        value: 'email-rpa-ocp-apim-subscription-key-demo'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_EMAIL_QUEUE_NAME'
        value: 'email-classification-queue'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_MAX_RETRY_COUNT'
        value: '3'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_MSG_COUNT_PER_BATCH'
        value: '20'
      }
      {
        name: 'MAILBOX_LISTENER_INTERVAL_IN_SECONDS'
        value: '30'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'COMMERCIAL_MB_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'COMMERCIAL_MB_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
    ]
  }
  chat_app_frontend: {
    name: 'ca-d01-ai-chatapp-frontend-tf'
    revision_mode: 'Single'
    target_port: 80
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '0.5'
    memory: '1Gi'
    liveness_probe_port: 80
    liveness_probe_path: '/'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/*']
    env: [
      {
        name: 'VITE_MAX_FILE_SIZE_MB'
        value: '20'
      }
      {
        name: 'VITE_INV_MAX_FILE_SIZE_MB'
        value: '30'
      }
      {
        name: 'VITE_REPORT_DURATION_DAYS'
        value: '30'
      }
      {
        name: 'VITE_MAX_UPLOAD_LIMIT'
        value: '5'
      }
      {
        name: 'VITE_MAX_INPUT_CHARACTER_LIMIT'
        value: '3000'
      }
      {
        name: 'VITE_BASE_URL'
        value: 'https://chatdev.trustage.com/chatapi'
      }
      {
        name: 'VITE_OIDC_CLIENT_AUTHORITY'
        value: 'https://federationdemo.trustage.com/'
      }
      {
        name: 'VITE_OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'VITE_OIDC_CLIENT_SCOPES'
        value: 'openid profile email groups'
      }
      {
        name: 'VITE_APPLICATION_FEEDBACK_LINK'
        value: 'https://forms.microsoft.com/r/3BFZbSUsFx?origin=lprLink'
      }
      {
        name: 'VITE_SAMPLE_QUESTIONS'
        value: 'What phrases help build trust with customers?,How do I de-escalate a tense situation over chat or phone?,How do I respond to a customer when I don\'t know the answer right away?,How do I give constructive feedback to a teammate?'
      }
      {
        name: 'VITE_APP_VERSION'
        value: '1.0.0'
      }
      {
        name: 'VITE_BUILD_URI'
        value: '/'
      }
      {
        name: 'VITE_PROCESS_MAX_FILE_SIZE_MB'
        value: '30'
      }
      {
        name: 'VITE_COMPLAINT_MANAGEMENT_LIBRARY_NAME'
        value: 'complaint management'
      }
      {
        name: 'VITE_KMS_TRAINING_BASE_URL'
        value: 'https://chatdev.trustage.com/chatkmstrainingapi'
      }
      {
        name: 'VITE_CHAT_CORE_BASE_URL'
        value: 'https://chatdev.trustage.com/coreservicesapi'
      }
      {
        name: 'VITE_INFERENCE_BASE_URL'
        value: 'https://chatdev.trustage.com/inferenceapi'
      }
      {
        name: 'VITE_DOC_INGESTION_BASE_URL'
        value: 'https://chatdev.trustage.com/documentingestionapi'
      }
    ]
  }
  chat_app_backend: {
    name: 'ca-d01-ai-chatapp-backend-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/chatapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOCAI_API_VERSION'
        value: '2023-07-31'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '0'
      }
      {
        name: 'AZURE_OPENAI_TIKTOKEN_MODEL_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_CORE_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_SUPPORT_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME'
        value: 'embedding'
      }
      {
        name: 'AZURE_OPENAI_PREMIUM_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-5-mini'
      }
      {
        name: 'AZURE_OPENAI_DEPLOYED_MODELS'
        value: 'gpt-4.1,gpt-5-mini,gpt-5-nano,model-router'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_CONTAINER_NAME'
        value: 'chats'
      }
      {
        name: 'COSMOSDB_NOSQL_DOCUMENTS_CONTAINER_NAME'
        value: 'documents'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_PROCESSED_DATA_CONTAINER_NAME'
        value: 'chat-document-processed-data'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_USAGE_CONTAINER_NAME'
        value: 'chat-document-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARIES_CONTAINER_NAME'
        value: 'libraries'
      }
      {
        name: 'COSMOSDB_NOSQL_TOOL_CONTAINER_NAME'
        value: 'tools'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'PURGE_JOB_CRON_EXPR'
        value: '0 2 * * *'
      }
      {
        name: 'DATA_RETENTION_PERIOD_DAYS'
        value: '30'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'RETIREMENTS_AD_GROUP'
        value: 'R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'AZURE_BLOB_USER_DOCUMENTS_CONTAINER_NAME'
        value: 'truchat-user-documents'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_ID'
        value: 'f8a1e7d4-315c-4188-a1f2-0861e5622c5d'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_SECRET_NAME'
        value: 'SP-AI-KMS-DATA-D'
      }
      {
        name: 'AZURE_APP_REGISTRATION_TENANT_ID'
        value: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
      }
      {
        name: 'WIKI_SOURCE_AZURE_DEVOPS_RESOURCE_ID'
        value: '499b84ac-1321-427f-aa17-267ca6975798'
      }
      {
        name: 'WIKI_SOURCE_ORGANIZATION_URL'
        value: 'https://dev.azure.com/cunamutual'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: 'null'
      }
      {
        name: 'BASE_URL'
        value: '/chatapi'
      }
      {
        name: 'ENABLE_AUTO_PURGE'
        value: 'false'
      }
      {
        name: 'COSMOSDB_NOSQL_APP_CONFIG_CONTAINER_NAME'
        value: 'app-config-data'
      }
      {
        name: 'SHAREPOINT_SITE_URL_PNC'
        value: 'https://cunamutual.sharepoint.com/sites/PRJITAT'
      }
      {
        name: 'SHAREPOINT_PNC_LIST_NAME'
        value: 'Test'
      }
      {
        name: 'SHAREPOINT_PNC_APP_CONFIG_ENABLE_UPLOAD_TO_LIST'
        value: 'pnc_sharepoint_list_enable_upload'
      }
      {
        name: 'SHAREPOINT_PNC_APP_CONFIG_LIST_FIELD_NAME_MAPPING'
        value: 'pnc_sharepoint_list_field_name_mapping'
      }
      {
        name: 'SHAREPOINT_CLIENT_SECRET_NAME'
        value: 'SP-AI-SharePoint-D'
      }
      {
        name: 'SHAREPOINT_CLIENT_ID'
        value: 'ccc7bf5e-152c-4373-b640-f2c460ffd245'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARY_DOCUMENTS_CONTAINER_NAME'
        value: 'library-documents'
      }
      {
        name: 'CHAT_KMS_TRAINING_BASE_URL'
        value: '/api'
      }
      {
        name: 'LIBRARY_RETRAIN_CRON'
        value: '12 19 * * *'
      }
      {
        name: 'LIBRARY_RETRAIN_ENABLE'
        value: 'false'
      }
      {
        name: 'SHAREPOINT_ORG_BASE_URL'
        value: 'https://cunamutual.sharepoint.com'
      }
      {
        name: 'SHAREPOINT_GRAPH_BASE_URL'
        value: 'https://graph.microsoft.com'
      }
      {
        name: 'SHAREPOINT_VERIFICATION_CERT_PATH'
        value: ' '
      }
      {
        name: 'AZURE_OPENAI_TRAINING_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1-training'
      }
      {
        name: 'USER_AD_GROUP_TO_DOC_CATEGORY_MAPPING'
        value: 'R-App-PropertyAndCasualtyCircular-NonProd:property_and_casualty_circular'
      }
      {
        name: 'SHAREPOINT_PNC_SP_DOC_SITE_NAME'
        value: 'PRJITAT'
      }
      {
        name: 'SHAREPOINT_PNC_SP_DOC_LIBRARY_NAME'
        value: 'PnC-Documents-TestData'
      }
      {
        name: 'PNC_CIRCULAR_JOB_CRON_EXPR'
        value: '*/15 * * * *'
      }
      {
        name: 'PNC_CIRCULAR_USER_AD_GROUP'
        value: 'R-App-PropertyAndCasualtyCircular-NonProd'
      }
      {
        name: 'AZURE_OPENAI_DEDICATED_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_EXCEL_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'CITATION_SOURCE_CONTENT_MAX_CHAR_LENGTH'
        value: '10000'
      }
      {
        name: 'DOCUMENT_RAG_TOP_K'
        value: '20'
      }
      {
        name: 'LIBRARY_RAG_TOP_K'
        value: '20'
      }
    ]
  }
  chatkmstrainingapi: {
    name: 'ca-d01-ai-chatkmstrainingapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/chatkmstrainingapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/chatkmstrainingapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOCAI_API_VERSION'
        value: '2023-07-31'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '0'
      }
      {
        name: 'AZURE_OPENAI_TIKTOKEN_MODEL_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_TRAINING_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1-training'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARIES_CONTAINER_NAME'
        value: 'libraries'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARY_DOCUMENTS_CONTAINER_NAME'
        value: 'library-documents'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'CHAT_KMS_TRAINING_BASE_URL'
        value: '/chatkmstrainingapi'
      }
      {
        name: 'LIBRARY_RETRAIN_CRON'
        value: '12 19 * * *'
      }
      {
        name: 'LIBRARY_RETRAIN_ENABLE'
        value: 'false'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_ID'
        value: 'f8a1e7d4-315c-4188-a1f2-0861e5622c5d'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_SECRET_NAME'
        value: 'SP-AI-KMS-DATA-D'
      }
      {
        name: 'AZURE_APP_REGISTRATION_TENANT_ID'
        value: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
      }
      {
        name: 'WIKI_SOURCE_AZURE_DEVOPS_RESOURCE_ID'
        value: '499b84ac-1321-427f-aa17-267ca6975798'
      }
      {
        name: 'WIKI_SOURCE_ORGANIZATION_URL'
        value: 'https://dev.azure.com/cunamutual'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: 'null'
      }
      {
        name: 'SHAREPOINT_ORG_BASE_URL'
        value: 'https://cunamutual.sharepoint.com'
      }
      {
        name: 'SHAREPOINT_GRAPH_BASE_URL'
        value: 'https://graph.microsoft.com'
      }
      {
        name: 'SHAREPOINT_VERIFICATION_CERT_PATH'
        value: '__SHAREPOINT_VERIFICATION_CERT_PATH__'
      }
      {
        name: 'AZURE_APP_REGISTRATION_KMS_CLIENT_ID'
        value: 'f8a1e7d4-315c-4188-a1f2-0861e5622c5d'
      }
      {
        name: 'AZURE_APP_REGISTRATION_KMS_CLIENT_SECRET_NAME'
        value: 'SP-AI-KMS-DATA-D'
      }
      {
        name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME'
        value: 'embedding'
      }
    ]
  }
  core_services_api: {
    name: 'ca-d01-ai-coreservicesapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/coreservicesapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/coreservicesapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_CONTAINER_NAME'
        value: 'chats'
      }
      {
        name: 'COSMOSDB_NOSQL_DOCUMENTS_CONTAINER_NAME'
        value: 'documents'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_PROCESSED_DATA_CONTAINER_NAME'
        value: 'chat-document-processed-data'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_USAGE_CONTAINER_NAME'
        value: 'chat-document-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARIES_CONTAINER_NAME'
        value: 'libraries'
      }
      {
        name: 'COSMOSDB_NOSQL_TOOL_CONTAINER_NAME'
        value: 'tools'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'ENABLE_AUTO_PURGE'
        value: 'false'
      }
      {
        name: 'PURGE_JOB_CRON_EXPR'
        value: '0 2 * * *'
      }
      {
        name: 'DATA_RETENTION_PERIOD_DAYS'
        value: '30'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'CHAT_CORE_BASE_URL'
        value: '/coreservicesapi'
      }
      {
        name: 'AZURE_BLOB_USER_DOCUMENTS_CONTAINER_NAME'
        value: 'truchat-user-documents'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'AZURE_APP_REGISTRATION_TENANT_ID'
        value: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: 'null'
      }
    ]
  }
  inference_api: {
    name: 'ca-d01-ai-inferenceapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/inferenceapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/inferenceapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOCAI_API_VERSION'
        value: '2023-07-31'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '0'
      }
      {
        name: 'AZURE_OPENAI_TIKTOKEN_MODEL_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_CORE_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_SUPPORT_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME'
        value: 'embedding'
      }
      {
        name: 'AZURE_OPENAI_TRAINING_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1-training'
      }
      {
        name: 'AZURE_OPENAI_PREMIUM_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-5-mini'
      }
      {
        name: 'AZURE_OPENAI_DEPLOYED_MODELS'
        value: 'gpt-4.1,gpt-5-mini,gpt-5-nano,model-router'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_CONTAINER_NAME'
        value: 'chats'
      }
      {
        name: 'COSMOSDB_NOSQL_DOCUMENTS_CONTAINER_NAME'
        value: 'documents'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_PROCESSED_DATA_CONTAINER_NAME'
        value: 'chat-document-processed-data'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_USAGE_CONTAINER_NAME'
        value: 'chat-document-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARIES_CONTAINER_NAME'
        value: 'libraries'
      }
      {
        name: 'COSMOSDB_NOSQL_TOOL_CONTAINER_NAME'
        value: 'tools'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'ENABLE_AUTO_PURGE'
        value: 'false'
      }
      {
        name: 'PURGE_JOB_CRON_EXPR'
        value: '0 2 * * *'
      }
      {
        name: 'DATA_RETENTION_PERIOD_DAYS'
        value: '30'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'INFERENCE_API_BASE_URL'
        value: '/inferenceapi'
      }
      {
        name: 'AZURE_BLOB_USER_DOCUMENTS_CONTAINER_NAME'
        value: 'truchat-user-documents'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'AZURE_APP_REGISTRATION_TENANT_ID'
        value: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
      }
      {
        name: 'WIKI_SOURCE_AZURE_DEVOPS_RESOURCE_ID'
        value: '499b84ac-1321-427f-aa17-267ca6975798'
      }
      {
        name: 'WIKI_SOURCE_ORGANIZATION_URL'
        value: 'https://dev.azure.com/cunamutual'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_ACCOUNT_NAME'
        value: 'null'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: 'null'
      }
      {
        name: 'AZURE_BLOB_TEST_EVALUATION_DOCS_CONTAINER_NAME'
        value: 'truchat-tests'
      }
      {
        name: 'SAVE_EVALUATION_TESTS_IN_APP'
        value: 'False'
      }
      {
        name: 'SAVE_EVALUATION_TESTS_IN_BLOB'
        value: 'True'
      }
    ]
  }
  document_ingestion_api: {
    name: 'ca-d01-ai-doc-ingestionapi-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/documentingestionapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/documentingestionapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOCAI_API_VERSION'
        value: '2023-07-31'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '0'
      }
      {
        name: 'AZURE_OPENAI_TIKTOKEN_MODEL_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_TRAINING_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1-training'
      }
      {
        name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME'
        value: 'embedding'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DOCUMENTS_CONTAINER_NAME'
        value: 'documents'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_PROCESSED_DATA_CONTAINER_NAME'
        value: 'chat-document-processed-data'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_USAGE_CONTAINER_NAME'
        value: 'chat-document-usage'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'CHAT_DOCUMENT_INGESTION_BASE_URL'
        value: '/documentingestionapi'
      }
      {
        name: 'AZURE_BLOB_USER_DOCUMENTS_CONTAINER_NAME'
        value: 'truchat-user-documents'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: ' '
      }
    ]
  }
  translator_service_api: {
    name: 'ca-d01-ai-translatorservice-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/translatorservice/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/translatorservice/*']
  }
  chat_app_frontend_v3: {
    name: 'ca-d01-ai-chatapp-frontend-v3-tf'
    revision_mode: 'Single'
    target_port: 80
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '0.5'
    memory: '1Gi'
    liveness_probe_port: 80
    liveness_probe_path: '/pilot/'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 10
    agw_enabled: true
    agw_path_patterns: ['/pilot', '/pilot/*']
    env: [
      {
        name: 'VITE_MAX_FILE_SIZE_MB'
        value: '20'
      }
      {
        name: 'VITE_INV_MAX_FILE_SIZE_MB'
        value: '30'
      }
      {
        name: 'VITE_REPORT_DURATION_DAYS'
        value: '30'
      }
      {
        name: 'VITE_MAX_UPLOAD_LIMIT'
        value: '5'
      }
      {
        name: 'VITE_BASE_URL'
        value: 'https://chatdev.trustage.com/pilotapi'
      }
      {
        name: 'VITE_OIDC_CLIENT_AUTHORITY'
        value: 'https://federationdemo.trustage.com/'
      }
      {
        name: 'VITE_OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'VITE_OIDC_CLIENT_SCOPES'
        value: 'openid profile email groups'
      }
      {
        name: 'VITE_APPLICATION_FEEDBACK_LINK'
        value: 'https://forms.microsoft.com/r/3BFZbSUsFx?origin=lprLink'
      }
      {
        name: 'VITE_SAMPLE_QUESTIONS'
        value: 'What phrases help build trust with customers?,How do I de-escalate a tense situation over chat or phone?,How do I respond to a customer when I don\'t know the answer right away?,How do I give constructive feedback to a teammate?'
      }
      {
        name: 'VITE_APP_VERSION'
        value: '1.0.0'
      }
      {
        name: 'VITE_BUILD_URI'
        value: '/pilot/'
      }
      {
        name: 'VITE_PROCESS_MAX_FILE_SIZE_MB'
        value: '30'
      }
      {
        name: 'VITE_COMPLAINT_MANAGEMENT_LIBRARY_NAME'
        value: 'complaint management'
      }
      {
        name: 'VITE_KMS_TRAINING_BASE_URL'
        value: 'https://chatdev.trustage.com/chatkmstrainingapi'
      }
      {
        name: 'VITE_MAX_INPUT_CHARACTER_LIMIT'
        value: '3000'
      }
    ]
  }
  chat_app_backend_v3: {
    name: 'ca-d01-ai-chatapp-backend-v3-tf'
    revision_mode: 'Single'
    target_port: 8001
    image: 'mcr.microsoft.com/k8se/quickstart:latest'
    cpu: '1'
    memory: '2Gi'
    liveness_probe_port: 8001
    liveness_probe_path: '/pilotapi/health'
    liveness_probe_transport: 'HTTP'
    min_replicas: 1
    max_replicas: 3
    max_inactive_revisions: 5
    agw_enabled: true
    agw_path_patterns: ['/pilotapi/*']
    env: [
      {
        name: 'ENVIRONMENT'
        value: 'Demo'
      }
      {
        name: 'LOG_LEVEL'
        value: 'DEBUG'
      }
      {
        name: 'API_PORT'
        value: '8000'
      }
      {
        name: 'API_TIMEOUT'
        value: '300'
      }
      {
        name: 'API_ALLOWED_ORIGINS'
        value: 'https://chatdev.trustage.com'
      }
      {
        name: 'AZURE_SUBSCRIPTION_ID'
        value: '059ed1ab-6824-4344-9a65-a0504248340f'
      }
      {
        name: 'AZURE_RG_NAME'
        value: 'RG-CMFG-D01-PSA-CognitiveServices-TF'
      }
      {
        name: 'AZURE_DOCAI_ENDPOINT'
        value: 'https://fr-d01-westus2-truchat.cognitiveservices.azure.com/'
      }
      {
        name: 'AZURE_DOCAI_API_VERSION'
        value: '2023-07-31'
      }
      {
        name: 'AZURE_SEARCH_ENDPOINT'
        value: 'https://ssvc-d01-ai-cognitive-tf.search.windows.net'
      }
      {
        name: 'AZURE_SEARCH_INDEX_NAME'
        value: 'truchatsearchindex-v3'
      }
      {
        name: 'AZURE_OPENAI_ENDPOINT'
        value: 'https://oai-d01-eastus2-truchat.openai.azure.com/'
      }
      {
        name: 'AZURE_OPENAI_ACCOUNT_NAME'
        value: 'oai-d01-ai-cognitive-eastus2-tf'
      }
      {
        name: 'AZURE_OPENAI_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_OPENAI_TEMPERATURE'
        value: '0'
      }
      {
        name: 'AZURE_OPENAI_TIKTOKEN_MODEL_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_CORE_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_TRAINING_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1-training'
      }
      {
        name: 'AZURE_OPENAI_SUPPORT_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME'
        value: 'embedding'
      }
      {
        name: 'AZURE_OPENAI_PREMIUM_CHAT_DEPLOYMENT_NAME'
        value: 'gpt-5-mini'
      }
      {
        name: 'AZURE_OPENAI_DEPLOYED_MODELS'
        value: 'gpt-4.1,gpt-5-mini,gpt-5-nano,model-router'
      }
      {
        name: 'COSMOSDB_NOSQL_SERVER'
        value: 'https://cdbacct-d01-ai-cognitive-tf.documents.azure.com:443/'
      }
      {
        name: 'COSMOSDB_NOSQL_ACCOUNT_NAME'
        value: 'cdbacct-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_DB_NAME'
        value: 'cdb-d01-ai-cognitive-tf'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_CONTAINER_NAME'
        value: 'chats'
      }
      {
        name: 'COSMOSDB_NOSQL_DOCUMENTS_CONTAINER_NAME'
        value: 'documents'
      }
      {
        name: 'COSMOSDB_NOSQL_PLATFORM_USAGE_CONTAINER_NAME'
        value: 'platform-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_TOKEN_USAGE_CONTAINER_NAME'
        value: 'token-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_PROCESSED_DATA_CONTAINER_NAME'
        value: 'chat-document-processed-data'
      }
      {
        name: 'COSMOSDB_NOSQL_CHAT_DOCUMENT_USAGE_CONTAINER_NAME'
        value: 'chat-document-usage'
      }
      {
        name: 'COSMOSDB_NOSQL_RESOURCE_GROUP_CONTAINER_NAME'
        value: 'resource-groups'
      }
      {
        name: 'COSMOSDB_NOSQL_LIBRARIES_CONTAINER_NAME'
        value: 'libraries'
      }
      {
        name: 'COSMOSDB_NOSQL_TOOL_CONTAINER_NAME'
        value: 'tools'
      }
      {
        name: 'COSMOSDB_NOSQL_APP_CONFIG_CONTAINER_NAME'
        value: 'app-config-data'
      }
      {
        name: 'AZURE_INSIGHTS_CONNECTION_STRING'
        value: 'InstrumentationKey=3c187b7f-f434-4cfa-9d03-d5b08fb287fd;IngestionEndpoint=https://centralus-0.in.applicationinsights.azure.com/;LiveEndpoint=https://centralus.livediagnostics.monitor.azure.com/;ApplicationId=47a3ed04-da3b-4e2b-835a-4f309165b555'
      }
      {
        name: 'AZURE_VAULT_URL'
        value: 'https://kv-d01-ai-cognitive-tf.vault.azure.net/'
      }
      {
        name: 'OIDC_ISSUER'
        value: 'https://federationdemo.trustage.com'
      }
      {
        name: 'OIDC_APIM_INTROSPECT_URI'
        value: 'https://dev-apimanager.trustage.com/openid-configuration-cmm/V1/as/introspect.oauth2'
      }
      {
        name: 'OIDC_CLIENT_ID'
        value: '0ef6a4a4-13c1-4812-a03e-1ed25db3ed27'
      }
      {
        name: 'APIM_SUBSCRIPTION_KEY_SECRET_NAME'
        value: 'trustage-chat-Apim-sub-key'
      }
      {
        name: 'RATE_LIMIT_COOLDOWN_IN_HRS'
        value: '12'
      }
      {
        name: 'ENABLE_AUTO_PURGE'
        value: 'false'
      }
      {
        name: 'PURGE_JOB_CRON_EXPR'
        value: '0 2 * * *'
      }
      {
        name: 'DATA_RETENTION_PERIOD_DAYS'
        value: '30'
      }
      {
        name: 'WHITELISTED_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'PLATFORM_ADMINS_AD_GROUP'
        value: 'R-App-AIKMS-PlatformAdmin-NonProd'
      }
      {
        name: 'ANALYTICS_AD_GROUP'
        value: 'R-App-Chat-Analytics-NonProd'
      }
      {
        name: 'CHAT_AUDIT_AD_GROUP'
        value: 'R-App-Temp-Chat-Audit-NonProd'
      }
      {
        name: 'AZURE_BLOB_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'BASE_URL'
        value: '/pilotapi'
      }
      {
        name: 'AZURE_BLOB_USER_DOCUMENTS_CONTAINER_NAME'
        value: 'truchat-user-documents'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_USERNAME'
        value: 'truchat_api_docs_user'
      }
      {
        name: 'TRUCHAT_API_SWAGGER_PASSWORD_SECRET_NAME'
        value: 'truchat-api-swagger-password'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_ID'
        value: 'f8a1e7d4-315c-4188-a1f2-0861e5622c5d'
      }
      {
        name: 'AZURE_APP_REGISTRATION_CLIENT_SECRET_NAME'
        value: 'SP-AI-KMS-DATA-D'
      }
      {
        name: 'AZURE_APP_REGISTRATION_TENANT_ID'
        value: 'a00452fd-8469-409e-91a8-bb7a008e2da0'
      }
      {
        name: 'WIKI_SOURCE_AZURE_DEVOPS_RESOURCE_ID'
        value: '499b84ac-1321-427f-aa17-267ca6975798'
      }
      {
        name: 'WIKI_SOURCE_ORGANIZATION_URL'
        value: 'https://dev.azure.com/cunamutual'
      }
      {
        name: 'AZURE_STORAGE_QUEUE_ACCOUNT_NAME'
        value: 'sad01aicognitivetf'
      }
      {
        name: 'STANDARD_QUOTA_AD_GROUPS'
        value: 'R-App-TruChat-NonProd,R-App-Retirements-BidTracker-NonProd'
      }
      {
        name: 'STANDARD_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '10000'
      }
      {
        name: 'STANDARD_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_ADVANCED_TOKENS_LIMIT'
        value: '100000'
      }
      {
        name: 'PREMIUM_QUOTA_BASIC_TOKENS_LIMIT'
        value: '100000000'
      }
      {
        name: 'PREMIUM_QUOTA_AD_GROUPS'
        value: 'null'
      }
      {
        name: 'SHAREPOINT_SITE_URL_PNC'
        value: 'https://cunamutual.sharepoint.com/sites/PRJITAT'
      }
      {
        name: 'SHAREPOINT_PNC_LIST_NAME'
        value: 'Test'
      }
      {
        name: 'SHAREPOINT_PNC_APP_CONFIG_ENABLE_UPLOAD_TO_LIST'
        value: 'pnc_sharepoint_list_enable_upload'
      }
      {
        name: 'SHAREPOINT_PNC_APP_CONFIG_LIST_FIELD_NAME_MAPPING'
        value: 'pnc_sharepoint_list_field_name_mapping'
      }
      {
        name: 'SHAREPOINT_CLIENT_SECRET_NAME'
        value: 'SP-AI-SharePoint-D'
      }
      {
        name: 'SHAREPOINT_CLIENT_ID'
        value: 'ccc7bf5e-152c-4373-b640-f2c460ffd245'
      }
      {
        name: 'SHAREPOINT_PNC_SP_DOC_SITE_NAME'
        value: 'PRJITAT'
      }
      {
        name: 'SHAREPOINT_PNC_SP_DOC_LIBRARY_NAME'
        value: 'PnC-Documents-TestData'
      }
      {
        name: 'PNC_CIRCULAR_JOB_CRON_EXPR'
        value: '*/15 * * * *'
      }
      {
        name: 'PNC_CIRCULAR_USER_AD_GROUP'
        value: 'R-App-PropertyAndCasualtyCircular-NonProd'
      }
      {
        name: 'ALATION_BASE_URL'
        value: 'https://trustage.alationcloud.com'
      }
      {
        name: 'ALATION_OAUTH_CLIENT_ID'
        value: '1a4b7c9a-b1de-4627-b8f5-09fb1b62afdf'
      }
      {
        name: 'ALATION_OAUTH_CLIENT_SECRET_NAME'
        value: 'ALATION-OAUTH-CLIENT-SECRET-NAME'
      }
      {
        name: 'SHAREPOINT_ORG_BASE_URL'
        value: 'https://cunamutual.sharepoint.com'
      }
      {
        name: 'ALATION_USER_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'ALATION_ADMIN_AD_GROUP'
        value: 'R-App-TruChat-NonProd'
      }
      {
        name: 'AZURE_AI_FOUNDRY_ENDPOINT'
        value: 'https://ais-np1-ai-ss-eu2-bi-01.services.ai.azure.com'
      }
      {
        name: 'AZURE_AI_FOUNDRY_PROJECT'
        value: 'prj-np1-ai-ss-eu2-bi-01'
      }
      {
        name: 'AZURE_AI_FOUNDRY_API_VERSION'
        value: '2024-12-01-preview'
      }
      {
        name: 'AZURE_AI_FOUNDRY_CHAT_MODEL'
        value: 'gpt-4.1'
      }
      {
        name: 'AZURE_AI_FOUNDRY_RESEARCH_MODEL'
        value: 'Kimi-K2.5'
      }
      {
        name: 'AZURE_AI_FOUNDRY_PREMIUM_MODEL'
        value: 'sonnet-4-5'
      }
      {
        name: 'AZURE_AI_FOUNDRY_EMBEDDING_MODEL'
        value: 'text-embedding-3-large'
      }
      {
        name: 'AZURE_AI_FOUNDRY_DEPLOYED_MODELS'
        value: '\'gpt-4.1,gpt-4o,Kimi-K2.5,sonnet-4-5\''
      }
    ]
  }
}

// ============================================================================
// Application Gateway Parameters
// ============================================================================

param agwafName = 'agwaf-d01-ai-cognitive-tf'
param blackListedCountries = [] // Dynamically injected from Atlas constants.ps1  // Add geo-blocked countries as needed
param backendAddressPoolFrontend = 'as-d01-ai-cognitive-truchat-frontend-tf.azurewebsites.net'
param backendAddressPoolFrontendInv = ''
param backendAddressPoolBackend = 'as-d01-ai-cognitive-truchat-backend-tf.azurewebsites.net'
param backendAddressPoolBackendInv = ''
param backendAddressPoolBackendResearch = 'as-d01-ai-cognitive-cs-backend-tf-fwh8asb4c2d2fpe4.centralus-01.azurewebsites.net'
param backendAddressPoolFrontendResearch = 'as-d01-ai-cognitive-cs-frontend-tf-enbgbkftgvffhqbq.centralus-01.azurewebsites.net'
param apimIp = '172.177.156.178/32'
param staticErrorPageUrl403 = 'https://sad01aicognitivetf.z19.web.core.windows.net/index.html'
