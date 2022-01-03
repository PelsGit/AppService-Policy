$armTemplateFiles = Get-ChildItem -Path C:\Local\Repos\Appservice-Policy\AppService-Policy\PolicyTemplates
$Subscription = Get-AzSubscription -SubscriptionName 'Visual Studio Enterprise'

ForEach($file in $armTemplateFiles) {

        New-AzPolicyDefinition `
        -Name (($file.Name).Split(".")[0]) `
        -Policy $file.FullName `
        -SubscriptionId $($Subscription.Id)
    }

Get-Job | Receive-Job