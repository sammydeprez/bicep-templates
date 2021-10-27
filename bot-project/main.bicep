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

@minLength(36)
@maxLength(36)
@description('Array that contains Group or User Object Ids that can edit & view secrets in Key Vault')

param adminUserIds array
param botName string
param applicationId string
@secure()
param applicationSecret string
param buildId string
param createStorageAccount bool

var tags = {
  Description: 'Chatbot ${botName}'
  Environment: environment
  Build: buildId
}

/**************************/
/*     RESOURCE GROUPS    */
/**************************/


resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-${projectName}-${environment}-01'
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
  name:'Bot Deployment'
  scope: rg
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
