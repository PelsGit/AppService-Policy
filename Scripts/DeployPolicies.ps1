<# 
Version: 0.1

.SYNOPSIS
Deploy Azure Policy defintion to Azure, Assign a Policy Set to a scope and check if old policy definitions need to be removed.

.DESCRIPTION
To run this script you need owner permissions on the scope where you want to assign the policy definitions and sets
This policy will iterate through the PolicyDefinitions folder, remove definitions that need to be removed and assign new policies to the correct scope.
If the policyset already exist, it will perform an update to the policy set.

#>

$PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions
$Subscription = Get-AzSubscription -SubscriptionName 'Visual Studio Enterprise'

ForEach ($PolicyTemplateFiles in $PolicyTemplateFiles) {
    #Check if there is a file which needs to be removed
    If ($PolicyTemplateFiles.FullName -Match 'remove-*') {
        Remove-AzPolicyDefinition `
            -Name (($PolicyTemplateFiles.Name.split("remove-")[1].Split(".")[0])) `
            -Force
    }
    else {
        #Deploy Policy Definition
        $Policydefinition = New-AzPolicyDefinition `
            -Name (($PolicyTemplateFiles.Name).Split(".")[0]) `
            -Policy $PolicyTemplateFiles.FullName `
            -SubscriptionId $($Subscription.Id)
    }
}

# New policies are now deployed, time to deploy and assign the initiatives. Check if the initiative exists first, if it is: update existing policyset, if not create new and assign to correct scope.
$Policyset = get-AzPolicySetDefinition -Name 'app-service-policy-set' -ErrorVariable notPresent -ErrorAction SilentlyContinue

if ($notPresent) {
    $newPolicySetDefinition = New-AzPolicySetDefinition `
        -Name 'app-service-policy-set' `
        -PolicyDefinition "PolicyTemplates\policyset\policyset.json"

    New-AzPolicyAssignment `
        -Name 'AppServicePolicyAssignment' `
        -PolicyDefinition $newPolicySetDefinition `
        -Scope $Subscription `
        -AssignIdentity `
        -Location 'west europe'

    else {
        set-AzPolicySetDefinition `
            -Name $Policyset.Name `
            -PolicyDefinition "PolicyTemplates\policyset\policyset.json"
    }
}
