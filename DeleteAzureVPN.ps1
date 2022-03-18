<#  Task: Automate Removing Azure VPNs
    Want: 
    Version: 1.0
    Author: Sam Solmonson
    DateWritten: 10/19/2021 DatePublished: 10/19/2021 DateLastChangeMade: 10/19/2021
#>  

$VPNName = '' #name of new VPN
$azSub = ''
$RG = 'rg'
$VPNConnectName = $VPNName + "_connection"
$localConnectName = $VPNName + "_local_gateway" 
$i = 10

Connect-AzAccount
Select-AzSubscription -SubscriptionName $azSub
Write-Host "$VPNConnectName & $localConnectName are queued to be removed from $azSub. If this is incorrect please stop the script." -BackgroundColor DarkYellow
Write-Host "Items will be deleted in" -BackgroundColor DarkYellow
while($i -gt 0){
write-host "$i"
sleep 1
$i--
}
Remove-AzVirtualNetworkGatewayConnection -Name $VPNConnectName -ResourceGroupName $RG -Force
Write-Host "$VPNConnectName has been deleted." -ForegroundColor Red
Remove-AzLocalNetworkGateway -Name $localConnectName -ResourceGroupName $RG -Force
Write-Host "$localConnectName has been deleted." -ForegroundColor Red
