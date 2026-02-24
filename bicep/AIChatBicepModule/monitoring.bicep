// ============================================================================
// Monitoring Module - monitoring.bicep
// Matches Terraform: monitoring.tf
// Contains: Application Insights, Log Analytics Workspace
// ============================================================================

@description('Location for the monitoring resources')
param location string

@description('Tags to apply to all resources')
param tags object

@description('Name of the Application Insights resource')
param applicationInsightsName string

@description('Name of the Log Analytics Workspace')
param logAnalyticsWorkspaceName string

@description('Retention in days for Log Analytics')
param retentionInDays int = 30

@description('SKU for Log Analytics Workspace')
@allowed(['PerGB2018', 'Free', 'Standalone', 'PerNode', 'Standard', 'Premium'])
param logAnalyticsSku string = 'PerGB2018'

@description('Name for the action group (optional)')
param actionGroupName string = ''

@description('Short name for the action group')
param actionGroupShortName string = 'SmartDetect'

// ============================================================================
// Log Analytics Workspace
// ============================================================================

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: logAnalyticsWorkspaceName
  location: location
  tags: tags
  properties: {
    sku: {
      name: logAnalyticsSku
    }
    retentionInDays: retentionInDays
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
    workspaceCapping: {
      dailyQuotaGb: -1
    }
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// ============================================================================
// Application Insights
// ============================================================================

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: applicationInsightsName
  location: location
  tags: tags
  kind: 'web'
  properties: {
    Application_Type: 'web'
    Flow_Type: 'Redfield'
    Request_Source: 'IbizaAIExtension'
    RetentionInDays: 90
    WorkspaceResourceId: logAnalyticsWorkspace.id
    IngestionMode: 'LogAnalytics'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

// ============================================================================
// Action Group for Smart Detection (optional)
// ============================================================================

resource actionGroup 'Microsoft.Insights/actionGroups@2023-09-01-preview' = if (!empty(actionGroupName)) {
  name: actionGroupName
  location: 'global'
  tags: tags
  properties: {
    groupShortName: actionGroupShortName
    enabled: true
    emailReceivers: []
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: [
      {
        name: 'Monitoring Contributor'
        roleId: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
        useCommonAlertSchema: true
      }
      {
        name: 'Monitoring Reader'
        roleId: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
        useCommonAlertSchema: true
      }
    ]
  }
}

// ============================================================================
// Smart Detector Alert Rule for Failure Anomalies
// ============================================================================

// Smart Detector Alert Rule with custom Action Group
resource failureAnomaliesDetectorWithActionGroup 'Microsoft.AlertsManagement/smartDetectorAlertRules@2021-04-01' = if (!empty(actionGroupName)) {
  name: 'failure-anomalies-${applicationInsightsName}'
  location: 'global'
  tags: tags
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [applicationInsights.id]
    actionGroups: {
      customEmailSubject: 'Failure Anomalies detected in ${applicationInsightsName}'
      customWebhookPayload: '{}'
      groupIds: [actionGroup.id]
    }
  }
}

// Smart Detector Alert Rule without custom Action Group (default)
resource failureAnomaliesDetectorDefault 'Microsoft.AlertsManagement/smartDetectorAlertRules@2021-04-01' = if (empty(actionGroupName)) {
  name: 'failure-anomalies-${applicationInsightsName}'
  location: 'global'
  tags: tags
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [applicationInsights.id]
    actionGroups: {
      customEmailSubject: 'Failure Anomalies detected in ${applicationInsightsName}'
      customWebhookPayload: '{}'
      groupIds: []
    }
  }
}

// ============================================================================
// Proactive Detection Configs
// These use lowercase property names as required by the API
// ============================================================================

resource degradationInDependencyDuration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: applicationInsights
  name: 'degradationindependencyduration'
  properties: {
    ruleDefinitions: {
      Name: 'degradationindependencyduration'
      DisplayName: 'Degradation in dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    enabled: true
    sendEmailsToSubscriptionOwners: true
    customEmails: []
  }
}

resource degradationInServerResponseTime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: applicationInsights
  name: 'degradationinserverresponsetime'
  properties: {
    ruleDefinitions: {
      Name: 'degradationinserverresponsetime'
      DisplayName: 'Degradation in server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    enabled: true
    sendEmailsToSubscriptionOwners: true
    customEmails: []
  }
}

resource longDependencyDuration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: applicationInsights
  name: 'longdependencyduration'
  properties: {
    ruleDefinitions: {
      Name: 'longdependencyduration'
      DisplayName: 'Long dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    enabled: true
    sendEmailsToSubscriptionOwners: true
    customEmails: []
  }
}

resource slowPageLoadTime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: applicationInsights
  name: 'slowpageloadtime'
  properties: {
    ruleDefinitions: {
      Name: 'slowpageloadtime'
      DisplayName: 'Slow page load time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    enabled: true
    sendEmailsToSubscriptionOwners: true
    customEmails: []
  }
}

resource slowServerResponseTime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: applicationInsights
  name: 'slowserverresponsetime'
  properties: {
    ruleDefinitions: {
      Name: 'slowserverresponsetime'
      DisplayName: 'Slow server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    enabled: true
    sendEmailsToSubscriptionOwners: true
    customEmails: []
  }
}


// ===========================================================================
// Email Action Group for Failure Anomalies
// ===========================================================================
resource actionGroups_email 'microsoft.insights/actionGroups@2024-10-01-preview' = {
  name: 'email_achyuth'
  location: 'Global'
  tags: tags
  properties: {
    groupShortName: 'email'
    enabled: true
    emailReceivers: [
      {
        name: 'deepa_-EmailAction-'
        emailAddress: 'Deepa.Vivek@trustage.com'
        useCommonAlertSchema: false
      }
      {
        name: 'Azad_-EmailAction-'
        emailAddress: 'Azad.Periwal@trustage.com'
        useCommonAlertSchema: false
      }
      {
        name: 'Achyuth_-EmailAction-'
        emailAddress: 'AchyuthNaidu.Bellary@trustage.com'
        useCommonAlertSchema: false
      }
    ]
  }
}

resource failure_anomalies 'microsoft.alertsmanagement/smartdetectoralertrules@2021-04-01' = {
  name: 'Failure Anomalies - ${applicationInsights.name}'
  location: 'global'
  tags: tags
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [
      applicationInsights.id
    ]
    actionGroups: {
      groupIds: [
        actionGroups_email.id
      ]
    }
  }
}

// ============================================================================
// Outputs
// ============================================================================

output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output logAnalyticsWorkspaceName string = logAnalyticsWorkspace.name
output logAnalyticsCustomerId string = logAnalyticsWorkspace.properties.customerId
output applicationInsightsId string = applicationInsights.id
output applicationInsightsInstrumentationKey string = applicationInsights.properties.InstrumentationKey
output applicationInsightsConnectionString string = applicationInsights.properties.ConnectionString
