param location string
param name string
param tags object
param serverFarmId string
param corsAll bool = false

resource app 'Microsoft.Web/sites@2019-08-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    serverFarmId: serverFarmId
    siteConfig: {
      alwaysOn: true
      webSocketsEnabled: true
      cors: corsAll ? {
        allowedOrigins: [
          '*'
        ]
      } : null
    }
  }
  identity: {
    type: 'SystemAssigned'
  }
}

output id string = app.id
output name string = app.name
output identity string = app.identity.principalId
