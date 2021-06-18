param keyvaultName string
param objectId string

resource keyvault_access 'Microsoft.KeyVault/vaults/accessPolicies@2019-09-01' = {
  name: '${keyvaultName}/add'
  properties: {
    accessPolicies: [
      {
        objectId: objectId
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
