## this belongs to part 1 ##

$path = "C:\Repos\appservice-policy\AppService-Policy\policyset\policyset.json"
$jsonFile = Get-Content $path -Raw | ConvertFrom-Json
$jsonContent = @"
{policyDefinitionId : /subscriptions/fffb0c65-e90a-4b5d-adac-a5d6d399e2cc/providers/Microsoft.Authorization/policyDefinitions/appservice-ftp-deny}
"@

$jsonFile.resources.properties.policyDefinitions += $jsonContent
$jsonFile | ConvertTo-Json -Depth 4 | Out-File $path


## this belongs to part 2 ##

$jsonFile = 'policyset\policyset.json'
$jsonBase = Get-Content -RAW $jsonfile | Out-String | ConvertFrom-Json
$jsonBase.resources.properties.policyDefinitions | Add-Member -Type NoteProperty -Name 'policyDefinitionId' -Value '/subscriptions/fffb0c65-e90a-4b5d-adac-a5d6d399e2cc/providers/Microsoft.Authorization/policyDefinitions/appservice-ftp-deny' -PassThru
$jsonBase | ConvertTo-Json -Depth 3 | Out-File $jsonFile