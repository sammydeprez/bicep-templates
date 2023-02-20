targetScope = 'subscription'

/**************************/
/* PARAMETERS & VARIABLES */
/**************************/

@allowed([
  'westeurope'
])
param location string = 'westeurope'

@allowed([
  'dev'
  'tst'
  'acc'
  'prd'
])
param environment string = 'prd'

@minLength(3)
@maxLength(15)
param projectName string = 'echo23'

param adminUserId string
param botName string = 'Ody'
param buildId string = 'manual'
param applicationId string
@secure()
param applicationSecret string

var tags = {
  Description: 'Chatbot ${botName}'
  Environment: environment
  Build: buildId
}

var adminUserIds = [
  adminUserId
]
/**************************/
/*     RESOURCE GROUPS    */
/**************************/


resource rg_resources 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${projectName}-${environment}-01'
  location: location
  tags: tags
}

/**************************/
/*        RESOURCES       */
/**************************/

module bot 'bot-template.bicep' = {
  name:'Bot_Deployment'
  scope: rg_resources
  params:{
    botName: botName
    buildId: buildId
    environment: environment
    location: location
    projectName: projectName
    applicationId: applicationId
    applicationSecret: applicationSecret
    adminUserIds: adminUserIds
  }
}
