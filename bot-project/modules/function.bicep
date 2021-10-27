param location string
param name string
param tags object
param serverFarmId string

resource app 'Microsoft.Web/sites@2019-08-01' = {
  name: name
  location: location
  tags: tags
  kind: 'functionapp'
  properties: {
    siteConfig:{
      ftpsState: 'FtpsOnly'
    }
    httpsOnly: true
    serverFarmId: serverFarmId
  }
  identity:{
    type:'SystemAssigned'
  }
}

output id string = app.id
output name string = app.name
output identity string = app.identity.principalId
