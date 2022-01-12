<# 
Version: 0.1

.SYNOPSIS
Check the deployment and/or removal from Azure Policies

.DESCRIPTION
To run this script you need owner permissions on the scope where you want to assign the policy definitions and sets
To remove a policy Definition perform the following:
- Rename the Policy Definition in the policydefinition folder to include the word remove-. 
- Manually remove the PolicyID from the Policyset.json. I'm currently trying to get that automated but no success thus far (V0.1).
- Run this script either via the pipeline, or via Powershell
- Check the output of the script to see what is removed or added.

The script will iterate through each file in policydefinitions and output what will be removed or added to Azure.

#>

$PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions

ForEach ($PolicyTemplateFiles in $PolicyTemplateFiles) {
    #Check if there is a file which needs to be removed
    If ($PolicyTemplateFiles.FullName -Match 'remove-*') {
        $PolicytobeDeleted = (($PolicyTemplateFiles.Name.split("remove-")[1].Split(".")[0]))
        $PolicytobeDeletedName = $PolicytobeDeleted
        Remove-AzPolicyDefinition `
            -Name $PolicytobeDeleted `
            -WhatIf
    }
    else {
        $PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions -Exclude 'remove-*'
        $PolicyTemplateFilesName = $PolicyTemplateFiles.Name
    }
}

Write-host "$PolicyTemplateFilesName will be created or updated"
if($PolicyTemplateFiles -eq $null) {
Write-host "No Policies will be deleted"
}
else {
    Write-host "$PolicytobeDeleted will be deleted"
}