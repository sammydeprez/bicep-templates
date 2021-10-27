targetScope = 'subscription'

/**************************/
/* PARAMETERS & VARIABLES */
/**************************/

@allowed([
  'westeurope'
])
param location string

@allowed([
  'dev'
  'tst'
  'acc'
  'prd'
])
param environment string

@minLength(3)
@maxLength(15)
param projectName string

param adminUserId string
param devopsUserId string
param botName string
param applicationId string
@secure()
param applicationSecret string
param buildId string
param createStorageAccount bool = true

var tags = {
  Description: 'Chatbot ${botName}'
  Environment: environment
  Build: buildId
}

var adminUserIds = [
  adminUserId
  devopsUserId
]

/**************************/
/*     RESOURCE GROUPS    */
/**************************/


resource rg_resources 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${projectName}-${environment}-01'
  location: location
  tags: tags
}

resource rg_networking 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${projectName}-${environment}-network-01'
  location: location
  tags: tags
}

//resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
//  name: 'rg-${projectName}-${environment}-01'
//}

/**************************/
/*        RESOURCES       */
/**************************/

module bot 'bot-template.bicep' = {
  name:'Bot_Deployment'
  scope: rg_resources
  params:{
    adminUserIds: adminUserIds
    applicationId: applicationId
    applicationSecret: applicationSecret
    botName: botName
    buildId: buildId
    createStorageAccount: createStorageAccount
    environment: environment
    location: location
    projectName: projectName
  }
}
