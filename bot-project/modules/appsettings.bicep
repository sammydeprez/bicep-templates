param appName string
param settings object

resource appsettings 'Microsoft.Web/sites/config@2018-11-01' = {
  name: '${appName}/appsettings'
  properties: settings
}
