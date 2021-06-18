param name string
param tags object
param botDisplayName string
param botEndPoint string
param botMicrosoftAppId string
param applicationInsightsKey string
param applicationInsightsApplicationId string


resource bot 'Microsoft.BotService/botServices@2018-07-12' = {
  name: name
  location: 'global'
  tags: tags
  sku: {
    name: 'S1'
  }
  kind: 'bot'
  properties: {
    displayName: botDisplayName
    endpoint: botEndPoint
    msaAppId: botMicrosoftAppId
    developerAppInsightKey: applicationInsightsKey
    developerAppInsightsApplicationId: applicationInsightsApplicationId
  }
}

resource channel 'Microsoft.BotService/botServices/channels@2018-07-12' = {
  name: '${bot.name}/DirectLineChannel'
  dependsOn:[
    bot
  ]
  location: 'global'
  tags: tags
  properties: {
    channelName: 'DirectLineChannel'
    properties: {
      sites: [
        {
          isEnabled: true
          siteName: 'bot'
          isV3Enabled: true
          isV1Enabled: false
        }
      ]
    }
  }
}


output id string = bot.id
output directlineKey string = listChannelWithKeys(channel.id, '2018-07-12').properties.properties.sites[0].key
