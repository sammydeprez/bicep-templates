param location string
param name string
param tags object

resource cosmosdb 'Microsoft.DocumentDB/databaseAccounts@2021-04-15' = {
  name: name
  location: location
  tags: tags
  properties: {
    databaseAccountOfferType: 'Standard'
    locations:[
      {
        locationName: location
      }
    ]
  }
}

output id string = cosmosdb.id
output name string = cosmosdb.name
output primaryMasterKey string = listKeys(cosmosdb.id, '2021-04-15').primaryMasterKey
