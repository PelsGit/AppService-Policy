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