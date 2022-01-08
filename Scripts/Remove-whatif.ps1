$PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions

ForEach ($PolicyTemplateFiles in $PolicyTemplateFiles) {
    #Check if there is a file which needs to be removed
    If ($PolicyTemplateFiles.FullName -Match 'remove-*') {
        Remove-AzPolicyDefinition `
            -Name (($PolicyTemplateFiles.Name.split("remove-")[1].Split(".")[0])) `
            -WhatIf
        
        Write-host "Removing policies, please check"
    }
    else {
        Write-host "No policies to be removed"
    }
}