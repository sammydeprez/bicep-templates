param location string = 'westeurope'
param environment string = 'dev'
param projectName string = 'bot'
param adminUserId string //User/Group ObjectId to give access to keyvault


param applicationId string //App Registration Id
@secure()
param applicationSecret string //App Registration Secret



var keyVaultName = 'kv-${projectName}-${environment}-01'
var appServicePlanName = 'plan-${projectName}-${environment}-01'
var appServiceName = 'app-${projectName}-${environment}-01'
var functionName = 'func-${projectName}-${environment}-01'
var appInsightsName = 'appi-${projectName}-${environment}-01'
var cosmosDbName = 'cosmos-${projectName}-${environment}-01'
var luisAuthoringName = 'cog-${projectName}-authoring-${environment}-01'
var luisPredictingName = 'cog-${projectName}-predicting-${environment}-01'
var botServiceName = 'bot-${projectName}-${environment}-01'
var logicName = 'logic-${projectName}-${environment}-01'
var qnaName = 'qna-${projectName}-${environment}-01'
var botName = 'Robin${(environment == 'dev') ? '_dev': ''}'

var botEndpoint = 'https://${appServiceName}.azurewebsites.net/api/messages'

var tags = {
  Description: 'Chatbot Robin'
  Environment: environment
}

module kv './modules/keyvault.bicep' = {
  name:'keyVaultDeploy'
  params: {
    location: location
    name: keyVaultName
    tags: tags
    adminUserId: adminUserId
  }
}

module kvsecret_AppId './modules/keyvault_secret.bicep' = {
  name:'addAppIdToKeyvault'
  params:{
    keyVaultName: kv.outputs.name
    secretName: 'BotAppId'
    secretValue: applicationId
  }
}

module kvsecret_AppSecret './modules/keyvault_secret.bicep' = {
  name:'addAppSecretToKeyvault'
  params:{
    keyVaultName: kv.outputs.name
    secretName: 'BotAppSecret'
    secretValue: applicationSecret
  }
}

module asp './modules/serverfarm.bicep' = {
  name:'appServicePlanDeploy'
  params:{
    location: location
    name: appServicePlanName
    tags:tags
  }
}

module app './modules/website.bicep' = {
  name: 'appServiceDeploy'
  params: {
    location: location
    name: appServiceName
    tags: tags
    serverFarmId: asp.outputs.id
  }
}

module kv_access_app './modules/keyvault_access.bicep' = {
  name: 'keyVaultAccessApp'
  params: {
    keyvaultName: kv.outputs.name
    objectId: app.outputs.identity
  }
}

module kv_access_func './modules/keyvault_access.bicep' = {
  name: 'keyVaultAccessFunction'
  params: {
    keyvaultName: kv.outputs.name
    objectId: func.outputs.identity
  }
}

module func './modules/function.bicep' = {
  name:'functionDeploy'
  params:{
    location: location
    name: functionName
    tags:tags
    serverFarmId: asp.outputs.id
  }
}

module cosmos './modules/cosmosdb.bicep' = {
  name:'cosmosdbDeploy'
  params:{
    location: location
    name: cosmosDbName
    tags:tags
  }
}

module kvsecret_CosmosKey './modules/keyvault_secret.bicep' = {
  name:'addCosmosKeyToKeyvault'
  params:{
    keyVaultName: kv.outputs.name
    secretName: 'CosmosDBPrimaryKey'
    secretValue: cosmos.outputs.primaryMasterKey
  }
}


module ai_web './modules/applicationinsights.bicep' = {
  name: 'applicationInsightsDeploy'
  params:{
    location: location
    name: appInsightsName
    type: 'web'
    tags: tags
  }
}

module luis './modules/luis.bicep' = {
  name: 'luisDeploy'
  params:{
    location: location
    name_predicting: luisPredictingName
    name_authoring: luisAuthoringName
    tags: tags
  }
}

module bot './modules/botservice.bicep' = {
  name: 'botServiceDeploy'
  params: {
    name: botServiceName
    tags: tags
    botDisplayName: botName
    botEndPoint: botEndpoint
    botMicrosoftAppId : applicationId
    applicationInsightsKey: ai_web.outputs.instrumentationKey
    applicationInsightsApplicationId: ai_web.outputs.appId
  }
}

module kvsecret_DirectLine './modules/keyvault_secret.bicep' = {
  name:'addDirectLineSecretToKeyvault'
  params:{
    keyVaultName: kv.outputs.name
    secretName: 'DirectLineSecret'
    secretValue: bot.outputs.directlineKey
  }
}

module appsettings './modules/appsettings.bicep' = {
  name: 'setAppSettings'
  params: {
    appName: '${app.outputs.name}'
    settings: {
      APPINSIGHTS_INSTRUMENTATIONKEY: ai_web.outputs.instrumentationKey
      APPLICATIONINSIGHTS_CONNECTION_STRING: ai_web.outputs.connectionstring
      MicrosoftAppId: '@Microsoft.KeyVault(VaultName=${kv.outputs.name};SecretName=BotAppId)'
      MicrosoftAppPassword: '@Microsoft.KeyVault(VaultName=${kv.outputs.name};SecretName=BotAppSecret)'
    }
  }
}

module funcsettings './modules/appsettings.bicep' = {
  name: 'setFuncSettings'
  params: {
    appName: '${func.outputs.name}'
    settings: {
      APPINSIGHTS_INSTRUMENTATIONKEY: ai_web.outputs.instrumentationKey
      APPLICATIONINSIGHTS_CONNECTION_STRING: ai_web.outputs.connectionstring
      DirectLineSecret: '@Microsoft.KeyVault(VaultName=${kv.outputs.name};SecretName=DirectLineSecret)'
    }
  }
}

module qna './modules/qna.bicep' = {
  name: 'searchDeploy'
  params:{
    location: location
    name: qnaName
    tags: tags
    serverFarmId: asp.outputs.id
    appInsightsName: ai_web.outputs.name
    appInsightsAppId: ai_web.outputs.appId
    appInsightsKey: ai_web.outputs.instrumentationKey
    keyVaultName: kv.outputs.name
  }
}

module logic './modules/logic.bicep' = {
  name: 'logicDeploy'
  params:{
    location: location
    name: logicName
    tags: tags
  }
}
