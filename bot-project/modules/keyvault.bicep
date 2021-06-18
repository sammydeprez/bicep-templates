param location string
param name string
param tags object
param adminUserId string

resource kv 'Microsoft.KeyVault/vaults@2019-09-01' = {
  name: name
  location: location
  tags: tags
  properties: {
    tenantId: subscription().tenantId
    sku: {
      family: 'A'
      name: 'standard'
    } 
    accessPolicies: [
      {
        objectId: adminUserId
        tenantId: subscription().tenantId
        permissions:{
          secrets:[
            'all'
            'backup'
            'delete'
            'get'
            'list'
            'purge'
            'recover'
            'restore'
            'set'
          ]
        }
      }
    ]
  }
}

output id string = kv.id
output name string = kv.name
