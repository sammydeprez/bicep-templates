param secretName string
param keyVaultName string
@secure()
param secretValue string


resource kvs 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${keyVaultName}/${secretName}'
  properties: {
    value: secretValue
  }
}

output secret_name string = kvs.name
