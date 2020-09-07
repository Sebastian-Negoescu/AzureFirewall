$servicePrincipalAppId = "1ef1b9fe-f380-48b5-90d4-04da43768578"
$servicePrincipalPwd = Read-Host "Your AzDevOps SP Password..."
$servicePrincipalSecret = ConvertTo-SecureString $servicePrincipalPwd -AsPlainText
$cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $servicePrincipalAppId, $servicePrincipalSecret
$rgName = "dummyRG"
Connect-AzAccount -ServicePrincipal -Credential $cred -Tenant "sebinego.onmicrosoft.com" -Subscription "Visual-Studio-Enterprise" | Out-Null

If ($?) {
    $cwd = (Get-Location).Path
    $templateFile = $cwd + "/arm.json"
    Test-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile "$templateFile"
    If ($?) {
        Write-Host "Works fine... Let's deploy."
        New-AzResourceGroupDeployment -ResourceGroupName $rgName -TemplateFile "$templateFile" -Verbose
    } Else {
        Write-Host "Err..."
    }
} Else {
    Write-Host "Couldn't connect to Azure"
}