$PolicyTemplateFiles = Get-ChildItem -Path C:\Repos\appservice-policy\AppService-Policy\PolicyTemplates
$Subscription = Get-AzSubscription -SubscriptionName 'Visual Studio Enterprise'

ForEach ($PolicyTemplateFiles in $PolicyTemplateFiles) {
    If ($PolicyTemplateFiles.FullName -Match 'remove-*') {
        Remove-AzPolicyDefinition `
            -Name (($PolicyTemplateFiles.Name.split("remove-")[1].Split(".")[0])) `
            -Force
    }
    else {
        New-AzPolicyDefinition `
            -Name (($PolicyTemplateFiles.Name).Split(".")[0]) `
            -Policy $PolicyTemplateFiles.FullName `
            -SubscriptionId $($Subscription.Id)
    }
}