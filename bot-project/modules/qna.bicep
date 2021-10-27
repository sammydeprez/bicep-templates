param location string
param name string
param tags object
param serverFarmId string
param appInsightsKey string
param appInsightsName string
param appInsightsAppId string
param keyVaultName string


resource search 'Microsoft.Search/searchServices@2020-08-01-preview' = {
  name: 'srch-${name}'
  tags: tags
  location: location
  sku: {
    name: 'basic'
  }
}

module app './website.bicep' = {
  name: 'deployQnaWebApp'
  params: {
    name: 'app-${name}'
    location: location
    serverFarmId: serverFarmId
    tags: tags
    corsAll: true
  }
}

module kvsecret_SearchAdminKey './keyvault_secret.bicep' = {
  name:'addSearchAdminKeySecretToKeyvault'
  params:{
    keyVaultName: keyVaultName
    secretName: 'SearchAdminKey'
    secretValue: listAdminKeys(search.id, '2020-08-01').primaryKey
  }
}

module kv_access_app './keyvault_access.bicep' = {
  name: 'keyVaultAccessApp'
  params: {
    keyvaultName: keyVaultName
    objectId: app.outputs.identity
  }
}

resource qnacog 'Microsoft.CognitiveServices/accounts@2017-04-18' = {
  name: 'cog-${name}'
  location: 'westus'
  tags: tags
  kind: 'QnAMaker'
  sku: {
    name: 'S0'
  }
  properties: {
    apiProperties:{
      qnaRuntimeEndpoint: 'https://app-${name}.azurewebsites.net'
    }
  }
  dependsOn:[
    app
  ]
}


module appsettings './appsettings.bicep' = {
  name: 'qnaWebAppSettings'
  params: {
    appName: app.outputs.name
    settings:{
      'AzureSearchName': search.name
      'AzureSearchAdminKey': '@Microsoft.KeyVault(VaultName=${keyVaultName};SecretName=SearchAdminKey)'
      'UserAppInsightsKey': appInsightsKey
      'UserAppInsightsName': appInsightsName
      'UserAppInsightsAppId': appInsightsAppId
      'PrimaryEndpointKey': '${app.outputs.name}-PrimaryEndpointKey'
      'SecondaryEndpointKey': '${app.outputs.name}-SecondaryEndpointKey'
      'DefaultAnswer': 'No good match found in KB.'
      'QNAMAKER_EXTENSION_VERSION': 'latest'
    }
  }
}
