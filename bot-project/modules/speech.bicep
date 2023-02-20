param location string
param name string
param tags object

resource luis_pred 'Microsoft.CognitiveServices/accounts@2022-10-01' = {
  name: name
  location: location
  tags: tags
  kind: 'SpeechServices'
  sku: {
    name: 'S0'
  }
  properties: {
  }
}
