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
        $PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions -Exclude 'remove-*'
        $tobeadded = $PolicyTemplateFiles.count
        Write-host "$tobeadded Policy Definition to be updated or created"
    }
}