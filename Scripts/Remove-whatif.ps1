$PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions

ForEach ($PolicyTemplateFiles in $PolicyTemplateFiles) {
    #Check if there is a file which needs to be removed
    If ($PolicyTemplateFiles.FullName -Match 'remove-*') {
        $PolicytobeDeleted = (($PolicyTemplateFiles.Name.split("remove-")[1].Split(".")[0]))
        $tobedeleted = $PolicytobeDeleted.count
        Remove-AzPolicyDefinition `
            -Name $PolicytobeDeleted `
            -WhatIf
            Write-host "$tobedeleted Policy Definition(s) to be deleted"
    }
    else {
        $PolicyTemplateFiles = Get-ChildItem -Path PolicyTemplates\policydefinitions -Exclude 'remove-*'
        $tobeadded = $PolicyTemplateFiles.count
        Write-host "$tobeadded Policy Definition(s) to be updated or created"
    }
}