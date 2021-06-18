param location string
param name_authoring string
param name_predicting string
param tags object

resource luis_pred 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: name_predicting
  location: location
  tags: tags
  kind: 'LUIS'
  sku: {
    name: 'S0'
  }
  properties: {
  }
}

resource luis_auth 'Microsoft.CognitiveServices/accounts@2021-04-30' = {
  name: name_authoring
  location: location
  tags: tags
  kind: 'LUIS.Authoring'
  sku: {
    name: 'F0'
  }
  properties: {
  }
}

