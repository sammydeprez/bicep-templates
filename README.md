# BICEP templates for different AI solutions

## Bot Project
![Architecture Schema](bot-project/bot-project.png)

Link to [Draw.IO](bot-project/bot-project.drawio)

### Deployment
#### Login
```
az login
```

#### Set Subscription
```
az account set --subscription {SubscriptionID|SubscriptionName}
```

#### Build
```
az bicep build --file bot-project/main.bicep
```

#### Deploy
##### Subscription Scope
```
az deployment sub create `
--location westeurope `
--template-file bot-project/main.bicep `
--parameters `
    location='westeurope' `
    environment='dev' `
    projectName='{projectName}' `
    adminUserIds= "['{UserId}']" `
    botName='{BotName}' `
    applicationId='{AppId}' `
    applicationSecret='{AppSecret}' `
    buildId='Manually Deployed'
```

##### Resource Group Scope
```
az deployment group create `
--resource-group {rg-myresourcegroup} `
--template-file bot-project/bot-template.bicep `
--parameters `
    location='westeurope' `
    environment='dev' `
    projectName='{projectName}' `
    adminUserIds= "['{UserId}']" `
    botName='{BotName}' `
    applicationId='{AppId}' `
    applicationSecret='{AppSecret}' `
    buildId='Manually Deployed'
```