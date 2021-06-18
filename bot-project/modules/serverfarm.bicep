param location string
param name string
param tags object

resource asp 'Microsoft.Web/serverfarms@2019-08-01' = {
  name: name
  location: location
  tags: tags
  sku: {
    tier: 'Standard'
    name: 'S1'
  }
}

output id string = asp.id
output name string = asp.name
